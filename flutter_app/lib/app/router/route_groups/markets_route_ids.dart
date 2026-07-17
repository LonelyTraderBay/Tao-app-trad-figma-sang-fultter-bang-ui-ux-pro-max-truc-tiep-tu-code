final class MarketsRoutePaths {
  const MarketsRoutePaths._();

  static const String markets = '/markets';
  static const String marketsOverview = '/markets/overview';
  static const String marketsMovers = '/markets/movers';
  static const String marketsSectors = '/markets/sectors';
  static const String marketsWatchlist = '/markets/watchlist';
  static const String marketsHeatmap = '/markets/heatmap';
  static const String marketsAlerts = '/markets/alerts';
  static const String marketsScreener = '/markets/screener';
  static const String marketsCompare = '/markets/compare';
  static const String marketsCalendar = '/markets/calendar';
  static const String marketsDerivatives = '/markets/derivatives';
  static const String marketsDepth = '/markets/depth';
  static const String marketsSocialSentiment = '/markets/social-sentiment';
  static const String marketsPortfolioTracker = '/markets/portfolio-tracker';
  static const String marketsNews = '/markets/news';
  static const String marketsAdvancedCharts = '/markets/advanced-charts';
  static const String marketsUnlocks = '/markets/unlocks';
  static const String marketsSignals = '/markets/signals';
  static const String marketsCorrelations = '/markets/correlations';
  static String pairDetail(String pairId) => '/pair/$pairId';
  static String pairInfo(String pairId) => '/pair/$pairId/info';
  static String pairDepth(String pairId) => '/pair/$pairId/depth';
}

final class MarketsRouteNames {
  const MarketsRouteNames._();

  static const String sc008MarketList = 'sc008MarketList';
  static const String sc009MarketOverview = 'sc009MarketOverview';
  static const String sc010MarketMovers = 'sc010MarketMovers';
  static const String sc011MarketSectors = 'sc011MarketSectors';
  static const String sc012Watchlist = 'sc012Watchlist';
  static const String sc013MarketHeatmap = 'sc013MarketHeatmap';
  static const String sc014PriceAlerts = 'sc014PriceAlerts';
  static const String sc015MarketScreener = 'sc015MarketScreener';
  static const String sc016ComparisonTool = 'sc016ComparisonTool';
  static const String sc017MarketCalendar = 'sc017MarketCalendar';
  static const String sc018DerivativesOverview = 'sc018DerivativesOverview';
  static const String sc019MarketDepth = 'sc019MarketDepth';
  static const String sc020SocialSentiment = 'sc020SocialSentiment';
  static const String sc021PortfolioTracker = 'sc021PortfolioTracker';
  static const String sc022MarketNews = 'sc022MarketNews';
  static const String sc023AdvancedCharts = 'sc023AdvancedCharts';
  static const String sc024TokenUnlocks = 'sc024TokenUnlocks';
  static const String sc025SocialSignals = 'sc025SocialSignals';
  static const String sc026MarketCorrelations = 'sc026MarketCorrelations';
  static const String sc044PairDetail = 'sc044PairDetail';
  static const String sc045TokenInfo = 'sc045TokenInfo';
  static const String sc046PairDepth = 'sc046PairDepth';
}
