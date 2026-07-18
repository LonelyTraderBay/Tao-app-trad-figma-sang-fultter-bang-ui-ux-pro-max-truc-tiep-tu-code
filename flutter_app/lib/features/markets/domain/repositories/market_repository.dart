import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';

/// Data contract for all Markets feature read-models: lists, overview,
/// movers, sectors, watchlist, screener, calendar, derivatives, depth,
/// sentiment, portfolio, news, charts, unlocks, signals, correlations,
/// and per-pair detail/token-info screens.
abstract interface class MarketRepository {
  Future<MarketListSnapshot> getMarketList();

  Future<MarketOverviewSnapshot> getMarketOverview();

  Future<MarketMoversSnapshot> getMarketMovers();

  Future<MarketSectorsSnapshot> getMarketSectors();

  Future<MarketWatchlistSnapshot> getMarketWatchlist();

  Future<MarketHeatmapSnapshot> getMarketHeatmap();

  Future<MarketAlertsSnapshot> getPriceAlerts();

  Future<MarketScreenerSnapshot> getMarketScreener({
    MarketScreenerQuery? query,
  });

  Future<MarketComparisonSnapshot> getMarketComparison();

  Future<MarketCalendarSnapshot> getMarketCalendar({
    MarketCalendarQuery? query,
  });

  Future<MarketDerivativesSnapshot> getMarketDerivatives({
    MarketDerivativesSort sortBy = MarketDerivativesSort.openInterest,
  });

  Future<MarketDepthSnapshot> getMarketDepth({
    String pairId = 'btcusdt',
    int levels = 25,
  });

  Future<MarketSocialSentimentSnapshot> getSocialSentiment({
    MarketSentimentSort sortBy = MarketSentimentSort.sentiment,
  });

  Future<MarketPortfolioSnapshot> getPortfolioTracker({
    MarketPortfolioSort sortBy = MarketPortfolioSort.value,
  });

  Future<MarketNewsSnapshot> getMarketNews({
    String category = 'all',
    MarketNewsSentiment? sentiment,
  });

  Future<MarketAdvancedChartsSnapshot> getAdvancedCharts({
    String indicatorCategory = 'all',
    String drawingCategory = 'all',
  });

  Future<MarketTokenUnlocksSnapshot> getTokenUnlocks({
    MarketUnlockSort sortBy = MarketUnlockSort.nearest,
    MarketUnlockImpact? impactFilter,
  });

  Future<MarketSocialSignalsSnapshot> getSocialSignals({
    TradingSignalStatus? statusFilter,
    TradingSignalCategory? categoryFilter,
  });

  Future<MarketCorrelationsSnapshot> getMarketCorrelations({
    MarketCorrelationTimeframe timeframe = MarketCorrelationTimeframe.d7,
    CorrelationSortOrder sortOrder = CorrelationSortOrder.high,
  });

  Future<MarketPairDetailSnapshot> getPairDetail(String pairId);

  Future<MarketTokenInfoSnapshot> getTokenInfo(String pairId);
}
