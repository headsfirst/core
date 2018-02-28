pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../tokens/SingularityNetToken.sol";


contract SpikeToken is MintableToken {
    string public constant name = "Spike Token";
    string public constant symbol = "SPIKE"; 
    uint8 public constant decimals = 0;

    event Unmint(address indexed beneficiary, uint256 amount);

    function unmint(address beneficiary, uint256 amount) onlyOwner canMint public returns (bool) {
        totalSupply = totalSupply.sub(amount);
        balances[beneficiary] = balances[beneficiary].sub(amount);

        Unmint(beneficiary, amount);
        return true;
    } 
}

contract Market {
    using SafeMath
    for uint256;

    uint256 public constant AGI_BASE_UNIT = 1;
    uint256 public constant SPIKE_BASE_UNIT = 1;
    

    MintableToken public spike;
    SingularityNetToken public token;

    address public owner;
    // amount of AGI at stake
    uint256 public pool = 0;
    // next price multiplier in AGI for minting next token
    uint256 public nextPrice = 1 * (10 ** 8);


    function Market(address _token) public {
        owner = msg.sender;
        spike = new SpikeToken();
        token = SingularityNetToken(_token);
    }

    function join() public {
        // We want to add 1 AGI. Use cogs instead?
        require(token.transferFrom(msg.sender, address(this), nextPrice));
        // Update pool 
        pool = pool.add(nextPrice);
        //Minting 1 SPIKE token
        spike.mint(msg.sender, SPIKE_BASE_UNIT);
        //Update the rate 
        require(updatePrice(AGI_BASE_UNIT,true));
    }

    function quit() public {
        require(spike.balanceOf(msg.sender) > 0);
        //Calculate the available reward 
        uint256 reward = pool.div(spike.totalSupply());

        //Now we can transfer back his AGI
        require(token.transfer(msg.sender, reward));
        //Update pool
        pool = pool.sub(reward);
        // Update now the SPIKE total supply along with the balance
        //spike.unmint(msg.sender, SPIKE_BASE_UNIT);
        //Update price in AGI
        require(updatePrice(AGI_BASE_UNIT, false));
    }

    function updatePrice(uint256 amount, bool action) internal returns (bool) {
        require(amount > 0);

        if (action) {
            nextPrice = nextPrice.add(amount * (10 ** 8));
        } else {
            nextPrice = nextPrice.sub(amount * (10 ** 8));            
        }
        return true;
    }

   

    function claimFunds() public {
        require(owner == msg.sender);
        token.transfer(owner, token.balanceOf(address(this)));
    }

}