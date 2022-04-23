//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.1;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// import {ILendingPool} from "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";
// import {ILendingPoolAddressesProvider} from "@aave/protocol-v2/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import {ILendingPool} from "./ILendingPool.sol";
import {ILendingPoolAddressesProvider} from "./ILendingPoolAddressesProvider.sol";

contract AaveV2 {
    using SafeERC20 for IERC20;
    address LendingPoolAddressProvider = address(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5);
    address public  PoolAddress= ILendingPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();


   function deposit(uint256 amount, address tokenAddr) external {
    IERC20 token = IERC20(tokenAddr);
    address LendingPoolAddress = PoolAddress;
    ILendingPool LendingPool = ILendingPool(LendingPoolAddress);

    token.safeTransferFrom(msg.sender, address(this), amount); 

    token.safeApprove(LendingPoolAddress, amount);
    LendingPool.deposit(tokenAddr, amount, address(this), 0); 
  }

  function withdraw(uint256 amount, address tokenAddr) external {
    ILendingPool LendingPool = ILendingPool(address(PoolAddress));
    LendingPool.withdraw(tokenAddr, amount, msg.sender); 
  }

  function borrow(uint256 amount, address tokenAddr) external {
    IERC20 token = IERC20(tokenAddr);
    address LendingPoolAddress = PoolAddress;
    ILendingPool LendingPool = ILendingPool(LendingPoolAddress);
    LendingPool.borrow(tokenAddr, amount, 2, 0, address(this)); 
    token.safeTransfer(msg.sender, amount); 
  }

  function repay(uint256 amount, address tokenAddr) external {
    IERC20 token = IERC20(tokenAddr);
    address LendingPoolAddress = PoolAddress;
    ILendingPool LendingPool = ILendingPool(LendingPoolAddress);
    token.safeTransferFrom(msg.sender, address(this), amount); 
    token.safeApprove(LendingPoolAddress, amount);
    LendingPool.repay(tokenAddr, amount, 2, address(this)); 
  }
}
