part of '../app_router.dart';

final List<GoRoute> _homeOutgoingPlaceholders = [];

final List<GoRoute> _launchpadOutgoingPlaceholders = [];

final List<GoRoute> _marketOutgoingPlaceholders = [];

final List<GoRoute> _walletOutgoingPlaceholders = [];

List<GoRoute> _dcaOutgoingPlaceholders(ShellRenderMode shellRenderMode) => [
  GoRoute(
    path: '/dca/rebalance/:configId/edit',
    builder: (_, _) => DCARebalanceConfig(shellRenderMode: shellRenderMode),
  ),
  GoRoute(
    path: '/dca/rebalance/:configId/history',
    builder: (_, state) => DCARebalanceDashboard(
      configId: state.pathParameters['configId'] ?? 'config001',
      shellRenderMode: shellRenderMode,
    ),
  ),
];

List<GoRoute> _adminOutgoingPlaceholders(ShellRenderMode shellRenderMode) => [
  GoRoute(
    path: AppRoutePaths.adminSettings,
    builder: (_, _) => AdminSettingsPage(shellRenderMode: shellRenderMode),
  ),
];

final List<GoRoute> _profileOutgoingPlaceholders = [];

final List<GoRoute> _tradeMarginOutgoingPlaceholders = [];

List<GoRoute> _tradeCopyTradingOutgoingPlaceholders(
  ShellRenderMode shellRenderMode,
) => [
  GoRoute(
    path: AppRoutePaths.tradeCopyClientOptUpRequest,
    builder: (_, _) => ClientOptUpRequestPage(shellRenderMode: shellRenderMode),
  ),
  GoRoute(
    path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
    redirect: (_, _) => AppRoutePaths.tradeCopyRegulatoryDisclosures,
  ),
  GoRoute(
    path: AppRoutePaths.settingsSecurity,
    builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
  ),
];

final List<GoRoute> _tradeBotsOutgoingPlaceholders = [];

final List<GoRoute> _earnRiskOutgoingPlaceholders = [];
