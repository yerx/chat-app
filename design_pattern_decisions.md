# Design Patterns Decisions

## Preventing fake events

To protect all parties, both the ticket buyers and the event host, there is an arbitrator. The transaction parts of the contract operate like an escrow. When users purchase tickets, those funds are transferred to the contract and held there. After the event host delivers the advertised goods or services, the arbitrator will release the funds from the contract to the event host. The role of the arbitrator is to ensure that the exchange between buyers and the event host is fair.

## Setting the ticket supply and ticket price

The contract adds flexibility by enabling a function to modify the ticket supply and the ticket price. However, these functions can only be modified by the arbitrator through the "onlyOnly" modifier method provided through OpenZeppelin's Ownable.sol contract. Again, the arbitrator facilitates fair, transparent, trusted transactions between the event host and the ticket buyers.

## Emergency stop

The arbitrator has the ability to use an emergency stop method if there are attacks. Through the OpenZeppelin Pausable.sol contract, the arbitrator can pause the deposit function and to pause the withdraw function when needed. 
