// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {UsingStorage} from "@devprotocol/util-contracts/contracts/storage/UsingStorage.sol";

contract PropertyDirectoryFactoryStorage is UsingStorage {
	// propertyDirectory
	function savePropertyDirectory(address _propertyDirectory) internal {
		eternalStorage().setBool(
			getPropertyDirectoryKey(_propertyDirectory),
			true
		);
	}

	function isTransferedProperty(address _propertyDirectory)
		public
		view
		returns (bool)
	{
		return
			eternalStorage().getBool(
				getPropertyDirectoryKey(_propertyDirectory)
			);
	}

	function getPropertyDirectoryKey(address _propertyDirectory)
		private
		pure
		returns (bytes32)
	{
		return
			keccak256(
				abi.encodePacked("_propertyDirectory", _propertyDirectory)
			);
	}
}
