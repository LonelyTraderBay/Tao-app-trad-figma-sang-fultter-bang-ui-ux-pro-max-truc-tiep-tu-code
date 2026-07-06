part of '../repositories/mock_market_repository.dart';

List<CorrelationPairDraft> _correlationPairs() {
  final pairs = <CorrelationPairDraft>[];
  for (var i = 0; i < _correlationAssets.length; i += 1) {
    for (var j = i + 1; j < _correlationAssets.length; j += 1) {
      pairs.add(
        CorrelationPairDraft(
          assetA: _correlationAssets[i].symbol,
          assetB: _correlationAssets[j].symbol,
          correlation7d: _corrMatrix7d[i][j],
          correlation30d: _corrMatrix30d[i][j],
          correlation90d: _corrMatrix90d[i][j],
        ),
      );
    }
  }
  return pairs;
}

List<List<double>> _correlationMatrix(MarketCorrelationTimeframe timeframe) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => _corrMatrix7d,
    MarketCorrelationTimeframe.d30 => _corrMatrix30d,
    MarketCorrelationTimeframe.d90 => _corrMatrix90d,
  };
}

double _correlationValue(
  CorrelationPairDraft pair,
  MarketCorrelationTimeframe timeframe,
) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => pair.correlation7d,
    MarketCorrelationTimeframe.d30 => pair.correlation30d,
    MarketCorrelationTimeframe.d90 => pair.correlation90d,
  };
}

DiversificationScoreDraft _calcDiversificationScore(
  MarketCorrelationTimeframe timeframe,
) {
  final pairs = _correlationPairs();
  final avg =
      pairs.fold<double>(
        0,
        (sum, pair) => sum + _correlationValue(pair, timeframe),
      ) /
      pairs.length;
  pairs.sort(
    (a, b) => _correlationValue(
      a,
      timeframe,
    ).compareTo(_correlationValue(b, timeframe)),
  );
  final lowest = pairs.first;
  final highest = pairs.last;
  final score = ((1 - avg) * 100).round();
  final label = score < 20
      ? 'Rất thấp'
      : score < 35
      ? 'Thấp'
      : score < 50
      ? 'Trung bình'
      : score < 65
      ? 'Tốt'
      : 'Rất tốt';
  final recommendation = avg > 0.8
      ? 'Danh mục có tương quan cao. Xem xét thêm tài sản ít tương quan để giảm rủi ro.'
      : avg > 0.6
      ? 'Tương quan trung bình. Cân nhắc thêm stablecoin hoặc tài sản ngoài crypto.'
      : 'Đa dạng hóa tốt. Tương quan thấp giúp giảm rủi ro tổng thể.';

  return DiversificationScoreDraft(
    score: score,
    label: label,
    avgCorrelation: avg,
    lowestCorr: CorrelationExtremum(
      pair: '${lowest.assetA}/${lowest.assetB}',
      value: _correlationValue(lowest, timeframe),
    ),
    highestCorr: CorrelationExtremum(
      pair: '${highest.assetA}/${highest.assetB}',
      value: _correlationValue(highest, timeframe),
    ),
    recommendation: recommendation,
  );
}

List<SignalProviderSummary> _tradingSignalProviderSummaries() {
  final summaries = <String, _MutableSignalProviderSummary>{};

  for (final signal in _tradingSignals) {
    final existing = summaries[signal.providerName];
    if (existing == null) {
      summaries[signal.providerName] = _MutableSignalProviderSummary(
        name: signal.providerName,
        avatar: signal.providerAvatar,
        tier: signal.providerTier,
        winRate: signal.providerWinRate,
        followers: signal.providerFollowers,
        totalSignals: 1,
        activeSignals: signal.status == TradingSignalStatus.active ? 1 : 0,
        avgPnl: signal.pnlPct,
      );
    } else {
      existing.totalSignals += 1;
      if (signal.status == TradingSignalStatus.active) {
        existing.activeSignals += 1;
      }
      existing.avgPnl =
          (existing.avgPnl * (existing.totalSignals - 1) + signal.pnlPct) /
          existing.totalSignals;
    }
  }

  final result = [
    for (final provider in summaries.values)
      SignalProviderSummary(
        name: provider.name,
        avatar: provider.avatar,
        tier: provider.tier,
        winRate: provider.winRate,
        followers: provider.followers,
        totalSignals: provider.totalSignals,
        activeSignals: provider.activeSignals,
        avgPnl: provider.avgPnl,
      ),
  ];
  result.sort((a, b) => b.winRate.compareTo(a.winRate));
  return result;
}

final class _MutableSignalProviderSummary {
  _MutableSignalProviderSummary({
    required this.name,
    required this.avatar,
    required this.tier,
    required this.winRate,
    required this.followers,
    required this.totalSignals,
    required this.activeSignals,
    required this.avgPnl,
  });

  final String name;
  final String avatar;
  final TradingSignalProviderTier tier;
  final double winRate;
  final int followers;
  int totalSignals;
  int activeSignals;
  double avgPnl;
}

MarketPair _findMarketPair(String pairId) {
  for (final pair in _marketPairs) {
    if (pair.id == pairId) return pair;
  }
  return _marketPairs.first;
}

