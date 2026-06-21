# VitTrade Trade UI Redesign Enterprise Execution Plan

Updated: 2026-06-22  
Status: Planning approved by user; implementation not started in this document.  
Scope: Redesign the Trade hub and all related `/trade` route surfaces for easier use, stronger consistency, and Flutter enterprise-grade UI quality.

## 1. Objective

Redesign the full Trade experience as a coherent financial command center instead of many visually independent pages. The goal is to make the Trade module easier to scan, safer to use, and visually consistent across root Trade, pair trading, orders, convert, futures, margin, trading bots, copy trading, and regulatory/compliance subpages.

Success means:

- Every Trade-related route keeps the same global VitTrade foundation: dark baseline, shared page shell, shared surfaces, shared typography, shared spacing, and shared bottom chrome.
- Trade-specific identity is an accent layer only: buy/sell colors, warning states, chart markers, risk disclosures, badges, and focused action states.
- User-facing pages in the Trade route group are covered by the redesign plan; no `/trade` route is skipped.
- High-risk flows show preview, fees, limits, risk, and next steps before confirmation.
- The final implementation passes Flutter analysis, tests, design-token audits, density audits, route audits, and emulator visual QA.

## 2. Authoritative Inputs

Follow this precedence order while implementing:

1. Current user instruction in the active thread.
2. `AGENTS.md`.
3. `docs/00_START_HERE.md`.
4. Flutter source under `flutter_app/lib/`.
5. Flutter tests under `flutter_app/test/`.
6. `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
7. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`.
8. `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`.
9. `docs/03_DESIGN_SYSTEM/Guidelines.md`.
10. Existing screen-specific references if they are current Flutter guidance.

Important constraints:

- App source of truth: `flutter_app/`.
- Router source: `flutter_app/lib/app/router/app_router.dart` and `flutter_app/lib/app/router/route_groups/trade_routes.dart`.
- Trade feature source: `flutter_app/lib/features/trade/`.
- Shared UI source: `flutter_app/lib/shared/`.
- Theme tokens: `flutter_app/lib/app/theme/`.
- Tests: `flutter_app/test/`.
- Generated artifacts: `flutter_app/run-artifacts/`.
- Do not recreate retired React, Vite, web screenshots, or root npm tooling.

## 3. Current Trade Route Scope

Current router inventory from `flutter_app/lib/app/router/route_groups/trade_routes.dart`:

| Metric | Count |
| --- | ---: |
| Trade `GoRoute` entries | 91 |
| Builder routes | 90 |
| Redirect routes | 1 |
| Direct navigation targets from main `TradePage` | 16 |

Route-group coverage target:

| Group | Routes | Redesign intent |
| --- | ---: | --- |
| Core Trade | 10 | Main trading command center, order lifecycle, settings, export, position visibility |
| Futures | 2 | Leverage-aware pair trading with strong risk framing |
| Margin and market data | 7 | Margin hub, pair margin, trader profile, analytics, advanced data |
| Trading Bots | 19 | Bot hub, automation safety, risk dashboards, backtesting, documentation |
| Risk and execution tools | 3 | Risk management, execution quality, advanced tool surfaces |
| Copy Trading and compliance | 50 | Copy hub, provider journeys, active copies, reports, safety, regulatory pages |

Main `TradePage` direct navigation targets:

1. `AppRoutePaths.tradePair(pair.id)`
2. `AppRoutePaths.tradeOrderReceipt`
3. `AppRoutePaths.tradeConvert`
4. `AppRoutePaths.tradeFutures(pair.id)`
5. `AppRoutePaths.tradeMargin`
6. `AppRoutePaths.tradeBots`
7. `AppRoutePaths.tradeCopyTrading`
8. `AppRoutePaths.dca`
9. `AppRoutePaths.wallet`
10. `AppRoutePaths.p2p`
11. `AppRoutePaths.earnStaking`
12. `AppRoutePaths.launchpad`
13. `AppRoutePaths.marketsPredictions`
14. `AppRoutePaths.arena`
15. `AppRoutePaths.rewards`
16. `AppRoutePaths.support`

`AppRoutePaths.trade` is a fallback/back target and should not be counted as a new user-facing target.

## 4. Complete `/trade` Route Coverage Manifest

Implementation must track all rows below. A route can be marked complete only when its page follows the Trade UI contract, preserves product safety, has focused tests updated if needed, and passes the relevant audits.

