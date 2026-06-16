# RCA Run Report — bsc 0x7226b394…5ae22c


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x7226b3947c7e8651982e5bd777bca52d03ea31d19b515dec123595a4435ae22c`
- **Block**: 51715418
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 450.69s (450691 ms)
- **Finding**: Uncapped dividend distribution lets flash-funded new shares withdraw more WBNB than the dividend pool backs


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
- **Verdict**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Incident net loss**: $19223.64
- **PoC net reproduced**: $15867.66
- **USD ratio**: 0.825x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

BankrollNetworkStack lets any caller add to dividendBalance_ through donatePool(), then buy internal shares before the same transaction calls distribute(). distribute() computes a time-scaled profit from dividendBalance_ and credits that uncapped profit to profitPerShare_, while dividendBalance_.safeSub(profit) only floors the stored pool to zero when profit exceeds available backing. The attacker flash-funded a donate/buy/sell/withdraw sequence so the newly acquired shares received an over-credited dividend entitlement, and withdraw() paid that entitlement in WBNB.

**Violated invariant**: Credited dividends and withdrawable payouts must be capped by the actually reserved dividendBalance_, and newly minted shares must not receive dividends accumulated before they became eligible.

| Field | Value |
|---|---|
| Entry function | attacker contract selector 0x227636c0; Bankroll calls donatePool(uint256), buy(uint256), sell(uint256), withdraw() |
| Funding source | Pancake pair flash swap from 0x16b9a82891338f9ba80e2d6970fdda79d1eb0dae |
| Public entrypoint | donatePool(uint256) -> buy(uint256) -> sell(uint256) -> withdraw() |
| Attacker callbacks | Pancake swap callback selector 0x84800812 |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `WBNB` | 24.586528993752124174 | `0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC gate passed: execution, build, test, and economic proof succeeded with no hard product static blockers.
- **balance_impact** (`evidence summary`): Evidence summary shows direct WBNB loss from Bankroll, WBNB gain to attacker EOA, and accounting/entitlement anomaly candidates.
- **balance_impact** (`evidence summary`): Bankroll WBNB decreased by 29786528993752124174 raw units and the attacker EOA WBNB increased by 24586528993752124174 raw units.
- **evidence** (`evidence summary`): The evidence summary links the attacker-controlled callback to Bankroll donatePool, buy, sell, and withdraw accounting steps.
- **attack_path** (`evidence summary`): Verified PoC executes the donatePool -> buy -> sell -> myDividends -> withdraw sequence and realizes WBNB profit.
- **source** (`evidence summary`): Source shows public dividend funding, share mint before distribute(), uncapped profitPerShare_ credit, dividend entitlement calculation, and downstream transfer payout.
- **negative_evidence** (`evidence summary`): ERC20 approval/transfer, Pancake swap, and withdraw transfer primitives were rejected as standalone root cause because the invalid economic decision is upstream dividend/share accounting.
- **proxy_metadata** (`evidence summary`): Bankroll code existed before and after the transaction and the EIP-1967 implementation slot was zero, supporting direct source-level analysis of the fetched contract.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xadefb902cab716b8043c5231ae9a50b8b4ee7c4e` | `storage_contract` | `WBNB` | -29.786528993752124174 | -$19223.64 |

## Root cause analysis

- **Title**: Uncapped dividend distribution lets flash-funded new shares withdraw more WBNB than the dividend pool backs
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: Credited dividends and withdrawable payouts must be capped by the actually reserved dividendBalance_, and newly minted shares must not receive dividends accumulated before they became eligible.

### Final root cause

BankrollNetworkStack lets any caller add to dividendBalance_ through donatePool(), then buy internal shares before the same transaction calls distribute(). distribute() computes a time-scaled profit from dividendBalance_ and credits that uncapped profit to profitPerShare_, while dividendBalance_.safeSub(profit) only floors the stored pool to zero when profit exceeds available backing. The attacker flash-funded a donate/buy/sell/withdraw sequence so the newly acquired shares received an over-credited dividend entitlement, and withdraw() paid that entitlement in WBNB.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xadefb902cab716b8043c5231ae9a50b8b4ee7c4e` | `BankrollNetworkStack` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Cap profit in distribute() to dividendBalance_ before both dividendBalance_ subtraction and profitPerShare_ credit.
- Prevent same-epoch shares minted after donatePool() from receiving pre-existing dividendBalance_ by distributing before minting or snapshotting eligible supply.
- Make withdraw() fail or pay only when the contract's token balance and reserved dividend accounting can cover the computed payout.

### Limitations

- internal evidence was not present in the manifest; the verified PoC test, evidence summary steps, source, asset deltas, and RPC observations were sufficient for the selected source-backed causal claim.
