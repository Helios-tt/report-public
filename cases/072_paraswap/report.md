# RCA Run Report — ethereum 0x35a73969…734e60


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x35a73969f582872c25c96c48d8bb31c23eab8a49c19282c67509b96186734e60`
- **Block**: 19470561
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 892.35s (892348 ms)
- **Finding**: Unauthenticated ParaSwap Uniswap V3 callback allowed a forged exact-output swap to spend a third-party allowance


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
- **PoC net reproduced**: $21292.41
- **USD ratio**: 1.000x

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

- Transaction: `0x35a73969f582872c25c96c48d8bb31c23eab8a49c19282c67509b96186734e60`
- Block: `19470561`
- Root call type: `CALL`
- Target/tx.to: `0x6980a47bee930a4584b09ee79ebe46484fbdbdd0`
- Attacker: `0xfde0d1575ed8e06fbf36256bcdfa1f359281455a`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | yoink() | `0x9846cd9e` | `0x6980a47bee930a4584b09ee79ebe46484fbdbdd0` | `1` |
| attacker_callback | unknown | `entry` | `0x6980a47bee930a4584b09ee79ebe46484fbdbdd0` | `11` |

## Economic Effect

- Reconciliation basis: `poc_selected_beneficial_payout`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_beneficial_payout | gain | `0x229b8325bb9ac04602898b7e8989998710235d5f` | `ETH` | 6.450406123948403069 | $21292.41 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_beneficial_payout`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_beneficial_payout | gain | `0x229b8325bb9ac04602898b7e8989998710235d5f` | `storage_contract` | `ETH` | 6.450406123948403069 | $21292.41 |


## Root cause analysis

- **Title**: Unauthenticated ParaSwap Uniswap V3 callback allowed a forged exact-output swap to spend a third-party allowance
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: Any Uniswap V3 swap callback that can initiate recursive pool settlement or spend a payer from callback data must first authenticate msg.sender as the expected canonical pool for that route.

### Final root cause

AugustusV6's UniswapV3Utils.uniswapV3SwapCallback authenticates msg.sender only in the short-data settlement path. In the long-data recursive exact-output branch selected by data.length > 160, it calls _callUniswapV3PoolsSwapExactAmountOut before proving the caller is the expected canonical Uniswap V3 pool. The attacker directly invoked that branch with crafted data, causing Augustus to call the real OPSEC/WETH pool with the attacker as recipient and a third-party OPSEC holder as payer, so pool settlement transferred WETH to the attacker and consumed OPSEC via transferFrom.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x00000000fdac7708d0d360bddc1bc7d097f47439` | `AugustusV6 / UniswapV3Utils` | `primary vulnerable contract` | `0xfc736f39579b25bdcccaac9bca34d3528b88f1be` |
| `0x45f4d60405b797a2b0e5ea581fe6ea445cb46b8f` | `UniswapV3Pool` | `affected pool used for settlement` | `—` |

### Recommended fixes

- In UniswapV3Utils.sol lines 73-83, authenticate msg.sender against the expected canonical pool or encoded previous pool before calling _callUniswapV3PoolsSwapExactAmountOut, and revert before reading fromAddress or route data when the caller is not valid.
- Add regression tests where an EOA or arbitrary contract directly calls uniswapV3SwapCallback with data.length > 160 and verify it reverts before any pool.swap or token transferFrom is attempted.

### Limitations

- The available evidence do not identify the prior transaction or actor that granted OPSEC allowance to Augustus; that is a non-causal precondition for execution steps and does not affect the callback-authentication root cause.
- The incident economic proof uses selected beneficial ETH payout as the exact PoC target, while the RCA also cites direct pool WETH/OPSEC deltas from evidence summary and RPC observations.
