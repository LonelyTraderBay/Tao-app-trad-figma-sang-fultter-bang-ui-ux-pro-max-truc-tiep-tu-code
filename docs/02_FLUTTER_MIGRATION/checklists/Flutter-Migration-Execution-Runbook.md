# Flutter Execution Runbook

This runbook replaces the old screen-by-screen web migration process. Use it for
new Flutter work, bug fixes, and QA cleanup.

## Standard Workflow

1. Read `AGENTS.md` and `docs/00_START_HERE.md`.
2. Identify the feature route in `flutter_app/lib/app/router/app_router.dart`.
3. Inspect the existing screen, repository/mock data, and tests for that module.
4. Implement the smallest coherent Flutter change.
5. Add or update focused widget/repository/router tests.
6. Run `flutter analyze`.
7. Run focused `flutter test` commands; run full `flutter test` for broad shared
   or routing changes.
8. Update docs only when behavior, routes, coverage status, or design rules
   changed.

## Screen Work Checklist

- Route is registered or intentionally redirected.
- Screen uses shared layout and widgets unless a local component is justified.
- Repository/mock state covers loading, empty, error, and primary data states
  when applicable.
- High-risk financial actions include preview/confirm states.
- Prediction and Arena domain boundaries remain separate.
- Tests cover visible state, key interactions, navigation/back behavior, and
  repository contract data touched by the change.

## When To Stop And Ask

Ask only when product intent cannot be inferred from active Flutter code, tests,
or current docs. Examples:

- A flow requires real backend semantics that are absent from repositories.
- Product copy changes risk merging Arena points-only behavior with wallet/value
  behavior.
- A requested design change contradicts global trust/safety rules.

## Retired Workflow

The previous workflow that required web source files, web screenshots, and
`output/flutter-ui-reference` is obsolete after the Flutter-only cleanup.
