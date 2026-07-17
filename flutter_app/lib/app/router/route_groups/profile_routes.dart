import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/predictions/presentation/pages/portfolio/predictions_portfolio_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/hub/my_arena_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/activity_log_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/api_management_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/api_key_create_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/device_management_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/kyc_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/security_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/settings_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/sub_account_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/vip_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';

List<RouteBase> profileRoutes(ShellRenderMode shellRenderMode) {
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
        semanticIdentifier: 'SC-167',
      ),
    ),
    GoRoute(
      path: AppRoutePaths.profileArena,
      name: AppRouteNames.sc168MyArena,
      builder: (_, _) => MyArenaPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurity,
      name: AppRouteNames.sc413SettingsSecurity,
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    ...profileOutgoingPlaceholders,
  ];
}
