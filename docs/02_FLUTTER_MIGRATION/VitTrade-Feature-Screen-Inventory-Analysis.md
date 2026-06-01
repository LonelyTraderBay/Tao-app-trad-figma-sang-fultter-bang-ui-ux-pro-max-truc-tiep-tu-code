# VitTrade Feature And Screen Inventory Analysis

Generated from Flutter router source and feature folders.

## Counting Rules

- Source of truth for screens: named `GoRoute` entries with a `builder` in `flutter_app/lib/app/router/route_groups/`.
- Redirect-only routes are tracked separately because they do not render their own screen.
- Feature implementation files under `features/<feature>/presentation/pages` are shown as supporting evidence, but they are not used as the primary screen count because many screens are split into `part_XX.dart` files.

## Executive Summary

- Feature folders under `flutter_app/lib/features`: **23**.
- Renderable named screens connected to router: **414**.
- Raw named route constants in `AppRouteNames`: **416** (`SC-001` through `SC-416`, continuous).
- Named route constants actually referenced by route groups: **415**.
- Redirect-only `GoRoute` entries: **3**.
- `features/*/presentation/pages` Dart files: **607** including part files.

Important route notes:

- `sc196ArenaPoints` exists as a route-name constant but is not used by a renderable route; `/arena/points` redirects to `/rewards?tab=arena`.
- `sc412TradeCopyRegulatoryDisclosuresAlias` is a named redirect alias to `/trade/copy-trading/regulatory-disclosures`, not a separate screen.
- `/` redirects to `/home` and is not counted as a screen.

## Screen Count By Function

| Function | Screens | Router Source | Scope |
| --- | ---: | --- | --- |
| Auth + Onboarding | 7 | `auth` | Login, register, OTP, 2FA setup, password recovery, onboarding. |
| Home + News | 2 | `home` | Main home dashboard and general news surface. |
| Markets + Pair Discovery | 22 | `markets` | Market list, overview, movers, sectors, watchlist, alerts, screeners, pair detail/info/depth. |
| Prediction Markets | 18 | `predictions` | Prediction home, search, event detail, portfolio, rewards, leaderboard, activity, risk and tournaments. |
| Trading / Bots / Copy / Margin | 90 | `trade` | Spot/futures/margin trading, orders, positions, execution quality, bots, copy trading, regulatory screens. |
| P2P Trading | 79 | `p2p` | Express buy/sell, orders, chat, disputes, ads, merchant, escrow, KYC, security, payments, insurance, compliance, tax. |
| Open Arena | 25 | `arena` | Arena hub, studio, challenge/mode details, join, ledger, creator, safety, reports, bridge/ecosystem handoff. |
| Earn / Staking / Savings | 70 | `earn` | Staking and savings product, portfolio, history, risk, governance, validator, reports, developer integrations. |
| Launchpad | 24 | `launchpad` | Launchpad portfolio/performance/staking, claims, bridge, contracts, notifications, address book, gas, multisig, swap/DCA/risk. |
| Wallet | 21 | `wallet` | Wallet, deposit/withdraw, transaction, portfolio analytics, address book, transfer, asset detail, gas, approvals, limits, network status. |
| Profile / Account | 14 | `profile` | Profile, KYC, security, VIP, API, devices, subaccounts, settings, activity, prediction and arena profile sections. |
| Admin / Analytics | 5 | `admin` | Admin dashboard, analytics, A/B test, funnel, settings. |
| DCA / Auto-Invest | 13 | `dca` | DCA overview, rebalance, schedule, portfolio optimizer, dynamic amount, backtester, multi-asset, smart rules. |
| Support | 3 | `support` | Support home, announcements, help. |
| Referral | 5 | `utility` | Referral home, history, rewards, rules, friend detail. |
| Discovery / Search / Topics | 3 | `utility` | Unified search and topic hub/detail. |
| Notifications | 1 | `utility` | Notifications center. |
| Rewards Hub | 1 | `utility` | Shared rewards hub, including Arena filtered mode. |
| Enterprise / Cross-Module | 5 | `utility` | Enterprise states, unified portfolio, cross-module analytics, smart alerts, tax reports. |
| Dev / QA / Demo Tools | 6 | `utility` | Route checker, performance monitor, missing-screen showcase, design system, DCA and copy-card demos. |
| **Total** | **414** |  |  |

## Trading Module Sub-Breakdown

The `Trading / Bots / Copy / Margin` row is counted as **90 screens** because all of these surfaces live in the same router group: `flutter_app/lib/app/router/route_groups/trade_routes.dart`. It is one large technical module, but product-wise it contains several sub-functions.

| Trade Sub-Function | Screens | SC Range / Key Routes | Notes |
| --- | ---: | --- | --- |
| Core Trading / Orders | 14 | `SC-048`-`SC-058`, `SC-060`-`SC-062` | Spot trade, pair trade, futures, leverage, convert, orders, positions, settings, export, chart, risk, execution quality, advanced tools. |
| Trading Bots | 19 | `SC-059`, `SC-117`-`SC-134` | Bot hub, terms, risk disclosure, suitability, dashboard, emergency stop, security, history, analytics, backtest, strategy compare, optimization, guide, FAQ, tax, API docs. |
| Copy Trading + Compliance | 49 | `SC-063`-`SC-084`, `SC-093`-`SC-116`, `SC-411`, `SC-415`, `SC-416` | Copy trading user flow plus provider, performance, audit, safety, dispute, regulatory, reporting, client categorization, costs, complaints, target market detail. |
| Margin / Advanced Trading | 8 | `SC-085`-`SC-092` | Margin hub, margin pair, trader profile, advanced trading demo, market data analytics, live analytics, advanced analytics. |
| **Total** | **90** |  |  |

## Feature Folder Implementation Footprint

| Feature Folder | Page Dart Files | `*Page` Classes | Unique `SC-xxx` Labels In Pages |
| --- | ---: | ---: | ---: |
| `admin` | 5 | 1 | 4 |
| `arena` | 61 | 26 | 27 |
| `auth` | 6 | 6 | 6 |
| `cross_module` | 7 | 0 | 4 |
| `dca` | 30 | 5 | 12 |
| `dev` | 4 | 2 | 4 |
| `discovery` | 2 | 2 | 2 |
| `earn` | 115 | 68 | 69 |
| `enterprise_states` | 1 | 1 | 1 |
| `home` | 4 | 1 | 1 |
| `launchpad` | 40 | 24 | 24 |
| `markets` | 37 | 21 | 21 |
| `news` | 1 | 1 | 1 |
| `notifications` | 1 | 1 | 1 |
| `onboarding` | 4 | 0 | 1 |
| `p2p` | 96 | 72 | 72 |
| `predictions` | 25 | 17 | 17 |
| `profile` | 11 | 11 | 11 |
| `referral` | 12 | 5 | 5 |
| `rewards` | 1 | 1 | 0 |
| `support` | 3 | 3 | 3 |
| `trade` | 119 | 86 | 87 |
| `wallet` | 22 | 19 | 21 |

## Redirect-Only Routes

| Route Group | Route Name | Path | Target Expression |
| --- | --- | --- | --- |
| `arena_routes.dart` | `(unnamed)` | `/arena/points` | `'${AppRoutePaths.rewards}?tab=arena'` |
| `auth_routes.dart` | `(unnamed)` | `/` | `AppRoutePaths.home` |
| `trade_routes.dart` | `sc412TradeCopyRegulatoryDisclosuresAlias` | `/trade/copy-trading/regulatory-disclosures` | `AppRoutePaths.tradeCopyRegulatoryDisclosures` |

