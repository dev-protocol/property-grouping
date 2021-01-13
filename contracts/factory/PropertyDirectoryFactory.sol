// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {UsingConfig} from "@devprotocol/util-contracts/contracts/config/UsingConfig.sol";
import {PropertyDirectory} from "contracts/PropertyDirectory.sol";
// prettier-ignore
import {PropertyDirectoryFactoryStorage} from "contracts/factory/PropertyDirectoryFactoryStorage.sol";
// prettier-ignore
import {IPropertyDirectoryFactory} from "contracts/factory/IPropertyDirectoryFactory.sol";

contract PropertyDirectoryFactory is
	UsingConfig,
	PropertyDirectoryFactoryStorage,
	IPropertyDirectoryFactory
{
	event Create(
		address indexed _propertyDirectory,
		address _author,
		string _name,
		string _symbol
	);
	event Recreate(address indexed _old, address _new);

	constructor(address _config) UsingConfig(_config) {}

	function create(string memory _name, string memory _symbol)
		external
		override
		returns (address)
	{
		PropertyDirectory p = new PropertyDirectory(configAddress());
		p.createStorage();
		p.createToken(msg.sender, _name, _symbol);
		address diredtoryAddress = address(p);
		addPropertyDirectory(diredtoryAddress);
		emit Create(diredtoryAddress, msg.sender, _name, _symbol);
		return diredtoryAddress;
	}

	function recreate(address _directory) external override returns (address) {
		require(isPropertyDirectory(_directory), "illegal address.");
		PropertyDirectory oldPropertyDirectory = PropertyDirectory(_directory);
		PropertyDirectory newPropertyDirectory =
			new PropertyDirectory(configAddress());
		address newDiredtoryAddress = address(newPropertyDirectory);
		address storageAddress = oldPropertyDirectory.getStorageAddress();
		newPropertyDirectory.setStorage(storageAddress);
		oldPropertyDirectory.changeOwner(newDiredtoryAddress);
		newPropertyDirectory.setMyAddress();
		for (uint256 i = 0; i < oldPropertyDirectory.propertySetIndex(); i++) {
			address property = oldPropertyDirectory.propertySetAt(i);
			oldPropertyDirectory.transferProperty(
				property,
				newDiredtoryAddress
			);
			newPropertyDirectory.addPropertySet(property);
		}
		oldPropertyDirectory.pause();
		addPropertyDirectory(newDiredtoryAddress);
		deletePropertyDirectory(address(oldPropertyDirectory));
		emit Recreate(_directory, newDiredtoryAddress);
		return newDiredtoryAddress;
	}

	function isPropertyDirectoryAddress(address _directory)
		external
		view
		override
		returns (bool)
	{
		return isPropertyDirectory(_directory);
	}
}
