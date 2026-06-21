# VitTrade Enterprise-Grade UI Standardization Plan

**Created:** 2026-06-21  
**Status:** Active execution plan  
**Scope:** All routed Flutter screens, shared layout primitives, shared widgets,
theme tokens, first-viewport density, and manual tool-surface QA.  
**Goal:** Make VitTrade feel like one coherent Flutter enterprise-grade product:
consistent dark financial UI, consistent spacing and sizing, consistent cards and
surfaces, phone-first density, and no missed routes.

This plan is the current coordination file for the next AI implementation pass.
It is based on the 2026-06-21 audit snapshot generated from current Flutter
source and repo audit tools. When this plan conflicts with older "complete"
tracking notes, use this file plus the current audit artifacts as the working
truth for the new standardization pass.

## 1. Source Of Truth

Use these sources in this order:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
4. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
5. Current Flutter source under `flutter_app/lib/`
6. Current Flutter tests under `flutter_app/test/`
7. `docs/03_DESIGN_SYSTEM/Guidelines.md`
8. `docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`
9. This plan
10. Current audit artifacts listed below

Current audit artifacts:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
flutter_app/run-artifacts/ui-ux-current-page-audit.md
```

The merged page-by-page report above is a convenience artifact. If it is missing
or stale, regenerate it from the four CSV artifacts before continuing. Every AI
batch must still use the CSVs and source files as the final truth.

## 2. Current Baseline Snapshot

Audit date: 2026-06-21.

| Metric | Current |
| --- | ---: |
| Routed screens audited | 414 |
| Body component grade A | 404 |
| Body component grade B | 5 |
| Fullscreen/tool manual QA screens | 5 |
| Visual density `P1_TOOL_VISUAL_QA` | 5 |
| Visual density `P2_MEDIUM_DENSITY_REVIEW` | 1 |
| Visual density `P3_LOW_DENSITY_REVIEW` | 194 |
| Visual density `PASS_MONITOR` | 214 |
| Design-token total debt | 1557 |
| Root page bundle design-token debt | 663 |
| Typography debt | 0 |

Interpretation:

- The app is structurally close to the shared component system.
- Header/chrome and typography are mostly healthy.
- The remaining visual inconsistency is mainly spacing, line-height, fixed
  height pressure, bottom inset pressure, and surface/card treatment drift.
- User-visible inconsistency is real even when body grade is A, because screens
  can use shared components but still feel sparse, overly padded, or differently
  sized.

## 3. Enterprise-Grade UI Definition

VitTrade enterprise-grade UI means:

- Home is the visual baseline for app chrome, dark surface treatment, card
  rhythm, bottom navigation, compact financial density, and primary brand use.
- Module identity is an accent layer only. Do not create module-specific page
  backgrounds, card palettes, bottom-nav colors, spacing systems, or typography
  systems.
- All screens use shared primitives first:
  `VitPageLayout`, `VitPageContent`, `VitInsetScrollView`,
  `VitAutoHideHeaderScaffold`, `VitHeader`, `VitTopChrome`, `VitBottomNav`,
  `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`, `VitSectionHeader`,
  `VitStatusPill`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`,
  `VitSkeleton`, `VitDiscoveryActionCard`, `VitMarketPairRow`,
  `VitRankedAssetRow`, `VitSparkline`, and `VitHighRiskStatePanel`.
- Use `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadii`,
  `AppModuleAccents`, and density tokens. Do not add raw local colors, spacing,
  radii, fixed sizes, or typography.
- Phone-first at 360 px and up. The first viewport must show useful content,
  not mostly chrome, hero space, blank gaps, or bottom-nav padding.
- High-risk financial flows preserve preview, confirmation, risk, fees, limits,
  masking, success, error, and next steps.
- Open Arena remains points-only. Prediction Markets keeps wallet/value,
  positions, probability, receipts, rewards, and P/L language separate.
- Fullscreen tools remain workspace-first; they are verified by visual QA, not
  compacted like ordinary content pages.

## 4. Non-Negotiable Rules For AI Agents

- Do not edit a Dart function, class, method, shared primitive, route, provider,
  controller, entity, or repository contract without GitNexus upstream impact
  analysis first.
- Warn before editing when impact is HIGH or CRITICAL. Narrow the batch instead
  of broad refactoring.
- Do not skip a routed screen. The `Page-By-Page Inventory` in
  `flutter_app/run-artifacts/ui-ux-current-page-audit.md` must account for all
  414 rows.
- Do not mark a module done because a module summary looks good. Module done
  requires every route row in that module to be fixed, accepted as a documented
  exception, or assigned to monitor-when-touched.
- Do not remove safety copy to improve density.
- Do not replace shared primitives with local compact widgets.
- Do not globally shrink typography.
- Do not introduce new one-off layout constants when an existing token or
  shared density tier can express the intent.
- Do not recreate root React/Vite/web tooling.
- Do not revert unrelated worktree changes.

## 5. Work Ledger Contract

The implementation agent must keep a ledger while working. A row is complete
only when it has one of these statuses:

| Status | Meaning |
| --- | --- |
| `fixed` | Source was changed and verification passed. |
| `accepted_tool_exception` | Fullscreen/tool route has visual QA evidence and should remain non-standard. |
| `accepted_product_exception` | Product/safety/domain reason justifies the remaining static signal. |
| `monitor_when_touched` | Low-risk row is acceptable now, but the checklist must be applied when the screen is touched. |
| `blocked` | Work is blocked after concrete attempts and has a recorded reason. |

Do not remove a row from the ledger. If routes change, regenerate the audit and
update the expected route count.

Quick route-count check:

```powershell
$rows = Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
$rows.Count
# Expected: 414
```

Quick page-by-page inventory check:

```powershell
$report = Get-Content flutter_app/run-artifacts/ui-ux-current-page-audit.md
$idx = [Array]::IndexOf($report, '## Page-By-Page Inventory')
($report[($idx + 4)..($report.Length - 1)] | Where-Object { $_ -like '| * |*' }).Count
# Expected: 414
```

## 6. Module Priority Board

| Priority | Module | Current signal | Reason |
| --- | --- | --- | --- |
| P0 | `p2p` | 77 routes, 30 token-debt pages, 141 token debt, 62 low density, 1 tool | Money movement, escrow, identity, payment, security, widest inconsistency. |
| P0 | `markets` | 22 routes, 11 token-debt pages, 138 token debt | Highest top-page token debt and market data density drift. |
| P0 | `trade` | 91 routes, 50 token-debt pages, 87 token debt, 3 tools, 1 medium density | Trading and tool surfaces must feel professional and workspace-grade. |
| P0 | `wallet` | 21 routes, 13 token-debt pages, 43 token debt, 11 low density | Financial safety and trust surface. |
| P1 | `earn` | 70 routes, 25 token-debt pages, 110 token debt, 45 low density | Broad yield/product surface with many spacing inconsistencies. |
| P1 | `launchpad` | 24 routes, 17 token-debt pages, 45 token debt | Campaign/detail/claim flows need consistent cards and risk copy. |
| P1 | `profile` | 14 routes, 3 B-grade screens, 3 token-debt pages | Account/security surfaces have visible surface consistency issues. |
| P1 | `predictions` | 19 routes, 2 B-grade screens, 5 token-debt pages | Boundary-sensitive Prediction/Arena/value copy. |
| P2 | `arena` | 26 routes, 9 token-debt pages, 40 token debt | Mostly passing density, still token cleanup and points-only protection. |
| P2 | `dca` | 14 routes, 3 token-debt pages, 26 token debt | Recurring-investment density polish. |
| P2 | `auth`, `onboarding`, `notifications`, `support`, `discovery`, `cross_module`, `referral`, `rewards`, `news`, `admin`, `dev`, `enterprise_states`, `home` | Low or monitor signals | Keep in inventory; handle flagged rows and monitor when touched. |

## 7. Top Immediate Screen Queue

Start with these screens because they have the strongest current mismatch
signal. Do not skip GitNexus impact analysis before editing any Dart symbol.

| Order | Page | Module | Main issue |
| ---: | --- | --- | --- |
| 1 | `lib/features/markets/presentation/pages/social_signals_page.dart` | markets | Highest token debt: line-height and spacing drift. |
| 2 | `lib/features/p2p/presentation/pages/p2p_home_page.dart` | p2p | Root command center spacing and first-viewport consistency. |
| 3 | `lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart` | p2p | Insurance card padding/fixed-height drift. |
| 4 | `lib/features/markets/presentation/pages/social_sentiment_page.dart` | markets | Local `EdgeInsets` surface rhythm. |
| 5 | `lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart` | p2p | KYC/identity spacing consistency. |
| 6 | `lib/features/arena/presentation/pages/arena_production_ready_page.dart` | arena | Line-height and `SizedBox` drift. |
| 7 | `lib/features/markets/presentation/pages/advanced_charts_page.dart` | markets | Chart/detail page padding consistency. |
| 8 | `lib/features/arena/presentation/pages/arena_challenge_detail_page.dart` | arena | Challenge detail spacing and copy density. |
| 9 | `lib/features/markets/presentation/pages/market_news_page.dart` | markets | News cards/list padding consistency. |
| 10 | `lib/features/p2p/presentation/pages/p2p_trading_level_page.dart` | p2p | Progress/hero spacing consistency. |
| 11 | `lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart` | earn | Regulatory content line-height/density. |
| 12 | `lib/features/markets/presentation/pages/market_screener_page.dart` | markets | Data/filter density. |
| 13 | `lib/features/wallet/presentation/pages/dust_converter_page.dart` | wallet | Financial utility padding consistency. |
| 14 | `lib/features/earn/presentation/pages/savings_risk_assessment_page.dart` | earn | High-risk/risk-assessment density. |
| 15 | `lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart` | predictions | Prediction list/card padding consistency. |
| 16 | `lib/features/earn/presentation/pages/staking_risk_assessment_page.dart` | earn | Risk-assessment density and line-height. |
| 17 | `lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart` | p2p | Security form spacing. |
| 18 | `lib/features/earn/presentation/pages/savings_recommendations_page.dart` | earn | Recommendation cards density. |
| 19 | `lib/features/earn/presentation/pages/staking_emergency_actions_page.dart` | earn | High-risk action density and safety copy. |
| 20 | `lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart` | p2p | Security settings spacing. |

After this queue, continue by descending `totalDebt` from:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv
```

Filter:

```powershell
Import-Csv docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv |
  Where-Object { $_.scope -eq 'root_page_bundle_summary' -and [int]$_.totalDebt -gt 0 -and $_.exception -eq 'no' } |
  Sort-Object {[int]$_.totalDebt} -Descending
```

## 8. Surface Consistency Queue

These screens are not normal grade A body screens and need explicit handling:

| Page | Route | Action |
| --- | --- | --- |
| `EnterpriseStatesPage` | `AppRoutePaths.enterpriseStates` | Keep as fullscreen/tool only with QA evidence. |
| `P2PChatPage` | `'/p2p/chat/:orderId'` | Keep as fullscreen encrypted chat only with QA evidence. |
| `PredictionEventDetailPage` | `'/markets/predictions/event/:eventId'` | Acceptable now, polish when touching Prediction detail. |
| `PredictionsSearchPage` | `AppRoutePaths.marketsPredictionsSearch` | Normalize primary surfaces to `VitCard` and theme tokens. |
| `ApiManagementPage` | `AppRoutePaths.profileApi` | Normalize account/security surfaces to `VitCard` and tokens. |
| `DeviceManagementPage` | `AppRoutePaths.profileDevices` | Normalize device/security surfaces to `VitCard` and tokens. |
| `EditProfilePage` | `AppRoutePaths.profileEdit` | Normalize form surfaces to shared card/input rhythm. |
| `AdvancedChartPage` | `'/trade/advanced-chart/:pairId'` | Keep as fullscreen chart tool with visual QA evidence. |
| `FuturesPage` | `'/trade/:pairId/futures'` | Keep as trading workspace with visual QA evidence. |
| `TradingBotsPage` | `AppRoutePaths.tradeBots` | Keep as bot workspace with visual QA evidence. |

## 9. Phase Plan

### Phase 0 - Baseline And Ledger Setup

**Goal:** Make sure the next AI cannot miss pages or work from stale docs.

Tasks:

- [ ] Confirm route count is 414.
- [ ] Regenerate stale audit artifacts if any audit reports stale output.
- [ ] Create or refresh a working ledger from the page-by-page inventory.
- [ ] Mark every row as `not_started`, `fixed`, `accepted_tool_exception`,
      `accepted_product_exception`, `monitor_when_touched`, or `blocked`.
- [ ] Record the current module summary before editing.

Verification:

```bash
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
```

Exit criteria:

- [ ] All audit artifacts are current.
- [ ] The ledger contains 414 routed screen rows.
- [ ] The next batch is selected from the highest-priority open row.

### Phase 1 - Shared Standard Lock

**Goal:** Prevent new inconsistency while fixing old inconsistency.

Tasks:

- [ ] Document the allowed card variants and density tiers for cleanup:
      standard/root command center, data list, high-risk form, receipt/detail,
      support/info, fullscreen tool.
- [ ] Confirm shared components can cover the active batch before local fixes.
- [ ] Add shared density/tokens only when at least two screens need the same
      pattern.
- [ ] Do not edit shared primitives without GitNexus impact plus broader tests.

Acceptance criteria:

- [ ] No new local palette, radius, text style, or ad hoc spacing helper.
- [ ] Screens use `AppTextStyles` and tabular figures for financial numbers.
- [ ] `VitCard` and `VitPageContent` own primary surface rhythm where applicable.

Verification:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
```

### Phase 2 - P0 Visual Consistency Screens

**Goal:** Fix the most visible inconsistency first.

Work order:

1. Top token-debt queue in Section 7.
2. Surface consistency queue in Section 8, excluding accepted tool exceptions.
3. Any `P2_MEDIUM_DENSITY_REVIEW` row from the visual density audit.
4. P0 modules by feature: `p2p`, `markets`, `trade`, `wallet`.

Per-screen task template:

```text
Task:
Screen:
Route:
Feature:
Audit signal:
Dominant root cause:
GitNexus impact:
Implementation:
Verification:
Ledger status:
```

Acceptance criteria for each screen:

- [ ] First viewport shows page identity, primary context, and at least one
      useful actionable/repeated section at 360 px.
- [ ] Primary surfaces use `VitCard` or documented fullscreen/tool exception.
- [ ] Spacing uses `AppSpacing`, `VitContentPadding`, `VitContentGap`, and
      shared density tiers.
- [ ] No new design-token debt is introduced.
- [ ] Existing financial safety/copy boundaries remain intact.
- [ ] Focused tests for the feature pass.

Verification:

```bash
cd flutter_app
dart format <touched dart files>
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/features/<feature> --reporter=compact
flutter analyze
```

### Phase 3 - Module Rollout

**Goal:** Finish every row by module without leaving secondary routes behind.

Process modules in this order:

1. `p2p`
2. `markets`
3. `trade`
4. `wallet`
5. `earn`
6. `launchpad`
7. `profile`
8. `predictions`
9. `arena`
10. `dca`
11. `auth`
12. `onboarding`
13. `notifications`
14. `support`
15. `discovery`
16. `cross_module`
17. `referral`
18. `rewards`
19. `news`
20. `admin`
21. `dev`
22. `enterprise_states`
23. `home`

Module done criteria:

- [ ] All module rows in the 414-row ledger have a final status.
- [ ] Module token debt is zero or each remaining row has an accepted exception.
- [ ] Module body grade has no unexpected B/C/D rows.
- [ ] Module visual-density P1/P2 rows are fixed or accepted.
- [ ] Focused module tests pass.
- [ ] Product boundary and financial-safety checks pass where relevant.

### Phase 4 - Fullscreen Tool QA

**Goal:** Prove tool/workspace routes are intentional exceptions, not broken
standard pages.

Routes:

- `EnterpriseStatesPage`
- `P2PChatPage`
- `AdvancedChartPage`
- `FuturesPage`
- `TradingBotsPage`

Acceptance criteria:

- [ ] 360 px and representative device viewport render without overflow.
- [ ] Tool content uses full available workspace intentionally.
- [ ] Back/close/header controls are visible and reachable.
- [ ] Bottom nav, composer, sticky controls, or footers do not hide primary
      content.
- [ ] Evidence is captured as screenshot, widget viewport assertion, or emulator
      QA report.

Verification:

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart --check
dart run tool/top_header_visual_archetype_audit.dart --check
flutter test test/quality/responsive_visual_qa_matrix_test.dart --reporter=compact
flutter analyze
```

### Phase 5 - Whole-App Final Gate

**Goal:** Prove the project is now enterprise-grade as a whole, not just in
selected batches.

Final commands:

```bash
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
dart run tool/top_header_action_audit.dart
dart run tool/top_header_visual_archetype_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Also run from repo root:

```bash
git diff --check
```

Final completion criteria:

- [ ] Route count is still 414 unless a deliberate route change updated tests
      and docs.
- [ ] Body grade B is 0, except documented accepted product/tool exceptions.
- [ ] `P2_MEDIUM_DENSITY_REVIEW` is 0, except documented accepted exceptions.
- [ ] `P3_LOW_DENSITY_REVIEW` is assigned to fixed or monitor-when-touched.
- [ ] Root-page-bundle token debt is reduced to 0 or every remaining row has an
      accepted exception.
- [ ] Fullscreen/tool routes have evidence.
- [ ] Full tests and analyze pass.
- [ ] GitNexus `detect_changes()` has been run before commit/final handoff.

## 10. Per-Screen Execution Checklist

Use this checklist for every routed row:

- [ ] Read the row in the page-by-page inventory.
- [ ] Read the target page and direct local widgets only.
- [ ] Identify page archetype: command center, data list, high-risk form,
      receipt/detail, support/info, profile/settings, points-only/social, or
      fullscreen tool.
- [ ] Identify root cause: `EdgeInsets`, line-height, `SizedBox`, fixed height,
      `Spacer`, bottom inset, top chrome cost, surface consistency, or tool QA.
- [ ] Run GitNexus context/impact for edited symbols.
- [ ] Replace local surface/gap/pill/header patterns with shared primitives
      where patterns match.
- [ ] Preserve route behavior, provider reads, controller state, keys, tests,
      safety copy, and domain boundaries.
- [ ] Add or update focused widget tests when first viewport, controls, or
      states change.
- [ ] Run focused verification.
- [ ] Update the ledger status and evidence.

## 11. Batch Evidence Template

Append this evidence to the active ledger or implementation log after each
batch:

```text
Batch:
Date:
Status:

Screens:
- 

Audit input:
- body grade:
- density priority:
- token debt:
- root causes:

GitNexus:
- context target:
- impact target:
- risk:
- direct callers:
- affected processes:

Implementation:
- 

Safety / boundary review:
- financial safety:
- Arena / Prediction boundary:
- sensitive data masking:

Visual QA:
- viewport:
- route(s):
- result:
- artifact:

Verification:
- command:
- result:

Ledger update:
- status:
- residual exception:
- next row:
```

## 12. Execution Ledger

### Batch 2026-06-21-01 - SC-025 Social Signals

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/social_signals_page.dart`
- `lib/features/markets/presentation/pages/social_signals_page_part_01.dart`
- `lib/features/markets/presentation/pages/social_signals_page_part_02.dart`
- `lib/features/markets/presentation/pages/social_signals_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `P3_LOW_DENSITY_REVIEW`; residual cause is
  `bottom_nav_inset_pressure`, covered by first-viewport widget test.
- Token debt before: root page bundle `32`.
- Token debt after: root page bundle `0`; all four source files pass.

GitNexus:
- Context target: `SocialSignalsPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_marketsRoutes` and imported by the app router/test surface.
- Direct callers/importers: `_marketsRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/markets/social_signals_page_test.dart`.
- Narrowed edit targets: private local widgets only; all checked local widget
  classes reported `LOW` risk and no affected processes.

Implementation:
- Replaced local `height: 1` / `height: 1.15` text overrides with existing
  `AppTextStyles.numericMicro.height`.
- Replaced raw vertical `EdgeInsets.symmetric` usage with tokenized
  `EdgeInsetsDirectional` padding while keeping the existing market spacing
  tokens.
- Removed the local fixed-height wrapper from tiny badges to avoid density
  regression.
- Preserved route, keys, providers, filters, tabs, market copy, and disclaimer
  behavior.

Safety / boundary review:
- Financial safety: risk disclaimer remains above signal cards.
- Arena / Prediction boundary: not applicable.
- Sensitive data masking: not applicable.

Visual QA:
- Viewport: `VitFirstViewport.qaPhone` via focused widget test.
- Route: `AppRoutePaths.marketsSignals`.
- Result: first viewport still reaches the second signal card.
- Artifact: `test/features/markets/social_signals_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/social_signals_page_part_01.dart lib/features/markets/presentation/pages/social_signals_page_part_02.dart lib/features/markets/presentation/pages/social_signals_page_part_03.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1493`, `scope_root_page_bundle_summary_debt=631`,
  `p0_markets_debt=125`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/markets/social_signals_page_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: `P3_LOW_DENSITY_REVIEW` bottom inset pressure remains
  `monitor_when_touched`; focused viewport test passes.
- Next row: `lib/features/p2p/presentation/pages/p2p_home_page.dart`.

### Batch 2026-06-21-02 - SC-282 P2P Home

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_home_page.dart`
- `lib/features/p2p/presentation/pages/p2p_home_page_part_01.dart`
- `lib/features/p2p/presentation/pages/p2p_home_page_part_02.dart`
- `lib/features/p2p/presentation/pages/p2p_home_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `P3_LOW_DENSITY_REVIEW`; residual causes are
  `bottom_nav_inset_pressure` and `root_top_chrome_first_viewport_cost`,
  covered by focused first-viewport widget test.
- Token debt before: root page bundle `18`.
- Token debt after: root page bundle `0`; all four source files pass.

GitNexus:
- Context target: `P2PHomePage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_p2pRoutes`
  and imported by the app router/test surfaces.
- Direct callers/importers: `_p2pRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/p2p/p2p_home_page_test.dart`.
- Narrowed edit targets: private local widgets only; all checked local widget
  classes reported `LOW` risk and no affected processes.

Implementation:
- Worked with the existing dirty compact-first P2P home changes without
  reverting them.
- Replaced remaining raw `EdgeInsets.*` calls with tokenized
  `EdgeInsetsDirectional.*` equivalents.
- Replaced residual `height: 1` text overrides with
  `AppTextStyles.numericMicro.height`.
- Preserved route keys, search/filter behavior, ad navigation, P2P escrow
  safety panel, offline banner, and merchant/report actions.

Safety / boundary review:
- Financial safety: `VitHighRiskStatePanel` remains wired for active P2P
  contract state.
- Arena / Prediction boundary: not applicable.
- Sensitive data masking: no sensitive identifier rendering changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_home_page_test.dart`.
- Route: `AppRoutePaths.p2p`.
- Result: first viewport reaches search and the first offer preview.
- Artifact: `test/features/p2p/p2p_home_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_home_page_part_01.dart lib/features/p2p/presentation/pages/p2p_home_page_part_02.dart lib/features/p2p/presentation/pages/p2p_home_page_part_03.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1457`, `scope_root_page_bundle_summary_debt=613`,
  `p0_p2p_debt=184`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/p2p/p2p_home_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: `P3_LOW_DENSITY_REVIEW` root chrome/bottom inset pressure
  remains `monitor_when_touched`; focused viewport test passes.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart`.

### Batch 2026-06-21-03 - SC-240 P2P Insurance Score

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_insurance_score_page_common.dart`
- `lib/features/p2p/presentation/widgets/p2p_insurance_score_page_sections.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; first-viewport coverage
  confirms score factors remain visible.
- Token debt before: root page bundle `15`.
- Token debt after: root page bundle `0`; all three source files pass.

GitNexus:
- Context target: `P2PInsuranceScorePage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_p2pRoutes`
  and imported by the app router/test surfaces.
- Direct callers/importers: `_p2pRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/p2p/p2p_insurance_score_page_test.dart`.
- Narrowed edit targets: private local widgets only; all checked local widget
  classes reported `LOW` risk and no affected processes.

Implementation:
- Replaced remaining raw `EdgeInsets.*` calls with tokenized
  `EdgeInsetsDirectional.*` equivalents.
- Replaced residual numeric line-height overrides with
  `AppTextStyles.numericMicro.height`.
- Re-tokenized the compact score ring dimensions and stroke with existing
  spacing primitives, preserving the first-viewport layout without editing
  shared theme globals.
