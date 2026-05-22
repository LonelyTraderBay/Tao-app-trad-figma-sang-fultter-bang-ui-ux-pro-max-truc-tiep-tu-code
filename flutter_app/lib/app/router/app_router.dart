import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/otp_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/reset_password_page.dart';
import '../../features/auth/presentation/two_fa_setup_page.dart';
import '../../features/home/data/home_mock_data.dart';
import '../../features/markets/presentation/advanced_charts_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/markets/presentation/derivatives_overview_page.dart';
import '../../features/markets/presentation/comparison_tool_page.dart';
import '../../features/markets/presentation/market_calendar_page.dart';
import '../../features/markets/presentation/market_correlations_page.dart';
import '../../features/markets/presentation/market_depth_page.dart';
import '../../features/markets/presentation/market_heatmap_page.dart';
import '../../features/markets/presentation/market_list_page.dart';
import '../../features/markets/presentation/market_movers_page.dart';
import '../../features/markets/presentation/market_news_page.dart';
import '../../features/markets/presentation/market_overview_page.dart';
import '../../features/markets/presentation/pair_detail_page.dart';
import '../../features/markets/presentation/portfolio_tracker_page.dart';
import '../../features/markets/presentation/market_screener_page.dart';
import '../../features/markets/presentation/market_sectors_page.dart';
import '../../features/markets/presentation/price_alerts_page.dart';
import '../../features/markets/presentation/social_signals_page.dart';
import '../../features/markets/presentation/social_sentiment_page.dart';
import '../../features/markets/presentation/token_info_page.dart';
import '../../features/markets/presentation/token_unlocks_page.dart';
import '../../features/markets/presentation/watchlist_page.dart';
import '../../features/news/presentation/news_page.dart';
import '../../features/predictions/presentation/prediction_advanced_chart_page.dart';
import '../../features/predictions/presentation/prediction_data_integration_page.dart';
import '../../features/predictions/presentation/predictions_breaking_page.dart';
import '../../features/predictions/presentation/prediction_event_calendar_page.dart';
import '../../features/predictions/presentation/prediction_event_detail_page.dart';
import '../../features/predictions/presentation/prediction_market_maker_page.dart';
import '../../features/predictions/presentation/prediction_order_receipt_page.dart';
import '../../features/predictions/presentation/prediction_portfolio_analyzer_page.dart';
import '../../features/predictions/presentation/prediction_risk_calculator_page.dart';
import '../../features/predictions/presentation/prediction_social_page.dart';
import '../../features/predictions/presentation/prediction_tournaments_page.dart';
import '../../features/predictions/presentation/predictions_global_activity_page.dart';
import '../../features/predictions/presentation/predictions_home_page.dart';
import '../../features/predictions/presentation/predictions_leaderboard_page.dart';
import '../../features/predictions/presentation/predictions_portfolio_page.dart';
import '../../features/predictions/presentation/predictions_rewards_page.dart';
import '../../features/predictions/presentation/predictions_search_page.dart';
import '../../features/profile/presentation/edit_profile_page.dart';
import '../../features/profile/presentation/activity_log_page.dart';
import '../../features/profile/presentation/api_management_page.dart';
import '../../features/profile/presentation/api_key_create_page.dart';
import '../../features/profile/presentation/kyc_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/security_page.dart';
import '../../features/profile/presentation/settings_page.dart';
import '../../features/trade/presentation/trade_page.dart';
import '../../features/trade/presentation/orders_history_page.dart';
import '../../features/trade/presentation/order_receipt_page.dart';
import '../../features/trade/presentation/ombudsman_referral_page.dart';
import '../../features/trade/presentation/trade_settings_page.dart';
import '../../features/trade/presentation/transaction_reporting_page.dart';
import '../../features/trade/presentation/position_dashboard_page.dart';
import '../../features/trade/presentation/trade_history_export_page.dart';
import '../../features/trade/presentation/advanced_chart_page.dart';
import '../../features/trade/presentation/advanced_analytics_page.dart';
import '../../features/trade/presentation/advanced_tools_demo_page.dart';
import '../../features/trade/presentation/advanced_trading_demo_page.dart';
import '../../features/trade/presentation/active_copies_page.dart';
import '../../features/trade/presentation/arm_integration_status_page.dart';
import '../../features/trade/presentation/audit_trail_page.dart';
import '../../features/trade/presentation/best_execution_reports_page.dart';
import '../../features/trade/presentation/bot_api_documentation_page.dart';
import '../../features/trade/presentation/bot_backtesting_page.dart';
import '../../features/trade/presentation/bot_drawdown_analyzer_page.dart';
import '../../features/trade/presentation/bot_equity_curve_page.dart';
import '../../features/trade/presentation/bot_faq_page.dart';
import '../../features/trade/presentation/bot_guide_page.dart';
import '../../features/trade/presentation/bot_history_page.dart';
import '../../features/trade/presentation/bot_optimization_page.dart';
import '../../features/trade/presentation/bot_performance_analytics_page.dart';
import '../../features/trade/presentation/bot_portfolio_dashboard_page.dart';
import '../../features/trade/presentation/bot_strategy_compare_page.dart';
import '../../features/trade/presentation/bot_tax_reporting_page.dart';
import '../../features/trade/presentation/bot_emergency_stop_page.dart';
import '../../features/trade/presentation/bot_risk_dashboard_page.dart';
import '../../features/trade/presentation/bot_risk_disclosure_page.dart';
import '../../features/trade/presentation/bot_security_settings_page.dart';
import '../../features/trade/presentation/bot_suitability_assessment_page.dart';
import '../../features/trade/presentation/bot_terms_of_service_page.dart';
import '../../features/trade/presentation/cass_reconciliation_page.dart';
import '../../features/trade/presentation/client_categorization_page.dart';
import '../../features/trade/presentation/client_money_protection_page.dart';
import '../../features/trade/presentation/complaint_submission_page.dart';
import '../../features/trade/presentation/complaint_tracking_page.dart';
import '../../features/trade/presentation/complaints_handling_page.dart';
import '../../features/trade/presentation/copy_audit_log_page.dart';
import '../../features/trade/presentation/copy_confirmation_page.dart';
import '../../features/trade/presentation/copy_education_page.dart';
import '../../features/trade/presentation/copy_configuration_page.dart';
import '../../features/trade/presentation/copy_notifications_page.dart';
import '../../features/trade/presentation/copy_performance_page.dart';
import '../../features/trade/presentation/copy_provider_detail_page.dart';
import '../../features/trade/presentation/copy_safety_center_page.dart';
import '../../features/trade/presentation/copy_settings_page.dart';
import '../../features/trade/presentation/copy_trading_page.dart';
import '../../features/trade/presentation/copy_trading_v2_page.dart';
import '../../features/trade/presentation/convert_page.dart';
import '../../features/trade/presentation/dispute_resolution_page.dart';
import '../../features/trade/presentation/ex_ante_costs_page.dart';
import '../../features/trade/presentation/ex_post_costs_report_page.dart';
import '../../features/trade/presentation/execution_quality_demo_page.dart';
import '../../features/trade/presentation/execution_venue_analysis_page.dart';
import '../../features/trade/presentation/futures_page.dart';
import '../../features/trade/presentation/investor_compensation_page.dart';
import '../../features/trade/presentation/kid_generator_page.dart';
import '../../features/trade/presentation/leverage_page.dart';
import '../../features/trade/presentation/live_market_data_analytics_page.dart';
import '../../features/trade/presentation/margin_trading_page.dart';
import '../../features/trade/presentation/margin_trading_hub_page.dart';
import '../../features/trade/presentation/market_data_analytics_page.dart';
import '../../features/trade/presentation/performance_attribution_page.dart';
import '../../features/trade/presentation/performance_scenarios_page.dart';
import '../../features/trade/presentation/pre_copy_assessment_page.dart';
import '../../features/trade/presentation/portfolio_risk_analysis_page.dart';
import '../../features/trade/presentation/product_governance_page.dart';
import '../../features/trade/presentation/provider_comparison_page.dart';
import '../../features/trade/presentation/provider_governance_page.dart';
import '../../features/trade/presentation/provider_leaderboard_page.dart';
import '../../features/trade/presentation/provider_application_page.dart';
import '../../features/trade/presentation/regulatory_disclosures_page.dart';
import '../../features/trade/presentation/regulatory_inspection_ready_page.dart';
import '../../features/trade/presentation/regulatory_reports_dashboard_page.dart';
import '../../features/trade/presentation/risk_indicator_explainer_page.dart';
import '../../features/trade/presentation/risk_management_demo_page.dart';
import '../../features/trade/presentation/riy_calculator_page.dart';
import '../../features/trade/presentation/safety_education_page.dart';
import '../../features/trade/presentation/slippage_monitoring_page.dart';
import '../../features/trade/presentation/target_market_definition_page.dart';
import '../../features/trade/presentation/trading_bots_page.dart';
import '../../features/trade/presentation/trader_profile_page.dart';
import '../../features/wallet/presentation/address_add_page.dart';
import '../../features/wallet/presentation/address_book_page.dart';
import '../../features/wallet/presentation/asset_detail_page.dart';
import '../../features/wallet/presentation/buy_crypto_page.dart';
import '../../features/wallet/presentation/deposit_page.dart';
import '../../features/wallet/presentation/dust_converter_page.dart';
import '../../features/wallet/presentation/network_status_page.dart';
import '../../features/wallet/presentation/pending_deposits_page.dart';
import '../../features/wallet/presentation/portfolio_analytics_page.dart';
import '../../features/wallet/presentation/transaction_detail_page.dart';
import '../../features/wallet/presentation/transaction_history_page.dart';
import '../../features/wallet/presentation/transfer_page.dart';
import '../../features/wallet/presentation/wallet_gas_optimizer_page.dart';
import '../../features/wallet/presentation/wallet_health_score_page.dart';
import '../../features/wallet/presentation/wallet_multi_manager_page.dart';
import '../../features/wallet/presentation/wallet_page.dart';
import '../../features/wallet/presentation/wallet_token_approval_page.dart';
import '../../features/wallet/presentation/withdraw_page.dart';
import '../../features/wallet/presentation/withdraw_limits_page.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/layout/vit_app_shell.dart';
import '../../shared/layout/vit_bottom_nav.dart';
import '../../shared/layout/vit_header.dart';
import '../../shared/layout/vit_page_content.dart';
import '../../shared/layout/vit_page_layout.dart';
import '../../shared/layout/shell_render_mode.dart';
import '../../shared/layout/vit_phone_frame.dart';
import '../../shared/layout/vit_status_bar.dart';

