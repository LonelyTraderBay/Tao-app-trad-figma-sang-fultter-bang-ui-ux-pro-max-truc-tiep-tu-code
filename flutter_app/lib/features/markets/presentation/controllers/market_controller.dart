import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

export 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
export 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

final class MarketController implements MarketRepository {
  const MarketController(this._repository);

  final MarketRepository _repository;

  @override
  MarketListSnapshot getMarketList() => _repository.getMarketList();

  @override
  MarketOverviewSnapshot getMarketOverview() {
    return _repository.getMarketOverview();
  }

  @override
  MarketMoversSnapshot getMarketMovers() => _repository.getMarketMovers();

  @override
  MarketSectorsSnapshot getMarketSectors() => _repository.getMarketSectors();

  @override
  MarketWatchlistSnapshot getMarketWatchlist() {
    return _repository.getMarketWatchlist();
  }

  @override
  MarketHeatmapSnapshot getMarketHeatmap() => _repository.getMarketHeatmap();

  @override
  MarketAlertsSnapshot getPriceAlerts() => _repository.getPriceAlerts();

  @override
  MarketScreenerSnapshot getMarketScreener({MarketScreenerQuery? query}) {
    return _repository.getMarketScreener(query: query);
  }

  @override
  MarketComparisonSnapshot getMarketComparison() {
    return _repository.getMarketComparison();
  }

  @override
  MarketCalendarSnapshot getMarketCalendar({MarketCalendarQuery? query}) {
    return _repository.getMarketCalendar(query: query);
  }

  @override
  MarketDerivativesSnapshot getMarketDerivatives({
    MarketDerivativesSort sortBy = MarketDerivativesSort.openInterest,
  }) {
    return _repository.getMarketDerivatives(sortBy: sortBy);
  }

  @override
  MarketDepthSnapshot getMarketDepth({
    String pairId = 'btcusdt',
    int levels = 25,
  }) {
    return _repository.getMarketDepth(pairId: pairId, levels: levels);
  }

  @override
  MarketSocialSentimentSnapshot getSocialSentiment({
    MarketSentimentSort sortBy = MarketSentimentSort.sentiment,
  }) {
    return _repository.getSocialSentiment(sortBy: sortBy);
  }

  @override
  MarketPortfolioSnapshot getPortfolioTracker({
    MarketPortfolioSort sortBy = MarketPortfolioSort.value,
  }) {
    return _repository.getPortfolioTracker(sortBy: sortBy);
  }

  @override
  MarketNewsSnapshot getMarketNews({
    String category = 'all',
    MarketNewsSentiment? sentiment,
  }) {
    return _repository.getMarketNews(category: category, sentiment: sentiment);
  }

  @override
  MarketAdvancedChartsSnapshot getAdvancedCharts({
    String indicatorCategory = 'all',
    String drawingCategory = 'all',
  }) {
    return _repository.getAdvancedCharts(
      indicatorCategory: indicatorCategory,
      drawingCategory: drawingCategory,
    );
  }

  @override
  MarketTokenUnlocksSnapshot getTokenUnlocks({
    MarketUnlockSort sortBy = MarketUnlockSort.nearest,
    MarketUnlockImpact? impactFilter,
  }) {
    return _repository.getTokenUnlocks(
      sortBy: sortBy,
      impactFilter: impactFilter,
    );
  }

  @override
  MarketSocialSignalsSnapshot getSocialSignals({
    TradingSignalStatus? statusFilter,
    TradingSignalCategory? categoryFilter,
  }) {
    return _repository.getSocialSignals(
      statusFilter: statusFilter,
      categoryFilter: categoryFilter,
    );
  }

  @override
  MarketCorrelationsSnapshot getMarketCorrelations({
    MarketCorrelationTimeframe timeframe = MarketCorrelationTimeframe.d7,
    CorrelationSortOrder sortOrder = CorrelationSortOrder.high,
  }) {
    return _repository.getMarketCorrelations(
      timeframe: timeframe,
      sortOrder: sortOrder,
    );
  }

  @override
  MarketPairDetailSnapshot getPairDetail(String pairId) {
    return _repository.getPairDetail(pairId);
  }

  @override
  MarketTokenInfoSnapshot getTokenInfo(String pairId) {
    return _repository.getTokenInfo(pairId);
  }
}
