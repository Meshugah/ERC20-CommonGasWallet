pragma solidity 0.5.8;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/*
    ERC 20 Transfer interface
*/
contract ERC20 {
    function transfer(address to, uint tokens) public returns (bool success);
}

/*
    Generic Receiver Contract
*/
contract Receiver is Ownable,Pausable {
    /*
        @notice Send funds owned by this contract to another address
        @param tracker  - ERC20 token tracker ( DAI / MKR / etc. )
        @param amount   - Amount of tokens to send
        @param receiver - Address we're sending these tokens to
        @return true if transfer succeeded, false otherwise 
    */
    using SafeMath for uint256;

    function sendFundsTo( address tracker, uint256 amount, address receiver) public onlyOwner returns ( bool ) {
        // callable only by the owner, not using modifiers to improve readability
        

        // Transfer tokens from this address to the receiver
        return ERC20(tracker).transfer(receiver, amount);
    }
}

/*
    Factory Contract
*/
contract Factory is Ownable, Pausable {

    using SafeMath for uint256;
    using SafeMath for uint8;

    mapping ( uint256 => address ) public receiversMap;
    uint256 public receiverCount = 0;


    /*
        @notice Create a number of receiver contracts
        @param number  - 0-255 
    */
    function createReceivers( uint8 number ) public onlyOwner{
        
        // would reach the gaslimit at 41 or so
        require(number <= 38);


        for(uint8 i = 0; i < number; i++) {
            // Create and index our new receiver
            receiversMap[++receiverCount] = address(new Receiver());
        }
        // add event here if you need it
    }

    /*
        @notice Send funds in a receiver to another address
        @param ID       - Receiver indexed ID
        @param tracker  - ERC20 token tracker ( DAI / MKR / etc. )
        @param amount   - Amount of tokens to send
        @param receiver - Address we're sending tokens to
        @return true if transfer succeeded, false otherwise 
    */
    function sendFundsFromReceiverTo( uint256 ID, address tracker, uint256 amount, address receiver ) public onlyOwner returns (bool) {
        
        return Receiver( receiversMap[ID] ).sendFundsTo( tracker, amount, receiver);
    }

    /*
        Batch Collection - Should support a few hundred transansfers

        @param tracker           - ERC20 token tracker ( DAI / MKR / etc. )
        @param receiver          - Address we're sending tokens to
        @param contractAddresses - we send an array of addresses instead of ids, so we don't need to read them ( lower gas cost )
        @param amounts           - array of amounts 

    */
    function batchCollect( address tracker, address receiver, uint256[] memory amounts, address[] memory contractAddresses) public onlyOwner{
        
        require(contractAddresses.length == amounts.length);

        for(uint256 i = 0; i < contractAddresses.length; i++) {

            // add exception handling
            require(Receiver( contractAddresses[i] ).sendFundsTo( tracker, amounts[i], receiver), "batchCollect's call to sendFundsTo failed");
        }
    }
}

// tests to check:
// batchcollect check for different lengths on amounts and contractAddress, addressed with the require
// check if the batchcollect function works after the require is added
// check for floating compiler
// transfer owner with openZeppelin
// what happens when you run createReceivers(0)
// change ownership
// check for createReceivers to be less than 40
