import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Sign } from "crypto";
import { BigNumber, ContractReceipt } from "ethers";
import { closeSync } from "fs";
import { ethers } from "hardhat";
import { ZktTwittMain, ZkTwitt, ZkTwittNFT } from "../typechain-types";

const AMOUNT_TOKEN = 20; 
const COST_PER_LIKE = 1;
const COST_PER_TWEET = 10;


describe("Twitt Main", () => {

  let twittMain: ZktTwittMain;
  let erc20Token: ZkTwitt;
  let erc721Token: ZkTwittNFT;
  let deployer: SignerWithAddress;
  let account1: SignerWithAddress;
  let account2: SignerWithAddress;

  beforeEach(async () => {

    const erc20TokenFactory = await ethers.getContractFactory("ZkTwitt");
    erc20Token = await erc20TokenFactory.deploy();
    await erc20Token.deployed();

    const erc721TokenFactory = await ethers.getContractFactory("ZkTwittNFT");
    erc721Token = await erc721TokenFactory.deploy();
    await erc721Token.deployed();

    const twittMainFactory = await ethers.getContractFactory("ZktTwittMain");
    twittMain = await twittMainFactory.deploy(COST_PER_TWEET, COST_PER_LIKE, erc20Token.address, erc721Token.address);
    await twittMain.deployed();

    [deployer, account1, account2] = await ethers.getSigners();
   
  });


  async function mintToken(address : string, amount: number) {
    const tx = await erc20Token.mint(address, amount);
    tx.wait();
  }

  async function checkBalance(address: string, expectedAmt: number){
    const balanceTx = await erc20Token.balanceOf(address);
    expect(balanceTx).to.be.equal(expectedAmt);
  }

  async function approveTx(from: SignerWithAddress, to: string, amount: number){
    console.log(`approve tx from ${from.address} to ${to} for the amount ${amount}`);
    const approveTx = await erc20Token.connect(from).approve(to, amount);
    approveTx.wait();
  }

  async function tweet(account: SignerWithAddress, tokenId: number) {
    const tweetTx = await twittMain.connect(account).tweet(tokenId);
    tweetTx.wait();
  }

  describe("When a user mints ERC20 token", () => {
    
    it("must receive token", async () => {
      mintToken(account1.address, AMOUNT_TOKEN);
      checkBalance(account1.address, AMOUNT_TOKEN);
    });

  });

  describe("When a user tweets", () => {
    it("must have enough balance", async () => {
      const tx = twittMain.connect(account2).tweet(1);
      await expect(tx).to.be.revertedWith("not enough balance to pay for tweet");
    });

    it("when a user successfully tweets", async () => {
      const TOKEN_ID = 1;
      
      mintToken(account2.address, AMOUNT_TOKEN);
      approveTx(account2, twittMain.address, AMOUNT_TOKEN);

      await tweet(account2, TOKEN_ID);

      checkBalance(account2.address, 0);
      expect(await erc721Token.ownerOf(TOKEN_ID)).to.be.equals(account2.address);
    });

  });


  describe("When a user likes a tweet", () => {
    it("must have enough balance", async () => {
      const tx = twittMain.like(1);
      expect(tx).to.be.revertedWith("not enough balance to pay for like");
    });

    it("when a user successfully likes a tweet", async () => {
        const TOKEN_ID = 2;
        mintToken(account1.address, AMOUNT_TOKEN);
        approveTx(account1, twittMain.address, AMOUNT_TOKEN);
        tweet(account1, TOKEN_ID);


        const likeTx = await twittMain.connect(account1).like(TOKEN_ID);
        likeTx.wait();

        const nbLikes = await twittMain.nbLike(TOKEN_ID);
        expect(nbLikes).to.be.equals(1);
    });
    
  });


});