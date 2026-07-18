part of 'market_entities.dart';

/// Read-model for the Market Events Calendar screen (upcoming events,
/// stats, active filters).
final class MarketCalendarSnapshot {
  const MarketCalendarSnapshot({
    required this.events,
    required this.stats,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.appliedQuery,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketCalendarEvent> events;
  final MarketCalendarStats stats;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final MarketCalendarQuery appliedQuery;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for the Derivatives Market screen (global stats, derivative
/// pairs, liquidation history).
final class MarketDerivativesSnapshot {
  const MarketDerivativesSnapshot({
    required this.globalStats,
    required this.pairs,
    required this.liquidationHistory,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.sortBy,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final DerivativesGlobalStats globalStats;
  final List<DerivativePair> pairs;
  final List<LiquidationPoint> liquidationHistory;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final MarketDerivativesSort sortBy;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for the Market Depth (order book) screen for a single pair.
final class MarketDepthSnapshot {
  const MarketDepthSnapshot({
    required this.pair,
    required this.depth,
    required this.whaleOrders,
    required this.availableLevels,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final MarketPair pair;
  final MarketDepthData depth;
  final List<MarketWhaleOrder> whaleOrders;
  final List<int> availableLevels;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Category of a market calendar event (unlock, upgrade, halving, etc.).
enum MarketCalendarEventType {
  unlock,
  upgrade,
  halving,
  airdrop,
  listing,
  fork,
  burn,
  conference,
  report,
}

/// Expected market impact of a calendar event: high, medium, or low.
enum MarketCalendarImpact { high, medium, low }

/// Active type/impact filter applied to the market calendar list.
final class MarketCalendarQuery {
  const MarketCalendarQuery({this.type, this.impact});

  static const defaults = MarketCalendarQuery();

  final MarketCalendarEventType? type;
  final MarketCalendarImpact? impact;

  MarketCalendarQuery copyWith({
    MarketCalendarEventType? type,
    MarketCalendarImpact? impact,
    bool clearType = false,
    bool clearImpact = false,
  }) {
    return MarketCalendarQuery(
      type: clearType ? null : type ?? this.type,
      impact: clearImpact ? null : impact ?? this.impact,
    );
  }

  // GD4-F3: value equality required so FutureProvider.family(query) caches
  // by content instead of instance identity — otherwise every rebuild would
  // create a brand-new provider element and re-flash the loading state.
  @override
  bool operator ==(Object other) {
    return other is MarketCalendarQuery &&
        other.type == type &&
        other.impact == impact;
  }

  @override
  int get hashCode => Object.hash(type, impact);
}

/// Aggregate calendar stats (upcoming/high-impact/this-week counts).
final class MarketCalendarStats {
  const MarketCalendarStats({
    required this.upcoming,
    required this.highImpact,
    required this.thisWeek,
  });

  final int upcoming;
  final int highImpact;
  final int thisWeek;
}

/// A single market calendar event (title, type, date, impact).
final class MarketCalendarEvent {
  const MarketCalendarEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.dateIso,
    required this.impact,
    required this.description,
    required this.confirmed,
    this.symbol,
    this.source,
  });

  final String id;
  final String title;
  final MarketCalendarEventType type;
  final String dateIso;
  final MarketCalendarImpact impact;
  final String description;
  final bool confirmed;
  final String? symbol;
  final String? source;
}

/// Aggregate global derivatives stats (open interest, volume,
/// liquidations, funding, fear/greed).
final class DerivativesGlobalStats {
  const DerivativesGlobalStats({
    required this.totalOpenInterest,
    required this.oiChange24h,
    required this.totalVolume24h,
    required this.volumeChange24h,
    required this.totalLiquidations24h,
    required this.longLiquidations24h,
    required this.shortLiquidations24h,
    required this.avgFundingRate,
    required this.btcLongShortRatio,
    required this.fearGreedDerivatives,
  });

  final double totalOpenInterest;
  final double oiChange24h;
  final double totalVolume24h;
  final double volumeChange24h;
  final double totalLiquidations24h;
  final double longLiquidations24h;
  final double shortLiquidations24h;
  final double avgFundingRate;
  final double btcLongShortRatio;
  final int fearGreedDerivatives;
}

/// A single derivatives (perpetual/futures) market row with funding,
/// open interest, and liquidation stats.
final class DerivativePair {
  const DerivativePair({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.indexPrice,
    required this.markPrice,
    required this.fundingRate,
    required this.fundingInterval,
    required this.openInterest,
    required this.openInterestChange24h,
    required this.volume24h,
    required this.longRatio,
    required this.shortRatio,
    required this.longLiquidations24h,
    required this.shortLiquidations24h,
    required this.maxLeverage,
  });

  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final double indexPrice;
  final double markPrice;
  final double fundingRate;
  final String fundingInterval;
  final double openInterest;
  final double openInterestChange24h;
  final double volume24h;
  final double longRatio;
  final double shortRatio;
  final double longLiquidations24h;
  final double shortLiquidations24h;
  final int maxLeverage;

  double get totalLiquidations24h => longLiquidations24h + shortLiquidations24h;
}

/// One time bucket's long/short liquidation volume.
final class LiquidationPoint {
  const LiquidationPoint({
    required this.time,
    required this.long,
    required this.short,
  });

  final String time;
  final double long;
  final double short;
}

/// Sort key for the derivatives market list: open interest, volume,
/// funding, or change.
enum MarketDerivativesSort { openInterest, volume, funding, change }

/// Bid/ask order book levels for the depth screen, with derived spread.
final class MarketDepthData {
  const MarketDepthData({
    required this.bids,
    required this.asks,
    required this.midPrice,
    required this.spread,
    required this.spreadPct,
  });

  final List<MarketDepthLevel> bids;
  final List<MarketDepthLevel> asks;
  final double midPrice;
  final double spread;
  final double spreadPct;

  double get totalBidQuantity =>
      bids.fold<double>(0, (sum, level) => sum + level.quantity);

  double get totalAskQuantity =>
      asks.fold<double>(0, (sum, level) => sum + level.quantity);

  double get bidRatioPct {
    final total = totalBidQuantity + totalAskQuantity;
    if (total == 0) return 0;
    return totalBidQuantity / total * 100;
  }
}

/// A single price/quantity/cumulative row of the market depth chart.
final class MarketDepthLevel {
  const MarketDepthLevel({
    required this.price,
    required this.quantity,
    required this.cumulative,
  });

  final double price;
  final double quantity;
  final double cumulative;
}

/// A single large ("whale") order shown on the market depth screen.
final class MarketWhaleOrder {
  const MarketWhaleOrder({
    required this.id,
    required this.side,
    required this.price,
    required this.quantity,
    required this.usdValue,
    required this.timeAgo,
  });

  final String id;
  final MarketOrderSide side;
  final double price;
  final double quantity;
  final double usdValue;
  final String timeAgo;
}

/// Side of a market order: buy or sell.
enum MarketOrderSide { buy, sell }
