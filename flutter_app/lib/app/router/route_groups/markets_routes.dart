part of '../app_router.dart';

List<RouteBase> _marketsRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.markets,
      name: AppRouteNames.sc008MarketList,
      builder: (_, _) => MarketListPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsOverview,
      name: AppRouteNames.sc009MarketOverview,
      builder: (_, _) => MarketOverviewPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsMovers,
      name: AppRouteNames.sc010MarketMovers,
      builder: (_, _) => MarketMoversPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsSectors,
      name: AppRouteNames.sc011MarketSectors,
      builder: (_, state) => MarketSectorsPage(
        shellRenderMode: shellRenderMode,
        selectedSectorId: state.uri.queryParameters['id'],
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsWatchlist,
      name: AppRouteNames.sc012Watchlist,
      builder: (_, _) => WatchlistPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsHeatmap,
      name: AppRouteNames.sc013MarketHeatmap,
      builder: (_, _) => MarketHeatmapPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsAlerts,
      name: AppRouteNames.sc014PriceAlerts,
      builder: (_, _) => PriceAlertsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsScreener,
      name: AppRouteNames.sc015MarketScreener,
      builder: (_, _) => MarketScreenerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsCompare,
      name: AppRouteNames.sc016ComparisonTool,
      builder: (_, _) => ComparisonToolPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsCalendar,
      name: AppRouteNames.sc017MarketCalendar,
      builder: (_, _) => MarketCalendarPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsDerivatives,
      name: AppRouteNames.sc018DerivativesOverview,
      builder: (_, _) =>
          DerivativesOverviewPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsDepth,
      name: AppRouteNames.sc019MarketDepth,
      builder: (_, _) => MarketDepthPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsSocialSentiment,
      name: AppRouteNames.sc020SocialSentiment,
      builder: (_, _) => SocialSentimentPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPortfolioTracker,
      name: AppRouteNames.sc021PortfolioTracker,
      builder: (_, _) => PortfolioTrackerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsNews,
      name: AppRouteNames.sc022MarketNews,
      builder: (_, _) => MarketNewsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsAdvancedCharts,
      name: AppRouteNames.sc023AdvancedCharts,
      builder: (_, _) => AdvancedChartsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsUnlocks,
      name: AppRouteNames.sc024TokenUnlocks,
      builder: (_, _) => TokenUnlocksPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsSignals,
      name: AppRouteNames.sc025SocialSignals,
      builder: (_, _) => SocialSignalsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsCorrelations,
      name: AppRouteNames.sc026MarketCorrelations,
      builder: (_, _) =>
          MarketCorrelationsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}

List<RouteBase> _marketPairRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: '/pair/:pairId',
      name: AppRouteNames.sc044PairDetail,
      builder: (_, state) => PairDetailPage(
        pairId: state.pathParameters['pairId'] ?? 'btcusdt',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/pair/:pairId/info',
      name: AppRouteNames.sc045TokenInfo,
      builder: (_, state) => TokenInfoPage(
        pairId: state.pathParameters['pairId'] ?? 'btcusdt',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/pair/:pairId/depth',
      name: AppRouteNames.sc046PairDepth,
      builder: (_, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        final returnTo = state.uri.queryParameters['returnTo'];
        return MarketDepthPage(
          pairId: pairId,
          backPath: returnTo ?? AppRoutePaths.pairDetail(pairId),
          shellRenderMode: shellRenderMode,
        );
      },
    ),
  ];
}
