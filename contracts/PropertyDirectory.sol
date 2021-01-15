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
import {IWithdraw} from "@devprotocol/protocol/contracts/interface/IWithdraw.sol";
import {Property} from "contracts/lib/Property.sol";
import {PropertyDirectoryStorage} from "contracts/PropertyDirectoryStorage.sol";
import {IPropertyDirectory} from "contracts/IPropertyDirectory.sol";
// prettier-ignore
import {IPropertyDirectoryConfig} from "contracts/config/IPropertyDirectoryConfig.sol";
// prettier-ignore
import {IPropertyDirectoryTokenFactory} from "contracts/token/IPropertyDirectoryTokenFactory.sol";
// prettier-ignore
import {IPropertyDirectoryEvent} from "contracts/event/IPropertyDirectoryEvent.sol";
// prettier-ignore
import {IPropertyDirectoryToken} from "contracts/token/IPropertyDirectoryToken.sol";
// prettier-ignore
import {IPropertyDirectoryLogic} from "contracts/logic/IPropertyDirectoryLogic.sol";

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
		address _author,
		string memory _name,
		string memory _symbol
	) external override onlyFactory {
		address tokenFactory =
			IPropertyDirectoryConfig(configAddress()).getTokenFactory();
		address token =
			IPropertyDirectoryTokenFactory(tokenFactory).create(
				_author,
				address(this),
				_name,
				_symbol
			);
		setToken(token);
	}

	function setMyAddress() external override onlyFactory {
		address token = getToken();
		IPropertyDirectoryToken(token).setPropertyDirectoryAddress(
			address(this)
		);
	}

	function pause() external override onlyFactory {
		_pause();
	}

	function associate(address _property, uint256 _amount)
		external
		override
		whenNotPaused
	{
		require(
			propertySet.length() < MAC_ASSOCIATE_COUNT,
			"over associate count"
		);
		getLogic().validatePropertyAddress(_property);

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
	// function disassociate(
	// 	address _recipient,
	// 	address _property,
	// 	uint256 _amount
	// ) external whenNotPaused {
	// 	validatePropertyAddress(_property);
	// 	uint256 transferdPropertyBalance =
	// 		getTransferedProperty(_property, msg.sender);
	// 	uint256 mulAmount = _property.mulAmount(_amount);
	// 	require(mulAmount <= transferdPropertyBalance, "amount is high");
	// 	IERC20 property = IERC20(_property);
	// 	require(property.transfer(_recipient, _amount), "transfer is fail");
	// 	setTransferedProperty(
	// 		_property,
	// 		msg.sender,
	// 		transferdPropertyBalance.sub(mulAmount)
	// 	);
	// 	if (property.balanceOf(address(this)) == 0) {
	// 		propertySet.remove(_property);
	// 	}
	// }

	function takeRewordAmount() external override whenNotPaused {
		address[] memory properties = convertToArray();
		address withdrawAddress = getLogic().getWithdrawAddress();
		uint256 minted = IWithdraw(withdrawAddress).bulkWithdraw(properties);
		require(minted != 0, "token is not mint");
		setCumulativeRewordAmount(minted.add(getCumulativeRewordAmount()));
	}

	function convertToArray() private view returns (address[] memory) {
		address[] memory properties;
		for (uint256 i = 0; i < propertySet.length(); i++) {
			properties[i] = propertySet.at(i);
		}
		return properties;
	}

	function beforeBalanceChange(
		address _from,
		address _to,
		uint256 _amount
	) external override whenNotPaused {
		require(msg.sender == getToken(), "illegal access");
		address eventAddress =
			IPropertyDirectoryConfig(configAddress()).getEvent();
		IPropertyDirectoryEvent(eventAddress).beforeBalanceChange(
			_from,
			_to,
			_amount
		);
		address[] memory properties = convertToArray();
		uint256 curretnRewardAmount =
			getLogic().curretnRewardAmount(properties);
		uint256 totalRewordAmount =
			curretnRewardAmount.add(getCumulativeRewordAmount());
		if (totalRewordAmount == 0) {
			return;
		}
		setPendingWithdrawalValue(totalRewordAmount, _from);
		setPendingWithdrawalValue(totalRewordAmount, _to);
	}

	function setPendingWithdrawalValue(
		uint256 _totalRewordAmount,
		address _account
	) private {
		setPendingWithdrawal(
			_account,
			getPendingWithdrawal(_account).add(
				calculateAmount(_totalRewordAmount, _account)
			)
		);
	}

	function withdraw() external override whenNotPaused {
		IERC20 token = IERC20(getToken());
		uint256 balance = token.balanceOf(msg.sender);
		require(balance != 0, "you do not execute withdraw");
		IPropertyDirectoryLogic logic = getLogic();
		address[] memory properties = convertToArray();
		uint256 curretnRewardAmount = logic.curretnRewardAmount(properties);
		uint256 totalRewordAmount =
			curretnRewardAmount.add(getCumulativeRewordAmount());
		uint256 value = calculateAmount(totalRewordAmount, msg.sender);
		address dev = logic.getDevTokenAddress();
		require(
			IERC20(dev).transfer(
				msg.sender,
				getPendingWithdrawal(msg.sender).add(value)
			),
			"transfer is failed"
		);
		setPendingWithdrawal(msg.sender, 0);
	}

	function calculateAmount(uint256 _totalRewordAmount, address _account)
		private
		returns (uint256)
	{
		uint256 lastTotalReword = getLastTotalRewordAmount(_account);
		address token = getToken();
		uint256 value =
			getLogic().calculateAmount(
				_totalRewordAmount,
				lastTotalReword,
				token,
				_account
			);
		setLastTotalRewordAmount(_account, _totalRewordAmount);
		return value;
	}

	function propertySetIndex() external view override returns (uint256) {
		return propertySet.length();
	}

	function propertySetAt(uint256 _index)
		external
		view
		override
		returns (address)
	{
		return propertySet.at(_index);
	}

	function addPropertySet(address _property) external override onlyFactory {
		propertySet.add(_property);
	}

	// TODO 去り際にDEVをwithdrawして、それも一緒に転送しなければいけない
	function transferProperty(address _property, address _newPropertyDirectory)
		external
		override
		onlyFactory
	{
		IERC20 iProperty = IERC20(_property);
		uint256 balance = iProperty.balanceOf(address(this));
		require(
			iProperty.transfer(_newPropertyDirectory, balance),
			"transer is fail"
		);
	}

	function getLogic() private view returns (IPropertyDirectoryLogic) {
		address logic = IPropertyDirectoryConfig(configAddress()).getLogic();
		return IPropertyDirectoryLogic(logic);
	}
}

//TODO
// TODO 去り際にDEVをwithdrawして、それも一緒に転送しなければいけない
// コントラクトの分離
// 特にロジック、ライブラリ、実態を分離していく