## Full Route Inventory

### Auth + Onboarding (7 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-001 | `sc001Login` | `/auth/login` | `LoginPage` |
| SC-002 | `sc002Register` | `/auth/register` | `RegisterPage` |
| SC-003 | `sc003Otp` | `/auth/otp` | `OTPPage` |
| SC-004 | `sc004TwoFaSetup` | `/auth/2fa-setup` | `TwoFASetupPage` |
| SC-005 | `sc005ForgotPassword` | `/auth/forgot-password` | `ForgotPasswordPage` |
| SC-006 | `sc006ResetPassword` | `/auth/reset-password` | `ResetPasswordPage` |
| SC-397 | `sc397Onboarding` | `/onboarding` | `OnboardingFlow` |

### Home + News (2 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-007 | `sc007Home` | `/home` | `HomePage` |
| SC-047 | `sc047News` | `/news` | `NewsPage` |

### Markets + Pair Discovery (22 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-008 | `sc008MarketList` | `/markets` | `MarketListPage` |
| SC-009 | `sc009MarketOverview` | `/markets/overview` | `MarketOverviewPage` |
| SC-010 | `sc010MarketMovers` | `/markets/movers` | `MarketMoversPage` |
| SC-011 | `sc011MarketSectors` | `/markets/sectors` | `MarketSectorsPage` |
| SC-012 | `sc012Watchlist` | `/markets/watchlist` | `WatchlistPage` |
| SC-013 | `sc013MarketHeatmap` | `/markets/heatmap` | `MarketHeatmapPage` |
| SC-014 | `sc014PriceAlerts` | `/markets/alerts` | `PriceAlertsPage` |
| SC-015 | `sc015MarketScreener` | `/markets/screener` | `MarketScreenerPage` |
| SC-016 | `sc016ComparisonTool` | `/markets/compare` | `ComparisonToolPage` |
| SC-017 | `sc017MarketCalendar` | `/markets/calendar` | `MarketCalendarPage` |
| SC-018 | `sc018DerivativesOverview` | `/markets/derivatives` | `DerivativesOverviewPage` |
| SC-019 | `sc019MarketDepth` | `/markets/depth` | `MarketDepthPage` |
| SC-020 | `sc020SocialSentiment` | `/markets/social-sentiment` | `SocialSentimentPage` |
| SC-021 | `sc021PortfolioTracker` | `/markets/portfolio-tracker` | `PortfolioTrackerPage` |
| SC-022 | `sc022MarketNews` | `/markets/news` | `MarketNewsPage` |
| SC-023 | `sc023AdvancedCharts` | `/markets/advanced-charts` | `AdvancedChartsPage` |
| SC-024 | `sc024TokenUnlocks` | `/markets/unlocks` | `TokenUnlocksPage` |
| SC-025 | `sc025SocialSignals` | `/markets/signals` | `SocialSignalsPage` |
| SC-026 | `sc026MarketCorrelations` | `/markets/correlations` | `MarketCorrelationsPage` |
| SC-044 | `sc044PairDetail` | `/pair/:pairId` | `PairDetailPage` |
| SC-045 | `sc045TokenInfo` | `/pair/:pairId/info` | `TokenInfoPage` |
| SC-046 | `sc046PairDepth` | `/pair/:pairId/depth` | `MarketDepthPage` |

### Prediction Markets (18 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-027 | `sc027PredictionsHome` | `/markets/predictions` | `PredictionsHomePage` |
| SC-028 | `sc028PredictionsSearch` | `/markets/predictions/search` | `PredictionsSearchPage` |
| SC-029 | `sc029PredictionsBreaking` | `/markets/predictions/breaking` | `PredictionsBreakingPage` |
| SC-030 | `sc030PredictionEventDetail` | `/markets/predictions/event/:eventId` | `PredictionEventDetailPage` |
| SC-031 | `sc031PredictionsPortfolio` | `/markets/predictions/portfolio` | `PredictionsPortfolioPage` |
| SC-032 | `sc032PredictionsRewards` | `/markets/predictions/rewards` | `PredictionsRewardsPage` |
| SC-033 | `sc033PredictionsLeaderboard` | `/markets/predictions/leaderboard` | `PredictionsLeaderboardPage` |
| SC-034 | `sc034PredictionsGlobalActivity` | `/markets/predictions/activity` | `PredictionsGlobalActivityPage` |
| SC-035 | `sc035PredictionOrderReceipt` | `/markets/predictions/receipt/:receiptId` | `PredictionOrderReceiptPage` |
| SC-036 | `sc036PredictionRiskCalculator` | `/markets/predictions/risk-calculator` | `PredictionRiskCalculatorPage` |
| SC-037 | `sc037PredictionMarketMaker` | `/markets/predictions/market-maker` | `PredictionMarketMakerPage` |
| SC-038 | `sc038PredictionPortfolioAnalyzer` | `/markets/predictions/portfolio-analyzer` | `PredictionPortfolioAnalyzerPage` |
| SC-039 | `sc039PredictionEventCalendar` | `/markets/predictions/event-calendar` | `PredictionEventCalendarPage` |
| SC-040 | `sc040PredictionSocial` | `/markets/predictions/social` | `PredictionSocialPage` |
| SC-041 | `sc041PredictionAdvancedChart` | `/markets/predictions/advanced-chart/:eventId` | `PredictionAdvancedChartPage` |
| SC-042 | `sc042PredictionTournaments` | `/markets/predictions/tournaments` | `PredictionTournamentsPage` |
| SC-043 | `sc043PredictionDataIntegration` | `/markets/predictions/data-integration` | `PredictionDataIntegrationPage` |
| SC-414 | `sc414PredictionTournamentDetail` | `/markets/predictions/tournament/:tournamentId` | `PredictionTournamentDetailPage` |

