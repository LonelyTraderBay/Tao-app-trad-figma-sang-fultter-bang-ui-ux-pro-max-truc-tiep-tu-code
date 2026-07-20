---
paths:
  - "flutter_app/lib/app/providers/**"
  - "flutter_app/lib/features/**/presentation/controllers/**"
  - "flutter_app/lib/features/**/data/**"
---
# State Management / Controller Pattern (ADR-001)

Decision record: `docs/05_ARCHITECTURE/decisions/ADR-001-async-error-idiom.md`
(chốt GĐ2 · STATE-S26). Guardrail:
`flutter_app/test/quality/state_management_guardrail_test.dart`.

## Decision tree

- Controller with **mutation / async / status transition** ⇒ `NotifierProvider`
  (pure async read path ⇒ `AsyncNotifierProvider`). Family arg via constructor
  (`ClassName.new`, Riverpod 3 idiom). Reference implementations:
  `NotificationsStateController`
  (`lib/app/providers/notifications_controller_providers.dart`) and
  `TradeOrderController`.
- `Provider<Controller>` const ONLY for **pure read-models** (no status writes,
  no repo writes) — e.g. `tradeReadModelControllerProvider`,
  `TradeMarginController`.
- High-risk state machines use the 10-value `TradeHighRiskFlowStatus` enum,
  NOT wrapped in `AsyncValue`.

## Bans

- No seeding `late List` from `ref.read` then mutating with `setState`
  (dual source of truth — STATE-S23).
- Family keys: scalar / record-of-scalar only, otherwise `.autoDispose` is
  mandatory (STATE-S24).

## Wiring

Feature/screen controller providers live in the composition root
`app/providers/<feature>_controller_providers.dart` (27 files / 28 modules;
`trade_core` intentionally has none). Repository contracts in `domain/`,
mock/remote implementations + base provider in `data/`.
