# VitTrade A-Grade Body Component Upgrade Plan

Updated: 2026-06-05

Scope: plan to upgrade all standard routed screens from body grade B to body
grade A while keeping the existing enterprise UI/UX synchronization gate clean.

Current measured baseline:

```text
total_routed_screens=414
grade_A=105
grade_B=304
grade_C=0
grade_D=0
grade_Tool=5
priority_P0=0
priority_P1=0
```

Target measured baseline:

```text
total_routed_screens=414
grade_A=409
grade_B=0
grade_C=0
grade_D=0
grade_Tool=5
priority_P0=0
priority_P1=0
```

The five `Tool` screens are fullscreen-tool exceptions. Do not force them into
standard A grading unless the tool audit definition changes.

## Why B Is Not A

In `flutter_app/tool/body_component_consistency_audit.dart`, a standard screen is
A only when all of these are true:

1. No audited status is `warn`.
2. No audited status is `fail`.
3. `shared_component_count >= 5`.
4. `custom_body_count <= 35`.

A B screen is already acceptable for the current enterprise gate, but it misses
one or more A-only conditions. The common B cases are:

- one or two warnings remain, such as `surface_status=warn` or
  `layout_status=warn`;
- the screen has enough safety but too many local body tokens;
- the screen has clean behavior but not enough shared primitives;
- the screen is a complex chart/form/dashboard that still uses local `Container`,
  `Stack`, `Positioned`, fixed `SizedBox(height:)`, local `fontSize:`, or
  `BorderRadius.circular(...)` patterns.

Important: adding audit tokens without real UI improvement is not acceptable.
Every A upgrade must make the screen more consistent, safer, or easier to
maintain.

## Current B Inventory

Feature distribution:

| Feature | B | Low Shared | Custom >35 | Custom >=50 | Layout Warn | Surface Warn | State Warn | Financial Warn |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| trade | 81 | 2 | 56 | 33 | 20 | 67 | 2 | 0 |
| p2p | 74 | 1 | 8 | 4 | 67 | 13 | 24 | 2 |
| earn | 31 | 8 | 10 | 2 | 0 | 20 | 6 | 2 |
| wallet | 21 | 2 | 13 | 2 | 3 | 15 | 1 | 0 |
| markets | 20 | 7 | 5 | 0 | 2 | 14 | 10 | 0 |
| launchpad | 14 | 0 | 6 | 2 | 0 | 6 | 8 | 1 |
| predictions | 12 | 2 | 3 | 1 | 0 | 6 | 5 | 0 |
| arena | 12 | 1 | 8 | 1 | 0 | 6 | 0 | 0 |
| profile | 11 | 0 | 9 | 1 | 0 | 6 | 0 | 0 |
| dca | 9 | 1 | 3 | 1 | 0 | 5 | 4 | 1 |
| auth | 6 | 0 | 1 | 0 | 1 | 5 | 0 | 0 |
| referral | 5 | 0 | 1 | 1 | 3 | 3 | 0 | 0 |
| discovery | 3 | 0 | 0 | 0 | 3 | 0 | 0 | 0 |
| admin | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| cross_module | 1 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| dev | 1 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
| home | 1 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
| support | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |

Primary issue distribution:

| Primary issue | B rows |
| --- | ---: |
| surface_consistency_needs_review | 142 |
| partial_shared_body_layout | 97 |
| none | 36 |
| state_coverage_needs_review | 23 |
| financial_safety_needs_manual_review | 6 |

Warning distribution:

| Warning pattern | B rows |
| --- | ---: |
| surface_status | 131 |
| layout_status | 45 |
| no warning, but low shared or high custom | 33 |
| layout_status + surface_status | 29 |
| state_status | 23 |
| layout_status + state_status | 23 |
| surface_status + state_status | 11 |
| state_status + financial_safety_status | 3 |
| controls_status | 3 |
| layout_status + financial_safety_status | 2 |
| financial_safety_status | 1 |

## Source Of Truth And Queue Commands

Always regenerate the audit before selecting work:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
```

List every current B row:

```powershell
Import-Csv ..\docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Where-Object { $_.body_grade -eq 'B' } |
  Sort-Object feature,primary_issue,page |
  Format-Table feature,page,shared_component_count,custom_body_count,layout_status,surface_status,controls_status,state_status,financial_safety_status,primary_issue -AutoSize
