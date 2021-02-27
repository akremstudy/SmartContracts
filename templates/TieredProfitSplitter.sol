pragma solidity ^0.5.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";


contract TieredProfitSplitter {
    using SafeMath for uint;
    
    address payable public CEO;
    address payable public CTO;
    address payable public Bob;
    address owner = msg.sender;

    constructor(address payable _CEO, address payable _CTO, address payable _Bob) public {
        CEO = _CEO;
        CTO = _CTO;
        Bob = _Bob;
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    //this function should always return 0, since ether is always being distributed to beneficiaries
    }

    function deposit () public payable {
        require(msg.sender == owner, "You don't have permission to make deposits!");
        uint points = msg.value.div(100);
        uint total;//to keep a running total
        uint amount;
        amount = points.mul(60);
        total = total.add(amount);
        CEO.transfer(amount);
        amount = points.mul(25);
        total = total.add(amount);
        CTO.transfer(amount);
        amount = points.mul(15);
        total = total.add(amount);
        Bob.transfer(amount);
        Bob.transfer(msg.value.sub(total));
    }
    
    function () external payable {
        deposit();
    }
}