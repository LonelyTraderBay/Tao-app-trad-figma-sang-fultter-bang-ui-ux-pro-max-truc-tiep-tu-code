import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return const MockMarketRepository();
});

abstract interface class MarketRepository {
  MarketListSnapshot getMarketList();

  MarketOverviewSnapshot getMarketOverview();

  MarketMoversSnapshot getMarketMovers();

  MarketSectorsSnapshot getMarketSectors();

  MarketWatchlistSnapshot getMarketWatchlist();

  MarketHeatmapSnapshot getMarketHeatmap();

  MarketAlertsSnapshot getPriceAlerts();

  MarketScreenerSnapshot getMarketScreener({MarketScreenerQuery? query});

  MarketComparisonSnapshot getMarketComparison();

  MarketCalendarSnapshot getMarketCalendar({MarketCalendarQuery? query});

  MarketDerivativesSnapshot getMarketDerivatives({
    MarketDerivativesSort sortBy = MarketDerivativesSort.openInterest,
  });

  MarketDepthSnapshot getMarketDepth({
    String pairId = 'btcusdt',
    int levels = 25,
  });

  MarketSocialSentimentSnapshot getSocialSentiment({
    MarketSentimentSort sortBy = MarketSentimentSort.sentiment,
  });

  MarketPortfolioSnapshot getPortfolioTracker({
    MarketPortfolioSort sortBy = MarketPortfolioSort.value,
  });

  MarketNewsSnapshot getMarketNews({
    String category = 'all',
    MarketNewsSentiment? sentiment,
  });

  MarketAdvancedChartsSnapshot getAdvancedCharts({
    String indicatorCategory = 'all',
    String drawingCategory = 'all',
  });

  MarketTokenUnlocksSnapshot getTokenUnlocks({
    MarketUnlockSort sortBy = MarketUnlockSort.nearest,
    MarketUnlockImpact? impactFilter,
  });

  MarketSocialSignalsSnapshot getSocialSignals({
    TradingSignalStatus? statusFilter,
    TradingSignalCategory? categoryFilter,
  });

  MarketCorrelationsSnapshot getMarketCorrelations({
    MarketCorrelationTimeframe timeframe = MarketCorrelationTimeframe.d7,
    CorrelationSortOrder sortOrder = CorrelationSortOrder.high,
  });

  MarketPairDetailSnapshot getPairDetail(String pairId);

  MarketTokenInfoSnapshot getTokenInfo(String pairId);
}

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

final class MockMarketRepository implements MarketRepository {
  const MockMarketRepository();

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
          colorA: _correlationAssets[i].color,
          colorB: _correlationAssets[j].color,
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
    icon: Icons.account_balance_rounded,
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
    icon: Icons.bar_chart_rounded,
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
    icon: Icons.rocket_launch_rounded,
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
    icon: Icons.diamond_rounded,
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
    icon: Icons.account_balance_wallet_rounded,
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
    icon: Icons.link_rounded,
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

const MarketScreenFilters _marketCalendarFilters = MarketScreenFilters(
  categories: [
    'Tất cả',
    'Token Unlock',
    'Nâng cấp',
    'Airdrop',
    'Đốt token',
    'Niêm yết',
    'Báo cáo',
    'Hội nghị',
  ],
  defaultCategory: 'Tất cả',
  defaultSort: 'date',
  sortOptions: [
    MarketSortOption(id: 'high', label: 'Cao'),
    MarketSortOption(id: 'medium', label: 'Trung bình'),
    MarketSortOption(id: 'low', label: 'Thấp'),
  ],
);

const List<int> _marketDepthLevels = [15, 25, 50];

const MarketScreenFilters _advancedChartsFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Xu hướng', 'Động lượng', 'Biến động', 'Khối lượng'],
  defaultCategory: 'Tất cả',
  defaultSort: 'indicators',
  sortOptions: [
    MarketSortOption(id: 'indicators', label: 'Chỉ báo'),
    MarketSortOption(id: 'drawing', label: 'Công cụ vẽ'),
    MarketSortOption(id: 'signals', label: 'Tín hiệu kỹ thuật'),
  ],
);

const List<AdvancedChartCategory> _advancedChartIndicatorCategories = [
  AdvancedChartCategory(
    id: 'trend',
    label: 'Xu hướng',
    color: Color(0xFF3B82F6),
  ),
  AdvancedChartCategory(
    id: 'momentum',
    label: 'Động lượng',
    color: Color(0xFFF59E0B),
  ),
  AdvancedChartCategory(
    id: 'volatility',
    label: 'Biến động',
    color: Color(0xFFEC4899),
  ),
  AdvancedChartCategory(
    id: 'volume',
    label: 'Khối lượng',
    color: Color(0xFF14B8A6),
  ),
];

const List<AdvancedChartCategory> _advancedChartDrawingCategories = [
  AdvancedChartCategory(id: 'line', label: 'Đường', color: Color(0xFF3B82F6)),
  AdvancedChartCategory(
    id: 'shape',
    label: 'Hình dạng',
    color: Color(0xFF8B5CF6),
  ),
  AdvancedChartCategory(
    id: 'fib',
    label: 'Fibonacci',
    color: Color(0xFFF59E0B),
  ),
  AdvancedChartCategory(
    id: 'measure',
    label: 'Đo lường',
    color: Color(0xFF14B8A6),
  ),
];

const List<TechnicalIndicator> _advancedChartIndicators = [
  TechnicalIndicator(
    id: 'sma',
    name: 'Simple Moving Average',
    shortName: 'SMA',
    categoryId: 'trend',
    color: Color(0xFF3B82F6),
    description: 'Trung bình giá đóng cửa trong N kỳ',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 20)],
  ),
  TechnicalIndicator(
    id: 'ema',
    name: 'Exponential Moving Average',
    shortName: 'EMA',
    categoryId: 'trend',
    color: Color(0xFF8B5CF6),
    description: 'Trung bình trọng số hàm mũ, phản ứng nhanh hơn SMA',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 12)],
  ),
  TechnicalIndicator(
    id: 'boll',
    name: 'Bollinger Bands',
    shortName: 'BOLL',
    categoryId: 'volatility',
    color: Color(0xFFEC4899),
    description: 'Dải biến động quanh SMA +/- 2 độ lệch chuẩn',
    params: [
      TechnicalIndicatorParam(label: 'Chu kỳ', value: 20),
      TechnicalIndicatorParam(label: 'Sigma', value: 2),
    ],
  ),
  TechnicalIndicator(
    id: 'rsi',
    name: 'Relative Strength Index',
    shortName: 'RSI',
    categoryId: 'momentum',
    color: Color(0xFFF59E0B),
    description: 'Chỉ số sức mạnh tương đối, quá mua >70, quá bán <30',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 14)],
  ),
  TechnicalIndicator(
    id: 'macd',
    name: 'MACD',
    shortName: 'MACD',
    categoryId: 'momentum',
    color: Color(0xFF10B981),
    description: 'Chênh lệch EMA nhanh và EMA chậm, phát hiện đảo chiều',
    params: [
      TechnicalIndicatorParam(label: 'Nhanh', value: 12),
      TechnicalIndicatorParam(label: 'Chậm', value: 26),
      TechnicalIndicatorParam(label: 'Signal', value: 9),
    ],
  ),
  TechnicalIndicator(
    id: 'stoch',
    name: 'Stochastic Oscillator',
    shortName: 'STOCH',
    categoryId: 'momentum',
    color: Color(0xFF06B6D4),
    description: 'So sánh giá đóng cửa với phạm vi giá trong kỳ',
    params: [
      TechnicalIndicatorParam(label: 'K', value: 14),
      TechnicalIndicatorParam(label: 'D', value: 3),
    ],
  ),
  TechnicalIndicator(
    id: 'atr',
    name: 'Average True Range',
    shortName: 'ATR',
    categoryId: 'volatility',
    color: Color(0xFFEF4444),
    description: 'Đo lường biến động trung bình, dùng đặt stop-loss',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 14)],
  ),
  TechnicalIndicator(
    id: 'vwap',
    name: 'Volume Weighted Average Price',
    shortName: 'VWAP',
    categoryId: 'volume',
    color: Color(0xFF14B8A6),
    description: 'Giá trung bình trọng số khối lượng trong phiên',
    params: [],
  ),
  TechnicalIndicator(
    id: 'obv',
    name: 'On-Balance Volume',
    shortName: 'OBV',
    categoryId: 'volume',
    color: Color(0xFFA855F7),
    description: 'Tích lũy khối lượng theo chiều giá, phát hiện phân kỳ',
    params: [],
  ),
  TechnicalIndicator(
    id: 'ichimoku',
    name: 'Ichimoku Cloud',
    shortName: 'ICHI',
    categoryId: 'trend',
    color: Color(0xFF059669),
    description: 'Hệ thống đa chỉ số: xu hướng, hỗ trợ/kháng cự, động lượng',
    params: [
      TechnicalIndicatorParam(label: 'Tenkan', value: 9),
      TechnicalIndicatorParam(label: 'Kijun', value: 26),
      TechnicalIndicatorParam(label: 'Senkou', value: 52),
    ],
  ),
];

