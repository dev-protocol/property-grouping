// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

interface IPropertyDirectoryFactory {
	function create(string memory _name, string memory _symbol)
		external
		returns (address);

	function recreate(address _directory) external returns (address);

	function isPropertyDirectoryAddress(address _directory) external view returns (bool);
}