- Preserved route keys, providers, quick actions, tier path, insurance
  disclosure, and the high-risk review panel.

Safety / boundary review:
- Financial safety: `VitHighRiskStatePanel` remains visible before P2P
  insurance readiness changes.
- Arena / Prediction boundary: not applicable.
- Sensitive data masking: no sensitive identifier rendering changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_insurance_score_page_test.dart`.
- Route: `AppRoutePaths.p2pInsuranceScore`.
- Result: first viewport reaches score factors safely.
- Artifact: `test/features/p2p/p2p_insurance_score_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart lib/features/p2p/presentation/widgets/p2p_insurance_score_page_common.dart lib/features/p2p/presentation/widgets/p2p_insurance_score_page_sections.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1413`, `scope_root_page_bundle_summary_debt=598`,
  `p0_p2p_debt=155`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/p2p/p2p_insurance_score_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/markets/presentation/pages/social_sentiment_page.dart`.

### Batch 2026-06-21-04 - SC-020 Social Sentiment

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/social_sentiment_page.dart`
- `lib/features/markets/presentation/widgets/social_sentiment_overview_widgets.dart`
- `lib/features/markets/presentation/widgets/social_sentiment_tabs_widgets.dart`
- `lib/features/markets/presentation/widgets/social_sentiment_token_widgets.dart`
- `lib/features/markets/presentation/widgets/social_sentiment_trends_widgets.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; first-viewport coverage
  confirms the sentiment timeline card remains visible.
- Token debt before: root page bundle `13`.
- Token debt after: root page bundle `0`; all five source files pass.

GitNexus:
- Context target: `SocialSentimentPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_marketsRoutes` and imported by the app router/test surfaces.
- State impact: `_SocialSentimentPageState` also reports `CRITICAL` through the
  router import surface, so the batch was narrowed to root layout constants and
  scroll padding only.
- Direct callers/importers: `_marketsRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/markets/social_sentiment_page_test.dart`.

Implementation:
- Replaced page-local `EdgeInsets.*` padding constants with
  `EdgeInsetsDirectional.*` and `EdgeInsetsGeometry`.
- Replaced the timeline row's raw vertical padding value with
  `AppSpacing.x1`.
- Replaced dynamic scroll-bottom padding with `EdgeInsetsDirectional.only`.
- Preserved route keys, tab state, sort state, provider usage, overview/token/
  trend panel composition, and market-body review copy.

Safety / boundary review:
- Financial safety: the page remains informational sentiment review, not an
  execution prompt.
- Arena / Prediction boundary: social sentiment stays separated from token-level
  ranking and trading action language.
- Sensitive data masking: not applicable.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/social_sentiment_page_test.dart`.
- Route: `AppRoutePaths.marketsSocialSentiment`.
- Result: first viewport reaches the sentiment timeline card.
- Artifact: `test/features/markets/social_sentiment_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/social_sentiment_page.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1387`, `scope_root_page_bundle_summary_debt=585`,
  `p0_markets_debt=112`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/markets/social_sentiment_page_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart`.

### Batch 2026-06-21-05 - SC-249 P2P Identity Verification

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_identity_verification_page_common.dart`
- `lib/features/p2p/presentation/widgets/p2p_identity_verification_page_sections.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `P3_LOW_DENSITY_REVIEW`; residual cause is
  bottom-nav inset pressure, covered by the focused first-viewport test.
- Token debt before: root page bundle `12`.
- Token debt after: root page bundle `0`; all three source files pass.

GitNexus:
- Context target: `P2PIdentityVerificationPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_p2pRoutes`
  and imported by the app router/test surfaces.
- State impact: `_P2PIdentityVerificationPageState` also reports `CRITICAL`
  through the router import surface; the batch was narrowed to local layout
  padding and line-height tokens.
- Direct callers/importers: `_p2pRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/p2p/p2p_identity_verification_page_test.dart`,
  `flutter_app/test/features/p2p/p2p_kyc_requirements_page_test.dart`.
- Narrowed edit targets: private local widgets only; all checked local widget
  classes reported `LOW` risk and no affected processes.

Implementation:
- Worked with existing dirty compact-first KYC changes without reverting them.
- Replaced raw `EdgeInsets.*` padding in the page, security card, checklist,
  hero, document picker, guideline card, and upload card with
  `EdgeInsetsDirectional.*`.
- Replaced residual numeric line-height overrides with
  `AppTextStyles.numericMicro.height`.
- Preserved document type selection, front/back upload state, submit routing,
  security copy, and the high-risk review panel.

Safety / boundary review:
- Financial safety: identity/KYC state review remains visible before continuing
  to the next verification step.
- Arena / Prediction boundary: not applicable.
- Sensitive data masking: no sensitive document/account identifiers were added
  or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_identity_verification_page_test.dart`.
- Routes: `AppRoutePaths.p2pKycIdentity`, `AppRoutePaths.p2pKycVerify`.
- Result: first viewport reaches the first identity document type while the KYC
  hero stays compact.
- Artifact: `test/features/p2p/p2p_identity_verification_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart lib/features/p2p/presentation/widgets/p2p_identity_verification_page_common.dart lib/features/p2p/presentation/widgets/p2p_identity_verification_page_sections.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1352`, `scope_root_page_bundle_summary_debt=573`,
  `p0_p2p_debt=132`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/p2p/p2p_identity_verification_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: `P3_LOW_DENSITY_REVIEW` bottom inset pressure remains
  `monitor_when_touched`; focused viewport test passes.
- Next row:
  `lib/features/arena/presentation/pages/arena_production_ready_page.dart`.

### Batch 2026-06-21-06 - SC-206 Arena Production Ready

Status: `fixed`

Screens:
- `lib/features/arena/presentation/pages/arena_production_ready_page.dart`
- `lib/features/arena/presentation/pages/arena_production_ready_page_part_01.dart`
- `lib/features/arena/presentation/pages/arena_production_ready_page_part_02.dart`
- `lib/features/arena/presentation/pages/arena_production_ready_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; first-viewport coverage
  confirms the first canonical screen card remains visible.
- Token debt before: root page bundle `12`.
- Token debt after: root page bundle `0`; all four source files pass.

GitNexus:
- Context target: `ArenaProductionReadyPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_arenaExtendedRoutes` and imported by the app router/test surfaces.
- Direct callers/importers: `_arenaExtendedRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/arena/arena_production_ready_page_test.dart`.
- Narrowed edit targets: private local widgets only; all checked local widget
  classes reported `LOW` risk and no affected processes.

Implementation:
- Replaced local numeric line-height overrides with existing typography token
  heights.
- Replaced small fixed flow/status dot sizes with existing `AppSpacing` tokens.
- Preserved release readiness tabs, route registry, component registry,
  handoff boards, state matrix, and navigation targets.

Safety / boundary review:
- Financial safety: not applicable.
- Arena / Prediction boundary: Arena copy remains internal release readiness,
  QA, route registry, component registry, completion/state language; no wallet,
  payout, profit, or stake-return wording was introduced.
- Sensitive data masking: not applicable.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/arena/arena_production_ready_page_test.dart`.
- Route: `AppRoutePaths.arenaProduction`.
- Result: first viewport reaches the first canonical screen card; readiness tabs
  and canonical route navigation remain stable.
- Artifact: `test/features/arena/arena_production_ready_page_test.dart`.

Verification:
- `dart format lib/features/arena/presentation/pages/arena_production_ready_page_part_01.dart lib/features/arena/presentation/pages/arena_production_ready_page_part_02.dart lib/features/arena/presentation/pages/arena_production_ready_page_part_03.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1328`, `scope_root_page_bundle_summary_debt=561`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/arena/arena_production_ready_page_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/markets/presentation/pages/advanced_charts_page.dart`.

### Batch 2026-06-21-07 - SC-023 Advanced Charts

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/advanced_charts_page.dart`
- `lib/features/markets/presentation/pages/advanced_charts_page_part_01.dart`
- `lib/features/markets/presentation/pages/advanced_charts_page_part_02.dart`
- `lib/features/markets/presentation/pages/advanced_charts_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; first-viewport coverage
  confirms the first indicator card remains visible.
- Token debt before: root page bundle `12`.
- Token debt after: root page bundle `0`; all four source files pass.

GitNexus:
- Context target: `AdvancedChartsPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_marketsRoutes` and imported by the app router/test surfaces.
- Direct callers/importers: `_marketsRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/markets/advanced_charts_page_test.dart`.
- State impact: `_AdvancedChartsPageState` reported `LOW`; no affected
  processes.

Implementation:
- Replaced chart control padding constants with `EdgeInsetsGeometry` and
  `EdgeInsetsDirectional.*`.
- Replaced dynamic scroll-bottom padding with `EdgeInsetsDirectional.only`.
- Preserved indicator tabs, drawing tools, signals disclaimer, active indicator
  chips, category filters, and market navigation behavior.

Safety / boundary review:
- Financial safety: technical signals disclaimer remains visible; no trading
  execution prompt was added.
- Arena / Prediction boundary: not applicable.
- Sensitive data masking: not applicable.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/advanced_charts_page_test.dart`.
- Route: `AppRoutePaths.marketsAdvancedCharts`.
- Result: first viewport reaches the first indicator card; indicator toggle,
  category filter, drawing tab, signals tab, and back navigation remain stable.
- Artifact: `test/features/markets/advanced_charts_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/advanced_charts_page.dart lib/features/markets/presentation/pages/advanced_charts_page_part_01.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1304`, `scope_root_page_bundle_summary_debt=549`,
  `p0_markets_debt=100`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/markets/advanced_charts_page_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/arena/presentation/pages/arena_challenge_detail_page.dart`.

### Batch 2026-06-21-08 - SC-190 Arena Challenge Detail

Status: `fixed`

Screens:
- `lib/features/arena/presentation/pages/arena_challenge_detail_page.dart`
- `lib/features/arena/presentation/pages/arena_challenge_detail_page_part_01.dart`
- `lib/features/arena/presentation/pages/arena_challenge_detail_page_part_02.dart`
- `lib/features/arena/presentation/pages/arena_challenge_detail_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; first-viewport coverage
  confirms the live points summary remains visible.
- Token debt before: root page bundle `10`.
- Token debt after: root page bundle `0`; all four source files pass.

GitNexus:
- Context target: `ArenaChallengeDetailPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_arenaCoreRoutes` and imported by the app router/test surfaces.
- State impact: `_ArenaChallengeDetailPageState` also reports `CRITICAL`
  through the router import surface; the batch was narrowed to local padding and
  line-height tokens.
- Direct callers/importers: `_arenaCoreRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/arena/arena_challenge_detail_page_test.dart`,
  and related Arena/discovery route tests.
- Narrowed edit targets: private local widgets only; all checked local widget
  classes reported `LOW` risk and no affected processes.

Implementation:
- Replaced root page `EdgeInsets.*` constants with `EdgeInsetsGeometry` and
  `EdgeInsetsDirectional.*`.
- Replaced numeric line-height overrides across challenge intro, member chips,
  clarity/creator/warning/prediction copy, summary rows, info cards, and initial
  badges with existing typography token heights.
- Replaced the local divider `height: 1` with `AppSpacing.dividerHairline`.
- Preserved tabs, action sheets, canonical Arena route navigation, report/block
  actions, prediction bridge copy, and Arena warning copy.

Safety / boundary review:
- Financial safety: not applicable.
- Arena / Prediction boundary: Arena remains points-only; the bridge copy still
  states Arena Points and Prediction Markets are fully separate systems.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/arena/arena_challenge_detail_page_test.dart`.
- Route: `/arena/challenge/:challengeId`.
- Result: first viewport reaches live points summary; tabs, action sheets, and
  canonical Arena route navigation remain stable.
- Artifact: `test/features/arena/arena_challenge_detail_page_test.dart`.

Verification:
- `dart format lib/features/arena/presentation/pages/arena_challenge_detail_page.dart lib/features/arena/presentation/pages/arena_challenge_detail_page_part_01.dart lib/features/arena/presentation/pages/arena_challenge_detail_page_part_02.dart lib/features/arena/presentation/pages/arena_challenge_detail_page_part_03.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=1284`, `scope_root_page_bundle_summary_debt=539`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `flutter test test/features/arena/arena_challenge_detail_page_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/markets/presentation/pages/market_news_page.dart`.

### Batch 2026-06-21-09 - SC-022 Market News

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/market_news_page.dart`
- `lib/features/markets/presentation/widgets/market_news_page_common.dart`
- `lib/features/markets/presentation/widgets/market_news_page_sections.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`.
- Token debt before: root page bundle `10`.
- Token debt after: root page bundle `0`; all three source files pass.
- Module checkpoint after regeneration: `total_debt=1255`,
  `scope_root_page_bundle_summary_debt=529`, `p0_markets_debt=81`.

GitNexus:
- Context target: `MarketNewsPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_marketsRoutes` and imported by the app router/test surfaces.
- Direct callers/importers: `_marketsRoutes`,
  `flutter_app/lib/app/router/app_router.dart`, and
  `flutter_app/test/features/markets/market_news_page_test.dart`.
- Narrowed edit targets: `_NewsCard` and `_BreakingNewsCard` checked as
  `LOW` risk with no affected processes; edits stayed in local presentation
  token usage.

Implementation:
- Replaced the dynamic scroll-bottom `EdgeInsets.only` with
  `EdgeInsetsDirectional.only`.
- Replaced chip, bookmark, metadata, related-token, reset-action, category, and
  sentiment padding with directional token padding.
- Removed local numeric title/summary line-height constants and used existing
  `AppTextStyles.body.height` / `AppTextStyles.caption.height`.
- Preserved category filtering, sentiment filtering, save state, expanded story
  state, token navigation, route keys, and market review copy.

Safety / boundary review:
- Financial safety: no trading, order, wallet, or withdrawal action changed.
- Prediction Markets / Arena boundary: not applicable.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/market_news_page_test.dart`.
- Route: `/markets/news`.
- Result: first viewport still reaches the first market news card; filters,
  save/expand behavior, token navigation, and back navigation remain stable.
- Artifact: `test/features/markets/market_news_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/market_news_page.dart lib/features/markets/presentation/widgets/market_news_page_common.dart lib/features/markets/presentation/widgets/market_news_page_sections.dart` - pass.
- `flutter test test/features/markets/market_news_page_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1255`, `p0_markets_debt=81`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_trading_level_page.dart`.

### Batch 2026-06-21-10 - SC-230 P2P Trading Level

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_trading_level_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_trading_level_hero_progress.dart`
- `lib/features/p2p/presentation/widgets/p2p_trading_level_cards.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `9`.
- Token debt after: root page bundle `0`; page and both widget parts pass.
- Module checkpoint after regeneration: `total_debt=1228`,
  `scope_root_page_bundle_summary_debt=520`, `p0_p2p_debt=114`.

GitNexus:
- Context target: `P2PTradingLevelPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_p2pRoutes`
  and imported by the app router/test surfaces.
- Direct callers/importers: `_p2pRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/p2p/p2p_trading_level_page_test.dart`, and
  `flutter_app/test/features/p2p/p2p_achievements_page_test.dart`.
- Narrowed edit targets: `_CurrentLevelHero`, `_HeroMetricCard`,
  `_NextLevelProgress`, `_LevelCard`, and `_LimitTile` all reported `LOW`
  risk with no affected processes.

Implementation:
- Replaced P2P trading-level hero, metric, progress, level-card, and limit-tile
  raw padding with `EdgeInsetsDirectional.all(...)`.
- Replaced local numeric line-height overrides with
  `AppTextStyles.sectionTitle.height`, `AppTextStyles.micro.height`, and
  `AppTextStyles.caption.height`.
- Preserved fee, volume, level, requirement, daily-limit, upgrade CTA,
  route keys, and P2P bottom-nav/header behavior.
- Worked with pre-existing compact-first dirty changes in the same files
  without reverting them.

Safety / boundary review:
- Financial safety: P2P fee/limit/level information remained read-only; no
  payment-method, escrow release, withdrawal, or order confirmation behavior
  changed.
- P2P boundary: copy still references P2P trading levels, limits, fee tiers,
  and the repository contract notes that require escrow.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_trading_level_page_test.dart`.
- Route: `/p2p/trading-level`.
- Result: first viewport reaches the first level card; all levels, upgrade CTA,
  and header back behavior remain stable.
- Artifact: `test/features/p2p/p2p_trading_level_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_trading_level_page.dart lib/features/p2p/presentation/widgets/p2p_trading_level_hero_progress.dart lib/features/p2p/presentation/widgets/p2p_trading_level_cards.dart test/features/p2p/p2p_trading_level_page_test.dart` - pass.
- `flutter test test/features/p2p/p2p_trading_level_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1228`, `p0_p2p_debt=114`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/markets/presentation/pages/market_screener_page.dart`.

### Batch 2026-06-21-11 - SC-015 Market Screener

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/market_screener_page.dart`
- `lib/features/markets/presentation/widgets/market_screener_filters.dart`
- `lib/features/markets/presentation/widgets/market_screener_results.dart`
- `lib/features/markets/presentation/widgets/market_screener_row_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`.
- Token debt before: root page bundle `9`.
- Token debt after: root page bundle `0`; page and all three widget parts pass.
- Module checkpoint after regeneration: `total_debt=1201`,
  `scope_root_page_bundle_summary_debt=511`, `p0_markets_debt=63`.

GitNexus:
- Context target: `MarketScreenerPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_marketsRoutes` and imported by the app router/test surfaces.
- Direct callers/importers: `_marketsRoutes`,
  `flutter_app/lib/app/router/app_router.dart`, and
  `flutter_app/test/features/markets/market_screener_page_test.dart`.
- Narrowed edit targets: `_PresetScroller`, `_CategoryChip`, `_SortChip`, and
  `_ScreenerRow` all reported `LOW` risk with no affected processes.

Implementation:
- Replaced preset/category/sort/result-row numeric line-height overrides with
  existing `AppTextStyles.caption.height`, `AppTextStyles.body.height`, and
  `AppTextStyles.micro.height`.
- Replaced the preset chip `SizedBox(width/height)` with a `ConstrainedBox`
  using the same width and height constraints, avoiding ad hoc fixed
  `SizedBox` debt while preserving chip sizing.
- Preserved search, preset selection, advanced category/range filters, reset,
  sort toggles, row keys, pair navigation, and market review copy.

Safety / boundary review:
- Financial safety: read-only market screening; no order placement, wallet, or
  confirmation behavior changed.
- Prediction Markets / Arena boundary: not applicable.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/market_screener_page_test.dart`.
- Route: `/markets/screener`.
- Result: first viewport reaches the first screener result row; search,
  presets, advanced filters, sorting, pair navigation, and back navigation
  remain stable.
- Artifact: `test/features/markets/market_screener_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/widgets/market_screener_filters.dart lib/features/markets/presentation/widgets/market_screener_results.dart` - pass.
- `flutter test test/features/markets/market_screener_page_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1201`, `p0_markets_debt=63`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/wallet/presentation/pages/dust_converter_page.dart`.

### Batch 2026-06-21-12 - SC-154 Dust Converter

Status: `fixed`

Screens:
- `lib/features/wallet/presentation/pages/dust_converter_page.dart`
- `lib/features/wallet/presentation/widgets/wallet_dust_converter_assets.dart`
- `lib/features/wallet/presentation/widgets/wallet_dust_converter_confirm.dart`
- `lib/features/wallet/presentation/widgets/wallet_dust_converter_hero.dart`
- `lib/features/wallet/presentation/widgets/wallet_dust_converter_targets.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`.
- Token debt before: root page bundle `9`.
- Token debt after: root page bundle `0`; page and all four widget parts pass.
- Module checkpoint after regeneration: `total_debt=1183`,
  `scope_root_page_bundle_summary_debt=502`, `p0_wallet_debt=48`.

GitNexus:
- Context target: `DustConverterPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_walletRoutes` and imported by the app router/test surfaces.
- State impact: `_DustConverterPageState` also reports `CRITICAL` through the
  page/router import surface.
- Direct callers/importers: `_walletRoutes`,
  `flutter_app/lib/app/router/app_router.dart`, and
  `flutter_app/test/features/wallet/dust_converter_page_test.dart`.
- Narrowed edit target: root-page padding constants only; widget parts were
  already audit-clean.

Implementation:
- Replaced all root-page dust converter padding constants with
  `EdgeInsetsDirectional.*`.
- Replaced the dynamic sticky footer padding `copyWith(left/right/bottom)` with
  explicit `EdgeInsetsDirectional.only(start/end/top/bottom)`.
- Preserved dust target selection, select-all behavior, eligible asset rows,
  preview sheet, conversion fee calculation, receive amount, confirm action,
  success banner, route keys, and high-risk review panel.
- Worked with pre-existing compact-first dirty scroll-physics change without
  reverting it.

Safety / boundary review:
- Financial safety: conversion preview and confirmation remain intact; fee,
  target asset, selected count, and received amount are still shown before
  submitting.
- Wallet boundary: dust conversion remains wallet-only and does not introduce
  trading/order language.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/wallet/dust_converter_page_test.dart`.
- Route: `/wallet/dust-converter`.
- Result: first viewport reaches the first dust asset row; select-all, confirm
  sheet, fee/receive preview, confirmation, and success state remain stable.
- Artifact: `test/features/wallet/dust_converter_page_test.dart`.

Verification:
- `dart format lib/features/wallet/presentation/pages/dust_converter_page.dart lib/features/wallet/presentation/widgets/wallet_dust_converter_confirm.dart` - pass.
- `flutter test test/features/wallet/dust_converter_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1183`, `p0_wallet_debt=48`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart`.

### Batch 2026-06-21-13 - SC-373 Staking Regulatory Framework

Status: `fixed`

Screens:
- `lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart`
- `lib/features/earn/presentation/widgets/staking_regulatory_framework_hero_licenses.dart`
- `lib/features/earn/presentation/widgets/staking_regulatory_framework_protection_complaints.dart`
- `lib/features/earn/presentation/widgets/staking_regulatory_framework_sheet_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `9`.
- Token debt after: root page bundle `0`; page and all three widget parts pass.
- Module checkpoint after regeneration: `total_debt=1157`,
  `scope_root_page_bundle_summary_debt=493`.

GitNexus:
- Context target: `StakingRegulatoryFrameworkPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_earnRoutes`
  and imported by the app router/test surfaces.
- Direct callers/importers: `_earnRoutes`,
  `flutter_app/lib/app/router/app_router.dart`, and
  `flutter_app/test/features/earn/staking_regulatory_framework_page_test.dart`.
- Narrowed edit targets: `_HeroCard`, `_ProtectionCard`, `_ComplaintStep`,
  `_LicenseDetailSheet`, `_InfoNote`, `_WarningNote`, and `_FooterNote` all
  reported `LOW` risk with no affected processes.

Implementation:
- Replaced root scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced regulatory hero, protection, complaint, license sheet, info/warning,
  and footer numeric line-height overrides with existing typography token
  heights.
- Preserved license cards, protection tab, complaints tab, regulatory contacts,
  license detail sheet, verify CTA, route keys, and back navigation.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- Earn safety: regulatory license, investor protection, complaint handling,
  risk/compliance notes, and staking hub navigation remained unchanged.
- Financial safety: no subscribe, withdrawal, lockup, or yield calculation
  behavior changed.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/earn/staking_regulatory_framework_page_test.dart`.
- Route: `/earn/regulatory-framework`.
- Result: first viewport reaches the first regulatory license card; detail
  sheet, tabs, complaint/protection content, and back navigation remain stable.
- Artifact: `test/features/earn/staking_regulatory_framework_page_test.dart`.

Verification:
- `dart format lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart lib/features/earn/presentation/widgets/staking_regulatory_framework_hero_licenses.dart lib/features/earn/presentation/widgets/staking_regulatory_framework_protection_complaints.dart lib/features/earn/presentation/widgets/staking_regulatory_framework_sheet_common.dart test/features/earn/staking_regulatory_framework_page_test.dart` - pass.
- `flutter test test/features/earn/staking_regulatory_framework_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1157`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/earn/presentation/pages/staking_risk_assessment_page.dart`.

### Batch 2026-06-21-14 - SC-357 Staking Risk Assessment

Status: `fixed`

Screens:
- `lib/features/earn/presentation/pages/staking_risk_assessment_page.dart`
- `lib/features/earn/presentation/widgets/staking_risk_assessment_page_common.dart`
- `lib/features/earn/presentation/widgets/staking_risk_assessment_page_sections.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `8`.
- Token debt after: root page bundle `0`; page and both widget parts pass.
- Module checkpoint after regeneration: `total_debt=1134`,
  `scope_root_page_bundle_summary_debt=485`.

