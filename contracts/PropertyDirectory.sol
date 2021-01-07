// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import {EnumerableSet} from "@openzeppelin/contracts/utils/EnumerableSet.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// prettier-ignore
import {UsingConfig} from "@devprotocol/util-contracts/contracts/config/UsingConfig.sol";
// prettier-ignore
import {IAddressConfig} from "@devprotocol/protocol/contracts/interface/IAddressConfig.sol";
// prettier-ignore
import {IPropertyGroup} from "@devprotocol/protocol/contracts/interface/IPropertyGroup.sol";
import {
	IWithdraw
} from "@devprotocol/protocol/contracts/interface/IWithdraw.sol";
import {Property} from "contracts/lib/Property.sol";
import {PropertyDirectoryStorage} from "contracts/PropertyDirectoryStorage.sol";
import {IPropertyDirectory} from "contracts/IPropertyDirectory.sol";
// prettier-ignore
import {IPropertyDirectoryConfig} from "contracts/config/IPropertyDirectoryConfig.sol";
// prettier-ignore
import {PropertyDirectoryToken} from "contracts/token/PropertyDirectoryToken.sol";

contract PropertyDirectory is
	Pausable,
	PropertyDirectoryStorage,
	UsingConfig,
	IPropertyDirectory
{
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

	function createToken(
		address _sender,
		string memory _name,
		string memory _symbol
	) external onlyFactory {
		PropertyDirectoryToken token =
			new PropertyDirectoryToken(_sender, _name, _symbol);
		token.setPropertyDirectoryAddress(address(this));
		setToken(address(token));
	}

	function setMyAddress() external onlyFactory {
		address token = getToken();
		PropertyDirectoryToken(token).setPropertyDirectoryAddress(
			address(this)
		);
	}

	function pause() external onlyFactory {
		_pause();
	}

	function associate(address _property, uint256 _amount)
		external
		whenNotPaused
	{
		require(
			propertySet.length() < MAC_ASSOCIATE_COUNT,
			"over associate count"
		);
		validatePropertyAddress(_property);

		address token = getToken();
		IERC20 directoryToken = IERC20(token);
		uint256 transferdPropertyBalance =
			getTransferedProperty(_property, msg.sender);
		uint256 directoryTokenBalance = directoryToken.balanceOf(msg.sender);
		uint256 mulAmount = _property.mulAmount(_amount);
		require(
			transferdPropertyBalance + mulAmount < directoryTokenBalance,
			"directory token balance is low"
		);
		require(
			IERC20(_property).transferFrom(msg.sender, address(this), _amount),
			"transfer is fail"
		);
		if (propertySet.contains(_property) == false) {
			propertySet.add(_property);
		}
		setTransferedProperty(
			_property,
			msg.sender,
			transferdPropertyBalance.add(mulAmount)
		);
	}

	// TODO governance
	function disassociate(
		address _recipient,
		address _property,
		uint256 _amount
	) external whenNotPaused {
		validatePropertyAddress(_property);
		uint256 transferdPropertyBalance =
			getTransferedProperty(_property, msg.sender);
		uint256 mulAmount = _property.mulAmount(_amount);
		require(mulAmount <= transferdPropertyBalance, "amount is high");
		IERC20 property = IERC20(_property);
		require(property.transfer(_recipient, _amount), "transfer is fail");
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

	function withdraw() external {
		address[] properties;
		for (uint256 i = 0; i < propertySet.length(); i++) {
			properties.push(propertySet.at(i));
		}
		address protocolConfig =
			IPropertyDirectoryConfig(configAddress()).getProtocolConfig();
		IAddressConfig addressConfig = IAddressConfig(protocolConfig);
		IWithdraw(addressConfig.withdraw()).bulkWithdraw(properties);
	}

	function withdrawableAmount() external view returns (uint256) {
		address protocolConfig =
			IPropertyDirectoryConfig(configAddress()).getProtocolConfig();
		IAddressConfig addressConfig = IAddressConfig(protocolConfig);
		IWithdraw withdraw = IWithdraw(addressConfig.withdraw());
		uint256 amount;
		for (uint256 i = 0; i < propertySet.length(); i++) {
			uint256 tmp =
				withdraw.calculateWithdrawableAmount(
					propertySet.at(i),
					address(this)
				);
			amount = amount.add(tmp);
		}
		return amount;
	}

	function beforeBalanceChange(
		address _from,
		address _to,
		uint256 _amount
	) external override {
		require(msg.sender == getToken(), "illegal access");
		// TODO 実装
		require(_from == address(0), "not property address");
		require(_to == address(0), "not property address");
		require(_amount == address(0), "not property address");
		// 転送
		// Directory Tokensを転送する際に、転送元と転送先のdrawableリワードを更新するフックです。Withdraw.beforeBalanceChangeがリファレンスモデルです
	}

	function propertySetIndex() external view returns (uint256) {
		return propertySet.length();
	}

	function propertySetAt(uint256 _index) external view returns (address) {
		return propertySet.at(_index);
	}

	function addPropertySet(address _property) external onlyFactory {
		propertySet.add(_property);
	}

	function transferProperty(address _property, address _newPropertyDirectory)
		external
		onlyFactory
	{
		IERC20 iProperty = IERC20(_property);
		uint256 balance = iProperty.balanceOf(address(this));
		require(
			iProperty.transfer(_newPropertyDirectory, balance),
			"transer is fail"
		);
	}
}
