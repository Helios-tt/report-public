# RCA Run Report — bsc 0x4f477e94…f5663f


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x4f477e941c12bbf32a58dc12db7bb0cb4d31d41ff25b2457e6af3c15d7f5663f`
- **Block**: 86731941
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1416.82s (1416818 ms)
- **Finding**: Prior delegated borrow authority plus exchange-rate collateral inflation enabled Venus asset extraction


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $12609434.54
- **PoC net reproduced**: $4189646.08
- **USD ratio**: 1.000x

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

- Transaction: `0x4f477e941c12bbf32a58dc12db7bb0cb4d31d41ff25b2457e6af3c15d7f5663f`
- Block: `86731941`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x43c743e316f40d4511762eedf6f6d484f67b2f82`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `entry` | `0x737bc98f1d34e19539c074b8ad1169d5d45da619` | `1` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_prof

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 3
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x737bc98f1d34e19539c074b8ad1169d5d45da619` | `attacker_entry` | `Cake` | 913858.263360521396654198 | $1303638.86 |
| poc_selected_direct_attacker_gain | gain | `0x737bc98f1d34e19539c074b8ad1169d5d45da619` | `attacker_entry` | `WBNB` | 1972.530910582753621682 | $1304554.18 |
| poc_selected_direct_attacker_gain | gain | `0x737bc98f1d34e19539c074b8ad1169d5d45da619` | `attacker_entry` | `vUSDC` | 0.006000446829622765 | $1581453.04 |


## Root cause analysis

- **Title**: Prior delegated borrow authority plus exchange-rate collateral inflation enabled Venus asset extraction
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A delegated borrow must not be able to turn prior broad authority and unsolicited collateral-market cash transfers into new borrower debt and delegate-owned assets unless borrower authorization and collateral valuation remain current, bounded, and source-proven.

### Final root cause

The current transaction exercised pre-existing THE allowances and Venus approved-delegate state, then moved THE into vTHE to raise the collateral market exchange-rate input used by ComptrollerLens. Venus vUSDC borrowBehalf required approvedDelegates(borrower,msg.sender), booked debt to the borrower, and sent borrowed USDC to the delegate; Comptroller borrowAllowed accepted the borrow through a liquidity calculation that multiplied vToken balance by exchangeRate and oracle price. The same delegated-borrow and collateral-valuation surface then supported Cake and WBNB borrows routed to the attack contract. The exact prior writer and intended authorization semantics for the consumed allowances/delegate state are not proven in the available evidence, so the RCA is partial.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xeca88125a5adbe82614ffc12d0db554e2e2867c8` | `VBep20Delegator vUSDC` | `borrow and mint execution market` | `0x1be1c626ecc5f0b1569349f5dac593291ddbec2550` |
| `0xfd36e2c2a6789db23113685031d7f16329158384` | `Venus Comptroller` | `delegate-state and liquidity gate` | `facet-based: PolicyFacet 0x3c1157657240d47fe7cdd8559f2a56fc8b12ed7f; MarketFacet 0x87fdf4f0ad0f0050d411b4a524b7750572cf58b5` |
| `0x86e06ea646aA7e9fBf625bC732c31B7c97aD739f` | `VBep20Delegator vTHE` | `collateral market whose exchange rate was increased by underlying THE transfers` | `0xb25a196ed1ffdb7b6ac3c0e6eaf55bcbd7da86bd` |
| `0xf4c8e32eadec4bfe97e0f595add0f4450a863a11` | `THE` | `underlying token moved into vTHE through pre-existing holder allowances` | `—` |

### Recommended fixes

- At VBep20.sol:128-130, require explicit bounded borrower authorization for delegated borrows and consider sending borrowed assets to the borrower rather than the delegate unless a per-asset/per-amount delegation is proven.
- Before ComptrollerLens.sol:257-260 values collateral with exchangeRate, cap or reject sudden unsolicited-cash exchange-rate jumps, or exclude unsynced donated cash from collateral liquidity.
- Add monitoring and revocation tooling for broad approvedDelegates and ERC20 allowances that can combine into delegated debt plus collateral-inflation paths.

### Limitations

- prior_state_provenance_gap: the available evidence do not identify the writer or intent of approvedDelegates[0x1A358Dcf39061a57b81ccF6f6909D061ea85D623][0x737bc98f1d34e19539c074b8ad1169d5d45da619].
- prior_state_provenance_gap: the available evidence do not identify the writers or intent of the THE allowances consumed by transferFrom from six holders.
- tx_scope_gap: if a prior setup transaction is the decisive exploit root, it is outside the supplied current-transaction evidence set.
- Because of those gaps, this RCA cannot classify the prior authority as legitimate consent, compromised-key activity, missing authorization, or another upstream protocol defect.
