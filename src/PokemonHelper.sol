// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { PokemonFactory } from "./PokemonFactory.sol";

contract PokemonHelper is PokemonFactory {

    error PokemonNotEnoughLevel(uint256 pokemonId, uint8 currentLevel, uint8 requiredLevel);

    modifier aboveLevel(uint8 _level, uint256 _pokemonId) {
        if (s_pokemons[_pokemonId].level < _level) {
            revert PokemonNotEnoughLevel(_pokemonId, s_pokemons[_pokemonId].level, _level);
        }
        _;
    }

    function changePokemonNickName(uint256 _pokemonId, string memory _newName) external isPokemonTrainer(_pokemonId) aboveLevel(10, _pokemonId) {
        s_pokemons[_pokemonId].nickname = _newName;
    }

    function levelUp(uint256 _pokemonId, uint16 _hp_increase, uint16 _atk_increase, uint16 _def_increase, uint16 _atk_sp_increase, uint16 _def_sp_increase, uint16 _speed_increase) external {
        Pokemon memory myPokemon = s_pokemons[_pokemonId];
        myPokemon.level++;
        myPokemon.hp += _hp_increase;
        myPokemon.attack += _atk_increase;
        myPokemon.defense += _def_increase;
        myPokemon.attack_sp += _atk_sp_increase;
        myPokemon.defense_sp += _def_sp_increase;
        myPokemon.speed += _speed_increase;
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

    function getPokemon(uint256 _pokemonId) public view isPokemonTrainer(_pokemonId) returns (Pokemon memory) {
        return s_pokemons[_pokemonId];
    }
   
}