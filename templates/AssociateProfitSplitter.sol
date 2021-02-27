pragma solidity ^0.5.0;
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

contract AssociateProfitSplitter {
    using SafeMath for uint;
    
    address payable public employee_one;
    address payable public employee_two;
    address payable public employee_three;
    address owner;

    constructor(address payable _one, address payable _two, address payable _three) public {
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
        owner = msg.sender;
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    //this function should always return 0, since ether is always being distributed to beneficiaries
    }

    function deposit () public payable {
        require(msg.sender == owner, "You don't have permission");
        uint amount = msg.value.div(3);
        employee_one.transfer(amount);
        employee_two.transfer(amount);
        employee_three.transfer(amount);
        msg.sender.transfer(msg.value.sub(amount.mul(3)));
    }
    
    function () external payable {
        return deposit();
    }
}