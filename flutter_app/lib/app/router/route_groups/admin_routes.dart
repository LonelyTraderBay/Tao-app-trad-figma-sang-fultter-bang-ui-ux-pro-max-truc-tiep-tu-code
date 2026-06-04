part of '../app_router.dart';

List<RouteBase> _adminRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.admin,
      name: AppRouteNames.sc180AdminHome,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.admin,
        child: AdminHome(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminAnalytics,
      name: AppRouteNames.sc181AnalyticsDashboard,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminAnalytics,
        child: AnalyticsDashboard(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminAbtests,
      name: AppRouteNames.sc182AbTestDashboard,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminAbtests,
        child: ABTestDashboard(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminFunnels,
      name: AppRouteNames.sc183FunnelDashboard,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminFunnels,
        child: FunnelDashboard(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminSettings,
      name: AppRouteNames.sc410AdminSettings,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminSettings,
        child: AdminSettingsPage(shellRenderMode: shellRenderMode),
      ),
    ),
  ];
}
