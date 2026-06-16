# RCA Run Report — base 0xd10faa5b…5df9f6


## Case overview

- **Chain**: base (chain_id=8453)
- **Tx hash**: `0xd10faa5b33ddb501b1dc6430896c966048271f2510ff9ed681dd6d510c5df9f6`
- **Block**: 25431001
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 866.00s (865995 ms)
- **Finding**: Side-effecting ERC-6492 signature validation let attackers make the Odos router transfer its own token balances


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
- **Incident net loss**: $38051.91
- **PoC net reproduced**: $38051.91
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

- Transaction: `0xd10faa5b33ddb501b1dc6430896c966048271f2510ff9ed681dd6d510c5df9f6`
- Block: `25431001`
- Root call type: `CALL`
- Target/tx.to: `0x22a7da241a39f189a8aec269a6f11a238b6086fc`
- Attacker: `0x4015d786e33c1842c3e4d27792098e4a3612fc0e`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | exploit(address,address[]) | `0xf536cfa0` | `0x22a7da241a39f189a8aec269a6f11a238b6086fc` | `1` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `exact`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `VIRTUAL` | -1514.424244715040557606 | $-4055.33 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` |

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 10

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `VIRTUAL` | -1514.424244715040557606 | $-4055.33 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `cbETH` | -0.144206352825325002 | $-510.36 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `WETH` | -2.261323351186171128 | $-7368.93 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `EURC` | -198.830527 | $-207.05 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `USDC` | -15578.334373 | $-15579.70 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `AERO` | -2134.216454655905106108 | $-2219.38 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `FAI` | -81182.355184994926311507 | $-4554.30 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `wstETH` | -0.122592242770994685 | $-475.29 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `cbBTC` | -0.02343323 | $-2472.36 |
| incident_drain | loss | `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `storage_contract` | `LBTC` | -0.00576319 | $-609.21 |


## Root cause analysis

- **Title**: Side-effecting ERC-6492 signature validation let attackers make the Odos router transfer its own token balances
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Signature validation must not permit arbitrary caller-supplied external calls to spend assets held by the validating contract; counterfactual validation side effects must be restricted or reverted.

### Final root cause

OdosLimitOrderRouter exposes public isValidSigImpl(address,bytes32,bytes,bool) and its ERC-6492 branch executes caller-controlled create2Factory.call(factoryCalldata) when the supplied signer has no code. The attacker set signer to 0x0000000000000000000000000000000000000004, passed allowSideEffects=true, and encoded each token contract plus transfer(attacker, amount) as the factory call, so the router itself spent its token balances before validation completed. The transfer steps are effects; the invariant-breaking decision is the validator allowing persistent arbitrary external side effects from router context.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xb6333e994fd02a9255e794c177efbdeb1fe779c7` | `OdosLimitOrderRouter` | `primary vulnerable contract` | `—` |

### Recommended fixes

- In OdosLimitOrderRouter.sol:2024-2047, prevent public callers from enabling persistent ERC-6492 side effects; public validation should force allowSideEffects=false or revert after validation.
- Restrict the ERC-6492 factory path to trusted deploy factories and reject arbitrary token contracts or arbitrary calldata as create2Factory/factoryCalldata.
- Add regression tests that direct calls to isValidSigImpl with signer address(4), ERC6492 suffix, and token transfer calldata cannot alter router-held ERC20 balances.
