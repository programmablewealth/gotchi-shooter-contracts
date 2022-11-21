// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

import './BattlePass.sol';
import './GameStore.sol';

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
    mapping (uint256 => string) profileName;                            // profile token id => profile name
    mapping (string => bool) nameInUse;                                 // profile name => is name in use
    mapping (uint256 => uint256) profileXP;                             // profile token id => profile XP
    mapping (uint256 => mapping(uint256 => uint256)) seasonXP;          // profile token id => season # => season XP
    mapping (address => uint256) ownersProfileTokenId;                  // account => profile token ID

    address battlePassAddress;
    address gameStoreAddress;

    struct GameProfileInfo {
        uint256 tokenId;
        string name;
        uint256 profileXP;
        uint256[] seasonXPs;
        bool[] battlePasses;
    }

    constructor() ERC721("GhordeProfile", "GPROF") {
    }

    function SetBattlePassAddress(address _battlePassAddress) public onlyOwner {
        battlePassAddress = _battlePassAddress;
    }

    function SetGameStoreAddress(address _gameStoreAddress) public onlyOwner {
        gameStoreAddress = _gameStoreAddress;
    }

    function MintProfile(string calldata _profileName) public {
        require(profilesOwned[msg.sender] == false, "You already have or had a profile");
        require(nameInUse[_profileName] == false, "Profile name already exists");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);

        profilesOwned[msg.sender] = true;
        nameInUse[_profileName] = true;
        ownersProfileTokenId[msg.sender] = tokenId;
        profileName[tokenId] = _profileName;
    }

    function IssueXP(address owner, uint256 season, uint256 xp) public onlyOwner {
        uint256 tokenId = ownersProfileTokenId[owner];
        
        // update profile XP
        profileXP[tokenId] += xp;

        // update season XP
        seasonXP[tokenId][season] += xp;
    }

    // used for testing, user can self claim XP without game verifying it is legitimate
    function ClaimXP(uint256 season, uint256 xp) public {
        require(profilesOwned[msg.sender] == true, "You must have a GameProfile to claim XP");

        uint256 tokenId = ownersProfileTokenId[msg.sender];
        
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

    function AccountSeasonXP(address _account, uint256 _season) public view returns(uint256) {
        require(HasGameProfile(_account) == true, "Account has no Game Profile");
        uint256 tokenId = GetOwnersGameProfileTokenID(_account);
        return seasonXP[tokenId][_season];
    }

    function GetGameProfileInfo(address _account) public view returns(GameProfileInfo memory) {
        require(HasGameProfile(_account) == true, "Account has no Game Profile");
        require(battlePassAddress != address(0), "Battle Pass address not set");
        require(gameStoreAddress != address(0), "Game Store address not set");

        uint256 tokenId = GetOwnersGameProfileTokenID(_account);
        uint256 seasons = BattlePass(battlePassAddress).GetSeasonCount();
        uint256[] memory seasonXPs = new uint256[](seasons);
        for (uint256 i = 0; i < seasons; i++) {
            seasonXPs[i] = seasonXP[tokenId][i];
        }

        bool[] memory battlePasses = new bool[](seasons);
        for (uint256 i = 0; i < seasons; i++) {
            battlePasses[i] = GameStore(gameStoreAddress).HasBattlePass(_account, i);
        }

        GameProfileInfo memory gameProfileInfo = GameProfileInfo(
            tokenId,
            profileName[tokenId],
            profileXP[tokenId],
            seasonXPs,
            battlePasses
        );

        return gameProfileInfo;
    }
 }