// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {Property} from "contracts/lib/Property.sol";

contract PropertyTest {
	using Property for address;
	address private property;

	function set(address _property) external {
		property = _property;
	}

	function mulAmount(uint256 _amount) external view returns (uint256) {
		return property.mulAmount(_amount);
	}
}
