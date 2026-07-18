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

  // GD4 Cụm F7 (REALTIME): 2 method Stream bổ sung — additive, không đổi
  // method Future nào ở trên. Mock phát tick giả lập DETERMINISTIC (không
  // Random/DateTime.now) qua `Stream.periodic`; UI dùng chúng làm lớp
  // "cập-nhật-đè" trên snapshot Future đã có (xem
  // `app/providers/market_controller_providers.dart`).

  /// Ticker giá realtime cho toàn bộ danh sách cặp giao dịch — trả
  /// `Stream<List<MarketPair>>` (KHÔNG phải [MarketListSnapshot] nặng hơn)
  /// vì phần "sống" duy nhất mỗi tick là giá; watchlist/alerts/filters/
  /// chartSeries của màn Danh sách thị trường không đổi theo tick nên không
  /// đáng để build lại toàn snapshot mỗi tick — `getMarketList()` vẫn là
  /// nguồn cho phần tĩnh đó. UI chọn giá của MỘT pair qua `.select()`
  /// (`marketPairLivePriceProvider`) để chỉ hàng có giá đổi mới rebuild.
  Stream<List<MarketPair>> watchTicker();

  /// Sổ lệnh (order book) realtime cho một cặp — trả nguyên
  /// [MarketDepthSnapshot] vì toàn bộ mặt màn Độ sâu thị trường (biểu đồ +
  /// sổ lệnh + cảnh báo cá voi) vẽ lại cùng lúc khi sổ lệnh dịch chuyển,
  /// khác với ticker danh sách (chỉ 1 field/pair đổi).
  Stream<MarketDepthSnapshot> watchDepth(String pairId, {int levels = 25});
}
