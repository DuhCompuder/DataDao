import {
  SavedDeploymentInfoOnlyABI,
  FormatedDeploymentInfo,
} from "../src/deployment/deploymentTypes";
import { abi } from "../artifacts/contracts/InstitutionDao.sol/Institution.json";
import { writeDeploymentInfo } from "./writeToDeploymentFile";
import clc from "cli-color";

async function main() {
  const deploymentInfo: SavedDeploymentInfoOnlyABI = abi;

  const formatDeploymentInfo: FormatedDeploymentInfo = {
    Institution: {
      contractABI: deploymentInfo,
    },
  };
  console.log(
    clc.green(`Saving contract ABI info for Institution contract...`)
  );
  try {
    //Check if file exist. create one if not, otherwise copy from file and modify it.
    const existingFile:
      | FormatedDeploymentInfo
      | undefined = require("../src/deployment/OperatingDeploymentInfo.json");
    if (existingFile) {
      existingFile.Institution = { contractABI: deploymentInfo };
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
