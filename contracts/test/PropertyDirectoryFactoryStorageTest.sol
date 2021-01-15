// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {
	PropertyDirectoryFactoryStorage
} from "contracts/factory/PropertyDirectoryFactoryStorage.sol";

contract PropertyDirectoryFactoryStorageTest is
	PropertyDirectoryFactoryStorage
{
	function addPropertyDirectoryTest(address _propertyDirectory) external {
		addPropertyDirectory(_propertyDirectory);
	}

	function deletePropertyDirectoryTest(address _propertyDirectory) external {
		deletePropertyDirectory(_propertyDirectory);
	}
}
