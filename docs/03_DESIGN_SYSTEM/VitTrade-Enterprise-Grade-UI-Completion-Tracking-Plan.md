# VitTrade Enterprise-Grade UI Completion Tracking Plan

**Created:** 2026-06-19  
**Status:** Active tracking plan  
**Scope:** All routed Flutter screens and shared UI surfaces.  
**Primary baseline:** Home screen density, shared chrome, shared component
usage, dark theme, financial-safety clarity, and phone-first layout.

## 1. Objective

Complete the final UI polish layer after shared-component adoption: every
screen should feel consistent, dense enough, full-width/fullscreen where
appropriate, and enterprise-grade at 360dp+ without breaking financial safety
or Prediction Markets / Open Arena boundaries.

This plan tracks the work that is not fully captured by token or shared-body
audits: visual density, practical screen utilization, fullscreen-tool behavior,
section rhythm, and manual visual QA.

## 2. Current Baseline

| Audit | Current result |
| --- | ---: |
| Routed screens audited | 414 |
| Body Grade A | 406 |
| Body Grade B | 3 |
| Body Tool exceptions | 5 |
| Header fixed remaining | 0 |
| Header auto-hide | 404 |
| Header custom-scroll | 4 |
| Header no-top-header | 6 |
| Visual archetype strict issues | 0 |
| Header policy violations | 0 |
| Density P1 refactor | 0 |
| Density P1 fullscreen-tool QA | 5 |
| Density P2 visual review | 0 |
| Density P3 follow-up review | 6 |
| Density pass / low signal | 403 |

Source artifacts:

- `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`
- `docs/03_DESIGN_SYSTEM/VitTrade-UI-Fullscreen-Density-Home-Standard-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`
- `flutter_app/tool/ui_fullscreen_density_audit.dart`

## 3. Enterprise UI Definition Of Done

Every routed screen is complete only when all applicable items are true:

- [ ] Uses shared layout primitives before local scaffolds:
  `VitPageLayout`, `VitPageContent`, `VitInsetScrollView`,
  `VitHeader` / `VitTopChrome`, `VitAutoHideHeaderScaffold`.
- [ ] Uses shared widgets before local equivalents:
  `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`, `VitSectionHeader`,
  `VitStatusPill`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`,
  `VitSkeleton`, `VitDiscoveryActionCard`, market row primitives, and
  high-risk state primitives where matching.
- [ ] Uses `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadii`, and
  module accent tokens; no new local spacing, radius, typography, or palette
  system is introduced.
- [ ] Matches Home density unless there is a documented exception:
  compact/default content rhythm, no unnecessary relaxed gaps, no avoidable
  narrow max-width layout, no sparse centered layout for data-heavy screens.
- [ ] Uses fullscreen or full-bleed treatment for tool surfaces where the
  product needs workspace area.
- [ ] Supports phone-first layout at 360px and up, including bottom-nav-safe
  content end.
- [ ] Includes needed loading, empty, error, offline, submitting, and success
  states for the flow.
- [ ] Preserves financial safety: preview, risk, fees, limits, masking, and
  confirmation before high-risk actions.
- [ ] Preserves product boundaries: Arena stays points-only; Prediction
  Markets keeps wallet/position/PnL language separate.
- [ ] Passes focused widget tests, audits, `flutter analyze`, and visual QA for
  changed routes.

## 4. Required Workflow For Each Implementation Batch

1. Pick the next unchecked task from the highest open priority.
2. Read the target screen and nearest shared primitives before editing.
3. Run GitNexus impact analysis before editing any Dart symbol.
4. If impact is HIGH or CRITICAL, record the warning and narrow the change.
5. Keep the batch small: one screen or one tightly related route group.
6. Implement using shared components and theme tokens first.
7. Run focused tests and audits.
8. Update this plan with result, command evidence, and remaining risks.
9. Run `detect_changes()` before any commit.

## 5. Phase P0 - Planning And Guardrails

**Goal:** Make the tracking system reliable before changing UI code.

| Task | Status | Acceptance criteria | Verification |
| --- | --- | --- | --- |
| P0.1 Confirm audit baseline | [x] | Density CSV has 414 rows and grouped priorities match this plan. | `Import-Csv ...VitTrade-UI-Fullscreen-Density-Audit.csv` |
| P0.2 Create completion tracking plan | [x] | This file exists with priority queues, DoD, workflow, and verification gates. | `git diff --check -- docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Completion-Tracking-Plan.md` |
| P0.3 Define visual QA evidence format | [x] | Each completed batch records route, viewport, screenshot/manual result, commands, and residual exception reason. | Evidence template in Section 10 now includes visual QA and residual exception fields. |
| P0.4 Decide whether to automate density audit | [x] | Either promote the density script into `flutter_app/tool/` or keep CSV regeneration as manual docs workflow. | Automated through `flutter_app/tool/ui_fullscreen_density_audit.dart`. |

### P0 Evidence

```text
Batch: P0.3/P0.4 visual QA evidence format and density audit automation
Date: 2026-06-19
Status: Complete

Scope:
- Defined the required evidence shape for visual QA batches in Section 10.
- Promoted the previous manual density scoring workflow into
  `flutter_app/tool/ui_fullscreen_density_audit.dart`.
- The tool reads `VitTrade-Body-Component-Consistency-Audit.csv`, scans each
  route source bundle, computes density score/priority, and writes
  `VitTrade-UI-Fullscreen-Density-Audit.csv` plus markdown.

Skills / MCP:
- skills: planning-and-task-breakdown, vittrade-ui-checklists,
  frontend-ui-engineering, incremental-implementation, test-driven-development,
  gitnexus-impact-analysis.
- GitNexus: impact summary for `body_component_consistency_audit.dart`
  returned LOW risk, direct=0, affected processes=0.
- Headroom: not needed.
- simulator/browser: not needed for docs/tool guardrail batch.

GitNexus:
- impact target: `body_component_consistency_audit.dart`
- risk: LOW
- direct callers: 0
- affected processes: 0

Implementation:
- Added `flutter_app/tool/ui_fullscreen_density_audit.dart`.
- Generated current density markdown and CSV artifacts under
  `docs/02_FLUTTER_MIGRATION/`.

Visual QA:
- viewport: not applicable for P0 guardrail batch.
- route(s): all 414 routed screens covered by source-level density inventory.
- result: current density counts reproduced from the manual audit baseline.
- screenshot/artifact:
  `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`
  and `.md`.

Verification:
- `dart format tool/ui_fullscreen_density_audit.dart`: pass.
- `dart analyze tool/ui_fullscreen_density_audit.dart`: pass.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=1, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=14, P3_followup_review=13,
  Pass_or_low_signal=381.

Residual exception:
- none.

Next:
- P1.A.1 `OnboardingFlow` density refactor.
```

## 6. Phase P1 - Must Fix / Must Visually Prove

**Goal:** Close the highest confidence screens that can visibly break the
Home-standard feel.

### P1.A Onboarding Density Refactor

| Task | Screen | Status | Main issue | Expected result |
| --- | --- | --- | --- | --- |
| P1.A.1 | `OnboardingFlow` | [x] | `VitContentPadding.relaxed=6`, `VitContentGap.relaxed=3` | Aligned onboarding density with Home-like default page density while preserving auth/onboarding intent. |

Acceptance criteria:

- [ ] Keeps onboarding visuals polished but removes unnecessary loose spacing.
- [ ] Uses compact/default density unless a step intentionally needs breathing
  room.
- [ ] Works at 360px without clipped text or excessive empty vertical space.

Verification:

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart --check
dart run tool/top_header_visual_archetype_audit.dart
flutter test test/features/onboarding --reporter=compact
flutter analyze
```

#### P1.A Evidence

