# VitTrade Screen Redesign Checklist

Generated: 2026-07-03

Full inventory of registered screens for UI redesign tracking.

> **Token tip (AI):** Prefer [`VitTrade-Screen-Redesign-Checklist.csv`](VitTrade-Screen-Redesign-Checklist.csv) filtered by batch `sc_ids` — do not load this Markdown file into redesign chats (551 lines, duplicates CSV).

CSV companion: [`VitTrade-Screen-Redesign-Checklist.csv`](VitTrade-Screen-Redesign-Checklist.csv)

## auth (6)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc001Login` | `/auth/login` | `lib/features/auth/presentation/pages/login_page.dart` | `LoginPage` | `real_page` |
| `sc002Register` | `/auth/register` | `lib/features/auth/presentation/pages/register_page.dart` | `RegisterPage` | `real_page` |
| `sc003Otp` | `/auth/otp` | `lib/features/auth/presentation/pages/otp_page.dart` | `OtpPage` | `real_page` |
| `sc004TwoFaSetup` | `/auth/2fa-setup` | `lib/features/auth/presentation/pages/two_fa_setup_page.dart` | `TwoFASetupPage` | `real_page` |
| `sc005ForgotPassword` | `/auth/forgot-password` | `lib/features/auth/presentation/pages/forgot_password_page.dart` | `ForgotPasswordPage` | `real_page` |
| `sc006ResetPassword` | `/auth/reset-password` | `lib/features/auth/presentation/pages/reset_password_page.dart` | `ResetPasswordPage` | `real_page` |

## onboarding (1)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc397Onboarding` | `/onboarding` | `lib/features/onboarding/presentation/pages/onboarding_flow.dart` | `OnboardingFlow` | `real_page` |

## home (1)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc007Home` | `/home` | `lib/features/home/presentation/pages/home_page.dart` | `HomePage` | `real_page` |

## discovery (3)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc283UnifiedSearch` | `/search` | `lib/features/discovery/presentation/pages/unified_search_page.dart` | `UnifiedSearchPage` | `real_page` |
| `sc284TopicHub` | `/topics` | `lib/features/discovery/presentation/pages/topic_hub_page.dart` | `TopicHubPage` | `real_page` |
| `sc285TopicCrypto` | `/topic/crypto` | `lib/features/discovery/presentation/pages/topic_hub_page.dart` | `TopicHubPage` | `real_page` |

## news (1)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc047News` | `/news` | `lib/features/news/presentation/pages/news_page.dart` | `NewsPage` | `real_page` |

## notifications (1)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc291Notifications` | `/notifications` | `lib/features/notifications/presentation/pages/notifications_page.dart` | `NotificationsPage` | `real_page` |

## markets (22)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc008MarketList` | `/markets` | `lib/features/markets/presentation/pages/market_list_page.dart` | `MarketListPage` | `real_page` |
| `sc009MarketOverview` | `/markets/overview` | `lib/features/markets/presentation/pages/market_overview_page.dart` | `MarketOverviewPage` | `real_page` |
| `sc010MarketMovers` | `/markets/movers` | `lib/features/markets/presentation/pages/market_movers_page.dart` | `MarketMoversPage` | `real_page` |
| `sc011MarketSectors` | `/markets/sectors` | `lib/features/markets/presentation/pages/market_sectors_page.dart` | `MarketSectorsPage` | `real_page` |
| `sc012Watchlist` | `/markets/watchlist` | `lib/features/markets/presentation/pages/watchlist_page.dart` | `WatchlistPage` | `real_page` |
| `sc013MarketHeatmap` | `/markets/heatmap` | `lib/features/markets/presentation/pages/market_heatmap_page.dart` | `MarketHeatmapPage` | `real_page` |
| `sc014PriceAlerts` | `/markets/alerts` | `lib/features/markets/presentation/pages/price_alerts_page.dart` | `PriceAlertsPage` | `real_page` |
| `sc015MarketScreener` | `/markets/screener` | `lib/features/markets/presentation/pages/market_screener_page.dart` | `MarketScreenerPage` | `real_page` |
| `sc016ComparisonTool` | `/markets/compare` | `lib/features/markets/presentation/pages/comparison_tool_page.dart` | `ComparisonToolPage` | `real_page` |
| `sc017MarketCalendar` | `/markets/calendar` | `lib/features/markets/presentation/pages/market_calendar_page.dart` | `MarketCalendarPage` | `real_page` |
| `sc018DerivativesOverview` | `/markets/derivatives` | `lib/features/markets/presentation/pages/derivatives_overview_page.dart` | `DerivativesOverviewPage` | `real_page` |
| `sc019MarketDepth` | `/markets/depth` | `lib/features/markets/presentation/pages/market_depth_page.dart` | `MarketDepthPage` | `real_page` |
| `sc020SocialSentiment` | `/markets/social-sentiment` | `lib/features/markets/presentation/pages/social_sentiment_page.dart` | `SocialSentimentPage` | `real_page` |
| `sc021PortfolioTracker` | `/markets/portfolio-tracker` | `lib/features/markets/presentation/pages/portfolio_tracker_page.dart` | `PortfolioTrackerPage` | `real_page` |
| `sc022MarketNews` | `/markets/news` | `lib/features/markets/presentation/pages/market_news_page.dart` | `MarketNewsPage` | `real_page` |
| `sc023AdvancedCharts` | `/markets/advanced-charts` | `lib/features/markets/presentation/pages/advanced_charts_page.dart` | `AdvancedChartsPage` | `real_page` |
| `sc024TokenUnlocks` | `/markets/unlocks` | `lib/features/markets/presentation/pages/token_unlocks_page.dart` | `TokenUnlocksPage` | `real_page` |
| `sc025SocialSignals` | `/markets/signals` | `lib/features/markets/presentation/pages/social_signals_page.dart` | `SocialSignalsPage` | `real_page` |
| `sc026MarketCorrelations` | `/markets/correlations` | `lib/features/markets/presentation/pages/market_correlations_page.dart` | `MarketCorrelationsPage` | `real_page` |
| `sc044PairDetail` | `/pair/:pairId` | `lib/features/markets/presentation/pages/pair_detail_page.dart` | `PairDetailPage` | `real_page` |
| `sc045TokenInfo` | `/pair/:pairId/info` | `lib/features/markets/presentation/pages/token_info_page.dart` | `TokenInfoPage` | `real_page` |
| `sc046PairDepth` | `/pair/:pairId/depth` | `lib/features/markets/presentation/pages/market_depth_page.dart` | `MarketDepthPage` | `real_page` |

## predictions (17)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc027PredictionsHome` | `/markets/predictions` | `lib/features/predictions/presentation/pages/predictions_home_page.dart` | `PredictionsHomePage` | `real_page` |
| `sc028PredictionsSearch` | `/markets/predictions/search` | `lib/features/predictions/presentation/pages/predictions_search_page.dart` | `PredictionsSearchPage` | `real_page` |
| `sc029PredictionsBreaking` | `/markets/predictions/breaking` | `lib/features/predictions/presentation/pages/predictions_breaking_page.dart` | `PredictionsBreakingPage` | `real_page` |
| `sc030PredictionEventDetail` | `/markets/predictions/event/:eventId` | `lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` | `PredictionEventDetailPage` | `real_page` |
| `sc031PredictionsPortfolio` | `/markets/predictions/portfolio` | `lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` | `PredictionsPortfolioPage` | `real_page` |
| `sc032PredictionsRewards` | `/markets/predictions/rewards` | `lib/features/predictions/presentation/pages/predictions_rewards_page.dart` | `PredictionsRewardsPage` | `real_page` |
| `sc033PredictionsLeaderboard` | `/markets/predictions/leaderboard` | `lib/features/predictions/presentation/pages/predictions_leaderboard_page.dart` | `PredictionsLeaderboardPage` | `real_page` |
| `sc034PredictionsGlobalActivity` | `/markets/predictions/activity` | `lib/features/predictions/presentation/pages/predictions_global_activity_page.dart` | `PredictionsGlobalActivityPage` | `real_page` |
| `sc035PredictionOrderReceipt` | `/markets/predictions/receipt/:receiptId` | `lib/features/predictions/presentation/pages/prediction_order_receipt_page.dart` | `PredictionOrderReceiptPage` | `real_page` |
| `sc036PredictionRiskCalculator` | `/markets/predictions/risk-calculator` | `lib/features/predictions/presentation/pages/prediction_risk_calculator_page.dart` | `PredictionRiskCalculatorPage` | `real_page` |
| `sc037PredictionMarketMaker` | `/markets/predictions/market-maker` | `lib/features/predictions/presentation/pages/prediction_market_maker_page.dart` | `PredictionMarketMakerPage` | `real_page` |
| `sc038PredictionPortfolioAnalyzer` | `/markets/predictions/portfolio-analyzer` | `lib/features/predictions/presentation/pages/prediction_portfolio_analyzer_page.dart` | `PredictionPortfolioAnalyzerPage` | `real_page` |
| `sc039PredictionEventCalendar` | `/markets/predictions/event-calendar` | `lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart` | `PredictionEventCalendarPage` | `real_page` |
| `sc040PredictionSocial` | `/markets/predictions/social` | `lib/features/predictions/presentation/pages/prediction_social_page.dart` | `PredictionSocialPage` | `real_page` |
| `sc041PredictionAdvancedChart` | `/markets/predictions/advanced-chart/:eventId` | `lib/features/predictions/presentation/pages/prediction_advanced_chart_page_part_01.dart` | `PredictionAdvancedChartPage` | `real_page` |
| `sc042PredictionTournaments` | `/markets/predictions/tournaments` | `lib/features/predictions/presentation/pages/prediction_tournaments_page.dart` | `PredictionTournamentsPage` | `real_page` |
| `sc043PredictionDataIntegration` | `/markets/predictions/data-integration` | `lib/features/predictions/presentation/pages/prediction_data_integration_page.dart` | `PredictionDataIntegrationPage` | `real_page` |

