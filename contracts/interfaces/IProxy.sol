// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IProxy {
    event TokenTransferFeeBurn(address, address, uint256);

    function VERSION() external returns (uint256);

    function owner() external returns (address);

    function invoke(
        address token,
        address replica,
        bytes calldata input
    ) external payable returns (bytes memory result);
}
