# RCA Run Report — ethereum 0xd64729c5…fc89c2


## Case overview

- **Chain**: ethereum (chain_id=42161)
- **Tx hash**: `0xd64729c528e6689cb18b0c90345ab0c9ed18fea44247c89af2f1374643fc89c2`
- **Block**: 391402008
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1029.85s (1029852 ms)
- **Finding**: One-click swap output flow counts temporary ephemeral collateral as margin entitlement before settlement


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
- **Incident net loss**: unknown
- **PoC net reproduced**: $1.00
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

- Transaction: `0xd64729c528e6689cb18b0c90345ab0c9ed18fea44247c89af2f1374643fc89c2`
- Block: `391402008`
- Root call type: `CALL`
- Target/tx.to: `0xd9ff21caeeea4329133c98a892db16b42f9baa25`
- Attacker: `0xd356c82e0c85e1568641d084dbdaf76b8df96c08`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_callback | onERC721Received(address,address,uint256,bytes) | `0x150b7a02` | `0xd9ff21caeeea4329133c98a892db16b42f9baa25` | `9` |
| attacker_callback | onMorphoFlashLoan(uint256,bytes) | `0x31f57072` | `0xd9ff21caeeea4329133c98a892db16b42f9baa25` | `7` |
| attacker_entry | fuck() | `0x4d6249d1` | `0xd9ff21caeeea4329133c98a892db16b42f9baa25` | `1` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0xd9ff21caeeea4329133c98a892db16b42f9baa25` | `MAT` | 0.000000000000000001 | N/A |
| poc_selected_direct_attacker_gain | gain | `0xd9ff21caeeea4329133c98a892db16b42f9baa25` | `USDC` | 0.000000000000999999 | $1.00 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0xd9ff21caeeea4329133c98a892db16b42f9baa25` | `attacker_entry` | `MAT` | 0.000000000000000001 | N/A |
| poc_selected_direct_attacker_gain | gain | `0xd9ff21caeeea4329133c98a892db16b42f9baa25` | `attacker_entry` | `USDC` | 0.000000000000999999 | $1.00 |


## Root cause analysis

- **Title**: One-click swap output flow counts temporary ephemeral collateral as margin entitlement before settlement
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: Ephemeral tokens minted only for an in-flight swap must not be valued as withdrawable margin collateral or permit real collateral withdrawal before real settlement and a post-action solvency check.

### Final root cause

The source-visible one-click swap-output branch mints an ephemeral token, deposits it to the margin account, and withdraws real token value before the exact-output swap settles. The margin valuation and withdrawal path accepts the temporary account state instead of excluding in-flight synthetic collateral or enforcing post-settlement solvency. Triggered through increaseLongPosition(18, WBTC, 36200000), this creates an in-transaction margin entitlement that downstream transferFrom steps use to move WBTC into the margin account.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x498ed9bdf41e2b1188a8383e76feb82c3c38c4f8` | `OneClickEphemeralSwapOutput` | `primary vulnerable contract` | `—` |
| `0xd50d8f69d7bc55614f596f4eebe9d09b738b0137` | `MarginTrading` | `margin valuation and health gate` | `—` |
| `0x5c4795469316453bcb7057b1b7cbd85c9e122580` | `MarginAccount` | `margin account storage and token custody` | `—` |

### Recommended fixes

- In OneClickEphemeralSwapOutput.swapOutput, do not provide ephemeral tokens as margin collateral that can authorize withdrawal of real token value; settlement should happen before collateral accounting changes are trusted.
- In MarginTrading and margin-account valuation, exclude ephemeral/in-flight tokens from collateral value and available ERC20 accounting unless backed by finalized real assets.
- Add a post-swap solvency check after exact-output settlement and before any real token withdrawal or position-finalization effect is accepted.

### Limitations

- missing_assumption: exact TradeRouter/facade source for increaseLongPosition and its call into OneClickEphemeralSwapOutput is absent under source bundle.
- source_branch_gap: margin-account storage/source for provideERC20, withdrawERC20, checkERC20Amount, and available ERC20 registry semantics is absent.
- RPC observations status is partial, although the decisive WBTC totalSupply and margin-account balance observations used here are present.
- The RCA therefore identifies the strongest supported accounting branch and violated invariant, but does not claim complete line-by-line patchability for the public entry branch.
