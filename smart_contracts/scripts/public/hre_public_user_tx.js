const path = require('path');
const fs = require('fs-extra');
var ethers = require('ethers');

// RPCNODE details
const { tessera, besu } = require("../keys.js");
const host = besu.rpcnode.url;
const accountPrivateKey = besu.rpcnode.accountPrivateKey;

// abi and bytecode generated from UserRegistration.sol:
const contractJsonPath = path.resolve(__dirname, '../../','contracts','UserRegistration.json');
const contractJson = JSON.parse(fs.readFileSync(contractJsonPath));
const contractAbi = contractJson.abi;
const contractBytecode = contractJson.evm.bytecode.object

async function createContract(provider, wallet, contractAbi, contractByteCode) {
    const factory = new ethers.ContractFactory(contractAbi, contractByteCode, wallet);
    const contract = await factory.deploy();
    // The contract is NOT deployed yet; we must wait until it is mined
    const deployed = await contract.waitForDeployment();
    //The contract is deployed now
    return contract
};

async function main(){
    const provider = new ethers.JsonRpcProvider(host);
    const wallet = new ethers.Wallet(accountPrivateKey, provider);
  
    createContract(provider, wallet, contractAbi, contractBytecode)
    .then(async function(contract){
      contractAddress = await contract.getAddress();
      console.log("UserRegistration Contract deployed at address: " + contractAddress);
    })
    .catch(console.error);
  
}

if (require.main === module) {
    main();
}

module.exports = exports = main