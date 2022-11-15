// deploy/00_deploy_my_contract.js

module.exports = async ({ethers, getNamedAccounts, deployments}) => {
    const {deploy} = deployments;
    const {deployer} = await getNamedAccounts();

    await deploy('GameProfile', {
      from: deployer,
      args: [],
      log: true,
    });
};

module.exports.tags = ['GameProfile'];