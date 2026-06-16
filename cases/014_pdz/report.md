# RCA Run Report — bsc 0x81fd00ea…6f05a5


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x81fd00eab3434eac93bfdf919400ae5ca280acd891f95f47691bbe3cbf6f05a5`
- **Block**: 57744491
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 525.69s (525689 ms)
- **Finding**: TOKENbnb pays native BNB rewards from a manipulable AMM spot quote and reflected balance delta


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
- **Incident net loss**: $3009.30
- **PoC net reproduced**: $2800.35
- **USD ratio**: 0.931x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

TOKENbnb burnToHolder computes the reward basis with PancakeRouter.getAmountsOut over the current PDZ/WBNB spot path, then burnFeeRewards records only a principal marker while internal reflection transfers can increase the caller's balance. receiveRewards treats balanceOf(msg.sender) minus burnAmount[msg.sender] as claimable native BNB and transfers amount * 1e9 wei without a funded reward ledger, TWAP, reserve-depth check, or solvency cap. After manipulating the PDZ/WBNB spot price, the attacker created an inflated claim and immediately withdrew BNB from TOKENbnb.

**Violated invariant**: Native-BNB rewards must be paid only from explicitly funded, non-manipulable reward accounting and must not be computed from same-transaction AMM spot quotes or mutable reflected token balances.

| Field | Value |
|---|---|
| Entry function | burnToHolder(uint256,address) followed by receiveRewards(address) |
| Funding source | WBNB/PDZ Pancake swap path and TOKENbnb native BNB balance |
| Attacker callbacks | helper callback selector 0x84800812 |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `BNB` | 3.352094698712248469 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passes with no hard static validation blockers.
- **evidence** (`evidence summary`): Evidence summary connects TOKENbnb burnToHolder and receiveRewards steps to direct BNB/TB Build loss and attacker BNB profit.
- **source** (`evidence summary`): Source shows the spot getAmountsOut reward basis, burnAmount principal marker, reflected balance-derived claim, and native payout.
- **source** (`evidence summary`): Router quote uses current pair reserves, supporting same-transaction spot-price manipulation as the reward input.
- **balance_impact** (`evidence summary`): Confirms direct victim native-BNB loss and attacker native-BNB profit.
- **negative_evidence** (`evidence summary`): PDZ and TB Build totalSupply do not expand, rejecting a giant-mint root cause; TOKENbnb holder balance loss is a transfer/accounting effect.
- **attack_path** (`execution summary`): Shows attacker order: WBNB-to-PDZ swap, burnToHolder, receiveRewards, PDZ sale, WBNB handling, and final BNB return.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x664201579057f50d23820d20558f4b61bd80bdda` | `storage_contract` | `BNB` | -3.606408757 | -$3009.30 |
| loss | `0x664201579057f50d23820d20558f4b61bd80bdda` | `storage_contract` | `TB Build` | -4.767358971 | N/A |
| loss | `0x7b51150f5a61e97f62447e59c7947660822438ab` | `storage_contract` | `PDZ` | -0.000000056371593044 | N/A |

## Root cause analysis

- **Title**: TOKENbnb pays native BNB rewards from a manipulable AMM spot quote and reflected balance delta
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Native-BNB rewards must be paid only from explicitly funded, non-manipulable reward accounting and must not be computed from same-transaction AMM spot quotes or mutable reflected token balances.

### Final root cause

TOKENbnb burnToHolder computes the reward basis with PancakeRouter.getAmountsOut over the current PDZ/WBNB spot path, then burnFeeRewards records only a principal marker while internal reflection transfers can increase the caller's balance. receiveRewards treats balanceOf(msg.sender) minus burnAmount[msg.sender] as claimable native BNB and transfers amount * 1e9 wei without a funded reward ledger, TWAP, reserve-depth check, or solvency cap. After manipulating the PDZ/WBNB spot price, the attacker created an inflated claim and immediately withdrew BNB from TOKENbnb.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x664201579057f50d23820d20558f4b61bd80bdda` | `TOKENbnb` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Replace PancakeRouter spot getAmountsOut in burnToHolder with a TWAP/trusted oracle and reject burns whose quoted value exceeds configured reserve-depth or slippage bounds.
- Track explicit per-user funded reward accrual instead of computing claimable BNB as balanceOf(user) - burnAmount[user].
- Cap receiveRewards payouts by a funded reward pool and update user reward state before external native transfers.
- Remove reflection side-effect transfers from reward accrual or exclude reflected balance changes from claimable native-BNB accounting.

### Limitations

- internal evidence was not present in the manifest; the attack order is supported by execution summary and the Foundry PoC instead.
- Exact intermediate Pancake pair reserve values were not decoded because the source-backed spot-quote mechanism and verified PoC were sufficient for the patchable cause.
