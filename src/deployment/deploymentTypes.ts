import { utils, providers, Contract } from "ethers";
import { JsonFragment } from "@ethersproject/abi";

export type SavedDeploymentInfo = {
  networkId: number;
  contractABI: string | readonly (string | utils.Fragment | JsonFragment)[];
  contractAddress: string;
};

export type FormatedDeploymentInfo = {
  [key: string]: {
    [key: number]: SavedDeploymentInfo;
  };
};
