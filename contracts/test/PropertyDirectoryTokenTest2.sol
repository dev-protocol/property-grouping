// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

contract PropertyDirectoryTokenTest2 {
	event BeforeBalanceChange(
		address indexed _from,
		address _to,
		uint256 _amount
	);

	function beforeBalanceChange(
		address _sender,
		address _recipient,
		uint256 _amount
	) external {
		emit BeforeBalanceChange(_sender, _recipient, _amount);
	}
}
