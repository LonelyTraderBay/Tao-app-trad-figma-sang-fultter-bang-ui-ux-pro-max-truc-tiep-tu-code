import 'package:vit_trade_flutter/app/router/app_router.dart';

import 'app_route_paths_contract_test_utils.dart';

void main() {
  routePathContractTest('defines stable market and prediction route paths', [
    c(AppRoutePaths.markets, '/markets'),
    c(AppRoutePaths.marketsOverview, '/markets/overview'),
    c(AppRoutePaths.marketsMovers, '/markets/movers'),
    c(AppRoutePaths.marketsSectors, '/markets/sectors'),
    c(AppRoutePaths.marketsWatchlist, '/markets/watchlist'),
    c(AppRoutePaths.marketsHeatmap, '/markets/heatmap'),
    c(AppRoutePaths.marketsAlerts, '/markets/alerts'),
    c(AppRoutePaths.marketsScreener, '/markets/screener'),
    c(AppRoutePaths.marketsCompare, '/markets/compare'),
    c(AppRoutePaths.marketsCalendar, '/markets/calendar'),
    c(AppRoutePaths.marketsDerivatives, '/markets/derivatives'),
    c(AppRoutePaths.marketsDepth, '/markets/depth'),
    c(AppRoutePaths.marketsSocialSentiment, '/markets/social-sentiment'),
    c(AppRoutePaths.marketsPortfolioTracker, '/markets/portfolio-tracker'),
    c(AppRoutePaths.marketsNews, '/markets/news'),
    c(AppRoutePaths.marketsAdvancedCharts, '/markets/advanced-charts'),
    c(AppRoutePaths.marketsUnlocks, '/markets/unlocks'),
    c(AppRoutePaths.marketsSignals, '/markets/signals'),
    c(AppRoutePaths.marketsCorrelations, '/markets/correlations'),
    c(AppRoutePaths.marketsPredictions, '/markets/predictions'),
    c(AppRoutePaths.marketsPredictionsSearch, '/markets/predictions/search'),
    c(
      AppRoutePaths.marketsPredictionsBreaking,
      '/markets/predictions/breaking',
    ),
    c(
      AppRoutePaths.marketsPredictionEvent('pred-1'),
      '/markets/predictions/event/pred-1',
    ),
    c(
      AppRoutePaths.marketsPredictionsPortfolio,
      '/markets/predictions/portfolio',
    ),
    c(
      AppRoutePaths.marketsPredictionReceipt('po-1'),
      '/markets/predictions/receipt/po-1',
    ),
    c(AppRoutePaths.marketsPredictionsRewards, '/markets/predictions/rewards'),
    c(
      AppRoutePaths.marketsPredictionsLeaderboard,
      '/markets/predictions/leaderboard',
    ),
    c(
      AppRoutePaths.marketsPredictionsActivity,
      '/markets/predictions/activity',
    ),
    c(
      AppRoutePaths.marketsPredictionsRiskCalculator,
      '/markets/predictions/risk-calculator',
    ),
    c(
      AppRoutePaths.marketsPredictionsMarketMaker,
      '/markets/predictions/market-maker',
    ),
    c(
      AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
      '/markets/predictions/portfolio-analyzer',
    ),
    c(
      AppRoutePaths.marketsPredictionsEventCalendar,
      '/markets/predictions/event-calendar',
    ),
    c(AppRoutePaths.marketsPredictionsSocial, '/markets/predictions/social'),
    c(
      AppRoutePaths.marketsPredictionsAdvancedChart('btcusdt'),
      '/markets/predictions/advanced-chart/btcusdt',
    ),
    c(
      AppRoutePaths.marketsPredictionsTournaments,
      '/markets/predictions/tournaments',
    ),
    c(
      AppRoutePaths.marketsPredictionTournament('tour1'),
      '/markets/predictions/tournament/tour1',
    ),
    c(
      AppRoutePaths.marketsPredictionsDataIntegration,
      '/markets/predictions/data-integration',
    ),
    c(AppRoutePaths.pairDetail('btcusdt'), '/pair/btcusdt'),
    c(AppRoutePaths.pairInfo('btcusdt'), '/pair/btcusdt/info'),
    c(AppRoutePaths.pairDepth('btcusdt'), '/pair/btcusdt/depth'),
    c(AppRoutePaths.profilePredictions, '/profile/predictions'),
  ]);
}
