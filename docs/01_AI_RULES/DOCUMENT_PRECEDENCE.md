# Document Precedence

Use this order when documents disagree.

## Precedence Order

1. User instruction in the current conversation.
2. Root `AGENTS.md` for coding and repository constraints.
3. `docs/00_START_HERE.md` for the docs reading order.
4. Flutter source under `flutter_app/lib/`.
5. Flutter tests under `flutter_app/test/`.
6. `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` for screen coverage
   tracking.
7. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md` and
   `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md` for UI rules.
8. `docs/03_DESIGN_SYSTEM/Guidelines.md` for product and design rules.
9. Screen-specific references under `docs/04_SCREEN_REFERENCES/`.
10. Architecture reports under `docs/05_ARCHITECTURE/`.

## Conflict Rules

- If docs conflict with current Flutter code and tests, inspect the code/tests
  first and update stale docs as part of the change when in scope.
- If a historical web-baseline note conflicts with Flutter-native design rules,
  Flutter-native design rules win.
- If a screen-specific reference conflicts with global product rules, follow the
  global rule unless the reference documents a deliberate exception.
- If an architecture report conflicts with current Flutter routing or
  repositories, current Flutter source wins.

## Artifact Rule

Generated outputs belong under `flutter_app/run-artifacts/` unless a tool has a
more specific Flutter-standard location. Do not recreate `output/flutter-ui-reference`.
