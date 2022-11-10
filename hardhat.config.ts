import "@nomicfoundation/hardhat-toolbox";
import { config as LoadEnv } from "dotenv";

LoadEnv();

const config = {
  defaultNetwork: "matic",
  solidity: "0.8.17",
  paths: { tests: "tests" },
  networks: {
    matic: {
      url: `https://rpc-mumbai.maticvigil.com/v1/${process.env.MATIC_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
      gas: 2100000,
      gasPrice: 8000000000,
    },
  },
};

export default config;
