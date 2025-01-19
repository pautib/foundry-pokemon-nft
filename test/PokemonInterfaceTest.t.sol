// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { Test, console2 } from "forge-std/Test.sol";
import { PokemonInterface } from "../src/PokemonInterface.sol";
import { DeployPokemonInterface } from "../script/DeployPokemonInterface.s.sol";

contract PokemonInterfaceTest is Test {

    DeployPokemonInterface public deployPokemonInterface;
    PokemonInterface public pokemonInterface;
    address public USER = makeAddr("user");
    address public USER2 = makeAddr("user2");

    string private constant TOKEN_SYMBOL = "PKMN";
    string private constant TOKEN_NAME = "PokesPautib";

    string private constant GHOLDENGO_IMG_ENCODED_URI = "iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAM1BMVEUAAACRcij/26b/1S0PDw/3pi3ZiA9IRBXVpDEyNDeDbFS5KFu/oz5UW2uKj5+5vs0AAAC5nrRsAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAADsMAAA7DAcdvqGQAAANdSURBVGje7VjtctwgDDxZAoE/4vd/264E9jmT/qlPdKZTK4kTz2V2WQnQwuv1xBNP/HdBiKH408QsA/FTSjySwQSAYhiBCYCCNI6AUYHU8POIYnuJPUGZOHE4gwtwAsBPaZp0CIHjT1OChCEEHZ8zvqIJFOMvgl8mZBSB+JOLCiIY3xgggABP0WM/CEoR/BT1iMX2TdQICMOnYhEpg5AXxpi1gEPLEVEM1FcYUlMahTaSFMPg094mqBTHF0s//s5YaxEMlAwf2S9ZfNzZcyO5xKxljB9bNDCJMGZELuTl1ZwjWo96B8jAL1Mhj15dkxOw1NR7GBBBwD369AlZysoYMhf0mJ8EIeFrClkxgloNHc+SAwnSMd+ppgwGe+ZABS+xKnsxHT3ZM1LBy2vpxTTo9h2q4B01J1OAZ2SRL0HvIo/pBn3HY6ZBBHBFAIeAOopAm4JhKToI+N8leOXOELvOrgSpRbjh+lsKSLsCGuO7sL7OjsDRtsvxTwIdQeGd+CAQpwg8MfdOfxLYHs7mllIEB5kxciehfBJYJ4KfwTnnUwoih3GHQn0hd0jBGQQffXQWBDwgMrcedhAcWwUY3PXdLLd5LLs3gEHMzWH9JCjZ/+HWjFJDdgIIaA7rJDiSYv4UnsM86p9TiHnb4ue+A/+wXlcJ9pLOyv8ZAwK+CwingOmbBNUZ/pSVVP30eSNL2HQ4nRb3QmBzVudlWQSHBKV8z6YCX9KZIMvQm6DoPBsDNLBmumdk1PDTObbM09nS4O1mY5jVJehNpyTX1LaDTifILmFWXVWsvjd3PrmWLrPfpvm8zy4BR8F1XuSTFn0pHdYcFnVvmcCHo19XXZdFY24UKm6I0lmChOsuqTIv87rMIX2hbjaH0hFYCFJrlQU5WiME1G0D3rth4rBTnQASQghkq1/7Vy0+Qw16M0bRecVijsiQ1G3/2rc27q0Feppi+DF3RlL3fdv3AxvDt2uFEjSBWo5MgTTwag2ZAy9bnAE1kFZZh3eCyHtT6rg+bO0MkR6VyqXXgGCKzlEnKO2ITAMI2j5RshOov2FDCiRgvyrqR3Blf4k8bjYFhdrRQL+9hYSWHwrOtxiC4Qp4tILSxtwJmgULvVOAPTHDJe83DrkTvGhwp/f7tyeeeOKJT+MXVWUgEteT/CMAAAAASUVORK5CYII=";

    function setUp() public {
        deployPokemonInterface = new DeployPokemonInterface();
        pokemonInterface = deployPokemonInterface.run();
    }

    function testNameIsCorrect() public view {
        assertEq(pokemonInterface.name(), TOKEN_NAME);
    }

    function testSymbolIsCorrect() public view {
        assertEq(pokemonInterface.symbol(), TOKEN_SYMBOL);
    }

    function testMintPokemon() public {
        vm.prank(USER);
        pokemonInterface.mintPokemon(1000, "Gholdengo", GHOLDENGO_IMG_ENCODED_URI, "good-as-gold", "", 87, 60, 95, 133, 91, 84, 12, 300);
        assertEq(pokemonInterface.ownerOf(0), USER);
    }

    function testTokenURI() public {
        vm.prank(USER);
        pokemonInterface.mintPokemon(1000, "Gholdengo", GHOLDENGO_IMG_ENCODED_URI, "good-as-gold", "", 87, 60, 95, 133, 91, 84, 12, 300);
        console2.log(pokemonInterface.tokenURI(0));
        assertEq(pokemonInterface.tokenURI(0), "data:application/json;base64,eyJuYW1lIjogIkdob2xkZW5nbyIsICJwb2tlZGV4X2lkIjogMTAwMCwgImFiaWxpdHlfMSI6ICJnb29kLWFzLWdvbGQiLCAiYWJpbGl0eV8yIjogIiIsICJocCI6IDg3LCAiYXR0YWNrIjogNjAsICJkZWZlbnNlIjogOTUsICJhdHRhY2tfc3AiOiAxMzMsICJkZWZlbnNlX3NwIjogOTEsICJzcGVlZCI6IDg0LCAiaGVpZ2h0IjogMTIsICJ3ZWlnaHQiOiAzMDAsICJsZXZlbCI6IDEsICJuYXR1cmVfaW5kZXgiOiAyLCAiZXhwIjogMCwgIml2X2hwIjogMjQsICJpdl9hdHRhY2siOiAyNCwgIml2X2RlZmVuc2UiOiAyNSwgIml2X2F0dGFja19zcCI6IDE5LCAiaXZfZGVmZW5zZV9zcCI6IDUsICJpdl9zcGVlZCI6IDksICJldl9ocCI6IDI0LCAiZXZfYXR0YWNrIjogMTg0LCAiZXZfZGVmZW5zZSI6IDIxNywgImV2X2F0dGFja19zcCI6IDI0MywgImV2X2RlZmVuc2Vfc3AiOiAzNywgImV2X3NwZWVkIjogMTM3LCAiaXNfc2hpbnkiOiBmYWxzZSwgImltYWdlIjogImRhdGE6aW1hZ2UvcG5nO2Jhc2U2NCxpVkJPUncwS0dnb0FBQUFOU1VoRVVnQUFBR0FBQUFCZ0NBTUFBQURWUm9jS0FBQUFCR2RCVFVFQUFMR1BDL3hoQlFBQUFDQmpTRkpOQUFCNkpnQUFnSVFBQVBvQUFBQ0E2QUFBZFRBQUFPcGdBQUE2bUFBQUYzQ2N1bEU4QUFBQU0xQk1WRVVBQUFDUmNpai8yNmIvMVMwUER3LzNwaTNaaUE5SVJCWFZwREV5TkRlRGJGUzVLRnUvb3o1VVcydUtqNSs1dnMwQUFBQzVuclJzQUFBQUFYUlNUbE1BUU9iWVpnQUFBQUZpUzBkRUFJZ0ZIVWdBQUFBSmNFaFpjd0FBRHNNQUFBN0RBY2R2cUdRQUFBTmRTVVJCVkdqZTdWanRjdHdnRER4WkFvRS80dmQvMjY0RTlqbVQvcWxQZEtaVEs0a1R6MlYyV1FuUXd1djF4Qk5QL0hkQmlLSDQwOFFzQS9GVFNqeVN3UVNBWWhpQkNZQ0NOSTZBVVlIVThQT0lZbnVKUFVHWk9IRTRnd3R3QXNCUGFacDBDSUhqVDFPQ2hDRUVIWjh6dnFJSkZPTXZnbDhtWkJTQitKT0xDaUlZM3hnZ2dBQlAwV00vQ0VvUi9CVDFpTVgyVGRRSUNNT25ZaEVwZzVBWHhwaTFnRVBMRVZFTTFGY1lVbE1haFRhU0ZNUGcwOTRtcUJUSEYwcy8vczVZYXhFTWxBd2YyUzlaZk56WmN5TzV4S3hsakI5Yk5EQ0pNR1pFTHVUbDFad2pXbzk2QjhqQUwxTWhqMTVka3hPdzFOUjdHQkJCd0QzNjlBbFp5c29ZTWhmMG1KOEVJZUZyQ2xreGdsb05IYytTQXduU01kK3BwZ3dHZStaQUJTK3hLbnN4SFQzWk0xTEJ5MnZweFRUbzloMnE0QjAxSjFPQVoyU1JMMEh2SW8vcEJuM0hZNlpCQkhCRkFJZUFPb3BBbTRKaEtUb0krTjhsZU9YT0VMdk9yZ1NwUmJqaCtsc0tTTHNDR3VPN3NMN09qc0RSdHN2eFR3SWRRZUdkK0NBUXB3ZzhNZmRPZnhMWUhzN21sbElFQjVreGNpZWhmQkpZSjRLZndUbm5Vd29paDNHSFFuMGhkMGpCR1FRZmZYUVdCRHdnTXJjZWRoQWNXd1VZM1BYZExMZDVMTHMzZ0VITXpXSDlKQ2paLytIV2pGSkRkZ0lJYUE3ckpEaVNZdjRVbnNNODZwOVRpSG5iNHVlK0EvK3dYbGNKOXBMT3l2OFpBd0srQ3dpbmdPbWJCTlVaL3BTVlZQMzBlU05MMkhRNG5SYjNRbUJ6VnVkbFdRU0hCS1Y4ejZZQ1g5S1pJTXZRbTZEb1BCc0ROTEJtdW1kazFQRFRPYmJNMDluUzRPMW1ZNWpWSmVoTnB5VFgxTGFEVGlmSUxtRldYVldzdmpkM1BybVdMclBmcHZtOHp5NEJSOEYxWHVTVEZuMHBIZFljRm5Wdm1jQ0hvMTlYWFpkRlkyNFVLbTZJMGxtQ2hPc3VxVEl2ODdyTUlYMmhiamFIMGhGWUNGSnJsUVU1V2lNRTFHMEQzcnRoNHJCVG5RQVNRZ2hrcTEvN1Z5MCtRdzE2TTBiUmVjVmlqc2lRMUczLzJyYzI3cTBGZXBwaStERjNSbEwzZmR2M0F4dkR0MnVGRWpTQldvNU1nVFR3YWcyWkF5OWJuQUUxa0ZaWmgzZUN5SHRUNnJnK2JPME1rUjZWeXFYWGdHQ0t6bEVuS08ySVRBTUkyajVSc2hPb3YyRkRDaVJndnlycVIzQmxmNGs4YmpZRmhkclJRTCs5aFlTV0h3ck90eGlDNFFwNHRJTFN4dHdKbWdVTHZWT0FQVEhESmU4M0Rya1R2R2h3cC9mN3R5ZWVlT0tKVCtNWFZXVWdFdGVUL0NNQUFBQUFTVVZPUks1Q1lJST0ifQ==");
    }

    function testBurnPokemon() public {
        vm.prank(USER);
        pokemonInterface.mintPokemon(1000, "Gholdengo", GHOLDENGO_IMG_ENCODED_URI, "good-as-gold", "", 87, 60, 95, 133, 91, 84, 12, 300);
        vm.prank(USER);
        pokemonInterface.burnPokemon(0);
        assertEq(pokemonInterface.balanceOf(USER), 0);
    }

    function testTransferFrom() public {
        vm.prank(USER);
        pokemonInterface.mintPokemon(1000, "Gholdengo", GHOLDENGO_IMG_ENCODED_URI, "good-as-gold", "", 87, 60, 95, 133, 91, 84, 12, 300);
        vm.prank(USER2);
        pokemonInterface.transferFrom(USER, USER2, 0);
        assertEq(pokemonInterface.ownerOf(0), USER2);
    }




}