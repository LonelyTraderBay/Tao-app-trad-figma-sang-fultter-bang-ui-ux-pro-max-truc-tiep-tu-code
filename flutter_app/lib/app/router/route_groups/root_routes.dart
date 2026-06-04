part of '../app_router.dart';

GoRouter createAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? _defaultInitialLocation,
    routes: [
      ..._topLevelRoutes(shellRenderMode),
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
      ..._homeRoutes(shellRenderMode),
      ..._marketsRoutes(shellRenderMode),
      ..._predictionRoutes(shellRenderMode),
      ..._marketPairRoutes(shellRenderMode),
      ..._tradeRoutes(shellRenderMode),
      ..._adminRoutes(shellRenderMode),
      ..._p2pRoutes(shellRenderMode),
      ..._supportRoutes(shellRenderMode),
      ..._launchpadRoutes(shellRenderMode),
      ..._arenaCoreRoutes(shellRenderMode),
      ..._utilityRoutes(shellRenderMode),
      ..._earnRoutes(shellRenderMode),
      ..._arenaExtendedRoutes(shellRenderMode),
      ..._dcaRoutes(shellRenderMode),
      ..._walletRoutes(shellRenderMode),
      ..._profileRoutes(shellRenderMode),
      ..._discoveryAndReferralRoutes(shellRenderMode),
      ..._navigationPlaceholderRoutes,
    ],
  );
}
