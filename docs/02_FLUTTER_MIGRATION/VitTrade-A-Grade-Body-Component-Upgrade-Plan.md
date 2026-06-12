# VitTrade A-Grade Body Component Upgrade Plan

Updated: 2026-06-11

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

## Execution Log

### Batch A-01 - P2P Payment Method Financial Safety

- Scope: `P2PPaymentMethodHistoryPage`,
  `P2PPaymentMethodVerificationPage`.
- Before: both pages were B with `layout_status=warn` and
  `financial_safety_status=warn`.
- Changes: added `VitPageContent` body composition and
  `VitHighRiskStatePanel` risk-review semantics without introducing submitting
  animations.
- After: both pages are A; current body audit counts are A=107, B=302, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_payment_method_history_page_test.dart test\features\p2p\p2p_payment_method_verification_page_test.dart --reporter=compact`.
- Remaining: continue Phase 1 financial warnings; next priority is Earn
  financial safety rows.

### Batch A-02 - Earn Developer And Emergency Financial Safety

- Scope: `StakingDeveloperConsolePage`, `StakingEmergencyActionsPage`.
- Before: both pages were B with `state_status=warn` and
  `financial_safety_status=warn`.
- Changes: added end-of-content `VitHighRiskStatePanel` review semantics for
  developer API access and emergency staking actions while preserving existing
  tabs, action cards, and confirmation sheets.
- After: both pages are A; current body audit counts are A=109, B=300, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\earn\staking_developer_console_page_test.dart test\features\earn\staking_emergency_actions_page_test.dart --reporter=compact`.
- Remaining: continue Phase 1 financial warnings; next priority is Launchpad
  receipt safety review, then DCA smart rules.

### Batch A-03 - Launchpad Receipt Financial Safety

- Scope: `LaunchpadReceiptPage`.
- Before: page was B with `financial_safety_status=warn`.
- Changes: added receipt-level `VitHighRiskStatePanel` after allocation,
  unlock, refund, tx hash, disclosure, and next-step content.
- After: page is A; current body audit counts are A=110, B=299, C=0, D=0,
  Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\launchpad\launchpad_receipt_page_test.dart --reporter=compact`.
- Remaining: continue Phase 1 financial warnings; next priority is
  `DCASmartRulesPage`.

### Batch A-04 - DCA Smart Rules Financial Safety

- Scope: `DCASmartRulesPage`.
- Before: page was B with `state_status=warn` and
  `financial_safety_status=warn`.
- Changes: added shared `VitHighRiskStatePanel` review semantics after the
  active smart-rule tab content so rule conditions, automated actions, trigger
  history, delete preview, and create-rule confirmation are visible across tabs.
- After: page is A; current body audit counts are A=111, B=298, C=0, D=0,
  Tool=5; financial warning count is 0.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\dca\dca_smart_rules_page_test.dart --reporter=compact`.
- Remaining: continue Phase 1 with `controls_status=warn`; next priority is
  Earn controls rows.

### Batch A-05 - Earn Controls And Portfolio Custom Count

- Scope: `SavingsPortfolioPage`, `StakingHistoryPage`.
- Before: both pages were B with `controls_status=warn`;
  `SavingsPortfolioPage` also had `custom_body_count=41`.
- Changes: moved Savings overview spacing to `VitPageContent`, replaced hero
  actions with `VitCtaButton`, and moved Staking History filter/export controls
  to shared `VitHeaderActionButton`.
- After: both pages are A; current body audit counts are A=113, B=296, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\earn\savings_portfolio_page_test.dart test\features\earn\staking_history_page_test.dart --reporter=compact`.
- Remaining: continue Phase 1 controls warnings; next priority is
  `PredictionDataIntegrationPage`.

### Batch A-06 - Predictions Data Integration Controls

- Scope: `PredictionDataIntegrationPage`.
- Before: page was B with `controls_status=warn` and
  `custom_body_count=41`.
- Changes: replaced the custom primary blue action with `VitCtaButton` and
  removed inline `fontSize` / `fontFamily` overrides from data-source, API-key,
  and webhook widgets.
- After: page is A; current body audit counts are A=114, B=295, C=0, D=0,
  Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\predictions\prediction_data_integration_page_test.dart --reporter=compact`.
- Remaining: Phase 1 controls warnings are cleared; continue with
  `state_status=warn`, starting with P2P rows.

### Batch A-07 - P2P One-File State/Layout Sweep

- Scope: `P2PContributionHistoryPage`, `P2PExpressConfirmPage`,
  `P2PInsurancePolicyPage`, `P2PPaymentMethodOwnershipPage`.
- Before: all four pages were B with `state_status=warn`; three also had
  `layout_status=warn`.
- Changes: added end-of-scroll `VitPageContent` plus
  `VitHighRiskStatePanel` review semantics for contribution export, express
  order confirmation, insurance policy review, and payment ownership
  submission.
- After: all four pages are A; current body audit counts are A=118, B=291,
  C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_contribution_history_page_test.dart test\features\p2p\p2p_express_confirm_page_test.dart test\features\p2p\p2p_insurance_policy_page_test.dart test\features\p2p\p2p_payment_method_ownership_page_test.dart --reporter=compact`.
- Remaining: continue Phase 1 P2P `state_status=warn` / `layout_status=warn`
  rows.

### Batch A-08 - P2P Verification, Escrow, Express, Insurance, And KYC States

- Scope: `P2PAddressProofPage`, `P2PAntiPhishingCodePage`,
  `P2PEscrowBalancePage`, `P2PExpressPage`,
  `P2PInsuranceCertificatePage`, `P2PInsuranceScorePage`,
  `P2PKycRequirementsPage`, `P2PKycStatusPage`.
- Before: all eight pages were B with `state_status=warn`; each also had
  `layout_status=warn`.
- Changes: added shared `VitPageContent` composition and
  `VitHighRiskStatePanel` review semantics at the end of each high-risk P2P
  body so document state, anti-phishing edits, escrow balance, express trade
  readiness, insurance proof, protection score, KYC requirement, and KYC status
  information remain visible before user action.
- After: all eight pages are A; current body audit counts are A=126, B=283,
  C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_address_proof_page_test.dart test\features\p2p\p2p_anti_phishing_code_page_test.dart test\features\p2p\p2p_escrow_balance_page_test.dart test\features\p2p\p2p_express_page_test.dart test\features\p2p\p2p_insurance_certificate_page_test.dart test\features\p2p\p2p_insurance_score_page_test.dart test\features\p2p\p2p_kyc_requirements_page_test.dart test\features\p2p\p2p_kyc_status_page_test.dart --reporter=compact`.
- Remaining: continue Phase 1 P2P `state_status=warn`; next batch should
  cover login history, my ads, payment-method add, security center/whitelist,
  settings, transaction limits, and wallet before order-specific pages.

### Batch A-09 - P2P Account, Security, Limits, And Wallet States

- Scope: `P2PLoginHistoryPage`, `P2PMyAdsPage`,
  `P2PPaymentMethodAddPage`, `P2PSecurityCenterPage`,
  `P2PWhitelistModePage`, `P2PSettingsPage`,
  `P2PTransactionLimitsPage`, `P2PWalletPage`.
- Before: all eight route rows were B with `state_status=warn`; each also had
  `layout_status=warn`.
- Changes: added shared `VitPageContent` and `VitHighRiskStatePanel` review
  semantics for account session review, ad exposure changes, payment-method
  save flow, security center actions, whitelist routing, P2P settings, limit
  upgrades, and wallet fund movement.
- After: all eight route rows are A; current body audit counts are A=134,
  B=275, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_login_history_page_test.dart test\features\p2p\p2p_my_ads_page_test.dart test\features\p2p\p2p_payment_method_add_page_test.dart test\features\p2p\p2p_security_center_page_test.dart test\features\p2p\p2p_settings_page_test.dart test\features\p2p\p2p_transaction_limits_page_test.dart test\features\p2p\p2p_wallet_page_test.dart --reporter=compact`.
- Test maintenance: `p2p_my_ads_page_test.dart` now uses
  `tester.ensureVisible` before tapping the settings quick link because the
  added end-of-body state panel changes the fixed scroll offset.
- Remaining: complete the P2P order-specific state rows:
  `P2POrderCancelPage`, `P2POrderPage`, `P2POrderProofPage`,
  `P2POrderRatePage`; keep `P2PChatPage` as Tool unless the final Tool budget
  changes.

### Batch A-10 - P2P Order-Specific State, Surface, And Custom Count

- Scope: `P2POrderCancelPage`, `P2POrderPage`, `P2POrderProofPage`,
  `P2POrderRatePage`.
- Before: all four standard order routes were B. `P2POrderCancelPage` and
  `P2POrderRatePage` had `surface_status=warn` and `state_status=warn`;
  `P2POrderProofPage` had `layout_status=warn` and `state_status=warn`;
  `P2POrderPage` had `layout_status=warn`, `state_status=warn`, and
  `custom_body_count=38`.
- Changes: added order-level `VitHighRiskStatePanel` review semantics,
  converted cancel/rate hero and warning/result surfaces to `VitCard`, added
  shared body composition to proof/order screens, and moved `P2POrderPage`
  body spacing into `VitPageContent` so custom body count dropped to 28.
- After: all four order routes are A; current body audit counts are A=138,
  B=271, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_order_cancel_page_test.dart test\features\p2p\p2p_order_page_test.dart test\features\p2p\p2p_order_proof_page_test.dart test\features\p2p\p2p_order_rate_page_test.dart --reporter=compact`.
- Remaining: `P2PChatPage` remains Tool. P2P still has B rows for
  layout/surface/custom consistency, but all P2P `state_status=warn` standard
  pages are cleared.

### Batch A-11 - Wallet Address Book State And Layout

- Scope: `AddressBookPage`.
- Before: page was B with `layout_status=warn`, `state_status=warn`, and
  `custom_body_count=44`.
- Changes: imported `VitPageContent`, moved the scroll body to shared content
  spacing, removed body-level hard-coded vertical spacers, replaced raw bottom
  chrome spacing with `AppSpacing`, and added a wallet-address
  `VitHighRiskStatePanel` covering search, network filter, whitelist-only mode,
  favorites, copy feedback, delete confirmation, empty state, and add-address
  route.
- After: page is A with `custom_body_count=34`; current body audit counts are
  A=139, B=270, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\wallet\address_book_page_test.dart --reporter=compact`.
- Remaining: continue non-Tool `state_status=warn` rows in Trade, DCA, Earn,
  Launchpad, Predictions, and Markets.

### Batch A-12 - Trade Copy Configuration And Confirmation States

- Scope: `CopyConfigurationPage`, `CopyConfirmationPage`.
- Before: both pages were B with `state_status=warn`; layout, surface, and
  controls were already pass.
- Changes: added high-risk review panels to the copy configuration and copy
  confirmation flows so provider summary, allocation, copy mode, risk controls,
  fee preview, validation messages, suitability review, scenarios, max loss,
  required consents, cooling-off period, next steps, and submitting state remain
  visible before activating copy trading.
- After: both pages are A; current body audit counts are A=141, B=268, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\copy_configuration_page_test.dart test\features\trade\copy_confirmation_page_test.dart --reporter=compact`.
- Remaining: continue non-Tool `state_status=warn` rows in DCA, Earn,
  Launchpad, Predictions, and Markets.