```text
Batch: P1.A.1 OnboardingFlow density refactor
Date: 2026-06-19
Status: Complete

Scope:
- Reduced avoidable relaxed page density in `OnboardingFlow` step bodies.
- Replaced six `VitContentPadding.relaxed` uses with
  `VitContentPadding.defaultPadding`.
- Replaced three `VitContentGap.relaxed` uses with
  `VitContentGap.defaultGap`.
- Preserved onboarding copy, route behavior, keys, footer controls, controller
  state, module carousel, goal selection, recommendation routing, and safety
  boundary messaging.

Skills / MCP:
- skills: planning-and-task-breakdown, vittrade-ui-checklists,
  frontend-ui-engineering, incremental-implementation, test-driven-development,
  gitnexus-impact-analysis.
- GitNexus: context and upstream impact on `OnboardingFlow`.
- Headroom: not needed.
- simulator/browser: not run for this source-level density batch; widget tests
  and responsive density audit were used.

GitNexus:
- impact target: `OnboardingFlow`
- risk: CRITICAL at depth 3 because router fan-out is broad; narrowed
  `maxDepth=1` returned LOW risk.
- direct callers: `flutter_app/lib/app/router/app_router.dart`
- affected processes: 0
- `detect_changes(scope=all)`: LOW risk, affected processes=0. Broad changed
  counts reflect the already-dirty worktree.

Implementation:
- Updated `flutter_app/lib/features/onboarding/presentation/pages/onboarding_flow_part_01.dart`.
- Updated `flutter_app/lib/features/onboarding/presentation/pages/onboarding_flow_part_02.dart`.

Visual QA:
- viewport: source-level density check plus existing onboarding widget viewport
  at 440x956.
- route(s): `AppRoutePaths.onboarding`
- result: `P1_density_refactor` dropped from 1 to 0 and
  `Pass_or_low_signal` increased from 381 to 382.
- screenshot/artifact:
  `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`
  and `.md`.

Verification:
- `dart format lib/features/onboarding/presentation/pages/onboarding_flow_part_01.dart lib/features/onboarding/presentation/pages/onboarding_flow_part_02.dart`: pass.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=14, P3_followup_review=13,
  Pass_or_low_signal=382.
- `flutter test test/features/onboarding --reporter=compact`: pass, 6 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none.

Next:
- P1.B.1 `EnterpriseStatesPage` fullscreen tool visual QA / workspace
  utilization.
```

### P1.B Fullscreen Tool QA / Workspace Utilization

| Task | Screen | Status | Expected result |
| --- | --- | --- | --- |
| P1.B.1 | `EnterpriseStatesPage` | [x] | Fullscreen tool content consumes available workspace; no unnecessary page padding. |
| P1.B.2 | `P2PChatPage` | [x] | Chat uses full height, keeps composer reachable, avoids sparse empty center. |
| P1.B.3 | `AdvancedChartPage` | [x] | Chart/tool area is full-bleed where useful and controls remain reachable. |
| P1.B.4 | `FuturesPage` | [x] | Trading workspace is dense, bottom-safe, and not boxed into a narrow body. |
| P1.B.5 | `TradingBotsPage` | [x] | Bot workspace uses available screen area and consistent tool chrome. |

Acceptance criteria:

- [ ] Each route has screenshot/manual visual QA at 360x800 or equivalent.
- [ ] Fullscreen tools either remain documented exceptions or are refactored to
  better use full screen.
- [ ] No financial controls are hidden, clipped, or pushed below unsafe areas.

Verification:

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart --check
dart run tool/top_header_visual_archetype_audit.dart
flutter analyze
flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact
```

#### P1.B Evidence

```text
Batch: P1.B.1 EnterpriseStatesPage fullscreen workspace QA
Date: 2026-06-19
Status: Complete

Scope:
- Verified the fullscreen-tool exception as a valid workspace surface instead
  of making unnecessary runtime UI changes.
- Confirmed the page already uses `VitPageLayout(variant: flush)`,
  `VitPageContent(fullBleed: true)`, shared state widgets, shared cards,
  shared tabs, shared buttons, and bottom-nav-safe scroll padding.
- Added a focused 360x800 widget QA assertion so the workspace cannot regress
  into a narrow or padded body.

Skills / MCP:
- skills: vittrade-ui-checklists, frontend-ui-engineering,
  incremental-implementation, test-driven-development,
  gitnexus-impact-analysis.
- GitNexus: context and upstream impact on `EnterpriseStatesPage`; impact on
  the target test file before editing test coverage.
- Headroom: not needed.
- simulator/browser: not run for this batch; widget viewport QA was used.

GitNexus:
- impact target: `EnterpriseStatesPage`
- risk: CRITICAL at depth 3 because router fan-out is broad; narrowed
  `maxDepth=1` returned LOW risk.
- direct callers: `_utilityRoutes` and `app_router.dart`
- affected processes: 0
- impact target: `enterprise_states_page_test.dart`
- test impact risk: LOW, direct callers=0, affected processes=0

Implementation:
- Updated `flutter_app/test/features/enterprise_states/enterprise_states_page_test.dart`.
- Added a `viewport` parameter to `pumpEnterpriseStates`.
- Added `SC-320 uses full-width workspace at 360x800`.

Visual QA:
- viewport: 360x800 at devicePixelRatio=1.
- route(s): `AppRoutePaths.enterpriseStates`
- result: `EnterpriseStatesPage.contentKey` spans x=0..360 and stays within
  the 800px viewport while `VitBottomNav` remains present.
- screenshot/artifact: widget-test viewport assertion.

Verification:
- `dart format test/features/enterprise_states/enterprise_states_page_test.dart`: pass.
- `flutter test test/features/enterprise_states/enterprise_states_page_test.dart --reporter=compact`: pass, 6 tests.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=14, P3_followup_review=13,
  Pass_or_low_signal=382.
- `dart run tool/body_component_consistency_audit.dart --check`: pass.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `flutter analyze`: pass.

Residual exception:
- Remains `Tool` by design because this route is a fullscreen utility/workbench
  surface, but the route now has full-width viewport regression coverage.

Next:
- P1.B.2 `P2PChatPage` fullscreen chat workspace QA.
```

```text
Batch: P1.B.2 P2PChatPage fullscreen chat workspace QA
Date: 2026-06-19
Status: Complete

Scope:
- Verified the fullscreen-tool exception as a valid chat/workspace surface.
- Confirmed the page already uses `VitPageLayout(variant: flush)`, a fixed
  shared-token header/risk/E2E banner stack, an expanded full-width message
  scroller, shared `VitInput`, shared status pills, shared icon buttons, and a
  bottom-inset-aware composer.
- Added a focused 360x800 widget QA assertion so the chat content cannot
  regress into a narrow/sparse body and the composer remains reachable.

Skills / MCP:
- skills: vittrade-ui-checklists, frontend-ui-engineering,
  incremental-implementation, test-driven-development,
  gitnexus-impact-analysis.
- GitNexus: context and upstream impact on `P2PChatPage`; impact on the target
  test file before editing test coverage.
- Headroom: not needed.
- simulator/browser: not run for this batch; widget viewport QA and responsive
  visual matrix were used.

GitNexus:
- impact target: `P2PChatPage`
- risk: CRITICAL at depth 3 because router fan-out is broad; narrowed
  `maxDepth=1` returned LOW risk.
- direct callers: `_p2pRoutes` and `app_router.dart`
- affected processes: 0
- impact target: `p2p_chat_page_test.dart`
- test impact risk: LOW, direct callers=0, affected processes=0

Implementation:
- Updated `flutter_app/test/features/p2p/p2p_chat_page_test.dart`.
- Added a `viewport` parameter to `pumpP2PChat`.
- Added `SC-320 uses full-height chat workspace at 360x800`.

Visual QA:
- viewport: 360x800 at devicePixelRatio=1.
- route(s): `AppRoutePaths.p2pChat('p2p001')`
- result: `P2PChatPage.contentKey` spans x=0..360, keeps a message workspace
  taller than 220px, and keeps input/send controls inside the 800px viewport
  while `VitBottomNav` remains present.
- screenshot/artifact: widget-test viewport assertion and responsive visual QA
  matrix.

Verification:
- `dart format test/features/p2p/p2p_chat_page_test.dart`: pass.
- `flutter test test/features/p2p/p2p_chat_page_test.dart --reporter=compact`:
  pass, 5 tests.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=14, P3_followup_review=13,
  Pass_or_low_signal=382.
- `dart run tool/body_component_consistency_audit.dart --check`: pass.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.
- `flutter test test/features/p2p --reporter=compact`: pass, 316 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.

Residual exception:
- Remains `Tool` by design because this route is a fullscreen encrypted chat
  surface with fixed header/composer chrome, but it now has full-width and
  composer-reachability regression coverage.

Next:
- P1.B.3 `AdvancedChartPage` fullscreen chart workspace QA.
```

```text
Batch: P1.B.3 AdvancedChartPage fullscreen chart workspace QA
Date: 2026-06-19
Status: Complete

Scope:
- Verified the fullscreen-tool exception as a valid chart/workbench surface.
- Added a 360x800 widget QA assertion for chart full width, chart height, and
  visible buy/sell/alert controls.
- The new guardrail exposed a real 360px overflow in the advanced chart header.
- Fixed the header by making the pair selector flexible and ellipsizing the
  pair symbol while keeping the price column visible.
