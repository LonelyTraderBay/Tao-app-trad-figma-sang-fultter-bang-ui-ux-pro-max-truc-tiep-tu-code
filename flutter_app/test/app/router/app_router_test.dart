import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  testWidgets('/home opens inside the native shell with Home active', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('VitTrade'), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_home')), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
  });

  testWidgets('bottom nav route taps update the active destination', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('vit_bottom_nav_markets')));
    await tester.pumpAndSettle();

    expect(find.text('Thị trường'), findsWidgets);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
  });

  test('defines stable route names and auth paths for ported screens', () {
    expect(AppRouteNames.sc001Login, 'sc001Login');
    expect(AppRouteNames.sc002Register, 'sc002Register');
    expect(AppRouteNames.sc003Otp, 'sc003Otp');
    expect(AppRouteNames.sc004TwoFaSetup, 'sc004TwoFaSetup');
    expect(AppRouteNames.sc005ForgotPassword, 'sc005ForgotPassword');
    expect(AppRouteNames.sc006ResetPassword, 'sc006ResetPassword');
    expect(AppRouteNames.sc007Home, 'sc007Home');
    expect(AppRouteNames.sc008MarketList, 'sc008MarketList');
    expect(AppRouteNames.sc009MarketOverview, 'sc009MarketOverview');
    expect(AppRouteNames.sc010MarketMovers, 'sc010MarketMovers');
    expect(AppRouteNames.sc011MarketSectors, 'sc011MarketSectors');
    expect(AppRouteNames.sc012Watchlist, 'sc012Watchlist');
    expect(AppRouteNames.sc013MarketHeatmap, 'sc013MarketHeatmap');
    expect(AppRouteNames.sc014PriceAlerts, 'sc014PriceAlerts');
    expect(AppRouteNames.sc015MarketScreener, 'sc015MarketScreener');
    expect(AppRouteNames.sc016ComparisonTool, 'sc016ComparisonTool');
    expect(AppRouteNames.sc017MarketCalendar, 'sc017MarketCalendar');
    expect(AppRouteNames.sc018DerivativesOverview, 'sc018DerivativesOverview');
    expect(AppRouteNames.sc019MarketDepth, 'sc019MarketDepth');
    expect(AppRouteNames.sc020SocialSentiment, 'sc020SocialSentiment');
    expect(AppRouteNames.sc021PortfolioTracker, 'sc021PortfolioTracker');
    expect(AppRouteNames.sc022MarketNews, 'sc022MarketNews');
    expect(AppRouteNames.sc023AdvancedCharts, 'sc023AdvancedCharts');
    expect(AppRouteNames.sc024TokenUnlocks, 'sc024TokenUnlocks');
    expect(AppRouteNames.sc025SocialSignals, 'sc025SocialSignals');
    expect(AppRouteNames.sc026MarketCorrelations, 'sc026MarketCorrelations');
    expect(AppRouteNames.sc027PredictionsHome, 'sc027PredictionsHome');
    expect(AppRouteNames.sc028PredictionsSearch, 'sc028PredictionsSearch');
    expect(AppRouteNames.sc029PredictionsBreaking, 'sc029PredictionsBreaking');
    expect(
      AppRouteNames.sc030PredictionEventDetail,
      'sc030PredictionEventDetail',
    );
    expect(
      AppRouteNames.sc031PredictionsPortfolio,
      'sc031PredictionsPortfolio',
    );
    expect(AppRouteNames.sc032PredictionsRewards, 'sc032PredictionsRewards');
    expect(
      AppRouteNames.sc033PredictionsLeaderboard,
      'sc033PredictionsLeaderboard',
    );
    expect(
      AppRouteNames.sc034PredictionsGlobalActivity,
      'sc034PredictionsGlobalActivity',
    );
    expect(
      AppRouteNames.sc035PredictionOrderReceipt,
      'sc035PredictionOrderReceipt',
    );
    expect(
      AppRouteNames.sc036PredictionRiskCalculator,
      'sc036PredictionRiskCalculator',
    );
    expect(
      AppRouteNames.sc037PredictionMarketMaker,
      'sc037PredictionMarketMaker',
    );
    expect(
      AppRouteNames.sc038PredictionPortfolioAnalyzer,
      'sc038PredictionPortfolioAnalyzer',
    );
    expect(
      AppRouteNames.sc039PredictionEventCalendar,
      'sc039PredictionEventCalendar',
    );
    expect(AppRouteNames.sc040PredictionSocial, 'sc040PredictionSocial');
    expect(
      AppRouteNames.sc041PredictionAdvancedChart,
      'sc041PredictionAdvancedChart',
    );
    expect(
      AppRouteNames.sc042PredictionTournaments,
      'sc042PredictionTournaments',
    );
    expect(
      AppRouteNames.sc043PredictionDataIntegration,
      'sc043PredictionDataIntegration',
    );
    expect(AppRouteNames.sc044PairDetail, 'sc044PairDetail');
    expect(AppRouteNames.sc045TokenInfo, 'sc045TokenInfo');
    expect(AppRouteNames.sc046PairDepth, 'sc046PairDepth');
    expect(AppRouteNames.sc047News, 'sc047News');
    expect(AppRouteNames.sc048Trade, 'sc048Trade');
    expect(AppRouteNames.sc049TradePair, 'sc049TradePair');
    expect(AppRouteNames.sc050OrdersHistory, 'sc050OrdersHistory');
    expect(AppRouteNames.sc051OrderReceipt, 'sc051OrderReceipt');
    expect(AppRouteNames.sc052TradeSettings, 'sc052TradeSettings');
    expect(AppRouteNames.sc053PositionDashboard, 'sc053PositionDashboard');
    expect(AppRouteNames.sc054TradeHistoryExport, 'sc054TradeHistoryExport');
    expect(AppRouteNames.sc055AdvancedChart, 'sc055AdvancedChart');
    expect(AppRouteNames.sc056Convert, 'sc056Convert');
    expect(AppRouteNames.sc057Futures, 'sc057Futures');
    expect(AppRouteNames.sc058Leverage, 'sc058Leverage');
    expect(AppRouteNames.sc059TradingBots, 'sc059TradingBots');
    expect(AppRouteNames.sc060RiskManagement, 'sc060RiskManagement');
    expect(AppRouteNames.sc061ExecutionQuality, 'sc061ExecutionQuality');
    expect(AppRouteNames.sc062AdvancedTools, 'sc062AdvancedTools');
    expect(AppRouteNames.sc063CopyTrading, 'sc063CopyTrading');
    expect(AppRouteNames.sc064CopyTradingV2, 'sc064CopyTradingV2');
    expect(AppRouteNames.sc065CopyEducation, 'sc065CopyEducation');
    expect(AppRouteNames.sc066ActiveCopies, 'sc066ActiveCopies');
    expect(AppRouteNames.sc067CopySettings, 'sc067CopySettings');
    expect(AppRouteNames.sc068CopyNotifications, 'sc068CopyNotifications');
    expect(AppRouteNames.sc069ProviderApplication, 'sc069ProviderApplication');
    expect(AppRouteNames.sc070CopyProviderDetail, 'sc070CopyProviderDetail');
    expect(AppRouteNames.sc071PreCopyAssessment, 'sc071PreCopyAssessment');
    expect(AppRouteNames.sc072CopyConfiguration, 'sc072CopyConfiguration');
    expect(AppRouteNames.sc073CopyConfirmation, 'sc073CopyConfirmation');
    expect(AppRouteNames.sc074CopyPerformance, 'sc074CopyPerformance');
    expect(
      AppRouteNames.sc075PerformanceAttribution,
      'sc075PerformanceAttribution',
    );
    expect(AppRouteNames.sc076ProviderComparison, 'sc076ProviderComparison');
    expect(AppRouteNames.sc077CopyAuditLog, 'sc077CopyAuditLog');
    expect(
      AppRouteNames.sc078PortfolioRiskAnalysis,
      'sc078PortfolioRiskAnalysis',
    );
    expect(AppRouteNames.sc079ProviderLeaderboard, 'sc079ProviderLeaderboard');
    expect(AppRouteNames.sc080SafetyEducation, 'sc080SafetyEducation');
    expect(AppRouteNames.sc081ProviderGovernance, 'sc081ProviderGovernance');
    expect(AppRouteNames.sc082DisputeResolution, 'sc082DisputeResolution');
    expect(AppRouteNames.sc083CopySafetyCenter, 'sc083CopySafetyCenter');
    expect(
      AppRouteNames.sc084RegulatoryDisclosures,
      'sc084RegulatoryDisclosures',
    );
    expect(AppRouteNames.sc085MarginTrading, 'sc085MarginTrading');
    expect(AppRouteNames.sc086MarginTradingPair, 'sc086MarginTradingPair');
    expect(AppRouteNames.sc087TraderProfile, 'sc087TraderProfile');
    expect(AppRouteNames.sc088AdvancedTradingDemo, 'sc088AdvancedTradingDemo');
    expect(AppRouteNames.sc089MarketDataAnalytics, 'sc089MarketDataAnalytics');
    expect(AppRouteNames.sc090MarginTradingHub, 'sc090MarginTradingHub');
    expect(
      AppRouteNames.sc091LiveMarketDataAnalytics,
      'sc091LiveMarketDataAnalytics',
    );
    expect(AppRouteNames.sc092AdvancedAnalytics, 'sc092AdvancedAnalytics');
    expect(
      AppRouteNames.sc093TransactionReporting,
      'sc093TransactionReporting',
    );
    expect(
      AppRouteNames.sc094RegulatoryReportsDashboard,
      'sc094RegulatoryReportsDashboard',
    );
    expect(
      AppRouteNames.sc095ArmIntegrationStatus,
      'sc095ArmIntegrationStatus',
    );
    expect(
      AppRouteNames.sc096BestExecutionReports,
      'sc096BestExecutionReports',
    );
    expect(
      AppRouteNames.sc097ExecutionVenueAnalysis,
      'sc097ExecutionVenueAnalysis',
    );
    expect(AppRouteNames.sc098SlippageMonitoring, 'sc098SlippageMonitoring');
    expect(
      AppRouteNames.sc099ClientCategorization,
      'sc099ClientCategorization',
    );
    expect(AppRouteNames.sc100ProductGovernance, 'sc100ProductGovernance');
    expect(
      AppRouteNames.sc101TargetMarketDefinition,
      'sc101TargetMarketDefinition',
    );
    expect(
      AppRouteNames.sc102ClientMoneyProtection,
      'sc102ClientMoneyProtection',
    );
    expect(AppRouteNames.sc103CassReconciliation, 'sc103CassReconciliation');
    expect(
      AppRouteNames.sc104InvestorCompensation,
      'sc104InvestorCompensation',
    );
    expect(AppRouteNames.sc105ExAnteCosts, 'sc105ExAnteCosts');
    expect(AppRouteNames.sc106RiyCalculator, 'sc106RiyCalculator');
    expect(AppRouteNames.sc107ExPostCostsReport, 'sc107ExPostCostsReport');
    expect(AppRouteNames.sc108KidGenerator, 'sc108KidGenerator');
    expect(
      AppRouteNames.sc109PerformanceScenarios,
      'sc109PerformanceScenarios',
    );
    expect(
      AppRouteNames.sc110RiskIndicatorExplainer,
      'sc110RiskIndicatorExplainer',
    );
    expect(AppRouteNames.sc111ComplaintsHandling, 'sc111ComplaintsHandling');
    expect(AppRouteNames.sc112ComplaintSubmission, 'sc112ComplaintSubmission');
    expect(AppRouteNames.sc113ComplaintTracking, 'sc113ComplaintTracking');
    expect(AppRouteNames.sc114OmbudsmanReferral, 'sc114OmbudsmanReferral');
    expect(AppRouteNames.sc115AuditTrail, 'sc115AuditTrail');
    expect(
      AppRouteNames.sc116RegulatoryInspectionReady,
      'sc116RegulatoryInspectionReady',
    );
    expect(AppRouteNames.sc117BotTermsOfService, 'sc117BotTermsOfService');
    expect(AppRouteNames.sc118BotRiskDisclosure, 'sc118BotRiskDisclosure');
    expect(
      AppRouteNames.sc119BotSuitabilityAssessment,
      'sc119BotSuitabilityAssessment',
    );
    expect(AppRouteNames.sc120BotRiskDashboard, 'sc120BotRiskDashboard');
    expect(AppRouteNames.sc121BotEmergencyStop, 'sc121BotEmergencyStop');
    expect(AppRouteNames.sc122BotSecuritySettings, 'sc122BotSecuritySettings');
    expect(AppRouteNames.sc123BotHistory, 'sc123BotHistory');
    expect(
      AppRouteNames.sc124BotPerformanceAnalytics,
      'sc124BotPerformanceAnalytics',
    );
    expect(AppRouteNames.sc125BotBacktesting, 'sc125BotBacktesting');
    expect(AppRouteNames.sc126BotStrategyCompare, 'sc126BotStrategyCompare');
    expect(AppRouteNames.sc127BotOptimization, 'sc127BotOptimization');
    expect(
      AppRouteNames.sc128BotPortfolioDashboard,
      'sc128BotPortfolioDashboard',
    );
    expect(AppRouteNames.sc129BotDrawdownAnalyzer, 'sc129BotDrawdownAnalyzer');
    expect(AppRouteNames.sc130BotEquityCurve, 'sc130BotEquityCurve');
    expect(AppRouteNames.sc131BotGuide, 'sc131BotGuide');
    expect(AppRouteNames.sc132BotFaq, 'sc132BotFaq');
    expect(AppRouteNames.sc133BotTaxReporting, 'sc133BotTaxReporting');
    expect(AppRouteNames.sc134BotApiDocumentation, 'sc134BotApiDocumentation');
    expect(AppRouteNames.sc135Wallet, 'sc135Wallet');
    expect(AppRouteNames.sc136TxHistory, 'sc136TxHistory');
    expect(AppRouteNames.sc137Deposit, 'sc137Deposit');
    expect(AppRouteNames.sc138DepositUsdt, 'sc138DepositUsdt');
    expect(AppRouteNames.sc139Withdraw, 'sc139Withdraw');
    expect(AppRouteNames.sc140WithdrawUsdt, 'sc140WithdrawUsdt');
    expect(AppRouteNames.sc141TransactionDetail, 'sc141TransactionDetail');
    expect(AppRouteNames.sc142PortfolioAnalytics, 'sc142PortfolioAnalytics');
    expect(AppRouteNames.sc143AddressAdd, 'sc143AddressAdd');
    expect(AppRouteNames.sc144AddressBook, 'sc144AddressBook');
    expect(AppRouteNames.sc145BuyCrypto, 'sc145BuyCrypto');
    expect(AppRouteNames.sc146Transfer, 'sc146Transfer');
    expect(AppRouteNames.sc147AssetDetail, 'sc147AssetDetail');
    expect(AppRouteNames.sc148MultiManager, 'sc148MultiManager');
    expect(AppRouteNames.sc149GasOptimizer, 'sc149GasOptimizer');
    expect(AppRouteNames.sc150TokenApproval, 'sc150TokenApproval');
    expect(AppRouteNames.sc151HealthScore, 'sc151HealthScore');
    expect(AppRouteNames.sc152PendingDeposits, 'sc152PendingDeposits');
    expect(AppRouteNames.sc153WithdrawLimits, 'sc153WithdrawLimits');
    expect(AppRouteNames.sc154DustConverter, 'sc154DustConverter');
    expect(AppRouteNames.sc155NetworkStatus, 'sc155NetworkStatus');
    expect(AppRouteNames.sc156Profile, 'sc156Profile');
    expect(AppRouteNames.sc157EditProfile, 'sc157EditProfile');
    expect(AppRouteNames.sc158Security, 'sc158Security');
    expect(AppRouteNames.sc159Kyc, 'sc159Kyc');
    expect(AppRouteNames.sc160Settings, 'sc160Settings');
    expect(AppRouteNames.sc161ActivityLog, 'sc161ActivityLog');
    expect(AppRouteNames.sc162ApiKeyCreate, 'sc162ApiKeyCreate');
    expect(AppRouteNames.sc163ApiManagement, 'sc163ApiManagement');
    expect(AppRoutePaths.authLogin, '/auth/login');
    expect(AppRoutePaths.authRegister, '/auth/register');
    expect(AppRoutePaths.authOtp, '/auth/otp');
    expect(AppRoutePaths.auth2faSetup, '/auth/2fa-setup');
    expect(AppRoutePaths.authForgotPassword, '/auth/forgot-password');
    expect(AppRoutePaths.authResetPassword, '/auth/reset-password');
    expect(AppRoutePaths.news, '/news');
    expect(AppRoutePaths.markets, '/markets');
    expect(AppRoutePaths.marketsOverview, '/markets/overview');
    expect(AppRoutePaths.marketsMovers, '/markets/movers');
    expect(AppRoutePaths.marketsSectors, '/markets/sectors');
    expect(AppRoutePaths.marketsWatchlist, '/markets/watchlist');
    expect(AppRoutePaths.marketsHeatmap, '/markets/heatmap');
    expect(AppRoutePaths.marketsAlerts, '/markets/alerts');
    expect(AppRoutePaths.marketsScreener, '/markets/screener');
    expect(AppRoutePaths.marketsCompare, '/markets/compare');
    expect(AppRoutePaths.marketsCalendar, '/markets/calendar');
    expect(AppRoutePaths.marketsDerivatives, '/markets/derivatives');
    expect(AppRoutePaths.marketsDepth, '/markets/depth');
    expect(AppRoutePaths.marketsSocialSentiment, '/markets/social-sentiment');
    expect(AppRoutePaths.marketsPortfolioTracker, '/markets/portfolio-tracker');
    expect(AppRoutePaths.marketsNews, '/markets/news');
    expect(AppRoutePaths.marketsAdvancedCharts, '/markets/advanced-charts');
    expect(AppRoutePaths.marketsUnlocks, '/markets/unlocks');
    expect(AppRoutePaths.marketsSignals, '/markets/signals');
    expect(AppRoutePaths.marketsCorrelations, '/markets/correlations');
    expect(AppRoutePaths.marketsPredictions, '/markets/predictions');
    expect(
      AppRoutePaths.marketsPredictionsSearch,
      '/markets/predictions/search',
    );
    expect(
      AppRoutePaths.marketsPredictionsBreaking,
      '/markets/predictions/breaking',
    );
    expect(
      AppRoutePaths.marketsPredictionEvent('pred-1'),
      '/markets/predictions/event/pred-1',
    );
    expect(
      AppRoutePaths.marketsPredictionsPortfolio,
      '/markets/predictions/portfolio',
    );
    expect(
      AppRoutePaths.marketsPredictionReceipt('po-1'),
      '/markets/predictions/receipt/po-1',
    );
    expect(
      AppRoutePaths.marketsPredictionsRewards,
      '/markets/predictions/rewards',
    );
    expect(
      AppRoutePaths.marketsPredictionsLeaderboard,
      '/markets/predictions/leaderboard',
    );
    expect(
      AppRoutePaths.marketsPredictionsActivity,
      '/markets/predictions/activity',
    );
    expect(
      AppRoutePaths.marketsPredictionsRiskCalculator,
      '/markets/predictions/risk-calculator',
    );
    expect(
      AppRoutePaths.marketsPredictionsMarketMaker,
      '/markets/predictions/market-maker',
    );
    expect(
      AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
      '/markets/predictions/portfolio-analyzer',
    );
    expect(
      AppRoutePaths.marketsPredictionsEventCalendar,
      '/markets/predictions/event-calendar',
    );
    expect(
      AppRoutePaths.marketsPredictionsSocial,
      '/markets/predictions/social',
    );
    expect(
      AppRoutePaths.marketsPredictionsAdvancedChart('btcusdt'),
      '/markets/predictions/advanced-chart/btcusdt',
    );
    expect(
      AppRoutePaths.marketsPredictionsTournaments,
      '/markets/predictions/tournaments',
    );
    expect(
      AppRoutePaths.marketsPredictionTournament('tour1'),
      '/markets/predictions/tournament/tour1',
    );
    expect(
      AppRoutePaths.marketsPredictionsDataIntegration,
      '/markets/predictions/data-integration',
    );
    expect(AppRoutePaths.pairDetail('btcusdt'), '/pair/btcusdt');
    expect(AppRoutePaths.pairInfo('btcusdt'), '/pair/btcusdt/info');
    expect(AppRoutePaths.pairDepth('btcusdt'), '/pair/btcusdt/depth');
    expect(
      AppRoutePaths.tradeAdvancedChart('btcusdt'),
      '/trade/advanced-chart/btcusdt',
    );
    expect(AppRoutePaths.tradePair('btcusdt'), '/trade/btcusdt');
    expect(AppRoutePaths.tradeFutures('btcusdt'), '/trade/btcusdt/futures');
    expect(
      AppRoutePaths.tradeFuturesLeverage('btcusdt'),
      '/trade/btcusdt/futures/leverage',
    );
    expect(AppRoutePaths.tradeOrderReceipt, '/trade/order-receipt');
    expect(AppRoutePaths.tradeOrdersHistory, '/trade/orders-history');
    expect(AppRoutePaths.tradeSettings, '/trade/settings');
    expect(AppRoutePaths.tradePositions, '/trade/positions');
    expect(AppRoutePaths.tradeExport, '/trade/export');
    expect(AppRoutePaths.tradeConvert, '/trade/convert');
    expect(AppRoutePaths.tradeBots, '/trade/bots');
    expect(
      AppRoutePaths.tradeBotTermsOfService,
      '/trade/bots/terms-of-service',
    );
    expect(AppRoutePaths.tradeBotRiskDisclosure, '/trade/bots/risk-disclosure');
    expect(
      AppRoutePaths.tradeBotSuitabilityAssessment,
      '/trade/bots/suitability-assessment',
    );
    expect(AppRoutePaths.tradeBotRiskDashboard, '/trade/bots/risk-dashboard');
    expect(AppRoutePaths.tradeBotEmergencyStop, '/trade/bots/emergency-stop');
    expect(
      AppRoutePaths.tradeBotSecuritySettings,
      '/trade/bots/security-settings',
    );
    expect(AppRoutePaths.tradeBotHistory, '/trade/bots/history');
    expect(
      AppRoutePaths.tradeBotPerformanceAnalytics,
      '/trade/bots/performance-analytics',
    );
    expect(AppRoutePaths.tradeBotBacktesting, '/trade/bots/backtesting');
    expect(
      AppRoutePaths.tradeBotStrategyCompare,
      '/trade/bots/strategy-compare',
    );
    expect(AppRoutePaths.tradeBotOptimization, '/trade/bots/optimization');
    expect(
      AppRoutePaths.tradeBotPortfolioDashboard,
      '/trade/bots/portfolio-dashboard',
    );
    expect(
      AppRoutePaths.tradeBotDrawdownAnalyzer,
      '/trade/bots/drawdown-analyzer',
    );
    expect(AppRoutePaths.tradeBotEquityCurve, '/trade/bots/equity-curve');
    expect(AppRoutePaths.tradeBotGuide, '/trade/bots/guide');
    expect(AppRoutePaths.tradeBotFaq, '/trade/bots/faq');
    expect(AppRoutePaths.tradeBotTaxReporting, '/trade/bots/tax-reporting');
    expect(
      AppRoutePaths.tradeBotApiDocumentation,
      '/trade/bots/api-documentation',
    );
    expect(AppRoutePaths.tradeRiskManagement, '/trade/risk-management');
    expect(AppRoutePaths.tradeExecutionQuality, '/trade/execution-quality');
    expect(AppRoutePaths.tradeAdvancedTools, '/trade/advanced-tools');
    expect(AppRoutePaths.tradeCopyTrading, '/trade/copy-trading');
    expect(AppRoutePaths.tradeCopyTradingV2, '/trade/copy-trading/v2');
    expect(AppRoutePaths.tradeCopyEducation, '/trade/copy-trading/education');
    expect(AppRoutePaths.tradeCopyActive, '/trade/copy-trading/active');
    expect(AppRoutePaths.tradeCopySettings, '/trade/copy-trading/settings');
    expect(
      AppRoutePaths.tradeCopyNotifications,
      '/trade/copy-trading/notifications',
    );
    expect(AppRoutePaths.tradeCopyComparison, '/trade/copy-trading/comparison');
    expect(AppRoutePaths.tradeCopyProviderApply, '/trade/copy-provider-apply');
    expect(
      AppRoutePaths.tradeCopyProvider('ct001'),
      '/trade/copy-provider/ct001',
    );
    expect(
      AppRoutePaths.tradeCopyProviderAssessment('provider001'),
      '/trade/copy-provider/provider001/assessment',
    );
    expect(
      AppRoutePaths.tradeCopyProvider(
        'ct001',
        backPath: AppRoutePaths.tradeCopyTradingV2,
      ),
      '/trade/copy-provider/ct001?back=%2Ftrade%2Fcopy-trading%2Fv2',
    );
    expect(
      AppRoutePaths.tradeCopyProviderConfiguration(
        'provider001',
        backPath: AppRoutePaths.tradeCopyActive,
      ),
      '/trade/copy-provider/provider001/configuration?back=%2Ftrade%2Fcopy-trading%2Factive',
    );
    expect(
      AppRoutePaths.tradeCopyProviderConfirmation('provider001'),
      '/trade/copy-provider/provider001/confirmation',
    );
    expect(
      AppRoutePaths.tradeCopyPerformance('copy001'),
      '/trade/copy-performance/copy001',
    );
    expect(
      AppRoutePaths.tradeCopyPerformanceAttribution('copy001'),
      '/trade/copy-performance/copy001/attribution',
    );
    expect(
      AppRoutePaths.tradeCopyAuditLog('copy001'),
      '/trade/copy-audit-log/copy001',
    );
    expect(
      AppRoutePaths.tradeCopyRiskAnalysis,
      '/trade/copy-trading/risk-analysis',
    );
    expect(
      AppRoutePaths.tradeCopyLeaderboard,
      '/trade/copy-trading/leaderboard',
    );
    expect(AppRoutePaths.tradeCopySafety, '/trade/copy-trading/safety');
    expect(
      AppRoutePaths.tradeCopyProviderGovernance,
      '/trade/copy-provider-governance',
    );
    expect(
      AppRoutePaths.tradeCopyDisputeResolution,
      '/trade/copy-dispute-resolution',
    );
    expect(AppRoutePaths.tradeCopySafetyCenter, '/trade/copy-safety-center');
    expect(
      AppRoutePaths.tradeCopyRegulatoryDisclosures,
      '/trade/copy-regulatory-disclosures',
    );
    expect(
      AppRoutePaths.tradeCopyTransactionReporting,
      '/trade/copy-trading/transaction-reporting',
    );
    expect(
      AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
      '/trade/copy-trading/regulatory-reports-dashboard',
    );
    expect(
      AppRoutePaths.tradeCopyArmIntegrationStatus,
      '/trade/copy-trading/arm-integration-status',
    );
    expect(
      AppRoutePaths.tradeCopyBestExecutionReports,
      '/trade/copy-trading/best-execution-reports',
    );
    expect(
      AppRoutePaths.tradeCopyExecutionVenueAnalysis,
      '/trade/copy-trading/execution-venue-analysis',
    );
    expect(
      AppRoutePaths.tradeCopySlippageMonitoring,
      '/trade/copy-trading/slippage-monitoring',
    );
    expect(
      AppRoutePaths.tradeCopyClientCategorization,
      '/trade/copy-trading/client-categorization',
    );
    expect(
      AppRoutePaths.tradeCopyClientOptUpRequest,
      '/trade/copy-trading/client-opt-up-request',
    );
    expect(
      AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
      '/trade/copy-trading/regulatory-disclosures',
    );
    expect(
      AppRoutePaths.tradeCopyProductGovernance,
      '/trade/copy-trading/product-governance',
    );
    expect(
      AppRoutePaths.tradeCopyTargetMarketDefinition,
      '/trade/copy-trading/target-market-definition',
    );
    expect(
      AppRoutePaths.tradeCopyTargetMarketDefinitionForProduct('prod-1'),
      '/trade/copy-trading/target-market-definition/prod-1',
    );
    expect(
      AppRoutePaths.tradeCopyClientMoneyProtection,
      '/trade/copy-trading/client-money-protection',
    );
    expect(
      AppRoutePaths.tradeCopyCassReconciliation,
      '/trade/copy-trading/cass-reconciliation',
    );
    expect(
      AppRoutePaths.tradeCopyInvestorCompensation,
      '/trade/copy-trading/investor-compensation',
    );
    expect(
      AppRoutePaths.tradeCopyExAnteCosts,
      '/trade/copy-trading/ex-ante-costs',
    );
    expect(
      AppRoutePaths.tradeCopyRiyCalculator,
      '/trade/copy-trading/riy-calculator',
    );
    expect(
      AppRoutePaths.tradeCopyExPostCostsReport,
      '/trade/copy-trading/ex-post-costs-report',
    );
    expect(
      AppRoutePaths.tradeCopyKidGenerator,
      '/trade/copy-trading/kid-generator',
    );
    expect(
      AppRoutePaths.tradeCopyPerformanceScenarios,
      '/trade/copy-trading/performance-scenarios',
    );
    expect(
      AppRoutePaths.tradeCopyRiskIndicatorExplainer,
      '/trade/copy-trading/risk-indicator-explainer',
    );
    expect(
      AppRoutePaths.tradeCopyComplaintsHandling,
      '/trade/copy-trading/complaints-handling',
    );
    expect(
      AppRoutePaths.tradeCopyComplaintSubmission,
      '/trade/copy-trading/complaint-submission',
    );
    expect(
      AppRoutePaths.tradeCopyComplaintTrackingBase,
      '/trade/copy-trading/complaint-tracking',
    );
    expect(
      AppRoutePaths.tradeCopyComplaintTracking('COMP-2026-001'),
      '/trade/copy-trading/complaint-tracking/COMP-2026-001',
    );
    expect(
      AppRoutePaths.tradeCopyOmbudsmanReferral,
      '/trade/copy-trading/ombudsman-referral',
    );
    expect(
      AppRoutePaths.tradeCopyAuditTrail,
      '/trade/copy-trading/audit-trail',
    );
    expect(
      AppRoutePaths.tradeCopyRegulatoryInspectionReady,
      '/trade/copy-trading/regulatory-inspection-ready',
    );
    expect(AppRoutePaths.settingsSecurity, '/settings/security');
    expect(AppRoutePaths.tradeMargin, '/trade/margin');
    expect(AppRoutePaths.tradeMarginBtcusdt, '/trade/margin/btcusdt');
    expect(
      AppRoutePaths.tradeMarginAdvancedDemo,
      '/trade/margin/advanced-demo',
    );
    expect(
      AppRoutePaths.tradeMarginMarketDataAnalytics,
      '/trade/margin/market-data-analytics',
    );
    expect(AppRoutePaths.tradeMarginHub, '/trade/margin/hub');
    expect(
      AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
      '/trade/margin/live-market-data-analytics',
    );
    expect(
      AppRoutePaths.tradeMarginAdvancedAnalytics,
      '/trade/margin/advanced-analytics',
    );
    expect(AppRoutePaths.tradeTrader('trader001'), '/trade/trader/trader001');
    expect(AppRoutePaths.wallet, '/wallet');
    expect(AppRoutePaths.walletHistory, '/wallet/history');
    expect(AppRoutePaths.walletDeposit, '/wallet/deposit');
    expect(AppRoutePaths.walletDepositAsset('USDT'), '/wallet/deposit/USDT');
    expect(AppRoutePaths.walletWithdraw, '/wallet/withdraw');
    expect(AppRoutePaths.walletWithdrawAsset('USDT'), '/wallet/withdraw/USDT');
    expect(
      AppRoutePaths.walletTransaction('tx001'),
      '/wallet/transaction/tx001',
    );
    expect(
      AppRoutePaths.walletPortfolioAnalytics,
      '/wallet/portfolio-analytics',
    );
    expect(AppRoutePaths.walletAddressBook, '/wallet/address-book');
    expect(AppRoutePaths.walletAddressBookAdd, '/wallet/address-book/add');
    expect(AppRoutePaths.walletBuyCrypto, '/wallet/buy-crypto');
    expect(AppRoutePaths.walletTransfer, '/wallet/transfer');
    expect(AppRoutePaths.walletAsset('btc'), '/wallet/asset/btc');
    expect(AppRoutePaths.walletMultiManager, '/wallet/multi-manager');
    expect(AppRoutePaths.walletGasOptimizer, '/wallet/gas-optimizer');
    expect(AppRoutePaths.walletTokenApproval, '/wallet/token-approval');
    expect(AppRoutePaths.walletHealthScore, '/wallet/health-score');
    expect(AppRoutePaths.walletPendingDeposits, '/wallet/pending-deposits');
    expect(AppRoutePaths.walletLimits, '/wallet/limits');
    expect(AppRoutePaths.walletDustConverter, '/wallet/dust-converter');
    expect(AppRoutePaths.walletNetworkStatus, '/wallet/network-status');
    expect(AppRoutePaths.profile, '/profile');
    expect(AppRoutePaths.profileEdit, '/profile/edit');
    expect(AppRoutePaths.profileKyc, '/profile/kyc');
    expect(AppRoutePaths.profileSecurity, '/profile/security');
    expect(AppRoutePaths.profileVip, '/profile/vip');
    expect(AppRoutePaths.profileApi, '/profile/api');
    expect(AppRoutePaths.profileApiCreate, '/profile/api/create');
    expect(AppRoutePaths.profileDevices, '/profile/devices');
    expect(AppRoutePaths.profileSubAccounts, '/profile/sub-accounts');
    expect(AppRoutePaths.profileSettings, '/profile/settings');
    expect(AppRoutePaths.profileActivity, '/profile/activity');
    expect(AppRoutePaths.profileArena, '/profile/arena');
    expect(AppRoutePaths.onboarding, '/onboarding');
    expect(AppRoutePaths.dca, '/dca');
    expect(AppRoutePaths.profilePredictions, '/profile/predictions');
    expect(AppRoutePaths.arena, '/arena');
    expect(AppRoutePaths.arenaStudio, '/arena/studio');
    expect(VitBottomNavDestination.home.routePath, AppRoutePaths.home);
  });
}
