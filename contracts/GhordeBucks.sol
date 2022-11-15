// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

/**
 * Can be Minted:
 * - with DAI or GHST for 10% bonus tokens      [done]
 * - by completing season quests                [todo]
 * 
 * Can be used for:
 * - Unlocking Battle Pass                      [todo]
 * - Buying items from the in-game store        [todo]
 */
contract GhordeBucks is ERC20, ERC20Burnable, Ownable {
    mapping (address => uint256) tokenMintRate;
    mapping (uint256 => uint256) questReward;
    mapping (address => mapping (uint256 => bool)) userQuestRedeemed;

    address DAI_TOKEN_ADDRESS = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
    address GHST_TOKEN_ADDRESS = 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7;

    uint256 BASE_GBUX_RATE = 100;
    uint256 GHST_GBUX_MULTIPLIER = 110;

    constructor() ERC20("GhordeBucks", "GBUX") {
        tokenMintRate[DAI_TOKEN_ADDRESS] = BASE_GBUX_RATE;
        tokenMintRate[GHST_TOKEN_ADDRESS] = GHST_GBUX_MULTIPLIER;
    }

    // note: msg.sender must have approved GhordeBucks contract to spend DAI/GHST first
    function BuyMint(address token, uint256 amount) public {
        require(amount > 0, "Amount Cannot Be 0"); 
        require(tokenMintRate[token] > 0, "Token Cannot Mint GBUX"); 

        require(IERC20(token).balanceOf(msg.sender) >= amount, "Insufficient Funds");

        uint256 allowance = IERC20(token).allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the Token Allowance");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, (amount / 100) * tokenMintRate[token]);
    }

    // function QuestMint(address to, uint256 questID) public {
    //     require(questReward[questID] > 0, "Quest must have reward"); 
    //     require(userQuestRedeemed[to][questID] == false, "Quest reward already redeemed"); 
    //     _mint(to, questReward[questID]); 
    // }

    function SetTokenMintRate(address token, uint256 amount) public onlyOwner {
        tokenMintRate[token] = amount;
    }

    function WithdrawERC20(address token, address to) public onlyOwner {
        uint256 erc20Bal = IERC20(token).balanceOf(address(this));
        require(erc20Bal > 0, "Contract ERC20 Balance is 0"); 
        IERC20(token).approve(address(this), erc20Bal);
        IERC20(token).transferFrom(address(this), to, erc20Bal);
    }

    function GetTokenMintRate(address token) public view returns(uint256) {
        return tokenMintRate[token];
    }
}