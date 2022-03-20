//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyTokenSwapPool is ERC20 {

    address public tokenA;
    address public tokenB;

    uint public reserveA;
    uint public reserveB;

    uint public constant INITIAL_SUPPLY = 10**6;

    constructor(address _tokenA, address _tokenB) ERC20("LooneyLiquidityProvider", "LP") {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }


    function add(uint amountA, uint amountB) public {
        assert(IERC20(tokenA).transferFrom(msg.sender, address(this), amountA));
        assert(IERC20(tokenB).transferFrom(msg.sender, address(this), amountB));

        uint reserveAAfter = reserveA + amountA;
        uint reserveBAfter = reserveB + amountB;

        if (reserveA == 0 && reserveB == 0) {
            _mint(msg.sender, INITIAL_SUPPLY);
        } else {
            uint currentSupply = totalSupply();
            uint newSupplyGivenReserveARatio = reserveAAfter * currentSupply / reserveA;
            uint newSupplyGivenReserveBRatio = reserveBAfter * currentSupply / reserveB;
            uint newSupply = Math.min(newSupplyGivenReserveARatio, newSupplyGivenReserveBRatio);
            _mint(msg.sender, newSupply - currentSupply);
        }

        reserveA = reserveAAfter;
        reserveB = reserveBAfter;
    }

    
    function remove(uint liquidity) public {
        assert(transfer(address(this), liquidity));

        uint currentSupply = totalSupply();
        uint amountA = liquidity * reserveA / currentSupply;
        uint amountB = liquidity * reserveB / currentSupply;

        _burn(address(this), liquidity);

        assert(IERC20(tokenA).transfer(msg.sender, amountA));
        assert(IERC20(tokenB).transfer(msg.sender, amountB));
        reserveA = reserveA - amountA;
        reserveB = reserveB - amountB;
    }


    function getAmountOut (uint amountIn, address fromToken) public view returns (uint amountOut, uint _reserveA, uint _reserveB) {
        uint newReserveA;
        uint newReserveB;
        uint k = reserveA * reserveB;

        if (fromToken == tokenA) {
            newReserveA = amountIn + reserveA;
            newReserveB = k / newReserveB;
            amountOut = reserveB - newReserveB;
        } else {
            newReserveB = amountIn + reserveB;
            newReserveA = k / newReserveB;
            amountOut = reserveA - newReserveA;
        }

        _reserveA = newReserveA;
        _reserveB = newReserveB;
    }

 
    function swap(uint amountIn, uint minAmountOut, address fromToken, address toToken, address to) public {
        require(amountIn > 0 && minAmountOut > 0, 'Amount invalid');
        require(fromToken == tokenA || fromToken == tokenB, 'From token invalid');
        require(toToken == tokenA || toToken == tokenB, 'To token invalid');
        require(fromToken != toToken, 'From and to tokens should not match');

        (uint amountOut, uint newReserveA, uint newReserveB) = getAmountOut(amountIn, fromToken);

        require(amountOut >= minAmountOut, 'Slipped... on a banana');

        assert(IERC20(fromToken).transferFrom(msg.sender, address(this), amountIn));
        assert(IERC20(toToken).transfer(to, amountOut));

        reserveA = newReserveA;
        reserveB = newReserveB;
    }
}