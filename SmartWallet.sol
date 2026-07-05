// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract SmartWallet {
    address public owner;

    constructor() {
       owner = msg.sender;

       emit OwnershipTransferred(address(0), owner);

        event Deposit(address indexed sender, uint256 amount);


        function withdraw(uint256 amount) external {

            require(msg.sender == owner, "Not owner");
        
            payable(owner).transfer(amount);
        
            emit Withdraw(owner, amount);


        event OwnershipTransferred(
            address indexed previousOwner,
            address indexed newOwner);
        }
}

    receive() external payable {
    emit Deposit(msg.sender, msg.value);
}

    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    function getOwner() external view returns (address) {
    return owner;
    }
}
