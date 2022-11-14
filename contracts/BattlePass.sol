// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/**
 * GameProfile can sign up to a Battlepass (costs stablecoin or GHST/Alch for discount) - these are tied to a profile
 * GHST/alch good give a bonus item aswell / delta between stablecoin vs ghst/alch should either get burned or be transferred to the AavegotchiDAO)
 * Battlepass have a season when they will be active (with claimable items)
 * Claimable items can be NFTs, ERC20s, ERC721s, ERC1155s
 * Where will these items come from
 *  either they will be minted when claimed
 *  or they will be pulled from a smart contract - how to make sure that these don't run out?
 * Resource earned in game needs to be spent to unlock items in the battlepass
 */

contract BattlePass {
    
}