```

List the next highest-impact B rows:

```powershell
Import-Csv ..\docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Where-Object { $_.body_grade -eq 'B' } |
  Sort-Object @{Expression={[int]$_.custom_body_count}; Descending=$true},feature,page |
  Select-Object -First 25 feature,page,shared_component_count,custom_body_count,layout_status,surface_status,state_status,financial_safety_status,primary_issue |
  Format-Table -AutoSize
```

Track completion after every batch:

```powershell
Import-Csv ..\docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Group-Object body_grade |
  Sort-Object Name |
  Format-Table Name,Count -AutoSize
```

## A-Upgrade Work Rules

1. Keep C and D at zero after every batch.
2. Keep header strict clean after major route or header-adjacent work.
3. Do not change product semantics to satisfy body grade.
4. Do not collapse Prediction Markets and Open Arena boundaries.
5. Do not use wallet, payout, profit, or stake-return language in Arena.
6. Do not remove financial safety preview/confirm semantics.
7. Prefer existing shared primitives before local abstractions:
   `VitPageLayout`, `VitAutoHideHeaderScaffold`, `VitPageContent`,
   `VitPageSection`, `VitCard`, `VitMetricCard`, `VitServiceTile`,
   `VitCtaButton`, `VitInput`, `VitSearchBar`, `VitTabBar`, `VitStatusPill`,
   `VitHighRiskStatePanel`, `VitEmptyState`, `VitErrorState`,
   `VitOfflineBanner`, and `VitSkeleton`.
8. Reduce real custom body complexity. The audit counts these custom-risk
   tokens:
   `Container(`, `GestureDetector(`, `TextField(`, `CustomPaint(`,
   `Positioned(`, `Stack(`, `SizedBox(height:`, `fontSize:`, `fontFamily:`,
   and `BorderRadius.circular(`.
9. Avoid moving important controls below the first viewport unless tests and UX
   require it. Put audit/support panels near the end of scroll content when the
   screen has primary controls.
10. Batch size should be small enough to isolate regressions:
    - high-risk financial or complex form pages: 1 to 3 screens;
    - normal pages sharing parts/widgets: 4 to 8 screens;
    - simple surface-only pages: up to 10 screens.

## Upgrade Patterns

### Pattern A1: Layout Warning To Pass

Use when `layout_status=warn`.

Implementation:

1. Import `package:vit_trade_flutter/shared/layout/vit_page_content.dart`.
2. Keep existing `VitPageLayout` and `VitAutoHideHeaderScaffold`.
3. Wrap scroll body content with:

```dart
VitPageContent(
  padding: VitContentPadding.none,
  fullBleed: true,
  customGap: 0,
  children: [
    // existing content
  ],
)
```

4. Wrap repeated or tab-driven content areas with `VitPageSection`.
5. Verify the page still respects bottom chrome and safe-area padding.

Expected audit improvement:

- `layout_status` becomes `pass`.
- `shared_component_count` usually increases.

### Pattern A2: Surface Warning To Pass

Use when `surface_status=warn`.

Implementation:

1. Replace local card-like `Container`, `DecoratedBox`, and repeated local panels
   with `VitCard`, `VitCardStat`, `VitMetricCard`, or `VitServiceTile`.
2. Prefer `borderColor`, `variant`, `radius`, and `padding` on shared cards over
   local `BoxDecoration`.
3. Keep chart canvases only where drawing is genuinely needed; wrap charts in
   `VitCard`.
4. Replace local status chips with `VitStatusPill`.

Expected audit improvement:

- `surface_status` becomes `pass`.
- `custom_body_count` usually drops.

### Pattern A3: State Warning To Pass

Use when `state_status=warn`.

Implementation:

1. Use real state surfaces, not decorative labels:
   `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`, `VitSkeleton`, or
   `VitHighRiskStatePanel`.
2. For high-risk financial pages, use `VitHighRiskStatePanel` with a clear
   `contractId`.
3. Avoid `VitHighRiskUiState.submitting` in static review panels because it can
   create indefinite animations in tests.
4. Confirm loading, empty, error, offline, submitting, success, and result states
   are represented where the flow needs them.

Expected audit improvement:

- `state_status` becomes `pass`.
- high-risk pages often also improve `financial_safety_status`.

### Pattern A4: Financial Warning To Pass

Use when `financial_safety_status=warn`.

Implementation:

1. Confirm the flow has preview and confirmation before high-risk action.
2. Show fee/risk/limit/escrow/network impacts before confirmation.
3. Mask sensitive data where applicable.
4. Show result/receipt and next-step semantics after completion.
5. Add or integrate `VitHighRiskStatePanel` only where it represents the real
   safety contract.

Expected audit improvement:

- `financial_safety_status` becomes `pass`.

### Pattern A5: Controls Warning To Pass

Use when `controls_status=warn`.

Implementation:

1. Replace raw `TextField` with `VitInput` or `VitSearchBar`.
2. Replace repeated raw buttons with `VitCtaButton`, `VitIconButton`, or header
   action primitives.
3. Replace `GestureDetector` interactions with `InkWell` inside shared surfaces
   unless gesture-only behavior is required.
4. Keep accessible labels and stable keys.

Expected audit improvement:

- `controls_status` becomes `pass`.

### Pattern A6: Custom Body Count To <=35

Use when all statuses are pass but the page remains B because
`custom_body_count > 35`.

Implementation:

1. Replace repeated local panels with shared component calls.
2. Replace repeated manual spacing with `VitPageContent` and
   `VitPageSection` gaps where possible.
3. Replace local text overrides such as `fontSize:` with a closer
   `AppTextStyles` token.
4. Replace `BorderRadius.circular(...)` with `AppRadii`.
5. Remove unnecessary `Stack` and `Positioned` patterns when a `Column`, `Row`,
   `LayoutBuilder`, or shared footer works.
6. Move repeated subtrees into feature widgets only when it reduces custom-risk
   tokens in the page and improves maintainability.
7. Re-run audit after each file or small group because this threshold is
   sensitive.

Expected audit improvement:

- `custom_body_count <= 35`.
- If warnings are already zero and shared count is at least 5, grade becomes A.

### Pattern A7: Shared Component Count To >=5

Use when all statuses are pass but `shared_component_count < 5`.

Implementation:

1. Add real shared layout or widgets that improve consistency.
2. Preferred additions:
   `VitPageContent`, `VitPageSection`, `VitCard`, `VitStatusPill`,
   `VitEmptyState`, `VitCtaButton`, `VitSearchBar`, `VitInput`.
3. Do not add hidden or redundant widgets just to increase the count.

Expected audit improvement:

- `shared_component_count >= 5`.
- If warnings are zero and custom count is <=35, grade becomes A.

## Execution Phases

### Phase 0: Guardrail Setup

Status: pending

Goal: make every batch measurable and repeatable.

Checklist:

- [ ] Regenerate body audit.
- [ ] Confirm `C=0` and `D=0`.
- [ ] Export current B queue from CSV.
- [ ] Pick one feature and one dominant issue group only.
- [ ] Identify page files, part files, feature widgets, and focused tests.
- [ ] Record baseline counts for the selected feature.

Do not start code edits if the current audit has C or D rows. Fix those first.

### Phase 1: Remove All Warnings

Status: pending

Goal: make every B row have zero status warnings. A requires `warnCount=0`.

Recommended order:

1. `financial_safety_status=warn`
2. `controls_status=warn`
3. `state_status=warn`
4. `layout_status=warn`
5. `surface_status=warn`

Why this order:

- financial and controls warnings are behavioral risk;
- state warnings affect reliability and QA;
- layout warnings can be fixed in batches;
- surface warnings are numerous and can be batched last.

Feature priorities:

| Order | Feature | Reason |
| ---: | --- | --- |
| 1 | p2p | 74 B, 67 layout warnings, high-risk financial flows |
| 2 | trade | 81 B, 67 surface warnings, 56 high-custom rows |
| 3 | wallet | high-risk money surfaces, 15 surface warnings |
| 4 | earn | financial copy/state safety, 20 surface warnings |
| 5 | markets | 10 state warnings and shared-count gaps |
| 6 | launchpad | 8 state warnings, high-risk launch actions |
| 7 | predictions | value-based financial boundary and state warnings |
| 8 | profile/auth/dca | security and account-management surfaces |
| 9 | arena | preserve points-only boundary while polishing surfaces |
| 10 | remaining small features | referral, discovery, admin, support, home, dev |

Exit criteria:

- [ ] No B row has any `*_status=warn`.
- [ ] Body audit remains `C=0`, `D=0`.
- [ ] Focused tests pass for every touched feature.

### Phase 2: Reduce High Custom Body Count

Status: pending

Goal: bring every standard screen to `custom_body_count <= 35`.

Current scope:

```text
custom_body_count > 35: 124 B rows
custom_body_count >= 50: 48 B rows
```

Recommended order:

1. Very high custom rows: `custom_body_count >= 50`.
2. High-risk money/security rows with `custom_body_count > 35`.
3. Dashboard/chart rows with repeated local panels.
4. Remaining rows from 36 to 49.

Feature priorities:

| Order | Feature | High custom | Very high custom | Main strategy |
| ---: | --- | ---: | ---: | --- |
| 1 | trade | 56 | 33 | extract repeated bot/copy/regulatory surfaces, replace local panels |
| 2 | wallet | 13 | 2 | normalize asset, transfer, approval, and analytics surfaces |
| 3 | earn | 10 | 2 | consolidate savings/staking cards and assessment sections |
| 4 | profile | 9 | 1 | reduce account/security local cards |
| 5 | arena | 8 | 1 | keep points-only copy, reduce local studio/rule builder bodies |
| 6 | p2p | 8 | 4 | finish insurance/ad analytics/custom dashboards |
| 7 | launchpad | 6 | 2 | reduce launch controls and analytics panels |
| 8 | markets | 5 | 0 | standardize watchlist/search/state surfaces |
| 9 | predictions | 3 | 1 | reduce event detail and market-maker custom panels |
| 10 | dca | 3 | 1 | normalize optimizer/rebalance body widgets |

Exit criteria:

- [ ] No standard screen has `custom_body_count > 35`.
- [ ] No C/D regressions.
- [ ] Full `flutter analyze` passes after every 20 to 30 pages.

### Phase 3: Raise Low Shared Count

Status: pending

Goal: bring every standard screen to `shared_component_count >= 5`.

Current scope:

```text
shared_component_count < 5: 26 B rows
```

Recommended fixes:

- add real `VitPageContent` and `VitPageSection`;
- replace local panel with `VitCard`;
- replace local chip/status with `VitStatusPill`;
- replace local CTA/input/search with shared controls;
- add real state surface where the page needs one.

Exit criteria:

- [ ] No standard screen has `shared_component_count < 5`.
- [ ] No page gained meaningless shared primitives.

### Phase 4: Feature-Level A Sweeps

Status: pending

Goal: convert whole features to A and lock them with focused tests.

Execution tracker:

| Feature | Current B | Status | Focused test scope |
| --- | ---: | --- | --- |
| p2p | 74 | pending | `flutter test test/features/p2p --reporter=compact` |
| trade | 81 | pending | `flutter test test/features/trade --reporter=compact` |
| wallet | 21 | pending | `flutter test test/features/wallet --reporter=compact` |
| earn | 31 | pending | `flutter test test/features/earn --reporter=compact` |
| markets | 20 | pending | `flutter test test/features/markets --reporter=compact` |
| launchpad | 14 | pending | `flutter test test/features/launchpad --reporter=compact` |
| predictions | 12 | pending | `flutter test test/features/predictions --reporter=compact` |
| arena | 12 | pending | `flutter test test/features/arena --reporter=compact` |
| profile | 11 | pending | `flutter test test/features/profile --reporter=compact` |
| dca | 9 | pending | `flutter test test/features/dca --reporter=compact` |
| auth | 6 | pending | `flutter test test/features/auth --reporter=compact` |
| referral | 5 | pending | focused referral tests or router smoke |
| discovery | 3 | pending | focused discovery tests or router smoke |
| admin | 1 | pending | `flutter test test/features/admin --reporter=compact` |
| cross_module | 1 | pending | focused route/widget smoke |
| dev | 1 | pending | focused route/widget smoke |
| home | 1 | pending | home/widget smoke |
| support | 1 | pending | focused support smoke |

Feature is complete only when:

- [ ] all rows for the feature are grade A or documented Tool;
- [ ] focused tests pass;
- [ ] body audit remains C/D free.

### Phase 5: Final All-A Gate

Status: pending

Run from `flutter_app/`:

```powershell
dart run tool\body_component_consistency_audit.dart --check
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\top_header_action_audit.dart
dart run tool\top_header_global_access_policy_audit.dart
dart run tool\back_navigation_behavior_audit.dart
dart run tool\home_entry_back_navigation_audit.dart
dart run tool\route_coverage_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Final acceptance:

- [ ] body audit: `grade_A=409`, `grade_B=0`, `grade_C=0`, `grade_D=0`,
  `grade_Tool=5`;
- [ ] header strict: `strict_visual_issues=0`,
  `screen_level_mismatches=0`;
- [ ] top-header action audit has no legacy/custom action usage;
- [ ] global access policy has `policy_violations=0`;
- [ ] back-navigation strict issues are zero;
- [ ] route coverage artifact is current;
- [ ] `flutter analyze` passes;
- [ ] full `flutter test --reporter=compact` passes.

## Batch Checklist Template

Use this template for every batch.

```text
Batch ID:
Feature:
Pages:
Primary audit issue:
Baseline:
  shared_component_count:
  custom_body_count:
  warnings:
Target:
  body_grade=A
  shared_component_count>=5
  custom_body_count<=35
  all statuses pass/not_applicable

Inspection:
[ ] page files read
[ ] part files read
[ ] direct feature widgets read
[ ] focused tests read
[ ] shared primitive APIs checked

Implementation:
[ ] layout warning fixed with VitPageContent/VitPageSection
[ ] surface warning fixed with VitCard/VitMetricCard/VitServiceTile
[ ] controls warning fixed with shared controls
[ ] state warning fixed with shared state surfaces
[ ] financial warning fixed with preview/confirm/fee/risk/limit/result semantics
[ ] custom body tokens reduced
[ ] shared component count raised by real UI improvements
[ ] no copy boundary regression
[ ] no high-risk safety regression

Verification:
[ ] dart format touched files
[ ] dart run tool\body_component_consistency_audit.dart
[ ] selected pages now A
[ ] C/D remain zero
[ ] focused tests pass
[ ] flutter analyze pass if batch touched shared/router/high-risk flow

Notes:
```

## Detailed Feature Guidance

### Trade

Current B: 81.

Dominant blockers:

- surface warnings: 67;
- high custom rows: 56;
- very high custom rows: 33.

Recommended strategy:

1. Start with high-custom bot, copy trading, regulatory, reporting, and risk
   dashboard pages.
2. Replace local dashboard cards with `VitMetricCard`, `VitCard`, and
   `VitStatusPill`.
3. Extract repeated rows/tables into feature widgets only when it reduces page
   custom-risk tokens.
4. Keep financial-safety review panels and confirmation semantics intact.
5. Run focused trade tests after every 5 to 8 screens.

### P2P

Current B: 74.

Dominant blockers:

- layout warnings: 67;
- state warnings: 24;
- surface warnings: 13.

Recommended strategy:

1. Do a layout sweep first: add `VitPageContent` and `VitPageSection` to pages
   that already use `VitPageLayout`.
2. Add real state surfaces only where state warnings remain.
3. Keep escrow, dispute, payment-method, KYC, and device-management safety
   semantics visible.
4. Run the full P2P focused suite frequently because many flows are connected.

### Earn

Current B: 31.

Dominant blockers:

- surface warnings: 20;
- low shared count: 8;
- state warnings: 6;
- financial warnings: 2.

Recommended strategy:

1. Normalize savings and staking cards with `VitCard`.
2. Replace assessment local result panels with shared state/status components.
3. Ensure redeem/withdraw/staking risk flows keep preview, confirmation, and
   result semantics.

### Wallet

Current B: 21.

Dominant blockers:

- surface warnings: 15;
- high custom rows: 13.

Recommended strategy:

1. Prioritize address, transfer, token approval, deposit, transaction, and
   analytics pages.
2. Reduce local money panels with shared wallet cards and `VitStatusPill`.
3. Preserve masking, fee/risk/network/limit preview, and receipt states.

### Markets

Current B: 20.

Dominant blockers:

- surface warnings: 14;
- state warnings: 10;
- low shared count: 7.

Recommended strategy:

1. Standardize watchlist/search/market-list controls.
2. Add empty/offline/error states where market data can be unavailable.
3. Keep price/movement styling tokenized and readable in dark theme.

### Launchpad

Current B: 14.

Dominant blockers:

- state warnings: 8;
- surface warnings: 6;
- financial warning: 1.

Recommended strategy:

1. Add state coverage for gas, notification, rebalance, and order flows.
2. Keep subscription/swap/limit-order confirmation semantics.
3. Avoid top-of-scroll panels that push primary CTAs out of test reach.

### Predictions

Current B: 12.

Dominant blockers:

- surface warnings: 6;
- state warnings: 5.

Recommended strategy:

1. Standardize event detail, search, market-maker, and trade panels.
2. Keep Prediction copy value-based: probability, position, receipt, reward,
   P/L.
3. Avoid casino/FOMO language.

### Arena

Current B: 12.

Dominant blockers:

- high custom rows: 8;
- surface warnings: 6.

Recommended strategy:

1. Reduce local studio/rule-builder custom bodies.
2. Keep Arena copy points-only.
3. Do not introduce wallet, payout, profit, stake-return, or P/L copy.

### Profile/Auth/DCA

Current B:

- profile: 11;
- auth: 6;
- dca: 9.

Recommended strategy:

1. Profile: normalize security/account/API/sub-account cards.
2. Auth: preserve 2FA/security setup semantics while replacing local surfaces.
3. DCA: normalize optimizer/rebalance controls and state panels.

### Small Features

Current B:

- referral: 5;
- discovery: 3;
- admin: 1;
- cross_module: 1;
- dev: 1;
- home: 1;
- support: 1.

Recommended strategy:

1. Fix these after high-impact features unless they share a touched widget.
2. Most should be quick A conversions by addressing layout or surface warnings.

## Risk Controls

Known risks when upgrading B to A:

1. Pushing primary controls below the visible test viewport.
2. Adding indeterminate loading indicators that make `pumpAndSettle` hang.
3. Increasing custom body count while adding review panels.
4. Creating visual density by wrapping too many cards inside cards.
5. Breaking financial safety semantics by simplifying confirmation steps.
6. Introducing Arena/Prediction copy boundary violations.

Mitigations:

- place supplemental review panels near the end of scroll content;
- avoid `VitHighRiskUiState.submitting` unless the screen is truly submitting;
- audit after each small batch;
- use shared primitives to replace local UI, not only add new shared UI;
- run focused tests before moving to the next feature.

## Recommended First Three Batches

### Batch A-01: P2P Layout Sweep

Reason: P2P has 67 layout warnings and only 8 high-custom rows. Many screens can
move to A by adding real `VitPageContent`/`VitPageSection` and reducing minor
surface/state warnings.

Batch size: 6 to 8 pages.

Acceptance:

- selected P2P pages become A;
- P2P focused tests pass;
- body audit remains C/D free.

### Batch A-02: Trade Surface Sweep

Reason: Trade has 67 surface warnings and 56 high-custom rows. This is the
largest long-tail risk.

Batch size: 3 to 6 pages, grouped by page families:

- bot dashboards;
- copy trading;
- regulatory/reporting;
- risk/compliance tools.

Acceptance:

- local dashboard surfaces converted to shared cards/metrics;
- selected pages become A or move to a clear custom-count-only queue;
- focused trade tests pass.

### Batch A-03: Wallet/Earn Financial Surface Sweep

Reason: Wallet and Earn are high-risk money flows with surface/custom pressure.

Batch size: 4 to 6 pages.

Acceptance:

- preview/confirm/result semantics preserved;
- masking and fee/risk/limit visibility preserved;
- selected pages become A.

## Completion Notes

All-A is a stricter polish target than the current enterprise gate. It is useful
for long-term design-system maturity, but it should be executed incrementally.
Do not convert 304 B rows in one broad pass. The correct workflow is:

1. current CSV;
2. small coherent batch;
3. real shared UI improvement;
4. audit;
5. focused tests;
6. repeat.
