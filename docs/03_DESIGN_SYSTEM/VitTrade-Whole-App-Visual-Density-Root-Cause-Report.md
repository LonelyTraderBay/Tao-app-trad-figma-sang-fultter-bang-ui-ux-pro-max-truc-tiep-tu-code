# VitTrade Whole-App Visual Density Root Cause Report

**Date:** 2026-06-19  
**Scope:** 414 routed Flutter screens across 23 features  
**Goal:** Find why screens can pass shared-component audits but still feel sparse,
loose, or unlike the compact Home standard on real phone viewports.

## 1. Report Artifacts

This report is the human-readable root-cause analysis.

The full per-screen matrix is here:

`flutter_app/run-artifacts/visual-density/whole_app_visual_density_root_cause_matrix.csv`

That CSV contains all 414 routed screens. Each row includes:

- feature,
- route,
- page class,
- page file,
- official density score,
- supplemental visual density score,
- priority,
- tokenized fixed-height references,
- tokenized gap references,
- `Spacer()` references,
- manual content density bypass references,
- bottom inset references,
- top chrome references,
- root-cause labels,
- recommended action.

### 2026-06-20 Closeout

The maintained current gate is now:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md`

Final checked counts: P0 `0`, P1 `0`, tool QA `5`, P2 `113`, P3 `143`, and
pass/monitor `153`.

Tool-screen evidence is saved in:

- `flutter_app/run-artifacts/whole_app_tool_visual_qa/report.md`

P2/P3 assignment is tracked in:

- `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`
- `docs/03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.md`

## 2. Main Conclusion

The same root cause found on `ProfilePage` exists across the app.

The project has largely succeeded at shared-component adoption, but the current
definition of "done" still does not enforce **first-viewport content density**.

The app can therefore pass official audits while still looking sparse because:

- screens use shared components correctly,
- screens use `AppSpacing` tokens correctly,
- widget QA confirms the routes render,
- but the first phone viewport is consumed by tokenized fixed heights, vertical
  gaps, `Spacer()` blocks, bottom-nav insets, and top chrome.

This is a design-system governance gap, not only a page-by-page implementation
bug.

## 3. Data Sources

The analysis combined:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`
- `docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv`
- route source files listed in the audit CSVs,
- the real emulator evidence already captured for `ProfilePage`,
- supplemental static scan for tokenized visual-density signals.

Official audit baseline:

| Metric | Count |
| --- | ---: |
| Routed screens scanned | 414 |
| Features scanned | 23 |
| Body grade A | 409 |
| Fullscreen tool grade | 5 |
| Official density P1 | 5 |
| Official density P2 | 0 |
| Official pass / low signal | 409 |

Important interpretation: the official audit says almost everything is structurally
compliant. The supplemental scan asks a different question: "will this screen
feel compact and useful in the first phone viewport?"

## 4. Supplemental Scoring Method

The supplemental score is a heuristic review score, not yet an official gate.
It is intentionally designed to catch what the current audits miss.

Signals counted:

| Code | Signal | Why it matters |
| --- | --- | --- |
| `H` | `height: AppSpacing.*Height`, `*CardHeight`, `*HeroHeight`, etc. | Tokenized fixed heights can still overdraw the first viewport. |
| `G` | `SizedBox(height: AppSpacing.*Gap/*Inset/*Footer/*Top/*Bottom)` | Feature-local vertical gaps accumulate even when tokenized. |
| `S` | `Spacer()` | Inside fixed-height cards it creates loose, stretched cards. |
| `M` | `customGap`, `VitContentPadding.relaxed`, `VitContentGap.loose/relaxed` | Shared layout can be bypassed into relaxed density. |
| `B` | `bottomInset`, `bottomChrome`, `nativeBottomChrome` | Bottom nav and scroll clearance reduce visible useful content. |
| `R` | `VitTopChromeType.rootModule/rootBrand` | Root chrome consumes the first viewport before content starts. |

Priority bands:

