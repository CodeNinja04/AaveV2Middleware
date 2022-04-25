//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.1;
import {DataTypes} from "./helpers.sol";
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
    function transfer(address to, uint256 value) external returns (bool);

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

    function borrowAllowance(address fromUser, address toUser)
        external
        view
        returns (uint256);

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

    function getTotalSupplyAndAvgRate()
        external
        view
        returns (uint256, uint256);

    function principalBalanceOf(address user) external view returns (uint256);
}

interface IScaledBalanceToken {
    function scaledBalanceOf(address user) external view returns (uint256);

    function getScaledUserBalanceAndSupply(address user)
        external
        view
        returns (uint256, uint256);

    function scaledTotalSupply() external view returns (uint256);
}

interface IVariableDebtToken is IScaledBalanceToken {
    event Mint(
        address indexed from,
        address indexed onBehalfOf,
        uint256 value,
        uint256 index
    );

    function approveDelegation(address delegatee, uint256 amount) external;

    function borrowAllowance(address fromUser, address toUser)
        external
        view
        returns (uint256);

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

interface ILendingPoolAddressesProvider {
    event MarketIdSet(string newMarketId);
    event LendingPoolUpdated(address indexed newAddress);
    event ConfigurationAdminUpdated(address indexed newAddress);
    event EmergencyAdminUpdated(address indexed newAddress);
    event LendingPoolConfiguratorUpdated(address indexed newAddress);
    event LendingPoolCollateralManagerUpdated(address indexed newAddress);
    event PriceOracleUpdated(address indexed newAddress);
    event LendingRateOracleUpdated(address indexed newAddress);
    event ProxyCreated(bytes32 id, address indexed newAddress);
    event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);

    function getMarketId() external view returns (string memory);

    function setMarketId(string calldata marketId) external;

    function setAddress(bytes32 id, address newAddress) external;

    function setAddressAsProxy(bytes32 id, address impl) external;

    function getAddress(bytes32 id) external view returns (address);

    function getLendingPool() external view returns (address);

    function setLendingPoolImpl(address pool) external;

    function getLendingPoolConfigurator() external view returns (address);

    function setLendingPoolConfiguratorImpl(address configurator) external;

    function getLendingPoolCollateralManager() external view returns (address);

    function setLendingPoolCollateralManager(address manager) external;

    function getPoolAdmin() external view returns (address);

    function setPoolAdmin(address admin) external;

    function getEmergencyAdmin() external view returns (address);

    function setEmergencyAdmin(address admin) external;

    function getPriceOracle() external view returns (address);

    function setPriceOracle(address priceOracle) external;

    function getLendingRateOracle() external view returns (address);

    function setLendingRateOracle(address lendingRateOracle) external;
}


interface ILendingPool {
 
    event Deposit(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        uint16 indexed referral
    );

   
    event Withdraw(
        address indexed reserve,
        address indexed user,
        address indexed to,
        uint256 amount
    );

  
    event Borrow(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        uint256 borrowRateMode,
        uint256 borrowRate,
        uint16 indexed referral
    );

  
    event Repay(
        address indexed reserve,
        address indexed user,
        address indexed repayer,
        uint256 amount
    );

   
    event Swap(address indexed reserve, address indexed user, uint256 rateMode);

   
    event ReserveUsedAsCollateralEnabled(
        address indexed reserve,
        address indexed user
    );

  
    event ReserveUsedAsCollateralDisabled(
        address indexed reserve,
        address indexed user
    );

   
    event RebalanceStableBorrowRate(
        address indexed reserve,
        address indexed user
    );

  
    event FlashLoan(
        address indexed target,
        address indexed initiator,
        address indexed asset,
        uint256 amount,
        uint256 premium,
        uint16 referralCode
    );

   
    event Paused();

   
    event Unpaused();

    
    event LiquidationCall(
        address indexed collateralAsset,
        address indexed debtAsset,
        address indexed user,
        uint256 debtToCover,
        uint256 liquidatedCollateralAmount,
        address liquidator,
        bool receiveAToken
    );

    event ReserveDataUpdated(
        address indexed reserve,
        uint256 liquidityRate,
        uint256 stableBorrowRate,
        uint256 variableBorrowRate,
        uint256 liquidityIndex,
        uint256 variableBorrowIndex
    );

    
    function deposit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;

   
    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns (uint256);

  
    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external;

    
    function repay(
        address asset,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external returns (uint256);

  
    function swapBorrowRateMode(address asset, uint256 rateMode) external;

   
    function rebalanceStableBorrowRate(address asset, address user) external;

  
    function setUserUseReserveAsCollateral(address asset, bool useAsCollateral)
        external;

    
    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;

  
    function getUserAccountData(address user)
        external
        view
        returns (
            uint256 totalCollateralETH,
            uint256 totalDebtETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        );

    function initReserve(
        address reserve,
        address aTokenAddress,
        address stableDebtAddress,
        address variableDebtAddress,
        address interestRateStrategyAddress
    ) external;

    function setReserveInterestRateStrategyAddress(
        address reserve,
        address rateStrategyAddress
    ) external;

    function setConfiguration(address reserve, uint256 configuration) external;

    function getConfiguration(address asset)
        external
        view
        returns (DataTypes.ReserveConfigurationMap memory);

   
    function getUserConfiguration(address user)
        external
        view
        returns (DataTypes.UserConfigurationMap memory);

   
    function getReserveNormalizedIncome(address asset)
        external
        view
        returns (uint256);

    
    function getReserveNormalizedVariableDebt(address asset)
        external
        view
        returns (uint256);

  
    function getReserveData(address asset)
        external
        view
        returns (DataTypes.ReserveData memory);

    function finalizeTransfer(
        address asset,
        address from,
        address to,
        uint256 amount,
        uint256 balanceFromAfter,
        uint256 balanceToBefore
    ) external;

    function getReservesList() external view returns (address[] memory);

    function getAddressesProvider()
        external
        view
        returns (ILendingPoolAddressesProvider);

    function setPause(bool val) external;

    function paused() external view returns (bool);
}
