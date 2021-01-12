// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// TODO interfaceの整理
interface IPropertyDirectory {
	function beforeBalanceChange(
		address _from,
		address _to,
		uint256 _amount
	) external;
}
