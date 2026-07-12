# Module hub prompts — Redesign UI (bộ đồng bộ)

**Bắt đầu tại:** [EXECUTION-PLAYBOOK.md](EXECUTION-PLAYBOOK.md) — 66 bước, copy-paste từng chat.  
**Contract chung:** [REDESIGN-CONTRACT.md](REDESIGN-CONTRACT.md)  
**Routing:** [ke-hoach-redesign-theo-module.md](../redesign/ke-hoach-redesign-theo-module.md) v2.5

## Tier A — 11 hub (+ Trading Bots trong Trade)

| batch_id | module | File | Trade sub-hub |
| --- | --- | --- | --- |
| `RD-M02-B01` | auth | [auth-hub.md](auth-hub.md) | |
| `RD-K01` | markets | [markets-hub.md](markets-hub.md) | |
| `RD-T01` | trade | [trade-core-hub.md](trade-core-hub.md) | Core spot/futures |
| `RD-T02` | trade | [trading-bots-hub.md](trading-bots-hub.md) | Bots SC-059 |
| `RD-T05` | trade | [copy-trading-hub.md](copy-trading-hub.md) | Copy trading |
| `RD-W01` | wallet | [wallet-hub.md](wallet-hub.md) | |
| `RD-P01` | p2p | [p2p-hub.md](p2p-hub.md) | |
| `RD-E01` | earn | [earn-staking-hub.md](earn-staking-hub.md) | |
| `RD-R01` | predictions | [predictions-hub.md](predictions-hub.md) | |
| `RD-A01` | arena | [arena-hub.md](arena-hub.md) | |
| `RD-L01` | launchpad | [launchpad-hub.md](launchpad-hub.md) | |

**Trade module:** 3 sub-hub (`T01` → `T02` → `T05` theo playbook) trước batch con T03–T11.

Legacy redirect: [trading-bots-hub.md](trading-bots-hub.md) → `trading-bots-hub.md`.

## Tier B

| Loại | Load |
| --- | --- |
| Batch con (`B_child`) | Playbook step + `_template-tier-b-batch.md` + partial `module_prompt` |
| Module nhỏ (`B_simple`) | Playbook step + template + accent |

## Templates

- [_template-tier-a-hub.md](_template-tier-a-hub.md)
- [_template-tier-b-batch.md](_template-tier-b-batch.md)

Regenerate playbook + CSV: `py -3 flutter_app/tool/gen_redesign_plan.py`
