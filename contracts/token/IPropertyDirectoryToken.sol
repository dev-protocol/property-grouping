// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

interface IPropertyDirectoryToken {
	function setPropertyDirectoryAddress(address _propertyDirectory) external;

	function tokenDecimals() external view returns (uint8);
}