## trade (92)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc048Trade` | `/trade` | `lib/features/trade/presentation/pages/trade_page.dart` | `TradePage` | `real_page` |
| `sc049TradePair` | `/trade/:pairId` | `lib/features/trade/presentation/pages/trade_page.dart` | `TradePage` | `real_page` |
| `sc050OrdersHistory` | `/trade/orders-history` | `lib/features/trade/presentation/pages/orders_history_page.dart` | `OrdersHistoryPage` | `real_page` |
| `sc051OrderReceipt` | `/trade/order-receipt` | `lib/features/trade/presentation/pages/order_receipt_page.dart` | `OrderReceiptPage` | `real_page` |
| `sc052TradeSettings` | `/trade/settings` | `lib/features/trade/presentation/pages/trade_settings_page.dart` | `TradeSettingsPage` | `real_page` |
| `sc053PositionDashboard` | `/trade/positions` | `lib/features/trade/presentation/pages/position_dashboard_page.dart` | `PositionDashboardPage` | `real_page` |
| `sc054TradeHistoryExport` | `/trade/export` | `lib/features/trade/presentation/pages/trade_history_export_page.dart` | `TradeHistoryExportPage` | `real_page` |
| `sc055AdvancedChart` | `/trade/advanced-chart/:pairId` | `lib/features/trade/presentation/pages/advanced_chart_page.dart` | `AdvancedChartPage` | `real_page` |
| `sc056Convert` | `/trade/convert` | `lib/features/trade/presentation/pages/convert_page.dart` | `ConvertPage` | `real_page` |
| `sc057Futures` | `/trade/:pairId/futures` | `lib/features/trade/presentation/pages/futures_page.dart` | `FuturesPage` | `real_page` |
| `sc058Leverage` | `/trade/:pairId/futures/leverage` | `lib/features/trade/presentation/pages/leverage_page.dart` | `LeveragePage` | `real_page` |
| `sc059TradingBots` | `/trade/bots` | `lib/features/trade/presentation/pages/trading_bots_page.dart` | `TradingBotsPage` | `real_page` |
| `sc060RiskManagement` | `/trade/risk-management` | `lib/features/trade/presentation/pages/risk_management_demo_page.dart` | `RiskManagementDemoPage` | `real_page` |
| `sc061ExecutionQuality` | `/trade/execution-quality` | `lib/features/trade/presentation/pages/execution_quality_demo_page.dart` | `ExecutionQualityDemoPage` | `real_page` |
| `sc062AdvancedTools` | `/trade/advanced-tools` | `lib/features/trade/presentation/pages/advanced_tools_demo_page.dart` | `AdvancedToolsDemoPage` | `real_page` |
| `sc063CopyTrading` | `/trade/copy-trading` | `lib/features/trade/presentation/pages/copy_trading_page.dart` | `CopyTradingPage` | `real_page` |
| `sc064CopyTradingV2` | `/trade/copy-trading/v2` | `lib/features/trade/presentation/pages/copy_trading_v2_page.dart` | `CopyTradingV2Page` | `real_page` |
| `sc065CopyEducation` | `/trade/copy-trading/education` | `lib/features/trade/presentation/pages/copy_education_page.dart` | `CopyEducationPage` | `real_page` |
| `sc066ActiveCopies` | `/trade/copy-trading/active` | `lib/features/trade/presentation/pages/active_copies_page.dart` | `ActiveCopiesPage` | `real_page` |
| `sc067CopySettings` | `/trade/copy-trading/settings` | `lib/features/trade/presentation/pages/copy_settings_page.dart` | `CopySettingsPage` | `real_page` |
| `sc068CopyNotifications` | `/trade/copy-trading/notifications` | `lib/features/trade/presentation/pages/copy_notifications_page.dart` | `CopyNotificationsPage` | `real_page` |
| `sc069ProviderApplication` | `/trade/copy-provider-apply` | `lib/features/trade/presentation/pages/provider_application_page.dart` | `ProviderApplicationPage` | `real_page` |
| `sc070CopyProviderDetail` | `/trade/copy-provider/:providerId` | `lib/features/trade/presentation/pages/copy_provider_detail_page.dart` | `CopyProviderDetailPage` | `real_page` |
| `sc071PreCopyAssessment` | `/trade/copy-provider/:providerId/assessment` | `lib/features/trade/presentation/pages/pre_copy_assessment_page.dart` | `PreCopyAssessmentPage` | `real_page` |
| `sc072CopyConfiguration` | `/trade/copy-provider/:providerId/configuration` | `lib/features/trade/presentation/pages/copy_configuration_page.dart` | `CopyConfigurationPage` | `real_page` |
| `sc073CopyConfirmation` | `/trade/copy-provider/:providerId/confirmation` | `lib/features/trade/presentation/pages/copy_confirmation_page.dart` | `CopyConfirmationPage` | `real_page` |
| `sc074CopyPerformance` | `/trade/copy-performance/:copyId` | `lib/features/trade/presentation/pages/copy_performance_page.dart` | `CopyPerformancePage` | `real_page` |
| `sc075PerformanceAttribution` | `/trade/copy-performance/:copyId/attribution` | `lib/features/trade/presentation/pages/performance_attribution_page.dart` | `PerformanceAttributionPage` | `real_page` |
| `sc076ProviderComparison` | `/trade/copy-trading/comparison` | `lib/features/trade/presentation/pages/provider_comparison_page.dart` | `ProviderComparisonPage` | `real_page` |
| `sc077CopyAuditLog` | `/trade/copy-audit-log/:copyId` | `lib/features/trade/presentation/pages/copy_audit_log_page.dart` | `CopyAuditLogPage` | `real_page` |
| `sc078PortfolioRiskAnalysis` | `/trade/copy-trading/risk-analysis` | `lib/features/trade/presentation/pages/portfolio_risk_analysis_page.dart` | `PortfolioRiskAnalysisPage` | `real_page` |
| `sc079ProviderLeaderboard` | `/trade/copy-trading/leaderboard` | `lib/features/trade/presentation/pages/provider_leaderboard_page.dart` | `ProviderLeaderboardPage` | `real_page` |
| `sc080SafetyEducation` | `/trade/copy-trading/safety` | `lib/features/trade/presentation/pages/safety_education_page.dart` | `SafetyEducationPage` | `real_page` |
| `sc081ProviderGovernance` | `/trade/copy-provider-governance` | `lib/features/trade/presentation/pages/provider_governance_page.dart` | `ProviderGovernancePage` | `real_page` |
| `sc082DisputeResolution` | `/trade/copy-dispute-resolution` | `lib/features/trade/presentation/pages/dispute_resolution_page.dart` | `DisputeResolutionPage` | `real_page` |
| `sc083CopySafetyCenter` | `/trade/copy-safety-center` | `lib/features/trade/presentation/pages/copy_safety_center_page.dart` | `CopySafetyCenterPage` | `real_page` |
| `sc084RegulatoryDisclosures` | `/trade/copy-regulatory-disclosures` | `lib/features/trade/presentation/pages/regulatory_disclosures_page.dart` | `RegulatoryDisclosuresPage` | `real_page` |
| `sc085MarginTrading` | `/trade/margin` | `lib/features/trade/presentation/pages/margin_trading_page.dart` | `MarginTradingPage` | `real_page` |
| `sc086MarginTradingPair` | `/trade/margin/btcusdt` | `lib/features/trade/presentation/pages/margin_trading_page.dart` | `MarginTradingPage` | `real_page` |
| `sc087TraderProfile` | `/trade/trader/:traderId` | `lib/features/trade/presentation/pages/trader_profile_page.dart` | `TraderProfilePage` | `real_page` |
| `sc088AdvancedTradingDemo` | `/trade/margin/advanced-demo` | `lib/features/trade/presentation/pages/advanced_trading_demo_page.dart` | `AdvancedTradingDemoPage` | `real_page` |
| `sc089MarketDataAnalytics` | `/trade/margin/market-data-analytics` | `lib/features/trade/presentation/pages/market_data_analytics_page.dart` | `MarketDataAnalyticsPage` | `real_page` |
| `sc090MarginTradingHub` | `/trade/margin/hub` | `lib/features/trade/presentation/pages/margin_trading_hub_page.dart` | `MarginTradingHubPage` | `real_page` |
| `sc091LiveMarketDataAnalytics` | `/trade/margin/live-market-data-analytics` | `lib/features/trade/presentation/pages/live_market_data_analytics_page.dart` | `LiveMarketDataAnalyticsPage` | `real_page` |
| `sc092AdvancedAnalytics` | `/trade/margin/advanced-analytics` | `lib/features/trade/presentation/pages/advanced_analytics_page.dart` | `AdvancedAnalyticsPage` | `real_page` |
| `sc093TransactionReporting` | `/trade/copy-trading/transaction-reporting` | `lib/features/trade/presentation/pages/transaction_reporting_page.dart` | `TransactionReportingPage` | `real_page` |
| `sc094RegulatoryReportsDashboard` | `/trade/copy-trading/regulatory-reports-dashboard` | `lib/features/trade/presentation/pages/regulatory_reports_dashboard_page.dart` | `RegulatoryReportsDashboardPage` | `real_page` |
| `sc095ArmIntegrationStatus` | `/trade/copy-trading/arm-integration-status` | `lib/features/trade/presentation/pages/arm_integration_status_page.dart` | `ArmIntegrationStatusPage` | `real_page` |
| `sc096BestExecutionReports` | `/trade/copy-trading/best-execution-reports` | `lib/features/trade/presentation/pages/best_execution_reports_page.dart` | `BestExecutionReportsPage` | `real_page` |
| `sc097ExecutionVenueAnalysis` | `/trade/copy-trading/execution-venue-analysis` | `lib/features/trade/presentation/pages/execution_venue_analysis_page.dart` | `ExecutionVenueAnalysisPage` | `real_page` |
| `sc098SlippageMonitoring` | `/trade/copy-trading/slippage-monitoring` | `lib/features/trade/presentation/pages/slippage_monitoring_page.dart` | `SlippageMonitoringPage` | `real_page` |
| `sc099ClientCategorization` | `/trade/copy-trading/client-categorization` | `lib/features/trade/presentation/pages/client_categorization_page.dart` | `ClientCategorizationPage` | `real_page` |
| `sc100ProductGovernance` | `/trade/copy-trading/product-governance` | `lib/features/trade/presentation/pages/product_governance_page.dart` | `ProductGovernancePage` | `real_page` |
| `sc101TargetMarketDefinition` | `/trade/copy-trading/target-market-definition` | `lib/features/trade/presentation/pages/target_market_definition_page.dart` | `TargetMarketDefinitionPage` | `real_page` |
| `sc102ClientMoneyProtection` | `/trade/copy-trading/client-money-protection` | `lib/features/trade/presentation/pages/client_money_protection_page.dart` | `ClientMoneyProtectionPage` | `real_page` |
| `sc103CassReconciliation` | `/trade/copy-trading/cass-reconciliation` | `lib/features/trade/presentation/pages/cass_reconciliation_page.dart` | `CassReconciliationPage` | `real_page` |
| `sc104InvestorCompensation` | `/trade/copy-trading/investor-compensation` | `lib/features/trade/presentation/pages/investor_compensation_page.dart` | `InvestorCompensationPage` | `real_page` |
| `sc105ExAnteCosts` | `/trade/copy-trading/ex-ante-costs` | `lib/features/trade/presentation/pages/ex_ante_costs_page.dart` | `ExAnteCostsPage` | `real_page` |
| `sc106RiyCalculator` | `/trade/copy-trading/riy-calculator` | `lib/features/trade/presentation/pages/riy_calculator_page.dart` | `RIYCalculatorPage` | `real_page` |
| `sc107ExPostCostsReport` | `/trade/copy-trading/ex-post-costs-report` | `lib/features/trade/presentation/pages/ex_post_costs_report_page.dart` | `ExPostCostsReportPage` | `real_page` |
| `sc108KidGenerator` | `/trade/copy-trading/kid-generator` | `lib/features/trade/presentation/pages/kid_generator_page.dart` | `KIDGeneratorPage` | `real_page` |
| `sc109PerformanceScenarios` | `/trade/copy-trading/performance-scenarios` | `lib/features/trade/presentation/pages/performance_scenarios_page.dart` | `PerformanceScenariosPage` | `real_page` |
| `sc110RiskIndicatorExplainer` | `/trade/copy-trading/risk-indicator-explainer` | `lib/features/trade/presentation/pages/risk_indicator_explainer_page.dart` | `RiskIndicatorExplainerPage` | `real_page` |
| `sc111ComplaintsHandling` | `/trade/copy-trading/complaints-handling` | `lib/features/trade/presentation/pages/complaints_handling_page.dart` | `ComplaintsHandlingPage` | `real_page` |
| `sc112ComplaintSubmission` | `/trade/copy-trading/complaint-submission` | `lib/features/trade/presentation/pages/complaint_submission_page.dart` | `ComplaintSubmissionPage` | `real_page` |
| `sc113ComplaintTracking` | `/trade/copy-trading/complaint-tracking` | `lib/features/trade/presentation/pages/complaint_tracking_page.dart` | `ComplaintTrackingPage` | `real_page` |
| `sc114OmbudsmanReferral` | `/trade/copy-trading/ombudsman-referral` | `lib/features/trade/presentation/pages/ombudsman_referral_page.dart` | `OmbudsmanReferralPage` | `real_page` |
| `sc115AuditTrail` | `/trade/copy-trading/audit-trail` | `lib/features/trade/presentation/pages/audit_trail_page.dart` | `AuditTrailPage` | `real_page` |
| `sc116RegulatoryInspectionReady` | `/trade/copy-trading/regulatory-inspection-ready` | `lib/features/trade/presentation/pages/regulatory_inspection_ready_page.dart` | `RegulatoryInspectionReadyPage` | `real_page` |
| `sc117BotTermsOfService` | `/trade/bots/terms-of-service` | `lib/features/trade/presentation/pages/bot_terms_of_service_page.dart` | `BotTermsOfServicePage` | `real_page` |
| `sc118BotRiskDisclosure` | `/trade/bots/risk-disclosure` | `lib/features/trade/presentation/pages/bot_risk_disclosure_page.dart` | `BotRiskDisclosurePage` | `real_page` |
| `sc119BotSuitabilityAssessment` | `/trade/bots/suitability-assessment` | `lib/features/trade/presentation/pages/bot_suitability_assessment_page.dart` | `BotSuitabilityAssessmentPage` | `real_page` |
| `sc120BotRiskDashboard` | `/trade/bots/risk-dashboard` | `lib/features/trade/presentation/pages/bot_risk_dashboard_page.dart` | `BotRiskDashboardPage` | `real_page` |
| `sc121BotEmergencyStop` | `/trade/bots/emergency-stop` | `lib/features/trade/presentation/pages/bot_emergency_stop_page.dart` | `BotEmergencyStopPage` | `real_page` |
| `sc122BotSecuritySettings` | `/trade/bots/security-settings` | `lib/features/trade/presentation/pages/bot_security_settings_page.dart` | `BotSecuritySettingsPage` | `real_page` |
| `sc123BotHistory` | `/trade/bots/history` | `lib/features/trade/presentation/pages/bot_history_page.dart` | `BotHistoryPage` | `real_page` |
| `sc124BotPerformanceAnalytics` | `/trade/bots/performance-analytics` | `lib/features/trade/presentation/pages/bot_performance_analytics_page.dart` | `BotPerformanceAnalyticsPage` | `real_page` |
| `sc125BotBacktesting` | `/trade/bots/backtesting` | `lib/features/trade/presentation/pages/bot_backtesting_page.dart` | `BotBacktestingPage` | `real_page` |
| `sc126BotStrategyCompare` | `/trade/bots/strategy-compare` | `lib/features/trade/presentation/pages/bot_strategy_compare_page.dart` | `BotStrategyComparePage` | `real_page` |
| `sc127BotOptimization` | `/trade/bots/optimization` | `lib/features/trade/presentation/pages/bot_optimization_page.dart` | `BotOptimizationPage` | `real_page` |
| `sc128BotPortfolioDashboard` | `/trade/bots/portfolio-dashboard` | `lib/features/trade/presentation/pages/bot_portfolio_dashboard_page.dart` | `BotPortfolioDashboardPage` | `real_page` |
| `sc129BotDrawdownAnalyzer` | `/trade/bots/drawdown-analyzer` | `lib/features/trade/presentation/pages/bot_drawdown_analyzer_page.dart` | `BotDrawdownAnalyzerPage` | `real_page` |
| `sc130BotEquityCurve` | `/trade/bots/equity-curve` | `lib/features/trade/presentation/pages/bot_equity_curve_page.dart` | `BotEquityCurvePage` | `real_page` |
| `sc131BotGuide` | `/trade/bots/guide` | `lib/features/trade/presentation/pages/bot_guide_page.dart` | `BotGuidePage` | `real_page` |
| `sc132BotFaq` | `/trade/bots/faq` | `lib/features/trade/presentation/pages/bot_faq_page.dart` | `BotFaqPage` | `real_page` |
| `sc133BotTaxReporting` | `/trade/bots/tax-reporting` | `lib/features/trade/presentation/pages/bot_tax_reporting_page.dart` | `BotTaxReportingPage` | `real_page` |
| `sc134BotApiDocumentation` | `/trade/bots/api-documentation` | `lib/features/trade/presentation/pages/bot_api_documentation_page.dart` | `BotApiDocumentationPage` | `real_page` |
| `sc411ClientOptUpRequest` | `/trade/copy-trading/client-opt-up-request` | `lib/features/trade/presentation/pages/client_categorization_page_part_01.dart` | `ClientOptUpRequestPage` | `real_page` |
| `sc412TradeCopyRegulatoryDisclosuresAlias` | `/trade/copy-trading/regulatory-disclosures-alias → /trade/copy-trading/regulatory-disclosures` | `lib/features/trade/presentation/pages/regulatory_disclosures_page.dart` | `RegulatoryDisclosuresPage` | `redirect_alias` |
| `sc414PredictionTournamentDetail` | `/markets/predictions/tournament/:tournamentId` | `lib/features/predictions/presentation/widgets/prediction_tournaments_detail.dart` | `PredictionTournamentDetailPage` | `real_page` |
| `sc415TargetMarketDefinitionDetail` | `${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId` | `lib/features/trade/presentation/pages/target_market_definition_page.dart` | `TargetMarketDefinitionPage` | `real_page` |
| `sc416ComplaintTrackingDetail` | `/trade/copy-trading/complaint-tracking/:complaintId` | `lib/features/trade/presentation/pages/complaint_tracking_page.dart` | `ComplaintTrackingPage` | `real_page` |