MarketDepthData _generateDepthData(double midPrice, int levels) {
  final bids = <MarketDepthLevel>[];
  final asks = <MarketDepthLevel>[];
  final step = midPrice * 0.0003;
  final multiplier = midPrice > 10000
      ? 0.01
      : midPrice > 100
      ? 1.0
      : 100.0;

  var bidCumulative = 0.0;
  for (var index = 0; index < levels; index += 1) {
    final price = midPrice - (index + 1) * step;
    final quantity =
        _depthBidPattern[index % _depthBidPattern.length] * multiplier;
    bidCumulative += quantity;
    bids.add(
      MarketDepthLevel(
        price: price,
        quantity: quantity,
        cumulative: bidCumulative,
      ),
    );
  }

  var askCumulative = 0.0;
  for (var index = 0; index < levels; index += 1) {
    final price = midPrice + (index + 1) * step;
    final quantity =
        _depthAskPattern[index % _depthAskPattern.length] * multiplier;
    askCumulative += quantity;
    asks.add(
      MarketDepthLevel(
        price: price,
        quantity: quantity,
        cumulative: askCumulative,
      ),
    );
  }

  final spread = asks.first.price - bids.first.price;
  return MarketDepthData(
    bids: bids,
    asks: asks,
    midPrice: midPrice,
    spread: spread,
    spreadPct: spread / midPrice * 100,
  );
}

List<MarketWhaleOrder> _generateWhaleOrders(double midPrice) {
  final multiplier = midPrice > 10000
      ? 0.01
      : midPrice > 100
      ? 1.0
      : 100.0;
  return [
    MarketWhaleOrder(
      id: 'w1',
      side: MarketOrderSide.buy,
      price: midPrice * 0.994,
      quantity: 12.5 * multiplier,
      usdValue: midPrice * 12.5 * multiplier,
      timeAgo: '2 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w2',
      side: MarketOrderSide.sell,
      price: midPrice * 1.005,
      quantity: 8.9 * multiplier,
      usdValue: midPrice * 8.9 * multiplier,
      timeAgo: '5 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w3',
      side: MarketOrderSide.buy,
      price: midPrice * 0.988,
      quantity: 15.2 * multiplier,
      usdValue: midPrice * 15.2 * multiplier,
      timeAgo: '8 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w4',
      side: MarketOrderSide.sell,
      price: midPrice * 1.012,
      quantity: 7.4 * multiplier,
      usdValue: midPrice * 7.4 * multiplier,
      timeAgo: '12 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w5',
      side: MarketOrderSide.buy,
      price: midPrice * 0.982,
      quantity: 20.1 * multiplier,
      usdValue: midPrice * 20.1 * multiplier,
      timeAgo: '18 phút trước',
    ),
  ];
}

List<MarketCalendarEvent> _applyCalendarQuery(
  List<MarketCalendarEvent> source,
  MarketCalendarQuery query,
) {
  var events = source;
  if (query.type != null) {
    events = [
      for (final event in events)
        if (event.type == query.type) event,
    ];
  }
  if (query.impact != null) {
    events = [
      for (final event in events)
        if (event.impact == query.impact) event,
    ];
  }
  return [...events]..sort(
    (a, b) => DateTime.parse(a.dateIso).compareTo(DateTime.parse(b.dateIso)),
  );
}

int _daysUntil(String dateIso) {
  final now = DateTime.utc(2026, 3, 11, 12);
  final eventDate = DateTime.parse(dateIso).toUtc();
  return ((eventDate.difference(now).inMilliseconds) /
          Duration.millisecondsPerDay)
      .ceil();
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

const GlobalMarketStats _globalMarketStats = GlobalMarketStats(
  totalMarketCap: 2456789012345,
  totalMarketCapChange24h: 2.14,
  total24hVolume: 98765432100,
  total24hVolumeChange: -3.21,
  btcDominance: 53.8,
  ethDominance: 17.2,
  totalCoins: 12847,
  totalExchanges: 742,
  fearGreedIndex: 62,
  fearGreedLabel: 'Tham lam',
  activeCryptocurrencies: 9432,
  defiTVL: 89234567000,
  defiTVLChange24h: 1.87,
  stablecoinVolume24h: 45678901000,
);

const MarketBreadth _marketBreadth = MarketBreadth(
  advancing: 5843,
  declining: 3412,
  unchanged: 1177,
  newATH: 47,
  dropping10Pct: 123,
);

const MarketScreenFilters _marketMoverFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Layer 1', 'Layer 2', 'DeFi', 'AI', 'Payment'],
  defaultCategory: 'Tất cả',
  defaultSort: 'change',
  sortOptions: [
    MarketSortOption(id: 'change', label: '% Thay đổi'),
    MarketSortOption(id: 'volume', label: 'Khối lượng'),
    MarketSortOption(id: 'market_cap', label: 'Market Cap'),
  ],
);

const MarketScreenFilters _marketSectorFilters = MarketScreenFilters(
  categories: [
    'Tất cả',
    'Layer 1',
    'DeFi',
    'Layer 2',
    'AI',
    'Meme',
    'Payment',
    'Gaming',
    'Privacy',
  ],
  defaultCategory: 'Tất cả',
  defaultSort: 'performance',
  sortOptions: [
    MarketSortOption(id: 'performance', label: 'Hiệu suất 24h'),
    MarketSortOption(id: 'market_cap', label: 'Vốn hóa'),
    MarketSortOption(id: 'coin_count', label: 'Số coin'),
  ],
);

const MarketScreenFilters _marketWatchlistFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Có ghi chú', 'Tăng 24h', 'Giảm 24h'],
  defaultCategory: 'Tất cả',
  defaultSort: 'manual',
  sortOptions: [
    MarketSortOption(id: 'manual', label: 'Thứ tự theo dõi'),
    MarketSortOption(id: 'price_desc', label: 'Giá cao -> thấp'),
    MarketSortOption(id: 'change_desc', label: 'Tăng nhiều nhất'),
  ],
);

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
