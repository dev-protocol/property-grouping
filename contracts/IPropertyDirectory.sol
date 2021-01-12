// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

interface IPropertyDirectory {
	function createToken(
		address _author,
		string memory _name,
		string memory _symbol
	) external;

	function setMyAddress() external;

	function pause() external;

	function takeRewordAmount() external;

	function associate(address _property, uint256 _amount) external;

	function beforeBalanceChange(
		address _from,
		address _to,
		uint256 _amount
	) external;

	function withdraw() external;

	function propertySetIndex() external view returns (uint256);

	function propertySetAt(uint256 _index) external view returns (address);

	function addPropertySet(address _property) external;

	function transferProperty(address _property, address _newPropertyDirectory)
		external;
}