const List<AdvancedDrawingTool> _advancedChartDrawingTools = [
  AdvancedDrawingTool(
    id: 'trendline',
    name: 'Đường xu hướng',
    icon: Icons.timeline_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'hline',
    name: 'Đường ngang',
    icon: Icons.horizontal_rule_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'channel',
    name: 'Kênh giá',
    icon: Icons.stacked_line_chart_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'ray',
    name: 'Tia',
    icon: Icons.trending_up_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'rect',
    name: 'Hình chữ nhật',
    icon: Icons.crop_square_rounded,
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'circle',
    name: 'Hình tròn',
    icon: Icons.circle_outlined,
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'text',
    name: 'Ghi chú',
    icon: Icons.notes_rounded,
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'fib_ret',
    name: 'Fibonacci Retracement',
    icon: Icons.format_list_numbered_rounded,
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'fib_ext',
    name: 'Fibonacci Extension',
    icon: Icons.bar_chart_rounded,
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'fib_fan',
    name: 'Fibonacci Fan',
    icon: Icons.radar_rounded,
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'measure',
    name: 'Đo khoảng cách',
    icon: Icons.straighten_rounded,
    categoryId: 'measure',
  ),
  AdvancedDrawingTool(
    id: 'daterange',
    name: 'Đo thời gian',
    icon: Icons.date_range_rounded,
    categoryId: 'measure',
  ),
];

const List<TechSignalSummaryDraft> _advancedChartSignalSummaries = [
  TechSignalSummaryDraft(
    pair: 'BTC/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.strongBuy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.buy,
    buyCount: 9,
    sellCount: 2,
    neutralCount: 1,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 62100),
      TechPivotPointDraft(label: 'S2', value: 64200),
      TechPivotPointDraft(label: 'S1', value: 65800),
      TechPivotPointDraft(label: 'Pivot', value: 67000),
      TechPivotPointDraft(label: 'R1', value: 68500),
      TechPivotPointDraft(label: 'R2', value: 70100),
      TechPivotPointDraft(label: 'R3', value: 72300),
    ],
  ),
  TechSignalSummaryDraft(
    pair: 'ETH/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.buy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.neutral,
    buyCount: 7,
    sellCount: 3,
    neutralCount: 2,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 3220),
      TechPivotPointDraft(label: 'S2', value: 3340),
      TechPivotPointDraft(label: 'S1', value: 3420),
      TechPivotPointDraft(label: 'Pivot', value: 3500),
      TechPivotPointDraft(label: 'R1', value: 3580),
      TechPivotPointDraft(label: 'R2', value: 3680),
      TechPivotPointDraft(label: 'R3', value: 3800),
    ],
  ),
  TechSignalSummaryDraft(
    pair: 'SOL/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.strongBuy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.buy,
    buyCount: 10,
    sellCount: 1,
    neutralCount: 1,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 155),
      TechPivotPointDraft(label: 'S2', value: 162),
      TechPivotPointDraft(label: 'S1', value: 168),
      TechPivotPointDraft(label: 'Pivot', value: 175),
      TechPivotPointDraft(label: 'R1', value: 182),
      TechPivotPointDraft(label: 'R2', value: 190),
      TechPivotPointDraft(label: 'R3', value: 198),
    ],
  ),
];

const MarketScreenFilters _tokenUnlockFilters = MarketScreenFilters(
  categories: ['Sắp mở khóa', 'Phân tích', 'Lịch trình'],
  defaultCategory: 'Sắp mở khóa',
  defaultSort: 'nearest',
  sortOptions: [
    MarketSortOption(id: 'nearest', label: 'Gần nhất'),
    MarketSortOption(id: 'value', label: 'Giá trị cao'),
    MarketSortOption(id: 'impact', label: 'Tác động lớn'),
  ],
);

const Map<MarketUnlockImpact, UnlockImpactConfig> _unlockImpactConfigs = {
  MarketUnlockImpact.high: UnlockImpactConfig(
    label: 'Cao',
    color: AppColors.sell,
  ),
  MarketUnlockImpact.medium: UnlockImpactConfig(
    label: 'Trung bình',
    color: AppColors.warn,
  ),
  MarketUnlockImpact.low: UnlockImpactConfig(
    label: 'Thấp',
    color: AppColors.buy,
  ),
};

const Map<MarketUnlockCategory, UnlockCategoryConfig> _unlockCategoryConfigs = {
  MarketUnlockCategory.team: UnlockCategoryConfig(
    label: 'Team',
    color: Color(0xFF3B82F6),
  ),
  MarketUnlockCategory.investor: UnlockCategoryConfig(
    label: 'Nhà đầu tư',
    color: AppColors.sell,
  ),
  MarketUnlockCategory.ecosystem: UnlockCategoryConfig(
    label: 'Hệ sinh thái',
    color: AppColors.buy,
  ),
  MarketUnlockCategory.community: UnlockCategoryConfig(
    label: 'Cộng đồng',
    color: AppColors.warn,
  ),
  MarketUnlockCategory.foundation: UnlockCategoryConfig(
    label: 'Quỹ',
    color: AppColors.accent,
  ),
};

const List<TokenUnlockDraft> _tokenUnlocks = [
  TokenUnlockDraft(
    id: 'u1',
    symbol: 'ARB',
    name: 'Arbitrum',
    color: Color(0xFF28A0F0),
    unlockDate: '2026-03-16',
    unlockDateLabel: '16 Th3 2026',
    daysUntil: 5,
    unlockAmount: 92650000,
    unlockValueUsd: 120445000,
    unlockPctCirculating: 2.8,
    totalLocked: 3240000000,
    totalLockedValueUsd: 4212000000,
    vestingType: MarketUnlockVestingType.cliff,
    category: MarketUnlockCategory.investor,
    impactLevel: MarketUnlockImpact.high,
    currentPrice: 1.30,
    priceChange7d: -4.2,
    circulatingSupply: 3340000000,
    totalSupply: 10000000000,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '03/2026',
        pct: 2.8,
        label: 'Investor cliff',
      ),
      TokenVestingEventDraft(date: '06/2026', pct: 3.5, label: 'Team vesting'),
      TokenVestingEventDraft(
        date: '09/2026',
        pct: 2.1,
        label: 'Advisor vesting',
      ),
      TokenVestingEventDraft(
        date: '12/2026',
        pct: 4.2,
        label: 'Ecosystem fund',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u2',
    symbol: 'OP',
    name: 'Optimism',
    color: Color(0xFFFF0420),
    unlockDate: '2026-03-20',
    unlockDateLabel: '20 Th3 2026',
    daysUntil: 9,
    unlockAmount: 31340000,
    unlockValueUsd: 62680000,
    unlockPctCirculating: 1.9,
    totalLocked: 2890000000,
    totalLockedValueUsd: 5780000000,
    vestingType: MarketUnlockVestingType.linear,
    category: MarketUnlockCategory.team,
    impactLevel: MarketUnlockImpact.medium,
    currentPrice: 2.00,
    priceChange7d: -1.8,
    circulatingSupply: 1640000000,
    totalSupply: 4294967296,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '03/2026',
        pct: 1.9,
        label: 'Core contributor',
      ),
      TokenVestingEventDraft(
        date: '04/2026',
        pct: 1.9,
        label: 'Core contributor',
      ),
      TokenVestingEventDraft(
        date: '05/2026',
        pct: 1.9,
        label: 'Core contributor',
      ),
      TokenVestingEventDraft(
        date: '06/2026',
        pct: 2.4,
        label: 'Investor unlock',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u3',
    symbol: 'APT',
    name: 'Aptos',
    color: Color(0xFF00BFA5),
    unlockDate: '2026-03-12',
    unlockDateLabel: '12 Th3 2026',
    daysUntil: 1,
    unlockAmount: 11310000,
    unlockValueUsd: 96135000,
    unlockPctCirculating: 2.4,
    totalLocked: 567000000,
    totalLockedValueUsd: 4819500000,
    vestingType: MarketUnlockVestingType.linear,
    category: MarketUnlockCategory.foundation,
    impactLevel: MarketUnlockImpact.high,
    currentPrice: 8.50,
    priceChange7d: -6.1,
    circulatingSupply: 472000000,
    totalSupply: 1084577833,
    vestingSchedule: [
      TokenVestingEventDraft(date: '03/2026', pct: 2.4, label: 'Foundation'),
      TokenVestingEventDraft(date: '04/2026', pct: 2.4, label: 'Foundation'),
      TokenVestingEventDraft(date: '05/2026', pct: 1.8, label: 'Community'),
      TokenVestingEventDraft(
        date: '06/2026',
        pct: 3.1,
        label: 'Investor cliff',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u4',
    symbol: 'SUI',
    name: 'Sui',
    color: Color(0xFF4DA2FF),
    unlockDate: '2026-04-01',
    unlockDateLabel: '01 Th4 2026',
    daysUntil: 21,
    unlockAmount: 64190000,
    unlockValueUsd: 96285000,
    unlockPctCirculating: 2.6,
    totalLocked: 5420000000,
    totalLockedValueUsd: 8130000000,
    vestingType: MarketUnlockVestingType.cliff,
    category: MarketUnlockCategory.investor,
    impactLevel: MarketUnlockImpact.medium,
    currentPrice: 1.50,
    priceChange7d: 3.2,
    circulatingSupply: 2480000000,
    totalSupply: 10000000000,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '04/2026',
        pct: 2.6,
        label: 'Investor unlock',
      ),
      TokenVestingEventDraft(date: '07/2026', pct: 3.8, label: 'Team vesting'),
      TokenVestingEventDraft(
        date: '10/2026',
        pct: 2.2,
        label: 'Community rewards',
      ),
      TokenVestingEventDraft(date: '01/2027', pct: 4.5, label: 'Foundation'),
    ],
  ),
  TokenUnlockDraft(
    id: 'u5',
    symbol: 'TIA',
    name: 'Celestia',
    color: Color(0xFF7B2BF9),
    unlockDate: '2026-03-25',
    unlockDateLabel: '25 Th3 2026',
    daysUntil: 14,
    unlockAmount: 18500000,
    unlockValueUsd: 148000000,
    unlockPctCirculating: 8.2,
    totalLocked: 818000000,
    totalLockedValueUsd: 6544000000,
    vestingType: MarketUnlockVestingType.cliff,
    category: MarketUnlockCategory.investor,
    impactLevel: MarketUnlockImpact.high,
    currentPrice: 8.00,
    priceChange7d: -8.5,
    circulatingSupply: 226000000,
    totalSupply: 1044000000,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '03/2026',
        pct: 8.2,
        label: 'Major investor cliff',
      ),
      TokenVestingEventDraft(date: '06/2026', pct: 5.1, label: 'Team cliff'),
      TokenVestingEventDraft(date: '09/2026', pct: 3.4, label: 'Ecosystem'),
      TokenVestingEventDraft(
        date: '10/2026',
        pct: 12.0,
        label: 'Investor cliff 2',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u6',
    symbol: 'STRK',
    name: 'Starknet',
    color: Color(0xFFFF4F00),
    unlockDate: '2026-04-15',
    unlockDateLabel: '15 Th4 2026',
    daysUntil: 35,
    unlockAmount: 127000000,
    unlockValueUsd: 88900000,
    unlockPctCirculating: 5.4,
    totalLocked: 7280000000,
    totalLockedValueUsd: 5096000000,
    vestingType: MarketUnlockVestingType.linear,
    category: MarketUnlockCategory.team,
    impactLevel: MarketUnlockImpact.medium,
    currentPrice: .70,
    priceChange7d: 1.2,
    circulatingSupply: 2350000000,
    totalSupply: 10000000000,
    vestingSchedule: [
      TokenVestingEventDraft(date: '04/2026', pct: 5.4, label: 'Team linear'),
      TokenVestingEventDraft(date: '05/2026', pct: 5.4, label: 'Team linear'),
      TokenVestingEventDraft(date: '06/2026', pct: 5.4, label: 'Team linear'),
      TokenVestingEventDraft(date: '07/2026', pct: 3.2, label: 'Ecosystem'),
    ],
  ),
];

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
    color: AppColors.warn,
    background: AppColors.warn10,
  ),
  TradingSignalProviderTier.silver: SignalTierConfig(
    label: 'Bạc',
    color: Color(0xFF94A3B8),
    background: Color(0x1A94A3B8),
  ),
  TradingSignalProviderTier.bronze: SignalTierConfig(
    label: 'Đồng',
    color: Color(0xFFD97706),
    background: Color(0x1AD97706),
  ),
};

