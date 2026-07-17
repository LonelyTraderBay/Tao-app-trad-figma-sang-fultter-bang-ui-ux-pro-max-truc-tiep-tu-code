import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/predictions/presentation/pages/event/prediction_advanced_chart_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/social/prediction_data_integration_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/hub/predictions_breaking_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/social/prediction_event_calendar_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/portfolio/prediction_market_maker_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/event/prediction_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/portfolio/prediction_portfolio_analyzer_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/portfolio/prediction_risk_calculator_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/social/prediction_social_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/social/prediction_tournaments_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/social/predictions_global_activity_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/social/predictions_leaderboard_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/portfolio/predictions_portfolio_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/hub/predictions_rewards_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/hub/predictions_search_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> predictionRoutes(ShellRenderMode shellRenderMode) {
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
      name: AppRouteNames.sc414PredictionTournamentDetail,
      builder: (_, state) => PredictionTournamentDetailPage(
        tournamentId: state.pathParameters['tournamentId'] ?? 'tour1',
        shellRenderMode: shellRenderMode,
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
