pragma solidity >=0.4.21 <0.6.0;
import "./Token.sol";

contract Receiver {
    uint public value;

    function requestBalance(address user, address token) public {
        Token tokenContract = Token(token);
        value = tokenContract.getBalance(user);
    }
}