| # | Group | Path expression | Route name | Page |
| ---: | --- | --- | --- | --- |
| 1 | Core Trade | `'/trade/advanced-chart/:pairId'` | `AppRouteNames.sc055AdvancedChart` | `AdvancedChartPage` |
| 2 | Core Trade | `AppRoutePaths.trade` | `AppRouteNames.sc048Trade` | `TradePage` |
| 3 | Core Trade | `AppRoutePaths.tradeConvert` | `AppRouteNames.sc056Convert` | `ConvertPage` |
| 4 | Trading Bots | `AppRoutePaths.tradeBots` | `AppRouteNames.sc059TradingBots` | `TradingBotsPage` |
| 5 | Trading Bots | `AppRoutePaths.tradeBotTermsOfService` | `AppRouteNames.sc117BotTermsOfService` | `BotTermsOfServicePage` |
| 6 | Trading Bots | `AppRoutePaths.tradeBotRiskDisclosure` | `AppRouteNames.sc118BotRiskDisclosure` | `BotRiskDisclosurePage` |
| 7 | Trading Bots | `AppRoutePaths.tradeBotSuitabilityAssessment` | `AppRouteNames.sc119BotSuitabilityAssessment` | `BotSuitabilityAssessmentPage` |
| 8 | Trading Bots | `AppRoutePaths.tradeBotRiskDashboard` | `AppRouteNames.sc120BotRiskDashboard` | `BotRiskDashboardPage` |
| 9 | Trading Bots | `AppRoutePaths.tradeBotEmergencyStop` | `AppRouteNames.sc121BotEmergencyStop` | `BotEmergencyStopPage` |
| 10 | Trading Bots | `AppRoutePaths.tradeBotSecuritySettings` | `AppRouteNames.sc122BotSecuritySettings` | `BotSecuritySettingsPage` |
| 11 | Trading Bots | `AppRoutePaths.tradeBotHistory` | `AppRouteNames.sc123BotHistory` | `BotHistoryPage` |
| 12 | Trading Bots | `AppRoutePaths.tradeBotPerformanceAnalytics` | `AppRouteNames.sc124BotPerformanceAnalytics` | `BotPerformanceAnalyticsPage` |
| 13 | Trading Bots | `AppRoutePaths.tradeBotBacktesting` | `AppRouteNames.sc125BotBacktesting` | `BotBacktestingPage` |
| 14 | Trading Bots | `AppRoutePaths.tradeBotStrategyCompare` | `AppRouteNames.sc126BotStrategyCompare` | `BotStrategyComparePage` |
| 15 | Trading Bots | `AppRoutePaths.tradeBotOptimization` | `AppRouteNames.sc127BotOptimization` | `BotOptimizationPage` |
| 16 | Trading Bots | `AppRoutePaths.tradeBotPortfolioDashboard` | `AppRouteNames.sc128BotPortfolioDashboard` | `BotPortfolioDashboardPage` |
| 17 | Trading Bots | `AppRoutePaths.tradeBotDrawdownAnalyzer` | `AppRouteNames.sc129BotDrawdownAnalyzer` | `BotDrawdownAnalyzerPage` |
| 18 | Trading Bots | `AppRoutePaths.tradeBotEquityCurve` | `AppRouteNames.sc130BotEquityCurve` | `BotEquityCurvePage` |
| 19 | Trading Bots | `AppRoutePaths.tradeBotGuide` | `AppRouteNames.sc131BotGuide` | `BotGuidePage` |
| 20 | Trading Bots | `AppRoutePaths.tradeBotFaq` | `AppRouteNames.sc132BotFaq` | `BotFaqPage` |
| 21 | Trading Bots | `AppRoutePaths.tradeBotTaxReporting` | `AppRouteNames.sc133BotTaxReporting` | `BotTaxReportingPage` |
| 22 | Trading Bots | `AppRoutePaths.tradeBotApiDocumentation` | `AppRouteNames.sc134BotApiDocumentation` | `BotApiDocumentationPage` |
| 23 | Risk and execution tools | `AppRoutePaths.tradeRiskManagement` | `AppRouteNames.sc060RiskManagement` | `RiskManagementDemoPage` |
| 24 | Risk and execution tools | `AppRoutePaths.tradeExecutionQuality` | `AppRouteNames.sc061ExecutionQuality` | `ExecutionQualityDemoPage` |
| 25 | Risk and execution tools | `AppRoutePaths.tradeAdvancedTools` | `AppRouteNames.sc062AdvancedTools` | `AdvancedToolsDemoPage` |
| 26 | Copy Trading and compliance | `AppRoutePaths.tradeCopyTrading` | `AppRouteNames.sc063CopyTrading` | `CopyTradingPage` |
| 27 | Copy Trading and compliance | `AppRoutePaths.tradeCopyTradingV2` | `AppRouteNames.sc064CopyTradingV2` | `CopyTradingV2Page` |
| 28 | Copy Trading and compliance | `AppRoutePaths.tradeCopyEducation` | `AppRouteNames.sc065CopyEducation` | `CopyEducationPage` |
| 29 | Copy Trading and compliance | `AppRoutePaths.tradeCopyActive` | `AppRouteNames.sc066ActiveCopies` | `ActiveCopiesPage` |
| 30 | Copy Trading and compliance | `AppRoutePaths.tradeCopySettings` | `AppRouteNames.sc067CopySettings` | `CopySettingsPage` |
| 31 | Copy Trading and compliance | `AppRoutePaths.tradeCopyNotifications` | `AppRouteNames.sc068CopyNotifications` | `CopyNotificationsPage` |
| 32 | Copy Trading and compliance | `AppRoutePaths.tradeCopyProviderApply` | `AppRouteNames.sc069ProviderApplication` | `ProviderApplicationPage` |
| 33 | Copy Trading and compliance | `AppRoutePaths.tradeCopyComparison` | `AppRouteNames.sc076ProviderComparison` | `ProviderComparisonPage` |
| 34 | Copy Trading and compliance | `AppRoutePaths.tradeCopyRiskAnalysis` | `AppRouteNames.sc078PortfolioRiskAnalysis` | `PortfolioRiskAnalysisPage` |
| 35 | Copy Trading and compliance | `AppRoutePaths.tradeCopyLeaderboard` | `AppRouteNames.sc079ProviderLeaderboard` | `ProviderLeaderboardPage` |
| 36 | Copy Trading and compliance | `AppRoutePaths.tradeCopySafety` | `AppRouteNames.sc080SafetyEducation` | `SafetyEducationPage` |
| 37 | Copy Trading and compliance | `AppRoutePaths.tradeCopyProviderGovernance` | `AppRouteNames.sc081ProviderGovernance` | `ProviderGovernancePage` |
| 38 | Copy Trading and compliance | `AppRoutePaths.tradeCopyDisputeResolution` | `AppRouteNames.sc082DisputeResolution` | `DisputeResolutionPage` |
| 39 | Copy Trading and compliance | `AppRoutePaths.tradeCopySafetyCenter` | `AppRouteNames.sc083CopySafetyCenter` | `CopySafetyCenterPage` |
| 40 | Copy Trading and compliance | `AppRoutePaths.tradeCopyRegulatoryDisclosures` | `AppRouteNames.sc084RegulatoryDisclosures` | `RegulatoryDisclosuresPage` |
| 41 | Copy Trading and compliance | `AppRoutePaths.tradeCopyTransactionReporting` | `AppRouteNames.sc093TransactionReporting` | `TransactionReportingPage` |
| 42 | Copy Trading and compliance | `AppRoutePaths.tradeCopyRegulatoryReportsDashboard` | `AppRouteNames.sc094RegulatoryReportsDashboard` | `RegulatoryReportsDashboardPage` |
| 43 | Copy Trading and compliance | `AppRoutePaths.tradeCopyArmIntegrationStatus` | `AppRouteNames.sc095ArmIntegrationStatus` | `ArmIntegrationStatusPage` |
| 44 | Copy Trading and compliance | `AppRoutePaths.tradeCopyBestExecutionReports` | `AppRouteNames.sc096BestExecutionReports` | `BestExecutionReportsPage` |
| 45 | Copy Trading and compliance | `AppRoutePaths.tradeCopyExecutionVenueAnalysis` | `AppRouteNames.sc097ExecutionVenueAnalysis` | `ExecutionVenueAnalysisPage` |
| 46 | Copy Trading and compliance | `AppRoutePaths.tradeCopySlippageMonitoring` | `AppRouteNames.sc098SlippageMonitoring` | `SlippageMonitoringPage` |
| 47 | Copy Trading and compliance | `AppRoutePaths.tradeCopyClientCategorization` | `AppRouteNames.sc099ClientCategorization` | `ClientCategorizationPage` |
| 48 | Copy Trading and compliance | `AppRoutePaths.tradeCopyProductGovernance` | `AppRouteNames.sc100ProductGovernance` | `ProductGovernancePage` |
| 49 | Copy Trading and compliance | `AppRoutePaths.tradeCopyTargetMarketDefinition` | `AppRouteNames.sc101TargetMarketDefinition` | `TargetMarketDefinitionPage` |
| 50 | Copy Trading and compliance | `'${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId'` | `AppRouteNames.sc415TargetMarketDefinitionDetail` | `TargetMarketDefinitionPage` |
| 51 | Copy Trading and compliance | `AppRoutePaths.tradeCopyClientMoneyProtection` | `AppRouteNames.sc102ClientMoneyProtection` | `ClientMoneyProtectionPage` |
| 52 | Copy Trading and compliance | `AppRoutePaths.tradeCopyCassReconciliation` | `AppRouteNames.sc103CassReconciliation` | `CassReconciliationPage` |
| 53 | Copy Trading and compliance | `AppRoutePaths.tradeCopyInvestorCompensation` | `AppRouteNames.sc104InvestorCompensation` | `InvestorCompensationPage` |
| 54 | Copy Trading and compliance | `AppRoutePaths.tradeCopyExAnteCosts` | `AppRouteNames.sc105ExAnteCosts` | `ExAnteCostsPage` |
| 55 | Copy Trading and compliance | `AppRoutePaths.tradeCopyRiyCalculator` | `AppRouteNames.sc106RiyCalculator` | `RIYCalculatorPage` |
| 56 | Copy Trading and compliance | `AppRoutePaths.tradeCopyExPostCostsReport` | `AppRouteNames.sc107ExPostCostsReport` | `ExPostCostsReportPage` |
| 57 | Copy Trading and compliance | `AppRoutePaths.tradeCopyKidGenerator` | `AppRouteNames.sc108KidGenerator` | `KIDGeneratorPage` |
| 58 | Copy Trading and compliance | `AppRoutePaths.tradeCopyPerformanceScenarios` | `AppRouteNames.sc109PerformanceScenarios` | `PerformanceScenariosPage` |
| 59 | Copy Trading and compliance | `AppRoutePaths.tradeCopyRiskIndicatorExplainer` | `AppRouteNames.sc110RiskIndicatorExplainer` | `RiskIndicatorExplainerPage` |
| 60 | Copy Trading and compliance | `AppRoutePaths.tradeCopyComplaintsHandling` | `AppRouteNames.sc111ComplaintsHandling` | `ComplaintsHandlingPage` |
| 61 | Copy Trading and compliance | `AppRoutePaths.tradeCopyComplaintSubmission` | `AppRouteNames.sc112ComplaintSubmission` | `ComplaintSubmissionPage` |
| 62 | Copy Trading and compliance | `AppRoutePaths.tradeCopyComplaintTrackingBase` | `AppRouteNames.sc113ComplaintTracking` | `ComplaintTrackingPage` |
| 63 | Copy Trading and compliance | `'/trade/copy-trading/complaint-tracking/:complaintId'` | `AppRouteNames.sc416ComplaintTrackingDetail` | `ComplaintTrackingPage` |
| 64 | Copy Trading and compliance | `AppRoutePaths.tradeCopyOmbudsmanReferral` | `AppRouteNames.sc114OmbudsmanReferral` | `OmbudsmanReferralPage` |
| 65 | Copy Trading and compliance | `AppRoutePaths.tradeCopyAuditTrail` | `AppRouteNames.sc115AuditTrail` | `AuditTrailPage` |
| 66 | Copy Trading and compliance | `AppRoutePaths.tradeCopyRegulatoryInspectionReady` | `AppRouteNames.sc116RegulatoryInspectionReady` | `RegulatoryInspectionReadyPage` |
| 67 | Copy Trading and compliance | `AppRoutePaths.tradeCopyClientOptUpRequest` | `AppRouteNames.sc411ClientOptUpRequest` | `ClientOptUpRequestPage` |
| 68 | Copy Trading and compliance | `AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias` | `AppRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias` | Redirect |
| 69 | Margin and market data | `AppRoutePaths.tradeMargin` | `AppRouteNames.sc085MarginTrading` | `MarginTradingPage` |
| 70 | Margin and market data | `AppRoutePaths.tradeMarginBtcusdt` | `AppRouteNames.sc086MarginTradingPair` | `MarginTradingPage` |
| 71 | Margin and market data | `'/trade/trader/:traderId'` | `AppRouteNames.sc087TraderProfile` | `TraderProfilePage` |
| 72 | Margin and market data | `AppRoutePaths.tradeMarginAdvancedDemo` | `AppRouteNames.sc088AdvancedTradingDemo` | `AdvancedTradingDemoPage` |
| 73 | Margin and market data | `AppRoutePaths.tradeMarginMarketDataAnalytics` | `AppRouteNames.sc089MarketDataAnalytics` | `MarketDataAnalyticsPage` |
| 74 | Margin and market data | `AppRoutePaths.tradeMarginHub` | `AppRouteNames.sc090MarginTradingHub` | `MarginTradingHubPage` |
| 75 | Margin and market data | `AppRoutePaths.tradeMarginLiveMarketDataAnalytics` | `AppRouteNames.sc091LiveMarketDataAnalytics` | `LiveMarketDataAnalyticsPage` |
| 76 | Margin and market data | `AppRoutePaths.tradeMarginAdvancedAnalytics` | `AppRouteNames.sc092AdvancedAnalytics` | `AdvancedAnalyticsPage` |
| 77 | Copy Trading and compliance | `'/trade/copy-provider/:providerId/assessment'` | `AppRouteNames.sc071PreCopyAssessment` | `PreCopyAssessmentPage` |
| 78 | Copy Trading and compliance | `'/trade/copy-provider/:providerId/configuration'` | `AppRouteNames.sc072CopyConfiguration` | `CopyConfigurationPage` |
| 79 | Copy Trading and compliance | `'/trade/copy-provider/:providerId/confirmation'` | `AppRouteNames.sc073CopyConfirmation` | `CopyConfirmationPage` |
| 80 | Copy Trading and compliance | `'/trade/copy-provider/:providerId'` | `AppRouteNames.sc070CopyProviderDetail` | `CopyProviderDetailPage` |
| 81 | Copy Trading and compliance | `'/trade/copy-performance/:copyId'` | `AppRouteNames.sc074CopyPerformance` | `CopyPerformancePage` |
| 82 | Copy Trading and compliance | `'/trade/copy-performance/:copyId/attribution'` | `AppRouteNames.sc075PerformanceAttribution` | `PerformanceAttributionPage` |
| 83 | Copy Trading and compliance | `'/trade/copy-audit-log/:copyId'` | `AppRouteNames.sc077CopyAuditLog` | `CopyAuditLogPage` |
| 84 | Core Trade | `AppRoutePaths.tradeOrderReceipt` | `AppRouteNames.sc051OrderReceipt` | `OrderReceiptPage` |
| 85 | Core Trade | `AppRoutePaths.tradeOrdersHistory` | `AppRouteNames.sc050OrdersHistory` | `OrdersHistoryPage` |
| 86 | Core Trade | `AppRoutePaths.tradePositions` | `AppRouteNames.sc053PositionDashboard` | `PositionDashboardPage` |
| 87 | Core Trade | `AppRoutePaths.tradeSettings` | `AppRouteNames.sc052TradeSettings` | `TradeSettingsPage` |
| 88 | Core Trade | `AppRoutePaths.tradeExport` | `AppRouteNames.sc054TradeHistoryExport` | `TradeHistoryExportPage` |
| 89 | Futures | `'/trade/:pairId/futures/leverage'` | `AppRouteNames.sc058Leverage` | `LeveragePage` |
| 90 | Futures | `'/trade/:pairId/futures'` | `AppRouteNames.sc057Futures` | `FuturesPage` |
| 91 | Core Trade | `'/trade/:pairId'` | `AppRouteNames.sc049TradePair` | `TradePage` |

