part of '../app_router.dart';

List<RouteBase> _tradeComplianceRoutes(ShellRenderMode shellRenderMode) {
  return [
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
      name: AppRouteNames.sc415TargetMarketDefinitionDetail,
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
      name: AppRouteNames.sc416ComplaintTrackingDetail,
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
    GoRoute(
      path: AppRoutePaths.tradeCopyClientOptUpRequest,
      name: AppRouteNames.sc411ClientOptUpRequest,
      builder: (_, _) =>
          ClientOptUpRequestPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginMarketDataAnalytics,
      name: AppRouteNames.sc089MarketDataAnalytics,
      builder: (_, _) =>
          MarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
      name: AppRouteNames.sc091LiveMarketDataAnalytics,
      builder: (_, _) =>
          LiveMarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
