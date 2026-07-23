// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error NotOwner();
error InvalidAddress();
error ContractPaused();
error InsufficientBalance();
error WithdrawalLimitExceeded();

contract SmartWallet
{
    address public owner;

    bool public paused;

    uint256 public withdrawalLimit;

    event Deposit(address indexed sender, uint256 amount);

    function pause() external 
    {
    if (msg.sender != owner) revert NotOwner();

    paused = true;

    emit Paused(msg.sender);

    Withdrawal[] private withdrawals;
    }

    function unpause() external 
    {
    if (msg.sender != owner) revert NotOwner();

    paused = false;

    emit Unpaused(msg.sender);
    }

    function withdraw(uint256 amount) external 
    {
        if (msg.sender != owner) revert 
    NotOwner();

        if (paused) revert ContractPaused();

    payable(owner).transfer(amount);

    emit Withdraw(owner, amount);
    }

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner);

    event Paused(address indexed account);
    event Unpaused(address indexed account);

    struct Withdrawal
    {
    uint256 amount;
    uint256 timestamp;
    }

    constructor() 
    {
        owner = msg.sender;

        withdrawalLimit = 10 ether;

        emit OwnershipTransferred(address(0), owner);
    }

    receive() external payable
    {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external
    {
        if (msg.sender != owner) revert NotOwner();

        if (address(this).balance < amount) 
        {
            revert InsufficientBalance();
        }

        if (address(this).balance < amount) 
        {
            revert InsufficientBalance();
        }

        payable(owner).transfer(amount);

        emit Withdraw(owner, amount);

        withdrawals.push(
            Withdrawal({
            amount: amount,
            timestamp: block.timestamp
            })
        );
    }

    function transferOwnership(address newOwner) external 
    {
        if (msg.sender != owner) revert NotOwner();
        if (newOwner == address(0)) revert InvalidAddress();

        address oldOwner = owner;
        owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function getBalance() external view returns (uint256) 
    {
        return address(this).balance;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function getWithdrawalCount() external view returns (uint256)
        {
        return withdrawals.length;
        }

    function getWithdrawal(uint256 index)
        external
        view
        returns (uint256 amount, uint256 timestamp)
        {
        Withdrawal memory record = withdrawals[index];
    
        return (record.amount, record.timestamp);
        }
}
