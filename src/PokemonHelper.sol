// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { PokemonFactory } from "./PokemonFactory.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { console2 } from "forge-std/Test.sol";

contract PokemonHelper is PokemonFactory {

    using Math for uint256;

    error PokemonNotEnoughLevel(uint256 pokemonId, uint8 currentLevel, uint8 requiredLevel);
    error PokemonNotEnoughFee(uint256 pokemonId, uint8 currentLevel, uint256 requiredFee);

    modifier aboveLevel(uint8 _level, uint256 _pokemonId) {
        if (s_pokemons[_pokemonId].level < _level) {
            revert PokemonNotEnoughLevel(_pokemonId, s_pokemons[_pokemonId].level, _level);
        }
        _;
    }

    function changePokemonNickName(uint256 _pokemonId, string memory _newName) external isPokemonTrainer(_pokemonId) aboveLevel(10, _pokemonId) {
        s_pokemons[_pokemonId].nickname = _newName;
    }

    function levelUp(uint256 _pokemonId) external payable isPokemonTrainer(_pokemonId) {
        Pokemon memory myPokemon = s_pokemons[_pokemonId];
        (, uint256 requiredFee) = Math.tryMul(100000000000000, myPokemon.level + 1);
        if (msg.value < requiredFee) {
            revert PokemonNotEnoughFee(_pokemonId, s_pokemons[_pokemonId].level, requiredFee);
        }
        myPokemon.level++;
        s_pokemons[_pokemonId] = myPokemon;
    }

    function getPokemonsByTrainer() external view returns(uint256[] memory) {
        uint256[] memory result = new uint256[](s_ownerPokemonCount[_msgSender()]);
        uint256 counter = 0;
        for (uint256 i = 0; i < s_pokemons.length; i++) {
            if (s_pokemonToOwner[i] == _msgSender()) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getPokemon(uint256 _pokemonId) external view isPokemonTrainer(_pokemonId) returns (Pokemon memory) {
        return s_pokemons[_pokemonId];
    }

    function getNaturePokemonArray(uint8 _nature_index) public view returns (uint8[5] memory){
        return s_nature_multipliers[_nature_index];
    }

    function getHpValue(uint16 _base_hp, uint8 _iv_hp, uint8 _ev_hp, uint8 level) public pure returns (uint16) {
        uint16 numerator = (8 * _base_hp + 4 * _iv_hp + _ev_hp + 400) * level + 4000;
        return numerator / 400;
    }

    function getStatValue(uint16 _base_stat, uint8 _iv_stat, uint8 _ev_stat, uint8 level, uint8 _nature_multiplier) public pure returns (uint16) {
        uint16 numerator = ((8 * _base_stat + 4 * _iv_stat + _ev_stat) * level + 2000) * _nature_multiplier;
        return numerator / 4000;
    } 
   
    function _baseURI() internal pure returns (string memory) {
        return "data:application/json;base64,";
    }

    function _encodePNGImageURI(string memory _png_encoded) internal pure returns (string memory) { // _png already encoded in base64
        return string(abi.encodePacked("data:image/png;base64,", _png_encoded));
    }

    function _encodeGIFImageURI(string memory _gif_encoded) internal pure returns (string memory) { // _gif already encoded in base64
        return string(abi.encodePacked("data:image/gif;base64,", _gif_encoded));
    }
}