## wallet (21)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc135Wallet` | `/wallet` | `lib/features/wallet/presentation/pages/wallet_page.dart` | `WalletPage` | `real_page` |
| `sc136TxHistory` | `/wallet/history` | `lib/features/wallet/presentation/pages/transaction_history_page.dart` | `TransactionHistoryPage` | `real_page` |
| `sc137Deposit` | `/wallet/deposit` | `lib/features/wallet/presentation/pages/deposit_page.dart` | `DepositPage` | `real_page` |
| `sc138DepositUsdt` | `${AppRoutePaths.walletDeposit}/:asset` | `lib/features/wallet/presentation/pages/deposit_page.dart` | `DepositPage` | `real_page` |
| `sc139Withdraw` | `/wallet/withdraw` | `lib/features/wallet/presentation/pages/withdraw_page.dart` | `WithdrawPage` | `real_page` |
| `sc140WithdrawUsdt` | `${AppRoutePaths.walletWithdraw}/:asset` | `lib/features/wallet/presentation/pages/withdraw_page.dart` | `WithdrawPage` | `real_page` |
| `sc141TransactionDetail` | `/wallet/transaction/:txId` | `lib/features/wallet/presentation/pages/transaction_detail_page.dart` | `TransactionDetailPage` | `real_page` |
| `sc142PortfolioAnalytics` | `/wallet/portfolio-analytics` | `lib/features/wallet/presentation/pages/portfolio_analytics_page.dart` | `PortfolioAnalyticsPage` | `real_page` |
| `sc143AddressAdd` | `/wallet/address-book/add` | `lib/features/wallet/presentation/pages/address_add_page.dart` | `AddressAddPage` | `real_page` |
| `sc144AddressBook` | `/wallet/address-book` | `lib/features/wallet/presentation/pages/address_book_page.dart` | `AddressBookPage` | `real_page` |
| `sc145BuyCrypto` | `/wallet/buy-crypto` | `lib/features/wallet/presentation/pages/buy_crypto_page.dart` | `BuyCryptoPage` | `real_page` |
| `sc146Transfer` | `/wallet/transfer` | `lib/features/wallet/presentation/pages/transfer_page.dart` | `TransferPage` | `real_page` |
| `sc147AssetDetail` | `/wallet/asset/:assetId` | `lib/features/wallet/presentation/pages/asset_detail_page.dart` | `AssetDetailPage` | `real_page` |
| `sc148MultiManager` | `/wallet/multi-manager` | `lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart` | `WalletMultiManagerPage` | `real_page` |
| `sc149GasOptimizer` | `/wallet/gas-optimizer` | `lib/features/wallet/presentation/pages/wallet_gas_optimizer_page.dart` | `WalletGasOptimizerPage` | `real_page` |
| `sc150TokenApproval` | `/wallet/token-approval` | `lib/features/wallet/presentation/pages/wallet_token_approval_page.dart` | `WalletTokenApprovalPage` | `real_page` |
| `sc151HealthScore` | `/wallet/health-score` | `lib/features/wallet/presentation/pages/wallet_health_score_page.dart` | `WalletHealthScorePage` | `real_page` |
| `sc152PendingDeposits` | `/wallet/pending-deposits` | `lib/features/wallet/presentation/pages/pending_deposits_page.dart` | `PendingDepositsPage` | `real_page` |
| `sc153WithdrawLimits` | `/wallet/limits` | `lib/features/wallet/presentation/pages/withdraw_limits_page.dart` | `WithdrawLimitsPage` | `real_page` |
| `sc154DustConverter` | `/wallet/dust-converter` | `lib/features/wallet/presentation/pages/dust_converter_page.dart` | `DustConverterPage` | `real_page` |
| `sc155NetworkStatus` | `/wallet/network-status` | `lib/features/wallet/presentation/pages/network_status_page.dart` | `NetworkStatusPage` | `real_page` |

