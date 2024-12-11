// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { Script } from "forge-std/Script.sol";
import { PokemonInterface } from "../src/PokemonInterface.sol";

contract DeployPokemonInterface is Script {
    
    function run() external returns (PokemonInterface) {
        vm.startBroadcast();
        PokemonInterface pokemonInterface = new PokemonInterface();
        vm.stopBroadcast();

        return pokemonInterface;
    }

}