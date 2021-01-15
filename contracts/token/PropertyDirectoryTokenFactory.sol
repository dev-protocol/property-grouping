// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

// prettier-ignore
import {PropertyDirectoryToken} from "contracts/token/PropertyDirectoryToken.sol";

contract PropertyDirectoryTokenFactory {
	function create(address _author, address _propertyDirectory, string memory _name, string memory _symbol) external returns (address){
		PropertyDirectoryToken token = new PropertyDirectoryToken(_author, _propertyDirectory, _name, _symbol);
		return address(token);
	}
}