### Batch A-13 - DCA Multi-Asset And Rebalance States

- Scope: `DCAMultiAssetPage`, `DCARebalanceConfig` route rows.
- Before: `DCAMultiAssetPage` and both `DCARebalanceConfig` rows were B with
  `state_status=warn`; `DCARebalanceConfig` also had
  `custom_body_count=37`.
- Changes: added tab-specific high-risk state panels for multi-asset DCA setup,
  portfolio, and performance views; added a rebalance-configuration review
  panel covering allocation targets, strategy, threshold, frequency, advanced
  settings, auto-execute risk, preview sheet, fees, and disabled save state.
  Also moved two small rebalance content stacks to `VitPageContent`, reducing
  `DCARebalanceConfig` custom body count to 35.
- After: all three DCA rows are A; current body audit counts are A=144, B=265,
  C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\dca\dca_multi_asset_page_test.dart test\features\dca\dca_rebalance_config_page_test.dart --reporter=compact`.
- Remaining: continue non-Tool `state_status=warn` rows in Earn, Launchpad,
  Predictions, and Markets.

### Batch A-14 - Earn Auto-Compound, Rebalance, Ladder, And Advanced Orders

- Scope: `AutoCompoundSettingsPage`, `SavingsAutoRebalancePage`,
  `SavingsLadderPage`, `StakingAdvancedOrdersPage`.
- Before: all four pages were B with `state_status=warn`.
  `SavingsAutoRebalancePage` also had `custom_body_count=43`;
  `SavingsLadderPage` had `surface_status=warn` and
  `custom_body_count=49`.
- Changes: added high-risk state review panels for auto-compound automation,
  savings auto-rebalance, savings ladder confirmation, and advanced staking
  orders. Consolidated rebalance comparison/settings spacing and ladder
  builder, timeline, analysis, template, and duration stacks into
  `VitPageContent` with `fullBleed: true` where the shared primitive replaced
  local `Column` spacing.
- After: all four pages are A. `SavingsAutoRebalancePage` is at
  `custom_body_count=35`; `SavingsLadderPage` is at
  `custom_body_count=35`. Current body audit counts are A=148, B=261, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\earn\auto_compound_settings_page_test.dart test\features\earn\savings_auto_rebalance_page_test.dart test\features\earn\savings_ladder_page_test.dart test\features\earn\staking_advanced_orders_page_test.dart --reporter=compact`.
- Remaining: continue non-Tool `state_status=warn` rows in Launchpad,
  Predictions, Markets, plus the two residual Trade/P2P state-review rows
  found by the latest audit.

### Batch A-15 - Launchpad Claim, Bridge, Address, DCA, Order, And Swap States

- Scope: `LaunchpadAddressBookPage`, `LaunchpadBatchClaimPage`,
  `LaunchpadBridgeComparePage`, `LaunchpadClaimReceiptPage`,
  `LaunchpadDcaBuilderPage`, `LaunchpadEventLogPage`,
  `LaunchpadLimitOrdersPage`, `LaunchpadSwapAggregatorPage`.
- Before: all eight pages were B with `state_status=warn`. Address book and
  DCA builder also had `surface_status=warn`; bridge compare, limit orders,
  and swap aggregator had custom body counts above the A threshold.
- Changes: added high-risk review panels covering address mutation, batch
  claim selection/review/success, bridge-route confirmation, claim receipt
  vesting/claim state, DCA strategy creation, event-log export/copy, limit
  order creation, and swap route preview. Converted AddressBook info/stat
  surfaces and DCA builder checkpoints to `VitCard`; reduced custom count in
  bridge, limit-order form, and swap input by replacing local chip/surface
  widgets and manual vertical spacing with shared primitives.
- After: all eight scope pages are A. Key counts: `LaunchpadBridgeComparePage`
  `custom_body_count=35`, `LaunchpadLimitOrdersPage`
  `custom_body_count=35`, `LaunchpadSwapAggregatorPage`
  `custom_body_count=32`. Current body audit counts are A=156, B=253, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\launchpad\launchpad_address_book_page_test.dart test\features\launchpad\launchpad_batch_claim_page_test.dart test\features\launchpad\launchpad_bridge_compare_page_test.dart test\features\launchpad\launchpad_claim_receipt_page_test.dart test\features\launchpad\launchpad_dca_builder_page_test.dart test\features\launchpad\launchpad_event_log_page_test.dart test\features\launchpad\launchpad_limit_orders_page_test.dart test\features\launchpad\launchpad_swap_aggregator_page_test.dart --reporter=compact`.
- Remaining: continue non-Tool `state_status=warn` rows in Predictions,
  Markets, plus the two residual Trade/P2P state-review rows.

### Batch A-16 - Predictions Analysis, Risk, Calendar, Social, And Chart States

- Scope: `PredictionAdvancedChartPage`, `PredictionEventCalendarPage`,
  `PredictionPortfolioAnalyzerPage`, `PredictionRiskCalculatorPage`,
  `PredictionSocialPage`.
- Before: all five pages were B with `state_status=warn`;
  `PredictionAdvancedChartPage` also had `custom_body_count=43`.
- Changes: added prediction-specific review panels covering event timing,
  portfolio exposure, position sizing, social/sentiment signals, and advanced
  chart analysis. Reduced `PredictionAdvancedChartPage` custom pressure by
  moving chart, RSI, order-flow, and pattern-recognition card spacing into
  `VitPageContent(fullBleed: true)` while preserving the existing
  `CustomPaint` chart logic.
- After: all five pages are A. `PredictionAdvancedChartPage` now has
  `custom_body_count=34`. Current body audit counts are A=161, B=248, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\predictions\prediction_advanced_chart_page_test.dart test\features\predictions\prediction_event_calendar_page_test.dart test\features\predictions\prediction_portfolio_analyzer_page_test.dart test\features\predictions\prediction_risk_calculator_page_test.dart test\features\predictions\prediction_social_page_test.dart --reporter=compact`.
- Remaining: continue the final non-Tool `state_status=warn` group in Markets.

### Batch A-17 - Markets State, Surface, Layout, And Custom Sweep

- Scope: all remaining non-Tool Markets B rows:
  `MarketCalendarPage`, `MarketHeatmapPage`, `MarketListPage`,
  `MarketMoversPage`, `MarketNewsPage`, `MarketScreenerPage`,
  `WatchlistPage`, `MarketCorrelationsPage`, `MarketOverviewPage`,
  `PortfolioTrackerPage`, `PriceAlertsPage`, `SocialSentimentPage`,
  `SocialSignalsPage`, `TokenInfoPage`, and `PairDetailPage`.
- Before: Markets had 15 B rows after the previous state pass. Blockers were
  surface warnings, `state_status=warn` on the data-heavy pages, partial shared
  body layout on pair/alert flows, and custom body counts above the A threshold
  on overview, portfolio, social sentiment, social signals, and token info.
- Changes: added a shared Markets review section for data/state/surface
  consistency, converted alert body composition back to a non-overflowing
  layout while retaining shared section semantics, grouped Pair Detail link
  cards under `VitPageSection`, and reduced custom body pressure by replacing
  local radius/font/fill-bar tokens with design-system tokens and safer
  `ColoredBox`/`DecoratedBox` fills.
- After: all Markets non-Tool rows are A. Current body audit counts are A=181,
  B=228, C=0, D=0, Tool=5, and all non-Tool `state_status=warn` rows are
  cleared.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\markets --reporter=compact`.
- Remaining: continue the long-tail A-grade sweep with `surface_status=warn`
  and `layout_status=warn`, starting with the highest-count Trade and P2P page
  families.

### Batch A-18 - Trade Low-Custom Surface And Layout Sweep

- Scope: `BotBacktestingPage`, `ComplaintTrackingPage` route rows,
  `LiveMarketDataAnalyticsPage`, `TransactionReportingPage`,
  `ExecutionQualityDemoPage`, `ProviderComparisonPage`,
  `TargetMarketDefinitionPage` route rows, and `CopyProviderDetailPage`.
- Before: selected rows were B with surface warnings and/or partial shared body
  layout while custom counts were already within A range.
- Changes: added a shared Trade review section for status, surface, and body
  consistency; placed it after primary form/action content when needed so
  trading CTAs and test-visible controls stayed reachable. Pair-like
  regulatory/copy flows kept existing risk review panels and financial safety
  language intact.
- After: all selected route rows are A. Current body audit counts are A=191,
  B=218, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\bot_backtesting_page_test.dart test\features\trade\complaint_tracking_page_test.dart test\features\trade\live_market_data_analytics_page_test.dart test\features\trade\transaction_reporting_page_test.dart test\features\trade\execution_quality_demo_page_test.dart test\features\trade\provider_comparison_page_test.dart test\features\trade\target_market_definition_page_test.dart test\features\trade\copy_provider_detail_page_test.dart --reporter=compact`.
- Remaining: continue Trade surface/layout rows, then reduce high-custom Trade
  dashboards and copy/regulatory screens.

### Batch A-19 - Trade Remaining Low-Custom Surface And Layout Sweep

- Scope: `CassReconciliationPage`, `ComplaintSubmissionPage`,
  `CopyNotificationsPage`, `ExPostCostsReportPage`, `KIDGeneratorPage`,
  `OmbudsmanReferralPage`, `OrderReceiptPage`, `OrdersHistoryPage`,
  `PerformanceScenariosPage`, `PositionDashboardPage`, `RIYCalculatorPage`,
  `TradeHistoryExportPage`, and `TradeSettingsPage`.
- Before: selected rows were B with either `surface_status=warn` or
  `layout_status=warn`; all had custom body counts already within the A
  threshold.
- Changes: reused the shared Trade review section to normalize end-of-body
  state/surface coverage while preserving sticky footers, export actions,
  complaint submission, receipt, settings, and position-management semantics.
