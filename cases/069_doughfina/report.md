# RCA Run Report — ethereum 0x92cdcc73…1ebb2e


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x92cdcc732eebf47200ea56123716e337f6ef7d5ad714a2295794fdc6031ebb2e`
- **Block**: 20288623
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 923.38s (923381 ms)
- **Finding**: Unrestricted deleveraging connector executes attacker-supplied arbitrary calls as a trusted Dough DSA connector


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
- **Incident net loss**: $1847703.92
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

- Transaction: `0x92cdcc732eebf47200ea56123716e337f6ef7d5ad714a2295794fdc6031ebb2e`
- Block: `20288623`
- Root call type: `CALL`
- Target/tx.to: `0x11a8dc866c5d03ff06bb74565b6575537b215978`
- Attacker: `0x67104175fc5fabbdb5a1876c3914e04b94c71741`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x5b8b87a8` | `0x11a8dc866c5d03ff06bb74565b6575537b215978` | `1` |
| attacker_callback | executeAction(uint256,address,uint256,address,uint256,uint256) | `0x75b4b22d` | `0x11a8dc866c5d03ff06bb74565b6575537b215978` | `60` |
| attacker_callback | receiveFlashLoan(address[],uint256[],uint256[],bytes) | `0xf04f2707` | `0x11a8dc866c5d03ff06bb74565b6575537b215978` | `12` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Hold

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x11a8dc866c5d03ff06bb74565b6575537b215978` | `attacker_callback` | `aEthUSDC` | 0.0000000000009975 | $1.00 |


## Root cause analysis

- **Title**: Unrestricted deleveraging connector executes attacker-supplied arbitrary calls as a trusted Dough DSA connector
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Only a DSA owner or authorized deleveraging automation may cause connector-authorized DSA actions, and swap payloads in the deleveraging connector must not be able to call arbitrary targets or DSA action surfaces.

### Final root cause

ConnectorDeleverageParaswap.flashloanReq is externally callable and records the caller-controlled address and swap payload into the flash-loan callback path. During executeOperation, deloopAllCollaterals decodes attacker-controlled paraSwapContract, tokenTransferProxy, and paraswapCallData, grants allowance, and calls the arbitrary target without restricting it to a trusted swap router. The attacker targeted DoughDsa.executeAction; because msg.sender was the registered connector, DoughDsa accepted the call and Aave performed normal debt repayment and WETH collateral withdrawal.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x9f54e8eaa9658316bb8006e03fff1cb191aafbe6` | `ConnectorDeleverageParaswap` | `primary vulnerable contract` | `—` |
| `0x534a3bb1ecb886ce9e7632e33d97bf22f838d085` | `DoughDsa` | `trusted DSA action surface abused through connector authorization` | `—` |

### Recommended fixes

- Restrict ConnectorDeleverageParaswap.flashloanReq to an authorized DSA or deleveraging automation path and verify that the requested DSA belongs to that authorized caller.
- In deloopAllCollaterals, allow only approved swap routers and validate calldata selectors/targets so attacker-controlled swapData cannot call DoughDsa.executeAction or token transfer primitives.
- Bind flash-loan callback data to the authorized DSA resolved before the flash loan, rather than to arbitrary msg.sender supplied by a public entrypoint.
