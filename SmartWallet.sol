// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error NotOwner();
error AlreadyPaused();
error InvalidAddress();
error ContractPaused();
error NotWhitelisted();
error AlreadyUnpaused();
error InsufficientBalance();
error WithdrawalBelowMinimum();
error WithdrawalLimitExceeded();



contract SmartWallet
{
    address public owner;

    bool public paused;

    mapping(address => bool) public whitelist;

    uint256 public whitelistCount;

    uint256 public totalDeposits;

    uint256 public withdrawalLimit;

    uint256 public minimumWithdrawal;

    uint256 public lastWithdrawalTime;

    event Deposit(address indexed sender, uint256 amount);

    event DepositCountUpdated(uint256 totalDeposits);

    event WithdrawalTimeUpdated(uint256 timestamp);

    event WhitelistUpdated(address indexed account, bool status);

    event MinimumWithdrawalUpdated(
    uint256 oldMinimum,
    uint256 newMinimum
    );



    function pause() external 
    {
            if (msg.sender != owner) revert 
        NotOwner();

            if (paused) revert AlreadyPaused();

            whitelist[msg.sender] = true;
        
            paused = true;
        
            emit Paused(msg.sender);
        
            Withdrawal[] private withdrawals;
    }



   function unpause() external 
    {
        if (msg.sender != owner) revert NotOwner();
        if (!paused) revert AlreadyUnpaused();
    
        paused = false;
    
        emit Unpaused(msg.sender);
    }



    function setMinimumWithdrawal(uint256 newMinimum) external 
    {
         if (msg.sender != owner) revert NotOwner();
    
         uint256 oldMinimum = minimumWithdrawal;
         minimumWithdrawal = newMinimum;
    
         emit MinimumWithdrawalUpdated(oldMinimum, newMinimum);
    }



   function withdraw(uint256 amount) external 
    {
         if (msg.sender != owner) revert 
         NotOwner();
    
         if (paused) revert ContractPaused();

         if (!whitelist[msg.sender]) revert NotWhitelisted();
    
        if (amount > withdrawalLimit)
        {
          revert WithdrawalLimitExceeded();
        }

        if (amount < minimumWithdrawal) 
        {
            revert WithdrawalBelowMinimum();
        }
    
     payable(owner).transfer(amount);

     emit Withdraw(owner, amount);
    }



    function setWhitelist(address account, bool status) external
    {
            if (msg.sender != owner) revert NotOwner();
            if (account == address(0)) revert InvalidAddress();
        
            bool previousStatus = whitelist[account];
        
            whitelist[account] = status;
        
            if (status && !previousStatus) 
            {
                whitelistCount++;
            }
        
            if (!status && previousStatus)     
            {
                whitelistCount--;
            }
        
            emit WhitelistUpdated(account, status);
    }

    
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner);

    event Paused(address indexed account);

    event Unpaused(address indexed account);

    event WithdrawalLimitUpdated(uint256 oldLimit, uint256 newLimit);

    struct Withdrawal
    {
    uint256 amount;
    uint256 timestamp;
    }

    constructor() 
    {
        owner = msg.sender;

        withdrawalLimit = 10 ether;

        minimumWithdrawal = 0.01 ether;

        emit OwnershipTransferred(address(0), owner);
    }

    receive() external payable
    {

        totalDeposits++;

        emit Deposit(msg.sender, msg.value);

        emit DepositCountUpdated(totalDeposits);
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

        lastWithdrawalTime = block.timestamp;

        emit WithdrawalTimeUpdated(block.timestamp);

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

    function setWithdrawalLimit(uint256 newLimit) external 
    {
        if (msg.sender != owner) revert NotOwner();
    
        uint256 oldLimit = withdrawalLimit;
        withdrawalLimit = newLimit;
    
        emit WithdrawalLimitUpdated(oldLimit, newLimit);
    }


    function getLastWithdrawalTime() external view returns (uint256) 
    {
    return lastWithdrawalTime;
    }

    function getTotalDeposits() external view returns (uint256)   
    {
    return totalDeposits;
    }

    function isWhitelisted(address account) external view returns (bool)
    {
    return whitelist[account];
    }

}