| Priority | Meaning |
| --- | --- |
| `P0_CRITICAL_DENSITY_REVIEW` | Highest visual-density risk; first-pass compact refactor candidate. |
| `P1_HIGH_DENSITY_REVIEW` | High risk; should be refactored after P0 or with the same archetype. |
| `P1_TOOL_VISUAL_QA` | Fullscreen tool; needs manual emulator QA rather than generic compacting. |
| `P2_MEDIUM_DENSITY_REVIEW` | Medium density drift; batch refactor after reference patterns are established. |
| `P3_LOW_DENSITY_REVIEW` | Low density signal; monitor when touched. |
| `PASS_MONITOR` | No immediate density action from static scan. |

## 5. Whole-App Result

| Priority | Screens |
| --- | ---: |
| `P0_CRITICAL_DENSITY_REVIEW` | 101 |
| `P1_HIGH_DENSITY_REVIEW` | 67 |
| `P1_TOOL_VISUAL_QA` | 5 |
| `P2_MEDIUM_DENSITY_REVIEW` | 111 |
| `P3_LOW_DENSITY_REVIEW` | 119 |
| `PASS_MONITOR` | 11 |

Root-cause totals:

| Root cause | Screens |
| --- | ---: |
| Official audit blind spot | 279 |
| Shared-component compliant but sparse | 279 |
| Tokenized fixed-height pressure | 210 |
| Very high tokenized fixed-height pressure | 83 |
| Vertical gap accumulation | 131 |
| Very high vertical gap accumulation | 97 |
| Spacer-driven looseness | 108 |
| Manual content density bypass | 99 |
| Bottom-nav inset pressure | 397 |
| Root top chrome first-viewport cost | 11 |

Interpretation:

- The most important number is `279` official blind spots. These are screens
  where the official score is low, but tokenized visual-density risk is real.
- The second important number is `397` bottom-inset references. This does not
  mean 397 screens are broken; it means almost every screen pays a bottom-nav
  budget cost and must be measured against it.
- `210` screens have tokenized fixed-height pressure. This confirms the root
  issue is not raw hard-coded pixels; it is approved tokens being used without
  density budgets.

## 6. Feature-Level Summary

| Feature | Screens | Avg risk | Max | P0 | P1 | Tool | P2 | P3 | Pass | Blind spots |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| news | 1 | 90 | 90 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| trade | 91 | 74.4 | 206 | 48 | 22 | 3 | 12 | 6 | 0 | 82 |
| predictions | 19 | 70.6 | 136 | 13 | 4 | 0 | 2 | 0 | 0 | 19 |
| profile | 14 | 66.7 | 112 | 9 | 5 | 0 | 0 | 0 | 0 | 14 |
| markets | 22 | 61.9 | 184 | 10 | 3 | 0 | 7 | 1 | 1 | 20 |
| home | 1 | 49 | 49 | 0 | 1 | 0 | 0 | 0 | 0 | 1 |
| wallet | 21 | 47.9 | 96 | 5 | 9 | 0 | 3 | 4 | 0 | 17 |
| arena | 26 | 46 | 114 | 6 | 5 | 0 | 11 | 4 | 0 | 22 |
| dca | 14 | 32.2 | 102 | 3 | 1 | 0 | 4 | 2 | 4 | 8 |
| launchpad | 24 | 31.7 | 61 | 1 | 3 | 0 | 15 | 5 | 0 | 19 |
| enterprise_states | 1 | 31 | 31 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |
| support | 3 | 29.3 | 33 | 0 | 0 | 0 | 2 | 1 | 0 | 2 |
| referral | 5 | 28.6 | 52 | 0 | 1 | 0 | 2 | 1 | 1 | 3 |
| p2p | 77 | 28.4 | 68 | 4 | 6 | 1 | 30 | 36 | 0 | 40 |
| rewards | 1 | 28 | 28 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |
| earn | 70 | 24.4 | 90 | 1 | 7 | 0 | 17 | 45 | 0 | 25 |
| cross_module | 4 | 24.2 | 32 | 0 | 0 | 0 | 2 | 1 | 1 | 2 |
| discovery | 3 | 23 | 35 | 0 | 0 | 0 | 1 | 2 | 0 | 1 |
| notifications | 1 | 22 | 22 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| admin | 5 | 21.8 | 32 | 0 | 0 | 0 | 1 | 4 | 0 | 1 |
| auth | 6 | 14.7 | 34 | 0 | 0 | 0 | 1 | 3 | 2 | 1 |
| dev | 4 | 14 | 20 | 0 | 0 | 0 | 0 | 3 | 1 | 0 |
| onboarding | 1 | 9 | 9 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |

