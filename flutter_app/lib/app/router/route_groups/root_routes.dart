part of '../app_router.dart';

GoRouter createAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
}) {
  final config = appConfig ?? AppConfig.current;
  return GoRouter(
    initialLocation: initialLocation ?? _defaultInitialLocation,
    // SEC-S45: route không khớp -> trang lỗi tiếng Việt thay ErrorScreen
    // mặc định tiếng Anh của go_router.
    errorBuilder: (context, state) => const VitRouteErrorPage(),
    // GĐ4-F1 kill-switch: redirect toàn cục sang 1 trong 2 trang gate khi
    // maintenanceMode/forceUpdateRequired bật, và tự đưa người dùng ra khỏi
    // gate khi cả 2 cờ đều tắt (không nhốt user ở lại trang gate).
    redirect: (context, state) {
      final path = state.uri.path;
      final onMaintenanceGate = path == AppRoutePaths.maintenanceGate;
      final onForceUpdateGate = path == AppRoutePaths.forceUpdateGate;

      if (config.maintenanceMode) {
        return onMaintenanceGate ? null : AppRoutePaths.maintenanceGate;
      }
      if (config.forceUpdateRequired) {
        return onForceUpdateGate ? null : AppRoutePaths.forceUpdateGate;
      }
      if (onMaintenanceGate || onForceUpdateGate) {
        return AppRoutePaths.home;
      }
      return null;
    },
    routes: [
      ...topLevelRoutes(shellRenderMode),
      _appShellRoute(shellRenderMode),
    ],
  );
}

ShellRoute _appShellRoute(ShellRenderMode shellRenderMode) {
  return ShellRoute(
    builder: (context, state, child) {
      final activeDestination = _activeDestinationForPath(state.uri.path);
      return Consumer(
        builder: (context, ref, _) {
          final appShell = VitAppShell(
            renderMode: shellRenderMode,
            currentPath: state.uri.path,
            activeDestination: activeDestination,
            notificationBadgeCount: ref.watch(notificationUnreadCountProvider),
            statusBarTime: shellRenderMode.usesVisualQaFrame
                ? _visualQaStatusBarTimeForUri(state.uri)
                : null,
            onDestinationSelected: (destination) {
              context.go(destination.routePath);
            },
            child: child,
          );

          if (!shellRenderMode.usesVisualQaFrame) return appShell;
          return VitPhoneFrame(child: appShell);
        },
      );
    },
    routes: [
      ...homeRoutes(shellRenderMode),
      ...marketsRoutes(shellRenderMode),
      ...predictionRoutes(shellRenderMode),
      ...marketPairRoutes(shellRenderMode),
      ...tradeComplianceRoutes(shellRenderMode),
      ...tradeCopyRoutes(shellRenderMode),
      ...tradeBotsRoutes(shellRenderMode),
      // NOTE: `tradeTerminalRoutes` must stay BEFORE `tradeRoutes`: the
      // terminal group registers literal `/trade/...` paths (risk-management,
      // execution-quality, advanced-tools, ...) that would otherwise be
      // shadowed by the parameterized `/trade/:pairId` route at the end of
      // `tradeRoutes` (go_router matches in declaration order).
      ...tradeTerminalRoutes(shellRenderMode),
      ...tradeRoutes(shellRenderMode),
      ...adminRoutes(shellRenderMode),
      // NOTE: marketplace + orders before residual `p2pRoutes` (ADR-012 PR1/PR2).
      ...p2pMarketplaceRoutes(shellRenderMode),
      ...p2pOrdersRoutes(shellRenderMode),
      ...p2pRoutes(shellRenderMode),
      ...supportRoutes(shellRenderMode),
      ...launchpadRoutes(shellRenderMode),
      ...arenaCoreRoutes(shellRenderMode),
      ...utilityRoutes(shellRenderMode),
      ...earnStakingRoutes(shellRenderMode),
      ...earnSavingsRoutes(shellRenderMode),
      ...arenaExtendedRoutes(shellRenderMode),
      ...dcaRoutes(shellRenderMode),
      ...walletRoutes(shellRenderMode),
      ...profileRoutes(shellRenderMode),
      ...discoveryAndReferralRoutes(shellRenderMode),
      ...navigationPlaceholderRoutes,
    ],
  );
}
