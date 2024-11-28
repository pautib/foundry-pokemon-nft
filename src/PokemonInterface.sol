// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { IERC721Metadata } from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import { IERC721Errors } from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Utils.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import { PokemonHelper } from "./PokemonHelper.sol";

contract PokemonInterface is Context, IERC721, IERC721Metadata, IERC721Errors, PokemonHelper {

    string private constant TOKEN_SYMBOL = "PKMN";
    string private constant TOKEN_NAME = "PokesPautib";

    /**
     * @dev We won't allow to allow sending Pokemons from another trainer.
     * The owner of the Pokemon is the only one allowed to transfer it.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error PokemonApprovalNotAllowed(address operator, uint256 tokenId);

    // Metadata
    function name() external pure returns (string memory) {
        return TOKEN_NAME;
    }

    function symbol() external pure returns (string memory) {
        return TOKEN_SYMBOL;
    }

    function tokenURI(uint256 _tokenId) external pure override returns (string memory) {
        return string(abi.encodePacked("https://pokeapi.co/api/v2/pokemon/", Strings.toString(_tokenId)));
    }

    // ERC721
    function balanceOf(address _owner) external view returns (uint256) {
        return ownerPokemonCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return pokemonToOwner[_tokenId];
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

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC721Errors).interfaceId; 
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

        ownerPokemonCount[_to]++;
        ownerPokemonCount[_from]--;
        pokemonToOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function _ownerOf(uint256 tokenId) internal view returns (address) {
        return pokemonToOwner[tokenId];
    }

    /**
     * @dev Reverts if the `tokenId` doesn't have a current owner (it hasn't been minted, or it has been burned).
     * Returns the owner.
     */
    function _requireOwned(uint256 tokenId) internal view returns (address) {
        address owner = _ownerOf(tokenId);
        if (owner == address(0)) {
            revert ERC721NonexistentToken(tokenId);
        }
        return owner;
    }

}