// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * erc721 token                                            [done]
 * soulbound                                               [done]
 * burnable                                                [done]
 * GameProfile tracks XP across many gotchis               [done]
 * Max of 1 GameProfile per account (even if burned)       [done]
 * Unique name                                             [done]
 * GameProfile can sign up for battlepass                  [done]
 **/

 contract GameProfile is ERC721, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping (address => bool) profilesOwned;                            // account => profile owned
    mapping (string => bool) nameInUse;                                 // profile name => is name in use
    mapping (uint256 => uint256) profileXP;                             // profile token id => profile XP
    mapping (uint256 => mapping(uint256 => uint256)) seasonXP;          // profile token id => season # => season XP
    mapping (address => uint256) ownersProfileTokenId;                  // account => profile token ID

    constructor() ERC721("GhordeProfile", "GPROF") {
    }

    function MintProfile(string calldata profileName) public {
        require(profilesOwned[msg.sender] == false, "You already have or had a profile");
        require(nameInUse[profileName] == false, "Profile name already exists");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);

        profilesOwned[msg.sender] = true;
        nameInUse[profileName] = true;
        ownersProfileTokenId[msg.sender] = tokenId;
    }

    function IssueXP(address owner, uint256 season, uint256 xp) public onlyOwner {
        uint256 tokenId = ownersProfileTokenId[owner];
        
        // update profile XP
        profileXP[tokenId] += xp;

        // update season XP
        seasonXP[tokenId][season] += xp;
    }

    function _beforeTokenTransfer(address from, address to, uint256, uint256) pure internal override {
        require(from == address(0) || to == address(0), "This a Soulbound token. It cannot be transferred. It can only be burned by the token owner.");
    }

    function burn(uint256 tokenId) public override {
        require(ownerOf(tokenId) == msg.sender, "Only the owner of the token can burn it.");
        _burn(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function HasGameProfile(address _account) public view returns(bool) {
        return profilesOwned[_account];
    }

    // important: Check HasGameProfile first, because it will return tokenId = 0 if there is no game profile
    function GetOwnersGameProfileTokenID(address _account) public view returns(uint256) {
        return ownersProfileTokenId[_account];
    }
 }