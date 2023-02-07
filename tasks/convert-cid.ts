import { task } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import CID from "cids";

task("convert-cid", "Converts filecoin cid to fevm format.")
  .addParam("cid", "The piece CID of the data you want converted.")
  .setAction(async (taskArgs) => {
    const cid = taskArgs.cid;

    const cidHexRaw = new CID(cid).toString("base16").substring(1);
    const cidHex = "0x00" + cidHexRaw;
    console.log("Bytes are:", cidHex);
  });