## 7. Highest-Priority Screens

Legend:

- `H`: tokenized fixed-height refs.
- `G`: tokenized vertical gap refs.
- `S`: `Spacer()` refs.
- `M`: manual/relaxed content refs.
- `B`: bottom inset refs.

| Feature | Page | Route | Official | Visual | Priority | H | G | S | M | B | Root causes |
| --- | --- | --- | ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: | --- |
| trade | `ClientCategorizationPage` | `AppRoutePaths.tradeCopyClientCategorization` | 0 | 206 | P0 | 26 | 3 | 1 | 20 | 8 | fixed heights, manual content, bottom inset, audit blind spot |
| trade | `ClientOptUpRequestPage` | `AppRoutePaths.tradeCopyClientOptUpRequest` | 0 | 206 | P0 | 26 | 3 | 1 | 20 | 8 | fixed heights, manual content, bottom inset, audit blind spot |
| markets | `SocialSignalsPage` | `AppRoutePaths.marketsSignals` | 6 | 184 | P0 | 41 | 14 | 1 | 2 | 6 | fixed heights, very high gaps, bottom inset |
| markets | `MarketOverviewPage` | `AppRoutePaths.marketsOverview` | 5 | 183 | P0 | 38 | 17 | 3 | 1 | 6 | fixed heights, very high gaps, bottom inset |
| trade | `AdvancedAnalyticsPage` | `AppRoutePaths.tradeMarginAdvancedAnalytics` | 1 | 170 | P0 | 28 | 13 | 0 | 10 | 4 | fixed heights, gaps, manual content |
| trade | `MarketDataAnalyticsPage` | `AppRoutePaths.tradeMarginMarketDataAnalytics` | 1 | 159 | P0 | 24 | 1 | 0 | 15 | 4 | fixed heights, manual content |
| trade | `BotSecuritySettingsPage` | `AppRoutePaths.tradeBotSecuritySettings` | 1 | 155 | P0 | 19 | 13 | 0 | 12 | 5 | fixed heights, gaps, manual content |
| trade | `RegulatoryReportsDashboardPage` | `AppRoutePaths.tradeCopyRegulatoryReportsDashboard` | 0 | 141 | P0 | 17 | 5 | 1 | 13 | 5 | fixed heights, manual content |
| trade | `TraderProfilePage` | `'/trade/trader/:traderId'` | 0 | 138 | P0 | 27 | 9 | 4 | 2 | 6 | fixed heights, gaps, spacers |
| predictions | `PredictionEventDetailPage` | `'/markets/predictions/event/:eventId'` | 6 | 136 | P0 | 9 | 36 | 1 | 2 | 8 | very high gaps, fixed heights |
| trade | `BotTaxReportingPage` | `AppRoutePaths.tradeBotTaxReporting` | 0 | 133 | P0 | 20 | 23 | 0 | 2 | 8 | fixed heights, very high gaps |
| trade | `ActiveCopiesPage` | `AppRoutePaths.tradeCopyActive` | 0 | 131 | P0 | 25 | 9 | 4 | 1 | 8 | fixed heights, spacers |
| trade | `ClientMoneyProtectionPage` | `AppRoutePaths.tradeCopyClientMoneyProtection` | 0 | 128 | P0 | 21 | 11 | 1 | 6 | 4 | fixed heights, gaps, manual content |
| trade | `DisputeResolutionPage` | `AppRoutePaths.tradeCopyDisputeResolution` | 0 | 126 | P0 | 24 | 8 | 0 | 5 | 6 | fixed heights, gaps, manual content |
| trade | `InvestorCompensationPage` | `AppRoutePaths.tradeCopyInvestorCompensation` | 0 | 123 | P0 | 20 | 20 | 1 | 2 | 4 | fixed heights, very high gaps |
| trade | `BotApiDocumentationPage` | `AppRoutePaths.tradeBotApiDocumentation` | 0 | 121 | P0 | 16 | 23 | 1 | 2 | 6 | fixed heights, very high gaps |
| arena | `MyArenaPage` | `AppRoutePaths.arenaMy` | 0 | 114 | P0 | 27 | 0 | 0 | 4 | 6 | fixed heights, manual content |
| arena | `MyArenaPage` | `AppRoutePaths.profileArena` | 0 | 114 | P0 | 27 | 0 | 0 | 4 | 6 | fixed heights, manual content |
| trade | `ExecutionVenueAnalysisPage` | `AppRoutePaths.tradeCopyExecutionVenueAnalysis` | 0 | 114 | P0 | 16 | 22 | 1 | 1 | 6 | fixed heights, very high gaps |
| profile | `ProfilePage` | `AppRoutePaths.profile` | 3 | 112 | P0 | 9 | 17 | 7 | 1 | 6 | fixed heights, gaps, spacers, root chrome |
| trade | `SafetyEducationPage` | `AppRoutePaths.tradeCopySafety` | 0 | 112 | P0 | 18 | 20 | 0 | 1 | 6 | fixed heights, very high gaps |
| trade | `ComplaintsHandlingPage` | `AppRoutePaths.tradeCopyComplaintsHandling` | 0 | 110 | P0 | 17 | 16 | 1 | 2 | 6 | fixed heights, gaps, manual content |
| trade | `RegulatoryDisclosuresPage` | `AppRoutePaths.tradeCopyRegulatoryDisclosures` | 0 | 109 | P0 | 13 | 21 | 0 | 3 | 6 | fixed heights, very high gaps |
| trade | `MarginTradingPage` | `AppRoutePaths.tradeMargin` | 0 | 108 | P0 | 3 | 9 | 3 | 12 | 4 | gaps, spacers, manual content |
| trade | `BotGuidePage` | `AppRoutePaths.tradeBotGuide` | 0 | 107 | P0 | 1 | 3 | 0 | 17 | 6 | manual content density bypass |
| arena | `ArenaProductionReadyPage` | `AppRoutePaths.arenaProduction` | 1 | 106 | P0 | 22 | 0 | 0 | 6 | 4 | fixed heights, manual content |
| trade | `FuturesPage` | `'/trade/:pairId/futures'` | 13 | 106 | Tool | 11 | 18 | 3 | 0 | 6 | fullscreen tool, fixed heights, gaps |
| trade | `BotSuitabilityAssessmentPage` | `AppRoutePaths.tradeBotSuitabilityAssessment` | 7 | 105 | P0 | 18 | 13 | 0 | 1 | 6 | fixed heights, gaps |
| trade | `BestExecutionReportsPage` | `AppRoutePaths.tradeCopyBestExecutionReports` | 0 | 103 | P0 | 20 | 5 | 1 | 4 | 4 | fixed heights, manual content |
| dca | `DCAPage` | `AppRoutePaths.dca` | 5 | 102 | P0 | 22 | 0 | 2 | 2 | 5 | fixed heights, root chrome |
| trade | `CopySettingsPage` | `AppRoutePaths.tradeCopySettings` | 0 | 101 | P0 | 17 | 6 | 4 | 1 | 8 | fixed heights, spacers |
| predictions | `PredictionAdvancedChartPage` | `'/markets/predictions/advanced-chart/:eventId'` | 5 | 100 | P0 | 8 | 7 | 0 | 8 | 8 | fixed heights, manual content |
| wallet | `WalletGasOptimizerPage` | `AppRoutePaths.walletGasOptimizer` | 0 | 96 | P0 | 8 | 11 | 3 | 5 | 6 | fixed heights, gaps, manual content |
| wallet | `WalletHealthScorePage` | `AppRoutePaths.walletHealthScore` | 0 | 96 | P0 | 6 | 10 | 0 | 9 | 6 | gaps, manual content |
| profile | `ApiKeyCreatePage` | `AppRoutePaths.profileApiCreate` | 0 | 91 | P0 | 5 | 11 | 1 | 2 | 19 | gaps, bottom inset |
| news | `NewsPage` | `AppRoutePaths.news` | 6 | 90 | P0 | 14 | 7 | 0 | 3 | 6 | fixed heights, gaps, manual content |

