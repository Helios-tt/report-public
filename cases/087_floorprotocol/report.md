# RCA Run Report — ethereum 0xec8f6d8e…927b40


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xec8f6d8e114caf8425736e0a3d5be2f93bbea6c01a50a7eeb3d61d2634927b40`
- **Block**: 18802289
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 664.70s (664701 ms)
- **Finding**: Public extMulticall let attackers spend Floor proxy ERC721 authority through arbitrary external calls


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
- **Verdict**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Incident net loss**: unknown
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

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

- Transaction: `0xec8f6d8e114caf8425736e0a3d5be2f93bbea6c01a50a7eeb3d61d2634927b40`
- Block: `18802289`
- Root call type: `CALL`
- Target/tx.to: `0x7e5433f02f4bf07c4f2a2d341c450e07d7531428`
- Attacker: `0x4d0d746e0f66bf825418e6b3def1a46ec3c0b847`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|-

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0xe5442ae87e0fef3f7cc43e507adf786c311a0529` | `transfer_counterparty` | `PPG` | -0.000000000000000036 | N/A |


## Root cause analysis

- **Title**: Public extMulticall let attackers spend Floor proxy ERC721 authority through arbitrary external calls
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A public batch-call router must not let untrusted callers execute arbitrary external calls from the protocol proxy address or consume that proxy's token authority.

### Final root cause

FlooringPeriphery exposed extMulticall((address,bytes)[]) as an external function that forwards arbitrary user supplied target/callData pairs with target.call from the Floor proxy address. The function has no trusted-caller guard, target allowlist, selector allowlist, or binding between the caller and the authority being spent. The attacker used that branch to make the proxy call PPG safeTransferFrom for NFTs owned by 0xe5442ae87e0fef3f7cc43e507adf786c311a0529, causing PPG to accept the proxy as the caller and move 36 raw PPG units to the attacker.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x49ad262c49c7aa708cc2df262ed53b64a17dd5ee` | `Floor proxy / FlooringPeriphery` | `primary vulnerable contract` | `0xc538d17a6aacc5271be5f51b891e2e92c8187edd` |
| `0xbd3531da5cf5857e7cfaa92426877b022e612cf8` | `PudgyPenguins` | `downstream asset contract` | `—` |

### Recommended fixes

- Restrict Multicall.extMulticall to trusted callers or remove it; before line 51 executes target.call, validate msg.sender and enforce target/selector allowlists that cannot spend the proxy's ERC721 authority on arbitrary owner assets.
- Avoid granting broad ERC721 authority to externally callable router contracts unless every public entrypoint that can use that authority binds the owner/source wallet to msg.sender or a protocol-validated operation.

### Limitations

- The available evidence do not prove the provenance or exact form of the PPG authority recognized for the Floor proxy, such as per-token approval versus operator approval. This does not affect the selected in-transaction root cause because the source and execution evidence prove public extMulticall let an untrusted caller consume that authority.
