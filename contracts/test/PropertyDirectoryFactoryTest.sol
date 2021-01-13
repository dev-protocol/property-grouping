// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

contract PropertyDirectoryFactoryTest {
	bool private value;
	function setValue(bool _value) external {
		value = _value;
	}

	function isPropertyDirectoryAddress(address) external view returns (bool) {
		return value;
	}
}
