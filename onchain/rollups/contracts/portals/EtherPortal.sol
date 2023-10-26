// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import {IEtherPortal} from "./IEtherPortal.sol";
import {InputRelay} from "../inputs/InputRelay.sol";
import {IInputBox} from "../inputs/IInputBox.sol";
import {InputEncoding} from "../common/InputEncoding.sol";

import {Address} from "@openzeppelin/contracts/utils/Address.sol";

/// @title Ether Portal
///
/// @notice Manages Ether transfers to and from Cartesi DApps.
contract EtherPortal is InputRelay, IEtherPortal {
    using Address for address payable;

    mapping(address => uint256) public balanceOf;

    /// @notice Constructs the portal.
    /// @param _inputBox The input box used by the portal
    constructor(IInputBox _inputBox) InputRelay(_inputBox) {}

    function depositEther(
        address _dapp,
        bytes calldata _execLayerData
    ) external payable override {
        balanceOf[_dapp] += msg.value;

        addEtherDepositInput(_dapp, msg.value, _execLayerData);
    }

    function transfer(
        address _dapp,
        uint256 _value,
        bytes calldata _execLayerData
    ) external {
        balanceOf[msg.sender] -= _value;
        balanceOf[_dapp] += _value;

        addEtherDepositInput(_dapp, _value, _execLayerData);
    }

    function withdraw(address payable _recipient, uint256 _value) external {
        balanceOf[msg.sender] -= _value;

        _recipient.sendValue(_value);
    }

    function addEtherDepositInput(
        address _dapp,
        uint256 _value,
        bytes calldata _execLayerData
    ) internal {
        bytes memory input = InputEncoding.encodeEtherDeposit(
            msg.sender,
            _value,
            _execLayerData
        );

        inputBox.addInput(_dapp, input);
    }
}
