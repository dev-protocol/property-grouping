// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

contract AddressConfigTest {
	address public withdraw;
	address public token;
	address public propertyGroup;

	function setWithdraw(address _withdraw) external {
		withdraw = _withdraw;
	}

	function setToken(address _token) external {
		token = _token;
	}

	function setPropertyGroup(address _propertyGroup) external {
		propertyGroup = _propertyGroup;
	}
}
