// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRouter.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MyTokenMarket {
    using SafeERC20 for IERC20;

    address public vToken;
    address public vRouter;
    address public vWeth;

    constructor(address _token, address _router, address _weth) {
        vToken = _token;
        vRouter = _router;
        vWeth = _weth;
    }

    //增加流动性函数
    function AddLiquidity(uint amount) public payable {
        IERC20(vToken).safeTransferFrom(msg.sender, address(this),amount);
        IERC20(vToken).safeApprove(vRouter, amount);


        IRouter(vRouter).addLiquidityETH{value: msg.value}(vToken, amount, 0, 0, msg.sender, block.timestamp);

    }

    // 用 ETH 购买 Token
    function buyToken(uint amount) public payable {
        address[] memory path = new address[](2);
        path[0] = vWeth;
        path[1] = vToken;

        IRouter(vRouter).swapExactETHForTokens{value : msg.value}(amount, path, msg.sender, block.timestamp);
    }


}