//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
//import {ILendingPool} from "./ILendingPool.sol";
//import {ILendingPoolAddressesProvider} from "./ILendingPoolAddressesProvider.sol";

import "./interfaces.sol";

contract AaveV2 {
    using SafeERC20 for IERC20;

    address LendingPoolAddressProvider =
        address(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5);
    address public PoolAddress =
        ILendingPoolAddressesProvider(LendingPoolAddressProvider)
            .getLendingPool();
    address wethGatewayAddress =
        address(0xcc9a0B7c43DC2a5F023Bb9b738E45B0Ef6B06E04);
    address wethAddress = IWETHGateway(wethGatewayAddress).getWETHAddress();
    address aWethAddress = address(0x030bA81f1c18d280636F32af80b9AAd02Cf0854e);
    address wethstabledebt =
        address(0x4e977830ba4bd783C0BB7F15d3e243f73FF57121);
    address wethvariabledebt =
        address(0xF63B34710400CAd3e044cFfDcAb00a0f32E33eCf);

    function deposit(uint256 amount, address tokenAddr) external {
        IERC20 token = IERC20(tokenAddr);

        ILendingPool LendingPool = ILendingPool(PoolAddress);

        token.safeTransferFrom(msg.sender, address(this), amount);

        token.safeApprove(PoolAddress, amount);
        LendingPool.deposit(tokenAddr, amount, address(this), 0);
    }

    function withdraw(uint256 amount, address tokenAddr) external {
        ILendingPool LendingPool = ILendingPool(address(PoolAddress));
        LendingPool.withdraw(tokenAddr, amount, msg.sender);
    }

    function borrow(uint256 amount, address tokenAddr) external {
        IERC20 token = IERC20(tokenAddr);

        ILendingPool LendingPool = ILendingPool(PoolAddress);
        LendingPool.borrow(tokenAddr, amount, 2, 0, address(this));
        token.safeTransfer(msg.sender, amount);
    }

    function repay(uint256 amount, address tokenAddr) external {
        IERC20 token = IERC20(tokenAddr);

        ILendingPool LendingPool = ILendingPool(PoolAddress);
        token.safeTransferFrom(msg.sender, address(this), amount);
        token.safeApprove(PoolAddress, amount);
        LendingPool.repay(tokenAddr, amount, 2, address(this));
    }

    function depositEth() external payable {
        IWETHGateway wethGateway = IWETHGateway(wethGatewayAddress);
        wethGateway.depositETH{value: msg.value}(PoolAddress, address(this), 0);
    }

    function withdrawEth(uint256 amount) external {
        IWETHGateway wethGateway = IWETHGateway(wethGatewayAddress);

        IERC20 token = IERC20(aWethAddress);
        token.safeApprove(wethGatewayAddress, amount);
        wethGateway.withdrawETH(PoolAddress, amount, msg.sender);
    }

    function borrowEth(uint256 amount)  external payable {
        // IStableDebtToken stabledebt = IStableDebtToken(wethstabledebt);
        // stabledebt.approveDelegation(wethGatewayAddress,amount);

        IVariableDebtToken variabledebt = IVariableDebtToken(wethvariabledebt);
        variabledebt.approveDelegation(wethGatewayAddress, amount);

        IWETHGateway wethGateway = IWETHGateway(wethGatewayAddress);
        wethGateway.borrowETH(PoolAddress, amount, 2, 0);
        payable(msg.sender).transfer(address(this).balance);
    }

        function repayEth() external payable {
        IWETHGateway wethGateway = IWETHGateway(wethGatewayAddress);
        wethGateway.repayETH{value: msg.value}(PoolAddress,msg.value,2,address(this));
    }

     receive() external payable {
        
    }

    fallback() external payable {

    }

   

}
