pragma solidity >=0.4.21 <0.6.0;

contract Token {
    mapping(address => uint) public balances;
    uint public totalSupply;

    constructor() public {
        balances[msg.sender] = 1000000;
    }

    function getBalance (address accountFrom) public view returns(uint) {
        return balances[accountFrom];
    }

    function getTotalSupply () public view returns(uint) {
        return totalSupply;
    }
}
