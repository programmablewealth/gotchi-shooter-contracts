// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';

import './GameProfile.sol';

/**
 * Purchase a Battle Pass with GBUX                                                         [done]
 * GBUX is burned during Purchase                                                           [done]
 * Battle Pass is associated with Game Profile                                              [done]
 * Implement a cut of sales going to player rewards pool, gamedev fund, and aavegotchi dao  [todo]
 */

contract GameStore is Ownable {
    address ghordeBucksContract;
    address gameProfileContract;
    
    mapping (uint256 => uint256) battlePassPrice;

    mapping (uint256 => mapping(uint256 => bool)) battlePassOwned;      // profile token id => season # => battle pass owned

    constructor(address _ghordeBucksContract, address _gameProfileContract) {
        ghordeBucksContract = _ghordeBucksContract;
        gameProfileContract = _gameProfileContract;
        battlePassPrice[0] = 5 ether;
    }

    function SetGhordeBucksContract(address _ghordeBucksContract) public onlyOwner {
        ghordeBucksContract = _ghordeBucksContract;
    }

    function SetGameProfileContract(address _gameProfileContract) public onlyOwner {
        gameProfileContract = _gameProfileContract;
    }

    function SetBattlePassPrice(uint256 _season, uint256 _price) public onlyOwner {
        battlePassPrice[_season] = _price;
    }

    function GetBattlePassPrice(uint256 _season) public view returns(uint256) {
        return battlePassPrice[_season];
    }

    // note: msg.sender must have approved GameStore contract to spend GBUX first
    function PurchaseBattlePass(uint256 _season) public {
        require(battlePassPrice[_season] > 0, "Battle Pass Has No Price"); 

        GameProfile gameProfile = GameProfile(gameProfileContract);
        require(gameProfile.HasGameProfile(msg.sender) == true, "Account doesn't have a Game Profile"); 
        require(HasBattlePass(msg.sender, _season) == false, "Account already has a Battle Pass"); 

        uint256 cost = battlePassPrice[_season];
        require(IERC20(ghordeBucksContract).balanceOf(msg.sender) >= cost, "Insufficient GhordeBucks"); 
        ERC20Burnable ghordeBucks = ERC20Burnable(ghordeBucksContract);
        ghordeBucks.burnFrom(msg.sender, cost);

        uint256 tokenId = gameProfile.GetOwnersGameProfileTokenID(msg.sender);
        battlePassOwned[tokenId][_season] = true;
    }

    function HasBattlePass(address _account, uint256 _season) public view returns(bool) {
        GameProfile gameProfile = GameProfile(gameProfileContract);

        if (!gameProfile.HasGameProfile(_account)) {
            return false;
        }

        uint256 tokenId = gameProfile.GetOwnersGameProfileTokenID(_account);
        return battlePassOwned[tokenId][_season];
    }
}