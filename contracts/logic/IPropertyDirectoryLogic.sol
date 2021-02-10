// SPDX-License-Identifier: MPL-2.0
pragma solidity 0.7.6;

interface IPropertyDirectoryLogic {
	function calculateAmount(
		uint256 _totalRewordAmount,
		uint256 _lastTotalReword,
		address _token,
		address _account
	) external view returns (uint256);

	function getDevTokenAddress() external view returns (address);

	function getWithdrawAddress() external view returns (address);

	function validatePropertyAddress(address _property) external view;

	function curretnRewardAmount(address[] memory properties)
		external
		view
		returns (uint256);
}
