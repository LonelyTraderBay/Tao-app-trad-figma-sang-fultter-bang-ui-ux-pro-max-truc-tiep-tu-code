part of 'market_entities.dart';

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
  const CorrelationAsset({required this.symbol});

  final String symbol;
}

final class CorrelationPairDraft {
  const CorrelationPairDraft({
    required this.assetA,
    required this.assetB,
    required this.correlation7d,
    required this.correlation30d,
    required this.correlation90d,
  });

  final String assetA;
  final String assetB;
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
  final AccentTone color;
  final AccentTone background;
}

final class SignalStatusConfig {
  const SignalStatusConfig({required this.label, required this.color});

  final String label;
  final AccentTone color;
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
  final AccentTone color;
}

final class UnlockCategoryConfig {
  const UnlockCategoryConfig({required this.label, required this.color});

  final String label;
  final AccentTone color;
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
  final AccentTone color;
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
  final AccentTone color;
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
  final String icon;
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
