// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { Test, console2 } from "forge-std/Test.sol";
import { PokemonInterface, PokemonHelper } from "../src/PokemonInterface.sol";
import { DeployPokemonInterface } from "../script/DeployPokemonInterface.s.sol";

contract PokemonHelperTest is Test {

    DeployPokemonInterface public deployPokemonInterface;
    PokemonInterface public pokemonInterface;
    PokemonHelper public pokemonHelper;
    address public USER = makeAddr("user");
    address public USER2 = makeAddr("user2");

    string private constant TOKEN_SYMBOL = "PKMN";
    string private constant TOKEN_NAME = "PokesPautib";

    //string private constant GHOLDENGO_IMG_ENCODED_URI = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAM1BMVEUAAACRcij/26b/1S0PDw/3pi3ZiA9IRBXVpDEyNDeDbFS5KFu/oz5UW2uKj5+5vs0AAAC5nrRsAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAADsMAAA7DAcdvqGQAAANdSURBVGje7VjtctwgDDxZAoE/4vd/264E9jmT/qlPdKZTK4kTz2V2WQnQwuv1xBNP/HdBiKH408QsA/FTSjySwQSAYhiBCYCCNI6AUYHU8POIYnuJPUGZOHE4gwtwAsBPaZp0CIHjT1OChCEEHZ8zvqIJFOMvgl8mZBSB+JOLCiIY3xgggABP0WM/CEoR/BT1iMX2TdQICMOnYhEpg5AXxpi1gEPLEVEM1FcYUlMahTaSFMPg094mqBTHF0s//s5YaxEMlAwf2S9ZfNzZcyO5xKxljB9bNDCJMGZELuTl1ZwjWo96B8jAL1Mhj15dkxOw1NR7GBBBwD369AlZysoYMhf0mJ8EIeFrClkxgloNHc+SAwnSMd+ppgwGe+ZABS+xKnsxHT3ZM1LBy2vpxTTo9h2q4B01J1OAZ2SRL0HvIo/pBn3HY6ZBBHBFAIeAOopAm4JhKToI+N8leOXOELvOrgSpRbjh+lsKSLsCGuO7sL7OjsDRtsvxTwIdQeGd+CAQpwg8MfdOfxLYHs7mllIEB5kxciehfBJYJ4KfwTnnUwoih3GHQn0hd0jBGQQffXQWBDwgMrcedhAcWwUY3PXdLLd5LLs3gEHMzWH9JCjZ/+HWjFJDdgIIaA7rJDiSYv4UnsM86p9TiHnb4ue+A/+wXlcJ9pLOyv8ZAwK+CwingOmbBNUZ/pSVVP30eSNL2HQ4nRb3QmBzVudlWQSHBKV8z6YCX9KZIMvQm6DoPBsDNLBmumdk1PDTObbM09nS4O1mY5jVJehNpyTX1LaDTifILmFWXVWsvjd3PrmWLrPfpvm8zy4BR8F1XuSTFn0pHdYcFnVvmcCHo19XXZdFY24UKm6I0lmChOsuqTIv87rMIX2hbjaH0hFYCFJrlQU5WiME1G0D3rth4rBTnQASQghkq1/7Vy0+Qw16M0bRecVijsiQ1G3/2rc27q0Feppi+DF3RlL3fdv3AxvDt2uFEjSBWo5MgTTwag2ZAy9bnAE1kFZZh3eCyHtT6rg+bO0MkR6VyqXXgGCKzlEnKO2ITAMI2j5RshOov2FDCiRgvyrqR3Blf4k8bjYFhdrRQL+9hYSWHwrOtxiC4Qp4tILSxtwJmgULvVOAPTHDJe83DrkTvGhwp/f7tyeeeOKJT+MXVWUgEteT/CMAAAAASUVORK5CYII=";
    string private constant GHOLDENGO_IMG_URL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1000.png";
    string private constant PKM_NAME = "Gholdengo";
    string private constant PKM_NICKNAME = "Gholdy";
    string private constant ABILITY_1 = "good-as-gold";
    string private constant ABILITY_2 = "";
    uint16 private constant POKEDEX_ID = 1000;

    function setUp() public {
        deployPokemonInterface = new DeployPokemonInterface();
        pokemonInterface = deployPokemonInterface.run();

        vm.deal(USER, 10 ether);
        vm.deal(USER2, 10 ether);
    }

    function testChangePokemonNickName() public {
        vm.startPrank(USER);
        pokemonInterface.mintPokemon(POKEDEX_ID, PKM_NAME, PKM_NICKNAME, GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        pokemonInterface.levelUp{value: 0.0002 ether}(0);
        pokemonInterface.levelUp{value: 0.0003 ether}(0);
        pokemonInterface.levelUp{value: 0.0004 ether}(0);
        pokemonInterface.levelUp{value: 0.0005 ether}(0);
        pokemonInterface.levelUp{value: 0.0006 ether}(0);
        pokemonInterface.levelUp{value: 0.0007 ether}(0);
        pokemonInterface.levelUp{value: 0.0008 ether}(0);
        pokemonInterface.levelUp{value: 0.0009 ether}(0);
        pokemonInterface.levelUp{value: 0.0010 ether}(0);
        pokemonInterface.changePokemonNickName(0, "Gholdengo the Great");
        
        assertEq(pokemonInterface.getPokemon(0).nickname, "Gholdengo the Great");
        vm.stopPrank();
    }

    function testLevelUp() public {
        vm.startPrank(USER);
        pokemonInterface.mintPokemon(POKEDEX_ID, PKM_NAME, PKM_NICKNAME, GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        pokemonInterface.levelUp{value: 0.0002 ether}(0);
        PokemonInterface.Pokemon memory pokemon = pokemonInterface.getPokemon(0);
        //uint8[5] memory nature_array = pokemonInterface.getNaturePokemonArray(pokemon.nature_index);
        
        assertEq(2, pokemon.level);
        assertEq(15, pokemonInterface.getHpValue(pokemon.base_hp, 15, 0, pokemon.level));
        assertEq(6, pokemonInterface.getStatValue(pokemon.base_attack, 15, 0, pokemon.level, 9)); //nature 3
        assertEq(9, pokemonInterface.getStatValue(pokemon.base_defense, 15, 0, pokemon.level, 10));
        assertEq(11, pokemonInterface.getStatValue(pokemon.base_attack_sp, 15, 0, pokemon.level, 11));
        assertEq(8, pokemonInterface.getStatValue(pokemon.base_defense_sp, 15, 0, pokemon.level, 10));
        assertEq(8, pokemonInterface.getStatValue(pokemon.base_speed, 15, 0, pokemon.level, 10));
        vm.stopPrank();
    }

    function testGetPokemonsByTrainer() public {
        vm.startPrank(USER);
        pokemonInterface.mintPokemon(POKEDEX_ID, "Gholdengo1", "Gholdy1", GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        pokemonInterface.mintPokemon(POKEDEX_ID, "Gholdengo2", "Gholdy2", GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        uint256[] memory pokemons = pokemonInterface.getPokemonsByTrainer();
        assertEq(pokemons.length, 2);
        vm.stopPrank();
    }

    function testGetPokemon() public {
        vm.startPrank(USER);
        pokemonInterface.mintPokemon(POKEDEX_ID, PKM_NAME, PKM_NICKNAME, GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        PokemonInterface.Pokemon memory pokemon = pokemonInterface.getPokemon(0);
        assertEq(pokemon.nickname, PKM_NICKNAME);
        assertEq(pokemon.pokedex_id, POKEDEX_ID);
        assertEq(pokemon.ability1_name, ABILITY_1);
        assertEq(pokemon.ability2_name, ABILITY_2);
        assertEq(pokemon.base_hp, 87);
        assertEq(pokemon.base_attack, 60);
        assertEq(pokemon.base_defense, 95);
        assertEq(pokemon.base_attack_sp, 133);
        assertEq(pokemon.base_defense_sp, 91);
        assertEq(pokemon.base_speed, 84);
        assertEq(pokemon.height, 12);
        assertEq(pokemon.weight, 300);
        vm.stopPrank();
    }

    function testNotAllowChangeNicknametoNotPokemonTrainer() public {
        vm.startPrank(USER);
        pokemonInterface.mintPokemon(POKEDEX_ID, PKM_NAME, PKM_NICKNAME, GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        pokemonInterface.levelUp{value: 0.0002 ether}(0);
        pokemonInterface.levelUp{value: 0.0003 ether}(0);
        pokemonInterface.levelUp{value: 0.0004 ether}(0);
        pokemonInterface.levelUp{value: 0.0005 ether}(0);
        pokemonInterface.levelUp{value: 0.0006 ether}(0);
        pokemonInterface.levelUp{value: 0.0007 ether}(0);
        pokemonInterface.levelUp{value: 0.0008 ether}(0);
        pokemonInterface.levelUp{value: 0.0009 ether}(0);
        pokemonInterface.levelUp{value: 0.0010 ether}(0);
        vm.stopPrank();

        vm.prank(USER2);
        vm.expectRevert(abi.encodeWithSelector(bytes4(keccak256("PokemonOnlyOwnerAllowed(address,uint256)")), USER, 0));
        pokemonInterface.changePokemonNickName(0, "Gholdengo the Great");
    }

    function testNotAllowChangeNicknameBelowLevel10() public {
        vm.startPrank(USER);
        pokemonInterface.mintPokemon(POKEDEX_ID, PKM_NAME, PKM_NICKNAME, GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        pokemonInterface.levelUp{value: 0.0002 ether}(0);
        vm.expectRevert(abi.encodeWithSelector(bytes4(keccak256("PokemonNotEnoughLevel(uint256,uint8,uint8)")), 0, 2, 10));
        pokemonInterface.changePokemonNickName(0, "Gholdengo the Great");
        vm.stopPrank();
    }

    

}