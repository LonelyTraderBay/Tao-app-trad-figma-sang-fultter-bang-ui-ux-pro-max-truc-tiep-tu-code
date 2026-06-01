# Flutter Enterprise Clean Codebase Master Plan

Date: 2026-06-01
Scope: `flutter_app/lib` and `flutter_app/test`
Purpose: keep VitTrade clean enough for long-term enterprise Flutter growth
without losing track of any file.

This file is the long-running execution plan. The full file-level ledger remains:

- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-100-Percent-File-Action-Manifest.csv`
- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-900-Line-Refactor-Tracking.md`

Use this plan to decide order, standards, verification, and tracking discipline.
Use the CSV manifest as the complete file register.

## 1. Current Baseline

Latest scan from repo root on 2026-06-01:

```text
flutter_app/lib dart files: 1945
flutter_app/test dart files: 443
manifest rows: 2388

production files over 1000 lines: 0
production files over 900 lines: 0
production files over 800 lines: 0
production files over 700 lines: 0
production files over 600 lines: 0
production files over 500 lines: 61

test files over 900 lines: 0
test files over 600 lines: 0
test files over 500 lines: 0
test files over 400 lines: 0
```

Verification already passed for this baseline:

```bash
cd flutter_app
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --reporter=compact
```

Result:

```text
flutter pub get: dependencies resolved
dart format --output=none --set-exit-if-changed .: 2390 files checked, 0 changed
flutter analyze: No issues found
flutter test --reporter=compact: full suite passed, 1872 tests passed
```

Conclusion: no production file currently requires an emergency split by hard
line-count limits, no test file remains over `400` lines, and all planned
clean-codebase batches are complete through `EClean-24`.

## 2. Enterprise Targets

Use these thresholds for new work and cleanup.

| File type | Preferred range | Soft review | Hard limit | Rule |
| --- | ---: | ---: | ---: | --- |
| `presentation/pages/*.dart` | 200-500 | >500 | >900 | Page owns route, provider reads, state wiring, navigation, and top-level composition only. |
| `presentation/widgets/*.dart` | 80-350 | >400 | >600 | Widget file maps to one visual section, card group, list, sheet, or painter family. |
| `presentation/controllers/*.dart` | 80-300 | >350 | >500 | Controller owns view state and orchestration, not fixtures or rendering. |
| `domain/entities/*.dart` | cohesive bounded context | >500 | >800 | Split by domain concept, not by arbitrary line count. |
| `data/repositories/mock_*.dart` | 200-500 | >500 | >900 | Move static fixtures before splitting repository behavior. |
| `app/router/*.dart` | 100-500 | >500 | >700 | Split by cohesive route group while preserving public router facade. |
| `test/**/*.dart` | 80-350 | >400 | >600 | Split by behavior group, route surface, or guardrail concern. |

Hard limits stop new feature work until the file is split or an exception is
documented. Soft review files can remain, but every touched soft-review file
must either be cleaned up or logged as intentionally deferred.

## 3. No-Miss Tracking System

Every Dart file must always be in one of these states:

| State | Meaning |
| --- | --- |
| `AUDIT_ONLY` | File is below thresholds and cohesive. No split expected. |
| `SOFT_REVIEW` | File is valid but should be reduced when touched. |
| `REFACTOR_NOW` | File breaks hard limits or mixes responsibilities. |
| `EXCEPTION` | File intentionally exceeds a target with a written reason and verification. |
| `DONE` | File was reviewed, cleaned if needed, tested, and logged. |

Required tracking rule:

1. Every production or test Dart file must exist in the CSV manifest.
2. Every cleanup batch must list its target files in this plan before edits.
3. Every touched file must have before/after line counts.
4. Every new file must be covered by package imports, tests, and guardrails.
5. No batch is complete until verification commands are recorded in this plan
   or in the linked tracker.

## 4. Audit Commands

Run from repo root unless noted.

### 4.1 Full File Count

```powershell
$root=(Resolve-Path flutter_app).Path
$files=Get-ChildItem flutter_app/lib,flutter_app/test -Recurse -Filter *.dart |
  ForEach-Object {
    [pscustomobject]@{
      Rel=$_.FullName.Substring($root.Length+1)
      Lines=(Get-Content $_.FullName).Count
    }
  }
$files | Sort-Object Lines -Descending | Select-Object -First 100
```

### 4.2 Production Threshold Scan

```powershell
$root=(Resolve-Path flutter_app).Path
Get-ChildItem flutter_app/lib -Recurse -Filter *.dart |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -gt 500) {
      [pscustomobject]@{Lines=$lines; Rel=$rel}
    }
  } |
  Sort-Object Lines -Descending
```

### 4.3 Test Threshold Scan

```powershell
$root=(Resolve-Path flutter_app).Path
Get-ChildItem flutter_app/test -Recurse -Filter *.dart |
  ForEach-Object {
    $rel=$_.FullName.Substring($root.Length+1)
    $lines=(Get-Content $_.FullName).Count
    if ($lines -gt 400) {
      [pscustomobject]@{Lines=$lines; Rel=$rel}
    }
  } |
  Sort-Object Lines -Descending
```

### 4.4 Class Boundary Scan

```powershell
rg -n "^class |^enum |^extension |^mixin |^typedef |^final class " <target-files>
```

### 4.5 Architecture Smell Scan

```powershell
rg -n "features/.*/data" flutter_app/lib/features | Select-String "presentation"
rg -n "\bColors\." flutter_app/lib/app flutter_app/lib/core flutter_app/lib/features flutter_app/lib/shared
rg -n "^import '(\.\./|features/|app/|core/|shared/)" flutter_app/lib
```

Expected direction:

- Presentation pages/widgets do not import feature `data`.
- New runtime UI does not add direct `Colors.*` usage.
- Cross-module imports use `package:vit_trade_flutter/...`.

## 5. Split Rules

### 5.1 Pages

Keep in the page:

- `Page` widget and route-level state.
- Riverpod reads and controller calls.
- Text controllers, form keys, focus nodes, selected tab index.
- Navigation and high-risk confirmation entry points.
- Page-level loading, empty, error, offline, submitting, and success branches.

Move out of the page:

- Repeated visual sections.
- Cards, rows, list items, timeline steps, tabs, sheets, and painters.
- Static demo panels and explanatory content blocks.

Target location:

```text
flutter_app/lib/features/<feature>/presentation/widgets/
```

### 5.2 Widgets

Split a widget file when it contains multiple visible product sections.

Good split units:

- `<screen>_hero.dart`
- `<screen>_filters.dart`
- `<screen>_list.dart`
- `<screen>_cards.dart`
- `<screen>_details.dart`
- `<screen>_confirm_sheet.dart`
- `<screen>_chart_painter.dart`

Avoid generic dumping grounds such as `common_widgets.dart` unless the file
contains only tiny primitives used by several sibling widgets.

### 5.3 Controllers

Controllers should not become mini repositories. If a controller grows:

- Move pure calculation into a domain service or value object.
- Move mock data into `data/fixtures`.
- Keep UI state transitions in the controller.
- Keep repository contracts under `domain`.

### 5.4 Domain Entities

Entity files can be longer than widgets when they are cohesive. Split only when
a clear domain boundary exists.

Preferred split directions:

- `trade_entities_orders.dart`
- `trade_entities_positions.dart`
- `trade_entities_risk.dart`
- `earn_entities_savings.dart`
- `earn_entities_staking.dart`
- `p2p_entities_orders.dart`
- `p2p_entities_disputes.dart`
- `p2p_entities_security.dart`

Maintain public imports and avoid churn if the only problem is line count.

### 5.5 Mock Repositories

Split fixtures before behavior:

```text
data/fixtures/<feature>_<area>_fixtures.dart
data/repositories/mock_<feature>_repository.dart
```

The repository API should remain stable.

### 5.6 Router

Preserve public router API:

- `createAppRouter`
- `appRouter`
- `AppRoutePaths`
- `AppRouteNames`

Route splits must stay under `flutter_app/lib/app/router/route_groups/`.

## 6. Priority Roadmap

### Phase 0 - Baseline Lock

Status: `[x]`

Goal: keep the clean baseline from regressing.

Tasks:

- [x] Refresh CSV manifest after any large refactor wave.
- [x] Keep `0` production files over `600` lines unless an exception exists.
- [x] Keep `0` production files over hard limits.
- [x] Keep architecture guardrails passing.
- [x] Record every exception in this plan.

Required verification:

