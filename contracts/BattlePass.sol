// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import '@openzeppelin/contracts/access/Ownable.sol';
import './GameItems.sol';

/**
 * Battle Passes have a season, season start block, and season end block
 * GameProfile will track a players XP/Level
 * Battle Passes have prizes that can be claimed once XP/Level requirements are met
 * Battle Pass should hold ERC20s, ERC721s, and ERC1155s
 *  These assets should be mintable by the protocol:
 *      ERC20s      - GBUX
 *      ERC721s     - 
 *      ERC1155s    - Health Potion, Shield Potion, Screen Clear Item, Gotchi Horde Raffle Ticket, Crafting Materials, Weapon Skins, Mana Potion
 *  It should support assets not minted by the protocol: (maybe this is done through the Gotchi Horde Raffle Tickets)
 *      ERC20s      - GLTR from protocol rewards staking pool, GHST, Alch
 *      Loot Chests being developed by John Gotchi
 * Battle Pass should segregate these assets based on the season
 * Battlepass have a season when they will be active (with claimable items)
 * Once a season ends unclaimed ERC20s/ERC721s/ERC1155s will be burned (or do items get minted as they are claimed)
 */

// technical the contract won't hold these rewards. they would be minting them at claim time on behalf of the player
contract BattlePass is Ownable {
    uint256 public constant ERC20_REWARD_TYPE = 0;
    uint256 public constant ERC721_REWARD_TYPE = 1;
    uint256 public constant ERC1155_REWARD_TYPE = 2;

    struct Pass {
        uint256 startBlock;
        uint256 endBlock;
    }

    struct Reward {
        uint256 levelRequirement;
        uint256 tokenType;
        address contractAddress;
        uint256 tokenId;
        uint256 quantity;
    }

    address gbuxAddress;
    address gameItemsAddress;

    mapping (uint256 => Pass) seasonBattlePass;                                                 // season id mapped to Pass
    mapping (uint256 => bool) seasonExists;                                                     // season id mapped to if Pass exists
    mapping (uint256 => Reward[]) rewards;
    mapping (uint256 => mapping(address => mapping(uint256 => bool))) rewardClaimed;

    constructor(address _gbuxAddress, address _gameItemsAddress) {
        gbuxAddress = _gbuxAddress;
        gameItemsAddress = _gameItemsAddress;
    }

    function CreateBattlePass(uint256 _season, uint256 _startBlock, uint256 _endBlock) public onlyOwner {
        require(seasonExists[_season] == false, "Battle Pass Season Already exists");
        seasonBattlePass[_season] = Pass(_startBlock, _endBlock);
        seasonExists[_season] = true;
    }

    function AddBattlePassRewards(uint256 _season) public onlyOwner {
        Reward memory gbux50 = Reward(1, ERC20_REWARD_TYPE, gbuxAddress, 0, 50);   
        Reward memory healthPotions3 = Reward(2, ERC1155_REWARD_TYPE, gameItemsAddress, 0, 3);   
        Reward memory raffleTickets5 = Reward(3, ERC1155_REWARD_TYPE, gameItemsAddress, 1, 5);   
        Reward memory screenClearer1 = Reward(4, ERC1155_REWARD_TYPE, gameItemsAddress, 2, 1);   
        Reward memory raffleTickets10 = Reward(5, ERC1155_REWARD_TYPE, gameItemsAddress, 1, 10);   
        Reward memory screenClearer2 = Reward(6, ERC1155_REWARD_TYPE, gameItemsAddress, 2, 2);   
        Reward memory screenClearer3 = Reward(7, ERC1155_REWARD_TYPE, gameItemsAddress, 2, 3);   
        Reward memory raffleTickets20 = Reward(8, ERC1155_REWARD_TYPE, gameItemsAddress, 1, 20);

        rewards[_season].push(gbux50);   
        rewards[_season].push(healthPotions3);   
        rewards[_season].push(raffleTickets5);   
        rewards[_season].push(screenClearer1);   
        rewards[_season].push(raffleTickets10);   
        rewards[_season].push(screenClearer2);   
        rewards[_season].push(screenClearer3);   
        rewards[_season].push(raffleTickets20);   
    }

    function ClaimReward(uint256 _season, uint256 level) public {
        uint[] memory tokenIds = new uint[](1);
        tokenIds[0] = rewards[_season][level].tokenId;

        uint[] memory amounts = new uint[](1);
        amounts[0] = rewards[_season][level].quantity;

        GameItems(gameItemsAddress).MintItems(msg.sender, _season, level, tokenIds, amounts, bytes(""));

        rewardClaimed[_season][msg.sender][level] = true;
    }

    function SeasonExists(uint256 _season) public view returns(bool) {
        return seasonExists[_season];
    }

    function RewardClaimed(uint256 _season, address _account, uint256 _level) public view returns(bool) {
        return rewardClaimed[_season][_account][_level];
    }
}