### Trading / Bots / Copy / Margin (90 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-048 | `sc048Trade` | `/trade` | `TradePage` |
| SC-049 | `sc049TradePair` | `/trade/:pairId` | `TradePage` |
| SC-050 | `sc050OrdersHistory` | `/trade/orders-history` | `OrdersHistoryPage` |
| SC-051 | `sc051OrderReceipt` | `/trade/order-receipt` | `OrderReceiptPage` |
| SC-052 | `sc052TradeSettings` | `/trade/settings` | `TradeSettingsPage` |
| SC-053 | `sc053PositionDashboard` | `/trade/positions` | `PositionDashboardPage` |
| SC-054 | `sc054TradeHistoryExport` | `/trade/export` | `TradeHistoryExportPage` |
| SC-055 | `sc055AdvancedChart` | `/trade/advanced-chart/:pairId` | `AdvancedChartPage` |
| SC-056 | `sc056Convert` | `/trade/convert` | `ConvertPage` |
| SC-057 | `sc057Futures` | `/trade/:pairId/futures` | `FuturesPage` |
| SC-058 | `sc058Leverage` | `/trade/:pairId/futures/leverage` | `LeveragePage` |
| SC-059 | `sc059TradingBots` | `/trade/bots` | `TradingBotsPage` |
| SC-060 | `sc060RiskManagement` | `/trade/risk-management` | `RiskManagementDemoPage` |
| SC-061 | `sc061ExecutionQuality` | `/trade/execution-quality` | `ExecutionQualityDemoPage` |
| SC-062 | `sc062AdvancedTools` | `/trade/advanced-tools` | `AdvancedToolsDemoPage` |
| SC-063 | `sc063CopyTrading` | `/trade/copy-trading` | `CopyTradingPage` |
| SC-064 | `sc064CopyTradingV2` | `/trade/copy-trading/v2` | `CopyTradingV2Page` |
| SC-065 | `sc065CopyEducation` | `/trade/copy-trading/education` | `CopyEducationPage` |
| SC-066 | `sc066ActiveCopies` | `/trade/copy-trading/active` | `ActiveCopiesPage` |
| SC-067 | `sc067CopySettings` | `/trade/copy-trading/settings` | `CopySettingsPage` |
| SC-068 | `sc068CopyNotifications` | `/trade/copy-trading/notifications` | `CopyNotificationsPage` |
| SC-069 | `sc069ProviderApplication` | `/trade/copy-provider-apply` | `ProviderApplicationPage` |
| SC-070 | `sc070CopyProviderDetail` | `/trade/copy-provider/:providerId` | `CopyProviderDetailPage` |
| SC-071 | `sc071PreCopyAssessment` | `/trade/copy-provider/:providerId/assessment` | `PreCopyAssessmentPage` |
| SC-072 | `sc072CopyConfiguration` | `/trade/copy-provider/:providerId/configuration` | `CopyConfigurationPage` |
| SC-073 | `sc073CopyConfirmation` | `/trade/copy-provider/:providerId/confirmation` | `CopyConfirmationPage` |
| SC-074 | `sc074CopyPerformance` | `/trade/copy-performance/:copyId` | `CopyPerformancePage` |
| SC-075 | `sc075PerformanceAttribution` | `/trade/copy-performance/:copyId/attribution` | `PerformanceAttributionPage` |
| SC-076 | `sc076ProviderComparison` | `/trade/copy-trading/comparison` | `ProviderComparisonPage` |
| SC-077 | `sc077CopyAuditLog` | `/trade/copy-audit-log/:copyId` | `CopyAuditLogPage` |
| SC-078 | `sc078PortfolioRiskAnalysis` | `/trade/copy-trading/risk-analysis` | `PortfolioRiskAnalysisPage` |
| SC-079 | `sc079ProviderLeaderboard` | `/trade/copy-trading/leaderboard` | `ProviderLeaderboardPage` |
| SC-080 | `sc080SafetyEducation` | `/trade/copy-trading/safety` | `SafetyEducationPage` |
| SC-081 | `sc081ProviderGovernance` | `/trade/copy-provider-governance` | `ProviderGovernancePage` |
| SC-082 | `sc082DisputeResolution` | `/trade/copy-dispute-resolution` | `DisputeResolutionPage` |
| SC-083 | `sc083CopySafetyCenter` | `/trade/copy-safety-center` | `CopySafetyCenterPage` |
| SC-084 | `sc084RegulatoryDisclosures` | `/trade/copy-regulatory-disclosures` | `RegulatoryDisclosuresPage` |
| SC-085 | `sc085MarginTrading` | `/trade/margin` | `MarginTradingPage` |
| SC-086 | `sc086MarginTradingPair` | `/trade/margin/btcusdt` | `MarginTradingPage` |
| SC-087 | `sc087TraderProfile` | `/trade/trader/:traderId` | `TraderProfilePage` |
| SC-088 | `sc088AdvancedTradingDemo` | `/trade/margin/advanced-demo` | `AdvancedTradingDemoPage` |
| SC-089 | `sc089MarketDataAnalytics` | `/trade/margin/market-data-analytics` | `MarketDataAnalyticsPage` |
| SC-090 | `sc090MarginTradingHub` | `/trade/margin/hub` | `MarginTradingHubPage` |
| SC-091 | `sc091LiveMarketDataAnalytics` | `/trade/margin/live-market-data-analytics` | `LiveMarketDataAnalyticsPage` |
| SC-092 | `sc092AdvancedAnalytics` | `/trade/margin/advanced-analytics` | `AdvancedAnalyticsPage` |
| SC-093 | `sc093TransactionReporting` | `/trade/copy-trading/transaction-reporting` | `TransactionReportingPage` |
| SC-094 | `sc094RegulatoryReportsDashboard` | `/trade/copy-trading/regulatory-reports-dashboard` | `RegulatoryReportsDashboardPage` |
| SC-095 | `sc095ArmIntegrationStatus` | `/trade/copy-trading/arm-integration-status` | `ArmIntegrationStatusPage` |
| SC-096 | `sc096BestExecutionReports` | `/trade/copy-trading/best-execution-reports` | `BestExecutionReportsPage` |
| SC-097 | `sc097ExecutionVenueAnalysis` | `/trade/copy-trading/execution-venue-analysis` | `ExecutionVenueAnalysisPage` |
| SC-098 | `sc098SlippageMonitoring` | `/trade/copy-trading/slippage-monitoring` | `SlippageMonitoringPage` |
| SC-099 | `sc099ClientCategorization` | `/trade/copy-trading/client-categorization` | `ClientCategorizationPage` |
| SC-100 | `sc100ProductGovernance` | `/trade/copy-trading/product-governance` | `ProductGovernancePage` |
| SC-101 | `sc101TargetMarketDefinition` | `/trade/copy-trading/target-market-definition` | `TargetMarketDefinitionPage` |
| SC-102 | `sc102ClientMoneyProtection` | `/trade/copy-trading/client-money-protection` | `ClientMoneyProtectionPage` |
| SC-103 | `sc103CassReconciliation` | `/trade/copy-trading/cass-reconciliation` | `CassReconciliationPage` |
| SC-104 | `sc104InvestorCompensation` | `/trade/copy-trading/investor-compensation` | `InvestorCompensationPage` |
| SC-105 | `sc105ExAnteCosts` | `/trade/copy-trading/ex-ante-costs` | `ExAnteCostsPage` |
| SC-106 | `sc106RiyCalculator` | `/trade/copy-trading/riy-calculator` | `RIYCalculatorPage` |
| SC-107 | `sc107ExPostCostsReport` | `/trade/copy-trading/ex-post-costs-report` | `ExPostCostsReportPage` |
| SC-108 | `sc108KidGenerator` | `/trade/copy-trading/kid-generator` | `KIDGeneratorPage` |
| SC-109 | `sc109PerformanceScenarios` | `/trade/copy-trading/performance-scenarios` | `PerformanceScenariosPage` |
| SC-110 | `sc110RiskIndicatorExplainer` | `/trade/copy-trading/risk-indicator-explainer` | `RiskIndicatorExplainerPage` |
| SC-111 | `sc111ComplaintsHandling` | `/trade/copy-trading/complaints-handling` | `ComplaintsHandlingPage` |
| SC-112 | `sc112ComplaintSubmission` | `/trade/copy-trading/complaint-submission` | `ComplaintSubmissionPage` |
| SC-113 | `sc113ComplaintTracking` | `/trade/copy-trading/complaint-tracking` | `ComplaintTrackingPage` |
| SC-114 | `sc114OmbudsmanReferral` | `/trade/copy-trading/ombudsman-referral` | `OmbudsmanReferralPage` |
| SC-115 | `sc115AuditTrail` | `/trade/copy-trading/audit-trail` | `AuditTrailPage` |
| SC-116 | `sc116RegulatoryInspectionReady` | `/trade/copy-trading/regulatory-inspection-ready` | `RegulatoryInspectionReadyPage` |
| SC-117 | `sc117BotTermsOfService` | `/trade/bots/terms-of-service` | `BotTermsOfServicePage` |
| SC-118 | `sc118BotRiskDisclosure` | `/trade/bots/risk-disclosure` | `BotRiskDisclosurePage` |
| SC-119 | `sc119BotSuitabilityAssessment` | `/trade/bots/suitability-assessment` | `BotSuitabilityAssessmentPage` |
| SC-120 | `sc120BotRiskDashboard` | `/trade/bots/risk-dashboard` | `BotRiskDashboardPage` |
| SC-121 | `sc121BotEmergencyStop` | `/trade/bots/emergency-stop` | `BotEmergencyStopPage` |
| SC-122 | `sc122BotSecuritySettings` | `/trade/bots/security-settings` | `BotSecuritySettingsPage` |
| SC-123 | `sc123BotHistory` | `/trade/bots/history` | `BotHistoryPage` |
| SC-124 | `sc124BotPerformanceAnalytics` | `/trade/bots/performance-analytics` | `BotPerformanceAnalyticsPage` |
| SC-125 | `sc125BotBacktesting` | `/trade/bots/backtesting` | `BotBacktestingPage` |
| SC-126 | `sc126BotStrategyCompare` | `/trade/bots/strategy-compare` | `BotStrategyComparePage` |
| SC-127 | `sc127BotOptimization` | `/trade/bots/optimization` | `BotOptimizationPage` |
| SC-128 | `sc128BotPortfolioDashboard` | `/trade/bots/portfolio-dashboard` | `BotPortfolioDashboardPage` |
| SC-129 | `sc129BotDrawdownAnalyzer` | `/trade/bots/drawdown-analyzer` | `BotDrawdownAnalyzerPage` |
| SC-130 | `sc130BotEquityCurve` | `/trade/bots/equity-curve` | `BotEquityCurvePage` |
| SC-131 | `sc131BotGuide` | `/trade/bots/guide` | `BotGuidePage` |
| SC-132 | `sc132BotFaq` | `/trade/bots/faq` | `BotFaqPage` |
| SC-133 | `sc133BotTaxReporting` | `/trade/bots/tax-reporting` | `BotTaxReportingPage` |
| SC-134 | `sc134BotApiDocumentation` | `/trade/bots/api-documentation` | `BotApiDocumentationPage` |
| SC-411 | `sc411ClientOptUpRequest` | `/trade/copy-trading/client-opt-up-request` | `ClientOptUpRequestPage` |
| SC-415 | `sc415TargetMarketDefinitionDetail` | `${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId` | `TargetMarketDefinitionPage` |
| SC-416 | `sc416ComplaintTrackingDetail` | `/trade/copy-trading/complaint-tracking/:complaintId` | `ComplaintTrackingPage` |