```bash
cd flutter_app
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

### Phase 1 - Highest-Value Widget Cleanup

Status: `[x]`

Goal: reduce widget files over `480` lines toward `250-350` lines.

| Priority | File | Current lines | Split direction | Status |
| --- | --- | ---: | --- | --- |
| P1 | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_cards.dart` | 560 | Split section header, account card, details, action chips, info note. | `[x]` |
| P1 | `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_home_tool_widgets.dart` | 538 | Split staking entry, tool section/tile, safety warning, badges/pills. | `[x]` |
| P1 | `flutter_app/lib/features/earn/presentation/widgets/staking_insurance_fund_overview.dart` | 151 | Split info banner, tabs, status card, asset breakdown, contribution card. | `[x]` |
| P1 | `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_create_widgets.dart` | 207 | Split create form, side choice, labeled fields, preview, empty state. | `[x]` |
| P1 | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_results.dart` | 164 | Split result shell plus prediction, arena mode, arena room, creator, trading pair cards. | `[x]` |
| P1 | `flutter_app/lib/features/dca/presentation/widgets/dca_performance_compare_analysis.dart` | 182 | Split pros/cons, info/warning cards, small metrics, painters. | `[x]` |
| P1 | `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_cards.dart` | 29 | Split open interest, long/short, top traders, funding, toggle/trend labels. | `[x]` |
| P1 | `flutter_app/lib/features/trade/presentation/widgets/regulatory_disclosures_common.dart` | 20 | Split disclosure cards, commitments, warnings, leverage rules, contact/document tiles. | `[x]` |

Required verification per touched feature:

```bash
cd flutter_app
dart format <touched-files>
flutter test test/features/<feature> --reporter=compact
flutter analyze
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

For Trade and Earn financial copy also run:

```bash
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

### Batch EClean-01 - Profile And Launchpad Widget Split

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_cards.dart` | 560 | 148 | Split card details, primitives, and formatters into sibling part files. | `[x]` |
| `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_home_tool_widgets.dart` | 538 | 196 | Split shared project primitives and home helpers into sibling part files. | `[x]` |

New files:

