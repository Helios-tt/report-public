# RCA Run Report — bsc 0x9afcac8e…e953b3


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x9afcac8e82180fa5b2f346ca66cf6eb343cd1da5a2cd1b5117eb7eaaebe953b3`
- **Block**: 43023423
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 895.71s (895710 ms)
- **Finding**: P719 buy/sell accounting allowed repeated helper purchases and sells to drain BNB-backed value


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: holder-net USD loss
- **Verdict**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Incident net loss**: $327124.27
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The verified exploit path localizes the harmful economic decision to P719's payable buy/fallback and sell(uint256) accounting path: attacker-created helpers buy P719 with BNB, approve the attacker, and the attacker then distributes/transfers P719 into many sell calls. The failed invariant is that buy/sell payout and token entitlement must be bounded by actual contributed BNB/reserves and correct burn/transfer accounting; the observed effect is a large loss of BNB and P719 from the P719 contract and attacker profit in sdgh. The exact vulnerable line or formula cannot be identified because P719 verified source is absent and the supplied execution summary compacts the internal calculation branch.

**Violated invariant**: For every P719 buy/sell cycle, credited token balances and BNB payouts must not exceed the value supported by actual net deposits/reserves and must be enforced before transfer/approval-based distribution can be used.

| Field | Value |
|---|---|
| Entry function | 0x510a82a9 (unresolved attacker entry) |
| Funding source | PancakeV3 flash(address,uint256,uint256,bytes) |
| Public entrypoint | P719 payable fallback/buy via helper buy(); then sell(uint256) on helper contracts |
| Attacker callbacks | pancakeV3FlashCallback(uint256,uint256,bytes) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `sdgh` | 99.999816860408262979 | `0xce7de92ab33fa219ef3b336925fbd33dd6e4a0f6` |

### Evidence Summary

- **poc_verification** (`evidence summary`): PoC gate passed with economic proof, forge build/test pass, execution pass, and no hard product static blockers.
- **evidence** (`evidence summary`): Evidence summary shows direct asset loss from P719 and an entitlement/accounting anomaly; analysis must not stop at approvals/drain steps.
- **evidence** (`evidence summary`): Approval steps write allowances but are downstream authority/path primitives, not the economic root cause.
- **evidence** (`execution summary`): Attacker entry takes flash liquidity, repeatedly creates helpers and calls P719 buy/value paths, then transferFrom/sell, swaps WBNB to sdgh, and repays.
- **balance_impact** (`evidence summary`): P719 totalSupply decreases while helper/P719 holder balances and attacker profit move materially, contradicting a standalone giant-mint RCA and supporting buy/sell accounting as impact path.
- **balance_impact** (`evidence summary`): P719 contract loses BNB and P719, helper addresses gain P719, and attacker contract gains sdgh.
- **negative_evidence** (`evidence summary`): WBNB wrapping/unwrapping is a downstream primitive with standard balance checks, not the invalid entitlement decision.
- **negative_evidence** (`evidence summary`): Router swap is downstream profit conversion with an output-minimum check; it does not compute the P719 entitlement or payout.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x6beee2b57b064eac5f432fc19009e3e78734eabc` | `storage_contract` | `BNB` | -575.799074208829188341 | -$327124.27 |
| loss | `0x6beee2b57b064eac5f432fc19009e3e78734eabc` | `storage_contract` | `P719` | -50419.87111444810644714 | N/A |

## Root cause analysis

- **Title**: P719 buy/sell accounting allowed repeated helper purchases and sells to drain BNB-backed value
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: For every P719 buy/sell cycle, credited token balances and BNB payouts must not exceed the value supported by actual net deposits/reserves and must be enforced before transfer/approval-based distribution can be used.

### Final root cause

The verified exploit path localizes the harmful economic decision to P719's payable buy/fallback and sell(uint256) accounting path: attacker-created helpers buy P719 with BNB, approve the attacker, and the attacker then distributes/transfers P719 into many sell calls. The failed invariant is that buy/sell payout and token entitlement must be bounded by actual contributed BNB/reserves and correct burn/transfer accounting; the observed effect is a large loss of BNB and P719 from the P719 contract and attacker profit in sdgh. The exact vulnerable line or formula cannot be identified because P719 verified source is absent and the supplied execution summary compacts the internal calculation branch.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x6beee2b57b064eac5f432fc19009e3e78734eabc` | `P719` | `primary vulnerable contract` | `—` |
| `0x3f32c7cfb0a78ddea80a2384ceb4633099cbdc98` | `attack contract` | `attacker orchestrator/callback` | `—` |

### Recommended fixes

- In P719's payable buy/fallback and sell(uint256) implementation, enforce that credited tokens and BNB payouts are derived from current reserves and actual net deposits, and revert when a sale payout exceeds the contract's reserve-backed liability.
- Add invariant tests around repeated helper buy/sell cycles, transferFrom-mediated sells, and flash-loan-funded buy/sell sequences so aggregate payouts cannot exceed actual contributed value.
- Do not rely on allowance/transferFrom sequencing as economic authorization; validate entitlement and payout at the P719 sell/buy calculation boundary.

### Limitations

- source_branch_gap: P719 source is absent under internal evidence, so the exact vulnerable source line and arithmetic formula cannot be identified.
- missing_assumption: the internal P719 amount/entitlement/payout validation branch is not visible in source or sufficiently decoded execution summary.
- The P719 storage layout and individual storage slots were not semantically decoded; storage writes are used only as observed state changes, not named mappings.
- Competing oracle/price/solvency gates for P719 were not visible in the available evidence.
