pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract ConcertTix is Ownable {

  using SafeMath for uint256;

  event TransferEvent(address indexed _from, uint _value);
  event ticketsRemainingEvent(uint ticketCount);

  // public can see the number of tickets available
  uint256 public ticketCount;
  /*
   * The cost of the concert ticket is set to .15 ether. The app roadmap includes adding a
   * currency converter and pegging the price to a more stable currency.
   */
  uint ticketPrice = .25 ether;
  uint256 maxTickets = 5;
  /*
   * Create a mapping to store the buyers' addresses.
   */
  mapping (address => uint) public buyers;
  mapping (address => uint) balances;


  function Concerttix() public {
    // set the ticketCount equal to the maximum tickets available
    ticketCount = maxTickets;
  }

  // enable the contract owner to modify the tickets available
  function setMaxTickets(uint256 _max) external onlyOwner {
    maxTickets = _max;
  }

  // enable the contract owner to modify the price of the tickets
  function setTicketPrice(uint _fee) external onlyOwner {
    ticketPrice = _fee;
  }

  function buyTickets() public payable {
    /*
     * If the buyer does not have enough ether or the buyer indicated an amount of
     * tickets that is greater than the total remaining tickets, the transaction
     * will not go through.
     */
    require(msg.value == ticketPrice && ticketCount != 0);
    // have the msg.sender send ether to the contract
    balances[msg.sender] -= msg.value;
    //Transfer(msg.sender, msg.value);
    // add the msg.sender to the buyers array
    buyers[msg.sender];
    // update the available tickets and use SafeMath library to prevent over/underflows
    ticketCount = ticketCount.sub(1);

    emit TransferEvent(msg.sender, msg.value);
  }

  function _ticketCount() public returns(uint256) {
    return ticketCount;

    emit ticketsRemainingEvent(ticketCount);
  }

  function withdraw() external onlyOwner{
    owner.transfer(address(this).balance);

  }

  function () payable {

  }

}
