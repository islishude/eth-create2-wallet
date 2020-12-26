// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function decimals() external view returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address tokenOwner)
    external
    view
    returns (uint256 balance);

  function allowance(address tokenOwner, address spender)
    external
    view
    returns (uint256 remaining);

  function transfer(address to, uint256 tokens) external returns (bool success);

  function approve(address spender, uint256 tokens)
    external
    returns (bool success);

  function transferFrom(
    address from,
    address to,
    uint256 tokens
  ) external returns (bool success);

  event Transfer(address indexed from, address indexed to, uint256 tokens);
  event Approval(
    address indexed tokenOwner,
    address indexed spender,
    uint256 tokens
  );
}
