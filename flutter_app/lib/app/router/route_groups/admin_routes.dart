part of '../app_router.dart';

List<RouteBase> _adminRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.admin,
      name: AppRouteNames.sc180AdminHome,
      builder: (_, _) => AdminHome(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.adminAnalytics,
      name: AppRouteNames.sc181AnalyticsDashboard,
      builder: (_, _) => AnalyticsDashboard(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.adminAbtests,
      name: AppRouteNames.sc182AbTestDashboard,
      builder: (_, _) => ABTestDashboard(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.adminFunnels,
      name: AppRouteNames.sc183FunnelDashboard,
      builder: (_, _) => FunnelDashboard(shellRenderMode: shellRenderMode),
    ),
    ..._adminOutgoingPlaceholders(shellRenderMode),
  ];
}
