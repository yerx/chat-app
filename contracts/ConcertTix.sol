pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract ConcertTix is Ownable {

  using SafeMath for uint256;

  event TransferEvent(address, uint);
  event ticketsRemainingEvent(uint ticketCount);

  // public can see the number of tickets available
  uint256 public ticketCount;
  /*
   * The cost of the concert ticket is set to .15 ether. The app roadmap includes adding a
   * currency converter and pegging the price to a more stable currency.
   */
  uint ticketPrice = 2 ether;
  uint256 maxTickets = 5;
  // receiver address is the contract address
  address public receiver = address(this);
  // approver address is the person putting on the event
  address constant public approver = 0x69ee9EC9045d3B650c1F52d40EAB79afB7458b0f;
  address public sender;
  //Create a mapping to store the sender addresses.
  mapping (address => uint) public ticketHolders;

  function ConcertTix() public {
    // set the ticketCount equal to the maximum tickets available
    ticketCount = maxTickets;
  }

  // enable the contract owner to modify the tickets available
  function setTicketCount(uint256 _maximum) external onlyOwner {
    maxTickets = _maximum;
  }


  // enable the contract owner to modify the price of the tickets
  function setTicketPrice(uint _fee) external onlyOwner {
    ticketPrice = _fee;
  }

  function deposit(address _receiver) external payable {
    /*
     * If the buyer does not have enough ether or the buyer indicated an amount of
     * tickets that is greater than the total remaining tickets, the transaction
     * will not go through.
     */
    require(msg.value == ticketPrice && ticketCount != 0);
    sender = msg.sender;
    ticketHolders[msg.sender];
    receiver = _receiver;
    // update the available tickets and use SafeMath library to prevent over/underflows
    ticketCount = ticketCount.sub(1);

    emit TransferEvent(msg.sender, msg.value);
  }

  function getTicketCount(uint256 _amount) public returns(uint256) {
    _amount = ticketCount;
    return ticketCount;

    emit ticketsRemainingEvent(ticketCount);
  }

  function viewApprover() external view returns(address) {
    return(approver);
  }

  function withdraw() external onlyOwner{
    require(msg.sender == approver);
    approver.transfer(address(this).balance);
  }

  function () payable {
  }

}

/*
function buyTickets() public payable {
  /*
   * If the buyer does not have enough ether or the buyer indicated an amount of
   * tickets that is greater than the total remaining tickets, the transaction
   * will not go through.
   */
/*
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

function getTicketCount(uint256 _amount) public returns(uint256) {
  _amount = ticketCount;
  return ticketCount;

  emit ticketsRemainingEvent(ticketCount);
}

function withdraw() external onlyOwner{
  owner.transfer(address(this).balance);

}

function () payable {

}

}
*/