GitNexus:
- Context target: `StakingRiskAssessmentPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_earnRoutes`
  and imported by the app router/test surfaces.
- Direct callers/importers: `_earnRoutes`,
  `flutter_app/lib/app/router/app_router.dart`,
  `flutter_app/test/features/earn/staking_risk_assessment_page_test.dart`, and
  `flutter_app/test/features/earn/staking_recommendations_page_test.dart`.
- Narrowed edit targets: `_ResultView`, `_BulletRow`, `_QuestionCard`,
  `_RiskOptionTile`, and `_InfoBanner` all reported `LOW` risk with no
  affected processes.

Implementation:
- Replaced root scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced staking risk result, bullet, question, option, description, and info
  banner numeric line-height overrides with existing typography token heights.
- Preserved risk scoring, answer progression, previous/reset behavior, result
  recommendations/warnings, explore CTA navigation, high-risk review panels,
  route keys, and back navigation.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- Earn safety: staking knowledge, liquidity need, risk reaction, allocation
  limits, APY variability, lockup, validator risk, and confirmation copy remain
  intact.
- Financial safety: no subscribe/withdraw/lockup behavior changed; the flow
  remains assessment-only until the user navigates to product exploration.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/earn/staking_risk_assessment_page_test.dart`.
- Route: `/earn/staking/risk-assessment`.
- Result: first viewport reaches the first answer option; wizard navigation,
  result rendering, reset, explore CTA, and back navigation remain stable.
- Artifact: `test/features/earn/staking_risk_assessment_page_test.dart`.

Verification:
- `dart format lib/features/earn/presentation/pages/staking_risk_assessment_page.dart lib/features/earn/presentation/widgets/staking_risk_assessment_page_common.dart lib/features/earn/presentation/widgets/staking_risk_assessment_page_sections.dart test/features/earn/staking_risk_assessment_page_test.dart` - pass.
- `flutter test test/features/earn/staking_risk_assessment_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1134`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/earn/presentation/pages/savings_risk_assessment_page.dart`.

### Batch 2026-06-21-15 - SC-339 Savings Risk Assessment

Status: `fixed`

Screens:
- `lib/features/earn/presentation/pages/savings_risk_assessment_page.dart`
- `lib/features/earn/presentation/widgets/savings_risk_assessment_questions.dart`
- `lib/features/earn/presentation/widgets/savings_risk_assessment_result.dart`
- `lib/features/earn/presentation/widgets/savings_risk_assessment_products_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `8`.
- Token debt after: root page bundle `0`; page and all three widget parts pass.
- Module checkpoint after regeneration: `total_debt=1111`,
  `scope_root_page_bundle_summary_debt=477`.

GitNexus:
- Context target: `SavingsRiskAssessmentPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_earnRoutes`
  and imported by the app router/test surfaces.
- Direct callers/importers: `_earnRoutes`,
  `flutter_app/lib/app/router/app_router.dart`, and
  `flutter_app/test/features/earn/savings_risk_assessment_page_test.dart`.
- Narrowed edit targets: `_QuestionCard`, `_RiskOptionTile`, `_InfoBanner`,
  `_ResultView`, `_BulletRow`, and `_AssetBadge` all reported `LOW` risk with
  no affected processes.

Implementation:
- Replaced root scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced savings risk help, option, result, info banner, bullet, and asset
  badge numeric line-height overrides with existing typography token heights.
- Replaced compact two-axis `SizedBox` dot/badge dimensions with
  `SizedBox.square` while preserving intended visual size.
- Preserved question progression, previous/reset behavior, moderate result
  rendering, product recommendation cards, product detail CTA wiring, risk
  labels, warning copy, and back navigation.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- Earn safety: liquidity horizon, loss tolerance, stablecoin/crypto exposure,
  emergency access, and recommendation rationale copy remain intact.
- Financial safety: no subscribe/withdraw/lockup behavior changed; the flow
  remains assessment-only until the user navigates to product exploration.
- Sensitive data masking: no sensitive identifiers were added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/earn/savings_risk_assessment_page_test.dart`.
- Route: `/earn/savings/risk-assessment`.
- Result: first viewport reaches the first risk option; wizard navigation,
  result rendering, product CTA routing, reset, and back navigation remain
  stable.
- Artifact: `test/features/earn/savings_risk_assessment_page_test.dart`.

Verification:
- `dart format lib/features/earn/presentation/pages/savings_risk_assessment_page.dart lib/features/earn/presentation/widgets/savings_risk_assessment_questions.dart lib/features/earn/presentation/widgets/savings_risk_assessment_result.dart lib/features/earn/presentation/widgets/savings_risk_assessment_products_common.dart test/features/earn/savings_risk_assessment_page_test.dart` - pass.
- `flutter test test/features/earn/savings_risk_assessment_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1111`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart`.

### Batch 2026-06-21-16 - SC-033 Predictions Leaderboard

Status: `fixed`

Screens:
- `lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart`
- `lib/features/predictions/presentation/widgets/predictions_leaderboard_filters_tabs.dart`
- `lib/features/predictions/presentation/widgets/predictions_leaderboard_podium_rankings.dart`
- `lib/features/predictions/presentation/widgets/predictions_leaderboard_rows_wins.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing first-viewport test
  confirms the top ranking row is reachable.
- Token debt before: root page bundle `8`.
- Token debt after: root page bundle `0`; page and all three widget parts pass.
- Module checkpoint after regeneration: `total_debt=1088`,
  `scope_root_page_bundle_summary_debt=469`.

GitNexus:
- Context target: `PredictionsLeaderboardPage`.
- Class impact: `CRITICAL` because the screen is route-owned by
  `_predictionRoutes` and imported by the app router.
- Direct callers/importers: `_predictionRoutes` and
  `flutter_app/lib/app/router/app_router.dart`.
- State impact: `_PredictionsLeaderboardPageState` reported `CRITICAL` because
  it is bound to the routed page state; the edit was limited to equivalent
  scroll padding.
- Narrowed edit targets: `_TimeFilters`, `_MetricTabs`, `_MetricTab`,
  `_PodiumColumn`, `_RankingHeader`, and `_RankingRow` all reported `LOW` risk
  with no affected processes.

Implementation:
- Replaced root scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced filter, metric info, metric tab, podium, ranking header, and ranking
  row `EdgeInsets` calls with directional equivalents.
- Preserved time filters, P/L vs volume metric switching, info bottom sheet,
  podium ranking order, ranking row content, biggest-win navigation, keys, and
  shell/header composition.

Safety / boundary review:
- Prediction Markets copy remains trading-context only: leaderboard metrics keep
  P/L, volume, trades, win rate, and event navigation semantics.
- Arena boundary: no Arena points, payout, fair-play, or completion copy was
  introduced into Prediction surfaces.
- Financial safety: no order, wallet, stake, or confirmation flow changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/predictions/predictions_leaderboard_page_test.dart`.
- Route: `/markets/predictions/leaderboard`.
- Result: first viewport reaches the top prediction leaderboard row; tabs,
  metric switching, info sheet, and biggest-win navigation remain stable.
- Artifact: `test/features/predictions/predictions_leaderboard_page_test.dart`.

Verification:
- `dart format lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart lib/features/predictions/presentation/widgets/predictions_leaderboard_filters_tabs.dart lib/features/predictions/presentation/widgets/predictions_leaderboard_podium_rankings.dart lib/features/predictions/presentation/widgets/predictions_leaderboard_rows_wins.dart test/features/predictions/predictions_leaderboard_page_test.dart` - pass.
- `flutter test test/features/predictions/predictions_leaderboard_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/prediction_product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1088`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart`.

### Batch 2026-06-21-17 - SC-276 P2P Blacklist Add

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `8`.
- Token debt after: root page bundle `0`; page passes.
- Module checkpoint after regeneration: `total_debt=1072`,
  `scope_root_page_bundle_summary_debt=461`, `p0_p2p_debt=106`.

GitNexus:
- Context target: `P2PBlacklistAddPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_p2pRoutes`
  and imported by the app router.
- Direct callers/importers: `_p2pRoutes` and
  `flutter_app/lib/app/router/app_router.dart`.
- State/private targets: `_P2PBlacklistAddPageState`, `_Hero`,
  `_ReasonTile`, `_NoteField`, and `_WarningCard` reported `CRITICAL` because
  they sit directly inside the routed page tree; no affected processes were
  reported.

Implementation:
- Replaced high-risk review, hero, reason tile, note field, and warning card
  `EdgeInsets` calls with directional equivalents.
- Replaced the hero title numeric line-height override with the existing
  caption typography token height.
- Preserved username field state, reason selection haptics, submit loading
  guard, route return to the blacklist parent, warning copy, high-risk review
  panel, and back navigation.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- P2P safety: blacklist reason, username, note, warning, submitting state, and
  undo/support review copy remain intact.
- Financial safety: no escrow, payment-method, order, wallet, or confirmation
  behavior changed.
- Sensitive data masking: no account, phone, email, wallet, or address data was
  added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_blacklist_add_page_test.dart`.
- Route: `/p2p/blacklist/add`.
- Result: first viewport reaches the username field and first blacklist reason;
  hero height remains bounded; reason selection, submit navigation, and header
  back remain stable.
- Artifact: `test/features/p2p/p2p_blacklist_add_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart test/features/p2p/p2p_blacklist_add_page_test.dart` - pass.
- `flutter test test/features/p2p/p2p_blacklist_add_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1072`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/earn/presentation/pages/savings_recommendations_page.dart`.

### Batch 2026-06-21-18 - SC-338 Savings Recommendations

Status: `fixed`

Screens:
- `lib/features/earn/presentation/pages/savings_recommendations_page.dart`
- `lib/features/earn/presentation/pages/savings_recommendations_page_part_01.dart`
- `lib/features/earn/presentation/pages/savings_recommendations_page_part_02.dart`
- `lib/features/earn/presentation/pages/savings_recommendations_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `7`.
- Token debt after: root page bundle `0`; page and all three parts pass.
- Module checkpoint after regeneration: `total_debt=1058`,
  `scope_root_page_bundle_summary_debt=454`.

GitNexus:
- Context target: `SavingsRecommendationsPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_earnRoutes`
  and imported by the app router.
- Direct callers/importers: `_earnRoutes` and
  `flutter_app/lib/app/router/app_router.dart`.
- Narrowed edit targets: `_SavingsRecommendationsPageState`, `_HeroCard`,
  `_InsightCard`, `_Disclaimer`, `_BulletSection`, and `_AssetBadge` all
  reported `LOW` risk with no affected processes.

Implementation:
- Replaced root scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced hero, insight, disclaimer, bullet, and asset badge numeric/static
  line-height overrides with existing typography token heights.
- Replaced bullet dot and asset badge two-axis `SizedBox` dimensions with
  `SizedBox.square` while preserving intended dimensions.
- Preserved amount input/controller state, quick amount updates, projected
  yearly yield math, compare sheet, strategy detail sheet, risk navigation,
  products navigation, savings CTA, and disclaimer copy.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- Earn safety: strategy recommendations, allocation mix, APY estimates,
  risk-assessment CTA, product CTA, and disclaimer remain intact.
- Financial safety: no subscribe/withdraw/lockup behavior changed; the strategy
  detail CTA still routes back to savings products for the product flow.
- Sensitive data masking: no sensitive account, wallet, email, phone, or
  address data was added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/earn/savings_recommendations_page_test.dart`.
- Route: `/earn/savings/recommendations`.
- Result: first viewport reaches the compare action; amount chips, projected
  yield, detail sheet CTA, compare sheet, and risk route remain stable.
- Artifact: `test/features/earn/savings_recommendations_page_test.dart`.

Verification:
- `dart format lib/features/earn/presentation/pages/savings_recommendations_page.dart lib/features/earn/presentation/pages/savings_recommendations_page_part_01.dart lib/features/earn/presentation/pages/savings_recommendations_page_part_02.dart lib/features/earn/presentation/pages/savings_recommendations_page_part_03.dart test/features/earn/savings_recommendations_page_test.dart` - pass.
- `flutter test test/features/earn/savings_recommendations_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1058`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/earn/presentation/pages/staking_emergency_actions_page.dart`.

### Batch 2026-06-21-19 - SC-385 Staking Emergency Actions

Status: `fixed`

Screens:
- `lib/features/earn/presentation/pages/staking_emergency_actions_page.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `7`.
- Token debt after: root page bundle `0`; page passes.
- Module checkpoint after regeneration: `total_debt=1044`,
  `scope_root_page_bundle_summary_debt=447`.

GitNexus:
- Context target: `StakingEmergencyActionsPage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_earnRoutes`
  and imported by the app router.
- Direct callers/importers: `_earnRoutes` and
  `flutter_app/lib/app/router/app_router.dart`.
- Method target: `_showActionSheet` reported `LOW` risk with one direct class
  caller and no affected processes.
- Widget targets: `_WarningBanner`, `_EmergencyActionCard`, `_UseCaseRow`, and
  `_FooterNote` reported `CRITICAL` because they sit directly in the routed page
  tree; no affected processes were reported.

Implementation:
- Replaced root scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced action sheet body/bullet, warning banner, emergency action body,
  use-case description, and footer note numeric/static line-height overrides
  with existing typography token heights.
- Preserved action IDs, pause/withdraw sheet keys, penalty and monitoring copy,
  confirm labels, disabled rebalance behavior, high-risk review panel, risk
  dashboard navigation, and header back route.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- Earn safety: emergency-only warning, penalty impact, current status, support
  next steps, and confirmation sheets remain intact.
- Financial safety: no subscribe/withdraw execution, lockup, fee, or emergency
  confirmation behavior changed; only presentation tokens changed.
- Sensitive data masking: no sensitive account, wallet, email, phone, or
  address data was added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/earn/staking_emergency_actions_page_test.dart`.
- Route: `/earn/staking/emergency-actions`.
- Result: first viewport reaches the primary emergency action; use cases,
  status, footer, pause sheet, withdrawal sheet, risk dashboard route, and
  header back remain stable.
- Artifact: `test/features/earn/staking_emergency_actions_page_test.dart`.

Verification:
- `dart format lib/features/earn/presentation/pages/staking_emergency_actions_page.dart test/features/earn/staking_emergency_actions_page_test.dart` - pass.
- `flutter test test/features/earn/staking_emergency_actions_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1044`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart`.

### Batch 2026-06-21-20 - SC-256 P2P Anti-Phishing Code

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_anti_phishing_code_page_sections.dart`
- `lib/features/p2p/presentation/widgets/p2p_anti_phishing_code_page_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `7`.
- Token debt after: root page bundle `0`; page and both widget parts pass.
- Module checkpoint after regeneration: `total_debt=1026`,
  `scope_root_page_bundle_summary_debt=440`, `p0_p2p_debt=95`.

GitNexus:
- Context target: `P2PAntiPhishingCodePage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_p2pRoutes`
  and imported by the app router.
- Direct callers/importers: `_p2pRoutes` and
  `flutter_app/lib/app/router/app_router.dart`.
- State impact: `_P2PAntiPhishingCodePageState` reported `CRITICAL` because it
  owns the routed security state tree.
- Method targets: `_currentCodeCard` and `_editCodeCard` reported `LOW` risk
  with no affected processes.
- Widget targets: `_StatusCard`, `_ExplainerCard`, and `_EmailExampleCard`
  reported `LOW` risk with no affected processes.

Implementation:
- Replaced current-code, masked-code inner card, edit-code, status, explainer,
  and email-example `EdgeInsets` calls with directional equivalents.
- Replaced status title numeric line-height override with the existing
  `baseMedium` typography token height.
- Preserved current-code masking, reveal/copy/edit/generate/save actions,
  input formatter, uppercase conversion, examples, warning copy, high-risk
  review panel, and security-center back route.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- P2P security: anti-phishing code visibility, edit state, examples, warnings,
  save readiness, and security-center return path remain intact.
- Financial safety: no P2P order, escrow, wallet, payment method, or security
  confirmation behavior changed.
- Sensitive data masking: the anti-phishing code remains masked until reveal;
  no account, wallet, email, phone, or address data was added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_anti_phishing_code_page_test.dart`.
- Route: `/p2p/security/anti-phishing`.
- Result: first viewport reaches the code card, reveal control, and edit action;
  reveal/update flow and back navigation remain stable.
- Artifact: `test/features/p2p/p2p_anti_phishing_code_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart lib/features/p2p/presentation/widgets/p2p_anti_phishing_code_page_sections.dart lib/features/p2p/presentation/widgets/p2p_anti_phishing_code_page_common.dart test/features/p2p/p2p_anti_phishing_code_page_test.dart` - pass.
- `flutter test test/features/p2p/p2p_anti_phishing_code_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1026`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/earn/presentation/pages/staking_community_governance_page.dart`.

### Batch 2026-06-21-21 - SC-388 Staking Community Governance

Status: `fixed`

Screens:
- `lib/features/earn/presentation/pages/staking_community_governance_page.dart`
- `lib/features/earn/presentation/widgets/staking_community_governance_page_common.dart`
- `lib/features/earn/presentation/widgets/staking_community_governance_page_sections.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; existing compact-first dirty
  changes in the worktree already added first-viewport coverage.
- Token debt before: root page bundle `7`.
- Token debt after: root page bundle `0`; page and both widget parts pass.
- Module checkpoint after regeneration: `total_debt=1006`,
  `scope_root_page_bundle_summary_debt=433`.

GitNexus:
- Context target: `StakingCommunityGovernancePage`.
- Class impact: `CRITICAL` because the screen is route-owned by `_earnRoutes`
  and imported by the app router.
- Direct callers/importers: `_earnRoutes` and
  `flutter_app/lib/app/router/app_router.dart`.
- Narrowed edit targets: `_InfoBanner`, `_StepRow`, `_FooterNote`, and `_Pill`
  all reported `LOW` risk with no affected processes.

Implementation:
- Replaced root scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced info banner, step badge, step description, footer note, and pill
  numeric/static line-height overrides with existing typography token heights.
- Replaced the governance step badge two-axis `SizedBox` dimensions with
  `SizedBox.square` while preserving dimensions.
- Preserved stats, active proposal entry, recent decisions, governance steps,
  voting power, proposals/forum navigation, footer note, and header back route.
- Worked with pre-existing compact-first dirty changes in the same screen/test
  without reverting them.

Safety / boundary review:
- Earn governance: on-chain governance copy, proposal semantics, voting power,
  decision history, and CTA routes remain intact.
- Financial safety: no staking position, subscribe, withdraw, reward, or
  emergency behavior changed.
- Sensitive data masking: no sensitive account, wallet, email, phone, or
  address data was added or unmasked.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/earn/staking_community_governance_page_test.dart`.
- Route: `/earn/community/governance`.
- Result: first viewport reaches governance overview; proposal, decisions,
  steps, voting power, proposals route, forum route, and header back remain
  stable.
- Artifact: `test/features/earn/staking_community_governance_page_test.dart`.

Verification:
- `dart format lib/features/earn/presentation/pages/staking_community_governance_page.dart lib/features/earn/presentation/widgets/staking_community_governance_page_common.dart lib/features/earn/presentation/widgets/staking_community_governance_page_sections.dart test/features/earn/staking_community_governance_page_test.dart` - pass.
- `flutter test test/features/earn/staking_community_governance_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=1006`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/arena/presentation/pages/arena_flow_map_page.dart`.

### Batch 2026-06-21-22 - SC-197 Arena Flow Map

Status: `fixed`

Screens:
- `lib/features/arena/presentation/pages/arena_flow_map_page.dart`
- `lib/features/arena/presentation/widgets/arena_flow_map_overview.dart`
- `lib/features/arena/presentation/widgets/arena_flow_map_nodes.dart`
- `lib/features/arena/presentation/widgets/arena_flow_map_qa.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; first-viewport coverage already
  asserts the first route registry row.
- Token debt before: root page bundle `6`.
- Token debt after: root page bundle `0`; root page and all widget parts pass.
- Module checkpoint after regeneration: `total_debt=994`,
  `scope_root_page_bundle_summary_debt=427`.

GitNexus:
- Context target: `ArenaFlowMapPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to root-page padding constants used by the part
  widgets.

Implementation:
- Replaced the six root `EdgeInsets` padding constants with
  `EdgeInsetsDirectional` equivalents.
- Preserved collapsible flow sections, route registry, flow-node navigation,
  QA checklist state, handoff notes, disclaimer, and header back behavior.
- Preserved all Open Arena copy and the points-only module boundary.

Safety / boundary review:
- Open Arena: points-only, moderation, completion, and fair-play semantics stay
  intact.
- Prediction Markets boundary: no position, payout, wallet, P/L, profit, or
  stake-return language was added to Arena.
- Financial safety: no wallet, withdrawal, trading, escrow, or payment method
  behavior changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/arena/arena_flow_map_page_test.dart`.
- Route: `/arena/flow-map`.
- Result: first viewport reaches the route registry row; route-node navigation,
  handoff expansion, QA expansion, QA toggle, and safe canonical routes remain
  stable.
- Artifact: `test/features/arena/arena_flow_map_page_test.dart`.

Verification:
- `dart format lib/features/arena/presentation/pages/arena_flow_map_page.dart lib/features/arena/presentation/widgets/arena_flow_map_overview.dart lib/features/arena/presentation/widgets/arena_flow_map_nodes.dart lib/features/arena/presentation/widgets/arena_flow_map_qa.dart test/features/arena/arena_flow_map_page_test.dart` - pass.
- `flutter test test/features/arena/arena_flow_map_page_test.dart --reporter=compact` - pass.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` - pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=994`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `dart run tool/ui_fullscreen_density_audit.dart` - regenerated artifacts.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/markets/presentation/pages/market_overview_page.dart`.

### Batch 2026-06-21-23 - SC-009 Market Overview

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/market_overview_page.dart`
- `lib/features/markets/presentation/pages/market_overview_page_part_01.dart`
- `lib/features/markets/presentation/pages/market_overview_page_part_02.dart`
- `lib/features/markets/presentation/pages/market_overview_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains `PASS_MONITOR`; first-viewport coverage reaches
  the market navigation cards.
- Token debt before: root page bundle `28` (`27` raw near-one line heights and
  `1` raw `EdgeInsets`).
- Token debt after: root page bundle `0`; root page and all three parts pass.
- Module checkpoint after regeneration: `total_debt=938`,
  `scope_root_page_bundle_summary_debt=399`, `p0_markets_debt=35`.

GitNexus:
- Context target: `MarketOverviewPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to typography line-height tokens and one sector
  row padding expression in the page bundle.

Implementation:
- Replaced all `height: 1` and `height: 1.15` text overrides in the three part
  files with existing theme token heights.
- Used compact token heights for fixed-height sentiment cards so the market
  breadth and Fear & Greed widgets preserve their dense layout.
- Replaced the sector-row raw vertical `EdgeInsets` with
  `EdgeInsetsDirectional.symmetric`.
- Preserved global stats, hero metric cards, quick navigation, movers, sector
  navigation, Fear & Greed history, tool links, refresh/read-model data, and
  header back behavior.

Safety / boundary review:
- Markets: market cap, breadth, movers, sectors, heatmap, alerts, watchlist,
  and market-list semantics remain intact.
- Financial safety: no trading, deposit, withdrawal, escrow, or payment method
  confirmation behavior changed.
- Product boundary: no Prediction Markets or Open Arena copy/flow changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/market_overview_page_test.dart`.
- Route: `/markets/overview`.
- Result: first viewport reaches the market movers shortcut; quick cards,
  movers header route, sector row route, tools, and back navigation remain
  stable.
- Regression found and fixed: the first focused run caught a 1-9 px overflow in
  fixed-height sentiment cards after initial tokenization; compact line-height
  tokens fixed the overflow while keeping audit clean.
- Artifact: `test/features/markets/market_overview_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/market_overview_page.dart lib/features/markets/presentation/pages/market_overview_page_part_01.dart lib/features/markets/presentation/pages/market_overview_page_part_02.dart lib/features/markets/presentation/pages/market_overview_page_part_03.dart test/features/markets/market_overview_page_test.dart` - pass.
- `flutter test test/features/markets/market_overview_page_test.dart --reporter=compact` - pass.
- `flutter test test/features/markets --reporter=compact` - pass, `145`
  tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=938`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart` - regenerated artifacts.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P2=1`, `P3=194`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains `PASS_MONITOR`.
