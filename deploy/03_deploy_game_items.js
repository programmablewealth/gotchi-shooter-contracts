// deploy/00_deploy_my_contract.js

module.exports = async ({ethers, getNamedAccounts, deployments}) => {
    const {deploy} = deployments;
    const {deployer} = await getNamedAccounts();
    
    const GameStoreContract = await ethers.getContract("GameStore");

    await deploy('GameItems', {
      from: deployer,
      args: [GameStoreContract.address],
      log: true,
    });
};

module.exports.tags = ['GameItems'];