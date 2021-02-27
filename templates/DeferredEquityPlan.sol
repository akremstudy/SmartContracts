pragma solidity ^0.5.0;
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

contract DeferredEquityPlan {
    using SafeMath for uint;
    
    //uint fakenow = now;
    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract
    uint total_shares = 1000;
    uint annual_distribution = 250;

    //uint start_time = fakenow; 
    uint start_time = now;
    // permanently stores the time this contract was initialized
    
    uint unlock_time = now + 365 days;

    //uint unlock_time = fakenow + 365 days;

    uint public distributed_shares; 
    // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You don't have permission");
        require(active == true, "Contract not active.");

        // 1: `unlock_time` is less than or equal to `now`
        // 2: `distributed_shares` is less than the `total_shares`
        //require(unlock_time <= now, "It is not time for your shares!");
        require(unlock_time <= now, "It is not time for your shares!");
        require(distributed_shares < total_shares, "You have recieved all of your shares!");

        unlock_time = unlock_time.add(365 days);
        distributed_shares = ((now.sub(start_time)).div(365 days)).mul(250);
        //distributed_shares = ((fakenow - start_time) / 365 days) * 250;
        // 250 shares every year distribution
        

        
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
            // double check in case the employee does not cash out until after 5+ years
        }
    }
    
    /*function fastforward() public {
        fakenow += 100 days;
    }*/

    
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You don't have permission");
        active = false;
        // human_resources and the employee can deactivate this contract at-will
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
