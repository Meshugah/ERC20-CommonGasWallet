pragma solidity 0.5.8;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

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
        require(msg.sender == owner);

        // Transfer tokens from this address to the receiver
        return ERC20(tracker).transfer(receiver, amount);
    }

}