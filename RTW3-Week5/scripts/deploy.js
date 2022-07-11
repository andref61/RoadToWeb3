const main = async () => {
    try {
      const nftContractFactory = await hre.ethers.getContractFactory(
        "BearsBulls"
      );
      const nftContract = await nftContractFactory.deploy(10, 7920);
      await nftContract.deployed();
  
      console.log("Contract deployed to:", nftContract.address);
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
    
  main();