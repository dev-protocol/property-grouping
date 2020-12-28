// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library Property {
	using SafeMath for uint256;
	uint120 private constant CURRENT_SUPPLY = 10000000000000000000000000;
	uint120 private constant OLD_SUPPLY = 10000000;
	uint120 private constant BASIS_VALUE = 1000000000000000000;

	function mulAmount(address _property, uint256 _amount)
		internal
		view
		returns (uint256)
	{
		IERC20 property = IERC20(_property);
		if(property.totalSupply() == CURRENT_SUPPLY) {
			return _amount;
		}
		require(property.totalSupply() == OLD_SUPPLY, "liiegal address");
		return _amount.mul(BASIS_VALUE);
	}
	function divAmount(address _property, uint256 _amount)
		internal
		view
		returns (uint256)
	{
		IERC20 property = IERC20(_property);
		if(property.totalSupply() == CURRENT_SUPPLY) {
			return _amount;
		}
		require(property.totalSupply() == OLD_SUPPLY, "liiegal address");
		return _amount.div(BASIS_VALUE);
	}
}
