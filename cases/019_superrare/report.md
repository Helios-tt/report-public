# RCA Run Report — ethereum 0xd813751b…a6e3c1


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xd813751bfb98a51912b8394b5856ae4515be6a9c6e5583e06b41d9255ba6e3c1`
- **Block**: 23016423
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 654.01s (654013 ms)
- **Finding**: Anyone could publish a SuperRare staking Merkle root and claim the full RARE balance.


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: victim loss usd
- **Verdict**: victim_loss_exact
- **Incident net loss**: $731375.68
- **PoC net reproduced**: $731375.68
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

- Transaction: `0xd813751bfb98a51912b8394b5856ae4515be6a9c6e5583e06b41d9255ba6e3c1`
- Block: `23016423`
- Root call type: `CALL`
- Target/tx.to: `0x2073111e6ebb6826f7e9c6192c6304aa5af5e340`
- Attacker: `0x5b9b4b4dafbcfceea7afba56958fcbb37d82d4a2`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| dynamic_instantiation | unknown | `0x643a0e92` | `0x08947cedf35f9669012bda6fda9d03c399b017ab` | `11` |
| dynamic_instantiation | getTokenBalance() | `0x82b2e257` | `0x08947cedf35f9669012bda6fda9d03c399b017ab` | `8` |
| dynamic_instantiation | getStakingContractBalance() | `0xc486ad37` | `0x08947cedf35f9669012bda6fda9d03c399b017ab` | `5` |
| dynamic_instantiation | unknown | `entry` | `0x08947cedf35f9669012bda6fda9d03c399b017ab` | `2` |
| attacker_entry | unknown | `0xad24067c` | `0x2073111e6ebb6826f7e9c6192c6304aa5af5e340` | `1` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `victim_loss_exact`
- Comparison basis: `victim_loss_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| incident_drain | loss | `0x3f4d749675b3e48bccd932033808a7079328eb48` | `RARE` | -11907874.71301910452905796 | $-731375.68 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x3f4d749675b3e48bccd932033808a7079328eb48` | `storage_contract` | `RARE` | -11907874.71301910452905796 | $-731375.68 |


## Root cause analysis

- **Title**: Anyone could publish a SuperRare staking Merkle root and claim the full RARE balance.
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Only an authorized root publisher may update currentClaimRoot; untrusted callers must not be able to create claim entitlement for themselves.

### Final root cause

RareStakingV1.updateMerkleRoot(bytes32) used an authorization predicate that passes for the attacker-controlled child because msg.sender != the hardcoded updater is true, so the OR expression does not restrict root publication. The attacker set currentClaimRoot to the leaf for its own address and the full staking balance, then called claim(uint256,bytes32[]) with an empty proof. claim trusted the attacker-published root and transferred 11907874713019104529057960 RARE from the staking proxy.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x3f4d749675b3e48bccd932033808a7079328eb48` | `ERC1967Proxy` | `staking proxy holding drained RARE` | `0xffb512b9176d527c5d32189c3e310ed4ab2bb9ec` |
| `0xffb512b9176d527c5d32189c3e310ed4ab2bb9ec` | `RareStakingV1` | `primary vulnerable implementation` | `—` |
| `0xba5bde662c17e2adff1075610382b9b691296350` | `RARE token proxy` | `downstream token transfer contract` | `0x31acaaea0529894e7c3a5c70d3f9ee6d7804684f` |

### Recommended fixes

- Replace RareStakingV1.sol:179 with an allow-list or onlyOwner authorization check that requires msg.sender to equal an authorized root publisher before writing currentClaimRoot.
- Add tests proving unauthorized callers cannot call updateMerkleRoot and cannot make an empty-proof claim by publishing a root equal to their own leaf.