### P2P Trading (79 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-210 | `sc210P2PExpressConfirm` | `/p2p/express/confirm` | `P2PExpressConfirmPage` |
| SC-211 | `sc211P2PExpress` | `/p2p/express` | `P2PExpressPage` |
| SC-212 | `sc212P2POrderTimeline` | `/p2p/order/timeline/:orderId` | `P2POrderTimelinePage` |
| SC-213 | `sc213P2POrderRate` | `/p2p/order/rate/:orderId` | `P2POrderRatePage` |
| SC-214 | `sc214P2POrderCancel` | `/p2p/order/cancel/:orderId` | `P2POrderCancelPage` |
| SC-215 | `sc215P2POrderProof` | `/p2p/order/proof/:orderId` | `P2POrderProofPage` |
| SC-216 | `sc216P2POrder` | `/p2p/order/:orderId` | `P2POrderPage` |
| SC-217 | `sc217P2PChat` | `/p2p/chat/:orderId` | `P2PChatPage` |
| SC-218 | `sc218P2PDisputeDetail` | `/p2p/dispute/detail/:disputeId` | `P2PDisputeDetailPage` |
| SC-219 | `sc219P2PDisputeEvidence` | `/p2p/dispute/evidence/:disputeId` | `P2PDisputeEvidencePage` |
| SC-220 | `sc220P2PDisputeResolution` | `/p2p/dispute/resolution/:disputeId` | `P2PDisputeResolutionPage` |
| SC-221 | `sc221P2PDispute` | `/p2p/dispute/:orderId` | `P2PDisputePage` |
| SC-222 | `sc222P2PDisputes` | `/p2p/disputes` | `P2PDisputesPage` |
| SC-223 | `sc223P2PAdAnalytics` | `/p2p/ad-analytics/:adId` | `P2PAdAnalyticsPage` |
| SC-224 | `sc224P2PAdDetail` | `/p2p/ad/:adId` | `P2PAdDetailPage` |
| SC-225 | `sc225P2PMyAds` | `/p2p/my-ads` | `P2PMyAdsPage` |
| SC-226 | `sc226P2PCreateAd` | `/p2p/create` | `P2PCreateAdPage` |
| SC-227 | `sc227P2PMerchantApply` | `/p2p/merchant-apply` | `P2PMerchantApplyPage` |
| SC-228 | `sc228P2PMerchantProfile` | `/p2p/merchant/:merchantId` | `P2PMerchantProfilePage` |
| SC-229 | `sc229P2PReportMerchant` | `/p2p/report/:merchantId` | `P2PReportMerchantPage` |
| SC-230 | `sc230P2PTradingLevel` | `/p2p/trading-level` | `P2PTradingLevelPage` |
| SC-231 | `sc231P2PReviews` | `/p2p/reviews` | `P2PReviewsPage` |
| SC-232 | `sc232P2PPaymentMethodAdd` | `/p2p/payment-method/add` | `P2PPaymentMethodAddPage` |
| SC-233 | `sc233P2PPaymentMethodVerification` | `/p2p/payment-method/verification/:methodId` | `P2PPaymentMethodVerificationPage` |
| SC-234 | `sc234P2PPaymentMethodOwnership` | `/p2p/payment-method/ownership/:methodId` | `P2PPaymentMethodOwnershipPage` |
| SC-235 | `sc235P2PPaymentMethodCoolingPeriod` | `/p2p/payment-method/cooling-period` | `P2PPaymentMethodCoolingPeriodPage` |
| SC-236 | `sc236P2PPaymentMethodHistory` | `/p2p/payment-method/history` | `P2PPaymentMethodHistoryPage` |
| SC-237 | `sc237P2PPaymentMethods` | `/p2p/payment-methods` | `P2PPaymentMethodsPage` |
| SC-238 | `sc238P2PInsuranceFund` | `/p2p/insurance` | `P2PInsuranceFundPage` |
| SC-239 | `sc239P2PInsuranceCertificate` | `/p2p/insurance/certificate` | `P2PInsuranceCertificatePage` |
| SC-240 | `sc240P2PInsuranceScore` | `/p2p/insurance/score` | `P2PInsuranceScorePage` |
| SC-241 | `sc241P2PInsurancePolicy` | `/p2p/insurance/policy` | `P2PInsurancePolicyPage` |
| SC-242 | `sc242P2PContributionHistory` | `/p2p/insurance/contribution-history` | `P2PContributionHistoryPage` |
| SC-243 | `sc243P2PClaimDetail` | `/p2p/insurance/claim/:claimId` | `P2PClaimDetailPage` |
| SC-244 | `sc244P2PInsuranceFundAlias` | `/p2p/insurance-fund` | `P2PInsuranceFundPage` |
| SC-245 | `sc245P2PEscrowBalance` | `/p2p/escrow/balance` | `P2PEscrowBalancePage` |
| SC-246 | `sc246P2PEscrowDetail` | `/p2p/escrow/:orderId` | `P2PEscrowDetailPage` |
| SC-247 | `sc247P2PKycRequirements` | `/p2p/kyc/requirements` | `P2PKycRequirementsPage` |
| SC-248 | `sc248P2PKycStatus` | `/p2p/kyc/status` | `P2PKycStatusPage` |
| SC-249 | `sc249P2PIdentityVerification` | `/p2p/kyc/identity` | `P2PIdentityVerificationPage` |
| SC-250 | `sc250P2PAddressProof` | `/p2p/kyc/address` | `P2PAddressProofPage` |
| SC-251 | `sc251P2PSelfieVerification` | `/p2p/kyc/selfie` | `P2PSelfieVerificationPage` |
| SC-252 | `sc252P2PVideoVerification` | `/p2p/kyc/video` | `P2PVideoVerificationPage` |
| SC-253 | `sc253P2PSecurityCenter` | `/p2p/security/center` | `P2PSecurityCenterPage` |
| SC-254 | `sc254P2P2FASettings` | `/p2p/security/2fa` | `P2P2FASettingsPage` |
| SC-255 | `sc255P2PDeviceManagement` | `/p2p/security/devices` | `P2PDeviceManagementPage` |
| SC-256 | `sc256P2PAntiPhishingCode` | `/p2p/security/anti-phishing` | `P2PAntiPhishingCodePage` |
| SC-257 | `sc257P2PLoginHistory` | `/p2p/security/login-history` | `P2PLoginHistoryPage` |
| SC-258 | `sc258P2PSuspiciousActivity` | `/p2p/security/suspicious-activity` | `P2PSuspiciousActivityPage` |
| SC-259 | `sc259P2PE2EInfo` | `/p2p/e2e-info` | `P2PE2EInfoPage` |
| SC-260 | `sc260P2PFraudPrevention` | `/p2p/fraud-prevention` | `P2PFraudPreventionPage` |
| SC-261 | `sc261P2PWalletTransfer` | `/p2p/wallet/transfer` | `P2PWalletTransferPage` |
| SC-262 | `sc262P2PFundLockHistory` | `/p2p/wallet/fund-lock-history` | `P2PFundLockHistoryPage` |
| SC-263 | `sc263P2PWalletHistoryAlias` | `/p2p/wallet/history` | `P2PFundLockHistoryPage` |
| SC-264 | `sc264P2PWallet` | `/p2p/wallet` | `P2PWalletPage` |
| SC-265 | `sc265P2PLimitTracker` | `/p2p/limits/tracker` | `P2PLimitTrackerPage` |
| SC-266 | `sc266P2PTransactionLimits` | `/p2p/limits` | `P2PTransactionLimitsPage` |
| SC-267 | `sc267P2PComplianceOverview` | `/p2p/compliance/overview` | `P2PComplianceOverviewPage` |
| SC-268 | `sc268P2PAmlScreening` | `/p2p/compliance/aml-screening` | `P2PAmlScreeningPage` |
| SC-269 | `sc269P2PSourceOfFunds` | `/p2p/compliance/source-of-funds` | `P2PSourceOfFundsPage` |
| SC-270 | `sc270P2PLargeTransaction` | `/p2p/compliance/large-transaction` | `P2PLargeTransactionJustificationPage` |
| SC-271 | `sc271P2PRiskAssessment` | `/p2p/compliance/risk-assessment` | `P2PRiskAssessmentPage` |
| SC-272 | `sc272P2PTaxReporting` | `/p2p/tax-reporting` | `P2PTaxReportingPage` |
| SC-273 | `sc273P2POrderBook` | `/p2p/order-book` | `P2POrderBookPage` |
| SC-274 | `sc274P2PDashboard` | `/p2p/dashboard` | `P2PDashboardPage` |
| SC-275 | `sc275P2PAchievements` | `/p2p/achievements` | `P2PAchievementsPage` |
| SC-276 | `sc276P2PBlacklistAdd` | `/p2p/blacklist/add` | `P2PBlacklistAddPage` |
| SC-277 | `sc277P2PBlacklist` | `/p2p/blacklist` | `P2PBlacklistPage` |
| SC-278 | `sc278P2PNotificationsSettings` | `/p2p/settings/notifications` | `P2PNotificationsSettingsPage` |
| SC-279 | `sc279P2PSettings` | `/p2p/settings` | `P2PSettingsPage` |
| SC-280 | `sc280P2PGuide` | `/p2p/guide` | `P2PGuidePage` |
| SC-281 | `sc281P2PMyOrders` | `/p2p/my-orders` | `P2PMyOrdersPage` |
| SC-282 | `sc282P2PHome` | `/p2p` | `P2PHomePage` |
| SC-402 | `sc402P2PKycVerify` | `/p2p/kyc/verify` | `P2PIdentityVerificationPage` |
| SC-403 | `sc403P2PKycFaceMatch` | `/p2p/kyc/face-match` | `P2PSelfieVerificationPage` |
| SC-404 | `sc404P2PWhitelistMode` | `/p2p/security/whitelist` | `P2PWhitelistModePage` |
| SC-405 | `sc405SettingsSecurityBiometric` | `/settings/security/biometric` | `SecurityPage` |
| SC-406 | `sc406SettingsSecurityChangePassword` | `/settings/security/change-password` | `SecurityPage` |
| SC-407 | `sc407P2PTaxReportDetail` | `/p2p/tax-report/detailed/:year` | `P2PTaxReportingPage` |

