//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ILendingPool} from "./ILendingPool.sol";
import {ILendingPoolAddressesProvider} from "./ILendingPoolAddressesProvider.sol";

import "./interfaces.sol";

contract AaveV2 {
    using SafeERC20 for IERC20;

    
    address LendingPoolAddressProvider = address(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5);
    address public  PoolAddress= ILendingPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
    address wethGatewayAddress =address(0xcc9a0B7c43DC2a5F023Bb9b738E45B0Ef6B06E04); 
    address wethAddress = IWETHGateway(wethGatewayAddress).getWETHAddress();                  
    address aWethAddress = 0x030bA81f1c18d280636F32af80b9AAd02Cf0854e; 

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
    wethGateway.depositETH{ value: msg.value }(
      PoolAddress,
      address(this),
      0
    );
    
  }

  function withdrawEth(uint256 amount) external {
    
    IWETHGateway wethGateway = IWETHGateway(wethGatewayAddress);
    
    IERC20 token = IERC20(aWethAddress);
    token.safeApprove(wethGatewayAddress, amount);
    wethGateway.withdrawETH(PoolAddress, amount, msg.sender);
  }


 


}
