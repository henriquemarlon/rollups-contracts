// Copyright 2022 Cartesi Pte. Ltd.

// SPDX-License-Identifier: Apache-2.0
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use
// this file except in compliance with the License. You may obtain a copy of the
// License at http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/// @title Generic ERC20 Portal interface
pragma solidity >=0.7.0;

interface IERC20Portal {
    /// @notice deposit an amount of a generic ERC20 token in the portal and create tokens in L2
    /// @param _ERC20 address of the ERC20 token contract
    /// @param _amount amount of the ERC20 token to be deposited
    /// @param _data information to be interpreted by L2
    /// @return hash of input generated by deposit
    function erc20Deposit(
        address _ERC20,
        uint256 _amount,
        bytes calldata _data
    ) external returns (bytes32);

    /// @notice withdraw an amount of a generic ERC20 token from the portal
    /// @param _data data with withdrawal information
    /// @dev can only be called by the Rollups contract
    function erc20Withdrawal(bytes calldata _data) external returns (bool);

    /// @notice emitted on ERC20 deposited
    event ERC20Deposited(
        address ERC20,
        address sender,
        uint256 amount,
        bytes data
    );

    /// @notice emitted on ERC20 withdrawal
    event ERC20Withdrawn(
        address ERC20,
        address payable receiver,
        uint256 amount
    );
}