## 5. Target Trade UX Model

### 5.1 Main Trade hub

The root `TradePage` should become a compact, phone-first command center:

- Market selector and selected pair summary.
- Price, change, liquidity, and key spread indicators.
- Primary order ticket with buy/sell state, amount, price, preview, and confirmation.
- Mini chart or chart access with a clear advanced-chart path.
- Recent orders, positions, and receipt access.
- Quick actions limited to the highest-value actions.
- Secondary actions grouped behind a clear "More" or sectioned navigation model.

### 5.2 User-level navigation hierarchy

Use this hierarchy to reduce cognitive load:

1. Primary trading: Trade, pair route, advanced chart, order receipt, history, positions, settings, export.
2. Simple conversion: Convert.
3. Higher-risk trading: Futures, leverage, margin, margin hub.
4. Automation: Trading bots and all bot support pages.
5. Social/professional copying: Copy Trading, provider detail, active copies, copy performance.
6. Safety and education: risk analysis, safety center, disclosures, suitability, risk dashboards.
7. Compliance and reports: transaction reporting, client categorization, CASS, KID, RIY, complaints, audit, regulatory inspection.

### 5.3 Visual model

- Global foundation: `AppColors`, `AppSpacing`, `AppRadii`, `AppTextStyles`, `DeviceMetrics`, `VitDensity`.
- Module accent: `AppModuleAccents.trade`, semantic `buy`, `sell`, `warn`, and risk colors.
- No local repeated `Color(0x...)`, raw `fontSize`, raw `EdgeInsets`, or one-off radii in touched UI files unless a documented chart/canvas exception is necessary.
- Use neutral cards and surfaces; apply Trade character through accent icons, badges, chart markers, and risk panels.
- Keep first viewport useful: avoid oversized heroes and vertical gaps that push the first actionable trading content below the fold.