### Open Arena (25 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-184 | `sc184ArenaHome` | `/arena` | `ArenaHomePage` |
| SC-185 | `sc185ArenaStudio` | `/arena/studio` | `ArenaStudioPage` |
| SC-186 | `sc186ArenaSmartRules` | `/arena/studio/smart-rules` | `ArenaSmartRuleBuilderPage` |
| SC-187 | `sc187ArenaPresetLibrary` | `/arena/studio/presets` | `ArenaUniversalPresetLibraryPage` |
| SC-188 | `sc188ArenaGovernanceGate` | `/arena/studio/governance` | `ArenaGovernanceGatePage` |
| SC-189 | `sc189ArenaModeDetail` | `/arena/mode/:modeId` | `ArenaModeDetailPage` |
| SC-190 | `sc190ArenaChallengeDetail` | `/arena/challenge/:challengeId` | `ArenaChallengeDetailPage` |
| SC-191 | `sc191ArenaJoin` | `/arena/join/:challengeId` | `ArenaJoinPage` |
| SC-192 | `sc192ArenaResolutionCenter` | `/arena/resolution` | `ArenaResolutionCenterPage` |
| SC-193 | `sc193ArenaCreator` | `/arena/creator/:creatorId` | `ArenaCreatorPage` |
| SC-194 | `sc194ArenaLeaderboard` | `/arena/leaderboard` | `ArenaLeaderboardPage` |
| SC-195 | `sc195VerifiedChallenges` | `/arena/verified` | `VerifiedChallengesPage` |
| SC-197 | `sc197ArenaFlowMap` | `/arena/flow-map` | `ArenaFlowMapPage` |
| SC-198 | `sc198ArenaSafetyCenter` | `/arena/safety` | `ArenaSafetyCenterPage` |
| SC-199 | `sc199ArenaTrustBreakdown` | `/arena/trust/:userId` | `ArenaTrustBreakdownPage` |
| SC-200 | `sc200ArenaPointsEntryDetail` | `/arena/ledger/entry/:entryId` | `ArenaPointsEntryDetailPage` |
| SC-201 | `sc201ArenaPointsLedger` | `/arena/ledger` | `ArenaPointsLedgerPage` |
| SC-202 | `sc202ArenaReportCase` | `/arena/report/:caseId` | `ArenaReportCasePage` |
| SC-203 | `sc203ArenaBlockedUsers` | `/arena/blocked` | `ArenaBlockedUsersPage` |
| SC-204 | `sc204MyArenaReports` | `/arena/my-reports` | `MyArenaReportsPage` |
| SC-205 | `sc205MyArena` | `/arena/my` | `MyArenaPage` |
| SC-206 | `sc206ArenaProductionReady` | `/arena/production` | `ArenaProductionReadyPage` |
| SC-207 | `sc207ArenaPredictionBridgeFoundation` | `/arena/bridge` | `ArenaPredictionBridgeFoundationPage` |
| SC-208 | `sc208ConnectedEcosystemProduction` | `/arena/ecosystem` | `ConnectedEcosystemProductionPage` |
| SC-209 | `sc209ArenaGuide` | `/arena/guide` | `ArenaGuidePage` |

