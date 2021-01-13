// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {UsingConfig} from "@devprotocol/util-contracts/contracts/config/UsingConfig.sol";
// prettier-ignore
import {IPropertyDirectoryEvent} from "contracts/event/IPropertyDirectoryEvent.sol";
// prettier-ignore
import {IPropertyDirectoryFactory} from "contracts/factory/IPropertyDirectoryFactory.sol";
// prettier-ignore
import {IPropertyDirectoryConfig} from "contracts/config/IPropertyDirectoryConfig.sol";

contract PropertyDirectoryEvent is IPropertyDirectoryEvent, UsingConfig {
	event BeforeBalanceChange(
		address indexed _from,
		address _to,
		uint256 _amount
	);

	constructor(address _config) UsingConfig(_config) {}

	function beforeBalanceChange(
		address _from,
		address _to,
		uint256 _amount
	) external override {
		address factory = IPropertyDirectoryConfig(configAddress()).getFactory();
		require(
			IPropertyDirectoryFactory(factory).isPropertyDirectoryAddress(msg.sender),
			"illegal address."
		);
		emit BeforeBalanceChange(_from, _to, _amount);
	}
}