final class AppRouteNames {
  const AppRouteNames._();

  static const String sc001Login = 'sc001Login';
  static const String sc002Register = 'sc002Register';
  static const String sc003Otp = 'sc003Otp';
  static const String sc004TwoFaSetup = 'sc004TwoFaSetup';
  static const String sc005ForgotPassword = 'sc005ForgotPassword';
  static const String sc006ResetPassword = 'sc006ResetPassword';
  static const String sc007Home = 'sc007Home';
  static const String sc008MarketList = 'sc008MarketList';
  static const String sc009MarketOverview = 'sc009MarketOverview';
  static const String sc010MarketMovers = 'sc010MarketMovers';
  static const String sc011MarketSectors = 'sc011MarketSectors';
  static const String sc012Watchlist = 'sc012Watchlist';
  static const String sc013MarketHeatmap = 'sc013MarketHeatmap';
  static const String sc014PriceAlerts = 'sc014PriceAlerts';
  static const String sc015MarketScreener = 'sc015MarketScreener';
  static const String sc016ComparisonTool = 'sc016ComparisonTool';
  static const String sc017MarketCalendar = 'sc017MarketCalendar';
  static const String sc018DerivativesOverview = 'sc018DerivativesOverview';
  static const String sc019MarketDepth = 'sc019MarketDepth';
  static const String sc020SocialSentiment = 'sc020SocialSentiment';
  static const String sc021PortfolioTracker = 'sc021PortfolioTracker';
  static const String sc022MarketNews = 'sc022MarketNews';
  static const String sc023AdvancedCharts = 'sc023AdvancedCharts';
  static const String sc024TokenUnlocks = 'sc024TokenUnlocks';
  static const String sc025SocialSignals = 'sc025SocialSignals';
  static const String sc026MarketCorrelations = 'sc026MarketCorrelations';
  static const String sc027PredictionsHome = 'sc027PredictionsHome';
  static const String sc028PredictionsSearch = 'sc028PredictionsSearch';
  static const String sc029PredictionsBreaking = 'sc029PredictionsBreaking';
  static const String sc030PredictionEventDetail = 'sc030PredictionEventDetail';
  static const String sc031PredictionsPortfolio = 'sc031PredictionsPortfolio';
  static const String sc032PredictionsRewards = 'sc032PredictionsRewards';
  static const String sc033PredictionsLeaderboard =
      'sc033PredictionsLeaderboard';
  static const String sc034PredictionsGlobalActivity =
      'sc034PredictionsGlobalActivity';
  static const String sc035PredictionOrderReceipt =
      'sc035PredictionOrderReceipt';
  static const String sc036PredictionRiskCalculator =
      'sc036PredictionRiskCalculator';
  static const String sc037PredictionMarketMaker = 'sc037PredictionMarketMaker';
  static const String sc038PredictionPortfolioAnalyzer =
      'sc038PredictionPortfolioAnalyzer';
  static const String sc039PredictionEventCalendar =
      'sc039PredictionEventCalendar';
  static const String sc040PredictionSocial = 'sc040PredictionSocial';
  static const String sc041PredictionAdvancedChart =
      'sc041PredictionAdvancedChart';
  static const String sc042PredictionTournaments = 'sc042PredictionTournaments';
  static const String sc043PredictionDataIntegration =
      'sc043PredictionDataIntegration';
  static const String sc044PairDetail = 'sc044PairDetail';
  static const String sc045TokenInfo = 'sc045TokenInfo';
  static const String sc046PairDepth = 'sc046PairDepth';
  static const String sc047News = 'sc047News';
  static const String sc048Trade = 'sc048Trade';
  static const String sc049TradePair = 'sc049TradePair';
  static const String sc050OrdersHistory = 'sc050OrdersHistory';
  static const String sc051OrderReceipt = 'sc051OrderReceipt';
  static const String sc052TradeSettings = 'sc052TradeSettings';
  static const String sc053PositionDashboard = 'sc053PositionDashboard';
  static const String sc054TradeHistoryExport = 'sc054TradeHistoryExport';
  static const String sc055AdvancedChart = 'sc055AdvancedChart';
  static const String sc056Convert = 'sc056Convert';
  static const String sc057Futures = 'sc057Futures';
  static const String sc058Leverage = 'sc058Leverage';
  static const String sc059TradingBots = 'sc059TradingBots';
  static const String sc060RiskManagement = 'sc060RiskManagement';
  static const String sc061ExecutionQuality = 'sc061ExecutionQuality';
  static const String sc062AdvancedTools = 'sc062AdvancedTools';
  static const String sc063CopyTrading = 'sc063CopyTrading';
  static const String sc064CopyTradingV2 = 'sc064CopyTradingV2';
  static const String sc065CopyEducation = 'sc065CopyEducation';
  static const String sc066ActiveCopies = 'sc066ActiveCopies';
  static const String sc067CopySettings = 'sc067CopySettings';
  static const String sc068CopyNotifications = 'sc068CopyNotifications';
  static const String sc069ProviderApplication = 'sc069ProviderApplication';
  static const String sc070CopyProviderDetail = 'sc070CopyProviderDetail';
  static const String sc071PreCopyAssessment = 'sc071PreCopyAssessment';
  static const String sc072CopyConfiguration = 'sc072CopyConfiguration';
  static const String sc073CopyConfirmation = 'sc073CopyConfirmation';
  static const String sc074CopyPerformance = 'sc074CopyPerformance';
  static const String sc075PerformanceAttribution =
      'sc075PerformanceAttribution';
  static const String sc076ProviderComparison = 'sc076ProviderComparison';
  static const String sc077CopyAuditLog = 'sc077CopyAuditLog';
  static const String sc078PortfolioRiskAnalysis = 'sc078PortfolioRiskAnalysis';
  static const String sc079ProviderLeaderboard = 'sc079ProviderLeaderboard';
  static const String sc080SafetyEducation = 'sc080SafetyEducation';
  static const String sc081ProviderGovernance = 'sc081ProviderGovernance';
  static const String sc082DisputeResolution = 'sc082DisputeResolution';
  static const String sc083CopySafetyCenter = 'sc083CopySafetyCenter';
  static const String sc084RegulatoryDisclosures = 'sc084RegulatoryDisclosures';
  static const String sc085MarginTrading = 'sc085MarginTrading';
  static const String sc086MarginTradingPair = 'sc086MarginTradingPair';
  static const String sc087TraderProfile = 'sc087TraderProfile';
  static const String sc088AdvancedTradingDemo = 'sc088AdvancedTradingDemo';
  static const String sc089MarketDataAnalytics = 'sc089MarketDataAnalytics';
  static const String sc090MarginTradingHub = 'sc090MarginTradingHub';
  static const String sc091LiveMarketDataAnalytics =
      'sc091LiveMarketDataAnalytics';
  static const String sc092AdvancedAnalytics = 'sc092AdvancedAnalytics';
  static const String sc093TransactionReporting = 'sc093TransactionReporting';
  static const String sc094RegulatoryReportsDashboard =
      'sc094RegulatoryReportsDashboard';
  static const String sc095ArmIntegrationStatus = 'sc095ArmIntegrationStatus';
  static const String sc096BestExecutionReports = 'sc096BestExecutionReports';
  static const String sc097ExecutionVenueAnalysis =
      'sc097ExecutionVenueAnalysis';
  static const String sc098SlippageMonitoring = 'sc098SlippageMonitoring';
  static const String sc099ClientCategorization = 'sc099ClientCategorization';
  static const String sc100ProductGovernance = 'sc100ProductGovernance';
  static const String sc101TargetMarketDefinition =
      'sc101TargetMarketDefinition';
  static const String sc102ClientMoneyProtection = 'sc102ClientMoneyProtection';
  static const String sc103CassReconciliation = 'sc103CassReconciliation';
  static const String sc104InvestorCompensation = 'sc104InvestorCompensation';
  static const String sc105ExAnteCosts = 'sc105ExAnteCosts';
  static const String sc106RiyCalculator = 'sc106RiyCalculator';
  static const String sc107ExPostCostsReport = 'sc107ExPostCostsReport';
  static const String sc108KidGenerator = 'sc108KidGenerator';
  static const String sc109PerformanceScenarios = 'sc109PerformanceScenarios';
  static const String sc110RiskIndicatorExplainer =
      'sc110RiskIndicatorExplainer';
  static const String sc111ComplaintsHandling = 'sc111ComplaintsHandling';
  static const String sc112ComplaintSubmission = 'sc112ComplaintSubmission';
  static const String sc113ComplaintTracking = 'sc113ComplaintTracking';
  static const String sc114OmbudsmanReferral = 'sc114OmbudsmanReferral';
  static const String sc115AuditTrail = 'sc115AuditTrail';
  static const String sc116RegulatoryInspectionReady =
      'sc116RegulatoryInspectionReady';
  static const String sc117BotTermsOfService = 'sc117BotTermsOfService';
  static const String sc118BotRiskDisclosure = 'sc118BotRiskDisclosure';
  static const String sc119BotSuitabilityAssessment =
      'sc119BotSuitabilityAssessment';
  static const String sc120BotRiskDashboard = 'sc120BotRiskDashboard';
  static const String sc121BotEmergencyStop = 'sc121BotEmergencyStop';
  static const String sc122BotSecuritySettings = 'sc122BotSecuritySettings';
  static const String sc123BotHistory = 'sc123BotHistory';
  static const String sc124BotPerformanceAnalytics =
      'sc124BotPerformanceAnalytics';
  static const String sc125BotBacktesting = 'sc125BotBacktesting';
  static const String sc126BotStrategyCompare = 'sc126BotStrategyCompare';
  static const String sc127BotOptimization = 'sc127BotOptimization';
  static const String sc128BotPortfolioDashboard = 'sc128BotPortfolioDashboard';
  static const String sc129BotDrawdownAnalyzer = 'sc129BotDrawdownAnalyzer';
  static const String sc130BotEquityCurve = 'sc130BotEquityCurve';
  static const String sc131BotGuide = 'sc131BotGuide';
  static const String sc132BotFaq = 'sc132BotFaq';
  static const String sc133BotTaxReporting = 'sc133BotTaxReporting';
  static const String sc134BotApiDocumentation = 'sc134BotApiDocumentation';
  static const String sc135Wallet = 'sc135Wallet';
  static const String sc136TxHistory = 'sc136TxHistory';
  static const String sc137Deposit = 'sc137Deposit';
  static const String sc138DepositUsdt = 'sc138DepositUsdt';
  static const String sc139Withdraw = 'sc139Withdraw';
  static const String sc140WithdrawUsdt = 'sc140WithdrawUsdt';
  static const String sc141TransactionDetail = 'sc141TransactionDetail';
  static const String sc142PortfolioAnalytics = 'sc142PortfolioAnalytics';
  static const String sc143AddressAdd = 'sc143AddressAdd';
  static const String sc144AddressBook = 'sc144AddressBook';
  static const String sc145BuyCrypto = 'sc145BuyCrypto';
  static const String sc146Transfer = 'sc146Transfer';
  static const String sc147AssetDetail = 'sc147AssetDetail';
  static const String sc148MultiManager = 'sc148MultiManager';
  static const String sc149GasOptimizer = 'sc149GasOptimizer';
  static const String sc150TokenApproval = 'sc150TokenApproval';
  static const String sc151HealthScore = 'sc151HealthScore';
  static const String sc152PendingDeposits = 'sc152PendingDeposits';
  static const String sc153WithdrawLimits = 'sc153WithdrawLimits';
  static const String sc154DustConverter = 'sc154DustConverter';
  static const String sc155NetworkStatus = 'sc155NetworkStatus';
  static const String sc156Profile = 'sc156Profile';
  static const String sc157EditProfile = 'sc157EditProfile';
  static const String sc158Security = 'sc158Security';
  static const String sc159Kyc = 'sc159Kyc';
  static const String sc160Settings = 'sc160Settings';
  static const String sc161ActivityLog = 'sc161ActivityLog';
  static const String sc162ApiKeyCreate = 'sc162ApiKeyCreate';
  static const String sc163ApiManagement = 'sc163ApiManagement';
}

