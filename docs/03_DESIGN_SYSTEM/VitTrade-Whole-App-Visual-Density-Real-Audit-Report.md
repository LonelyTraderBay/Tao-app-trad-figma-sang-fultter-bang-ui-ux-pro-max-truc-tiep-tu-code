# VitTrade Whole-App Visual Density Real Audit Report

**Date:** 2026-06-19  
**Scope:** 414 routed Flutter screens  
**Purpose:** Explain why many screens can pass shared-component audits while
still feeling too wide, sparse, or not fully optimized for phone screens.

## 1. Executive Summary

The current UI migration is strong on **shared-component compliance** but still
incomplete on **real phone visual density**.

The official audits show that the app is structurally healthy:

| Gate | Result |
| --- | --- |
| Route coverage | current |
| Design token consistency | `total_debt=0` |
| Body component consistency | `409 A`, `5 Tool`, `0 B/C/D` |
| Header visual archetype strict audit | `strict_visual_issues=0` |
| Density audit official blockers | `P1_density_refactor=0`, `P2_visual_density_review=0` |

However, the user-observed issue is real. The audit suite currently verifies
that screens use shared primitives and tokenized values. It does **not** fully
measure whether a screen uses too much vertical space in the first viewport.

In practical terms:

- Many screens are technically compliant.
- Many screens still have generous `AppSpacing.*Height`, `Spacer()`,
  `customGap`, `VitContentPadding.relaxed`, or manual `SizedBox` section gaps.
- These values are tokenized, so they are not design-token debt, but they can
  still produce sparse layouts on a 360-448dp phone viewport.

The clearest confirmed example is `ProfilePage` / `/profile`. It passes the
official audit as `A`, but the emulator screenshot shows that the first viewport
is dominated by a tall hero, VIP card, and two large product cards. The
important account/product menu begins under the bottom navigation.

Screenshot evidence:

```text
flutter_app/run-artifacts/emulator-ui/vittrade_profile_density.png
Device: emulator-5554
Physical size: 1344x2992
Physical density: 480
Logical viewport: about 448x997dp
Route observed: /profile
```

## 2. Methodology

This report uses four evidence layers.

1. Official whole-app audit commands:

```bash
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/body_component_consistency_audit.dart --check
dart run tool/ui_fullscreen_density_audit.dart --check
```

