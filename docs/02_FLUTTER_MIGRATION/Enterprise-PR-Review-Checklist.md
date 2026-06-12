# Enterprise PR Review Checklist

Use this checklist for every VitTrade Flutter pull request. It converts the
enterprise architecture rules into review gates that can be verified from the
diff, tests, and CI output.

## Required PR Evidence

- [ ] Scope summary explains the user-facing or engineering outcome.
- [ ] Changed files are grouped by feature, router, shared UI, test, or docs.
- [ ] Verification commands and results are listed in the PR description.
- [ ] Screenshots or emulator evidence are attached for visible UI changes.
- [ ] Any exception to line-count or layer rules is documented with a reason.

## Architecture Review

- [ ] Feature code stays inside `flutter_app/lib/features/<feature>/`.
- [ ] New feature modules include `domain`, `data`, and `presentation`.
- [ ] Domain contracts are introduced before presentation code depends on data.
- [ ] `presentation/pages` and `presentation/widgets` avoid direct
      `features/*/data` imports.
- [ ] Controllers own flow state, validation, submit intent, and high-risk
      orchestration.
- [ ] Pages focus on provider reads, route arguments, shell layout, navigation,
      and top-level composition.
- [ ] Shared layout and design-system primitives are reused before local
      variants are created.
- [ ] No new direct runtime `Colors.*` usage is introduced outside established
      theme or token boundaries.
- [ ] No new hardcoded numeric typography/spacing/radius/container patterns are
      added in feature or shared code without documented exception.
- [ ] Changed files do not increase design-token debt; `dart run
      tool/design_token_consistency_audit.dart --check` passes.
- [ ] P0 financial modules stay at or below the current design-token baseline
      enforced by `tool/design_token_consistency_audit.dart --check`.
- [ ] The CI design-token report artifact is reviewed when UI, theme, shared
      layout, or feature presentation files change.

## Router Review

- [ ] Public router facade remains `flutter_app/lib/app/router/app_router.dart`.
- [ ] New paths and names are covered by route contract tests.
- [ ] New pages are reachable through the correct route group.
- [ ] Back behavior is covered for high-risk or nested routes.
- [ ] `dart run tool/route_coverage_audit.dart --check` passes.
- [ ] `dart run tool/navigation_edge_audit.dart --check` passes when
      navigation calls, route builders, or screen links change.
- [ ] UI navigation uses `AppRoutePaths`, `AppRouteNames`, or
      `NavigationIntent`; new direct raw route strings are not introduced.
- [ ] Route-bearing mock/domain data resolves to declared router paths.

## Product Safety Review

- [ ] Withdraw, escrow, security, address, and P2P payment-method flows preview
      risk and require confirmation.
- [ ] Fees, limits, risk, and next steps are visible before confirmation.
- [ ] Sensitive data is masked in UI and tests.
- [ ] Arena remains points-only.
- [ ] Prediction Markets remains separate from Arena.
- [ ] Trade, margin, futures, and copy-trading copy avoids hype, casino, FOMO,
      and hidden-risk language.

## Test Review

- [ ] Focused tests cover the changed feature or controller behavior.
- [ ] Router tests run when routes change.
- [ ] Product copy guardrails run when Trade, Wallet, P2P, Prediction, Arena,
      or rewards copy changes.
- [ ] Accessibility or semantics tests run for high-risk controls.
- [ ] Full `flutter test --reporter=compact` passes before merge.
- [ ] Test files remain below `400` lines or are split by behavior group.

## Required Commands

Run from `flutter_app/` before merge:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test test/app/router --reporter=compact
flutter test test/quality/navigation_route_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test --reporter=compact
``` 

Design-token checks (required for every PR with UI changes):

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
```

CI uploads `VitTrade-Design-Token-Consistency-Audit.md` and `.csv` as the
`design-token-consistency-audit` artifact so reviewers can compare debt trends.

## Merge Criteria

- [ ] CI is green.
- [ ] No unresolved blocker comments remain.
- [ ] All required docs, manifest rows, route contracts, and tests are updated.
- [ ] Worktree output artifacts are not committed.
- [ ] The PR leaves the codebase at least as clean as it found it.
