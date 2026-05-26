import 'package:flutter/material.dart';

final class MarketCorrelationsSnapshot {
  const MarketCorrelationsSnapshot({
    required this.assets,
    required this.matrix,
    required this.pairs,
    required this.diversificationScore,
    required this.timeframe,
    required this.sortOrder,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<CorrelationAsset> assets;
  final List<List<double>> matrix;
  final List<CorrelationPairDraft> pairs;
  final DiversificationScoreDraft diversificationScore;
  final MarketCorrelationTimeframe timeframe;
  final CorrelationSortOrder sortOrder;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class CorrelationAsset {
  const CorrelationAsset({required this.symbol, required this.color});

  final String symbol;
  final Color color;
}

final class CorrelationPairDraft {
  const CorrelationPairDraft({
    required this.assetA,
    required this.assetB,
    required this.colorA,
    required this.colorB,
    required this.correlation7d,
    required this.correlation30d,
    required this.correlation90d,
  });

  final String assetA;
  final String assetB;
  final Color colorA;
  final Color colorB;
  final double correlation7d;
  final double correlation30d;
  final double correlation90d;
}

final class DiversificationScoreDraft {
  const DiversificationScoreDraft({
    required this.score,
    required this.label,
    required this.avgCorrelation,
    required this.lowestCorr,
    required this.highestCorr,
    required this.recommendation,
  });

  final int score;
  final String label;
  final double avgCorrelation;
  final CorrelationExtremum lowestCorr;
  final CorrelationExtremum highestCorr;
  final String recommendation;
}

final class CorrelationExtremum {
  const CorrelationExtremum({required this.pair, required this.value});

  final String pair;
  final double value;
}

enum MarketCorrelationTimeframe { d7, d30, d90 }

enum CorrelationSortOrder { high, low }

final class MarketSocialSignalsSnapshot {
  const MarketSocialSignalsSnapshot({
    required this.signals,
    required this.providers,
    required this.totalSignals,
    required this.hitSignals,
    required this.stoppedSignals,
    required this.overallWinRate,
    required this.avgPnl,
    required this.tierConfigs,
    required this.statusConfigs,
    required this.statusFilter,
    required this.categoryFilter,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradingSignalDraft> signals;
  final List<SignalProviderSummary> providers;
  final int totalSignals;
  final int hitSignals;
  final int stoppedSignals;
  final double overallWinRate;
  final double avgPnl;
  final Map<TradingSignalProviderTier, SignalTierConfig> tierConfigs;
  final Map<TradingSignalStatus, SignalStatusConfig> statusConfigs;
  final TradingSignalStatus? statusFilter;
  final TradingSignalCategory? categoryFilter;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class TradingSignalDraft {
  const TradingSignalDraft({
    required this.id,
    required this.providerName,
    required this.providerAvatar,
    required this.providerTier,
    required this.providerWinRate,
    required this.providerFollowers,
    required this.pair,
    required this.baseAsset,
    required this.direction,
    required this.entry,
    required this.targets,
    required this.stopLoss,
    required this.currentPrice,
    required this.status,
    required this.pnlPct,
    required this.confidence,
    required this.reasoning,
    required this.timeAgo,
    required this.expiresIn,
    required this.likes,
    required this.copies,
    required this.category,
  });

  final String id;
  final String providerName;
  final String providerAvatar;
  final TradingSignalProviderTier providerTier;
  final double providerWinRate;
  final int providerFollowers;
  final String pair;
  final String baseAsset;
  final TradingSignalDirection direction;
  final double entry;
  final List<double> targets;
  final double stopLoss;
  final double currentPrice;
  final TradingSignalStatus status;
  final double pnlPct;
  final TradingSignalConfidence confidence;
  final String reasoning;
  final String timeAgo;
  final String expiresIn;
  final int likes;
  final int copies;
  final TradingSignalCategory category;
}

final class SignalProviderSummary {
  const SignalProviderSummary({
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
  final int totalSignals;
  final int activeSignals;
  final double avgPnl;
}

final class SignalTierConfig {
  const SignalTierConfig({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

final class SignalStatusConfig {
  const SignalStatusConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

enum TradingSignalProviderTier { gold, silver, bronze }

enum TradingSignalDirection { long, short }

enum TradingSignalStatus { active, targetHit, stopped, expired }

enum TradingSignalConfidence { high, medium, low }

enum TradingSignalCategory { scalp, swing, position }

final class MarketTokenUnlocksSnapshot {
  const MarketTokenUnlocksSnapshot({
    required this.unlocks,
    required this.totalValueNext30d,
    required this.highImpactCount,
    required this.avgDilution,
    required this.impactConfigs,
    required this.categoryConfigs,
    required this.sortBy,
    required this.impactFilter,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TokenUnlockDraft> unlocks;
  final double totalValueNext30d;
  final int highImpactCount;
  final double avgDilution;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final Map<MarketUnlockCategory, UnlockCategoryConfig> categoryConfigs;
  final MarketUnlockSort sortBy;
  final MarketUnlockImpact? impactFilter;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class TokenUnlockDraft {
  const TokenUnlockDraft({
    required this.id,
    required this.symbol,
    required this.name,
    required this.color,
    required this.unlockDate,
    required this.unlockDateLabel,
    required this.daysUntil,
    required this.unlockAmount,
    required this.unlockValueUsd,
    required this.unlockPctCirculating,
    required this.totalLocked,
    required this.totalLockedValueUsd,
    required this.vestingType,
    required this.category,
    required this.impactLevel,
    required this.currentPrice,
    required this.priceChange7d,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.vestingSchedule,
  });

  final String id;
  final String symbol;
  final String name;
  final Color color;
  final String unlockDate;
  final String unlockDateLabel;
  final int daysUntil;
  final double unlockAmount;
  final double unlockValueUsd;
  final double unlockPctCirculating;
  final double totalLocked;
  final double totalLockedValueUsd;
  final MarketUnlockVestingType vestingType;
  final MarketUnlockCategory category;
  final MarketUnlockImpact impactLevel;
  final double currentPrice;
  final double priceChange7d;
  final double circulatingSupply;
  final double totalSupply;
  final List<TokenVestingEventDraft> vestingSchedule;
}

final class TokenVestingEventDraft {
  const TokenVestingEventDraft({
    required this.date,
    required this.pct,
    required this.label,
  });

  final String date;
  final double pct;
  final String label;
}

final class UnlockImpactConfig {
  const UnlockImpactConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

final class UnlockCategoryConfig {
  const UnlockCategoryConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

enum MarketUnlockSort { nearest, value, impact }

enum MarketUnlockImpact { high, medium, low }

enum MarketUnlockCategory { team, investor, ecosystem, community, foundation }

enum MarketUnlockVestingType { cliff, linear, milestone }

final class MarketAdvancedChartsSnapshot {
  const MarketAdvancedChartsSnapshot({
    required this.indicators,
    required this.drawingTools,
    required this.signalSummaries,
    required this.indicatorCategories,
    required this.drawingCategories,
    required this.activeIndicatorIds,
    required this.selectedIndicatorCategory,
    required this.selectedDrawingCategory,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TechnicalIndicator> indicators;
  final List<AdvancedDrawingTool> drawingTools;
  final List<TechSignalSummaryDraft> signalSummaries;
  final List<AdvancedChartCategory> indicatorCategories;
  final List<AdvancedChartCategory> drawingCategories;
  final Set<String> activeIndicatorIds;
  final String selectedIndicatorCategory;
  final String selectedDrawingCategory;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class AdvancedChartCategory {
  const AdvancedChartCategory({
    required this.id,
    required this.label,
    required this.color,
  });

  final String id;
  final String label;
  final Color color;
}

final class TechnicalIndicator {
  const TechnicalIndicator({
    required this.id,
    required this.name,
    required this.shortName,
    required this.categoryId,
    required this.color,
    required this.description,
    required this.params,
  });

  final String id;
  final String name;
  final String shortName;
  final String categoryId;
  final Color color;
  final String description;
  final List<TechnicalIndicatorParam> params;
}

final class TechnicalIndicatorParam {
  const TechnicalIndicatorParam({required this.label, required this.value});

  final String label;
  final int value;
}

final class AdvancedDrawingTool {
  const AdvancedDrawingTool({
    required this.id,
    required this.name,
    required this.icon,
    required this.categoryId,
  });

  final String id;
  final String name;
  final IconData icon;
  final String categoryId;
}

final class TechSignalSummaryDraft {
  const TechSignalSummaryDraft({
    required this.pair,
    required this.timeframe,
    required this.overallSignal,
    required this.maSummary,
    required this.oscSummary,
    required this.buyCount,
    required this.sellCount,
    required this.neutralCount,
    required this.pivotPoints,
  });

  final String pair;
  final String timeframe;
  final TechSignal overallSignal;
  final TechSignal maSummary;
  final TechSignal oscSummary;
  final int buyCount;
  final int sellCount;
  final int neutralCount;
  final List<TechPivotPointDraft> pivotPoints;
}

final class TechPivotPointDraft {
  const TechPivotPointDraft({required this.label, required this.value});

  final String label;
  final double value;
}

enum TechSignal { strongBuy, buy, neutral, sell, strongSell }

final class MarketNewsSnapshot {
  const MarketNewsSnapshot({
    required this.news,
    required this.breakingNews,
    required this.categories,
    required this.sentimentBadges,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.selectedCategory,
    required this.sentimentFilter,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketNewsItem> news;
  final List<MarketNewsItem> breakingNews;
  final List<MarketNewsCategory> categories;
  final Map<MarketNewsSentiment, MarketNewsSentimentBadge> sentimentBadges;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String selectedCategory;
  final MarketNewsSentiment? sentimentFilter;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

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
  final IconData icon;
  final Color iconColor;
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
  final Color color;
}

final class MarketNewsSentimentBadge {
  const MarketNewsSentimentBadge({required this.label, required this.color});

  final String label;
  final Color color;
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
    required this.color,
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
  final Color color;
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
    required this.color,
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
  final Color color;
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
    required this.color,
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
  final Color color;
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
    this.symbolColor,
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
  final Color? symbolColor;
  final String? source;
}

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

enum MarketCalendarImpact { high, medium, low }

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
}

final class MarketComparisonSnapshot {
  const MarketComparisonSnapshot({
    required this.marketPairs,
    required this.selectedPairIds,
    required this.popularPairIds,
    required this.metrics,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketPair> marketPairs;
  final List<String> selectedPairIds;
  final List<String> popularPairIds;
  final List<MarketComparisonMetric> metrics;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class MarketComparisonMetric {
  const MarketComparisonMetric({
    required this.key,
    required this.label,
    required this.format,
    this.highlight,
  });

  final String key;
  final String label;
  final MarketComparisonMetricFormat format;
  final MarketComparisonHighlight? highlight;
}

enum MarketComparisonMetricFormat { price, compact, percent, raw }

enum MarketComparisonHighlight { high, low }

final class MarketScreenerSnapshot {
  const MarketScreenerSnapshot({
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.presets,
    required this.appliedQuery,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final List<MarketScreenerPreset> presets;
  final MarketScreenerQuery appliedQuery;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class MarketScreenerPreset {
  const MarketScreenerPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.query,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final MarketScreenerQuery query;
}

final class MarketScreenerQuery {
  const MarketScreenerQuery({
    this.searchQuery = '',
    this.categories = const [],
    this.minPrice,
    this.maxPrice,
    this.minMarketCap,
    this.maxMarketCap,
    this.minVolume24h,
    this.maxVolume24h,
    this.minChange24h,
    this.maxChange24h,
    this.sortBy = MarketScreenerSort.marketCap,
    this.sortDirection = MarketSortDirection.desc,
  });

  static const defaults = MarketScreenerQuery();

  final String searchQuery;
  final List<String> categories;
  final double? minPrice;
  final double? maxPrice;
  final double? minMarketCap;
  final double? maxMarketCap;
  final double? minVolume24h;
  final double? maxVolume24h;
  final double? minChange24h;
  final double? maxChange24h;
  final MarketScreenerSort sortBy;
  final MarketSortDirection sortDirection;

  MarketScreenerQuery copyWith({
    String? searchQuery,
    List<String>? categories,
    double? minPrice,
    double? maxPrice,
    double? minMarketCap,
    double? maxMarketCap,
    double? minVolume24h,
    double? maxVolume24h,
    double? minChange24h,
    double? maxChange24h,
    MarketScreenerSort? sortBy,
    MarketSortDirection? sortDirection,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinMarketCap = false,
    bool clearMaxMarketCap = false,
    bool clearMinVolume24h = false,
    bool clearMaxVolume24h = false,
    bool clearMinChange24h = false,
    bool clearMaxChange24h = false,
  }) {
    return MarketScreenerQuery(
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      minPrice: clearMinPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
      minMarketCap: clearMinMarketCap
          ? null
          : minMarketCap ?? this.minMarketCap,
      maxMarketCap: clearMaxMarketCap
          ? null
          : maxMarketCap ?? this.maxMarketCap,
      minVolume24h: clearMinVolume24h
          ? null
          : minVolume24h ?? this.minVolume24h,
      maxVolume24h: clearMaxVolume24h
          ? null
          : maxVolume24h ?? this.maxVolume24h,
      minChange24h: clearMinChange24h
          ? null
          : minChange24h ?? this.minChange24h,
      maxChange24h: clearMaxChange24h
          ? null
          : maxChange24h ?? this.maxChange24h,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

enum MarketScreenerSort { marketCap, volume, change24h, price }

enum MarketSortDirection { asc, desc }

final class MarketAlertsSnapshot {
  const MarketAlertsSnapshot({
    required this.priceAlerts,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketPriceAlert> priceAlerts;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class MarketPriceAlert {
  const MarketPriceAlert({
    required this.id,
    required this.pairId,
    required this.symbol,
    required this.condition,
    required this.targetPrice,
    required this.currentPrice,
    required this.isActive,
    required this.createdAt,
    this.triggeredAt,
  });

  final String id;
  final String pairId;
  final String symbol;
  final MarketAlertCondition condition;
  final double targetPrice;
  final double currentPrice;
  final bool isActive;
  final String createdAt;
  final String? triggeredAt;
}

enum MarketAlertCondition { above, below }

final class MarketHeatmapSnapshot {
  const MarketHeatmapSnapshot({
    required this.coins,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.metrics,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<HeatmapCoin> coins;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final List<String> metrics;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class HeatmapCoin {
  const HeatmapCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.change7d,
    required this.marketCap,
    required this.volume24h,
    required this.category,
    required this.color,
  });

  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final double change7d;
  final double marketCap;
  final double volume24h;
  final String category;
  final Color color;
}

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

final class MarketScreenFilters {
  const MarketScreenFilters({
    required this.categories,
    required this.sortOptions,
    required this.defaultCategory,
    required this.defaultSort,
  });

  final List<String> categories;
  final List<MarketSortOption> sortOptions;
  final String defaultCategory;
  final String defaultSort;
}

final class MarketSortOption {
  const MarketSortOption({required this.id, required this.label});

  final String id;
  final String label;
}

final class MarketAlertDraft {
  const MarketAlertDraft({
    required this.id,
    required this.pairId,
    required this.label,
  });

  final String id;
  final String pairId;
  final String label;
}

enum MarketScreenState { loading, empty, error, offline, realtimeRefresh }

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
  final Color color;
  final IconData icon;
  final double totalMarketCap;
  final double change24h;
  final double change7d;
  final double change30d;
  final double volume24h;
  final List<String> topCoins;
  final int coinCount;
  final double dominance;
}

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
    required this.color,
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
  final Color color;
  final List<double> sparkline;
  final bool isNew;
  final String? listingDate;
}

final class MarketPair {
  const MarketPair({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.price,
    required this.prevPrice,
    required this.change24h,
    required this.high24h,
    required this.low24h,
    required this.volume24h,
    required this.marketCap,
    required this.sparklineData,
    required this.logoColor,
    required this.isFavorite,
    required this.category,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final double price;
  final double prevPrice;
  final double change24h;
  final double high24h;
  final double low24h;
  final double volume24h;
  final double marketCap;
  final List<double> sparklineData;
  final Color logoColor;
  final bool isFavorite;
  final String category;
}

final class MarketPairDetailSnapshot {
  const MarketPairDetailSnapshot({
    required this.pair,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.depth,
    required this.recentTrades,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final MarketPair pair;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final MarketDepthData depth;
  final List<MarketRecentTrade> recentTrades;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;

  List<double> get activeChartSeries =>
      chartSeries[pair.id] ?? pair.sparklineData;
}

final class MarketRecentTrade {
  const MarketRecentTrade({
    required this.id,
    required this.price,
    required this.amount,
    required this.time,
    required this.side,
  });

  final String id;
  final double price;
  final double amount;
  final String time;
  final MarketOrderSide side;
}

final class MarketTokenInfoSnapshot {
  const MarketTokenInfoSnapshot({
    required this.pair,
    required this.fundamentals,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final MarketPair pair;
  final TokenFundamentalsDraft fundamentals;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class TokenFundamentalsDraft {
  const TokenFundamentalsDraft({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.consensus,
    required this.network,
    required this.website,
    required this.whitepaper,
    required this.github,
    required this.twitter,
    required this.telegram,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.fullyDilutedValuation,
    required this.inflationRate,
    required this.allTimeHigh,
    required this.allTimeHighDate,
    required this.allTimeLow,
    required this.allTimeLowDate,
    required this.roi1y,
    required this.activeAddresses24h,
    required this.txCount24h,
    required this.holders,
    required this.tvl,
    required this.supplyDistribution,
    required this.contractAddresses,
  });

  final String id;
  final String symbol;
  final String name;
  final String description;
  final String consensus;
  final String network;
  final String website;
  final String whitepaper;
  final String github;
  final String twitter;
  final String telegram;
  final double circulatingSupply;
  final double totalSupply;
  final double? maxSupply;
  final double fullyDilutedValuation;
  final double inflationRate;
  final double allTimeHigh;
  final String allTimeHighDate;
  final double allTimeLow;
  final String allTimeLowDate;
  final double roi1y;
  final int activeAddresses24h;
  final int txCount24h;
  final int holders;
  final double? tvl;
  final List<SupplyDistributionDraft> supplyDistribution;
  final List<ContractAddressDraft> contractAddresses;
}

final class SupplyDistributionDraft {
  const SupplyDistributionDraft({
    required this.label,
    required this.percentage,
    required this.color,
  });

  final String label;
  final double percentage;
  final Color color;
}

final class ContractAddressDraft {
  const ContractAddressDraft({required this.network, required this.address});

  final String network;
  final String address;
}
