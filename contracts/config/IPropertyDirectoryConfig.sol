// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// interfaceとimportの清書
interface IPropertyDirectoryConfig {
	function setToken(address _propertyDirectory, address _token) external;

	function getToken(address _propertyDirectory) external returns (address);

	function getFactory() external returns (address);

	function getProtocolConfig() external view returns (address);
}