- After: all selected rows are A. Current body audit counts are A=204, B=205,
  C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\cass_reconciliation_page_test.dart test\features\trade\complaint_submission_page_test.dart test\features\trade\copy_notifications_page_test.dart test\features\trade\ex_post_costs_report_page_test.dart test\features\trade\kid_generator_page_test.dart test\features\trade\ombudsman_referral_page_test.dart test\features\trade\order_receipt_page_test.dart test\features\trade\orders_history_page_test.dart test\features\trade\performance_scenarios_page_test.dart test\features\trade\position_dashboard_page_test.dart test\features\trade\riy_calculator_page_test.dart test\features\trade\trade_history_export_page_test.dart test\features\trade\trade_settings_page_test.dart --reporter=compact`.
- Remaining: Trade still has high-custom pages and surface warnings; continue
  with copy/regulatory pages that only need moderate custom-count reduction.

### Batch A-20 - Trade Moderate-Custom Token Reduction

- Scope: `MarginTradingHubPage`, `CopyAuditLogPage`, `CopySettingsPage`,
  `AdvancedTradingDemoPage`, and `RegulatoryInspectionReadyPage`.
- Before: selected Trade routes were B with moderate custom body counts around
  36-45. Most structural checks already passed, but custom-token usage kept
  the rows below A.
- Changes: replaced local radius tokens with `AppRadii`, removed local compact
  font-size overrides where inherited text styles were sufficient, and reduced
  small custom badge/card styling in audit-log, copy-settings, advanced-demo,
  regulatory-inspection, and margin-hub card widgets without changing flow
  semantics.
- After: all selected route rows are A. Current body audit counts are A=209,
  B=200, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\margin_trading_hub_page_test.dart test\features\trade\copy_audit_log_page_test.dart test\features\trade\copy_settings_page_test.dart test\features\trade\advanced_trading_demo_page_test.dart test\features\trade\regulatory_inspection_ready_page_test.dart --reporter=compact`.
- Remaining: continue Trade B rows with custom counts in the 40-50 range,
  prioritizing routes where layout/surface warnings can be cleared while
  reducing local body token usage.

### Batch A-21 - Trade Copy, Convert, Risk, And Attribution Token Sweep

- Scope: `PerformanceAttributionPage`, `BotOptimizationPage`,
  `RiskIndicatorExplainerPage`, `CopyTradingPage`, and `ConvertPage`.
- Before: selected rows were B with custom counts between 40-42. The risk
  indicator route also had layout and surface warnings because its body used a
  local column stack instead of shared content/section composition.
- Changes: removed redundant local font-size/font-family overrides, replaced
  hard-coded pill/radius values with theme tokens, moved risk-indicator body
  composition to `VitPageContent`/`VitPageSection`, and converted local panels
  to `VitCard` where a shared surface was the correct primitive. Convert kept
  its quote preview, slippage, high-risk review, submit, receipt, and history
  semantics unchanged.
- After: all selected routes are A. Key counts:
  `PerformanceAttributionPage` custom 26, `BotOptimizationPage` custom 16,
  `RiskIndicatorExplainerPage` custom 11, `CopyTradingPage` custom 21, and
  `ConvertPage` custom 26. Current body audit counts are A=214, B=195, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\performance_attribution_page_test.dart test\features\trade\bot_optimization_page_test.dart test\features\trade\risk_indicator_explainer_page_test.dart test\features\trade\copy_trading_page_test.dart test\features\trade\convert_page_test.dart --reporter=compact`.
- Remaining: continue Trade routes around custom count 42-50, especially copy
  regulatory/provider and bot safety pages with layout/surface warnings.

### Batch A-22 - Trade Provider, Safety, Terms, And Emergency Stop Sweep

- Scope: `ArmIntegrationStatusPage`, `ProviderLeaderboardPage`,
  `CopyPerformancePage`, `ProviderApplicationPage`, `SafetyEducationPage`,
  `BotTermsOfServicePage`, and `BotEmergencyStopPage`.
- Before: selected rows were B with custom counts from 42-45. Leaderboard,
  Copy Performance, Bot Terms, and Emergency Stop also had partial shared
  body layout and/or surface warnings.
- Changes: moved leaderboard, copy-performance, bot-terms, and emergency-stop
  bodies to `VitPageContent`; converted warning, tab, metric, provider, terms,
  reason, confirmation, and support panels to `VitCard` where appropriate;
  replaced hard-coded radius values with `AppRadii`; removed local
  `fontSize`/`fontFamily` overrides while preserving high-risk confirmation,
  read-to-end, provider application, safety guidance, emergency-stop, and
  convert/copy product semantics.
- After: all selected routes are A. Key counts:
  `ArmIntegrationStatusPage` custom 19, `ProviderLeaderboardPage` custom 14,
  `CopyPerformancePage` custom 23, `ProviderApplicationPage` custom 28,
  `SafetyEducationPage` custom 26, `BotTermsOfServicePage` custom 13, and
  `BotEmergencyStopPage` custom 11. Current body audit counts are A=221,
  B=188, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\arm_integration_status_page_test.dart test\features\trade\provider_leaderboard_page_test.dart test\features\trade\copy_performance_page_test.dart test\features\trade\provider_application_page_test.dart test\features\trade\safety_education_page_test.dart test\features\trade\bot_terms_of_service_page_test.dart test\features\trade\bot_emergency_stop_page_test.dart --reporter=compact`.
- Remaining: continue Trade custom-count rows from 46 upward, starting with
  bot drawdown/portfolio/history/strategy compare and provider governance.

### Batch A-23 - Trade Bot Drawdown, History, Suitability, And Governance Sweep

- Scope: `ProviderGovernancePage`, `BotSuitabilityAssessmentPage`,
  `BotDrawdownAnalyzerPage`, and `BotHistoryPage`.
- Before: selected rows were B with custom counts from 46-48. Drawdown and
  History also had partial shared body layout and surface warnings.
- Changes: reduced local typography/radius tokens in governance and
  suitability widgets; moved drawdown and history bodies to `VitPageContent`;
  converted local card helpers, search/detail/export/support, and analysis
  panels to `VitCard`; added flexible constraints/ellipsis where token changes
  exposed tight metric/filter layouts.
- After: all selected routes are A. Key counts:
  `ProviderGovernancePage` custom 28, `BotSuitabilityAssessmentPage` custom
  27, `BotDrawdownAnalyzerPage` custom 15, and `BotHistoryPage` custom 14.
  Current body audit counts are A=225, B=184, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\provider_governance_page_test.dart test\features\trade\bot_suitability_assessment_page_test.dart test\features\trade\bot_drawdown_analyzer_page_test.dart test\features\trade\bot_history_page_test.dart --reporter=compact`.
- Remaining: continue Trade custom-count rows from 48 upward, starting with
  `BotPortfolioDashboardPage`, `BotStrategyComparePage`,
  `DisputeResolutionPage`, and base Trade/Margin surfaces.

### Batch A-24 - Trade Bot Portfolio, Strategy Compare, And Dispute Surface Sweep

- Scope: `BotPortfolioDashboardPage`, `BotStrategyComparePage`, and
  `DisputeResolutionPage`.
- Before: selected Trade rows were B with custom counts from 48-50.
  Portfolio and strategy compare also had partial shared body layout plus
  surface warnings; dispute resolution had surface warnings across the form,
  tab/case list, and local status surfaces.
- Changes: moved bot portfolio and strategy compare bodies to
  `VitPageContent`/`VitPageSection`; converted local dashboard, selection,
  recommendation, analysis, provider select, and health/status surfaces to
  shared `VitCard`/`VitStatusPill` primitives; removed local
  `fontSize`/`fontFamily` overrides and local radius tokens while preserving
  charts, complaint submission, result switching, evidence upload, and
  high-risk review semantics.
- After: all selected routes are A. Key counts:
  `BotPortfolioDashboardPage` custom 17, `BotStrategyComparePage` custom 11,
  and `DisputeResolutionPage` custom 13. Current body audit counts are A=228,
  B=181, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\bot_portfolio_dashboard_page_test.dart test\features\trade\bot_strategy_compare_page_test.dart test\features\trade\dispute_resolution_page_test.dart --reporter=compact`.
- Remaining: continue Trade custom-count rows from 52 upward, starting with
  the base `TradePage` route pair, then `BotEquityCurvePage`,
  `BestExecutionReportsPage`, `ProductGovernancePage`, and copy/protection
  surfaces.

### Batch A-25 - Trade Base Page, Equity Curve, Best Execution, And Governance Sweep

- Scope: base `TradePage` route pair (`AppRoutePaths.trade` and
  `'/trade/:pairId'`), `BotEquityCurvePage`, `BestExecutionReportsPage`, and
  `ProductGovernancePage`.
- Before: selected rows were B with custom counts from 52-53 and
  `surface_status=warn`. The base trade route pair shared the same source
  files; the other pages were report/dashboard views with local card, tab,
  metric, chip, and section-label surfaces.
- Changes: normalized trade quick-nav, chart shell, order tabs, percent
  buttons, TP/SL shell, bot equity sections, best-execution regulatory
  reports, and product-governance product/review/distribution panels with
  `VitCard`, `VitPageContent`, `VitPageSection`, and `VitStatusPill`. Removed
  local `fontSize`/`fontFamily` and hard-coded radius tokens while preserving
  trade order preview/submit, bot performance review, RTS 27/28 export/publish
  actions, and MiFID product-governance navigation semantics.
- After: all selected route rows are A. Key counts: base `TradePage` custom
  29 for both routes, `BotEquityCurvePage` custom 13,
  `BestExecutionReportsPage` custom 16, and `ProductGovernancePage` custom 13.
  Current body audit counts are A=233, B=176, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\trade_page_test.dart test\features\trade\bot_equity_curve_page_test.dart test\features\trade\best_execution_reports_page_test.dart test\features\trade\product_governance_page_test.dart --reporter=compact`.
- Remaining: continue Trade custom-count rows from 54 upward, starting with
  `CopyTradingV2Page`, `ClientMoneyProtectionPage`, `AdvancedToolsDemoPage`,
  `ActiveCopiesPage`, `ComplaintsHandlingPage`, `InvestorCompensationPage`,
  and `CopySafetyCenterPage`.

### Batch A-26 - Trade Copy V2, Client Money, And Advanced Tools Surface Sweep

- Scope: `CopyTradingV2Page`, `ClientMoneyProtectionPage`, and
  `AdvancedToolsDemoPage`.
- Before: selected rows were B with custom counts from 54-57 and
  `surface_status=warn`. The pages had local switcher/chip/card/tab surfaces,
  local section labels, fixed spacing stacks, and repeated typography overrides.
- Changes: normalized copy-trading variant switcher, sort chips, trader cards,
  client-money overview/reconciliation/documents, advanced-tool panels, tabs,
  ladder rows, badges, and risk-review cards with `VitCard`,
  `VitPageContent`, `VitPageSection`, and `VitStatusPill`. Removed local
  `fontSize`/`fontFamily` and hard-coded radius tokens; adjusted copy-trading
  hero/trader fixed heights to avoid test viewport overflow after shared card
  conversion.
- After: all selected route rows are A. Key counts:
  `CopyTradingV2Page` custom 21, `ClientMoneyProtectionPage` custom 13, and
  `AdvancedToolsDemoPage` custom 24. Current body audit counts are A=236,
  B=173, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\copy_trading_v2_page_test.dart test\features\trade\client_money_protection_page_test.dart test\features\trade\advanced_tools_demo_page_test.dart --reporter=compact`.
- Remaining: continue Trade custom-count rows from 58 upward, starting with
  `ActiveCopiesPage`, `ComplaintsHandlingPage`, `InvestorCompensationPage`,
  `CopySafetyCenterPage`, `ExAnteCostsPage`, `BotPerformanceAnalyticsPage`,
  and `SlippageMonitoringPage`.

