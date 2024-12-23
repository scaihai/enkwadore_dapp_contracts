import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("EnkwadoreWallet", (m) => {
    const ISwapRouterAddress = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
    const wallet = m.contract("EnkwadoreWallet_Uniswap_V1", [ISwapRouterAddress, 3000]);
    return { wallet };
});