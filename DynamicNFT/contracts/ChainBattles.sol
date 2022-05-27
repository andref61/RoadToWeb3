// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter; 
    Counters.Counter private _tokenIds;
    Counters.Counter private _randNonce;

    struct character {
        string class;
        uint256 level;
        uint256 health;
        uint256 defense;
        uint256 strength;
    }

    string[] classArray = ["Warrior", "Mage", "Healer", "Thief"];

    mapping(uint256 => character) public tokenIdToCharacter;

    constructor() ERC721 ("Chain Battles", "CBTLS") {
    }

    function generateCharacter(uint256 tokenId) public view returns(string memory) {
        bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',getClass(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevel(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Health: ",getHealth(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Defense: ",getDefense(tokenId),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '</svg>'
        );

        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function getClass(uint256 tokenId) public view returns (string memory) {
        string memory class = tokenIdToCharacter[tokenId].class;
        return class;
    }
    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToCharacter[tokenId].level;
        return level.toString();
    }

    function getHealth(uint256 tokenId) public view returns (string memory) {
        uint256 health = tokenIdToCharacter[tokenId].health;
        return health.toString();
    }

    function getDefense(uint256 tokenId) public view returns (string memory) {
        uint256 defense = tokenIdToCharacter[tokenId].defense;
        return defense.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToCharacter[tokenId].strength;
        return strength.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        character memory newCharacter = character(classArray[random(3)], 1, random(10), random(10), random(10));
        tokenIdToCharacter[newItemId] = newCharacter;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        uint randomTest = random(10);
        require(randomTest > tokenIdToCharacter[tokenId].level, "Failed to train");
        tokenIdToCharacter[tokenId].level++;
        tokenIdToCharacter[tokenId].defense++;
        tokenIdToCharacter[tokenId].health++;
        tokenIdToCharacter[tokenId].strength++;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function random(uint number) public returns(uint){
        _randNonce.increment();
        return uint(keccak256(abi.encodePacked(block.timestamp, _randNonce.current(), msg.sender))) % number;
    }
}