const Map<TradingSignalStatus, SignalStatusConfig> _signalStatusConfigs = {
  TradingSignalStatus.active: SignalStatusConfig(
    label: 'Đang hoạt động',
    color: Color(0xFF3B82F6),
  ),
  TradingSignalStatus.targetHit: SignalStatusConfig(
    label: 'Đạt mục tiêu',
    color: AppColors.buy,
  ),
  TradingSignalStatus.stopped: SignalStatusConfig(
    label: 'Dừng lỗ',
    color: AppColors.sell,
  ),
  TradingSignalStatus.expired: SignalStatusConfig(
    label: 'Hết hạn',
    color: Color(0xFF6B7280),
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
  CorrelationAsset(symbol: 'BTC', color: Color(0xFFF7931A)),
  CorrelationAsset(symbol: 'ETH', color: Color(0xFF627EEA)),
  CorrelationAsset(symbol: 'SOL', color: Color(0xFF9945FF)),
  CorrelationAsset(symbol: 'BNB', color: Color(0xFFF3BA2F)),
  CorrelationAsset(symbol: 'XRP', color: Color(0xFF00AAE4)),
  CorrelationAsset(symbol: 'ADA', color: Color(0xFF0033AD)),
  CorrelationAsset(symbol: 'AVAX', color: Color(0xFFE84142)),
  CorrelationAsset(symbol: 'LINK', color: Color(0xFF2A5ADA)),
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

const MarketScreenFilters _marketPortfolioFilters = MarketScreenFilters(
  categories: ['Tổng quan', 'Tài sản', 'Hiệu suất'],
  defaultCategory: 'Tổng quan',
  defaultSort: 'value',
  sortOptions: [
    MarketSortOption(id: 'value', label: 'Giá trị'),
    MarketSortOption(id: 'pnl', label: 'Lãi/Lỗ'),
    MarketSortOption(id: 'change', label: 'Thay đổi 24h'),
  ],
);

const MarketScreenFilters _marketNewsFilters = MarketScreenFilters(
  categories: [
    'Tất cả',
    'Nóng',
    'Bitcoin',
    'Altcoin',
    'DeFi',
    'Vĩ mô',
    'Pháp lý',
    'Phân tích',
    'NFT',
  ],
  defaultCategory: 'Tất cả',
  defaultSort: 'latest',
  sortOptions: [
    MarketSortOption(id: 'bullish', label: 'Tích cực'),
    MarketSortOption(id: 'neutral', label: 'Trung lập'),
    MarketSortOption(id: 'bearish', label: 'Tiêu cực'),
  ],
);

const List<MarketNewsCategory> _marketNewsCategories = [
  MarketNewsCategory(id: 'all', label: 'Tất cả', color: Color(0xFF6B7280)),
  MarketNewsCategory(id: 'breaking', label: 'Nóng', color: AppColors.sell),
  MarketNewsCategory(id: 'bitcoin', label: 'Bitcoin', color: Color(0xFFF7931A)),
  MarketNewsCategory(id: 'altcoin', label: 'Altcoin', color: AppColors.accent),
  MarketNewsCategory(id: 'defi', label: 'DeFi', color: Color(0xFF3B82F6)),
  MarketNewsCategory(id: 'macro', label: 'Vĩ mô', color: Color(0xFF64748B)),
  MarketNewsCategory(id: 'regulation', label: 'Pháp lý', color: AppColors.warn),
  MarketNewsCategory(id: 'analysis', label: 'Phân tích', color: AppColors.buy),
  MarketNewsCategory(id: 'nft', label: 'NFT', color: Color(0xFFEC4899)),
];

const Map<MarketNewsSentiment, MarketNewsSentimentBadge>
_marketNewsSentimentBadges = {
  MarketNewsSentiment.bullish: MarketNewsSentimentBadge(
    label: 'Tích cực',
    color: AppColors.buy,
  ),
  MarketNewsSentiment.neutral: MarketNewsSentimentBadge(
    label: 'Trung lập',
    color: AppColors.text3,
  ),
  MarketNewsSentiment.bearish: MarketNewsSentimentBadge(
    label: 'Tiêu cực',
    color: AppColors.sell,
  ),
};

const List<MarketNewsItem> _marketNews = [
  MarketNewsItem(
    id: 'n1',
    title: 'Bitcoin ETF ghi nhan dong tien vao ky luc \$1.2B trong 1 ngay',
    summary:
        'Cac quy ETF Bitcoin spot tai My da ghi nhan dong tien vao rong lon nhat tu khi ra mat, cho thay nhu cau to chuc tang manh.',
    source: 'CoinDesk',
    timeAgo: '15 phut truoc',
    category: 'bitcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['BTC'],
    icon: Icons.show_chart_rounded,
    iconColor: Color(0xFF93C5FD),
    isBreaking: true,
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n2',
    title: 'Ethereum Pectra upgrade xac nhan ngay 15/3 — nhung thay doi lon',
    summary:
        'Nang cap Pectra mang den EIP-7251 tang gioi han staking va EIP-7702 cho account abstraction, se anh huong lon den he sinh thai.',
    source: 'The Block',
    timeAgo: '45 phut truoc',
    category: 'altcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['ETH', 'ARB', 'OP'],
    icon: Icons.upload_rounded,
    iconColor: Color(0xFF60A5FA),
    readTime: '5 phut',
  ),
  MarketNewsItem(
    id: 'n3',
    title: 'SEC My co the phe duyet ETF Solana trong quy 2 — phan tich',
    summary:
        'Cac chuyen gia phap ly nhan dinh SEC co the xem xet don xin ETF Solana som hon du kien sau thanh cong cua BTC ETF.',
    source: 'Bloomberg',
    timeAgo: '1 gio truoc',
    category: 'regulation',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['SOL'],
    icon: Icons.balance_rounded,
    iconColor: AppColors.warn,
    readTime: '4 phut',
  ),
  MarketNewsItem(
    id: 'n4',
    title: 'TVL DeFi vuot \$120B — muc cao nhat ke tu 2022',
    summary:
        'Tong gia tri khoa trong DeFi dat muc cao nhat trong 2 nam, dan dau boi Aave, Lido va cac giao thuc restaking moi.',
    source: 'DeFi Llama',
    timeAgo: '2 gio truoc',
    category: 'defi',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['ETH', 'LINK', 'AAVE'],
    icon: Icons.account_balance_rounded,
    iconColor: Color(0xFFCBD5E1),
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n5',
    title: 'Lam phat My thang 2 cao hon du kien — crypto giam nhe',
    summary:
        'CPI thang 2 dat 3.2% YoY, cao hon du kien 3.1%, khien thi truong lo ngai Fed se giu lai suat lau hon.',
    source: 'Reuters',
    timeAgo: '3 gio truoc',
    category: 'macro',
    sentiment: MarketNewsSentiment.bearish,
    relatedTokens: ['BTC', 'ETH'],
    icon: Icons.bar_chart_rounded,
    iconColor: Color(0xFF94A3B8),
    readTime: '4 phut',
  ),
  MarketNewsItem(
    id: 'n6',
    title: 'Solana Firedancer dat 1 trieu TPS tren testnet',
    summary:
        'Client moi Firedancer cua Jump Crypto dat ky luc xu ly 1 trieu giao dich/giay tren moi truong thu nghiem.',
    source: 'Solana Blog',
    timeAgo: '4 gio truoc',
    category: 'altcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['SOL'],
    icon: Icons.local_fire_department_rounded,
    iconColor: AppColors.warn,
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n7',
    title: 'Binance dot 1.5 trieu BNB — gia tri gan \$620M',
    summary:
        'Dot token BNB hang quy lan thu 27 da hoan thanh, loai bo vinh vien 1.5 trieu BNB khoi luu thong.',
    source: 'Binance',
    timeAgo: '5 gio truoc',
    category: 'altcoin',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['BNB'],
    icon: Icons.local_fire_department_rounded,
    iconColor: AppColors.warn,
    readTime: '2 phut',
  ),
  MarketNewsItem(
    id: 'n8',
    title: 'Chainlink CCIP V2 ho tro 20+ blockchains — chi tiet',
    summary:
        'Phien ban moi cua Cross-Chain Interoperability Protocol mang den ho tro nhieu chuoi hon va giam 40% phi bridge.',
    source: 'Chainlink Blog',
    timeAgo: '6 gio truoc',
    category: 'defi',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['LINK'],
    icon: Icons.link_rounded,
    iconColor: Color(0xFFCBD5E1),
    readTime: '5 phut',
  ),
  MarketNewsItem(
    id: 'n9',
    title: 'Ca voi BTC chuyen \$450M ve san — tin hieu ban?',
    summary:
        'Du lieu on-chain cho thay mot vi ca voi da chuyen 6,700 BTC ve Coinbase, tao lo ngai ap luc ban.',
    source: 'Whale Alert',
    timeAgo: '7 gio truoc',
    category: 'bitcoin',
    sentiment: MarketNewsSentiment.bearish,
    relatedTokens: ['BTC'],
    icon: Icons.water_drop_rounded,
    iconColor: Color(0xFF38BDF8),
    readTime: '3 phut',
  ),
  MarketNewsItem(
    id: 'n10',
    title: 'NFT marketplace OpenSea ra mat phien ban moi hoan toan',
    summary:
        'OpenSea 2.0 gioi thieu giao dien moi, ho tro da chuoi tot hon va giam phi giao dich xuong 1%.',
    source: 'OpenSea Blog',
    timeAgo: '8 gio truoc',
    category: 'nft',
    sentiment: MarketNewsSentiment.neutral,
    relatedTokens: ['ETH', 'SOL'],
    icon: Icons.palette_rounded,
    iconColor: Color(0xFFF472B6),
    readTime: '4 phut',
  ),
  MarketNewsItem(
    id: 'n11',
    title: 'EU ap dung MiCA day du tu thang 4 — anh huong gi?',
    summary:
        'Khung phap ly Markets in Crypto-Assets se co hieu luc toan phan, yeu cau cac san giao dich phai dang ky giay phep.',
    source: 'CoinTelegraph',
    timeAgo: '10 gio truoc',
    category: 'regulation',
    sentiment: MarketNewsSentiment.neutral,
    relatedTokens: ['BTC', 'ETH', 'USDT'],
    icon: Icons.account_balance_rounded,
    iconColor: Color(0xFFE5E7EB),
    readTime: '6 phut',
  ),
  MarketNewsItem(
    id: 'n12',
    title: 'Phan tich: Altcoin season sap bat dau?',
    summary:
        'Chi so Altcoin Season Index dat 68/100, nhieu altcoin lon outperform BTC trong 7 ngay qua. Chuyen gia nhan dinh xu huong se tiep tuc.',
    source: 'Messari',
    timeAgo: '12 gio truoc',
    category: 'analysis',
    sentiment: MarketNewsSentiment.bullish,
    relatedTokens: ['SOL', 'AVAX', 'MATIC'],
    icon: Icons.bar_chart_rounded,
    iconColor: Color(0xFF94A3B8),
    readTime: '5 phut',
  ),
];

const PortfolioStats _portfolioStats = PortfolioStats(
  totalValue: 56279.10,
  totalPnl: 7140.30,
  totalPnlPct: 14.53,
  totalCost: 49138.80,
  best24hSymbol: 'SOL',
  best24hChange: 8.07,
  worst24hSymbol: 'ETH',
  worst24hChange: -1.23,
  stableAllocation: 22.2,
);

const List<PortfolioHolding> _portfolioHoldings = [
  PortfolioHolding(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    color: Color(0xFFF7931A),
    quantity: 0.23451,
    avgBuyPrice: 58200,
    currentPrice: 67543.21,
    value: 15839.84,
    pnl: 2190.84,
    pnlPct: 16.04,
    allocation: 28.2,
    change24h: 2.34,
    sparkline: [65100, 65800, 66500, 67000, 67200, 67543],
  ),
  PortfolioHolding(
    id: 'eth',
    symbol: 'ETH',
    name: 'Ethereum',
    color: Color(0xFF627EEA),
    quantity: 3.521,
    avgBuyPrice: 3200,
    currentPrice: 3521.45,
    value: 12400.02,
    pnl: 1132.02,
    pnlPct: 10.05,
    allocation: 22.1,
    change24h: -1.23,
    sparkline: [3565, 3555, 3540, 3530, 3525, 3521],
  ),
  PortfolioHolding(
    id: 'usdt',
    symbol: 'USDT',
    name: 'Tether',
    color: Color(0xFF26A17B),
    quantity: 12450.80,
    avgBuyPrice: 1,
    currentPrice: 1,
    value: 12450.80,
    pnl: 0,
    pnlPct: 0,
    allocation: 22.2,
    change24h: 0.01,
    sparkline: [1, 1, 1, 1, 1, 1],
  ),
  PortfolioHolding(
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    color: Color(0xFF9945FF),
    quantity: 45.8,
    avgBuyPrice: 120,
    currentPrice: 178.32,
    value: 8167.06,
    pnl: 2671.06,
    pnlPct: 48.60,
    allocation: 14.5,
    change24h: 8.07,
    sparkline: [165, 168, 172, 175, 178, 178.32],
  ),
  PortfolioHolding(
    id: 'bnb',
    symbol: 'BNB',
    name: 'BNB',
    color: Color(0xFFF3BA2F),
    quantity: 12.5,
    avgBuyPrice: 350,
    currentPrice: 412.87,
    value: 5160.88,
    pnl: 785.88,
    pnlPct: 17.97,
    allocation: 9.2,
    change24h: 3.61,
    sparkline: [398, 402, 407, 410, 412, 412.87],
  ),
  PortfolioHolding(
    id: 'ada',
    symbol: 'ADA',
    name: 'Cardano',
    color: Color(0xFF0033AD),
    quantity: 5000,
    avgBuyPrice: 0.38,
    currentPrice: 0.4521,
    value: 2260.50,
    pnl: 360.50,
    pnlPct: 18.97,
    allocation: 4.0,
    change24h: 3.22,
    sparkline: [0.44, 0.445, 0.448, 0.450, 0.451, 0.4521],
  ),
];

const List<PortfolioPerformancePoint> _portfolioPerformance = [
  PortfolioPerformancePoint(date: '30d trước', value: 48500),
  PortfolioPerformancePoint(date: '25d trước', value: 49200),
  PortfolioPerformancePoint(date: '20d trước', value: 50100),
  PortfolioPerformancePoint(date: '15d trước', value: 49800),
  PortfolioPerformancePoint(date: '10d trước', value: 51400),
  PortfolioPerformancePoint(date: '7d trước', value: 52800),
  PortfolioPerformancePoint(date: '5d trước', value: 53600),
  PortfolioPerformancePoint(date: '3d trước', value: 54900),
  PortfolioPerformancePoint(date: 'Hôm qua', value: 55100),
  PortfolioPerformancePoint(date: 'Hôm nay', value: 56279),
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
    color: Color(0xFFF7931A),
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
    color: Color(0xFF627EEA),
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
    color: Color(0xFF9945FF),
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
    color: Color(0xFF00AAE4),
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
    color: Color(0xFFC3A634),
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
    color: Color(0xFF2A5ADA),
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
    color: Color(0xFFE84142),
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
    color: Color(0xFFF3BA2F),
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

const MarketScreenFilters _marketDepthFilters = MarketScreenFilters(
  categories: ['Depth Chart', 'Order Book', 'Whale Alert'],
  defaultCategory: 'Depth Chart',
  defaultSort: '25L',
  sortOptions: [
    MarketSortOption(id: '15', label: '15L'),
    MarketSortOption(id: '25', label: '25L'),
    MarketSortOption(id: '50', label: '50L'),
  ],
);

const List<double> _depthBidPattern = [
  2.1,
  3.5,
  1.8,
  5.2,
  2.7,
  1.3,
  4.8,
  2.2,
  6.1,
  3.3,
  1.5,
  2.9,
  7.4,
  2.1,
  3.8,
  1.6,
  4.2,
  2.8,
  1.9,
  12.5,
  3.1,
  2.4,
  1.7,
  3.6,
  2.3,
];

const List<double> _depthAskPattern = [
  1.9,
  2.8,
  4.1,
  1.6,
  3.2,
  2.5,
  1.4,
  5.6,
  2.9,
  1.8,
  3.7,
  2.1,
  1.3,
  4.5,
  2.6,
  8.9,
  1.7,
  3.4,
  2.2,
  1.5,
  2.8,
  3.1,
  1.9,
  2.4,
  4.7,
];

const MarketCalendarStats _marketCalendarStats = MarketCalendarStats(
  upcoming: 12,
  highImpact: 6,
  thisWeek: 7,
);

const List<MarketCalendarEvent> _marketEvents = [
  MarketCalendarEvent(
    id: 'ev7',
    title: 'WLD niêm yết trên Coinbase',
    type: MarketCalendarEventType.listing,
    dateIso: '2026-03-11T18:00:00Z',
    symbol: 'WLD',
    symbolColor: Color(0xFF1D1D1B),
    impact: MarketCalendarImpact.medium,
    description: 'Worldcoin (WLD) sẽ được list trên Coinbase với cặp WLD/USD.',
    source: 'Coinbase Blog',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev1',
    title: 'Mở khóa ARB',
    type: MarketCalendarEventType.unlock,
    dateIso: '2026-03-12T08:00:00Z',
    symbol: 'ARB',
    symbolColor: Color(0xFF28A0F0),
    impact: MarketCalendarImpact.high,
    description:
        '92.65M ARB mở khóa từ investor và team, khoảng 3.49% tổng cung.',
    source: 'TokenUnlocks.app',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev11',
    title: 'Báo cáo CPI Mỹ',
    type: MarketCalendarEventType.report,
    dateIso: '2026-03-12T12:30:00Z',
    impact: MarketCalendarImpact.high,
    description:
        'Báo cáo chỉ số giá tiêu dùng tháng 2 của Mỹ, dự kiến 3.1% YoY.',
    source: 'Bureau of Labor Statistics',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev6',
    title: 'Mở khóa MATIC',
    type: MarketCalendarEventType.unlock,
    dateIso: '2026-03-13T08:00:00Z',
    symbol: 'MATIC',
    symbolColor: Color(0xFF8247E5),
    impact: MarketCalendarImpact.medium,
    description: '200M MATIC mở khóa từ quỹ phát triển ecosystem.',
    source: 'TokenUnlocks.app',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev3',
    title: 'Airdrop PYTH Mùa 2',
    type: MarketCalendarEventType.airdrop,
    dateIso: '2026-03-14T00:00:00Z',
    symbol: 'PYTH',
    symbolColor: Color(0xFF6B21A8),
    impact: MarketCalendarImpact.medium,
    description: 'Đợt phát hành airdrop thứ 2 cho người dùng DeFi và staker.',
    source: 'pyth.network',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev2',
    title: 'Nâng cấp Ethereum Pectra',
    type: MarketCalendarEventType.upgrade,
    dateIso: '2026-03-15T14:00:00Z',
    symbol: 'ETH',
    symbolColor: Color(0xFF627EEA),
    impact: MarketCalendarImpact.high,
    description: 'Nâng cấp Pectra bao gồm EIP-7251 và EIP-7702.',
    source: 'ethereum.org',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev4',
    title: 'Đốt BNB Hàng Quý',
    type: MarketCalendarEventType.burn,
    dateIso: '2026-03-18T12:00:00Z',
    symbol: 'BNB',
    symbolColor: Color(0xFFF3BA2F),
    impact: MarketCalendarImpact.medium,
    description: 'Đợt BNB định kỳ hàng quý, ước tính 1.5M BNB sẽ bị đốt.',
    source: 'bnbchain.org',
    confirmed: false,
  ),
  MarketCalendarEvent(
    id: 'ev12',
    title: 'Họp FOMC',
    type: MarketCalendarEventType.report,
    dateIso: '2026-03-19T18:00:00Z',
    impact: MarketCalendarImpact.high,
    description:
        'Cuộc họp Fed quyết định lãi suất. Thị trường dự đoán giữ nguyên.',
    source: 'Federal Reserve',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev5',
    title: 'Solana Firedancer Mainnet',
    type: MarketCalendarEventType.upgrade,
    dateIso: '2026-03-20T16:00:00Z',
    symbol: 'SOL',
    symbolColor: Color(0xFF9945FF),
    impact: MarketCalendarImpact.high,
    description:
        'Client Firedancer ra mắt mainnet, tập trung cải thiện hiệu suất mạng.',
    source: 'solana.com',
    confirmed: false,
  ),
  MarketCalendarEvent(
    id: 'ev8',
    title: 'Hội nghị Token2049 Dubai',
    type: MarketCalendarEventType.conference,
    dateIso: '2026-03-22T09:00:00Z',
    impact: MarketCalendarImpact.low,
    description:
        'Hội nghị blockchain lớn tại MENA, dự kiến 10,000+ người tham dự.',
    source: 'token2049.com',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev9',
    title: 'Mở khóa OP',
    type: MarketCalendarEventType.unlock,
    dateIso: '2026-03-25T08:00:00Z',
    symbol: 'OP',
    symbolColor: Color(0xFFFF0420),
    impact: MarketCalendarImpact.high,
    description: '31.3M OP mở khóa từ core contributors và investors.',
    source: 'TokenUnlocks.app',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev10',
    title: 'Chainlink CCIP V2 Launch',
    type: MarketCalendarEventType.upgrade,
    dateIso: '2026-03-28T14:00:00Z',
    symbol: 'LINK',
    symbolColor: Color(0xFF2A5ADA),
    impact: MarketCalendarImpact.medium,
    description:
        'Cross-Chain Interoperability Protocol v2 hỗ trợ hơn 20 chains.',
    source: 'chain.link',
    confirmed: false,
  ),
];

const MarketScreenFilters _marketDerivativesFilters = MarketScreenFilters(
  categories: ['Tổng quan', 'Perpetual', 'Thanh lý'],
  defaultCategory: 'Tổng quan',
  defaultSort: 'openInterest',
  sortOptions: [
    MarketSortOption(id: 'openInterest', label: 'OI'),
    MarketSortOption(id: 'volume', label: 'Volume'),
    MarketSortOption(id: 'funding', label: 'Funding'),
    MarketSortOption(id: 'change', label: 'Thay đổi'),
  ],
);

const DerivativesGlobalStats _derivativesGlobalStats = DerivativesGlobalStats(
  totalOpenInterest: 45678901000,
  oiChange24h: 3.45,
  totalVolume24h: 98765432000,
  volumeChange24h: 12.34,
  totalLiquidations24h: 234567000,
  longLiquidations24h: 156789000,
  shortLiquidations24h: 77778000,
  avgFundingRate: 0.0065,
  btcLongShortRatio: 1.18,
  fearGreedDerivatives: 68,
);

const List<LiquidationPoint> _liquidationHistory = [
  LiquidationPoint(time: '00:00', long: 12345, short: 8901),
  LiquidationPoint(time: '04:00', long: 8901, short: 15678),
  LiquidationPoint(time: '08:00', long: 23456, short: 5678),
  LiquidationPoint(time: '12:00', long: 15678, short: 12345),
  LiquidationPoint(time: '16:00', long: 9012, short: 18901),
  LiquidationPoint(time: '20:00', long: 18901, short: 9012),
  LiquidationPoint(time: 'Hiện tại', long: 15432, short: 11234),
];

const List<DerivativePair> _derivativePairs = [
  DerivativePair(
    id: 'btc-perp',
    symbol: 'BTC/USDT',
    name: 'Bitcoin',
    price: 67589.45,
    change24h: 2.41,
    indexPrice: 67543.21,
    markPrice: 67567.89,
    fundingRate: 0.0087,
    fundingInterval: '8h',
    openInterest: 12345678000,
    openInterestChange24h: 5.67,
    volume24h: 45678901000,
    longRatio: 54.2,
    shortRatio: 45.8,
    longLiquidations24h: 23456000,
    shortLiquidations24h: 18901000,
    color: Color(0xFFF7931A),
    maxLeverage: 125,
  ),
  DerivativePair(
    id: 'eth-perp',
    symbol: 'ETH/USDT',
    name: 'Ethereum',
    price: 3524.67,
    change24h: -1.12,
    indexPrice: 3521.45,
    markPrice: 3523.01,
    fundingRate: -0.0034,
    fundingInterval: '8h',
    openInterest: 6789012000,
    openInterestChange24h: -2.34,
    volume24h: 18901234000,
    longRatio: 47.8,
    shortRatio: 52.2,
    longLiquidations24h: 12345000,
    shortLiquidations24h: 8901000,
    color: Color(0xFF627EEA),
    maxLeverage: 100,
  ),
  DerivativePair(
    id: 'sol-perp',
    symbol: 'SOL/USDT',
    name: 'Solana',
    price: 178.89,
    change24h: 8.23,
    indexPrice: 178.32,
    markPrice: 178.56,
    fundingRate: 0.0156,
    fundingInterval: '8h',
    openInterest: 2345678000,
    openInterestChange24h: 12.45,
    volume24h: 6789012000,
    longRatio: 62.3,
    shortRatio: 37.7,
    longLiquidations24h: 5678000,
    shortLiquidations24h: 15432000,
    color: Color(0xFF9945FF),
    maxLeverage: 75,
  ),
  DerivativePair(
    id: 'bnb-perp',
    symbol: 'BNB/USDT',
    name: 'BNB',
    price: 413.21,
    change24h: 3.72,
    indexPrice: 412.87,
    markPrice: 413.05,
    fundingRate: 0.0045,
    fundingInterval: '8h',
    openInterest: 1234567000,
    openInterestChange24h: 3.21,
    volume24h: 3456789000,
    longRatio: 55.1,
    shortRatio: 44.9,
    longLiquidations24h: 2345000,
    shortLiquidations24h: 3456000,
    color: Color(0xFFF3BA2F),
    maxLeverage: 75,
  ),
  DerivativePair(
    id: 'xrp-perp',
    symbol: 'XRP/USDT',
    name: 'Ripple',
    price: 0.6245,
    change24h: -2.48,
    indexPrice: 0.6234,
    markPrice: 0.6238,
    fundingRate: -0.0078,
    fundingInterval: '8h',
    openInterest: 890123000,
    openInterestChange24h: -4.56,
    volume24h: 2345678000,
    longRatio: 43.5,
    shortRatio: 56.5,
    longLiquidations24h: 4567000,
    shortLiquidations24h: 1234000,
    color: Color(0xFF00AAE4),
    maxLeverage: 75,
  ),
  DerivativePair(
    id: 'doge-perp',
    symbol: 'DOGE/USDT',
    name: 'Dogecoin',
    price: 0.1234,
    change24h: 5.67,
    indexPrice: 0.1230,
    markPrice: 0.1232,
    fundingRate: 0.0234,
    fundingInterval: '8h',
    openInterest: 567890000,
    openInterestChange24h: 8.90,
    volume24h: 1890123000,
    longRatio: 67.8,
    shortRatio: 32.2,
    longLiquidations24h: 1234000,
    shortLiquidations24h: 5678000,
    color: Color(0xFFC3A634),
    maxLeverage: 50,
  ),
  DerivativePair(
    id: 'avax-perp',
    symbol: 'AVAX/USDT',
    name: 'Avalanche',
    price: 38.67,
    change24h: 4.89,
    indexPrice: 38.54,
    markPrice: 38.60,
    fundingRate: 0.0067,
    fundingInterval: '8h',
    openInterest: 456789000,
    openInterestChange24h: 6.78,
    volume24h: 1234567000,
    longRatio: 58.4,
    shortRatio: 41.6,
    longLiquidations24h: 890000,
    shortLiquidations24h: 2345000,
    color: Color(0xFFE84142),
    maxLeverage: 50,
  ),
  DerivativePair(
    id: 'link-perp',
    symbol: 'LINK/USDT',
    name: 'Chainlink',
    price: 14.28,
    change24h: -5.65,
    indexPrice: 14.23,
    markPrice: 14.25,
    fundingRate: -0.0123,
    fundingInterval: '8h',
    openInterest: 345678000,
    openInterestChange24h: -7.89,
    volume24h: 890123000,
    longRatio: 41.2,
    shortRatio: 58.8,
    longLiquidations24h: 3456000,
    shortLiquidations24h: 678000,
    color: Color(0xFF2A5ADA),
    maxLeverage: 50,
  ),
];

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
    color: Color(0xFFF7931A),
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
    color: Color(0xFF627EEA),
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
    color: Color(0xFFF3BA2F),
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
    color: Color(0xFF9945FF),
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
    color: Color(0xFF00AAE4),
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
    color: Color(0xFF0033AD),
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
    color: Color(0xFFE84142),
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
    color: Color(0xFFE6007A),
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
    color: Color(0xFF8247E5),
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
    color: Color(0xFF2A5ADA),
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
    color: Color(0xFFFF007A),
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
    color: Color(0xFF2E3148),
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
    color: Color(0xFF00C1DE),
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
    color: Color(0xFF28A0F0),
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
    color: Color(0xFFFF0420),
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
    color: Color(0xFF2A2A2A),
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
    color: Color(0xFF00F2FE),
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
    color: Color(0xFF9B1C1C),
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
    color: Color(0xFF5546FF),
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
    color: Color(0xFF1D1D1B),
  ),
];

const List<MarketWatchlistEntry> _watchlistEntries = [
  MarketWatchlistEntry(id: 'watch-btc', pairId: 'btcusdt'),
  MarketWatchlistEntry(
    id: 'watch-eth',
    pairId: 'ethusdt',
    note: 'Chờ mốc \$3800',
  ),
  MarketWatchlistEntry(id: 'watch-sol', pairId: 'solusdt'),
];

const List<FearGreedPoint> _fearGreedHistory = [
  FearGreedPoint(date: '7 ngày trước', value: 45, label: 'Trung lập'),
  FearGreedPoint(date: '6 ngày trước', value: 48, label: 'Trung lập'),
  FearGreedPoint(date: '5 ngày trước', value: 52, label: 'Trung lập'),
  FearGreedPoint(date: '4 ngày trước', value: 55, label: 'Tham lam'),
  FearGreedPoint(date: '3 ngày trước', value: 58, label: 'Tham lam'),
  FearGreedPoint(date: '2 ngày trước', value: 60, label: 'Tham lam'),
  FearGreedPoint(date: 'Hôm qua', value: 59, label: 'Tham lam'),
  FearGreedPoint(date: 'Hôm nay', value: 62, label: 'Tham lam'),
];

const List<MarketSector> _marketSectors = [
  MarketSector(
    id: 'layer1',
    name: 'Layer 1',
    nameVi: 'Layer 1',
    color: Color(0xFF3B82F6),
    icon: Icons.diamond_rounded,
    totalMarketCap: 1856234567000,
    change24h: 2.87,
    change7d: 5.43,
    change30d: 12.1,
    volume24h: 45678901000,
    topCoins: ['BTC', 'ETH', 'SOL', 'ADA', 'AVAX'],
    coinCount: 48,
    dominance: 75.5,
  ),
  MarketSector(
    id: 'defi',
    name: 'DeFi',
    nameVi: 'DeFi',
    color: Color(0xFF8B5CF6),
    icon: Icons.account_balance_rounded,
    totalMarketCap: 89234567000,
    change24h: -1.23,
    change7d: 3.21,
    change30d: 8.7,
    volume24h: 12345678000,
    topCoins: ['UNI', 'LINK', 'AAVE', 'MKR', 'SNX'],
    coinCount: 156,
    dominance: 3.6,
  ),
  MarketSector(
    id: 'layer2',
    name: 'Layer 2',
    nameVi: 'Layer 2',
    color: Color(0xFF06B6D4),
    icon: Icons.link_rounded,
    totalMarketCap: 34567890000,
    change24h: 4.56,
    change7d: 9.87,
    change30d: 18.3,
    volume24h: 5678901000,
    topCoins: ['MATIC', 'ARB', 'OP', 'STX', 'IMX'],
    coinCount: 32,
    dominance: 1.4,
  ),
  MarketSector(
    id: 'ai',
    name: 'AI',
    nameVi: 'Trí tuệ nhân tạo',
    color: Color(0xFFF59E0B),
    icon: Icons.smart_toy_rounded,
    totalMarketCap: 23456789000,
    change24h: 6.78,
    change7d: 15.43,
    change30d: 34.2,
    volume24h: 4567890000,
    topCoins: ['FET', 'RNDR', 'AGIX', 'WLD', 'OCEAN'],
    coinCount: 67,
    dominance: 0.95,
  ),
  MarketSector(
    id: 'meme',
    name: 'Meme',
    nameVi: 'Meme',
    color: Color(0xFFEF4444),
    icon: Icons.pets_rounded,
    totalMarketCap: 56789012000,
    change24h: -3.45,
    change7d: -2.10,
    change30d: 5.6,
    volume24h: 8901234000,
    topCoins: ['DOGE', 'SHIB', 'PEPE', 'WIF', 'BONK'],
    coinCount: 234,
    dominance: 2.3,
  ),
  MarketSector(
    id: 'payment',
    name: 'Payment',
    nameVi: 'Thanh toán',
    color: Color(0xFF10B981),
    icon: Icons.credit_card_rounded,
    totalMarketCap: 45678901000,
    change24h: -0.87,
    change7d: 1.23,
    change30d: 3.4,
    volume24h: 6789012000,
    topCoins: ['XRP', 'XLM', 'ALGO', 'NANO', 'DASH'],
    coinCount: 28,
    dominance: 1.86,
  ),
  MarketSector(
    id: 'gaming',
    name: 'Gaming',
    nameVi: 'Trò chơi',
    color: Color(0xFFEC4899),
    icon: Icons.sports_esports_rounded,
    totalMarketCap: 12345678000,
    change24h: 3.21,
    change7d: 7.89,
    change30d: 15.2,
    volume24h: 2345678000,
    topCoins: ['AXS', 'SAND', 'MANA', 'GALA', 'IMX'],
    coinCount: 89,
    dominance: 0.5,
  ),
  MarketSector(
    id: 'privacy',
    name: 'Privacy',
    nameVi: 'Bảo mật',
    color: Color(0xFF6366F1),
    icon: Icons.lock_rounded,
    totalMarketCap: 5678901000,
    change24h: 1.45,
    change7d: 4.56,
    change30d: 9.8,
    volume24h: 890123000,
    topCoins: ['XMR', 'ZEC', 'DASH', 'SCRT', 'ROSE'],
    coinCount: 18,
    dominance: 0.23,
  ),
];

const List<MarketMover> _marketMovers = [
  MarketMover(
    id: 'btc',
    symbol: 'BTC',
    name: 'Bitcoin',
    price: 67543.21,
    change1h: 0.34,
    change24h: 2.34,
    change7d: 5.12,
    volume24h: 23456789000,
    volumeChange24h: 12.3,
    marketCap: 1324567890000,
    marketCapRank: 1,
    category: 'Layer 1',
    color: Color(0xFFF7931A),
    sparkline: [65100, 65800, 66500, 67000, 67200, 67543.21],
  ),
  MarketMover(
    id: 'sol',
    symbol: 'SOL',
    name: 'Solana',
    price: 178.32,
    change1h: 1.23,
    change24h: 8.07,
    change7d: 12.34,
    volume24h: 3456789000,
    volumeChange24h: 45.2,
    marketCap: 78456789000,
    marketCapRank: 3,
    category: 'Layer 1',
    color: Color(0xFF9945FF),
    sparkline: [165, 168, 170, 172, 175, 178.32],
  ),
  MarketMover(
    id: 'bnb',
    symbol: 'BNB',
    name: 'BNB',
    price: 412.87,
    change1h: 0.41,
    change24h: 3.61,
    change7d: 7.82,
    volume24h: 1234567000,
    volumeChange24h: 15.6,
    marketCap: 63456789000,
    marketCapRank: 4,
    category: 'Layer 1',
    color: Color(0xFFF3BA2F),
    sparkline: [395, 400, 405, 408, 410, 412.87],
  ),
  MarketMover(
    id: 'xrp',
    symbol: 'XRP',
    name: 'Ripple',
    price: 0.6234,
    change1h: -0.23,
    change24h: -2.59,
    change7d: -4.21,
    volume24h: 1876543000,
    volumeChange24h: 32.6,
    marketCap: 34567890000,
    marketCapRank: 5,
    category: 'Payment',
    color: Color(0xFF00AAE4),
    sparkline: [0.66, 0.65, 0.64, 0.63, 0.63, 0.6234],
  ),
  MarketMover(
    id: 'ada',
    symbol: 'ADA',
    name: 'Cardano',
    price: 0.4521,
    change1h: 0.12,
    change24h: 3.22,
    change7d: 6.78,
    volume24h: 654321000,
    volumeChange24h: 18.7,
    marketCap: 16234567000,
    marketCapRank: 6,
    category: 'Layer 1',
    color: Color(0xFF0033AD),
    sparkline: [0.43, 0.44, 0.44, 0.45, 0.45, 0.4521],
  ),
  MarketMover(
    id: 'avax',
    symbol: 'AVAX',
    name: 'Avalanche',
    price: 38.54,
    change1h: 0.56,
    change24h: 4.73,
    change7d: 9.15,
    volume24h: 567890000,
    volumeChange24h: 28.4,
    marketCap: 15678901000,
    marketCapRank: 7,
    category: 'Layer 1',
    color: Color(0xFFE84142),
    sparkline: [36.5, 37.0, 37.5, 38.0, 38.3, 38.54],
  ),
  MarketMover(
    id: 'dot',
    symbol: 'DOT',
    name: 'Polkadot',
    price: 7.832,
    change1h: -0.34,
    change24h: -3.55,
    change7d: -1.23,
    volume24h: 432109000,
    volumeChange24h: 25.3,
    marketCap: 10345678000,
    marketCapRank: 8,
    category: 'DeFi',
    color: Color(0xFFE6007A),
    sparkline: [8.3, 8.2, 8.1, 8.0, 7.9, 7.832],
  ),
  MarketMover(
    id: 'matic',
    symbol: 'MATIC',
    name: 'Polygon',
    price: 0.8976,
    change1h: 0.34,
    change24h: 5.60,
    change7d: 11.20,
    volume24h: 789012000,
    volumeChange24h: 38.9,
    marketCap: 8912345000,
    marketCapRank: 9,
    category: 'Layer 2',
    color: Color(0xFF8247E5),
    sparkline: [0.82, 0.84, 0.86, 0.87, 0.89, 0.8976],
  ),
  MarketMover(
    id: 'link',
    symbol: 'LINK',
    name: 'Chainlink',
    price: 14.23,
    change1h: -0.67,
    change24h: -5.76,
    change7d: -3.45,
    volume24h: 345678000,
    volumeChange24h: 56.4,
    marketCap: 8123456000,
    marketCapRank: 10,
    category: 'DeFi',
    color: Color(0xFF2A5ADA),
    sparkline: [15.5, 15.2, 14.9, 14.6, 14.4, 14.23],
  ),
  MarketMover(
    id: 'near',
    symbol: 'NEAR',
    name: 'NEAR Protocol',
    price: 5.67,
    change1h: 0.45,
    change24h: 6.89,
    change7d: 14.56,
    volume24h: 456789000,
    volumeChange24h: 52.3,
    marketCap: 5890123000,
    marketCapRank: 11,
    category: 'Layer 1',
    color: Color(0xFF00C1DE),
    sparkline: [4.8, 5.0, 5.2, 5.4, 5.5, 5.67],
  ),
  MarketMover(
    id: 'arb',
    symbol: 'ARB',
    name: 'Arbitrum',
    price: 1.23,
    change1h: 0.23,
    change24h: 4.32,
    change7d: 8.90,
    volume24h: 567890000,
    volumeChange24h: 34.1,
    marketCap: 4321098000,
    marketCapRank: 12,
    category: 'Layer 2',
    color: Color(0xFF28A0F0),
    sparkline: [1.12, 1.15, 1.18, 1.20, 1.22, 1.23],
  ),
  MarketMover(
    id: 'apt',
    symbol: 'APT',
    name: 'Aptos',
    price: 8.90,
    change1h: 0.18,
    change24h: 3.45,
    change7d: 7.89,
    volume24h: 234567000,
    volumeChange24h: 22.3,
    marketCap: 3210987000,
    marketCapRank: 15,
    category: 'Layer 1',
    color: Color(0xFF2A2A2A),
    sparkline: [8.2, 8.4, 8.5, 8.6, 8.8, 8.9],
  ),
  MarketMover(
    id: 'inj',
    symbol: 'INJ',
    name: 'Injective',
    price: 28.45,
    change1h: 0.87,
    change24h: 7.23,
    change7d: 15.67,
    volume24h: 345678000,
    volumeChange24h: 67.8,
    marketCap: 2876543000,
    marketCapRank: 16,
    category: 'DeFi',
    color: Color(0xFF00F2FE),
    sparkline: [24, 25, 26, 27, 28, 28.45],
  ),
  MarketMover(
    id: 'wld',
    symbol: 'WLD',
    name: 'Worldcoin',
    price: 3.12,
    change1h: -0.89,
    change24h: -6.78,
    change7d: -8.90,
    volume24h: 345678000,
    volumeChange24h: 78.9,
    marketCap: 1890123000,
    marketCapRank: 18,
    category: 'AI',
    color: Color(0xFF1D1D1B),
    sparkline: [3.8, 3.6, 3.5, 3.3, 3.2, 3.12],
  ),
  MarketMover(
    id: 'zro',
    symbol: 'ZRO',
    name: 'LayerZero',
    price: 4.23,
    change1h: 2.34,
    change24h: 15.67,
    change7d: 0,
    volume24h: 892345000,
    volumeChange24h: 0,
    marketCap: 1234567000,
    marketCapRank: 19,
    category: 'Layer 2',
    color: Color(0xFF7B3FE4),
    sparkline: [3.2, 3.5, 3.8, 4.0, 4.1, 4.23],
    isNew: true,
    listingDate: '2026-03-09',
  ),
  MarketMover(
    id: 'sei',
    symbol: 'SEI',
    name: 'Sei',
    price: 0.45,
    change1h: -0.45,
    change24h: -4.56,
    change7d: -2.34,
    volume24h: 189012000,
    volumeChange24h: 42.1,
    marketCap: 1234567000,
    marketCapRank: 19,
    category: 'Layer 1',
    color: Color(0xFF9B1C1C),
    sparkline: [0.49, 0.48, 0.47, 0.46, 0.46, 0.45],
  ),
  MarketMover(
    id: 'strk',
    symbol: 'STRK',
    name: 'Starknet',
    price: 1.87,
    change1h: 1.56,
    change24h: 12.34,
    change7d: 0,
    volume24h: 567890000,
    volumeChange24h: 0,
    marketCap: 987654000,
    marketCapRank: 20,
    category: 'Layer 2',
    color: Color(0xFF29296E),
    sparkline: [1.5, 1.6, 1.65, 1.7, 1.8, 1.87],
    isNew: true,
    listingDate: '2026-03-10',
  ),
  MarketMover(
    id: 'pyth',
    symbol: 'PYTH',
    name: 'Pyth Network',
    price: 0.56,
    change1h: 0.89,
    change24h: 8.90,
    change7d: 0,
    volume24h: 234567000,
    volumeChange24h: 0,
    marketCap: 654321000,
    marketCapRank: 21,
    category: 'DeFi',
    color: Color(0xFF6B21A8),
    sparkline: [0.48, 0.50, 0.52, 0.53, 0.55, 0.56],
    isNew: true,
    listingDate: '2026-03-11',
  ),
];

const List<MarketPair> _marketPairs = [
  MarketPair(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    price: 67543.21,
    prevPrice: 66012.50,
    change24h: 2.34,
    high24h: 68100.00,
    low24h: 65800.00,
    volume24h: 23456789000,
    marketCap: 1324567890000,
    sparklineData: [
      65100,
      65400,
      65200,
      65800,
      66200,
      65900,
      66500,
      67000,
      66800,
      67200,
      67100,
      67543,
    ],
    logoColor: Color(0xFFF7931A),
    isFavorite: true,
    category: 'Layer 1',
  ),
  MarketPair(
    id: 'ethusdt',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    quoteAsset: 'USDT',
    price: 3521.45,
    prevPrice: 3565.00,
    change24h: -1.23,
    high24h: 3600.00,
    low24h: 3480.00,
    volume24h: 8765432000,
    marketCap: 423456789000,
    sparklineData: [
      3565,
      3555,
      3570,
      3540,
      3530,
      3545,
      3520,
      3510,
      3525,
      3515,
      3530,
      3521,
    ],
    logoColor: Color(0xFF627EEA),
    isFavorite: true,
    category: 'Layer 1',
  ),
  MarketPair(
    id: 'bnbusdt',
    symbol: 'BNB/USDT',
    baseAsset: 'BNB',
    quoteAsset: 'USDT',
    price: 412.87,
    prevPrice: 398.50,
    change24h: 3.61,
    high24h: 415.00,
    low24h: 395.00,
    volume24h: 1234567000,
    marketCap: 63456789000,
    sparklineData: [398, 400, 402, 405, 403, 407, 410, 408, 411, 413, 412.87],
    logoColor: Color(0xFFF3BA2F),
    isFavorite: false,
    category: 'Layer 1',
  ),
  MarketPair(
    id: 'solusdt',
    symbol: 'SOL/USDT',
    baseAsset: 'SOL',
    quoteAsset: 'USDT',
    price: 178.32,
    prevPrice: 165.00,
    change24h: 8.07,
    high24h: 182.00,
    low24h: 163.00,
    volume24h: 3456789000,
    marketCap: 78456789000,
    sparklineData: [165, 168, 170, 172, 171, 175, 176, 179, 178, 180, 178.32],
    logoColor: Color(0xFF9945FF),
    isFavorite: true,
    category: 'Layer 1',
  ),
  MarketPair(
    id: 'xrpusdt',
    symbol: 'XRP/USDT',
    baseAsset: 'XRP',
    quoteAsset: 'USDT',
    price: 0.6234,
    prevPrice: 0.6400,
    change24h: -2.59,
    high24h: 0.6500,
    low24h: 0.6100,
    volume24h: 1876543000,
    marketCap: 34567890000,
    sparklineData: [0.64, 0.638, 0.635, 0.632, 0.628, 0.625, 0.621, 0.6234],
    logoColor: Color(0xFF00AAE4),
    isFavorite: false,
    category: 'Layer 1',
  ),
  MarketPair(
    id: 'adausdt',
    symbol: 'ADA/USDT',
    baseAsset: 'ADA',
    quoteAsset: 'USDT',
    price: 0.4521,
    prevPrice: 0.4380,
    change24h: 3.22,
    high24h: 0.4600,
    low24h: 0.4350,
    volume24h: 654321000,
    marketCap: 16234567000,
    sparklineData: [0.438, 0.440, 0.442, 0.445, 0.448, 0.450, 0.452, 0.4521],
    logoColor: Color(0xFF0033AD),
    isFavorite: false,
    category: 'Layer 1',
  ),
  MarketPair(
    id: 'dotusdt',
    symbol: 'DOT/USDT',
    baseAsset: 'DOT',
    quoteAsset: 'USDT',
    price: 7.832,
    prevPrice: 8.120,
    change24h: -3.55,
    high24h: 8.200,
    low24h: 7.700,
    volume24h: 432109000,
    marketCap: 10345678000,
    sparklineData: [8.12, 8.05, 7.98, 7.92, 7.88, 7.85, 7.83, 7.832],
    logoColor: Color(0xFFE6007A),
    isFavorite: false,
    category: 'DeFi',
  ),
  MarketPair(
    id: 'maticusdt',
    symbol: 'MATIC/USDT',
    baseAsset: 'MATIC',
    quoteAsset: 'USDT',
    price: 0.8976,
    prevPrice: 0.8500,
    change24h: 5.60,
    high24h: 0.9100,
    low24h: 0.8400,
    volume24h: 789012000,
    marketCap: 8912345000,
    sparklineData: [0.850, 0.855, 0.862, 0.870, 0.875, 0.882, 0.890, 0.8976],
    logoColor: Color(0xFF8247E5),
    isFavorite: false,
    category: 'Layer 2',
  ),
  MarketPair(
    id: 'avaxusdt',
    symbol: 'AVAX/USDT',
    baseAsset: 'AVAX',
    quoteAsset: 'USDT',
    price: 38.54,
    prevPrice: 36.80,
    change24h: 4.73,
    high24h: 39.00,
    low24h: 36.50,
    volume24h: 567890000,
    marketCap: 15678901000,
    sparklineData: [36.8, 37.0, 37.3, 37.6, 37.9, 38.1, 38.4, 38.54],
    logoColor: Color(0xFFE84142),
    isFavorite: false,
    category: 'Layer 1',
  ),
  MarketPair(
    id: 'linkusdt',
    symbol: 'LINK/USDT',
    baseAsset: 'LINK',
    quoteAsset: 'USDT',
    price: 14.23,
    prevPrice: 15.10,
    change24h: -5.76,
    high24h: 15.20,
    low24h: 14.00,
    volume24h: 345678000,
    marketCap: 8123456000,
    sparklineData: [15.10, 15.00, 14.85, 14.70, 14.55, 14.40, 14.30, 14.23],
    logoColor: Color(0xFF2A5ADA),
    isFavorite: false,
    category: 'DeFi',
  ),
];

const List<MarketRecentTrade> _marketRecentTrades = [
  MarketRecentTrade(
    id: 'tr-1',
    price: 67543.21,
    amount: 0.1842,
    time: '23:29:14',
    side: MarketOrderSide.buy,
  ),
  MarketRecentTrade(
    id: 'tr-2',
    price: 67541.10,
    amount: 0.0724,
    time: '23:29:08',
    side: MarketOrderSide.sell,
  ),
  MarketRecentTrade(
    id: 'tr-3',
    price: 67545.80,
    amount: 0.4200,
    time: '23:28:57',
    side: MarketOrderSide.buy,
  ),
  MarketRecentTrade(
    id: 'tr-4',
    price: 67538.40,
    amount: 0.2105,
    time: '23:28:42',
    side: MarketOrderSide.sell,
  ),
  MarketRecentTrade(
    id: 'tr-5',
    price: 67552.30,
    amount: 0.0961,
    time: '23:28:25',
    side: MarketOrderSide.buy,
  ),
];

const TokenFundamentalsDraft _btcFundamentals = TokenFundamentalsDraft(
  id: 'btcusdt',
  symbol: 'BTC',
  name: 'Bitcoin',
  description:
      'Bitcoin la tien te ky thuat so phi tap trung dau tien, hoat dong tren mang luoi ngang hang khong can trung gian, su dung co che Proof of Work.',
  consensus: 'Proof of Work (SHA-256)',
  network: 'Bitcoin',
  website: 'https://bitcoin.org',
  whitepaper: 'https://bitcoin.org/bitcoin.pdf',
  github: 'https://github.com/bitcoin/bitcoin',
  twitter: 'https://x.com/bitcoin',
  telegram: '',
  circulatingSupply: 19630000,
  totalSupply: 19630000,
  maxSupply: 21000000,
  fullyDilutedValuation: 1418410000000,
  inflationRate: 1.74,
  allTimeHigh: 73750.07,
  allTimeHighDate: '2024-03-14',
  allTimeLow: 67.81,
  allTimeLowDate: '2013-07-06',
  roi1y: 125.40,
  activeAddresses24h: 987654,
  txCount24h: 543210,
  holders: 53120000,
  tvl: null,
  supplyDistribution: [
    SupplyDistributionDraft(
      label: 'Luu hanh',
      percentage: 93.5,
      color: Color(0xFFF7931A),
    ),
    SupplyDistributionDraft(
      label: 'Chua dao',
      percentage: 6.5,
      color: Color(0xFF6B4A22),
    ),
  ],
  contractAddresses: [],
);

const Map<String, TokenFundamentalsDraft> _tokenFundamentals = {
  'btcusdt': _btcFundamentals,
};
