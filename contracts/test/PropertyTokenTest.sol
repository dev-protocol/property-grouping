// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PropertyTokenTest is ERC20 {
	constructor(uint256 _supply) ERC20("test", "TEST") {
		_mint(msg.sender, _supply);
	}
}
