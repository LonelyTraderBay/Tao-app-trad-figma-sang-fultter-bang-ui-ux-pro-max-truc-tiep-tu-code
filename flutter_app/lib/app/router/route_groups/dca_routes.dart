part of '../app_router.dart';

List<RouteBase> _dcaRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.dca,
      name: AppRouteNames.sc169Dca,
      builder: (_, _) => DCAPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaPortfolioOptimizer,
      name: AppRouteNames.sc174DcaPortfolioOptimizer,
      builder: (_, _) =>
          DCAPortfolioOptimizer(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaDynamicAmount,
      name: AppRouteNames.sc175DcaDynamicAmount,
      builder: (_, _) => DCADynamicAmount(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaBacktester,
      name: AppRouteNames.sc176DcaBacktester,
      builder: (_, _) => DCABacktesterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaMultiAsset,
      name: AppRouteNames.sc177DcaMultiAsset,
      builder: (_, _) => DCAMultiAssetPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaPerformanceCompare,
      name: AppRouteNames.sc178DcaPerformanceCompare,
      builder: (_, _) =>
          DCAPerformanceComparePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaSmartRules,
      name: AppRouteNames.sc179DcaSmartRules,
      builder: (_, _) => DCASmartRulesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaRebalanceConfig,
      name: AppRouteNames.sc170DcaRebalanceConfig,
      builder: (_, _) => DCARebalanceConfig(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaRebalanceDashboard,
      name: AppRouteNames.sc171DcaRebalanceDashboard,
      builder: (_, _) => DCARebalanceDashboard(
        configId: 'config001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaScheduleConfig,
      name: AppRouteNames.sc172DcaScheduleConfig,
      builder: (_, _) => DCAScheduleConfig(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.dcaScheduleAnalytics,
      name: AppRouteNames.sc173DcaScheduleAnalytics,
      builder: (_, _) => DCAScheduleAnalytics(
        configId: 'config001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/dca/rebalance/:configId/edit',
      name: AppRouteNames.sc408DcaRebalanceEdit,
      builder: (_, _) => DCARebalanceConfig(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/dca/rebalance/:configId/history',
      name: AppRouteNames.sc409DcaRebalanceHistory,
      builder: (_, state) => DCARebalanceDashboard(
        configId: state.pathParameters['configId'] ?? 'config001',
        shellRenderMode: shellRenderMode,
      ),
    ),
  ];
}
