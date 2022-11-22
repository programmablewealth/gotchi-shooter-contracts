# Gotchi Horde Game Smart Contracts

## Introduction

This repo contains the smart contracts used in [Gotchi Horde](https://gotchihorde.com) a multiplayer shoot 'em up game, currently under development, that makes use of Aavegotchi ecosystem assets.

## Smart Contracts

### GotchiHorde Bucks (GBUX)

GBUX is an ERC20 built specifically for this game.

GBUX can be minted using DAI or GHST. To incentivise the use of GHST, when minting with GHST you will receive a notably higher amount of GBUX per USD value of GHST vs. DAI.

These funds will be set aside to fund additional game development and content.

Some may be used for player rewards and as a commission to the Aavegotchi DAO.

GBUX is used in the Game Store and for purchasing the Battle Pass that allows that player to mint ERC20s, ERC1155s, and ERC721s in the Battle Pass as they level up their Battle Pass through gameplay.

### Game Profile

Accounts require a Game Profile to collect XP and acquire a Battle Pass.

A Game Profile is a soulbound (i.e. non-transferable) NFT, specifically it is an ERC721.

A Game Profile must have a unique nick name, and there is a maximum of one that can be held per account.

XP dropped to a player's account on-chain, as a reward for completing gameplay.

The mechanism for this is still under development but will likely involve off-chain storage of matches completed by the player that is batch dropped on-chain by an XP manager contract that has the access to update the player's XP on-chain.

### Game Store

Players will be able to purchase in-game items and a seasonal Battle Pass from the Game Store smart contract using GBUX.

### Game Items

The game will feature a number of ERC1155s that can be used in-game.

These items get minted when claimed through a Battle Pass reward or when they are purchased via the Game Store.

These items get burned when they are consumed in-game.

### Battle Pass

The seasonal Battle Pass can be purchased with GBUX and will feature different rewards per level.

Once the XP requirements are meet for each level, rewards can be claimed via the Battle Pass, and they will be minted on-chain and transferred to the Battle Pass owner.

### Raffles

Support for raffles will be added in the future. The Battle Pass will contain some raffle tickets as rewards that can be entered into a raffle managed by Chainlink VRF to win various Aavegotchi NFTs.