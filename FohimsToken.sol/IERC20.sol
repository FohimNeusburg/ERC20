// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
   
    function totalSupply() external view returns (uint256);
    function getBalance(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    event Transfer(address indexed _sender, address indexed _too, uint256 _amount);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}