For the complete 414-screen table, use the CSV matrix listed in section 1.

## 8. Feature-By-Feature Root Cause Notes

### Trade

`trade` is the largest and highest-risk module: 91 screens, 48 P0, 22 P1, and
3 fullscreen tools.

Root causes:

- copy-trading compliance/report pages share heavy layout patterns,
- many tokenized fixed heights and repeated metric/report cards,
- high manual content refs on bot, margin, and analytics pages,
- multiple fullscreen tools need manual QA instead of generic compaction.

Recommended approach:

1. Create compact report/compliance card primitives.
2. Refactor copy-trading regulatory pages as one archetype.
3. Refactor margin and bot analytics pages as one archetype.
4. Keep chart/futures/tool pages under manual fullscreen QA.

### Predictions

`predictions` has 19 screens, all with visual-density review priority.

Root causes:

- event detail and tournament pages are extremely gap-heavy,
- portfolio/advanced chart screens combine bottom inset pressure with manual
  content and fixed-height modules,
- shared components exist, but first-viewport information density is not
  budgeted.

Recommended approach:

1. Compact event detail first.
2. Compact tournament list/detail as one archetype.
3. Compact portfolio cards and keep Prediction Markets copy separate from Arena.

### Profile

`profile` has 14 screens, with 9 P0 and 5 P1.

