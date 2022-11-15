User Journey

Go to GotchHorde.com
Login to the game via Metamask using Chainsafe SDK
Select register a GameProfile
Enter a profile nick name, select button to mint the soulbound ERC721 (maximum of 1 per account)
Nickname must be unique can pay a once off fee to get this changed later
On your Game Profile, see the prizes up for grabs for those with a battlepass, select from two options to mint a battlepass, one for stables or one for ghst (at a discount)
Via Season Quests available against your Game Profile, turn them in when you have completed them for an season based ERC20 to level up season progress in GameProfile

Process:

Get DAI or GHST to buy GBUX
Approve the GBUX contract to spend your DAI/GHST (using the DAI/GHST contract approve function)
Mint GBUX with your DAI/GHST (using GBUX contract BuyMint function)
Mint a Game Profile (using GameProfile contract MintProfile function)
Approve the GameStore contract to spend your GBUX (using GBUX contract approve function)
Purchase the Battle Pass (using GameStore contract PurchaseBattlePass function)