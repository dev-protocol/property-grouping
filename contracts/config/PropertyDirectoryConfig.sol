// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {Config} from "@devprotocol/util-contracts/contracts/config/Config.sol";


contract PrpertyDirectoryConfig is Config {
	function setFactory(address _factory) external {
		set("_factory", _factory);
	}

	function getFactory() external view returns (address) {
		return get("_factory");
	}

	function setProtocolConfig(address _protocolConfig) external {
		set("_protocolConfig", _protocolConfig);
	}

	function getProtocolConfig() external view returns (address) {
		return get("_protocolConfig");
	}

	function setToken(address _propertyDirectory, address _token) external {
		setByteKey(getTokenKey(_propertyDirectory), _token);
	}

	function getToken(address _propertyDirectory) external view returns (address) {
		return getByteKey(getTokenKey(_propertyDirectory));
	}

	function getTokenKey(address _propertyDirectory)
		private
		pure
		returns (bytes32)
	{
		return keccak256(abi.encodePacked("_token", _propertyDirectory));
	}
}
