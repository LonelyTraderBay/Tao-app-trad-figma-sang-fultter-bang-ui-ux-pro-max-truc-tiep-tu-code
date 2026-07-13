# All routes (413) — master table

| # | Module file | Path | Page class | EP cha | Phân loại | Menu UI đề xuất |
|--:|-------------|------|------------|--------|-----------|-----------------|
| 1 | `01-home.md` | `AppRoutePaths.home` | `HomePage` | EP-01 | GIỮ | Bottom Nav → Home |
| 2 | `01-home.md` | `AppRoutePaths.news` | `NewsPage` | EP-30 | GIỮ | Home header → Tin tức |
| 3 | `02-auth.md` | `AppRoutePaths.auth2faSetup` | `_AuthRouteShell` | EP-35 | ẨN | — Auth flow (không menu) |
| 4 | `02-auth.md` | `AppRoutePaths.authForgotPassword` | `_AuthRouteShell` | EP-35 | ẨN | — Auth flow (không menu) |
| 5 | `02-auth.md` | `AppRoutePaths.authLogin` | `_AuthRouteShell` | EP-35 | GIỮ | — Auth shell (Login) |
| 6 | `02-auth.md` | `AppRoutePaths.authOtp` | `_AuthRouteShell` | EP-35 | ẨN | — Auth flow (không menu) |
| 7 | `02-auth.md` | `AppRoutePaths.authRegister` | `_AuthRouteShell` | EP-35 | ẨN | — Auth flow (không menu) |
| 8 | `02-auth.md` | `AppRoutePaths.authResetPassword` | `_AuthRouteShell` | EP-35 | ẨN | — Auth flow (không menu) |
| 9 | `02-auth.md` | `AppRoutePaths.onboarding` | `OnboardingFlow` | EP-35 | ẨN | — Auth flow (không menu) |
| 10 | `03-markets.md` | `'/pair/:pairId'` | `PairDetailPage` | EP-25 | ẨN | — Markets → tap cặp |
| 11 | `03-markets.md` | `'/pair/:pairId/depth'` | `MarketDepthPage` | EP-25 | ẨN | — Markets → tap cặp |
| 12 | `03-markets.md` | `'/pair/:pairId/info'` | `TokenInfoPage` | EP-25 | ẨN | — Markets → tap cặp |
| 13 | `03-markets.md` | `AppRoutePaths.markets` | `MarketListPage` | EP-02 | GIỮ | Bottom Nav → Markets |
| 14 | `03-markets.md` | `AppRoutePaths.marketsAdvancedCharts` | `AdvancedChartsPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 15 | `03-markets.md` | `AppRoutePaths.marketsAlerts` | `PriceAlertsPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 16 | `03-markets.md` | `AppRoutePaths.marketsCalendar` | `MarketCalendarPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 17 | `03-markets.md` | `AppRoutePaths.marketsCompare` | `ComparisonToolPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 18 | `03-markets.md` | `AppRoutePaths.marketsCorrelations` | `MarketCorrelationsPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 19 | `03-markets.md` | `AppRoutePaths.marketsDepth` | `MarketDepthPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 20 | `03-markets.md` | `AppRoutePaths.marketsDerivatives` | `DerivativesOverviewPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 21 | `03-markets.md` | `AppRoutePaths.marketsHeatmap` | `MarketHeatmapPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 22 | `03-markets.md` | `AppRoutePaths.marketsMovers` | `MarketMoversPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 23 | `03-markets.md` | `AppRoutePaths.marketsNews` | `MarketNewsPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 24 | `03-markets.md` | `AppRoutePaths.marketsOverview` | `MarketOverviewPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 25 | `03-markets.md` | `AppRoutePaths.marketsPortfolioTracker` | `PortfolioTrackerPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 26 | `03-markets.md` | `AppRoutePaths.marketsScreener` | `MarketScreenerPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 27 | `03-markets.md` | `AppRoutePaths.marketsSectors` | `MarketSectorsPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 28 | `03-markets.md` | `AppRoutePaths.marketsSignals` | `SocialSignalsPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 29 | `03-markets.md` | `AppRoutePaths.marketsSocialSentiment` | `SocialSentimentPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 30 | `03-markets.md` | `AppRoutePaths.marketsUnlocks` | `TokenUnlocksPage` | EP-02 | ẨN | — Flow / deep link (không menu) |
| 31 | `03-markets.md` | `AppRoutePaths.marketsWatchlist` | `WatchlistPage` | EP-02 | HUB | Markets hub → Công cụ & danh sách |
| 32 | `04-trade.md` | `'/trade/:pairId'` | `TradePage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 33 | `04-trade.md` | `'/trade/:pairId/futures'` | `FuturesPage` | EP-10 | ẨN | — Trade → chọn cặp Futures |
| 34 | `04-trade.md` | `'/trade/:pairId/futures/leverage'` | `LeveragePage` | EP-10 | ẨN | — Trade → chọn cặp Futures |
| 35 | `04-trade.md` | `'/trade/advanced-chart/:pairId'` | `AdvancedChartPage` | EP-03 | HUB | Trade hub → Công cụ Spot |
| 36 | `04-trade.md` | `'/trade/copy-audit-log/:copyId'` | `CopyAuditLogPage` | EP-13 | GOM | Copy hub → Tuân thủ & audit |
| 37 | `04-trade.md` | `'/trade/copy-performance/:copyId'` | `CopyPerformancePage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 38 | `04-trade.md` | `'/trade/copy-performance/:copyId/attribution'` | `PerformanceAttributionPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 39 | `04-trade.md` | `'/trade/copy-provider/:providerId'` | `CopyProviderDetailPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 40 | `04-trade.md` | `'/trade/copy-provider/:providerId/assessment'` | `PreCopyAssessmentPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 41 | `04-trade.md` | `'/trade/copy-provider/:providerId/configuration'` | `CopyConfigurationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 42 | `04-trade.md` | `'/trade/copy-provider/:providerId/confirmation'` | `CopyConfirmationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 43 | `04-trade.md` | `'/trade/trader/:traderId'` | `TraderProfilePage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 44 | `04-trade.md` | `AppRoutePaths.trade` | `TradePage` | EP-03 | GIỮ | Bottom Nav → Trade |
| 45 | `04-trade.md` | `AppRoutePaths.tradeAdvancedTools` | `AdvancedToolsDemoPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 46 | `04-trade.md` | `AppRoutePaths.tradeBotApiDocumentation` | `BotApiDocumentationPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 47 | `04-trade.md` | `AppRoutePaths.tradeBotBacktesting` | `BotBacktestingPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 48 | `04-trade.md` | `AppRoutePaths.tradeBotDrawdownAnalyzer` | `BotDrawdownAnalyzerPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 49 | `04-trade.md` | `AppRoutePaths.tradeBotEmergencyStop` | `BotEmergencyStopPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 50 | `04-trade.md` | `AppRoutePaths.tradeBotEquityCurve` | `BotEquityCurvePage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 51 | `04-trade.md` | `AppRoutePaths.tradeBotFaq` | `BotFaqPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 52 | `04-trade.md` | `AppRoutePaths.tradeBotGuide` | `BotGuidePage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 53 | `04-trade.md` | `AppRoutePaths.tradeBotHistory` | `BotHistoryPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 54 | `04-trade.md` | `AppRoutePaths.tradeBotOptimization` | `BotOptimizationPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 55 | `04-trade.md` | `AppRoutePaths.tradeBotPerformanceAnalytics` | `BotPerformanceAnalyticsPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 56 | `04-trade.md` | `AppRoutePaths.tradeBotPortfolioDashboard` | `BotPortfolioDashboardPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 57 | `04-trade.md` | `AppRoutePaths.tradeBotRiskDashboard` | `BotRiskDashboardPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 58 | `04-trade.md` | `AppRoutePaths.tradeBotRiskDisclosure` | `BotRiskDisclosurePage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 59 | `04-trade.md` | `AppRoutePaths.tradeBots` | `TradingBotsPage` | EP-14 | GIỮ | Home → Sản phẩm Pro (Bot) |
| 60 | `04-trade.md` | `AppRoutePaths.tradeBotSecuritySettings` | `BotSecuritySettingsPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 61 | `04-trade.md` | `AppRoutePaths.tradeBotStrategyCompare` | `BotStrategyComparePage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 62 | `04-trade.md` | `AppRoutePaths.tradeBotSuitabilityAssessment` | `BotSuitabilityAssessmentPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 63 | `04-trade.md` | `AppRoutePaths.tradeBotTaxReporting` | `BotTaxReportingPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 64 | `04-trade.md` | `AppRoutePaths.tradeBotTermsOfService` | `BotTermsOfServicePage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 65 | `04-trade.md` | `AppRoutePaths.tradeConvert` | `ConvertPage` | EP-12 | GIỮ | Home → Sản phẩm Giao dịch |
| 66 | `04-trade.md` | `AppRoutePaths.tradeCopyActive` | `ActiveCopiesPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 67 | `04-trade.md` | `AppRoutePaths.tradeCopyComparison` | `ProviderComparisonPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 68 | `04-trade.md` | `AppRoutePaths.tradeCopyDisputeResolution` | `DisputeResolutionPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 69 | `04-trade.md` | `AppRoutePaths.tradeCopyEducation` | `CopyEducationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 70 | `04-trade.md` | `AppRoutePaths.tradeCopyLeaderboard` | `ProviderLeaderboardPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 71 | `04-trade.md` | `AppRoutePaths.tradeCopyNotifications` | `CopyNotificationsPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 72 | `04-trade.md` | `AppRoutePaths.tradeCopyProviderApply` | `ProviderApplicationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 73 | `04-trade.md` | `AppRoutePaths.tradeCopyProviderGovernance` | `ProviderGovernancePage` | EP-13 | GOM | Copy hub → Tuân thủ & audit |
| 74 | `04-trade.md` | `AppRoutePaths.tradeCopyRiskAnalysis` | `PortfolioRiskAnalysisPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 75 | `04-trade.md` | `AppRoutePaths.tradeCopySafety` | `SafetyEducationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 76 | `04-trade.md` | `AppRoutePaths.tradeCopySafetyCenter` | `CopySafetyCenterPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 77 | `04-trade.md` | `AppRoutePaths.tradeCopySettings` | `CopySettingsPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 78 | `04-trade.md` | `AppRoutePaths.tradeCopyTrading` | `CopyTradingPage` | EP-13 | GIỮ | Home → Sản phẩm Pro (Copy) |
| 79 | `04-trade.md` | `AppRoutePaths.tradeExecutionQuality` | `ExecutionQualityDemoPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 80 | `04-trade.md` | `AppRoutePaths.tradeExport` | `TradeHistoryExportPage` | EP-03 | HUB | Trade hub → Công cụ Spot |
| 81 | `04-trade.md` | `AppRoutePaths.tradeMargin` | `MarginTradingPage` | EP-11 | GIỮ | Trade tab + Home → Sản phẩm Giao dịch |
| 82 | `04-trade.md` | `AppRoutePaths.tradeMarginAdvancedAnalytics` | `AdvancedAnalyticsPage` | EP-11 | HUB | Margin hub → Công cụ |
| 83 | `04-trade.md` | `AppRoutePaths.tradeMarginAdvancedDemo` | `AdvancedTradingDemoPage` | EP-11 | ẨN | — Flow / deep link (không menu) |
| 84 | `04-trade.md` | `AppRoutePaths.tradeMarginBtcusdt` | `MarginTradingPage` | EP-11 | ẨN | — Flow / deep link (không menu) |
| 85 | `04-trade.md` | `AppRoutePaths.tradeMarginHub` | `MarginTradingHubPage` | EP-11 | HUB | Margin hub → Công cụ |
| 86 | `04-trade.md` | `AppRoutePaths.tradeOrderReceipt` | `OrderReceiptPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 87 | `04-trade.md` | `AppRoutePaths.tradeOrdersHistory` | `OrdersHistoryPage` | EP-26 | GIỮ | Trade hub → Lệnh & lịch sử |
| 88 | `04-trade.md` | `AppRoutePaths.tradePositions` | `PositionDashboardPage` | EP-27 | GIỮ | Trade hub → Vị thế |
| 89 | `04-trade.md` | `AppRoutePaths.tradeRiskManagement` | `RiskManagementDemoPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 90 | `04-trade.md` | `AppRoutePaths.tradeSettings` | `TradeSettingsPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 91 | `05-trade-compliance.md` | `'${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId'` | `TargetMarketDefinitionPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 92 | `05-trade-compliance.md` | `'/trade/copy-trading/complaint-tracking/:complaintId'` | `ComplaintTrackingPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 93 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyArmIntegrationStatus` | `ArmIntegrationStatusPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 94 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyAuditTrail` | `AuditTrailPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 95 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyBestExecutionReports` | `BestExecutionReportsPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 96 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyCassReconciliation` | `CassReconciliationPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 97 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyClientCategorization` | `ClientCategorizationPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 98 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyClientMoneyProtection` | `ClientMoneyProtectionPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 99 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyClientOptUpRequest` | `ClientOptUpRequestPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 100 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyComplaintsHandling` | `ComplaintsHandlingPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 101 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyComplaintSubmission` | `ComplaintSubmissionPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 102 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyComplaintTrackingBase` | `ComplaintTrackingPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 103 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyExAnteCosts` | `ExAnteCostsPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 104 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyExecutionVenueAnalysis` | `ExecutionVenueAnalysisPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 105 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyExPostCostsReport` | `ExPostCostsReportPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 106 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyInvestorCompensation` | `InvestorCompensationPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 107 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyKidGenerator` | `KIDGeneratorPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 108 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyOmbudsmanReferral` | `OmbudsmanReferralPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 109 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyPerformanceScenarios` | `PerformanceScenariosPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 110 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyProductGovernance` | `ProductGovernancePage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 111 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyRegulatoryDisclosures` | `RegulatoryDisclosuresPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 112 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyRegulatoryInspectionReady` | `RegulatoryInspectionReadyPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 113 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyRegulatoryReportsDashboard` | `RegulatoryReportsDashboardPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 114 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyRiskIndicatorExplainer` | `RiskIndicatorExplainerPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 115 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyRiyCalculator` | `RIYCalculatorPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 116 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopySlippageMonitoring` | `SlippageMonitoringPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 117 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyTargetMarketDefinition` | `TargetMarketDefinitionPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 118 | `05-trade-compliance.md` | `AppRoutePaths.tradeCopyTransactionReporting` | `TransactionReportingPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 119 | `05-trade-compliance.md` | `AppRoutePaths.tradeMarginLiveMarketDataAnalytics` | `LiveMarketDataAnalyticsPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 120 | `05-trade-compliance.md` | `AppRoutePaths.tradeMarginMarketDataAnalytics` | `MarketDataAnalyticsPage` | EP-13 | GOM | Profile → Pháp lý & báo cáo |
| 121 | `06-earn.md` | `AppRoutePaths.earn` | `StakingEarnPage` | EP-15 | GIỮ | Home → Sản phẩm Sinh lời (Staking) |
| 122 | `06-earn.md` | `AppRoutePaths.earnAdvancedOrders` | `StakingAdvancedOrdersPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 123 | `06-earn.md` | `AppRoutePaths.earnAnalytics` | `StakingAnalyticsPage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 124 | `06-earn.md` | `AppRoutePaths.earnApiDocumentation` | `StakingApiDocumentationPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 125 | `06-earn.md` | `AppRoutePaths.earnAuditReports` | `StakingAuditReportsPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 126 | `06-earn.md` | `AppRoutePaths.earnAutoCompound` | `StakingAutoCompoundPage` | EP-15 | ẨN | — Flow / deep link (không menu) |
| 127 | `06-earn.md` | `AppRoutePaths.earnCalendar` | `StakingEarningsCalendarPage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 128 | `06-earn.md` | `AppRoutePaths.earnCommunityGovernance` | `StakingCommunityGovernancePage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 129 | `06-earn.md` | `AppRoutePaths.earnContingencyPlan` | `StakingContingencyPlanPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 130 | `06-earn.md` | `AppRoutePaths.earnCustody` | `StakingCustodyPage` | EP-15 | ẨN | — Flow / deep link (không menu) |
| 131 | `06-earn.md` | `AppRoutePaths.earnDashboard` | `StakingDashboardPage` | EP-28 | GIỮ | Earn hub → Staking dashboard |
| 132 | `06-earn.md` | `AppRoutePaths.earnDataExport` | `StakingDataExportPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 133 | `06-earn.md` | `AppRoutePaths.earnDeveloperConsole` | `StakingDeveloperConsolePage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 134 | `06-earn.md` | `AppRoutePaths.earnEmergencyActions` | `StakingEmergencyActionsPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 135 | `06-earn.md` | `AppRoutePaths.earnFAQ` | `StakingFAQPage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 136 | `06-earn.md` | `AppRoutePaths.earnForum` | `StakingForumPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 137 | `06-earn.md` | `AppRoutePaths.earnGuide` | `StakingGuidePage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 138 | `06-earn.md` | `AppRoutePaths.earnHistory` | `StakingHistoryPage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 139 | `06-earn.md` | `AppRoutePaths.earnInstitutional` | `StakingInstitutionalPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 140 | `06-earn.md` | `AppRoutePaths.earnInsurance` | `StakingInsurancePage` | EP-15 | ẨN | — Flow / deep link (không menu) |
| 141 | `06-earn.md` | `AppRoutePaths.earnInsuranceFundTransparency` | `StakingInsuranceFundTransparencyPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 142 | `06-earn.md` | `AppRoutePaths.earnLiquidStaking` | `StakingLiquidStakingPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 143 | `06-earn.md` | `AppRoutePaths.earnMultiChain` | `StakingMultiChainPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 144 | `06-earn.md` | `AppRoutePaths.earnNotifications` | `StakingNotificationsPage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 145 | `06-earn.md` | `AppRoutePaths.earnProofOfReserves` | `StakingProofOfReservesPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 146 | `06-earn.md` | `AppRoutePaths.earnProposals` | `StakingProposalsPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 147 | `06-earn.md` | `AppRoutePaths.earnRecommendations` | `StakingRecommendationsPage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 148 | `06-earn.md` | `AppRoutePaths.earnRegulatoryFramework` | `StakingRegulatoryFrameworkPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 149 | `06-earn.md` | `AppRoutePaths.earnRiskDashboard` | `StakingRiskDashboardPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 150 | `06-earn.md` | `AppRoutePaths.earnRiskScoreCalculator` | `StakingRiskScoreCalculatorPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 151 | `06-earn.md` | `AppRoutePaths.earnSavings` | `SavingsPage` | EP-16 | GIỮ | Home → Sản phẩm Sinh lời (Tiết kiệm) |
| 152 | `06-earn.md` | `AppRoutePaths.earnSavingsAnalytics` | `SavingsAnalyticsPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 153 | `06-earn.md` | `AppRoutePaths.earnSavingsAutoCompound` | `AutoCompoundSettingsPage` | EP-16 | ẨN | — Flow / deep link (không menu) |
| 154 | `06-earn.md` | `AppRoutePaths.earnSavingsAutoPilot` | `SavingsAutoPilotPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 155 | `06-earn.md` | `AppRoutePaths.earnSavingsBacktest` | `SavingsBacktestPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 156 | `06-earn.md` | `AppRoutePaths.earnSavingsComparison` | `SavingsComparisonPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 157 | `06-earn.md` | `AppRoutePaths.earnSavingsDca` | `SavingsDCAPage` | EP-16 | ẨN | — Flow / deep link (không menu) |
| 158 | `06-earn.md` | `AppRoutePaths.earnSavingsExport` | `SavingsExportPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 159 | `06-earn.md` | `AppRoutePaths.earnSavingsFAQ` | `SavingsFAQPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 160 | `06-earn.md` | `AppRoutePaths.earnSavingsGoals` | `SavingsGoalPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 161 | `06-earn.md` | `AppRoutePaths.earnSavingsGuide` | `SavingsGuidePage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 162 | `06-earn.md` | `AppRoutePaths.earnSavingsHistory` | `SavingsHistoryPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 163 | `06-earn.md` | `AppRoutePaths.earnSavingsLadder` | `SavingsLadderPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 164 | `06-earn.md` | `AppRoutePaths.earnSavingsNotificationPreferences` | `SavingsNotificationPreferencesPage` | EP-16 | ẨN | — Flow / deep link (không menu) |
| 165 | `06-earn.md` | `AppRoutePaths.earnSavingsNotifications` | `SavingsNotificationsPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 166 | `06-earn.md` | `AppRoutePaths.earnSavingsPortfolio` | `SavingsPortfolioPage` | EP-29 | GIỮ | Savings hub → Portfolio |
| 167 | `06-earn.md` | `AppRoutePaths.earnSavingsProductSample` | `SavingsProductDetailPage` | EP-16 | ẨN | — Flow / deep link (không menu) |
| 168 | `06-earn.md` | `AppRoutePaths.earnSavingsRebalance` | `SavingsAutoRebalancePage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 169 | `06-earn.md` | `AppRoutePaths.earnSavingsReceipt` | `SavingsReceiptPage` | EP-16 | ẨN | — Flow / deep link (không menu) |
| 170 | `06-earn.md` | `AppRoutePaths.earnSavingsRecommendations` | `SavingsRecommendationsPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 171 | `06-earn.md` | `AppRoutePaths.earnSavingsRedeemPos001` | `SavingsRedeemPage` | EP-16 | ẨN | — Flow / deep link (không menu) |
| 172 | `06-earn.md` | `AppRoutePaths.earnSavingsRiskAssessment` | `SavingsRiskAssessmentPage` | EP-16 | ẨN | — Flow / deep link (không menu) |
| 173 | `06-earn.md` | `AppRoutePaths.earnSavingsSmartSuggestions` | `SavingsSmartSuggestionsPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 174 | `06-earn.md` | `AppRoutePaths.earnSavingsWhatIf` | `SavingsWhatIfPage` | EP-16 | HUB | Savings hub → Công cụ (tile/tab) |
| 175 | `06-earn.md` | `AppRoutePaths.earnSlashingHistory` | `StakingSlashingHistoryPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 176 | `06-earn.md` | `AppRoutePaths.earnSocialFeed` | `StakingSocialFeedPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 177 | `06-earn.md` | `AppRoutePaths.earnStaking` | `StakingEarnPage` | EP-15 | HUB | Earn hub → Staking (tile/tab) |
| 178 | `06-earn.md` | `AppRoutePaths.earnStakingRiskAssessment` | `StakingRiskAssessmentPage` | EP-15 | ẨN | — Flow / deep link (không menu) |
| 179 | `06-earn.md` | `AppRoutePaths.earnStakingRiskDisclosure` | `StakingRiskDisclosurePage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 180 | `06-earn.md` | `AppRoutePaths.earnStakingTaxGuide` | `StakingTaxGuidePage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 181 | `06-earn.md` | `AppRoutePaths.earnStakingTerms` | `StakingTermsPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 182 | `06-earn.md` | `AppRoutePaths.earnStakingWithdrawalPolicy` | `StakingWithdrawalPolicyPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 183 | `06-earn.md` | `AppRoutePaths.earnSuitabilityAssessment` | `StakingSuitabilityAssessmentPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 184 | `06-earn.md` | `AppRoutePaths.earnThirdPartyIntegrations` | `StakingThirdPartyIntegrationsPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 185 | `06-earn.md` | `AppRoutePaths.earnTransactionReporting` | `StakingTransactionReportingPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 186 | `06-earn.md` | `AppRoutePaths.earnValidatorHealthMonitor` | `StakingValidatorHealthMonitorPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 187 | `06-earn.md` | `AppRoutePaths.earnValidatorSelection` | `StakingValidatorSelectionPage` | EP-15 | ẨN | — Flow / deep link (không menu) |
| 188 | `06-earn.md` | `AppRoutePaths.earnVoting` | `StakingVotingPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 189 | `06-earn.md` | `AppRoutePaths.earnVotingProposalRoute` | `StakingVotingPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 190 | `06-earn.md` | `AppRoutePaths.earnWebhooks` | `StakingWebhooksPage` | EP-15 | GOM | Earn → Tài liệu & rủi ro |
| 191 | `07-wallet.md` | `'${AppRoutePaths.walletDeposit}/:asset'` | `DepositPage` | EP-08 | ẨN | — Wallet flow (chọn asset) |
| 192 | `07-wallet.md` | `'${AppRoutePaths.walletWithdraw}/:asset'` | `WithdrawPage` | EP-09 | ẨN | — Wallet flow (chọn asset) |
| 193 | `07-wallet.md` | `'/wallet/asset/:assetId'` | `AssetDetailPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 194 | `07-wallet.md` | `'/wallet/transaction/:txId'` | `TransactionDetailPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 195 | `07-wallet.md` | `AppRoutePaths.wallet` | `WalletPage` | EP-04 | GIỮ | Bottom Nav → Wallet |
| 196 | `07-wallet.md` | `AppRoutePaths.walletAddressBook` | `AddressBookPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 197 | `07-wallet.md` | `AppRoutePaths.walletAddressBookAdd` | `AddressAddPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 198 | `07-wallet.md` | `AppRoutePaths.walletBuyCrypto` | `BuyCryptoPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 199 | `07-wallet.md` | `AppRoutePaths.walletDeposit` | `DepositPage` | EP-08 | GIỮ | Home Hero + Wallet → Nạp |
| 200 | `07-wallet.md` | `AppRoutePaths.walletDustConverter` | `DustConverterPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 201 | `07-wallet.md` | `AppRoutePaths.walletGasOptimizer` | `WalletGasOptimizerPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 202 | `07-wallet.md` | `AppRoutePaths.walletHealthScore` | `WalletHealthScorePage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 203 | `07-wallet.md` | `AppRoutePaths.walletHistory` | `TransactionHistoryPage` | EP-04 | HUB | Wallet hub → Dịch vụ ví |
| 204 | `07-wallet.md` | `AppRoutePaths.walletLimits` | `WithdrawLimitsPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 205 | `07-wallet.md` | `AppRoutePaths.walletMultiManager` | `WalletMultiManagerPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 206 | `07-wallet.md` | `AppRoutePaths.walletNetworkStatus` | `NetworkStatusPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 207 | `07-wallet.md` | `AppRoutePaths.walletPendingDeposits` | `PendingDepositsPage` | EP-08 | ẨN | — Flow / deep link (không menu) |
| 208 | `07-wallet.md` | `AppRoutePaths.walletPortfolioAnalytics` | `PortfolioAnalyticsPage` | EP-04 | HUB | Wallet hub → Dịch vụ ví |
| 209 | `07-wallet.md` | `AppRoutePaths.walletTokenApproval` | `WalletTokenApprovalPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 210 | `07-wallet.md` | `AppRoutePaths.walletTransfer` | `TransferPage` | EP-04 | ẨN | — Flow / deep link (không menu) |
| 211 | `07-wallet.md` | `AppRoutePaths.walletWithdraw` | `WithdrawPage` | EP-09 | GIỮ | Home Next action + Wallet → Rút |
| 212 | `08-p2p.md` | `'/p2p/ad/:adId'` | `P2PAdDetailPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 213 | `08-p2p.md` | `'/p2p/ad-analytics/:adId'` | `P2PAdAnalyticsPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 214 | `08-p2p.md` | `'/p2p/chat/:orderId'` | `P2PChatPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 215 | `08-p2p.md` | `'/p2p/dispute/:orderId'` | `P2PDisputePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 216 | `08-p2p.md` | `'/p2p/dispute/detail/:disputeId'` | `P2PDisputeDetailPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 217 | `08-p2p.md` | `'/p2p/dispute/evidence/:disputeId'` | `P2PDisputeEvidencePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 218 | `08-p2p.md` | `'/p2p/dispute/resolution/:disputeId'` | `P2PDisputeResolutionPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 219 | `08-p2p.md` | `'/p2p/escrow/:orderId'` | `P2PEscrowDetailPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 220 | `08-p2p.md` | `'/p2p/insurance/claim/:claimId'` | `P2PClaimDetailPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 221 | `08-p2p.md` | `'/p2p/merchant/:merchantId'` | `P2PMerchantProfilePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 222 | `08-p2p.md` | `'/p2p/order/:orderId'` | `P2POrderPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 223 | `08-p2p.md` | `'/p2p/order/cancel/:orderId'` | `P2POrderCancelPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 224 | `08-p2p.md` | `'/p2p/order/proof/:orderId'` | `P2POrderProofPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 225 | `08-p2p.md` | `'/p2p/order/rate/:orderId'` | `P2POrderRatePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 226 | `08-p2p.md` | `'/p2p/order/timeline/:orderId'` | `P2POrderTimelinePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 227 | `08-p2p.md` | `'/p2p/payment-method/ownership/:methodId'` | `P2PPaymentMethodOwnershipPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 228 | `08-p2p.md` | `'/p2p/payment-method/verification/:methodId'` | `P2PPaymentMethodVerificationPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 229 | `08-p2p.md` | `'/p2p/report/:merchantId'` | `P2PReportMerchantPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 230 | `08-p2p.md` | `'/p2p/tax-report/detailed/:year'` | `P2PTaxReportingPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 231 | `08-p2p.md` | `AppRoutePaths.p2p` | `P2PHomePage` | EP-17 | GIỮ | Home → Sản phẩm Giao dịch (P2P) |
| 232 | `08-p2p.md` | `AppRoutePaths.p2pAchievements` | `P2PAchievementsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 233 | `08-p2p.md` | `AppRoutePaths.p2pBlacklist` | `P2PBlacklistPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 234 | `08-p2p.md` | `AppRoutePaths.p2pBlacklistAdd` | `P2PBlacklistAddPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 235 | `08-p2p.md` | `AppRoutePaths.p2pComplianceAmlScreening` | `P2PAmlScreeningPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 236 | `08-p2p.md` | `AppRoutePaths.p2pComplianceLargeTransaction` | `P2PLargeTransactionJustificationPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 237 | `08-p2p.md` | `AppRoutePaths.p2pComplianceOverview` | `P2PComplianceOverviewPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 238 | `08-p2p.md` | `AppRoutePaths.p2pComplianceRiskAssessment` | `P2PRiskAssessmentPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 239 | `08-p2p.md` | `AppRoutePaths.p2pComplianceSourceOfFunds` | `P2PSourceOfFundsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 240 | `08-p2p.md` | `AppRoutePaths.p2pContributionHistory` | `P2PContributionHistoryPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 241 | `08-p2p.md` | `AppRoutePaths.p2pCreate` | `P2PCreateAdPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 242 | `08-p2p.md` | `AppRoutePaths.p2pDashboard` | `P2PDashboardPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 243 | `08-p2p.md` | `AppRoutePaths.p2pDisputes` | `P2PDisputesPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 244 | `08-p2p.md` | `AppRoutePaths.p2pE2EInfo` | `P2PE2EInfoPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 245 | `08-p2p.md` | `AppRoutePaths.p2pEscrowBalance` | `P2PEscrowBalancePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 246 | `08-p2p.md` | `AppRoutePaths.p2pExpress` | `P2PExpressPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 247 | `08-p2p.md` | `AppRoutePaths.p2pExpressConfirm` | `P2PExpressConfirmPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 248 | `08-p2p.md` | `AppRoutePaths.p2pFraudPrevention` | `P2PFraudPreventionPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 249 | `08-p2p.md` | `AppRoutePaths.p2pGuide` | `P2PGuidePage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 250 | `08-p2p.md` | `AppRoutePaths.p2pInsurance` | `P2PInsuranceFundPage` | EP-17 | GOM | Profile → Pháp lý & báo cáo |
| 251 | `08-p2p.md` | `AppRoutePaths.p2pInsuranceCertificate` | `P2PInsuranceCertificatePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 252 | `08-p2p.md` | `AppRoutePaths.p2pInsuranceFundAlias` | `P2PInsuranceFundPage` | EP-17 | GOM | Profile → Pháp lý & báo cáo |
| 253 | `08-p2p.md` | `AppRoutePaths.p2pInsurancePolicy` | `P2PInsurancePolicyPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 254 | `08-p2p.md` | `AppRoutePaths.p2pInsuranceScore` | `P2PInsuranceScorePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 255 | `08-p2p.md` | `AppRoutePaths.p2pKycAddress` | `P2PAddressProofPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 256 | `08-p2p.md` | `AppRoutePaths.p2pKycFaceMatch` | `P2PSelfieVerificationPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 257 | `08-p2p.md` | `AppRoutePaths.p2pKycIdentity` | `P2PIdentityVerificationPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 258 | `08-p2p.md` | `AppRoutePaths.p2pKycRequirements` | `P2PKycRequirementsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 259 | `08-p2p.md` | `AppRoutePaths.p2pKycSelfie` | `P2PSelfieVerificationPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 260 | `08-p2p.md` | `AppRoutePaths.p2pKycStatus` | `P2PKycStatusPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 261 | `08-p2p.md` | `AppRoutePaths.p2pKycVerify` | `P2PIdentityVerificationPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 262 | `08-p2p.md` | `AppRoutePaths.p2pKycVideo` | `P2PVideoVerificationPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 263 | `08-p2p.md` | `AppRoutePaths.p2pLimits` | `P2PTransactionLimitsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 264 | `08-p2p.md` | `AppRoutePaths.p2pLimitsTracker` | `P2PLimitTrackerPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 265 | `08-p2p.md` | `AppRoutePaths.p2pMerchantApply` | `P2PMerchantApplyPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 266 | `08-p2p.md` | `AppRoutePaths.p2pMyAds` | `P2PMyAdsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 267 | `08-p2p.md` | `AppRoutePaths.p2pMyOrders` | `P2PMyOrdersPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 268 | `08-p2p.md` | `AppRoutePaths.p2pOrderBook` | `P2POrderBookPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 269 | `08-p2p.md` | `AppRoutePaths.p2pPaymentMethodAdd` | `P2PPaymentMethodAddPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 270 | `08-p2p.md` | `AppRoutePaths.p2pPaymentMethodCoolingPeriod` | `P2PPaymentMethodCoolingPeriodPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 271 | `08-p2p.md` | `AppRoutePaths.p2pPaymentMethodHistory` | `P2PPaymentMethodHistoryPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 272 | `08-p2p.md` | `AppRoutePaths.p2pPaymentMethods` | `P2PPaymentMethodsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 273 | `08-p2p.md` | `AppRoutePaths.p2pReviews` | `P2PReviewsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 274 | `08-p2p.md` | `AppRoutePaths.p2pSecurity2fa` | `P2P2FASettingsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 275 | `08-p2p.md` | `AppRoutePaths.p2pSecurityAntiPhishing` | `P2PAntiPhishingCodePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 276 | `08-p2p.md` | `AppRoutePaths.p2pSecurityCenter` | `P2PSecurityCenterPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 277 | `08-p2p.md` | `AppRoutePaths.p2pSecurityDevices` | `P2PDeviceManagementPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 278 | `08-p2p.md` | `AppRoutePaths.p2pSecurityLoginHistory` | `P2PLoginHistoryPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 279 | `08-p2p.md` | `AppRoutePaths.p2pSecuritySuspiciousActivity` | `P2PSuspiciousActivityPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 280 | `08-p2p.md` | `AppRoutePaths.p2pSecurityWhitelist` | `P2PWhitelistModePage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 281 | `08-p2p.md` | `AppRoutePaths.p2pSettings` | `P2PSettingsPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 282 | `08-p2p.md` | `AppRoutePaths.p2pSettingsNotifications` | `P2PNotificationsSettingsPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 283 | `08-p2p.md` | `AppRoutePaths.p2pTaxReporting` | `P2PTaxReportingPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 284 | `08-p2p.md` | `AppRoutePaths.p2pTradingLevel` | `P2PTradingLevelPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 285 | `08-p2p.md` | `AppRoutePaths.p2pWallet` | `P2PWalletPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 286 | `08-p2p.md` | `AppRoutePaths.p2pWalletFundLockHistory` | `P2PFundLockHistoryPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 287 | `08-p2p.md` | `AppRoutePaths.p2pWalletHistory` | `P2PFundLockHistoryPage` | EP-17 | HUB | P2P hub → Express & đơn hàng |
| 288 | `08-p2p.md` | `AppRoutePaths.p2pWalletTransfer` | `P2PWalletTransferPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 289 | `08-p2p.md` | `AppRoutePaths.settingsSecurityBiometric` | `SecurityPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 290 | `08-p2p.md` | `AppRoutePaths.settingsSecurityChangePassword` | `SecurityPage` | EP-17 | ẨN | — Flow / deep link (không menu) |
| 291 | `09-profile.md` | `AppRoutePaths.profile` | `ProfilePage` | EP-05 | GIỮ | Bottom Nav → Profile |
| 292 | `09-profile.md` | `AppRoutePaths.profileActivity` | `ActivityLogPage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 293 | `09-profile.md` | `AppRoutePaths.profileApi` | `ApiManagementPage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 294 | `09-profile.md` | `AppRoutePaths.profileApiCreate` | `ApiKeyCreatePage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 295 | `09-profile.md` | `AppRoutePaths.profileArena` | `MyArenaPage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 296 | `09-profile.md` | `AppRoutePaths.profileDevices` | `DeviceManagementPage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 297 | `09-profile.md` | `AppRoutePaths.profileEdit` | `EditProfilePage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 298 | `09-profile.md` | `AppRoutePaths.profileKyc` | `KYCPage` | EP-33 | GIỮ | Profile → KYC (banner) |
| 299 | `09-profile.md` | `AppRoutePaths.profilePredictions` | `PredictionsPortfolioPage` | EP-05 | HUB | Profile → Cài đặt & tài khoản |
| 300 | `09-profile.md` | `AppRoutePaths.profileSecurity` | `SecurityPage` | EP-32 | ẨN | — Flow / deep link (không menu) |
| 301 | `09-profile.md` | `AppRoutePaths.profileSettings` | `SettingsPage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 302 | `09-profile.md` | `AppRoutePaths.profileSubAccounts` | `SubAccountPage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 303 | `09-profile.md` | `AppRoutePaths.profileVip` | `VIPPage` | EP-05 | ẨN | — Flow / deep link (không menu) |
| 304 | `09-profile.md` | `AppRoutePaths.settingsSecurity` | `SecurityPage` | EP-32 | GIỮ | Profile → Bảo mật |
| 305 | `10-arena.md` | `'/arena/challenge/:challengeId'` | `ArenaChallengeDetailPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 306 | `10-arena.md` | `'/arena/creator/:creatorId'` | `ArenaCreatorPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 307 | `10-arena.md` | `'/arena/join/:challengeId'` | `ArenaJoinPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 308 | `10-arena.md` | `'/arena/ledger/entry/:entryId'` | `ArenaPointsEntryDetailPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 309 | `10-arena.md` | `'/arena/mode/:modeId'` | `ArenaModeDetailPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 310 | `10-arena.md` | `'/arena/report/:caseId'` | `ArenaReportCasePage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 311 | `10-arena.md` | `'/arena/trust/:userId'` | `ArenaTrustBreakdownPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 312 | `10-arena.md` | `AppRoutePaths.arena` | `ArenaHomePage` | EP-21 | GIỮ | Home → Discovery Arena |
| 313 | `10-arena.md` | `AppRoutePaths.arenaBlocked` | `ArenaBlockedUsersPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 314 | `10-arena.md` | `AppRoutePaths.arenaBridge` | `ArenaPredictionBridgeFoundationPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 315 | `10-arena.md` | `AppRoutePaths.arenaEcosystem` | `ConnectedEcosystemProductionPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 316 | `10-arena.md` | `AppRoutePaths.arenaFlowMap` | `ArenaFlowMapPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 317 | `10-arena.md` | `AppRoutePaths.arenaGuide` | `ArenaGuidePage` | EP-21 | HUB | Arena hub → Studio & thách đấu |
| 318 | `10-arena.md` | `AppRoutePaths.arenaLeaderboard` | `ArenaLeaderboardPage` | EP-21 | HUB | Arena hub → Studio & thách đấu |
| 319 | `10-arena.md` | `AppRoutePaths.arenaLedger` | `ArenaPointsLedgerPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 320 | `10-arena.md` | `AppRoutePaths.arenaMy` | `MyArenaPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 321 | `10-arena.md` | `AppRoutePaths.arenaMyReports` | `MyArenaReportsPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 322 | `10-arena.md` | `AppRoutePaths.arenaProduction` | `ArenaProductionReadyPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 323 | `10-arena.md` | `AppRoutePaths.arenaResolution` | `ArenaResolutionCenterPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 324 | `10-arena.md` | `AppRoutePaths.arenaSafety` | `ArenaSafetyCenterPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 325 | `10-arena.md` | `AppRoutePaths.arenaStudio` | `ArenaStudioPage` | EP-21 | HUB | Arena hub → Studio & thách đấu |
| 326 | `10-arena.md` | `AppRoutePaths.arenaStudioGovernance` | `ArenaGovernanceGatePage` | EP-21 | GOM | Profile → Pháp lý & báo cáo |
| 327 | `10-arena.md` | `AppRoutePaths.arenaStudioPresets` | `ArenaUniversalPresetLibraryPage` | EP-21 | HUB | Arena hub → Studio & thách đấu |
| 328 | `10-arena.md` | `AppRoutePaths.arenaStudioSmartRules` | `ArenaSmartRuleBuilderPage` | EP-21 | HUB | Arena hub → Studio & thách đấu |
| 329 | `10-arena.md` | `AppRoutePaths.arenaVerified` | `VerifiedChallengesPage` | EP-21 | ẨN | — Flow / deep link (không menu) |
| 330 | `11-predictions.md` | `'/markets/predictions/advanced-chart/:eventId'` | `PredictionAdvancedChartPage` | EP-20 | HUB | Predictions hub → Danh mục & portfolio |
| 331 | `11-predictions.md` | `'/markets/predictions/event/:eventId'` | `PredictionEventDetailPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 332 | `11-predictions.md` | `'/markets/predictions/receipt/:receiptId'` | `PredictionOrderReceiptPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 333 | `11-predictions.md` | `'/markets/predictions/tournament/:tournamentId'` | `PredictionTournamentDetailPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 334 | `11-predictions.md` | `AppRoutePaths.marketsPredictions` | `PredictionsHomePage` | EP-20 | GIỮ | Home → Discovery Predictions |
| 335 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsActivity` | `PredictionsGlobalActivityPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 336 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsBreaking` | `PredictionsBreakingPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 337 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsDataIntegration` | `PredictionDataIntegrationPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 338 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsEventCalendar` | `PredictionEventCalendarPage` | EP-20 | HUB | Predictions hub → Danh mục & portfolio |
| 339 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsLeaderboard` | `PredictionsLeaderboardPage` | EP-20 | HUB | Predictions hub → Danh mục & portfolio |
| 340 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsMarketMaker` | `PredictionMarketMakerPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 341 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsPortfolio` | `PredictionsPortfolioPage` | EP-20 | HUB | Predictions hub → Danh mục & portfolio |
| 342 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsPortfolioAnalyzer` | `PredictionPortfolioAnalyzerPage` | EP-20 | HUB | Predictions hub → Danh mục & portfolio |
| 343 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsRewards` | `PredictionsRewardsPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 344 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsRiskCalculator` | `PredictionRiskCalculatorPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 345 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsSearch` | `PredictionsSearchPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 346 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsSocial` | `PredictionSocialPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 347 | `11-predictions.md` | `AppRoutePaths.marketsPredictionsTournaments` | `PredictionTournamentsPage` | EP-20 | ẨN | — Flow / deep link (không menu) |
| 348 | `12-launchpad.md` | `AppRoutePaths.launchpad` | `LaunchpadPage` | EP-19 | GIỮ | Home → Sản phẩm Khám phá (Launchpad) |
| 349 | `12-launchpad.md` | `AppRoutePaths.launchpadAbiDiff` | `LaunchpadAbiDiffPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 350 | `12-launchpad.md` | `AppRoutePaths.launchpadAddressBook` | `LaunchpadAddressBookPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 351 | `12-launchpad.md` | `AppRoutePaths.launchpadBatchClaim` | `LaunchpadBatchClaimPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 352 | `12-launchpad.md` | `AppRoutePaths.launchpadBridgeCompare` | `LaunchpadBridgeComparePage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 353 | `12-launchpad.md` | `AppRoutePaths.launchpadBridgeOrderTx001` | `LaunchpadBridgeOrderPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 354 | `12-launchpad.md` | `AppRoutePaths.launchpadClaimReceiptPos001` | `LaunchpadClaimReceiptPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 355 | `12-launchpad.md` | `AppRoutePaths.launchpadContractSample` | `LaunchpadContractPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 356 | `12-launchpad.md` | `AppRoutePaths.launchpadDcaBuilder` | `LaunchpadDcaBuilderPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 357 | `12-launchpad.md` | `AppRoutePaths.launchpadEventLog` | `LaunchpadEventLogPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 358 | `12-launchpad.md` | `AppRoutePaths.launchpadGasTracker` | `LaunchpadGasTrackerPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 359 | `12-launchpad.md` | `AppRoutePaths.launchpadIdoBridgeSample` | `LaunchpadIdoBridgePage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 360 | `12-launchpad.md` | `AppRoutePaths.launchpadLimitOrders` | `LaunchpadLimitOrdersPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 361 | `12-launchpad.md` | `AppRoutePaths.launchpadMultisig` | `LaunchpadMultisigPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 362 | `12-launchpad.md` | `AppRoutePaths.launchpadNotifSound` | `LaunchpadNotifSoundPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 363 | `12-launchpad.md` | `AppRoutePaths.launchpadPerformance` | `LaunchpadPerformancePage` | EP-19 | HUB | Launchpad hub → Dự án & portfolio |
| 364 | `12-launchpad.md` | `AppRoutePaths.launchpadPortfolio` | `LaunchpadPortfolioPage` | EP-19 | HUB | Launchpad hub → Dự án & portfolio |
| 365 | `12-launchpad.md` | `AppRoutePaths.launchpadRebalance` | `LaunchpadRebalancePage` | EP-19 | HUB | Launchpad hub → Dự án & portfolio |
| 366 | `12-launchpad.md` | `AppRoutePaths.launchpadReceiptSub001` | `LaunchpadReceiptPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 367 | `12-launchpad.md` | `AppRoutePaths.launchpadRiskAnalytics` | `LaunchpadRiskAnalyticsPage` | EP-19 | HUB | Launchpad hub → Dự án & portfolio |
| 368 | `12-launchpad.md` | `AppRoutePaths.launchpadSample` | `LaunchpadDetailPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 369 | `12-launchpad.md` | `AppRoutePaths.launchpadStaking` | `LaunchpadStakingPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 370 | `12-launchpad.md` | `AppRoutePaths.launchpadSwapAggregator` | `LaunchpadSwapAggregatorPage` | EP-19 | ẨN | — Flow / deep link (không menu) |
| 371 | `12-launchpad.md` | `AppRoutePaths.launchpadWebhooks` | `LaunchpadWebhooksPage` | EP-19 | GOM | Profile → Pháp lý & báo cáo |
| 372 | `13-dca.md` | `'/dca/rebalance/:configId/edit'` | `DCARebalanceConfig` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 373 | `13-dca.md` | `'/dca/rebalance/:configId/history'` | `DCARebalanceDashboard` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 374 | `13-dca.md` | `AppRoutePaths.dca` | `DCAPage` | EP-18 | GIỮ | Home → Sản phẩm Sinh lời (DCA) |
| 375 | `13-dca.md` | `AppRoutePaths.dcaBacktester` | `DCABacktesterPage` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 376 | `13-dca.md` | `AppRoutePaths.dcaDynamicAmount` | `DCADynamicAmount` | EP-18 | ẨN | — Flow / deep link (không menu) |
| 377 | `13-dca.md` | `AppRoutePaths.dcaMultiAsset` | `DCAMultiAssetPage` | EP-18 | ẨN | — Flow / deep link (không menu) |
| 378 | `13-dca.md` | `AppRoutePaths.dcaPerformanceCompare` | `DCAPerformanceComparePage` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 379 | `13-dca.md` | `AppRoutePaths.dcaPortfolioOptimizer` | `DCAPortfolioOptimizer` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 380 | `13-dca.md` | `AppRoutePaths.dcaRebalanceConfig` | `DCARebalanceConfig` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 381 | `13-dca.md` | `AppRoutePaths.dcaRebalanceDashboard` | `DCARebalanceDashboard` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 382 | `13-dca.md` | `AppRoutePaths.dcaScheduleAnalytics` | `DCAScheduleAnalytics` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 383 | `13-dca.md` | `AppRoutePaths.dcaScheduleConfig` | `DCAScheduleConfig` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 384 | `13-dca.md` | `AppRoutePaths.dcaSmartRules` | `DCASmartRulesPage` | EP-18 | HUB | DCA hub → Lịch & công cụ |
| 385 | `14-utility-cross-module.md` | `'/referral/friend/:friendId'` | `ReferralFriendDetailPage` | EP-23 | ẨN | — Flow / deep link (không menu) |
| 386 | `14-utility-cross-module.md` | `AppRoutePaths.crossModuleAnalytics` | `CrossModuleAnalytics` | EP-34 | HUB | Profile → Analytics & báo cáo thuế |
| 387 | `14-utility-cross-module.md` | `AppRoutePaths.demoCopyCard` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 388 | `14-utility-cross-module.md` | `AppRoutePaths.devDcaOverview` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 389 | `14-utility-cross-module.md` | `AppRoutePaths.devDesignSystem` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 390 | `14-utility-cross-module.md` | `AppRoutePaths.devShowcase` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 391 | `14-utility-cross-module.md` | `AppRoutePaths.enterpriseStates` | `EnterpriseStatesPage` | EP-05 | DEV | Ẩn — Dev/Admin |
| 392 | `14-utility-cross-module.md` | `AppRoutePaths.notifications` | `NotificationsPage` | EP-07 | GIỮ | Header → Thông báo |
| 393 | `14-utility-cross-module.md` | `AppRoutePaths.performanceMonitor` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 394 | `14-utility-cross-module.md` | `AppRoutePaths.referral` | `ReferralHomePage` | EP-23 | GIỮ | Profile → Giới thiệu |
| 395 | `14-utility-cross-module.md` | `AppRoutePaths.referralHistory` | `ReferralHistoryPage` | EP-23 | HUB | Referral hub → Lịch sử & thưởng |
| 396 | `14-utility-cross-module.md` | `AppRoutePaths.referralRewards` | `ReferralRewardsPage` | EP-22 | ẨN | — Flow / deep link (không menu) |
| 397 | `14-utility-cross-module.md` | `AppRoutePaths.referralRules` | `ReferralRulesPage` | EP-23 | ẨN | — Flow / deep link (không menu) |
| 398 | `14-utility-cross-module.md` | `AppRoutePaths.rewards` | `RewardsHubPage` | EP-22 | GIỮ | Home → Sản phẩm Khám phá (Rewards) |
| 399 | `14-utility-cross-module.md` | `AppRoutePaths.routeChecker` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 400 | `14-utility-cross-module.md` | `AppRoutePaths.search` | `UnifiedSearchPage` | EP-06 | GIỮ | Header → Tìm kiếm |
| 401 | `14-utility-cross-module.md` | `AppRoutePaths.smartAlerts` | `SmartAlertCenter` | EP-34 | HUB | Profile → Analytics & báo cáo thuế |
| 402 | `14-utility-cross-module.md` | `AppRoutePaths.taxReports` | `TaxReportCenter` | EP-34 | ẨN | — Flow / deep link (không menu) |
| 403 | `14-utility-cross-module.md` | `AppRoutePaths.topicCrypto` | `TopicHubPage` | EP-31 | HUB | Discovery → Topic hub |
| 404 | `14-utility-cross-module.md` | `AppRoutePaths.topics` | `TopicHubPage` | EP-31 | GIỮ | Home → Sản phẩm Khám phá (Topics) |
| 405 | `14-utility-cross-module.md` | `AppRoutePaths.unifiedPortfolio` | `UnifiedPortfolioDashboard` | EP-34 | GIỮ | Profile → Portfolio nâng cao |
| 406 | `15-support.md` | `AppRoutePaths.support` | `SupportPage` | EP-24 | GIỮ | Profile → Hỗ trợ |
| 407 | `15-support.md` | `AppRoutePaths.supportAnnouncements` | `AnnouncementsPage` | EP-24 | ẨN | — Flow / deep link (không menu) |
| 408 | `15-support.md` | `AppRoutePaths.supportHelp` | `HelpCenterPage` | EP-24 | ẨN | — Flow / deep link (không menu) |
| 409 | `16-admin-dev.md` | `AppRoutePaths.admin` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 410 | `16-admin-dev.md` | `AppRoutePaths.adminAbtests` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 411 | `16-admin-dev.md` | `AppRoutePaths.adminAnalytics` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 412 | `16-admin-dev.md` | `AppRoutePaths.adminFunnels` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |
| 413 | `16-admin-dev.md` | `AppRoutePaths.adminSettings` | `InternalSurfaceGate` | EP-05 | DEV | Ẩn — Dev/Admin |

**Total rows:** 413