## 6. Component Strategy

Use existing shared primitives first:

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
- `VitInfoRow`
- `VitStatusPill`
- `VitMetricCard`
- `VitModuleSectionHeader`
- `VitModuleHeroCard`
- `VitActionTileGrid`
- `VitFinancialSafetySummary`
- `VitHighRiskStatePanel`
- `VitSkeleton`

Only add Trade-specific widgets when shared primitives cannot express the pattern cleanly. Prefer placing Trade-only components under:

```text
flutter_app/lib/features/trade/presentation/widgets/
```

Candidate Trade components:

- `TradePageScaffold`: standardizes page header, content density, and optional bottom CTA for Trade pages.
- `TradeMarketHeader`: selected pair, price, spread, change, status.
- `TradeOrderTicket`: buy/sell, order type, amount, estimated cost, validation, preview.
- `TradeRiskNotice`: risk/fee/limit disclosure strip using `VitFinancialSafetySummary`.
- `TradeActionTile`: standardized shortcut action using existing tile primitives.
- `TradeMetricStrip`: compact financial metrics with numeric text styles.
- `TradeStatusBanner`: loading, offline, degraded market, submitting, success, and error states.
- `TradeComplianceListSection`: compact section for regulatory/compliance pages.
- `TradeEmptyOrLoadingState`: unified state adapter for trade list/detail pages.

Do not build these components all at once. Add each only when the current vertical slice needs it.

## 7. AI Execution Protocol

Every implementation session must follow this protocol:

1. Read this plan and the current user instruction.
2. Read `AGENTS.md`, `docs/00_START_HERE.md`, and the relevant design docs if they are not already in context.
3. Use GitNexus for exploration before editing:
   - `query` for unfamiliar flows.
   - `context` for the exact class/function being changed.
   - `impact({target, direction: "upstream"})` before editing any symbol.
   - Warn the user before continuing if impact is HIGH or CRITICAL.