- Preserved timeframe, chart type, indicator sheet, buy/sell, alert, and pair
  selector route behavior.

Skills / MCP:
- skills: vittrade-ui-checklists, frontend-ui-engineering,
  incremental-implementation, test-driven-development,
  gitnexus-impact-analysis, debugging-and-error-recovery.
- GitNexus: context and upstream impact on `AdvancedChartPage`; impact on
  `_ChartToolbar`, `_AdvancedHeader`, and the target test file before edits.
- Headroom: not needed.
- simulator/browser: not run for this batch; widget viewport QA and responsive
  visual matrix were used.

GitNexus:
- impact target: `AdvancedChartPage`
- risk: CRITICAL at depth 3 because router fan-out is broad; narrowed
  `maxDepth=1` returned LOW risk.
- direct callers: `_tradeRoutes` and `app_router.dart`
- affected processes: 0
- impact target: `_AdvancedHeader`
- header impact risk: LOW, direct callers=0, affected processes=0
- impact target: `_ChartToolbar`
- toolbar impact risk: LOW, direct callers=0, affected processes=0
- impact target: `advanced_chart_page_test.dart`
- test impact risk: LOW, direct callers=0, affected processes=0

Implementation:
- Updated `flutter_app/lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart`.
- Updated `flutter_app/test/features/trade/advanced_chart_page_test.dart`.
- Added a `viewport` parameter to `pumpAdvancedChart`.
- Added `SC-320 uses full-width chart workspace at 360x800`.

Visual QA:
- viewport: 360x800 at devicePixelRatio=1.
- route(s): `AppRoutePaths.tradeAdvancedChart('btcusdt')`
- result: chart painter spans x=0..360, chart height stays above 140px, and
  buy/sell/alert controls stay inside the 800px viewport with no Flutter
  layout exception.
- screenshot/artifact: widget-test viewport assertion and responsive visual QA
  matrix.

Verification:
- `dart format lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart test/features/trade/advanced_chart_page_test.dart`: pass.
- `flutter test test/features/trade/advanced_chart_page_test.dart --reporter=compact`:
  pass, 7 tests.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=14, P3_followup_review=13,
  Pass_or_low_signal=382.
- `dart run tool/body_component_consistency_audit.dart --check`: pass.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.
- `flutter test test/features/trade --reporter=compact`: pass, 351 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.

Residual exception:
- Remains `Tool` by design because this route is a fullscreen trading chart
  workspace, but the route now has full-width chart and no-overflow regression
  coverage at 360x800.

Next:
- P1.B.4 `FuturesPage` fullscreen trading workspace QA.
```

```text
Batch: P1.B.4 FuturesPage fullscreen trading workspace QA
Date: 2026-06-19
Status: Complete

Scope:
- Verified the fullscreen-tool exception as a valid futures trading workspace.
- Added a 360x800 widget QA assertion for full-width root scroll, visible
  header/chart/leverage controls, and bottom-safe submit CTA after scrolling.
- The new guardrail exposed a real 1px vertical overflow in the futures header.
- Fixed the header by increasing `_FuturesHeader` height by
  `AppSpacing.hairlineStroke`.
- Preserved financial safety copy, high-risk panels, leverage route, advanced
  chart route, submit/receipt behavior, positions/orders tabs, and Trade shell
  navigation.

Skills / MCP:
- skills: vittrade-ui-checklists, frontend-ui-engineering,
  incremental-implementation, test-driven-development,
  gitnexus-impact-analysis, debugging-and-error-recovery.
- GitNexus: context and upstream impact on `FuturesPage`; impact on
  `_FuturesHeader` and the target test file before edits.
- Headroom: not needed.
- simulator/browser: not run for this batch; widget viewport QA and responsive
  visual matrix were used.

GitNexus:
- impact target: `FuturesPage`
- risk: CRITICAL at depth 3 because router fan-out is broad; narrowed
  `maxDepth=1` returned LOW risk.
- direct callers: `_tradeRoutes` and `app_router.dart`
- affected processes: 0
- impact target: `_FuturesHeader`
- header impact risk: LOW, direct callers=0, affected processes=0
- impact target: `futures_page_test.dart`
- test impact risk: LOW, direct callers=0, affected processes=0

Implementation:
- Updated `flutter_app/lib/features/trade/presentation/pages/futures_page_part_01.dart`.
- Updated `flutter_app/test/features/trade/futures_page_test.dart`.
- Added a `viewport` parameter to `pumpFutures`.
- Added `SC-320 uses full-width futures workspace at 360x800`.

Visual QA:
- viewport: 360x800 at devicePixelRatio=1.
- route(s): `AppRoutePaths.tradeFutures('btcusdt')`
- result: root futures scroll spans x=0..360, visible top controls stay inside
  the viewport, submit CTA can be scrolled into the 800px viewport, and no
  Flutter layout exception remains.
- screenshot/artifact: widget-test viewport assertion and responsive visual QA
  matrix.

Verification:
- `dart format lib/features/trade/presentation/pages/futures_page_part_01.dart test/features/trade/futures_page_test.dart`: pass.
- `flutter test test/features/trade/futures_page_test.dart --reporter=compact`:
  pass, 9 tests.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=14, P3_followup_review=13,
  Pass_or_low_signal=382.
- `dart run tool/body_component_consistency_audit.dart --check`: pass.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.
- `flutter test test/features/trade --reporter=compact`: pass, 352 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.

Residual exception:
- Remains `Tool` by design because this route is a high-risk futures trading
  workspace, but it now has full-width, bottom-safe, no-overflow regression
  coverage at 360x800.

Next:
- P1.B.5 `TradingBotsPage` fullscreen bot workspace QA.
```

```text
Batch: P1.B.5 TradingBotsPage fullscreen bot workspace QA
Date: 2026-06-19
Status: Complete

Scope:
- Verified the fullscreen-tool exception as a valid trading-bot workspace.
- Added a 360x800 widget QA assertion for full-width content, visible shell
  controls, active tabs, and bottom-safe add-bot CTA after scrolling.
- The new guardrail exposed two real 360px vertical overflows:
  `_TradingBotsHeader` by 1px and `_HeroStat` by 8px/3px.
- Fixed the header height and hero stat card height with existing spacing
  tokens.
- Preserved bot toggle/delete behavior, strategy creation sheet, success toast,
  scoped child-route returns, risk warning copy, and Trade shell navigation.

Skills / MCP:
- skills: vittrade-ui-checklists, frontend-ui-engineering,
  incremental-implementation, test-driven-development,
  gitnexus-impact-analysis, debugging-and-error-recovery.
- GitNexus: context and upstream impact on `TradingBotsPage`; impact on
  `_TradingBotsHeader`, `_HeroStat`, and the target test file before edits.
- Headroom: not needed.
- simulator/browser: not run for this batch; widget viewport QA and responsive
  visual matrix were used.

GitNexus:
- impact target: `TradingBotsPage`
- risk: CRITICAL at depth 3 because router fan-out is broad; narrowed
  `maxDepth=1` returned LOW risk.
- direct callers: `_tradeRoutes` and `app_router.dart`
- affected processes: 0
- impact target: `_TradingBotsHeader`
- header impact risk: LOW, direct callers=0, affected processes=0
- impact target: `_HeroStat`
- hero-stat impact risk: LOW, direct callers=0, affected processes=0
- impact target: `trading_bots_page_test.dart`
- test impact risk: LOW, direct callers=0, affected processes=0

Implementation:
- Updated `flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_01.dart`.
- Updated `flutter_app/test/features/trade/trading_bots_page_test.dart`.
- Added a `viewport` parameter to `pumpTradingBots`.
- Added `SC-320 uses full-width bot workspace at 360x800`.

Visual QA:
- viewport: 360x800 at devicePixelRatio=1.
- route(s): `AppRoutePaths.tradeBots`
- result: `TradingBotsPage.contentKey` spans x=0..360, back/tab controls stay
  visible, add-bot CTA can be scrolled into the 800px viewport, and no Flutter
  layout exception remains.
- screenshot/artifact: widget-test viewport assertion and responsive visual QA
  matrix.

Verification:
- `dart format lib/features/trade/presentation/pages/trading_bots_page_part_01.dart test/features/trade/trading_bots_page_test.dart`: pass.
- `flutter test test/features/trade/trading_bots_page_test.dart --reporter=compact`:
  pass, 7 tests.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=14, P3_followup_review=13,
  Pass_or_low_signal=382.
