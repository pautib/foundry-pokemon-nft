// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { Script } from "forge-std/Script.sol";
import { DevOpsTools } from "lib/foundry-devops/src/DevOpsTools.sol";
import { PokemonInterface } from "../src/PokemonInterface.sol";

contract MintGholdengoNFT is Script {

    //string private constant GHOLDENGO_IMG_ENCODED_URI = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAM1BMVEUAAACRcij/26b/1S0PDw/3pi3ZiA9IRBXVpDEyNDeDbFS5KFu/oz5UW2uKj5+5vs0AAAC5nrRsAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAADsMAAA7DAcdvqGQAAANdSURBVGje7VjtctwgDDxZAoE/4vd/264E9jmT/qlPdKZTK4kTz2V2WQnQwuv1xBNP/HdBiKH408QsA/FTSjySwQSAYhiBCYCCNI6AUYHU8POIYnuJPUGZOHE4gwtwAsBPaZp0CIHjT1OChCEEHZ8zvqIJFOMvgl8mZBSB+JOLCiIY3xgggABP0WM/CEoR/BT1iMX2TdQICMOnYhEpg5AXxpi1gEPLEVEM1FcYUlMahTaSFMPg094mqBTHF0s//s5YaxEMlAwf2S9ZfNzZcyO5xKxljB9bNDCJMGZELuTl1ZwjWo96B8jAL1Mhj15dkxOw1NR7GBBBwD369AlZysoYMhf0mJ8EIeFrClkxgloNHc+SAwnSMd+ppgwGe+ZABS+xKnsxHT3ZM1LBy2vpxTTo9h2q4B01J1OAZ2SRL0HvIo/pBn3HY6ZBBHBFAIeAOopAm4JhKToI+N8leOXOELvOrgSpRbjh+lsKSLsCGuO7sL7OjsDRtsvxTwIdQeGd+CAQpwg8MfdOfxLYHs7mllIEB5kxciehfBJYJ4KfwTnnUwoih3GHQn0hd0jBGQQffXQWBDwgMrcedhAcWwUY3PXdLLd5LLs3gEHMzWH9JCjZ/+HWjFJDdgIIaA7rJDiSYv4UnsM86p9TiHnb4ue+A/+wXlcJ9pLOyv8ZAwK+CwingOmbBNUZ/pSVVP30eSNL2HQ4nRb3QmBzVudlWQSHBKV8z6YCX9KZIMvQm6DoPBsDNLBmumdk1PDTObbM09nS4O1mY5jVJehNpyTX1LaDTifILmFWXVWsvjd3PrmWLrPfpvm8zy4BR8F1XuSTFn0pHdYcFnVvmcCHo19XXZdFY24UKm6I0lmChOsuqTIv87rMIX2hbjaH0hFYCFJrlQU5WiME1G0D3rth4rBTnQASQghkq1/7Vy0+Qw16M0bRecVijsiQ1G3/2rc27q0Feppi+DF3RlL3fdv3AxvDt2uFEjSBWo5MgTTwag2ZAy9bnAE1kFZZh3eCyHtT6rg+bO0MkR6VyqXXgGCKzlEnKO2ITAMI2j5RshOov2FDCiRgvyrqR3Blf4k8bjYFhdrRQL+9hYSWHwrOtxiC4Qp4tILSxtwJmgULvVOAPTHDJe83DrkTvGhwp/f7tyeeeOKJT+MXVWUgEteT/CMAAAAASUVORK5CYII=";
    string private constant GHOLDENGO_IMG_URL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1000.png";
    string private constant PKM_NAME = "Gholdengo";
    string private constant PKM_NICKNAME = "Gholdy";
    string private constant ABILITY_1 = "good-as-gold";
    string private constant ABILITY_2 = "";
    uint16 private constant POKEDEX_ID = 1000;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("PokemonInterface", block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) internal {

        vm.startBroadcast();
        PokemonInterface(contractAddress).mintPokemon(POKEDEX_ID, PKM_NAME, PKM_NICKNAME, GHOLDENGO_IMG_URL, ABILITY_1, ABILITY_2, 87, 60, 95, 133, 91, 84, 12, 300);
        vm.stopBroadcast();

    }

    
}