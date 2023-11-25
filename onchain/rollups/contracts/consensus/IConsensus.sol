// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import {InputRange} from "../common/InputRange.sol";

/// @notice Provides epoch hashes for DApps.
/// @notice An epoch hash is produced after the machine processes a range of inputs and the epoch is finalized.
/// This hash serves as proof for the outputs produced by the machine during the epoch.
/// @notice Empty input ranges are not accepted, since at least one input is necessary to advance the state of the machine.
/// @notice Validators may synchronize epoch finalization, but such mechanism is not specified by this interface.
/// @notice Regardless of synchronization or the lack thereof,
/// validators shouldn't need to submit a claim if it was already submitted by them or accepted by the consensus.
/// These conditions can be checked prior to submitting a claim by listening to the events specified by this interface.
/// @notice The acceptance criteria for claims may depend on the type of consensus, and is not transparent through this interface.
/// For example, a claim may be accepted if it was...
/// - submitted by an authority or;
/// - submitted by the majority of a quorum or;
/// - submitted and not proven wrong after some period of time.
interface IConsensus {
    /// @notice A claim was submitted to the consensus.
    /// @param submitter The submitter address
    /// @param dapp The DApp contract address
    /// @param inputRange The input range
    /// @param epochHash The epoch hash
    /// @dev The input range MUST NOT be empty.
    /// @dev Overwrites any previous `ClaimSubmission(submitter, dapp, inputRange, _)`.
    event ClaimSubmission(
        address indexed submitter,
        address indexed dapp,
        InputRange inputRange,
        bytes32 epochHash
    );

    /// @notice A claim was accepted by the consensus.
    /// @param dapp The DApp contract address
    /// @param inputRange The input range
    /// @param epochHash The epoch hash
    /// @dev The input range MUST NOT be empty.
    /// @dev Overwrites any previous `ClaimAcceptance(dapp, inputRange, _)`.
    /// @dev MUST be triggered whenever `getEpochHash(dapp, inputRange)` changes to `epochHash`.
    /// @dev MUST be triggered after some `ClaimSubmission(_, dapp, inputRange, epochHash)`.
    event ClaimAcceptance(
        address indexed dapp,
        InputRange inputRange,
        bytes32 epochHash
    );

    /// @notice Submit a claim to the consensus.
    /// @param dapp The DApp contract address
    /// @param inputRange The input range
    /// @param epochHash The epoch hash
    /// @dev MUST trigger a `ClaimSubmission` event.
    function submitClaim(
        address dapp,
        InputRange calldata inputRange,
        bytes32 epochHash
    ) external;

    /// @notice Get the epoch hash for a certain DApp and input range.
    /// @param dapp The DApp contract address
    /// @param inputRange The input range
    /// @return epochHash The epoch hash
    /// @dev For unclaimed epochs and empty input ranges, MUST either revert or return `bytes32(0)`.
    function getEpochHash(
        address dapp,
        InputRange calldata inputRange
    ) external view returns (bytes32 epochHash);
}
