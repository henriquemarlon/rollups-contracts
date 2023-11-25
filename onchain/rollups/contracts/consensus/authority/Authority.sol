// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IConsensus} from "../IConsensus.sol";
import {AbstractConsensus} from "../AbstractConsensus.sol";
import {InputRange} from "../../common/InputRange.sol";

/// @notice A consensus contract controlled by a single address, the owner.
/// @dev This contract inherits from OpenZeppelin's `Ownable` contract.
///      For more information on `Ownable`, please consult OpenZeppelin's official documentation.
contract Authority is AbstractConsensus, Ownable {
    /// @notice Constructs an `Authority` contract.
    /// @param _owner The initial contract owner
    constructor(address _owner) {
        // constructor in Ownable already called `transferOwnership(msg.sender)`, so
        // we only need to call `transferOwnership(_owner)` if _owner != msg.sender
        if (msg.sender != _owner) {
            transferOwnership(_owner);
        }
    }

    function submitClaim(
        address _dapp,
        InputRange calldata _inputRange,
        bytes32 _epochHash
    ) external override onlyOwner {
        _setEpochHash(_dapp, _inputRange, _epochHash);
        emit ClaimSubmission(msg.sender, _dapp, _inputRange, _epochHash);
        emit ClaimAcceptance(_dapp, _inputRange, _epochHash);
    }
}
