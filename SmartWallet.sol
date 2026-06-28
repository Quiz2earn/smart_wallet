// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract SmartWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
