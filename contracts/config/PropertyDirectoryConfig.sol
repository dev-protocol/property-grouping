// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

import {Config} from "@devprotocol/util-contracts/contracts/config/Config.sol";
// prettier-ignore
import {IPropertyDirectoryConfig} from "contracts/config/IPropertyDirectoryConfig.sol";

contract PrpertyDirectoryConfig is Config, IPropertyDirectoryConfig {
	function setFactory(address _factory) external {
		set("_factory", _factory);
	}

	function getFactory() external view override returns (address) {
		return get("_factory");
	}

	function setProtocolConfig(address _protocolConfig) external {
		set("_protocolConfig", _protocolConfig);
	}

	function getProtocolConfig() external view override returns (address) {
		return get("_protocolConfig");
	}

	function setEvent(address _event) external {
		set("_event", _event);
	}

	function getEvent() external view override returns (address) {
		return get("_event");
	}
}
