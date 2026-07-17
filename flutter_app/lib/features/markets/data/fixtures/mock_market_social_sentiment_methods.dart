part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositorySocialSentimentMethods on _MockMarketRepositoryBase {
  @override
  MarketSocialSentimentSnapshot getSocialSentiment({
    MarketSentimentSort sortBy = MarketSentimentSort.sentiment,
  }) {
    final sortedTokens = [..._socialSentimentTokens];
    switch (sortBy) {
      case MarketSentimentSort.sentiment:
        sortedTokens.sort(
          (a, b) => b.sentimentScore.compareTo(a.sentimentScore),
        );
      case MarketSentimentSort.mentions:
        sortedTokens.sort((a, b) => b.mentions24h.compareTo(a.mentions24h));
      case MarketSentimentSort.trending:
        sortedTokens.sort(
          (a, b) => (a.trendingRank ?? 999).compareTo(b.trendingRank ?? 999),
        );
    }

    final trendingTokens = [
      for (final token in _socialSentimentTokens)
        if (token.trending) token,
    ]..sort((a, b) => (a.trendingRank ?? 999).compareTo(b.trendingRank ?? 999));

    return MarketSocialSentimentSnapshot(
      global: _socialSentimentGlobal,
      tokens: sortedTokens,
      trendingTokens: trendingTokens,
      timeline: _socialSentimentTimeline,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'sentiment-btc-trending',
          pairId: 'btcusdt',
          label: 'BTC social sentiment trending',
        ),
        MarketAlertDraft(
          id: 'sentiment-sol-bullish',
          pairId: 'solusdt',
          label: 'SOL sentiment score leads tokens',
        ),
      ],
      screenFilters: _marketSocialSentimentFilters,
      chartSeries: {
        'sentimentTimeline': [
          for (final point in _socialSentimentTimeline) point.score.toDouble(),
        ],
        'mentionsTimeline': [
          for (final point in _socialSentimentTimeline) point.mentions,
        ],
        'socialDominance': [
          _socialSentimentGlobal.socialDominanceBtc,
          _socialSentimentGlobal.socialDominanceEth,
          _socialSentimentGlobal.socialDominanceOther,
        ],
        for (final token in _socialSentimentTokens)
          token.id: [
            token.sentimentScore.toDouble(),
            token.mentions24h,
            token.mentionsChange,
            token.socialVolume,
          ],
      },
      sortBy: sortBy,
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

const MarketScreenFilters _marketSocialSignalsFilters = MarketScreenFilters(
  categories: ['Tín hiệu', 'Nhà cung cấp', 'Hiệu suất'],
  defaultCategory: 'Tín hiệu',
  defaultSort: 'all',
  sortOptions: [
    MarketSortOption(id: 'all', label: 'Tất cả'),
    MarketSortOption(id: 'active', label: 'Đang hoạt động'),
    MarketSortOption(id: 'target_hit', label: 'Đạt mục tiêu'),
    MarketSortOption(id: 'stopped', label: 'Dừng lỗ'),
  ],
);

const Map<TradingSignalProviderTier, SignalTierConfig> _signalTierConfigs = {
  TradingSignalProviderTier.gold: SignalTierConfig(
    label: 'Vàng',
    color: AccentTone.warn,
    background: AccentTone.warn10,
  ),
  TradingSignalProviderTier.silver: SignalTierConfig(
    label: 'Bạc',
    color: AccentTone.medalSilverBlue,
    background: AccentTone.medalSilverBlue10,
  ),
  TradingSignalProviderTier.bronze: SignalTierConfig(
    label: 'Đồng',
    color: AccentTone.medalBronzeMuted,
    background: AccentTone.medalBronzeMuted10,
  ),
};

const Map<TradingSignalStatus, SignalStatusConfig> _signalStatusConfigs = {
  TradingSignalStatus.active: SignalStatusConfig(
    label: 'Đang hoạt động',
    color: AccentTone.info,
  ),
  TradingSignalStatus.targetHit: SignalStatusConfig(
    label: 'Đạt mục tiêu',
    color: AccentTone.buy,
  ),
  TradingSignalStatus.stopped: SignalStatusConfig(
    label: 'Dừng lỗ',
    color: AccentTone.sell,
  ),
  TradingSignalStatus.expired: SignalStatusConfig(
    label: 'Hết hạn',
    color: AccentTone.text3,
  ),
};

const List<TradingSignalDraft> _tradingSignals = [
  TradingSignalDraft(
    id: 's1',
    providerName: 'CryptoWhale_VN',
    providerAvatar: '🐋',
    providerTier: TradingSignalProviderTier.gold,
    providerWinRate: 72.5,
    providerFollowers: 12400,
    pair: 'BTC/USDT',
    baseAsset: 'BTC',
    direction: TradingSignalDirection.long,
    entry: 66800,
    targets: [68500, 70000, 72000],
    stopLoss: 64500,
    currentPrice: 67543,
    status: TradingSignalStatus.active,
    pnlPct: 1.11,
    confidence: TradingSignalConfidence.high,
    reasoning:
        'BTC phá kháng cự \$66.5K với volume mạnh. RSI 58 còn dư để tăng. ETF inflow tích cực.',
    timeAgo: '2 giờ trước',
    expiresIn: '5 ngày',
    likes: 342,
    copies: 89,
    category: TradingSignalCategory.swing,
  ),
  TradingSignalDraft(
    id: 's2',
    providerName: 'SOL_Hunter',
    providerAvatar: '🎯',
    providerTier: TradingSignalProviderTier.gold,
    providerWinRate: 68.3,
    providerFollowers: 8900,
    pair: 'SOL/USDT',
    baseAsset: 'SOL',
    direction: TradingSignalDirection.long,
    entry: 175,
    targets: [185, 195, 210],
    stopLoss: 165,
    currentPrice: 178.32,
    status: TradingSignalStatus.active,
    pnlPct: 1.90,
    confidence: TradingSignalConfidence.high,
    reasoning:
        'SOL breakout trên đường trend dài hạn. Firedancer testnet thành công. Volume tăng 67%.',
    timeAgo: '4 giờ trước',
    expiresIn: '7 ngày',
    likes: 567,
    copies: 145,
    category: TradingSignalCategory.swing,
  ),
  TradingSignalDraft(
    id: 's3',
    providerName: 'DeFi_Alpha',
    providerAvatar: '🔬',
    providerTier: TradingSignalProviderTier.silver,
    providerWinRate: 64.1,
    providerFollowers: 5600,
    pair: 'ETH/USDT',
    baseAsset: 'ETH',
    direction: TradingSignalDirection.long,
    entry: 3480,
    targets: [3600, 3750],
    stopLoss: 3350,
    currentPrice: 3521,
    status: TradingSignalStatus.active,
    pnlPct: 1.18,
    confidence: TradingSignalConfidence.medium,
    reasoning:
        'ETH accumulation zone. Pectra upgrade sắp tới. Gas fees ổn định thấp.',
    timeAgo: '6 giờ trước',
    expiresIn: '10 ngày',
    likes: 234,
    copies: 67,
    category: TradingSignalCategory.position,
  ),
  TradingSignalDraft(
    id: 's4',
    providerName: 'ScalpKing',
    providerAvatar: '⚡',
    providerTier: TradingSignalProviderTier.silver,
    providerWinRate: 71.2,
    providerFollowers: 3200,
    pair: 'BTC/USDT',
    baseAsset: 'BTC',
    direction: TradingSignalDirection.short,
    entry: 68200,
    targets: [67000, 66200],
    stopLoss: 69500,
    currentPrice: 67543,
    status: TradingSignalStatus.active,
    pnlPct: 0.96,
    confidence: TradingSignalConfidence.medium,
    reasoning:
        'BTC test kháng cự \$68K, RSI overbought trên H4. Funding rate cao - khả năng pullback.',
    timeAgo: '1 giờ trước',
    expiresIn: '2 ngày',
    likes: 189,
    copies: 34,
    category: TradingSignalCategory.scalp,
  ),
  TradingSignalDraft(
    id: 's5',
    providerName: 'AltSeason_Pro',
    providerAvatar: '🚀',
    providerTier: TradingSignalProviderTier.bronze,
    providerWinRate: 59.8,
    providerFollowers: 2100,
    pair: 'AVAX/USDT',
    baseAsset: 'AVAX',
    direction: TradingSignalDirection.long,
    entry: 38.50,
    targets: [42, 46],
    stopLoss: 35,
    currentPrice: 39.80,
    status: TradingSignalStatus.active,
    pnlPct: 3.38,
    confidence: TradingSignalConfidence.medium,
    reasoning:
        'AVAX subnet growth mạnh. Gaming ecosystem phát triển. Giá phá MA50.',
    timeAgo: '8 giờ trước',
    expiresIn: '14 ngày',
    likes: 156,
    copies: 28,
    category: TradingSignalCategory.swing,
  ),
  TradingSignalDraft(
    id: 's6',
    providerName: 'CryptoWhale_VN',
    providerAvatar: '🐋',
    providerTier: TradingSignalProviderTier.gold,
    providerWinRate: 72.5,
    providerFollowers: 12400,
    pair: 'LINK/USDT',
    baseAsset: 'LINK',
    direction: TradingSignalDirection.long,
    entry: 14.20,
    targets: [15.50, 17.00],
    stopLoss: 13.00,
    currentPrice: 14.85,
    status: TradingSignalStatus.targetHit,
    pnlPct: 4.58,
    confidence: TradingSignalConfidence.high,
    reasoning:
        'CCIP V2 launch catalyst. Cross-chain demand tăng. Accumulation whale lớn.',
    timeAgo: '1 ngày trước',
    expiresIn: 'Hoàn thành',
    likes: 412,
    copies: 112,
    category: TradingSignalCategory.swing,
  ),
  TradingSignalDraft(
    id: 's7',
    providerName: 'DeFi_Alpha',
    providerAvatar: '🔬',
    providerTier: TradingSignalProviderTier.silver,
    providerWinRate: 64.1,
    providerFollowers: 5600,
    pair: 'DOGE/USDT',
    baseAsset: 'DOGE',
    direction: TradingSignalDirection.long,
    entry: 0.125,
    targets: [0.145, 0.160],
    stopLoss: 0.110,
    currentPrice: 0.108,
    status: TradingSignalStatus.stopped,
    pnlPct: -13.60,
    confidence: TradingSignalConfidence.low,
    reasoning: 'DOGE breakout attempt thất bại. Meme momentum giảm.',
    timeAgo: '2 ngày trước',
    expiresIn: 'Dừng lỗ',
    likes: 89,
    copies: 15,
    category: TradingSignalCategory.swing,
  ),
];

const MarketScreenFilters _marketCorrelationFilters = MarketScreenFilters(
  categories: ['Ma trận', 'Cặp tương quan', 'Đa dạng hóa'],
  defaultCategory: 'Ma trận',
  defaultSort: '7d',
  sortOptions: [
    MarketSortOption(id: '7d', label: '7d'),
    MarketSortOption(id: '30d', label: '30d'),
    MarketSortOption(id: '90d', label: '90d'),
    MarketSortOption(id: 'high', label: 'Tương quan cao'),
    MarketSortOption(id: 'low', label: 'Tương quan thấp'),
  ],
);

const List<CorrelationAsset> _correlationAssets = [
  CorrelationAsset(symbol: 'BTC'),
  CorrelationAsset(symbol: 'ETH'),
  CorrelationAsset(symbol: 'SOL'),
  CorrelationAsset(symbol: 'BNB'),
  CorrelationAsset(symbol: 'XRP'),
  CorrelationAsset(symbol: 'ADA'),
  CorrelationAsset(symbol: 'AVAX'),
  CorrelationAsset(symbol: 'LINK'),
];

const List<List<double>> _corrMatrix7d = [
  [1.00, 0.92, 0.85, 0.88, 0.72, 0.68, 0.78, 0.74],
  [0.92, 1.00, 0.88, 0.82, 0.65, 0.71, 0.82, 0.79],
  [0.85, 0.88, 1.00, 0.76, 0.58, 0.62, 0.74, 0.69],
  [0.88, 0.82, 0.76, 1.00, 0.70, 0.65, 0.72, 0.67],
  [0.72, 0.65, 0.58, 0.70, 1.00, 0.78, 0.60, 0.55],
  [0.68, 0.71, 0.62, 0.65, 0.78, 1.00, 0.68, 0.72],
  [0.78, 0.82, 0.74, 0.72, 0.60, 0.68, 1.00, 0.80],
  [0.74, 0.79, 0.69, 0.67, 0.55, 0.72, 0.80, 1.00],
];

const List<List<double>> _corrMatrix30d = [
  [1.00, 0.89, 0.82, 0.85, 0.68, 0.64, 0.75, 0.71],
  [0.89, 1.00, 0.84, 0.79, 0.62, 0.67, 0.79, 0.76],
  [0.82, 0.84, 1.00, 0.73, 0.55, 0.59, 0.71, 0.66],
  [0.85, 0.79, 0.73, 1.00, 0.67, 0.62, 0.69, 0.64],
  [0.68, 0.62, 0.55, 0.67, 1.00, 0.75, 0.57, 0.52],
  [0.64, 0.67, 0.59, 0.62, 0.75, 1.00, 0.65, 0.69],
  [0.75, 0.79, 0.71, 0.69, 0.57, 0.65, 1.00, 0.77],
  [0.71, 0.76, 0.66, 0.64, 0.52, 0.69, 0.77, 1.00],
];

const List<List<double>> _corrMatrix90d = [
  [1.00, 0.86, 0.78, 0.82, 0.64, 0.60, 0.72, 0.68],
  [0.86, 1.00, 0.81, 0.76, 0.58, 0.63, 0.76, 0.73],
  [0.78, 0.81, 1.00, 0.70, 0.51, 0.55, 0.68, 0.63],
  [0.82, 0.76, 0.70, 1.00, 0.63, 0.58, 0.66, 0.61],
  [0.64, 0.58, 0.51, 0.63, 1.00, 0.72, 0.54, 0.49],
  [0.60, 0.63, 0.55, 0.58, 0.72, 1.00, 0.62, 0.66],
  [0.72, 0.76, 0.68, 0.66, 0.54, 0.62, 1.00, 0.74],
  [0.68, 0.73, 0.63, 0.61, 0.49, 0.66, 0.74, 1.00],
];

const SocialSentimentGlobal _socialSentimentGlobal = SocialSentimentGlobal(
  overallScore: 62,
  overallLabel: 'Tích cực',
  totalMentions24h: 2345678,
  mentionsChange: 18.9,
  trendingTokens: 47,
  socialDominanceBtc: 38.2,
  socialDominanceEth: 18.5,
  socialDominanceOther: 43.3,
);

const List<SocialSentimentToken> _socialSentimentTokens = [
  SocialSentimentToken(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    sentimentScore: 72,
    sentimentLabel: 'Rất tích cực',
    mentions24h: 345678,
    mentionsChange: 23.4,
    socialVolume: 1234567,
    twitterFollowers: 6200000,
    telegramMembers: 890000,
    redditSubscribers: 5400000,
    bullishPct: 68,
    bearishPct: 18,
    neutralPct: 14,
    trending: true,
    trendingRank: 1,
    topTopics: ['ETF Flows', 'Halving', 'Institutional'],
  ),
  SocialSentimentToken(
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    sentimentScore: 45,
    sentimentLabel: 'Tích cực',
    mentions24h: 198456,
    mentionsChange: -5.6,
    socialVolume: 876543,
    twitterFollowers: 3100000,
    telegramMembers: 456000,
    redditSubscribers: 2800000,
    bullishPct: 52,
    bearishPct: 28,
    neutralPct: 20,
    trending: true,
    trendingRank: 3,
    topTopics: ['Pectra Upgrade', 'L2 Growth', 'Staking Yield'],
  ),
  SocialSentimentToken(
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    sentimentScore: 85,
    sentimentLabel: 'Cực kỳ tích cực',
    mentions24h: 267890,
    mentionsChange: 67.8,
    socialVolume: 987654,
    twitterFollowers: 2800000,
    telegramMembers: 567000,
    redditSubscribers: 890000,
    bullishPct: 78,
    bearishPct: 12,
    neutralPct: 10,
    trending: true,
    trendingRank: 2,
    topTopics: ['Firedancer', 'Meme Season', 'DePIN'],
  ),
  SocialSentimentToken(
    id: 'xrp',
    symbol: 'XRP',
    name: 'Ripple',
    sentimentScore: -15,
    sentimentLabel: 'Hơi tiêu cực',
    mentions24h: 89012,
    mentionsChange: -12.3,
    socialVolume: 345678,
    twitterFollowers: 1500000,
    telegramMembers: 234000,
    redditSubscribers: 890000,
    bullishPct: 35,
    bearishPct: 42,
    neutralPct: 23,
    trending: false,
    topTopics: ['SEC Case', 'Price Drop', 'RLUSD'],
  ),
  SocialSentimentToken(
    id: 'doge',
    symbol: 'DOGE',
    name: 'Dogecoin',
    sentimentScore: 58,
    sentimentLabel: 'Tích cực',
    mentions24h: 156789,
    mentionsChange: 34.5,
    socialVolume: 567890,
    twitterFollowers: 3400000,
    telegramMembers: 123000,
    redditSubscribers: 2300000,
    bullishPct: 62,
    bearishPct: 22,
    neutralPct: 16,
    trending: true,
    trendingRank: 4,
    topTopics: ['Elon Tweet', 'Meme Rally', 'Payment Adoption'],
  ),
  SocialSentimentToken(
    id: 'link',
    symbol: 'LINK',
    name: 'Chainlink',
    sentimentScore: -32,
    sentimentLabel: 'Tiêu cực',
    mentions24h: 45678,
    mentionsChange: -8.9,
    socialVolume: 198765,
    twitterFollowers: 890000,
    telegramMembers: 167000,
    redditSubscribers: 234000,
    bullishPct: 28,
    bearishPct: 52,
    neutralPct: 20,
    trending: false,
    topTopics: ['CCIP V2', 'Price Drop', 'Staking'],
  ),
  SocialSentimentToken(
    id: 'avax',
    symbol: 'AVAX',
    name: 'Avalanche',
    sentimentScore: 41,
    sentimentLabel: 'Tích cực',
    mentions24h: 67890,
    mentionsChange: 15.6,
    socialVolume: 234567,
    twitterFollowers: 780000,
    telegramMembers: 189000,
    redditSubscribers: 156000,
    bullishPct: 55,
    bearishPct: 25,
    neutralPct: 20,
    trending: false,
    topTopics: ['Subnet Growth', 'Gaming', 'Institutional'],
  ),
  SocialSentimentToken(
    id: 'bnb',
    symbol: 'BNB',
    name: 'BNB',
    sentimentScore: 35,
    sentimentLabel: 'Tích cực',
    mentions24h: 123456,
    mentionsChange: 8.9,
    socialVolume: 456789,
    twitterFollowers: 1200000,
    telegramMembers: 345000,
    redditSubscribers: 567000,
    bullishPct: 50,
    bearishPct: 30,
    neutralPct: 20,
    trending: false,
    topTopics: ['BNB Burn', 'BSC TVL', 'Launchpool'],
  ),
];

const List<SocialSentimentTimelinePoint> _socialSentimentTimeline = [
  SocialSentimentTimelinePoint(time: '7d trước', score: 48, mentions: 1890000),
  SocialSentimentTimelinePoint(time: '6d trước', score: 52, mentions: 1950000),
  SocialSentimentTimelinePoint(time: '5d trước', score: 55, mentions: 2100000),
  SocialSentimentTimelinePoint(time: '4d trước', score: 50, mentions: 1980000),
  SocialSentimentTimelinePoint(time: '3d trước', score: 58, mentions: 2200000),
  SocialSentimentTimelinePoint(time: '2d trước', score: 60, mentions: 2300000),
  SocialSentimentTimelinePoint(time: 'Hôm qua', score: 57, mentions: 2250000),
  SocialSentimentTimelinePoint(time: 'Hôm nay', score: 62, mentions: 2345678),
];

const MarketScreenFilters _marketSocialSentimentFilters = MarketScreenFilters(
  categories: ['Tổng quan', 'Theo token', 'Xu hướng'],
  defaultCategory: 'Tổng quan',
  defaultSort: 'sentiment',
  sortOptions: [
    MarketSortOption(id: 'sentiment', label: 'Sentiment'),
    MarketSortOption(id: 'mentions', label: 'Mentions'),
    MarketSortOption(id: 'trending', label: 'Trending'),
  ],
);
