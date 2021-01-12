// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {IPropertyDirectoryEvent} from "contracts/event/IPropertyDirectoryEvent.sol";

contract PropertyDirectoryEvent is IPropertyDirectoryEvent{
	event BeforeBalanceChange(
		address indexed _from,
		address _to,
		uint256 _amount
	);

	function beforeBalanceChange(address _from, address _to, uint256 _amount)
		override external
	{
		emit BeforeBalanceChange(_from, _to, _amount);
	}
}
