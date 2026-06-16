# RCA Run Report — bsc 0xc9bccafd…bad4c8


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xc9bccafdb0cd977556d1f88ac39bf8b455c0275ac1dd4b51d75950fb58bad4c8`
- **Block**: 47469060
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1105.39s (1105395 ms)
- **Finding**: WebKeyProSales buy() minted immediately liquid wkeyDAO without a value or vesting bound


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
- **Incident net loss**: unknown
- **PoC net reproduced**: $737977.76
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

- Transaction: `0xc9bccafdb0cd977556d1f88ac39bf8b455c0275ac1dd4b51d75950fb58bad4c8`
- Block: `47469060`
- Root call type: `CALL`
- Target/tx.to: `0x3783c91ee49a303c17c558f92bf8d6395d2f76e3`
- Attacker: `0x3026c464d3bd6ef0ced0d49e80f171b58176ce32`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x3026c464d3bd6ef0ced0d49e80f171b58176ce32` | `tx_from_eoa` | `USDT` | 737321.043501382964470008 | $737977.76 |
| poc_selected_direct_attacker_gain | gain | `0x3783c91ee49a303c17c558f92bf8d6395d2f76e3` | `attacker_callback` | `WKNFT` | 0.000000000000000067 | N/A |


## Root cause analysis

- **Title**: WebKeyProSales buy() minted immediately liquid wkeyDAO without a value or vesting bound
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A sale purchase must not mint and release liquid wkeyDAO whose market-drainable value is not bounded by the paid price or by an enforced vesting/escrow rule.

### Final root cause

WebKeyProSales.buy() on proxy 0xd511096a73292a7419a94354d4c1c73e8a3cd851 accepts currentSaleInfo.price, then uses currentSaleInfo.immediateReleaseTokens as an immediate liquid wkeyDAO mint amount. The function has no trusted market-value, oracle/TWAP, solvency, or vesting bound before IMintable(wkey).mint(address(this), immediateTokens) and transfer(msg.sender, immediateTokens). The attacker repeated the branch 67 times, creating 15410000000000 raw wkeyDAO and swapping it through Pancake for USDT.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xd511096a73292a7419a94354d4c1c73e8a3cd851` | `TransparentUpgradeableProxy` | `primary vulnerable proxy` | `0xc39c54868a4f842b02a99339f4a57a44efc310b8` |
| `0xc39c54868a4f842b02a99339f4a57a44efc310b8` | `WebKeyProSales` | `primary vulnerable implementation` | `—` |

### Recommended fixes

- In Sales.sol:143-147, require a trusted value bound such as currentSaleInfo.price >= oracleOrTWAPValue(immediateTokens) before minting liquid wkey, or mint immediateTokens only into a vesting/escrow mechanism instead of transferring it directly to msg.sender.

### Limitations

- The available evidence do not include the prior transaction that configured currentSaleInfo; this RCA does not claim that setup was unauthorized.
- wkeyDAO token source was not present under source bundle, but the selected root cause is in the Sales implementation and the mint/transfer effects are supported by execution logs and RPC supply observations.
