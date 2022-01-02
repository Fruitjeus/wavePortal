const main = async () => {
  // commands with npx hardhat will build hre object on the fly
  const [owner, randomPerson] = await hre.ethers.getSigners(); // get wallet addresses
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal"); // Compile to artefacts dir. HRE is in scope cause we are using hardhat
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  }); // Create local Eth network with contract. When script ends, destroy network

  await waveContract.deployed(); // Wait for deployment before proceeding

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveCount;
  waveCount = await waveContract.getTotalWaves();

  // owner wave
  let waveTxn = await waveContract.wave("Owner Wave 1");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  // owner wave again
  waveTxn = await waveContract.wave("Owner Wave 2");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  // random person wave
  waveTxn = await waveContract.connect(randomPerson).wave("Random Wave 1");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves()

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();