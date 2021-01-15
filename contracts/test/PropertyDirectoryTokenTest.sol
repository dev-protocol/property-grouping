// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {PropertyDirectoryToken} from "contracts/token/PropertyDirectoryToken.sol";

contract PropertyDirectoryTokenTest {
	event BeforeBalanceChange(
		address indexed _from,
		address _to,
		uint256 _amount
	);
	address public token;

	function createToken(address _author) external {
		// TODO テスト
		PropertyDirectoryToken tmp =
			new PropertyDirectoryToken(_author, address(0), "test", "TEST");
		token = address(tmp);
	}

	function beforeBalanceChange(
		address _sender,
		address _recipient,
		uint256 _amount
	) external {
		emit BeforeBalanceChange(_sender, _recipient, _amount);
	}
}
