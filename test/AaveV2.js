
const { ethers } = require("hardhat");
const { network } = require("hardhat");

describe("AaveV2", function () {

    const Usdc = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48" // usdc contract address
    const acc = ethers.utils.getAddress("0xe63fEd8d441Ee8128eAA583549dcB60DF4F4F109")
    const aweth = "0x030bA81f1c18d280636F32af80b9AAd02Cf0854e"
    const ausdc = "0xBcca60bB61934080951369a648Fb03DF4F96263C"
    var UsdcContract;
    var AwethContract;
    var AusdcContract;
    var signer;
    var Aave;

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
        AwethContract = new ethers.Contract(aweth, abi, signer);
        AusdcContract = new ethers.Contract(ausdc, abi, signer);
        console.log("its working")
    });




    it("Contract Deployed", async function () {
        Aave = await ethers.getContractFactory("AaveV2");
        AaveContract = await Aave.deploy();
        await AaveContract.deployed();
        deployedContractAddress = AaveContract.address;
        console.log(
            "Deployed sucessfully",
            deployedContractAddress
        );
    });

    xit("Deposit USDC", async function () {


        var bali = await UsdcContract.balanceOf(acc);
        console.log("initial : ", bali)
        let approval = await UsdcContract.connect(signer).approve(
            deployedContractAddress,
            100
        );

        var dep = await AaveContract
            .connect(signer)
            .deposit(100, Usdc);

        //console.log(dep)

        var balf = await UsdcContract.balanceOf(acc);
        console.log("final :", balf)
    });

    xit("withdraw USDC", async function () {


        var bali = await UsdcContract.balanceOf(acc);
        console.log("initial:", bali)


        var dep = await AaveContract
            .connect(signer)
            .withdraw(1, Usdc);

        //console.log(dep)

        var balf = await UsdcContract.balanceOf(acc);
        console.log("final:", balf)
    });

    xit("borrow USDC", async function () {


        var bali = await UsdcContract.balanceOf(acc);
        console.log(bali)


        var dep = await AaveContract
            .connect(signer)
            .borrow(1, Usdc);

        //console.log(dep)

        var balf = await UsdcContract.balanceOf(acc);
        console.log(balf)
    });

    xit("repay USDC", async function () {


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





    it("Deposit ETH", async function () {

        console.log("eth:", await signer.getBalance());
        var bali = await AwethContract.balanceOf(deployedContractAddress);
        console.log("inital : ", bali);


        var dep = await AaveContract.connect(signer).depositEth({
            value: ethers.utils.parseEther("5"),
        });

        console.log("eth Balance", await signer.getBalance());
        balf = await AwethContract.balanceOf(deployedContractAddress);
        console.log("final", balf);


    });


    xit("Withdraw ETH", async function () {

        console.log("eth:", await signer.getBalance());
        var bali = await AwethContract.balanceOf(deployedContractAddress);
        console.log("inital : ", bali);


        var dep = await AaveContract.connect(signer).withdrawEth(
            ethers.utils.parseEther("1")
        );

        console.log("eth Balance", await signer.getBalance());
        balf = await AwethContract.balanceOf(deployedContractAddress);
        console.log("final", balf);


    });

  

})