- `dart run tool/body_component_consistency_audit.dart --check`: pass.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.
- `flutter test test/features/trade --reporter=compact`: pass, 353 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.

Residual exception:
- Remains `Tool` by design because this route is an automation/bot workspace,
  but it now has full-width, bottom-safe, no-overflow regression coverage at
  360x800.

Next:
- P2.2 `ConnectedEcosystemProductionPage` visual density review.
```

## 7. Phase P2 - Visual Density Review Queue

**Goal:** Bring high-signal A/B screens closer to Home density and shared-body
composition.

| Task | Feature | Screen / route | Status | Main issue |
| --- | --- | --- | --- | --- |
| P2.1 | p2p | `P2PWalletTransferPage` | [x] | Custom body exceeds shared count; few dense sections/cards. |
| P2.2 | arena | `ConnectedEcosystemProductionPage` | [x] | Body B and custom body exceeds shared count. |
| P2.3 | news | `NewsPage` | [x] | Relaxed padding and few dense sections/cards. |
| P2.4 | arena | `ArenaProductionReadyPage` | [x] | Custom body exceeds shared count by 14. |
| P2.5 | trade | `TradePage` and `/trade/:pairId` | [x] | Instrument route has relaxed padding signals. |
| P2.6 | arena | `MyArenaPage` and `profileArena` | [x] | Relaxed padding and custom body exceeds shared count. |
| P2.7 | dca | `DCAOverviewDemo` | [x] | Loose gap and few dense sections/cards. |
| P2.8 | predictions | `PredictionTournamentsPage` and tournament detail route | [x] | Relaxed padding signals. |
| P2.9 | p2p | `P2PMerchantApplyPage` | [x] | Custom body exceeds shared count by 9. |
| P2.10 | markets | `AdvancedChartsPage` | [x] | Relaxed padding and custom body exceeds shared count. |
| P2.11 | launchpad | `LaunchpadWebhooksPage` | [x] | Custom body exceeds shared count by 9. |

Acceptance criteria for each task:

- [ ] Remove avoidable relaxed/loose page density.
- [ ] Replace local repeated layout/card/state controls with shared primitives
  where the shared primitive exists.
- [ ] Preserve domain copy, safety copy, route behavior, provider behavior, and
  product boundaries.
- [ ] Re-run the target feature tests.

Verification command template:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
flutter test test/features/<feature> --reporter=compact
flutter analyze
```

P2.1 evidence - `P2PWalletTransferPage`

```text
Scope:
- Replaced local asset tile material/ink shell with `VitCard` while preserving
  selection keys and P2P wallet copy.
- Replaced quick percentage chips, submit CTA, and confirm CTA wrappers with
  `VitCtaButton`.
- Added a 360x800 full-width regression test covering scroll workspace,
  submit visibility, confirm-panel navigation, and no layout exceptions.
- Fixed confirm-row value overflow by constraining label/value text with
  responsive `Expanded`/`Flexible` behavior.

GitNexus:
- `impact(P2PWalletTransferPage)`: router-wide summary is CRITICAL because the
  central route table fans out broadly; direct local page impact is LOW.
- `_AssetTile`, `_QuickPercentRow`, `_SubmitButton`, `_ConfirmButton`, and
  `_ConfirmRow`: LOW impact, no affected execution flows.

Verification:
- `flutter test test/features/p2p/p2p_wallet_transfer_page_test.dart --reporter=compact`:
  pass, 7 tests.
- `flutter test test/features/p2p --reporter=compact`: pass, 317 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=13, P3_followup_review=13,
  Pass_or_low_signal=383.
- `dart run tool/body_component_consistency_audit.dart --check`: pass.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none. This screen now sits below the P2 density threshold and keeps
  360x800 full-screen usage covered.

Next:
- P2.2 `ConnectedEcosystemProductionPage` visual density review.
```

P2.2 evidence - `ConnectedEcosystemProductionPage`

```text
Scope:
- Replaced local inline text action shell with compact `VitCtaButton` for
  canonical route and flow-step navigation actions.
- Consolidated canonical, states, flows, and handoff section spacing through
  `VitPageSection` instead of local `SizedBox(height:)` separators.
- Preserved Open Arena / Prediction Markets product boundary copy and route
  resolving behavior.

GitNexus:
- `impact(ConnectedEcosystemProductionPage)`: router-wide summary is CRITICAL
  because the central route table fans out broadly; direct local page impact is
  LOW.
- `_SmallTextAction`, `_CanonicalSection`, `_StatesSection`, `_FlowsSection`,
  and `_HandoffSection`: LOW impact, no affected execution flows.

Audit result:
- Body audit moved `ConnectedEcosystemProductionPage` from grade B to grade A.
- Fullscreen density moved the page from P2 to `Pass_or_low_signal`.
- Shared/custom counts are now shared=46 and custom=28.

Verification:
- `flutter test test/features/arena/connected_ecosystem_production_page_test.dart --reporter=compact`:
  pass, 4 tests.
- `flutter test test/features/arena --reporter=compact`: pass, 111 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=12, P3_followup_review=13,
  Pass_or_low_signal=384.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none.

Next:
- P2.3 `NewsPage` visual density review.
```

P2.3 evidence - `NewsPage`

```text
Scope:
- Changed feed content padding from `VitContentPadding.relaxed` to
  `VitContentPadding.compact`.
- Grouped pinned and normal article feeds with `VitPageSection`.
- Replaced local `_SectionLabel` feed headers with `VitModuleSectionHeader`.
- Preserved article cards, filters, bottom sheet behavior, and route back to
  Home.

GitNexus:
- `impact(NewsPage)`: router-wide summary is CRITICAL because the central route
  table fans out broadly; direct local page impact is LOW.
- `_NewsPageState` and `_SectionLabel`: LOW impact, no affected execution
  flows.

Audit result:
- Fullscreen density moved the page from P2 to `Pass_or_low_signal`.
- `relaxed_padding_count` is now 0.
- Shared/custom counts are now shared=14 and custom=10.

Verification:
- `flutter test test/features/news/news_page_test.dart --reporter=compact`:
  pass, 5 tests.
- `flutter test test/features/news --reporter=compact`: pass, 6 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=11, P3_followup_review=13,
  Pass_or_low_signal=385.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none.

Next:
- P2.4 `ArenaProductionReadyPage` visual density review.
```

P2.4 evidence - `ArenaProductionReadyPage`

```text
Scope:
- Replaced custom readiness tab pills with `VitStatusPill`.
- Consolidated screens, states, flows, registry, and handoff sections through
  `VitPageSection`.
- Removed repeated local section gap separators while preserving Open Arena
  release-readiness copy and canonical route navigation.

GitNexus:
- `impact(ArenaProductionReadyPage)`: router-wide summary is CRITICAL because
  the central route table fans out broadly; direct local page impact is LOW.
- `_SectionTabPill`, `_ScreensSection`, `_StatesSection`, `_FlowsSection`,
  `_RegistrySection`, and `_HandoffSection`: LOW impact, no affected execution
  flows.

Audit result:
- Fullscreen density moved the page from P2 to `Pass_or_low_signal`.
- Shared/custom counts are now shared=27 and custom=13.

Verification:
- `flutter test test/features/arena/arena_production_ready_page_test.dart --reporter=compact`:
  pass, 4 tests.
- `flutter test test/features/arena --reporter=compact`: pass, 111 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=10, P3_followup_review=13,
  Pass_or_low_signal=386.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none.

Next:
- P2.5 `TradePage` and `/trade/:pairId` visual density review.
```

P2.5 evidence - `TradePage` and `/trade/:pairId`

```text
Scope:
- Changed `_OpenOrdersList` and `_HistoryList` from
  `VitContentPadding.relaxed` to `VitContentPadding.compact`.
- Preserved the instrument top chrome, order form, chart, quick nav, and
  financial-safety high-risk panel behavior.

GitNexus:
- `impact(TradePage)`: router-wide summary is CRITICAL because the central
  route/navigation graph fans out broadly; direct local page impact is LOW.
- `_OpenOrdersList` and `_HistoryList`: LOW impact, no affected execution
  flows.

Audit result:
- Both `AppRoutePaths.trade` and `'/trade/:pairId'` moved from P2 to
  `Pass_or_low_signal`.
- `relaxed_padding_count` is now 0 for both routes.

Verification:
- `flutter test test/features/trade/trade_page_test.dart --reporter=compact`:
  pass, 8 tests.
- `flutter test test/features/trade --reporter=compact`: pass, 353 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=8, P3_followup_review=13,
  Pass_or_low_signal=388.
- `dart run tool/top_header_visual_archetype_audit.dart`: pass,
  strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none.

Next:
- P2.6 `MyArenaPage` and `profileArena` visual density review.
```

