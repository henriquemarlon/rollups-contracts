// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import {IConsensus} from "./IConsensus.sol";
import {EpochHashStorage} from "./EpochHashStorage.sol";
import {InputRange} from "../common/InputRange.sol";

/// @title Abstract Consensus
/// @notice An abstract contract that partially implements `IConsensus`.
abstract contract AbstractConsensus is IConsensus, EpochHashStorage {
    /// @notice Get the epoch hash for a certain DApp and input range.
    /// @param dapp The DApp contract address
    /// @param inputRange The input range
    /// @return epochHash The epoch hash
    /// @dev For unclaimed epochs, returns `bytes32(0)`.
    function getEpochHash(
        address dapp,
        InputRange calldata inputRange
    ) external view override returns (bytes32 epochHash) {
        epochHash = _getEpochHash(dapp, inputRange);
    }
}
