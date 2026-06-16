# RCA Run Report — ethereum 0x23b69bef…7e2bb3


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x23b69bef57656f493548a5373300f7557777f352ade8131353ff87a1b27e2bb3`
- **Block**: 23260641
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 473.60s (473600 ms)
- **Finding**: HEXOTC allows stale fixed-price ETH escrow offers to be taken indefinitely


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
- **Incident net loss**: $0.14
- **PoC net reproduced**: $546.27
- **USD ratio**: 1.001x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

HEXOTC take(bytes32) routes msg.value==0 to buyETH(uint256), which pays offer.pay_amt ETH to the taker after receiving offer.buy_amt HEX. The branch validates only that the offer is active, has escrowType==1, positive amounts, and that the caller currently has enough HEX; it does not enforce expiry, maker freshness, oracle price validity, or re-confirmation. The attacker acquired HEX through a UniswapV3 swap, approved HEXOTC, and took old active offers 0x43 and 0x2b, causing the contract to treat stale fixed-price offers as a valid payout entitlement.

**Violated invariant**: An ETH-escrowed OTC order must not remain executable forever at stale fixed terms without expiry or fresh maker authorization.

| Field | Value |
|---|---|
| Entry function | take(bytes32) via attacker helper sequence |
| Public entrypoint | HEXOTC.take(bytes32) |
| Attacker callbacks | 0xfa461e33 UniswapV3 swap callback repaid WETH |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH` | 0.122278953515569393 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with forge build/test and economic proof passing and no hard product-static blockers.
- **balance_impact** (`evidence summary`): The evidence summary shows direct asset loss, attacker profit, and an entitlement/accounting anomaly, requiring analysis beyond transfer/approval steps.
- **evidence** (`evidence summary`): Two attack-surface HEXOTC take(bytes32) calls consumed offer ids 0x43 and 0x2b, deleted offer storage, and invoked child HEX transferFrom flows.
- **source** (`evidence summary`): Source shows take routes to buyETH; buyETH validates active escrow type and caller HEX balance, then transfers HEX to maker and ETH to taker, with no expiry or freshness field in OfferInfo.
- **negative_evidence** (`evidence summary`): HEX supply did not expand; WETH supply/balance changes match deposit accounting; HEXOTC and Uniswap pool code existed pre/post and were not proxies per EIP-1967 slot observations.
- **negative_evidence** (`evidence summary`): WETH deposit credits balance by msg.value and totalSupply is native ETH balance, so the WETH supply expansion is an effect of deposited ETH rather than the invalid entitlement.
- **negative_evidence** (`evidence summary`): The UniswapV3 swap branch is the acquisition/callback path for HEX and WETH repayment; no supplied source evidence shows it is the broken economic decision.
- **attack_path** (`execution summary`): Execution summary sequence shows WETH deposit, Uniswap swap, HEX approval, two HEXOTC takes, callback repayment, and final ETH/HEX profit routing.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x9e0905249ceefffb9605e034b534544684a58be6` | `storage_contract` | `HEX` | -92365.61624407 | -$165.00 |

## Root cause analysis

- **Title**: HEXOTC allows stale fixed-price ETH escrow offers to be taken indefinitely
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: An ETH-escrowed OTC order must not remain executable forever at stale fixed terms without expiry or fresh maker authorization.

### Final root cause

HEXOTC take(bytes32) routes msg.value==0 to buyETH(uint256), which pays offer.pay_amt ETH to the taker after receiving offer.buy_amt HEX. The branch validates only that the offer is active, has escrowType==1, positive amounts, and that the caller currently has enough HEX; it does not enforce expiry, maker freshness, oracle price validity, or re-confirmation. The attacker acquired HEX through a UniswapV3 swap, approved HEXOTC, and took old active offers 0x43 and 0x2b, causing the contract to treat stale fixed-price offers as a valid payout entitlement.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x204b937feaec333e9e6d72d35f1d131f187ecea1` | `HEXOTC` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Add an expiresAt/deadline or maker re-confirmation field to OfferInfo, set it in newOffer, and require now <= expiresAt in can_buy/buyETH before paying offer.pay_amt ETH.
- For signed or off-chain quoted orders, include nonce, deadline, chain/domain separation, and explicit cancellation semantics before accepting a stale fixed-price quote.
- Consider adding maker-configurable maximum slippage or oracle/TWAP freshness checks if offers are intended to track market price rather than remain fixed-price escrow orders.

### Limitations

- internal evidence was not present, so PoC flow evidence uses the executable PoC and compact execution summary instead.
- The evidence do not establish the original makers' off-chain intent for offers 0x43 and 0x2b; the root cause is limited to the on-chain absence of expiry or freshness validation for active offers.
