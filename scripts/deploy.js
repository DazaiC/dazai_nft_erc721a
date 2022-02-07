// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  // const Greeter = await hre.ethers.getContractFactory("Greeter");
  // const greeter = await Greeter.deploy("Hello, Hardhat!");

  // await greeter.deployed();

  // console.log("Greeter deployed to:", greeter.address);
  // const EGG = await hre.ethers.getContractFactory("EGG");
  // const egg = await EGG.deploy();

  // await egg.deployed();

  // console.log("EGG deployed to:", egg.address);

  // const SharedWallet = await hre.ethers.getContractFactory("SharedWallet");
  // const share = await SharedWallet.deploy();

  // await share.deployed();

  // console.log("SHARE deployed to:", share.address);

  const Rookies = await hre.ethers.getContractFactory("Rookies");
  const roky = await Rookies.deploy();

  await roky.deployed();

  console.log("Rookies deployed to:", roky.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