final class AppRoutePaths {
  const AppRoutePaths._();

  static const String root = '/';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authOtp = '/auth/otp';
  static const String auth2faSetup = '/auth/2fa-setup';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String home = '/home';
  static const String news = '/news';
  static const String markets = '/markets';
  static const String marketsOverview = '/markets/overview';
  static const String marketsMovers = '/markets/movers';
  static const String marketsSectors = '/markets/sectors';
  static const String marketsWatchlist = '/markets/watchlist';
  static const String marketsHeatmap = '/markets/heatmap';
  static const String marketsAlerts = '/markets/alerts';
  static const String marketsScreener = '/markets/screener';
  static const String marketsCompare = '/markets/compare';
  static const String marketsCalendar = '/markets/calendar';
  static const String marketsDerivatives = '/markets/derivatives';
  static const String marketsDepth = '/markets/depth';
  static const String marketsSocialSentiment = '/markets/social-sentiment';
  static const String marketsPortfolioTracker = '/markets/portfolio-tracker';
  static const String marketsNews = '/markets/news';
  static const String marketsAdvancedCharts = '/markets/advanced-charts';
  static const String marketsUnlocks = '/markets/unlocks';
  static const String marketsSignals = '/markets/signals';
  static const String marketsCorrelations = '/markets/correlations';
  static const String marketsPredictions = '/markets/predictions';
  static const String marketsPredictionsSearch = '/markets/predictions/search';
  static const String marketsPredictionsBreaking =
      '/markets/predictions/breaking';
  static const String marketsPredictionsPortfolio =
      '/markets/predictions/portfolio';
  static String marketsPredictionEvent(String eventId) =>
      '/markets/predictions/event/$eventId';
  static String marketsPredictionReceipt(String receiptId) =>
      '/markets/predictions/receipt/$receiptId';
  static const String marketsPredictionsRewards =
      '/markets/predictions/rewards';
  static const String marketsPredictionsLeaderboard =
      '/markets/predictions/leaderboard';
  static const String marketsPredictionsActivity =
      '/markets/predictions/activity';
  static const String marketsPredictionsRiskCalculator =
      '/markets/predictions/risk-calculator';
  static const String marketsPredictionsMarketMaker =
      '/markets/predictions/market-maker';
  static const String marketsPredictionsPortfolioAnalyzer =
      '/markets/predictions/portfolio-analyzer';
  static const String marketsPredictionsEventCalendar =
      '/markets/predictions/event-calendar';
  static const String marketsPredictionsSocial = '/markets/predictions/social';
  static String marketsPredictionsAdvancedChart(String eventId) =>
      '/markets/predictions/advanced-chart/$eventId';
  static const String marketsPredictionsTournaments =
      '/markets/predictions/tournaments';
  static String marketsPredictionTournament(String tournamentId) =>
      '/markets/predictions/tournament/$tournamentId';
  static const String marketsPredictionsDataIntegration =
      '/markets/predictions/data-integration';
  static String pairDetail(String pairId) => '/pair/$pairId';
  static String pairInfo(String pairId) => '/pair/$pairId/info';
  static String pairDepth(String pairId) => '/pair/$pairId/depth';
  static String tradeAdvancedChart(String pairId) =>
      '/trade/advanced-chart/$pairId';
  static String tradePair(String pairId) => '/trade/$pairId';
  static String tradeFutures(String pairId) => '/trade/$pairId/futures';
  static String tradeFuturesLeverage(String pairId) =>
      '/trade/$pairId/futures/leverage';
  static const String tradeOrderReceipt = '/trade/order-receipt';
  static const String tradeOrdersHistory = '/trade/orders-history';
  static const String tradeSettings = '/trade/settings';
  static const String tradePositions = '/trade/positions';
  static const String tradeExport = '/trade/export';
  static const String tradeConvert = '/trade/convert';
  static const String tradeBots = '/trade/bots';
  static const String tradeBotTermsOfService = '/trade/bots/terms-of-service';
  static const String tradeBotRiskDisclosure = '/trade/bots/risk-disclosure';
  static const String tradeBotSuitabilityAssessment =
      '/trade/bots/suitability-assessment';
  static const String tradeBotRiskDashboard = '/trade/bots/risk-dashboard';
  static const String tradeBotEmergencyStop = '/trade/bots/emergency-stop';
  static const String tradeBotSecuritySettings =
      '/trade/bots/security-settings';
  static const String tradeBotHistory = '/trade/bots/history';
  static const String tradeBotPerformanceAnalytics =
      '/trade/bots/performance-analytics';
  static const String tradeBotBacktesting = '/trade/bots/backtesting';
  static const String tradeBotStrategyCompare = '/trade/bots/strategy-compare';
  static const String tradeBotOptimization = '/trade/bots/optimization';
  static const String tradeBotPortfolioDashboard =
      '/trade/bots/portfolio-dashboard';
  static const String tradeBotDrawdownAnalyzer =
      '/trade/bots/drawdown-analyzer';
  static const String tradeBotEquityCurve = '/trade/bots/equity-curve';
  static const String tradeBotGuide = '/trade/bots/guide';
  static const String tradeBotFaq = '/trade/bots/faq';
  static const String tradeBotTaxReporting = '/trade/bots/tax-reporting';
  static const String tradeBotApiDocumentation =
      '/trade/bots/api-documentation';
  static const String tradeRiskManagement = '/trade/risk-management';
  static const String tradeExecutionQuality = '/trade/execution-quality';
  static const String tradeAdvancedTools = '/trade/advanced-tools';
  static const String tradeCopyTrading = '/trade/copy-trading';
  static const String tradeCopyTradingV2 = '/trade/copy-trading/v2';
  static const String tradeCopyEducation = '/trade/copy-trading/education';
  static const String tradeCopyActive = '/trade/copy-trading/active';
  static const String tradeCopySettings = '/trade/copy-trading/settings';
  static const String tradeCopyNotifications =
      '/trade/copy-trading/notifications';
  static const String tradeCopyComparison = '/trade/copy-trading/comparison';
  static const String tradeCopyProviderApply = '/trade/copy-provider-apply';
  static String tradeCopyProvider(String providerId, {String? backPath}) {
    final path = '/trade/copy-provider/$providerId';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderAssessment(String providerId) =>
      '/trade/copy-provider/$providerId/assessment';

  static String tradeCopyProviderConfiguration(
    String providerId, {
    String? backPath,
  }) {
    final path = '/trade/copy-provider/$providerId/configuration';
    if (backPath == null || backPath.isEmpty) return path;
    return '$path?back=${Uri.encodeComponent(backPath)}';
  }

  static String tradeCopyProviderConfirmation(String providerId) =>
      '/trade/copy-provider/$providerId/confirmation';

  static String tradeCopyPerformance(String copyId) =>
      '/trade/copy-performance/$copyId';

  static String tradeCopyPerformanceAttribution(String copyId) =>
      '/trade/copy-performance/$copyId/attribution';

  static String tradeCopyAuditLog(String copyId) =>
      '/trade/copy-audit-log/$copyId';

  static const String tradeCopyRiskAnalysis =
      '/trade/copy-trading/risk-analysis';
  static const String tradeCopyLeaderboard = '/trade/copy-trading/leaderboard';
  static const String tradeCopySafety = '/trade/copy-trading/safety';
  static const String tradeCopyProviderGovernance =
      '/trade/copy-provider-governance';
  static const String tradeCopyDisputeResolution =
      '/trade/copy-dispute-resolution';
  static const String tradeCopySafetyCenter = '/trade/copy-safety-center';
  static const String tradeCopyRegulatoryDisclosures =
      '/trade/copy-regulatory-disclosures';
  static const String tradeCopyTransactionReporting =
      '/trade/copy-trading/transaction-reporting';
  static const String tradeCopyRegulatoryReportsDashboard =
      '/trade/copy-trading/regulatory-reports-dashboard';
  static const String tradeCopyArmIntegrationStatus =
      '/trade/copy-trading/arm-integration-status';
  static const String tradeCopyBestExecutionReports =
      '/trade/copy-trading/best-execution-reports';
  static const String tradeCopyExecutionVenueAnalysis =
      '/trade/copy-trading/execution-venue-analysis';
  static const String tradeCopySlippageMonitoring =
      '/trade/copy-trading/slippage-monitoring';
  static const String tradeCopyClientCategorization =
      '/trade/copy-trading/client-categorization';
  static const String tradeCopyClientOptUpRequest =
      '/trade/copy-trading/client-opt-up-request';
  static const String tradeCopyRegulatoryDisclosuresAlias =
      '/trade/copy-trading/regulatory-disclosures';
  static const String tradeCopyProductGovernance =
      '/trade/copy-trading/product-governance';
  static const String tradeCopyTargetMarketDefinition =
      '/trade/copy-trading/target-market-definition';
  static String tradeCopyTargetMarketDefinitionForProduct(String productId) =>
      '$tradeCopyTargetMarketDefinition/$productId';
  static const String tradeCopyClientMoneyProtection =
      '/trade/copy-trading/client-money-protection';
  static const String tradeCopyCassReconciliation =
      '/trade/copy-trading/cass-reconciliation';
  static const String tradeCopyInvestorCompensation =
      '/trade/copy-trading/investor-compensation';
  static const String tradeCopyExAnteCosts =
      '/trade/copy-trading/ex-ante-costs';
  static const String tradeCopyRiyCalculator =
      '/trade/copy-trading/riy-calculator';
  static const String tradeCopyExPostCostsReport =
      '/trade/copy-trading/ex-post-costs-report';
  static const String tradeCopyKidGenerator =
      '/trade/copy-trading/kid-generator';
  static const String tradeCopyPerformanceScenarios =
      '/trade/copy-trading/performance-scenarios';
  static const String tradeCopyRiskIndicatorExplainer =
      '/trade/copy-trading/risk-indicator-explainer';
  static const String tradeCopyComplaintsHandling =
      '/trade/copy-trading/complaints-handling';
  static const String tradeCopyComplaintSubmission =
      '/trade/copy-trading/complaint-submission';
  static const String tradeCopyComplaintTrackingBase =
      '/trade/copy-trading/complaint-tracking';
  static String tradeCopyComplaintTracking(String complaintId) =>
      '/trade/copy-trading/complaint-tracking/$complaintId';
  static const String tradeCopyOmbudsmanReferral =
      '/trade/copy-trading/ombudsman-referral';
  static const String tradeCopyAuditTrail = '/trade/copy-trading/audit-trail';
  static const String tradeCopyRegulatoryInspectionReady =
      '/trade/copy-trading/regulatory-inspection-ready';
  static const String settingsSecurity = '/settings/security';
  static const String tradeMargin = '/trade/margin';
  static const String tradeMarginBtcusdt = '/trade/margin/btcusdt';
  static const String tradeMarginAdvancedDemo = '/trade/margin/advanced-demo';
  static const String tradeMarginMarketDataAnalytics =
      '/trade/margin/market-data-analytics';
  static const String tradeMarginHub = '/trade/margin/hub';
  static const String tradeMarginLiveMarketDataAnalytics =
      '/trade/margin/live-market-data-analytics';
  static const String tradeMarginAdvancedAnalytics =
      '/trade/margin/advanced-analytics';
  static String tradeTrader(String traderId) => '/trade/trader/$traderId';

  static const String dca = '/dca';
  static const String profilePredictions = '/profile/predictions';
  static const String arena = '/arena';
  static const String arenaStudio = '/arena/studio';
  static const String trade = '/trade';
  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet/history';
  static const String walletDeposit = '/wallet/deposit';
  static String walletDepositAsset(String asset) => '/wallet/deposit/$asset';
  static const String walletWithdraw = '/wallet/withdraw';
  static String walletWithdrawAsset(String asset) => '/wallet/withdraw/$asset';
  static String walletTransaction(String transactionId) =>
      '/wallet/transaction/$transactionId';
  static const String walletPortfolioAnalytics = '/wallet/portfolio-analytics';
  static const String walletAddressBook = '/wallet/address-book';
  static const String walletAddressBookAdd = '/wallet/address-book/add';
  static const String walletBuyCrypto = '/wallet/buy-crypto';
  static const String walletTransfer = '/wallet/transfer';
  static String walletAsset(String assetId) => '/wallet/asset/$assetId';
  static const String walletMultiManager = '/wallet/multi-manager';
  static const String walletGasOptimizer = '/wallet/gas-optimizer';
  static const String walletTokenApproval = '/wallet/token-approval';
  static const String walletHealthScore = '/wallet/health-score';
  static const String walletPendingDeposits = '/wallet/pending-deposits';
  static const String walletLimits = '/wallet/limits';
  static const String walletDustConverter = '/wallet/dust-converter';
  static const String walletNetworkStatus = '/wallet/network-status';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profileKyc = '/profile/kyc';
  static const String profileSecurity = '/profile/security';
  static const String profileVip = '/profile/vip';
  static const String profileApi = '/profile/api';
  static const String profileApiCreate = '/profile/api/create';
  static const String profileDevices = '/profile/devices';
  static const String profileSubAccounts = '/profile/sub-accounts';
  static const String profileSettings = '/profile/settings';
  static const String profileActivity = '/profile/activity';
  static const String profileArena = '/profile/arena';
  static const String onboarding = '/onboarding';
}

const String _initialRouteFromEnvironment = String.fromEnvironment(
  'INITIAL_ROUTE',
);

String get _defaultInitialLocation => _initialRouteFromEnvironment.isEmpty
    ? AppRoutePaths.home
    : _initialRouteFromEnvironment;

GoRouter createAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? _defaultInitialLocation,
    routes: [
      GoRoute(path: AppRoutePaths.root, redirect: (_, _) => AppRoutePaths.home),
      GoRoute(
        path: AppRoutePaths.authLogin,
        name: AppRouteNames.sc001Login,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authRegister,
        name: AppRouteNames.sc002Register,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authOtp,
        name: AppRouteNames.sc003Otp,
        builder: (_, state) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: _buildOtpPage(state),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.auth2faSetup,
        name: AppRouteNames.sc004TwoFaSetup,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const TwoFASetupPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authForgotPassword,
        name: AppRouteNames.sc005ForgotPassword,
        builder: (_, _) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.authResetPassword,
        name: AppRouteNames.sc006ResetPassword,
        builder: (_, state) => _AuthRouteShell(
          renderMode: shellRenderMode,
          child: ResetPasswordPage(
            email: state.uri.queryParameters['email'] ?? 'user@vittrade.vn',
            otp: state.uri.queryParameters['otp'] ?? '123456',
          ),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final activeDestination = _activeDestinationForPath(state.uri.path);
          final appShell = VitAppShell(
            renderMode: shellRenderMode,
            currentPath: state.uri.path,
            activeDestination: activeDestination,
            homeBadgeCount: HomeMockData.homeBadge,
            statusBarTime: shellRenderMode.usesVisualQaFrame
                ? _visualQaStatusBarTimeForPath(state.uri.path)
                : null,
            onDestinationSelected: (destination) {
              context.go(destination.routePath);
            },
            child: child,
          );

          if (!shellRenderMode.usesVisualQaFrame) return appShell;
          return VitPhoneFrame(child: appShell);
        },
        routes: [
          GoRoute(
            path: AppRoutePaths.home,
            name: AppRouteNames.sc007Home,
            builder: (_, _) => HomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.news,
            name: AppRouteNames.sc047News,
            builder: (_, _) => NewsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.markets,
            name: AppRouteNames.sc008MarketList,
            builder: (_, _) => MarketListPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsOverview,
            name: AppRouteNames.sc009MarketOverview,
            builder: (_, _) =>
                MarketOverviewPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsMovers,
            name: AppRouteNames.sc010MarketMovers,
            builder: (_, _) =>
                MarketMoversPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsSectors,
            name: AppRouteNames.sc011MarketSectors,
            builder: (_, state) => MarketSectorsPage(
              shellRenderMode: shellRenderMode,
              selectedSectorId: state.uri.queryParameters['id'],
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsWatchlist,
            name: AppRouteNames.sc012Watchlist,
            builder: (_, _) => WatchlistPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsHeatmap,
            name: AppRouteNames.sc013MarketHeatmap,
            builder: (_, _) =>
                MarketHeatmapPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsAlerts,
            name: AppRouteNames.sc014PriceAlerts,
            builder: (_, _) =>
                PriceAlertsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsScreener,
            name: AppRouteNames.sc015MarketScreener,
            builder: (_, _) =>
                MarketScreenerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsCompare,
            name: AppRouteNames.sc016ComparisonTool,
            builder: (_, _) =>
                ComparisonToolPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsCalendar,
            name: AppRouteNames.sc017MarketCalendar,
            builder: (_, _) =>
                MarketCalendarPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsDerivatives,
            name: AppRouteNames.sc018DerivativesOverview,
            builder: (_, _) =>
                DerivativesOverviewPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsDepth,
            name: AppRouteNames.sc019MarketDepth,
            builder: (_, _) =>
                MarketDepthPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsSocialSentiment,
            name: AppRouteNames.sc020SocialSentiment,
            builder: (_, _) =>
                SocialSentimentPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPortfolioTracker,
            name: AppRouteNames.sc021PortfolioTracker,
            builder: (_, _) =>
                PortfolioTrackerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsNews,
            name: AppRouteNames.sc022MarketNews,
            builder: (_, _) => MarketNewsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsAdvancedCharts,
            name: AppRouteNames.sc023AdvancedCharts,
            builder: (_, _) =>
                AdvancedChartsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsUnlocks,
            name: AppRouteNames.sc024TokenUnlocks,
            builder: (_, _) =>
                TokenUnlocksPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsSignals,
            name: AppRouteNames.sc025SocialSignals,
            builder: (_, _) =>
                SocialSignalsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsCorrelations,
            name: AppRouteNames.sc026MarketCorrelations,
            builder: (_, _) =>
                MarketCorrelationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictions,
            name: AppRouteNames.sc027PredictionsHome,
            builder: (_, _) =>
                PredictionsHomePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsSearch,
            name: AppRouteNames.sc028PredictionsSearch,
            builder: (_, _) =>
                PredictionsSearchPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsBreaking,
            name: AppRouteNames.sc029PredictionsBreaking,
            builder: (_, _) =>
                PredictionsBreakingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/event/:eventId',
            name: AppRouteNames.sc030PredictionEventDetail,
            builder: (_, state) => PredictionEventDetailPage(
              eventId: state.pathParameters['eventId'] ?? 'pred-1',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsPortfolio,
            name: AppRouteNames.sc031PredictionsPortfolio,
            builder: (_, _) =>
                PredictionsPortfolioPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsRewards,
            name: AppRouteNames.sc032PredictionsRewards,
            builder: (_, _) =>
                PredictionsRewardsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsLeaderboard,
            name: AppRouteNames.sc033PredictionsLeaderboard,
            builder: (_, _) =>
                PredictionsLeaderboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsActivity,
            name: AppRouteNames.sc034PredictionsGlobalActivity,
            builder: (_, _) =>
                PredictionsGlobalActivityPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/receipt/:receiptId',
            name: AppRouteNames.sc035PredictionOrderReceipt,
            builder: (_, state) => PredictionOrderReceiptPage(
              receiptId: state.pathParameters['receiptId'] ?? 'p2p001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsRiskCalculator,
            name: AppRouteNames.sc036PredictionRiskCalculator,
            builder: (_, _) =>
                PredictionRiskCalculatorPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsMarketMaker,
            name: AppRouteNames.sc037PredictionMarketMaker,
            builder: (_, _) =>
                PredictionMarketMakerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
            name: AppRouteNames.sc038PredictionPortfolioAnalyzer,
            builder: (_, _) => PredictionPortfolioAnalyzerPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsEventCalendar,
            name: AppRouteNames.sc039PredictionEventCalendar,
            builder: (_, _) =>
                PredictionEventCalendarPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsSocial,
            name: AppRouteNames.sc040PredictionSocial,
            builder: (_, _) =>
                PredictionSocialPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/advanced-chart/:eventId',
            name: AppRouteNames.sc041PredictionAdvancedChart,
            builder: (_, state) => PredictionAdvancedChartPage(
              eventId: state.pathParameters['eventId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsTournaments,
            name: AppRouteNames.sc042PredictionTournaments,
            builder: (_, _) =>
                PredictionTournamentsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/markets/predictions/tournament/:tournamentId',
            builder: (_, state) => _BottomNavRouteSkeleton(
              title:
                  'Tournament ${state.pathParameters['tournamentId'] ?? 'tour'}',
            ),
          ),
          GoRoute(
            path: AppRoutePaths.marketsPredictionsDataIntegration,
            name: AppRouteNames.sc043PredictionDataIntegration,
            builder: (_, _) =>
                PredictionDataIntegrationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/pair/:pairId',
            name: AppRouteNames.sc044PairDetail,
            builder: (_, state) => PairDetailPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/pair/:pairId/info',
            name: AppRouteNames.sc045TokenInfo,
            builder: (_, state) => TokenInfoPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/pair/:pairId/depth',
            name: AppRouteNames.sc046PairDepth,
            builder: (_, state) {
              final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
              return MarketDepthPage(
                pairId: pairId,
                backPath: AppRoutePaths.pairDetail(pairId),
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/advanced-chart/:pairId',
            name: AppRouteNames.sc055AdvancedChart,
            builder: (_, state) => AdvancedChartPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.trade,
            name: AppRouteNames.sc048Trade,
            builder: (_, _) => TradePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeConvert,
            name: AppRouteNames.sc056Convert,
            builder: (_, _) => ConvertPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBots,
            name: AppRouteNames.sc059TradingBots,
            builder: (_, _) =>
                TradingBotsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotTermsOfService,
            name: AppRouteNames.sc117BotTermsOfService,
            builder: (_, _) =>
                BotTermsOfServicePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotRiskDisclosure,
            name: AppRouteNames.sc118BotRiskDisclosure,
            builder: (_, _) =>
                BotRiskDisclosurePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotSuitabilityAssessment,
            name: AppRouteNames.sc119BotSuitabilityAssessment,
            builder: (_, _) =>
                BotSuitabilityAssessmentPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotRiskDashboard,
            name: AppRouteNames.sc120BotRiskDashboard,
            builder: (_, _) =>
                BotRiskDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotEmergencyStop,
            name: AppRouteNames.sc121BotEmergencyStop,
            builder: (_, _) =>
                BotEmergencyStopPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotSecuritySettings,
            name: AppRouteNames.sc122BotSecuritySettings,
            builder: (_, _) =>
                BotSecuritySettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotHistory,
            name: AppRouteNames.sc123BotHistory,
            builder: (_, _) => BotHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotPerformanceAnalytics,
            name: AppRouteNames.sc124BotPerformanceAnalytics,
            builder: (_, _) =>
                BotPerformanceAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotBacktesting,
            name: AppRouteNames.sc125BotBacktesting,
            builder: (_, _) =>
                BotBacktestingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotStrategyCompare,
            name: AppRouteNames.sc126BotStrategyCompare,
            builder: (_, _) =>
                BotStrategyComparePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotOptimization,
            name: AppRouteNames.sc127BotOptimization,
            builder: (_, _) =>
                BotOptimizationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotPortfolioDashboard,
            name: AppRouteNames.sc128BotPortfolioDashboard,
            builder: (_, _) =>
                BotPortfolioDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotDrawdownAnalyzer,
            name: AppRouteNames.sc129BotDrawdownAnalyzer,
            builder: (_, _) =>
                BotDrawdownAnalyzerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotEquityCurve,
            name: AppRouteNames.sc130BotEquityCurve,
            builder: (_, _) =>
                BotEquityCurvePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotGuide,
            name: AppRouteNames.sc131BotGuide,
            builder: (_, _) => BotGuidePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotFaq,
            name: AppRouteNames.sc132BotFaq,
            builder: (_, _) => BotFaqPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotTaxReporting,
            name: AppRouteNames.sc133BotTaxReporting,
            builder: (_, _) =>
                BotTaxReportingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeBotApiDocumentation,
            name: AppRouteNames.sc134BotApiDocumentation,
            builder: (_, _) =>
                BotApiDocumentationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeRiskManagement,
            name: AppRouteNames.sc060RiskManagement,
            builder: (_, _) =>
                RiskManagementDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeExecutionQuality,
            name: AppRouteNames.sc061ExecutionQuality,
            builder: (_, _) =>
                ExecutionQualityDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeAdvancedTools,
            name: AppRouteNames.sc062AdvancedTools,
            builder: (_, _) =>
                AdvancedToolsDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTrading,
            name: AppRouteNames.sc063CopyTrading,
            builder: (_, _) =>
                CopyTradingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTradingV2,
            name: AppRouteNames.sc064CopyTradingV2,
            builder: (_, _) =>
                CopyTradingV2Page(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyEducation,
            name: AppRouteNames.sc065CopyEducation,
            builder: (_, _) =>
                CopyEducationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyActive,
            name: AppRouteNames.sc066ActiveCopies,
            builder: (_, _) =>
                ActiveCopiesPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySettings,
            name: AppRouteNames.sc067CopySettings,
            builder: (_, _) =>
                CopySettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyNotifications,
            name: AppRouteNames.sc068CopyNotifications,
            builder: (_, _) =>
                CopyNotificationsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyProviderApply,
            name: AppRouteNames.sc069ProviderApplication,
            builder: (_, _) =>
                ProviderApplicationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComparison,
            name: AppRouteNames.sc076ProviderComparison,
            builder: (_, _) =>
                ProviderComparisonPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRiskAnalysis,
            name: AppRouteNames.sc078PortfolioRiskAnalysis,
            builder: (_, _) =>
                PortfolioRiskAnalysisPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyLeaderboard,
            name: AppRouteNames.sc079ProviderLeaderboard,
            builder: (_, _) =>
                ProviderLeaderboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySafety,
            name: AppRouteNames.sc080SafetyEducation,
            builder: (_, _) =>
                SafetyEducationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyProviderGovernance,
            name: AppRouteNames.sc081ProviderGovernance,
            builder: (_, _) =>
                ProviderGovernancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyDisputeResolution,
            name: AppRouteNames.sc082DisputeResolution,
            builder: (_, _) =>
                DisputeResolutionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySafetyCenter,
            name: AppRouteNames.sc083CopySafetyCenter,
            builder: (_, _) =>
                CopySafetyCenterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRegulatoryDisclosures,
            name: AppRouteNames.sc084RegulatoryDisclosures,
            builder: (_, _) =>
                RegulatoryDisclosuresPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTransactionReporting,
            name: AppRouteNames.sc093TransactionReporting,
            builder: (_, _) =>
                TransactionReportingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
            name: AppRouteNames.sc094RegulatoryReportsDashboard,
            builder: (_, _) => RegulatoryReportsDashboardPage(
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyArmIntegrationStatus,
            name: AppRouteNames.sc095ArmIntegrationStatus,
            builder: (_, _) =>
                ArmIntegrationStatusPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyBestExecutionReports,
            name: AppRouteNames.sc096BestExecutionReports,
            builder: (_, _) =>
                BestExecutionReportsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyExecutionVenueAnalysis,
            name: AppRouteNames.sc097ExecutionVenueAnalysis,
            builder: (_, _) =>
                ExecutionVenueAnalysisPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopySlippageMonitoring,
            name: AppRouteNames.sc098SlippageMonitoring,
            builder: (_, _) =>
                SlippageMonitoringPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyClientCategorization,
            name: AppRouteNames.sc099ClientCategorization,
            builder: (_, _) =>
                ClientCategorizationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyProductGovernance,
            name: AppRouteNames.sc100ProductGovernance,
            builder: (_, _) =>
                ProductGovernancePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyTargetMarketDefinition,
            name: AppRouteNames.sc101TargetMarketDefinition,
            builder: (_, _) =>
                TargetMarketDefinitionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId',
            builder: (_, state) => TargetMarketDefinitionPage(
              productId: state.pathParameters['productId'] ?? 'prod-1',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyClientMoneyProtection,
            name: AppRouteNames.sc102ClientMoneyProtection,
            builder: (_, _) =>
                ClientMoneyProtectionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyCassReconciliation,
            name: AppRouteNames.sc103CassReconciliation,
            builder: (_, _) =>
                CassReconciliationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyInvestorCompensation,
            name: AppRouteNames.sc104InvestorCompensation,
            builder: (_, _) =>
                InvestorCompensationPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyExAnteCosts,
            name: AppRouteNames.sc105ExAnteCosts,
            builder: (_, _) =>
                ExAnteCostsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRiyCalculator,
            name: AppRouteNames.sc106RiyCalculator,
            builder: (_, _) =>
                RIYCalculatorPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyExPostCostsReport,
            name: AppRouteNames.sc107ExPostCostsReport,
            builder: (_, _) =>
                ExPostCostsReportPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyKidGenerator,
            name: AppRouteNames.sc108KidGenerator,
            builder: (_, _) =>
                KIDGeneratorPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyPerformanceScenarios,
            name: AppRouteNames.sc109PerformanceScenarios,
            builder: (_, _) =>
                PerformanceScenariosPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRiskIndicatorExplainer,
            name: AppRouteNames.sc110RiskIndicatorExplainer,
            builder: (_, _) =>
                RiskIndicatorExplainerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComplaintsHandling,
            name: AppRouteNames.sc111ComplaintsHandling,
            builder: (_, _) =>
                ComplaintsHandlingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComplaintSubmission,
            name: AppRouteNames.sc112ComplaintSubmission,
            builder: (_, _) =>
                ComplaintSubmissionPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyComplaintTrackingBase,
            name: AppRouteNames.sc113ComplaintTracking,
            builder: (_, _) =>
                ComplaintTrackingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/trade/copy-trading/complaint-tracking/:complaintId',
            builder: (_, state) => ComplaintTrackingPage(
              complaintId: state.pathParameters['complaintId'],
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyOmbudsmanReferral,
            name: AppRouteNames.sc114OmbudsmanReferral,
            builder: (_, _) =>
                OmbudsmanReferralPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyAuditTrail,
            name: AppRouteNames.sc115AuditTrail,
            builder: (_, _) => AuditTrailPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeCopyRegulatoryInspectionReady,
            name: AppRouteNames.sc116RegulatoryInspectionReady,
            builder: (_, _) =>
                RegulatoryInspectionReadyPage(shellRenderMode: shellRenderMode),
          ),
          ..._tradeCopyTradingOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.tradeMargin,
            name: AppRouteNames.sc085MarginTrading,
            builder: (_, _) =>
                MarginTradingPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginBtcusdt,
            name: AppRouteNames.sc086MarginTradingPair,
            builder: (_, _) => MarginTradingPage(
              pairId: 'btcusdt',
              pairRouteVariant: true,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/trade/trader/:traderId',
            name: AppRouteNames.sc087TraderProfile,
            builder: (_, state) => TraderProfilePage(
              traderId: state.pathParameters['traderId'] ?? 'trader001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginAdvancedDemo,
            name: AppRouteNames.sc088AdvancedTradingDemo,
            builder: (_, _) =>
                AdvancedTradingDemoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginMarketDataAnalytics,
            name: AppRouteNames.sc089MarketDataAnalytics,
            builder: (_, _) =>
                MarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginHub,
            name: AppRouteNames.sc090MarginTradingHub,
            builder: (_, _) =>
                MarginTradingHubPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
            name: AppRouteNames.sc091LiveMarketDataAnalytics,
            builder: (_, _) =>
                LiveMarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeMarginAdvancedAnalytics,
            name: AppRouteNames.sc092AdvancedAnalytics,
            builder: (_, _) =>
                AdvancedAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          ..._tradeMarginOutgoingPlaceholders,
          ..._tradeBotsOutgoingPlaceholders,
          GoRoute(
            path: '/trade/copy-provider/:providerId/assessment',
            name: AppRouteNames.sc071PreCopyAssessment,
            builder: (_, state) {
              final providerId = state.pathParameters['providerId'] ?? '';
              return PreCopyAssessmentPage(
                providerId: providerId,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-provider/:providerId/configuration',
            name: AppRouteNames.sc072CopyConfiguration,
            builder: (_, state) {
              final backPath = state.uri.queryParameters['back'];
              return CopyConfigurationPage(
                providerId: state.pathParameters['providerId'] ?? '',
                backPath: backPath == null || backPath.isEmpty
                    ? null
                    : backPath,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-provider/:providerId/confirmation',
            name: AppRouteNames.sc073CopyConfirmation,
            builder: (_, state) {
              final providerId = state.pathParameters['providerId'] ?? '';
              return CopyConfirmationPage(
                providerId: providerId,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-provider/:providerId',
            name: AppRouteNames.sc070CopyProviderDetail,
            builder: (_, state) {
              final backPath = state.uri.queryParameters['back'];
              return CopyProviderDetailPage(
                providerId: state.pathParameters['providerId'] ?? 'provider001',
                backPath: backPath == null || backPath.isEmpty
                    ? AppRoutePaths.tradeCopyTrading
                    : backPath,
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-performance/:copyId',
            name: AppRouteNames.sc074CopyPerformance,
            builder: (_, state) {
              return CopyPerformancePage(
                copyId: state.pathParameters['copyId'] ?? 'copy001',
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-performance/:copyId/attribution',
            name: AppRouteNames.sc075PerformanceAttribution,
            builder: (_, state) {
              return PerformanceAttributionPage(
                copyId: state.pathParameters['copyId'] ?? 'copy001',
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: '/trade/copy-audit-log/:copyId',
            name: AppRouteNames.sc077CopyAuditLog,
            builder: (_, state) {
              return CopyAuditLogPage(
                copyId: state.pathParameters['copyId'] ?? 'copy001',
                shellRenderMode: shellRenderMode,
              );
            },
          ),
          GoRoute(
            path: AppRoutePaths.tradeOrderReceipt,
            name: AppRouteNames.sc051OrderReceipt,
            builder: (_, _) =>
                OrderReceiptPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeOrdersHistory,
            name: AppRouteNames.sc050OrdersHistory,
            builder: (_, _) =>
                OrdersHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradePositions,
            name: AppRouteNames.sc053PositionDashboard,
            builder: (_, _) =>
                PositionDashboardPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeSettings,
            name: AppRouteNames.sc052TradeSettings,
            builder: (_, _) =>
                TradeSettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.tradeExport,
            name: AppRouteNames.sc054TradeHistoryExport,
            builder: (_, _) =>
                TradeHistoryExportPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/trade/:pairId/futures/leverage',
            name: AppRouteNames.sc058Leverage,
            builder: (_, state) => LeveragePage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/trade/:pairId/futures',
            name: AppRouteNames.sc057Futures,
            builder: (_, state) => FuturesPage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/trade/:pairId',
            name: AppRouteNames.sc049TradePair,
            builder: (_, state) => TradePage(
              pairId: state.pathParameters['pairId'] ?? 'btcusdt',
              chartVariant: TradeChartVariant.pairRoute,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.wallet,
            name: AppRouteNames.sc135Wallet,
            builder: (_, _) => WalletPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletHistory,
            name: AppRouteNames.sc136TxHistory,
            builder: (_, _) =>
                TransactionHistoryPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletDeposit,
            name: AppRouteNames.sc137Deposit,
            builder: (_, _) => DepositPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '${AppRoutePaths.walletDeposit}/:asset',
            name: AppRouteNames.sc138DepositUsdt,
            builder: (_, state) => DepositPage(
              asset: state.pathParameters['asset'] ?? 'USDT',
              assetScoped: true,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.walletWithdraw,
            name: AppRouteNames.sc139Withdraw,
            builder: (_, _) => WithdrawPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '${AppRoutePaths.walletWithdraw}/:asset',
            name: AppRouteNames.sc140WithdrawUsdt,
            builder: (_, state) => WithdrawPage(
              asset: state.pathParameters['asset'] ?? 'USDT',
              assetScoped: true,
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: '/wallet/transaction/:txId',
            name: AppRouteNames.sc141TransactionDetail,
            builder: (_, state) => TransactionDetailPage(
              transactionId: state.pathParameters['txId'] ?? 'tx001',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.walletPortfolioAnalytics,
            name: AppRouteNames.sc142PortfolioAnalytics,
            builder: (_, _) =>
                PortfolioAnalyticsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletAddressBookAdd,
            name: AppRouteNames.sc143AddressAdd,
            builder: (_, _) => AddressAddPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletAddressBook,
            name: AppRouteNames.sc144AddressBook,
            builder: (_, _) =>
                AddressBookPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletBuyCrypto,
            name: AppRouteNames.sc145BuyCrypto,
            builder: (_, _) => BuyCryptoPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletTransfer,
            name: AppRouteNames.sc146Transfer,
            builder: (_, _) => TransferPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: '/wallet/asset/:assetId',
            name: AppRouteNames.sc147AssetDetail,
            builder: (_, state) => AssetDetailPage(
              assetId: state.pathParameters['assetId'] ?? 'btc',
              shellRenderMode: shellRenderMode,
            ),
          ),
          GoRoute(
            path: AppRoutePaths.walletMultiManager,
            name: AppRouteNames.sc148MultiManager,
            builder: (_, _) =>
                WalletMultiManagerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletGasOptimizer,
            name: AppRouteNames.sc149GasOptimizer,
            builder: (_, _) =>
                WalletGasOptimizerPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletTokenApproval,
            name: AppRouteNames.sc150TokenApproval,
            builder: (_, _) =>
                WalletTokenApprovalPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletHealthScore,
            name: AppRouteNames.sc151HealthScore,
            builder: (_, _) =>
                WalletHealthScorePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletPendingDeposits,
            name: AppRouteNames.sc152PendingDeposits,
            builder: (_, _) =>
                PendingDepositsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletLimits,
            name: AppRouteNames.sc153WithdrawLimits,
            builder: (_, _) =>
                WithdrawLimitsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletDustConverter,
            name: AppRouteNames.sc154DustConverter,
            builder: (_, _) =>
                DustConverterPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.walletNetworkStatus,
            name: AppRouteNames.sc155NetworkStatus,
            builder: (_, _) =>
                NetworkStatusPage(shellRenderMode: shellRenderMode),
          ),
          ..._walletOutgoingPlaceholders,
          GoRoute(
            path: AppRoutePaths.profile,
            name: AppRouteNames.sc156Profile,
            builder: (_, _) => ProfilePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileEdit,
            name: AppRouteNames.sc157EditProfile,
            builder: (_, _) =>
                EditProfilePage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileKyc,
            name: AppRouteNames.sc159Kyc,
            builder: (_, _) => KYCPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileSecurity,
            name: AppRouteNames.sc158Security,
            builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileSettings,
            name: AppRouteNames.sc160Settings,
            builder: (_, _) => SettingsPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileActivity,
            name: AppRouteNames.sc161ActivityLog,
            builder: (_, _) =>
                ActivityLogPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileApi,
            name: AppRouteNames.sc163ApiManagement,
            builder: (_, _) =>
                ApiManagementPage(shellRenderMode: shellRenderMode),
          ),
          GoRoute(
            path: AppRoutePaths.profileApiCreate,
            name: AppRouteNames.sc162ApiKeyCreate,
            builder: (_, _) =>
                ApiKeyCreatePage(shellRenderMode: shellRenderMode),
          ),
          ..._profileOutgoingPlaceholders,
          ..._homeOutgoingPlaceholders,
          ..._marketOutgoingPlaceholders,
        ],
      ),
    ],
  );
}

OTPPage _buildOtpPage(GoRouterState state) {
  final extra = state.extra;
  final query = state.uri.queryParameters;
  OtpPageRouteArgs? args;
  if (extra is OtpPageRouteArgs) {
    args = extra;
  }

  final purposeText = args?.purpose?.name ?? query['purpose'];
  final purpose = switch (purposeText) {
    'register' => AuthOtpPurpose.register,
    'twoFactor' || '2fa' => AuthOtpPurpose.twoFactor,
    'passwordReset' || 'reset' => AuthOtpPurpose.passwordReset,
    _ => AuthOtpPurpose.verify,
  };

  final contactTypeText = args?.contactType?.name ?? query['type'];
  final contactType = contactTypeText == 'phone'
      ? AuthContactType.phone
      : AuthContactType.email;

  return OTPPage(
    contact: args?.contact ?? query['contact'] ?? 'your@email.com',
    contactType: contactType,
    purpose: purpose,
  );
}

class _AuthRouteShell extends StatelessWidget {
  const _AuthRouteShell({required this.child, required this.renderMode});

  final Widget child;
  final ShellRenderMode renderMode;

  @override
  Widget build(BuildContext context) {
    final body = Material(
      color: AppColors.bg,
      child: SizedBox.expand(child: child),
    );

    if (!renderMode.usesVisualQaFrame) {
      return SafeArea(top: true, bottom: false, child: body);
    }

    return Material(
      color: AppColors.bg,
      child: Column(
        children: [
          const VitStatusBar(time: '23:27'),
          Expanded(child: body),
        ],
      ),
    );
  }
}

final GoRouter appRouter = createAppRouter();

VitBottomNavDestination _activeDestinationForPath(String path) {
  if (path == AppRoutePaths.news) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith(AppRoutePaths.markets)) {
    return VitBottomNavDestination.markets;
  }
  if (path.startsWith(AppRoutePaths.trade)) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith('/pair/')) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith(AppRoutePaths.wallet)) {
    return VitBottomNavDestination.wallet;
  }
  if (path.startsWith(AppRoutePaths.profile)) {
    return VitBottomNavDestination.profile;
  }
  return VitBottomNavDestination.home;
}

String _visualQaStatusBarTimeForPath(String path) {
  if (path == AppRoutePaths.marketsSocialSentiment) return '23:28';
  if (path == AppRoutePaths.marketsPortfolioTracker) return '23:28';
  if (path == AppRoutePaths.marketsNews) return '23:28';
  if (path == AppRoutePaths.marketsAdvancedCharts) return '23:28';
  if (path == AppRoutePaths.marketsUnlocks) return '23:28';
  if (path == AppRoutePaths.marketsSignals) return '23:28';
  if (path == AppRoutePaths.marketsCorrelations) return '23:28';
  if (path == AppRoutePaths.marketsPredictions) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsSearch) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsBreaking) return '23:28';
  if (path.startsWith('/markets/predictions/event/')) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsPortfolio) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsRewards) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsLeaderboard) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsActivity) return '23:28';
  if (path.startsWith('/markets/predictions/receipt/')) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsRiskCalculator) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsMarketMaker) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsPortfolioAnalyzer) {
    return '23:28';
  }
  if (path == AppRoutePaths.marketsPredictionsEventCalendar) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsSocial) return '23:28';
  if (path.startsWith('/markets/predictions/advanced-chart/')) return '23:29';
  if (path == AppRoutePaths.marketsPredictionsTournaments) return '23:29';
  if (path.startsWith('/markets/predictions/tournament/')) return '23:29';
  if (path == AppRoutePaths.marketsPredictionsDataIntegration) return '23:29';
  if (path.startsWith('/pair/')) return '23:29';
  if (path == AppRoutePaths.news) return '23:29';
  if (path == AppRoutePaths.trade) return '23:29';
  if (path == AppRoutePaths.tradeBotTermsOfService) return '23:31';
  if (path == AppRoutePaths.tradeBotRiskDisclosure) return '23:31';
  if (path == AppRoutePaths.tradeBotSuitabilityAssessment) return '23:31';
  if (path == AppRoutePaths.tradeBotRiskDashboard) return '23:31';
  if (path == AppRoutePaths.tradeBotEmergencyStop) return '23:31';
  if (path == AppRoutePaths.tradeBotSecuritySettings) return '23:31';
  if (path == AppRoutePaths.tradeBotHistory) return '23:31';
  if (path == AppRoutePaths.tradeBotPerformanceAnalytics) return '23:31';
  if (path == AppRoutePaths.tradeBotBacktesting) return '23:31';
  if (path == AppRoutePaths.tradeBotStrategyCompare) return '23:31';
  if (path == AppRoutePaths.tradeBotOptimization) return '23:31';
  if (path == AppRoutePaths.tradeBotPortfolioDashboard) return '23:31';
  if (path == AppRoutePaths.tradeBotDrawdownAnalyzer) return '23:32';
  if (path == AppRoutePaths.tradeBotEquityCurve) return '23:32';
  if (path == AppRoutePaths.tradeBotGuide) return '23:32';
  if (path == AppRoutePaths.tradeBotFaq) return '23:32';
  if (path == AppRoutePaths.tradeBotTaxReporting) return '23:32';
  if (path == AppRoutePaths.tradeBotApiDocumentation) return '23:32';
  if (path.startsWith('/trade/advanced-chart/')) return '23:29';
  if (path.startsWith(AppRoutePaths.tradeCopyTargetMarketDefinition)) {
    return '23:31';
  }
  if (path == AppRoutePaths.tradeCopyClientMoneyProtection) return '23:31';
  if (path == AppRoutePaths.tradeCopyCassReconciliation) return '23:31';
  if (path == AppRoutePaths.tradeCopyInvestorCompensation) return '23:31';
  if (path == AppRoutePaths.tradeCopyExAnteCosts) return '23:31';
  if (path == AppRoutePaths.tradeCopyRiyCalculator) return '23:31';
  if (path == AppRoutePaths.tradeCopyExPostCostsReport) return '23:31';
  if (path == AppRoutePaths.tradeCopyKidGenerator) return '23:31';
  if (path == AppRoutePaths.tradeCopyPerformanceScenarios) return '23:31';
  if (path == AppRoutePaths.tradeCopyRiskIndicatorExplainer) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintsHandling) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintSubmission) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintTrackingBase ||
      path.startsWith('${AppRoutePaths.tradeCopyComplaintTrackingBase}/')) {
    return '23:31';
  }
  if (path == AppRoutePaths.tradeCopyOmbudsmanReferral) return '23:31';
  if (path == AppRoutePaths.tradeCopyAuditTrail) return '23:31';
  if (path == AppRoutePaths.tradeCopyRegulatoryInspectionReady) return '23:31';
  if (path == AppRoutePaths.tradeCopyRegulatoryDisclosures) return '23:30';
  if (path.startsWith('/trade/margin')) return '23:30';
  if (path.startsWith('/trade/trader/')) return '23:30';
  if (path.startsWith('/trade/copy-provider/')) return '23:30';
  if (path.startsWith('/trade/copy-performance/')) return '23:30';
  if (path.startsWith('/trade/')) return '23:29';
  if (path.startsWith(AppRoutePaths.wallet)) return '23:32';
  if (path.startsWith(AppRoutePaths.profile)) return '23:33';
  if (path == AppRoutePaths.marketsDepth) return '23:28';
  if (path == AppRoutePaths.marketsDerivatives) return '23:28';
  if (path == AppRoutePaths.marketsCalendar) return '23:28';
  if (path == AppRoutePaths.marketsCompare) return '23:28';
  if (path == AppRoutePaths.marketsScreener) return '23:28';
  if (path == AppRoutePaths.marketsAlerts) return '23:28';
  if (path == AppRoutePaths.marketsHeatmap) return '23:28';
  if (path == AppRoutePaths.marketsWatchlist) return '23:28';
  return '23:27';
}

final List<GoRoute> _homeOutgoingPlaceholders = [
  _placeholderRoute('/search', 'Search'),
  _placeholderRoute('/notifications', 'Notifications'),
  _placeholderRoute(
    '/support',
    'Support',
    backPath: AppRoutePaths.walletHistory,
  ),
  _placeholderRoute('/topics', 'Topics'),
  _placeholderRoute('/p2p', 'P2P'),
  _placeholderRoute('/launchpad', 'Launchpad'),
  _placeholderRoute('/earn/staking', 'Staking'),
  _placeholderRoute('/earn/savings', 'Savings'),
  _placeholderRoute('/dca', 'DCA'),
  _placeholderRoute('/rewards', 'Rewards'),
  _placeholderRoute('/referral', 'Referral'),
  _placeholderRoute(AppRoutePaths.arena, 'Open Arena'),
  _placeholderRoute(
    AppRoutePaths.arenaStudio,
    'Arena Studio',
    backPath: AppRoutePaths.marketsPredictions,
  ),
];

final List<GoRoute> _marketOutgoingPlaceholders = [
  _placeholderRoute(
    AppRoutePaths.profilePredictions,
    'My Predictions',
    backPath: AppRoutePaths.marketsPredictions,
  ),
];

final List<GoRoute> _walletOutgoingPlaceholders = [];

final List<GoRoute> _profileOutgoingPlaceholders = [
  _placeholderRoute(
    AppRoutePaths.profileVip,
    'VIP Program',
    backPath: AppRoutePaths.profile,
  ),
  _placeholderRoute(
    AppRoutePaths.profileDevices,
    'Device Management',
    backPath: AppRoutePaths.profile,
  ),
  _placeholderRoute(
    AppRoutePaths.profileSubAccounts,
    'Sub Accounts',
    backPath: AppRoutePaths.profile,
  ),
  _placeholderRoute(
    AppRoutePaths.profileArena,
    'My Arena',
    backPath: AppRoutePaths.profile,
  ),
  _placeholderRoute(
    AppRoutePaths.onboarding,
    'Onboarding',
    backPath: AppRoutePaths.profile,
  ),
];

final List<GoRoute> _tradeMarginOutgoingPlaceholders = [];

final List<GoRoute> _tradeCopyTradingOutgoingPlaceholders = [
  _placeholderRoute(
    AppRoutePaths.tradeCopyClientOptUpRequest,
    'Client Opt-Up Request',
    backPath: AppRoutePaths.tradeCopyClientCategorization,
  ),
  GoRoute(
    path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
    redirect: (_, _) => AppRoutePaths.tradeCopyRegulatoryDisclosures,
  ),
  _placeholderRoute(
    AppRoutePaths.settingsSecurity,
    'Security Settings',
    backPath: AppRoutePaths.tradeCopyClientCategorization,
  ),
];

final List<GoRoute> _tradeBotsOutgoingPlaceholders = [];

GoRoute _placeholderRoute(
  String path,
  String title, {
  String backPath = AppRoutePaths.home,
}) {
  return GoRoute(
    path: path,
    builder: (_, _) =>
        _UnportedRoutePlaceholder(title: title, backPath: backPath),
  );
}

class _BottomNavRouteSkeleton extends StatelessWidget {
  const _BottomNavRouteSkeleton({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(title: title),
          const VitPageContent(children: []),
        ],
      ),
    );
  }
}

class _UnportedRoutePlaceholder extends StatelessWidget {
  const _UnportedRoutePlaceholder({
    required this.title,
    required this.backPath,
  });

  final String title;
  final String backPath;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(
            title: title,
            showBack: true,
            onBack: () => context.go(backPath),
          ),
          const VitPageContent(children: [SizedBox.shrink()]),
        ],
      ),
    );
  }
}
