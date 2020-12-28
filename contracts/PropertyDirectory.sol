// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import {EnumerableSet} from "@openzeppelin/contracts/utils/EnumerableSet.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {
	IAddressConfig
} from "@devprotocol/protocol/contracts/interface/IAddressConfig.sol";
import {
	IPropertyGroup
} from "@devprotocol/protocol/contracts/interface/IPropertyGroup.sol";
import {
	UsingConfig
} from "@devprotocol/util-contracts/contracts/config/UsingConfig.sol";
import {Property} from "contracts/lib/Property.sol";
import {PropertyDirectoryStorage} from "contracts/PropertyDirectoryStorage.sol";
import {
	IPropertyDirectoryConfig
} from "contracts/config/IPropertyDirectoryConfig.sol";

contract PropertyDirectory is PropertyDirectoryStorage, UsingConfig {
	using SafeMath for uint256;
	using Property for address;
	using EnumerableSet for EnumerableSet.AddressSet;

	EnumerableSet.AddressSet private propertySet;
	uint256 private constant MAC_ASSOCIATE_COUNT = 9;

	constructor(address _config) UsingConfig(_config) {}

	modifier onlyFactory() {
		require(
			msg.sender ==
				IPropertyDirectoryConfig(configAddress()).getFactory(),
			"factory only."
		);
		_;
	}

	function associate(address _property, uint256 _amount) external {
		require(
			propertySet.length() < MAC_ASSOCIATE_COUNT,
			"over associate count"
		);
		validatePropertyAddress(_property);

		address token =
			IPropertyDirectoryConfig(configAddress()).getToken(address(this));
		IERC20 directoryToken = IERC20(token);
		uint256 transferdPropertyBalance =
			getTransferedProperty(_property, msg.sender);
		uint256 directoryTokenBalance = directoryToken.balanceOf(msg.sender);
		uint256 mulAmount = _property.mulAmount(_amount);
		require(
			transferdPropertyBalance + mulAmount < directoryTokenBalance,
			"directory token balance is low"
		);
		IERC20(_property).transferFrom(msg.sender, address(this), _amount);
		if (propertySet.contains(_property) == false) {
			propertySet.add(_property);
		}
		setTransferedProperty(
			_property,
			msg.sender,
			transferdPropertyBalance.add(mulAmount)
		);
	}

	function transferProperty(address nextPropertyDirectory)
		external
		onlyFactory
	{}

	// TODO governance
	function disassociate(
		address _recipient,
		address _property,
		uint256 _amount
	) external {
		validatePropertyAddress(_property);
		uint256 transferdPropertyBalance =
			getTransferedProperty(_property, msg.sender);
		uint256 mulAmount = _property.mulAmount(_amount);
		require(mulAmount <= transferdPropertyBalance, "amount is high");
		IERC20 property = IERC20(_property);
		property.transfer(_recipient, _amount);
		setTransferedProperty(
			_property,
			msg.sender,
			transferdPropertyBalance.sub(mulAmount)
		);
		if (property.balanceOf(address(this)) == 0) {
			propertySet.remove(_property);
		}
	}

	function validatePropertyAddress(address _property) private view {
		address protocolConfig =
			IPropertyDirectoryConfig(configAddress()).getProtocolConfig();
		IAddressConfig addressConfig = IAddressConfig(protocolConfig);
		IPropertyGroup propertyGroup =
			IPropertyGroup(addressConfig.propertyGroup());
		require(propertyGroup.isGroup(_property), "not property address");
	}
}
