part of 'market_entities.dart';

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