2. Existing generated CSVs:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-UI-Fullscreen-Density-Audit.csv
```

3. Emulator visual evidence:

```text
flutter_app/run-artifacts/emulator-ui/vittrade_profile_density.png
```

4. Additional source scan performed for this report:

```text
Signals scanned per route source_files:
- height: AppSpacing.*Height
- SizedBox(height: AppSpacing.*Gap/Inset/Top/Bottom/Footer/Spacing)
- Spacer()
- customGap
- VitContentPadding.relaxed
- VitContentGap.relaxed / VitContentGap.loose
```

This extra scan is not an official blocker yet. It is a practical visual-risk
lens that explains sparse screens better than the current static audit.

## 3. Official Audit Snapshot

### 3.1 Body Component Consistency

| Metric | Count |
| --- | ---: |
| Total routed screens | 414 |
| Grade A | 409 |
| Grade Tool | 5 |
| Grade B/C/D | 0 |
| P0 issues | 0 |
| P1 issues | 0 |
| P2 issues | 1 |
| P3 follow-up/pass | 413 |

Interpretation:

- The app has completed the main shared-component migration.
- Body structure is not the current source of the visual-density complaint.
- The remaining concern is screen composition, vertical rhythm, and phone
  viewport use.

### 3.2 Official Density Score Distribution

| Score | Screens |
| ---: | ---: |
| 14 | 1 |
| 13 | 3 |
| 12 | 1 |
| 7 | 4 |
| 6 | 18 |
| 5 | 42 |
| 4 | 40 |
| 3 | 7 |
| 2 | 10 |
| 1 | 60 |
| 0 | 228 |

Derived buckets:

| Bucket | Screens | Meaning |
| --- | ---: | --- |
| Tool/manual QA | 5 | Fullscreen/workbench surfaces, not normal content pages |
| Score >= 6, non-tool | 22 | Strong static density signal despite Grade A |
| Score 4-5, non-tool | 82 | Needs visual-density review |
| Score 2-3, non-tool | 17 | Usually looks acceptable in CSV, but may still fail visually |
| Score 0-1, non-tool | 288 | Low static signal |

Important note: `ProfilePage` is in the score `2-3` group, which explains why
the current audit does not flag it strongly even though the emulator screenshot
does.

## 4. Feature-Level Findings

### 4.1 Official Density Risk By Feature

| Feature | Screens | Avg score | Max score | Score >= 6 | Score >= 5 | Score >= 4 | Tool |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| p2p | 77 | 1.78 | 14 | 9 | 13 | 22 | 1 |
| predictions | 19 | 4.68 | 6 | 4 | 17 | 17 | 0 |
| earn | 70 | 1.14 | 4 | 0 | 0 | 16 | 0 |
| markets | 22 | 3.73 | 6 | 1 | 15 | 15 | 0 |
| trade | 91 | 1.02 | 13 | 4 | 5 | 7 | 3 |
| launchpad | 24 | 1.46 | 7 | 1 | 4 | 6 | 0 |
| dca | 14 | 1.71 | 5 | 0 | 4 | 5 | 0 |
| wallet | 21 | 1.33 | 5 | 0 | 1 | 5 | 0 |
| profile | 14 | 1.07 | 5 | 0 | 1 | 1 | 0 |

Official density suggests the biggest broad review groups are:

1. `p2p`
2. `predictions`
3. `markets`
4. `earn`
5. `trade`

But this is incomplete because tokenized fixed-height patterns are not heavily
weighted by the official density audit.

### 4.2 Tokenized Visual-Risk Scan By Feature

This scan explains the user's complaint more clearly.

| Feature | Screens | Avg visual risk | Max visual risk | Score >= 60 | Score >= 40 | Score >= 25 | Height refs | Gap refs | Spacer refs | Manual content refs |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| trade | 91 | 37.42 | 117 | 13 | 35 | 58 | 855 | 773 | 62 | 235 |
| predictions | 19 | 31.32 | 68 | 1 | 3 | 14 | 84 | 180 | 13 | 44 |
| markets | 22 | 30.77 | 110 | 2 | 4 | 11 | 162 | 167 | 7 | 30 |
| profile | 14 | 29.71 | 55 | 0 | 2 | 10 | 78 | 167 | 15 | 16 |
| arena | 26 | 23.92 | 66 | 3 | 5 | 7 | 237 | 3 | 3 | 39 |
| wallet | 21 | 20.81 | 49 | 0 | 2 | 6 | 58 | 154 | 8 | 41 |
| p2p | 77 | 11.44 | 34 | 0 | 0 | 6 | 197 | 18 | 10 | 104 |
| dca | 14 | 16.14 | 59 | 0 | 1 | 3 | 65 | 0 | 9 | 18 |
| earn | 70 | 9.19 | 48 | 0 | 1 | 3 | 236 | 0 | 23 | 15 |
| news | 1 | 50.00 | 50 | 0 | 1 | 1 | 14 | 7 | 0 | 3 |

Interpretation:

- `trade` is the largest hidden visual-density risk. Many trade/regulatory/bot
  pages have low official density scores but many tokenized fixed heights and
  manual layout controls.
- `profile` is a real problem area despite low official density. It has 10 of
  14 routes with tokenized visual risk >= 25.
- `predictions` and `markets` are broad review areas because many routes still
  use relaxed padding or detail-style spacing.
- `wallet` has fewer routes, but several still use bottom insets and gap-heavy
  composition.
- `p2p` has many official density signals, but tokenized visual risk is lower
  than trade/profile because much of the module has already been compacted.

## 5. Top Official Density Routes

These are the highest official density-score routes. Some are intentional Tool
surfaces, but the non-tool routes should be visually reviewed.

| Priority | Feature | Route | Page | Grade | Score | Reason |
| --- | --- | --- | --- | --- | ---: | --- |
| Tool QA | p2p | `/p2p/chat/:orderId` | `P2PChatPage` | Tool | 14 | body Tool; few dense sections/cards=0 |
| Tool QA | trade | `AppRoutePaths.tradeBots` | `TradingBotsPage` | Tool | 13 | body Tool |
| Tool QA | trade | `/trade/:pairId/futures` | `FuturesPage` | Tool | 13 | body Tool |
| Tool QA | trade | `/trade/advanced-chart/:pairId` | `AdvancedChartPage` | Tool | 13 | body Tool |
| Tool QA | enterprise_states | `AppRoutePaths.enterpriseStates` | `EnterpriseStatesPage` | Tool | 12 | body Tool |
| P1 visual review | trade | `AppRoutePaths.tradeBotSuitabilityAssessment` | `BotSuitabilityAssessmentPage` | A | 7 | custom>15 by 7 |
| P1 visual review | trade | `AppRoutePaths.tradeCopyProviderApply` | `ProviderApplicationPage` | A | 7 | custom>17 by 7 |
| P1 visual review | launchpad | `AppRoutePaths.launchpadGasTracker` | `LaunchpadGasTrackerPage` | A | 7 | custom>19 by 6 |
| P1 visual review | p2p | `/p2p/order/cancel/:orderId` | `P2POrderCancelPage` | A | 7 | relaxedPadding=1 |
| P1 visual review | p2p | `AppRoutePaths.p2pWallet` | `P2PWalletPage` | A | 6 | few dense sections/cards=2 |
| P1 visual review | predictions | `AppRoutePaths.marketsPredictionsDataIntegration` | `PredictionDataIntegrationPage` | A | 6 | relaxedPadding=1 |
| P1 visual review | p2p | `AppRoutePaths.p2pTaxReporting` | `P2PTaxReportingPage` | A | 6 | custom>14 by 4 |
| P1 visual review | predictions | `/markets/predictions/event/:eventId` | `PredictionEventDetailPage` | A | 6 | relaxedPadding=1 |
| P1 visual review | trade | `AppRoutePaths.tradeBotRiskDashboard` | `BotRiskDashboardPage` | A | 6 | custom>27 by 6 |
| P1 visual review | trade | `AppRoutePaths.demoCopyCard` | `CopyTradingCardDemo` | A | 6 | looseGap=1 |
| P1 visual review | predictions | `AppRoutePaths.marketsPredictionsBreaking` | `PredictionsBreakingPage` | A | 6 | relaxedPadding=1 |
| P1 visual review | predictions | `AppRoutePaths.marketsPredictionsActivity` | `PredictionsGlobalActivityPage` | A | 6 | relaxedPadding=1 |
| P1 visual review | markets | `AppRoutePaths.marketsSignals` | `SocialSignalsPage` | A | 6 | relaxedPadding=1 |
| P1 visual review | news | `AppRoutePaths.news` | `NewsPage` | A | 6 | few dense sections/cards=2 |
| P1 visual review | cross_module | `AppRoutePaths.taxReports` | `TaxReportCenter` | A | 6 | custom>22 by 6 |
| P1 visual review | p2p | `/p2p/ad-analytics/:adId` | `P2PAdAnalyticsPage` | A | 6 | custom>20 by 5 |
| P1 visual review | p2p | `AppRoutePaths.p2pLimitsTracker` | `P2PLimitTrackerPage` | A | 6 | custom>9 by 1; few dense sections/cards=2 |
| P1 visual review | p2p | `/p2p/order/rate/:orderId` | `P2POrderRatePage` | A | 6 | relaxedPadding=1 |

## 6. Top Hidden Visual-Risk Routes

These routes may pass the official audit but still deserve visual-density
review because they contain many tokenized fixed heights, manual gaps, spacers,
or relaxed/custom content controls.

| Priority | Feature | Route | Page | Official score | Visual-risk score | Signals |
| --- | --- | --- | --- | ---: | ---: | --- |
| P0 | trade | `AppRoutePaths.tradeCopyClientOptUpRequest` | `ClientOptUpRequestPage` | 0 | 117 | 26 height refs, 3 gap refs, 1 spacer, 20 manual content refs |
| P0 | trade | `AppRoutePaths.tradeCopyClientCategorization` | `ClientCategorizationPage` | 0 | 117 | 26 height refs, 3 gap refs, 1 spacer, 20 manual content refs |
| P0 | markets | `AppRoutePaths.marketsSignals` | `SocialSignalsPage` | 6 | 110 | 41 height refs, 14 gap refs, 1 spacer, 2 manual content refs |
| P0 | markets | `AppRoutePaths.marketsOverview` | `MarketOverviewPage` | 5 | 106 | 38 height refs, 16 gap refs, 3 spacers, 1 manual content ref |
| P0 | trade | `AppRoutePaths.tradeMarginAdvancedAnalytics` | `AdvancedAnalyticsPage` | 1 | 100 | 28 height refs, 13 gap refs, 10 manual content refs |
| P0 | trade | `AppRoutePaths.tradeMarginMarketDataAnalytics` | `MarketDataAnalyticsPage` | 1 | 95 | 24 height refs, 1 gap ref, 15 manual content refs |
| P0 | trade | `AppRoutePaths.tradeBotSecuritySettings` | `BotSecuritySettingsPage` | 1 | 88 | 19 height refs, 13 gap refs, 12 manual content refs |
| P0 | trade | `AppRoutePaths.tradeCopyRegulatoryReportsDashboard` | `RegulatoryReportsDashboardPage` | 0 | 80 | 17 height refs, 5 gap refs, 1 spacer, 13 manual content refs |
| P0 | trade | `/trade/trader/:traderId` | `TraderProfilePage` | 0 | 77 | 27 height refs, 9 gap refs, 4 spacers, 2 manual content refs |
| P0 | trade | `AppRoutePaths.tradeCopyClientMoneyProtection` | `ClientMoneyProtectionPage` | 0 | 73 | 21 height refs, 11 gap refs, 1 spacer, 6 manual content refs |
| P0 | trade | `AppRoutePaths.tradeCopyDisputeResolution` | `DisputeResolutionPage` | 0 | 71 | 24 height refs, 8 gap refs, 5 manual content refs |
| P0 | trade | `AppRoutePaths.tradeCopyActive` | `ActiveCopiesPage` | 0 | 70 | 25 height refs, 9 gap refs, 4 spacers, 1 manual content ref |
| P0 | trade | `AppRoutePaths.tradeBotTaxReporting` | `BotTaxReportingPage` | 0 | 69 | 20 height refs, 23 gap refs, 2 manual content refs |
| P0 | predictions | `/markets/predictions/event/:eventId` | `PredictionEventDetailPage` | 6 | 68 | 9 height refs, 36 gap refs, 1 spacer, 2 manual content refs |
| P0 | trade | `AppRoutePaths.tradeCopyInvestorCompensation` | `InvestorCompensationPage` | 0 | 68 | 20 height refs, 20 gap refs, 1 spacer, 2 manual content refs |
| P0 | arena | `AppRoutePaths.arenaMy` | `MyArenaPage` | 0 | 66 | 27 height refs, 4 manual content refs |
| P0 | arena | `AppRoutePaths.profileArena` | `MyArenaPage` | 0 | 66 | 27 height refs, 4 manual content refs |
| P1 | profile | `AppRoutePaths.profile` | `ProfilePage` | 3 | visual evidence confirmed | Tall hero, VIP block, two large module cards, bottom-nav overlap |

## 7. Profile / Account Deep Dive

`ProfilePage` is the best example of why the current audit is not enough.

Official row:

```text
feature=profile
route=AppRoutePaths.profile
page=ProfilePage
body_grade=A
density_score=3
density_priority=Pass_or_low_signal
density_reason=custom>17 by 2
shared_component_count=17
custom_body_count=19
vit_card_count=8
```

But actual emulator evidence shows the first viewport is not dense enough.

Root causes in code:

| Source | Problem |
| --- | --- |
| `profile_page.dart` | `VitPageContent(padding: none, customGap: 0, fullBleed: true)` bypasses shared vertical rhythm and relies on manual `SizedBox` gaps. |
| `app_spacing.dart` | Profile tokens are generous: `profileHeroHeight=216`, `profileHeroToVipGap=24`, `profileVipToSectionGap=26`, `profileSectionGap=25`, `profileActivityGap=28`, `profileFooterGap=38`. |
| `profile_home_hero.dart` | Hero uses fixed height plus `Spacer()`, creating blank vertical air between identity and UID/referral boxes. |
| `profile_home_vip_prediction.dart` | Prediction card is fixed at `profileModuleCardHeight=137` and uses `Spacer()` for internal distribution. |
| `profile_home_arena_stats.dart` | Arena card repeats the same large fixed-card pattern. |
| `profile_home_menu_actions.dart` | Product tiles and menu rows are acceptable, but they arrive too late because upper blocks consume the viewport. |

Practical effect:

- The first viewport shows `Tài khoản`, hero, VIP progress, Prediction card,
  Arena card, and only the beginning of `Sản phẩm & Hỗ trợ`.
- Bottom navigation covers the product grid area.
- The actual account-management actions are pushed down, even though this is
  a root profile/account screen.

Recommended compact direction:

| Item | Current | Target |
| --- | ---: | ---: |
| Profile hero | 216dp | 156-176dp |
| VIP card | 92dp | 56-72dp or merge into hero |
| Prediction/Arena cards | 137dp each | 92-108dp each |
| Root section gaps | 24-28dp | 12-16dp |
| Product tiles | 74dp | 60-64dp |
| Menu rows | 62dp | 52-56dp |
| Fixed card + `Spacer()` | common | avoid; use fixed row groups/gaps |

## 8. Root Causes Across The App

### 8.1 Compliance And Density Are Different Problems

The migration successfully removed raw debt and moved screens onto shared
primitives. That does not automatically make each screen visually compact.

Example:

```dart
height: AppSpacing.profileHeroHeight
```

This is token-compliant, but it can still be too tall for a phone viewport.

### 8.2 Tokenized Fixed Heights Escaped The Old Debt Model

The design-token audit treats tokenized size usage as good. That is correct for
consistency, but some token values are still too large for dense phone layouts.

Patterns to review:

- `height: AppSpacing.*HeroHeight`
- `height: AppSpacing.*CardHeight`
- `height: AppSpacing.*ChartHeight`
- `height: AppSpacing.*SummaryHeight`
- `height: AppSpacing.*RowHeight`
- `height: AppSpacing.*TileHeight`

### 8.3 Manual Gap Stacks Still Exist

Many pages use shared wrappers but then manually insert section rhythm:

```dart
const SizedBox(height: AppSpacing.someSectionGap)
const SizedBox(height: AppSpacing.someFooterGap)
```

This is not wrong by itself. The problem is that many feature-local gap tokens
are larger than the Home-standard 8-16dp rhythm.

### 8.4 `Spacer()` Inside Fixed Cards Creates Invisible Waste

`Spacer()` is useful in flexible layouts, but inside a fixed-height card it
often creates empty bands. This is visible on Profile hero and profile module
cards.

### 8.5 Bottom Navigation Requires First-Viewport Awareness

Root tab pages should assume bottom nav overlap. A screen can technically have
bottom padding and still feel wrong if the next important section starts under
the nav.

### 8.6 Tool Surfaces Need Separate Rules

The 5 Tool routes should not be forced into normal `VitPageContent` density:

- `EnterpriseStatesPage`
- `P2PChatPage`
- `AdvancedChartPage`
- `FuturesPage`
- `TradingBotsPage`

They need manual screenshot QA and workbench-specific density rules.

## 9. Recommended Priority Plan

### P0 - Add A Real Visual-Density Guardrail

Goal: make future audit catch the Profile-style issue before manual review.

Acceptance criteria:

- Add a route-level report for tokenized visual-risk signals:
  `AppSpacing.*Height`, `Spacer()`, manual gap stacks, relaxed/loose padding,
  and bottom-nav first viewport risk.
- Flag non-tool root/detail screens when visual risk exceeds threshold.
- Keep Tool routes separately classified.

Suggested thresholds:

| Signal | Suggested threshold |
| --- | ---: |
| `height: AppSpacing.*Height` per route bundle | > 15 review |
| `Spacer()` inside fixed-height card bundle | > 0 review |
| `customGap` plus manual `SizedBox` stack | review |
| root tab page first viewport | hero + two sections must fit before bottom nav |
| detail page first viewport | title/context + primary form/list section must fit |

### P1 - Profile / Account Compact Pass

Routes:

- `AppRoutePaths.profile`
- `AppRoutePaths.profileVip`
- `AppRoutePaths.profileKyc`
- `AppRoutePaths.profileSecurity`
- `AppRoutePaths.profileSettings`
- `AppRoutePaths.profileDevices`
- `AppRoutePaths.profileSubAccounts`
- `AppRoutePaths.profileActivity`
- `AppRoutePaths.profileApi`
- `AppRoutePaths.profileApiCreate`

Primary fixes:

- Compact root hero and VIP progress.
- Convert Prediction/Arena blocks to dense account shortcut cards.
- Replace manual gap stack with `VitPageSection`/Home-standard rhythm.
- Keep account/security copy safe and masked.

Verification:

- `flutter test test/features/profile --reporter=compact`
- `flutter analyze`
- Android emulator screenshot for `/profile`

### P2 - Trade Hidden Visual-Risk Pass

Highest-risk routes from tokenized scan:

- `ClientOptUpRequestPage`
- `ClientCategorizationPage`
- `AdvancedAnalyticsPage`
- `MarketDataAnalyticsPage`
- `BotSecuritySettingsPage`
- `RegulatoryReportsDashboardPage`
- `TraderProfilePage`
- `ClientMoneyProtectionPage`
- `DisputeResolutionPage`
- `ActiveCopiesPage`
- `BotTaxReportingPage`

Primary fixes:

- Reduce tokenized hero/card/chart heights where content is mostly summary.
- Replace `Spacer()` distribution with explicit tight gaps.
- Collapse repeated regulatory info cards into denser rows/accordion sections
  where safe.
- Keep financial/regulatory copy complete; compact layout, not remove content.

Verification:

- focused `test/features/trade`
- financial safety guardrails
- emulator screenshots for top 3 routes

### P3 - Predictions And Markets Relaxed Padding Pass

High-signal predictions/markets routes:

- `PredictionEventDetailPage`
- `PredictionDataIntegrationPage`
- `PredictionsBreakingPage`
- `PredictionsGlobalActivityPage`
- `PredictionPortfolioAnalyzerPage`
- `PredictionOrderReceiptPage`
- `SocialSignalsPage`
- `MarketOverviewPage`
- `MarketScreenerPage`
- `MarketDepthPage`
- `TokenInfoPage`

Primary fixes:

- Replace `VitContentPadding.relaxed` with compact/default where possible.
- Use denser row/table/list sections for repeated data.
- Keep Prediction Markets wallet/positions/PnL language separate from Arena.

Verification:

- focused predictions/markets tests
- product-copy guardrail
- emulator screenshot for one detail route and one root/list route

### P4 - Wallet, DCA, Earn, Launchpad, P2P Follow-Up

Reason:

- These areas have fewer top hidden-risk routes than trade/profile, but still
  contain score 4-6 official density signals or visual-risk score >= 25.

Targets:

- `P2PWalletPage`
- `P2POrderCancelPage`
- `P2PTaxReportingPage`
- `P2PAdAnalyticsPage`
- `DCAPage`
- `DCARebalanceConfig`
- high-score Earn routes from route-level token scan
- `LaunchpadGasTrackerPage`

Primary fixes:

- Reduce relaxed padding in transaction/detail flows only where it does not
  weaken confirmation or risk copy.
- Keep money movement and high-risk confirmations explicit.
- Use dense account/summary rows before long explanatory panels.

### P5 - Tool Surfaces Manual QA

Keep these as accepted exceptions but require real screenshots:

- `EnterpriseStatesPage`
- `P2PChatPage`
- `AdvancedChartPage`
- `FuturesPage`
- `TradingBotsPage`

Acceptance criteria:

- Each route has a current emulator screenshot.
- No important control is hidden behind bottom navigation or safe area.
- Workbench UI uses available width/height intentionally.

## 10. Screen-Level Acceptance Standard

Use this standard for the next UI completion pass.

### Root Tab Screens

The first phone viewport should show:

- top header,
- primary account/product context,
- at least two actionable sections or one actionable section plus the start of
  the next section,
- no important content hidden behind bottom nav.

### Detail/Transaction Screens

The first phone viewport should show:

- route title/context,
- primary status or risk summary,
- first actionable form/list group,
- no oversized empty hero unless the hero contains critical information.

### Dense List/Market Screens

The first phone viewport should show:

- filters/search if applicable,
- at least 4-6 list rows or 2-3 rich data cards,
- visible reset/empty/error affordance when applicable.

### Tool Screens

The first viewport should show:

- the main workbench/tool area,
- primary controls,
- no accidental dead space unless it is reserved for a chart/canvas/editor.

## 11. Recommended Audit Enhancement

Create a new generated artifact:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.csv
docs/02_FLUTTER_MIGRATION/VitTrade-Visual-Density-Risk-Audit.md
flutter_app/tool/visual_density_risk_audit.dart
```

Suggested columns:

```text
feature
route
page
screen_level
archetype
body_grade
official_density_score
visual_risk_score
token_height_refs
token_gap_refs
spacer_refs
manual_content_refs
bottom_nav_sensitive
recommended_priority
recommended_action
source_files
```

This would prevent the Profile issue from being invisible after the existing
audits pass.

## 12. Final Assessment

The user's concern is valid.

Current state:

- The app is enterprise-grade in shared-component/token/header compliance.
- The app is **not yet uniformly enterprise-grade in phone visual density**.
- The remaining work is not a full redesign. It is a focused density pass:
  compact oversized tokenized layouts, remove `Spacer()` waste, reduce manual
  gap stacks, and validate first viewport behavior on emulator.

Highest practical priorities:

1. Add visual-density risk audit so the problem becomes measurable.
2. Compact Profile/Account first because the issue is already visually
   confirmed on emulator.
3. Compact hidden high-risk Trade pages because the tokenized scan shows the
   largest structural density risk.
4. Review Predictions/Markets relaxed-padding routes.
5. Keep Tool routes as intentional exceptions with screenshot QA.

