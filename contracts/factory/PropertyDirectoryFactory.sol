// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {
	UsingConfig
} from "@devprotocol/util-contracts/contracts/config/UsingConfig.sol";
import {
	IUsingStorage
} from "@devprotocol/util-contracts/contracts/storage/IUsingStorage.sol";
import {
	IPropertyDirectoryConfig
} from "contracts/config/IPropertyDirectoryConfig.sol";
import {PropertyDirectory} from "contracts/PropertyDirectory.sol";
import {
	PropertyDirectoryToken
} from "contracts/token/PropertyDirectoryToken.sol";

contract PropertyDirectoryFactory is UsingConfig {
	event Create(
		address indexed _propertyDirectory,
		address _sender,
		string _name,
		string _symbol
	);
	event ReCreate(address indexed _new, address _old);

	constructor(address _config) UsingConfig(_config) {}

	function create(string memory _name, string memory _symbol)
		external
		returns (address)
	{
		PropertyDirectory p = new PropertyDirectory(configAddress());
		p.createStorage();
		PropertyDirectoryToken token =
			new PropertyDirectoryToken(msg.sender, _name, _symbol);
		address diredtoryAddress = address(p);
		IPropertyDirectoryConfig(configAddress()).setToken(
			diredtoryAddress,
			address(token)
		);
		emit Create(diredtoryAddress, msg.sender, _name, _symbol);
		return diredtoryAddress;
	}

	function reCreate(address _directory) external returns (address) {
		address token =
			IPropertyDirectoryConfig(configAddress()).getToken(_directory);
		require(token != address(0), "illegal address.");
		IUsingStorage oldPropertyDirectory = IUsingStorage(_directory);
		PropertyDirectory p = new PropertyDirectory(configAddress());
		address newDiredtoryAddress = address(p);
		address storageAddress = oldPropertyDirectory.getStorageAddress();
		p.setStorage(storageAddress);
		oldPropertyDirectory.changeOwner(newDiredtoryAddress);
		IPropertyDirectoryConfig(configAddress()).setToken(
			newDiredtoryAddress,
			token
		);
		emit ReCreate(newDiredtoryAddress, _directory);
		return newDiredtoryAddress;
		// TODO propertyのtrasnfer機能をつける
	}
}