4. Use `rg`/`rg --files` first for local search.
5. Use `multi_tool_use.parallel` for independent file reads or searches.
6. Keep changes incremental and vertical. Do not redesign every page in one huge edit.
7. Use `apply_patch` for manual edits.
8. Run focused tests after each phase; run full checks before final handoff.
9. Run `detect_changes()` before any commit or final merge handoff.
10. Preserve all user or unrelated worktree changes.

Recommended skills for implementation sessions:

- `vittrade-ui-checklists`: Flutter-safe UI checklist.
- `ui-ux-pro-max`: design-system guidance and Flutter stack recommendations.
- `planning-and-task-breakdown`: phase/task decomposition.
- `incremental-implementation`: multi-file implementation discipline.
- `test-driven-development`: test-first or test-near changes.
- `debugging-and-error-recovery`: failed tests/builds.
- `code-review-and-quality`: final self-review.
- `gitnexus-impact-analysis`: blast-radius checks.
- `build-ios-apps:ios-debugger-agent` or Android emulator QA skill if validating platform UI on an emulator.

Token-saving rules for future AI agents:

- Do not paste entire large files into the conversation unless necessary.
- Read only the route/page/widget/test files for the current phase.
- Use concise route inventories and targeted `rg` queries.
- Compress large outputs when available.
- Keep a running checklist in this file or a linked tracking artifact instead of restating all context in each message.

## 8. Implementation Phases

### Phase 0: Baseline and route audit

Purpose: establish current behavior and prevent accidental scope drift.

Tasks:

- [ ] Confirm current branch and worktree status.
- [ ] Read active docs and this plan.
- [ ] Use GitNexus `query`/`context` to inspect `TradePage`, `trade_routes.dart`, and high-risk Trade controllers.
- [ ] Confirm route count from `trade_routes.dart`.
- [ ] Confirm direct navigation targets from `TradePage`.
- [ ] Run baseline static checks before code changes.

Acceptance criteria:

- [ ] AI can explain the current Trade route graph.
- [ ] AI knows which pages are in the current phase.
- [ ] No Flutter UI code has been changed yet.

Verification commands:

```bash
cd flutter_app
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
```

### Phase 1: Trade UI contract and component mapping

Purpose: define the shared visual contract before editing pages.

Tasks:

- [ ] Map current Trade page patterns to shared primitives.
- [ ] Identify repeated local scaffolds, cards, section headers, action tiles, metric cards, and risk panels.
- [ ] Decide which patterns should use existing shared widgets and which require Trade-only widgets.
- [ ] Define compact first-viewport expectations for Trade root, pair, convert, futures, margin, bots, and copy trading.
- [ ] Define loading, empty, error, offline, submitting, and success state requirements per route group.

Acceptance criteria:

- [ ] There is a concrete component mapping for every phase below.
- [ ] No new module-specific background/card/bottom-nav palette is planned.
- [ ] High-risk flows have explicit preview and confirmation expectations.

Verification:

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
```

### Phase 2: Foundation components for Trade

Purpose: add only the smallest reusable Trade UI layer needed by Phase 3.

Likely files:

- `flutter_app/lib/features/trade/presentation/widgets/`
- `flutter_app/lib/shared/widgets/` only if a component is genuinely reusable outside Trade.
- `flutter_app/test/features/trade/`

Tasks:

- [ ] Create or adapt `TradeMarketHeader` if the existing page has repeated market summary UI.
- [ ] Create or adapt `TradeRiskNotice` using `VitFinancialSafetySummary` or `VitHighRiskStatePanel`.
- [ ] Create or adapt `TradeMetricStrip` for compact numeric metrics.
- [ ] Create or adapt `TradeActionTile` only if `VitActionTileGrid` is insufficient.
- [ ] Add widget tests for the new component states.

Acceptance criteria:

- [ ] New components use `AppTextStyles`, `AppSpacing`, `AppRadii`, `AppColors`, and semantic tokens.
- [ ] Components support phone width at 360 px.
- [ ] Components include accessibility labels/tooltips for icon-only or high-risk actions.
- [ ] No duplicated local color/spacing/radius systems are introduced.

Verification:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed .
flutter test test/features/trade --reporter=compact
flutter analyze
```

### Phase 3: Redesign Core Trade root and pair surfaces

Routes:

- `AppRoutePaths.trade`
- `'/trade/:pairId'`
- `'/trade/advanced-chart/:pairId'`

Likely files:

- `flutter_app/lib/features/trade/presentation/pages/trade_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/trade_page_part_01.dart`
- `flutter_app/lib/features/trade/presentation/pages/trade_page_part_02.dart`
- `flutter_app/lib/features/trade/presentation/pages/trade_page_part_03.dart`
- `flutter_app/lib/features/trade/presentation/pages/advanced_chart_page.dart`
- `flutter_app/test/features/trade/trade_page_test.dart`
- `flutter_app/test/features/trade/advanced_chart_page_test.dart`

Tasks:

- [ ] Restructure the first viewport into market summary, order ticket, and compact quick actions.
- [ ] Reduce quick action visual noise; keep primary actions visible and group secondary actions.
- [ ] Standardize pair ticker cards, order ticket cards, and recent order/receipt sections.
- [ ] Ensure buy/sell visual states use semantic tokens.
- [ ] Ensure order submit path shows submitting and success states.
- [ ] Ensure route `/trade/:pairId` behaves as a pair-specific version of Trade, not a visually separate app.
- [ ] Update advanced chart entry to match Trade header/action patterns.

Acceptance criteria:

- [ ] First viewport contains actionable trading content at phone width.
- [ ] Root and pair Trade share the same shell, spacing, typography, and card treatment.
- [ ] Order preview/receipt path is visible and safe.
- [ ] `TradePage` still supports `initialSide`, `pairId`, `chartVariant`, and `shellRenderMode`.

Verification:

```bash
cd flutter_app
flutter test test/features/trade/trade_page_test.dart --reporter=compact
flutter test test/features/trade/advanced_chart_page_test.dart --reporter=compact
flutter test test/app/router/app_route_paths_trade_contract_test.dart --reporter=compact
dart run tool/navigation_edge_audit.dart --check
```

