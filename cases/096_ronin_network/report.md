# RCA Run Report — ethereum 0xc28fad5e…67d0b7


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xc28fad5e8d5e0ce6a2eaf67b6687be5d58113e16be590824d6cfa1a94467d0b7`
- **Block**: 14442835
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 783.25s (783251 ms)
- **Finding**: Gateway withdrawal consumed a prior validator-quorum authority and released WETH to the attacker


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
- **PoC net reproduced**: $514132282.82
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

- Transaction: `0xc28fad5e8d5e0ce6a2eaf67b6687be5d58113e16be590824d6cfa1a94467d0b7`
- Block: `14442835`
- Root call type: `CALL`
- Target/tx.to: `0x1a2a1c938ce3ec39b6d47113c7955baa9dd454f2`
- Attacker: `0x098b716b8aaf21512996dc57eb0615e2383e2f96`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x098b716b8aaf21512996dc57eb0615e2383e2f96` | `tx_from_eoa` | `ETH` | 173600 | $514132282.82 |


## Root cause analysis

- **Title**: Gateway withdrawal consumed a prior validator-quorum authority and released WETH to the attacker
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Mainchain escrow must not be released unless the withdrawal is backed by legitimate sidechain withdrawal provenance and uncompromised validator-quorum authority.

### Final root cause

The transaction called the gateway withdrawal path with a signature blob that recovered five registered validators, passed MainchainValidator.checkThreshold(5), and then released 173,600 WETH/ETH to the attacker-controlled recipient path. Available evidence prove the local validator-quorum consumption and payout path but do not prove whether the signing authority came from compromised keys, colluding validators, or prior setup outside this transaction. Because the exact prior provenance and gateway implementation source are missing, the RCA is partial.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x1a2a1c938ce3ec39b6d47113c7955baa9dd454f2` | `MainchainGatewayProxy` | `primary gateway whose withdrawal branch released escrowed WETH/ETH` | `0x8407dc57739bcda7aa53ca6f12f82f9d51c2f21e` |
| `0x42b19dca30fd612b1757682c074497847f2b57e0` | `MainchainValidator` | `validator-set and quorum authority consumed by the gateway` | `—` |
| `0x33e71e649abdc09f650ad44139674828a2075ad2` | `Registry` | `registry used to resolve token and validator contract addresses` | `—` |

### Recommended fixes

- In the gateway withdrawal authorization branch, require independently verifiable sidechain withdrawal provenance in addition to validator quorum before releasing mainchain escrow.
- Rotate and harden validator signing authority, use stronger quorum/key isolation, and monitor unusual high-value withdrawals because the decisive local authority was validator-signature based.
- Add replay/provenance controls around withdrawal ids and signer intent in the implementation branch that writes withdrawals and calls WETH withdraw.

### Limitations

- implementation_source_gap: gateway implementation source for 0x8407dc57739bcda7aa53ca6f12f82f9d51c2f21e is not present under internal evidence
- prior_authority_or_key_provenance_gap: available evidence do not prove how the five validator signatures were obtained
- tx_scope_gap: if the ultimate cause was key compromise, validator collusion, or prior governance/setup, it occurred outside this transaction scope
