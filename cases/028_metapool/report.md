# RCA Run Report — ethereum 0x57ee419a…d1fa69


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x57ee419a001d85085478d04dd2a73daa91175b1d7c11d8a8fb5622c56fd1fa69`
- **Block**: 22722911
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 824.58s (824584 ms)
- **Finding**: mpETH inherited ERC4626 mint bypasses asset receipt after Staking overrides _deposit


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: unknown
- **PoC net reproduced**: $22976.94
- **USD ratio**: 1.003x

## Attack narrative

# Attack Flow

Generated from a verified Solidity reproduction and economic proof.

## Verification Gate

- Status: `pass`
- Execution status: `pass`
- Economic status: `pass`
- Proof kind: `economic_proof`
- Forge build: `pass`
- Forge test: `pass`

## Replay Target

- Transaction: `0x57ee419a001d85085478d04dd2a73daa91175b1d7c11d8a8fb5622c56fd1fa69`
- Block: `22722911`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x48f1d0f5831eb6e544f8cbde777b527b87a1be98`

## PoC Surfaces

|

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x48f1d0f5831eb6e544f8cbde777b527b87a1be98` | `tx_from_eoa` | `ETH` | 8.891824723356455409 | $22976.94 |
| poc_selected_direct_attacker_gain | gain | `0x48f1d0f5831eb6e544f8cbde777b527b87a1be98` | `tx_from_eoa` | `mpETH` | 9682.71863155466315162 | N/A |


## Root cause analysis

- **Title**: mpETH inherited ERC4626 mint bypasses asset receipt after Staking overrides _deposit
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Every path that mints mpETH shares must first receive the corresponding ETH/WETH assets or prove an equivalent pre-funded asset increase before updating totalUnderlying or transferring shares to the receiver.

### Final root cause

The mpETH Staking implementation inherits ERC4626 mint(uint256,address), which computes required assets with previewMint and dispatches to the virtual _deposit hook. Staking overrides _deposit for ETH/WETH deposit flows but removes the base ERC4626 safeTransferFrom asset receipt step and does not add an equivalent balance/msg.value receipt check. A zero-value mint call can therefore mint and transfer mpETH shares, update totalUnderlying, and create economic entitlement without the caller supplying the required assets.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x48afbbd342f64ef8a9ab1c143719b63c2ad81710` | `TransparentUpgradeableProxy / Staking mpETH` | `primary vulnerable contract` | `0x3747484567119592ff6841df399cf679955a111a` |
| `0x3747484567119592ff6841df399cf679955a111a` | `Staking` | `mpETH implementation source` | `—` |

### Recommended fixes

- Override Staking.mint to collect previewMint(shares) WETH from msg.sender and unwrap it before calling _deposit, or restore the base ERC4626 asset-transfer invariant inside the shared deposit path.
- Add a pre/post asset receipt assertion around Staking._deposit so totalUnderlying and minted shares can only increase by assets actually received or provably routed from the liquid pool.
- Add regression tests where mint(uint256,address) is called with zero WETH allowance/balance and zero msg.value, expecting revert and no mpETH balance or totalSupply increase.

### Limitations

- The bounded rpc_questions did not include an mpETH totalSupply pre/post call; mpETH supply expansion is therefore supported by execution steps storage/log evidence and ERC20 _mint source rather than a separate totalSupply RPC observation.
