import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

export 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
export 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

final class MarketController implements MarketRepository {
  const MarketController(this._repository);

  final MarketRepository _repository;

  @override
  Future<MarketListSnapshot> getMarketList() => _repository.getMarketList();

  @override
  Future<MarketOverviewSnapshot> getMarketOverview() {
    return _repository.getMarketOverview();
  }

  @override
  Future<MarketMoversSnapshot> getMarketMovers() =>
      _repository.getMarketMovers();

  @override
  Future<MarketSectorsSnapshot> getMarketSectors() =>
      _repository.getMarketSectors();

  @override
  Future<MarketWatchlistSnapshot> getMarketWatchlist() {
    return _repository.getMarketWatchlist();
  }

  @override
  Future<MarketHeatmapSnapshot> getMarketHeatmap() =>
      _repository.getMarketHeatmap();

  @override
  Future<MarketAlertsSnapshot> getPriceAlerts() => _repository.getPriceAlerts();

  @override
  Future<MarketScreenerSnapshot> getMarketScreener({
    MarketScreenerQuery? query,
  }) {
    return _repository.getMarketScreener(query: query);
  }

  @override
  Future<MarketComparisonSnapshot> getMarketComparison() {
    return _repository.getMarketComparison();
  }

  @override
  Future<MarketCalendarSnapshot> getMarketCalendar({
    MarketCalendarQuery? query,
  }) {
    return _repository.getMarketCalendar(query: query);
  }

  @override
  Future<MarketDerivativesSnapshot> getMarketDerivatives({
    MarketDerivativesSort sortBy = MarketDerivativesSort.openInterest,
  }) {
    return _repository.getMarketDerivatives(sortBy: sortBy);
  }

  @override
  Future<MarketDepthSnapshot> getMarketDepth({
    String pairId = 'btcusdt',
    int levels = 25,
  }) {
    return _repository.getMarketDepth(pairId: pairId, levels: levels);
  }

  @override
  Future<MarketSocialSentimentSnapshot> getSocialSentiment({
    MarketSentimentSort sortBy = MarketSentimentSort.sentiment,
  }) {
    return _repository.getSocialSentiment(sortBy: sortBy);
  }

  @override
  Future<MarketPortfolioSnapshot> getPortfolioTracker({
    MarketPortfolioSort sortBy = MarketPortfolioSort.value,
  }) {
    return _repository.getPortfolioTracker(sortBy: sortBy);
  }

  @override
  Future<MarketNewsSnapshot> getMarketNews({
    String category = 'all',
    MarketNewsSentiment? sentiment,
  }) {
    return _repository.getMarketNews(category: category, sentiment: sentiment);
  }

  @override
  Future<MarketAdvancedChartsSnapshot> getAdvancedCharts({
    String indicatorCategory = 'all',
    String drawingCategory = 'all',
  }) {
    return _repository.getAdvancedCharts(
      indicatorCategory: indicatorCategory,
      drawingCategory: drawingCategory,
    );
  }

  @override
  Future<MarketTokenUnlocksSnapshot> getTokenUnlocks({
    MarketUnlockSort sortBy = MarketUnlockSort.nearest,
    MarketUnlockImpact? impactFilter,
  }) {
    return _repository.getTokenUnlocks(
      sortBy: sortBy,
      impactFilter: impactFilter,
    );
  }

  @override
  Future<MarketSocialSignalsSnapshot> getSocialSignals({
    TradingSignalStatus? statusFilter,
    TradingSignalCategory? categoryFilter,
  }) {
    return _repository.getSocialSignals(
      statusFilter: statusFilter,
      categoryFilter: categoryFilter,
    );
  }

  @override
  Future<MarketCorrelationsSnapshot> getMarketCorrelations({
    MarketCorrelationTimeframe timeframe = MarketCorrelationTimeframe.d7,
    CorrelationSortOrder sortOrder = CorrelationSortOrder.high,
  }) {
    return _repository.getMarketCorrelations(
      timeframe: timeframe,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<MarketPairDetailSnapshot> getPairDetail(String pairId) {
    return _repository.getPairDetail(pairId);
  }

  @override
  Future<MarketTokenInfoSnapshot> getTokenInfo(String pairId) {
    return _repository.getTokenInfo(pairId);
  }
}
