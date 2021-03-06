// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./interfaces/IReplica.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IProxyV0.sol";

contract ProxyV0 is IProxyV0 {
    uint256 public constant override VERSION = 0;

    address public override owner;

    modifier OnlyOwner {
        require(msg.sender == owner, "403");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function transferEther(address receiver, Payment[] calldata payments)
        external
        override
        OnlyOwner
    {
        for (uint256 i = 0; i < payments.length; i++) {
            Payment calldata payment = payments[i];
            IReplica(payment.replica).invoke(
                receiver,
                payment.value,
                new bytes(0)
            );
        }
    }

    function transferERC20Token(
        address token,
        address receiver,
        bool checkres,
        Payment[] calldata payments
    ) external override OnlyOwner {
        for (uint256 i = 0; i < payments.length; i++) {
            Payment calldata payment = payments[i];
            bytes memory input =
                abi.encodeWithSelector(
                    IERC20.transfer.selector,
                    receiver,
                    payment.value
                );
            bytes memory result =
                IReplica(payment.replica).invoke(token, 0, input);
            if (checkres) {
                require(
                    (result.length == 0 || abi.decode(result, (bool))),
                    "ERC20_TRANSFER_FAILED"
                );
            }
        }
    }

    function transferFeeBurnERC20Token(
        address token,
        address replica,
        address receiver,
        uint256 value
    ) external override OnlyOwner {
        uint256 balanceAtFirst = IERC20(token).balanceOf(receiver);
        bytes memory input =
            abi.encodeWithSelector(IERC20.transfer.selector, receiver, value);
        bytes memory result = IReplica(replica).invoke(token, 0, input);
        require(
            (result.length == 0 || abi.decode(result, (bool))),
            "ERC20_TRANSFER_FAILED"
        );
        uint256 balanceAtLast = IERC20(token).balanceOf(receiver);
        uint256 feeBurndAmount = balanceAtFirst + value - balanceAtLast;
        if (feeBurndAmount > 0) {
            emit TokenTransferFeeBurn(token, receiver, feeBurndAmount);
        }
    }

    function invoke(
        address token,
        address replica,
        bytes calldata input
    ) external payable override OnlyOwner returns (bytes memory result) {
        return IReplica(replica).invoke(token, msg.value, input);
    }
}