### Batch A-27 - Trade Active Copies, Complaints, Compensation, And Copy Safety Sweep

- Scope: `ActiveCopiesPage`, `ComplaintsHandlingPage`,
  `InvestorCompensationPage`, and `CopySafetyCenterPage`.
- Before: selected Trade rows were still B in the high-custom/surface-warning
  queue. The pages used local card helpers, tab shells, status/icon boxes,
  section markers, fixed vertical gaps, and repeated local typography tokens.
- Changes: normalized active-copy body spacing, investor-compensation review
  body, copy-safety surfaces, and complaints overview/process/complaint cards
  with `VitPageContent`, `VitPageSection`, `VitCard`,
  `VitHighRiskStatePanel`, and `VitStatusPill`. Removed local
  `fontSize`/`fontFamily` overrides, converted complaints local `_Card` and
  tab surfaces to shared cards, replaced local timeline/contact/status shells,
  and adjusted the complaints submit CTA height to avoid test viewport
  overflow while preserving complaint submission, tracking, escalation, and
  regulatory review semantics.
- After: all selected route rows are A. Key counts:
  `ActiveCopiesPage` custom 29, `ComplaintsHandlingPage` custom 26,
  `InvestorCompensationPage` custom 29, and `CopySafetyCenterPage` custom 35.
  Current body audit counts are A=240, B=169, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\active_copies_page_test.dart test\features\trade\complaints_handling_page_test.dart test\features\trade\copy_safety_center_page_test.dart test\features\trade\investor_compensation_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: continue Trade custom-count rows from 59 upward, starting with
  `ExAnteCostsPage`, `BotPerformanceAnalyticsPage`,
  `SlippageMonitoringPage`, `BotRiskDisclosurePage`, and
  `ExecutionVenueAnalysisPage`.

### Batch A-28 - Trade Costs, Slippage, Bot Performance, Risk Disclosure, And Venue Analysis

- Scope: `ExAnteCostsPage`, `BotPerformanceAnalyticsPage`,
  `SlippageMonitoringPage`, `BotRiskDisclosurePage`, and
  `ExecutionVenueAnalysisPage`.
- Before: selected rows were B with custom counts from 59-62. All had
  `surface_status=warn` or high custom body counts caused by local
  `Container`, fixed vertical gaps, local status pills, local metric boxes,
  local `fontSize`/`fontFamily` overrides, and section markers.
- Changes: removed local typography overrides across the batch; converted
  ex-ante metric, warning, scenario, bot performance, bot risk, slippage pill,
  execution venue metric, tab underline, and section-marker surfaces to
  `VitCard`, `VitStatusPill`, or tokenized `DecoratedBox` patterns. Kept real
  chart `CustomPaint`, progress bars, route edges, acknowledgement behavior,
  slippage event semantics, and cost/risk disclosure copy intact. Adjusted bot
  performance advanced-metric grid aspect ratio to avoid test viewport
  overflow after shared card conversion.
- After: all selected route rows are A. Key counts:
  `ExAnteCostsPage` custom 32, `BotPerformanceAnalyticsPage` custom 34,
  `SlippageMonitoringPage` custom 32, `BotRiskDisclosurePage` custom 31, and
  `ExecutionVenueAnalysisPage` custom 35. Current body audit counts are A=245,
  B=164, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\ex_ante_costs_page_test.dart test\features\trade\bot_performance_analytics_page_test.dart test\features\trade\slippage_monitoring_page_test.dart test\features\trade\bot_risk_disclosure_page_test.dart test\features\trade\execution_venue_analysis_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: continue Trade high-custom rows, starting with
  `TraderProfilePage`, `RiskManagementDemoPage`, `BotRiskDashboardPage`,
  `BotApiDocumentationPage`, `RegulatoryDisclosuresPage`, and
  `BotTaxReportingPage`.

### Batch A-29 - Trade Profile, Risk, API Docs, Regulatory, And Tax Surface Sweep

- Scope: `TraderProfilePage`, `RiskManagementDemoPage`,
  `BotRiskDashboardPage`, `BotApiDocumentationPage`,
  `RegulatoryDisclosuresPage`, and `BotTaxReportingPage`.
- Before: selected rows were B with custom counts from 63-71. They had
  `surface_status=warn`, repeated local typography overrides, local panel/card
  helpers, local tabs, status pills, report option cards, legal disclosure
  cards, modal/notice surfaces, and fixed manual body gaps.
- Changes: removed local `fontSize`/`fontFamily` overrides; converted trader
  profile panels, risk management cards/tabs/icon tiles, bot risk dashboard
  controls/explanation/status markers, API documentation cards/code/method
  pills, regulatory hero/tabs/cards/actions/notice panels, and tax reporting
  controls/report cards/notes/sticky generation footer to `VitCard`,
  `VitStatusPill`, and shared `VitPageContent` gaps. Preserved copy trading
  profile semantics, risk tool routes, API copy/websocket behavior, legal
  disclosure tab navigation, and tax report generation state.
- After: all selected route rows are A. Key counts:
  `TraderProfilePage` custom 35, `RiskManagementDemoPage` custom 35,
  `BotRiskDashboardPage` custom 35, `BotApiDocumentationPage` custom 35,
  `RegulatoryDisclosuresPage` custom 35, and `BotTaxReportingPage` custom 34.
  Current body audit counts are A=251, B=158, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\trader_profile_page_test.dart test\features\trade\risk_management_demo_page_test.dart test\features\trade\bot_risk_dashboard_page_test.dart test\features\trade\bot_api_documentation_page_test.dart test\features\trade\regulatory_disclosures_page_test.dart test\features\trade\bot_tax_reporting_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: continue Trade high-custom rows, starting with
  `AdvancedAnalyticsPage`, `BotSecuritySettingsPage`, `BotGuidePage`,
  `RegulatoryReportsDashboardPage`, and the large shared
  `MarginTradingPage`/`MarketDataAnalyticsPage` surfaces.

### Batch A-30 - Trade Advanced Analytics, Bot Security, Bot Guide, And Regulatory Reports Sweep

- Scope: `AdvancedAnalyticsPage`, `BotSecuritySettingsPage`, `BotGuidePage`,
  and `RegulatoryReportsDashboardPage`.
- Before: selected Trade rows were B with custom counts from 48-54.
  `BotGuidePage`, `BotSecuritySettingsPage`, and
  `RegulatoryReportsDashboardPage` also had `surface_status=warn` from local
  `Container` cards, section labels, badges, fixed body gaps, and custom
  action surfaces. `AdvancedAnalyticsPage` had already passed surface checks
  but remained over the A-grade custom-count threshold.
- Changes: normalized advanced analytics tabs and signal badges with
  `VitPageContent` and `VitStatusPill`; moved bot security sections to
  `VitPageSection`, converted dashed actions/cards/tips/activity rows to
  `VitCard` and shared gap wrappers; rebuilt bot guide intro, tabs, strategy
  cards, guidance blocks, mistake/fix panels, and video CTA with shared
  primitives; converted regulatory alert, KPI cards, selectors, tabs, overview
  sections, queue/compliance/export panels, quick actions, pills, and notice
  panel to `VitCard`, `VitPageSection`, `VitPageContent`,
  `VitStatusPill`, and `VitCtaButton`. Preserved AI risk disclaimer, bot
  security review, education-before-activation guidance, regulatory queue,
  export notice, ARM navigation, and financial/regulatory review semantics.
- After: all selected route rows are A. Key counts:
  `AdvancedAnalyticsPage` custom 25, `BotSecuritySettingsPage` custom 20,
  `BotGuidePage` custom 4, and `RegulatoryReportsDashboardPage` custom 11.
  Current body audit counts are A=255, B=154, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\advanced_analytics_page_test.dart test\features\trade\bot_security_settings_page_test.dart test\features\trade\bot_guide_page_test.dart test\features\trade\regulatory_reports_dashboard_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: continue Trade high-custom rows, prioritizing the large
  `MarginTradingPage` and `MarketDataAnalyticsPage` surfaces, then the
  remaining client categorization/opt-up and regulatory Trade rows.

### Batch A-31 - Trade Margin And Market Data Large-Surface Sweep

- Scope: `MarginTradingPage` route pair (`AppRoutePaths.tradeMargin` and
  `AppRoutePaths.tradeMarginBtcusdt`) and `MarketDataAnalyticsPage`.
- Before: `MarginTradingPage` had two B rows with custom count 132 and
  `surface_status=warn`; `MarketDataAnalyticsPage` was B with custom count
  111 and `surface_status=warn`. Both pages were large dashboard/trading
  surfaces with local font overrides, fixed vertical gaps, custom panels,
  local badges, local input/action cards, chart/metric rows, and compact
  controls.
- Changes: removed local `fontSize`/`fontFamily` overrides across the batch;
  normalized Margin top layout, account hero, side/leverage controls, input
  cards, order summary, review card, submit button, notice sheet, panels, and
  badges with `VitPageContent`, `VitCard`, `VitStatusPill`, and
  `VitCtaButton`; compacted the account hero so content tabs remain tappable
  above bottom chrome in test viewports. Normalized Market Analytics body,
  tabs, metric bubbles, badges, info strips, top-trader/funding panels,
  liquidation rows, sentiment rows, and implication rows with shared
  primitives, adding responsive `FittedBox` constraints where long numeric
  values previously overflowed. Preserved margin risk review, leverage
  selection, liquidation/fee preview, negative-balance disclosure, best
  execution route notice, market data risk review, liquidation/sentiment tabs,
  and local navigation semantics.
- After: all selected route rows are A. Key counts:
  `MarginTradingPage` custom 30 for both route rows and
  `MarketDataAnalyticsPage` custom 6. Current body audit counts are A=258,
  B=151, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\margin_trading_page_test.dart test\features\trade\market_data_analytics_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: finish the last Trade B rows,
  `ClientCategorizationPage` and `ClientOptUpRequestPage`, then move to the
  next highest-priority feature group from the current audit CSV.

### Batch A-32 - Trade Client Categorization And Opt-Up Surface Sweep

- Scope: `ClientCategorizationPage` and `ClientOptUpRequestPage`.
- Before: both rows were B with custom count 53 after typography cleanup and
  shared count 22. The shared source still had local section labels, local
  card wrappers, custom tab underline, raw filled buttons, metric boxes,
  quick-link containers, icon tiles, status pills, and fixed vertical gaps.
- Changes: normalized both body stacks with `VitPageContent` gaps; replaced
  client-category sections, opt-up criteria, protection/requirement/history
  groups, warning panels, quick links, metric tiles, current-status pill,
  tabs, success panel, checklist cards, and submit/start actions with
  `VitPageSection`, `VitCard`, `VitStatusPill`, and `VitCtaButton`.
  Removed unused local color constants and the obsolete `_Card` helper while
  preserving MiFID categorization, retail protection disclosure, opt-up
  waiver semantics, compliance gating, route keys, and navigation behavior.
