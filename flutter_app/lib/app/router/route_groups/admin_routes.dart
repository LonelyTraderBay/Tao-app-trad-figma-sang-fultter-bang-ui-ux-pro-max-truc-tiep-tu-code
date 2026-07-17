import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/admin/presentation/pages/admin_home.dart';
import 'package:vit_trade_flutter/features/admin/presentation/pages/ab_test_dashboard.dart';
import 'package:vit_trade_flutter/features/admin/presentation/pages/analytics_dashboard.dart';
import 'package:vit_trade_flutter/features/admin/presentation/pages/funnel_dashboard.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> adminRoutes(ShellRenderMode shellRenderMode) {
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
