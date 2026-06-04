# VitTrade Home Entry Back Navigation Tracking Plan

Created: 2026-06-04

Status: Complete - implemented and verified on 2026-06-04.

Scope: standardize every navigation entry that starts from `HomePage` so the
visible header back button returns to Home when the user entered from Home, and
returns to the correct parent module when the user is deeper inside a feature.

Note: Vietnamese UI labels are written without diacritics in this tracking file
to keep the file ASCII-safe.

## 1. Objective

Make Home-origin navigation predictable:

- If the user taps a Home product/function card, the first destination screen
  should return to Home when the header back button is pressed.
- If the user then drills deeper inside the destination feature, the next back
  action should return to that feature parent, not directly to Home.
- If the same destination is opened by deep link, bottom nav, notification, or
  another module, it must still have a safe fallback parent.
- High-risk financial flows must keep preview, confirmation, dirty-form, and
  submitting safety intact.

## 2. Source Of Truth

Read these before implementation:

| File | Purpose |
| --- | --- |
| `AGENTS.md` | Repo rules and Flutter architecture. |
| `docs/00_START_HERE.md` | Required reading order and verification commands. |
| `flutter_app/lib/features/home/data/home_mock_data.dart` | Home product grid and Home route targets. |
| `flutter_app/lib/features/home/presentation/pages/home_page.dart` | Home page shell. |
| `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` | Home navigation helper. |
| `flutter_app/lib/core/navigation/back_navigation.dart` | Shared back helper contract. |
| `flutter_app/lib/app/router/app_route_paths.dart` | Canonical route paths. |
| `flutter_app/lib/app/router/route_groups/` | Route ownership by module. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Header-Back-Navigation-Behavior-Audit.csv` | Current header back inventory. |

## 3. Current Findings

These are the findings from the manual Home-entry audit on 2026-06-04:

| Finding | Evidence | Impact |
| --- | --- | --- |
| Home uses `context.go(path)` | `home_page_part_01.dart` `_go` | Destination replaces Home, so history cannot return to Home. |
| Convert back goes to Trade | `convert_page.dart` | Home -> Convert -> Back goes to Trade, not Home. |
| Margin back goes to Trade | `margin_trading_page.dart` | Home -> Margin -> Back goes to Trade, not Home. |
| Bot back goes to Trade | `trading_bots_page.dart` | Home -> Bot -> Back goes to Trade, not Home. |
| Copy Trade back goes to Trade | `copy_trading_page.dart` | Home -> Copy Trade -> Back goes to Trade, not Home. |
| DCA fallback goes to Trade | `dca_page_part_01.dart` | Home -> DCA -> Back falls to Trade when no stack exists. |
| Wallet entry has no Home back | `wallet_page.dart` | Home -> Nap/Rut opens Wallet without a visible Home-return back. |
| Savings back goes to Earn | `savings_page.dart` via `snapshot.backRoute` | Home -> Tiet kiem -> Back goes to Earn, not Home. |
| Predictions back goes to Markets | `predictions_home_page.dart` | Home -> Du doan -> Back goes to Markets, not Home. |

Current guardrail result:

```bash
cd flutter_app
dart run tool/back_navigation_behavior_audit.dart
```

Observed output:

```text
visible_header_back_entries=380
strict_back_issues=0
high_risk_entries=43
parent_route_only=323
history_then_fallback=57
```

Important: this audit proves routes have safe back handlers; it does not yet
prove Home-origin back behavior is correct.

Home-entry guardrail result after implementation:

```bash
cd flutter_app
dart run tool/home_entry_back_navigation_audit.dart --check
```

Observed output:

```text
home_entry_back_rules=44
passed=44
failed=0
Home entry back navigation artifacts are current.
```

## 4. Desired Contract

Use this contract for implementation:

| User path | Header back should do |
| --- | --- |
| `Home -> Entry screen` | Return to `Home`. |
| `Home -> Entry screen -> Child screen` | Return to `Entry screen` or the child parent. |
| `Direct/deep link -> Entry screen` | Use safe fallback parent. |
| `Bottom nav -> Root module` | No header back unless the route was pushed from Home. |
| `High-risk form/confirm screen` | Confirm discard or use safe parent fallback where needed. |

Preferred implementation pattern:

```dart
goBackOrFallback(
  context,
  fallbackPath: AppRoutePaths.<safeParent>,
  mode: BackNavigationMode.historyThenFallback,
)
```

Home should push entry routes when the user is entering a feature from Home:

```dart
context.push(path);
```

This preserves the real Home history. Entry screens that use
`historyThenFallback` will pop to Home when they were opened from Home, and will
fall back to the safe parent when opened directly.

## 5. Home Entry Matrix

Every Home outgoing entry must have one row here. Do not remove a row without
also removing or replacing the corresponding Home navigation source.

| ID | Home label/source | Route | Current behavior | Target behavior | Status |
| --- | --- | --- | --- | --- | --- |
| HEB-001 | Header Search | `/search` | Back to Home | Back to Home | Done - regression covered |
| HEB-002 | Header Notifications | `/notifications` | Back to Home | Back to Home | Done - regression covered |
| HEB-003 | Next action: withdraw USDT | `/wallet/withdraw/USDT` | Fallback Wallet | Pop Home if from Home, fallback Wallet if direct | Done |
| HEB-004 | Recent product: BTC/USDT | `/trade/btcusdt` | No clear header back | Pop Home if from Home, safe Trade fallback if direct | Done |
| HEB-005 | Recent product: P2P USDT/VND | `/p2p` | Back to Home | Back to Home | Done |
| HEB-006 | Recent product: Copy Trade | `/trade/copy-trading` | Back to Trade | Pop Home if from Home, fallback Trade if direct | Done |
| HEB-030 | Recent product: ETH staking | `/earn/staking` | Back to Home | Back to Home | Done - added missing row |
| HEB-007 | Product: Mua nhanh | `/trade/btcusdt` | No clear header back | Pop Home if from Home, safe Trade fallback if direct | Done |
| HEB-008 | Product: Convert | `/trade/convert` | Back to Trade | Pop Home if from Home, fallback Trade if direct | Done |
| HEB-009 | Product: Margin | `/trade/margin` | Back to Trade | Pop Home if from Home, fallback Trade if direct | Done |
| HEB-010 | Product: Bot | `/trade/bots` | Back to Trade | Pop Home if from Home, fallback Trade if direct | Done |
| HEB-011 | Product: Copy Trade | `/trade/copy-trading` | Back to Trade | Pop Home if from Home, fallback Trade if direct | Done |
| HEB-012 | Product: Mua dinh ky | `/dca` | Pop if stack, fallback Trade | Pop Home if from Home, fallback Trade if direct | Done - direct fallback kept Trade |
| HEB-013 | Product: Nap/Rut | `/wallet` | No visible Home back | Pop Home if from Home, no back from bottom nav/direct root | Done |
| HEB-014 | Product: P2P | `/p2p` | Back to Home | Back to Home | Done |
| HEB-015 | Product: Staking | `/earn/staking` | Back to Home | Back to Home | Done |
| HEB-016 | Product: Tiet kiem | `/earn/savings` | Back to Earn | Pop Home if from Home, fallback Earn if direct | Done |
| HEB-017 | Product: Launchpad | `/launchpad` | Back to Home | Back to Home | Done |
| HEB-018 | Product: Du doan | `/markets/predictions` | Back to Markets | Pop Home if from Home, fallback Markets if direct | Done |
| HEB-019 | Product: Arena | `/arena` | Pop if stack, fallback Home | Back to Home | Done |
| HEB-020 | Product: Phan thuong | `/rewards` | Pop if stack, fallback Home | Back to Home | Done |
| HEB-021 | Product: Ho tro | `/support` | Back to Home | Back to Home | Done |
| HEB-022 | Product: Kham pha | `/topics` | Back to Home | Back to Home | Done |
| HEB-023 | Product: Gioi thieu | `/referral` | Back to Home | Back to Home | Done |
| HEB-024 | Discovery card: Prediction Markets | `/markets/predictions` | Back to Markets | Pop Home if from Home, fallback Markets if direct | Done |
| HEB-025 | Discovery card: Open Arena | `/arena` | Pop if stack, fallback Home | Back to Home | Done |
| HEB-026 | Market section: all markets | `/markets` | Root tab behavior | Push Home history; system back returns Home; no artificial root header back | Done - decision recorded |
| HEB-027 | Market section: pair row | `/pair/:pairId` | Market detail parent behavior | Pop Home if from Home, fallback Markets if direct | Done |
| HEB-028 | Trending pair card | `/pair/:pairId` | Market detail parent behavior | Pop Home if from Home, fallback Markets if direct | Done |
| HEB-029 | Ranked list pair row | `/pair/:pairId` | Market detail parent behavior | Pop Home if from Home, fallback Markets if direct | Done |

## 6. Implementation Phases

### Phase 0 - Baseline Freeze

Goal: prevent silent regressions before editing.

Checklist:

- [x] Re-read source docs listed in section 2.
- [x] Run `git status --short` and identify unrelated user changes.
- [x] Run current back navigation behavior audit.
- [x] Run Home tests to capture current behavior.
- [x] Record current failing/mismatched Home-entry rows in section 5.
- [x] Do not modify unrelated top-header visual polish files.

Commands:

```bash
cd flutter_app
dart run tool/back_navigation_behavior_audit.dart --check
flutter test test/features/home/home_page_test.dart --reporter=compact
flutter test test/core/navigation/back_navigation_test.dart --reporter=compact
```

### Phase 1 - Home Navigation Intent Cleanup

Goal: preserve Home history for Home-origin feature entry.

Checklist:

- [x] Replace or split `_go(String path)` in `home_page_part_01.dart`.
- [x] Add a clearly named Home entry helper, for example `_openHomeEntry`.
- [x] Use `context.push(path)` for feature/product entries that should return
  to Home.
- [x] Keep route changes scoped to Home; do not change bottom nav behavior.
- [x] Confirm search and notifications still return to Home.
- [x] Confirm no Home tap uses a raw unsupported route.

Decision log:

| Decision | Selected | Notes |
| --- | --- | --- |
| Home feature entry navigation | `context.push(path)` | Preserves true Home history. |
| Direct/deep-link fallback | Existing module parent | Avoids sending deep-link users to Home unexpectedly. |
| Bottom nav root navigation | Keep existing behavior | Root tabs should not show artificial back. |
| Markets root from Home | `push` plus system/router back | `/markets` is a root tab surface with no artificial header back. |

### Phase 2 - Entry Screen Back Handlers

Goal: make entry screens source-aware through history plus fallback.

Checklist:

- [x] Convert `ConvertPage` back to `goBackOrFallback(... AppRoutePaths.trade, historyThenFallback)`.
- [x] Convert `MarginTradingPage` back to `goBackOrFallback(... AppRoutePaths.trade, historyThenFallback)`.
- [x] Convert `TradingBotsPage` back to `goBackOrFallback(... AppRoutePaths.trade, historyThenFallback)`.
- [x] Convert `CopyTradingPage` back to `goBackOrFallback(... AppRoutePaths.trade, historyThenFallback)`.
- [x] Convert `DCAPage` `_close` fallback behavior after deciding whether direct fallback is `AppRoutePaths.trade` or `AppRoutePaths.dca`.
- [x] Convert `SavingsPage` back to history plus `snapshot.backRoute`.
- [x] Convert `PredictionsHomePage` back to history plus `AppRoutePaths.markets`.
- [x] Review `WithdrawPage` for Home next-action behavior without weakening form/confirmation safety.
- [x] Add conditional Home-return back affordance for `TradePage` when opened by push from Home.
- [x] Add conditional Home-return back affordance for `WalletPage` when opened by push from Home.

Do not change:

- Child pages that already correctly return to their feature parent.
- Modal/sheet close handlers using `Navigator.pop`.
- High-risk submit, preview, confirmation, or receipt logic.

### Phase 3 - Home Entry Route Matrix Tests

Goal: every row in section 5 gets coverage.

Checklist:

- [x] Add a focused Home-entry back test file if `home_page_test.dart` becomes too large.
- [x] Test Home -> P2P -> Back returns Home.
- [x] Test Home -> Convert -> Back returns Home.
- [x] Test Home -> Margin -> Back returns Home.
- [x] Test Home -> Bot -> Back returns Home.
- [x] Test Home -> Copy Trade -> Back returns Home.
- [x] Test Home -> DCA -> Back returns Home.
- [x] Test Home -> Wallet -> Back returns Home if the route displays source-aware back.
- [x] Test Home -> Savings -> Back returns Home.
- [x] Test Home -> Predictions -> Back returns Home.
- [x] Test Home -> Launchpad -> Back returns Home.
- [x] Test Home -> Arena -> Back returns Home.
- [x] Test Home -> Rewards -> Back returns Home.
- [x] Test Home -> Support -> Back returns Home.
- [x] Test Home -> Topics -> Back returns Home.
- [x] Test Home -> Referral -> Back returns Home.
- [x] Test direct route -> Back still falls back to module parent for Convert, Margin, Bot, Copy, Savings, Predictions.
- [x] Test child drilldown remains parent-first: `Home -> P2P -> P2P child -> Back` returns to P2P child parent, not Home.

Minimum test assertion:

```dart
expect(find.byType(HomePage), findsOneWidget);
```

For direct-entry fallback tests, assert the module parent page type or stable
module title instead of Home.

### Phase 4 - Audit Guardrail Extension

Goal: make the rule machine-checkable.

Checklist:

- [x] Extend `back_navigation_behavior_audit.dart` or add a new Home-entry audit tool.
- [x] Parse Home outgoing routes from:
  - `home_mock_data.dart`
  - `home_page_part_01.dart`
  - `home_page_part_02.dart`
  - `home_page_part_03.dart`
- [x] Emit a CSV row for every Home outgoing route.
- [x] Classify each row as:
  - `home_entry_history_ok`
  - `home_entry_parent_only`
  - `home_entry_missing_back`
  - `home_entry_high_risk_needs_review`
  - `home_entry_decision_required`
- [x] Fail strict mode if a section 5 row is missing.
- [x] Add a quality guardrail test for the new audit artifact.

Suggested output:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Home-Entry-Back-Navigation-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Home-Entry-Back-Navigation-Audit.csv
```

