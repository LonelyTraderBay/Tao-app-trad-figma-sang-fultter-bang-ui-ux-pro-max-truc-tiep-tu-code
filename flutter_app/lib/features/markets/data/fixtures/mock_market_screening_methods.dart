part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositoryScreeningMethods on _MockMarketRepositoryBase {
  @override
  Future<MarketHeatmapSnapshot> getMarketHeatmap() async {
    await _simulateNetwork();
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
  Future<MarketAlertsSnapshot> getPriceAlerts() async {
    await _simulateNetwork();
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
  Future<MarketScreenerSnapshot> getMarketScreener({
    MarketScreenerQuery? query,
  }) async {
    await _simulateNetwork();
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
  Future<MarketComparisonSnapshot> getMarketComparison() async {
    await _simulateNetwork();
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
}

List<MarketPair> _applyScreenerQuery(
  List<MarketPair> source,
  MarketScreenerQuery query,
) {
  final search = query.searchQuery.trim().toLowerCase();
  var pairs = [
    for (final pair in source)
      if (search.isEmpty ||
          pair.baseAsset.toLowerCase().contains(search) ||
          pair.symbol.toLowerCase().contains(search))
        pair,
  ];

  if (query.categories.isNotEmpty) {
    pairs = [
      for (final pair in pairs)
        if (query.categories.contains(pair.category)) pair,
    ];
  }
  if (query.minPrice != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.price >= query.minPrice!) pair,
    ];
  }
  if (query.maxPrice != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.price <= query.maxPrice!) pair,
    ];
  }
  if (query.minMarketCap != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.marketCap >= query.minMarketCap!) pair,
    ];
  }
  if (query.maxMarketCap != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.marketCap <= query.maxMarketCap!) pair,
    ];
  }
  if (query.minVolume24h != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.volume24h >= query.minVolume24h!) pair,
    ];
  }
  if (query.maxVolume24h != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.volume24h <= query.maxVolume24h!) pair,
    ];
  }
  if (query.minChange24h != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.change24h >= query.minChange24h!) pair,
    ];
  }
  if (query.maxChange24h != null) {
    pairs = [
      for (final pair in pairs)
        if (pair.change24h <= query.maxChange24h!) pair,
    ];
  }

  final direction = query.sortDirection == MarketSortDirection.desc ? -1 : 1;
  pairs.sort((a, b) {
    final aValue = _screenerSortValue(a, query.sortBy);
    final bValue = _screenerSortValue(b, query.sortBy);
    return aValue.compareTo(bValue) * direction;
  });

  return pairs;
}

double _screenerSortValue(MarketPair pair, MarketScreenerSort sortBy) {
  return switch (sortBy) {
    MarketScreenerSort.marketCap => pair.marketCap,
    MarketScreenerSort.volume => pair.volume24h,
    MarketScreenerSort.change24h => pair.change24h,
    MarketScreenerSort.price => pair.price,
  };
}