- `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_card_details.dart` (`204` lines)
- `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_primitives.dart` (`122` lines)
- `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_formatters.dart` (`89` lines)
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_home_shared_widgets.dart` (`231` lines)
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_home_helpers.dart` (`113` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused profile tests passed.
- [x] Focused launchpad tests passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: production threshold scan - no production hard-limit regression; max production Dart file 574 lines.
2026-06-01: test threshold scan - existing test soft-review files remain outside this batch.
2026-06-01: manifest grep - both target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for both target files.
2026-06-01: dart format touched profile and launchpad page/widget part files - passed, 0 changed after formatting.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter test test/features/profile --reporter=compact - passed, 38 tests.
2026-06-01: flutter test test/features/launchpad --reporter=compact - first run failed because copied Launchpad tab/safety copy was mojibake; fixed touched Launchpad strings to UTF-8 Vietnamese and reran.
2026-06-01: flutter test test/features/launchpad --reporter=compact - passed, 121 tests.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: Flutter-Enterprise-100-Percent-File-Action-Manifest.csv updated for split_done target files and five new part files.
```

Notes:

- Batch uses additional `part` files because both target files already belong
  to page libraries and their private widgets/helpers are used across sibling
  page part files.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-02 - Earn Staking Insurance And Launchpad Limit Orders Widget Split

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/earn/presentation/widgets/staking_insurance_fund_overview.dart` | 499 | 151 | Split status/asset/contribution widgets into cohesive sibling files. | `[x]` |
| `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_create_widgets.dart` | 494 | 207 | Split create form, preview, empty state, and shared formatter helpers into sibling part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/earn/presentation/widgets/staking_insurance_fund_history.dart` | 121 | 121 | Retarget import to extracted status card file. | `[x]` |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_limit_orders_page.dart` | 196 | 199 | Add part declarations for extracted limit order widget files. | `[x]` |

New files:

- `flutter_app/lib/features/earn/presentation/widgets/staking_insurance_fund_status_card.dart` (`196` lines)
- `flutter_app/lib/features/earn/presentation/widgets/staking_insurance_fund_asset_breakdown.dart` (`92` lines)
- `flutter_app/lib/features/earn/presentation/widgets/staking_insurance_fund_contribution_card.dart` (`88` lines)
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_create_fields.dart` (`151` lines)
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_preview_widgets.dart` (`129` lines)
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_formatters.dart` (`10` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Earn tests passed.
- [x] Focused Launchpad tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short - workspace has many pre-existing modified/untracked files; EClean-02 will only touch listed target/source/doc/manifest files.
2026-06-01: full inventory scan - current max production Dart file 574 lines; no production file over 600 lines.
2026-06-01: manifest grep - both EClean-02 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for both EClean-02 target files.
2026-06-01: dart format touched Earn and Launchpad files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter test test/features/earn --reporter=compact - passed, 354 tests.
2026-06-01: flutter test test/features/launchpad --reporter=compact - passed, 121 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: Flutter-Enterprise-100-Percent-File-Action-Manifest.csv updated for two split_done target files, two touched support files, and six new files.
```

Notes:

- Earn overview uses public widget imports, so extracted files should stay as
  public sibling widget files with package imports.
- Launchpad limit order widgets already use page `part` files and private page
  state, so extracted siblings should remain `part of` the page library.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-03 - Discovery Search Results And DCA Performance Compare Widget Split

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/discovery/presentation/widgets/unified_search_results.dart` | 490 | 164 | Split result shell, prediction/Arena cards, creator, and trading pair cards into sibling part files. | `[x]` |
| `flutter_app/lib/features/dca/presentation/widgets/dca_performance_compare_analysis.dart` | 489 | 182 | Split analysis cards, primitives, formatters, and painters into cohesive sibling part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/discovery/presentation/pages/unified_search_page.dart` | 125 | 127 | Add part declarations for extracted result card files. | `[x]` |
| `flutter_app/lib/features/dca/presentation/pages/dca_performance_compare_page.dart` | 166 | 168 | Add part declarations for extracted primitives and painters. | `[x]` |

New files:

- `flutter_app/lib/features/discovery/presentation/widgets/unified_search_prediction_arena_cards.dart` (`127` lines)
- `flutter_app/lib/features/discovery/presentation/widgets/unified_search_entity_cards.dart` (`201` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_performance_compare_primitives.dart` (`81` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_performance_compare_painters.dart` (`228` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Discovery tests passed.
- [x] Focused DCA tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: class boundary scan - completed for both EClean-03 target files.
2026-06-01: manifest grep - both EClean-03 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: dart format touched Discovery and DCA files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter test test/features/discovery --reporter=compact - passed, 12 tests.
2026-06-01: flutter test test/features/dca --reporter=compact - passed, 44 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: Flutter-Enterprise-100-Percent-File-Action-Manifest.csv updated for two split_done target files, two touched support files, and four new files.
```

Notes:

- Both target files are existing page `part` files, so extracted siblings should
  remain `part of` their page libraries to preserve private UI APIs.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-04 - Trade Market Interest And Regulatory Disclosure Widget Split

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_cards.dart` | 489 | 29 | Split open interest, long/short, top traders, funding, and small toggles into sibling part files. | `[x]` |
| `flutter_app/lib/features/trade/presentation/widgets/regulatory_disclosures_common.dart` | 486 | 20 | Split disclosure cards, warning/leverage cards, actions, contacts, documents, and notice panel into sibling part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/trade/presentation/pages/regulatory_disclosures_page.dart` | 111 | 102 | Add part declarations for extracted regulatory card/action files and retain page composition. | `[x]` |

New files:

- `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_open_interest.dart` (`75` lines)
- `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_ratio.dart` (`168` lines)
- `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_top_traders.dart` (`109` lines)
- `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_funding.dart` (`95` lines)
- `flutter_app/lib/features/trade/presentation/widgets/regulatory_disclosures_cards.dart` (`222` lines)
- `flutter_app/lib/features/trade/presentation/widgets/regulatory_disclosures_actions.dart` (`217` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Trade tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: manifest grep - both EClean-04 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for both EClean-04 target files.
2026-06-01: dart format touched Trade live market and regulatory disclosure files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter test test/features/trade --reporter=compact - passed, 343 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-04 - flutter_app/lib Dart files 1888; test Dart files 430; manifest rows 2318; production files over 600 lines 0; production files over 500 lines 188.
2026-06-01: Flutter-Enterprise-100-Percent-File-Action-Manifest.csv updated for two split_done target files, one touched support page, and six new files.
```

Notes:

- Live market interest is a public widget import surface; sibling part files
  preserve private widget names without exposing new public classes.
- Regulatory disclosures already use page part files, so extracted siblings
  should stay in the page library to preserve private regulatory UI APIs.
- Phase 1 is complete. All eight highest-value widget cleanup targets are now
  below their configured soft-review thresholds.

### Phase 2 - Page Part Debt Cleanup

Status: `[x]`

Goal: convert large page part files into clearer widget files when touched.

| Priority | File group | Current max | Split direction | Status |
| --- | --- | ---: | --- | --- |
| P1 | `prediction_event_detail_page_part_01.dart` to `_part_04.dart` | 334 | Move event hero, market tabs, probability sections, order/receipt panels to widgets. | `[x]` |
| P1 | `margin_trading_page_part_02.dart`, `_part_03.dart` | 246 | Move margin calculator, risk panel, position controls, liquidation explainers. | `[x]` |
| P2 | `dca_portfolio_optimizer_page_part_01.dart` to `_part_03.dart` | 310 | Move optimizer cards, recommendation lists, charts, scenario panels. | `[x]` |
| P2 | `savings_what_if_page_part_02.dart`, `_part_03.dart` | 314 | Move assumptions, result cards, projection chart, scenario comparison. | `[x]` |
| P2 | `arena_governance_gate_page_part_01.dart` to `_part_03.dart` | 275 | Move eligibility, review steps, points-only rules, governance panels. | `[x]` |
| P2 | `p2p_order_proof_page.dart`, `p2p_order_rate_page.dart` | 386 | Move proof upload/review panels, rating cards, safety guidance. | `[x]` |
| P2 | `predictions_global_activity_page.dart` | 243 | Move filters, activity sections, event rows, empty/error states. | `[x]` |
| P3 | `bot_backtesting_page.dart`, `performance_scenarios_page.dart` | 377 | Move scenario cards, metrics, charts, control panels. | `[x]` |
| P3 | `announcements_page.dart` | 331 | Move filters, announcement cards, detail/empty states. | `[x]` |
| P3 | `convert_page_part_01.dart` | 294 | Move asset inputs, preview, fee/risk rows, confirmation section. | `[x]` |
| P3 | `launchpad_webhooks_page_part_03.dart` | 218 | Move endpoint cards, delivery logs, retry panels. | `[x]` |

Page part files are not automatically bad, but they should not become the
default structure for new screens. Prefer public widget files for reusable or
reviewable UI sections.

### Batch EClean-05 - Prediction Event Detail Page Part Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page_part_01.dart` | 564 | 1 | Extract event header, outcome cards, stats, position, and chart sections into cohesive widget part files. | `[x]` |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page_part_02.dart` | 574 | 1 | Extract chart painter, order book, and trade panel sections into cohesive widget part files. | `[x]` |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page_part_03.dart` | 519 | 1 | Extract trade controls, detail tabs, rules, and comments sections into cohesive widget part files. | `[x]` |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page_part_04.dart` | 560 | 1 | Extract holders, activity, related markets, and Arena bridge sections into cohesive widget part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` | 227 | 237 | Add part declarations for extracted Prediction Event Detail widget files. | `[x]` |
| `flutter_app/test/quality/product_copy_guardrails_test.dart` | 632 | 642 | Extend Prediction event copy scan list to include extracted widget files. | `[x]` |

New files:

- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_header.dart` (`334` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_stats_position.dart` (`187` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_chart.dart` (`178` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_order_book.dart` (`198` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_trade_panel.dart` (`192` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_trade_controls.dart` (`222` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_detail_tabs.dart` (`267` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_comments.dart` (`187` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_activity_holders.dart` (`153` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/prediction_event_detail_related_arena.dart` (`305` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Predictions tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short - workspace has many pre-existing modified/untracked files; EClean-05 will only touch listed Prediction Event Detail source/doc/manifest files.
2026-06-01: inventory scan - flutter_app/lib Dart files 1888; test Dart files 430; production files over 600 lines 0; production files over 500 lines 188.
2026-06-01: manifest grep - all four EClean-05 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for all four EClean-05 target files.
2026-06-01: dart format touched Prediction Event Detail page, page parts, widget part files, and product copy guardrail test - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - first post-split run failed because two new widget part files were missing from the page `part` list; added the missing declarations.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/predictions --reporter=compact - passed, 85 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - first run failed because the guardrail still scanned the old page-part-only Prediction Event Detail file list after Arena boundary copy moved to a widget part file; scan list updated without weakening assertions.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-05 - flutter_app/lib Dart files 1898; test Dart files 430; manifest rows 2328; production files over 600 lines 0; production files over 500 lines 184.
2026-06-01: Flutter-Enterprise-100-Percent-File-Action-Manifest.csv updated for four split_done target files, two touched support files, and ten new widget part files.
```

Notes:

- Prediction Event Detail already uses page part files and private UI helpers
  across sibling parts. Extracted widgets should be sibling `part of` files
  under `presentation/widgets/` to reduce page-part debt without exposing new
  public APIs or changing route/provider contracts.
- The extracted `prediction_event_detail_related_arena.dart` keeps the
  Prediction-to-Arena boundary copy together so the points-only guardrail can
  continue scanning that source directly.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-06 - Margin Trading Page Part Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/trade/presentation/pages/margin_trading_page_part_02.dart` | 521 | 1 | Extract price comparison, pair card, side toggle, leverage selector/sheet, and order inputs into cohesive widget part files. | `[x]` |
| `flutter_app/lib/features/trade/presentation/pages/margin_trading_page_part_03.dart` | 568 | 1 | Extract input card, order summary/review, risk warnings, best execution, positions, and orders into cohesive widget part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/trade/presentation/pages/margin_trading_page.dart` | 189 | 195 | Add part declarations for extracted Margin Trading widget files. | `[x]` |
| `flutter_app/test/quality/product_copy_guardrails_test.dart` | 642 | 648 | Extend margin/futures copy scan list to include extracted margin widget files. | `[x]` |

New files:

- `flutter_app/lib/features/trade/presentation/widgets/margin_trading_price_pair.dart` (`246` lines)
- `flutter_app/lib/features/trade/presentation/widgets/margin_trading_order_controls.dart` (`230` lines)
- `flutter_app/lib/features/trade/presentation/widgets/margin_trading_order_inputs.dart` (`132` lines)
- `flutter_app/lib/features/trade/presentation/widgets/margin_trading_order_summary.dart` (`148` lines)
- `flutter_app/lib/features/trade/presentation/widgets/margin_trading_risk_cards.dart` (`221` lines)
- `flutter_app/lib/features/trade/presentation/widgets/margin_trading_positions_orders.dart` (`116` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Trade tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- margin trading target files - no direct pre-existing modifications on EClean-06 target files.
2026-06-01: manifest grep - both EClean-06 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for both EClean-06 target files.
2026-06-01: dart format touched Margin Trading page, page parts, widget part files, and product copy guardrail test - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/trade --reporter=compact - passed, 343 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - first run failed because the margin guardrail still scanned the old page-part-only file list after fee/leverage copy moved to widget part files; scan list updated without weakening assertions.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-06 - flutter_app/lib Dart files 1904; test Dart files 430; manifest rows 2334; production files over 600 lines 0; production files over 500 lines 182.
2026-06-01: Flutter-Enterprise-100-Percent-File-Action-Manifest.csv updated for two split_done target files, two touched support files, and six new widget part files.
```

Notes:

- Margin Trading already uses page part files and private page state callbacks.
  Extracted widgets should remain sibling `part of` files under
  `presentation/widgets/` to preserve private APIs and route/provider behavior.
- Margin order review, fee preview, leverage, liquidation, and risk copy remain
  covered by the product copy guardrail after the scan list update.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-07 - DCA Portfolio Optimizer Page Part Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/dca/presentation/pages/dca_portfolio_optimizer_page_part_01.dart` | 551 | 1 | Extract drift banner, comparison hero, allocation rows, optimizer tabs, and tab switcher into cohesive widget part files. | `[x]` |
| `flutter_app/lib/features/dca/presentation/pages/dca_portfolio_optimizer_page_part_02.dart` | 560 | 1 | Extract frontier, selected portfolio, suggestions, correlation, backtest, risk, and floating actions into cohesive widget part files. | `[x]` |
| `flutter_app/lib/features/dca/presentation/pages/dca_portfolio_optimizer_page_part_03.dart` | 545 | 1 | Extract common optimizer widgets, allocation helper rows, stat cards, and chart painter into cohesive widget part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart` | 150 | 160 | Add part declarations for extracted DCA Portfolio Optimizer widget files. | `[x]` |

New files:

- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_header_drift.dart` (`136` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_comparison_hero.dart` (`310` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_tabs.dart` (`107` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_frontier.dart` (`238` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_tab_panels.dart` (`211` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_floating_actions.dart` (`113` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_common_widgets.dart` (`133` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_allocation_widgets.dart` (`182` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_stat_widgets.dart` (`143` lines)
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_frontier_painter.dart` (`90` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused DCA tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- DCA optimizer target files - no direct pre-existing modifications on EClean-07 target files.
2026-06-01: manifest grep - all three EClean-07 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for all three EClean-07 target files.
2026-06-01: dart format touched DCA Portfolio Optimizer page, page parts, and widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/dca --reporter=compact - passed, 44 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-07 - flutter_app/lib Dart files 1914; test Dart files 430; manifest rows 2344; production files over 600 lines 0; production files over 500 lines 179.
```

Notes:

- DCA Portfolio Optimizer already uses page part files and private tab enum,
  helper methods, and callbacks. Extracted widgets should remain sibling
  `part of` files under `presentation/widgets/` to reduce page-part debt
  without changing public API.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-08 - Savings What-If Page Part Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/earn/presentation/pages/savings_what_if_page_part_02.dart` | 549 | 1 | Extract results, empty results, stress scenarios, stress bars/ranks, and comparison chart into cohesive widget part files. | `[x]` |
| `flutter_app/lib/features/earn/presentation/pages/savings_what_if_page_part_03.dart` | 559 | 1 | Extract asset impact list, shared metric/section widgets, callouts, score ring, legend, and chart painters into cohesive widget part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/earn/presentation/pages/savings_what_if_page.dart` | 200 | 207 | Add part declarations for extracted Savings What-If widget files. | `[x]` |

New files:

- `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_results.dart` (`219` lines)
- `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_stress.dart` (`168` lines)
- `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_stress_components.dart` (`164` lines)
- `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_asset_impact.dart` (`81` lines)
- `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_common_widgets.dart` (`314` lines)
- `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_painters.dart` (`97` lines)
- `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_models.dart` (`70` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Earn tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- Savings What-If target files - no direct pre-existing modifications on EClean-08 target files; unrelated Earn widget files are already dirty/untracked and will be left alone.
2026-06-01: manifest grep - both EClean-08 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for both EClean-08 target files.
2026-06-01: dart format touched Savings What-If page, page parts, and widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/earn --reporter=compact - passed, 354 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-08 - flutter_app/lib Dart files 1921; test Dart files 430; manifest rows 2351; production files over 600 lines 0; production files over 500 lines 177.
```

Notes:

- Savings What-If already uses page part files and private page callbacks.
  Extracted widgets should remain sibling `part of` files under
  `presentation/widgets/` to reduce page-part debt without changing route,
  provider, repository, or public domain contracts.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-09 - Arena Governance Gate Page Part Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/arena/presentation/pages/arena_governance_gate_page_part_01.dart` | 543 | 1 | Extract stepper, title/privacy, clarity, domain/type, and win-condition UI into cohesive Arena widget part files. | `[x]` |
| `flutter_app/lib/features/arena/presentation/pages/arena_governance_gate_page_part_02.dart` | 548 | 1 | Extract description/resolution fields, timing rules, warnings, eligibility, summary, and footer panels into cohesive Arena widget part files. | `[x]` |
| `flutter_app/lib/features/arena/presentation/pages/arena_governance_gate_page_part_03.dart` | 556 | 1 | Extract field blocks, chips, builder/dropdown/switch controls, summary rows, status/next-action chips, and moderation note into cohesive Arena widget part files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/arena/presentation/pages/arena_governance_gate_page.dart` | 403 | 413 | Add part declarations for extracted Arena Governance Gate widget files. | `[x]` |

New files:

- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_models.dart` (`32` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_stepper_title.dart` (`115` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_privacy_clarity.dart` (`188` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_setup_fields.dart` (`211` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_resolution_timing.dart` (`208` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_suggestions_eligibility.dart` (`141` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_summary_footer.dart` (`201` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_field_controls.dart` (`275` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_status_widgets.dart` (`177` lines)
- `flutter_app/lib/features/arena/presentation/widgets/arena_governance_gate_helpers.dart` (`106` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Arena tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- Arena Governance Gate target files - no direct pre-existing modifications on EClean-09 target files; unrelated Arena widget files are already untracked and will be left alone.
2026-06-01: manifest grep - all three EClean-09 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for all three EClean-09 target files.
2026-06-01: dart format touched Arena Governance Gate page, page parts, and widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/arena --reporter=compact - passed, 111 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-09 - flutter_app/lib Dart files 1931; test Dart files 430; manifest rows 2361; production files over 600 lines 0; production files over 500 lines 174.
```

Notes:

- Arena Governance Gate already uses page part files and private page state.
  Extracted widgets should remain sibling `part of` files under
  `presentation/widgets/`.
- Arena copy must remain points-only and must not borrow wallet, payout,
  profit, or stake-return language.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-10 - P2P Order Proof And Rate Page Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/p2p/presentation/pages/p2p_order_proof_page.dart` | 547 | 169 | Extract order proof summary, upload section/source cards, uploaded proof thumbnails, tips, and proof warning into cohesive P2P widget files. | `[x]` |
| `flutter_app/lib/features/p2p/presentation/pages/p2p_order_rate_page.dart` | 544 | 161 | Extract merchant summary, rating card, stars/tags, review box, action row, and success view into cohesive P2P widget files. | `[x]` |

New files:

- `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_proof_widgets.dart` (`381` lines)
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_rate_widgets.dart` (`386` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused P2P tests passed.
- [x] Product copy guardrail passed.
- [x] Accessibility critical flows passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- P2P order proof/rate target files - no direct pre-existing modifications on EClean-10 target files; unrelated P2P widget files are already dirty/untracked and will be left alone.
2026-06-01: manifest grep - both EClean-10 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for both EClean-10 target files.
2026-06-01: dart format touched P2P order proof/rate pages and widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/p2p --reporter=compact - passed, 311 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact - passed, 6 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-10 - flutter_app/lib Dart files 1933; test Dart files 430; manifest rows 2363; production files over 600 lines 0; production files over 500 lines 172.
```

Notes:

- P2P proof/rate files are now page libraries with sibling `part of` widget
  files under `presentation/widgets/`, preserving private keys/helpers and
  route/provider behavior while reducing page responsibility.
- Preserve escrow/proof/payment safety copy and do not weaken confirmation or
  evidence language.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-11 - Predictions Global Activity Page Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/predictions/presentation/pages/predictions_global_activity_page.dart` | 546 | 109 | Extract live stats, amount filters, activity list/rows, and outcome badge into cohesive Predictions widget files. | `[x]` |

New files:

- `flutter_app/lib/features/predictions/presentation/widgets/predictions_global_activity_widgets.dart` (`243` lines)
- `flutter_app/lib/features/predictions/presentation/widgets/predictions_global_activity_feed_widgets.dart` (`199` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target file exists in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Predictions tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- Predictions Global Activity target file - no direct pre-existing modifications on EClean-11 target file; unrelated Prediction widget files are already untracked and will be left alone.
2026-06-01: manifest grep - EClean-11 target file found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for EClean-11 target file.
2026-06-01: dart format touched Predictions Global Activity page and widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/predictions --reporter=compact - passed, 85 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-11 - flutter_app/lib Dart files 1935; test Dart files 430; manifest rows 2365; production files over 600 lines 0; production files over 500 lines 171.
```

Notes:

- Predictions Global Activity is a standalone page. Extracted widgets should
  remain a sibling `part of` file under `presentation/widgets/` to preserve
  private keys/helpers and route/provider behavior.
- Preserve Prediction Market copy and keep Arena bridge/boundary language
  separated.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-12 - Bot Backtesting And Performance Scenarios Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/trade/presentation/pages/bot_backtesting_page.dart` | 542 | 168 | Extract strategy/pair/date selectors, capital input, period card, run footer, and section label into cohesive Trade widget files. | `[x]` |
| `flutter_app/lib/features/trade/presentation/pages/performance_scenarios_page.dart` | 541 | 113 | Extract warning/investment cards, holding period selector, scenario cards, metric boxes, notes, and card shell into cohesive Trade widget files. | `[x]` |

New files:

- `flutter_app/lib/features/trade/presentation/widgets/bot_backtesting_widgets.dart` (`377` lines)
- `flutter_app/lib/features/trade/presentation/widgets/performance_scenarios_intro_widgets.dart` (`182` lines)
- `flutter_app/lib/features/trade/presentation/widgets/performance_scenarios_outcome_widgets.dart` (`251` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target files exist in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Trade tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: manifest lookup - EClean-12 target files live under `lib/features/trade/...`, not separate `bot` or `performance` feature directories; next-batch paths corrected to match CSV source of truth.
2026-06-01: git status --short -- Trade bot/performance target files - no direct pre-existing modifications on EClean-12 target files; unrelated Trade widget files are already dirty/untracked and will be left alone.
2026-06-01: manifest grep - both EClean-12 target files found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for both EClean-12 target files.
2026-06-01: dart format touched Bot Backtesting and Performance Scenarios pages plus widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/trade --reporter=compact - passed, 343 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-12 - flutter_app/lib Dart files 1938; test Dart files 430; manifest rows 2368; production files over 600 lines 0; production files over 500 lines 169.
```

Notes:

- These are standalone Trade pages. Extracted widgets should remain sibling
  `part of` files under `presentation/widgets/` to preserve private keys,
  labels, helpers, route/provider behavior, and existing tests.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-13 - Announcements Page Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/support/presentation/pages/announcements_page.dart` | 542 | 133 | Extract filter rail/chips, pinned section, announcement list/cards, type/pill/tag widgets, and formatting helpers into cohesive Support widget files. | `[x]` |

New files:

- `flutter_app/lib/features/support/presentation/widgets/announcements_filters_widgets.dart` (`83` lines)
- `flutter_app/lib/features/support/presentation/widgets/announcements_list_widgets.dart` (`331` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target file exists in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Support tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: manifest lookup - EClean-13 target file lives under `lib/features/support/...`, not `features/announcements`; next-batch path corrected to match CSV source of truth.
2026-06-01: git status --short -- Announcements target file - no direct pre-existing modifications on EClean-13 target file; unrelated Support widget directory is already untracked and will be left alone.
2026-06-01: manifest grep - EClean-13 target file found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for EClean-13 target file.
2026-06-01: dart format touched Announcements page and widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/support --reporter=compact - passed, 16 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-13 - flutter_app/lib Dart files 1940; test Dart files 430; manifest rows 2370; production files over 600 lines 0; production files over 500 lines 168.
```

Notes:

- Announcements is a standalone Support page. Extracted widgets should remain
  a sibling `part of` file under `presentation/widgets/` to preserve private
  keys/helpers and route/provider behavior.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-14 - Convert Page Part Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/trade/presentation/pages/convert_page_part_01.dart` | 538 | 1 | Extract convert header, mode tabs, favorite pairs, rate bar, amount card, asset button, and percent chip into cohesive Trade widget files. | `[x]` |

Touched support files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/trade/presentation/pages/convert_page.dart` | 263 | 265 | Add part declarations for extracted Convert widget files. | `[x]` |

New files:

- `flutter_app/lib/features/trade/presentation/widgets/convert_page_header_widgets.dart` (`294` lines)
- `flutter_app/lib/features/trade/presentation/widgets/convert_page_amount_widgets.dart` (`245` lines)

Checks:

- [x] Class boundary scan completed.
- [x] Target file exists in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Trade tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- Convert target files - no direct pre-existing modifications on EClean-14 target files; unrelated Trade widget files are already dirty/untracked and will be left alone.
2026-06-01: manifest grep - EClean-14 target file found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for EClean-14 target file.
2026-06-01: dart format touched Convert page, page part, and widget part files - passed.
2026-06-01: direct grep `features/.*/data|\bColors\.` over touched source - no matches.
2026-06-01: flutter analyze - passed, No issues found.
2026-06-01: flutter test test/features/trade --reporter=compact - passed, 343 tests.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - passed, 13 tests.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - passed, 10 tests.
2026-06-01: inventory scan after EClean-14 - flutter_app/lib Dart files 1942; test Dart files 430; manifest rows 2372; production files over 600 lines 0; production files over 500 lines 167.
```

Notes:

- Convert already uses page part files and private page state. Extracted widgets
  should remain sibling `part of` files under `presentation/widgets/`.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Batch EClean-15 - Launchpad Webhooks Page Part Cleanup

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_webhooks_page.dart` | 233 | 236 | Added widget part declarations for extracted Launchpad Webhooks sections. | `[x]` |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_03.dart` | 534 | 1 | Extract create webhook sheet state, sheet text field, choice controls, status/mini pills, copy button, and empty subscriptions into cohesive Launchpad widget files. | `[x]` |

New files:

- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_webhooks_sheet_state.dart` - 194 lines.
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_webhooks_form_controls.dart` - 218 lines.
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_webhooks_common_widgets.dart` - 124 lines.

Checks:

- [x] Class boundary scan completed.
- [x] Target file exists in CSV manifest.
- [x] No new presentation imports from `features/*/data`.
- [x] No new direct runtime `Colors.*`.
- [x] Package imports used across modules.
- [x] Focused Launchpad tests passed.
- [x] Product copy guardrail passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: git status --short -- Launchpad Webhooks target files - no direct pre-existing modifications on EClean-15 target files; unrelated Launchpad widget files are already dirty/untracked and will be left alone.
2026-06-01: manifest grep - EClean-15 target file found in Flutter-Enterprise-100-Percent-File-Action-Manifest.csv.
2026-06-01: class boundary scan - completed for EClean-15 target file.
2026-06-01: dart format launchpad webhooks touched files - formatted 5 files, 0 changed.
2026-06-01: smell scan touched files - no `features/*/data` presentation imports and no direct runtime `Colors.*` matches.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/features/launchpad --reporter=compact - 121 tests passed.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - 13 tests passed.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-15 - flutter_app/lib Dart files 1945; test Dart files 430; manifest rows 2375; production files over 600 lines 0; production files over 500 lines 166.
```

Notes:

- Launchpad Webhooks already uses page part files and private sheet state.
  Extracted widgets should remain sibling `part of` files under
  `presentation/widgets/`.
- No product behavior, route path, provider, repository, or public domain
  contract changes were made.

### Phase 3 - Domain Entity Boundary Review

Status: `[x]`

Goal: ensure entity files are split by domain meaning, not arbitrary chunks.

Current soft-review counts over `500` lines:

| Feature | Files over 500 | Max lines | Direction |
| --- | ---: | ---: | --- |
| `trade` | 13 | 558 | Split by orders, positions, risk, copy trading, compliance only during domain work. |
| `earn` | 12 | 560 | Split by savings, staking, insurance, reporting, suitability. |
| `p2p` | 10 | 553 | Split by ads, orders, disputes, security, merchant, payments. |
| `launchpad` | 4 | 552 | Split by project, sale, bridge, risk, operations. |
| `arena` | 4 | 560 | Keep points-only boundary clear; split by challenge, points ledger, governance, safety. |
| `markets` | 3 | 517 | Split by pair, depth, alerts, social signals if needed. |
| `predictions` | 2 | 514 | Keep separate from Arena; split event, order, portfolio, receipt. |
| `referral` | 1 | 552 | Split campaign, invite, reward, analytics if feature expands. |

Do not churn these files only to reduce line count. Refactor when a feature
change touches the domain.

### Batch EClean-16 - Domain Entity Boundary Review: Trade And Earn

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| Feature | Files Reviewed | Max Lines | Decision | Status |
| --- | ---: | ---: | --- | --- |
| `trade` | 13 | 558 | Documented exception. Keep `trade_entities.dart` facade and current entity part topology until a bounded-context contract change requires a semantic split. | `[x]` |
| `earn` | 12 | 560 | Documented exception. Keep `earn_entities.dart` facade and current entity part topology until a bounded-context contract change requires a semantic split. | `[x]` |

Checks:

- [x] Trade domain entity part line counts scanned.
- [x] Earn domain entity part line counts scanned.
- [x] Symbol boundary scan completed for Trade and Earn entity parts.
- [x] No Dart source edit made for line-count-only churn.
- [x] CSV manifest updated to `exception_documented` for reviewed Trade/Earn soft-review entity parts.
- [x] `flutter analyze` passed.
- [x] Focused Trade tests passed.
- [x] Focused Earn tests passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: Trade domain entity scan - 13 soft-review files over 500 lines, max 558, all under domain hard limit 800.
2026-06-01: Earn domain entity scan - 12 soft-review files over 500 lines, max 560, all under domain hard limit 800.
2026-06-01: symbol boundary scan - completed for Trade and Earn entity part files.
2026-06-01: decision - no source split; preserve public domain facade and part topology until real bounded-context work touches the entities.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/features/trade --reporter=compact - 343 tests passed.
2026-06-01: flutter test test/features/earn --reporter=compact - 354 tests passed.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-16 - no Dart source files added or removed; flutter_app/lib Dart files 1945; test Dart files 430; manifest rows 2375; production files over 600 lines 0; production files over 500 lines 166.
```

Notes:

- This batch intentionally avoided mechanical domain splitting. The current
  files are generated-style library parts, below hard limit, and exported
  through stable public facades.
- Future Trade splits must follow domain meaning such as orders, positions,
  risk, copy trading, bot automation, compliance, reporting, costs, or market
  analytics.
- Future Earn splits must follow domain meaning such as savings, staking,
  insurance, reporting, suitability, governance, API/developer surfaces,
  automation, or risk.

### Batch EClean-17 - Domain Entity Boundary Review: P2P, Launchpad, Arena

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| Feature | Files Reviewed | Max Lines | Decision | Status |
| --- | ---: | ---: | --- | --- |
| `p2p` | 10 | 553 | Documented exception. Keep `p2p_entities.dart` facade and current entity part topology until a bounded-context contract change requires a semantic split. | `[x]` |
| `launchpad` | 4 | 552 | Documented exception. Keep `launchpad_entities.dart` facade and current entity part topology until a bounded-context contract change requires a semantic split. | `[x]` |
| `arena` | 4 | 560 | Documented exception. Keep `arena_entities.dart` facade and current entity part topology until a bounded-context contract change requires a semantic split; preserve Arena points-only boundary. | `[x]` |

Checks:

- [x] P2P domain entity part line counts scanned.
- [x] Launchpad domain entity part line counts scanned.
- [x] Arena domain entity part line counts scanned.
- [x] Symbol boundary scan completed for P2P, Launchpad, and Arena entity parts.
- [x] No Dart source edit made for line-count-only churn.
- [x] CSV manifest updated to `exception_documented` for reviewed P2P/Launchpad/Arena soft-review entity parts.
- [x] `flutter analyze` passed.
- [x] Focused P2P tests passed.
- [x] Focused Launchpad tests passed.
- [x] Focused Arena tests passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: P2P domain entity scan - 10 soft-review files over 500 lines, max 553, all under domain hard limit 800.
2026-06-01: Launchpad domain entity scan - 4 soft-review files over 500 lines, max 552, all under domain hard limit 800.
2026-06-01: Arena domain entity scan - 4 soft-review files over 500 lines, max 560, all under domain hard limit 800.
2026-06-01: symbol boundary scan - completed for P2P, Launchpad, and Arena entity part files.
2026-06-01: decision - no source split; preserve public domain facades and part topology until real bounded-context work touches the entities.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/features/p2p --reporter=compact - 311 tests passed.
2026-06-01: flutter test test/features/launchpad --reporter=compact - 121 tests passed.
2026-06-01: flutter test test/features/arena --reporter=compact - 111 tests passed.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-17 - no Dart source files added or removed; flutter_app/lib Dart files 1945; test Dart files 430; manifest rows 2375; production files over 600 lines 0; production files over 500 lines 166.
```

Notes:

- P2P future splits must follow ads, orders, disputes, escrow, security,
  merchant, payments, compliance, wallet, claims, or risk boundaries.
- Launchpad future splits must follow project, sale, staking, claim, bridge,
  address book, webhooks, gas, rebalance, multisig, swap, DCA, risk, or
  contract operation boundaries.
- Arena future splits must preserve the points-only model and stay separated
  from Prediction Markets financial language.

### Batch EClean-18 - Domain Entity Boundary Review: Markets, Predictions, Referral

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| Feature | Files Reviewed | Max Lines | Decision | Status |
| --- | ---: | ---: | --- | --- |
| `markets` | 3 | 517 | Documented exception. Keep `market_entities.dart` facade and current entity part topology until a bounded-context contract change requires a semantic split. | `[x]` |
| `predictions` | 2 | 514 | Documented exception. Keep `predictions_entities.dart` facade and current entity part topology until a bounded-context contract change requires a semantic split; keep Prediction Markets separate from Arena. | `[x]` |
| `referral` | 1 | 552 | Documented exception. Keep single Referral bounded-context entity file until referral contracts expand enough for a semantic split. | `[x]` |

Checks:

- [x] Markets domain entity line counts scanned.
- [x] Predictions domain entity line counts scanned.
- [x] Referral domain entity line counts scanned.
- [x] Symbol boundary scan completed for Markets, Predictions, and Referral entity files.
- [x] No Dart source edit made for line-count-only churn.
- [x] CSV manifest updated to `exception_documented` for reviewed Markets/Predictions/Referral soft-review entity files.
- [x] `flutter analyze` passed.
- [x] Focused Markets tests passed.
- [x] Focused Predictions tests passed.
- [x] Focused Referral tests passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: Markets domain entity scan - 3 soft-review files over 500 lines, max 517, all under domain hard limit 800.
2026-06-01: Predictions domain entity scan - 2 soft-review files over 500 lines, max 514, all under domain hard limit 800.
2026-06-01: Referral domain entity scan - 1 soft-review file over 500 lines, max 552, under domain hard limit 800.
2026-06-01: symbol boundary scan - completed for Markets, Predictions, and Referral entity files.
2026-06-01: decision - no source split; preserve public domain facades and bounded-context entity topology until real domain work touches the entities.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/features/markets --reporter=compact - 124 tests passed.
2026-06-01: flutter test test/features/predictions --reporter=compact - 85 tests passed.
2026-06-01: flutter test test/features/referral --reporter=compact - 23 tests passed.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-18 - no Dart source files added or removed; flutter_app/lib Dart files 1945; test Dart files 430; manifest rows 2375; production files over 600 lines 0; production files over 500 lines 166.
```

Notes:

- Phase 3 is complete. All domain entity soft-review groups listed in this
  plan are either already under soft target or documented with semantic split
  rules in the CSV manifest.
- Markets future splits must follow pair, depth, alerts, social signals, token
  unlocks, charts, derivatives, calendar, news, screener, or watchlist
  boundaries.
- Predictions future splits must preserve the Prediction Markets versus Arena
  boundary and split only by event, order, portfolio, receipt, leaderboard,
  rewards, calendar, social, tournament, integrations, or liquidity.
- Referral future splits should wait for campaign, invite, friend, reward,
  history, analytics, rules, dispute, or export contracts to expand.

### Phase 4 - Router And Route Contract Cleanup

Status: `[x]`

Goal: keep router files readable as routes grow.

| File | Current lines | Action | Status |
| --- | ---: | --- | --- |
| `flutter_app/lib/app/router/route_groups/trade_routes.dart` | 567 | Documented exception; split into trade route subgroups only if new trade routes require a semantic route-boundary change. | `[x]` |
| `flutter_app/lib/app/router/app_route_paths.dart` | 550 | Documented exception; consider grouped path constants only if route count keeps growing without changing the public router facade. | `[x]` |
| `flutter_app/lib/app/router/route_groups/p2p_routes.dart` | 515 | Documented exception; split by P2P order, merchant, security, or payment routes only when real route work touches the group. | `[x]` |

Required tests:

```bash
cd flutter_app
flutter test test/app/router --reporter=compact
flutter test test/quality/route_coverage_guardrails_test.dart --reporter=compact
flutter analyze
```

### Batch EClean-19 - Router And Route Contract Review

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Decision | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/lib/app/router/route_groups/trade_routes.dart` | 567 | 567 | Documented exception. Keep current Trade route group until a cohesive route subgroup change requires a semantic split. | `[x]` |
| `flutter_app/lib/app/router/app_route_paths.dart` | 550 | 550 | Documented exception. Keep current public path constants until grouped path contracts can be split without changing public route API. | `[x]` |
| `flutter_app/lib/app/router/route_groups/p2p_routes.dart` | 515 | 515 | Documented exception. Keep current P2P route group until a cohesive P2P route subgroup change requires a semantic split. | `[x]` |

Checks:

- [x] Router file line counts scanned.
- [x] Route path/name surface scanned.
- [x] No Dart source edit made for line-count-only churn.
- [x] CSV manifest updated to `exception_documented` for reviewed router soft-review files.
- [x] `flutter analyze` passed.
- [x] App router tests passed.
- [x] Route coverage guardrail passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: router line scan - trade_routes.dart 567 lines; app_route_paths.dart 550 lines; p2p_routes.dart 515 lines; all under router hard limit 700.
2026-06-01: route surface scan - route path/name declarations reviewed for target files.
2026-06-01: decision - no source split; preserve public router facade, path constants, route names, redirects, and route topology until real route subgroup work touches the files.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/app/router --reporter=compact - 12 tests passed.
2026-06-01: flutter test test/quality/route_coverage_guardrails_test.dart --reporter=compact - 1 test passed.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-19 - no Dart source files added or removed; flutter_app/lib Dart files 1945; test Dart files 430; manifest rows 2375; production files over 600 lines 0; production files over 500 lines 166.
```

Notes:

- Phase 4 is complete. Future router splits must be route-contract work, not
  line-count-only churn.
- `app_router.dart` remains the public router import surface.

### Phase 5 - Test Suite Cleanup

Status: `[x]`

Goal: keep tests readable and fast to run by focused surface.

| Priority | File | Current lines | Split direction | Status |
| --- | --- | ---: | --- | --- |
| P1 | `flutter_app/test/features/trade/trade_history_export_page_test.dart` | 166 | Replaced full repository wrapper with focused export fake; no sibling split required after cleanup. | `[x]` |
| P1 | `flutter_app/test/quality/product_copy_guardrails_test.dart` | 229 | Split financial copy, Arena copy, Prediction copy, banned language guardrails. | `[x]` |
| P2 | `flutter_app/test/app/router/app_route_paths_contract_test.dart` | 15 | Split into focused core, market/prediction, Trade, P2P, wallet/profile, and Arena/support route path contract tests; max sibling file 235 lines. | `[x]` |
| P2 | `flutter_app/test/features/trade/trade_controller_test.dart` | 149 | Split order/leverage/margin, copy/provider, futures/risk/order/advanced tools, and bot safety controller tests; max sibling file 146 lines. | `[x]` |

Required verification:

```bash
cd flutter_app
flutter test <new-test-files> --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter analyze
```

### Batch EClean-20 - Test Suite Cleanup: Trade History Export

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/test/features/trade/trade_history_export_page_test.dart` | 794 | 166 | Replaced full `TradeRepository` capture wrapper with a focused export fake using `noSuchMethod` fallback; preserved SC-054 expectations. | `[x]` |

Checks:

- [x] Test behavior groups reviewed.
- [x] No production Dart source edited.
- [x] Large capture-only repository wrapper removed.
- [x] Focused test file now under soft target.
- [x] `dart format` passed.
- [x] Focused export test passed.
- [x] Full Trade feature test suite passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: line scan before EClean-20 - trade_history_export_page_test.dart 794 lines.
2026-06-01: cleanup - replaced full TradeRepository wrapper with focused export fake; no route, provider, production, or assertion behavior changed.
2026-06-01: dart format test/features/trade/trade_history_export_page_test.dart - formatted 1 file, 0 changed.
2026-06-01: flutter test test/features/trade/trade_history_export_page_test.dart --reporter=compact - 5 tests passed.
2026-06-01: flutter test test/features/trade --reporter=compact - 343 tests passed.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-20 - flutter_app/lib Dart files 1945; test Dart files 430; manifest rows 2375; production files over 600 lines 0; production files over 500 lines 166; test files over 600 lines 1; test files over 500 lines 3; test files over 400 lines 3.
```

Notes:

- The test was large because the capture fake implemented the entire
  `TradeRepository` interface. The page under test only needs
  `getTradeExport` and `createTradeExport`, so a focused test fake is the
  cleaner enterprise boundary here.
- No sibling test file was created because the remaining five tests now read as
  one cohesive export page behavior suite.

### Batch EClean-21 - Test Suite Cleanup: Product Copy Guardrails

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/test/quality/product_copy_guardrails_test.dart` | 648 | 178 | Kept Arena, RewardsHub, and auth reset copy guardrails in the original file. | `[x]` |
| `flutter_app/test/quality/product_copy_guardrail_test_utils.dart` | new | 47 | Extracted shared source reading, ASCII fold, and high-risk target helpers. | `[x]` |
| `flutter_app/test/quality/trade_product_copy_guardrails_test.dart` | new | 132 | Extracted Trade copy, futures, and margin safety-copy guardrails. | `[x]` |
| `flutter_app/test/quality/prediction_product_copy_guardrails_test.dart` | new | 89 | Extracted Prediction Markets, Wallet high-risk, and Arena boundary copy guardrails. | `[x]` |
| `flutter_app/test/quality/p2p_wallet_product_copy_guardrails_test.dart` | new | 229 | Extracted P2P, escrow, wallet, and payment-method safety-copy guardrails. | `[x]` |

Checks:

- [x] Guardrail concerns reviewed and grouped by product boundary.
- [x] No production Dart source edited.
- [x] Shared helper extracted without duplicate test registration.
- [x] All resulting files are below test soft target.
- [x] `dart format` passed.
- [x] Original Product Copy guardrail file passed.
- [x] New Trade, Prediction, and P2P/Wallet guardrail files passed.
- [x] Full quality suite passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: line scan before EClean-21 - product_copy_guardrails_test.dart 648 lines.
2026-06-01: split - extracted shared helper plus Trade, Prediction, and P2P/Wallet quality test files; original file now covers Arena, RewardsHub, and auth reset copy guardrails.
2026-06-01: dart format product copy guardrail files - formatted 5 files, 4 changed.
2026-06-01: flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact - 7 tests passed.
2026-06-01: flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact - 2 tests passed.
2026-06-01: flutter test test/quality/prediction_product_copy_guardrails_test.dart --reporter=compact - 2 tests passed.
2026-06-01: flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact - 2 tests passed.
2026-06-01: flutter test test/quality --reporter=compact - all quality tests passed.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-21 - flutter_app/lib Dart files 1945; test Dart files 434; manifest rows 2379; production files over 600 lines 0; production files over 500 lines 166; test files over 600 lines 0; test files over 500 lines 2; test files over 400 lines 2.
```

Notes:

- Product boundary coverage is unchanged: Arena remains points-only,
  Prediction Markets remains separated from Arena, and P2P/Wallet/Trade
  high-risk confirmation copy remains guarded.
- Splitting by concern makes future copy additions less likely to weaken an
  unrelated product-boundary assertion.

### Batch EClean-22 - Test Suite Cleanup: App Route Paths Contract

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/test/app/router/app_route_paths_contract_test.dart` | 545 | 15 | Kept only core auth, news, and bottom-nav path assertions in the original file. | `[x]` |
| `flutter_app/test/app/router/app_route_paths_contract_test_utils.dart` | new | 10 | Extracted shared route path contract assertion helper. | `[x]` |
| `flutter_app/test/app/router/app_route_paths_market_prediction_contract_test.dart` | new | 89 | Extracted market, pair, and Prediction Markets route path assertions. | `[x]` |
| `flutter_app/test/app/router/app_route_paths_trade_contract_test.dart` | new | 235 | Extracted Trade, bot, copy trading, and margin route path assertions. | `[x]` |
| `flutter_app/test/app/router/app_route_paths_p2p_contract_test.dart` | new | 65 | Extracted P2P route path assertions. | `[x]` |
| `flutter_app/test/app/router/app_route_paths_wallet_profile_contract_test.dart` | new | 76 | Extracted wallet, profile, DCA, admin, onboarding, and settings route path assertions. | `[x]` |
| `flutter_app/test/app/router/app_route_paths_arena_contract_test.dart` | new | 28 | Extracted Arena and support route path assertions. | `[x]` |

Checks:

- [x] Route path contract assertions reviewed and grouped by route surface.
- [x] All 267 route path assertions preserved.
- [x] No production Dart source edited.
- [x] All resulting route path contract files are below the test soft-review target.
- [x] `dart format` passed.
- [x] Full app router test suite passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: line scan before EClean-22 - app_route_paths_contract_test.dart 545 lines.
2026-06-01: split - extracted shared helper plus core, market/prediction, Trade, P2P, wallet/profile, and Arena/support route path contract tests.
2026-06-01: assertion audit - parsed and preserved 267 route path assertions across focused files.
2026-06-01: dart format route path contract files - formatted 7 files, 4 changed.
2026-06-01: flutter test test/app/router --reporter=compact - 17 tests passed.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-22 - flutter_app/lib Dart files 1945; test Dart files 440; manifest rows 2385; production files over 600 lines 0; production files over 500 lines 61; test files over 600 lines 0; test files over 500 lines 0; test files over 400 lines 1.
```

Notes:

- The contract is now organized by route boundary, so future route additions can
  update the matching focused file without re-opening one large assertion list.
- Arena route assertions remain isolated from Prediction Markets and Trade route
  assertions, matching the product-boundary standard.

### Batch EClean-23 - Test Suite Cleanup: Trade Controller

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `flutter_app/test/features/trade/trade_controller_test.dart` | 476 | 149 | Kept core order, leverage, and margin controller assertions in the original file. | `[x]` |
| `flutter_app/test/features/trade/trade_copy_controller_test.dart` | new | 103 | Extracted copy confirmation, active copy, settings, provider application, and copy configuration assertions. | `[x]` |
| `flutter_app/test/features/trade/trade_risk_order_controller_test.dart` | new | 146 | Extracted futures, risk-management, order-history, and advanced-tool controller assertions. | `[x]` |
| `flutter_app/test/features/trade/trade_bot_controller_test.dart` | new | 93 | Extracted bot emergency, security, suitability, and bot action assertions. | `[x]` |

Checks:

- [x] Controller assertions reviewed and grouped by behavior surface.
- [x] All 8 original controller tests preserved.
- [x] No production Dart source edited.
- [x] All resulting Trade controller test files are below the test soft-review target.
- [x] `dart format` passed.
- [x] Focused original controller test passed.
- [x] Focused split controller tests passed.
- [x] Full Trade feature test suite passed.
- [x] `flutter analyze` passed.
- [x] Architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: line scan before EClean-23 - trade_controller_test.dart 476 lines.
2026-06-01: split - extracted copy/provider, futures/risk/order/advanced tools, and bot safety controller tests; original file now covers order, leverage, and margin controllers.
2026-06-01: dart format trade controller test files - formatted 4 files, 4 changed.
2026-06-01: flutter test test/features/trade/trade_controller_test.dart --reporter=compact - 3 tests passed.
2026-06-01: flutter test test/features/trade/trade_copy_controller_test.dart test/features/trade/trade_risk_order_controller_test.dart test/features/trade/trade_bot_controller_test.dart --reporter=compact - 5 tests passed.
2026-06-01: flutter test test/features/trade --reporter=compact - 343 tests passed.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact - 10 tests passed.
2026-06-01: inventory scan after EClean-23 - flutter_app/lib Dart files 1945; test Dart files 443; manifest rows 2388; production files over 600 lines 0; production files over 500 lines 61; test files over 600 lines 0; test files over 500 lines 0; test files over 400 lines 0.
```

Notes:

- Phase 5 is now complete: no test file remains over 400 lines.
- The split keeps high-risk Trade and copy-provider controller assertions
  readable while preserving the original repository fixture behavior.

### Phase 6 - Future Feature Onboarding Standard

Status: `[x]`

Goal: make every new feature follow the same enterprise shape from day one.

Required feature layout:

```text
flutter_app/lib/features/<feature>/
|-- domain/
|   |-- entities/
|   `-- repositories/
|-- data/
|   |-- fixtures/
|   |-- providers/
|   `-- repositories/
`-- presentation/
    |-- controllers/
    |-- pages/
    `-- widgets/
```

Required implementation order:

1. Define route path and route name.
2. Define domain entities and repository contract.
3. Add mock or fail-closed repository implementation.
4. Add Riverpod provider in `data/providers`.
5. Add app-level controller provider only if the app pattern requires it.
6. Add presentation controller for stateful flows.
7. Build page using shared layout primitives.
8. Extract page sections into widgets before the page exceeds `500` lines.
9. Add focused tests.
10. Add or update router contract tests when routes change.
11. Update the file-action manifest when adding new Dart files during cleanup.
12. Run guardrails.

Required shared primitives before local equivalents:

- `VitAppShell`
- `VitPageLayout`
- `VitPageContent`
- `VitHeader`
- `VitBottomNav`
- `VitCard`
- `VitCtaButton`
- `VitInput`
- `VitTabBar`
- `VitEmptyState`
- `VitErrorState`
- `VitOfflineBanner`

Definition of done for future features:

- Domain contracts exist before presentation code depends on data fixtures.
- Presentation pages and widgets do not import `features/*/data`.
- Controllers own stateful or high-risk flow decisions instead of pages.
- Pages stay below `500` lines by extracting focused widgets early.
- Tests stay below `400` lines by splitting by behavior group or product
  boundary.
- Financial, P2P, Prediction Markets, and Arena copy follows the product safety
  gates in Section 7.
- Router, architecture, and product-copy guardrails are run when affected.

### Batch EClean-24 - Future Feature Onboarding Standard Lock

Status: `[x]`
Owner/date: Codex / 2026-06-01

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-Clean-Codebase-Master-Plan.md` | existing | updated | Locked Phase 6 onboarding standard with ASCII layout, implementation order, and definition of done. | `[x]` |

Checks:

- [x] Required repo source-of-truth docs reviewed.
- [x] Future feature layout aligns with `AGENTS.md` and `docs/00_START_HERE.md`.
- [x] Feature implementation order includes route contracts and manifest updates.
- [x] Line-count and product-boundary expectations are explicit for future work.
- [x] Final full-app format audit passed.
- [x] Final full Flutter test suite passed.
- [x] Only format-only production Dart edits were made during the final format
  audit; no behavioral source change was required.
- [x] Latest `flutter analyze` passed.
- [x] Latest architecture baseline guardrail passed.

Verification log:

```text
2026-06-01: docs/00_START_HERE.md reviewed before locking the long-form Phase 6 standard.
2026-06-01: flutter pub get - dependencies resolved.
2026-06-01: dart format --output=none --set-exit-if-changed . - initially found four format-only files; formatted them and refreshed manifest line counts.
2026-06-01: dart format --output=none --set-exit-if-changed . - passed, 2390 files checked, 0 changed.
2026-06-01: flutter analyze - No issues found.
2026-06-01: flutter test --reporter=compact - full suite passed, 1872 tests passed.
2026-06-01: final inventory after EClean-24 - flutter_app/lib Dart files 1945; test Dart files 443; manifest rows 2388; production files over 600 lines 0; production files over 500 lines 61; test files over 600 lines 0; test files over 500 lines 0; test files over 400 lines 0.
```

Notes:

- The clean-codebase master plan is now complete through all planned phases.
- Future development should use this section as the gate before adding any new
  feature, route, high-risk flow, or large test surface.

## 7. Financial And Product Safety Gates

High-risk flows require preview and confirmation:

- Withdrawals.
- Escrow release.
- Security changes.
- 2FA disablement.
- Address additions.
- P2P payment-method changes.

Required copy boundaries:

- Arena is points-only. Do not use wallet, payout, profit, or stake-return copy.
- Prediction Markets can use positions, probability, receipt, rewards, and P/L.
- Avoid casino, hype, FOMO, and hidden-risk language.

Required verification for affected areas:

```bash
cd flutter_app
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
```

## 8. Batch Template

Copy this block for every cleanup batch.

````markdown
### Batch <ID> - <Area>

Status: `[ ]`
Owner/date:

Target files:

| File | Before | After | Action | Status |
| --- | ---: | ---: | --- | --- |
| `<path>` | `<lines>` | `<lines>` | `<split/keep/defer>` | `[ ]` |

New files:

- `<path>`

Checks:

- [ ] Class boundary scan completed.
- [ ] No new presentation imports from `features/*/data`.
- [ ] No new direct runtime `Colors.*`.
- [ ] Package imports used across modules.
- [ ] Focused feature tests passed.
- [ ] Product copy guardrail passed if financial/Arena/Prediction/P2P copy changed.
- [ ] Accessibility semantics guardrail passed if high-risk flow changed.
- [ ] Router tests passed if routes changed.
- [ ] `flutter analyze` passed.
- [ ] Architecture baseline guardrail passed.

Verification log:

```text
<date>: <command> - <result>
```

Notes:

- <exception/deferred reason>
````

## 9. Definition Of Done

A cleanup batch is complete only when:

- The target files are below preferred or documented soft-review thresholds.
- Public route, provider, and repository contracts remain stable.
- Tests cover the changed behavior.
- Financial copy and domain boundaries remain correct.
- `flutter analyze` passes.
- Architecture guardrails pass.
- This plan or the linked tracker records before/after counts and commands.

## 10. Next Recommended Batch

All planned clean-codebase phases are complete through EClean-24.

No open cleanup batch remains in this master plan. Future work should use the
Phase 6 onboarding standard before adding new features, routes, high-risk
flows, or large test surfaces.

Ongoing verification for future feature work:

```bash
cd flutter_app
dart format .
flutter analyze
flutter test test/app/router --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```
