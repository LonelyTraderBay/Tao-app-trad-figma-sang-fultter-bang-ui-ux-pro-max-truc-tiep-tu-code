import 'package:vit_trade_flutter/app/router/app_router.dart';

import 'app_route_names_contract_test_utils.dart';

void main() {
  routeNameContractTest(
    'defines stable auth market and prediction route names',
    [
      n(AppRouteNames.sc001Login, 'sc001Login'),
      n(AppRouteNames.sc002Register, 'sc002Register'),
      n(AppRouteNames.sc003Otp, 'sc003Otp'),
      n(AppRouteNames.sc004TwoFaSetup, 'sc004TwoFaSetup'),
      n(AppRouteNames.sc005ForgotPassword, 'sc005ForgotPassword'),
      n(AppRouteNames.sc006ResetPassword, 'sc006ResetPassword'),
      n(AppRouteNames.sc007Home, 'sc007Home'),
      n(AppRouteNames.sc008MarketList, 'sc008MarketList'),
      n(AppRouteNames.sc009MarketOverview, 'sc009MarketOverview'),
      n(AppRouteNames.sc010MarketMovers, 'sc010MarketMovers'),
      n(AppRouteNames.sc011MarketSectors, 'sc011MarketSectors'),
      n(AppRouteNames.sc012Watchlist, 'sc012Watchlist'),
      n(AppRouteNames.sc013MarketHeatmap, 'sc013MarketHeatmap'),
      n(AppRouteNames.sc014PriceAlerts, 'sc014PriceAlerts'),
      n(AppRouteNames.sc015MarketScreener, 'sc015MarketScreener'),
      n(AppRouteNames.sc016ComparisonTool, 'sc016ComparisonTool'),
      n(AppRouteNames.sc017MarketCalendar, 'sc017MarketCalendar'),
      n(AppRouteNames.sc018DerivativesOverview, 'sc018DerivativesOverview'),
      n(AppRouteNames.sc019MarketDepth, 'sc019MarketDepth'),
      n(AppRouteNames.sc020SocialSentiment, 'sc020SocialSentiment'),
      n(AppRouteNames.sc021PortfolioTracker, 'sc021PortfolioTracker'),
      n(AppRouteNames.sc022MarketNews, 'sc022MarketNews'),
      n(AppRouteNames.sc023AdvancedCharts, 'sc023AdvancedCharts'),
      n(AppRouteNames.sc024TokenUnlocks, 'sc024TokenUnlocks'),
      n(AppRouteNames.sc025SocialSignals, 'sc025SocialSignals'),
      n(AppRouteNames.sc026MarketCorrelations, 'sc026MarketCorrelations'),
      n(AppRouteNames.sc027PredictionsHome, 'sc027PredictionsHome'),
      n(AppRouteNames.sc028PredictionsSearch, 'sc028PredictionsSearch'),
      n(AppRouteNames.sc029PredictionsBreaking, 'sc029PredictionsBreaking'),
      n(AppRouteNames.sc030PredictionEventDetail, 'sc030PredictionEventDetail'),
      n(AppRouteNames.sc031PredictionsPortfolio, 'sc031PredictionsPortfolio'),
      n(AppRouteNames.sc032PredictionsRewards, 'sc032PredictionsRewards'),
      n(
        AppRouteNames.sc033PredictionsLeaderboard,
        'sc033PredictionsLeaderboard',
      ),
      n(
        AppRouteNames.sc034PredictionsGlobalActivity,
        'sc034PredictionsGlobalActivity',
      ),
      n(
        AppRouteNames.sc035PredictionOrderReceipt,
        'sc035PredictionOrderReceipt',
      ),
      n(
        AppRouteNames.sc036PredictionRiskCalculator,
        'sc036PredictionRiskCalculator',
      ),
      n(AppRouteNames.sc037PredictionMarketMaker, 'sc037PredictionMarketMaker'),
      n(
        AppRouteNames.sc038PredictionPortfolioAnalyzer,
        'sc038PredictionPortfolioAnalyzer',
      ),
      n(
        AppRouteNames.sc039PredictionEventCalendar,
        'sc039PredictionEventCalendar',
      ),
      n(AppRouteNames.sc040PredictionSocial, 'sc040PredictionSocial'),
      n(
        AppRouteNames.sc041PredictionAdvancedChart,
        'sc041PredictionAdvancedChart',
      ),
      n(AppRouteNames.sc042PredictionTournaments, 'sc042PredictionTournaments'),
      n(
        AppRouteNames.sc043PredictionDataIntegration,
        'sc043PredictionDataIntegration',
      ),
      n(
        AppRouteNames.sc414PredictionTournamentDetail,
        'sc414PredictionTournamentDetail',
      ),
    ],
  );
}
