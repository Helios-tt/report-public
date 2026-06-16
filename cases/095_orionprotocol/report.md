# RCA Run Report — ethereum 0xa6f63fcb…40b2aa


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xa6f63fcb6bec8818864d96a5b1bb19e8bd85ee37b2cc916412e720988440b2aa`
- **Block**: 16542148
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 495.56s (495559 ms)
- **Finding**: Exchange in-contract pool swap output can be double-counted through reentrant deposits


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: holder net position delta usd
- **Verdict**: position_delta_close
- **Incident net loss**: $2844919.51
- **PoC net reproduced**: $2776224.58
- **USD ratio**: 0.976x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The Exchange credits swap proceeds from PoolFunctionality's aggregate token balance delta on the Exchange contract. During a Uniswap callback, the attacker reentered the Exchange through the unguarded depositAsset path, causing the same USDT transfer to be credited once as a deposit and again as swap output. The inflated internal USDT entitlement was then withdrawn and routed to WETH.

**Violated invariant**: A user's internal Exchange balance must be credited only for assets legitimately deposited by that user or produced by the current swap, and a token inflow must not be counted simultaneously as both a deposit and swap output.

| Field | Value |
|---|---|
| Entry function | 0xbe9a6555 / start() |
| Attacker callbacks | 0x10d1e85c / uniswapV2Call plus 0xd0e30db0 / deposit callback |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `WETH` | 1.651247397448511042 | `0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with forge build/test pass and economic proof pass.
- **balance_impact** (`evidence summary`): Exchange proxy holder lost 2844766426324 raw USDT while the exploit transaction produced WETH profit routing.
- **evidence** (`evidence summary`): Evidence summary shows direct asset loss with accounting steps in Exchange deposit, nested pool swap, and withdrawal; approval/transfer steps are downstream.
- **source** (`evidence summary`): depositAsset credits internal assetBalances from token balance deltas and is not guarded by nonReentrant; withdraw consumes the inflated balance.
- **source** (`evidence summary`): In-contract swaps debit spend assets, call the pool router, and credit the caller with the returned receive amount.
- **source** (`evidence summary`): The router computes swap output as the recipient token balance delta, so reentrant deposits into the Exchange recipient pollute the output amount.
- **attack_path** (`execution summary`): The callback sequence calls swapThroughOrionPool, then reenters depositAsset with USDT, then withdraws the doubled internal USDT balance.
- **negative_evidence** (`evidence summary`): ATK and USDT totalSupply did not increase, the Exchange USDT holder dropped to 1 raw unit, and the Exchange proxy implementation was stable.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xb5599f568d3f3e6113b286d010d2bca40a7745aa` | `storage_contract` | `USDT` | -2844766.426324 | -$2844920.01 |
| loss | `0x4e68ccd3e89f51c3074ca5072bbac773960dfa36` | `storage_contract` | `WETH` | -293.788317482566649246 | -$493943.15 |
| loss | `0x13e557c51c0a37e25e051491037ee546597c689f` | `storage_contract` | `USDT` | -0.000099 | -$0.00 |
| loss | `0x76fe189e4fa5ff997872ddf44023b04cd7cb03d2` | `storage_contract` | `ATK` | -0.000099680123783317 | N/A |

## Root cause analysis

- **Title**: Exchange in-contract pool swap output can be double-counted through reentrant deposits
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A user's internal Exchange balance must be credited only for assets legitimately deposited by that user or produced by the current swap, and a token inflow must not be counted simultaneously as both a deposit and swap output.

### Final root cause

The Exchange credits swap proceeds from PoolFunctionality's aggregate token balance delta on the Exchange contract. During a Uniswap callback, the attacker reentered the Exchange through the unguarded depositAsset path, causing the same USDT transfer to be credited once as a deposit and again as swap output. The inflated internal USDT entitlement was then withdrawn and routed to WETH.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xb5599f568d3f3e6113b286d010d2bca40a7745aa` | `ExchangeWithOrionPool proxy` | `primary vulnerable contract` | `0x98a877bb507f19eb43130b688f522a13885cf604` |
| `0x420a50a62b17c18b36c64478784536ba980feac8` | `PoolFunctionality` | `swap output amount source` | `—` |

### Recommended fixes

- Apply the same reentrancy protection or a shared accounting lock to depositAsset that protects withdraw and swapThroughOrionPool.
- Do not credit in-contract swap output from the Exchange's aggregate token balance delta; isolate router/pair output accounting from unrelated transfers and deposits.
- After pool swaps, validate that credited internal output equals assets produced by that swap and cannot include preexisting or concurrent balance changes.
