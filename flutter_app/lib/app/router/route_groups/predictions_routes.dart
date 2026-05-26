part of '../app_router.dart';

List<RouteBase> _predictionRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.marketsPredictions,
      name: AppRouteNames.sc027PredictionsHome,
      builder: (_, _) => PredictionsHomePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsSearch,
      name: AppRouteNames.sc028PredictionsSearch,
      builder: (_, _) =>
          PredictionsSearchPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsBreaking,
      name: AppRouteNames.sc029PredictionsBreaking,
      builder: (_, _) =>
          PredictionsBreakingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/markets/predictions/event/:eventId',
      name: AppRouteNames.sc030PredictionEventDetail,
      builder: (_, state) => PredictionEventDetailPage(
        eventId: state.pathParameters['eventId'] ?? 'pred-1',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsPortfolio,
      name: AppRouteNames.sc031PredictionsPortfolio,
      builder: (_, _) =>
          PredictionsPortfolioPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsRewards,
      name: AppRouteNames.sc032PredictionsRewards,
      builder: (_, _) =>
          PredictionsRewardsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsLeaderboard,
      name: AppRouteNames.sc033PredictionsLeaderboard,
      builder: (_, _) =>
          PredictionsLeaderboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsActivity,
      name: AppRouteNames.sc034PredictionsGlobalActivity,
      builder: (_, _) =>
          PredictionsGlobalActivityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/markets/predictions/receipt/:receiptId',
      name: AppRouteNames.sc035PredictionOrderReceipt,
      builder: (_, state) => PredictionOrderReceiptPage(
        receiptId: state.pathParameters['receiptId'] ?? 'p2p001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsRiskCalculator,
      name: AppRouteNames.sc036PredictionRiskCalculator,
      builder: (_, _) =>
          PredictionRiskCalculatorPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsMarketMaker,
      name: AppRouteNames.sc037PredictionMarketMaker,
      builder: (_, _) =>
          PredictionMarketMakerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
      name: AppRouteNames.sc038PredictionPortfolioAnalyzer,
      builder: (_, _) =>
          PredictionPortfolioAnalyzerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsEventCalendar,
      name: AppRouteNames.sc039PredictionEventCalendar,
      builder: (_, _) =>
          PredictionEventCalendarPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsSocial,
      name: AppRouteNames.sc040PredictionSocial,
      builder: (_, _) => PredictionSocialPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/markets/predictions/advanced-chart/:eventId',
      name: AppRouteNames.sc041PredictionAdvancedChart,
      builder: (_, state) => PredictionAdvancedChartPage(
        eventId: state.pathParameters['eventId'] ?? 'btcusdt',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsTournaments,
      name: AppRouteNames.sc042PredictionTournaments,
      builder: (_, _) =>
          PredictionTournamentsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/markets/predictions/tournament/:tournamentId',
      builder: (_, state) => _BottomNavRouteSkeleton(
        title: 'Tournament ${state.pathParameters['tournamentId'] ?? 'tour'}',
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsDataIntegration,
      name: AppRouteNames.sc043PredictionDataIntegration,
      builder: (_, _) =>
          PredictionDataIntegrationPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
