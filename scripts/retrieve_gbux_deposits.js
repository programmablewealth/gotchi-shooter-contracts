// node .\scripts\retrieve_gbux_deposits.js HARDHAT_NETWORK=polygon
const hre = require("hardhat");

async function main() {
    const ghstToken = "0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7";
    const withdrawalDestination = "0xc17919f92ed514f90e5e476949311b587dc3332c";
    const GhordeBucksContractAddress = "0x9609B23D7d3168693cFB2Ad9E11Aabcd14775A31";        // update this with the correct contract

    // const GhordeBucksContract = await hre.ethers.getContract("GhordeBucks");
    const GhordeBucksContract = await hre.ethers.getContractAt("GhordeBucks", GhordeBucksContractAddress);
    const withdraw = await GhordeBucksContract.WithdrawERC20(ghstToken, withdrawalDestination);

    console.log(
        `withdraw ${ghstToken} from ${GhordeBucksContract.address} and send to ${withdrawalDestination}`
    );

    console.log(withdraw.hash)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});