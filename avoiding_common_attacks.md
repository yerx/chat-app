## Avoiding Common Attacks


### Integer Underflow with the ticket supply

The application has a ticket count feature where you can set the total ticket supply. The ticket counter will decrement each time tickets are purchased, and once the ticket count reaches 0, users will no longer be able to purchase tickets. If the ticket supply can be made to be less than zero, it will create an underflow that will set the ticket supply to its maximum value.

The application utilizes OpenZeppelin's SafeMath library to prevent underflow. Below is the subtraction function from the SafeMath library. The sub function makes sure that b is less than or equal to a.  

'function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }'

### Ownership and permissions as the owner

The contract owner has the ability to set the ticket price and ticket supply. The application limits this ability to only the owner by inheriting from the OpenZeppelin Ownable contract. The contract uses the 'onlyOwner' modifier for the set ticket price and set ticket supply functions in the contract. 