- Next row:
  `lib/features/dca/presentation/pages/dca_page.dart`.

### Batch 2026-06-21-24 - SC-169 DCA Main

Status: `fixed`

Screens:
- `lib/features/dca/presentation/pages/dca_page.dart`
- `lib/features/dca/presentation/pages/dca_page_part_01.dart`
- `lib/features/dca/presentation/pages/dca_page_part_02.dart`
- `lib/features/dca/presentation/pages/dca_page_part_03.dart`
- `lib/features/dca/presentation/pages/dca_page_part_04.dart`

Audit input:
- Body grade: `A`.
- Density before/after: first pass briefly created one P1 visual-density row;
  final audit is back to `P1_HIGH_DENSITY_REVIEW=0`.
- Token debt before: root page bundle `21` (`15` raw near-one line heights and
  `6` raw `SizedBox` dimensions).
- Token debt after: root page bundle `0`; root page and all four parts pass.
- Module checkpoint after regeneration: `total_debt=896`,
  `scope_root_page_bundle_summary_debt=378`.

GitNexus:
- Initial symbol lookup for `DcaPage` failed because the actual class is
  `DCAPage`.
- Context target: `DCAPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to line-height tokens and square/bar dimensions in
  the root page bundle.

Implementation:
- Replaced all raw `height: 1.04`, `height: 1.08`, and `height: 1.18`
  typography overrides with `AppTextStyles` token heights.
- Converted raw 28/32/36 icon boxes to `SizedBox.square` with token-derived
  dimensions that preserve the existing compact sizes.
- Replaced the raw plan status bar height with
  `AppSpacing.dcaMainPlanStatusBarHeight`.
- Preserved DCA dashboard state, create sheet, pause/history actions, plan
  cards, advanced tool routes, chart painters, and header back behavior.

Safety / boundary review:
- DCA investment semantics, plan amounts, holdings, frequency, P/L labels, and
  next-purchase copy remain intact.
- Financial safety: no plan creation confirmation, routing, pause/delete
  behavior, balance, order, or trading execution logic changed.
- Product boundary: no Prediction Markets, Open Arena, wallet, or P2P copy/flow
  changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/dca/dca_page_test.dart`.
- Route: `/dca`.
- Result: first viewport reaches the first DCA plan card; create sheet, history
  tab, advanced tool links, and trade bottom-nav state remain stable.
- Regression found and fixed: using `AppSpacing` line-height tokens produced a
  new `P1_HIGH_DENSITY_REVIEW` row due tokenized fixed-height pressure; moving
  text line-height to `AppTextStyles` tokens removed the P1 while preserving
  token consistency.
- Artifact: `test/features/dca/dca_page_test.dart`.

Verification:
- `dart format lib/features/dca/presentation/pages/dca_page.dart lib/features/dca/presentation/pages/dca_page_part_01.dart lib/features/dca/presentation/pages/dca_page_part_02.dart lib/features/dca/presentation/pages/dca_page_part_03.dart lib/features/dca/presentation/pages/dca_page_part_04.dart test/features/dca/dca_page_test.dart` - pass.
- `flutter test test/features/dca/dca_page_test.dart --reporter=compact` -
  pass.
- `flutter test test/features/dca --reporter=compact` - pass, `51` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=896`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart` - regenerated artifacts.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/markets/presentation/pages/token_info_page.dart`.

### Batch 2026-06-21-25 - SC-045 Token Info

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/token_info_page.dart`
- `lib/features/markets/presentation/widgets/token_info_tabs_widgets.dart`
- `lib/features/markets/presentation/widgets/token_info_market_widgets.dart`
- `lib/features/markets/presentation/widgets/token_info_detail_widgets.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first-viewport coverage reaches the
  market statistics card.
- Token debt before: root page bundle `14` (`14` raw `EdgeInsets`).
- Token debt after: root page bundle `0`; root page and all three widgets pass.
- Module checkpoint after regeneration: `total_debt=867`,
  `scope_root_page_bundle_summary_debt=364`, `p0_markets_debt=20`.

GitNexus:
- Context target: `TokenInfoPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to page and tab padding expressions.

Implementation:
- Replaced all token-info padding constants with `EdgeInsetsDirectional`
  equivalents.
- Replaced the scroll bottom padding with `EdgeInsetsDirectional.only`.
- Replaced tab vertical padding with `EdgeInsetsDirectional.symmetric`.
- Preserved overview/on-chain/project tabs, market statistics, token supply,
  distribution, ATH/ATL, chart CTA, project links, disclaimer, and back route.

Safety / boundary review:
- Markets token information semantics, pair data, market metrics, and on-chain
  information remain intact.
- Financial safety: no order, trading, wallet, deposit, withdrawal, or alert
  behavior changed.
- Product boundary: no Prediction Markets, Open Arena, P2P, or DCA copy/flow
  changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/token_info_page_test.dart`.
- Route: `/markets/pair/btcusdt/info`.
- Result: first viewport reaches the market statistics card; tab switching,
  chart CTA, back route, and trade-shell bottom nav remain stable.
- Artifact: `test/features/markets/token_info_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/token_info_page.dart lib/features/markets/presentation/widgets/token_info_tabs_widgets.dart lib/features/markets/presentation/widgets/token_info_market_widgets.dart lib/features/markets/presentation/widgets/token_info_detail_widgets.dart test/features/markets/token_info_page_test.dart` - pass.
- `flutter test test/features/markets/token_info_page_test.dart --reporter=compact` - pass.
- `flutter test test/features/markets --reporter=compact` - pass, `145`
  tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=867`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/markets/presentation/pages/portfolio_tracker_page.dart`.

### Batch 2026-06-21-26 - SC-021 Portfolio Tracker

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/portfolio_tracker_page.dart`
- `lib/features/markets/presentation/pages/portfolio_tracker_page_part_01.dart`
- `lib/features/markets/presentation/pages/portfolio_tracker_page_part_02.dart`
- `lib/features/markets/presentation/pages/portfolio_tracker_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first-viewport coverage reaches the
  first holding row.
- Token debt before: root page bundle `12` (`12` raw `EdgeInsets`).
- Token debt after: root page bundle `0`; root page and all three parts pass.
- Module checkpoint after regeneration: `total_debt=843`,
  `scope_root_page_bundle_summary_debt=352`, `p0_markets_debt=8`.

GitNexus:
- Context target: `PortfolioTrackerPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to root page and scroll padding expressions.

Implementation:
- Replaced all portfolio tracker padding constants with
  `EdgeInsetsDirectional` equivalents.
- Replaced the scroll bottom padding with `EdgeInsetsDirectional.only`.
- Preserved overview/assets/performance tabs, balance masking, allocation
  donut, holdings, risk card, performance chart, PnL breakdown, pair-detail
  navigation, and back route.

Safety / boundary review:
- Portfolio value, cost basis, PnL, allocation, sort, risk, and masked balance
  behavior remain intact.
- Financial safety: no trade, deposit, withdrawal, transfer, alert, or order
  execution behavior changed.
- Sensitive data: balance masking remains tested and unchanged.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/portfolio_tracker_page_test.dart`.
- Route: `/markets/portfolio-tracker`.
- Result: first viewport reaches first holding row; masking, tabs, chart,
  holding route, and back navigation remain stable.
- Artifact: `test/features/markets/portfolio_tracker_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/portfolio_tracker_page.dart lib/features/markets/presentation/pages/portfolio_tracker_page_part_01.dart lib/features/markets/presentation/pages/portfolio_tracker_page_part_02.dart lib/features/markets/presentation/pages/portfolio_tracker_page_part_03.dart test/features/markets/portfolio_tracker_page_test.dart` - pass.
- `flutter test test/features/markets/portfolio_tracker_page_test.dart --reporter=compact` - pass.
- `flutter test test/features/markets --reporter=compact` - pass, `145`
  tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=843`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_order_page.dart`.

### Batch 2026-06-21-27 - SC-216 P2P Order

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_order_page.dart`
- `lib/features/p2p/presentation/pages/p2p_order_page_part_01.dart`
- `lib/features/p2p/presentation/pages/p2p_order_page_part_02.dart`
- `lib/features/p2p/presentation/pages/p2p_order_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport keeps escrow,
  payment, and action controls visible.
- Token debt before: root page bundle `10` (`7` raw `EdgeInsets`, `3`
  near-one line heights).
- Token debt after: root page bundle `0`; root page and all three parts pass.
- Module checkpoint after regeneration: `total_debt=823`,
  `scope_root_page_bundle_summary_debt=342`, `p0_p2p_debt=85`.

GitNexus:
- Context target: `P2POrderPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to padding and local text line-height
  normalization.

Implementation:
- Replaced order, stepper, safety, escrow, and info-line padding constants
  with `EdgeInsetsDirectional` equivalents.
- Replaced dense safety/escrow detail text heights with existing
  `AppTextStyles.numericMicro.height` rather than adding ad hoc values.
- Preserved QR/copy, mark-paid, proof, cancel, chat, escrow detail, and route
  behavior.

Safety / boundary review:
- P2P payment and escrow copy remains boundary-safe.
- High-risk confirmation roles remain present in the P2P/wallet guardrail
  test.
- No wallet, order, dispute, proof upload, transfer, or escrow state logic was
  changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_order_page_test.dart`.
- Route: `/p2p/order/:id`.
- Result: first viewport still reaches escrow and payment controls; copy, QR,
  mark-paid, proof, cancel, chat, and escrow routes remain stable.
- Artifact: `test/features/p2p/p2p_order_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_order_page.dart lib/features/p2p/presentation/pages/p2p_order_page_part_01.dart lib/features/p2p/presentation/pages/p2p_order_page_part_02.dart lib/features/p2p/presentation/pages/p2p_order_page_part_03.dart test/features/p2p/p2p_order_page_test.dart` - pass.
- `flutter test test/features/p2p/p2p_order_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=823`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/earn/presentation/pages/staking_proof_of_reserves_page.dart`.

### Batch 2026-06-21-28 - SC-380 Staking Proof of Reserves

Status: `fixed`

Screens:
- `lib/features/earn/presentation/pages/staking_proof_of_reserves_page.dart`
- `lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_01.dart`
- `lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_02.dart`
- `lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_03.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  reserve ratio trend preview.
- Token debt before: root page bundle `8` (`1` raw `EdgeInsets`, `7`
  near-one line heights); bundle carried a `CustomPainter` exception label.
- Token debt after: root page bundle `0`; all four files have zero debt.
- Module checkpoint after regeneration: `total_debt=807`,
  `scope_root_page_bundle_summary_debt=334`.

GitNexus:
- Context target: `StakingProofOfReservesPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to scroll padding and local text style overrides.

Implementation:
- Replaced scroll bottom padding with `EdgeInsetsDirectional.only`.
- Removed ad hoc `height: 1.2` overrides from caption/micro copy so text uses
  the canonical `AppTextStyles` line-height tokens.
- Preserved reserve progress painter, trend painter, chart extents, proof
  sheet, Merkle proof flow, audit cards, asset tab, and back route.

Safety / boundary review:
- Proof-of-reserves copy remains informational and verification-focused.
- No subscription, staking, wallet, proof generation, or repository behavior
  changed.
- The `CustomPainter` exception label remains only as a source-context marker;
  the target bundle now has zero token debt.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/earn/staking_proof_of_reserves_page_test.dart`.
- Route: `/earn/proof-of-reserves`.
- Result: first viewport still reaches the reserve ratio trend preview; tabs,
  Merkle verification sheet, proof result, and back navigation remain stable.
- Artifact: `test/features/earn/staking_proof_of_reserves_page_test.dart`.

Verification:
- `dart format lib/features/earn/presentation/pages/staking_proof_of_reserves_page.dart lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_01.dart lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_02.dart lib/features/earn/presentation/pages/staking_proof_of_reserves_page_part_03.dart test/features/earn/staking_proof_of_reserves_page_test.dart` - pass.
- `flutter test test/features/earn/staking_proof_of_reserves_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/earn --reporter=compact` - pass, `380` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=807`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: source-context `CustomPainter` label only; target bundle
  debt is zero and density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_kyc_requirements_page.dart`.

### Batch 2026-06-21-29 - SC-247 P2P KYC Requirements

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_kyc_requirements_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_kyc_requirements_page_sections.dart`
- `lib/features/p2p/presentation/widgets/p2p_kyc_requirements_page_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  current P2P KYC tier card.
- Token debt before: root page bundle `6` (`6` raw `EdgeInsets`).
- Token debt after: root page bundle `0`; root page and shared widgets pass.
- Module checkpoint after regeneration: `total_debt=795`,
  `scope_root_page_bundle_summary_debt=328`, `p0_p2p_debt=79`.

GitNexus:
- Context target: `P2PKycRequirementsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced root scroll padding with `EdgeInsetsDirectional.fromSTEB`.
- Replaced shared KYC card, notice, tier-section, tier-action, and checklist
  icon padding constants with `EdgeInsetsDirectional` equivalents.
- Preserved tier status, KYC limits, upgrade route, support route, and high-risk
  state panel.

Safety / boundary review:
- P2P KYC and limit-impact copy remains visible before verification actions.
- No identity verification, tier upgrade, support routing, P2P wallet, escrow,
  or payment behavior changed.
- P2P boundary language remains compliance-focused and escrow-safe.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_kyc_requirements_page_test.dart`.
- Route: `/p2p/kyc/requirements`.
- Result: first viewport still reaches the current KYC tier card; upgrade and
  support navigation remain stable.
- Artifact: `test/features/p2p/p2p_kyc_requirements_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_kyc_requirements_page.dart lib/features/p2p/presentation/widgets/p2p_kyc_requirements_page_common.dart lib/features/p2p/presentation/widgets/p2p_kyc_requirements_page_sections.dart test/features/p2p/p2p_kyc_requirements_page_test.dart` - pass.
- `flutter test test/features/p2p/p2p_kyc_requirements_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  pre-existing non-fatal hit-test warning remains in
  `p2p_payment_methods_page_test.dart`.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=795`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart`.

### Batch 2026-06-21-30 - SC-039 Prediction Event Calendar

Status: `fixed`

Screens:
- `lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart`
- `lib/features/predictions/presentation/widgets/prediction_event_calendar_controls.dart`
- `lib/features/predictions/presentation/widgets/prediction_event_calendar_events.dart`
- `lib/features/predictions/presentation/widgets/prediction_event_calendar_notifications.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  first calendar event card.
- Token debt before: root page bundle `6` (`6` raw `EdgeInsets`) across
  feature widgets.
- Token debt after: root page bundle `0`; root page and all calendar widgets
  pass.
- Module checkpoint after regeneration: `total_debt=777`,
  `scope_feature_widget_debt=252`,
  `scope_root_page_bundle_summary_debt=322`.

GitNexus:
- Context target: `PredictionEventCalendarPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding/margin in calendar widgets.

Implementation:
- Replaced filter chip padding, status/category pill padding, watching category
  padding, notification row padding, and toggle knob margin with
  `EdgeInsetsDirectional` equivalents.
- Preserved calendar/upcoming/notification tabs, category filters, event card
  navigation, watchlist summaries, probabilities, volumes, and notification
  settings.

Safety / boundary review:
- Prediction Markets copy remains event/probability/volume focused.
- No Arena points language, challenge mechanics, wallet, order, or trading
  execution behavior was introduced or changed.
- Event detail navigation and Predictions home back route remain tested.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/predictions/prediction_event_calendar_page_test.dart`.
- Route: `/markets/predictions/calendar`.
- Result: first viewport still reaches the first event card; filters, tabs,
  event detail route, and back navigation remain stable.
- Artifact: `test/features/predictions/prediction_event_calendar_page_test.dart`.

Verification:
- `dart format lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart lib/features/predictions/presentation/widgets/prediction_event_calendar_controls.dart lib/features/predictions/presentation/widgets/prediction_event_calendar_events.dart lib/features/predictions/presentation/widgets/prediction_event_calendar_notifications.dart test/features/predictions/prediction_event_calendar_page_test.dart` - pass.
- `flutter test test/features/predictions/prediction_event_calendar_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/predictions --reporter=compact` - pass, `104`
  tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=777`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/markets/presentation/pages/price_alerts_page.dart`.

### Batch 2026-06-21-31 - SC-014 Price Alerts

Status: `fixed`

Screens:
- `lib/features/markets/presentation/pages/price_alerts_page.dart`
- `lib/features/markets/presentation/widgets/price_alerts_page_overview.dart`
- `lib/features/markets/presentation/widgets/price_alerts_page_details.dart`
- `lib/features/markets/presentation/widgets/price_alerts_page_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  first price alert card.
- Token debt before: root page bundle `6` (`6` raw `EdgeInsets`) in root page
  padding constants.
- Token debt after: root page bundle `0`; root page and all feature widgets
  pass.
- Module checkpoint after regeneration: `total_debt=765`,
  `scope_root_page_bundle_summary_debt=316`, `p0_markets_debt=2`.

GitNexus:
- Context target: `PriceAlertsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced scroll, notice, filter header, filter tab, alert card, and empty
  state padding constants with `EdgeInsetsDirectional` equivalents.
- Preserved alert counts, active/triggered filters, toggle/delete local state,
  add-alert notice, empty state, refresh-state copy, and Markets back route.

Safety / boundary review:
- Market alert copy remains watchlist/price-alert focused.
- No order placement, trade execution, wallet, or high-risk financial
  confirmation behavior changed.
- Toggle and delete behavior still preserve selected pair context in tests.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/price_alerts_page_test.dart`.
- Route: `/markets/alerts`.
- Result: first viewport still reaches the first alert card; filters, local
  actions, add notice, and back navigation remain stable.
- Artifact: `test/features/markets/price_alerts_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/price_alerts_page.dart lib/features/markets/presentation/widgets/price_alerts_page_common.dart lib/features/markets/presentation/widgets/price_alerts_page_details.dart lib/features/markets/presentation/widgets/price_alerts_page_overview.dart test/features/markets/price_alerts_page_test.dart` - pass.
- `flutter test test/features/markets/price_alerts_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/markets --reporter=compact` - pass, `145`
  tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=765`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_blacklist_page.dart`.

### Batch 2026-06-21-32 - SC-277 P2P Blacklist

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_blacklist_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_blacklist_common.dart`
- `lib/features/p2p/presentation/widgets/p2p_blacklist_entries.dart`
- `lib/features/p2p/presentation/widgets/p2p_blacklist_summary_filters.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches search
  and first blocked user row.
- Token debt before: root page bundle `6` (`6` raw `EdgeInsets`) across
  feature widgets.
- Token debt after: root page bundle `0`; root page and blacklist widgets pass.
- Module checkpoint after regeneration: `total_debt=747`,
  `scope_feature_widget_debt=240`,
  `scope_root_page_bundle_summary_debt=310`, `p0_p2p_debt=67`.

GitNexus:
- Context target: `P2PBlacklistPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding in blacklist widgets.

Implementation:
- Replaced summary, entry row, expanded entry, reason detail, order link, and
  tiny stat padding with `EdgeInsetsDirectional.all`.
- Preserved search, reason filters, entry expansion, unblock action, add route,
  support context, and P2P parent back route.

Safety / boundary review:
- P2P blacklist copy remains safety/compliance focused.
- No escrow, payment, wallet, merchant profile, order, report, or unblock
  state logic changed.
- Reason filtering, search filtering, add action, and unblock action remain
  covered by focused tests.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_blacklist_page_test.dart`.
- Route: `/p2p/blacklist`.
- Result: first viewport still reaches search and the first blocked user row;
  filters, search, add route, expand/unblock, and back navigation remain stable.
- Artifact: `test/features/p2p/p2p_blacklist_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_blacklist_page.dart lib/features/p2p/presentation/widgets/p2p_blacklist_common.dart lib/features/p2p/presentation/widgets/p2p_blacklist_entries.dart lib/features/p2p/presentation/widgets/p2p_blacklist_summary_filters.dart test/features/p2p/p2p_blacklist_page_test.dart` - pass.
- `flutter test test/features/p2p/p2p_blacklist_page_test.dart --reporter=compact` -
  pass, `8` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  pre-existing non-fatal hit-test warning remains in
  `p2p_payment_methods_page_test.dart`.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=747`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/wallet/presentation/pages/deposit_page.dart`.

### Batch 2026-06-21-33 - SC-137 Deposit

Status: `fixed`

Screens:
- `lib/features/wallet/presentation/pages/deposit_page.dart`
- `lib/features/wallet/presentation/widgets/deposit_page_sections.dart`
- `lib/features/wallet/presentation/widgets/deposit_page_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  copy-address action.
- Token debt before: root page bundle `6` (`5` raw `EdgeInsets`, `1`
  raw `SizedBox` dimension); bundle carried a `CustomPainter` exception label.
- Token debt after: root page bundle `0`; page and widgets have zero debt.
- Module checkpoint after regeneration: `total_debt=732`,
  `scope_feature_widget_debt=234`,
  `scope_root_page_bundle_summary_debt=304`, `p0_wallet_debt=39`.

GitNexus:
- Context target: `DepositPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route layer direct count `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants and one tokenized
  status-dot size.

Implementation:
- Replaced deposit card, compact, sheet, copy-button, and QR padding with
  `EdgeInsetsDirectional` equivalents.
- Replaced the raw network-health dot size with a token expression.
- Preserved QR painter, address display, copy action, network picker, warning
  panel, min-deposit/confirmation copy, refresh action, asset-scoped route, and
  Wallet back route.

Safety / boundary review:
- Deposit network warning remains visible and unchanged.
- Wrong-network and minimum-deposit copy remains intact.
- No address, QR, network selection, clipboard, wallet, transfer, or
  transaction behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/wallet/deposit_page_test.dart`.
- Route: `/wallet/deposit`.
- Result: first viewport still reaches the copy-address action; network picker,
  asset-scoped route, warning copy, QR/address display, and shell route remain
  stable.
- Artifact: `test/features/wallet/deposit_page_test.dart`.

Verification:
- `dart format lib/features/wallet/presentation/pages/deposit_page.dart lib/features/wallet/presentation/widgets/deposit_page_common.dart lib/features/wallet/presentation/widgets/deposit_page_sections.dart test/features/wallet/deposit_page_test.dart` - pass.
- `flutter test test/features/wallet/deposit_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/wallet --reporter=compact` - pass, `83` tests.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=732`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: source-context `CustomPainter` label only; target bundle
  debt is zero and density remains below P1.
- Next row:
  `lib/features/predictions/presentation/pages/predictions_breaking_page.dart`.

### Batch 2026-06-21-34 - SC-029 Predictions Breaking

Status: `fixed`

Screens:
- `lib/features/predictions/presentation/pages/predictions_breaking_page.dart`
- `lib/features/predictions/presentation/widgets/predictions_breaking_page_common.dart`
- `lib/features/predictions/presentation/widgets/predictions_breaking_page_sections.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  first breaking mover card.
- Token debt before: root page bundle `5` raw `EdgeInsets`.
- Token debt after: root page bundle `0`; page and widgets have zero debt.
- Module checkpoint after regeneration: `total_debt=718`,
  `scope_feature_widget_debt=226`,
  `scope_root_page_bundle_summary_debt=299`, `p0_markets_debt=2`.

GitNexus:
- Context target: `PredictionsBreakingPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_predictionRoutes` and `app_router.dart`, direct
  count `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced the scroll bottom inset with `EdgeInsetsDirectional.only`.
- Replaced Subscribe, category tab, change badge, and tiny badge padding with
  `EdgeInsetsDirectional.symmetric`.
- Preserved category filtering, mover ordering, event-detail navigation,
  email subscription state, Markets shell, and Prediction Markets copy.

Safety / boundary review:
- Prediction Markets terminology remains positions/probability/receipt/reward
  safe; no Arena points or P2P wallet language was introduced.
- No route, repository, controller, analytics, or financial behavior changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/predictions/predictions_breaking_page_test.dart`.
- Route: `/markets/predictions/breaking`.
- Result: first viewport still reaches the first mover card; shell, category
  chips, subscribe CTA, event navigation, and back route remain stable.
- Artifact: `test/features/predictions/predictions_breaking_page_test.dart`.

Verification:
- `dart format lib/features/predictions/presentation/pages/predictions_breaking_page.dart lib/features/predictions/presentation/widgets/predictions_breaking_page_common.dart lib/features/predictions/presentation/widgets/predictions_breaking_page_sections.dart` - pass.
- `flutter test test/features/predictions/predictions_breaking_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/predictions --reporter=compact` - pass,
  `104` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=718`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_address_proof_page.dart`.

