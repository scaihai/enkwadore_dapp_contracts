// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "../../../uniswap/ISwapRouter.sol";
import "./EnkwadoreWalletV1.sol";

contract EnkwadoreWallet_Uniswap_V1 is EnkwadoreWalletV1 {
    ISwapRouter public immutable swapRouter;
    uint24 public immutable fee;

    constructor(ISwapRouter _swapRouter, uint24 _fee) {
        swapRouter = _swapRouter;
        fee = _fee;
    }

    function swap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMinimum
    )
        external
        override
        onlyRole(BOT_ROLE)
        nonReentrant
        returns (uint256 amtOut)
    {
        TransferHelper.safeApprove(tokenIn, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                recipient: address(this),
                deadline: block.timestamp + 300, // 5 minutes
                amountIn: amountIn,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0 /* Calculate price limit */
            });

        uint256 amountOut = swapRouter.exactInputSingle(params);

        require(amountOut >= amountOutMinimum, "Slippage too high");
        emit Swap(tokenIn, tokenOut, amountIn, amountOut);
        return amountOut;
    }
}
