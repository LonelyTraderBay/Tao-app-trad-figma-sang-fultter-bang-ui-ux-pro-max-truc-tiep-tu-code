part of 'predictions_entities.dart';

final class PredictionTournamentDraft {
  const PredictionTournamentDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.prizePool,
    required this.participants,
    required this.maxParticipants,
    required this.status,
    required this.entryFee,
    required this.category,
    required this.timeLabel,
    this.myRank,
    this.myScore,
    this.isJoined = false,
    this.requiredLevel = 0,
    this.featured = false,
  });

  final String id;
  final String name;
  final String description;
  final int prizePool;
  final int participants;
  final int maxParticipants;
  final TournamentStatus status;
  final int entryFee;
  final String category;
  final String timeLabel;
  final int? myRank;
  final int? myScore;
  final bool isJoined;
  final int requiredLevel;
  final bool featured;
}

enum TournamentStatus { upcoming, active, ended }

final class PredictionTournamentLeaderboardEntry {
  const PredictionTournamentLeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.prize,
  });

  final int rank;
  final String name;
  final int score;
  final int prize;
}

final class PredictionDataIntegrationSnapshot {
  const PredictionDataIntegrationSnapshot({
    required this.sources,
    required this.apiKeys,
    required this.webhooks,
    required this.predictionEvents,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionDataSourceDraft> sources;
  final List<PredictionApiKeyDraft> apiKeys;
  final List<PredictionWebhookDraft> webhooks;
  final List<PredictionEventDraft> predictionEvents;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  int get activeSources => sources
      .where((source) => source.status == PredictionDataSourceStatus.active)
      .length;

  double get averageReliability => sources.isEmpty
      ? 0
      : sources.fold<double>(0, (sum, source) => sum + source.reliability) /
            sources.length;

  int get eventsResolved =>
      sources.fold<int>(0, (sum, source) => sum + source.eventsResolved);
}

final class PredictionDataSourceDraft {
  const PredictionDataSourceDraft({
    required this.id,
    required this.name,
    required this.provider,
    required this.category,
    required this.status,
    required this.lastSyncLabel,
    required this.eventsResolved,
    required this.reliability,
    this.apiUrl,
  });

  final String id;
  final String name;
  final String provider;
  final String category;
  final PredictionDataSourceStatus status;
  final String lastSyncLabel;
  final int eventsResolved;
  final double reliability;
  final String? apiUrl;
}

enum PredictionDataSourceStatus { active, inactive, error }

final class PredictionApiKeyDraft {
  const PredictionApiKeyDraft({
    required this.id,
    required this.name,
    required this.key,
    required this.createdAtLabel,
    required this.permissions,
    required this.status,
    this.lastUsedLabel,
  });

  final String id;
  final String name;
  final String key;
  final String createdAtLabel;
  final List<String> permissions;
  final PredictionApiKeyStatus status;
  final String? lastUsedLabel;
}

enum PredictionApiKeyStatus { active, revoked }

final class PredictionWebhookDraft {
  const PredictionWebhookDraft({
    required this.id,
    required this.url,
    required this.events,
    required this.status,
    required this.successRate,
    this.lastTriggeredLabel,
  });

  final String id;
  final String url;
  final List<String> events;
  final PredictionWebhookStatus status;
  final double successRate;
  final String? lastTriggeredLabel;
}

enum PredictionWebhookStatus { active, inactive }

final class PredictionRewardOpportunityDraft {
  const PredictionRewardOpportunityDraft({
    required this.id,
    required this.eventId,
    required this.category,
    required this.maxSpread,
    required this.minShares,
    required this.dailyReward,
    required this.earningsPct,
    required this.priceChange24h,
    this.isFavorite = false,
  });

  final String id;
  final String eventId;
  final String category;
  final double maxSpread;
  final int minShares;
  final double dailyReward;
  final double earningsPct;
  final double priceChange24h;
  final bool isFavorite;
}

final class PredictionPortfolioPositionDraft {
  const PredictionPortfolioPositionDraft({
    required this.id,
    required this.eventId,
    required this.outcome,
    required this.shares,
    required this.avgPrice,
    required this.currentPrice,
    required this.investedAmount,
    required this.currentValue,
    required this.pnl,
    required this.pnlPct,
    required this.status,
    required this.purchasedAt,
  });

  final String id;
  final String eventId;
  final String outcome;
  final double shares;
  final double avgPrice;
  final double currentPrice;
  final double investedAmount;
  final double currentValue;
  final double pnl;
  final double pnlPct;
  final PredictionPortfolioPositionStatus status;
  final DateTime purchasedAt;
}

final class PredictionPortfolioOrderDraft {
  const PredictionPortfolioOrderDraft({
    required this.id,
    required this.eventId,
    required this.outcome,
    required this.side,
    required this.orderType,
    required this.price,
    required this.shares,
    required this.filled,
    required this.total,
    required this.createdAt,
  });

  final String id;
  final String eventId;
  final String outcome;
  final String side;
  final String orderType;
  final double price;
  final double shares;
  final double filled;
  final double total;
  final DateTime createdAt;

  String get receiptId => id.replaceFirst('oo-', 'po-');
}

final class PredictionPortfolioReceiptDraft {
  const PredictionPortfolioReceiptDraft({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.outcome,
    required this.side,
    required this.orderType,
    required this.shares,
    required this.filledShares,
    required this.price,
    required this.avgPrice,
    required this.total,
    required this.fee,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.timeline = const [],
  });

  final String id;
  final String eventId;
  final String eventTitle;
  final String outcome;
  final String side;
  final String orderType;
  final double shares;
  final double filledShares;
  final double price;
  final double avgPrice;
  final double total;
  final double fee;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<PredictionReceiptTimelineDraft> timeline;
}

final class PredictionReceiptTimelineDraft {
  const PredictionReceiptTimelineDraft({
    required this.label,
    required this.date,
    required this.done,
  });

  final String label;
  final String date;
  final bool done;
}

final class PredictionDetailPositionDraft {
  const PredictionDetailPositionDraft({
    required this.outcome,
    required this.shares,
    required this.avgPrice,
    required this.pnl,
    required this.pnlPct,
  });

  final String outcome;
  final double shares;
  final double avgPrice;
  final double pnl;
  final double pnlPct;
}

final class PredictionOrderBookDraft {
  const PredictionOrderBookDraft({required this.bids, required this.asks});

  final List<PredictionOrderBookEntryDraft> bids;
  final List<PredictionOrderBookEntryDraft> asks;
}

final class PredictionOrderBookEntryDraft {
  const PredictionOrderBookEntryDraft({
    required this.price,
    required this.shares,
  });

  final double price;
  final int shares;
}

final class PredictionHolderDraft {
  const PredictionHolderDraft({
    required this.name,
    required this.outcome,
    required this.shares,
  });

  final String name;
  final String outcome;
  final int shares;
}

final class PredictionActivityDraft {
  const PredictionActivityDraft({
    required this.actor,
    required this.action,
    required this.amount,
    required this.time,
  });

  final String actor;
  final String action;
  final String amount;
  final String time;
}

final class PredictionArenaRoomDraft {
  const PredictionArenaRoomDraft({
    required this.title,
    required this.slots,
    required this.points,
    required this.badge,
  });

  final String title;
  final String slots;
  final int points;
  final String badge;
}

final class PredictionEventDraft {
  const PredictionEventDraft({
    required this.id,
    required this.title,
    required this.category,
    required this.tags,
    required this.outcomes,
    required this.volume24h,
    required this.totalVolume,
    required this.endDate,
    required this.liquidity,
    required this.participants,
    required this.status,
    required this.change24h,
    required this.createdAt,
    this.resolvedOutcome,
    this.isNew = false,
    this.isTrending = false,
  });

  final String id;
  final String title;
  final String category;
  final List<String> tags;
  final List<PredictionOutcomeDraft> outcomes;
  final double volume24h;
  final double totalVolume;
  final DateTime endDate;
  final double liquidity;
  final int participants;
  final PredictionEventStatus status;
  final String? resolvedOutcome;
  final bool isNew;
  final bool isTrending;
  final double change24h;
  final DateTime createdAt;
}

final class PredictionOutcomeDraft {
  const PredictionOutcomeDraft({
    required this.label,
    required this.chance,
    required this.tone,
  });

  final String label;
  final int chance;
  final AccentTone tone;
}

final class PredictionPositionDraft {
  const PredictionPositionDraft({
    required this.id,
    required this.eventId,
    required this.outcome,
    required this.shares,
    required this.avgPrice,
    required this.status,
  });

  final String id;
  final String eventId;
  final String outcome;
  final double shares;
  final double avgPrice;
  final PredictionPositionStatus status;
}

final class PredictionOrderDraft {
  const PredictionOrderDraft({
    required this.id,
    required this.eventId,
    required this.outcome,
    required this.side,
    required this.price,
    required this.shares,
    required this.status,
  });

  final String id;
  final String eventId;
  final String outcome;
  final String side;
  final double price;
  final double shares;
  final String status;
}

final class PredictionReceiptDraft {
  const PredictionReceiptDraft({
    required this.id,
    required this.eventId,
    required this.outcome,
    required this.total,
    required this.fee,
    required this.status,
  });

  final String id;
  final String eventId;
  final String outcome;
  final double total;
  final double fee;
  final String status;
}

final class PredictionRewardDraft {
  const PredictionRewardDraft({
    required this.id,
    required this.eventId,
    required this.category,
    required this.dailyReward,
    required this.earningsPct,
  });

  final String id;
  final String eventId;
  final String category;
  final double dailyReward;
  final double earningsPct;
}

enum PredictionFilterTab {
  trending,
  newEvents,
  popular,
  liquid,
  ending,
  competitive,
}

enum PredictionSearchSort {
  trending,
  liquidity,
  volume,
  newest,
  ending,
  competitive,
}

enum PredictionStatusFilter { active, resolved, all }

enum PredictionEventStatus { active, resolved }

enum PredictionPositionStatus { open, closed }

enum PredictionPortfolioPositionStatus { open, won, lost }

enum PredictionScreenState { loading, empty, error, offline, realtimeRefresh }

enum PredictionLeaderboardTimeFilter { today, weekly, monthly, allTime }
