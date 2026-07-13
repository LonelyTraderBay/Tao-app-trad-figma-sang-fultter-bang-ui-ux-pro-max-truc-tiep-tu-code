# TRADE — Route map (59 routes)

Route group: `trade_routes`

| # | Path | Page class | EP cha | Phân loại | Menu UI đề xuất |
|--:|------|------------|--------|-----------|-----------------|
| 1 | `'/trade/:pairId'` | `TradePage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 2 | `'/trade/:pairId/futures'` | `FuturesPage` | EP-10 | ẨN | — Trade → chọn cặp Futures |
| 3 | `'/trade/:pairId/futures/leverage'` | `LeveragePage` | EP-10 | ẨN | — Trade → chọn cặp Futures |
| 4 | `'/trade/advanced-chart/:pairId'` | `AdvancedChartPage` | EP-03 | HUB | Trade hub → Công cụ Spot |
| 5 | `'/trade/copy-audit-log/:copyId'` | `CopyAuditLogPage` | EP-13 | GOM | Copy hub → Tuân thủ & audit |
| 6 | `'/trade/copy-performance/:copyId'` | `CopyPerformancePage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 7 | `'/trade/copy-performance/:copyId/attribution'` | `PerformanceAttributionPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 8 | `'/trade/copy-provider/:providerId'` | `CopyProviderDetailPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 9 | `'/trade/copy-provider/:providerId/assessment'` | `PreCopyAssessmentPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 10 | `'/trade/copy-provider/:providerId/configuration'` | `CopyConfigurationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 11 | `'/trade/copy-provider/:providerId/confirmation'` | `CopyConfirmationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 12 | `'/trade/trader/:traderId'` | `TraderProfilePage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 13 | `AppRoutePaths.trade` | `TradePage` | EP-03 | GIỮ | Bottom Nav → Trade |
| 14 | `AppRoutePaths.tradeAdvancedTools` | `AdvancedToolsDemoPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 15 | `AppRoutePaths.tradeBotApiDocumentation` | `BotApiDocumentationPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 16 | `AppRoutePaths.tradeBotBacktesting` | `BotBacktestingPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 17 | `AppRoutePaths.tradeBotDrawdownAnalyzer` | `BotDrawdownAnalyzerPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 18 | `AppRoutePaths.tradeBotEmergencyStop` | `BotEmergencyStopPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 19 | `AppRoutePaths.tradeBotEquityCurve` | `BotEquityCurvePage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 20 | `AppRoutePaths.tradeBotFaq` | `BotFaqPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 21 | `AppRoutePaths.tradeBotGuide` | `BotGuidePage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 22 | `AppRoutePaths.tradeBotHistory` | `BotHistoryPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 23 | `AppRoutePaths.tradeBotOptimization` | `BotOptimizationPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 24 | `AppRoutePaths.tradeBotPerformanceAnalytics` | `BotPerformanceAnalyticsPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 25 | `AppRoutePaths.tradeBotPortfolioDashboard` | `BotPortfolioDashboardPage` | EP-14 | HUB | Bots hub → Công cụ & chiến lược |
| 26 | `AppRoutePaths.tradeBotRiskDashboard` | `BotRiskDashboardPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 27 | `AppRoutePaths.tradeBotRiskDisclosure` | `BotRiskDisclosurePage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 28 | `AppRoutePaths.tradeBots` | `TradingBotsPage` | EP-14 | GIỮ | Home → Sản phẩm Pro (Bot) |
| 29 | `AppRoutePaths.tradeBotSecuritySettings` | `BotSecuritySettingsPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 30 | `AppRoutePaths.tradeBotStrategyCompare` | `BotStrategyComparePage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 31 | `AppRoutePaths.tradeBotSuitabilityAssessment` | `BotSuitabilityAssessmentPage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 32 | `AppRoutePaths.tradeBotTaxReporting` | `BotTaxReportingPage` | EP-14 | ẨN | — Flow / deep link (không menu) |
| 33 | `AppRoutePaths.tradeBotTermsOfService` | `BotTermsOfServicePage` | EP-14 | GOM | Profile → Pháp lý & báo cáo |
| 34 | `AppRoutePaths.tradeConvert` | `ConvertPage` | EP-12 | GIỮ | Home → Sản phẩm Giao dịch |
| 35 | `AppRoutePaths.tradeCopyActive` | `ActiveCopiesPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 36 | `AppRoutePaths.tradeCopyComparison` | `ProviderComparisonPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 37 | `AppRoutePaths.tradeCopyDisputeResolution` | `DisputeResolutionPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 38 | `AppRoutePaths.tradeCopyEducation` | `CopyEducationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 39 | `AppRoutePaths.tradeCopyLeaderboard` | `ProviderLeaderboardPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 40 | `AppRoutePaths.tradeCopyNotifications` | `CopyNotificationsPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 41 | `AppRoutePaths.tradeCopyProviderApply` | `ProviderApplicationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 42 | `AppRoutePaths.tradeCopyProviderGovernance` | `ProviderGovernancePage` | EP-13 | GOM | Copy hub → Tuân thủ & audit |
| 43 | `AppRoutePaths.tradeCopyRiskAnalysis` | `PortfolioRiskAnalysisPage` | EP-13 | HUB | Copy hub → Công cụ & danh sách |
| 44 | `AppRoutePaths.tradeCopySafety` | `SafetyEducationPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 45 | `AppRoutePaths.tradeCopySafetyCenter` | `CopySafetyCenterPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 46 | `AppRoutePaths.tradeCopySettings` | `CopySettingsPage` | EP-13 | ẨN | — Flow / deep link (không menu) |
| 47 | `AppRoutePaths.tradeCopyTrading` | `CopyTradingPage` | EP-13 | GIỮ | Home → Sản phẩm Pro (Copy) |
| 48 | `AppRoutePaths.tradeExecutionQuality` | `ExecutionQualityDemoPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 49 | `AppRoutePaths.tradeExport` | `TradeHistoryExportPage` | EP-03 | HUB | Trade hub → Công cụ Spot |
| 50 | `AppRoutePaths.tradeMargin` | `MarginTradingPage` | EP-11 | GIỮ | Trade tab + Home → Sản phẩm Giao dịch |
| 51 | `AppRoutePaths.tradeMarginAdvancedAnalytics` | `AdvancedAnalyticsPage` | EP-11 | HUB | Margin hub → Công cụ |
| 52 | `AppRoutePaths.tradeMarginAdvancedDemo` | `AdvancedTradingDemoPage` | EP-11 | ẨN | — Flow / deep link (không menu) |
| 53 | `AppRoutePaths.tradeMarginBtcusdt` | `MarginTradingPage` | EP-11 | ẨN | — Flow / deep link (không menu) |
| 54 | `AppRoutePaths.tradeMarginHub` | `MarginTradingHubPage` | EP-11 | HUB | Margin hub → Công cụ |
| 55 | `AppRoutePaths.tradeOrderReceipt` | `OrderReceiptPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 56 | `AppRoutePaths.tradeOrdersHistory` | `OrdersHistoryPage` | EP-26 | GIỮ | Trade hub → Lệnh & lịch sử |
| 57 | `AppRoutePaths.tradePositions` | `PositionDashboardPage` | EP-27 | GIỮ | Trade hub → Vị thế |
| 58 | `AppRoutePaths.tradeRiskManagement` | `RiskManagementDemoPage` | EP-03 | ẨN | — Flow / deep link (không menu) |
| 59 | `AppRoutePaths.tradeSettings` | `TradeSettingsPage` | EP-03 | ẨN | — Flow / deep link (không menu) |

### Thống kê module

| Phân loại | Số |
|-----------|---:|
| ẨN | 28 |
| GIỮ | 7 |
| GOM | 8 |
| HUB | 16 |
