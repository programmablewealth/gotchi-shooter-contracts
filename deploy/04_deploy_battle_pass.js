// deploy/00_deploy_my_contract.js

module.exports = async ({ethers, getNamedAccounts, deployments}) => {
    const {deploy} = deployments;
    const {deployer} = await getNamedAccounts();
    
    const GhordeBucksContract = await ethers.getContract("GhordeBucks");

    const GameItemsContract = await ethers.getContract("GameItems", deployer);

    await deploy('BattlePass', {
      from: deployer,
      args: [GhordeBucksContract.address, GameItemsContract.address],
      log: true,
    });

    // set battle pass address on game items contract
    const BattlePassContract = await ethers.getContract("BattlePass");

    await GameItemsContract.SetBattlePassAddress(BattlePassContract.address).then(
      (tx) => {
        console.log(`Calling SetBattlePassAddress on "Game Items" contract (tx: ${tx})`);
        tx.wait()
      }
    );

    await BattlePassContract.CreateBattlePass(0, 100, 1000).then(
      (tx) => {
        console.log(`Calling CreateBattlePass on "BattlePassContract" contract (tx: ${tx})`);
        tx.wait()
      }
    );

    await BattlePassContract.AddBattlePassRewards(0).then(
      (tx) => {
        console.log(`Calling AddBattlePassRewards on "BattlePassContract" contract (tx: ${tx})`);
        tx.wait()
      }
    );
};

module.exports.tags = ['BattlePass'];