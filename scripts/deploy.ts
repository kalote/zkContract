import { ethers } from "hardhat";
import * as dotenv from "dotenv";
import {
  ZkTwittNFT__factory,
  ZktTwittMain__factory,
  ZkTwitt__factory,
} from "../typechain-types";

dotenv.config();

const COST_PER_TWITT = 20;
const COST_PER_LIKE = 10;

async function main() {
  // let provider = ethers.getDefaultProvider("mumbai");
  // console.log(provider);
  // let wallet;
  // wallet = new ethers.Wallet(process.env.PRIVATE_KEY ?? "", provider);
  // console.log(`Using Signer address ${wallet.address}`);
  // let signer = wallet.connect(provider);
  let zktokenFactory = await ethers.getContractFactory("ZkTwitt");
  let zknftFactory = await ethers.getContractFactory("ZkTwittNFT");
  let zkmainFactory = await ethers.getContractFactory("ZkTwittMain");

  // const [deployer] = await ethers.getSigners();

  // console.log("Deploying contracts with the account: ", deployer.address);
  // console.log("Account balance: ", (await deployer.getBalance()).toString());

  const Token = await zktokenFactory.deploy();
  const token = await Token.deployed();
  console.log("Token address: ", token.address);

  const NFT = await zknftFactory.deploy();
  const nft = await NFT.deployed();
  console.log("NFT address: ", nft.address);

  const MainContract = await zkmainFactory.deploy(
    COST_PER_TWITT,
    COST_PER_LIKE,
    token.address,
    nft.address
  );
  const maincontract = await MainContract.deployed();
  console.log("Main contract address: ", maincontract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
