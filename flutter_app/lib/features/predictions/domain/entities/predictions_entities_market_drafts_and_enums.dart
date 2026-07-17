part of 'predictions_entities.dart';

/// One prediction tournament (prize pool, participants, the user's rank if
/// joined) shown on the tournaments screen.
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

/// Lifecycle state of a [PredictionTournamentDraft].
enum TournamentStatus { upcoming, active, ended }

/// One ranked entry (rank/name/score/prize) on a tournament's leaderboard.
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

/// Data for the Prediction Markets data-integration (admin/tooling) screen:
/// data sources, API keys, and webhooks with derived reliability stats.
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

/// One external data source (provider, sync status, reliability) feeding
/// prediction event resolution.
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

/// Connection state of a [PredictionDataSourceDraft].
enum PredictionDataSourceStatus { active, inactive, error }

/// One API key (permissions, usage) shown on the data-integration screen.
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

/// Whether a [PredictionApiKeyDraft] is still usable.
enum PredictionApiKeyStatus { active, revoked }

/// One webhook subscription (target URL, subscribed events, success rate)
/// shown on the data-integration screen.
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

/// Whether a [PredictionWebhookDraft] is currently firing.
enum PredictionWebhookStatus { active, inactive }

/// One reward opportunity (spread/share requirements, daily reward, 24h
/// price change) shown on the rewards screen.
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

/// One held position (shares, prices, P&L, purchase date) shown on the
/// portfolio screen.
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

/// One open order (side, price, fill progress) shown on the portfolio
/// screen.
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

/// A settled order's full receipt (fill details, fee, status timeline)
/// shown on the order-receipt screen.
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

/// One dated step (label + done flag) in a [PredictionPortfolioReceiptDraft]'s
/// status timeline.
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

/// The user's position summary (shares, avg price, P&L) shown on an
/// event's detail screen.
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

/// An event's order book: bid and ask [PredictionOrderBookEntryDraft] lists.
final class PredictionOrderBookDraft {
  const PredictionOrderBookDraft({required this.bids, required this.asks});

  final List<PredictionOrderBookEntryDraft> bids;
  final List<PredictionOrderBookEntryDraft> asks;
}

/// One price/shares level in a [PredictionOrderBookDraft].
final class PredictionOrderBookEntryDraft {
  const PredictionOrderBookEntryDraft({
    required this.price,
    required this.shares,
  });

  final double price;
  final int shares;
}

/// One top holder entry (name, outcome held, shares) shown on an event's
/// detail screen.
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

/// One recent trade-activity entry shown in an event's activity feed.
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

/// A points-only Arena room reference (title, slots, points, badge) linked
/// to a prediction event's detail screen.
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

/// A prediction market event: title, category, outcomes, volume/liquidity
/// stats, and lifecycle status.
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

/// One possible outcome (label, implied chance, tone) of a
/// [PredictionEventDraft].
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

/// A lightweight held position reference (event/outcome/shares/status) used
/// on the home screen.
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

/// A lightweight open-order reference (event/outcome/side/price) used on
/// the home screen.
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

/// A lightweight settled-receipt reference (event/outcome/total/fee) used
/// on the home screen.
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

/// A lightweight reward-opportunity reference (event/category/daily
/// reward) used on the home screen.
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

/// The active event-filter tab on the Prediction Markets home screen.
enum PredictionFilterTab {
  trending,
  newEvents,
  popular,
  liquid,
  ending,
  competitive,
}

/// Sort order applied to search results on the Prediction Markets search
/// screen.
enum PredictionSearchSort {
  trending,
  liquidity,
  volume,
  newest,
  ending,
  competitive,
}

/// Status filter applied to search results on the Prediction Markets
/// search screen.
enum PredictionStatusFilter { active, resolved, all }

/// Resolution status of a [PredictionEventDraft].
enum PredictionEventStatus { active, resolved }

/// Whether a [PredictionPositionDraft] is still open or closed.
enum PredictionPositionStatus { open, closed }

/// Outcome status of a [PredictionPortfolioPositionDraft].
enum PredictionPortfolioPositionStatus { open, won, lost }

/// UI state a Prediction Markets screen snapshot supports rendering.
enum PredictionScreenState { loading, empty, error, offline, realtimeRefresh }

/// Time window filter applied to the Prediction Markets leaderboard.
enum PredictionLeaderboardTimeFilter { today, weekly, monthly, allTime }
