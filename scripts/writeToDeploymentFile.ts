import fs from "fs";
import { FormatedDeploymentInfo } from "../src/deployment/deploymentTypes";
import clc from "cli-color";

export async function writeDeploymentInfo(
  deploymentFormat: FormatedDeploymentInfo
) {
  try {
    fs.writeFile(
      `./src/deployment/OperatingDeploymentInfo.json`,
      JSON.stringify(deploymentFormat),
      (err) => {
        err
          ? console.error(err)
          : console.log(
              clc.green(`Write OperatingDeploymentInfo.json Succeeded.`)
            );
      }
    );
  } catch {
    console.error(clc.red("Write OperatingDeploymentInfo.json file failed."));
  }
}
