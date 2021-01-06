// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IPropertyDirectory} from "contracts/IPropertyDirectory.sol";

contract PropertyDirectoryToken is ERC20 {
	uint256 private constant SUPPLY = 10000000000000000000000000;
	address private propertyDirectory;

	constructor(
		address _author,
		string memory _name,
		string memory _symbol
	) ERC20(_name, _symbol) {
		_mint(_author, SUPPLY);
		propertyDirectory = msg.sender;
	}

	function setPropertyDirectoryAddress(address _propertyDirectory) external {
		require(msg.sender == propertyDirectory, "illegal access");
		propertyDirectory = _propertyDirectory;
	}

	function transfer(address _recipient, uint256 _amount)
		public
		override
		returns (bool)
	{
		IPropertyDirectory(propertyDirectory).beforeBalanceChange(
			msg.sender,
			_recipient,
			_amount
		);
		return ERC20.transfer(_recipient, _amount);
	}

	function transferFrom(
		address _sender,
		address _recipient,
		uint256 _amount
	) public override returns (bool) {
		IPropertyDirectory(propertyDirectory).beforeBalanceChange(
			msg.sender,
			_recipient,
			_amount
		);
		return ERC20.transferFrom(_sender, _recipient, _amount);
	}
}