### Phase 4: Redesign order lifecycle and core utility pages

Routes:

- `AppRoutePaths.tradeOrderReceipt`
- `AppRoutePaths.tradeOrdersHistory`
- `AppRoutePaths.tradePositions`
- `AppRoutePaths.tradeSettings`
- `AppRoutePaths.tradeExport`
- `AppRoutePaths.tradeConvert`

Likely files:

- `order_receipt_page.dart`
- `orders_history_page.dart`
- `position_dashboard_page.dart`
- `trade_settings_page.dart`
- `trade_history_export_page.dart`
- `convert_page.dart`
- Related widgets under `presentation/widgets/`
- Matching tests under `test/features/trade/`

Tasks:

- [ ] Standardize receipt layout: status, order details, fee/limit summary, next actions.
- [ ] Standardize order history and positions: filters, empty state, offline state, compact rows.
- [ ] Standardize settings and export pages: clear sections, safe toggles, masked sensitive values where needed.
- [ ] Standardize convert page: simple two-asset flow, preview, fee/rate visibility, confirmation.
- [ ] Ensure all rows use `VitInfoRow` or a consistent Trade info-row pattern.

Acceptance criteria:

- [ ] Core utility pages look like the same product family as `TradePage`.
- [ ] Convert and export show fees, rates, limits, or next steps where relevant.
- [ ] Empty/loading/error/offline states are covered where data-driven.

Verification:

```bash
cd flutter_app
flutter test test/features/trade/order_receipt_page_test.dart --reporter=compact
flutter test test/features/trade/orders_history_page_test.dart --reporter=compact
flutter test test/features/trade/position_dashboard_page_test.dart --reporter=compact
flutter test test/features/trade/trade_settings_page_test.dart --reporter=compact
flutter test test/features/trade/trade_history_export_page_test.dart --reporter=compact
flutter test test/features/trade/convert_page_test.dart --reporter=compact
```

### Phase 5: Redesign futures, leverage, margin, and market data

Routes:

- `'/trade/:pairId/futures'`
- `'/trade/:pairId/futures/leverage'`
- `AppRoutePaths.tradeMargin`
- `AppRoutePaths.tradeMarginBtcusdt`
- `'/trade/trader/:traderId'`
- `AppRoutePaths.tradeMarginAdvancedDemo`
- `AppRoutePaths.tradeMarginMarketDataAnalytics`
- `AppRoutePaths.tradeMarginHub`
- `AppRoutePaths.tradeMarginLiveMarketDataAnalytics`
- `AppRoutePaths.tradeMarginAdvancedAnalytics`

Tasks:

- [ ] Make futures and leverage pages explicitly risk-aware.
- [ ] Keep leverage confirmation visible and stable only after preview/disclosure.
- [ ] Standardize margin order input, risk cards, positions, and order summary.
- [ ] Standardize margin hub navigation and advanced market-data surfaces.
- [ ] Ensure analytics/chart pages are dense but readable on phone.
- [ ] Ensure trader profile uses neutral card treatment and Trade accent only for relevant metrics.

Acceptance criteria:

- [ ] Futures and margin surfaces never hide liquidation/risk/fee information.
- [ ] Margin and market data pages share the same Trade visual foundation.
- [ ] No hype/casino/FOMO language is introduced.

Verification:

```bash
cd flutter_app
flutter test test/features/trade/futures_page_test.dart --reporter=compact
flutter test test/features/trade/leverage_page_test.dart --reporter=compact
flutter test test/features/trade/margin_trading_page_test.dart --reporter=compact
flutter test test/features/trade/margin_trading_hub_page_test.dart --reporter=compact
flutter test test/features/trade/market_data_analytics_page_test.dart --reporter=compact
flutter test test/features/trade/live_market_data_analytics_page_test.dart --reporter=compact
flutter test test/features/trade/advanced_analytics_page_test.dart --reporter=compact
flutter test test/features/trade/trader_profile_page_test.dart --reporter=compact
flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact
```

### Phase 6: Redesign trading bots

Routes:

- `AppRoutePaths.tradeBots`
- All `AppRoutePaths.tradeBot*` routes listed in the manifest.

Tasks:

- [ ] Make the bots hub explain active bots, risk, performance, and next action without oversized hero treatment.
- [ ] Standardize bot risk, emergency stop, security, and suitability pages as safety-first flows.
- [ ] Standardize bot analytics pages with compact metrics, chart cards, filters, and empty states.
- [ ] Standardize bot education/documentation pages with clear section hierarchy.
- [ ] Keep emergency stop and security actions visually distinct and confirmable.

Acceptance criteria:

- [ ] All 19 bot routes use a consistent Trade automation visual pattern.
- [ ] Risk and security actions are obvious and accessible.
- [ ] Analytics pages avoid layout overflow and unreadable dense charts on mobile.

Verification:

```bash
cd flutter_app
flutter test test/features/trade/trading_bots_page_test.dart --reporter=compact
flutter test test/features/trade/bot_risk_dashboard_page_test.dart --reporter=compact
flutter test test/features/trade/bot_emergency_stop_page_test.dart --reporter=compact
flutter test test/features/trade/bot_security_settings_page_test.dart --reporter=compact
flutter test test/features/trade/bot_suitability_assessment_page_test.dart --reporter=compact
flutter test test/features/trade/bot_performance_analytics_page_test.dart --reporter=compact
flutter test test/features/trade/bot_backtesting_page_test.dart --reporter=compact
flutter test test/features/trade/bot_strategy_compare_page_test.dart --reporter=compact
flutter test test/features/trade/bot_optimization_page_test.dart --reporter=compact
flutter test test/features/trade/bot_portfolio_dashboard_page_test.dart --reporter=compact
flutter test test/features/trade/bot_drawdown_analyzer_page_test.dart --reporter=compact
flutter test test/features/trade/bot_equity_curve_page_test.dart --reporter=compact
flutter test test/features/trade/bot_history_page_test.dart --reporter=compact
flutter test test/features/trade/bot_guide_page_test.dart --reporter=compact
flutter test test/features/trade/bot_faq_page_test.dart --reporter=compact
flutter test test/features/trade/bot_tax_reporting_page_test.dart --reporter=compact
flutter test test/features/trade/bot_api_documentation_page_test.dart --reporter=compact
```

