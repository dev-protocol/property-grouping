// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PropertyDirectoryToken is ERC20 {
	uint256 private constant SUPPLY = 10000000000000000000000000;
	constructor(address _author, string memory _name, string memory _symbol) ERC20(_name, _symbol) {
		_mint(_author, SUPPLY);
	}
}