### Batch 2026-06-21-35 - SC-250 P2P Address Proof

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_address_proof_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_address_proof_page_sections.dart`
- `lib/features/p2p/presentation/widgets/p2p_address_proof_page_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  document requirements and first document choice.
- Token debt before: root page bundle `5` raw `EdgeInsets`, all in sections.
- Token debt after: root page bundle `0`; page and widgets have zero debt.
- Module checkpoint after regeneration: `total_debt=703`,
  `scope_feature_widget_debt=216`,
  `scope_root_page_bundle_summary_debt=294`, `p0_p2p_debt=57`.

GitNexus:
- Context target: `P2PAddressProofPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced hero, document type, uploaded-state, empty-upload, and upload icon
  padding with `EdgeInsetsDirectional` equivalents.
- Preserved document type selection, upload/remove state, OCR extracted data,
  manual address confirmation, submit routing, and P2P KYC status back route.

Safety / boundary review:
- Address proof state review remains visible.
- Document type, upload status, extracted address, manual confirmation, and
  next verification step remain unchanged before submission.
- No P2P escrow, KYC, wallet, route, provider, or copy behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_address_proof_page_test.dart`.
- Route: `/p2p/kyc/address`.
- Result: first viewport still reaches requirements and first document choice;
  upload state, extracted data, address confirmation, submit, and back route
  remain stable.
- Artifact: `test/features/p2p/p2p_address_proof_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/widgets/p2p_address_proof_page_sections.dart` -
  pass.
- `flutter test test/features/p2p/p2p_address_proof_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=703`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_login_history_page.dart`.

### Batch 2026-06-21-36 - SC-257 P2P Login History

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_login_history_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_login_history_events.dart`
- `lib/features/p2p/presentation/widgets/p2p_login_history_summary_filters.dart`
- `lib/features/p2p/presentation/widgets/p2p_login_history_common.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches the
  filters, suspicious-login warning, and first login event.
- Token debt before: root page bundle `5` raw `EdgeInsets`.
- Token debt after: root page bundle `0`; page and widgets have zero debt.
- Module checkpoint after regeneration: `total_debt=688`,
  `scope_feature_widget_debt=206`,
  `scope_root_page_bundle_summary_debt=289`, `p0_p2p_debt=47`.

GitNexus:
- Context target: `P2PLoginHistoryPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced stat tile, risk warning, event card, expanded-detail, and
  suspicious-detail padding with `EdgeInsetsDirectional` equivalents.
- Preserved all-login/success/suspicious filters, event expansion, current
  device badge, warning copy, security tips, export action, and back route.

Safety / boundary review:
- Suspicious login warning remains visible.
- IP address, login method, location, device, and 90-day security note copy
  remain unchanged.
- No P2P security-center, device, auth, route, provider, or copy behavior
  changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_login_history_page_test.dart`.
- Route: `/p2p/security/login-history`.
- Result: first viewport still reaches filters, warning, and first event;
  suspicious filtering, expanded details, and back route remain stable.
- Artifact: `test/features/p2p/p2p_login_history_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/widgets/p2p_login_history_summary_filters.dart lib/features/p2p/presentation/widgets/p2p_login_history_events.dart` -
  pass.
- `flutter test test/features/p2p/p2p_login_history_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=688`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass after
  rerun; first parallel attempt raced the regenerate step and reported stale
  artifacts.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_dispute_page.dart`.

### Batch 2026-06-21-37 - SC-221 P2P Dispute

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_dispute_page.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still keeps dispute
  choices compact and reaches the description label.
- Token debt before: root page bundle `4` raw `EdgeInsets`; bundle carried a
  `CustomPainter` exception label for the dashed upload border.
- Token debt after: root page bundle `0`; exception label remains
  `allowed_source_keyword: custompainter`.
- Module checkpoint after regeneration: `total_debt=680`,
  `scope_root_page_debt=189`,
  `scope_root_page_bundle_summary_debt=285`, `p0_p2p_debt=43`.

GitNexus:
- Context target: `P2PDisputePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants; dashed border
  painter was not changed.

Implementation:
- Replaced dispute hero, hero icon, reason tile, and evidence upload padding
  with `EdgeInsetsDirectional` equivalents.
- Preserved selected reason state, description field, evidence upload state,
  submit enablement, dispute detail route, and order back route.

Safety / boundary review:
- Dispute submission review remains visible.
- Reason, description, uploaded evidence, escrow impact, case target, and next
  dispute step remain unchanged before submission.
- No escrow, evidence, route, provider, painter, or copy behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_dispute_page_test.dart`.
- Route: `/p2p/orders/:orderId/dispute`.
- Result: first viewport still keeps reason choices compact; evidence upload,
  submit enablement, detail navigation, and back route remain stable.
- Artifact: `test/features/p2p/p2p_dispute_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_dispute_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_dispute_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=680`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: `CustomPainter` dashed upload border only; target bundle
  debt is zero and density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_insurance_policy_page.dart`.

### Batch 2026-06-21-38 - SC-241 P2P Insurance Policy

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_insurance_policy_page.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches policy
  version summary, coverage notice, and section list.
- Token debt before: root page bundle `4` raw `EdgeInsets`.
- Token debt after: root page bundle `0`; page has zero debt.
- Module checkpoint after regeneration: `total_debt=672`,
  `scope_root_page_debt=185`,
  `scope_root_page_bundle_summary_debt=281`, `p0_p2p_debt=39`.

GitNexus:
- Context target: `P2PInsurancePolicyPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced policy hero, coverage notice, policy section, and privacy notice
  card padding with `EdgeInsetsDirectional` equivalents.
- Preserved policy version, last updated date, all ten section terms, privacy
  notice, high-risk review panel, and insurance fund back route.

Safety / boundary review:
- P2P insurance policy state review remains visible.
- Policy version, coverage notice, section terms, privacy handling, and current
  policy state remain unchanged before insurance decisions.
- No insurance, escrow, policy, route, provider, or copy behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_insurance_policy_page_test.dart`.
- Route: `/p2p/insurance/policy`.
- Result: first viewport still reaches hero, notice, and section list; full
  document scroll to privacy notice and back route remain stable.
- Artifact: `test/features/p2p/p2p_insurance_policy_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_insurance_policy_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_insurance_policy_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=672`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_report_merchant_page.dart`.

### Batch 2026-06-21-39 - SC-229 P2P Report Merchant

Status: `fixed`

Screens:
- `lib/features/p2p/presentation/pages/p2p_report_merchant_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_report_merchant_summary_actions.dart`
- `lib/features/p2p/presentation/widgets/p2p_report_merchant_reasons_details.dart`

Audit input:
- Body grade: `A`.
- Density before/after: remains below P1; first viewport still reaches block
  action, merchant profile action, and first report reason.
- Token debt before: root page bundle `4` raw `EdgeInsets`.
- Token debt after: root page bundle `0`; page and widgets have zero debt.
- Module checkpoint after regeneration: `total_debt=661`,
  `scope_feature_widget_debt=200`,
  `scope_root_page_bundle_summary_debt=277`, `p0_p2p_debt=32`.

GitNexus:
- Context target: `P2PReportMerchantPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced scroll content padding, merchant summary, report action row, and
  reason card padding with directional equivalents.
- Preserved merchant summary, block action, merchant profile action, reason
  selection, optional detail field, submit loading delay, and back fallback.

Safety / boundary review:
- Report reasons and review notice remain visible and unchanged.
- Blacklist add route, merchant profile route, submit return route, and header
  back fallback remain unchanged.
- No P2P report, fraud-prevention, blacklist, merchant-profile, provider, or
  copy behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_report_merchant_page_test.dart`.
- Route: `/p2p/report/:merchantId`.
- Result: first viewport still reaches quick actions and first report reason;
  detail reveal, submit return, quick action routes, and back fallback remain
  stable.
- Artifact: `test/features/p2p/p2p_report_merchant_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_report_merchant_page.dart lib/features/p2p/presentation/widgets/p2p_report_merchant_reasons_details.dart lib/features/p2p/presentation/widgets/p2p_report_merchant_summary_actions.dart` -
  pass.
- `flutter test test/features/p2p/p2p_report_merchant_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=661`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_order_cancel_page.dart`.

### Batch 40 - SC-214 P2P Order Cancel

Scope:
- `lib/features/p2p/presentation/pages/p2p_order_cancel_page.dart`

Starting audit:
- Design-token audit row: root page warning with `edgeInsets=3`,
  `totalDebt=3`.
- Global snapshot before the batch: `total_debt=661`,
  `scope_root_page_debt=184`,
  `scope_root_page_bundle_summary_debt=277`, `p0_p2p_debt=32`.

GitNexus:
- Context target: `P2POrderCancelPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced cancel hero, reason-list gap, and reason-button horizontal padding
  with directional equivalents.
- Preserved reason-required confirmation, submitting delay, back fallback,
  order summary, warning copy, and route return behavior.

Safety / boundary review:
- Cancellation reason selection, disabled confirm state, warning state, and
  P2P order return path remain unchanged.
- No escrow, merchant, wallet, order-state, route, or product-copy behavior
  changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_order_cancel_page_test.dart`.
- Route: `/p2p/order/:orderId/cancel`.
- Result: first viewport still reaches the order summary, first cancel reason,
  and safe return action; submit and back navigation remain stable.
- Artifact: `test/features/p2p/p2p_order_cancel_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_order_cancel_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_order_cancel_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=655`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=29`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_security_center_page.dart`.

### Batch 41 - SC-253 P2P Security Center

Scope:
- `lib/features/p2p/presentation/pages/p2p_security_center_page.dart`
- `lib/features/p2p/presentation/widgets/p2p_security_center_score_features.dart`
- `lib/features/p2p/presentation/widgets/p2p_security_center_actions_events.dart`

Starting audit:
- Design-token audit row: root page warning with `edgeInsets=3`,
  `totalDebt=3`.
- Global snapshot before the batch: `total_debt=655`,
  `scope_root_page_debt=181`,
  `scope_root_page_bundle_summary_debt=274`, `p0_p2p_debt=29`.

GitNexus:
- Context targets: `P2PSecurityCenterPage` and `P2PWhitelistModePage`.
- Class impact: `CRITICAL` for both route-owned classes because they are
  imported by the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced the shared compact padding constant with an
  `EdgeInsetsDirectional` geometry.
- Replaced both security-center and whitelist scroll paddings with directional
  `start/end/top/bottom` equivalents.
- Preserved security score, feature rows, quick actions, recent events,
  settings route, whitelist route, login-history route, and back route.

Safety / boundary review:
- Security score, feature status, quick-action targets, login events, and
  whitelist review path remain unchanged.
- No device, anti-phishing, login-history, settings, escrow, wallet, or P2P
  copy behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertions in
  `test/features/p2p/p2p_security_center_page_test.dart`.
- Routes: `/p2p/security/center` and `/p2p/security/whitelist`.
- Result: first viewport still reaches security features and whitelist trusted
  device review; feature, view-all, and back route edges remain stable.
- Artifact: `test/features/p2p/p2p_security_center_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_security_center_page.dart lib/features/p2p/presentation/widgets/p2p_security_center_score_features.dart lib/features/p2p/presentation/widgets/p2p_security_center_actions_events.dart` -
  pass.
- `flutter test test/features/p2p/p2p_security_center_page_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=649`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=26`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_order_timeline_page.dart`.

### Batch 42 - SC-212 P2P Order Timeline

Scope:
- `lib/features/p2p/presentation/pages/p2p_order_timeline_page.dart`

Starting audit:
- Design-token audit row: root page warning with `edgeInsets=3`,
  `totalDebt=3`.
- Global snapshot before the batch: `total_debt=649`,
  `scope_root_page_debt=178`,
  `scope_root_page_bundle_summary_debt=271`, `p0_p2p_debt=26`.

GitNexus:
- Context target: `P2POrderTimelinePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced timeline hero card padding, timeline row bottom gap, and event card
  padding with directional equivalents.
- Preserved event order, status labels, actor/time text, connector geometry,
  refresh behavior, empty state, and back fallback.

Safety / boundary review:
- Timeline escrow/status copy and order-detail fallback route remain unchanged.
- No P2P order, escrow, merchant, route, refresh, or product-copy behavior
  changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_order_timeline_page_test.dart`.
- Route: `/p2p/order/:orderId/timeline`.
- Result: first viewport still reaches the timeline summary, first event, and
  next useful event; back navigation returns to order detail.
- Artifact: `test/features/p2p/p2p_order_timeline_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_order_timeline_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_order_timeline_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=643`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=23`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart`.

### Batch 43 - SC-267 P2P Compliance Overview

Scope:
- `lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart`

Starting audit:
- Design-token audit row: root page warning with `edgeInsets=2`,
  `totalDebt=2`.
- Global snapshot before the batch: `total_debt=643`,
  `scope_root_page_debt=175`,
  `scope_root_page_bundle_summary_debt=268`, `p0_p2p_debt=23`.

GitNexus:
- Context target: `P2PComplianceOverviewPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to padding token constants.

Implementation:
- Replaced compliance hero padding and checklist row padding with directional
  equivalents.
- Replaced checklist card zero padding with the shared `AppSpacing.zeroInsets`
  token.
- Preserved hero status, checklist rows, KYC/AML/limits/source-of-funds route
  edges, and parent back route.

Safety / boundary review:
- Compliance checklist status, route targets, incomplete requirements, and
  parent P2P route remain unchanged.
- No KYC, AML, limits, source-of-funds, escrow, wallet, or product-copy
  behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertions in
  `test/features/p2p/p2p_compliance_overview_page_test.dart`.
- Route: `/p2p/compliance`.
- Result: first viewport still reaches the compliance status summary, KYC
  checklist action, and AML checklist action; all checklist route edges remain
  stable.
- Artifact: `test/features/p2p/p2p_compliance_overview_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_compliance_overview_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=639`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=21`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_express_confirm_page.dart`.

### Batch 44 - SC-210 P2P Express Confirm

Scope:
- `lib/features/p2p/presentation/pages/p2p_express_confirm_page.dart`

Starting audit:
- Design-token audit row: root page warning with `edgeInsets=2`,
  `totalDebt=2`.
- Global snapshot before the batch: `total_debt=639`,
  `scope_root_page_debt=173`,
  `scope_root_page_bundle_summary_debt=266`, `p0_p2p_debt=21`.

GitNexus:
- Context target: `P2PExpressConfirmPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced express summary card horizontal padding and summary line vertical
  padding with directional equivalents.
- Preserved buy/sell query params, merchant summary, payment method, free-fee
  row, escrow note, warning note, submitting state, confirm route, and cancel
  route.

Safety / boundary review:
- Trade direction, fiat amount, crypto amount, merchant, payment method,
  escrow note, fee, warning, cancel and confirm actions remain unchanged.
- No P2P order creation, escrow, merchant, wallet, fee, route, or product-copy
  behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_express_confirm_page_test.dart`.
- Route: `/p2p/express/confirm`.
- Result: first viewport still reaches the selected merchant summary, cancel
  action, and final confirm action; buy/sell query state and submit/cancel
  navigation remain stable.
- Artifact: `test/features/p2p/p2p_express_confirm_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_express_confirm_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_express_confirm_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=635`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=19`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_notifications_settings_page.dart`.

### Batch 45 - SC-278 P2P Notifications Settings

Scope:
- `lib/features/p2p/presentation/pages/p2p_notifications_settings_page.dart`

Starting audit:
- Design-token audit row: root page warning with `edgeInsets=2`,
  `totalDebt=2`.
- Global snapshot before the batch: `total_debt=635`,
  `scope_root_page_debt=171`,
  `scope_root_page_bundle_summary_debt=264`, `p0_p2p_debt=19`.

GitNexus:
- Context target: `P2PNotificationsSettingsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to padding token constants.

Implementation:
- Replaced notification hero icon padding and channel-button padding with
  directional equivalents.
- Replaced settings card zero padding with the shared `AppSpacing.zeroInsets`
  token.
- Preserved notification state initialization, channel toggles, selected color
  state, and parent settings back route.

Safety / boundary review:
- Push/email/SMS toggle state, order/payment/security/KYC notification labels,
  and settings parent route remain unchanged.
- No P2P order, escrow, notification, settings, route, or product-copy behavior
  changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertions in
  `test/features/p2p/p2p_notifications_settings_page_test.dart`.
- Route: `/p2p/settings/notifications`.
- Result: first viewport still reaches order update push and payment received
  push toggles; SMS toggle and header back route remain stable.
- Artifact: `test/features/p2p/p2p_notifications_settings_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_notifications_settings_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_notifications_settings_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=631`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=17`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_reviews_page.dart`.

### Batch 46 - SC-231 P2P Reviews

Scope:
- `lib/features/p2p/presentation/pages/p2p_reviews_page.dart`

Starting audit:
- Design-token audit row: root page warning with `edgeInsets=2`,
  `totalDebt=2`.
- Global snapshot before the batch: `total_debt=631`,
  `scope_root_page_debt=169`,
  `scope_root_page_bundle_summary_debt=262`, `p0_p2p_debt=17`.

GitNexus:
- Context target: `P2PReviewsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding constants.

Implementation:
- Replaced review summary card padding and review card padding with
  directional equivalents.
- Preserved average rating, star distribution, received/given tabs, review
  preview keys, reply copy, and parent back route.

Safety / boundary review:
- Reputation/review data, P2P parent route, and tab state remain unchanged.
- No P2P order, escrow, merchant, review, rating, route, or product-copy
  behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_reviews_page_test.dart`.
- Route: `/p2p/reviews`.
- Result: first viewport still reaches the first received review preview; given
  review tab and header back route remain stable.
- Artifact: `test/features/p2p/p2p_reviews_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_reviews_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_reviews_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=627`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=15`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_wallet_page.dart`.

### Batch 47 - SC-264 P2P Wallet

Scope:
- Route/screen: `/p2p/wallet`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_page.dart`

Impact:
- Context target: `P2PWalletPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to tokenized and directional padding.

Implementation:
- Replaced the wallet card padding constant type with `EdgeInsetsGeometry`
  while preserving the existing compact wallet spacing token.
- Replaced hero padding and scroll padding with directional equivalents.
- Preserved masked balance toggle, transfer directions, expanded asset actions,
  escrow detail route, recent transactions, and history route.

Safety / boundary review:
- Wallet balance, escrow balances, transfer from/to main wallet, and transaction
  status copy remain unchanged.
- No P2P order, escrow release, transfer confirmation, route, or financial
  safety behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_wallet_page_test.dart`.
- Route: `/p2p/wallet`.
- Result: first viewport still reaches the first balance card; masking,
  expanded breakdown, transfer route, escrow detail route, and history route
  remain stable.
- Artifact: `test/features/p2p/p2p_wallet_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_wallet_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_wallet_page_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=623`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=13`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_ad_analytics_page.dart`.

### Batch 48 - SC-223 P2P Ad Analytics

Scope:
- Route/screen: `/p2p/ad-analytics/:adId`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/pages/p2p_ad_analytics_page.dart`

Impact:
- Context target: `P2PAdAnalyticsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional scroll padding.

Implementation:
- Replaced the page scroll padding with `EdgeInsetsDirectional.fromSTEB`.
- Preserved ad identity, KPI grid, quick stats, conversion funnel, performance
  trend, volume chart, heatmap, payment breakdown, competitor comparison, tips,
  and risk-review panel.

Safety / boundary review:
- Analytics copy, escrow contract note, ad metrics, and P2P parent route remain
  unchanged.
- No order, escrow, payment, wallet, ranking, or backend snapshot behavior
  changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_ad_analytics_page_test.dart`.
- Route: `/p2p/ad-analytics/sample`.
- Result: first viewport still previews the conversion funnel; deep scroll
  still reaches competitor comparison and optimization tips.
- Artifact: `test/features/p2p/p2p_ad_analytics_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_ad_analytics_page.dart lib/features/p2p/presentation/pages/p2p_ad_analytics_page_part_01.dart lib/features/p2p/presentation/pages/p2p_ad_analytics_page_part_02.dart lib/features/p2p/presentation/pages/p2p_ad_analytics_page_part_03.dart` -
  pass.
- `flutter test test/features/p2p/p2p_ad_analytics_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=621`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=12`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: chart CustomPainter exception remains documented as
  `allowed_source_keyword: custompainter`; no unreviewed root page padding debt
  remains for this screen.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart`.

### Batch 49 - SC-243 P2P Claim Detail

Scope:
- Route/screen: `/p2p/claim/:claimId`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart`

Impact:
- Context target: `P2PClaimDetailPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional scroll padding in the state part.

Implementation:
- Replaced claim-detail scroll padding with `EdgeInsetsDirectional.fromSTEB`.
- Preserved claim status, claim code, order link, support link, benchmarks,
  description, tabs, evidence, notes, notification toggle, receipt CTA, and
  review panel.

Safety / boundary review:
- P2P claim amount, escrow/insurance copy, evidence/reviewer notes, receipt
  behavior, and canonical navigation routes remain unchanged.
- No order, escrow, payment, insurance, support route, or claim status behavior
  changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_claim_detail_page_test.dart`.
- Route: `/p2p/claim/sample`.
- Result: first viewport still reaches benchmark comparison; evidence, notes,
  notification, receipt, order route, support route, and insurance-fund entry
  navigation remain stable.
- Artifact: `test/features/p2p/p2p_claim_detail_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_claim_detail_page.dart lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_02.dart lib/features/p2p/presentation/pages/p2p_claim_detail_page_part_03.dart` -
  pass.
- `flutter test test/features/p2p/p2p_claim_detail_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=619`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=11`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart`.

### Batch 50 - SC-259 P2P E2E Info

Scope:
- Route/screen: `/p2p/e2e-info`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart`

Impact:
- Context target: `P2PE2EInfoPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional scroll padding.

Implementation:
- Replaced E2E info scroll padding with `EdgeInsetsDirectional.fromSTEB`.
- Preserved hero, encryption diagram, security info items, fingerprint card,
  how-it-works steps, server note, chat entry route, and back route.

Safety / boundary review:
- E2E encryption, fingerprint, server privacy note, and P2P chat safety copy
  remain unchanged.
- No chat, encryption, escrow, security, or navigation behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_e2e_info_page_test.dart`.
- Route: `/p2p/e2e-info`.
- Result: first viewport still reaches the first E2E security explanation card;
  chat E2E action and back-to-chat route remain stable.
- Artifact: `test/features/p2p/p2p_e2e_info_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart` -
  pass.
- `flutter test test/features/p2p/p2p_e2e_info_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=617`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=10`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_insurance_fund_page.dart`.

### Batch 51 - SC-238 P2P Insurance Fund

Scope:
- Route/screen: `/p2p/insurance` and legacy alias `/p2p/insurance-fund`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/pages/p2p_insurance_fund_page.dart`

Impact:
- Context target: `P2PInsuranceFundPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional scroll padding.

Implementation:
- Replaced insurance fund scroll padding with `EdgeInsetsDirectional.fromSTEB`.
- Preserved onboarding tour overlay, overview/claims tabs, fund health,
  eligibility, coverage tiers, claim list, certificate route, legacy alias, and
  high-risk review panel.

Safety / boundary review:
- Insurance fund amounts, claim state, certificate navigation, escrow contract
  note, and P2P parent route remain unchanged.
- No claim, certificate, tour, tab, escrow, or financial safety behavior
  changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_insurance_fund_page_test.dart`.
- Route: `/p2p/insurance`.
- Result: first viewport still reaches the eligibility card after dismissing
  the tour; claims tab, certificate route, and legacy alias remain stable.
- Artifact: `test/features/p2p/p2p_insurance_fund_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_insurance_fund_page.dart lib/features/p2p/presentation/pages/p2p_insurance_fund_page_part_01.dart lib/features/p2p/presentation/pages/p2p_insurance_fund_page_part_02.dart lib/features/p2p/presentation/pages/p2p_insurance_fund_page_part_03.dart` -
  pass.
- `flutter test test/features/p2p/p2p_insurance_fund_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=615`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=9`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: fund chart CustomPainter exception remains documented as
  `allowed_source_keyword: custompainter`; no unreviewed root page padding debt
  remains for this screen.
- Next row:
  `lib/features/p2p/presentation/pages/p2p_merchant_apply_page_part_01.dart`.

### Batch 52 - SC-227 P2P Merchant Apply

Scope:
- Route/screen: `/p2p/merchant-apply`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/pages/p2p_merchant_apply_page_part_01.dart`