### Phase 7: Redesign copy trading and provider journey

Routes:

- `AppRoutePaths.tradeCopyTrading`
- `AppRoutePaths.tradeCopyTradingV2`
- `AppRoutePaths.tradeCopyEducation`
- `AppRoutePaths.tradeCopyActive`
- `AppRoutePaths.tradeCopySettings`
- `AppRoutePaths.tradeCopyNotifications`
- `AppRoutePaths.tradeCopyProviderApply`
- `'/trade/copy-provider/:providerId'`
- `'/trade/copy-provider/:providerId/assessment'`
- `'/trade/copy-provider/:providerId/configuration'`
- `'/trade/copy-provider/:providerId/confirmation'`
- `'/trade/copy-performance/:copyId'`
- `'/trade/copy-performance/:copyId/attribution'`
- `'/trade/copy-audit-log/:copyId'`

Tasks:

- [ ] Make copy trading hub easy to understand: providers, active copies, risk, education, safety.
- [ ] Standardize provider detail, assessment, configuration, and confirmation as one continuous journey.
- [ ] Show capital, allocation, risk, fees, drawdown, and exit/next steps before confirmation.
- [ ] Standardize active copies and performance pages with compact cards and clear status.
- [ ] Ensure safe back paths remain controlled through existing `resolveSafeBackPath` behavior.

Acceptance criteria:

- [ ] Provider flow feels connected and consistent from detail through confirmation.
- [ ] High-risk copy actions require review and confirmation.
- [ ] Active copy performance and audit history are readable on phone.

Verification:

```bash
cd flutter_app
flutter test test/features/trade/copy_trading_page_test.dart --reporter=compact
flutter test test/features/trade/copy_trading_v2_page_test.dart --reporter=compact
flutter test test/features/trade/copy_education_page_test.dart --reporter=compact
flutter test test/features/trade/active_copies_page_test.dart --reporter=compact
flutter test test/features/trade/copy_settings_page_test.dart --reporter=compact
flutter test test/features/trade/copy_notifications_page_test.dart --reporter=compact
flutter test test/features/trade/provider_application_page_test.dart --reporter=compact
flutter test test/features/trade/copy_provider_detail_page_test.dart --reporter=compact
flutter test test/features/trade/pre_copy_assessment_page_test.dart --reporter=compact
flutter test test/features/trade/copy_configuration_page_test.dart --reporter=compact
flutter test test/features/trade/copy_confirmation_page_test.dart --reporter=compact
flutter test test/features/trade/copy_performance_page_test.dart --reporter=compact
flutter test test/features/trade/performance_attribution_page_test.dart --reporter=compact
flutter test test/features/trade/copy_audit_log_page_test.dart --reporter=compact
```

### Phase 8: Redesign copy safety, compliance, reports, and regulatory pages

Routes:

- Remaining Copy Trading and compliance routes in the manifest, including comparison, leaderboard, safety, governance, dispute, disclosures, reports, transaction reporting, execution reports, client protection, CASS, investor compensation, costs, KID, RIY, scenarios, complaints, ombudsman, audit, and inspection readiness.

Tasks:

- [ ] Standardize regulatory pages with compact headers, clear status pills, evidence lists, and next-action cards.
- [ ] Standardize report dashboards with filters, summary metrics, report rows, empty/offline states.
- [ ] Standardize complaints/dispute flows with progressive steps and accessible validation.
- [ ] Standardize cost/KID/RIY/performance scenario pages with consistent calculation panels.
- [ ] Keep legal/compliance pages calm, dense, and trustworthy; avoid promotional styling.

Acceptance criteria:

- [ ] All compliance/report routes follow the same visual language.
- [ ] Legal or risk copy is not hidden behind decorative layout.
- [ ] Forms and high-risk controls have semantics and validation messages.

Verification:

```bash
cd flutter_app
flutter test test/features/trade/provider_comparison_page_test.dart --reporter=compact
flutter test test/features/trade/provider_leaderboard_page_test.dart --reporter=compact
flutter test test/features/trade/copy_safety_center_page_test.dart --reporter=compact
flutter test test/features/trade/provider_governance_page_test.dart --reporter=compact
flutter test test/features/trade/dispute_resolution_page_test.dart --reporter=compact
flutter test test/features/trade/regulatory_disclosures_page_test.dart --reporter=compact
flutter test test/features/trade/transaction_reporting_page_test.dart --reporter=compact
flutter test test/features/trade/regulatory_reports_dashboard_page_test.dart --reporter=compact
flutter test test/features/trade/arm_integration_status_page_test.dart --reporter=compact
flutter test test/features/trade/best_execution_reports_page_test.dart --reporter=compact
flutter test test/features/trade/execution_venue_analysis_page_test.dart --reporter=compact
flutter test test/features/trade/slippage_monitoring_page_test.dart --reporter=compact
flutter test test/features/trade/client_categorization_page_test.dart --reporter=compact
flutter test test/features/trade/product_governance_page_test.dart --reporter=compact
flutter test test/features/trade/target_market_definition_page_test.dart --reporter=compact
flutter test test/features/trade/client_money_protection_page_test.dart --reporter=compact
flutter test test/features/trade/cass_reconciliation_page_test.dart --reporter=compact
flutter test test/features/trade/investor_compensation_page_test.dart --reporter=compact
flutter test test/features/trade/ex_ante_costs_page_test.dart --reporter=compact
flutter test test/features/trade/riy_calculator_page_test.dart --reporter=compact
flutter test test/features/trade/ex_post_costs_report_page_test.dart --reporter=compact
flutter test test/features/trade/kid_generator_page_test.dart --reporter=compact
flutter test test/features/trade/performance_scenarios_page_test.dart --reporter=compact
flutter test test/features/trade/risk_indicator_explainer_page_test.dart --reporter=compact
flutter test test/features/trade/complaints_handling_page_test.dart --reporter=compact
flutter test test/features/trade/complaint_submission_page_test.dart --reporter=compact
flutter test test/features/trade/complaint_tracking_page_test.dart --reporter=compact
flutter test test/features/trade/ombudsman_referral_page_test.dart --reporter=compact
flutter test test/features/trade/audit_trail_page_test.dart --reporter=compact
flutter test test/features/trade/regulatory_inspection_ready_page_test.dart --reporter=compact
```

