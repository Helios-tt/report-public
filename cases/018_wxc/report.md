# RCA Run Report — bsc 0x1397bc7f…ad068f


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x1397bc7f0d284f8e2e30d0a9edd0db1f3eb0dd284c75e30d226b02bf09ad068f`
- **Block**: 57177438
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 762.11s (762109 ms)
- **Finding**: WXC transferFrom mutates AMM pair reserves during router pricing


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
- **Verdict**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Incident net loss**: $34669.05
- **PoC net reproduced**: $31071.67
- **USD ratio**: 0.896x

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

- Transaction: `0x1397bc7f0d284f8e2e30d0a9edd0db1f3eb0dd284c75e30d226b02bf09ad068f`
- Block: `57177438`
- Root call type: `CALL`
- Target/tx.to: `0x798465b25b68206370d99f541e11eea43288d297`
- Attacker: `0x476954c752a6ee04b68382c97f7560040eda7309`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_callback | onMoolahFlashLoan(uint256,bytes) | `0x13a1a562` | `0x798465b25b68206370d99f541e11eea43288d297` | `11` |
| attacker_entry | unknown | `0x32e4d6f3` | `0x798465b25b68206370d99f541e11eea43288d297` | `1` |
| attacker_internal | unknown | `0x6c496ac4` | `0x798465b25b68206370d99f541e11eea43288d297` | `12` |
| attacker_callback | unknown | `0x84800812` | `0x798465b25b68206370d99f541e11eea43288d297` | `30` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `close`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| incident_d

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0xda5c7ea4458ee9c5484fa00f2b8c933393bac965` | `storage_contract` | `WXC` | -71589789.332022099676595255 | N/A |
| incident_drain | loss | `0xda5c7ea4458ee9c5484fa00f2b8c933393bac965` | `storage_contract` | `WBNB` | -41.90268471956639884 | $-34669.05 |


## Root cause analysis

- **Title**: WXC transferFrom mutates AMM pair reserves during router pricing
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: A token transferFrom to an AMM pair must only apply the intended balance/allowance transition and must not call pair sync, burn pair-held balance, or reenter router/pair accounting before AMM input is measured.

### Final root cause

WXC proxy 0x8087720eeea59f9f04787065447d52150c09643e, via implementation 0x4c100d30d9c511b8bb9d1c951bbc1be489a0172f, executed transferFrom(address,address,uint256) during a Pancake router sell and performed nonstandard AMM-reserve-changing side effects before router pricing completed. The execution evidence shows the WXC transferFrom step calling the router, causing nested pair swaps, burning/moving pair WXC, calling pair sync, and only later transferring attacker WXC to the pair. This violates the invariant that ERC20 transferFrom into an AMM pair must not reset pair reserves or mutate unrelated pair-held balances before the router/pair computes input and enforces K.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x8087720eeea59f9f04787065447d52150c09643e` | `WXC proxy` | `primary vulnerable contract` | `0x4c100d30d9c511b8bb9d1c951bbc1be489a0172f` |
| `0xda5c7ea4458ee9c5484fa00f2b8c933393bac965` | `PancakePair` | `impacted AMM pair` | `—` |

### Recommended fixes

- In the WXC implementation, remove or strictly gate transferFrom side effects that call the router, burn/move pair-held WXC, or call pair sync before AMM accounting completes.
- Enforce that transferFrom to an AMM pair performs only the sender-to-recipient balance movement and allowance decrement; any fee/swap logic must not mutate the target pair reserves during the transfer.
- Add tests where a router supporting-fee swap calls WXC transferFrom and asserts the token cannot reenter router/pair accounting or call pair sync before the router computes amountInput.

### Limitations

- WXC implementation source for 0x4c100d30d9c511b8bb9d1c951bbc1be489a0172f is not present under internal evidence, so the exact vulnerable source line and guard cannot be named.
- internal evidence reconstructs the attacker flow rather than the WXC implementation branch, so source/execution summary branch evidence is insufficient for analysis_status=complete.
- missing_assumption: the partial RCA infers the WXC transferFrom branch semantics from execution evidence execution context/log effects and standard Pancake source, not from WXC source code.