### Earn / Staking / Savings (70 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-327 | `sc327StakingEarn` | `/earn` | `StakingEarnPage` |
| SC-328 | `sc328StakingEarnStaking` | `/earn/staking` | `StakingEarnPage` |
| SC-329 | `sc329Savings` | `/earn/savings` | `SavingsPage` |
| SC-330 | `sc330SavingsProductDetail` | `/earn/savings/product/sample` | `SavingsProductDetailPage` |
| SC-331 | `sc331SavingsRedeem` | `/earn/savings/redeem/pos001` | `SavingsRedeemPage` |
| SC-332 | `sc332SavingsReceipt` | `/earn/savings/receipt` | `SavingsReceiptPage` |
| SC-333 | `sc333SavingsPortfolio` | `/earn/savings/portfolio` | `SavingsPortfolioPage` |
| SC-334 | `sc334SavingsHistory` | `/earn/savings/history` | `SavingsHistoryPage` |
| SC-335 | `sc335SavingsGuide` | `/earn/savings/guide` | `SavingsGuidePage` |
| SC-336 | `sc336SavingsFAQ` | `/earn/savings/faq` | `SavingsFAQPage` |
| SC-337 | `sc337SavingsNotifications` | `/earn/savings/notifications` | `SavingsNotificationsPage` |
| SC-338 | `sc338SavingsRecommendations` | `/earn/savings/recommendations` | `SavingsRecommendationsPage` |
| SC-339 | `sc339SavingsRiskAssessment` | `/earn/savings/risk-assessment` | `SavingsRiskAssessmentPage` |
| SC-340 | `sc340SavingsComparison` | `/earn/savings/comparison` | `SavingsComparisonPage` |
| SC-341 | `sc341AutoCompoundSettings` | `/earn/savings/auto-compound` | `AutoCompoundSettingsPage` |
| SC-342 | `sc342SavingsGoal` | `/earn/savings/goals` | `SavingsGoalPage` |
| SC-343 | `sc343SavingsAnalytics` | `/earn/savings/analytics` | `SavingsAnalyticsPage` |
| SC-344 | `sc344SavingsAutoRebalance` | `/earn/savings/rebalance` | `SavingsAutoRebalancePage` |
| SC-345 | `sc345SavingsNotificationPreferences` | `/earn/savings/notification-preferences` | `SavingsNotificationPreferencesPage` |
| SC-346 | `sc346SavingsDca` | `/earn/savings/dca` | `SavingsDCAPage` |
| SC-347 | `sc347SavingsSmartSuggestions` | `/earn/savings/smart-suggestions` | `SavingsSmartSuggestionsPage` |
| SC-348 | `sc348SavingsExport` | `/earn/savings/export` | `SavingsExportPage` |
| SC-349 | `sc349SavingsBacktest` | `/earn/savings/backtest` | `SavingsBacktestPage` |
| SC-350 | `sc350SavingsAutoPilot` | `/earn/savings/autopilot` | `SavingsAutoPilotPage` |
| SC-351 | `sc351SavingsLadder` | `/earn/savings/ladder` | `SavingsLadderPage` |
| SC-352 | `sc352SavingsWhatIf` | `/earn/savings/whatif` | `SavingsWhatIfPage` |
| SC-353 | `sc353StakingTerms` | `/earn/staking/terms` | `StakingTermsPage` |
| SC-354 | `sc354StakingRiskDisclosure` | `/earn/staking/risk-disclosure` | `StakingRiskDisclosurePage` |
| SC-355 | `sc355StakingWithdrawalPolicy` | `/earn/staking/withdrawal-policy` | `StakingWithdrawalPolicyPage` |
| SC-356 | `sc356StakingTaxGuide` | `/earn/staking/tax-guide` | `StakingTaxGuidePage` |
| SC-357 | `sc357StakingRiskAssessment` | `/earn/staking/risk-assessment` | `StakingRiskAssessmentPage` |
| SC-358 | `sc358StakingDashboard` | `/earn/dashboard` | `StakingDashboardPage` |
| SC-359 | `sc359StakingAnalytics` | `/earn/analytics` | `StakingAnalyticsPage` |
| SC-360 | `sc360StakingHistory` | `/earn/history` | `StakingHistoryPage` |
| SC-361 | `sc361StakingEarningsCalendar` | `/earn/calendar` | `StakingEarningsCalendarPage` |
| SC-362 | `sc362StakingValidatorSelection` | `/earn/validator-selection` | `StakingValidatorSelectionPage` |
| SC-363 | `sc363StakingAutoCompound` | `/earn/auto-compound` | `StakingAutoCompoundPage` |
| SC-364 | `sc364StakingLiquidStaking` | `/earn/liquid-staking` | `StakingLiquidStakingPage` |
| SC-365 | `sc365StakingInsurance` | `/earn/insurance` | `StakingInsurancePage` |
| SC-366 | `sc366StakingAdvancedOrders` | `/earn/advanced-orders` | `StakingAdvancedOrdersPage` |
| SC-367 | `sc367StakingMultiChain` | `/earn/multi-chain` | `StakingMultiChainPage` |
| SC-368 | `sc368StakingInstitutional` | `/earn/institutional` | `StakingInstitutionalPage` |
| SC-369 | `sc369StakingGuide` | `/earn/guide` | `StakingGuidePage` |
| SC-370 | `sc370StakingFAQ` | `/earn/faq` | `StakingFAQPage` |
| SC-371 | `sc371StakingNotifications` | `/earn/notifications` | `StakingNotificationsPage` |
| SC-372 | `sc372StakingRecommendations` | `/earn/recommendations` | `StakingRecommendationsPage` |
| SC-373 | `sc373StakingRegulatoryFramework` | `/earn/regulatory-framework` | `StakingRegulatoryFrameworkPage` |
| SC-374 | `sc374StakingAuditReports` | `/earn/audit-reports` | `StakingAuditReportsPage` |
| SC-375 | `sc375StakingCustody` | `/earn/custody` | `StakingCustodyPage` |
| SC-376 | `sc376StakingSuitabilityAssessment` | `/earn/suitability-assessment` | `StakingSuitabilityAssessmentPage` |
| SC-377 | `sc377StakingInsuranceFundTransparency` | `/earn/insurance-fund-transparency` | `StakingInsuranceFundTransparencyPage` |
| SC-378 | `sc378StakingTransactionReporting` | `/earn/transaction-reporting` | `StakingTransactionReportingPage` |
| SC-379 | `sc379StakingApiDocumentation` | `/earn/api-documentation` | `StakingApiDocumentationPage` |
| SC-380 | `sc380StakingProofOfReserves` | `/earn/proof-of-reserves` | `StakingProofOfReservesPage` |
| SC-381 | `sc381StakingRiskDashboard` | `/earn/risk-dashboard` | `StakingRiskDashboardPage` |
| SC-382 | `sc382StakingSlashingHistory` | `/earn/slashing-history` | `StakingSlashingHistoryPage` |
| SC-383 | `sc383StakingValidatorHealthMonitor` | `/earn/validator-health-monitor` | `StakingValidatorHealthMonitorPage` |
| SC-384 | `sc384StakingRiskScoreCalculator` | `/earn/risk-score-calculator` | `StakingRiskScoreCalculatorPage` |
| SC-385 | `sc385StakingEmergencyActions` | `/earn/emergency-actions` | `StakingEmergencyActionsPage` |
| SC-386 | `sc386StakingContingencyPlan` | `/earn/contingency-plan` | `StakingContingencyPlanPage` |
| SC-387 | `sc387StakingSocialFeed` | `/earn/social-feed` | `StakingSocialFeedPage` |
| SC-388 | `sc388StakingCommunityGovernance` | `/earn/community-governance` | `StakingCommunityGovernancePage` |
| SC-389 | `sc389StakingProposals` | `/earn/proposals` | `StakingProposalsPage` |
| SC-390 | `sc390StakingVotingDetail` | `/earn/voting/:proposalId` | `StakingVotingPage` |
| SC-391 | `sc391StakingVoting` | `/earn/voting` | `StakingVotingPage` |
| SC-392 | `sc392StakingForum` | `/earn/forum` | `StakingForumPage` |
| SC-393 | `sc393StakingWebhooks` | `/earn/webhooks` | `StakingWebhooksPage` |
| SC-394 | `sc394StakingDataExport` | `/earn/data-export` | `StakingDataExportPage` |
| SC-395 | `sc395StakingThirdPartyIntegrations` | `/earn/third-party-integrations` | `StakingThirdPartyIntegrationsPage` |
| SC-396 | `sc396StakingDeveloperConsole` | `/earn/developer-console` | `StakingDeveloperConsolePage` |