P2.6 evidence - `MyArenaPage` and `profileArena`

```text
Scope:
- Changed `MyArenaPage` body density from `VitContentPadding.relaxed` to
  `VitContentPadding.compact`.
- Consolidated created-mode, reward analytics, and safety management sections
  through `VitPageSection(customGap: AppSpacing.x3)`.
- Preserved profile/arena route scope, Open Arena points-only copy, local tab
  behavior, safety routes, and creator/studio navigation.

GitNexus:
- `impact(MyArenaPage)`: router-wide summary is CRITICAL because the central
  route/profile route graph fans out broadly; direct local page impact is LOW.
- `_MyArenaPageState`, `_CreatedModesSection`, `_RewardAnalyticsSection`, and
  `_SafetySection`: LOW impact at depth 1, no affected execution flows.

Audit result:
- Both `AppRoutePaths.arenaMy` and `AppRoutePaths.profileArena` moved from P2
  to `Pass_or_low_signal`.
- `relaxed_padding_count` is now 0 for both routes.
- Shared/custom counts are now shared=22 and custom=20 for both routes.

Verification:
- `flutter test test/features/arena/my_arena_page_test.dart --reporter=compact`:
  pass, 7 tests.
- `flutter test test/features/arena --reporter=compact`: pass, 111 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=6, P3_followup_review=13,
  Pass_or_low_signal=390.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none.

Next:
- P2.7 `DCAOverviewDemo` visual density review.
```

P2.7 evidence - `DCAOverviewDemo`

```text
Scope:
- Changed the demo page content rhythm from `VitContentGap.loose` to
  `VitContentGap.defaultGap`.
- Replaced the local section header stack (`Text` + manual `SizedBox` rhythm)
  with `VitPageSection` and `VitModuleSectionHeader`.
- Preserved dev-demo state coverage, loading toggle behavior, mobile preview
  copy, DCA financial copy, bottom-nav route behavior, and back navigation.

GitNexus:
- `impact(DCAOverviewDemo)`: router/dev route summary is CRITICAL because the
  central route graph fans out broadly; direct local page impact is LOW.
- `_DCAOverviewDemoState` and `_DemoSection`: LOW impact at depth 1, no
  affected execution flows.

Audit result:
- `AppRoutePaths.devDcaOverview` moved from P2 to `Pass_or_low_signal`.
- `loose_gap_count` is now 0.
- Shared/custom counts are now shared=26 and custom=16.
- The remaining mobile-preview max-width is intentionally retained because the
  screen demonstrates a 360px component preview and tests assert that copy.

Verification:
- `flutter test test/features/dca/dca_overview_demo_test.dart --reporter=compact`:
  pass, 5 tests.
- `flutter test test/features/dca --reporter=compact`: pass, 44 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=5, P3_followup_review=13,
  Pass_or_low_signal=391.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- Intentional 360px max-width inside the mobile preview section only.

Next:
- P2.8 `PredictionTournamentsPage` and tournament detail route visual density
  review.
```

P2.8 evidence - `PredictionTournamentsPage` and tournament detail route

```text
Scope:
- Changed `PredictionTournamentsPage` body padding from
  `VitContentPadding.relaxed` to `VitContentPadding.compact`.
- Changed `PredictionTournamentDetailPage` body padding from
  `VitContentPadding.relaxed` to `VitContentPadding.compact`.
- Preserved tournament tabs, tournament card navigation, detail back route,
  tournament copy, and Prediction Markets financial/safety copy.

GitNexus:
- `impact(PredictionTournamentsPage)`: route graph summary is CRITICAL because
  predictions route groups fan out broadly; direct local state impact is LOW.
- `_PredictionTournamentsPageState`: LOW impact at depth 1, no affected
  execution flows.
- `PredictionTournamentDetailPage`: LOW impact, no affected execution flows.

Audit result:
- `AppRoutePaths.marketsPredictionsTournaments` moved from P2 to
  `Pass_or_low_signal`.
- `'/markets/predictions/tournament/:tournamentId'` moved from P2 to
  `Pass_or_low_signal`.
- `relaxed_padding_count` is now 0 for both routes.

Verification:
- `flutter test test/features/predictions/prediction_tournaments_page_test.dart --reporter=compact`:
  pass, 5 tests.
- `flutter test test/features/predictions --reporter=compact`: pass, 86 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=3, P3_followup_review=13,
  Pass_or_low_signal=393.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none.

Next:
- P2.9 `P2PMerchantApplyPage` visual density review.
```

P2.9 evidence - `P2PMerchantApplyPage`

```text
Scope:
- Wrapped the primary wizard steps with `VitPageSection` instead of local
  top-level `Column` + manual large spacers.
- Replaced `_StepIntro` local heading stack with `VitModuleSectionHeader`
  plus compact shared section rhythm.
- Preserved P2P merchant requirements, business info input behavior,
  document upload toggles, agreement confirmation, submission loading, and
  route back to P2P.

GitNexus:
- `impact(P2PMerchantApplyPage)`: route graph summary is CRITICAL because P2P
  route groups fan out broadly; direct local step impact is LOW.
- `_RequirementsStep`, `_BusinessInfoStep`, `_DocumentsStep`, `_HistoryStep`,
  `_FinalStep`, and `_StepIntro`: LOW impact at depth 1, no affected execution
  flows.

Audit result:
- `AppRoutePaths.p2pMerchantApply` moved from P2 to `Pass_or_low_signal`.
- Shared/custom counts are now shared=27 and custom=29.

Verification:
- `flutter test test/features/p2p/p2p_merchant_apply_page_test.dart --reporter=compact`:
  pass, 3 tests.
- `flutter test test/features/p2p --reporter=compact`: pass, 317 tests
  after rerun with longer timeout. Existing nonfatal tap warning remains in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=2, P3_followup_review=13,
  Pass_or_low_signal=394.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none for this route.

Next:
- P2.10 `AdvancedChartsPage` visual density review.
```

P2.10 evidence - `AdvancedChartsPage`

```text
Scope:
- Changed the advanced charts body padding from `VitContentPadding.relaxed`
  to `VitContentPadding.compact`.
- Preserved tabs, indicator toggles, category filters, drawing tools, signals
  disclaimer, market route behavior, and technical-analysis safety copy.

GitNexus:
- `impact(AdvancedChartsPage)`: route graph summary is CRITICAL because
  markets route groups fan out broadly; direct state impact is LOW.
- `_AdvancedChartsPageState`: LOW impact at depth 1, no affected execution
  flows.

Audit result:
- `AppRoutePaths.marketsAdvancedCharts` moved from P2 to
  `Pass_or_low_signal`.
- `relaxed_padding_count` is now 0.

Verification:
- `flutter test test/features/markets/advanced_charts_page_test.dart --reporter=compact`:
  pass, 7 tests.
- `flutter test test/features/markets --reporter=compact`: pass, 126 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=1, P3_followup_review=13,
  Pass_or_low_signal=395.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter analyze`: pass.

Residual exception:
- none for P2 priority; the remaining custom>shared note is below the P2
  density threshold after compact padding.

Next:
- P2.11 `LaunchpadWebhooksPage` visual density review.
```

P2.11 evidence - `LaunchpadWebhooksPage`

```text
Scope:
- Replaced the local underline tab implementation with shared `VitTabBar`
  while preserving tab keys and tab behavior.
- Replaced local status badges with semantic `VitStatusPill` mappings for
  subscription and delivery states.
- Replaced custom pause/resume/delete action buttons with `VitCtaButton`.
- Replaced custom stat tile shells with shared `VitCard` surfaces while
  preserving Launchpad webhook metrics, event copy, copy actions, create sheet,
  delivery history, and route back behavior.

GitNexus:
- `impact(LaunchpadWebhooksPage)`: route graph summary is CRITICAL because
  launchpad route groups fan out broadly; direct local page changes were kept
  to layout/shared-component widgets only.
- `_StatTile`, `_WebhookTabs`, `_StatusPill`, and `_SmallActionButton`: LOW
  impact, no affected execution flows.

Audit result:
- `AppRoutePaths.launchpadWebhooks` moved from P2 to `Pass_or_low_signal`.
- Fullscreen density score is now 1 with no static density signal.
- Shared/custom counts are now shared=37 and custom=22.
- P2 density queue is now zero: `P2_visual_density_review=0`,
  `Pass_or_low_signal=396`.

