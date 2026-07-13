part of '../app_router.dart';

List<RouteBase> _tradeBotsRoutes(ShellRenderMode shellRenderMode) {
  return [
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
  ];
}
