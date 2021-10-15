pragma solidity >=0.7.0 <0.9.0;

contract Transaction {
    event Transfer(address indexed from, address indexed to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    
    mapping(address => uint256) private balances;
    
    address private customer ;

    mapping(address => mapping(address => uint256)) private _allowed;
    
    uint256 private _totalTime ;
    uint256 private _totalYear ; 

    uint constant YEAR_IN_SECONDS = 31536000;
    uint constant LEAP_YEAR_IN_SECONDS = 31622400;

    constructor (address _customer) public{
        customer = _customer ; 
    }
    function setYear (uint _years) public  returns (bool){
           
        totalYear = years ; 
        
        if(isLeapYear(_years)){
            
        totalTime = block.timestamp + ( years * LEAP_YEAR_IN_SECONDS );
            
        }
        
        else {
            totalTime = block.timestamp + (years * YEAR_IN_SECONDS);
        }
        return true ; 
    }
    function setDeposit(uint _deposit) public  returns (bool) {
        require(customer != address(0),'address of customer must  be not null');
        require(balances[customer]>= _deposit) ;
         balances[customer] -= _deposit ;
         balances[msg.sender] += _deposit ;
        allowed[customer][msg.sender] += deposit ; 
        return true ;
    }
    
    function caculateInterest() private returns (uint256){
        uint interest = 0 ;
        uint rate = uint(11)/uint(10);
        interest = balances[msg.sender]  ( (rate) * _totalYear ) - balances[msg.sender] ; 
        return interest ;
    }
    
     function balanceOf(address account) public  view returns (uint256) {
         
        return balances[account];
    }


    function withDraw()  public  returns (uint256){
    require(_totalTime >= block.timestamp ,'total year save money must be less than currensYeas') ;
    uint256 interest = 0 ;
    interest = caculateInterest();
    uint256 totalMoney = 0 ;
    balances[msg.sender] -= totalMoney ;
    _allowed[customer][msg.sender] -=totalMoney ; 
    balances[customer] += totalMoney;
    return balances[msg.sender];
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

   function approve(address spender, uint256 value) public returns (bool){
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint256 remaining){
        return _allowed[_owner][_spender];
    }
    
}