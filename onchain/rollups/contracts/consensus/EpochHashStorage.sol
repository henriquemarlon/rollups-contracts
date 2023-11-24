// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import {InputRange} from "../common/InputRange.sol";

/// @notice Stores epoch hashes for several DApps and input ranges.
/// @dev This contract was designed to be inherited by implementations of the `IConsensus` interface
/// for simple storage and retrieval of epoch hashes.
contract EpochHashStorage {
    /// @notice Indexes epoch hashes by DApp address, first input index and last input index.
    mapping(address => mapping(uint256 => mapping(uint256 => bytes32))) _epochHashes;

    /// @notice Get the epoch hash for a certain DApp and input range.
    /// @param dapp The DApp contract address
    /// @param r The input range
    /// @return epochHash The epoch hash
    /// @dev By default, returns `bytes32(0)`.
    function _getEpochHash(
        address dapp,
        InputRange calldata r
    ) internal view returns (bytes32 epochHash) {
        epochHash = _epochHashes[dapp][r.firstInputIndex][r.lastInputIndex];
    }

    /// @notice Set an epoch hash for a certain DApp and input range.
    /// @param dapp The DApp contract address
    /// @param r The input range
    /// @param epochHash The epoch hash
    /// @dev Reverts if `r.firstInputIndex > r.lastInputIndex`.
    function _setEpochHash(
        address dapp,
        InputRange calldata r,
        bytes32 epochHash
    ) internal {
        require(r.firstInputIndex <= r.lastInputIndex, "invalid input range");
        _epochHashes[dapp][r.firstInputIndex][r.lastInputIndex] = epochHash;
    }
}
