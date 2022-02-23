// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract ShopContract {
    uint public status;

    constructor() {
        status = 1;
    }

    function open() public {
        status = 1;
    }

    function close() public {
        status = 0;
    }

    function get() public view returns(uint) {
        return status;
    }
}