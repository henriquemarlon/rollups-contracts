// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import {Proof} from "../common/Proof.sol";

library LibProof {
    function getInputIndex(
        Proof calldata proof
    ) internal pure returns (uint256 inputIndex) {
        inputIndex =
            proof.inputRange.firstInputIndex +
            proof.validity.inputIndexWithinEpoch;
        require(
            inputIndex <= proof.inputRange.lastInputIndex,
            "input outside claimed range"
        );
        return inputIndex;
    }
}
