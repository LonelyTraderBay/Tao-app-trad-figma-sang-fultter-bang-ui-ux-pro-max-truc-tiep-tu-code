# UI/UX Reorg Master Plan

Generated: 2026-07-21  
Prerequisite: `UI-UX-Pre-Implementation-Gate.md`. Batches: **5–10 files**; new chat per batch.

## Locked decisions

- 5 bottom tabs; active-tab Option A
- Trade = Spot terminal-first
- P2P = marketplace-first + hub drawer
- Earn dual entry + legal sheet
- Discovery canonical on Home
- GOM: Profile Pháp lý + Earn sheet

## Phases

| Phase | Scope |
|-------|-------|
| 0 | Evidence pack — DONE |
| 1 | Home + Profile (2–3 batches) |
| 2 | Markets + Trade + Wallet |
| 3 | Earn/Savings + P2P |
| 4 | Discovery family |
| 5 | States + sparse P0 |
| 6 | Wiring sweeps + Visual QA expand |

## Phase 1 batches

1.1 Home product IA data (`home_mock_data` + products widgets)
1.2 Home header News
1.3 Profile sections + Pháp lý scaffold

## Verify each code batch

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```