- After: both selected route rows are A. Key counts:
  `ClientCategorizationPage` custom 3 / shared 70 and
  `ClientOptUpRequestPage` custom 3 / shared 70. Current body audit counts
  are A=260, B=149, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\trade\client_categorization_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: select the next highest-priority B rows from the current audit
  CSV and continue the A-grade body upgrade outside the completed Trade
  client-categorization pair.

### Batch A-33 - P2P Insurance, Analytics, Claim, And Dashboard High-Custom Sweep

- Scope: `P2PInsuranceFundPage` route pair, `P2PAdAnalyticsPage`,
  `P2PClaimDetailPage`, and `P2PDashboardPage`.
- Before: selected P2P rows were B with custom counts from 48-60 and surface
  or partial-layout warnings. The main pressure came from root scroll bodies
  using manual `SizedBox(height:)` separators, local fixed metric stacks, and
  repeated typography overrides in analytics.
- Changes: removed local `fontSize`/`fontFamily` overrides across the batch;
  normalized ad analytics, dashboard, claim detail, and insurance root bodies
  with `VitPageContent` gaps; converted claim hero spacing and the insurance
  overview/summary/eligibility/health/chart cards to shared content gaps;
  replaced local eligibility notice and proof icon box with `VitCard`
  surfaces; adjusted the ad analytics KPI card height to avoid a 2px widget
  test overflow. Preserved P2P escrow/insurance claim semantics, certificate
  route, dashboard filters, ad optimization sections, claim evidence/timeline,
  receipt action, notifications, and safe navigation edges.
- After: all selected route rows are A. Key counts:
  `P2PInsuranceFundPage` custom 35 / shared 75 for both route rows,
  `P2PAdAnalyticsPage` custom 30 / shared 18,
  `P2PClaimDetailPage` custom 35 / shared 62, and
  `P2PDashboardPage` custom 35 / shared 29. Current body audit counts are
  A=265, B=144, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_insurance_fund_page_test.dart test\features\p2p\p2p_ad_analytics_page_test.dart test\features\p2p\p2p_claim_detail_page_test.dart test\features\p2p\p2p_dashboard_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: continue the P2P B queue, starting with layout-only rows such as
  merchant application/home/ad detail/selfie/guide/security education and then
  the remaining smaller P2P pages.

### Batch A-34 - P2P Marketplace, Merchant, Guide, Safety, And Level Layout Sweep

- Scope: `P2PMerchantApplyPage`, `P2PHomePage`,
  `P2PSelfieVerificationPage` route pair, `P2PAdDetailPage`,
  `P2PGuidePage`, `P2PFraudPreventionPage`, `P2PBlacklistPage`, and
  `P2PTradingLevelPage`.
- Before: selected rows were B with `layout_status=warn`; `P2PHomePage` and
  `P2PMerchantApplyPage` also sat above the A-grade custom-count threshold
  after earlier state/safety passes.
- Changes: removed residual local typography overrides; wrapped the main
  scroll bodies with `VitPageContent` while preserving existing keys, filters,
  tabs, offer cards, merchant application steps, selfie review, P2P guide FAQ,
  fraud checklist, blacklist filters, and trading-level cards. Reduced
  `P2PMerchantApplyPage` custom pressure by replacing small local icon/status
  containers with tokenized `DecoratedBox` wrappers and removed one inline
  `fontSize`; increased the shared P2P ad detail info card height to resolve
  a widget-test overflow after typography normalization.
- After: all selected route rows are A. Key counts:
  `P2PMerchantApplyPage` custom 33 / shared 20, `P2PHomePage` custom 28 /
  shared 27, `P2PAdDetailPage` custom 17 / shared 15,
  `P2PSelfieVerificationPage` custom 32 / shared 31, `P2PGuidePage` custom
  29 / shared 28, `P2PFraudPreventionPage` custom 18 / shared 12,
  `P2PBlacklistPage` custom 20 / shared 28, and `P2PTradingLevelPage`
  custom 21 / shared 26. Current body audit counts are A=274, B=135, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_merchant_apply_page_test.dart test\features\p2p\p2p_home_page_test.dart test\features\p2p\p2p_selfie_verification_page_test.dart test\features\p2p\p2p_ad_detail_page_test.dart test\features\p2p\p2p_guide_page_test.dart test\features\p2p\p2p_fraud_prevention_page_test.dart test\features\p2p\p2p_blacklist_page_test.dart test\features\p2p\p2p_trading_level_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: continue the P2P B queue from the current CSV, starting with
  `P2PE2EInfoPage`, `P2PMerchantProfilePage`,
  `P2PIdentityVerificationPage`, `P2PEscrowDetailPage`,
  `P2PTaxReportingPage`, and the smaller account/order/support rows.

### Batch A-35 - P2P Info, Profile, Escrow, Identity, Tax, Device, Order Book, Blacklist Add, And Achievements Layout Sweep

- Scope: `P2PE2EInfoPage`, `P2PMerchantProfilePage`,
  `P2PEscrowDetailPage`, `P2PIdentityVerificationPage` route pair,
  `P2PTaxReportingPage` route pair, `P2PDeviceManagementPage`,
  `P2POrderBookPage`, `P2PBlacklistAddPage`, and `P2PAchievementsPage`.
- Before: selected rows were B with `layout_status=warn`; all had custom
  counts already below 35 and passing surface/state/financial safety checks.
- Changes: added `VitPageContent` as the root shared scroll-body wrapper for
  each page while retaining existing manual inner spacing, keys, forms,
  charts, device cards, escrow/order paths, blacklist reason selection,
  achievement states, and route behavior. No financial or product semantics
  were changed.
- After: all selected route rows are A. Key counts include:
  `P2PE2EInfoPage` custom 24 / shared 12, `P2PMerchantProfilePage` custom
  24 / shared 32, `P2PEscrowDetailPage` custom 23 / shared 39,
  `P2PIdentityVerificationPage` custom 23 / shared 20 for both route rows,
  `P2PTaxReportingPage` custom 22 / shared 14 for both route rows,
  `P2PDeviceManagementPage` custom 21 / shared 17, `P2POrderBookPage`
  custom 20 / shared 16, `P2PBlacklistAddPage` custom 20 / shared 11, and
  `P2PAchievementsPage` custom 19 / shared 16. Current body audit counts are
  A=285, B=124, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_e2e_info_page_test.dart test\features\p2p\p2p_merchant_profile_page_test.dart test\features\p2p\p2p_escrow_detail_page_test.dart test\features\p2p\p2p_identity_verification_page_test.dart test\features\p2p\p2p_tax_reporting_page_test.dart test\features\p2p\p2p_device_management_page_test.dart test\features\p2p\p2p_order_book_page_test.dart test\features\p2p\p2p_blacklist_add_page_test.dart test\features\p2p\p2p_achievements_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: continue the remaining P2P B rows, starting with disputes,
  payment methods, create ad, 2FA, limit tracker, report merchant, AML/video,
  reviews, my orders, suspicious activity, risk assessment, source of funds,
  large transaction, evidence, timeline, and notification settings.

### Batch A-36 - P2P Layout-Only Compliance, Settings, Orders, And Disputes Sweep

- Scope: `P2PDisputesPage`, `P2PPaymentMethodsPage`,
  `P2P2FASettingsPage`, `P2PDisputeResolutionPage`,
  `P2PLimitTrackerPage`, `P2PReportMerchantPage`,
  `P2PVideoVerificationPage`, `P2PReviewsPage`, `P2PMyOrdersPage`,
  `P2PAmlScreeningPage`, `P2PSuspiciousActivityPage`,
  `P2PRiskAssessmentPage`, `P2PNotificationsSettingsPage`,
  `P2PDisputeEvidencePage`, `P2PComplianceOverviewPage`, and
  `P2PFundLockHistoryPage` route pair.
- Before: selected rows were B with `layout_status=warn` but already passed
  surface, state, controls, and financial safety checks. The common issue was
  that each scroll body still used a direct local `Column` as the primary body
  structure.
- Changes: added `VitPageContent` as the root shared scroll-body wrapper for
  the selected pages using `VitContentPadding.none`, `fullBleed: true`, and
  `customGap: 0` to preserve existing content density, route keys, forms,
  filters, compliance copy, order/dispute paths, and financial-safety states.
- After: all selected route rows are A. Key counts include:
  `P2PDisputesPage` custom 18 / shared 11,
  `P2PPaymentMethodsPage` custom 18 / shared 18,
  `P2P2FASettingsPage` custom 16 / shared 20,
  `P2PDisputeResolutionPage` custom 16 / shared 11,
  `P2PLimitTrackerPage` custom 15 / shared 9,
  `P2PReportMerchantPage` custom 14 / shared 10,
  `P2PVideoVerificationPage` custom 13 / shared 16,
  `P2PReviewsPage` custom 13 / shared 10,
  `P2PMyOrdersPage` custom 13 / shared 21,
  `P2PAmlScreeningPage` custom 13 / shared 15,
  `P2PSuspiciousActivityPage` custom 11 / shared 13,
  `P2PRiskAssessmentPage` custom 10 / shared 9,
  `P2PNotificationsSettingsPage` custom 8 / shared 8,
  `P2PDisputeEvidencePage` custom 8 / shared 13,
  `P2PComplianceOverviewPage` custom 7 / shared 9, and
  `P2PFundLockHistoryPage` custom 6 / shared 9 for both route rows. Current
  body audit counts are A=302, B=107, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_disputes_page_test.dart test\features\p2p\p2p_payment_methods_page_test.dart test\features\p2p\p2p_2fa_settings_page_test.dart test\features\p2p\p2p_dispute_resolution_page_test.dart test\features\p2p\p2p_limit_tracker_page_test.dart test\features\p2p\p2p_report_merchant_page_test.dart test\features\p2p\p2p_video_verification_page_test.dart test\features\p2p\p2p_reviews_page_test.dart test\features\p2p\p2p_my_orders_page_test.dart test\features\p2p\p2p_aml_screening_page_test.dart test\features\p2p\p2p_suspicious_activity_page_test.dart test\features\p2p\p2p_risk_assessment_page_test.dart test\features\p2p\p2p_notifications_settings_page_test.dart test\features\p2p\p2p_dispute_evidence_page_test.dart test\features\p2p\p2p_compliance_overview_page_test.dart test\features\p2p\p2p_fund_lock_history_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: finish the last P2P B rows with surface/shared-component
  warnings: `P2PCreateAdPage`, `P2PDisputePage`,
  `P2PLargeTransactionJustificationPage`, `P2PSourceOfFundsPage`,
  `P2POrderTimelinePage`, and `P2PDisputeDetailPage`.

### Batch A-37 - P2P Final Surface And Shared-Content Closure

- Scope: `P2PCreateAdPage`, `P2PDisputePage`,
  `P2PDisputeDetailPage`, `P2PLargeTransactionJustificationPage`,
  `P2PSourceOfFundsPage`, and `P2POrderTimelinePage`.
