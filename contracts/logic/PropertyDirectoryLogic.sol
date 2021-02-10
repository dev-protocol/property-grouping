// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
// prettier-ignore
import {IPropertyDirectoryToken} from "contracts/token/IPropertyDirectoryToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// prettier-ignore
import {IPropertyDirectoryLogic} from "contracts/logic/IPropertyDirectoryLogic.sol";
// prettier-ignore
import {UsingConfig} from "@devprotocol/util-contracts/contracts/config/UsingConfig.sol";
// prettier-ignore
import {IPropertyDirectoryConfig} from "contracts/config/IPropertyDirectoryConfig.sol";
// prettier-ignore
import {IAddressConfig} from "@devprotocol/protocol/contracts/interface/IAddressConfig.sol";
// prettier-ignore
import {IPropertyGroup} from "@devprotocol/protocol/contracts/interface/IPropertyGroup.sol";
// prettier-ignore
import {IWithdraw} from "@devprotocol/protocol/contracts/interface/IWithdraw.sol";

contract PropertyDirectoryLogic is IPropertyDirectoryLogic, UsingConfig {
	using SafeMath for uint256;

	constructor(address _config) UsingConfig(_config) {}

	function calculateAmount(
		uint256 _totalRewordAmount,
		uint256 _lastTotalReword,
		address _token,
		address _account
	) external view override returns (uint256) {
		uint256 decimals = IPropertyDirectoryToken(_token).tokenDecimals();
		IERC20 token = IERC20(_token);
		uint256 balance = token.balanceOf(_account);
		uint256 totalSupply = token.totalSupply();
		uint256 unitPrice =
			_totalRewordAmount.sub(_lastTotalReword).mul(decimals).div(
				totalSupply
			);
		uint256 value = unitPrice.mul(balance).div(decimals);
		return value;
	}

	function getDevTokenAddress() external view override returns (address) {
		address protocolConfig =
			IPropertyDirectoryConfig(configAddress()).getProtocolConfig();
		IAddressConfig addressConfig = IAddressConfig(protocolConfig);
		return addressConfig.token();
	}

	function validatePropertyAddress(address _property) external view override {
		address protocolConfig =
			IPropertyDirectoryConfig(configAddress()).getProtocolConfig();
		IAddressConfig addressConfig = IAddressConfig(protocolConfig);
		IPropertyGroup propertyGroup =
			IPropertyGroup(addressConfig.propertyGroup());
		require(propertyGroup.isGroup(_property), "not property address");
	}

	function getWithdrawAddress() external view override returns (address) {
		return getWithdraw();
	}

	function getWithdraw() private view returns (address) {
		address protocolConfig =
			IPropertyDirectoryConfig(configAddress()).getProtocolConfig();
		IAddressConfig addressConfig = IAddressConfig(protocolConfig);
		return addressConfig.withdraw();
	}

	function curretnRewardAmount(address[] memory properties)
		external
		view
		override
		returns (uint256)
	{
		address withdrawAddress = getWithdraw();
		IWithdraw withdrawContract = IWithdraw(withdrawAddress);
		uint256 amount;
		for (uint256 i = 0; i < properties.length; i++) {
			uint256 tmp =
				withdrawContract.calculateWithdrawableAmount(
					properties[i],
					address(this)
				);
			amount = amount.add(tmp);
		}
		return amount;
	}
}
