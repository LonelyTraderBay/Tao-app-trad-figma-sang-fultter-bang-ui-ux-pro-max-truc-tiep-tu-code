---
paths:
  - "flutter_app/test/**"
---
# Testing Conventions

Repo idiom (see `.claude/agents/flutter-test-writer.md` for the full runbook):

- Flat `test()` / `testWidgets()` files — no nested `group()` towers.
- Riverpod controllers: `ProviderContainer` unit tests.
- Page tests: pump the real app + router, not isolated widget shells.
- Use the production mock repositories, not ad-hoc fakes.
- SC-NNN traceability naming for scenario tests.
- Test files stay under the 400-line limit
  (`flutter-test-coverage-auditor` flags violations).

## Blast-radius lessons (learned the hard way)

- Growing a shared primitive's footprint (size, padding) breaks goldens and
  offset-based taps app-wide — run the FULL suite after touching
  `shared/widgets`, not just the widget's own test. `FittedBox` defeats
  `tester.getSize(find.text(...))`.
- Async tests: zero-timer `FakeAsync` traps, shell-watch `Duration.zero`,
  unawaited haptics, `async*` cancellation — see memory
  `feedback_async_migration_traps` before writing stream/async tests.

## Commands

Focused tests for touched modules; FULL suite for router, shared layout,
repository, or broad structural changes. Canonical verification block:
`/vt-verify` (pub get → format → route/nav audits → analyze → tests).
