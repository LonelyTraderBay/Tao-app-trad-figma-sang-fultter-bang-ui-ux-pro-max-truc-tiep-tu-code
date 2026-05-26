part of '../app_router.dart';

final List<GoRoute> _homeOutgoingPlaceholders = [
  _placeholderRoute(AppRoutePaths.p2p, 'P2P'),
];

final List<GoRoute> _launchpadOutgoingPlaceholders = [];

final List<GoRoute> _marketOutgoingPlaceholders = [];

final List<GoRoute> _walletOutgoingPlaceholders = [];

final List<GoRoute> _dcaOutgoingPlaceholders = [
  _placeholderRoute(
    '/dca/rebalance/:configId/edit',
    'Rebalance Settings',
    backPath: AppRoutePaths.dcaRebalanceDashboard,
  ),
  _placeholderRoute(
    '/dca/rebalance/:configId/history',
    'Rebalance History',
    backPath: AppRoutePaths.dcaRebalanceDashboard,
  ),
];

final List<GoRoute> _adminOutgoingPlaceholders = [
  _placeholderRoute(
    AppRoutePaths.adminSettings,
    'Admin Settings',
    backPath: AppRoutePaths.admin,
  ),
];

final List<GoRoute> _profileOutgoingPlaceholders = [];

final List<GoRoute> _tradeMarginOutgoingPlaceholders = [];

final List<GoRoute> _tradeCopyTradingOutgoingPlaceholders = [
  _placeholderRoute(
    AppRoutePaths.tradeCopyClientOptUpRequest,
    'Client Opt-Up Request',
    backPath: AppRoutePaths.tradeCopyClientCategorization,
  ),
  GoRoute(
    path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
    redirect: (_, _) => AppRoutePaths.tradeCopyRegulatoryDisclosures,
  ),
  _placeholderRoute(
    AppRoutePaths.settingsSecurity,
    'Security Settings',
    backPath: AppRoutePaths.tradeCopyClientCategorization,
  ),
];

final List<GoRoute> _tradeBotsOutgoingPlaceholders = [];

final List<GoRoute> _earnRiskOutgoingPlaceholders = [];

GoRoute _placeholderRoute(
  String path,
  String title, {
  String backPath = AppRoutePaths.home,
}) {
  return GoRoute(
    path: path,
    builder: (_, _) =>
        _UnportedRoutePlaceholder(title: title, backPath: backPath),
  );
}

class _BottomNavRouteSkeleton extends StatelessWidget {
  const _BottomNavRouteSkeleton({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(title: title),
          const VitPageContent(children: []),
        ],
      ),
    );
  }
}

class _UnportedRoutePlaceholder extends StatelessWidget {
  const _UnportedRoutePlaceholder({
    required this.title,
    required this.backPath,
  });

  final String title;
  final String backPath;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      child: Column(
        children: [
          VitHeader(
            title: title,
            showBack: true,
            onBack: () => context.go(backPath),
          ),
          const VitPageContent(children: [SizedBox.shrink()]),
        ],
      ),
    );
  }
}
