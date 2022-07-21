// SPDX-License-Identifier:MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/ILendingPoolAddressesProvider.sol";
import "./interface/ILendingPool.sol";

contract Lending{
    ILendingPoolAddressesProvider public provider;
    ILendingPool public lendingPool;
    address aWETH = 0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347;
    address aDAI = 0xdCf0aF9e59C002FA3AA091a46196b37530FD48a8;
    address IWETHAddress = 0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70;

    event LendingPool(ILendingPool lendingPoolAddress);

    constructor() {
        provider = ILendingPoolAddressesProvider(0x88757f2f99175387aB4C6a4b3067c77A695b0349);
        lendingPool = ILendingPool(provider.getLendingPool());
        emit LendingPool(lendingPool);
    }

    function deposit(address token, uint amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        IERC20(token).approve(address(lendingPool), amount);
        lendingPool.deposit(token, amount, address(this), 0);
    }

    function totalFunds() external view returns (uint256) {
        return IERC20(aWETH).balanceOf(address(this));
    }

    function withdraw(address token, uint amount) public {
        IERC20(aWETH).approve(IWETHAddress, amount);
        lendingPool.withdraw(token, amount, msg.sender);
    }
}