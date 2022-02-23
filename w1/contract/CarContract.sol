// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.9;

contract CarContract {
    uint public price;

    constructor () {
        price = 100;
    }

    function get() public view returns(uint) {
        return price;
    }

    function set(uint p) public {
        price = p;
    }
}