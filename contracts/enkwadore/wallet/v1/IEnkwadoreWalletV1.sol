// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

interface IEnkwadoreWalletV1 {
    function swap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMinimum
    ) external returns (uint256 amtOut);
    function withdraw(address tokenAddress, uint256 _amount) external;
    function withdrawNativeToken(uint256 _amount) external;
}
