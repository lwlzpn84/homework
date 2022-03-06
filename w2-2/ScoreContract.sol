// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ScoreContract {

    mapping (address => uint) private scores;

    address teacher;

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

    function setScore(address student, uint new_score) public onlyOwner {
        if(msg.sender == teacher) {
            if(new_score >=0 && new_score <= 100) {
            scores[student] = new_score;
            }
        }
    }
}

interface SetScoreIntf {
    function setScore(address student, uint score) external;
}