// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Event is Ownable, Pausable {
    
    IERC20 ownerToken;
    
    mapping (address => bool) whileList;
    address[] private allowedAddressList;
    uint256 totalSupply;
    uint256 withdrawAmount;
    
    function SetOwnerToken(address tokenAddress) external {
        ownerToken = IERC20(tokenAddress);
    }
    
    function SetWithDrawAmount(uint256 amount) external onlyOwner {
         withdrawAmount = amount;
    }

    function GetWithDrawAmount() external view returns (uint256) {
         return withdrawAmount;
    }
    
    function DepositTokens(uint256 tokens) external onlyOwner {
        totalSupply = totalSupply + tokens;
        ownerToken.approve(address(this), tokens);
        ownerToken.transferFrom(owner(), address(this), tokens);
    }
    
    function SetWhileList(address[] memory accessableList) external onlyOwner {
        for(uint i = 0; i < accessableList.length; i++) {
            allowedAddressList.push(accessableList[i]);
            whileList[accessableList[i]] = true;
        }
    }
    
    function PauseEvent() external onlyOwner {
        _pause();
    }
    
    function Withdraw() external whenNotPaused {
        require(whileList[msg.sender], "You can not claim tokens!");
        ownerToken.transfer(msg.sender, withdrawAmount);
        totalSupply = totalSupply - withdrawAmount;
        whileList[msg.sender] = false;
    }
    
    function CheckBalance() external view returns(uint256) {
        return totalSupply;
    }
    
    function BackToOwner() external onlyOwner whenPaused {
        ownerToken.transfer(owner(), totalSupply);
        totalSupply = 0;
    }

    function GetOwnerToken() external view returns (address) {
        return address(ownerToken);
    }

    function GetAddress() external view returns (address) {
        return address(this);
    }

    function GetWhiteList() external view returns (address[] memory) {
        return allowedAddressList;
    }
}