Impact:
- Context target: `P2PMerchantApplyPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional scroll padding in the state part.

Implementation:
- Replaced merchant-apply wizard scroll padding with
  `EdgeInsetsDirectional.fromSTEB`.
- Preserved progress header, requirement checks, business form, business type
  selection, required document toggles, history review, agreement gate, submit
  state, success CTA, and back-to-P2P route.

Safety / boundary review:
- Merchant eligibility, KYC/document requirements, review notice, agreement,
  submit guard, and P2P route behavior remain unchanged.
- No onboarding, KYC, document, merchant status, escrow, or compliance copy
  behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_merchant_apply_page_test.dart`.
- Route: `/p2p/merchant-apply`.
- Result: first viewport still reaches merchant minimum requirements; full
  wizard submit and success CTA route remain stable.
- Artifact: `test/features/p2p/p2p_merchant_apply_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_merchant_apply_page.dart lib/features/p2p/presentation/pages/p2p_merchant_apply_page_part_01.dart lib/features/p2p/presentation/pages/p2p_merchant_apply_page_part_02.dart lib/features/p2p/presentation/pages/p2p_merchant_apply_page_part_03.dart` -
  pass.
- `flutter test test/features/p2p/p2p_merchant_apply_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=613`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=8`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  Re-audit `p0_p2p_debt=8` residual queue from the current token CSV before
  selecting the next screen.

### Batch 53 - SC-213 P2P Order Rate

Scope:
- Route/screen: `/p2p/order/:orderId/rate`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_rate_widgets.dart`

Impact:
- Context target: `P2POrderRatePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to directional padding in the route-owned widget
  part.

Implementation:
- Replaced two order-rating card paddings with
  `EdgeInsetsDirectional.all(AppSpacing.x3)`.
- Preserved merchant summary, star rating, quick tags, optional review input,
  skip path, disabled/enabled submit, loading state, success view, and
  back-to-P2P CTA.

Safety / boundary review:
- Order amount, merchant identity, escrow contract note, feedback labels, and
  close/skip route behavior remain unchanged.
- No order, escrow, payment, review submission, or route behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_order_rate_page_test.dart`.
- Route: `/p2p/order/p2p001/rate`.
- Result: first viewport still reaches the 5-star control and submit action;
  selecting a rating still reveals the first quick feedback tag; submit success
  and skip route remain stable.
- Artifact: `test/features/p2p/p2p_order_rate_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/pages/p2p_order_rate_page.dart lib/features/p2p/presentation/widgets/p2p_order_rate_widgets.dart` -
  pass.
- `flutter test test/features/p2p/p2p_order_rate_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/p2p --reporter=compact` - pass on rerun,
  `356` tests; retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=607`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=4`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/widgets/p2p_payment_methods_page_sections.dart`.

### Batch 54 - SC-237 P2P Payment Methods

Scope:
- Route/screen: `/p2p/payment-methods`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_payment_methods_page_sections.dart`

Impact:
- Context target: `P2PPaymentMethodsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to the payment-method section widget token debt.

Implementation:
- Replaced the payment-method icon padding with
  `EdgeInsetsDirectional.all(AppSpacing.x2)`.
- Preserved add bank/e-wallet routing, default method state, delete
  confirmation, masking, verified/unverified status copy, and local repository
  state transitions.

Safety / boundary review:
- Payment-method add, default, delete, and confirmation behavior remains
  unchanged.
- Sensitive account and wallet labels remain masked by the existing UI.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/p2p/p2p_payment_methods_page_test.dart`.
- Route: `/p2p/payment-methods`.
- Result: first viewport still reaches saved payment methods; add buttons still
  route to bank and e-wallet flows; default and delete confirmation behavior
  remains stable.
- Artifact: `test/features/p2p/p2p_payment_methods_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/widgets/p2p_payment_methods_page_sections.dart` -
  pass.
- `flutter test test/features/p2p/p2p_payment_methods_page_test.dart --reporter=compact` -
  pass, `5` tests; retained pre-existing non-fatal hit-test warning on the
  dialog `Xoa` tap.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained the same pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=604`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=2`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=195`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/p2p/presentation/widgets/p2p_guide_video_common.dart`.

### Batch 55 - SC-280 P2P Guide

Scope:
- Route/screen: `/p2p/guide`.
- Files touched:
  - `flutter_app/lib/features/p2p/presentation/widgets/p2p_guide_video_common.dart`

Impact:
- Context target: `P2PGuidePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_p2pRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit target stayed limited to the guide video shared widget line-height token.

Implementation:
- Replaced the guide step badge `height: 1` magic number with
  `AppSpacing.p2pGuidePillLineHeight`.
- Preserved FAQ list, guide mode controls, buy/sell guide content, support
  navigation, start navigation, and header back behavior.

Safety / boundary review:
- P2P guide copy and navigation remain unchanged.
- No payment, escrow, wallet, account, or verification behavior changed.
- P2P/wallet product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertions in
  `test/features/p2p/p2p_guide_page_test.dart`.
- Route: `/p2p/guide`.
- Result: FAQ list depth, mode controls, accordion expansion, buy/sell tabs,
  support/start navigation, and header back all remain stable.
- Artifact: `test/features/p2p/p2p_guide_page_test.dart`.

Verification:
- `dart format lib/features/p2p/presentation/widgets/p2p_guide_video_common.dart` -
  pass.
- `flutter test test/features/p2p/p2p_guide_page_test.dart --reporter=compact` -
  pass, `8` tests.
- `flutter test test/features/p2p --reporter=compact` - pass, `356` tests;
  retained pre-existing non-fatal hit-test warning in
  `p2p_payment_methods_page_test.dart`.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=601`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_p2p_debt=0`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart` - regenerated stale visual
  density artifacts after token report changes.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  Re-audit `p0_markets_debt=2` and select the highest-priority remaining
  Markets target now that P2P is cleared.

### Batch 56 - SC-026 Market Correlations

Scope:
- Route/screen: `/markets/correlations`.
- Files touched:
  - `flutter_app/lib/features/markets/presentation/pages/market_correlations_page.dart`

Impact:
- Context target: `MarketCorrelationsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_marketsRoutes` and `app_router.dart`, direct
  count `2`.
- Affected processes: `0`.
- Edit target stayed limited to the route page scroll padding token debt.

Implementation:
- Replaced `EdgeInsets.only(bottom: scrollEndClearance)` with
  `EdgeInsetsDirectional.only(bottom: scrollEndClearance)`.
- Preserved matrix/pairs/diversification tabs, timeframe selector, sorting,
  insight cards, and back navigation.

Safety / boundary review:
- Market data read model, chart widgets, sorting, and navigation remain
  unchanged.
- No trading, wallet, order, or prediction-market behavior changed.
- General product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/market_correlations_page_test.dart`.
- Route: `/markets/correlations`.
- Result: first viewport still reaches the correlation matrix card; timeframe,
  pair sorting, diversification tab, and back navigation remain stable.
- Artifact: `test/features/markets/market_correlations_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/market_correlations_page.dart` -
  pass.
- `flutter test test/features/markets/market_correlations_page_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter test test/features/markets --reporter=compact` - pass, `145` tests.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=599`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_markets_debt=1`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/markets/presentation/pages/token_unlocks_page_part_01.dart`.

### Batch 57 - SC-024 Token Unlocks

Scope:
- Route/screen: `/markets/token-unlocks`.
- Files touched:
  - `flutter_app/lib/features/markets/presentation/pages/token_unlocks_page_part_01.dart`

Impact:
- Context target: `TokenUnlocksPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_marketsRoutes` and `app_router.dart`, direct
  count `2`.
- Affected processes: `0`.
- Edit target stayed limited to the token-unlocks route page scroll padding
  token debt.

Implementation:
- Replaced `EdgeInsets.only(bottom: scrollEndClearance)` with
  `EdgeInsetsDirectional.only(bottom: scrollEndClearance)`.
- Preserved upcoming unlocks, high-value sort/filter behavior, expanded risk
  details, analysis/schedule tabs, and back navigation.

Safety / boundary review:
- Token unlock data, risk labels, tab content, filters, and route behavior
  remain unchanged.
- No trading, wallet, order, or prediction-market behavior changed.
- General product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/markets/token_unlocks_page_test.dart`.
- Route: `/markets/token-unlocks`.
- Result: first viewport still reaches the first unlock card; sort/filter,
  expanded details, supporting tabs, and back navigation remain stable.
- Artifact: `test/features/markets/token_unlocks_page_test.dart`.

Verification:
- `dart format lib/features/markets/presentation/pages/token_unlocks_page_part_01.dart` -
  pass.
- `flutter test test/features/markets/token_unlocks_page_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter test test/features/markets --reporter=compact` - pass, `145` tests.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=597`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_markets_debt=0`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  Re-audit `p0_profile_debt=6` and select the highest-priority remaining
  Profile target now that Markets is cleared.

### Batch 58 - SC-163 API Management

Scope:
- Route/screen: `/profile/api-management`.
- Files touched:
  - `flutter_app/lib/features/profile/presentation/widgets/api_management_key_controls.dart`

Impact:
- Context target: `ApiManagementPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_profileRoutes` and `app_router.dart`, direct
  count `2`.
- Affected processes: `0`.
- Edit target stayed limited to API management key-control padding tokens.

Implementation:
- Replaced two `EdgeInsets.symmetric(...)` paddings with
  `EdgeInsetsDirectional.symmetric(...)`.
- Preserved API key inventory, reveal action, enable/disable toggle, delete
  action, create edge, and header back behavior.

Safety / boundary review:
- API key reveal/toggle/delete/create state and route behavior remain
  unchanged.
- Security-sensitive labels and local action state remain untouched.
- High-risk state primitives and general product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/profile/api_management_page_test.dart`.
- Route: `/profile/api-management`.
- Result: first viewport still reaches API key inventory; local key actions and
  create route edge remain stable.
- Artifact: `test/features/profile/api_management_page_test.dart`.

Verification:
- `dart format lib/features/profile/presentation/widgets/api_management_key_controls.dart` -
  pass.
- `flutter test test/features/profile/api_management_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/profile --reporter=compact` - pass, `54` tests.
- `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact` -
  pass, `1` test.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=591`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_profile_debt=2`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/profile/presentation/pages/edit_profile_page.dart`.

### Batch 59 - SC-157 Edit Profile

Scope:
- Route/screen: `/profile/edit`.
- Files touched:
  - `flutter_app/lib/features/profile/presentation/pages/edit_profile_page.dart`

Impact:
- Context target: `EditProfilePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_profileRoutes` and `app_router.dart`, direct
  count `2`.
- Affected processes: `0`.
- Edit target stayed limited to the edit-profile route page scroll padding
  token debt.

Implementation:
- Replaced `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Preserved avatar editor, text fields, camera state, save action, and close
  route behavior.

Safety / boundary review:
- Personal profile edit state and navigation remain unchanged.
- No account, authentication, KYC, security, wallet, or financial behavior
  changed.
- General product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/profile/edit_profile_page_test.dart`.
- Route: `/profile/edit`.
- Result: first viewport still reaches save action; local edit, camera, save,
  and back edges remain stable.
- Artifact: `test/features/profile/edit_profile_page_test.dart`.

Verification:
- `dart format lib/features/profile/presentation/pages/edit_profile_page.dart` -
  pass.
- `flutter test test/features/profile/edit_profile_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/profile --reporter=compact` - pass, `54` tests.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=589`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_profile_debt=1`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `lib/features/profile/presentation/pages/vip_page.dart`.

### Batch 60 - SC-164 VIP

Scope:
- Route/screen: `/profile/vip`.
- Files touched:
  - `flutter_app/lib/features/profile/presentation/pages/vip_page.dart`

Impact:
- Context target: `VIPPage` (`VipPage` was not indexed because the class uses
  the all-caps acronym).
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_profileRoutes` and `app_router.dart`, direct
  count `2`.
- Affected processes: `0`.
- Edit target stayed limited to the VIP route page scroll padding token debt.

Implementation:
- Replaced `EdgeInsets.only(bottom: scrollClearance)` with
  `EdgeInsetsDirectional.only(bottom: scrollClearance)`.
- Preserved VIP hero, upgrade progress, overview/benefits/history tabs, trade
  CTA, and navigation edges.

Safety / boundary review:
- VIP level data, benefit copy, progress math, and route behavior remain
  unchanged.
- No account, wallet, trade, order, or payment behavior changed.
- General product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/profile/vip_page_test.dart`.
- Route: `/profile/vip`.
- Result: first viewport still keeps upgrade progress visible; tab state and
  navigation edges remain stable.
- Artifact: `test/features/profile/vip_page_test.dart`.

Verification:
- `dart format lib/features/profile/presentation/pages/vip_page.dart` - pass.
- `flutter test test/features/profile/vip_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/profile --reporter=compact` - pass, `54` tests.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=587`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_profile_debt=0`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  Re-audit `p0_trade_debt=121` and select the highest-priority remaining Trade
  target now that Profile is cleared.

### Batch 61 - SC-048/SC-049 Trade Page

Scope:
- Route/screen: `/trade` and `/trade/:pair`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/trade_page_part_01.dart`
  - `flutter_app/lib/features/trade/presentation/pages/trade_page_part_02.dart`
  - `flutter_app/lib/features/trade/presentation/pages/trade_page_part_03.dart`

Impact:
- Context target: `TradePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_tradeRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit targets stayed limited to raw padding token debt in the route page part
  files.

Implementation:
- Replaced five raw `EdgeInsets.*` paddings with
  `EdgeInsetsDirectional.*`.
- Preserved orderbook/chart painter math, pair route behavior, buy/sell side
  selection, amount shortcuts, product hub order, and Convert quick navigation.

Safety / boundary review:
- Order draft state, order side switching, market data tabs, pair query
  handling, and quick trade navigation remain unchanged.
- Trading risk/product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/trade_page_test.dart`.
- Route: `/trade` and `/trade/BTC-USDT`.
- Result: first viewport still reaches order side switch; pair route, market
  data tabs, order side switch, amount shortcuts, product hub order, and
  Convert quick nav remain stable.
- Artifact: `test/features/trade/trade_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/trade_page_part_01.dart lib/features/trade/presentation/pages/trade_page_part_02.dart lib/features/trade/presentation/pages/trade_page_part_03.dart` -
  pass.
- `flutter test test/features/trade/trade_page_test.dart --reporter=compact` -
  pass, `9` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=577`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=116`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; orderbook/custom painter exceptions
  remain audited but no longer carry token debt for this screen.
- Next row:
  `flutter_app/lib/features/trade/presentation/pages/bot_security_settings_page.dart`.

### Batch 62 - SC-122 Bot Security Settings

Scope:
- Route/screen: `/trade/bots/security`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/bot_security_settings_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/bot_security_settings_cards.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/bot_security_settings_sheets.dart`

Impact:
- Context target: `BotSecuritySettingsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_tradeRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit targets stayed limited to security settings page/card/sheet token debt.

Implementation:
- Replaced three raw `EdgeInsets.fromLTRB(...)` paddings with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced divider `height: 1` with `AppSpacing.dividerHairline`.
- Preserved 2FA toggle, API key sheet, generated key reveal state, IP whitelist
  sheet, activity list, emergency/security copy, and back navigation.

Safety / boundary review:
- Security-sensitive actions and local state remain unchanged.
- Generated API key visibility behavior and IP add flow remain unchanged.
- Trading risk/product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/bot_security_settings_page_test.dart`.
- Route: `/trade/bots/security`.
- Result: first viewport still reaches API key controls; API key and IP
  whitelist sheets open normally.
- Artifact: `test/features/trade/bot_security_settings_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/bot_security_settings_page.dart lib/features/trade/presentation/widgets/bot_security_settings_sheets.dart lib/features/trade/presentation/widgets/bot_security_settings_cards.dart` -
  pass.
- `flutter test test/features/trade/bot_security_settings_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=566`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=109`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  `flutter_app/lib/features/trade/presentation/pages/provider_application_page.dart`.

### Batch 63 - SC-069 Provider Application

Scope:
- Route/screen: `/trade/copy/provider/apply`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/widgets/provider_application_common.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/provider_application_progress_intro.dart`

Impact:
- Context target: `ProviderApplicationPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: `_tradeRoutes` and `app_router.dart`, direct count
  `2`.
- Affected processes: `0`.
- Edit targets stayed limited to provider application widget token debt.

Implementation:
- Replaced toggle panel button height arithmetic with `AppSpacing.buttonCompact`.
- Kept provider application consent, intro, panel description, benefit, and
  responsibility line heights on existing provider-specific `AppSpacing`
  tokens.
- Reduced two intro vertical gaps from arithmetic/non-domain tokens to
  `AppSpacing.x5` for a tighter phone-first onboarding viewport.
- Preserved wizard gating, requirement acknowledgement, disclosure/consent,
  draft repository data, and return navigation to copy trading.

Safety / boundary review:
- Provider onboarding behavior and submission gating remain unchanged.
- Copy Trading provider copy stays in Trade context; no Arena/wallet language
  crossover was introduced.
- High-risk Trade copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/provider_application_page_test.dart`.
- Route: `/trade/copy/provider/apply`.
- Result: first viewport still reaches the wizard action; requirement gating and
  back navigation remain functional.
- Artifact: `test/features/trade/provider_application_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/widgets/provider_application_common.dart lib/features/trade/presentation/widgets/provider_application_progress_intro.dart` -
  pass.
- `flutter test test/features/trade/provider_application_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=554`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=101`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart` - regenerated stale artifacts
  after token audit refresh.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; provider-specific line-height tokens
  remain accepted.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 64 - SC-098 Slippage Monitoring

Scope:
- Route/screen: `/trade/slippage`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/widgets/slippage_monitoring_overview.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/slippage_monitoring_tabs.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/slippage_monitoring_events.dart`

Impact:
- Context target: `SlippageMonitoringPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to slippage monitoring widget padding token debt.

Implementation:
- Replaced tab wrapper `EdgeInsets.all(...)` with
  `EdgeInsetsDirectional.all(...)`.
- Replaced three compact inner-card `EdgeInsets.symmetric(...)` paddings with
  `EdgeInsetsDirectional.symmetric(...)`.
- Preserved provider/history/alert tab switching, cost impact math, event
  metrics, alert severity styling, and slippage copy.

Safety / boundary review:
- Slippage calculations and alert thresholds remain unchanged.
- Trade copy guardrails remain green.
- No wallet, Arena, or P2P boundary copy was changed.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/slippage_monitoring_page_test.dart`.
- Route: `/trade/slippage`.
- Result: first viewport still reaches the first slippage event; provider,
  history, and alert tabs still switch.
- Artifact: `test/features/trade/slippage_monitoring_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/widgets/slippage_monitoring_overview.dart lib/features/trade/presentation/widgets/slippage_monitoring_tabs.dart lib/features/trade/presentation/widgets/slippage_monitoring_events.dart` -
  pass.
- `flutter test test/features/trade/slippage_monitoring_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=542`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=93`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 65 - SC-087 Trader Profile

Scope:
- Route/screen: `/trade/copy/trader-profile`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/trader_profile_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/trader_profile_stats_common.dart`

Impact:
- Context target: `TraderProfilePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to trader profile page/stats token debt.

Implementation:
- Replaced scroll `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced stats row `EdgeInsets.symmetric(...)` with
  `EdgeInsetsDirectional.symmetric(...)`.
- Replaced divider `height: 1` with `AppSpacing.dividerHairline`.
- Preserved follow state, copy CTA, local tabs, trader metrics, and return
  navigation.

Safety / boundary review:
- Copy Trading profile behavior and local state remain unchanged.
- Trade copy guardrails remain green.
- No financial-risk confirmation copy was altered.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/trader_profile_page_test.dart`.
- Route: `/trade/copy/trader-profile`.
- Result: first viewport still reaches the copy action; local tabs and follow
  state still update.
- Artifact: `test/features/trade/trader_profile_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/trader_profile_page.dart lib/features/trade/presentation/widgets/trader_profile_stats_common.dart` -
  pass.
- `flutter test test/features/trade/trader_profile_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=534`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=88`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 66 - SC-090 Margin Trading Hub

Scope:
- Route/screen: `/trade/margin/hub`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/margin_trading_hub_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/margin_trading_hub_hero_nav.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/margin_trading_hub_cards.dart`

Impact:
- Context target: `MarginTradingHubPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to margin hub page/card/nav token debt.

Implementation:
- Replaced scroll `EdgeInsets.only(...)` with
  `EdgeInsetsDirectional.only(...)`.
- Replaced hero stat `EdgeInsets.symmetric(...)` with
  `EdgeInsetsDirectional.symmetric(...)`.
- Replaced compliance grid raw `crossAxisCount: 2` and local raw extent with
  existing `AppSpacing.marginTradingHubComplianceGrid*` tokens.
- Preserved menu routes/placeholders, high-risk margin review panel, feature
  cards, compliance list, and back navigation.

Safety / boundary review:
- Margin risk review copy and high-risk panel remain unchanged.
- Leverage/margin navigation behavior remains unchanged.
- Trade copy and margin product guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/margin_trading_hub_page_test.dart`.
- Route: `/trade/margin/hub`.
- Result: first viewport still reaches the first margin action; menu edges still
  use real routes and placeholders safely.
- Artifact: `test/features/trade/margin_trading_hub_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/margin_trading_hub_page.dart lib/features/trade/presentation/widgets/margin_trading_hub_hero_nav.dart lib/features/trade/presentation/widgets/margin_trading_hub_cards.dart` -
  pass.
- `flutter test test/features/trade/margin_trading_hub_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=526`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=83`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 67 - SC-082 Dispute Resolution

Scope:
- Route/screen: `/trade/copy/disputes`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/dispute_resolution_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/dispute_resolution_cases.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/dispute_resolution_form.dart`

Impact:
- Context target: `DisputeResolutionPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to dispute page/form/case padding token debt.

Implementation:
- Replaced tab `EdgeInsets.symmetric(...)` with
  `EdgeInsetsDirectional.symmetric(...)`.
- Replaced form scroll `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced upload evidence top padding with `EdgeInsetsDirectional.only(...)`.
- Preserved complaint form fields, evidence button, tab switching, submission
  state, active/history cases, and copy trading back navigation.

Safety / boundary review:
- Dispute submission and evidence state remain unchanged.
- Complaint copy and escalation behavior remain in Trade/Copy Trading context.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/dispute_resolution_page_test.dart`.
- Route: `/trade/copy/disputes`.
- Result: first viewport still reaches complaint type inventory; complaint
  submission and history tab still work.
- Artifact: `test/features/trade/dispute_resolution_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/dispute_resolution_page.dart lib/features/trade/presentation/widgets/dispute_resolution_cases.dart lib/features/trade/presentation/widgets/dispute_resolution_form.dart` -
  pass.
- `flutter test test/features/trade/dispute_resolution_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=518`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=78`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 68 - SC-126 Bot Strategy Compare

Scope:
- Route/screen: `/trade/bots/strategy-compare`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/widgets/bot_strategy_compare_selection.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/bot_strategy_compare_metrics.dart`

Impact:
- Context target: `BotStrategyComparePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to strategy compare selection/metrics token debt.

Implementation:
- Replaced selection grid raw `childAspectRatio: 2.25` with
  `AppSpacing.tradeBotStrategyGridAspectRatio`.
- Replaced two table row/header `EdgeInsets.symmetric(...)` paddings with
  `EdgeInsetsDirectional.symmetric(...)`.
- Preserved strategy selection toggles, metric comparison values, best-strategy
  highlight, chart/custom painter area, and back navigation.

Safety / boundary review:
- Strategy comparison data and selection state remain unchanged.
- Custom painter exception remains audited and bounded to this screen.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/bot_strategy_compare_page_test.dart`.
- Route: `/trade/bots/strategy-compare`.
- Result: first viewport still reaches best strategy card; strategy selection
  toggles still work.
- Artifact: `test/features/trade/bot_strategy_compare_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/widgets/bot_strategy_compare_selection.dart lib/features/trade/presentation/widgets/bot_strategy_compare_metrics.dart` -
  pass.
- `flutter test test/features/trade/bot_strategy_compare_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=509`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=72`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: bounded `custompainter` exception remains for this
  screen, but no unreviewed token debt remains in the touched widgets.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 69 - SC-072 Copy Configuration

Scope:
- Route/screen: `/trade/copy/:providerId/configure`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/copy_configuration_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_validation_common.dart`