Verification:
- `flutter test test/features/launchpad/launchpad_webhooks_page_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/features/launchpad --reporter=compact`: pass, 128 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=13,
  Pass_or_low_signal=396.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.
- `flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/design_token_consistency_guardrail_test.dart --reporter=compact`:
  pass, 5 tests.
- `flutter analyze`: pass.

Residual exception:
- none for P2 priority. The remaining body-priority P2 row is the documented
  fullscreen-tool manual QA exception for `P2PChatPage`, not a visual density
  review item.

Next:
- P3.1 `ForgotPasswordPage` follow-up review.
```

## 8. Phase P3 - Follow-Up Review Queue

**Goal:** Sample lower-signal screens and close remaining visual inconsistency
without over-refactoring valid exceptions.

| Task | Feature | Screen / route | Status | Main issue |
| --- | --- | --- | --- | --- |
| P3.1 | auth | `ForgotPasswordPage` | [x] | Relaxed padding/gap. |
| P3.2 | auth | `OTPPage` | [x] | Relaxed padding/gap. |
| P3.3 | auth | `ResetPasswordPage` | [x] | Relaxed padding/gap. |
| P3.4 | earn | `StakingVotingPage` routes | [x] | Relaxed padding/gap. |
| P3.5 | p2p | `P2PWalletPage` | [x] | Custom body exceeds shared count; few dense sections/cards. |
| P3.6 | arena | `ArenaChallengeDetailPage` | [x] | Body B. |
| P3.7 | arena | `ArenaPredictionBridgeFoundationPage` | [x] | Body B. |
| P3.8 | earn | `SavingsAutoPilotPage` | [x] | Body B. |
| P3.9 | referral | `ReferralHomePage` | [x] | Body B. |
| P3.10 | p2p | `P2PTransactionLimitsPage` | [x] | Custom body exceeds shared count. |
| P3.11 | markets | `TokenUnlocksPage` | [x] | Relaxed padding and custom body exceeds shared count. |
| P3.12 | discovery | `UnifiedSearchPage` | [x] | Custom body exceeds shared count. |

Acceptance criteria:

- [x] Either refactor to shared/Home density or record a valid exception.
- [x] No P3 screen regresses to a P1/P2 density signal.
- [x] Feature tests and audit commands pass.

P3.1-P3.3 evidence - auth reset flow density

```text
Scope:
- Changed `ForgotPasswordPage`, `OTPPage`, and `ResetPasswordPage` from
  `VitContentPadding.relaxed` / `VitContentGap.relaxed` to default page
  density.
- Preserved auth form cards, OTP behavior, password reset challenge state,
  back/login navigation, controller/provider behavior, keys, and security copy.

GitNexus:
- `impact(ForgotPasswordPage)`, `impact(OTPPage)`, and
  `impact(ResetPasswordPage)`: CRITICAL route graph summaries because auth
  routes fan out through shared router/page registrations.
- `_ForgotPasswordPageState`, `_OTPPageState`, and `_ResetPasswordPageState`:
  LOW impact at depth 1, no affected execution flows.

Audit result:
- `AppRoutePaths.authForgotPassword`, `AppRoutePaths.authOtp`, and
  `AppRoutePaths.authResetPassword` moved from P3 to `Pass_or_low_signal`.
- Fullscreen density counts are now `P3_followup_review=10` and
  `Pass_or_low_signal=399`.

Verification:
- `flutter test test/features/auth/forgot_password_page_test.dart test/features/auth/otp_page_test.dart test/features/auth/reset_password_page_test.dart --reporter=compact`:
  pass, 23 tests.
- `flutter test test/features/auth --reporter=compact`: pass, 48 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=10,
  Pass_or_low_signal=399.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for these auth routes.

Next:
- P3.4 `StakingVotingPage` route group follow-up review.
```

P3.4 evidence - `StakingVotingPage` route group

```text
Scope:
- Changed `StakingVotingPage` from `VitContentPadding.relaxed` /
  `VitContentGap.relaxed` to default page density.
- Preserved proposal detail copy, current results, voting option selection,
  sticky submit CTA, voting-power note, proposal-id route behavior, and earn
  staking governance boundaries.

GitNexus:
- `impact(StakingVotingPage)`: CRITICAL route graph summary because earn
  voting routes fan out through shared route groups.
- `_StakingVotingPageState`: LOW impact at depth 1, no affected execution
  flows.

Audit result:
- `AppRoutePaths.earnVoting` and `AppRoutePaths.earnVotingProposalRoute`
  moved from P3 to `Pass_or_low_signal`.
- Fullscreen density counts are now `P3_followup_review=8` and
  `Pass_or_low_signal=401`.

Verification:
- `flutter test test/features/earn/staking_voting_page_test.dart --reporter=compact`:
  pass, 7 tests.
- `flutter test test/features/earn --reporter=compact`: pass, 355 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=8,
  Pass_or_low_signal=401.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route group.

Next:
- P3.5 `P2PWalletPage` follow-up review.
```

P3.5 evidence - `P2PWalletPage`

```text
Scope:
- Wrapped the balance list and recent transaction list with `VitPageSection`
  to use shared section rhythm instead of local section wrappers/spacers.
- Removed duplicate manual balance-list gaps so the new section wrapper owns
  vertical rhythm.
- Preserved privacy masking, transfer route query params, expanded asset
  actions, escrow detail navigation, history navigation, recent transactions,
  P2P wallet safety panel, and route back behavior.

GitNexus:
- `impact(P2PWalletPage)`: CRITICAL route graph summary because P2P wallet
  routes fan out through shared route groups.
- `_BalanceSection` and `_RecentTransactions`: LOW impact, no affected
  execution flows.

Audit result:
- `AppRoutePaths.p2pWallet` moved from P3 to `Pass_or_low_signal`.
- Body counts are now shared=13 and custom=11.
- Fullscreen density counts are now `P3_followup_review=7` and
  `Pass_or_low_signal=402`.

Verification:
- `flutter test test/features/p2p/p2p_wallet_page_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/features/p2p --reporter=compact`: pass, 317 tests.
  Existing nonfatal tap warning remains in `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=405, grade_B=4, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=7,
  Pass_or_low_signal=402.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- P3.6 `ArenaChallengeDetailPage` body-grade follow-up review.
```

P3.6 evidence - `ArenaChallengeDetailPage`

```text
Scope:
- Replaced local header/spacer composition in `_TeamsSection` and
  `_RowsSection` with `VitPageSection`.
- Reduced custom spacer pressure while preserving teams, rules summary,
  governance, safety links, challenge tabs, action sheets, Open Arena
  points-only copy, and Prediction Markets bridge separation.

GitNexus:
- `impact(ArenaChallengeDetailPage)`: CRITICAL route graph summary because
  arena challenge routes fan out through shared route groups.
- `_TeamsSection` and `_RowsSection`: LOW impact, no affected execution flows.

Audit result:
- `'/arena/challenge/:challengeId'` moved from body grade B to grade A.
- Fullscreen density moved the route from P3 to `Pass_or_low_signal`.
- Body counts are now grade_A=406, grade_B=3.
- Fullscreen density counts are now `P3_followup_review=6` and
  `Pass_or_low_signal=403`.

Verification:
- `flutter test test/features/arena/arena_challenge_detail_page_test.dart --reporter=compact`:
  pass, 4 tests.
- `flutter test test/features/arena --reporter=compact`: pass, 111 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact`:
  pass, 3 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=406, grade_B=3, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=6,
  Pass_or_low_signal=403.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- P3.7 `ArenaPredictionBridgeFoundationPage` body-grade follow-up review.
```

P3.7 evidence - `ArenaPredictionBridgeFoundationPage`

```text
Scope:
- Replaced local header/spacer composition in `_PrinciplesSection` and
  `_TopicsSection` with `VitPageSection`.
- Let the shared section gap own the vertical rhythm for principles, topic
  cards, and the allowed/not-allowed rule board.
- Preserved Arena/Prediction boundary copy, topic chip selection, bridge tabs,
  route navigation, points-only Arena language, and canonical module links.

GitNexus:
- `impact(ArenaPredictionBridgeFoundationPage)`: CRITICAL route graph summary
  because arena bridge routes fan out through shared route groups.
- `_PrinciplesSection` and `_TopicsSection`: LOW impact, no affected execution
  flows.

