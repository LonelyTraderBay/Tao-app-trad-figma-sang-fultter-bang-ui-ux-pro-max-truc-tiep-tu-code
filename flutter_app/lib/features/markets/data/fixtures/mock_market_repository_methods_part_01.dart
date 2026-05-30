part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositoryMethodsPart01 on _MockMarketRepositoryBase {
  @override
  MarketPairDetailSnapshot getPairDetail(String pairId) {
    final pair = _findMarketPair(pairId);
    return MarketPairDetailSnapshot(
      pair: pair,
      marketPairs: _marketPairs,
      watchlist: {
        for (final item in _marketPairs)
          if (item.isFavorite) item.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vuot 68,000',
        ),
        MarketAlertDraft(
          id: 'eth-dip',
          pairId: 'ethusdt',
          label: 'ETH giam duoi 3,500',
        ),
      ],
      screenFilters: const MarketScreenFilters(
        categories: ['Tat ca', 'Layer 1', 'Layer 2', 'DeFi', 'Meme', 'AI'],
        defaultCategory: 'Tat ca',
        defaultSort: 'default',
        sortOptions: [
          MarketSortOption(id: 'default', label: 'Mac dinh'),
          MarketSortOption(id: 'price_desc', label: 'Gia cao -> thap'),
          MarketSortOption(id: 'price_asc', label: 'Gia thap -> cao'),
          MarketSortOption(id: 'change_desc', label: 'Tang nhieu nhat'),
          MarketSortOption(id: 'change_asc', label: 'Giam nhieu nhat'),
          MarketSortOption(id: 'volume_desc', label: 'Volume lon nhat'),
        ],
      ),
      chartSeries: {
        for (final item in _marketPairs) item.id: item.sparklineData,
      },
      depth: _generateDepthData(pair.price, 25),
      recentTrades: _marketRecentTrades,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
      },
    );
  }

  @override
  MarketTokenInfoSnapshot getTokenInfo(String pairId) {
    final pair = _findMarketPair(pairId);
    final fundamentals = _tokenFundamentals[pair.id] ?? _btcFundamentals;
    return MarketTokenInfoSnapshot(
      pair: pair,
      fundamentals: fundamentals,
      marketPairs: _marketPairs,
      watchlist: {
        for (final item in _marketPairs)
          if (item.isFavorite) item.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vuot 68,000',
        ),
        MarketAlertDraft(
          id: 'eth-dip',
          pairId: 'ethusdt',
          label: 'ETH giam duoi 3,500',
        ),
      ],
      screenFilters: const MarketScreenFilters(
        categories: ['Tong quan', 'On-chain', 'Du an'],
        defaultCategory: 'Tong quan',
        defaultSort: 'token-info',
        sortOptions: [
          MarketSortOption(id: 'overview', label: 'Tong quan'),
          MarketSortOption(id: 'onchain', label: 'On-chain'),
          MarketSortOption(id: 'project', label: 'Du an'),
        ],
      ),
      chartSeries: {
        for (final item in _marketPairs) item.id: item.sparklineData,
      },
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
      },
    );
  }

  @override
  MarketListSnapshot getMarketList() {
    return MarketListSnapshot(
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vượt 68,000',
        ),
        MarketAlertDraft(
          id: 'eth-dip',
          pairId: 'ethusdt',
          label: 'ETH giảm dưới 3,500',
        ),
      ],
      screenFilters: const MarketScreenFilters(
        categories: ['Tất cả', 'Layer 1', 'Layer 2', 'DeFi', 'Meme', 'AI'],
        defaultCategory: 'Tất cả',
        defaultSort: 'default',
        sortOptions: [
          MarketSortOption(id: 'default', label: 'Mặc định'),
          MarketSortOption(id: 'price_desc', label: 'Giá cao -> thấp'),
          MarketSortOption(id: 'price_asc', label: 'Giá thấp -> cao'),
          MarketSortOption(id: 'change_desc', label: 'Tăng nhiều nhất'),
          MarketSortOption(id: 'change_asc', label: 'Giảm nhiều nhất'),
          MarketSortOption(id: 'volume_desc', label: 'Volume lớn nhất'),
        ],
      ),
      chartSeries: {
        for (final pair in _marketPairs) pair.id: pair.sparklineData,
      },
      lastUpdatedLabel: 'vừa xong',
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
  MarketOverviewSnapshot getMarketOverview() {
    return MarketOverviewSnapshot(
      globalStats: _globalMarketStats,
      marketBreadth: _marketBreadth,
      fearGreedHistory: _fearGreedHistory,
      sectors: _marketSectors,
      movers: _marketMovers,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vượt 68,000',
        ),
        MarketAlertDraft(
          id: 'eth-dip',
          pairId: 'ethusdt',
          label: 'ETH giảm dưới 3,500',
        ),
      ],
      screenFilters: const MarketScreenFilters(
        categories: ['Tất cả', 'Layer 1', 'Layer 2', 'DeFi', 'Meme', 'AI'],
        defaultCategory: 'Tất cả',
        defaultSort: 'default',
        sortOptions: [
          MarketSortOption(id: 'default', label: 'Mặc định'),
          MarketSortOption(id: 'change_desc', label: 'Tăng nhiều nhất'),
          MarketSortOption(id: 'change_asc', label: 'Giảm nhiều nhất'),
          MarketSortOption(id: 'volume_desc', label: 'Volume lớn nhất'),
        ],
      ),
      chartSeries: {
        'fearGreed7d': [
          for (final point in _fearGreedHistory) point.value.toDouble(),
        ],
        for (final mover in _marketMovers) mover.id: mover.sparkline,
      },
      lastUpdatedLabel: 'vừa xong',
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
  MarketMoversSnapshot getMarketMovers() {
    return MarketMoversSnapshot(
      movers: _marketMovers,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vượt 68,000',
        ),
        MarketAlertDraft(
          id: 'sol-volume',
          pairId: 'solusdt',
          label: 'SOL volume tăng bất thường',
        ),
      ],
      screenFilters: _marketMoverFilters,
      chartSeries: {
        for (final mover in _marketMovers) mover.id: mover.sparkline,
      },
      tabs: const [
        'Tăng mạnh',
        'Giảm mạnh',
        'Hoạt động',
        'KL bất thường',
        'Mới niêm yết',
      ],
      timeframes: const ['1h', '24h', '7d'],
      lastUpdatedLabel: 'mỗi 30 giây',
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
  MarketSectorsSnapshot getMarketSectors() {
    return MarketSectorsSnapshot(
      sectors: _marketSectors,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'layer1-dominance',
          pairId: 'btcusdt',
          label: 'Layer 1 vượt 75% dominance',
        ),
        MarketAlertDraft(
          id: 'ai-sector-momentum',
          pairId: 'wldusdt',
          label: 'AI dẫn đầu hiệu suất 24h',
        ),
      ],
      screenFilters: _marketSectorFilters,
      chartSeries: {
        'sectorDominance': [
          for (final sector in _marketSectors) sector.dominance,
        ],
        for (final sector in _marketSectors)
          sector.id: [sector.change24h, sector.change7d, sector.change30d],
      },
      timeframes: const ['24h', '7d', '30d'],
      lastUpdatedLabel: 'Dữ liệu cập nhật liên tục',
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
  MarketWatchlistSnapshot getMarketWatchlist() {
    return MarketWatchlistSnapshot(
      entries: _watchlistEntries,
      marketPairs: _marketPairs,
      watchlist: {for (final entry in _watchlistEntries) entry.pairId},
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vượt 68,000',
        ),
        MarketAlertDraft(
          id: 'eth-note',
          pairId: 'ethusdt',
          label: 'ETH có ghi chú chờ mốc 3800',
        ),
      ],
      screenFilters: _marketWatchlistFilters,
      chartSeries: {
        for (final pair in _marketPairs) pair.id: pair.sparklineData,
      },
      lastUpdatedLabel: 'vừa xong',
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
  MarketHeatmapSnapshot getMarketHeatmap() {
    return MarketHeatmapSnapshot(
      coins: _heatmapCoins,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'heatmap-sol-breakout',
          pairId: 'solusdt',
          label: 'SOL leads the 24h heatmap',
        ),
        MarketAlertDraft(
          id: 'heatmap-wld-risk',
          pairId: 'wldusdt',
          label: 'AI has a sharp downside mover',
        ),
      ],
      screenFilters: _marketHeatmapFilters,
      chartSeries: {
        for (final coin in _heatmapCoins)
          coin.id: [coin.change24h, coin.change7d, coin.volume24h],
      },
      metrics: const ['24h', '7d'],
      lastUpdatedLabel: 'realtime-refresh',
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
  MarketAlertsSnapshot getPriceAlerts() {
    return MarketAlertsSnapshot(
      priceAlerts: _priceAlerts,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'price-alert-eth',
          pairId: 'ethusdt',
          label: 'ETH above 3,600',
        ),
        MarketAlertDraft(
          id: 'price-alert-btc',
          pairId: 'btcusdt',
          label: 'BTC below 65,000',
        ),
      ],
      screenFilters: _marketAlertsFilters,
      chartSeries: {
        for (final alert in _priceAlerts)
          alert.id: [alert.currentPrice, alert.targetPrice],
      },
      lastUpdatedLabel: 'realtime-refresh',
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
  MarketScreenerSnapshot getMarketScreener({MarketScreenerQuery? query}) {
    final appliedQuery = query ?? MarketScreenerQuery.defaults;
    final pairs = _applyScreenerQuery(_marketPairs, appliedQuery);

    return MarketScreenerSnapshot(
      marketPairs: pairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'screener-large-cap',
          pairId: 'btcusdt',
          label: 'Large-cap screener result',
        ),
        MarketAlertDraft(
          id: 'screener-high-volume',
          pairId: 'solusdt',
          label: 'High-volume screener result',
        ),
      ],
      screenFilters: _marketScreenerFilters,
      chartSeries: {
        for (final pair in _marketPairs) pair.id: pair.sparklineData,
      },
      presets: _screenerPresets,
      appliedQuery: appliedQuery,
      lastUpdatedLabel: 'realtime-refresh',
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
  MarketComparisonSnapshot getMarketComparison() {
    return MarketComparisonSnapshot(
      marketPairs: _marketPairs,
      selectedPairIds: const ['btcusdt', 'ethusdt'],
      popularPairIds: const ['btcusdt', 'ethusdt', 'solusdt', 'bnbusdt'],
      metrics: _comparisonMetrics,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'compare-btc-eth',
          pairId: 'btcusdt',
          label: 'BTC/ETH comparison baseline',
        ),
        MarketAlertDraft(
          id: 'compare-add-sol',
          pairId: 'solusdt',
          label: 'SOL popular comparison candidate',
        ),
      ],
      screenFilters: _marketCompareFilters,
      chartSeries: {
        for (final pair in _marketPairs) pair.id: pair.sparklineData,
      },
      lastUpdatedLabel: 'realtime-refresh',
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
  MarketCalendarSnapshot getMarketCalendar({MarketCalendarQuery? query}) {
    final appliedQuery = query ?? MarketCalendarQuery.defaults;
    final events = _applyCalendarQuery(_marketEvents, appliedQuery);

    return MarketCalendarSnapshot(
      events: events,
      stats: _marketCalendarStats,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'calendar-high-impact',
          pairId: 'ethusdt',
          label: 'Sự kiện tác động cao trong tuần',
        ),
        MarketAlertDraft(
          id: 'calendar-token-unlock',
          pairId: 'arbusdt',
          label: 'Token unlock cần theo dõi',
        ),
      ],
      screenFilters: _marketCalendarFilters,
      chartSeries: {
        'impact': [
          _marketCalendarStats.upcoming.toDouble(),
          _marketCalendarStats.highImpact.toDouble(),
          _marketCalendarStats.thisWeek.toDouble(),
        ],
        for (final event in _marketEvents)
          event.id: [
            _daysUntil(event.dateIso).toDouble(),
            event.impact.index.toDouble(),
          ],
      },
      appliedQuery: appliedQuery,
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