const List<HeatmapCoin> _heatmapCoins = [
  HeatmapCoin(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    price: 67543.21,
    change24h: 2.34,
    change7d: 5.12,
    marketCap: 1324567890000,
    volume24h: 23456789000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    price: 3521.45,
    change24h: -1.23,
    change7d: 3.45,
    marketCap: 423456789000,
    volume24h: 8765432000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'bnb',
    symbol: 'BNB',
    name: 'BNB',
    price: 412.87,
    change24h: 3.61,
    change7d: 7.82,
    marketCap: 63456789000,
    volume24h: 1234567000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    price: 178.32,
    change24h: 8.07,
    change7d: 12.34,
    marketCap: 78456789000,
    volume24h: 3456789000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'xrp',
    symbol: 'XRP',
    name: 'Ripple',
    price: 0.6234,
    change24h: -2.59,
    change7d: -4.21,
    marketCap: 34567890000,
    volume24h: 1876543000,
    category: 'Payment',
  ),
  HeatmapCoin(
    id: 'ada',
    symbol: 'ADA',
    name: 'Cardano',
    price: 0.4521,
    change24h: 3.22,
    change7d: 6.78,
    marketCap: 16234567000,
    volume24h: 654321000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'avax',
    symbol: 'AVAX',
    name: 'Avalanche',
    price: 38.54,
    change24h: 4.73,
    change7d: 9.15,
    marketCap: 15678901000,
    volume24h: 567890000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'dot',
    symbol: 'DOT',
    name: 'Polkadot',
    price: 7.832,
    change24h: -3.55,
    change7d: -1.23,
    marketCap: 10345678000,
    volume24h: 432109000,
    category: 'DeFi',
  ),
  HeatmapCoin(
    id: 'matic',
    symbol: 'MATIC',
    name: 'Polygon',
    price: 0.8976,
    change24h: 5.60,
    change7d: 11.20,
    marketCap: 8912345000,
    volume24h: 789012000,
    category: 'Layer 2',
  ),
  HeatmapCoin(
    id: 'link',
    symbol: 'LINK',
    name: 'Chainlink',
    price: 14.23,
    change24h: -5.76,
    change7d: -3.45,
    marketCap: 8123456000,
    volume24h: 345678000,
    category: 'DeFi',
  ),
  HeatmapCoin(
    id: 'uni',
    symbol: 'UNI',
    name: 'Uniswap',
    price: 7.45,
    change24h: 2.15,
    change7d: 4.56,
    marketCap: 5612345000,
    volume24h: 234567000,
    category: 'DeFi',
  ),
  HeatmapCoin(
    id: 'atom',
    symbol: 'ATOM',
    name: 'Cosmos',
    price: 9.12,
    change24h: -1.87,
    change7d: 2.34,
    marketCap: 3456789000,
    volume24h: 189012000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'near',
    symbol: 'NEAR',
    name: 'NEAR Protocol',
    price: 5.67,
    change24h: 6.89,
    change7d: 14.56,
    marketCap: 5890123000,
    volume24h: 456789000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'arb',
    symbol: 'ARB',
    name: 'Arbitrum',
    price: 1.23,
    change24h: 4.32,
    change7d: 8.90,
    marketCap: 4321098000,
    volume24h: 567890000,
    category: 'Layer 2',
  ),
  HeatmapCoin(
    id: 'op',
    symbol: 'OP',
    name: 'Optimism',
    price: 3.45,
    change24h: -0.89,
    change7d: 5.67,
    marketCap: 3789012000,
    volume24h: 321098000,
    category: 'Layer 2',
  ),
  HeatmapCoin(
    id: 'apt',
    symbol: 'APT',
    name: 'Aptos',
    price: 8.90,
    change24h: 3.45,
    change7d: 7.89,
    marketCap: 3210987000,
    volume24h: 234567000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'inj',
    symbol: 'INJ',
    name: 'Injective',
    price: 28.45,
    change24h: 7.23,
    change7d: 15.67,
    marketCap: 2876543000,
    volume24h: 345678000,
    category: 'DeFi',
  ),
  HeatmapCoin(
    id: 'sei',
    symbol: 'SEI',
    name: 'Sei',
    price: 0.45,
    change24h: -4.56,
    change7d: -2.34,
    marketCap: 1234567000,
    volume24h: 189012000,
    category: 'Layer 1',
  ),
  HeatmapCoin(
    id: 'stx',
    symbol: 'STX',
    name: 'Stacks',
    price: 2.34,
    change24h: 1.23,
    change7d: 3.45,
    marketCap: 2345678000,
    volume24h: 123456000,
    category: 'Layer 2',
  ),
  HeatmapCoin(
    id: 'wld',
    symbol: 'WLD',
    name: 'Worldcoin',
    price: 3.12,
    change24h: -6.78,
    change7d: -8.90,
    marketCap: 1890123000,
    volume24h: 345678000,
    category: 'AI',
  ),
];

const MarketScreenFilters _marketHeatmapFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Layer 1', 'Layer 2', 'DeFi', 'Payment', 'AI'],
  defaultCategory: 'Tất cả',
  defaultSort: 'market_cap',
  sortOptions: [
    MarketSortOption(id: 'market_cap', label: 'Market Cap'),
    MarketSortOption(id: 'change_24h', label: '24h'),
    MarketSortOption(id: 'change_7d', label: '7d'),
  ],
);

const List<MarketPriceAlert> _priceAlerts = [
  MarketPriceAlert(
    id: 'alert001',
    pairId: 'ethusdt',
    symbol: 'ETH/USDT',
    condition: MarketAlertCondition.above,
    targetPrice: 3600,
    currentPrice: 3521.45,
    isActive: true,
    createdAt: '2024-02-20 10:00:00',
  ),
  MarketPriceAlert(
    id: 'alert002',
    pairId: 'btcusdt',
    symbol: 'BTC/USDT',
    condition: MarketAlertCondition.below,
    targetPrice: 65000,
    currentPrice: 67543.21,
    isActive: true,
    createdAt: '2024-02-19 14:30:00',
  ),
  MarketPriceAlert(
    id: 'alert003',
    pairId: 'solusdt',
    symbol: 'SOL/USDT',
    condition: MarketAlertCondition.above,
    targetPrice: 180,
    currentPrice: 178.32,
    isActive: true,
    createdAt: '2024-02-18 09:15:00',
  ),
  MarketPriceAlert(
    id: 'alert004',
    pairId: 'bnbusdt',
    symbol: 'BNB/USDT',
    condition: MarketAlertCondition.above,
    targetPrice: 420,
    currentPrice: 412.87,
    isActive: false,
    createdAt: '2024-02-15 16:20:00',
    triggeredAt: '2024-02-17 11:30:00',
  ),
];

const MarketScreenFilters _marketAlertsFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Đang hoạt động', 'Đã kích hoạt'],
  defaultCategory: 'Tất cả',
  defaultSort: 'status',
  sortOptions: [
    MarketSortOption(id: 'status', label: 'Trạng thái'),
    MarketSortOption(id: 'symbol', label: 'Cặp giao dịch'),
    MarketSortOption(id: 'target', label: 'Mục tiêu'),
  ],
);

