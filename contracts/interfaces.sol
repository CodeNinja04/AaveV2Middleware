//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.1;

interface IWETHGateway {
    function depositETH(
        address lendingPool,
        address onBehalfOf,
        uint16 referralCode
    ) external payable;

    function withdrawETH(
        address lendingPool,
        uint256 amount,
        address onBehalfOf
    ) external;

    function repayETH(
        address lendingPool,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external payable;

    function borrowETH(
        address lendingPool,
        uint256 amount,
        uint256 interesRateMode,
        uint16 referralCode
    ) external;

    function getWETHAddress() external returns (address);
}

interface Iweth {

  function transfer(address to, uint value) external returns (bool);

  function deposit() external payable;

  function withdraw(uint256) external;

  function approve(address guy, uint256 wad) external returns (bool);

  function transferFrom(
    address src,
    address dst,
    uint256 wad
  ) external returns (bool);
}

interface IStableDebtToken {

  event Mint(
    address indexed user,
    address indexed onBehalfOf,
    uint256 amount,
    uint256 currentBalance,
    uint256 balanceIncrease,
    uint256 newRate,
    uint256 avgStableRate,
    uint256 newTotalSupply
  );


  event Burn(
    address indexed user,
    uint256 amount,
    uint256 currentBalance,
    uint256 balanceIncrease,
    uint256 avgStableRate,
    uint256 newTotalSupply
  );
  

  function approveDelegation(address delegatee, uint256 amount) external;
  
 
  function borrowAllowance(address fromUser, address toUser) external view returns (uint256);

 
  function mint(
    address user,
    address onBehalfOf,
    uint256 amount,
    uint256 rate
  ) external returns (bool);


  function burn(address user, uint256 amount) external;


  function getAverageStableRate() external view returns (uint256);

 
  function getUserStableRate(address user) external view returns (uint256);

 
  function getUserLastUpdated(address user) external view returns (uint40);

 
  function getSupplyData()
    external
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint40
    );

 
  function getTotalSupplyLastUpdated() external view returns (uint40);

  function getTotalSupplyAndAvgRate() external view returns (uint256, uint256);

 
  function principalBalanceOf(address user) external view returns (uint256);
}


interface IScaledBalanceToken {

  function scaledBalanceOf(address user) external view returns (uint256);

 
  function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);

 
  function scaledTotalSupply() external view returns (uint256);
}



interface IVariableDebtToken is IScaledBalanceToken {

  event Mint(address indexed from, address indexed onBehalfOf, uint256 value, uint256 index);

 
 
  function approveDelegation(address delegatee, uint256 amount) external;
  
 
  function borrowAllowance(address fromUser, address toUser) external view returns (uint256);

  function mint(
    address user,
    address onBehalfOf,
    uint256 amount,
    uint256 index
  ) external returns (bool);

 
  event Burn(address indexed user, uint256 amount, uint256 index);

 
  function burn(
    address user,
    uint256 amount,
    uint256 index
  ) external;
}