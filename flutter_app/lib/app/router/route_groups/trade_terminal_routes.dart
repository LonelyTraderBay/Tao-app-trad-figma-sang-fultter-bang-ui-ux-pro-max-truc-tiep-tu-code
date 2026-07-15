part of '../app_router.dart';

List<RouteBase> _tradeTerminalRoutes(ShellRenderMode shellRenderMode) {
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
      path: AppRoutePaths.tradeMarginAdvancedDemo,
      name: AppRouteNames.sc088AdvancedTradingDemo,
      builder: (_, _) =>
          AdvancedTradingDemoPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginAdvancedAnalytics,
      name: AppRouteNames.sc092AdvancedAnalytics,
      builder: (_, _) =>
          AdvancedAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
