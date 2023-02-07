import { task } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
// import { ethers, network } from "hardhat";
import {
  SavedDeploymentInfo,
  FormatedDeploymentInfo,
} from "../src/deployment/deploymentTypes";

task("dao-manager-addr", "Gets address of deployed contract: DaoManager.sol.")
  .addParam("networkid", "network contract is deployed to.")
  .setAction(async (taskArgs) => {
    const existingFile:
      | FormatedDeploymentInfo
      | undefined = require("../src/deployment/OperatingDeploymentInfo.json");
    if (existingFile) {
      const info = existingFile!.DataDaoManager[
        taskArgs.networkid
      ] as SavedDeploymentInfo; //[taskArgs.networkId as number]!; //as SavedDeploymentInfo;
      console.log("Dao Manager Address", info.contractAddress);
    }
  });
