
const { ethers } = require("hardhat");
const { network } = require("hardhat");

describe("AaveV2", function () {

    const Usdc = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48" // usdc contract address
    const acc = ethers.utils.getAddress("0xe63fEd8d441Ee8128eAA583549dcB60DF4F4F109")
    var UsdcContract;
    let signer;
    var Aave;
    var ContractAddress;
    const abi = [
        "function balanceOf(address) view returns (uint)",

        "function approve(address to, uint amount)", 
    ];
    beforeEach(async () => {

        await hre.network.provider.request({
            method: "hardhat_impersonateAccount",
            params: [acc],
        });

        signer = await ethers.getSigner(acc);
        //console.log(signer);
        UsdcContract = new ethers.Contract(Usdc, abi, signer);
        console.log("its working")
    });


 

    it("Contract Deployed", async function () {
        Aave = await ethers.getContractFactory("AaveV2");
        AaveContract = await Aave.deploy();
        await AaveContract.deployed();
        deployedContractAddress = AaveContract.address;
        console.log(
            "Deployed sucessfully",
            ContractAddress
        );
    });

    it("Deposit USDC", async function () {
       
       
        var bali = await UsdcContract.balanceOf(acc);
        console.log("initial : ",bali)
        let approval = await UsdcContract.connect(signer).approve(
            deployedContractAddress,
            100
        );
        
        var dep = await AaveContract
            .connect(signer)
            .deposit(100, Usdc);
       
        //console.log(dep)

        var balf = await UsdcContract.balanceOf(acc);
        console.log("final :",balf)
    });

    it("withdraw USDC", async function () {
        
        
        var bali = await UsdcContract.balanceOf(acc);
        console.log("initial:",bali)
      
    
        var dep = await AaveContract
            .connect(signer)
            .withdraw(1, Usdc);

        //console.log(dep)

        var balf = await UsdcContract.balanceOf(acc);
        console.log("final:",balf)
    });

    it("borrow USDC", async function () {


        var bali = await UsdcContract.balanceOf(acc);
        console.log(bali)
        
        
        var dep = await AaveContract
            .connect(signer)
            .borrow(1, Usdc);

        //console.log(dep)

        var balf = await UsdcContract.balanceOf(acc);
        console.log(balf)
    });

    it("repay USDC", async function () {


        var bali = await UsdcContract.balanceOf(acc);
        console.log(bali)
        let approval = await UsdcContract.connect(signer).approve(
            deployedContractAddress,
            1
        );
        //console.log(approval)
        var dep = await AaveContract
            .connect(signer)
            .repay(1, Usdc);

        //console.log(dep)

        var balf = await UsdcContract.balanceOf(acc);
        console.log(balf)
    });





        

    });

