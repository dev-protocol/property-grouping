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

	// cumulativeRewordAmount
	function setCumulativeRewordAmount(uint256 _amount) internal {
		eternalStorage().setUint(getCumulativeRewordAmountKey(), _amount);
	}

	function getCumulativeRewordAmount() public view returns (uint256) {
		return eternalStorage().getUint(getCumulativeRewordAmountKey());
	}

	function getCumulativeRewordAmountKey() private pure returns (bytes32) {
		return keccak256(abi.encodePacked("_cumulativeRewordAmount"));
	}

	// lastTotalRewordAmount
	function setLastTotalRewordAmount(address _account, uint256 _amount)
		internal
	{
		eternalStorage().setUint(
			getLastTotalRewordAmountKey(_account),
			_amount
		);
	}

	function getLastTotalRewordAmount(address _account)
		public
		view
		returns (uint256)
	{
		return eternalStorage().getUint(getLastTotalRewordAmountKey(_account));
	}

	function getLastTotalRewordAmountKey(address _account)
		private
		pure
		returns (bytes32)
	{
		return keccak256(abi.encodePacked("_lastTotalRewordAmount", _account));
	}

	// pendingWithdrawal
	function setPendingWithdrawal(address _account, uint256 _amount) internal {
		eternalStorage().setUint(getPendingWithdrawalKey(_account), _amount);
	}

	function getPendingWithdrawal(address _account)
		public
		view
		returns (uint256)
	{
		return eternalStorage().getUint(getPendingWithdrawalKey(_account));
	}

	function getPendingWithdrawalKey(address _account)
		private
		pure
		returns (bytes32)
	{
		return keccak256(abi.encodePacked("_pendingWithdrawal", _account));
	}
}
