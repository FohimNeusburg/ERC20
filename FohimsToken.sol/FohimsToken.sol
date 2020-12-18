// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import"./GSNContext.sol";
import"./IERC20.sol";
import"./Pausable.sol";
import"./SafeMath.sol";

contract ERC20 is IERC20, GSNContext, Pausable {
    
    using SafeMath for uint256;
    
    uint private _decimals;
    uint private _totalsupply;
    
    string private _name;
    string private _ticker;
    
    address public _owner;
    
    mapping (address => uint) private _balances;
    mapping (address => mapping (address => uint)) private _allowances;


    constructor () {
        _decimals = 10;
        _totalsupply = 100 * (10 ** _decimals);
        _name = "FohimNuesburgsTokenContract";
        _ticker = "FNT";
        _owner = msg.sender;
        _balances[_owner] = _balances[_owner].add(_totalsupply);
    }
    
    function name() public view returns (string memory) {
        return _name;
    }
    
    function ticker() public view returns (string memory) {
        return _ticker;
    }
    
    function totalSupply() public view override returns (uint) {
        return _totalsupply;
    }
    
    function getBalance(address _key) public view override returns (uint) {
        return _balances[_key];
    }
    
    function allowance(address _from, address _spender) public view override returns (uint) {
        return _allowances[_from][_spender];
    }
    
    function approve(address _spender, uint _amount) public override whenNotPaused() returns (bool) {
        require (_balances[msg.sender] >= _amount, "ERC20: Amount is lower than requested from transfer");
    
        _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_amount);
    
        emit Approval(msg.sender, _spender, _amount);
    
        return true;
    }
    
    function decreaseApproval(address _from, address _spender, uint _amount) public whenNotPaused() returns (bool) {
        require (_allowances[_from][_spender] >= _amount, "ERC20: Amount is lower than requested from transfer");
        
        _allowances[_from][_spender] = _allowances[_from][_spender].sub(_amount);
        
        return true;
    }
    
    function transfer(address _too, uint _amount) public override whenNotPaused() returns (bool) {
        _transfer(_msgSender(), _too, _amount);
        return true;
    }
    
    function _transfer(address _from, address _too, uint _amount) internal returns (bool) {
        require (_balances[_from] >=_amount, "ERC20: Amount is lower than requested from transfer");
        require (_from != address(0), "ERC20: Is not the zero address");
        require (_too != address(0), "ERC20: Is not the zero address");
        
        _beforeTokenTransfer(_msgSender(),  _too, _amount);
        
        _balances[_from] = _balances[_from].sub(_amount);
        _balances[_too] = _balances[_too].add(_amount);
        
        emit Transfer(msg.sender, _too, _amount);
        
        return true;
    }
    
    function transferFrom(address _from, address _spender, uint _amount) public override whenNotPaused() returns (bool) {
        require (_allowances[_from][_spender] >= _amount, "ERC20: Amount is lower than requested from transfer");
        require (_balances[_from] >= _amount, "ERC20: Amount is lower than requested from transfer");
        
        _transfer(_from, _msgSender(), _amount);
        
        _allowances[_from][_spender] = _allowances[_from][_spender].sub(_amount);
        
        emit Approval(_from, _msgSender(), _amount);
        
        return true;
    }
    
    function mint(uint _amount) public whenPaused() onlyOwner() {
        require (msg.sender == _owner);
        require (_amount > 0);
        
        _beforeTokenTransfer(address(0), _owner, _amount);
        
        _totalsupply = _totalsupply.add(_amount);
        _balances[_owner] = _balances[_owner].add(_amount);
        
        emit Transfer(address(0), _owner, _amount);
    }
    
    function burn(uint _amount) public whenPaused() onlyOwner() {
        require (_totalsupply >= _amount);
        require (_amount > 0);
        
        _totalsupply = _totalsupply.sub(_amount);
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