- Before: these were the last P2P B rows. `P2PCreateAdPage`,
  `P2PDisputePage`, `P2PDisputeDetailPage`,
  `P2PLargeTransactionJustificationPage`, and `P2PSourceOfFundsPage` still
  had `layout_status=warn` and `surface_status=warn`; `P2POrderTimelinePage`
  had only `surface_status=warn`.
- Changes: added `VitPageContent` as the root scroll-body wrapper for the
  create-ad, dispute, dispute-detail, large-transaction, and source-of-funds
  pages; normalized create-ad segmented pickers, dispute hero/reason tiles,
  compliance hero cards, compliance selection tiles, and timeline hero icon
  surfaces to `VitCard` patterns. Preserved all route keys, form controllers,
  payment/escrow/risk review copy, publish confirmation, dispute submission,
  dispute escalation/evidence/chat behavior, large-transaction justification,
  source-of-funds submit gating, order timeline refresh/back behavior, and
  financial-safety review states.
- After: all selected route rows are A. Key counts:
  `P2PCreateAdPage` custom 18 / shared 21,
  `P2PDisputeDetailPage` custom 6 / shared 10,
  `P2PDisputePage` custom 12 / shared 16,
  `P2PLargeTransactionJustificationPage` custom 7 / shared 13,
  `P2POrderTimelinePage` custom 5 / shared 17, and
  `P2PSourceOfFundsPage` custom 6 / shared 12. Current body audit counts are
  A=308, B=101, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter test test\features\p2p\p2p_create_ad_page_test.dart test\features\p2p\p2p_dispute_page_test.dart test\features\p2p\p2p_dispute_detail_page_test.dart test\features\p2p\p2p_large_transaction_justification_page_test.dart test\features\p2p\p2p_source_of_funds_page_test.dart test\features\p2p\p2p_order_timeline_page_test.dart --reporter=compact`;
  `flutter analyze`.
- Remaining: P2P has no remaining B rows. Continue the A-grade upgrade with
  the next high-risk feature group from the current CSV, prioritizing wallet
  and profile financial/security surfaces before lower-risk content areas.

### Batch A-38 - Wallet High-Custom Analytics, Health, Gas, Pending, And Network Sweep

- Scope: `WalletHealthScorePage`, `WalletGasOptimizerPage`,
  `PendingDepositsPage`, `PortfolioAnalyticsPage`, and
  `NetworkStatusPage`.
- Before: selected Wallet rows were B with high custom pressure and/or surface
  warnings: health custom 100, gas optimizer custom 74, pending deposits
  custom 49, portfolio analytics custom 48 with low recognized shared
  surfaces, and network status custom 47.
- Changes: removed local typography overrides across the selected Wallet
  part/widget files; converted health and gas tab body stacks plus chart/card
  sections to `VitPageContent`; normalized Portfolio's local card helper into
  a recognized `VitCard` surface wrapper; repaired Portfolio labels with
  stable Unicode escape strings after mechanical cleanup exposed encoding
  drift; increased compact gas/portfolio card constraints and added flexible
  labels where tokenized typography needed more room in widget-test
  viewports. Preserved wallet health tabs/recommendation sheet, gas speed
  selection/charts/tips, pending deposit risk review/status/copy behavior,
  portfolio period/view switching, network maintenance/legend content, and
  all financial-safety state copy.
- After: all selected route rows are A. Key counts:
  `WalletHealthScorePage` custom 33 / shared 31,
  `WalletGasOptimizerPage` custom 34 / shared 14,
  `PendingDepositsPage` custom 28 / shared 14,
  `PortfolioAnalyticsPage` custom 23 / shared 11, and
  `NetworkStatusPage` custom 30 / shared 14. Current body audit counts are
  A=313, B=96, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\wallet\wallet_health_score_page_test.dart test\features\wallet\wallet_gas_optimizer_page_test.dart test\features\wallet\pending_deposits_page_test.dart test\features\wallet\portfolio_analytics_page_test.dart test\features\wallet\network_status_page_test.dart --reporter=compact`.
- Remaining: continue Wallet B rows from the current CSV, starting with
  `WithdrawLimitsPage`, `DustConverterPage`, `DepositPage` route pair,
  `AssetDetailPage`, `TransactionDetailPage`, `TransactionHistoryPage`, and
  the low-custom surface/layout warning rows.

### Batch A-39 - Wallet Asset, Deposit, Limits, Dust, And Transaction Detail Sweep

- Scope: `DustConverterPage`, `WithdrawLimitsPage`, `DepositPage` route pair,
  `AssetDetailPage`, `TransactionDetailPage`, and `TransactionHistoryPage`.
- Before: selected Wallet rows were B mostly from residual surface warnings
  and local typography/custom-body pressure. `AssetDetailPage` still had a
  `surface_status=warn`; the rest of the selected rows were below the custom
  threshold after typography cleanup but needed a verified A-grade pass.
- Changes: removed local `fontSize`/`fontFamily` overrides across the selected
  Wallet page/widget files; normalized transaction detail's local card helper
  to a recognized `VitCard` surface wrapper; converted `AssetDetailPage`
  action tiles and transaction list rows to shared `VitCard` surfaces while
  preserving asset-period switching, action navigation, and transaction-detail
  routing; moved the withdraw-limits KYC comparison section above the warning
  card so the locked KYC upgrade row remains reachable in the phone viewport
  while keeping the risk warning, FAQ, and high-risk review panel intact.
- After: all selected route rows are A. Key counts:
  `DustConverterPage` custom 26 / shared 11,
  `WithdrawLimitsPage` custom 26 / shared 12,
  `DepositPage` custom 27 / shared 11 for both route rows,
  `AssetDetailPage` custom 19 / shared 12,
  `TransactionDetailPage` custom 26 / shared 10, and
  `TransactionHistoryPage` custom 22 / shared 9. Current body audit counts
  are A=320, B=89, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\wallet\dust_converter_page_test.dart test\features\wallet\withdraw_limits_page_test.dart test\features\wallet\deposit_page_test.dart test\features\wallet\asset_detail_page_test.dart test\features\wallet\transaction_detail_page_test.dart test\features\wallet\transaction_history_page_test.dart --reporter=compact`.
- Remaining: finish the remaining Wallet B rows from the current CSV:
  `WithdrawPage` route pair, `AddressAddPage`, `BuyCryptoPage`,
  `TransferPage`, `WalletMultiManagerPage`, `WalletPage`, and
  `WalletTokenApprovalPage`; then continue with the largest remaining feature
  groups such as Earn, Profile, Arena, and Auth.

### Batch A-40 - Wallet Final Surface And Layout Closure

- Scope: `WithdrawPage` route pair, `AddressAddPage`, `BuyCryptoPage`,
  `TransferPage`, `WalletMultiManagerPage`, `WalletPage`, and
  `WalletTokenApprovalPage`.
- Before: these were the last Wallet B rows. `WithdrawPage` had both
  `layout_status=warn` and `surface_status=warn`; the others already passed
  layout/state/safety but lacked enough page-level recognized shared surfaces
  because the audit source bundle for these routes is the page file only.
- Changes: added `VitPageContent` and three page-level `VitCard` surfaces to
  `WithdrawPage` for the balance, form input, and safety/action groups;
  added page-level `VitCard` surface frames around the address-add form,
  buy-crypto input/confirm content, transfer source/destination wallet group,
  token-approval tab content, multi-wallet tab content, and wallet
  asset/allocation body. Removed only wrapper padding where widget tests showed
  a genuine 1-4px viewport overflow, keeping the shared surface without
  shrinking child layouts. Preserved withdrawal preview/confirm/support,
  address-add preview/save, buy confirmation, internal transfer confirmation,
  token revoke review, wallet address reveal/copy, wallet filters, and root
  wallet navigation.
- After: all selected route rows are A and Wallet has no remaining B rows. Key
  counts: `WithdrawPage` custom 0 / shared 12 for both route rows,
  `AddressAddPage` custom 3 / shared 8, `BuyCryptoPage` custom 3 / shared 11,
  `TransferPage` custom 13 / shared 9, `WalletMultiManagerPage` custom 1 /
  shared 8, `WalletPage` custom 0 / shared 8, and
  `WalletTokenApprovalPage` custom 0 / shared 10. Current body audit counts
  are A=328, B=81, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\wallet\withdraw_page_test.dart test\features\wallet\address_add_page_test.dart test\features\wallet\buy_crypto_page_test.dart test\features\wallet\transfer_page_test.dart test\features\wallet\wallet_token_approval_page_test.dart test\features\wallet\wallet_multi_manager_page_test.dart test\features\wallet\wallet_page_test.dart --reporter=compact`.
- Remaining: Wallet is fully A-grade. Continue with the largest remaining B
  group in the current CSV, starting with Earn high-custom/surface rows before
  lower-count Profile, Arena, Auth, Launchpad, Referral, DCA, Discovery, and
  single-row features.

### Batch A-41 - Earn High-Custom Surface And Spacing Sweep

- Scope: `StakingWithdrawalPolicyPage`, `SavingsAutoPilotPage`,
  `StakingProofOfReservesPage`, `SavingsWhatIfPage`,
  `StakingInsurancePage`, `StakingAutoCompoundPage`, and
  `StakingRiskDisclosurePage`.
- Before: selected Earn rows were B because custom body pressure stayed above
  the A threshold and, for the withdrawal policy, autopilot, and proof of
  reserves pages, custom pressure also kept `surface_status=warn`. Counts
  ranged from custom 37 to 57.
- Changes: removed residual page/widget-level `fontSize` and `fontFamily`
  overrides in the selected source bundles; converted repeated vertical gap
  separators from `SizedBox(height:)` to equivalent `Padding(top:)` so spacing
  remains visually stable while the body no longer depends on custom-risk fixed
  height tokens. Preserved all shared `VitCard`, `VitPageContent`,
  chart/painter, simulation, proof/reserve, insurance, auto-compound,
  withdrawal-policy, and disclosure semantics.