### Launchpad (24 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-295 | `sc295Launchpad` | `/launchpad` | `LaunchpadPage` |
| SC-296 | `sc296LaunchpadPortfolio` | `/launchpad/portfolio` | `LaunchpadPortfolioPage` |
| SC-297 | `sc297LaunchpadPerformance` | `/launchpad/performance` | `LaunchpadPerformancePage` |
| SC-298 | `sc298LaunchpadStaking` | `/launchpad/staking` | `LaunchpadStakingPage` |
| SC-299 | `sc299LaunchpadIdoBridge` | `/launchpad/idobridge/sample` | `LaunchpadIdoBridgePage` |
| SC-300 | `sc300LaunchpadContract` | `/launchpad/contract/sample` | `LaunchpadContractPage` |
| SC-301 | `sc301LaunchpadReceipt` | `/launchpad/receipt/sub001` | `LaunchpadReceiptPage` |
| SC-302 | `sc302LaunchpadClaimReceipt` | `/launchpad/claim-receipt/pos001` | `LaunchpadClaimReceiptPage` |
| SC-303 | `sc303LaunchpadBridgeOrder` | `/launchpad/bridge-order/tx001` | `LaunchpadBridgeOrderPage` |
| SC-304 | `sc304LaunchpadBatchClaim` | `/launchpad/batch-claim` | `LaunchpadBatchClaimPage` |
| SC-305 | `sc305LaunchpadBridgeCompare` | `/launchpad/bridge-compare` | `LaunchpadBridgeComparePage` |
| SC-306 | `sc306LaunchpadNotifSound` | `/launchpad/notif-sound` | `LaunchpadNotifSoundPage` |
| SC-307 | `sc307LaunchpadEventLog` | `/launchpad/event-log` | `LaunchpadEventLogPage` |
| SC-308 | `sc308LaunchpadAbiDiff` | `/launchpad/abi-diff/contract001` | `LaunchpadAbiDiffPage` |
| SC-309 | `sc309LaunchpadAddressBook` | `/launchpad/address-book` | `LaunchpadAddressBookPage` |
| SC-310 | `sc310LaunchpadWebhooks` | `/launchpad/webhooks` | `LaunchpadWebhooksPage` |
| SC-311 | `sc311LaunchpadGasTracker` | `/launchpad/gas-tracker` | `LaunchpadGasTrackerPage` |
| SC-312 | `sc312LaunchpadRebalance` | `/launchpad/rebalance` | `LaunchpadRebalancePage` |
| SC-313 | `sc313LaunchpadMultisig` | `/launchpad/multisig` | `LaunchpadMultisigPage` |
| SC-314 | `sc314LaunchpadSwapAggregator` | `/launchpad/swap-aggregator` | `LaunchpadSwapAggregatorPage` |
| SC-315 | `sc315LaunchpadLimitOrders` | `/launchpad/limit-orders` | `LaunchpadLimitOrdersPage` |
| SC-316 | `sc316LaunchpadDcaBuilder` | `/launchpad/dca-builder` | `LaunchpadDcaBuilderPage` |
| SC-317 | `sc317LaunchpadRiskAnalytics` | `/launchpad/risk-analytics` | `LaunchpadRiskAnalyticsPage` |
| SC-318 | `sc318LaunchpadDetail` | `/launchpad/sample` | `LaunchpadDetailPage` |

### Wallet (21 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-135 | `sc135Wallet` | `/wallet` | `WalletPage` |
| SC-136 | `sc136TxHistory` | `/wallet/history` | `TransactionHistoryPage` |
| SC-137 | `sc137Deposit` | `/wallet/deposit` | `DepositPage` |
| SC-138 | `sc138DepositUsdt` | `${AppRoutePaths.walletDeposit}/:asset` | `DepositPage` |
| SC-139 | `sc139Withdraw` | `/wallet/withdraw` | `WithdrawPage` |
| SC-140 | `sc140WithdrawUsdt` | `${AppRoutePaths.walletWithdraw}/:asset` | `WithdrawPage` |
| SC-141 | `sc141TransactionDetail` | `/wallet/transaction/:txId` | `TransactionDetailPage` |
| SC-142 | `sc142PortfolioAnalytics` | `/wallet/portfolio-analytics` | `PortfolioAnalyticsPage` |
| SC-143 | `sc143AddressAdd` | `/wallet/address-book/add` | `AddressAddPage` |
| SC-144 | `sc144AddressBook` | `/wallet/address-book` | `AddressBookPage` |
| SC-145 | `sc145BuyCrypto` | `/wallet/buy-crypto` | `BuyCryptoPage` |
| SC-146 | `sc146Transfer` | `/wallet/transfer` | `TransferPage` |
| SC-147 | `sc147AssetDetail` | `/wallet/asset/:assetId` | `AssetDetailPage` |
| SC-148 | `sc148MultiManager` | `/wallet/multi-manager` | `WalletMultiManagerPage` |
| SC-149 | `sc149GasOptimizer` | `/wallet/gas-optimizer` | `WalletGasOptimizerPage` |
| SC-150 | `sc150TokenApproval` | `/wallet/token-approval` | `WalletTokenApprovalPage` |
| SC-151 | `sc151HealthScore` | `/wallet/health-score` | `WalletHealthScorePage` |
| SC-152 | `sc152PendingDeposits` | `/wallet/pending-deposits` | `PendingDepositsPage` |
| SC-153 | `sc153WithdrawLimits` | `/wallet/limits` | `WithdrawLimitsPage` |
| SC-154 | `sc154DustConverter` | `/wallet/dust-converter` | `DustConverterPage` |
| SC-155 | `sc155NetworkStatus` | `/wallet/network-status` | `NetworkStatusPage` |

