# RCA Run Report — bsc 0x6ba4152d…afd9b4


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x6ba4152db9da45f5751f2c083bf77d4b3385373d5660c51fe2e4382718afd9b4`
- **Block**: 34739874
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 449.40s (449399 ms)
- **Finding**: Attacker-triggered proxy functions approved router spending and swapped contract-held assets


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
- **Incident net loss**: unknown
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The directly loss-causing path is an attacker-triggered call into the implementations behind 0x37177ccc66ef919894cef37596bbebd76e7a40b2 selector 0x369baafe and 0xe38d7ff85bb801d35382eef15eb8263f2c751ecd selector 0xb7da6a49. Those calls cause the proxy contracts to approve PancakeRouter over their own CCV/USDT balances and invoke swaps that route value through the Pancake pair, ultimately leaving the attacker with USDT profit. The exact vulnerable branch is source-gapped because the implementation source for those selectors is not present under source bundle, so this is partial rather than complete.

**Violated invariant**: Externally callable strategy/proxy functions must not grant token spending authority or swap contract-owned assets unless the caller, amount, path, and recipient are authorized and economically accounted to the contract.

| Field | Value |
|---|---|
| Entry function | test(uint256,bytes) / selector 0xe4c38d6d on attacker contract, callback DPPFlashLoanCall selector 0x7ed1f1dd |
| Funding source | DPP flashLoan selector 0xd0a494e4 |
| Attacker callbacks | DPPFlashLoanCall |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `USDT` | 3171.894324298232046025 | `0x55d398326f99059ff775485246999027b3197955` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC passes, forge test passes, and hard static blockers are zero.
- **balance_impact** (`evidence summary`): USDT and CCV supplies are unchanged while the attacker gains USDT and proxy/pair holders lose CCV/USDT.
- **evidence** (`evidence summary`): Attacker-triggered proxy selectors lead to token approvals and router swaps.
- **evidence** (`execution summary`): Proxy-owned CCV/USDT approve PancakeRouter before the router swaps consume balances.
- **source** (`evidence summary`): PancakePair enforces transfer success, positive input, and fee-adjusted K, supporting treatment of pair swaps as downstream execution.
- **proxy_metadata** (`evidence summary`): EIP-1967 implementation slots resolve proxy implementations, but implementation source is not present in source bundle.
- **negative_evidence** (`evidence summary`): ERC20 approval/transfer and PancakePair steps are rejected as standalone root cause; exact proxy implementation branch remains source-gapped.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x37177ccc66ef919894cef37596bbebd76e7a40b2` | `storage_contract` | `CCV` | -6489.051154605916542594 | N/A |
| loss | `0x4da070f3c4295389ddff6d4398650001e412cb39` | `storage_contract` | `USDT` | -2275.639798006133123809 | N/A |
| loss | `0xe38d7ff85bb801d35382eef15eb8263f2c751ecd` | `storage_contract` | `USDT` | -896.254526292098922216 | N/A |

## Root cause analysis

- **Title**: Attacker-triggered proxy functions approved router spending and swapped contract-held assets
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Externally callable strategy/proxy functions must not grant token spending authority or swap contract-owned assets unless the caller, amount, path, and recipient are authorized and economically accounted to the contract.

### Final root cause

The directly loss-causing path is an attacker-triggered call into the implementations behind 0x37177ccc66ef919894cef37596bbebd76e7a40b2 selector 0x369baafe and 0xe38d7ff85bb801d35382eef15eb8263f2c751ecd selector 0xb7da6a49. Those calls cause the proxy contracts to approve PancakeRouter over their own CCV/USDT balances and invoke swaps that route value through the Pancake pair, ultimately leaving the attacker with USDT profit. The exact vulnerable branch is source-gapped because the implementation source for those selectors is not present under source bundle, so this is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x37177ccc66ef919894cef37596bbebd76e7a40b2` | `ERC1967Proxy` | `primary vulnerable proxy holding CCV` | `0x18f6e45b017187e19e62ba0118621c9a2200ce0c` |
| `0xe38d7ff85bb801d35382eef15eb8263f2c751ecd` | `ERC1967Proxy` | `primary vulnerable proxy holding USDT` | `0x238217598abb32a3a031f6a9cccc86f5946a07e3` |
| `0x4da070f3c4295389ddff6d4398650001e412cb39` | `PancakePair` | `downstream swap venue` | `—` |

### Recommended fixes

- In the implementations behind 0x37177...40b2 selector 0x369baafe and 0xe38d...1ecd selector 0xb7da6a49, add explicit caller authorization and validate amount, token path, and recipient before any token approve or PancakeRouter call.
- Approve exact spend amounts only after validation and clear router allowances after use.
- Add invariant tests that arbitrary external callers cannot cause proxy-held assets to be approved, swapped, or sent to attacker-controlled recipients.

### Limitations

- internal evidence is missing or unreadable in the supplied output root.
- missing_assumption: implementation source for 0x18f6e45b017187e19e62ba0118621c9a2200ce0c and 0x238217598abb32a3a031f6a9cccc86f5946a07e3 is absent, so the exact authorization/amount branch cannot be line-pinned.
- source_gap: selector signatures for 0x369baafe and 0xb7da6a49 are unresolved in selector evidence.