### Phase 9: Cross-module direct navigation polish

Targets from main Trade quick actions:

- DCA
- Wallet
- P2P
- Earn/Staking
- Launchpad
- Prediction Markets
- Arena
- Rewards
- Support

Tasks:

- [ ] Ensure Trade quick actions use shared navigation primitives and `AppRoutePaths`.
- [ ] Verify labels do not mix Trade wallet/PnL language with Arena points-only language.
- [ ] Ensure cross-module cards do not visually imply those modules are part of Trade risk surfaces.
- [ ] Keep Prediction Markets and Arena visually and semantically separated.

Acceptance criteria:

- [ ] Cross-module links are clear but visually secondary to trading actions.
- [ ] Arena copy remains points-only.
- [ ] Prediction Markets copy remains probability/positions/receipt/P&L oriented.

Verification:

```bash
cd flutter_app
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact
dart run tool/navigation_edge_audit.dart --check
```

### Phase 10: Full QA and final hardening

Tasks:

- [ ] Run full formatting check.
- [ ] Run route coverage audit.
- [ ] Run navigation edge audit.
- [ ] Run design token audit.
- [ ] Run visual density audit.
- [ ] Run quality guardrails.
- [ ] Run full `flutter analyze`.
- [ ] Run full `flutter test`.
- [ ] Run emulator/device validation for representative screens.
- [ ] Capture screenshots/videos into `flutter_app/run-artifacts/`.
- [ ] Run GitNexus `detect_changes()`.
- [ ] Complete a code-review pass focused on regressions, product safety, accessibility, and missing tests.

Required final commands:

```bash
cd flutter_app
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter test test/app/router --reporter=compact
flutter test test/quality/navigation_route_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/trade_product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
flutter analyze
flutter test --reporter=compact
```

Representative emulator QA screens:

- `/trade`
- `/trade/btcusdt`
- `/trade/order-receipt`
- `/trade/orders-history`
- `/trade/convert`
- `/trade/btcusdt/futures`
- `/trade/btcusdt/futures/leverage`
- `/trade/margin`
- `/trade/bots`
- `/trade/bots/risk-dashboard`
- `/trade/bots/emergency-stop`
- `/trade/copy-trading`
- `/trade/copy-provider/provider001`
- `/trade/copy-provider/provider001/configuration`
- `/trade/copy-provider/provider001/confirmation`
- `/trade/copy-trading/regulatory-disclosures`
- `/trade/copy-trading/transaction-reporting`

## 9. Design Acceptance Checklist

For every touched page:

- [ ] Uses shared layout primitives before local scaffolds.
- [ ] Uses theme tokens, not local repeated colors/spacing/radii/typography.
- [ ] Uses dark baseline and neutral surfaces.
- [ ] Uses Trade module accent only for icons, badges, focus, charts, buy/sell, and warnings.
- [ ] Works at 360 px phone width.
- [ ] First viewport contains useful/actionable content.
- [ ] Text does not overlap controls.
- [ ] Tap targets are usable.
- [ ] Icon-only controls have tooltips or semantics.
- [ ] Loading state exists where data loads.
- [ ] Empty state exists where lists can be empty.
- [ ] Error state exists where calls can fail.
- [ ] Offline/degraded state exists where network state matters.
- [ ] Submitting state exists for forms/actions.
- [ ] Success state exists after completion.
- [ ] High-risk actions preview fee/risk/limit/next step.
- [ ] No hype, casino, FOMO, or hidden-risk copy.
- [ ] Prediction Markets and Arena boundaries are not crossed.
- [ ] Focused tests are updated.

## 10. Stop Conditions

Stop implementation and report the blocker if any of these occur:

- GitNexus impact analysis returns HIGH or CRITICAL and the user has not acknowledged the risk.
- A page grows beyond 500 lines because it owns too many visual sections directly.
- A widget grows beyond 350 lines without a clear reason.
- Presentation imports `features/*/data` directly in a new way.
- New local design-token debt is introduced without a reviewed exception.
- High-risk Trade, margin, futures, bot, or copy-trading flow lacks preview/confirmation.
- Arena and Prediction Markets copy or reward semantics are mixed.
- Route or navigation audits fail and the failure is not understood.
- Emulator shows overflow, clipped text, unreadable controls, or first-viewport chrome dominance.

## 11. Suggested Autonomous AI Prompt

Use this prompt when starting the implementation after this plan is approved:

```text
You are implementing the VitTrade Trade UI Redesign Enterprise Execution Plan.

Read first:
- AGENTS.md
- docs/00_START_HERE.md
- docs/03_DESIGN_SYSTEM/VitTrade-Trade-UI-Redesign-Enterprise-Execution-Plan.md
- docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md
- docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md
- docs/03_DESIGN_SYSTEM/Guidelines.md

Work only in flutter_app/ unless updating documentation. Do not recreate React, Vite, web screenshot tooling, or retired baselines.

Before editing any Dart symbol, use GitNexus context and impact analysis. If impact is HIGH or CRITICAL, warn the user before editing.

Execute the plan phase by phase:
1. Phase 0 baseline and route audit.
2. Phase 1 Trade UI contract and component mapping.
3. Phase 2 minimal Trade component foundation.
4. Phase 3 core Trade root, pair, and advanced chart.
5. Phase 4 order lifecycle, convert, settings, export, positions.
6. Phase 5 futures, leverage, margin, market data.
7. Phase 6 trading bots.
8. Phase 7 copy trading provider journey.
9. Phase 8 compliance and regulatory pages.
10. Phase 9 cross-module quick action polish.
11. Phase 10 full QA and emulator validation.

Use shared VitTrade primitives before local widgets. Use AppColors, AppSpacing, AppRadii, AppTextStyles, DeviceMetrics, VitDensity, and AppModuleAccents. Keep Trade identity as an accent layer only.

After each phase, run the focused tests listed in the plan. Before final handoff, run all required final commands and emulator QA. Keep the user updated with concise progress. Do not stop halfway unless blocked by a documented stop condition.
```
