part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryMethodsPart01 on _MockTradeRepositoryBase {
  @override
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'}) {
    final pair = _pairs.firstWhere(
      (pair) => pair.id == pairId,
      orElse: () => _pairs.first,
    );
    return TradeScreenSnapshot(
      pair: pair,
      pairs: _pairs,
      orderBook: _orderBook,
      trades: _trades,
      orders: _orders,
      positions: _positions,
      copyProviders: const ['AlphaQuant', 'Delta Scalper'],
      botStrategies: const ['Grid BTC', 'DCA ETH', 'Momentum SOL'],
      balances: const TradeBalances(usdtAvailable: 10200, baseAvailable: 0.84),
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeOrdersHistorySnapshot getOrdersHistory() {
    return TradeOrdersHistorySnapshot(
      trade: getTrade(),
      openOrders: _historyOpenOrders,
      historyOrders: _historyOrders,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeOrderReceiptSnapshot getOrderReceipt() {
    return TradeOrderReceiptSnapshot(
      trade: getTrade(),
      receipt: const TradeOrderReceiptDetails(
        orderId: 'ORD-98EH1ZT2',
        symbol: 'BTC/USDT',
        baseAsset: 'BTC',
        side: TradeOrderSide.buy,
        orderType: 'Giới hạn',
        price: 67543.21,
        amount: .015,
        total: 1013.15,
        fee: .96,
        feeRate: '0.095% (VIP 1, -5%)',
        timestamp: '23:29:21 18/5/2026',
        status: TradeReceiptStatus.submitted,
        tpPrice: 72000,
        slPrice: 65000,
        estimatedFill: '< 2 phút',
      ),
      lastUpdatedLabel: 'success',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeSettingsSnapshot getTradeSettings() {
    return TradeSettingsSnapshot(
      trade: getTrade(),
      settings: _defaultTradeSettings,
      lastUpdatedLabel: 'success',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePositionsSnapshot getTradePositions() {
    return TradePositionsSnapshot(
      trade: getTrade(),
      positions: _dashboardPositions,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExportSnapshot getTradeExport() {
    return TradeExportSnapshot(
      trade: getTrade(),
      stats: const TradeExportStats(
        totalTrades: 847,
        totalVolume: 2458300,
        totalFees: 2340.56,
        netPnl: 12456.78,
      ),
      formats: _tradeExportFormats,
      periods: _tradeExportPeriods,
      includes: _tradeExportIncludes,
      lastUpdatedLabel: 'success',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'}) {
    final trade = getTrade(pairId: pairId);
    return TradeAdvancedChartSnapshot(
      trade: trade,
      pair: trade.pair,
      candles: _advancedChartCandles,
      indicators: _advancedChartIndicators,
      timeframes: const ['1m', '5m', '15m', '1h', '4h', '1D', '1W'],
      chartTypes: const ['candle', 'line', 'area'],
      ohlcv: const TradeOhlcv(
        open: 64312.26,
        high: 64475.28,
        low: 64185.74,
        close: 64268.03,
        volumeLabel: '8.0K',
      ),
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeConvertSnapshot getConvert() {
    return TradeConvertSnapshot(
      trade: getTrade(),
      assets: _convertAssets,
      favoritePairs: _convertFavoritePairs,
      history: _convertHistory,
      slippageOptions: const [.5, 1, 2],
      fromAsset: _convertAssetBySymbol('USDT'),
      toAsset: _convertAssetBySymbol('BTC'),
      rateLabel: '1 USDT = 0.000015 BTC',
      countdownLabel: '14s',
      minUsd: 10,
      maxUsd: 500000,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'}) {
    final trade = getTrade(pairId: pairId);
    return TradeFuturesSnapshot(
      trade: trade,
      pair: trade.pair,
      positions: _futuresPositions,
      leverages: const [1, 2, 3, 5, 10, 20, 50, 75, 100],
      markPrice: trade.pair.price,
      indexPrice: trade.pair.price * .9998,
      fundingRate: .01,
      accountBalance: 5000,
      usedMargin: 544,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeFuturesLeverageSnapshot getFuturesLeverage({String pairId = 'btcusdt'}) {
    return TradeFuturesLeverageSnapshot(
      futures: getFutures(pairId: pairId),
      currentLeverage: 10,
      presets: const [1, 2, 3, 5, 10, 20, 25, 50, 75, 100],
      sliderStops: const [1, 10, 25, 50, 75, 100],
      exampleMargin: 100,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeBotsSnapshot getTradingBots() {
    return TradeBotsSnapshot(
      trade: getTrade(),
      strategies: _botStrategies,
      activeBots: _activeBots,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeRiskManagementSnapshot getRiskManagement() {
    return TradeRiskManagementSnapshot(
      trade: getTrade(),
      features: _riskFeatures,
      positions: _riskPositions,
      statusItems: _riskStatusItems,
      accountBalance: 50000,
      currentPrice: 69000,
      availableBalance: 50000,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExecutionQualitySnapshot getExecutionQuality() {
    return TradeExecutionQualitySnapshot(
      trade: getTrade(),
      features: _executionFeatures,
      report: _executionReport,
      openOrder: _executionOpenOrder,
      slippageSettings: _defaultSlippageSettings,
      statusItems: _executionStatusItems,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeAdvancedToolsSnapshot getAdvancedTools() {
    return TradeAdvancedToolsSnapshot(
      trade: getTrade(),
      features: _advancedToolFeatures,
      ladderOrders: _ladderOrders,
      bulkOrders: _bulkOrders,
      shortcuts: _shortcuts,
      statusItems: _advancedToolStatusItems,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyTradingSnapshot getCopyTrading() {
    return TradeCopyTradingSnapshot(
      trade: getTrade(),
      traders: _copyTraders,
      sortOptions: _copyTradingSortOptions,
      totalCopiers: _copyTraders.fold<int>(
        0,
        (total, trader) => total + trader.copiers,
      ),
      totalAum: _copyTraders.fold<double>(
        0,
        (total, trader) => total + trader.aum,
      ),
      aumTrendPct: 12.3,
      riskWarningTitle: 'Cảnh báo rủi ro',
      riskWarningText:
          'Copy Trading có rủi ro cao. Hiệu suất quá khứ không đảm bảo lợi nhuận tương lai. Bạn có thể mất toàn bộ vốn đầu tư.',
      disclaimer:
          'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Tất cả chỉ số mang tính tham khảo. Copy Trading có rủi ro cao, chỉ đầu tư với số tiền bạn có thể chấp nhận mất.',
      lastUpdatedLabel: '2 mins ago',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyTradingV2Snapshot getCopyTradingV2() {
    return TradeCopyTradingV2Snapshot(
      copyTrading: getCopyTrading(),
      heroVariants: const ['clean', 'bold', 'glass'],
      defaultHeroVariant: 'clean',
      lastUpdatedLabel: '2 mins ago',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }
}
