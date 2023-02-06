import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

function getPK() {
  return (
    (process.env.PRIVATE_KEY as string) ||
    "96ab64cf18341198d2bd031d09bbe4e1787a05a0355184ac09ca23eabb28ebea"
  ); //exposed default account for testing only
}

const config: HardhatUserConfig = {
  networks: {
    wallaby: {
      url: "https://wallaby.node.glif.io/rpc/v0",
      chainId: 31415,
      accounts: [getPK()],
    },
    hyperspace: {
      chainId: 3141,
      url: "https://api.hyperspace.node.glif.io/rpc/v1",
      accounts: [getPK()],
      gasPrice: 50000000000,
      //1500000000
      //3500000000
      //50000000000
    },
    // hyperspace: {
    //   url: "https://api.hyperspace.node.glif.io/rpc/v1",
    //   chainId: 3141,
    //   accounts: [getPK()],
    // },
    bsc_testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      chainId: 97,
      accounts: [getPK()],
    },
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        // runs: 200,
      },
    },
  },
  typechain: {
    outDir: "src/types",
    target: "ethers-v5",
    alwaysGenerateOverloads: false, // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    externalArtifacts: ["externalArtifacts/*.json"], // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
    dontOverrideCompile: false, // defaults to false
  },
};

export default config;
