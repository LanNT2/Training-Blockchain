
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./ERC20Token.sol";

contract Dapp {
    ERC20Token private tokenContract;
    uint256 public depositRatePerYear;
    address public admin;
    // Number of days at least that customer can withdraw token with profit
    uint256 private withDrawTimeLimit;
    address public  customer ;
     uint256 public period ;
     uint256 public totalYear ;
    uint256 public amount;
    
    uint constant YEAR_IN_SECONDS = 31536000;
    uint constant LEAP_YEAR_IN_SECONDS = 31622400;
    uint constant DAY_IN_SECONDS = 86400;
    
    mapping(address => uint256) private balances;
    
    mapping(address => mapping(address => uint256)) private allowances;
    
    
    event ReceiveTokens(address _sender, uint256 amount);
    
    function setPeriod(uint _year) public {
        totalYear= _year;
        
        if(isLeapYear(_year)){
            
        period = block.timestamp + ( _year * LEAP_YEAR_IN_SECONDS );
            
        }
        else {
            period = block.timestamp + (_year * YEAR_IN_SECONDS);
        }
    }
    
    function setWithDrawTimeLimit(uint _day) public returns (int256){
        withDrawTimeLimit = block.timestamp+_day*DAY_IN_SECONDS;
    }
    
    function setDepositRate(uint8 _depositRatePerYear) public {
        depositRatePerYear = _depositRatePerYear;
    }
    constructor (uint256 _depositRatePerYear, address _customer, uint256 _amount , uint _day, uint _year) public {
        admin = msg.sender;
        customer = _customer;
        amount = _amount;
        depositRatePerYear = _depositRatePerYear;
        setPeriod(_year);
        setWithDrawTimeLimit(_day);
    }
    function calculateProfit(uint256 amount) internal returns (uint256 newBalance){
        return amount + (amount*depositRatePerYear*totalYear)/100;
    }
    
    function sendTokens(uint256 _numberOfTokens) public {
        require(customer != address(0),'address of customer can not be null');
        require(admin != address(0),'address of admin can not be null');
        require(tokenContract.balanceOf(customer) >= _numberOfTokens, "NumberOfTokens can not exceed customer balance");
        tokenContract.transfer(admin,_numberOfTokens);
        balances[admin] += _numberOfTokens;
    }
    
    
    
    function withDraw() public returns (uint256){
        require(period >= withDrawTimeLimit ,'Customer can withdraw money if not reach the withDrawTimeLimit') ;
        uint256 profit = calculateProfit(amount);
        balances[admin] -= profit ;
        balances[customer] += profit;
        return balances[customer];
    }
    
    function isLeapYear(uint256 year) private pure returns (bool) {
                if (year % 4 != 0) {
                        return false;
                }
                if (year % 100 != 0) {
                        return true;
                }
                if (year % 400 != 0) {
                        return false;
                }
                return true;
     }
    
}