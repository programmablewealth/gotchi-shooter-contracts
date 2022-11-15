// deploy/00_deploy_my_contract.js

module.exports = async ({ethers, getNamedAccounts, deployments}) => {
    const {deploy} = deployments;
    const {deployer} = await getNamedAccounts();
    
    const GhordeBucksContract = await ethers.getContract("GhordeBucks");
    const GameProfileContract = await ethers.getContract("GameProfile");

    await deploy('GameStore', {
      from: deployer,
      args: [GhordeBucksContract.address, GameProfileContract.address],
      log: true,
    });
};

module.exports.tags = ['GameStore'];