// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "../../../openzeppelin-contracts/access/AccessControl.sol";
import "../../../openzeppelin-contracts/utils/Pausable.sol";
import "../../../openzeppelin-contracts/token/ERC20/IERC20.sol";
import "../../../openzeppelin-contracts/utils/ReentrancyGuard.sol";
import "../../../uniswap/TransferHelper.sol";
import "./IEnkwadoreWalletV1.sol";

abstract contract EnkwadoreWalletV1 is
    Pausable,
    AccessControl,
    ReentrancyGuard,
    IEnkwadoreWalletV1
{
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant BOT_ROLE = keccak256("BOT_ROLE");

    constructor(address payable _EOA) {
        _grantRole(OWNER_ROLE, _EOA);
        _grantRole(BOT_ROLE, msg.sender);
        EOA = _EOA;
    }

    function pause() public onlyRole(OWNER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(OWNER_ROLE) {
        _unpause();
    }

    // End of snippet from OpenZeppelin wizard

    event Swap(
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 indexed amountIn,
        uint256 amountOut
    );
    event DepositNativeToken(address indexed toAddress, uint256 indexed amount);
    event WithdrawNativeToken(
        address indexed toAddress,
        uint256 indexed amount
    );
    event Withdraw(
        address indexed token,
        address indexed toAddress,
        uint256 indexed amount
    );
    event TradingAddressChanged(
        address indexed previousTradingAddress,
        address indexed newTradingAddress
    );

    address payable public immutable EOA;

    function swap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMinimum
    ) external virtual returns (uint256 amtOut);

    function withdraw(
        address tokenAddress,
        uint256 _amount
    ) external onlyRole(OWNER_ROLE) {
        IERC20 tokenContract = IERC20(tokenAddress);
        uint256 balance = tokenContract.balanceOf(address(this));
        uint256 amount = _amount == 0 ? balance : _amount;
        require(amount <= balance, "Insufficient balance");
        TransferHelper.safeTransfer(tokenAddress, EOA, amount);
        emit Withdraw(tokenAddress, EOA, amount);
    }

    function withdrawNativeToken(
        uint256 _amount
    ) external onlyRole(OWNER_ROLE) {
        uint256 balance = address(this).balance;
        uint256 amount = _amount == 0 ? balance : _amount;
        require(amount <= balance, "Insufficient balance");
        EOA.transfer(amount);
        emit WithdrawNativeToken(EOA, amount);
    }
}
