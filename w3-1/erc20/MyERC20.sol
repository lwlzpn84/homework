// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MyERC2O {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor (string memory name, string memory symbol, uint8 decimals, uint total) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _mint(msg.sender, total);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender]  - amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
        return true;
    }


    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "_transfer发送账号地址不能等于address(0)");
        require(recipient != address(0), "_transfer接收账号地址不能等于address(0)");

        _balances[sender] = _balances[sender]- amount;
        _balances[recipient] = _balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
    }


    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "_mint账号地址不能等于address(0)");
        if (amount == 0) {
          return ;
        }

        _totalSupply = _totalSupply + amount;
        _balances[account] = _balances[account] + amount;
        emit Transfer(address(0), account, amount);
    }


    function _burn(address account, uint256 value) internal {
        require(account != address(0), "_burn账号地址不能等于address(0)");

        _balances[account] = _balances[account] - value;
        _totalSupply = _totalSupply - value;
        emit Transfer(account, address(0), value);
    }


    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "token所有者账号地址不能等于address(0)");
        require(spender != address(0), "token使用者账号地址不能等于address(0)");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender] - amount);
    }
}