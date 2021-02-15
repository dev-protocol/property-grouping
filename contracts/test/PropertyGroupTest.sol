// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

contract PropertyGroupTest
{
	mapping(address => bool) private map;

	function isGroup(address _property) external view returns (bool){
		return map[_property];
	}

	function addGroup(address _property) external {
		map[_property] = true;
	}
}
