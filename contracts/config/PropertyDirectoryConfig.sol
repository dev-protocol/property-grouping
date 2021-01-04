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
}
