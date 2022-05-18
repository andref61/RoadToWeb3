// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";

contract Alchemy is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _tokensOwned;
    uint256 MAX_SUPPLY= 10000;

    mapping(address => Counters.Counter) public tokenOwners;

    function tokenOwnerCount(address owner) public view returns(uint256 count) {
        return tokenOwners[owner].current();
    }

    constructor() ERC721("ADF NFT Collection!", "ADF") {}

    function safeMint(address to, string memory uri) public  {
        require( tokenOwners[msg.sender].current() < 5, "You have minted the max number of NFTS...");
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= MAX_SUPPLY, "Max NFTs have been minted");
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        tokenOwners[msg.sender].increment();
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
