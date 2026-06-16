# RCA Run Report — ethereum 0xe3eab35b…15c475


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xe3eab35b288c086afa9b86a97ab93c7bb61d21b1951a156d2a8f6f5d5715c475`
- **Block**: 23769387
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1990.29s (1990287 ms)
- **Finding**: Public DRLVaultV3 swap uses a manipulable same-pool quote to spend vault USDC


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
- **PoC net reproduced**: $94074.52
- **USD ratio**: 0.995x

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

- Transaction: `0xe3eab35b288c086afa9b86a97ab93c7bb61d21b1951a156d2a8f6f5d5715c475`
- Block: `23769387`
- Root call type: `CALL`
- Target/tx.to: `0xe08d97e151473a848c3d9ca3f323cb720472d015`
- Attacker: `0xc0ffeebabe5d496b2dde509f9fa189c25cf29671`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_callback | unknown | `0x00000000` | `0xe08d97e151473a848c3d9ca3f323cb720472d015` | `30` |
| attacker_callback | onMorphoFlashLoan(uint256,bytes) | `0x31f57072` | `0xe08d97e151473a848c3d9ca3f323cb720472d015` | `5` |
| attacker_entry | NotYoink() | `0x8cbf8566` | `0xe08d97e151473a848c3d9ca3f323cb720472d015` | `1` |
| attacker_callback | uniswapV3SwapCallback(int256,int256,bytes) | `0xfa461e33` | `0xe08d97e151473a848c3d9ca3f323cb720472d015` | `88` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gai

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0xc0ffeebabe5d496b2dde509f9fa189c25cf29671` | `tx_from_eoa` | `ETH` | 26.126564958977372348 | $94074.52 |


## Root cause analysis

- **Title**: Public DRLVaultV3 swap uses a manipulable same-pool quote to spend vault USDC
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Vault-owned USDC may be swapped only by authorized vault actors and only against a manipulation-resistant minimum output independent of the current manipulated pool spot.

### Final root cause

DRLVaultV3.swapToWETH(uint256) is public and lets any caller choose an amount of vault-held token0/USDC to swap. In the token0 != WETH branch it computes amountOutMinimum from getQuoteForUSDC, which calls the current QuoterV2 route for the same Uniswap V3 pool with sqrtPriceLimitX96 set to zero, so an attacker can manipulate the pool spot state and then force the vault to accept the manipulated minimum. The exploit calls swapToWETH(100000000000), causing the vault to exchange 100,000 USDC for only 120518513556060 WETH while the attacker unwinds the pool and realizes ETH profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x6a06707ab339bee00c6663db17ddb422301ff5e8` | `DRLVaultV3` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Restrict swapToWETH at DRLVaultV3.sol:616 with onlyOwner or onlyOperator so arbitrary external callers cannot spend vault balances.
- Replace the same-pool QuoterV2-derived minOut at DRLVaultV3.sol:634-637 with an owner-supplied minimum, TWAP/independent oracle bounds, and a nonzero sqrtPriceLimitX96.
- Add a post-swap value invariant that reverts if the vault's received WETH value is materially below the USDC spent under a manipulation-resistant price.