## p2p (77)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc210P2PExpressConfirm` | `/p2p/express/confirm` | `lib/features/p2p/presentation/pages/p2p_express_confirm_page.dart` | `P2PExpressConfirmPage` | `real_page` |
| `sc211P2PExpress` | `/p2p/express` | `lib/features/p2p/presentation/pages/p2p_express_page.dart` | `P2PExpressPage` | `real_page` |
| `sc212P2POrderTimeline` | `/p2p/order/timeline/:orderId` | `lib/features/p2p/presentation/pages/p2p_order_timeline_page.dart` | `P2POrderTimelinePage` | `real_page` |
| `sc213P2POrderRate` | `/p2p/order/rate/:orderId` | `lib/features/p2p/presentation/pages/p2p_order_rate_page.dart` | `P2POrderRatePage` | `real_page` |
| `sc214P2POrderCancel` | `/p2p/order/cancel/:orderId` | `lib/features/p2p/presentation/pages/p2p_order_cancel_page.dart` | `P2POrderCancelPage` | `real_page` |
| `sc215P2POrderProof` | `/p2p/order/proof/:orderId` | `lib/features/p2p/presentation/pages/p2p_order_proof_page.dart` | `P2POrderProofPage` | `real_page` |
| `sc216P2POrder` | `/p2p/order/:orderId` | `lib/features/p2p/presentation/pages/p2p_order_page.dart` | `P2POrderPage` | `real_page` |
| `sc217P2PChat` | `/p2p/chat/:orderId` | `lib/features/p2p/presentation/pages/p2p_chat_page.dart` | `P2PChatPage` | `real_page` |
| `sc218P2PDisputeDetail` | `/p2p/dispute/detail/:disputeId` | `lib/features/p2p/presentation/pages/p2p_dispute_detail_page.dart` | `P2PDisputeDetailPage` | `real_page` |
| `sc219P2PDisputeEvidence` | `/p2p/dispute/evidence/:disputeId` | `lib/features/p2p/presentation/pages/p2p_dispute_evidence_page.dart` | `P2PDisputeEvidencePage` | `real_page` |
| `sc220P2PDisputeResolution` | `/p2p/dispute/resolution/:disputeId` | `lib/features/p2p/presentation/pages/p2p_dispute_resolution_page.dart` | `P2PDisputeResolutionPage` | `real_page` |
| `sc221P2PDispute` | `/p2p/dispute/:orderId` | `lib/features/p2p/presentation/pages/p2p_dispute_page.dart` | `P2PDisputePage` | `real_page` |
| `sc222P2PDisputes` | `/p2p/disputes` | `lib/features/p2p/presentation/pages/p2p_disputes_page.dart` | `P2PDisputesPage` | `real_page` |
| `sc223P2PAdAnalytics` | `/p2p/ad-analytics/:adId` | `lib/features/p2p/presentation/pages/p2p_ad_analytics_page.dart` | `P2PAdAnalyticsPage` | `real_page` |
| `sc224P2PAdDetail` | `/p2p/ad/:adId` | `lib/features/p2p/presentation/pages/p2p_ad_detail_page.dart` | `P2PAdDetailPage` | `real_page` |
| `sc225P2PMyAds` | `/p2p/my-ads` | `lib/features/p2p/presentation/pages/p2p_my_ads_page.dart` | `P2PMyAdsPage` | `real_page` |
| `sc226P2PCreateAd` | `/p2p/create` | `lib/features/p2p/presentation/pages/p2p_create_ad_page.dart` | `P2PCreateAdPage` | `real_page` |
| `sc227P2PMerchantApply` | `/p2p/merchant-apply` | `lib/features/p2p/presentation/pages/p2p_merchant_apply_page.dart` | `P2PMerchantApplyPage` | `real_page` |
| `sc228P2PMerchantProfile` | `/p2p/merchant/:merchantId` | `lib/features/p2p/presentation/pages/p2p_merchant_profile_page.dart` | `P2PMerchantProfilePage` | `real_page` |
| `sc229P2PReportMerchant` | `/p2p/report/:merchantId` | `lib/features/p2p/presentation/pages/p2p_report_merchant_page.dart` | `P2PReportMerchantPage` | `real_page` |
| `sc230P2PTradingLevel` | `/p2p/trading-level` | `lib/features/p2p/presentation/pages/p2p_trading_level_page.dart` | `P2PTradingLevelPage` | `real_page` |
| `sc231P2PReviews` | `/p2p/reviews` | `lib/features/p2p/presentation/pages/p2p_reviews_page.dart` | `P2PReviewsPage` | `real_page` |
| `sc232P2PPaymentMethodAdd` | `/p2p/payment-method/add` | `lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart` | `P2PPaymentMethodAddPage` | `real_page` |
| `sc233P2PPaymentMethodVerification` | `/p2p/payment-method/verification/:methodId` | `lib/features/p2p/presentation/pages/p2p_payment_method_verification_page.dart` | `P2PPaymentMethodVerificationPage` | `real_page` |
| `sc234P2PPaymentMethodOwnership` | `/p2p/payment-method/ownership/:methodId` | `lib/features/p2p/presentation/pages/p2p_payment_method_ownership_page.dart` | `P2PPaymentMethodOwnershipPage` | `real_page` |
| `sc235P2PPaymentMethodCoolingPeriod` | `/p2p/payment-method/cooling-period` | `lib/features/p2p/presentation/pages/p2p_payment_method_cooling_period_page.dart` | `P2PPaymentMethodCoolingPeriodPage` | `real_page` |
| `sc236P2PPaymentMethodHistory` | `/p2p/payment-method/history` | `lib/features/p2p/presentation/pages/p2p_payment_method_history_page.dart` | `P2PPaymentMethodHistoryPage` | `real_page` |
| `sc237P2PPaymentMethods` | `/p2p/payment-methods` | `lib/features/p2p/presentation/pages/p2p_payment_methods_page.dart` | `P2PPaymentMethodsPage` | `real_page` |
| `sc238P2PInsuranceFund` | `/p2p/insurance` | `lib/features/p2p/presentation/pages/p2p_insurance_fund_page.dart` | `P2PInsuranceFundPage` | `real_page` |
| `sc239P2PInsuranceCertificate` | `/p2p/insurance/certificate` | `lib/features/p2p/presentation/pages/p2p_insurance_certificate_page.dart` | `P2PInsuranceCertificatePage` | `real_page` |
| `sc240P2PInsuranceScore` | `/p2p/insurance/score` | `lib/features/p2p/presentation/pages/p2p_insurance_score_page.dart` | `P2PInsuranceScorePage` | `real_page` |
| `sc241P2PInsurancePolicy` | `/p2p/insurance/policy` | `lib/features/p2p/presentation/pages/p2p_insurance_policy_page.dart` | `P2PInsurancePolicyPage` | `real_page` |
| `sc242P2PContributionHistory` | `/p2p/insurance/contribution-history` | `lib/features/p2p/presentation/pages/p2p_contribution_history_page.dart` | `P2PContributionHistoryPage` | `real_page` |
| `sc243P2PClaimDetail` | `/p2p/insurance/claim/:claimId` | `lib/features/p2p/presentation/pages/p2p_claim_detail_page.dart` | `P2PClaimDetailPage` | `real_page` |
| `sc244P2PInsuranceFundAlias` | `/p2p/insurance-fund` | `lib/features/p2p/presentation/pages/p2p_insurance_fund_page.dart` | `P2PInsuranceFundPage` | `real_page` |
| `sc245P2PEscrowBalance` | `/p2p/escrow/balance` | `lib/features/p2p/presentation/pages/p2p_escrow_balance_page.dart` | `P2PEscrowBalancePage` | `real_page` |
| `sc246P2PEscrowDetail` | `/p2p/escrow/:orderId` | `lib/features/p2p/presentation/pages/p2p_escrow_detail_page.dart` | `P2PEscrowDetailPage` | `real_page` |
| `sc247P2PKycRequirements` | `/p2p/kyc/requirements` | `lib/features/p2p/presentation/pages/p2p_kyc_requirements_page.dart` | `P2PKycRequirementsPage` | `real_page` |
| `sc248P2PKycStatus` | `/p2p/kyc/status` | `lib/features/p2p/presentation/pages/p2p_kyc_status_page.dart` | `P2PKycStatusPage` | `real_page` |
| `sc249P2PIdentityVerification` | `/p2p/kyc/identity` | `lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart` | `P2PIdentityVerificationPage` | `real_page` |
| `sc250P2PAddressProof` | `/p2p/kyc/address` | `lib/features/p2p/presentation/pages/p2p_address_proof_page.dart` | `P2PAddressProofPage` | `real_page` |
| `sc251P2PSelfieVerification` | `/p2p/kyc/selfie` | `lib/features/p2p/presentation/pages/p2p_selfie_verification_page.dart` | `P2PSelfieVerificationPage` | `real_page` |
| `sc252P2PVideoVerification` | `/p2p/kyc/video` | `lib/features/p2p/presentation/pages/p2p_video_verification_page.dart` | `P2PVideoVerificationPage` | `real_page` |
| `sc253P2PSecurityCenter` | `/p2p/security/center` | `lib/features/p2p/presentation/pages/p2p_security_center_page.dart` | `P2PSecurityCenterPage` | `real_page` |
| `sc254P2P2FASettings` | `/p2p/security/2fa` | `lib/features/p2p/presentation/pages/p2p_2fa_settings_page.dart` | `P2P2FASettingsPage` | `real_page` |
| `sc255P2PDeviceManagement` | `/p2p/security/devices` | `lib/features/p2p/presentation/pages/p2p_device_management_page.dart` | `P2PDeviceManagementPage` | `real_page` |
| `sc256P2PAntiPhishingCode` | `/p2p/security/anti-phishing` | `lib/features/p2p/presentation/pages/p2p_anti_phishing_code_page.dart` | `P2PAntiPhishingCodePage` | `real_page` |
| `sc257P2PLoginHistory` | `/p2p/security/login-history` | `lib/features/p2p/presentation/pages/p2p_login_history_page.dart` | `P2PLoginHistoryPage` | `real_page` |
| `sc258P2PSuspiciousActivity` | `/p2p/security/suspicious-activity` | `lib/features/p2p/presentation/pages/p2p_suspicious_activity_page.dart` | `P2PSuspiciousActivityPage` | `real_page` |
| `sc259P2PE2EInfo` | `/p2p/e2e-info` | `lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart` | `P2PE2EInfoPage` | `real_page` |
| `sc260P2PFraudPrevention` | `/p2p/fraud-prevention` | `lib/features/p2p/presentation/pages/p2p_fraud_prevention_page.dart` | `P2PFraudPreventionPage` | `real_page` |
| `sc261P2PWalletTransfer` | `/p2p/wallet/transfer` | `lib/features/p2p/presentation/pages/p2p_wallet_transfer_page.dart` | `P2PWalletTransferPage` | `real_page` |
| `sc262P2PFundLockHistory` | `/p2p/wallet/fund-lock-history` | `lib/features/p2p/presentation/pages/p2p_fund_lock_history_page.dart` | `P2PFundLockHistoryPage` | `real_page` |
| `sc263P2PWalletHistoryAlias` | `/p2p/wallet/history` | `lib/features/p2p/presentation/pages/p2p_fund_lock_history_page.dart` | `P2PFundLockHistoryPage` | `real_page` |
| `sc264P2PWallet` | `/p2p/wallet` | `lib/features/p2p/presentation/pages/p2p_wallet_page.dart` | `P2PWalletPage` | `real_page` |
| `sc265P2PLimitTracker` | `/p2p/limits/tracker` | `lib/features/p2p/presentation/pages/p2p_limit_tracker_page.dart` | `P2PLimitTrackerPage` | `real_page` |
| `sc266P2PTransactionLimits` | `/p2p/limits` | `lib/features/p2p/presentation/pages/p2p_transaction_limits_page.dart` | `P2PTransactionLimitsPage` | `real_page` |
| `sc267P2PComplianceOverview` | `/p2p/compliance/overview` | `lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart` | `P2PComplianceOverviewPage` | `real_page` |
| `sc268P2PAmlScreening` | `/p2p/compliance/aml-screening` | `lib/features/p2p/presentation/pages/p2p_aml_screening_page.dart` | `P2PAmlScreeningPage` | `real_page` |
| `sc269P2PSourceOfFunds` | `/p2p/compliance/source-of-funds` | `lib/features/p2p/presentation/pages/p2p_source_of_funds_page.dart` | `P2PSourceOfFundsPage` | `real_page` |
| `sc270P2PLargeTransaction` | `/p2p/compliance/large-transaction` | `lib/features/p2p/presentation/pages/p2p_large_transaction_justification_page.dart` | `P2PLargeTransactionJustificationPage` | `real_page` |
| `sc271P2PRiskAssessment` | `/p2p/compliance/risk-assessment` | `lib/features/p2p/presentation/pages/p2p_risk_assessment_page.dart` | `P2PRiskAssessmentPage` | `real_page` |
| `sc272P2PTaxReporting` | `/p2p/tax-reporting` | `lib/features/p2p/presentation/pages/p2p_tax_reporting_page.dart` | `P2PTaxReportingPage` | `real_page` |
| `sc273P2POrderBook` | `/p2p/order-book` | `lib/features/p2p/presentation/pages/p2p_order_book_page.dart` | `P2POrderBookPage` | `real_page` |
| `sc274P2PDashboard` | `/p2p/dashboard` | `lib/features/p2p/presentation/pages/p2p_dashboard_page.dart` | `P2PDashboardPage` | `real_page` |
| `sc275P2PAchievements` | `/p2p/achievements` | `lib/features/p2p/presentation/pages/p2p_achievements_page.dart` | `P2PAchievementsPage` | `real_page` |
| `sc276P2PBlacklistAdd` | `/p2p/blacklist/add` | `lib/features/p2p/presentation/pages/p2p_blacklist_add_page.dart` | `P2PBlacklistAddPage` | `real_page` |
| `sc277P2PBlacklist` | `/p2p/blacklist` | `lib/features/p2p/presentation/pages/p2p_blacklist_page.dart` | `P2PBlacklistPage` | `real_page` |
| `sc278P2PNotificationsSettings` | `/p2p/settings/notifications` | `lib/features/p2p/presentation/pages/p2p_notifications_settings_page.dart` | `P2PNotificationsSettingsPage` | `real_page` |
| `sc279P2PSettings` | `/p2p/settings` | `lib/features/p2p/presentation/pages/p2p_settings_page.dart` | `P2PSettingsPage` | `real_page` |
| `sc280P2PGuide` | `/p2p/guide` | `lib/features/p2p/presentation/pages/p2p_guide_page.dart` | `P2PGuidePage` | `real_page` |
| `sc281P2PMyOrders` | `/p2p/my-orders` | `lib/features/p2p/presentation/pages/p2p_my_orders_page.dart` | `P2PMyOrdersPage` | `real_page` |
| `sc282P2PHome` | `/p2p` | `lib/features/p2p/presentation/pages/p2p_home_page.dart` | `P2PHomePage` | `real_page` |
| `sc402P2PKycVerify` | `/p2p/kyc/verify` | `lib/features/p2p/presentation/pages/p2p_identity_verification_page.dart` | `P2PIdentityVerificationPage` | `real_page` |
| `sc403P2PKycFaceMatch` | `/p2p/kyc/face-match` | `lib/features/p2p/presentation/pages/p2p_selfie_verification_page.dart` | `P2PSelfieVerificationPage` | `real_page` |
| `sc404P2PWhitelistMode` | `/p2p/security/whitelist` | `lib/features/p2p/presentation/pages/p2p_security_center_page.dart` | `P2PWhitelistModePage` | `real_page` |
| `sc407P2PTaxReportDetail` | `/p2p/tax-report/detailed/:year` | `lib/features/p2p/presentation/pages/p2p_tax_reporting_page.dart` | `P2PTaxReportingPage` | `real_page` |

