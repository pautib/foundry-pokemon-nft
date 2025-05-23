// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { IERC721Metadata } from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import { IERC721Errors } from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Utils.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { PokemonHelper } from "./PokemonHelper.sol";

contract PokemonInterface is Context, IERC721, IERC721Metadata, IERC721Errors, PokemonHelper {

    string private constant TOKEN_SYMBOL = "PKMN";
    string private constant TOKEN_NAME = "PokesPautib";

    /**
     * @dev We won't allow sending Pokemons from another trainer.
     * The owner of the Pokemon is the only one allowed to transfer it.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error PokemonApprovalNotAllowed(address operator, uint256 tokenId);

    // Metadata
    function name() public pure returns (string memory) {
        return TOKEN_NAME;
    }

    function symbol() public pure returns (string memory) {
        return TOKEN_SYMBOL;
    }

    function tokenURI(uint256 _pokemonId) external view override returns (string memory) {

        Pokemon memory pokemon = s_pokemons[_pokemonId];
        string memory isShiny = pokemon.is_shiny ? "true" : "false";

        string memory json = Base64.encode(
            bytes(
                abi.encodePacked(
                    '{"name": "', pokemon.name,
                    '", "nickName": "', pokemon.nickname,
                    '", "tokenId": ', Strings.toString(pokemon.id),
                    ', "pokedexId": ', Strings.toString(pokemon.pokedex_id),
                    ', "ability1": "', pokemon.ability1_name,
                    '", "ability2": "', pokemon.ability2_name,
                    '", "baseHp": ', Strings.toString(pokemon.base_hp),
                    ', "baseAtk": ', Strings.toString(pokemon.base_attack),
                    ', "baseDef": ', Strings.toString(pokemon.base_defense),
                    ', "baseSpAtk": ', Strings.toString(pokemon.base_attack_sp),
                    ', "baseSpDef": ', Strings.toString(pokemon.base_defense_sp),
                    ', "baseSpeed": ', Strings.toString(pokemon.base_speed),
                    ', "height": ', Strings.toString(pokemon.height),
                    ', "weight": ', Strings.toString(pokemon.weight),
                    ', "level": ', Strings.toString(pokemon.level),
                    ', "natureIndex": ', Strings.toString(pokemon.nature_index),
                    ', "exp": ', Strings.toString(pokemon.exp),
                    ', "ivHp": ', Strings.toString(pokemon.iv_hp),
                    ', "ivAtk": ', Strings.toString(pokemon.iv_attack),
                    ', "ivDef": ', Strings.toString(pokemon.iv_defense),
                    ', "ivSpAtk": ', Strings.toString(pokemon.iv_attack_sp),
                    ', "ivSpDef": ', Strings.toString(pokemon.iv_defense_sp),
                    ', "ivSpeed": ', Strings.toString(pokemon.iv_speed),
                    ', "evHp": ', Strings.toString(pokemon.ev_hp),
                    ', "evAtk": ', Strings.toString(pokemon.ev_attack),
                    ', "evDef": ', Strings.toString(pokemon.ev_defense),
                    ', "evSpAtk": ', Strings.toString(pokemon.ev_attack_sp),
                    ', "evSpDef": ', Strings.toString(pokemon.ev_defense_sp),
                    ', "evSpeed": ', Strings.toString(pokemon.ev_speed),
                    ', "isShiny": ', isShiny,
                    ', "image": "', pokemon.img_sprite_url,
                    '"}'
                )
            )
        );

        return string (abi.encodePacked(_baseURI(), json));
    }

    function mintPokemon(
        uint16 _pokedex_id,
        string memory _name,
        string memory _nickname,
        string memory _img_sprite_url,
        string memory _ability1_name,
        string memory _ability2_name,
        uint16 _base_hp,
        uint16 _base_attack,
        uint16 _base_defense,
        uint16 _base_attack_sp,
        uint16 _base_defense_sp,
        uint16 _base_speed,
        uint16 _base_height,
        uint16 _base_weight) external {

        uint256 pokemonId = createRandomPokemon(
            _pokedex_id,
            _name,
            _nickname,
            _img_sprite_url,
            _ability1_name,
            _ability2_name,
            _base_hp,
            _base_attack,
            _base_defense,
            _base_attack_sp,
            _base_defense_sp,
            _base_speed,
            _base_height,
            _base_weight
        );

        emit Transfer(address(0), _msgSender(), pokemonId);
    }

    function burnPokemon(uint256 _pokemonId) public {
        releasePokemon(_pokemonId);
        emit Transfer(_msgSender(), address(0), _pokemonId);
    }

    // ERC721
    function balanceOf(address _owner) external view returns (uint256) {
        return s_ownerPokemonCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return s_pokemonToOwner[_tokenId];
    }

    function approve(address /*_to*/, uint256 _tokenId) external view {
        revert PokemonApprovalNotAllowed(_msgSender(), _tokenId);
    }

    function setApprovalForAll(address _operator, bool /*_approved*/) external pure {
        revert PokemonApprovalNotAllowed(_operator, 0);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        return _requireOwned(_tokenId);
    }

    function isApprovedForAll(address _owner, address _operator) external pure returns (bool) {
        return _operator == _owner;
    }

    function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
        return
            _interfaceId == type(IERC721).interfaceId ||
            _interfaceId == type(IERC721Metadata).interfaceId ||
            _interfaceId == type(IERC721Errors).interfaceId; 
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
        safeTransferFrom(_from, _to, _tokenId, _msgData());
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) public {
        transferFrom(_from, _to, _tokenId);
        ERC721Utils.checkOnERC721Received(_msgSender(), _from, _to, _tokenId, _data);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        
        if (_from == address(0)) {
            revert ERC721InvalidSender(address(0));
        }
        
        if (_to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }
        
        if (_requireOwned(_tokenId) != _from) {
            revert ERC721InvalidOwner(_from);
        }

        s_ownerPokemonCount[_to]++;
        s_ownerPokemonCount[_from]--;
        s_pokemonToOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function _ownerOf(uint256 _tokenId) internal view returns (address) {
        return s_pokemonToOwner[_tokenId];
    }

    /**
     * @dev Reverts if the `tokenId` doesn't have a current owner (it hasn't been minted, or it has been burned).
     * Returns the owner.
     */
    function _requireOwned(uint256 _tokenId) internal view returns (address) {
        address owner = _ownerOf(_tokenId);
        if (owner == address(0)) {
            revert ERC721NonexistentToken(_tokenId);
        }
        return owner;
    }



}