Impact:
- Context target: `CopyConfigurationPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to copy configuration padding token debt.

Implementation:
- Replaced content scroll `EdgeInsets.only(...)` with
  `EdgeInsetsDirectional.only(...)`.
- Replaced sticky footer `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced validation summary row `EdgeInsets.symmetric(...)` with
  `EdgeInsetsDirectional.symmetric(...)`.
- Preserved provider blank state, capital field, copy mode, risk controls, fee
  preview, validation messages, disabled/active confirmation CTA, and back
  query fallback behavior.

Safety / boundary review:
- Copy Trading configuration and confirmation route edge remain unchanged.
- Financial safety review panel and validation copy remain visible.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/copy_configuration_page_test.dart`.
- Route: `/trade/copy/:providerId/configure`.
- Result: first viewport still reaches capital field; confirmation CTA still
  uses the SC-073 route edge.
- Artifact: `test/features/trade/copy_configuration_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/copy_configuration_page.dart lib/features/trade/presentation/widgets/copy_configuration_validation_common.dart` -
  pass.
- `flutter test test/features/trade/copy_configuration_page_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=502`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=68`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 70 - SC-092 Advanced Analytics

Scope:
- Route/screen: `/trade/advanced-analytics`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/advanced_analytics_page_part_01.dart`
  - `flutter_app/lib/features/trade/presentation/pages/advanced_analytics_page_part_02.dart`

Impact:
- Context target: `AdvancedAnalyticsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to advanced analytics page token debt.

Implementation:
- Replaced content scroll `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced signal separator `SizedBox(height: 1)` with
  `AppSpacing.dividerHairline`.
- Preserved AI signal filtering, local tabs, risk/portfolio sections, model
  attribution row, and back navigation.

Safety / boundary review:
- Analytics data, signal copy, and model attribution remain unchanged.
- No trading action or financial confirmation behavior was changed.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/advanced_analytics_page_test.dart`.
- Route: `/trade/advanced-analytics`.
- Result: first viewport still reaches the first AI signal; filters and local
  tabs still work.
- Artifact: `test/features/trade/advanced_analytics_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/advanced_analytics_page_part_01.dart lib/features/trade/presentation/pages/advanced_analytics_page_part_02.dart` -
  pass.
- `flutter test test/features/trade/advanced_analytics_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=496`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=65`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 71 - SC-113 Complaint Tracking

Scope:
- Route/screen: `/trade/copy/complaints/:complaintId`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/complaint_tracking_page.dart`

Impact:
- Context target: `ComplaintTrackingPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to complaint tracking page padding token debt.

Implementation:
- Replaced content scroll `EdgeInsets.only(...)` with
  `EdgeInsetsDirectional.only(...)`.
- Replaced timeline connector `EdgeInsets.symmetric(...)` with
  `EdgeInsetsDirectional.symmetric(...)`.
- Replaced timeline content bottom padding with
  `EdgeInsetsDirectional.only(...)`.
- Preserved complaint status card, investigation timeline, dynamic complaint id
  edge, ombudsman route edge, and back navigation.

Safety / boundary review:
- Complaint tracking data and escalation route behavior remain unchanged.
- Complaint copy remains in Trade/Copy Trading context.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/complaint_tracking_page_test.dart`.
- Route: `/trade/copy/complaints/:complaintId`.
- Result: first viewport still reaches investigation timeline; dynamic
  complaint id and ombudsman edge still work.
- Artifact: `test/features/trade/complaint_tracking_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/complaint_tracking_page.dart` -
  pass.
- `flutter test test/features/trade/complaint_tracking_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=490`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=62`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 72 - SC-075 Performance Attribution

Scope:
- Route/screen: `/trade/copy/performance-attribution`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/widgets/performance_attribution_summary_tabs.dart`

Impact:
- Context target: `PerformanceAttributionPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to performance attribution summary grid token
  debt.

Implementation:
- Replaced summary grid raw `crossAxisCount: 2` with
  `AppSpacing.tradeBotGridColumns`.
- Replaced summary grid raw `childAspectRatio: 1.65` with
  `AppSpacing.tradeBotAttributionMetricAspectRatio`.
- Preserved total return/alpha/beta/R2 metrics, tab switching, charts/custom
  painter area, and back navigation.

Safety / boundary review:
- Attribution calculations and displayed values remain unchanged.
- Custom painter exception remains audited and bounded to this screen.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/performance_attribution_page_test.dart`.
- Route: `/trade/copy/performance-attribution`.
- Result: first viewport still reaches attribution tabs; drawdown/projection
  tabs still switch.
- Artifact: `test/features/trade/performance_attribution_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/widgets/performance_attribution_summary_tabs.dart` -
  pass.
- `flutter test test/features/trade/performance_attribution_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=484`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=58`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: bounded `custompainter` exception remains for this screen,
  but summary grid token debt is cleared.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 73 - SC-081 Provider Governance

Scope:
- Route/screen: `/trade/copy/provider-governance`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/widgets/provider_governance_page_overview.dart`

Impact:
- Context target: `ProviderGovernancePage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to provider governance overview padding token
  debt.

Implementation:
- Replaced tab wrapper `EdgeInsets.all(...)` with
  `EdgeInsetsDirectional.all(...)`.
- Replaced modification log heading `EdgeInsets.only(left: ...)` with
  `EdgeInsetsDirectional.only(start: ...)`.
- Preserved governance tabs, fee content, modification log, request button
  behavior, and message panel.

Safety / boundary review:
- Provider governance data and request flow remain unchanged.
- Copy Trading governance copy stays separated from wallet/Arena language.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/provider_governance_page_test.dart`.
- Route: `/trade/copy/provider-governance`.
- Result: first viewport still reaches governance tabs; fees tab and request
  message panel still work.
- Artifact: `test/features/trade/provider_governance_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/widgets/provider_governance_page_overview.dart` -
  pass.
- `flutter test test/features/trade/provider_governance_page_test.dart --reporter=compact` -
  pass, `5` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=478`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=54`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 74 - SC-063 Copy Trading

Scope:
- Route/screen: `/trade/copy`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/copy_trading_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/copy_trading_metrics_common.dart`

Impact:
- Context target: `CopyTradingPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to copy trading page/disclaimer padding token
  debt.

Implementation:
- Replaced content scroll `EdgeInsets.only(...)` with
  `EdgeInsetsDirectional.only(...)`.
- Replaced disclaimer `EdgeInsets.symmetric(...)` with
  `EdgeInsetsDirectional.symmetric(...)`.
- Preserved copy trading hero, risk warning panel, provider cards, sort chips,
  provider detail route edge, and back navigation.

Safety / boundary review:
- Copy Trading risk warning and high-risk panel remain unchanged.
- Provider discovery/sorting behavior remains unchanged.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/copy_trading_page_test.dart`.
- Route: `/trade/copy`.
- Result: first viewport still reaches first provider card; sort chips, provider
  detail edge, and back nav still work.
- Artifact: `test/features/trade/copy_trading_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/copy_trading_page.dart lib/features/trade/presentation/widgets/copy_trading_metrics_common.dart` -
  pass.
- `flutter test test/features/trade/copy_trading_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=473`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=51`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 75 - SC-089 Market Data Analytics

Scope:
- Route/screen: `/trade/market-data-analytics`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/market_data_analytics_page_part_01.dart`
  - `flutter_app/lib/features/trade/presentation/pages/market_data_analytics_page_part_03.dart`

Impact:
- Context target: `MarketDataAnalyticsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to market data analytics padding/body-component
  token debt.

Implementation:
- Replaced content scroll `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced an implication color bar raw `Container` with token-sized
  `SizedBox` plus `ColoredBox`.
- Preserved pair selector, risk panel, market/liquidations/sentiment tabs,
  implication copy, and custom painter/chart exception coverage.

Safety / boundary review:
- Market analytics data and tab behavior remain unchanged.
- No trading action or confirmation behavior was changed.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/market_data_analytics_page_test.dart`.
- Route: `/trade/market-data-analytics`.
- Result: first viewport still reaches market data card; liquidations and
  sentiment tabs still switch.
- Artifact: `test/features/trade/market_data_analytics_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/market_data_analytics_page_part_01.dart lib/features/trade/presentation/pages/market_data_analytics_page_part_03.dart` -
  pass.
- `flutter test test/features/trade/market_data_analytics_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=469`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=49`.
- `dart run tool/body_component_consistency_audit.dart` - regenerated stale
  body artifacts after replacing raw `Container`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: bounded `custompainter` exception remains for this screen,
  but no unreviewed body/token debt remains in touched code.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 76 - SC-052 Trade Settings

Scope:
- Route/screen: `/trade/settings`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/trade_settings_page.dart`

Impact:
- Context target: `TradeSettingsPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to trade settings page token debt.

Implementation:
- Replaced local raw toggle knob margin `EdgeInsets.all(3)` with
  `AppSpacing.settingsSwitchKnobMargin`.
- Replaced content scroll `EdgeInsets.only(...)` with
  `EdgeInsetsDirectional.only(...)`.
- Preserved order defaults, display toggles, reset behavior, orderbook-related
  exception coverage, and high-risk settings safety panel.

Safety / boundary review:
- Trade settings state and reset behavior remain unchanged.
- Confirmation and small-order safety copy remain visible.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/trade_settings_page_test.dart`.
- Route: `/trade/settings`.
- Result: first viewport still reaches order defaults; toggles, dependent
  setting visibility, and reset still work.
- Artifact: `test/features/trade/trade_settings_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/trade_settings_page.dart` -
  pass.
- `flutter test test/features/trade/trade_settings_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- Tooling note: an attempted parallel `flutter test`/`flutter analyze` run
  briefly emptied Flutter `engine.stamp`; restored it from
  `bin/internal/engine.version`, then reran verification sequentially.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass after recovery, `2` tests.
- `flutter analyze` - pass after recovery.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=465`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=47`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart` - regenerated stale artifact.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: bounded `orderbook` exception remains for this screen, but
  the two unreviewed token debts are cleared.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 77 - SC-112 Complaint Submission

Scope:
- Route/screen: `/trade/copy/complaints/submit`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/complaint_submission_page.dart`

Impact:
- Context target: `ComplaintSubmissionPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to complaint submission page padding token debt.

Implementation:
- Replaced form scroll `EdgeInsets.only(...)` with
  `EdgeInsetsDirectional.only(...)`.
- Replaced sticky submit footer `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Preserved complaint category/details/evidence form, regulated safety review
  panel, sticky submit CTA, and tracking route edge.

Safety / boundary review:
- Complaint evidence/personal detail review copy remains visible.
- Submission behavior and SC-113 tracking navigation remain unchanged.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/complaint_submission_page_test.dart`.
- Route: `/trade/copy/complaints/submit`.
- Result: first viewport still reaches complaint category field; valid form
  still opens SC-113 complaint tracking.
- Artifact: `test/features/trade/complaint_submission_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/complaint_submission_page.dart` -
  pass.
- `flutter test test/features/trade/complaint_submission_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=461`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=45`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 78 - SC-119 Bot Suitability Assessment

Scope:
- Route/screen: `/trade/bots/suitability-assessment`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/widgets/bot_suitability_breakdown_common.dart`

Impact:
- Context target: `BotSuitabilityAssessmentPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to suitability breakdown grid token debt.

Implementation:
- Replaced raw category breakdown `crossAxisCount: 2` with
  `AppSpacing.tradeBotGridColumns`.
- Replaced raw `childAspectRatio: 1.45` with
  `AppSpacing.tradeBotGridAspectRatio`.
- Preserved suitability questions, category scoring, result gating, and
  continue-to-bots behavior.

Safety / boundary review:
- Suitability scoring and pass/fail behavior remain unchanged.
- Trade bot risk/suitability copy remains unchanged.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/bot_suitability_assessment_page_test.dart`.
- Route: `/trade/bots/suitability-assessment`.
- Result: first viewport still reaches first answer option; pass result still
  continues to Trading Bots.
- Artifact: `test/features/trade/bot_suitability_assessment_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/widgets/bot_suitability_breakdown_common.dart` -
  pass.
- `flutter test test/features/trade/bot_suitability_assessment_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=455`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=41`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 79 - SC-134 Bot API Documentation

Scope:
- Route/screen: `/trade/bots/api-documentation`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/bot_api_documentation_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/bot_api_documentation_websocket_examples.dart`

Impact:
- Context target: `BotApiDocumentationPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to API documentation page/websocket example
  padding token debt.

Implementation:
- Replaced documentation scroll `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced language button `EdgeInsets.symmetric(...)` with
  `EdgeInsetsDirectional.symmetric(...)`.
- Preserved endpoint cards, tabs, websocket/examples content, language toggle
  behavior, and back navigation.

Safety / boundary review:
- API documentation copy and examples remain unchanged.
- No API key/security behavior was changed.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/bot_api_documentation_page_test.dart`.
- Route: `/trade/bots/api-documentation`.
- Result: first viewport still reaches first endpoint card; tabs still switch
  websocket/examples content.
- Artifact: `test/features/trade/bot_api_documentation_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/bot_api_documentation_page.dart lib/features/trade/presentation/widgets/bot_api_documentation_websocket_examples.dart` -
  pass.
- `flutter test test/features/trade/bot_api_documentation_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=450`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=38`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 80 - SC-088 Advanced Trading Demo

Scope:
- Route/screen: `/trade/advanced-demo`.
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/advanced_trading_demo_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/advanced_trading_demo_page_common.dart`

Impact:
- Context target: `AdvancedTradingDemoPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to advanced demo page/sheet padding token debt.

Implementation:
- Replaced page scroll `EdgeInsets.only(...)` with
  `EdgeInsetsDirectional.only(...)`.
- Replaced demo sheet outer `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Preserved local tabs, demo controls, draft-mode copy, sheet panel behavior,
  and back navigation.

Safety / boundary review:
- Demo remains local/draft-only; no backend execution behavior was changed.
- Trade action copy and safety framing remain unchanged.
- Trade product copy guardrails remain green.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/advanced_trading_demo_page_test.dart`.
- Route: `/trade/advanced-demo`.
- Result: first viewport still reaches first position action; local tabs and
  demo controls still update.
- Artifact: `test/features/trade/advanced_trading_demo_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/advanced_trading_demo_page.dart lib/features/trade/presentation/widgets/advanced_trading_demo_page_common.dart` -
  pass.
- `flutter test test/features/trade/advanced_trading_demo_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=445`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=35`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 81 - SC-133 Bot Tax Reporting

Scope:
- Route: `/trade/bots/tax-reporting`
- Files touched:
  - `flutter_app/lib/features/trade/presentation/pages/bot_tax_reporting_page.dart`
  - `flutter_app/lib/features/trade/presentation/widgets/bot_tax_reporting_reports.dart`

Impact:
- Context target: `BotTaxReportingPage`.
- Class impact: `CRITICAL` because the screen is route-owned and imported by
  the app router.
- Direct callers/importers: route group imports, direct count `2`.
- Affected processes: `0`.
- Edit targets stayed limited to page/report-card directional padding debt.

Implementation:
- Replaced page scroll `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced report-generation `VitCard` padding `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Preserved tax-report draft copy, report type controls, generate action, and
  local report preview behavior.

Safety / boundary review:
- Tax reporting remains informational/draft-only; no tax, wallet, order, or
  backend execution behavior was changed.
- Trade product copy guardrails remain green.
- No casino/hype wording or financial-safety copy changes were introduced.

Visual QA:
- Viewport: focused first-viewport widget assertion in
  `test/features/trade/bot_tax_reporting_page_test.dart`.
- Route: `/trade/bots/tax-reporting`.
- Result: first viewport still reaches report type selection; controls still
  update the CTA and baseline tax-report content renders.
- Artifact: `test/features/trade/bot_tax_reporting_page_test.dart`.

Verification:
- `dart format lib/features/trade/presentation/pages/bot_tax_reporting_page.dart lib/features/trade/presentation/widgets/bot_tax_reporting_reports.dart` -
  pass.
- `flutter test test/features/trade/bot_tax_reporting_page_test.dart --reporter=compact` -
  pass, `4` tests.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=440`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=32`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for this screen; density remains below P1.
- Remaining P0 token debt after regeneration: `p0_trade_debt=32`,
  `p0_wallet_debt=39`.
- Next row:
  re-audit remaining Trade bundles and continue with the highest P0 token debt.

### Batch 82 - Trade Single-Token Padding Sweep A

Scope:
- Routes/files:
  - `/trade/active-copies` -
    `flutter_app/lib/features/trade/presentation/pages/active_copies_page.dart`
  - `/trade/advanced-tools-demo` -
    `flutter_app/lib/features/trade/presentation/pages/advanced_tools_demo_page.dart`
  - `/trade/best-execution-reports` -
    `flutter_app/lib/features/trade/presentation/pages/best_execution_reports_page.dart`
  - `/trade/bots/performance-analytics` -
    `flutter_app/lib/features/trade/presentation/pages/bot_performance_analytics_page.dart`
  - `/trade/bots/risk-disclosure` -
    `flutter_app/lib/features/trade/presentation/pages/bot_risk_disclosure_page.dart`
  - `/trade/bots/terms-of-service` -
    `flutter_app/lib/features/trade/presentation/pages/bot_terms_of_service_page.dart`
  - `/trade/cass-reconciliation` -
    `flutter_app/lib/features/trade/presentation/pages/cass_reconciliation_page.dart`
  - `/trade/client-money-protection` -
    `flutter_app/lib/features/trade/presentation/pages/client_money_protection_page.dart`
  - `/trade/complaints-handling` -
    `flutter_app/lib/features/trade/presentation/pages/complaints_handling_page.dart`
  - `/trade/convert` -
    `flutter_app/lib/features/trade/presentation/pages/convert_page.dart`

Impact:
- Context targets: `ActiveCopiesPage`, `AdvancedToolsDemoPage`,
  `BestExecutionReportsPage`, `BotPerformanceAnalyticsPage`,
  `BotRiskDisclosurePage`, `BotTermsOfServicePage`,
  `CassReconciliationPage`, `ClientMoneyProtectionPage`,
  `ComplaintsHandlingPage`, and `ConvertPage`.
- Impact result: all `LOW`, direct count `2`, affected processes `0`.
- Edit targets stayed limited to one scroll padding expression per screen.

Implementation:
- Replaced remaining raw `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Replaced remaining raw `EdgeInsets.only(bottom: ...)` with
  `EdgeInsetsDirectional.only(bottom: ...)`.
- Preserved route shell behavior, local tabs, copy, confirmation/risk panels,
  conversion controls, and all domain state providers.

Safety / boundary review:
- No trade execution, copy-trading enrollment, compliance, complaint, CASS, or
  client-money logic was changed.
- Financial-safety copy and Trade product copy guardrails remain green.

Visual QA:
- Viewport coverage: full Trade widget suite, including the existing
  `ConvertPage` quick-nav/route test, ran after the sweep.
- Result: routed Trade screens still render inside the Trade shell and route
  interactions remain stable.
- Artifact: `test/features/trade`.

Verification:
- `dart format` on the `10` touched Trade page files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=420`.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=22`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for these screens; density remains below P1.
- Remaining P0 token debt after regeneration: `p0_trade_debt=22`,
  `p0_wallet_debt=39`.
- Next row:
  continue the remaining Trade single-token route/widget queue.

### Batch 83 - Trade Single-Token Padding Sweep B

Scope:
- Routes/files:
  - `/trade/copy-audit-log` -
    `flutter_app/lib/features/trade/presentation/pages/copy_audit_log_page.dart`
  - `/trade/copy-performance` -
    `flutter_app/lib/features/trade/presentation/pages/copy_performance_page.dart`
  - `/trade/copy-provider/:id` -
    `flutter_app/lib/features/trade/presentation/pages/copy_provider_detail_page.dart`
  - `/trade/copy-safety-center` -
    `flutter_app/lib/features/trade/presentation/pages/copy_safety_center_page.dart`
  - `/trade/copy-trading-v2` -
    `flutter_app/lib/features/trade/presentation/pages/copy_trading_v2_page.dart`
  - `/trade/ex-ante-costs` -
    `flutter_app/lib/features/trade/presentation/pages/ex_ante_costs_page.dart`
  - `/trade/execution-venue-analysis` -
    `flutter_app/lib/features/trade/presentation/pages/execution_venue_analysis_page.dart`
  - `/trade/investor-compensation` -
    `flutter_app/lib/features/trade/presentation/pages/investor_compensation_page.dart`
  - `/trade/leverage` -
    `flutter_app/lib/features/trade/presentation/pages/leverage_page.dart`
  - `/trade/performance-scenarios` -
    `flutter_app/lib/features/trade/presentation/pages/performance_scenarios_page.dart`

Impact:
- Context targets: `CopyAuditLogPage`, `CopyPerformancePage`,
  `CopyProviderDetailPage`, `CopySafetyCenterPage`, `CopyTradingV2Page`,
  `ExAnteCostsPage`, `ExecutionVenueAnalysisPage`,
  `InvestorCompensationPage`, `LeveragePage`, and
  `PerformanceScenariosPage`.
- Impact result: all `LOW`, direct count `2`, affected processes `0`.
- Edit targets stayed limited to one scroll padding expression per screen.

Implementation:
- Replaced remaining raw `EdgeInsets.only(bottom: ...)` with
  `EdgeInsetsDirectional.only(bottom: ...)`.
- Replaced remaining raw `EdgeInsets.fromLTRB(...)` with
  `EdgeInsetsDirectional.fromSTEB(...)`.
- Preserved copy-provider detail state, compliance panels, leverage controls,
  fee/cost disclosure content, and performance-scenario risk framing.

Safety / boundary review:
- No enrollment, leverage, order, cost calculation, investor-compensation, or
  compliance behavior was changed.
- Financial-safety copy and Trade product copy guardrails remain green.

Visual QA:
- Viewport coverage: full Trade widget suite ran after the sweep.
- Result: routed Trade screens still render in the Trade shell and copy/trading
  navigation tests remain stable.
- Artifact: `test/features/trade`.

Verification:
- `dart format` on the `10` touched Trade page files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=400`.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=12`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for these screens; density remains below P1.
- Remaining P0 token debt after regeneration: `p0_trade_debt=12`,
  `p0_wallet_debt=39`.
- Next row:
  finish the remaining Trade single-token route/widget queue.

### Batch 84 - Trade Single-Token Padding Sweep C

Scope:
- Routes/files:
  - `/trade/portfolio-risk-analysis` -
    `flutter_app/lib/features/trade/presentation/pages/portfolio_risk_analysis_page.dart`
  - `/trade/positions` -
    `flutter_app/lib/features/trade/presentation/pages/position_dashboard_page.dart`
  - `/trade/provider-leaderboard` -
    `flutter_app/lib/features/trade/presentation/pages/provider_leaderboard_page.dart`
  - `/trade/regulatory-disclosures` -
    `flutter_app/lib/features/trade/presentation/pages/regulatory_disclosures_page.dart`
  - `/trade/risk-management-demo` -
    `flutter_app/lib/features/trade/presentation/pages/risk_management_demo_page.dart`
  - `/trade/safety-education` -
    `flutter_app/lib/features/trade/presentation/pages/safety_education_page.dart`
  - `/trade/arm-integration-status` part widget -
    `flutter_app/lib/features/trade/presentation/widgets/arm_integration_providers.dart`
  - `/trade/bots/risk-dashboard` part widget -
    `flutter_app/lib/features/trade/presentation/widgets/bot_risk_dashboard_metrics.dart`
  - `/trade/copy-confirmation` part widget -
    `flutter_app/lib/features/trade/presentation/widgets/copy_confirmation_page_common.dart`
  - Shared token add-only:
    `flutter_app/lib/app/theme/app_spacing.dart`

Impact:
- Context targets: `PortfolioRiskAnalysisPage`, `PositionDashboardPage`,
  `ProviderLeaderboardPage`, `RegulatoryDisclosuresPage`,
  `RiskManagementDemoPage`, `SafetyEducationPage`,
  `ArmIntegrationStatusPage`, `BotRiskDashboardPage`, and
  `CopyConfirmationPage`.
- Impact result for route/widget owners: all `LOW`, direct count `2`,
  affected processes `0`.
- Shared token target: `AppSpacing` returned `CRITICAL`, direct count `607`,
  affected processes `0`. The actual token change was add-only: no existing
  spacing, size, or aspect-ratio token value was modified.

