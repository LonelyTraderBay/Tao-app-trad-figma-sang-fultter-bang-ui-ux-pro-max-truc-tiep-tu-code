part of '../app_router.dart';

List<RouteBase> _tradeCopyRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.tradeCopyTrading,
      name: AppRouteNames.sc063CopyTrading,
      builder: (_, _) => CopyTradingPage(shellRenderMode: shellRenderMode),
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
      path: '/trade/trader/:traderId',
      name: AppRouteNames.sc087TraderProfile,
      builder: (_, state) => TraderProfilePage(
        traderId: state.pathParameters['traderId'] ?? 'trader001',
        shellRenderMode: shellRenderMode,
      ),
    ),
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
        final providerId = state.pathParameters['providerId'] ?? '';
        final backPath = resolveSafeBackPath(
          candidate: state.uri.queryParameters['back'],
          fallbackPath: AppRoutePaths.tradeCopyProvider(providerId),
          allowedPrefixes: const [AppRoutePaths.trade],
        );
        return CopyConfigurationPage(
          providerId: providerId,
          backPath: backPath,
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
        final backPath = resolveSafeBackPath(
          candidate: state.uri.queryParameters['back'],
          fallbackPath: AppRoutePaths.tradeCopyTrading,
          allowedPrefixes: const [AppRoutePaths.trade],
        );
        return CopyProviderDetailPage(
          providerId: state.pathParameters['providerId'] ?? 'provider001',
          backPath: backPath,
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
      path: AppRoutePaths.demoCopyCard,
      name: AppRouteNames.sc401CopyTradingCardDemo,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.qaDemo,
        routePath: AppRoutePaths.demoCopyCard,
        child: CopyTradingCardDemo(shellRenderMode: shellRenderMode),
      ),
    ),
  ];
}
