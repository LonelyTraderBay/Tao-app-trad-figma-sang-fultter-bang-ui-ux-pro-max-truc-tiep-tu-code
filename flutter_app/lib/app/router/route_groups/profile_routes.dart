part of '../app_router.dart';

List<RouteBase> _profileRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.profile,
      name: AppRouteNames.sc156Profile,
      builder: (_, _) => ProfilePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileEdit,
      name: AppRouteNames.sc157EditProfile,
      builder: (_, _) => EditProfilePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileKyc,
      name: AppRouteNames.sc159Kyc,
      builder: (_, _) => KYCPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileSecurity,
      name: AppRouteNames.sc158Security,
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileSettings,
      name: AppRouteNames.sc160Settings,
      builder: (_, _) => SettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileActivity,
      name: AppRouteNames.sc161ActivityLog,
      builder: (_, _) => ActivityLogPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileApi,
      name: AppRouteNames.sc163ApiManagement,
      builder: (_, _) => ApiManagementPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileApiCreate,
      name: AppRouteNames.sc162ApiKeyCreate,
      builder: (_, _) => ApiKeyCreatePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileVip,
      name: AppRouteNames.sc164Vip,
      builder: (_, _) => VIPPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileDevices,
      name: AppRouteNames.sc165DeviceManagement,
      builder: (_, _) => DeviceManagementPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileSubAccounts,
      name: AppRouteNames.sc166SubAccount,
      builder: (_, _) => SubAccountPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profilePredictions,
      name: AppRouteNames.sc167ProfilePredictions,
      builder: (_, _) => PredictionsPortfolioPage(
        shellRenderMode: shellRenderMode,
        backPath: AppRoutePaths.profile,
        semanticLabel: 'SC-167 PredictionsPortfolioPage',
      ),
    ),
    GoRoute(
      path: AppRoutePaths.profileArena,
      name: AppRouteNames.sc168MyArena,
      builder: (_, _) => MyArenaPage(shellRenderMode: shellRenderMode),
    ),
    ..._profileOutgoingPlaceholders,
  ];
}
