# RCA Run Report — ethereum 0x636be30e…1c65d9


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x636be30e58acce0629b2bf975b5c3133840cd7d41ffc3b903720c528f01c65d9`
- **Block**: 20434450
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 581.11s (581113 ms)
- **Finding**: Unchecked user-supplied staking claim contract forged CVG reward entitlement


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
- **Incident net loss**: $15900.11
- **PoC net reproduced**: $203628.90
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

CvxRewardDistributor.claimMultipleStaking accepts caller-supplied staking claim contracts and calls claimCvgCvxMultiple on each without proving that the contract is an authorized staking service. The attacker supplied an attacker-controlled helper that returned a forged, huge cvgClaimable value; the distributor trusted it and called CVG.mintStaking, which minted the remaining staking allocation to the attacker-controlled receiver. The attacker then swapped the newly minted CVG for crvFRAX and WETH.

**Violated invariant**: Every CVG staking reward mint must be derived from a registered staking contract's own accounting for the claimant, not from an arbitrary external contract supplied in calldata.

| Field | Value |
|---|---|
| Entry function | claimMultipleStaking(ICvxStakingPositionService[],address,uint256,bool,uint256) via selector 0x23446652 on proxy |
| Public entrypoint | claimMultipleStaking |
| Attacker callbacks | 0x74840edc21fab546f0fc085869862a3137f48e1b fallback for selector 0x011f20bf returned forged claim data |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `WETH` | 60.058285738671884767 | `0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC reproduced attacker profit in crvFRAX and WETH with no hard product validation blockers.
- **balance_impact** (`evidence summary`): Victim pool lost crvFRAX, attacker gained crvFRAX and WETH, and CVG was flagged as a giant mint/supply expansion token.
- **evidence** (`evidence summary`): CVG execution steps wrote supply/minted staking/balance state and emitted mint-style transfer to the attacker contract, identifying the entitlement creation step.
- **evidence** (`evidence summary`): CVG totalSupply increased by 58718395056818121904518498 in the incident block.
- **proxy_metadata** (`evidence summary`): Proxy 0x2b083beaac310cc5e190b1d2507038ccb03e7606 resolved to CvxRewardDistributor implementation 0x47c69e8c909ce626af73c955a5e34a20b7c71f19 at the incident block.
- **source** (`evidence summary`): The distributor accepts arbitrary claimContracts, calls claimCvgCvxMultiple on them, accumulates returned cvgClaimable, and mints CVG through CVG.mintStaking.
- **source** (`evidence summary`): CVG mintStaking authorizes the distributor as a staking minter, caps to MAX_STAKING, updates mintedStaking, and mints to the supplied account.
- **source** (`evidence summary`): The protocol has a staking-contract registry, but CvxRewardDistributor.claimMultipleStaking does not apply it to each user-supplied claim contract.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xa7b0e924c2dbb9b4f576cce96ac80657e42c3e42` | `storage_contract` | `crvFRAX` | -15925.234299672041310152 | -$15900.11 |

## Root cause analysis

- **Title**: Unchecked user-supplied staking claim contract forged CVG reward entitlement
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Every CVG staking reward mint must be derived from a registered staking contract's own accounting for the claimant, not from an arbitrary external contract supplied in calldata.

### Final root cause

CvxRewardDistributor.claimMultipleStaking accepts caller-supplied staking claim contracts and calls claimCvgCvxMultiple on each without proving that the contract is an authorized staking service. The attacker supplied an attacker-controlled helper that returned a forged, huge cvgClaimable value; the distributor trusted it and called CVG.mintStaking, which minted the remaining staking allocation to the attacker-controlled receiver. The attacker then swapped the newly minted CVG for crvFRAX and WETH.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x2b083beaac310cc5e190b1d2507038ccb03e7606` | `CvxRewardDistributor proxy` | `primary vulnerable contract` | `0x47c69e8c909ce626af73c955a5e34a20b7c71f19` |
| `0x47c69e8c909ce626af73c955a5e34a20b7c71f19` | `CvxRewardDistributor` | `implementation containing vulnerable branch` | `—` |
| `0x97effb790f2fbb701d88f89db4521348a2b77be8` | `Cvg` | `downstream token minter enforcing cap` | `—` |

### Recommended fixes

- In CvxRewardDistributor.claimMultipleStaking, require each claimContracts entry to be a registered staking contract before calling claimCvgCvxMultiple, or replace the user-supplied list with a protocol-maintained allowlist.
- Keep CVG.mintStaking capped, but do not rely on the cap as entitlement validation; validate the reward source and claimant accounting before any mint request reaches CVG.

### Limitations

- internal evidence was not present/readable in this output root; the verified Foundry PoC and on-disk source were used instead.
- Selector 0x23446652 was unresolved in selector_db, but the calldata structure, proxy implementation source, and PoC reconstruction match claimMultipleStaking.