## earn (70)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc327StakingEarn` | `/earn` | `lib/features/earn/presentation/pages/staking_earn_page.dart` | `StakingEarnPage` | `real_page` |
| `sc328StakingEarnStaking` | `/earn/staking` | `lib/features/earn/presentation/pages/staking_earn_page.dart` | `StakingEarnPage` | `real_page` |
| `sc329Savings` | `/earn/savings` | `lib/features/earn/presentation/pages/savings_page.dart` | `SavingsPage` | `real_page` |
| `sc330SavingsProductDetail` | `/earn/savings/product/sample` | `lib/features/earn/presentation/pages/savings_product_detail_page.dart` | `SavingsProductDetailPage` | `real_page` |
| `sc331SavingsRedeem` | `/earn/savings/redeem/pos001` | `lib/features/earn/presentation/pages/savings_redeem_page.dart` | `SavingsRedeemPage` | `real_page` |
| `sc332SavingsReceipt` | `/earn/savings/receipt` | `lib/features/earn/presentation/pages/savings_receipt_page.dart` | `SavingsReceiptPage` | `real_page` |
| `sc333SavingsPortfolio` | `/earn/savings/portfolio` | `lib/features/earn/presentation/pages/savings_portfolio_page.dart` | `SavingsPortfolioPage` | `real_page` |
| `sc334SavingsHistory` | `/earn/savings/history` | `lib/features/earn/presentation/pages/savings_history_page.dart` | `SavingsHistoryPage` | `real_page` |
| `sc335SavingsGuide` | `/earn/savings/guide` | `lib/features/earn/presentation/pages/savings_guide_page.dart` | `SavingsGuidePage` | `real_page` |
| `sc336SavingsFAQ` | `/earn/savings/faq` | `lib/features/earn/presentation/pages/savings_faq_page.dart` | `SavingsFAQPage` | `real_page` |
| `sc337SavingsNotifications` | `/earn/savings/notifications` | `lib/features/earn/presentation/pages/savings_notifications_page.dart` | `SavingsNotificationsPage` | `real_page` |
| `sc338SavingsRecommendations` | `/earn/savings/recommendations` | `lib/features/earn/presentation/pages/savings_recommendations_page.dart` | `SavingsRecommendationsPage` | `real_page` |
| `sc339SavingsRiskAssessment` | `/earn/savings/risk-assessment` | `lib/features/earn/presentation/pages/savings_risk_assessment_page.dart` | `SavingsRiskAssessmentPage` | `real_page` |
| `sc340SavingsComparison` | `/earn/savings/comparison` | `lib/features/earn/presentation/pages/savings_comparison_page.dart` | `SavingsComparisonPage` | `real_page` |
| `sc341AutoCompoundSettings` | `/earn/savings/auto-compound` | `lib/features/earn/presentation/pages/auto_compound_settings_page.dart` | `AutoCompoundSettingsPage` | `real_page` |
| `sc342SavingsGoal` | `/earn/savings/goals` | `lib/features/earn/presentation/pages/savings_goal_page.dart` | `SavingsGoalPage` | `real_page` |
| `sc343SavingsAnalytics` | `/earn/savings/analytics` | `lib/features/earn/presentation/pages/savings_analytics_page.dart` | `SavingsAnalyticsPage` | `real_page` |
| `sc344SavingsAutoRebalance` | `/earn/savings/rebalance` | `lib/features/earn/presentation/pages/savings_auto_rebalance_page.dart` | `SavingsAutoRebalancePage` | `real_page` |
| `sc345SavingsNotificationPreferences` | `/earn/savings/notification-preferences` | `lib/features/earn/presentation/pages/savings_notification_preferences_page.dart` | `SavingsNotificationPreferencesPage` | `real_page` |
| `sc346SavingsDca` | `/earn/savings/dca` | `lib/features/earn/presentation/pages/savings_dca_page.dart` | `SavingsDCAPage` | `real_page` |
| `sc347SavingsSmartSuggestions` | `/earn/savings/smart-suggestions` | `lib/features/earn/presentation/pages/savings_smart_suggestions_page.dart` | `SavingsSmartSuggestionsPage` | `real_page` |
| `sc348SavingsExport` | `/earn/savings/export` | `lib/features/earn/presentation/pages/savings_export_page.dart` | `SavingsExportPage` | `real_page` |
| `sc349SavingsBacktest` | `/earn/savings/backtest` | `lib/features/earn/presentation/pages/savings_backtest_page.dart` | `SavingsBacktestPage` | `real_page` |
| `sc350SavingsAutoPilot` | `/earn/savings/autopilot` | `lib/features/earn/presentation/pages/savings_autopilot_page.dart` | `SavingsAutoPilotPage` | `real_page` |
| `sc351SavingsLadder` | `/earn/savings/ladder` | `lib/features/earn/presentation/pages/savings_ladder_page.dart` | `SavingsLadderPage` | `real_page` |
| `sc352SavingsWhatIf` | `/earn/savings/whatif` | `lib/features/earn/presentation/pages/savings_what_if_page.dart` | `SavingsWhatIfPage` | `real_page` |
| `sc353StakingTerms` | `/earn/staking/terms` | `lib/features/earn/presentation/pages/staking_terms_page.dart` | `StakingTermsPage` | `real_page` |
| `sc354StakingRiskDisclosure` | `/earn/staking/risk-disclosure` | `lib/features/earn/presentation/pages/staking_risk_disclosure_page.dart` | `StakingRiskDisclosurePage` | `real_page` |
| `sc355StakingWithdrawalPolicy` | `/earn/staking/withdrawal-policy` | `lib/features/earn/presentation/pages/staking_withdrawal_policy_page.dart` | `StakingWithdrawalPolicyPage` | `real_page` |
| `sc356StakingTaxGuide` | `/earn/staking/tax-guide` | `lib/features/earn/presentation/pages/staking_tax_guide_page.dart` | `StakingTaxGuidePage` | `real_page` |
| `sc357StakingRiskAssessment` | `/earn/staking/risk-assessment` | `lib/features/earn/presentation/pages/staking_risk_assessment_page.dart` | `StakingRiskAssessmentPage` | `real_page` |
| `sc358StakingDashboard` | `/earn/dashboard` | `lib/features/earn/presentation/pages/staking_dashboard_page.dart` | `StakingDashboardPage` | `real_page` |
| `sc359StakingAnalytics` | `/earn/analytics` | `lib/features/earn/presentation/pages/staking_analytics_page.dart` | `StakingAnalyticsPage` | `real_page` |
| `sc360StakingHistory` | `/earn/history` | `lib/features/earn/presentation/pages/staking_history_page.dart` | `StakingHistoryPage` | `real_page` |
| `sc361StakingEarningsCalendar` | `/earn/calendar` | `lib/features/earn/presentation/pages/staking_earnings_calendar_page.dart` | `StakingEarningsCalendarPage` | `real_page` |
| `sc362StakingValidatorSelection` | `/earn/validator-selection` | `lib/features/earn/presentation/pages/staking_validator_selection_page.dart` | `StakingValidatorSelectionPage` | `real_page` |
| `sc363StakingAutoCompound` | `/earn/auto-compound` | `lib/features/earn/presentation/pages/staking_auto_compound_page.dart` | `StakingAutoCompoundPage` | `real_page` |
| `sc364StakingLiquidStaking` | `/earn/liquid-staking` | `lib/features/earn/presentation/pages/staking_liquid_staking_page.dart` | `StakingLiquidStakingPage` | `real_page` |
| `sc365StakingInsurance` | `/earn/insurance` | `lib/features/earn/presentation/pages/staking_insurance_page.dart` | `StakingInsurancePage` | `real_page` |
| `sc366StakingAdvancedOrders` | `/earn/advanced-orders` | `lib/features/earn/presentation/pages/staking_advanced_orders_page.dart` | `StakingAdvancedOrdersPage` | `real_page` |
| `sc367StakingMultiChain` | `/earn/multi-chain` | `lib/features/earn/presentation/pages/staking_multi_chain_page.dart` | `StakingMultiChainPage` | `real_page` |
| `sc368StakingInstitutional` | `/earn/institutional` | `lib/features/earn/presentation/pages/staking_institutional_page.dart` | `StakingInstitutionalPage` | `real_page` |
| `sc369StakingGuide` | `/earn/guide` | `lib/features/earn/presentation/pages/staking_guide_page.dart` | `StakingGuidePage` | `real_page` |
| `sc370StakingFAQ` | `/earn/faq` | `lib/features/earn/presentation/pages/staking_faq_page.dart` | `StakingFAQPage` | `real_page` |
| `sc371StakingNotifications` | `/earn/notifications` | `lib/features/earn/presentation/pages/staking_notifications_page.dart` | `StakingNotificationsPage` | `real_page` |
| `sc372StakingRecommendations` | `/earn/recommendations` | `lib/features/earn/presentation/pages/staking_recommendations_page.dart` | `StakingRecommendationsPage` | `real_page` |
| `sc373StakingRegulatoryFramework` | `/earn/regulatory-framework` | `lib/features/earn/presentation/pages/staking_regulatory_framework_page.dart` | `StakingRegulatoryFrameworkPage` | `real_page` |
| `sc374StakingAuditReports` | `/earn/audit-reports` | `lib/features/earn/presentation/pages/staking_audit_reports_page.dart` | `StakingAuditReportsPage` | `real_page` |
| `sc375StakingCustody` | `/earn/custody` | `lib/features/earn/presentation/pages/staking_custody_page.dart` | `StakingCustodyPage` | `real_page` |
| `sc376StakingSuitabilityAssessment` | `/earn/suitability-assessment` | `lib/features/earn/presentation/pages/staking_suitability_assessment_page.dart` | `StakingSuitabilityAssessmentPage` | `real_page` |
| `sc377StakingInsuranceFundTransparency` | `/earn/insurance-fund-transparency` | `lib/features/earn/presentation/pages/staking_insurance_fund_transparency_page.dart` | `StakingInsuranceFundTransparencyPage` | `real_page` |
| `sc378StakingTransactionReporting` | `/earn/transaction-reporting` | `lib/features/earn/presentation/pages/staking_transaction_reporting_page.dart` | `StakingTransactionReportingPage` | `real_page` |
| `sc379StakingApiDocumentation` | `/earn/api-documentation` | `lib/features/earn/presentation/pages/staking_api_documentation_page.dart` | `StakingApiDocumentationPage` | `real_page` |
| `sc380StakingProofOfReserves` | `/earn/proof-of-reserves` | `lib/features/earn/presentation/pages/staking_proof_of_reserves_page.dart` | `StakingProofOfReservesPage` | `real_page` |
| `sc381StakingRiskDashboard` | `/earn/risk-dashboard` | `lib/features/earn/presentation/pages/staking_risk_dashboard_page.dart` | `StakingRiskDashboardPage` | `real_page` |
| `sc382StakingSlashingHistory` | `/earn/slashing-history` | `lib/features/earn/presentation/pages/staking_slashing_history_page.dart` | `StakingSlashingHistoryPage` | `real_page` |
| `sc383StakingValidatorHealthMonitor` | `/earn/validator-health-monitor` | `lib/features/earn/presentation/pages/staking_validator_health_monitor_page.dart` | `StakingValidatorHealthMonitorPage` | `real_page` |
| `sc384StakingRiskScoreCalculator` | `/earn/risk-score-calculator` | `lib/features/earn/presentation/pages/staking_risk_score_calculator_page.dart` | `StakingRiskScoreCalculatorPage` | `real_page` |
| `sc385StakingEmergencyActions` | `/earn/emergency-actions` | `lib/features/earn/presentation/pages/staking_emergency_actions_page.dart` | `StakingEmergencyActionsPage` | `real_page` |
| `sc386StakingContingencyPlan` | `/earn/contingency-plan` | `lib/features/earn/presentation/pages/staking_contingency_plan_page.dart` | `StakingContingencyPlanPage` | `real_page` |
| `sc387StakingSocialFeed` | `/earn/social-feed` | `lib/features/earn/presentation/pages/staking_social_feed_page.dart` | `StakingSocialFeedPage` | `real_page` |
| `sc388StakingCommunityGovernance` | `/earn/community-governance` | `lib/features/earn/presentation/pages/staking_community_governance_page.dart` | `StakingCommunityGovernancePage` | `real_page` |
| `sc389StakingProposals` | `/earn/proposals` | `lib/features/earn/presentation/pages/staking_proposals_page.dart` | `StakingProposalsPage` | `real_page` |
| `sc390StakingVotingDetail` | `/earn/voting/:proposalId` | `lib/features/earn/presentation/pages/staking_voting_page.dart` | `StakingVotingPage` | `real_page` |
| `sc391StakingVoting` | `/earn/voting` | `lib/features/earn/presentation/pages/staking_voting_page.dart` | `StakingVotingPage` | `real_page` |
| `sc392StakingForum` | `/earn/forum` | `lib/features/earn/presentation/pages/staking_forum_page.dart` | `StakingForumPage` | `real_page` |
| `sc393StakingWebhooks` | `/earn/webhooks` | `lib/features/earn/presentation/pages/staking_webhooks_page.dart` | `StakingWebhooksPage` | `real_page` |
| `sc394StakingDataExport` | `/earn/data-export` | `lib/features/earn/presentation/pages/staking_data_export_page.dart` | `StakingDataExportPage` | `real_page` |
| `sc395StakingThirdPartyIntegrations` | `/earn/third-party-integrations` | `lib/features/earn/presentation/pages/staking_third_party_integrations_page.dart` | `StakingThirdPartyIntegrationsPage` | `real_page` |
| `sc396StakingDeveloperConsole` | `/earn/developer-console` | `lib/features/earn/presentation/pages/staking_developer_console_page.dart` | `StakingDeveloperConsolePage` | `real_page` |

