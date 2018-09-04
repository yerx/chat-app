pragma solidity ^0.4.24;

contract ConcertTix {

  event Transfer(address indexed _from, uint _value);
  event ticketsRemainingEvent(uint ticketCount);

  // public can see the number of tickets available
  uint public ticketCount;
  /*
   * The cost of the concert ticket is set to .15 ether. The app roadmap includes adding a
   * currency converter and pegging the price to a more stable currency.
   */
  uint constant ticketPrice = .25 ether;
  /*
   * Create a mapping to store the buyers' addresses.
   */
  mapping (address => uint) public buyers;
  mapping (address => uint) balances;


  function Concerttix() {
    // set the maximum number of tickets for the concert for demo purposes
    uint _maximum = 5;
    // set var maxTickets equal to the maximum tickets available
    ticketCount = _maximum;
  }

  function buyTickets() public payable {
    /*
     * If the buyer does not have enough ether or the buyer indicated an amount of
     * tickets that is greater than the total remaining tickets, the transaction
     * will not go through.
     */
    require(msg.value == ticketPrice && ticketCount != 0);
    // have the msg.sender send ether to the contract
    balances[msg.sender] += msg.value;
    Transer(msg.sender, msg.value);
    // add the msg.sender to the buyers array
    buyer[msg.sender];
    // update the available tickets
    ticketCount --;
    }

    /*
     * Returns the updated ticket count. It is a view function so that
     * the function only reads from the contract.
     */
  function _ticketCount() public view returns(uint) {
    return ticketCount;

    emit ticketsRemainingEvent(ticketCount);
  }

}
