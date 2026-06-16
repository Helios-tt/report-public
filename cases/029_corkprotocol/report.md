# RCA Run Report — ethereum 0xfd89cdd0…09f64d


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xfd89cdd0be468a564dd525b222b728386d7c6780cf7b2f90d2b54493be09f64d`
- **Block**: 22581020
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 567.12s (567123 ms)
- **Finding**: Unauthenticated Cork market initialization lets an attacker choose the exchange-rate provider and redeem against real protocol assets


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
- **Incident net loss**: $11965876.37
- **PoC net reproduced**: $11969047.19
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

CorkConfig.initializeModuleCore and CorkConfig.issueNewDs are external without onlyManager, even though they create and issue protocol markets. The attacker initialized a market over real wstETH/weETH assets while setting exchangeRateProvider to the attack contract, then issued CT/DS and used PSM/LV redemption flows to make Cork accept the resulting entitlement. The source-visible competing price/accounting gate is PsmLibrary._getLatestRate/_getLatestApplicableRate, which consumes the configured exchangeRateProvider; no supplied independent oracle, solvency, LTV, health-check, or post-action validation branch was found to override that provider choice. The downstream approvals, transferFrom, PoolManager settlement, and returnRaWithCtDs steps move assets after the invalid market/provider selection; they are not the invariant-breaking branch.

**Violated invariant**: Only authorized protocol managers may create/issue Cork markets and choose the exchange-rate provider used for PSM/LV entitlement calculations.

| Field | Value |
|---|---|
| Entry function | 0x0f626b5a / attack() reconstructed in PoC |
| Attacker callbacks | unlockCallback(bytes) and attacker exchange-rate provider rate methods |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `wstETH` | 3761.877955369549831945 | `0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with no hard static-validation blockers.
- **balance_impact** (`evidence summary`): Shows attacker-controlled gains in wstETH and weETH8DS-2 and corresponding Cork proxy/storage holder losses.
- **evidence** (`evidence summary`): Evidence summary identifies direct asset loss plus entitlement/accounting anomaly, demotes ERC20 approval-shaped steps, and surfaces Cork accounting steps.
- **source** (`evidence summary`): Verified PoC path initializes a Cork market with exchangeRateProvider set to the attack contract, which returns attacker-controlled rates.
- **source** (`evidence summary`): CorkConfig exposes market initialization and issuance externally without onlyManager while other privileged configuration functions are manager-gated.
- **source** (`evidence summary`): ModuleCore accepts calls from CorkConfig and initializes PSM/Vault/LV and CT/DS issuance for the supplied market parameters.
- **source** (`evidence summary`): PSM entitlement calculations consume the configured exchangeRateProvider, mint CT/DS on deposit, and unlock RA when matching CT/DS are returned; no supplied independent oracle/solvency/health gate was found.
- **negative_evidence** (`evidence summary`): Approval, transferFrom, settlement, and profit-routing steps were rejected as downstream effects; the competing mechanism check and faithfulness audit found no high-risk violation.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xccd90f6435dd78c4ecced1fa4db0d7242548a2a9` | `storage_contract` | `wstETH` | -3760.881365943909071528 | -$11965876.37 |
| loss | `0x55b90b37416dc0bd936045a8110d1af3b6bf0fc3` | `storage_contract` | `weETH8DS-2` | -3761.257491693078379366 | N/A |

## Root cause analysis

- **Title**: Unauthenticated Cork market initialization lets an attacker choose the exchange-rate provider and redeem against real protocol assets
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Only authorized protocol managers may create/issue Cork markets and choose the exchange-rate provider used for PSM/LV entitlement calculations.

### Final root cause

CorkConfig.initializeModuleCore and CorkConfig.issueNewDs are external without onlyManager, even though they create and issue protocol markets. The attacker initialized a market over real wstETH/weETH assets while setting exchangeRateProvider to the attack contract, then issued CT/DS and used PSM/LV redemption flows to make Cork accept the resulting entitlement. The source-visible competing price/accounting gate is PsmLibrary._getLatestRate/_getLatestApplicableRate, which consumes the configured exchangeRateProvider; no supplied independent oracle, solvency, LTV, health-check, or post-action validation branch was found to override that provider choice. The downstream approvals, transferFrom, PoolManager settlement, and returnRaWithCtDs steps move assets after the invalid market/provider selection; they are not the invariant-breaking branch.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xf0da8927df8d759d5ba6d3d714b1452135d99cfc` | `CorkConfig` | `primary vulnerable contract` | `—` |
| `0xccd90f6435dd78c4ecced1fa4db0d7242548a2a9` | `ERC1967Proxy / ModuleCore-facing protocol proxy` | `state/accounting contract affected by invalid market setup` | `0x58c76e589a632739c4b27e1292d89048504c4f5d` |

### Recommended fixes

- Add onlyManager to CorkConfig.initializeModuleCore and CorkConfig.issueNewDs so unauthorized users cannot create or issue markets.
- Restrict exchangeRateProvider to a trusted registry or the protocol default provider, and reject attacker-supplied arbitrary provider addresses during market creation.
- Add regression tests proving non-manager callers cannot initialize/issue markets and cannot configure a provider that returns arbitrary rates.