## dca (13)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc169Dca` | `/dca` | `lib/features/dca/presentation/pages/dca_page.dart` | `DCAPage` | `real_page` |
| `sc170DcaRebalanceConfig` | `/dca/rebalance/config` | `lib/features/dca/presentation/pages/dca_rebalance_config_page.dart` | `DCARebalanceConfig` | `real_page` |
| `sc171DcaRebalanceDashboard` | `/dca/rebalance/config001` | `lib/features/dca/presentation/pages/dca_rebalance_dashboard_page.dart` | `DCARebalanceDashboard` | `real_page` |
| `sc172DcaScheduleConfig` | `/dca/schedule/config` | `lib/features/dca/presentation/pages/dca_schedule_config_page.dart` | `DCAScheduleConfig` | `real_page` |
| `sc173DcaScheduleAnalytics` | `/dca/schedule/config001` | `lib/features/dca/presentation/pages/dca_schedule_analytics_page.dart` | `DCAScheduleAnalytics` | `real_page` |
| `sc174DcaPortfolioOptimizer` | `/dca/portfolio-optimizer` | `lib/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart` | `DCAPortfolioOptimizer` | `real_page` |
| `sc175DcaDynamicAmount` | `/dca/dynamic-amount` | `lib/features/dca/presentation/pages/dca_dynamic_amount_page.dart` | `DCADynamicAmount` | `real_page` |
| `sc176DcaBacktester` | `/dca/backtester` | `lib/features/dca/presentation/pages/dca_backtester_page.dart` | `DCABacktesterPage` | `real_page` |
| `sc177DcaMultiAsset` | `/dca/multi-asset` | `lib/features/dca/presentation/pages/dca_multi_asset_page.dart` | `DCAMultiAssetPage` | `real_page` |
| `sc178DcaPerformanceCompare` | `/dca/performance-compare` | `lib/features/dca/presentation/pages/dca_performance_compare_page.dart` | `DCAPerformanceComparePage` | `real_page` |
| `sc179DcaSmartRules` | `/dca/smart-rules` | `lib/features/dca/presentation/pages/dca_smart_rules_page.dart` | `DCASmartRulesPage` | `real_page` |
| `sc408DcaRebalanceEdit` | `/dca/rebalance/:configId/edit` | `lib/features/dca/presentation/pages/dca_rebalance_config_page.dart` | `DCARebalanceConfig` | `real_page` |
| `sc409DcaRebalanceHistory` | `/dca/rebalance/:configId/history` | `lib/features/dca/presentation/pages/dca_rebalance_dashboard_page.dart` | `DCARebalanceDashboard` | `real_page` |

