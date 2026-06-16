# RCA Run Report — optimism 0xd12016b2…54c4fe


## Case overview

- **Chain**: optimism (chain_id=10)
- **Tx hash**: `0xd12016b25d7aef681ade3dc3c9d1a1cc12f35b2c99953ff0e0ee23a59454c4fe`
- **Block**: 129697251
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1039.17s (1039171 ms)
- **Finding**: MoonHacker flash-loan callback lacks caller validation and lets attackers redeem and approve victim funds


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
- **Incident net loss**: $319784.88
- **PoC net reproduced**: $318971.66
- **USD ratio**: 0.997x

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

- Transaction: `0xd12016b25d7aef681ade3dc3c9d1a1cc12f35b2c99953ff0e0ee23a59454c4fe`
- Block: `129697251`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x36491840ebcf040413003df9fb65b6bc9a181f52`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 6

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x24592ed1ccf9e5ae235e24a932b378891313fb75` | `storage_contract` | `mUSDC` | -2627692.65535659 | N/A |
| incident_drain | loss | `0x80472c6848015146fdc3d15cdf6dc11ca3cb3513` | `storage_contract` | `mUSDC` | -53006424.78793435 | N/A |
| incident_drain | loss | `0x8e08617b0d66359d73aa11e11017834c29155525` | `storage_contract` | `USDC` | -319429.531352 | $-319413.60 |
| incident_drain | loss | `0xd9b45e2c389b6ad55dd3631abc1de6f2d2229847` | `storage_contract` | `mUSDC` | -29142993.00544423 | N/A |
| incident_drain | loss | `0xf9524bfa18c19c3e605fbfe8dfd05c6e967574aa` | `storage_contract` | `OP` | -191.284209780459277074 | $-371.28 |
| incident_drain | loss | `0xf9524bfa18c19c3e605fbfe8dfd05c6e967574aa` | `storage_contract` | `WELL` | -10900.526042791663905553 | N/A |


## Root cause analysis

- **Title**: MoonHacker flash-loan callback lacks caller validation and lets attackers redeem and approve victim funds
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Only the configured flash-loan pool, for a loan initiated by MoonHacker itself, may execute callback logic that redeems collateral, claims rewards, or approves token spenders; mToken and token parameters must be trusted or owner-approved.

### Final root cause

MoonHacker exposes executeOperation(address,uint256,uint256,address,bytes) as an unauthenticated external callback. Because it does not require msg.sender to be the configured Aave Pool or initiator to be the contract, an attacker can supply arbitrary params, force the REDEEM branch to repay/redeem MoonHacker's mUSDC and claim rewards, then force the SUPPLY branch to approve an attacker-controlled mToken spender. The final transferFrom is downstream use of the allowance created by that invalid callback branch.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x24592ed1ccf9e5ae235e24a932b378891313fb75` | `MoonHacker` | `primary vulnerable contract` | `—` |
| `0x80472c6848015146fdc3d15cdf6dc11ca3cb3513` | `MoonHacker` | `same vulnerable contract pattern` | `—` |
| `0xd9b45e2c389b6ad55dd3631abc1de6f2d2229847` | `MoonHacker` | `same vulnerable contract pattern` | `—` |
| `0xce5e0e2bcf40a049a6e148f411a19419d0443607` | `MoonHacker` | `same vulnerable contract pattern` | `—` |

### Recommended fixes

- Add callback authentication to MoonHacker.executeOperation: require msg.sender == address(POOL) and initiator == address(this) before decoding params or moving funds.
- Validate token and mToken against owner-approved allowlists before approving, minting, borrowing, repaying, redeeming, or claiming rewards.
- Remove arbitrary calldata-controlled token approvals; if approval is needed, approve only known protocol contracts for exact amounts and reset allowances after use.

### Limitations

- The evidence summary did not provide full execution context for every MoonHacker executeOperation step, so PoC line references and verified MoonHacker source are used for exact callback branch mapping.
- No semantic claim is made about raw storage slots in reward distributor steps; those steps are treated only as downstream impact evidence.
