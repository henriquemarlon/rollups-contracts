// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

/// @title Inputs
/// @notice Defines the signatures of inputs.
interface Inputs {
    /// @notice An advance request from an EVM-compatible blockchain to a Cartesi Machine.
    /// @param sender The address of whoever sent the input
    /// @param blockNumber The number of the block in which the input was added
    /// @param blockTimestamp The timestamp of the block in which the input was added
    /// @param inputIndex The index of the input in the DApp's input box
    /// @param input The payload provided by the sender
    function EvmAdvance(
        address sender,
        uint256 blockNumber,
        uint256 blockTimestamp,
        uint256 inputIndex,
        bytes calldata input
    ) external;

    /// @notice An inspect request to a Cartesi Machine.
    /// @param payload The inspect payload
    function EvmInspect(bytes calldata payload) external;
}