Implementation:
- Replaced final Trade raw `EdgeInsets.only(...)`,
  `EdgeInsets.fromLTRB(...)`, and `EdgeInsets.symmetric(...)` debt with
  directional equivalents.
- Added `AppSpacing.tradeBotCriticalMetricAspectRatio` and used it for the
  bot risk dashboard critical metrics grid instead of the raw `1.85` literal.
- Preserved risk education, regulatory disclosure, leaderboard, position,
  portfolio-risk, ARM provider, bot risk, and copy-confirmation behavior.

Safety / boundary review:
- No position, risk, copy-confirmation, provider, ARM, disclosure, or bot risk
  logic was changed.
- The `AppSpacing` edit was additive only and covered by analyze, full Trade
  tests, and audit checks.
- Financial-safety copy and Trade product copy guardrails remain green.

Visual QA:
- Viewport coverage: full Trade widget suite ran after the final sweep.
- Result: routed Trade screens still render in the Trade shell and scoped bot,
  copy, settings, conversion, transaction-reporting, and route-navigation tests
  remain stable.
- Artifact: `test/features/trade`.

Verification:
- `dart format` on the `9` touched Trade/theme files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=379`.
- `flutter test test/features/trade --reporter=compact` - pass, `430` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_trade_debt=0`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for Trade P0 token debt; density remains below P1.
- Remaining P0 token debt after regeneration: `p0_trade_debt=0`,
  `p0_wallet_debt=39`.
- Next row:
  move to the P0 Wallet token-debt queue.

### Batch 85 - Wallet Page Padding Sweep A

Scope:
- Routes/files:
  - `/wallet/address-book` -
    `flutter_app/lib/features/wallet/presentation/pages/address_book_page.dart`
  - `/wallet/asset/:symbol` -
    `flutter_app/lib/features/wallet/presentation/pages/asset_detail_page.dart`
  - `/wallet/network-status` -
    `flutter_app/lib/features/wallet/presentation/pages/network_status_page.dart`
  - `/wallet/pending-deposits` -
    `flutter_app/lib/features/wallet/presentation/pages/pending_deposits_page.dart`
  - `/wallet/transactions/:id` -
    `flutter_app/lib/features/wallet/presentation/pages/transaction_detail_page.dart`
  - `/wallet/transactions` -
    `flutter_app/lib/features/wallet/presentation/pages/transaction_history_page.dart`
  - `/wallet/withdraw-limits` -
    `flutter_app/lib/features/wallet/presentation/pages/withdraw_limits_page.dart`
  - `/wallet/transfer` -
    `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart`
  - `/wallet/portfolio-analytics` -
    `flutter_app/lib/features/wallet/presentation/pages/portfolio_analytics_page.dart`

Impact:
- Context targets: `AddressBookPage`, `AssetDetailPage`,
  `NetworkStatusPage`, `PendingDepositsPage`, `TransactionDetailPage`,
  `TransactionHistoryPage`, `WithdrawLimitsPage`, `TransferPage`, and
  `PortfolioAnalyticsPage`.
- Impact result: all `LOW`, direct count `2`, affected processes `0`.
- Edit targets stayed limited to page-local padding constants and one scroll
  padding expression.

Implementation:
- Replaced page-local raw `EdgeInsets.symmetric(...)`,
  `EdgeInsets.fromLTRB(...)`, and `EdgeInsets.only(...)` debt with
  directional equivalents.
- Preserved existing padding numbers to avoid changing the visual density of
  wallet, transfer, history, limits, pending deposit, and address flows.
- No provider, amount, network, transaction, or confirmation state was touched.

Safety / boundary review:
- Wallet flows remain confirmation-safe; no withdrawal, transfer, address-book,
  fee, network, transaction, or deposit logic was changed.
- P2P/Wallet product copy guardrails remain green.

Visual QA:
- Viewport coverage: full Wallet widget suite ran after the sweep.
- Result: wallet baseline, withdraw, withdraw limits, transfer, transaction,
  asset detail, network status, pending deposit, and portfolio analytics tests
  remain stable.
- Artifact: `test/features/wallet`.

Verification:
- `dart format` on the `9` touched Wallet page files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=335`.
- `flutter test test/features/wallet --reporter=compact` - pass, `83` tests.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `p0_wallet_debt=17`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart --check` - pass,
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=196`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for these screens; density remains below P1.
- Remaining P0 token debt after regeneration: `p0_trade_debt=0`,
  `p0_wallet_debt=17`.
- Next row:
  finish Wallet health/gas/transfer widget token debt.

### Batch 86 - Wallet Health/Gas/Transfer Token Sweep

Scope:
- Routes/files:
  - `/wallet/health-score` -
    `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page.dart`
    and parts `wallet_health_score_page_part_01.dart`,
    `wallet_health_score_page_part_02.dart`
  - `/wallet/gas-optimizer` -
    `flutter_app/lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart`
    and `wallet_gas_optimizer_current.dart`
  - `/wallet/transfer` helper widgets -
    `flutter_app/lib/features/wallet/presentation/widgets/wallet_transfer_sections.dart`,
    `wallet_transfer_asset_amount.dart`, `wallet_transfer_confirm_sheet.dart`,
    and `wallet_transfer_wallet_cards.dart`

Impact:
- Context targets: `WalletHealthScorePage`, `WalletGasOptimizerPage`, and
  `TransferPage`.
- Impact result: all `LOW`, direct count `2`, affected processes `0`.
- Edit targets stayed limited to local size constants and directional padding
  in Wallet health, gas, and internal transfer widgets.

Implementation:
- Replaced remaining Wallet raw `SizedBox` dimensions with scoped local
  constants, preserving existing heights/widths.
- Replaced remaining transfer-widget raw `EdgeInsets.*` debt with
  `EdgeInsetsDirectional.*`.
- Preserved transfer confirmation copy, wallet selection, amount entry, gas
  speed tabs, wallet health metrics, and first-viewport behavior.

Safety / boundary review:
- No transfer, gas estimate, wallet health scoring, balance, fee, address, or
  confirmation logic was changed.
- P2P/Wallet product copy guardrails remain green.

Visual QA:
- Viewport coverage: full Wallet widget suite ran after the sweep.
- Result: Wallet health first viewport, gas optimizer current baseline,
  transfer/withdraw, wallet baseline, and route-stability tests remain green.
- Artifact: `test/features/wallet`.

Verification:
- `dart format` on the `9` touched Wallet page/widget files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=312`.
- `flutter test test/features/wallet --reporter=compact` - pass, `83` tests.
- `flutter test test/quality/p2p_wallet_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.
- `dart run tool/body_component_consistency_audit.dart` - regenerated stale
  artifacts, unchanged `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart` and
  `dart run tool/ui_fullscreen_density_audit.dart` - regenerated stale
  artifacts, unchanged `P1_HIGH=0`, `P2=1`, `P1_density_refactor=0`.
- Final audit checks pass:
  `p0_markets_debt=0`, `p0_p2p_debt=0`, `p0_profile_debt=0`,
  `p0_trade_debt=0`, `p0_wallet_debt=0`, strict typography residuals `0`.

Ledger update:
- Status: `fixed`.
- Residual exception: none for Wallet P0 token debt; density remains below P1.
- Remaining P0 token debt after regeneration: all tracked P0 modules are `0`.
- Non-P0 residual token debt remains and must continue through Phase 3/5:
  root-page-bundle summary debt is `128`, total debt is `312`.
- Next row:
  continue module rollout for non-P0 residual debt; do not run final gate yet.

### Batch 87 - Launchpad Line-Height And Padding Sweep

Scope:
- Feature: `launchpad`
- Owner routes impacted:
  `LaunchpadAbiDiffPage`, `LaunchpadAddressBookPage`,
  `LaunchpadBridgeComparePage`, `LaunchpadClaimReceiptPage`,
  `LaunchpadEventLogPage`, `LaunchpadGasTrackerPage`,
  `LaunchpadLimitOrdersPage`, `LaunchpadMultisigPage`,
  `LaunchpadNotifSoundPage`, `LaunchpadPage`,
  `LaunchpadPerformancePage`, `LaunchpadPortfolioPage`,
  `LaunchpadReceiptPage`, `LaunchpadRiskAnalyticsPage`,
  `LaunchpadStakingPage`, `LaunchpadSwapAggregatorPage`, and
  `LaunchpadWebhooksPage`.
- Shared token add-only:
  `flutter_app/lib/app/theme/app_spacing.dart`
  added `AppSpacing.launchpadLineHeightMicro`.

Impact:
- Route/widget owner impact: all `LOW`, direct count `2`, affected processes
  `0`.
- Shared token target: `AppSpacing` returned `CRITICAL`, direct count `607`,
  affected processes `0`. The actual shared change was add-only; no existing
  token value was modified.

Implementation:
- Replaced Launchpad literal `TextStyle.height` values with
  `AppSpacing.launchpadLineHeightTight`, `launchpadLineHeightMicro`,
  `launchpadLineHeightCompact`, `launchpadLineHeightLabel`, and
  `launchpadLineHeightShort`.
- Replaced remaining raw Launchpad `EdgeInsets.only(...)`,
  `EdgeInsets.all(...)`, `EdgeInsets.symmetric(...)`, and
  `EdgeInsets.fromLTRB(...)` debt with directional equivalents.
- Preserved launchpad claims, receipts, bridge, gas tracker, staking,
  multisig, webhooks, portfolio, swap aggregator, and limit-order behavior.

Safety / boundary review:
- No subscription, claim, receipt, bridge, swap, staking, alert, webhook, or
  risk calculation logic was changed.
- Product copy guardrail remains green.

Visual QA:
- Viewport coverage: full Launchpad widget suite ran after the sweep.
- Result: Launchpad baseline, bridge, claim receipt, gas tracker, event log,
  DCA builder, multisig, portfolio, performance, risk analytics, receipt,
  rebalance, swap aggregator, staking, and webhooks tests remain green.
- Artifact: `test/features/launchpad`.

Verification:
- `dart format` on Launchpad files containing
  `AppSpacing.launchpadLineHeight*`, `launchpad_page.dart`,
  `launchpad_performance_page.dart`, `launchpad_webhooks_page.dart`, and
  `app_spacing.dart` - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=191`, Launchpad residual `0`.
- `flutter test test/features/launchpad --reporter=compact` - pass,
  `147` tests.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  strict typography residuals `0`, all tracked P0 module debts `0`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_Tool=5`.
- `dart run tool/visual_density_risk_audit.dart` - regenerated stale artifacts;
  `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=208`.
- `dart run tool/ui_fullscreen_density_audit.dart` - regenerated stale
  artifacts; `P1_density_refactor=0`, `P2_visual_density_review=4`.
- Final audit checks pass after regeneration.

Ledger update:
- Status: `fixed`.
- Residual exception: Launchpad token debt is `0`; density remains below P1.
  P3 low-density monitor count increased after tokenization but P0/P1/P2 gates
  did not regress.
- Remaining total token debt after regeneration: `191`.
- Next row:
  continue module rollout with Earn residual token debt.

### Batch 88 - Earn Line-Height And Padding Sweep

Scope:
- Feature: `earn`
- Owner routes impacted:
  `AutoCompoundSettingsPage`, `SavingsAutoRebalancePage`,
  `SavingsAutoPilotPage`, `SavingsDCAPage`, `SavingsFAQPage`,
  `SavingsHistoryPage`, `SavingsLadderPage`, `SavingsPortfolioPage`,
  `StakingAnalyticsPage`, `StakingDataExportPage`,
  `StakingRiskDashboardPage`, `StakingRiskDisclosurePage`,
  `StakingRiskScoreCalculatorPage`, `StakingSocialFeedPage`,
  `StakingSuitabilityAssessmentPage`, `StakingTransactionReportingPage`,
  `StakingValidatorHealthMonitorPage`, and
  `StakingWithdrawalPolicyPage`.

Impact:
- Route/widget owner impact: all `LOW`, direct count `2`, affected processes
  `0`.
- No shared token was added or modified.

Implementation:
- Replaced remaining Earn literal `TextStyle.height: 1.2` debt with the
  existing `AppSpacing.stakingEarnHeroTabLabelLineHeight` token.
- Replaced remaining raw Earn `EdgeInsets.only(...)`,
  `EdgeInsets.all(...)`, `EdgeInsets.symmetric(...)`,
  `EdgeInsets.fromLTRB(...)`, and zero-padding audit debt with directional
  equivalents.
- Repaired encoding after the bulk token rewrite for touched Earn files that
  showed mojibake-pattern regressions, then reran the focused withdrawal
  policy test before the full Earn suite.

Safety / boundary review:
- No Earn repository, staking policy, withdrawal preview, calculator, DCA,
  risk, validator health, suitability, social feed, or transaction reporting
  logic was changed.
- Financial-safety copy and Arena boundaries are unchanged.

Visual QA:
- Viewport coverage: full Earn widget suite ran after the sweep.
- Result: savings, staking, validator, risk, disclosure, withdrawal,
  reporting, social feed, and data export tests remain green.
- Artifact: `test/features/earn`.

Verification:
- `dart format` on touched Earn page/widget files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=62`, Earn residual `0`.
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  strict typography residuals `0`, all tracked P0 module debts `0`.
- `flutter test test/features/earn/staking_withdrawal_policy_page_test.dart --reporter=compact` -
  pass, `6` tests.
- `flutter test test/features/earn --reporter=compact` - pass, `380` tests.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: Earn token debt is `0`.
- Remaining total token debt after regeneration: `62`.
- Next row:
  continue module rollout with Arena residual token debt.

### Batch 89 - Arena Directional Padding Sweep

Scope:
- Feature: `arena`
- Owner routes impacted:
  `ArenaHomePage`, `ArenaLeaderboardPage`,
  `ArenaPredictionBridgeFoundationPage`, `ArenaReportCasePage`,
  `ConnectedEcosystemProductionPage`, and `ArenaSafetyCenterPage`.

Impact:
- Route/widget owner impact: all `LOW`, direct count `2`, affected processes
  `0`.
- No shared token was added or modified.

Implementation:
- Replaced remaining Arena raw `EdgeInsets.only(...)`,
  `EdgeInsets.all(...)`, `EdgeInsets.symmetric(...)`, and zero-padding debt
  with directional equivalents.
- Used explicit UTF-8 read/write for the mechanical rewrite and verified no
  mojibake-pattern hits in patched Arena files.

Safety / boundary review:
- No Arena points ledger, reporting, safety, leaderboard, connected ecosystem,
  route, or bridge logic was changed.
- Arena copy remains points-only; Prediction Markets and Open Arena boundaries
  remain separated.

Visual QA:
- Viewport coverage: full Arena widget suite ran after the sweep.
- Result: home, leaderboard, bridge foundation, report case, safety center,
  connected ecosystem, studio, governance, and My Arena tests remain green.
- Artifact: `test/features/arena`.

Verification:
- `dart format` on touched Arena page/widget files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=36`, Arena residual `0`.
- `flutter test test/features/arena --reporter=compact` - pass, `143` tests.
- `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` -
  pass, `7` tests.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: Arena token debt is `0`.
- Remaining total token debt after regeneration: `36`.
- Next row:
  continue module rollout with Predictions residual token debt.

### Batch 90 - Predictions Data And Rewards Line-Height Sweep

Scope:
- Feature: `predictions`
- Owner routes impacted:
  `PredictionDataIntegrationPage` and `PredictionsRewardsPage`.
- Shared token add-only:
  `flutter_app/lib/app/theme/app_spacing.dart`
  added `AppSpacing.predictionDataCompactLineHeight`.

Impact:
- Route/widget owner impact: all `LOW`, direct count `2`, affected processes
  `0`.
- Shared token target: `AppSpacing` returned `CRITICAL`, direct count `607`,
  affected processes `0`. The actual shared change was add-only; no existing
  token value was modified.

Implementation:
- Replaced remaining Predictions literal `TextStyle.height` values in data
  integration widgets with `AppSpacing.predictionDataCompactLineHeight` and
  `AppSpacing.predictionDataMetricLineHeight`.
- Replaced the Rewards Arena bridge tiny-badge literal with
  `AppSpacing.predictionRewardsTinyBadgeLineHeight`.

Safety / boundary review:
- No Prediction Markets event, portfolio, receipt, order, data integration,
  reward, or Arena bridge logic was changed.
- Prediction Markets copy guardrail remains green and Arena boundary copy is
  unchanged.

Visual QA:
- Viewport coverage: full Predictions widget suite ran after the sweep.
- Result: home, event detail, rewards, portfolio, data integration, receipt,
  risk calculator, social, tournament, and search tests remain green.
- Artifact: `test/features/predictions`.

Verification:
- `dart format` on `app_spacing.dart` and touched Predictions widgets - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=21`, Predictions residual `0`.
- `flutter test test/features/predictions --reporter=compact` - pass,
  `104` tests.
- `flutter test test/quality/prediction_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: Predictions token debt is `0`.
- Remaining total token debt after regeneration: `21`.
- Next row:
  continue module rollout with DCA residual token debt.

### Batch 91 - DCA Directional Padding Sweep

Scope:
- Feature: `dca`
- Owner routes impacted:
  `DCAPortfolioOptimizer` and `DCARebalanceConfig`.

Impact:
- Route/widget owner impact: all `LOW`, direct count `2`, affected processes
  `0`.
- No shared token was added or modified.

Implementation:
- Replaced remaining DCA raw `EdgeInsets.only(...)`,
  `EdgeInsets.all(...)`, and `EdgeInsets.fromLTRB(...)` debt with directional
  equivalents.
- Used explicit UTF-8 read/write for the mechanical rewrite.

Safety / boundary review:
- No DCA schedule, rebalance, portfolio optimizer, strategy, amount, or route
  logic was changed.
- Trade-adjacent copy guardrail remains green.

Visual QA:
- Viewport coverage: full DCA widget suite ran after the sweep.
- Result: dashboard, schedule config, rebalance config, portfolio optimizer,
  backtester, multi-asset, dynamic amount, performance compare, and smart rules
  tests remain green.
- Artifact: `test/features/dca`.

Verification:
- `dart format` on touched DCA page files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=11`, DCA residual `0`.
- `flutter test test/features/dca --reporter=compact` - pass, `51` tests.
- `flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact` -
  pass, `2` tests.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: DCA token debt is `0`.
- Remaining total token debt after regeneration: `11`.
- Next row:
  continue module rollout with Referral residual token debt.

### Batch 92 - Referral Support News Final Padding Sweep

Scope:
- Features: `referral`, `support`, and `news`
- Owner routes impacted:
  `ReferralHomePage`, `AnnouncementsPage`, and `NewsPage`.

Impact:
- Route/widget owner impact: all `LOW`, direct count `2`, affected processes
  `0`.
- No shared token was added or modified.

Implementation:
- Replaced the remaining Referral raw `EdgeInsets.only(...)` and
  `EdgeInsets.symmetric(...)` debt with directional equivalents.
- Replaced the remaining Support announcements raw `EdgeInsets.all(...)` debt
  with a directional equivalent.
- Replaced the remaining News raw `EdgeInsets.only(...)` debt with a
  directional equivalent.
- Used explicit UTF-8 read/write for the mechanical rewrite.

Safety / boundary review:
- No referral reward, announcement, support ticket, help-center, news filter,
  article detail, or route logic was changed.
- All changes are layout-token normalization only.

Visual QA:
- Viewport coverage: full Referral, Support, and News widget suites ran after
  the sweep.
- Result: referral home/rewards/rules/history/detail, support hub/help
  center/announcements, and news feed/detail/filter tests remain green.
- Artifacts: `test/features/referral`, `test/features/support`, and
  `test/features/news`.

Verification:
- `dart format` on touched Referral, Support, and News files - pass.
- `dart run tool/design_token_consistency_audit.dart` - regenerated artifacts,
  `total_debt=0`, all feature residuals `0`.
- `flutter test test/features/referral --reporter=compact` - pass,
  `26` tests.
- `flutter test test/features/support --reporter=compact` - pass, `19` tests.
- `flutter test test/features/news --reporter=compact` - pass, `7` tests.
- `flutter analyze` - pass.

Ledger update:
- Status: `fixed`.
- Residual exception: none. Design token consistency debt is `0`.
- Remaining total token debt after regeneration: `0`.
- Next row:
  run final audit and review gate.

### Batch 93 - Final Audit And Review Gate

Scope:
- Whole Flutter app UI standardization gate after all P0 and residual
  design-token debt sweeps.
- Audit artifacts regenerated where strict/current checks reported stale
  output.

Impact:
- No production Dart symbols were edited in this batch.
- Artifact-only refreshes covered visual density, back navigation, and
  top-header audit outputs.

Implementation:
- Regenerated stale `VitTrade-Visual-Density-Risk-Audit.*` artifacts.
- Regenerated stale `VitTrade-Header-Back-Navigation-Behavior-Audit.*`
  artifacts.
- Regenerated stale top-header action, behavior, global access policy, and
  visual archetype audit artifacts.
- Re-ran full static and test gates after artifact refresh.

Safety / boundary review:
- Design token consistency debt is `0` across root pages, feature widgets,
  shared layout, shared widgets, and all tracked P0 modules.
- Arena points-only copy, Prediction Markets boundary copy, trade high-risk
  copy, and wallet/P2P safety guardrails were exercised through the full suite.
- Code review found no blocking correctness, architecture, security, or
  performance issues in the completed normalization work.

Final verification:
- `dart run tool/design_token_consistency_audit.dart --check` - pass,
  `total_debt=0`, strict typography residuals `0`, all tracked P0 module
  debts `0`.
- `dart run tool/body_component_consistency_audit.dart --check` - pass,
  `total_routed_screens=414`, `grade_A=404`, `grade_B=5`, `grade_C=0`,
  `grade_D=0`, `grade_Tool=5`, `priority_P0=0`, `priority_P1=0`.
- `dart run tool/visual_density_risk_audit.dart` then `--check` - pass after
  regeneration, `P0=0`, `P1_HIGH=0`, `P2=1`, `P3=216`, `PASS_MONITOR=192`.
- `dart run tool/ui_fullscreen_density_audit.dart --check` - pass,
  `P1_density_refactor=0`, `P2_visual_density_review=4`.
- `dart run tool/back_navigation_behavior_audit.dart` - regenerated,
  `strict_back_issues=0`; `flutter test
  test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact`
  - pass.
- `dart run tool/top_header_action_audit.dart` - regenerated,
  `vit_header_with_custom_trailing=0`, `vit_header_with_legacy_action=0`,
  `migration_candidates=0`, `banned_icon_usages=0`.
- `dart run tool/top_header_behavior_audit.dart` - regenerated,
  `fixed_vit_header_remaining=0`.
- `dart run tool/top_header_global_access_policy_audit.dart` - regenerated,
  `policy_violations=0`.
- `dart run tool/top_header_visual_archetype_audit.dart` - regenerated,
  `strict_visual_issues=0`, `screen_level_mismatches=0`.
- `flutter test` for top-header guardrails - pass, `6` tests.
- `flutter analyze` - pass.
- `flutter test --reporter=compact` - pass, `2339` tests.

Ledger update:
- Status: `complete`.
- Residual exception: none.
- Final design token consistency debt: `0`.
- Next row:
  enterprise-grade UI standardization complete.

## 13. Recommended First AI Prompt

Use this in a fresh AI thread:

```text
Execute docs/03_DESIGN_SYSTEM/VitTrade-Enterprise-Grade-UI-Standardization-Plan.md.

Do not create a new plan. Start with Phase 0, confirm all current audit artifacts
and the 414-row inventory, then work the highest-priority open screen queue.

Use Home as the visual baseline. Use shared Flutter primitives and theme tokens
first. Do not skip any route. Preserve financial safety and Prediction
Markets/Open Arena boundaries. Run GitNexus impact before editing Dart symbols.
After each batch, update the ledger evidence and continue to the next eligible
row until the final gate passes or a real blocker is documented.
```

## 14. Final Target

The standardization pass is complete when a user can move between Home, Markets,
Trade, Wallet, Profile, P2P, Earn, Launchpad, Predictions, Arena, DCA, support,
and internal utility routes without feeling that the app changes size, spacing,
card language, or visual polish from screen to screen.

The measurable target is:

- 414 routed screens accounted for.
- No unreviewed B/C/D body-grade pages.
- No unreviewed P2 density pages.
- P3 pages assigned to monitor or fixed.
- Root-page-bundle token debt cleared or justified.
- Tool routes documented with QA evidence.
- Full audit suite, `flutter analyze`, and `flutter test --reporter=compact`
  pass.
