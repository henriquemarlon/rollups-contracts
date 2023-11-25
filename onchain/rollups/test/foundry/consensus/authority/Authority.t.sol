// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

/// @title Authority Test
pragma solidity ^0.8.8;

import {Vm} from "forge-std/Vm.sol";

import {Authority} from "contracts/consensus/authority/Authority.sol";
import {InputRange} from "contracts/common/InputRange.sol";

import {TestBase} from "../../util/TestBase.sol";

contract AuthorityTest is TestBase {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    event ClaimSubmission(
        address indexed submitter,
        address indexed dapp,
        InputRange inputRange,
        bytes32 epochHash
    );

    event ClaimAcceptance(
        address indexed dapp,
        InputRange inputRange,
        bytes32 epochHash
    );

    function testConstructor(address _owner) public {
        vm.assume(_owner != address(0));
        uint256 numOfEvents;

        // two `OwnershipTransferred` events might be emitted during the constructor call
        // the first event is emitted by Ownable constructor
        vm.expectEmit(true, true, false, false);
        emit OwnershipTransferred(address(0), address(this));
        ++numOfEvents;

        // a second event is emitted by Authority constructor iff msg.sender != _owner
        if (_owner != address(this)) {
            vm.expectEmit(true, true, false, false);
            emit OwnershipTransferred(address(this), _owner);
            ++numOfEvents;
        }

        vm.recordLogs();
        Authority authority = new Authority(_owner);
        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, numOfEvents, "number of events");
        assertEq(authority.owner(), _owner, "authority owner");
    }

    function testContructorRevertsOwnerAddressZero() public {
        vm.expectRevert("Ownable: new owner is the zero address");
        new Authority(address(0));
    }

    function testSubmitClaimRevertsCallerNotOwner(
        address _owner,
        address _notOwner,
        address _dapp,
        InputRange calldata _inputRange,
        bytes32 _epochHash
    ) public {
        vm.assume(_owner != address(0));
        vm.assume(_owner != _notOwner);

        Authority authority = new Authority(_owner);

        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(_notOwner);
        authority.submitClaim(_dapp, _inputRange, _epochHash);
    }

    function testSubmitClaim(
        address _owner,
        address _dapp,
        InputRange calldata _inputRange,
        bytes32 _epochHash
    ) public {
        vm.assume(_owner != address(0));
        vm.assume(_inputRange.firstInputIndex <= _inputRange.lastInputIndex);

        Authority authority = new Authority(_owner);

        vm.expectEmit(true, true, false, true, address(authority));
        emit ClaimSubmission(_owner, _dapp, _inputRange, _epochHash);

        vm.expectEmit(true, true, false, true, address(authority));
        emit ClaimAcceptance(_dapp, _inputRange, _epochHash);

        vm.prank(_owner);
        authority.submitClaim(_dapp, _inputRange, _epochHash);

        assertEq(authority.getEpochHash(_dapp, _inputRange), _epochHash);
    }
}
