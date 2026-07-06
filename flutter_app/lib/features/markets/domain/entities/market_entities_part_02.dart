part of 'market_entities.dart';

final class MarketNewsItem {
  const MarketNewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.timeAgo,
    required this.category,
    required this.sentiment,
    required this.relatedTokens,
    required this.icon,
    required this.iconColor,
    required this.readTime,
    this.isBreaking = false,
  });

  final String id;
  final String title;
  final String summary;
  final String source;
  final String timeAgo;
  final String category;
  final MarketNewsSentiment sentiment;
  final List<String> relatedTokens;
  final String icon;
  final AccentTone iconColor;
  final String readTime;
  final bool isBreaking;
}

final class MarketNewsCategory {
  const MarketNewsCategory({
    required this.id,
    required this.label,
    required this.color,
  });

  final String id;
  final String label;
  final AccentTone color;
}

final class MarketNewsSentimentBadge {
  const MarketNewsSentimentBadge({required this.label, required this.color});

  final String label;
  final AccentTone color;
}

enum MarketNewsSentiment { bullish, bearish, neutral }

final class MarketPortfolioSnapshot {
  const MarketPortfolioSnapshot({
    required this.stats,
    required this.holdings,
    required this.performance,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.sortBy,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final PortfolioStats stats;
  final List<PortfolioHolding> holdings;
  final List<PortfolioPerformancePoint> performance;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final MarketPortfolioSort sortBy;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class PortfolioStats {
  const PortfolioStats({
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.totalCost,
    required this.best24hSymbol,
    required this.best24hChange,
    required this.worst24hSymbol,
    required this.worst24hChange,
    required this.stableAllocation,
  });

  final double totalValue;
  final double totalPnl;
  final double totalPnlPct;
  final double totalCost;
  final String best24hSymbol;
  final double best24hChange;
  final String worst24hSymbol;
  final double worst24hChange;
  final double stableAllocation;
}

final class PortfolioHolding {
  const PortfolioHolding({
    required this.id,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.avgBuyPrice,
    required this.currentPrice,
    required this.value,
    required this.pnl,
    required this.pnlPct,
    required this.allocation,
    required this.change24h,
    required this.sparkline,
  });

  final String id;
  final String symbol;
  final String name;
  final double quantity;
  final double avgBuyPrice;
  final double currentPrice;
  final double value;
  final double pnl;
  final double pnlPct;
  final double allocation;
  final double change24h;
  final List<double> sparkline;
}

final class PortfolioPerformancePoint {
  const PortfolioPerformancePoint({required this.date, required this.value});

  final String date;
  final double value;
}

enum MarketPortfolioSort { value, pnl, change }

final class MarketSocialSentimentSnapshot {
  const MarketSocialSentimentSnapshot({
    required this.global,
    required this.tokens,
    required this.trendingTokens,
    required this.timeline,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.sortBy,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final SocialSentimentGlobal global;
  final List<SocialSentimentToken> tokens;
  final List<SocialSentimentToken> trendingTokens;
  final List<SocialSentimentTimelinePoint> timeline;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final MarketSentimentSort sortBy;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class SocialSentimentGlobal {
  const SocialSentimentGlobal({
    required this.overallScore,
    required this.overallLabel,
    required this.totalMentions24h,
    required this.mentionsChange,
    required this.trendingTokens,
    required this.socialDominanceBtc,
    required this.socialDominanceEth,
    required this.socialDominanceOther,
  });

  final int overallScore;
  final String overallLabel;
  final double totalMentions24h;
  final double mentionsChange;
  final int trendingTokens;
  final double socialDominanceBtc;
  final double socialDominanceEth;
  final double socialDominanceOther;
}

final class SocialSentimentToken {
  const SocialSentimentToken({
    required this.id,
    required this.symbol,
    required this.name,
    required this.sentimentScore,
    required this.sentimentLabel,
    required this.mentions24h,
    required this.mentionsChange,
    required this.socialVolume,
    required this.twitterFollowers,
    required this.telegramMembers,
    required this.redditSubscribers,
    required this.bullishPct,
    required this.bearishPct,
    required this.neutralPct,
    required this.trending,
    required this.topTopics,
    this.trendingRank,
  });

  final String id;
  final String symbol;
  final String name;
  final int sentimentScore;
  final String sentimentLabel;
  final double mentions24h;
  final double mentionsChange;
  final double socialVolume;
  final double twitterFollowers;
  final double telegramMembers;
  final double redditSubscribers;
  final int bullishPct;
  final int bearishPct;
  final int neutralPct;
  final bool trending;
  final List<String> topTopics;
  final int? trendingRank;
}

final class SocialSentimentTimelinePoint {
  const SocialSentimentTimelinePoint({
    required this.time,
    required this.score,
    required this.mentions,
  });

  final String time;
  final int score;
  final double mentions;
}

enum MarketSentimentSort { sentiment, mentions, trending }

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

enum MarketOrderSide { buy, sell }

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

enum MarketDerivativesSort { openInterest, volume, funding, change }

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
