// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract HouseContract {
    uint public num;
    constructor() {
        num = 0;
    }

    function add(uint n) public {
        num = num + n;
    }

    function get() public view returns(uint) {
        return num;
    }
}