const MarketScreenFilters _marketScreenerFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Layer 1', 'Layer 2', 'DeFi', 'Meme', 'AI'],
  defaultCategory: 'Tất cả',
  defaultSort: 'marketCap',
  sortOptions: [
    MarketSortOption(id: 'marketCap', label: 'Vốn hóa'),
    MarketSortOption(id: 'volume', label: 'Khối lượng'),
    MarketSortOption(id: 'change24h', label: 'Thay đổi 24h'),
    MarketSortOption(id: 'price', label: 'Giá'),
  ],
);

const List<MarketScreenerPreset> _screenerPresets = [
  MarketScreenerPreset(
    id: 'large-cap',
    name: 'Large Cap',
    description: 'Dòng tiền vốn hóa lớn, ổn định',
    icon: 'accountBalance',
    query: MarketScreenerQuery(
      minMarketCap: 10000000000,
      sortBy: MarketScreenerSort.marketCap,
      sortDirection: MarketSortDirection.desc,
    ),
  ),
  MarketScreenerPreset(
    id: 'high-volume',
    name: 'Volume Cao',
    description: 'Khối lượng giao dịch lớn trong 24h',
    icon: 'barChart',
    query: MarketScreenerQuery(
      minVolume24h: 1000000000,
      sortBy: MarketScreenerSort.volume,
      sortDirection: MarketSortDirection.desc,
    ),
  ),
  MarketScreenerPreset(
    id: 'gainers',
    name: 'Tăng Mạnh',
    description: 'Dòng tiền tăng giá mạnh nhất 24h',
    icon: 'rocketLaunch',
    query: MarketScreenerQuery(
      minChange24h: 3,
      sortBy: MarketScreenerSort.change24h,
      sortDirection: MarketSortDirection.desc,
    ),
  ),
  MarketScreenerPreset(
    id: 'bargains',
    name: 'Giá Thấp',
    description: 'Dòng tiền dưới 1 USD với volume tốt',
    icon: 'diamond',
    query: MarketScreenerQuery(
      maxPrice: 1,
      minVolume24h: 100000000,
      sortBy: MarketScreenerSort.volume,
      sortDirection: MarketSortDirection.desc,
    ),
  ),
  MarketScreenerPreset(
    id: 'defi-gems',
    name: 'DeFi Gems',
    description: 'Token DeFi đang tăng',
    icon: 'accountBalanceWallet',
    query: MarketScreenerQuery(
      categories: ['DeFi'],
      minChange24h: 0,
      sortBy: MarketScreenerSort.change24h,
      sortDirection: MarketSortDirection.desc,
    ),
  ),
  MarketScreenerPreset(
    id: 'l2-watch',
    name: 'L2 Watch',
    description: 'Token Layer 2 tiềm năng',
    icon: 'link',
    query: MarketScreenerQuery(
      categories: ['Layer 2'],
      sortBy: MarketScreenerSort.marketCap,
      sortDirection: MarketSortDirection.desc,
    ),
  ),
];

const List<MarketComparisonMetric> _comparisonMetrics = [
  MarketComparisonMetric(
    key: 'price',
    label: 'Giá hiện tại',
    format: MarketComparisonMetricFormat.price,
  ),
  MarketComparisonMetric(
    key: 'mcap',
    label: 'Vốn hóa',
    format: MarketComparisonMetricFormat.compact,
    highlight: MarketComparisonHighlight.high,
  ),
  MarketComparisonMetric(
    key: 'vol',
    label: 'Khối lượng 24h',
    format: MarketComparisonMetricFormat.compact,
    highlight: MarketComparisonHighlight.high,
  ),
  MarketComparisonMetric(
    key: 'chg',
    label: 'Thay đổi 24h',
    format: MarketComparisonMetricFormat.percent,
    highlight: MarketComparisonHighlight.high,
  ),
  MarketComparisonMetric(
    key: 'high',
    label: 'Cao nhất 24h',
    format: MarketComparisonMetricFormat.price,
  ),
  MarketComparisonMetric(
    key: 'low',
    label: 'Thấp nhất 24h',
    format: MarketComparisonMetricFormat.price,
  ),
  MarketComparisonMetric(
    key: 'range',
    label: 'Biên độ 24h',
    format: MarketComparisonMetricFormat.percent,
  ),
  MarketComparisonMetric(
    key: 'volmcap',
    label: 'Vol/MCap',
    format: MarketComparisonMetricFormat.percent,
  ),
];

const MarketScreenFilters _marketCompareFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Layer 1', 'Layer 2', 'DeFi'],
  defaultCategory: 'Tất cả',
  defaultSort: 'selected',
  sortOptions: [
    MarketSortOption(id: 'selected', label: 'Đang chọn'),
    MarketSortOption(id: 'popular', label: 'Phổ biến'),
    MarketSortOption(id: 'marketCap', label: 'Vốn hóa'),
  ],
);
