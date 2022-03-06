// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ScoreContract {

    mapping (address => uint) private scores;

    address teacher;

    uint score;

    constructor() public {
        teacher = msg.sender;
    }
    
    function getUserScore(address student) public view returns (uint) {
        return scores[student];
    }
    
    modifier onlyOwner {
    if (msg.sender == teacher) {
            _;
        }
    }

    function setScore(uint new_score) public onlyOwner {
        score = new_score;
    }
}