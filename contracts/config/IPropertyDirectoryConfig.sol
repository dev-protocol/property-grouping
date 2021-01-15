// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

interface IPropertyDirectoryConfig {
	function getFactory() external view returns (address);

	function getProtocolConfig() external view returns (address);

	function getEvent() external view returns (address);

	function getTokenFactory() external view returns (address);

	function getLogic() external view returns (address);
}
