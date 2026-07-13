import 'package:vit_trade_flutter/app/router/app_router.dart';

import 'app_route_paths_contract_test_utils.dart';

void main() {
  routePathContractTest('defines stable trade route paths', [
    c(
      AppRoutePaths.tradeAdvancedChart('btcusdt'),
      '/trade/advanced-chart/btcusdt',
    ),
    c(AppRoutePaths.tradePair('btcusdt'), '/trade/btcusdt'),
    c(AppRoutePaths.tradeFutures('btcusdt'), '/trade/btcusdt/futures'),
    c(
      AppRoutePaths.tradeFuturesLeverage('btcusdt'),
      '/trade/btcusdt/futures/leverage',
    ),
    c(AppRoutePaths.tradeOrderReceipt, '/trade/order-receipt'),
    c(AppRoutePaths.tradeOrdersHistory, '/trade/orders-history'),
    c(AppRoutePaths.tradeSettings, '/trade/settings'),
    c(AppRoutePaths.tradePositions, '/trade/positions'),
    c(AppRoutePaths.tradeExport, '/trade/export'),
    c(AppRoutePaths.tradeConvert, '/trade/convert'),
    c(AppRoutePaths.tradeBots, '/trade/bots'),
    c(AppRoutePaths.tradeBotTermsOfService, '/trade/bots/terms-of-service'),
    c(AppRoutePaths.tradeBotRiskDisclosure, '/trade/bots/risk-disclosure'),
    c(
      AppRoutePaths.tradeBotSuitabilityAssessment,
      '/trade/bots/suitability-assessment',
    ),
    c(AppRoutePaths.tradeBotRiskDashboard, '/trade/bots/risk-dashboard'),
    c(AppRoutePaths.tradeBotEmergencyStop, '/trade/bots/emergency-stop'),
    c(AppRoutePaths.tradeBotSecuritySettings, '/trade/bots/security-settings'),
    c(AppRoutePaths.tradeBotHistory, '/trade/bots/history'),
    c(
      AppRoutePaths.tradeBotPerformanceAnalytics,
      '/trade/bots/performance-analytics',
    ),
    c(AppRoutePaths.tradeBotBacktesting, '/trade/bots/backtesting'),
    c(AppRoutePaths.tradeBotStrategyCompare, '/trade/bots/strategy-compare'),
    c(AppRoutePaths.tradeBotOptimization, '/trade/bots/optimization'),
    c(
      AppRoutePaths.tradeBotPortfolioDashboard,
      '/trade/bots/portfolio-dashboard',
    ),
    c(AppRoutePaths.tradeBotDrawdownAnalyzer, '/trade/bots/drawdown-analyzer'),
    c(AppRoutePaths.tradeBotEquityCurve, '/trade/bots/equity-curve'),
    c(AppRoutePaths.tradeBotGuide, '/trade/bots/guide'),
    c(AppRoutePaths.tradeBotFaq, '/trade/bots/faq'),
    c(AppRoutePaths.tradeBotTaxReporting, '/trade/bots/tax-reporting'),
    c(AppRoutePaths.tradeBotApiDocumentation, '/trade/bots/api-documentation'),
    c(AppRoutePaths.tradeRiskManagement, '/trade/risk-management'),
    c(AppRoutePaths.tradeExecutionQuality, '/trade/execution-quality'),
    c(AppRoutePaths.tradeAdvancedTools, '/trade/advanced-tools'),
    c(AppRoutePaths.tradeCopyTrading, '/trade/copy-trading'),
    c(AppRoutePaths.tradeCopyEducation, '/trade/copy-trading/education'),
    c(AppRoutePaths.tradeCopyActive, '/trade/copy-trading/active'),
    c(AppRoutePaths.tradeCopySettings, '/trade/copy-trading/settings'),
    c(
      AppRoutePaths.tradeCopyNotifications,
      '/trade/copy-trading/notifications',
    ),
    c(AppRoutePaths.tradeCopyComparison, '/trade/copy-trading/comparison'),
    c(AppRoutePaths.tradeCopyProviderApply, '/trade/copy-provider-apply'),
    c(AppRoutePaths.tradeCopyProvider('ct001'), '/trade/copy-provider/ct001'),
    c(
      AppRoutePaths.tradeCopyProviderAssessment('provider001'),
      '/trade/copy-provider/provider001/assessment',
    ),
    c(
      AppRoutePaths.tradeCopyProvider(
        'ct001',
        backPath: AppRoutePaths.tradeCopyTrading,
      ),
      '/trade/copy-provider/ct001?back=%2Ftrade%2Fcopy-trading',
    ),
    c(
      AppRoutePaths.tradeCopyProviderConfiguration(
        'provider001',
        backPath: AppRoutePaths.tradeCopyActive,
      ),
      '/trade/copy-provider/provider001/configuration?back=%2Ftrade%2Fcopy-trading%2Factive',
    ),
    c(
      AppRoutePaths.tradeCopyProviderConfirmation('provider001'),
      '/trade/copy-provider/provider001/confirmation',
    ),
    c(
      AppRoutePaths.tradeCopyPerformance('copy001'),
      '/trade/copy-performance/copy001',
    ),
    c(
      AppRoutePaths.tradeCopyPerformanceAttribution('copy001'),
      '/trade/copy-performance/copy001/attribution',
    ),
    c(
      AppRoutePaths.tradeCopyAuditLog('copy001'),
      '/trade/copy-audit-log/copy001',
    ),
    c(AppRoutePaths.tradeCopyRiskAnalysis, '/trade/copy-trading/risk-analysis'),
    c(AppRoutePaths.tradeCopyLeaderboard, '/trade/copy-trading/leaderboard'),
    c(AppRoutePaths.tradeCopySafety, '/trade/copy-trading/safety'),
    c(
      AppRoutePaths.tradeCopyProviderGovernance,
      '/trade/copy-provider-governance',
    ),
    c(
      AppRoutePaths.tradeCopyDisputeResolution,
      '/trade/copy-dispute-resolution',
    ),
    c(AppRoutePaths.tradeCopySafetyCenter, '/trade/copy-safety-center'),
    c(
      AppRoutePaths.tradeCopyRegulatoryDisclosures,
      '/trade/copy-regulatory-disclosures',
    ),
    c(
      AppRoutePaths.tradeCopyTransactionReporting,
      '/trade/copy-trading/transaction-reporting',
    ),
    c(
      AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
      '/trade/copy-trading/regulatory-reports-dashboard',
    ),
    c(
      AppRoutePaths.tradeCopyArmIntegrationStatus,
      '/trade/copy-trading/arm-integration-status',
    ),
    c(
      AppRoutePaths.tradeCopyBestExecutionReports,
      '/trade/copy-trading/best-execution-reports',
    ),
    c(
      AppRoutePaths.tradeCopyExecutionVenueAnalysis,
      '/trade/copy-trading/execution-venue-analysis',
    ),
    c(
      AppRoutePaths.tradeCopySlippageMonitoring,
      '/trade/copy-trading/slippage-monitoring',
    ),
    c(
      AppRoutePaths.tradeCopyClientCategorization,
      '/trade/copy-trading/client-categorization',
    ),
    c(
      AppRoutePaths.tradeCopyClientOptUpRequest,
      '/trade/copy-trading/client-opt-up-request',
    ),
    c(
      AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
      '/trade/copy-trading/regulatory-disclosures',
    ),
    c(
      AppRoutePaths.tradeCopyProductGovernance,
      '/trade/copy-trading/product-governance',
    ),
    c(
      AppRoutePaths.tradeCopyTargetMarketDefinition,
      '/trade/copy-trading/target-market-definition',
    ),
    c(
      AppRoutePaths.tradeCopyTargetMarketDefinitionForProduct('prod-1'),
      '/trade/copy-trading/target-market-definition/prod-1',
    ),
    c(
      AppRoutePaths.tradeCopyClientMoneyProtection,
      '/trade/copy-trading/client-money-protection',
    ),
    c(
      AppRoutePaths.tradeCopyCassReconciliation,
      '/trade/copy-trading/cass-reconciliation',
    ),
    c(
      AppRoutePaths.tradeCopyInvestorCompensation,
      '/trade/copy-trading/investor-compensation',
    ),
    c(AppRoutePaths.tradeCopyExAnteCosts, '/trade/copy-trading/ex-ante-costs'),
    c(
      AppRoutePaths.tradeCopyRiyCalculator,
      '/trade/copy-trading/riy-calculator',
    ),
    c(
      AppRoutePaths.tradeCopyExPostCostsReport,
      '/trade/copy-trading/ex-post-costs-report',
    ),
    c(AppRoutePaths.tradeCopyKidGenerator, '/trade/copy-trading/kid-generator'),
    c(
      AppRoutePaths.tradeCopyPerformanceScenarios,
      '/trade/copy-trading/performance-scenarios',
    ),
    c(
      AppRoutePaths.tradeCopyRiskIndicatorExplainer,
      '/trade/copy-trading/risk-indicator-explainer',
    ),
    c(
      AppRoutePaths.tradeCopyComplaintsHandling,
      '/trade/copy-trading/complaints-handling',
    ),
    c(
      AppRoutePaths.tradeCopyComplaintSubmission,
      '/trade/copy-trading/complaint-submission',
    ),
    c(
      AppRoutePaths.tradeCopyComplaintTrackingBase,
      '/trade/copy-trading/complaint-tracking',
    ),
    c(
      AppRoutePaths.tradeCopyComplaintTracking('COMP-2026-001'),
      '/trade/copy-trading/complaint-tracking/COMP-2026-001',
    ),
    c(
      AppRoutePaths.tradeCopyOmbudsmanReferral,
      '/trade/copy-trading/ombudsman-referral',
    ),
    c(AppRoutePaths.tradeCopyAuditTrail, '/trade/copy-trading/audit-trail'),
    c(
      AppRoutePaths.tradeCopyRegulatoryInspectionReady,
      '/trade/copy-trading/regulatory-inspection-ready',
    ),
    c(AppRoutePaths.tradeMargin, '/trade/margin'),
    c(AppRoutePaths.tradeMarginBtcusdt, '/trade/margin/btcusdt'),
    c(AppRoutePaths.tradeMarginAdvancedDemo, '/trade/margin/advanced-demo'),
    c(
      AppRoutePaths.tradeMarginMarketDataAnalytics,
      '/trade/margin/market-data-analytics',
    ),
    c(AppRoutePaths.tradeMarginHub, '/trade/margin/hub'),
    c(
      AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
      '/trade/margin/live-market-data-analytics',
    ),
    c(
      AppRoutePaths.tradeMarginAdvancedAnalytics,
      '/trade/margin/advanced-analytics',
    ),
    c(AppRoutePaths.tradeTrader('trader001'), '/trade/trader/trader001'),
  ]);
}