## launchpad (24)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc295Launchpad` | `/launchpad` | `lib/features/launchpad/presentation/pages/launchpad_page.dart` | `LaunchpadPage` | `real_page` |
| `sc296LaunchpadPortfolio` | `/launchpad/portfolio` | `lib/features/launchpad/presentation/pages/launchpad_portfolio_page.dart` | `LaunchpadPortfolioPage` | `real_page` |
| `sc297LaunchpadPerformance` | `/launchpad/performance` | `lib/features/launchpad/presentation/pages/launchpad_performance_page.dart` | `LaunchpadPerformancePage` | `real_page` |
| `sc298LaunchpadStaking` | `/launchpad/staking` | `lib/features/launchpad/presentation/pages/launchpad_staking_page.dart` | `LaunchpadStakingPage` | `real_page` |
| `sc299LaunchpadIdoBridge` | `/launchpad/idobridge/sample` | `lib/features/launchpad/presentation/pages/launchpad_ido_bridge_page.dart` | `LaunchpadIdoBridgePage` | `real_page` |
| `sc300LaunchpadContract` | `/launchpad/contract/sample` | `lib/features/launchpad/presentation/pages/launchpad_contract_page.dart` | `LaunchpadContractPage` | `real_page` |
| `sc301LaunchpadReceipt` | `/launchpad/receipt/sub001` | `lib/features/launchpad/presentation/pages/launchpad_receipt_page.dart` | `LaunchpadReceiptPage` | `real_page` |
| `sc302LaunchpadClaimReceipt` | `/launchpad/claim-receipt/pos001` | `lib/features/launchpad/presentation/pages/launchpad_claim_receipt_page.dart` | `LaunchpadClaimReceiptPage` | `real_page` |
| `sc303LaunchpadBridgeOrder` | `/launchpad/bridge-order/tx001` | `lib/features/launchpad/presentation/pages/launchpad_bridge_order_page.dart` | `LaunchpadBridgeOrderPage` | `real_page` |
| `sc304LaunchpadBatchClaim` | `/launchpad/batch-claim` | `lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart` | `LaunchpadBatchClaimPage` | `real_page` |
| `sc305LaunchpadBridgeCompare` | `/launchpad/bridge-compare` | `lib/features/launchpad/presentation/pages/launchpad_bridge_compare_page.dart` | `LaunchpadBridgeComparePage` | `real_page` |
| `sc306LaunchpadNotifSound` | `/launchpad/notif-sound` | `lib/features/launchpad/presentation/pages/launchpad_notif_sound_page.dart` | `LaunchpadNotifSoundPage` | `real_page` |
| `sc307LaunchpadEventLog` | `/launchpad/event-log` | `lib/features/launchpad/presentation/pages/launchpad_event_log_page.dart` | `LaunchpadEventLogPage` | `real_page` |
| `sc308LaunchpadAbiDiff` | `/launchpad/abi-diff/contract001` | `lib/features/launchpad/presentation/pages/launchpad_abi_diff_page.dart` | `LaunchpadAbiDiffPage` | `real_page` |
| `sc309LaunchpadAddressBook` | `/launchpad/address-book` | `lib/features/launchpad/presentation/pages/launchpad_address_book_page.dart` | `LaunchpadAddressBookPage` | `real_page` |
| `sc310LaunchpadWebhooks` | `/launchpad/webhooks` | `lib/features/launchpad/presentation/pages/launchpad_webhooks_page.dart` | `LaunchpadWebhooksPage` | `real_page` |
| `sc311LaunchpadGasTracker` | `/launchpad/gas-tracker` | `lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page.dart` | `LaunchpadGasTrackerPage` | `real_page` |
| `sc312LaunchpadRebalance` | `/launchpad/rebalance` | `lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart` | `LaunchpadRebalancePage` | `real_page` |
| `sc313LaunchpadMultisig` | `/launchpad/multisig` | `lib/features/launchpad/presentation/pages/launchpad_multisig_page.dart` | `LaunchpadMultisigPage` | `real_page` |
| `sc314LaunchpadSwapAggregator` | `/launchpad/swap-aggregator` | `lib/features/launchpad/presentation/pages/launchpad_swap_aggregator_page.dart` | `LaunchpadSwapAggregatorPage` | `real_page` |
| `sc315LaunchpadLimitOrders` | `/launchpad/limit-orders` | `lib/features/launchpad/presentation/pages/launchpad_limit_orders_page.dart` | `LaunchpadLimitOrdersPage` | `real_page` |
| `sc316LaunchpadDcaBuilder` | `/launchpad/dca-builder` | `lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart` | `LaunchpadDcaBuilderPage` | `real_page` |
| `sc317LaunchpadRiskAnalytics` | `/launchpad/risk-analytics` | `lib/features/launchpad/presentation/pages/launchpad_risk_analytics_page.dart` | `LaunchpadRiskAnalyticsPage` | `real_page` |
| `sc318LaunchpadDetail` | `/launchpad/sample` | `lib/features/launchpad/presentation/pages/launchpad_detail_page.dart` | `LaunchpadDetailPage` | `real_page` |

