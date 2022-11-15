require("@nomicfoundation/hardhat-toolbox");
require('hardhat-deploy');
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config()

/** @type import('hardhat/config').HardhatUserConfig */

// npx hardhat verify --network polygon 0xEf7B07dA9cE15cF53E60E51b6227901d4E5C60D1

module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "polygon",
  chainId: 137,
  networks: {
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      gasPrice: 60 * 1000000000,
      chainId: 137,
      accounts: [process.env.DEPLOYER_PRIVATE_KEY]
    },
  },
  namedAccounts: {
    deployer: {
        default: 0, // here this will by default take the first account as deployer
    },
  },
  etherscan: {
    apiKey : {
      polygon: process.env.POLYGONSCAN_API_KEY
    }
  },
};
