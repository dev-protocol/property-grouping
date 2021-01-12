// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

interface IPropertyDirectoryEvent {
	function beforeBalanceChange(address _from, address _to, uint256 _amount) external;
}
