import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';

/// Data contract for all Markets feature read-models: lists, overview,
/// movers, sectors, watchlist, screener, calendar, derivatives, depth,
/// sentiment, portfolio, news, charts, unlocks, signals, correlations,
/// and per-pair detail/token-info screens.
abstract interface class MarketRepository {
  MarketListSnapshot getMarketList();

  MarketOverviewSnapshot getMarketOverview();

  MarketMoversSnapshot getMarketMovers();

  MarketSectorsSnapshot getMarketSectors();

  MarketWatchlistSnapshot getMarketWatchlist();

  MarketHeatmapSnapshot getMarketHeatmap();

  MarketAlertsSnapshot getPriceAlerts();

  MarketScreenerSnapshot getMarketScreener({MarketScreenerQuery? query});

  MarketComparisonSnapshot getMarketComparison();

  MarketCalendarSnapshot getMarketCalendar({MarketCalendarQuery? query});

  MarketDerivativesSnapshot getMarketDerivatives({
    MarketDerivativesSort sortBy = MarketDerivativesSort.openInterest,
  });

  MarketDepthSnapshot getMarketDepth({
    String pairId = 'btcusdt',
    int levels = 25,
  });

  MarketSocialSentimentSnapshot getSocialSentiment({
    MarketSentimentSort sortBy = MarketSentimentSort.sentiment,
  });

  MarketPortfolioSnapshot getPortfolioTracker({
    MarketPortfolioSort sortBy = MarketPortfolioSort.value,
  });

  MarketNewsSnapshot getMarketNews({
    String category = 'all',
    MarketNewsSentiment? sentiment,
  });

  MarketAdvancedChartsSnapshot getAdvancedCharts({
    String indicatorCategory = 'all',
    String drawingCategory = 'all',
  });

  MarketTokenUnlocksSnapshot getTokenUnlocks({
    MarketUnlockSort sortBy = MarketUnlockSort.nearest,
    MarketUnlockImpact? impactFilter,
  });

  MarketSocialSignalsSnapshot getSocialSignals({
    TradingSignalStatus? statusFilter,
    TradingSignalCategory? categoryFilter,
  });

  MarketCorrelationsSnapshot getMarketCorrelations({
    MarketCorrelationTimeframe timeframe = MarketCorrelationTimeframe.d7,
    CorrelationSortOrder sortOrder = CorrelationSortOrder.high,
  });

  MarketPairDetailSnapshot getPairDetail(String pairId);

  MarketTokenInfoSnapshot getTokenInfo(String pairId);
}
