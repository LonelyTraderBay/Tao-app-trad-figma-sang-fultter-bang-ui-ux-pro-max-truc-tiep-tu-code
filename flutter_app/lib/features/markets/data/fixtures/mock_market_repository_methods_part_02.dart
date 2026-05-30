part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositoryMethodsPart02 on _MockMarketRepositoryBase {
  @override
  MarketDerivativesSnapshot getMarketDerivatives({
    MarketDerivativesSort sortBy = MarketDerivativesSort.openInterest,
  }) {
    final sortedPairs = [..._derivativePairs];
    switch (sortBy) {
      case MarketDerivativesSort.openInterest:
        sortedPairs.sort((a, b) => b.openInterest.compareTo(a.openInterest));
      case MarketDerivativesSort.volume:
        sortedPairs.sort((a, b) => b.volume24h.compareTo(a.volume24h));
      case MarketDerivativesSort.funding:
        sortedPairs.sort(
          (a, b) => b.fundingRate.abs().compareTo(a.fundingRate.abs()),
        );
      case MarketDerivativesSort.change:
        sortedPairs.sort(
          (a, b) => b.change24h.abs().compareTo(a.change24h.abs()),
        );
    }

    return MarketDerivativesSnapshot(
      globalStats: _derivativesGlobalStats,
      pairs: sortedPairs,
      liquidationHistory: _liquidationHistory,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'derivatives-liquidation-spike',
          pairId: 'btcusdt',
          label: 'Liquidation spike in BTC perpetuals',
        ),
        MarketAlertDraft(
          id: 'derivatives-funding-watch',
          pairId: 'solusdt',
          label: 'Funding rate watchlist',
        ),
      ],
      screenFilters: _marketDerivativesFilters,
      chartSeries: {
        'liquidationLong': [
          for (final point in _liquidationHistory) point.long,
        ],
        'liquidationShort': [
          for (final point in _liquidationHistory) point.short,
        ],
        for (final pair in _derivativePairs)
          pair.id: [
            pair.openInterest,
            pair.volume24h,
            pair.fundingRate,
            pair.longRatio,
            pair.shortRatio,
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
  MarketDepthSnapshot getMarketDepth({
    String pairId = 'btcusdt',
    int levels = 25,
  }) {
    final normalizedLevels = _marketDepthLevels.contains(levels) ? levels : 25;
    final pair = _findMarketPair(pairId);
    final depth = _generateDepthData(pair.price, normalizedLevels);
    final whales = _generateWhaleOrders(pair.price);

    return MarketDepthSnapshot(
      pair: pair,
      depth: depth,
      whaleOrders: whales,
      availableLevels: _marketDepthLevels,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'depth-btc-spread',
          pairId: 'btcusdt',
          label: 'BTC depth spread baseline',
        ),
        MarketAlertDraft(
          id: 'depth-whale-wall',
          pairId: 'btcusdt',
          label: 'Whale order wall watch',
        ),
      ],
      screenFilters: _marketDepthFilters,
      chartSeries: {
        'bidCumulative': [for (final level in depth.bids) level.cumulative],
        'askCumulative': [for (final level in depth.asks) level.cumulative],
        'whaleUsdValue': [for (final order in whales) order.usdValue],
        pair.id: pair.sparklineData,
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
  MarketPortfolioSnapshot getPortfolioTracker({
    MarketPortfolioSort sortBy = MarketPortfolioSort.value,
  }) {
    final sortedHoldings = [..._portfolioHoldings];
    switch (sortBy) {
      case MarketPortfolioSort.value:
        sortedHoldings.sort((a, b) => b.value.compareTo(a.value));
      case MarketPortfolioSort.pnl:
        sortedHoldings.sort((a, b) => b.pnlPct.compareTo(a.pnlPct));
      case MarketPortfolioSort.change:
        sortedHoldings.sort((a, b) => b.change24h.compareTo(a.change24h));
    }

    return MarketPortfolioSnapshot(
      stats: _portfolioStats,
      holdings: sortedHoldings,
      performance: _portfolioPerformance,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'portfolio-stable-allocation',
          pairId: 'usdtusdt',
          label: 'Stablecoin allocation baseline',
        ),
        MarketAlertDraft(
          id: 'portfolio-sol-outperform',
          pairId: 'solusdt',
          label: 'SOL leads portfolio performance',
        ),
      ],
      screenFilters: _marketPortfolioFilters,
      chartSeries: {
        'portfolioPerformance': [
          for (final point in _portfolioPerformance) point.value,
        ],
        'portfolioAllocation': [
          for (final holding in _portfolioHoldings) holding.allocation,
        ],
        for (final holding in _portfolioHoldings) holding.id: holding.sparkline,
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
  MarketNewsSnapshot getMarketNews({
    String category = 'all',
    MarketNewsSentiment? sentiment,
  }) {
    var items = [..._marketNews];
    if (category != 'all') {
      items = category == 'breaking'
          ? items.where((item) => item.isBreaking).toList()
          : items.where((item) => item.category == category).toList();
    }
    if (sentiment != null) {
      items = items.where((item) => item.sentiment == sentiment).toList();
    }

    final breaking = [
      for (final item in _marketNews)
        if (item.isBreaking) item,
    ];

    return MarketNewsSnapshot(
      news: items,
      breakingNews: breaking,
      categories: _marketNewsCategories,
      sentimentBadges: _marketNewsSentimentBadges,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'news-breaking-btc',
          pairId: 'btcusdt',
          label: 'Breaking BTC ETF news',
        ),
        MarketAlertDraft(
          id: 'news-defi-tvl',
          pairId: 'ethusdt',
          label: 'DeFi TVL news watch',
        ),
      ],
      screenFilters: _marketNewsFilters,
      chartSeries: {
        'sentimentCounts': [
          _marketNews
              .where((item) => item.sentiment == MarketNewsSentiment.bullish)
              .length
              .toDouble(),
          _marketNews
              .where((item) => item.sentiment == MarketNewsSentiment.neutral)
              .length
              .toDouble(),
          _marketNews
              .where((item) => item.sentiment == MarketNewsSentiment.bearish)
              .length
              .toDouble(),
        ],
        'categoryCounts': [
          for (final category in _marketNewsCategories.skip(1))
            category.id == 'breaking'
                ? breaking.length.toDouble()
                : _marketNews
                      .where((item) => item.category == category.id)
                      .length
                      .toDouble(),
        ],
      },
      selectedCategory: category,
      sentimentFilter: sentiment,
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
  MarketAdvancedChartsSnapshot getAdvancedCharts({
    String indicatorCategory = 'all',
    String drawingCategory = 'all',
  }) {
    final indicators = indicatorCategory == 'all'
        ? _advancedChartIndicators
        : [
            for (final indicator in _advancedChartIndicators)
              if (indicator.categoryId == indicatorCategory) indicator,
          ];
    final drawingTools = drawingCategory == 'all'
        ? _advancedChartDrawingTools
        : [
            for (final tool in _advancedChartDrawingTools)
              if (tool.categoryId == drawingCategory) tool,
          ];

    return MarketAdvancedChartsSnapshot(
      indicators: indicators,
      drawingTools: drawingTools,
      signalSummaries: _advancedChartSignalSummaries,
      indicatorCategories: _advancedChartIndicatorCategories,
      drawingCategories: _advancedChartDrawingCategories,
      activeIndicatorIds: const {'sma', 'rsi'},
      selectedIndicatorCategory: indicatorCategory,
      selectedDrawingCategory: drawingCategory,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'advanced-chart-sma-rsi',
          pairId: 'btcusdt',
          label: 'SMA + RSI active chart setup',
        ),
        MarketAlertDraft(
          id: 'advanced-chart-sol-signal',
          pairId: 'solusdt',
          label: 'SOL technical signal leads watchlist',
        ),
      ],
      screenFilters: _advancedChartsFilters,
      chartSeries: {
        for (final indicator in _advancedChartIndicators)
          indicator.id: [
            for (final param in indicator.params) param.value.toDouble(),
          ],
        for (final signal in _advancedChartSignalSummaries)
          signal.pair: [
            signal.buyCount.toDouble(),
            signal.neutralCount.toDouble(),
            signal.sellCount.toDouble(),
          ],
        for (final pair in _marketPairs.take(3)) pair.id: pair.sparklineData,
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
  MarketTokenUnlocksSnapshot getTokenUnlocks({
    MarketUnlockSort sortBy = MarketUnlockSort.nearest,
    MarketUnlockImpact? impactFilter,
  }) {
    final unlocks = [
      for (final unlock in _tokenUnlocks)
        if (impactFilter == null || unlock.impactLevel == impactFilter) unlock,
    ];

    switch (sortBy) {
      case MarketUnlockSort.nearest:
        unlocks.sort((a, b) => a.daysUntil.compareTo(b.daysUntil));
      case MarketUnlockSort.value:
        unlocks.sort((a, b) => b.unlockValueUsd.compareTo(a.unlockValueUsd));
      case MarketUnlockSort.impact:
        unlocks.sort(
          (a, b) => b.unlockPctCirculating.compareTo(a.unlockPctCirculating),
        );
    }

    final totalValue = _tokenUnlocks.fold<double>(
      0,
      (sum, unlock) => sum + unlock.unlockValueUsd,
    );
    final totalDilution = _tokenUnlocks.fold<double>(
      0,
      (sum, unlock) => sum + unlock.unlockPctCirculating,
    );

    return MarketTokenUnlocksSnapshot(
      unlocks: unlocks,
      totalValueNext30d: totalValue,
      highImpactCount: _tokenUnlocks
          .where((unlock) => unlock.impactLevel == MarketUnlockImpact.high)
          .length,
      avgDilution: totalDilution / _tokenUnlocks.length,
      impactConfigs: _unlockImpactConfigs,
      categoryConfigs: _unlockCategoryConfigs,
      sortBy: sortBy,
      impactFilter: impactFilter,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'unlock-apt-high-impact',
          pairId: 'aptusdt',
          label: 'APT high impact unlock in 1 day',
        ),
        MarketAlertDraft(
          id: 'unlock-tia-dilution-risk',
          pairId: 'tiausdt',
          label: 'TIA dilution risk leads unlock calendar',
        ),
      ],
      screenFilters: _tokenUnlockFilters,
      chartSeries: {
        'unlockValueUsd': [
          for (final unlock in _tokenUnlocks) unlock.unlockValueUsd,
        ],
        'unlockDilutionPct': [
          for (final unlock in _tokenUnlocks) unlock.unlockPctCirculating,
        ],
        'daysUntil': [
          for (final unlock in _tokenUnlocks) unlock.daysUntil.toDouble(),
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
