// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// interfaceとimportの清書
interface IPropertyDirectoryConfig {
	function getFactory() external returns (address);

	function getProtocolConfig() external view returns (address);

	function getEvent() external view returns (address);
}
