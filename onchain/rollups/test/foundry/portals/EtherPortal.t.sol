// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

/// @title Ether Portal Test
pragma solidity ^0.8.8;

import {Test} from "forge-std/Test.sol";
import {EtherPortal} from "contracts/portals/EtherPortal.sol";
import {IEtherPortal} from "contracts/portals/IEtherPortal.sol";
import {IInputBox} from "contracts/inputs/IInputBox.sol";
import {InputBox} from "contracts/inputs/InputBox.sol";
import {InputEncoding} from "contracts/common/InputEncoding.sol";

import {SimpleEtherReceiver} from "../util/SimpleEtherReceiver.sol";

contract EtherPortalTest is Test {
    IInputBox inputBox;
    IEtherPortal etherPortal;

    event InputAdded(
        address indexed dapp,
        uint256 indexed inputIndex,
        address sender,
        bytes input
    );

    function setUp() external {
        inputBox = new InputBox();
        etherPortal = new EtherPortal(inputBox);
    }

    function calculateTVL() internal view returns (uint256) {
        return address(etherPortal).balance;
    }

    function expectInputAdded(address _dapp, bytes memory _input) internal {
        uint256 inputIndex = inputBox.getNumberOfInputs(_dapp);
        vm.expectEmit(true, true, false, true, address(inputBox));
        emit InputAdded(_dapp, inputIndex, address(etherPortal), _input);
    }
}

contract CoreEtherPortalTest is EtherPortalTest {
    function testGetInputBox() external {
        assertEq(address(etherPortal.getInputBox()), address(inputBox));
    }

    function testBalanceOf(address _owner) external {
        assertEq(etherPortal.balanceOf(_owner), 0);
    }
}

contract DepositEtherPortalTest is EtherPortalTest {
    struct Context {
        address depositor;
        address receiver;
        uint256 value;
        bytes execLayerData;
    }

    struct Snapshot {
        uint256 tvl;
        uint256 receiverBalance;
        uint256 depositorBalance;
        uint256 numOfInputs;
    }

    function takeSnapshot(
        Context calldata _ctx
    ) internal returns (Snapshot memory) {
        return
            Snapshot({
                tvl: calculateTVL(),
                receiverBalance: etherPortal.balanceOf(_ctx.receiver),
                depositorBalance: _ctx.depositor.balance,
                numOfInputs: inputBox.getNumberOfInputs(_ctx.receiver)
            });
    }

    function testDepositEther(Context calldata _ctx) external {
        vm.assume(_ctx.depositor != address(etherPortal));
        vm.deal(_ctx.depositor, _ctx.value);

        Snapshot memory s1 = takeSnapshot(_ctx);

        bytes memory input = InputEncoding.encodeEtherDeposit(
            _ctx.depositor,
            _ctx.value,
            _ctx.execLayerData
        );

        expectInputAdded(_ctx.receiver, input);

        vm.prank(_ctx.depositor);
        etherPortal.depositEther{value: _ctx.value}(
            _ctx.receiver,
            _ctx.execLayerData
        );

        Snapshot memory s2 = takeSnapshot(_ctx);

        assertEq(s2.tvl, s1.tvl + _ctx.value);
        assertEq(s2.depositorBalance, s1.depositorBalance - _ctx.value);
        assertEq(s2.numOfInputs, s1.numOfInputs + 1);
        assertEq(s2.receiverBalance, s1.receiverBalance + _ctx.value);
    }
}
