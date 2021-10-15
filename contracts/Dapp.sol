
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./ERC20Token.sol";

contract Dapp {
    ERC20Token private tokenContract;
    uint8 public depositRatePerYear;
    uint8 public period ;
    address public admin;
    address public  customer ;
    uint256 private totalTime;
    uint256 private withDrawTimeLimit;
    
    mapping(address => uint256) private balances;
    
     mapping(address => uint256) private tokenSendingAmount;
    
    mapping(address => mapping(address => uint256)) private allowances;
    
    
    event ReceiveTokens(address _sender, uint256 amount);
    
    function setPeriod(uint8 _period) public {
        period= _period;
    }
    function setDepositRate(uint8 _depositRatePerYear) public {
        depositRatePerYear = _depositRatePerYear;
    }
    constructor (uint8 _period, uint8 _depositRatePerYear, address _customer, uint256 _withDrawTimeLimit ) public {
        admin = msg.sender;
        customer = _customer;
        depositRatePerYear = _depositRatePerYear;
        period = _period;
        withDrawTimeLimit =_withDrawTimeLimit;
    }
    function calculateProfit(uint256 amount) internal returns (uint256 newBalance){
        return amount + amount*depositRatePerYear*period;
    }
    
    function sendTokens(uint256 _numberOfTokens) public {
        require(customer != address(0),'address of customer can not be null');
        require(admin != address(0),'address of admin can not be null');
        require(tokenContract.balanceOf(customer) >= _numberOfTokens, "NumberOfTokens can not exceed customer balance");
        tokenContract.transfer(admin,_numberOfTokens);
        balances[admin] += _numberOfTokens;
    }
    
    function withDraw() public returns (uint256){
        require(totalTime >= block.timestamp ,'total year save money must be less than currensYeas') ;
        uint256 profit = calculateProfit(tokenSendingAmount[customer]);
        balances[admin] -= profit ;
        balances[customer] += profit;
        return balances[customer];
    }
    
}