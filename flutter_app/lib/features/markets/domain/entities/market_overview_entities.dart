part of 'market_entities.dart';

/// Read-model for the full Markets list screen (pairs, watchlist, active
/// alerts and filters).
final class MarketListSnapshot {
  const MarketListSnapshot({
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for the Markets Overview dashboard (global stats, breadth,
/// fear/greed history, sectors, movers).
final class MarketOverviewSnapshot {
  const MarketOverviewSnapshot({
    required this.globalStats,
    required this.marketBreadth,
    required this.fearGreedHistory,
    required this.sectors,
    required this.movers,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final GlobalMarketStats globalStats;
  final MarketBreadth marketBreadth;
  final List<FearGreedPoint> fearGreedHistory;
  final List<MarketSector> sectors;
  final List<MarketMover> movers;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for the Top Movers screen (gainers/losers tabs across
/// timeframes).
final class MarketMoversSnapshot {
  const MarketMoversSnapshot({
    required this.movers,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.tabs,
    required this.timeframes,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketMover> movers;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final List<String> tabs;
  final List<String> timeframes;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for the Market Sectors screen.
final class MarketSectorsSnapshot {
  const MarketSectorsSnapshot({
    required this.sectors,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.timeframes,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketSector> sectors;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final List<String> timeframes;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for the Watchlist screen (saved pairs plus notes).
final class MarketWatchlistSnapshot {
  const MarketWatchlistSnapshot({
    required this.entries,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketWatchlistEntry> entries;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// A single market sector (e.g. DeFi, L1) with aggregate market cap and
/// change stats.
final class MarketSector {
  const MarketSector({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.color,
    required this.icon,
    required this.totalMarketCap,
    required this.change24h,
    required this.change7d,
    required this.change30d,
    required this.volume24h,
    required this.topCoins,
    required this.coinCount,
    required this.dominance,
  });

  final String id;
  final String name;
  final String nameVi;
  final AccentTone color;
  final String icon;
  final double totalMarketCap;
  final double change24h;
  final double change7d;
  final double change30d;
  final double volume24h;
  final List<String> topCoins;
  final int coinCount;
  final double dominance;
}

/// A single top-mover coin row (price and 1h/24h/7d change, volume,
/// market cap).
final class MarketMover {
  const MarketMover({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change1h,
    required this.change24h,
    required this.change7d,
    required this.volume24h,
    required this.volumeChange24h,
    required this.marketCap,
    required this.marketCapRank,
    required this.category,
    required this.sparkline,
    this.isNew = false,
    this.listingDate,
  });

  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change1h;
  final double change24h;
  final double change7d;
  final double volume24h;
  final double volumeChange24h;
  final double marketCap;
  final int marketCapRank;
  final String category;
  final List<double> sparkline;
  final bool isNew;
  final String? listingDate;
}

/// A single saved watchlist entry (pair id plus an optional user note).
final class MarketWatchlistEntry {
  const MarketWatchlistEntry({
    required this.id,
    required this.pairId,
    this.note,
  });

  final String id;
  final String pairId;
  final String? note;
}

/// Aggregate global crypto market stats (total market cap, volume,
/// dominance, fear/greed index).
final class GlobalMarketStats {
  const GlobalMarketStats({
    required this.totalMarketCap,
    required this.totalMarketCapChange24h,
    required this.total24hVolume,
    required this.total24hVolumeChange,
    required this.btcDominance,
    required this.ethDominance,
    required this.totalCoins,
    required this.totalExchanges,
    required this.fearGreedIndex,
    required this.fearGreedLabel,
    required this.activeCryptocurrencies,
    required this.defiTVL,
    required this.defiTVLChange24h,
    required this.stablecoinVolume24h,
  });

  final double totalMarketCap;
  final double totalMarketCapChange24h;
  final double total24hVolume;
  final double total24hVolumeChange;
  final double btcDominance;
  final double ethDominance;
  final int totalCoins;
  final int totalExchanges;
  final int fearGreedIndex;
  final String fearGreedLabel;
  final int activeCryptocurrencies;
  final double defiTVL;
  final double defiTVLChange24h;
  final double stablecoinVolume24h;
}

/// Market breadth counts (advancing/declining/unchanged/new-highs) shown
/// on the overview dashboard.
final class MarketBreadth {
  const MarketBreadth({
    required this.advancing,
    required this.declining,
    required this.unchanged,
    required this.newATH,
    required this.dropping10Pct,
  });

  final int advancing;
  final int declining;
  final int unchanged;
  final int newATH;
  final int dropping10Pct;
}

/// One date's Fear & Greed index value.
final class FearGreedPoint {
  const FearGreedPoint({
    required this.date,
    required this.value,
    required this.label,
  });

  final String date;
  final int value;
  final String label;
}
