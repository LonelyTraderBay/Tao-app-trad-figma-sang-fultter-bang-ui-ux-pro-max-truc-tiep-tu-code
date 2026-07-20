---
paths:
  - "flutter_app/lib/app/router/**"
  - "flutter_app/lib/core/navigation/**"
---
# Router & Navigation

Public router import: `flutter_app/lib/app/router/app_router.dart`.

- Every route change must keep both audits green (run from `flutter_app/`):
  `dart run tool/route_coverage_audit.dart --check` and
  `dart run tool/navigation_edge_audit.dart --check`. Truth table:
  `docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md`.
- Back navigation: `goBackOrFallback` in `core/navigation/back_navigation.dart`
  — the ONE sanctioned UI-adjacent file in `core/` (needs `BuildContext`).
  Do not use it as precedent for importing Flutter/UI elsewhere in `core/`.
  Contract: `docs/02_FLUTTER_MIGRATION/standards/Back-Navigation-Standard.md`
  + `Top-Header-Standard.md`; guardrails
  `back_navigation_behavior_guardrail_test.dart`,
  `home_entry_back_navigation_guardrail_test.dart`,
  `navigation_route_guardrails_test.dart`.
- After renaming any router symbol: grep `flutter_app/tool/` for the old name —
  audit tools match on literal strings (see `.claude/rules/audit-tools.md`).
- Router changes = full test suite, not focused tests.