### Profile / Account (14 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-156 | `sc156Profile` | `/profile` | `ProfilePage` |
| SC-157 | `sc157EditProfile` | `/profile/edit` | `EditProfilePage` |
| SC-158 | `sc158Security` | `/profile/security` | `SecurityPage` |
| SC-159 | `sc159Kyc` | `/profile/kyc` | `KYCPage` |
| SC-160 | `sc160Settings` | `/profile/settings` | `SettingsPage` |
| SC-161 | `sc161ActivityLog` | `/profile/activity` | `ActivityLogPage` |
| SC-162 | `sc162ApiKeyCreate` | `/profile/api/create` | `ApiKeyCreatePage` |
| SC-163 | `sc163ApiManagement` | `/profile/api` | `ApiManagementPage` |
| SC-164 | `sc164Vip` | `/profile/vip` | `VIPPage` |
| SC-165 | `sc165DeviceManagement` | `/profile/devices` | `DeviceManagementPage` |
| SC-166 | `sc166SubAccount` | `/profile/sub-accounts` | `SubAccountPage` |
| SC-167 | `sc167ProfilePredictions` | `/profile/predictions` | `PredictionsPortfolioPage` |
| SC-168 | `sc168MyArena` | `/profile/arena` | `MyArenaPage` |
| SC-413 | `sc413SettingsSecurity` | `/settings/security` | `SecurityPage` |

### Admin / Analytics (5 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-180 | `sc180AdminHome` | `/admin` | `AdminHome` |
| SC-181 | `sc181AnalyticsDashboard` | `/admin/analytics` | `AnalyticsDashboard` |
| SC-182 | `sc182AbTestDashboard` | `/admin/abtests` | `ABTestDashboard` |
| SC-183 | `sc183FunnelDashboard` | `/admin/funnels` | `FunnelDashboard` |
| SC-410 | `sc410AdminSettings` | `/admin/settings` | `AdminSettingsPage` |

### DCA / Auto-Invest (13 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-169 | `sc169Dca` | `/dca` | `DCAPage` |
| SC-170 | `sc170DcaRebalanceConfig` | `/dca/rebalance/config` | `DCARebalanceConfig` |
| SC-171 | `sc171DcaRebalanceDashboard` | `/dca/rebalance/config001` | `DCARebalanceDashboard` |
| SC-172 | `sc172DcaScheduleConfig` | `/dca/schedule/config` | `DCAScheduleConfig` |
| SC-173 | `sc173DcaScheduleAnalytics` | `/dca/schedule/config001` | `DCAScheduleAnalytics` |
| SC-174 | `sc174DcaPortfolioOptimizer` | `/dca/portfolio-optimizer` | `DCAPortfolioOptimizer` |
| SC-175 | `sc175DcaDynamicAmount` | `/dca/dynamic-amount` | `DCADynamicAmount` |
| SC-176 | `sc176DcaBacktester` | `/dca/backtester` | `DCABacktesterPage` |
| SC-177 | `sc177DcaMultiAsset` | `/dca/multi-asset` | `DCAMultiAssetPage` |
| SC-178 | `sc178DcaPerformanceCompare` | `/dca/performance-compare` | `DCAPerformanceComparePage` |
| SC-179 | `sc179DcaSmartRules` | `/dca/smart-rules` | `DCASmartRulesPage` |
| SC-408 | `sc408DcaRebalanceEdit` | `/dca/rebalance/:configId/edit` | `DCARebalanceConfig` |
| SC-409 | `sc409DcaRebalanceHistory` | `/dca/rebalance/:configId/history` | `DCARebalanceDashboard` |

### Support (3 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-292 | `sc292HelpCenter` | `/support/help` | `HelpCenterPage` |
| SC-293 | `sc293Announcements` | `/support/announcements` | `AnnouncementsPage` |
| SC-294 | `sc294Support` | `/support` | `SupportPage` |

### Referral (5 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-286 | `sc286ReferralHistory` | `/referral/history` | `ReferralHistoryPage` |
| SC-287 | `sc287ReferralRewards` | `/referral/rewards` | `ReferralRewardsPage` |
| SC-288 | `sc288ReferralRules` | `/referral/rules` | `ReferralRulesPage` |
| SC-289 | `sc289ReferralFriendDetail` | `/referral/friend/:friendId` | `ReferralFriendDetailPage` |
| SC-290 | `sc290ReferralHome` | `/referral` | `ReferralHomePage` |

### Discovery / Search / Topics (3 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-283 | `sc283UnifiedSearch` | `/search` | `UnifiedSearchPage` |
| SC-284 | `sc284TopicHub` | `/topics` | `TopicHubPage` |
| SC-285 | `sc285TopicCrypto` | `/topic/crypto` | `TopicHubPage` |

### Notifications (1 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-291 | `sc291Notifications` | `/notifications` | `NotificationsPage` |

### Rewards Hub (1 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-319 | `sc319RewardsHub` | `/rewards` | `RewardsHubPage` |

### Enterprise / Cross-Module (5 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-320 | `sc320EnterpriseStates` | `/enterprise-states` | `EnterpriseStatesPage` |
| SC-321 | `sc321UnifiedPortfolio` | `/unified-portfolio` | `UnifiedPortfolioDashboard` |
| SC-322 | `sc322CrossModuleAnalytics` | `/cross-module-analytics` | `CrossModuleAnalytics` |
| SC-323 | `sc323SmartAlertCenter` | `/smart-alerts` | `SmartAlertCenter` |
| SC-324 | `sc324TaxReportCenter` | `/tax-reports` | `TaxReportCenter` |

### Dev / QA / Demo Tools (6 screens)

| SC | Route Name | Path | Widget/Page |
| --- | --- | --- | --- |
| SC-325 | `sc325RouteChecker` | `/dev/route-checker` | `RouteChecker` |
| SC-326 | `sc326PerformanceMonitor` | `/dev/performance-monitor` | `PerformanceMonitor` |
| SC-398 | `sc398MissingScreensShowcase` | `/dev/showcase` | `MissingScreensShowcasePage` |
| SC-399 | `sc399DesignSystem` | `/dev/design-system` | `DesignSystemPage` |
| SC-400 | `sc400DcaOverviewDemo` | `/dev/dca-overview` | `DCAOverviewDemo` |
| SC-401 | `sc401CopyTradingCardDemo` | `/demo/copy-card` | `CopyTradingCardDemo` |