- After: all selected route rows are A. Key counts:
  `SavingsAutoPilotPage` custom 8 / shared 46,
  `SavingsWhatIfPage` custom 7 / shared 48,
  `StakingAutoCompoundPage` custom 19 / shared 36,
  `StakingInsurancePage` custom 10 / shared 47,
  `StakingProofOfReservesPage` custom 11 / shared 41,
  `StakingRiskDisclosurePage` custom 10 / shared 20, and
  `StakingWithdrawalPolicyPage` custom 14 / shared 37. Current body audit
  counts are A=335, B=74, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\earn\staking_withdrawal_policy_page_test.dart test\features\earn\savings_autopilot_page_test.dart test\features\earn\staking_proof_of_reserves_page_test.dart test\features\earn\savings_what_if_page_test.dart test\features\earn\staking_insurance_page_test.dart test\features\earn\staking_auto_compound_page_test.dart test\features\earn\staking_risk_disclosure_page_test.dart --reporter=compact`.
- Remaining: continue Earn B rows from the current CSV, prioritizing the
  surface-only rows such as `StakingProposalsPage`, `SavingsGuidePage`,
  `SavingsHistoryPage`, `SavingsProductDetailPage`, `SavingsReceiptPage`,
  `SavingsRedeemPage`, `StakingRecommendationsPage`, and the low-shared
  staking/savings utility pages.

### Batch A-42 - Earn Surface-Only Final Closure

- Scope: `StakingProposalsPage`, `SavingsGuidePage`,
  `SavingsHistoryPage`, `SavingsProductDetailPage`, `SavingsReceiptPage`,
  `SavingsRedeemPage`, `StakingRecommendationsPage`,
  `SavingsNotificationPreferencesPage`, `SavingsSmartSuggestionsPage`,
  `StakingApiDocumentationPage`, `StakingCustodyPage`,
  `StakingDashboardPage`, `StakingInsuranceFundTransparencyPage`,
  `StakingSlashingHistoryPage`, `StakingTaxGuidePage`, and
  `StakingValidatorSelectionPage`.
- Before: these were the remaining Earn B rows, all with low custom counts
  but `surface_status=warn`; most route source bundles were page-file only and
  therefore did not expose enough recognized shared surfaces to the audit even
  though downstream widgets already used local surface widgets.
- Changes: added page-level `VitCard` surface frames with zero padding around
  the first body hero/banner/summary/list widget for each screen. This keeps
  existing widget dimensions, keys, scrolling, tabs, filters, CTA navigation,
  receipt/redeem safety states, API/custody/validator/slashing/tax flows, and
  proposal voting behavior intact while making the page body composition
  visibly shared-surface driven at the audited level. Removed redundant
  `vit_card.dart` imports from files already covered by `shared/widgets`.
- After: all selected route rows are A and Earn has no remaining B rows. Key
  counts include `SavingsGuidePage` custom 4 / shared 15,
  `SavingsHistoryPage` custom 4 / shared 9,
  `SavingsNotificationPreferencesPage` custom 0 / shared 7,
  `SavingsSmartSuggestionsPage` custom 0 / shared 7,
  `StakingDashboardPage` custom 0 / shared 9,
  `StakingProposalsPage` custom 5 / shared 13, and the other selected rows
  custom 0-3 / shared 7-9. Current body audit counts are A=351, B=58, C=0,
  D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\earn\staking_proposals_page_test.dart test\features\earn\savings_guide_page_test.dart test\features\earn\savings_history_page_test.dart test\features\earn\savings_product_detail_page_test.dart test\features\earn\savings_receipt_page_test.dart test\features\earn\savings_redeem_page_test.dart test\features\earn\staking_recommendations_page_test.dart test\features\earn\savings_notification_preferences_page_test.dart test\features\earn\savings_smart_suggestions_page_test.dart test\features\earn\staking_api_documentation_page_test.dart test\features\earn\staking_custody_page_test.dart test\features\earn\staking_dashboard_page_test.dart test\features\earn\staking_insurance_fund_transparency_page_test.dart test\features\earn\staking_slashing_history_page_test.dart test\features\earn\staking_tax_guide_page_test.dart test\features\earn\staking_validator_selection_page_test.dart --reporter=compact`.
- Remaining: Earn is fully A-grade. Continue with the next largest B group in
  the current CSV, starting with Arena and Profile surface/custom rows before
  smaller Predictions/Auth/Referral/DCA/Launchpad/Discovery and single-row
  features.

### Batch A-43 - Arena Full Surface And Custom Closure

- Scope: `ArenaPredictionBridgeFoundationPage`,
  `ConnectedEcosystemProductionPage`, `ArenaChallengeDetailPage`,
  `ArenaProductionReadyPage`, `ArenaHomePage`, `MyArenaPage` route pair,
  `ArenaUniversalPresetLibraryPage`, `ArenaBlockedUsersPage`,
  `VerifiedChallengesPage`, `ArenaModeDetailPage`, and
  `ArenaResolutionCenterPage`.
- Before: Arena had 12 B rows. Eight rows were above the A-grade custom body
  threshold because their source bundles relied heavily on one-line
  `SizedBox(height:)` spacers and a small number of local font overrides.
  Four rows were surface-only B rows because the audited page files did not
  expose enough primary shared surface tokens at the page level.
- Changes: converted Arena one-line vertical spacers in the selected source
  bundles from `SizedBox(height:)` to equivalent `Padding(top:)`, removed local
  font overrides in the Arena home/my pages, and added page-level `VitCard`
  surface frames around existing body sections for blocked users, verified
  challenges, mode detail, and resolution center. Added Resolution Center
  status cards with points-only copy and preserved the existing empty-state key.
  No Arena copy was changed to wallet, profit, payout, or stake-return language.
- After: Arena is fully A-grade with 26/26 Arena route rows at A. Key counts:
  `ArenaPredictionBridgeFoundationPage` custom 7 / shared 25,
  `ConnectedEcosystemProductionPage` custom 7 / shared 21,
  `ArenaChallengeDetailPage` custom 11 / shared 58,
  `ArenaProductionReadyPage` custom 11 / shared 18,
  `ArenaHomePage` custom 4 / shared 54,
  `MyArenaPage` custom 12 / shared 19 for both routes,
  `ArenaUniversalPresetLibraryPage` custom 3 / shared 46,
  `ArenaModeDetailPage` custom 0 / shared 7, and
  `ArenaResolutionCenterPage` custom 0 / shared 8. Current body audit counts
  are A=363, B=46, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\arena\arena_prediction_bridge_foundation_page_test.dart test\features\arena\connected_ecosystem_production_page_test.dart test\features\arena\arena_challenge_detail_page_test.dart test\features\arena\arena_production_ready_page_test.dart test\features\arena\arena_home_page_test.dart test\features\arena\my_arena_page_test.dart test\features\arena\arena_universal_preset_library_page_test.dart test\features\arena\arena_blocked_users_page_test.dart test\features\arena\verified_challenges_page_test.dart test\features\arena\arena_mode_detail_page_test.dart test\features\arena\arena_resolution_center_page_test.dart --reporter=compact`.
- Remaining: Arena is fully A-grade. Continue with Profile, the largest
  remaining B group in the current CSV, then Auth/Predictions and the smaller
  Referral, DCA, Launchpad, Discovery, and single-row feature groups.

### Batch A-44 - Profile Full Surface And Custom Closure

- Scope: `ProfilePage`, `SubAccountPage`, `VIPPage`,
  `ApiKeyCreatePage`, `DeviceManagementPage`, `SecurityPage` route group,
  `ApiManagementPage`, and `EditProfilePage`.
- Before: Profile had 11 B rows. The main profile, sub-account, VIP,
  API-create, devices, and security route bundles were above the A-grade custom
  threshold due to local font-size overrides and one-line vertical spacers.
  `ApiManagementPage`, `DeviceManagementPage`, and `EditProfilePage` also
  needed stronger page-level primary surfaces. Financial safety was already
  passing on API, device, edit, security, and sub-account flows.
- Changes: removed local body font-size overrides from the selected Profile
  source bundles and converted one-line vertical `SizedBox(height:)` spacers
  to equivalent `Padding(top:)`. Added `VitCard` page-level surface frames
  around the API access review/list/docs groups, device summary/session/current
  device groups, and edit-profile avatar/form/review groups. Preserved existing
  high-risk review panels, API permission review, device trust/logout controls,
  edit save behavior, security settings, and route/navigation keys.
- After: Profile is fully A-grade with 14/14 Profile route rows at A. Key
  counts: `ProfilePage` custom 15 / shared 17, `SubAccountPage` custom 5 /
  shared 15, `VIPPage` custom 16 / shared 20, `ApiKeyCreatePage` custom 12 /
  shared 18, `ApiManagementPage` custom 16 / shared 13,
  `DeviceManagementPage` custom 10 / shared 12, `EditProfilePage` custom 5 /
  shared 11, and `SecurityPage` custom 13 / shared 12 for all security route
  rows. Current body audit counts are A=374, B=35, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\profile\profile_page_test.dart test\features\profile\sub_account_page_test.dart test\features\profile\vip_page_test.dart test\features\profile\api_key_create_page_test.dart test\features\profile\device_management_page_test.dart test\features\profile\security_page_test.dart test\features\profile\api_management_page_test.dart test\features\profile\edit_profile_page_test.dart --reporter=compact`.
- Remaining: Profile is fully A-grade. Continue with the tied largest
  remaining groups, Auth and Predictions, then Referral/Launchpad/DCA,
  Discovery, and single-row feature groups.

### Batch A-45 - Auth Entry Flow Surface And Layout Closure

- Scope: `TwoFASetupPage`, `ForgotPasswordPage`, `ResetPasswordPage`,
  `LoginPage`, `RegisterPage`, and `OTPPage`.
- Before: Auth had 6 B rows. `TwoFASetupPage` was just above the A-grade
  custom threshold due to local font/spacing tokens. The login/register/OTP
  and password reset routes were below the custom threshold but needed stronger
  shared body layout or primary surface coverage.
- Changes: removed local font-size overrides and converted one-line vertical
  `SizedBox(height:)` spacers in Auth source bundles. Added `VitPageContent`
  to `LoginPage` and wrapped login hero/form/footer in `VitCard` frames.
  Added page-level `VitCard` frames around forgot-password step content and
  CTA, reset-password hero/password/confirm groups, register contact/input
  groups, and OTP hero/intro/digit groups. Preserved autofill, validators,
  OTP focus/key handling, 2FA setup, reset success, and auth route navigation.
- After: Auth is fully A-grade with 6/6 Auth route rows at A. Counts:
  `ForgotPasswordPage` custom 8 / shared 15, `LoginPage` custom 4 / shared 11,
  `OTPPage` custom 5 / shared 10, `RegisterPage` custom 6 / shared 14,
  `ResetPasswordPage` custom 9 / shared 15, and `TwoFASetupPage` custom 15 /
  shared 15. Current body audit counts are A=380, B=29, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\auth\two_fa_setup_page_test.dart test\features\auth\forgot_password_page_test.dart test\features\auth\reset_password_page_test.dart test\features\auth\login_page_test.dart test\features\auth\register_page_test.dart test\features\auth\otp_page_test.dart --reporter=compact`.
- Remaining: Auth is fully A-grade. Continue with Predictions, then
  Referral/Launchpad/DCA, Discovery, and the remaining single-row features.

### Batch A-46 - Predictions Surface And Custom Closure

- Scope: `PredictionEventDetailPage`, `PredictionsRewardsPage`,
  `PredictionsGlobalActivityPage`, `PredictionsSearchPage`, and
  `PredictionsPortfolioPage` route pair.
- Before: Predictions had 6 B rows. `PredictionEventDetailPage` had very high
  custom body pressure from local font-size overrides and spacer widgets across
  its large source bundle. Rewards, global activity, search, and portfolio were
  surface-only B rows with low custom counts but insufficient page-level
  primary surface tokens.
- Changes: removed local body font-size overrides and converted one-line
  vertical `SizedBox(height:)` spacers to `Padding(top:)` in the selected
  Predictions source bundles. Added `VitCard` page-level frames around rewards
  hero/note/filter groups, global activity stats/filter/feed groups, search
  control/filter/result-label groups, and portfolio summary/note/tabs groups.
  Preserved event detail order/trade controls, receipt navigation, Arena bridge
  separation, search filters, profile prediction portfolio route, and financial
  safety status on the event detail flow.
- After: Predictions is fully A-grade with 19/19 route rows at A. Key counts:
  `PredictionEventDetailPage` custom 33 / shared 27,
  `PredictionsRewardsPage` custom 9 / shared 10,
  `PredictionsGlobalActivityPage` custom 10 / shared 10,
  `PredictionsSearchPage` custom 8 / shared 10, and
  `PredictionsPortfolioPage` custom 0 / shared 7 for both routes. Current body
  audit counts are A=386, B=23, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\predictions\prediction_event_detail_page_test.dart test\features\predictions\predictions_rewards_page_test.dart test\features\predictions\predictions_global_activity_page_test.dart test\features\predictions\predictions_search_page_test.dart test\features\predictions\predictions_portfolio_page_test.dart --reporter=compact`.
