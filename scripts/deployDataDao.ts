import hre, { ethers } from "hardhat";
import {
  SavedDeploymentInfo,
  FormatedDeploymentInfo,
} from "../src/deployment/deploymentTypes";
import { DaoManager, DaoManager__factory } from "../src/types";
import { abi } from "../artifacts/contracts/DataDaoManager.sol/DaoManager.json";
import { writeDeploymentInfo } from "./writeToDeploymentFile";
import clc from "cli-color";

async function main() {
  const feeData = await hre.ethers.provider.getFeeData();
  const DaoManager: DaoManager__factory = await ethers.getContractFactory(
    "DaoManager"
  );
  const daoManager: DaoManager = await DaoManager.deploy({
    maxPriorityFeePerGas: feeData.maxPriorityFeePerGas!,
    maxFeePerGas: feeData.maxFeePerGas!,
  });
  await daoManager.deployed();
  console.log("DataDaoManager to address: ", daoManager.address);

  // create JSON file of each contract and contract details/deployment for the most recent deployed info
  const network = (await ethers.provider.getNetwork()).chainId;
  const deploymentInfo: SavedDeploymentInfo = {
    networkId: network,
    contractABI: abi,
    contractAddress: daoManager.address,
  };

  const formatDeploymentInfo: FormatedDeploymentInfo = {
    DataDaoManager: {
      [network]: deploymentInfo,
    },
  };
  console.log(
    clc.green(
      `Saving deployment info for DataDaoManager contract on network: ${network}...`
    )
  );
  try {
    //Check if file exist. create one if not, otherwise copy from file and modify it.
    const existingFile:
      | FormatedDeploymentInfo
      | undefined = require("../src/deployment/OperatingDeploymentInfo.json");
    if (existingFile) {
      existingFile.DataDaoManager[network] = deploymentInfo;
      await writeDeploymentInfo(existingFile);
    }
  } catch (e) {
    // uncomment for debug
    // console.error(e);
    console.log(
      clc.yellow("No existing file: Creating new deployment info json file...")
    );
    await writeDeploymentInfo(formatDeploymentInfo);
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