Root causes:

- account root page reproduces the first-viewport issue on emulator,
- security/API/settings flows have bottom inset and gap pressure,
- almost every screen is an official audit blind spot.

Recommended approach:

1. Fix `ProfilePage` as the reference account pattern.
2. Apply the same compact row/card density to settings, security, API, VIP,
   activity, and notification pages.
3. Add viewport assertions so product/menu rows appear earlier above bottom nav.

### Markets

`markets` has 22 screens, with 10 P0 and 3 P1.

Root causes:

- overview and social signal pages have very high fixed-height and gap counts,
- detail/analytics pages use tall chart/metric modules,
- only `MarketListPage` is currently pass/monitor.

Recommended approach:

1. Keep `MarketListPage` as a compact reference.
2. Refactor overview, signals, screener, and alerts into compact market modules.
3. Treat analytics/chart pages separately from standard list pages.

### Wallet

`wallet` has 21 screens, with 5 P0 and 9 P1.

Root causes:

- health/gas/security pages combine manual content with gap and bottom-inset
  pressure,
- financial safety flows need compactness without hiding fees, limits, risk, or
  next steps,
- several wallet screens are compliant structurally but sparse visually.

Recommended approach:

1. Compact health score and gas optimizer first.
2. Preserve confirmation, masking, and fee/risk copy.
3. Add viewport checks for bottom CTA and first financial summary block.

### Arena

`arena` has 26 screens, with 6 P0 and 5 P1.

Root causes:

- `MyArenaPage` appears through both Arena and Profile routes and has high
  fixed-height pressure,
- production/foundation/ecosystem pages use tall informational surfaces,
- challenge/detail pages have medium density risk.

Recommended approach:

1. Compact `MyArenaPage` once and verify both routes.
2. Keep Arena points-only language.
3. Reuse compact challenge/detail section primitives.

### P2P

`p2p` has 77 screens. It is broad but less severe on average than trade/profile:
4 P0, 6 P1, 1 tool, 30 P2, 36 P3.

Root causes:

- many flows have bottom inset pressure,
- a few chat/order/dispute/payment screens still need visual QA,
- much of the module is already closer to compact standards than trade.

Recommended approach:

1. Prioritize the 4 P0 routes from the CSV.
2. Keep escrow/payment safety confirmations explicit.
3. Batch P2/P3 screens only after the shared compact primitives are stable.

### Earn

`earn` has 70 screens. Most are P3, with 1 P0 and 7 P1.

Root causes:

- broad guide/dashboard surfaces use repeated sections,
- savings ladder is the main P0,
- the module has many low-signal screens that should be monitored rather than
  rewritten immediately.

Recommended approach:

1. Fix savings ladder first.
2. Then compact the 7 P1 pages.
3. Leave P3 pages until touched unless emulator QA shows obvious looseness.

### Launchpad

`launchpad` has 24 screens, mostly P2 with 1 P0 and 3 P1.

Root causes:

- claim/rebalance/swap/receipt flows need both financial safety and compactness,
- medium-risk screens should be handled by shared financial flow templates.

Recommended approach:

1. Identify the P0 route in the CSV and refactor it first.
2. Use compact financial summary, risk, and next-step sections.
3. Preserve confirmation and receipt clarity.

