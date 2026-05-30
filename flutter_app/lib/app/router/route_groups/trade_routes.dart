part of '../app_router.dart';

List<RouteBase> _tradeRoutes(ShellRenderMode shellRenderMode) {
  return [
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
      builder: (_, _) => TradingBotsPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => BotRiskDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotEmergencyStop,
      name: AppRouteNames.sc121BotEmergencyStop,
      builder: (_, _) => BotEmergencyStopPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => BotBacktestingPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => BotOptimizationPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => BotEquityCurvePage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => BotTaxReportingPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => CopyTradingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyTradingV2,
      name: AppRouteNames.sc064CopyTradingV2,
      builder: (_, _) => CopyTradingV2Page(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyEducation,
      name: AppRouteNames.sc065CopyEducation,
      builder: (_, _) => CopyEducationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyActive,
      name: AppRouteNames.sc066ActiveCopies,
      builder: (_, _) => ActiveCopiesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopySettings,
      name: AppRouteNames.sc067CopySettings,
      builder: (_, _) => CopySettingsPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => SafetyEducationPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => CopySafetyCenterPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) =>
          RegulatoryReportsDashboardPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => ExAnteCostsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRiyCalculator,
      name: AppRouteNames.sc106RiyCalculator,
      builder: (_, _) => RIYCalculatorPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => KIDGeneratorPage(shellRenderMode: shellRenderMode),
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
    ..._tradeCopyTradingOutgoingPlaceholders(shellRenderMode),
    GoRoute(
      path: AppRoutePaths.tradeMargin,
      name: AppRouteNames.sc085MarginTrading,
      builder: (_, _) => MarginTradingPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => MarginTradingHubPage(shellRenderMode: shellRenderMode),
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
          backPath: backPath == null || backPath.isEmpty ? null : backPath,
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
      builder: (_, _) => OrderReceiptPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeOrdersHistory,
      name: AppRouteNames.sc050OrdersHistory,
      builder: (_, _) => OrdersHistoryPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => TradeSettingsPage(shellRenderMode: shellRenderMode),
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
  ];
}
