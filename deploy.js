const hre = require("hardhat");

async function main() {
  const RebaseToken = await hre.ethers.getContractFactory("RebaseToken");
  const token = await RebaseToken.deploy();

  await token.waitForDeployment();
  console.log(`RebaseToken deployed to: ${await token.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
