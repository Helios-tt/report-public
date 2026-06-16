# RCA Run Report — base 0x6ab5b7b5…d3149e


## Case overview

- **Chain**: base (chain_id=8453)
- **Tx hash**: `0x6ab5b7b51f780e8c6c5ddaf65e9badb868811a95c1fd64e86435283074d3149e`
- **Block**: 21512063
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1401.76s (1401764 ms)
- **Finding**: Compound-fork cToken collateral valuation allowed same-transaction inflated borrow entitlement


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
- **Incident net loss**: $885521.07
- **PoC net reproduced**: $958709.69
- **USD ratio**: 1.083x

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

- Transaction: `0x6ab5b7b51f780e8c6c5ddaf65e9badb868811a95c1fd64e86435283074d3149e`
- Block: `21512063`
- Root call type: `CALL`
- Target/tx.to: `0x7562846468089cf0e8f7b38ac53406b895284901`
- Attacker: `0x81d5187c8346073b648f2d44b9e269509513aae2`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 13

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x3d0149abd30ee101d3a9ba5efb63f653841ef149` | `storage_contract` | `PEPE` | -0.000000000000000028 | N/A |
| incident_drain | loss | `0x4c2a994ef90873e16437b19eaf29171cb19e3453` | `storage_contract` | `MIGGLES` | -540140.357829674244175888 | $-8857.72 |
| incident_drain | loss | `0x4c721a6c5a12b3f6c8a57ce2fffb2a673ef2482d` | `storage_contract` | `uSOL` | -24.633466675014019644 | $-4365.06 |
| incident_drain | loss | `0x5c52649d3c1e1d0ddf6a46e1c25a25d9fb148af8` | `storage_contract` | `WETH` | -247.435971398571237348 | $-626816.32 |
| incident_drain | loss | `0x5ebffe29f0241cf2792f9a52cad41c402061f925` | `storage_contract` | `USDT` | -18908.270171 | $-18893.51 |
| incident_drain | loss | `0x7fdc62d7696b868f98f3a9a6b7e1bed4e34dc18d` | `storage_contract` | `cbBTC` | -0.68269296 | $-46534.28 |
| incident_drain | loss | `0x8c8dc6d6bd89afe91b4bee3403448af2a7f149c5` | `storage_contract` | `WIF` | -0.000000000000053197 | N/A |
| incident_drain | loss | `0x92954a19791b39e345bee621d81360467f1f9f57` | `storage_contract` | `DEGEN` | -8098042.912568830424227988 | $-63401.66 |
| incident_drain | loss | `0x9db2965287906ba97c61500195cd84140d4ceea5` | `storage_contract` | `USD+` | -89511.194194 | $-89464.94 |
| incident_drain | loss | `0xa2092f9a2a5dd84d6df7d175673ec8a7357c551b` | `storage_contract` | `uSUI` | -13932.86655039537992478 | $-27187.59 |
| incident_drain | loss | `0xa51486f0d852689372b4d665f0fa7c7be3257b4f` | `storage_contract` | `USDz` | -0.000000000068993811 | $-0.00 |
| incident_drain | loss | `0xc8ec09d64c7d21f0a04f3d4f1047c20abdf3cd88` | `storage_contract` | `BRETT` | -74764.34254714229060459 | N/A |
| incident_drain | loss | `0xf5606e742fa2403bfd0385cc23124b84cba1037d` | `storage_contract` | `wstETH` | -7.674494588504909905 | N/A |


## Root cause analysis

- **Title**: Compound-fork cToken collateral valuation allowed same-transaction inflated borrow entitlement
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: cToken borrow liquidity must be granted only from manipulation-resistant collateral valuation and verified collateral state; same-transaction attacker-controlled price/setup changes must not create borrowable collateral beyond real deposited value.

### Final root cause

The current transaction used Morpho WETH as temporary funding, then interacted with a Compound-style cToken/Comptroller/oracle path to mint cWETH/cSUI collateral and borrow many cToken markets. The supported causal mechanism is that cSUI/cWETH collateral and liquidity were accepted after attacker-controlled same-transaction price/setup calls, allowing borrow amounts beyond real collateral value. The exact vulnerable source branch is not present in the available evidence, so this RCA is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xa2092f9a2a5dd84d6df7d175673ec8a7357c551b` | `cSUI` | `primary cToken collateral and borrow market` | `0x37b64f37106b63ffd8827d6fdf1ebdb3b54f9e4f` |
| `0x5c52649d3c1e1d0ddf6a46e1c25a25d9fb148af8` | `cWETH` | `cToken collateral mint and drained borrow market` | `0x37b64f37106b63ffd8827d6fdf1ebdb3b54f9e4f` |
| `0xf91d26405fb5e489b7c4bbc11b9a5402ae9243d3` | `unknown Comptroller-like contract` | `market entry/liquidity validation path` | `0x94a9a7cffcbdbc6898002fa2dfa92c09ee99e943` |
| `0x93d619623abc60a22ee71a15db62eede3ef4dd5a` | `unknown price oracle` | `cSUI price source used before liquidity/borrow path` | `—` |

### Recommended fixes

- Replace the cSUI collateral price source with a manipulation-resistant TWAP or external oracle and enforce stale/deviation bounds before getAccountLiquidity can authorize borrows.
- In the cToken/Comptroller path behind mint(uint256), borrow(uint256), getUnderlyingPrice(cSUI), getAccountLiquidity, and unresolved selector 0x38edc837, reject same-transaction collateral valuation that depends on attacker-controlled pool balances or freshly toggled market state.
- Add source-level tests that mint cSUI after a same-block WETH-to-uSUI price movement and assert that borrow liquidity remains bounded by pre-manipulation collateral value.

### Limitations

- source_branch_gap: verified source or decoded execution summary for cToken implementation 0x37b64f37106b63ffd8827d6fdf1ebdb3b54f9e4f is missing.
- source_branch_gap: verified source or decoded execution summary for Comptroller-like 0xf91d26405fb5e489b7c4bbc11b9a5402ae9243d3 and oracle 0x93d619623abc60a22ee71a15db62eede3ef4dd5a is missing.
- unresolved_selector_gap: selector 0x38edc837 is executed before cSUI mint/borrow setup but is unresolved in selector_db.
- missing_assumption: the exact price/account-liquidity formula and guard that accepted the inflated cSUI/cWETH entitlement cannot be source-line pinned from available evidence.
