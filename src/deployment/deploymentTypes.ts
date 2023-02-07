import { utils, providers, Contract } from "ethers";
import { JsonFragment } from "@ethersproject/abi";

export type SavedDeploymentInfoOnlyABI =
  | string
  | readonly (string | utils.Fragment | JsonFragment)[];
export type SavedDeploymentInfo = {
  networkId: number;
  contractABI: string | readonly (string | utils.Fragment | JsonFragment)[];
  contractAddress: string;
};

export type FormatedDeploymentInfo = {
  [key: string]: {
    [key: number | string]: SavedDeploymentInfo | SavedDeploymentInfoOnlyABI;
  };
};