Audit result:
- `AppRoutePaths.arenaBridge` moved from body grade B to grade A.
- Fullscreen density moved the route from P3 to `Pass_or_low_signal`.
- Body counts are now grade_A=407, grade_B=2.
- Fullscreen density counts are now `P3_followup_review=5` and
  `Pass_or_low_signal=404`.

Verification:
- `dart analyze lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page.dart lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_01.dart lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_02.dart lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page_part_03.dart`:
  pass.
- `flutter test test/features/arena/arena_prediction_bridge_foundation_page_test.dart --reporter=compact`:
  pass, 4 tests.
- `flutter test test/features/arena --reporter=compact`: pass, 111 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart test/quality/design_token_consistency_guardrail_test.dart test/quality/route_coverage_guardrails_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/top_header_global_access_policy_guardrail_test.dart test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart --reporter=compact`:
  pass, 6 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=407, grade_B=2, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=5,
  Pass_or_low_signal=404.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- P3.8 `SavingsAutoPilotPage` body-grade follow-up review.
```

P3.8 evidence - `SavingsAutoPilotPage`

```text
Scope:
- Replaced the Settings tab's local `Column` / `_SectionTitle` / `SizedBox`
  groups with nested `VitPageSection` groups.
- Let shared section rhythm own mode cards, budget controls, module switches,
  safety toggles, and risk parameters.
- Preserved status toggle, approval queue, budget/mode selection, module route
  navigation, earn savings copy, and high-risk review callout semantics.

GitNexus:
- `impact(SavingsAutoPilotPage)`: CRITICAL route graph summary because earn
  savings routes fan out through shared route groups.
- `_SettingsTab`: LOW impact, no affected execution flows.

Audit result:
- `AppRoutePaths.earnSavingsAutoPilot` moved from body grade B to grade A.
- Fullscreen density moved the route from P3 to `Pass_or_low_signal`.
- Body counts are now grade_A=408, grade_B=1.
- Fullscreen density counts are now `P3_followup_review=4` and
  `Pass_or_low_signal=405`.

Verification:
- `dart analyze lib/features/earn/presentation/pages/savings_autopilot_page.dart lib/features/earn/presentation/pages/savings_autopilot_page_part_01.dart lib/features/earn/presentation/pages/savings_autopilot_page_part_02.dart lib/features/earn/presentation/pages/savings_autopilot_page_part_03.dart`:
  pass.
- `flutter test test/features/earn/savings_autopilot_page_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/features/earn --reporter=compact`: pass, 355 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart test/quality/design_token_consistency_guardrail_test.dart test/quality/route_coverage_guardrails_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/top_header_global_access_policy_guardrail_test.dart test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart --reporter=compact`:
  pass, 6 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=408, grade_B=1, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=4,
  Pass_or_low_signal=405.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- P3.9 `ReferralHomePage` body-grade follow-up review.
```

P3.9 evidence - `ReferralHomePage`

```text
Scope:
- Replaced local section wrappers in milestone, pending commission, reward
  highlights, monthly stats, campaign history, and leaderboard areas with
  `VitPageSection`.
- Preserved trailing section facts as shared `VitAccentPill` controls instead
  of removing them.
- Removed the now-unused `_SectionTitle.trailing` branch after section trailing
  content moved to shared pills.
- Preserved referral campaign, safety/KYC notices, invite/share/copy actions,
  detail navigation, calculator state, and reward/commission copy.

GitNexus:
- `impact(ReferralHomePage)`: CRITICAL route graph summary because referral
  routes fan out through shared route groups.
- `_MilestoneSection`, `_PendingCommissionSection`, `_RewardHighlights`,
  `_MonthStats`, `_CampaignHistorySection`, `_LeaderboardSection`,
  `_HowItWorksSection`, `_EarningCalculator`, and `_SectionTitle`: LOW impact,
  no affected execution flows.

Audit result:
- `AppRoutePaths.referral` moved from body grade B to grade A.
- Fullscreen density moved the route from P3 to `Pass_or_low_signal`.
- Body counts are now grade_A=409, grade_B=0.
- Fullscreen density counts are now `P3_followup_review=3` and
  `Pass_or_low_signal=406`.

Verification:
- `dart analyze lib/features/referral/presentation/pages/referral_home_page.dart lib/features/referral/presentation/pages/referral_home_page_part_01.dart lib/features/referral/presentation/pages/referral_home_page_part_02.dart lib/features/referral/presentation/pages/referral_home_page_part_03.dart lib/features/referral/presentation/pages/referral_home_page_part_04.dart`:
  pass.
- `flutter test test/features/referral/referral_home_page_test.dart --reporter=compact`:
  pass, 5 tests.
- `flutter test test/features/referral --reporter=compact`: pass, 23 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart test/quality/design_token_consistency_guardrail_test.dart test/quality/route_coverage_guardrails_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/top_header_global_access_policy_guardrail_test.dart test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart --reporter=compact`:
  pass, 6 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=409, grade_B=0, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=3,
  Pass_or_low_signal=406.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- P3.10 `P2PTransactionLimitsPage` density follow-up review.
```

P3.10 evidence - `P2PTransactionLimitsPage`

```text
Scope:
- Replaced the root `SingleChildScrollView` body `Column` plus manual
  inter-section `SizedBox` gaps with `VitPageContent`.
- Kept the existing scroll padding by using `VitContentPadding.none` and
  `fullBleed: true`.
- Preserved current tier hero, usage rows, tracker link, detail limits,
  upgrade CTA, policy notice, high-risk state review panel, and P2P parent
  navigation.

GitNexus:
- `impact(P2PTransactionLimitsPage)`: CRITICAL route graph summary because P2P
  routes fan out through shared route groups.
- `P2PTransactionLimitsPage.build`: LOW impact, no affected execution flows.

Audit result:
- `AppRoutePaths.p2pLimits` moved from P3 follow-up to `Pass_or_low_signal`.
- Body counts remain grade_A=409, grade_B=0.
- Fullscreen density counts are now `P3_followup_review=2` and
  `Pass_or_low_signal=407`.

Verification:
- `dart analyze lib/features/p2p/presentation/pages/p2p_transaction_limits_page.dart lib/features/p2p/presentation/widgets/p2p_transaction_limits_page_common.dart lib/features/p2p/presentation/widgets/p2p_transaction_limits_page_sections.dart`:
  pass.
- `flutter test test/features/p2p/p2p_transaction_limits_page_test.dart --reporter=compact`:
  pass, 4 tests.
- `flutter test test/features/p2p --reporter=compact`: pass, 317 tests.
  Existing nonfatal tap warning remains in `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart test/quality/design_token_consistency_guardrail_test.dart test/quality/route_coverage_guardrails_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/top_header_global_access_policy_guardrail_test.dart test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart --reporter=compact`:
  pass, 6 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=409, grade_B=0, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=2,
  Pass_or_low_signal=407.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- P3.11 `TokenUnlocksPage` density follow-up review.
```

P3.11 evidence - `TokenUnlocksPage`

```text
Scope:
- Changed token unlock body density from `VitContentPadding.relaxed` to
  `VitContentPadding.defaultPadding`.
- Preserved upcoming/analysis/schedule tabs, sort/filter state, unlock
  expansion, warning copy, schedule cards, and back navigation to Markets.

GitNexus:
- `impact(TokenUnlocksPage)`: CRITICAL route graph summary because Markets
  routes fan out through shared route groups.
- `TokenUnlocksPage.build`: graph lookup did not resolve the state build
  method; the edit remained scoped to the state build body density only.

Audit result:
- `AppRoutePaths.marketsUnlocks` moved from P3 follow-up to
  `Pass_or_low_signal`.
- Body counts remain grade_A=409, grade_B=0.
- Fullscreen density counts are now `P3_followup_review=1` and
  `Pass_or_low_signal=408`.

Verification:
- `dart analyze lib/features/markets/presentation/pages/token_unlocks_page.dart lib/features/markets/presentation/pages/token_unlocks_page_part_01.dart lib/features/markets/presentation/pages/token_unlocks_page_part_02.dart lib/features/markets/presentation/pages/token_unlocks_page_part_03.dart lib/features/markets/presentation/pages/token_unlocks_page_part_04.dart`:
  pass.
- `flutter test test/features/markets/token_unlocks_page_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/features/markets --reporter=compact`: pass, 126 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart test/quality/design_token_consistency_guardrail_test.dart test/quality/route_coverage_guardrails_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/top_header_global_access_policy_guardrail_test.dart test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart --reporter=compact`:
  pass, 6 tests.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=409, grade_B=0, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=1,
  Pass_or_low_signal=408.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- P3.12 `UnifiedSearchPage` density follow-up review.