### Phase 5 - Verification

Run from `flutter_app/`:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/back_navigation_behavior_audit.dart --check --strict
dart run tool/navigation_edge_audit.dart --check
dart run tool/route_coverage_audit.dart --check
flutter analyze
flutter test test/core/navigation/back_navigation_test.dart --reporter=compact
flutter test test/features/home/home_page_test.dart --reporter=compact
flutter test test/app/router/critical_navigation_back_behavior_test.dart --reporter=compact
flutter test test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact
flutter test --reporter=compact
```

If the Home-entry audit is added, also run:

```bash
dart run tool/home_entry_back_navigation_audit.dart --check --strict
flutter test test/quality/home_entry_back_navigation_guardrail_test.dart --reporter=compact
```

Verification result on 2026-06-04:

| Command | Result | Notes |
| --- | --- | --- |
| `flutter pub get` | Passed | Dependency resolution succeeded. |
| `dart format --output=none --set-exit-if-changed .` | Blocked by generated `build/` path | `PathNotFoundException` under `build/app/intermediates/...`; source format was checked with generated folders excluded. |
| `rg --files -g '*.dart' -g '!build/**' -g '!.dart_tool/**' -g '!run-artifacts/**' -g '!tmp/**'` batched into `dart format --output=none --set-exit-if-changed` | Passed | 0 source files changed. |
| `dart run tool/back_navigation_behavior_audit.dart --check --strict` | Passed | `strict_back_issues=0`. |
| `dart run tool/navigation_edge_audit.dart --check` | Passed | Artifact current after update. |
| `dart run tool/route_coverage_audit.dart --check` | Passed | Artifact current. |
| `dart run tool/home_entry_back_navigation_audit.dart --check` | Passed | 44/44 rules pass. |
| `dart run tool/top_header_action_audit.dart --check --strict` | Passed | Artifact current after update. |
| `dart run tool/top_header_global_access_policy_audit.dart --check` | Passed | Artifact current after update; `policy_violations=0`. |
| `flutter analyze` | Passed | No issues found. |
| `flutter test test/core/navigation/back_navigation_test.dart --reporter=compact` | Passed | 7 tests. |
| `flutter test test/features/home/home_page_test.dart --reporter=compact` | Passed | 8 tests. |
| `flutter test test/features/home/home_entry_back_navigation_test.dart --reporter=compact` | Passed | 33 tests. |
| `flutter test test/features/markets/pair_detail_page_test.dart --reporter=compact` | Passed | 6 tests. |
| `flutter test test/app/router/critical_navigation_back_behavior_test.dart --reporter=compact` | Passed | 9 tests. |
| `flutter test test/quality/home_entry_back_navigation_guardrail_test.dart --reporter=compact` | Passed | 1 test. |
| `flutter test test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact` | Passed | 1 test. |
| `flutter test test/quality/top_header_action_guardrail_test.dart --reporter=compact` | Passed | 1 test. |
| `flutter test test/quality/top_header_global_access_policy_guardrail_test.dart --reporter=compact` | Passed | 1 test. |
| `flutter test --reporter=compact` | Passed | Full suite: 2019 tests. |

## 7. No-Omission Protocol

Before marking this plan complete:

- [x] Every `HomeQuickAction` in `home_mock_data.dart` has a row in section 5.
- [x] Every `HomeRecentProduct` in `home_mock_data.dart` has a row in section 5.
- [x] Every Home header action has a row in section 5.
- [x] Every Home discovery card has a row in section 5.
- [x] Every Home market/pair navigation surface has a row in section 5.
- [x] Every row in section 5 is marked `Done`, `Deferred with reason`, or `Out of scope with reason`.
- [x] Every `Needs decision` row has a written decision in section 8.
- [x] Every changed route has a test for Home-origin behavior.
- [x] Every changed route that can be deep-linked has a direct-entry fallback test.
- [x] High-risk routes were reviewed for dirty form, preview, confirm, submitting, success, and receipt states.
- [x] Full verification commands in section 6 passed or failures are documented.

## 8. Decision Log

| Date | Decision | Reason | Owner |
| --- | --- | --- | --- |
| 2026-06-04 | Home feature entries should preserve Home history | User expects back to return to Home after tapping a Home function card. | Codex/User |
| 2026-06-04 | Deeper feature screens should return to feature parent | Prevents losing feature context after the first drilldown. | Codex/User |
| 2026-06-04 | Use `historyThenFallback` for Home-entry compatible screens | Supports both Home-origin navigation and direct/deep-link fallback. | Codex/User |
| 2026-06-04 | Keep DCA direct fallback as Trade | DCA is reached from Home but remains owned by the Trade module in current routing. | Codex |
| 2026-06-04 | Wallet root back is conditional on route history | Bottom nav/direct Wallet should not show artificial back; Home-pushed Wallet should return Home. | Codex |
| 2026-06-04 | Home `/markets` uses push but no artificial root header back | Markets is a root tab surface; system/router back returns Home from Home-origin history. | Codex |
| 2026-06-04 | Pair detail pops Home only when Home-pushed and falls back to Markets directly | Pair detail is owned by Markets for direct/deep-link entry. | Codex |

Open decisions: none.

## 9. Work Log

| Date | Phase | Change | Verification | Status |
| --- | --- | --- | --- | --- |
| 2026-06-04 | Baseline | Created Home-entry tracking plan | Manual audit plus `back_navigation_behavior_audit.dart` output | Done |
| 2026-06-04 | Implementation | Changed Home outbound navigation to `context.push(path)` and converted Home-entry screens to history-plus-fallback where needed | `flutter test test/features/home/home_entry_back_navigation_test.dart --reporter=compact` | Done |
| 2026-06-04 | Guardrail | Added `tool/home_entry_back_navigation_audit.dart`, CSV/Markdown artifacts, and quality test | `dart run tool/home_entry_back_navigation_audit.dart --check`; `flutter test test/quality/home_entry_back_navigation_guardrail_test.dart --reporter=compact` | Done |
| 2026-06-04 | Existing audits | Updated global back-navigation and navigation-edge artifacts | `dart run tool/back_navigation_behavior_audit.dart --check --strict`; `dart run tool/navigation_edge_audit.dart --check` | Done |

## 10. Completion Criteria

This work is complete only when:

- Home product/function entries return to Home on visible header back.
- Direct/deep-link entry routes still fall back to safe module parents.
- Child routes preserve feature parent navigation.
- High-risk flow safety is unchanged.
- The Home entry matrix has no unreviewed rows.
- Focused tests and full verification pass.
- Audit artifacts are updated and strict guardrails pass.
