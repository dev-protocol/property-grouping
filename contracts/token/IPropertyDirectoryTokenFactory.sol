// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;


interface IPropertyDirectoryTokenFactory {
	function create(address _author, address _propertyDirectory, string memory _name, string memory _symbol) external returns (address);
}
