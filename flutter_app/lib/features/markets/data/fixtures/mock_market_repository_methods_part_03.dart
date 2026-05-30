part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositoryMethodsPart03 on _MockMarketRepositoryBase {
  @override
  MarketSocialSignalsSnapshot getSocialSignals({
    TradingSignalStatus? statusFilter,
    TradingSignalCategory? categoryFilter,
  }) {
    final signals = [
      for (final signal in _tradingSignals)
        if ((statusFilter == null || signal.status == statusFilter) &&
            (categoryFilter == null || signal.category == categoryFilter))
          signal,
    ];

    final hitSignals = _tradingSignals
        .where((signal) => signal.status == TradingSignalStatus.targetHit)
        .length;
    final stoppedSignals = _tradingSignals
        .where((signal) => signal.status == TradingSignalStatus.stopped)
        .length;
    final realizedCount = hitSignals + stoppedSignals;
    final avgPnl =
        _tradingSignals.fold<double>(0, (sum, signal) => sum + signal.pnlPct) /
        _tradingSignals.length;

    return MarketSocialSignalsSnapshot(
      signals: signals,
      providers: _tradingSignalProviderSummaries(),
      totalSignals: _tradingSignals.length,
      hitSignals: hitSignals,
      stoppedSignals: stoppedSignals,
      overallWinRate: realizedCount == 0
          ? 0
          : (hitSignals / realizedCount) * 100,
      avgPnl: avgPnl,
      tierConfigs: _signalTierConfigs,
      statusConfigs: _signalStatusConfigs,
      statusFilter: statusFilter,
      categoryFilter: categoryFilter,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'signals-btc-breakout-active',
          pairId: 'btcusdt',
          label: 'BTC/USDT active community signal',
        ),
        MarketAlertDraft(
          id: 'signals-link-target-hit',
          pairId: 'linkusdt',
          label: 'LINK/USDT target hit signal',
        ),
      ],
      screenFilters: _marketSocialSignalsFilters,
      chartSeries: {
        'pnlPct': [for (final signal in _tradingSignals) signal.pnlPct],
        'providerWinRate': [
          for (final signal in _tradingSignals) signal.providerWinRate,
        ],
        'socialActions': [
          for (final signal in _tradingSignals)
            (signal.likes + signal.copies).toDouble(),
        ],
        for (final signal in _tradingSignals)
          signal.id: [
            signal.entry,
            signal.currentPrice,
            signal.stopLoss,
            ...signal.targets,
          ],
      },
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      },
    );
  }

  @override
  MarketCorrelationsSnapshot getMarketCorrelations({
    MarketCorrelationTimeframe timeframe = MarketCorrelationTimeframe.d7,
    CorrelationSortOrder sortOrder = CorrelationSortOrder.high,
  }) {
    final pairs = _correlationPairs();
    pairs.sort((a, b) {
      final aValue = _correlationValue(a, timeframe);
      final bValue = _correlationValue(b, timeframe);
      return sortOrder == CorrelationSortOrder.high
          ? bValue.compareTo(aValue)
          : aValue.compareTo(bValue);
    });

    return MarketCorrelationsSnapshot(
      assets: _correlationAssets,
      matrix: _correlationMatrix(timeframe),
      pairs: pairs,
      diversificationScore: _calcDiversificationScore(timeframe),
      timeframe: timeframe,
      sortOrder: sortOrder,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'corr-btc-eth-high',
          pairId: 'btcusdt',
          label: 'BTC/ETH remains highest correlation pair',
        ),
        MarketAlertDraft(
          id: 'corr-xrp-link-low',
          pairId: 'xrpusdt',
          label: 'XRP/LINK is the lowest correlation pair',
        ),
      ],
      screenFilters: _marketCorrelationFilters,
      chartSeries: {
        'matrix': [
          for (final row in _correlationMatrix(timeframe))
            for (final value in row) value,
        ],
        'pairCorrelations': [
          for (final pair in pairs) _correlationValue(pair, timeframe),
        ],
        'diversificationByTimeframe': [
          _calcDiversificationScore(
            MarketCorrelationTimeframe.d7,
          ).score.toDouble(),
          _calcDiversificationScore(
            MarketCorrelationTimeframe.d30,
          ).score.toDouble(),
          _calcDiversificationScore(
            MarketCorrelationTimeframe.d90,
          ).score.toDouble(),
        ],
      },
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      },
    );
  }
}
