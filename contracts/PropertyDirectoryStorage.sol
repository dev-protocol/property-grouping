// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {UsingStorage} from "@devprotocol/util-contracts/contracts/storage/UsingStorage.sol";

contract PropertyDirectoryStorage is UsingStorage {
	// function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
	// 	bytesStorage[_key] = _value;
	// }

	// propertySet
	// function setPropertySet(bytes32 _propertySet)
	// 	internal
	// {
	// 	eternalStorage().setBytes(getPropertySetKey(), _propertySet);
	// }

	// function getPropertySet()
	// 	public
	// 	view
	// 	returns (bytes32)
	// {
	// 	return eternalStorage().getBytes(getPropertySetKey());
	// }

	// function getPropertySetKey()
	// 	private
	// 	pure
	// 	returns (bytes32)
	// {
	// 	return keccak256(abi.encodePacked("_propertySet"));
	// }

	// // associateCount
	// function setAssociateCount(uint256 _count)
	// 	internal
	// {
	// 	eternalStorage().setUint(getAssociateCountKey(), _count);
	// }

	// function getAssociateCount()
	// 	public
	// 	view
	// 	returns (uint256)
	// {
	// 	return eternalStorage().getUint(getAssociateCountKey());
	// }

	// function getAssociateCountKey()
	// 	private
	// 	pure
	// 	returns (bytes32)
	// {
	// 	return keccak256(abi.encodePacked("_associateCount"));
	// }

	// // associateProperty
	// function setAssociateProperty(address _property, bool _added)
	// 	internal
	// {
	// 	eternalStorage().setBool(getAssociatePropertyKey(_property), _added);
	// }

	// function isAssociateProperty(address _property)
	// 	public
	// 	view
	// 	returns (bool)
	// {
	// 	return eternalStorage().getBool(getAssociatePropertyKey(_property));
	// }

	// function getAssociatePropertyKey(address _property)
	// 	private
	// 	pure
	// 	returns (bytes32)
	// {
	// 	return keccak256(abi.encodePacked("_associateProperty", _property));
	// }

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