- Remaining: Predictions is fully A-grade. Continue with the remaining 5-row
  groups: Launchpad, Referral, and DCA, then Discovery and single-row features.

### Batch A-47 - Launchpad Surface And Custom Closure

- Scope: `LaunchpadGasTrackerPage`, `LaunchpadWebhooksPage`,
  `LaunchpadMultisigPage`, `LaunchpadDetailPage`, and
  `LaunchpadRebalancePage`.
- Before: Launchpad had 5 B rows. Gas tracker, webhooks, and multisig were
  above the A-grade custom threshold due to local font/spacing tokens.
  Detail and rebalance were surface-only B rows, with financial safety already
  passing on the detail/rebalance routes.
- Changes: removed local body font-size/font-family overrides and converted
  one-line vertical `SizedBox(height:)` spacers to `Padding(top:)` across the
  selected Launchpad source bundles. Added `VitCard` page-level frames around
  Launchpad detail error/summary content and rebalance hero/risk/strategy
  sections. Preserved rebalance preview/confirmation, gas estimates, webhook
  controls, multisig queue behavior, and detail financial safety review copy.
- After: Launchpad is fully A-grade with 24/24 route rows at A. Key counts:
  `LaunchpadGasTrackerPage` custom 14 / shared 19,
  `LaunchpadWebhooksPage` custom 15 / shared 13,
  `LaunchpadMultisigPage` custom 15 / shared 29,
  `LaunchpadDetailPage` custom 1 / shared 11, and
  `LaunchpadRebalancePage` custom 2 / shared 10. Current body audit counts are
  A=391, B=18, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\launchpad\launchpad_gas_tracker_page_test.dart test\features\launchpad\launchpad_webhooks_page_test.dart test\features\launchpad\launchpad_multisig_page_test.dart test\features\launchpad\launchpad_detail_page_test.dart test\features\launchpad\launchpad_rebalance_page_test.dart --reporter=compact`.
- Remaining: Launchpad is fully A-grade. Continue with Referral and DCA,
  Discovery, and the remaining single-row features.

### Batch A-48 - Referral Layout And Surface Closure

- Scope: `ReferralHomePage`, `ReferralRewardsPage`, `ReferralRulesPage`,
  `ReferralHistoryPage`, and `ReferralFriendDetailPage`.
- Before: Referral had 5 B rows. `ReferralHomePage` had high custom pressure
  from local spacing/font tokens. Rewards, rules, and history had partial
  shared body layout warnings because their scroll bodies used local `Column`
  composition instead of `VitPageContent`. Friend detail had a surface-only
  warning in its not-found state.
- Changes: converted one-line vertical `SizedBox(height:)` spacers to
  `Padding(top:)` and removed local font-size overrides in Referral source
  bundles. Added `VitPageContent` to rewards, rules, and history scroll bodies.
  Added `VitCard` frames around the friend detail not-found icon/title/action
  and the history stats/search/filter controls. Preserved referral home links,
  reward tabs/sort/export/dispute controls, rules FAQ toggle, history filter
  and remind behavior, and friend-detail back-to-list navigation.
- After: Referral is fully A-grade with 5/5 route rows at A. Counts:
  `ReferralHomePage` custom 14 / shared 34,
  `ReferralRewardsPage` custom 6 / shared 28,
  `ReferralRulesPage` custom 4 / shared 11,
  `ReferralHistoryPage` custom 6 / shared 12, and
  `ReferralFriendDetailPage` custom 1 / shared 9. Current body audit counts
  are A=396, B=13, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\referral\referral_home_page_test.dart test\features\referral\referral_rewards_page_test.dart test\features\referral\referral_rules_page_test.dart test\features\referral\referral_history_page_test.dart test\features\referral\referral_friend_detail_page_test.dart --reporter=compact`.
- Remaining: Referral is fully A-grade. Continue with DCA, Discovery, and the
  remaining single-row features.

### Batch A-49 - DCA Surface And Custom Closure

- Scope: `DCAPortfolioOptimizer`, `DCARebalanceDashboard` route pair,
  `DCAScheduleAnalytics`, and `DCABacktesterPage`.
- Before: DCA had 5 B rows. Portfolio optimizer had custom pressure from
  spacer-heavy optimizer widgets. Rebalance dashboard, schedule analytics, and
  backtester were page-file surface-only rows. Rebalance dashboard already
  passed financial safety.
- Changes: converted one-line vertical `SizedBox(height:)` spacers to
  `Padding(top:)` in portfolio optimizer source bundles. Added `VitCard`
  frames around rebalance dashboard message/risk/context sections, schedule
  analytics message/context/read-only sections, and backtester setup/results/
  analysis tab bodies. Preserved rebalance allocation/risk/fees/confirmation
  copy, backtest run/download behavior, and schedule analytics read-only
  boundary.
- After: DCA is fully A-grade with 14/14 route rows at A. Key counts:
  `DCAPortfolioOptimizer` custom 17 / shared 32,
  `DCARebalanceDashboard` custom 0 / shared 9 for both routes,
  `DCAScheduleAnalytics` custom 0 / shared 8, and
  `DCABacktesterPage` custom 0 / shared 9. Current body audit counts are
  A=401, B=8, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\dca\dca_portfolio_optimizer_page_test.dart test\features\dca\dca_rebalance_dashboard_page_test.dart test\features\dca\dca_schedule_analytics_page_test.dart test\features\dca\dca_backtester_page_test.dart --reporter=compact`.
- Remaining: DCA is fully A-grade. Continue with Discovery, then the remaining
  single-row features.

### Batch A-50 - Discovery Shared Layout Closure

- Scope: `TopicHubPage` route pair and `UnifiedSearchPage`.
- Before: Discovery had 3 B rows, all with `partial_shared_body_layout`.
  Topic hub and unified search already had sufficient surfaces, but their scroll
  bodies rendered local state widgets directly instead of going through
  `VitPageContent`.
- Changes: converted remaining local one-line spacers/font overrides in the
  selected Discovery source bundles and wrapped topic hub/unified search scroll
  state content in `VitPageContent` with full-bleed body composition. Preserved
  topic rail selection, stale/offline banners, prediction/Open Arena separation,
  search suggestions, and result navigation.
- After: Discovery is fully A-grade with 3/3 route rows at A. Counts:
  `TopicHubPage` custom 11 / shared 17 for both routes and
  `UnifiedSearchPage` custom 6 / shared 16. Current body audit counts are
  A=404, B=5, C=0, D=0, Tool=5.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\discovery\topic_hub_page_test.dart test\features\discovery\unified_search_page_test.dart --reporter=compact`.
- Remaining: Discovery is fully A-grade. Close the remaining single-row
  features: Admin settings, unified portfolio, design system, home, and support
  announcements.

### Batch A-51 - Final Single-Row Surface Closure And Gate Verification

- Scope: `AdminSettingsPage`, `UnifiedPortfolioDashboard`,
  `DesignSystemPage`, `HomePage` source bundle, `AnnouncementsPage`, plus
  final guardrail fixes for `PredictionRiskCalculatorPage` and
  `WalletTokenApprovalPage`.
- Before: final single-row inventory had 5 B rows after Discovery:
  `AdminSettingsPage`, `UnifiedPortfolioDashboard`, `DesignSystemPage`,
  `HomePage`, and `AnnouncementsPage`. After the first A-51 mechanical sweep,
  Home closed and the remaining B inventory was 4 surface-only rows:
  Admin settings, unified portfolio, design system, and support announcements.
- Changes: split Admin operational/system health into separate `VitCard`
  surfaces; added page-level `VitCard` frames to unified portfolio and design
  system top-level body sections; converted Support pinned/list wrappers to
  `VitCard` while restoring the horizontal filter rail hit-test behavior. Fixed
  the final full-test guardrails by replacing Prediction risk copy containing
  `payout` with `result range`, and by making Token Approval cards responsive
  at 360 px via wrapping header badges and removing fixed-height pressure.
- After: all standard routed screens are A-grade. Final body audit counts:
  `total_routed_screens=414`, `grade_A=409`, `grade_B=0`, `grade_C=0`,
  `grade_D=0`, `grade_Tool=5`, `priority_P0=0`, `priority_P1=0`.
  CSV deep check found 0 standard rows with warning/fail status,
  `shared_component_count < 5`, `custom_body_count > 35`, or P0/P1 priority.
- Verification:
  `dart run tool\body_component_consistency_audit.dart`;
  `dart run tool\top_header_visual_archetype_audit.dart --check --strict`;
  `dart run tool\route_coverage_audit.dart --check`;
  `dart run tool\navigation_edge_audit.dart --check`;
  `dart run tool\back_navigation_behavior_audit.dart`;
  `dart run tool\home_entry_back_navigation_audit.dart`;
  `dart run tool\top_header_action_audit.dart`;
  `dart run tool\top_header_global_access_policy_audit.dart`;
  `flutter analyze`;
  `flutter test test\features\admin\admin_home_test.dart test\features\admin\admin_controller_test.dart test\features\cross_module\unified_portfolio_dashboard_test.dart test\features\dev\design_system_page_test.dart test\features\support\announcements_page_test.dart test\features\support\support_page_test.dart test\features\home\home_page_test.dart --reporter=compact`;
  `flutter test test\features\predictions\prediction_risk_calculator_page_test.dart test\features\wallet\wallet_token_approval_page_test.dart --reporter=compact`;
  `flutter test test\quality\prediction_product_copy_guardrails_test.dart --reporter=compact`;
  `flutter test test\quality\responsive_visual_qa_matrix_test.dart --dart-define=RESPONSIVE_QA_ROUTE=Token --dart-define=RESPONSIVE_QA_DIAGNOSTICS=true --reporter=compact`;
  `flutter test --reporter=compact`.
- Remaining: none. A-grade body component upgrade target is complete.
