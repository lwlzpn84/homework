// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract BankContract {
    uint8 private clientCount;
    mapping (address => uint) private balances;
    address public owner;


    constructor() public payable {
        require(msg.value == 30 ether, "30 ether initial");
        
        owner = msg.sender;
        clientCount = 0;
    }

    function deposit() public payable returns (uint) {
        balances[msg.sender] += msg.value;
        return balances[msg.sender];
    }

    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        
        if (withdrawAmount <= balances[msg.sender]) {
            balances[msg.sender] -= withdrawAmount;
            msg.sender.transfer(withdrawAmount);
        }
        return balances[msg.sender];
    }

    function balance() public view returns (uint) {
        return balances[msg.sender];
    }

    function depositsBalance() public view returns (uint) {
        return address(this).balance;
    }
}
