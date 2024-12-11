// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { PokemonFactory } from "./PokemonFactory.sol";

contract PokemonHelper is PokemonFactory {

    modifier aboveLevel(uint256 _level, uint256 _pokemonId) {
        require(s_pokemons[_pokemonId].level >= _level);
        _;
    }

    function changePokemonNickName(uint256 _pokemonId, string memory _newName) external aboveLevel(10, _pokemonId) {
        require(msg.sender == s_pokemonToOwner[_pokemonId]);
        s_pokemons[_pokemonId].nickname = _newName;
    }

    function levelUp(uint256 _pokemonId) external {
        s_pokemons[_pokemonId].level++;
    }

    function getPokemonsByTrainer(address _owner) external view returns(uint256[] memory) {
        uint256[] memory result = new uint256[](s_ownerPokemonCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < s_pokemons.length; i++) {
            if (s_pokemonToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
   
}