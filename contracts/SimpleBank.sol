/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

    /* State variables
     */
    
    // Fill in the visibility keyword. 
    // Hint: We want to protect our users balance from other contracts
    mapping (address => uint) balances ;
    
    // Fill in the visibility keyword
    // Hint: We want to create a getter function and allow contracts to be able
    //       to see if a user is enrolled.
    mapping (address => bool) public enrolled;

    // Let's make sure everyone knows who owns the bank, yes, fill in the
    // appropriate visilibility keyword
    address public owner = msg.sender;
    
    /* Events - publicize actions to external listeners
     */
    
    // Add an argument for this event, an accountAddress
    event LogEnrolled(address accountAddress);

    // Add 2 arguments for this event, an accountAddress and an amount
    event LogDepositMade(address accountAddress, uint amount);

    // Create an event called LogWithdrawal
    // Hint: it should take 3 arguments: an accountAddress, withdrawAmount and a newBalance 
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    /* Functions
     */

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      enrolled[msg.sender] = true;
      emit LogEnrolled(msg.sender);
      return true;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() payable public returns (uint) {
      require(enrolled[msg.sender], "must be enrolled");
      balances[msg.sender] += msg.value;
      emit LogDepositMade(msg.sender, msg.value);
      return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {

      require(balances[msg.sender] >= withdrawAmount, "not enough funds");
      balances[msg.sender] -= withdrawAmount;
      msg.sender.transfer(withdrawAmount);
      emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
      return withdrawAmount;
    }
}
