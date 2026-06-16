# RCA Run Report — ethereum 0xa05f047d…35736f


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xa05f047ddfdad9126624c4496b5d4a59f961ee7c091e7b4e38cee86f1335736f`
- **Block**: 22157900
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 735.72s (735722 ms)
- **Finding**: Vault callback authorization reused transient storage for both pool identity and minted amount, allowing forged callbacks to drain vault assets


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: holder-net USD loss
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $354184.29
- **PoC net reproduced**: $354184.29
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

Vault.mint's debt-token path stores the authorized Uniswap pool in transient slot 1, but uniswapV3SwapCallback later overwrites the same slot with the minted amount. Because the callback authorizes only by checking msg.sender == tload(1), an attacker can make slot 1 equal an attacker-controlled caller and directly invoke the callback outside a live Uniswap swap with forged decoded data/reserves. The resulting _mint and transfer side effects let the attacker drain Vault-held WBTC, USDC, and WETH.

**Violated invariant**: The callback authorization value must be bound to the active Uniswap pool and active swap, must not be overwritten with return data, and must be cleared before any later external callback can be accepted.

| Field | Value |
|---|---|
| Entry function | 0xcb01c553 on attacker contract, then Vault.mint(bool,(address,address,int8),uint256,uint144) and Vault.uniswapV3SwapCallback(int256,int256,bytes) |
| Public entrypoint | uniswapV3SwapCallback(int256,int256,bytes) |
| Attacker callbacks | direct forged Vault.uniswapV3SwapCallback calls after transient slot pollution |
| Callback is root cause | true |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `WETH` | 119.871037891574186422 | `0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passes with exact reproduced WBTC, USDC, and WETH gains and no hard product blockers.
- **balance_impact** (`evidence summary`): The Vault loses WETH, USDC, and WBTC while attacker-controlled surfaces gain corresponding assets; evidence summary warns not to stop at drain steps because entitlement/accounting anomalies are present.
- **evidence** (`evidence summary`): Vault accounting/callback steps write protocol state and are connected to the loss; child token transfers are downstream effects.
- **source** (`evidence summary`): Vault.mint stores the pool in transient slot 1; uniswapV3SwapCallback authorizes with msg.sender == tload(1), decodes caller-controlled data, calls _mint, and overwrites slot 1 with the minted amount.
- **source** (`evidence summary`): The oracle/pool mechanism supplies an initial pool during mint, but the callback does not recompute or bind callback data to that pool after transient slot reuse.
- **source** (`evidence summary`): APE amount calculations are downstream of Vault._mint; no standalone APE arithmetic defect was needed for the selected causal claim.
- **source** (`evidence summary`): TEA amount calculations were inspected as the competing share path; the root cause remains forged callback authorization before share/accounting updates.
- **evidence** (`evidence summary`): The verified PoC sequence initializes the Vault path, calls Vault.mint, then performs direct Vault.uniswapV3SwapCallback calls and downstream token transfers.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xb91ae2c8365fd45030aba84a4666c4db074e53e7` | `storage_contract` | `WETH` | -119.871037891574186422 | -$219860.94 |
| loss | `0xb91ae2c8365fd45030aba84a4666c4db074e53e7` | `storage_contract` | `WBTC` | -1.4085292 | -$116510.33 |
| loss | `0xb91ae2c8365fd45030aba84a4666c4db074e53e7` | `storage_contract` | `USDC` | -17814.862676 | -$17813.01 |

## Root cause analysis

- **Title**: Vault callback authorization reused transient storage for both pool identity and minted amount, allowing forged callbacks to drain vault assets
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: The callback authorization value must be bound to the active Uniswap pool and active swap, must not be overwritten with return data, and must be cleared before any later external callback can be accepted.

### Final root cause

Vault.mint's debt-token path stores the authorized Uniswap pool in transient slot 1, but uniswapV3SwapCallback later overwrites the same slot with the minted amount. Because the callback authorizes only by checking msg.sender == tload(1), an attacker can make slot 1 equal an attacker-controlled caller and directly invoke the callback outside a live Uniswap swap with forged decoded data/reserves. The resulting _mint and transfer side effects let the attacker drain Vault-held WBTC, USDC, and WETH.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xb91ae2c8365fd45030aba84a4666c4db074e53e7` | `Vault` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Use separate transient slots for the active Uniswap pool and the minted return amount, clear the active pool slot after the swap, and reject callbacks unless an active swap flag and recomputed expected pool match msg.sender.
- Do not trust callback calldata for minter, vaultParams, vaultState, or reserves unless it is bound to the active mint invocation and authenticated pool.
- Add regression tests that call uniswapV3SwapCallback directly after a mint/callback lifecycle and assert it reverts before any _mint or token transfer side effect.

### Limitations

- internal evidence is absent from the public bundle, so PoC source and verified result.json were used instead.
- RPC observations did not include A-token totalSupply for the giant setup token; this does not affect the selected Vault callback-auth root cause.
