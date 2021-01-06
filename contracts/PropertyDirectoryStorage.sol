// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {UsingStorage} from "@devprotocol/util-contracts/contracts/storage/UsingStorage.sol";

contract PropertyDirectoryStorage is UsingStorage {
	// token
	function setToken(address _token) internal {
		eternalStorage().setAddress(getAddressKey(), _token);
	}

	function getToken() public view returns (address) {
		return eternalStorage().getAddress(getAddressKey());
	}

	function getAddressKey() private pure returns (bytes32) {
		return keccak256(abi.encodePacked("_address"));
	}

	// transferedProperty
	function setTransferedProperty(
		address _property,
		address _sender,
		uint256 _amount
	) internal {
		eternalStorage().setUint(
			getTransferedPropertyKey(_property, _sender),
			_amount
		);
	}

	function getTransferedProperty(address _property, address _sender)
		public
		view
		returns (uint256)
	{
		return
			eternalStorage().getUint(
				getTransferedPropertyKey(_property, _sender)
			);
	}

	function getTransferedPropertyKey(address _property, address _sender)
		private
		pure
		returns (bytes32)
	{
		return
			keccak256(
				abi.encodePacked("_transferedProperty", _property, _sender)
			);
	}
}
