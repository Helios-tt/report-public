# RCA Run Report — ethereum 0xd4c7c11c…4503b0


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0xd4c7c11c46f81b6bf98284e4921a5b9f0ff97b4c71ebade206cb10507e4503b0`
- **Block**: 42481611
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 606.77s (606766 ms)
- **Finding**: Bankroll buyFor accepts self-payer deposits and mints unbacked dividend entitlement


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
- **Incident net loss**: $239574.34
- **PoC net reproduced**: $234927.59
- **USD ratio**: 0.981x

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

- Transaction: `0xd4c7c11c46f81b6bf98284e4921a5b9f0ff97b4c71ebade206cb10507e4503b0`
- Block: `42481611`
- Root call type: `CALL`
- Target/tx.to: `0x8f921e27e3af106015d1c3a244ec4f48dbfcad14`
- Attacker: `0x4645863205b47a0a3344684489e8c446a437d66c`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x564d4126af2b195ffaa7fb470ed658b1d9d07a54` | `storage_contract` | `WBNB` | -412.459593848661728154 | $-239574.34 |


## Root cause analysis

- **Title**: Bankroll buyFor accepts self-payer deposits and mints unbacked dividend entitlement
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A buy that mints internal STACK balance or distributes fee/dividend entitlement must be backed by a fresh external WBNB inflow of the credited amount.

### Final root cause

BankrollNetworkStack.buyFor(address,uint256) lets callers set _customerAddress to the Bankroll contract itself and treats WBNB transferFrom(address(this), address(this), buy_amount) as a real deposit. WBNB self-transfer can succeed without increasing Bankroll's WBNB balance, but Bankroll still increments totalDeposits, mints internal STACK balance, and distributes fees/dividends from the nominal amount. Repeated self-buys inside the flash callback inflated the attacker's withdrawable entitlement, and the later sell/withdraw steps transferred the WBNB out.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x564d4126af2b195ffaa7fb470ed658b1d9d07a54` | `BankrollNetworkStack` | `primary vulnerable contract` | `—` |

### Recommended fixes

- In BankrollNetworkStack.buyFor, reject _customerAddress == address(this) and verify Bankroll's WBNB balance increases by buy_amount before minting internal tokens or allocating fees.
- Apply the same net-token-inflow invariant to any path that increases tokenSupply_, tokenBalanceLedger_, profitPerShare_, dividendBalance_, totalDeposits, or withdrawable payout state.