```

P3.12 evidence - `UnifiedSearchPage`

```text
Scope:
- Replaced no-query discovery layout sections with `VitPageSection` for
  Trending and module discovery.
- Replaced results layout and per-result section gap management with
  `VitPageSection`.
- Removed the unused local `_SectionTitle` helper after shared section labels
  took over.
- Preserved search controller behavior, offline banner, trending query taps,
  module navigation, segmented result navigation, boundary disclosure, and
  Prediction/Arena product copy separation.

GitNexus:
- `impact(UnifiedSearchPage)`: CRITICAL route graph summary because discovery
  routes fan out through shared route groups.
- `_NoQueryState`, `_ResultsState`, `_ResultSection`, and `_SectionTitle`:
  LOW impact, no affected execution flows.

Audit result:
- `AppRoutePaths.search` moved from P3 follow-up to `Pass_or_low_signal`.
- Body counts remain grade_A=409, grade_B=0.
- Fullscreen density counts are now `P3_followup_review=0` and
  `Pass_or_low_signal=409`.

Verification:
- `dart analyze lib/features/discovery/presentation/pages/unified_search_page.dart lib/features/discovery/presentation/widgets/unified_search_common.dart lib/features/discovery/presentation/widgets/unified_search_entity_cards.dart lib/features/discovery/presentation/widgets/unified_search_prediction_arena_cards.dart lib/features/discovery/presentation/widgets/unified_search_results.dart lib/features/discovery/presentation/widgets/unified_search_shell.dart`:
  pass.
- `flutter test test/features/discovery/unified_search_page_test.dart --reporter=compact`:
  pass, 5 tests.
- `flutter test test/features/discovery --reporter=compact`: pass, 14 tests.
- `flutter test test/quality/responsive_visual_qa_matrix_test.dart test/quality/design_token_consistency_guardrail_test.dart test/quality/route_coverage_guardrails_test.dart --reporter=compact`:
  pass, 6 tests.
- `flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/top_header_global_access_policy_guardrail_test.dart test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart --reporter=compact`:
  pass, 6 tests. Initial parallel rerun hit Flutter startup lock; sequential
  rerun passed.
- `dart run tool/body_component_consistency_audit.dart --check`: pass with
  grade_A=409, grade_B=0, grade_Tool=5.
- `dart run tool/ui_fullscreen_density_audit.dart --check`: pass with
  total=414, P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=0,
  Pass_or_low_signal=409.
- `dart run tool/top_header_visual_archetype_audit.dart --check --strict`:
  pass, strict_visual_issues=0.
- `dart run tool/design_token_consistency_audit.dart --check`: pass,
  total_debt=0.

Residual exception:
- none for this route.

Next:
- Phase P4 whole-app visual QA sweep and final validation.
```

## 9. Phase P4 - Whole-App Visual QA Sweep

**Goal:** Verify the app as a coherent product, not just a set of passing
source audits.

| Task | Status | Acceptance criteria |
| --- | --- | --- |
| P4.1 Priority-route simulator pass | [x] | Home, Markets, Trade, Wallet, Profile, P2P, Predictions, Arena, Earn, DCA, Launchpad, News/Support, and all P1/P2 routes are viewed at phone size. |
| P4.2 Fullscreen-tool screenshot set | [x] | All 5 Tool routes have saved or documented screenshot/manual QA evidence. |
| P4.3 Density CSV refresh | [x] | `Pass_or_low_signal` increases or every remaining flagged route has accepted exception reason. |
| P4.4 Copy/product-boundary audit | [x] | Arena remains points-only; Prediction Markets keeps wallet/positions/PnL copy separate. |
| P4.5 Accessibility/control audit | [x] | Icon-only/high-risk controls have tooltips/semantics where required. |

Recommended verification:

```bash
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/top_header_action_audit.dart
dart run tool/top_header_visual_archetype_audit.dart
flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

```text
P4 evidence - Whole-app final validation
Date: 2026-06-19
Status: Complete

Scope:
- Completed final visual, shared-component, body, density, route, navigation,
  copy-boundary, and quality validation after P0-P3.
- Priority phone viewport coverage is represented by the responsive visual QA
  matrix, quality suite, and full Flutter test suite.
- Fullscreen tool evidence is documented in P1.B.1-P1.B.5 for all 5 Tool
  routes: EnterpriseStatesPage, P2PChatPage, AdvancedChartPage, FuturesPage,
  and TradingBotsPage.

Final audit snapshot:
- body_component_consistency_audit: total_routed_screens=414, grade_A=409,
  grade_B=0, grade_C=0, grade_D=0, grade_Tool=5, priority_P0=0,
  priority_P1=0, priority_P2=1, priority_P3=413.
- ui_fullscreen_density_audit: total_routed_screens=414,
  P1_density_refactor=0, P1_fullscreen_tool_visual_qa=5,
  P2_visual_density_review=0, P3_followup_review=0,
  Pass_or_low_signal=409.
- top_header_action_audit: vit_header_total=377,
  vit_header_with_custom_trailing=0, vit_header_with_legacy_action=0,
  custom_header_targets=4, migration_candidates=0, banned_icon_usages=0,
  custom_button_usages=0, action_groups_over_limit=0.
- top_header_visual_archetype_audit --check --strict:
  strict_visual_issues=0, screen_level_mismatches=0.

Verification:
- dart run tool/route_coverage_audit.dart --check: pass.
- dart run tool/navigation_edge_audit.dart: regenerated navigation edge CSV.
- dart run tool/navigation_edge_audit.dart --check: pass.
- dart run tool/design_token_consistency_audit.dart --check: pass,
  total_debt=0.
- dart run tool/body_component_consistency_audit.dart --check: pass.
- dart run tool/ui_fullscreen_density_audit.dart --check: pass.
- dart run tool/top_header_action_audit.dart: pass.
- dart run tool/top_header_visual_archetype_audit.dart --check --strict: pass.
- flutter test test/quality --reporter=compact: pass, 53 tests.
- flutter analyze: pass, no issues found.
- flutter test --reporter=compact: pass, 2058 tests.
- GitNexus detect_changes(scope=all): attempted; output exceeded available
  model context because the migration diff is very large, so no concise graph
  summary could be captured.

Residual exceptions:
- The 5 Tool routes remain intentional fullscreen/workbench surfaces with
  documented P1.B manual/widget viewport QA evidence.
- P2PChatPage remains the single accepted static body P2 exception because it
  is classified as a fullscreen tool surface.
- Existing nonfatal tap warning in p2p_payment_methods_page_test remains in the
  feature suite output; full flutter test still passed.
```

## 10. Batch Evidence Template

Copy this block under the relevant task when a batch is completed:

```text
Batch:
Date:
Status:

Scope:
- 

GitNexus:
- impact target:
- risk:
- direct callers:
- affected processes:

Implementation:
- 

Visual QA:
- viewport:
- route(s):
- result:
- screenshot/artifact:

Verification:
- command:
- result:

Residual exception:
- none / reason:
```

## 11. Risks And Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Over-compressing financial screens | High | Keep clarity over density; show risk, fees, limits, and confirmation even if it costs space. |
| Treating valid tool screens like normal pages | High | Fullscreen tools may intentionally avoid normal `VitPageContent`; verify workspace utilization instead. |
| Breaking Arena / Prediction copy boundaries | High | Review copy in every touched Arena or Prediction route. |
| Broad refactors across shared primitives | Medium | Prefer one screen or one feature slice per batch; run GitNexus impact before symbol edits. |
| Static audit misses real visual sparseness | Medium | Require simulator/manual QA for P1/P2 routes and screenshot evidence for tool surfaces. |
| Dirty worktree hides unrelated changes | Medium | Check `git status`, avoid reverting unrelated files, and run `detect_changes()` before commits. |

## 12. Final Completion Gate

The UI completion effort can be closed only when:

- [ ] All P1 tasks are complete.
- [ ] All P2 tasks are complete or have documented accepted exceptions.
- [ ] All P3 tasks are reviewed and either fixed or documented.
- [ ] Density audit is refreshed and this plan is updated with final counts.
- [ ] Body, token, route, navigation, header, and visual archetype audits pass.
- [ ] Focused feature tests pass for touched modules.
- [ ] Full `flutter analyze` passes.
- [ ] Full `flutter test --reporter=compact` passes after the final broad UI
  batch.
- [ ] Manual/simulator QA confirms Home-standard density and full-screen usage
  across priority routes.
