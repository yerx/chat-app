pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";

/**
 * @title ConcertTix
 * @notice Primary contract to purchase tickets, set a ticket supply and fee,
 * and holds the funds destined to the receiver/event host until the delivery of
 * goods and/or services.
 * @dev The approver role will enable the withdraw of
 * funds from the contract to the receiver/event host.
 */

contract ConcertTix is Ownable, Pausable {

  using SafeMath for uint256;

  event TransferEvent(address, uint256);
  event ticketsRemainingEvent(uint256 ticketCount);

  // @dev The public can see the number of tickets available
  uint256 public ticketCount;
  /*
   * @dev The cost of the concert ticket is set to 1 ether. The amount is in Wei
   * because msg.value is in Wei. The app roadmap includes adding a
   * currency converter and pegging the price to a more stable currency.
   */
  uint256 ticketPrice = 1000000000000000000;
  uint256 maxTickets = 5;
  // receiver address is the address of the event host
  address public receiver = 0x239eD3f154552eecc95B6F7922c72bDb419D08E2;
  /*
   * @dev the Approver is an event arbitrator who will release the funds to the
   * event host after the delivery of the service i.e. the concert
  */
  address constant public approver = 0x69ee9EC9045d3B650c1F52d40EAB79afB7458b0f;
  address public sender;
  // @dev Create a mapping to store the sender addresses.
  mapping (address => uint) public ticketHolders;

  /**
   * @dev Sets the ticket count equal to the maximum tickets available.
   * The ticket count will count down to 0 and disallow transactions when
   * there are no tickets remaining.
   */
  constructor() internal {
    ticketCount = maxTickets;
  }

  /**
   * @dev If the buyer does not have enough ether or the buyer indicated an amount of
   * tickets that is greater than the total remaining tickets, the transaction
   * will not go through. Uses the openzeppelin SafeMath library to prevent
   * underflows/overflows for the ticket counter. The function has an
   * emergency stop function of whenNotPaused to stop accepting deposits if
   * the contract is paused to ensure that buyers don't lose their funds.
   */
  function deposit(address _receiver) external payable whenNotPaused {

    require(msg.value == ticketPrice && ticketCount != 0);
    sender = msg.sender;
    ticketHolders[msg.sender];
    receiver = _receiver;
    ticketCount = ticketCount.sub(1);

    emit TransferEvent(sender, msg.value);
  }

  /**
   * @dev a Separate function to keep track of the ticket count.
   * @return Provides an updated ticket count that can be called publically.
   */
  function getTicketCount(uint256 _amount) public returns(uint256) {
    _amount = ticketCount;
    return ticketCount;

    emit ticketsRemainingEvent(ticketCount);
  }

  /**
   * @dev The address of the arbitrator/approver can be called. This is
   * for the purpose of transparency for all parties involved.
   */
  function viewApprover() external view returns(address) {
    return(approver);
  }

  /**
   * @dev Uses the openzeppelin Ownable contract so that only the designated
   * user can approve the the withdraw of funds from the contract to the
   * event host.
   */
  function withdraw() external onlyOwner whenNotPaused {
    require(msg.sender == approver);
    receiver.transfer(address(this).balance);
  }

  /**
   * @dev Only the contract owner can set the ticket supply.
   */
   function setTicketCount(uint256 _maximum) external onlyOwner {
    maxTickets = _maximum;
  }

  /**
   * @dev Only the contract owner can set the ticket fee.
   */
   function setTicketPrice(uint256 _fee) external onlyOwner {
    ticketPrice = _fee;
  }

  function () payable {
  }

}
