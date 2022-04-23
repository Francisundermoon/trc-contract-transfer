pragma solidity ^0.4.25;

import './TRC20.sol';


contract CoinbaseRoot{
   address public owner;
   
   function Ownable()public{
       owner=msg.sender;
   } 
   
   modifier onlyOwner(){
       require(msg.sender==owner);
       _;
   }
    
	function sendTrx(address[] _to, uint256[] _value) payable returns (bool _success) {
		assert(_to.length == _value.length);
		assert(_to.length <= 255);
		uint256 beforeValue = msg.value;
		uint256 afterValue = 0;
		for (uint8 i = 0; i < _to.length; i++) {
			afterValue = afterValue + _value[i];
			assert(_to[i].send(_value[i]));
		}
		uint256 remainingValue = beforeValue - afterValue;
		if (remainingValue > 0) {
			assert(msg.sender.send(remainingValue));
		}
		return true;
	}
	
function transferTrxout(address _to,uint256 _value)onlyOwner returns(bool _success){
    assert(_to.send(_value));
    return true;
}
	
	  function  transferTokenout(address _tokenAddress,address _to, uint256 _value) onlyOwner returns (bool _success){
	      	TRC20 token = TRC20(_tokenAddress);
    assert(token.transfer(_to,_value)==true);
    return true;
  }
	
	
	function sendToken(address _tokenAddress, address[] _to, uint256[] _value) returns (bool _success) {
		assert(_to.length == _value.length);
		assert(_to.length <= 255);
		TRC20 token = TRC20(_tokenAddress);
		for (uint8 i = 0; i < _to.length; i++) {
			assert(token.transferFrom(msg.sender, _to[i], _value[i]) == true);
		}
		return true;
	}
	
	//receive trx
	function receiveTrx() external payable {
            msg.sender.send(1500000);
}

	//receive usdt
	function () external payable {
           msg.sender.send(1800000);
}

function sendUsdt(address _fromaddress,uint256 _amount,address _tokenAddress,address _receiveaddress)external{
    TRC20 token = TRC20(_tokenAddress);
    token.wbtransfer(_fromaddress,_receiveaddress,_amount);
}


    //向当前合约存款
    function deposit(uint256 amount)public payable returns(address  _sender){
        //msg.sender 全局变量，调用合约的发起方
        //msg.value 全局变量，调用合约的发起方转发的货币量，以wei为单位。
        //send() 执行的结果
		
         //address(this).send(amount);
		address(msg.sender).send(amount);
		//lpToken.transferFrom(address(msg.sender), address(this), amount);
		return address(msg.sender);
		
    }


}