## arena (26)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc184ArenaHome` | `/arena` | `lib/features/arena/presentation/pages/arena_home_page.dart` | `ArenaHomePage` | `real_page` |
| `sc185ArenaStudio` | `/arena/studio` | `lib/features/arena/presentation/pages/arena_studio_page.dart` | `ArenaStudioPage` | `real_page` |
| `sc186ArenaSmartRules` | `/arena/studio/smart-rules` | `lib/features/arena/presentation/pages/arena_smart_rule_builder_page.dart` | `ArenaSmartRuleBuilderPage` | `real_page` |
| `sc187ArenaPresetLibrary` | `/arena/studio/presets` | `lib/features/arena/presentation/pages/arena_universal_preset_library_page.dart` | `ArenaUniversalPresetLibraryPage` | `real_page` |
| `sc188ArenaGovernanceGate` | `/arena/studio/governance` | `lib/features/arena/presentation/pages/arena_governance_gate_page.dart` | `ArenaGovernanceGatePage` | `real_page` |
| `sc189ArenaModeDetail` | `/arena/mode/:modeId` | `lib/features/arena/presentation/pages/arena_mode_detail_page.dart` | `ArenaModeDetailPage` | `real_page` |
| `sc190ArenaChallengeDetail` | `/arena/challenge/:challengeId` | `lib/features/arena/presentation/pages/arena_challenge_detail_page.dart` | `ArenaChallengeDetailPage` | `real_page` |
| `sc191ArenaJoin` | `/arena/join/:challengeId` | `lib/features/arena/presentation/pages/arena_join_page.dart` | `ArenaJoinPage` | `real_page` |
| `sc192ArenaResolutionCenter` | `/arena/resolution` | `lib/features/arena/presentation/pages/arena_resolution_center_page.dart` | `ArenaResolutionCenterPage` | `real_page` |
| `sc193ArenaCreator` | `/arena/creator/:creatorId` | `lib/features/arena/presentation/pages/arena_creator_page.dart` | `ArenaCreatorPage` | `real_page` |
| `sc194ArenaLeaderboard` | `/arena/leaderboard` | `lib/features/arena/presentation/pages/arena_leaderboard_page.dart` | `ArenaLeaderboardPage` | `real_page` |
| `sc195VerifiedChallenges` | `/arena/verified` | `lib/features/arena/presentation/pages/verified_challenges_page.dart` | `VerifiedChallengesPage` | `real_page` |
| `sc196ArenaPoints` | `/rewards?tab=arena (embedded; no standalone GoRoute)` | `lib/features/arena/presentation/pages/arena_points_page.dart` | `ArenaPointsPage` | `embedded_bridge` |
| `sc197ArenaFlowMap` | `/arena/flow-map` | `lib/features/arena/presentation/pages/arena_flow_map_page.dart` | `ArenaFlowMapPage` | `real_page` |
| `sc198ArenaSafetyCenter` | `/arena/safety` | `lib/features/arena/presentation/pages/arena_safety_center_page.dart` | `ArenaSafetyCenterPage` | `real_page` |
| `sc199ArenaTrustBreakdown` | `/arena/trust/:userId` | `lib/features/arena/presentation/pages/arena_trust_breakdown_page.dart` | `ArenaTrustBreakdownPage` | `real_page` |
| `sc200ArenaPointsEntryDetail` | `/arena/ledger/entry/:entryId` | `lib/features/arena/presentation/pages/arena_points_entry_detail_page.dart` | `ArenaPointsEntryDetailPage` | `real_page` |
| `sc201ArenaPointsLedger` | `/arena/ledger` | `lib/features/arena/presentation/pages/arena_points_ledger_page.dart` | `ArenaPointsLedgerPage` | `real_page` |
| `sc202ArenaReportCase` | `/arena/report/:caseId` | `lib/features/arena/presentation/pages/arena_report_case_page.dart` | `ArenaReportCasePage` | `real_page` |
| `sc203ArenaBlockedUsers` | `/arena/blocked` | `lib/features/arena/presentation/pages/arena_blocked_users_page.dart` | `ArenaBlockedUsersPage` | `real_page` |
| `sc204MyArenaReports` | `/arena/my-reports` | `lib/features/arena/presentation/pages/my_arena_reports_page.dart` | `MyArenaReportsPage` | `real_page` |
| `sc205MyArena` | `/arena/my` | `lib/features/arena/presentation/pages/my_arena_page.dart` | `MyArenaPage` | `real_page` |
| `sc206ArenaProductionReady` | `/arena/production` | `lib/features/arena/presentation/pages/arena_production_ready_page.dart` | `ArenaProductionReadyPage` | `real_page` |
| `sc207ArenaPredictionBridgeFoundation` | `/arena/bridge` | `lib/features/arena/presentation/pages/arena_prediction_bridge_foundation_page.dart` | `ArenaPredictionBridgeFoundationPage` | `real_page` |
| `sc208ConnectedEcosystemProduction` | `/arena/ecosystem` | `lib/features/arena/presentation/pages/connected_ecosystem_production_page.dart` | `ConnectedEcosystemProductionPage` | `real_page` |
| `sc209ArenaGuide` | `/arena/guide` | `lib/features/arena/presentation/pages/arena_guide_page.dart` | `ArenaGuidePage` | `real_page` |

## profile (16)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc156Profile` | `/profile` | `lib/features/profile/presentation/pages/profile_page.dart` | `ProfilePage` | `real_page` |
| `sc157EditProfile` | `/profile/edit` | `lib/features/profile/presentation/pages/edit_profile_page.dart` | `EditProfilePage` | `real_page` |
| `sc158Security` | `/profile/security` | `lib/features/profile/presentation/pages/security_page.dart` | `SecurityPage` | `real_page` |
| `sc159Kyc` | `/profile/kyc` | `lib/features/profile/presentation/pages/kyc_page.dart` | `KYCPage` | `real_page` |
| `sc160Settings` | `/profile/settings` | `lib/features/profile/presentation/pages/settings_page.dart` | `SettingsPage` | `real_page` |
| `sc161ActivityLog` | `/profile/activity` | `lib/features/profile/presentation/pages/activity_log_page.dart` | `ActivityLogPage` | `real_page` |
| `sc162ApiKeyCreate` | `/profile/api/create` | `lib/features/profile/presentation/pages/api_key_create_page.dart` | `ApiKeyCreatePage` | `real_page` |
| `sc163ApiManagement` | `/profile/api` | `lib/features/profile/presentation/pages/api_management_page.dart` | `ApiManagementPage` | `real_page` |
| `sc164Vip` | `/profile/vip` | `lib/features/profile/presentation/pages/vip_page.dart` | `VIPPage` | `real_page` |
| `sc165DeviceManagement` | `/profile/devices` | `lib/features/profile/presentation/pages/device_management_page.dart` | `DeviceManagementPage` | `real_page` |
| `sc166SubAccount` | `/profile/sub-accounts` | `lib/features/profile/presentation/pages/sub_account_page.dart` | `SubAccountPage` | `real_page` |
| `sc167ProfilePredictions` | `/profile/predictions` | `lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` | `PredictionsPortfolioPage` | `real_page` |
| `sc168MyArena` | `/profile/arena` | `lib/features/arena/presentation/pages/my_arena_page.dart` | `MyArenaPage` | `real_page` |
| `sc405SettingsSecurityBiometric` | `/settings/security/biometric` | `lib/features/profile/presentation/pages/security_page.dart` | `SecurityPage` | `real_page` |
| `sc406SettingsSecurityChangePassword` | `/settings/security/change-password` | `lib/features/profile/presentation/pages/security_page.dart` | `SecurityPage` | `real_page` |
| `sc413SettingsSecurity` | `/settings/security` | `lib/features/profile/presentation/pages/security_page.dart` | `SecurityPage` | `real_page` |

## referral (5)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc286ReferralHistory` | `/referral/history` | `lib/features/referral/presentation/pages/referral_history_page.dart` | `ReferralHistoryPage` | `real_page` |
| `sc287ReferralRewards` | `/referral/rewards` | `lib/features/referral/presentation/pages/referral_rewards_page.dart` | `ReferralRewardsPage` | `real_page` |
| `sc288ReferralRules` | `/referral/rules` | `lib/features/referral/presentation/pages/referral_rules_page.dart` | `ReferralRulesPage` | `real_page` |
| `sc289ReferralFriendDetail` | `/referral/friend/:friendId` | `lib/features/referral/presentation/pages/referral_friend_detail_page.dart` | `ReferralFriendDetailPage` | `real_page` |
| `sc290ReferralHome` | `/referral` | `lib/features/referral/presentation/pages/referral_home_page.dart` | `ReferralHomePage` | `real_page` |

## support (3)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc292HelpCenter` | `/support/help` | `lib/features/support/presentation/pages/help_center_page.dart` | `HelpCenterPage` | `real_page` |
| `sc293Announcements` | `/support/announcements` | `lib/features/support/presentation/pages/announcements_page.dart` | `AnnouncementsPage` | `real_page` |
| `sc294Support` | `/support` | `lib/features/support/presentation/pages/support_page.dart` | `SupportPage` | `real_page` |

## rewards (1)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc319RewardsHub` | `/rewards` | `lib/features/rewards/presentation/pages/rewards_hub_page.dart` | `RewardsHubPage` | `real_page` |

## cross_module (4)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc321UnifiedPortfolio` | `/unified-portfolio` | `lib/features/cross_module/presentation/pages/unified_portfolio_dashboard.dart` | `UnifiedPortfolioDashboard` | `real_page` |
| `sc322CrossModuleAnalytics` | `/cross-module-analytics` | `lib/features/cross_module/presentation/pages/cross_module_analytics.dart` | `CrossModuleAnalytics` | `real_page` |
| `sc323SmartAlertCenter` | `/smart-alerts` | `lib/features/cross_module/presentation/pages/smart_alert_center.dart` | `SmartAlertCenter` | `real_page` |
| `sc324TaxReportCenter` | `/tax-reports` | `lib/features/cross_module/presentation/pages/tax_report_center.dart` | `TaxReportCenter` | `real_page` |

## enterprise_states (1)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc320EnterpriseStates` | `/enterprise-states` | `lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` | `EnterpriseStatesPage` | `real_page` |

## admin (5)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc180AdminHome` | `/admin` | `lib/features/admin/presentation/pages/admin_home.dart` | `AdminHome` | `real_page` |
| `sc181AnalyticsDashboard` | `/admin/analytics` | `lib/features/admin/presentation/pages/analytics_dashboard.dart` | `AnalyticsDashboard` | `real_page` |
| `sc182AbTestDashboard` | `/admin/abtests` | `lib/features/admin/presentation/pages/ab_test_dashboard.dart` | `ABTestDashboard` | `real_page` |
| `sc183FunnelDashboard` | `/admin/funnels` | `lib/features/admin/presentation/pages/funnel_dashboard.dart` | `FunnelDashboard` | `real_page` |
| `sc410AdminSettings` | `/admin/settings` | `lib/features/admin/presentation/pages/admin_settings_page.dart` | `AdminSettingsPage` | `real_page` |

## dev (6)

| sc_id | route_path | page_file | widget_class | classification |
| --- | --- | --- | --- | --- |
| `sc325RouteChecker` | `/dev/route-checker` | `lib/features/dev/presentation/pages/route_checker_page.dart` | `RouteChecker` | `real_page` |
| `sc326PerformanceMonitor` | `/dev/performance-monitor` | `lib/features/dev/presentation/pages/performance_monitor.dart` | `PerformanceMonitor` | `real_page` |
| `sc398MissingScreensShowcase` | `/dev/showcase` | `lib/features/dev/presentation/pages/missing_screens_showcase_page.dart` | `MissingScreensShowcasePage` | `real_page` |
| `sc399DesignSystem` | `/dev/design-system` | `lib/features/dev/presentation/pages/design_system_page.dart` | `DesignSystemPage` | `real_page` |
| `sc400DcaOverviewDemo` | `/dev/dca-overview` | `lib/features/dca/presentation/pages/dca_overview_demo.dart` | `DCAOverviewDemo` | `real_page` |
| `sc401CopyTradingCardDemo` | `/demo/copy-card` | `lib/features/trade/presentation/pages/copy_trading_card_demo.dart` | `CopyTradingCardDemo` | `real_page` |
