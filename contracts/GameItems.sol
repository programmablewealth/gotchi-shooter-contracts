// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import './GameStore.sol';
import './BattlePass.sol';

contract GameItems is ERC1155, Ownable {
    struct Item {
        string itemName;
        bool isConsumable;
    }

    Item[] items;

    address gameStoreAddress;
    address battlePassAddress;

    constructor(address _gameStoreAddress) ERC1155("https://game.example/api/item/{id}.json") {
        items.push(Item("Health Potion", true));
        items.push(Item("Screen Clearer", true));
        items.push(Item("Raffle Tickets", false));

        gameStoreAddress = _gameStoreAddress;
    }

    function SetBattlePassAddress(address _battlePassAddress) public onlyOwner {
        battlePassAddress = _battlePassAddress;
    }
    
    function AddItem(string calldata _itemName, bool _isConsumable) public onlyOwner {
        items.push(Item(_itemName, _isConsumable));
    }

    function GetItemInfo(uint256 _tokenId) public view returns(Item memory) {
        return items[_tokenId];
    }

    function MintItems(
        address player,
        uint256 season,
        uint256 level,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        require(battlePassAddress != address(0), "Battle Pass Address Must Be Set");
        require(BattlePass(battlePassAddress).SeasonExists(season) == true, "Battle Pass Season Doesn't Exist");
        require(GameStore(gameStoreAddress).HasBattlePass(player, season), "Player Doesn't Have Battle Pass");
        require(BattlePass(battlePassAddress).RewardClaimed(season, player, level) == false, "Reward Already Claimed");

        _mintBatch(player, ids, amounts, data);
    }
}