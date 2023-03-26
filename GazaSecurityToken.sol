// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Token {
    
    function totalsupply() public view returns(uint supply){}

    function balanceOf(address _owner) public virtual returns(uint ){}

    function transfer(address _to, uint _value) public virtual returns(bool success){}

    function transferFrom(address _from, address _to, uint _value) public returns(bool success){}

    function approve(address _spender, uint256 _value) public returns (bool success){}
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){}



    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);


}

contract standardToken is Token {

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    uint private _totalsupply = 1000000000000000000;

    function transfer(address _to, uint _value) public override returns(bool success){
        if(balances[msg.sender] >= _value && _value > 0){
            balances[msg.sender] -= _value;
            balances[_to] += _value;

            emit Transfer(msg.sender, _to, _value);

            return true;
        }else {
            return false;
        }
    }

    function balanceOf(address _owner) public view override returns(uint balance){
        return balances[_owner];
    }

}

contract GazaToken is standardToken {
    string public name;
    string public symbol;
    uint public decimal;
    uint public totaleEthInWei;
    address payable public fundsWallet;
    uint public maxTokens = 1000000000000000000;
    uint public unitOneEthCanBuy;

    constructor() {
        balances[msg.sender] = maxTokens;
        name = "GazaToken";
        decimal = 18;
        symbol = "Gaza";
        fundsWallet = payable(msg.sender);
        unitOneEthCanBuy = 100000;
    }

    fallback() external  payable {
        totaleEthInWei += msg.value;
        uint amount = msg.value * unitOneEthCanBuy;
        require(balances[msg.sender] >= amount, "You don't have enough token");
        balances[fundsWallet] -= amount;
        balances[msg.sender] += amount;
        fundsWallet.transfer(msg.value);
        emit Transfer(fundsWallet, msg.sender, amount);
    }
}