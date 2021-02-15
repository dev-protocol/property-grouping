// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

contract WithdrawTest {
	function calculateWithdrawableAmount(address _property, address)
		external
		view
		returns (uint256)
	{
		if (_property == 0x1dCb85efEa6A3FB528d19B9174E88ee35BfF540a) {
			return 100000000000000000000;
		}
		if (_property == 0x2c2807A0Eb5Fd0DFaC8A93A2c9D788154a17B369) {
			return 200000000000000000000;
		}
		return 0;
	}
}
