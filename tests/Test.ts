import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Sign } from "crypto";
import { BigNumber, ContractReceipt } from "ethers";
import { closeSync } from "fs";
import { ethers } from "hardhat";
import { ZktTwittMain, ZkTwitt } from "../typechain-types";

const TOKEN_RATIO = 5; 
const COST_PER_LIKE = 1;

describe("Twitt Main", () => {

  let twittMain: ZktTwittMain;
  let erc20Token: ZkTwitt;
  let deployer: SignerWithAddress;
  let account1: SignerWithAddress;

  beforeEach(async () => {

    const erc20TokenFactory = await ethers.getContractFactory("ZkTwitt");
    erc20Token = await erc20TokenFactory.deploy();
    await erc20Token._deployed();

    const twittMainFactory = await ethers.getContractFactory("ZktTwittMain");
    twittMain = await twittMainFactory.deploy(COST_PER_LIKE, erc20Token.address);
    await twittMain.deployed();

    [deployer, account1] = await ethers.getSigners();

  });

  describe("When a user likes a tweet", () => {
    it("must have enough balance", async () => {
      const tx = await twittMain.like(1);
      expect(tx).to.be.revertedWith("not enough balance to pay for like");
    });

    it("when a user successfully likes a tweet", async () => {
        const TOKEN_ID = 2;
        const tx = await erc20Token.mint(account1.address, 20);
        tx.wait();

        const likeTx = await twittMain.connect(account1).like(TOKEN_ID);
        likeTx.wait();

        const nbLikes = await twittMain.nbLike(TOKEN_ID);
        expect(nbLikes).to.be.equals(1);
    });
    
  });


});