### DCA

`dca` has 14 screens: 3 P0, 1 P1, 4 P2, 2 P3, and 4 pass/monitor.

Root causes:

- DCA root page has high fixed-height and root chrome cost,
- backtester and some analytics screens are already low risk.

Recommended approach:

1. Compact `DCAPage` first.
2. Keep passing DCA screens as reference examples.

### Lower-Risk Modules

These modules are lower risk or smaller:

- `auth`: mostly compact; `LoginPage` and `ForgotPasswordPage` are pass/monitor.
- `admin`: low to medium review only.
- `dev`: mostly monitor.
- `onboarding`: pass/monitor.
- `cross_module`, `discovery`, `notifications`, `support`, `referral`,
  `rewards`, `enterprise_states`: included in the matrix; handle when their
  priority appears in the CSV.

## 9. Pass / Monitor Screens

Only 11 screens currently fall into `PASS_MONITOR`:

| Feature | Page | Route | Risk |
| --- | --- | --- | ---: |
| auth | `ForgotPasswordPage` | `AppRoutePaths.authForgotPassword` | 7 |
| auth | `LoginPage` | `AppRoutePaths.authLogin` | 6 |
| cross_module | `UnifiedPortfolioDashboard` | `AppRoutePaths.unifiedPortfolio` | 9 |
| dca | `DCABacktesterPage` | `AppRoutePaths.dcaBacktester` | 6 |
| dca | `DCARebalanceDashboard` | `AppRoutePaths.dcaRebalanceDashboard` | 1 |
| dca | `DCARebalanceDashboard` | `'/dca/rebalance/:configId/history'` | 1 |
| dca | `DCAScheduleAnalytics` | `AppRoutePaths.dcaScheduleAnalytics` | 1 |
| dev | `RouteChecker` | `AppRoutePaths.routeChecker` | 9 |
| markets | `MarketListPage` | `AppRoutePaths.markets` | 8 |
| onboarding | `OnboardingFlow` | `AppRoutePaths.onboarding` | 9 |
| referral | `ReferralFriendDetailPage` | `'/referral/friend/:friendId'` | 4 |

These should not be rewritten just because the whole app is being audited.
Use them as reference screens when they visually match the Home standard.

## 10. Execution Plan

### Phase 1: Turn the blind spot into a gate

1. Convert this supplemental scan into a maintained Dart audit tool.
2. Add CSV and Markdown outputs under the existing Flutter audit docs.
3. Add a `--check` mode with thresholds for first-viewport density.
4. Add route-level exceptions only for true fullscreen tools.

### Phase 2: Build compact shared patterns

1. Add compact density semantics to shared surfaces.
2. Define compact/default/hero budgets for cards and section gaps.
3. Add a first-viewport budget helper for root module pages.
4. Keep financial safety content visible; compact layout, not safety copy.

### Phase 3: Refactor by archetype, not by random screen

Recommended order:

1. `profile`: `ProfilePage` first, then settings/security/API/VIP.
2. `trade`: copy-trading compliance/report pages, then bot/margin analytics.
3. `markets`: overview/signals/screener/alerts.
4. `predictions`: event detail, tournament pages, portfolio/chart.
5. `wallet`: health score, gas optimizer, security/financial surfaces.
6. `arena`: `MyArenaPage`, production/foundation/ecosystem surfaces.
7. `p2p`, `earn`, `launchpad`, `dca`: P0/P1 routes from the matrix.

### Phase 4: Verify with emulator and widget viewport assertions

For each reference archetype, assert:

- the first repeated/actionable section is visible above bottom nav,
- no primary content row is mostly hidden by bottom chrome,
- at least two meaningful sections are visible or clearly previewed in the first
  viewport for root pages,
- high-risk financial flows still show fees, risk, limits, and next steps.

## 11. Final Diagnosis

The project is not failing because screens ignored shared components.

The project is failing the user's visual expectation because shared-component
adoption and token adoption were treated as completion, while viewport density
was not measured.

To reach Flutter Enterprise-Grade UI consistency, completion must now mean:

1. shared-component compliance,
2. token compliance,
3. product and financial-safety compliance,
4. responsive render safety,
5. and first-viewport density compliance.

The fifth item is the missing piece.
