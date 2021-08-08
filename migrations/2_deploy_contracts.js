var MarketPlace = artifacts.require("./MarketPlace.sol");
var WWToken = artifacts.require("./WWToken.sol");
var WWNFTToken = artifacts.require("./WWNFTToken.sol");

module.exports = async function(deployer) {
  let addr = await web3.eth.getAccounts();

  await deployer.deploy(WWToken);
  let WWTokenInstance = await WWToken.deployed();
  
  await deployer.deploy(WWNFTToken);
  let WWNFTTokenInstance = await WWNFTToken.deployed();
  
  await deployer.deploy(MarketPlace, WWTokenInstance.address, WWNFTTokenInstance.address);
};
