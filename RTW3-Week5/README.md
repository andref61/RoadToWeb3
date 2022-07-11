# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```


RoadToWeb3 Week 5: Dynamic NFTsMinted NFT image will update based on price of ETH/USD.  Price feed provided by Chainlink AggregatorV3Interface.

Current ETH/USD price updated using Chaninlink Keepers to automate smart contract.

NFT images updated based on random number generated using Chainlink VRF function.

Smart contract address on Rinkeby testnet: 0x21E86C71120Bac755C1565f0B93B1C139Dc061b2