# AI Execution Contract

These rules are mandatory for VitTrade Flutter work after the 2026-05-26
Flutter-only cleanup.

## Active Rules

- Treat `flutter_app/` as the application source of truth.
- Do not recreate the retired React/Vite app, root npm tooling, or
  `output/flutter-ui-reference`.
- Prefer existing Flutter routes, repositories, shared layout primitives, shared
  widgets, and theme tokens before adding new abstractions.
- Keep screen work focused: update only the target module, shared component, or
  route surface needed for the task.
- Keep BE contracts as repository/interface behavior in Flutter until a backend
  endpoint is confirmed.
- Use Flutter-native design rules for runtime UI; deleted web screenshots are no
  longer an acceptance gate.

## Required Workflow

1. Read the active docs listed in `docs/00_START_HERE.md`.
2. Locate the relevant Flutter route in
   `flutter_app/lib/app/router/app_router.dart`.
3. Inspect the existing feature implementation under `flutter_app/lib/features/`.
4. Reuse shared layout/widgets from `flutter_app/lib/shared/` and theme tokens
   from `flutter_app/lib/app/theme/`.
5. Add or update focused tests under `flutter_app/test/`.
6. Run `flutter analyze` and the relevant `flutter test` suite.

## Domain Boundary Rules

- Prediction Markets are wallet/value-based.
- Open Arena is Arena Points only.
- Do not merge Prediction wallet/PnL/history with Arena points/pool/ledger.
- Safe bridge surfaces are discovery, topic/category, event context, creator
  discovery, and profile sections, but the BE domains remain separate.

## Completion Rule

A task is not complete until the Flutter code, route behavior, repository/mock
state, and relevant tests match the requested behavior.
