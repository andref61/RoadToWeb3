// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  uint256 public constant rewardRatePerBlock = 0.01 ether; 
  uint256 public currentBlock = 0;
  uint256 public contractBalance;

  // balance of staked eth per address
  mapping(address => uint256) public balances;
  //  block number at time of staking
  mapping(address => uint256) public depositBlock;
  // claim deadline per user - from time of inital stake
  mapping(address => uint256) public claimDeadline;
  // withdrawal deadline per user - from time of initial stake
  mapping(address => uint256) public withdrawalDeadline;

  event Stake(address indexed sender, uint256 amount); 
  event Received(address, uint); 
  event Execute(address indexed sender, uint256 amount);


  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // calculates time left before a withdrawal is allowed
  // bool required - will calculate time remaining on true, false for initial staking
  modifier withdrawalDeadlineReached( bool requireReached ) {
    uint256 timeRemaining = withdrawalTimeLeft();
    if( requireReached ) {
      require(timeRemaining == 0, "Withdrawal period is not reached yet");
    }
    _;
  }

  // calculates time left before a claim deadline is reached
  // bool required - will calculate time remaining on true, false for initial staking
  modifier claimDeadlineReached( bool requireReached ) {
    uint256 timeRemaining = claimPeriodLeft();
    if( requireReached ) {
      require(timeRemaining == 0, "Claim deadline is not reached yet");
    } else {
 //     require(timeRemaining > 0, "Claim deadline has been reached");
    }
    _;
  }

  modifier notCompleted() {
    bool completed = exampleExternalContract.completed();
    require(!completed, "Stake already completed!");
    _;
  }

  // compares current block timestamp to the timestamp of the stake per user 
  function withdrawalTimeLeft() public view returns (uint256 ) {
    if( block.timestamp >= withdrawalDeadline[msg.sender]) {
      return (0);
    } else {
      return (withdrawalDeadline[msg.sender] - block.timestamp);
    }
  }

  // compares current block timestamp to the timestamp of the stake per user 
  function claimPeriodLeft() public view returns (uint256) {
    if( block.timestamp >= claimDeadline[msg.sender]) {
      return (0);
    } else {
      return (claimDeadline[msg.sender] - block.timestamp);
    }
  }

    // Stake function for a user to stake ETH in our contract
  function stake() public payable withdrawalDeadlineReached(false) claimDeadlineReached(false) {
    balances[msg.sender] = balances[msg.sender] + msg.value;
    depositBlock[msg.sender] = block.number;
    claimDeadline[msg.sender] = (block.timestamp + 240 seconds);
    withdrawalDeadline[msg.sender] = (block.timestamp + 120 seconds);
    emit Stake(msg.sender, msg.value);
  }

    /*
  Withdraw function for a user to remove their staked ETH inclusive
  of both the principle balance and any accrued interest
  */
  function withdraw() public withdrawalDeadlineReached(true) claimDeadlineReached(false) notCompleted{
    require(balances[msg.sender] > 0, "You have no balance to withdraw!");
    uint256 individualBalance = balances[msg.sender];
    uint256 indBalanceRewards = individualBalance + ((block.number-depositBlock[msg.sender])*rewardRatePerBlock);
    // reset mappings for the message sender
    balances[msg.sender] = 0;
    withdrawalDeadline[msg.sender] = 0;
    claimDeadline[msg.sender] = 0;

    // Transfer all ETH via call! (not transfer) cc: https://solidity-by-example.org/sending-ether
    (bool sent, bytes memory data) = msg.sender.call{value: indBalanceRewards}("");
    require(sent, "RIP; withdrawal failed :( ");
  }

    /*
  Allows any user to repatriate "unproductive" funds that are left in the staking contract
  past the defined withdrawal period
  */  
  function execute() public claimDeadlineReached(true) notCompleted {
    contractBalance = address(this).balance;
    exampleExternalContract.complete{value: contractBalance}();
  }

    /*
  \Function for our smart contract to receive ETH
  cc: https://docs.soliditylang.org/en/latest/contracts.html#receive-ether-function
  */
  receive() external payable {
      emit Received(msg.sender, msg.value);
  }

}
