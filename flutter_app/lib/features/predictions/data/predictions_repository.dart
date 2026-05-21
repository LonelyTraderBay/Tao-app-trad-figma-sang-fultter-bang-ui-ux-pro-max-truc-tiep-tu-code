import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';

final predictionsRepositoryProvider = Provider<PredictionsRepository>((ref) {
  return const MockPredictionsRepository();
});

abstract interface class PredictionsRepository {
  PredictionHomeSnapshot getHome({
    PredictionFilterTab filter = PredictionFilterTab.trending,
    String? category,
    String searchQuery = '',
  });

  PredictionSearchSnapshot getSearch({
    PredictionSearchSort sort = PredictionSearchSort.trending,
    PredictionStatusFilter status = PredictionStatusFilter.active,
    String? category,
    String searchQuery = '',
  });

  PredictionBreakingSnapshot getBreaking({String? category});

  PredictionEventDetailSnapshot getEventDetail(String eventId);

  PredictionPortfolioSnapshot getPortfolio();

  PredictionRewardsSnapshot getRewards();

  PredictionLeaderboardSnapshot getLeaderboard({
    PredictionLeaderboardTimeFilter timeFilter =
        PredictionLeaderboardTimeFilter.weekly,
    PredictionLeaderboardMetric metric = PredictionLeaderboardMetric.pnl,
  });

  PredictionGlobalActivitySnapshot getGlobalActivity({double minAmount = 0});

  PredictionOrderReceiptSnapshot getOrderReceipt(String receiptId);

  PredictionRiskCalculatorSnapshot getRiskCalculator();

  PredictionMarketMakerSnapshot getMarketMaker();

  PredictionPortfolioAnalyzerSnapshot getPortfolioAnalyzer();

  PredictionEventCalendarSnapshot getEventCalendar({String? category});

  PredictionSocialSnapshot getSocial();

  PredictionAdvancedChartSnapshot getAdvancedChart(String eventId);

  PredictionTournamentsSnapshot getTournaments();

  PredictionDataIntegrationSnapshot getDataIntegration();
}

final class PredictionHomeSnapshot {
  const PredictionHomeSnapshot({
    required this.events,
    required this.categories,
    required this.positions,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.breakingMovers,
    required this.openPositionCount,
    required this.filter,
    required this.category,
    required this.searchQuery,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionEventDraft> events;
  final List<String> categories;
  final List<PredictionPositionDraft> positions;
  final List<PredictionOrderDraft> orders;
  final List<PredictionReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final List<PredictionEventDraft> breakingMovers;
  final int openPositionCount;
  final PredictionFilterTab filter;
  final String? category;
  final String searchQuery;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;
}

final class PredictionSearchSnapshot {
  const PredictionSearchSnapshot({
    required this.results,
    required this.categories,
    required this.sort,
    required this.status,
    required this.category,
    required this.searchQuery,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionEventDraft> results;
  final List<String> categories;
  final PredictionSearchSort sort;
  final PredictionStatusFilter status;
  final String? category;
  final String searchQuery;
  final List<PredictionOrderDraft> orders;
  final List<PredictionReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;
}

final class PredictionBreakingSnapshot {
  const PredictionBreakingSnapshot({
    required this.movers,
    required this.categories,
    required this.category,
    required this.upCount,
    required this.downCount,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionEventDraft> movers;
  final List<String> categories;
  final String? category;
  final int upCount;
  final int downCount;
  final List<PredictionOrderDraft> orders;
  final List<PredictionReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;
}

final class PredictionEventDetailSnapshot {
  const PredictionEventDetailSnapshot({
    required this.event,
    required this.position,
    required this.relatedEvents,
    required this.probabilityHistory,
    required this.volumeHistory,
    required this.orderBook,
    required this.rules,
    required this.topHolders,
    required this.activity,
    required this.arenaRooms,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final PredictionEventDraft event;
  final PredictionDetailPositionDraft? position;
  final List<PredictionEventDraft> relatedEvents;
  final List<int> probabilityHistory;
  final List<int> volumeHistory;
  final PredictionOrderBookDraft orderBook;
  final List<String> rules;
  final List<PredictionHolderDraft> topHolders;
  final List<PredictionActivityDraft> activity;
  final List<PredictionArenaRoomDraft> arenaRooms;
  final List<PredictionOrderDraft> orders;
  final List<PredictionReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;
}

final class PredictionPortfolioSnapshot {
  const PredictionPortfolioSnapshot({
    required this.events,
    required this.positions,
    required this.openOrders,
    required this.receipts,
    required this.rewards,
    required this.totalCurrentValue,
    required this.totalInvested,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionEventDraft> events;
  final List<PredictionPortfolioPositionDraft> positions;
  final List<PredictionPortfolioOrderDraft> openOrders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final double totalCurrentValue;
  final double totalInvested;
  final double totalPnl;
  final double totalPnlPct;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  int get activeCount => activePositions.length;
  int get closedCount => closedPositions.length;
  int get historyCount => historyReceipts.length;

  List<PredictionPortfolioPositionDraft> get activePositions => positions
      .where(
        (position) => position.status == PredictionPortfolioPositionStatus.open,
      )
      .toList();

  List<PredictionPortfolioPositionDraft> get closedPositions => positions
      .where(
        (position) =>
            position.status == PredictionPortfolioPositionStatus.won ||
            position.status == PredictionPortfolioPositionStatus.lost,
      )
      .toList();

  List<PredictionPortfolioReceiptDraft> get historyReceipts => receipts
      .where(
        (receipt) => receipt.status == 'filled' || receipt.status == 'canceled',
      )
      .toList();

  PredictionEventDraft eventFor(String eventId) {
    return events.firstWhere(
      (event) => event.id == eventId,
      orElse: () => events.first,
    );
  }
}

final class PredictionRewardsSnapshot {
  const PredictionRewardsSnapshot({
    required this.events,
    required this.categories,
    required this.rewards,
    required this.arenaRooms,
    required this.totalDailyPool,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionEventDraft> events;
  final List<String> categories;
  final List<PredictionRewardOpportunityDraft> rewards;
  final List<PredictionArenaRoomDraft> arenaRooms;
  final double totalDailyPool;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  PredictionEventDraft eventFor(String eventId) {
    return events.firstWhere(
      (event) => event.id == eventId,
      orElse: () => events.first,
    );
  }
}

final class PredictionLeaderboardSnapshot {
  const PredictionLeaderboardSnapshot({
    required this.events,
    required this.traders,
    required this.biggestWins,
    required this.timeFilter,
    required this.metric,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionEventDraft> events;
  final List<PredictionLeaderboardTraderDraft> traders;
  final List<PredictionLeaderboardTraderDraft> biggestWins;
  final PredictionLeaderboardTimeFilter timeFilter;
  final PredictionLeaderboardMetric metric;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  PredictionEventDraft? eventForWin(PredictionLeaderboardTraderDraft trader) {
    final market = trader.biggestWinMarket;
    if (market == null) return null;
    final normalized = market.toLowerCase();
    for (final event in events) {
      if (event.title.toLowerCase().contains(normalized)) return event;
    }
    final words = normalized.split(' ').take(3);
    for (final event in events) {
      final title = event.title.toLowerCase();
      if (words.every(title.contains)) return event;
    }
    return null;
  }
}

final class PredictionLeaderboardTraderDraft {
  const PredictionLeaderboardTraderDraft({
    required this.rank,
    required this.user,
    required this.avatar,
    required this.pnl,
    required this.pnlPct,
    required this.volume,
    required this.trades,
    required this.winRate,
    this.biggestWin,
    this.biggestWinMarket,
  });

  final int rank;
  final String user;
  final String avatar;
  final double pnl;
  final double pnlPct;
  final double volume;
  final int trades;
  final int winRate;
  final double? biggestWin;
  final String? biggestWinMarket;

  PredictionLeaderboardTraderDraft copyWith({int? rank}) {
    return PredictionLeaderboardTraderDraft(
      rank: rank ?? this.rank,
      user: user,
      avatar: avatar,
      pnl: pnl,
      pnlPct: pnlPct,
      volume: volume,
      trades: trades,
      winRate: winRate,
      biggestWin: biggestWin,
      biggestWinMarket: biggestWinMarket,
    );
  }
}

final class PredictionGlobalActivitySnapshot {
  const PredictionGlobalActivitySnapshot({
    required this.events,
    required this.activities,
    required this.totalVolume,
    required this.buyCount,
    required this.sellCount,
    required this.minAmount,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionEventDraft> events;
  final List<PredictionGlobalActivityDraft> activities;
  final double totalVolume;
  final int buyCount;
  final int sellCount;
  final double minAmount;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  PredictionEventDraft eventFor(String eventId) {
    return events.firstWhere(
      (event) => event.id == eventId,
      orElse: () => events.first,
    );
  }
}

final class PredictionGlobalActivityDraft {
  const PredictionGlobalActivityDraft({
    required this.id,
    required this.user,
    required this.avatar,
    required this.action,
    required this.outcome,
    required this.eventId,
    required this.price,
    required this.amount,
    required this.shares,
    required this.timestamp,
  });

  final String id;
  final String user;
  final String avatar;
  final PredictionGlobalActivityAction action;
  final String outcome;
  final String eventId;
  final double price;
  final double amount;
  final int shares;
  final String timestamp;
}

enum PredictionGlobalActivityAction { bought, sold }

final class PredictionOrderReceiptSnapshot {
  const PredictionOrderReceiptSnapshot({
    required this.receiptId,
    required this.receipt,
    required this.events,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String receiptId;
  final PredictionPortfolioReceiptDraft? receipt;
  final List<PredictionEventDraft> events;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  bool get found => receipt != null;

  PredictionEventDraft? get event {
    final current = receipt;
    if (current == null) return null;
    return events.firstWhere(
      (event) => event.id == current.eventId,
      orElse: () => events.first,
    );
  }
}

final class PredictionRiskCalculatorSnapshot {
  const PredictionRiskCalculatorSnapshot({
    required this.defaultEventName,
    required this.defaultOutcome,
    required this.defaultShares,
    required this.defaultEntryPrice,
    required this.defaultCurrentPrice,
    required this.defaultBankroll,
    required this.events,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String defaultEventName;
  final String defaultOutcome;
  final double defaultShares;
  final double defaultEntryPrice;
  final double defaultCurrentPrice;
  final double defaultBankroll;
  final List<PredictionEventDraft> events;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;
}

final class PredictionMarketMakerSnapshot {
  const PredictionMarketMakerSnapshot({
    required this.defaultEventName,
    required this.defaultSpreadBps,
    required this.defaultMinDepth,
    required this.positions,
    required this.earningsHistory,
    required this.events,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String defaultEventName;
  final int defaultSpreadBps;
  final double defaultMinDepth;
  final List<PredictionLiquidityPositionDraft> positions;
  final List<PredictionEarningsPointDraft> earningsHistory;
  final List<PredictionEventDraft> events;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  double get totalLiquidity =>
      positions.fold(0, (sum, position) => sum + position.liquidityProvided);

  double get totalValue =>
      positions.fold(0, (sum, position) => sum + position.currentValue);

  double get totalFees =>
      positions.fold(0, (sum, position) => sum + position.feesEarned);

  double get totalImpermanentLoss =>
      positions.fold(0, (sum, position) => sum + position.impermanentLoss);

  double get netReturn =>
      totalValue - totalLiquidity + totalFees + totalImpermanentLoss;

  double get netReturnPercent =>
      totalLiquidity == 0 ? 0 : (netReturn / totalLiquidity) * 100;

  double get averageApr => positions.isEmpty
      ? 0
      : positions.fold(0.0, (sum, position) => sum + position.apr) /
            positions.length;
}

final class PredictionLiquidityPositionDraft {
  const PredictionLiquidityPositionDraft({
    required this.id,
    required this.eventName,
    required this.liquidityProvided,
    required this.currentValue,
    required this.feesEarned,
    required this.impermanentLoss,
    required this.apr,
    required this.dateAdded,
    required this.status,
  });

  final String id;
  final String eventName;
  final double liquidityProvided;
  final double currentValue;
  final double feesEarned;
  final double impermanentLoss;
  final double apr;
  final DateTime dateAdded;
  final String status;

  double get netPnl =>
      currentValue - liquidityProvided + feesEarned + impermanentLoss;

  double get netPnlPercent =>
      liquidityProvided == 0 ? 0 : (netPnl / liquidityProvided) * 100;
}

final class PredictionEarningsPointDraft {
  const PredictionEarningsPointDraft({
    required this.date,
    required this.fees,
    required this.volume,
  });

  final String date;
  final double fees;
  final double volume;
}

final class PredictionPortfolioAnalyzerSnapshot {
  const PredictionPortfolioAnalyzerSnapshot({
    required this.positions,
    required this.pnlHistory,
    required this.events,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionAnalyzerPositionDraft> positions;
  final List<PredictionAnalyzerPnlPointDraft> pnlHistory;
  final List<PredictionEventDraft> events;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  List<PredictionAnalyzerPositionDraft> get openPositions => positions
      .where(
        (position) => position.status == PredictionAnalyzerPositionStatus.open,
      )
      .toList();

  List<PredictionAnalyzerPositionDraft> get closedPositions => positions
      .where(
        (position) =>
            position.status == PredictionAnalyzerPositionStatus.closed,
      )
      .toList();

  double get totalInvested => positions.fold<double>(
    0,
    (sum, position) => sum + position.investedAmount,
  );

  double get currentValue => openPositions.fold<double>(
    0,
    (sum, position) => sum + position.currentValue,
  );

  double get realizedPnl =>
      closedPositions.fold<double>(0, (sum, position) => sum + position.pnl);

  double get unrealizedPnl =>
      openPositions.fold<double>(0, (sum, position) => sum + position.pnl);

  double get totalPnl => realizedPnl + unrealizedPnl;

  double get totalPortfolioValue => totalInvested + totalPnl;

  double get totalPnlPercent =>
      totalInvested == 0 ? 0 : (totalPnl / totalInvested) * 100;

  int get winningTrades =>
      closedPositions.where((position) => position.pnl > 0).length;

  int get losingTrades =>
      closedPositions.where((position) => position.pnl < 0).length;

  int get totalTrades => closedPositions.length;

  double get winRate =>
      totalTrades == 0 ? 0 : (winningTrades / totalTrades) * 100;

  double get averageTrade =>
      positions.isEmpty ? 0 : totalInvested / positions.length;

  List<PredictionAnalyzerCategoryDraft> get categories {
    final totals = <String, ({double invested, double pnl})>{};
    for (final position in positions) {
      final current = totals[position.category] ?? (invested: 0, pnl: 0);
      totals[position.category] = (
        invested: current.invested + position.investedAmount,
        pnl: current.pnl + position.pnl,
      );
    }
    return totals.entries
        .map(
          (entry) => PredictionAnalyzerCategoryDraft(
            name: entry.key,
            invested: entry.value.invested,
            pnl: entry.value.pnl,
          ),
        )
        .toList();
  }
}

final class PredictionAnalyzerPositionDraft {
  const PredictionAnalyzerPositionDraft({
    required this.id,
    required this.eventName,
    required this.category,
    required this.outcome,
    required this.shares,
    required this.avgPrice,
    required this.currentPrice,
    required this.status,
    this.resolvedAtLabel,
    this.closedPnl,
  });

  final String id;
  final String eventName;
  final String category;
  final String outcome;
  final double shares;
  final double avgPrice;
  final double currentPrice;
  final PredictionAnalyzerPositionStatus status;
  final String? resolvedAtLabel;
  final double? closedPnl;

  double get investedAmount => shares * avgPrice;

  double get currentValue => shares * currentPrice;

  double get pnl => status == PredictionAnalyzerPositionStatus.closed
      ? (closedPnl ?? 0)
      : currentValue - investedAmount;
}

enum PredictionAnalyzerPositionStatus { open, closed }

final class PredictionAnalyzerPnlPointDraft {
  const PredictionAnalyzerPnlPointDraft({
    required this.date,
    required this.value,
  });

  final String date;
  final double value;
}

final class PredictionAnalyzerCategoryDraft {
  const PredictionAnalyzerCategoryDraft({
    required this.name,
    required this.invested,
    required this.pnl,
  });

  final String name;
  final double invested;
  final double pnl;
}

final class PredictionEventCalendarSnapshot {
  const PredictionEventCalendarSnapshot({
    required this.events,
    required this.categories,
    required this.selectedCategory,
    required this.predictionEvents,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionCalendarEventDraft> events;
  final List<String> categories;
  final String? selectedCategory;
  final List<PredictionEventDraft> predictionEvents;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  int get watchingCount =>
      _predictionCalendarEvents.where((event) => event.isWatching).length;

  int get thisMonthCount {
    final now = DateTime.utc(2026, 5, 20);
    return events
        .where(
          (event) =>
              event.resolutionDate.month == now.month &&
              event.resolutionDate.year == now.year,
        )
        .length;
  }

  List<PredictionCalendarEventDraft> get upcomingEvents {
    final filtered = events
        .where(
          (event) =>
              event.status == PredictionCalendarEventStatus.active ||
              event.status == PredictionCalendarEventStatus.upcoming,
        )
        .toList();
    filtered.sort((a, b) => a.resolutionDate.compareTo(b.resolutionDate));
    return filtered;
  }

  List<PredictionCalendarEventDraft> get watchingEvents =>
      _predictionCalendarEvents.where((event) => event.isWatching).toList();

  List<PredictionCalendarMonthDraft> get months {
    final grouped = <String, List<PredictionCalendarEventDraft>>{};
    for (final event in events) {
      final key = _monthLabel(event.resolutionDate);
      grouped[key] = [...(grouped[key] ?? const []), event];
    }
    return grouped.entries
        .map(
          (entry) => PredictionCalendarMonthDraft(
            label: entry.key,
            events: entry.value,
          ),
        )
        .toList();
  }
}

final class PredictionCalendarEventDraft {
  const PredictionCalendarEventDraft({
    required this.id,
    required this.title,
    required this.category,
    required this.resolutionDate,
    required this.status,
    required this.probability,
    required this.volume,
    required this.isWatching,
    this.notifyBefore,
  });

  final String id;
  final String title;
  final String category;
  final DateTime resolutionDate;
  final PredictionCalendarEventStatus status;
  final int probability;
  final double volume;
  final bool isWatching;
  final String? notifyBefore;
}

enum PredictionCalendarEventStatus { active, upcoming, resolving, resolved }

final class PredictionCalendarMonthDraft {
  const PredictionCalendarMonthDraft({
    required this.label,
    required this.events,
  });

  final String label;
  final List<PredictionCalendarEventDraft> events;
}

final class PredictionSocialSnapshot {
  const PredictionSocialSnapshot({
    required this.eventTitle,
    required this.comments,
    required this.sentiment,
    required this.contributors,
    required this.shareUrl,
    required this.predictionEvents,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String eventTitle;
  final List<PredictionSocialCommentDraft> comments;
  final List<PredictionSentimentDraft> sentiment;
  final List<PredictionContributorDraft> contributors;
  final String shareUrl;
  final List<PredictionEventDraft> predictionEvents;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  int get totalComments =>
      comments.fold<int>(0, (sum, comment) => sum + 1 + comment.replies.length);

  int get bullishPercent => sentiment
      .firstWhere(
        (item) => item.name == 'Bullish',
        orElse: () => const PredictionSentimentDraft(
          name: 'Bullish',
          value: 0,
          color: AppColors.buy,
        ),
      )
      .value;
}

final class PredictionSocialCommentDraft {
  const PredictionSocialCommentDraft({
    required this.id,
    required this.userName,
    required this.userTier,
    required this.content,
    required this.stance,
    required this.upvotes,
    required this.downvotes,
    required this.createdAtLabel,
    this.replies = const [],
    this.isPinned = false,
  });

  final String id;
  final String userName;
  final PredictionSocialTier userTier;
  final String content;
  final PredictionSocialStance stance;
  final int upvotes;
  final int downvotes;
  final String createdAtLabel;
  final List<PredictionSocialCommentDraft> replies;
  final bool isPinned;
}

enum PredictionSocialTier { bronze, silver, gold, platinum }

enum PredictionSocialStance { bullish, bearish, neutral }

final class PredictionSentimentDraft {
  const PredictionSentimentDraft({
    required this.name,
    required this.value,
    required this.color,
  });

  final String name;
  final int value;
  final Color color;
}

final class PredictionContributorDraft {
  const PredictionContributorDraft({
    required this.name,
    required this.tier,
    required this.comments,
    required this.upvotes,
  });

  final String name;
  final PredictionSocialTier tier;
  final int comments;
  final int upvotes;
}

final class PredictionAdvancedChartSnapshot {
  const PredictionAdvancedChartSnapshot({
    required this.eventId,
    required this.priceHistory,
    required this.orderFlow,
    required this.indicators,
    required this.patterns,
    required this.predictionEvents,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String eventId;
  final List<PredictionChartPointDraft> priceHistory;
  final List<PredictionOrderFlowDraft> orderFlow;
  final List<PredictionIndicatorSignalDraft> indicators;
  final List<PredictionPatternDraft> patterns;
  final List<PredictionEventDraft> predictionEvents;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  double get currentProbability => priceHistory.last.price;

  double get priceChangePercent {
    final first = priceHistory.first.price;
    if (first == 0) return 0;
    return ((currentProbability - first) / first) * 100;
  }

  int get currentRsi => priceHistory.last.rsi;

  double get supportLevel => .62;

  double get resistanceLevel => .72;
}

final class PredictionChartPointDraft {
  const PredictionChartPointDraft({
    required this.time,
    required this.price,
    required this.volume,
    required this.ma7,
    required this.ma25,
    required this.rsi,
    required this.bbUpper,
    required this.bbLower,
  });

  final String time;
  final double price;
  final int volume;
  final double ma7;
  final double ma25;
  final int rsi;
  final double bbUpper;
  final double bbLower;
}

final class PredictionOrderFlowDraft {
  const PredictionOrderFlowDraft({
    required this.price,
    required this.buyVolume,
    required this.sellVolume,
  });

  final double price;
  final int buyVolume;
  final int sellVolume;
}

final class PredictionIndicatorSignalDraft {
  const PredictionIndicatorSignalDraft({
    required this.name,
    required this.signal,
    required this.strength,
    required this.color,
    required this.description,
  });

  final String name;
  final String signal;
  final String strength;
  final Color color;
  final String description;
}

final class PredictionPatternDraft {
  const PredictionPatternDraft({
    required this.name,
    required this.confidence,
    this.bullish = true,
  });

  final String name;
  final int confidence;
  final bool bullish;
}

final class PredictionTournamentsSnapshot {
  const PredictionTournamentsSnapshot({
    required this.tournaments,
    required this.leaderboard,
    required this.predictionEvents,
    required this.orders,
    required this.receipts,
    required this.rewards,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<PredictionTournamentDraft> tournaments;
  final List<PredictionTournamentLeaderboardEntry> leaderboard;
  final List<PredictionEventDraft> predictionEvents;
  final List<PredictionPortfolioOrderDraft> orders;
  final List<PredictionPortfolioReceiptDraft> receipts;
  final List<PredictionRewardDraft> rewards;
  final String lastUpdatedLabel;
  final Set<PredictionScreenState> supportedStates;

  List<PredictionTournamentDraft> get activeTournaments => tournaments
      .where((item) => item.status == TournamentStatus.active)
      .toList();

  List<PredictionTournamentDraft> get upcomingTournaments => tournaments
      .where((item) => item.status == TournamentStatus.upcoming)
      .toList();

  List<PredictionTournamentDraft> get myTournaments =>
      tournaments.where((item) => item.isJoined).toList();

  List<PredictionTournamentDraft> get pastTournaments => tournaments
      .where((item) => item.status == TournamentStatus.ended)
      .toList();
}

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
    required this.color,
  });

  final String label;
  final int chance;
  final Color color;
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

enum PredictionLeaderboardMetric { pnl, volume }

final class MockPredictionsRepository implements PredictionsRepository {
  const MockPredictionsRepository();

  @override
  PredictionHomeSnapshot getHome({
    PredictionFilterTab filter = PredictionFilterTab.trending,
    String? category,
    String searchQuery = '',
  }) {
    var events = _applyFilter(_predictionEvents, filter);
    if (category != null && category.isNotEmpty) {
      events = events.where((event) => event.category == category).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      events = events
          .where(
            (event) =>
                event.title.toLowerCase().contains(query) ||
                event.category.toLowerCase().contains(query) ||
                event.tags.any((tag) => tag.toLowerCase().contains(query)),
          )
          .toList();
    }

    final breakingMovers =
        _predictionEvents
            .where((event) => event.status == PredictionEventStatus.active)
            .toList()
          ..sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));

    return PredictionHomeSnapshot(
      events: events,
      categories: _predictionCategories,
      positions: _predictionPositions,
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      breakingMovers: breakingMovers.take(3).toList(),
      openPositionCount: _predictionPositions
          .where((position) => position.status == PredictionPositionStatus.open)
          .length,
      filter: filter,
      category: category,
      searchQuery: searchQuery,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionSearchSnapshot getSearch({
    PredictionSearchSort sort = PredictionSearchSort.trending,
    PredictionStatusFilter status = PredictionStatusFilter.active,
    String? category,
    String searchQuery = '',
  }) {
    var events = _predictionEvents.toList();

    switch (status) {
      case PredictionStatusFilter.active:
        events = events
            .where((event) => event.status == PredictionEventStatus.active)
            .toList();
      case PredictionStatusFilter.resolved:
        events = events
            .where((event) => event.status == PredictionEventStatus.resolved)
            .toList();
      case PredictionStatusFilter.all:
        break;
    }

    if (category != null && category.isNotEmpty) {
      events = events.where((event) => event.category == category).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      events = events
          .where(
            (event) =>
                event.title.toLowerCase().contains(query) ||
                event.category.toLowerCase().contains(query) ||
                event.tags.any((tag) => tag.toLowerCase().contains(query)),
          )
          .toList();
    }

    events = _sortSearchEvents(events, sort);

    return PredictionSearchSnapshot(
      results: events,
      categories: _predictionCategories,
      sort: sort,
      status: status,
      category: category,
      searchQuery: searchQuery,
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionBreakingSnapshot getBreaking({String? category}) {
    var movers = _predictionEvents
        .where(
          (event) =>
              event.status == PredictionEventStatus.active &&
              event.change24h != 0,
        )
        .toList();
    if (category != null && category.isNotEmpty) {
      movers = movers.where((event) => event.category == category).toList();
    }
    movers.sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));

    return PredictionBreakingSnapshot(
      movers: movers,
      categories: const [
        'Politics',
        'Sports',
        'Live Crypto',
        'Finance',
        'Tech',
        'AI',
        'Culture',
      ],
      category: category,
      upCount: movers.where((event) => event.change24h > 0).length,
      downCount: movers.where((event) => event.change24h < 0).length,
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionEventDetailSnapshot getEventDetail(String eventId) {
    final event = _predictionEvents.firstWhere(
      (item) => item.id == eventId,
      orElse: () => _predictionEvents.first,
    );
    PredictionPositionDraft? openPosition;
    for (final position in _predictionPositions) {
      if (position.eventId == event.id) {
        openPosition = position;
        break;
      }
    }
    final relatedEvents = _predictionEvents
        .where(
          (item) =>
              item.id != event.id &&
              item.status == PredictionEventStatus.active &&
              item.category == event.category,
        )
        .take(2)
        .toList();

    return PredictionEventDetailSnapshot(
      event: event,
      position: openPosition == null
          ? null
          : PredictionDetailPositionDraft(
              outcome: openPosition.outcome,
              shares: openPosition.shares,
              avgPrice: openPosition.avgPrice,
              pnl: 30,
              pnlPct: 21.4,
            ),
      relatedEvents: relatedEvents,
      probabilityHistory: [
        14,
        13,
        12,
        13,
        12,
        18,
        12,
        10,
        24,
        17,
        12,
        21,
        21,
        20,
        18,
        19,
        29,
        21,
        19,
        33,
        27,
        23,
        30,
        30,
        30,
        27,
        29,
        39,
        31,
        event.outcomes.first.chance,
      ],
      volumeHistory: const [
        9,
        5,
        7,
        13,
        6,
        16,
        8,
        15,
        12,
        17,
        7,
        13,
        19,
        17,
        17,
        12,
        9,
        5,
        13,
        15,
        11,
        9,
        8,
        10,
        6,
        15,
        8,
        7,
        9,
        6,
      ],
      orderBook: const PredictionOrderBookDraft(
        bids: [
          PredictionOrderBookEntryDraft(price: .33, shares: 1280),
          PredictionOrderBookEntryDraft(price: .32, shares: 2140),
          PredictionOrderBookEntryDraft(price: .31, shares: 1740),
        ],
        asks: [
          PredictionOrderBookEntryDraft(price: .35, shares: 1160),
          PredictionOrderBookEntryDraft(price: .36, shares: 1890),
          PredictionOrderBookEntryDraft(price: .37, shares: 1420),
        ],
      ),
      rules: const [
        'Resolution is based on publicly verifiable information from the specified source.',
        'If the outcome is ambiguous, the market operator will consult multiple sources.',
        'Markets may be voided if the underlying event is cancelled or fundamentally altered.',
        'All times are in UTC. The market closes at 23:59:59 UTC on the end date.',
        'Shares of the winning outcome pay out \$1.00. Losing shares pay \$0.00.',
      ],
      topHolders: const [
        PredictionHolderDraft(name: 'AlphaDesk', outcome: 'Yes', shares: 8200),
        PredictionHolderDraft(name: 'NorthStar', outcome: 'No', shares: 6400),
        PredictionHolderDraft(name: 'QuantPro', outcome: 'Yes', shares: 5100),
      ],
      activity: const [
        PredictionActivityDraft(
          actor: 'Trader A',
          action: 'bought Yes',
          amount: '200 shares',
          time: '2m ago',
        ),
        PredictionActivityDraft(
          actor: 'Market maker',
          action: 'added liquidity',
          amount: '\$12K',
          time: '9m ago',
        ),
      ],
      arenaRooms: const [
        PredictionArenaRoomDraft(
          title: 'BTC \$70K? — Tuần 9',
          slots: '38/50 slots',
          points: 100,
          badge: 'Closest Guess',
        ),
        PredictionArenaRoomDraft(
          title: 'Altcoin Battle — SOL vs AVAX',
          slots: '40/40 slots',
          points: 200,
          badge: 'Team Battle',
        ),
      ],
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionPortfolioSnapshot getPortfolio() {
    final totalCurrent = _predictionPortfolioPositions.fold<double>(
      0,
      (sum, position) => sum + position.currentValue,
    );
    final totalInvested = _predictionPortfolioPositions.fold<double>(
      0,
      (sum, position) => sum + position.investedAmount,
    );
    final totalPnl = _predictionPortfolioPositions.fold<double>(
      0,
      (sum, position) => sum + position.pnl,
    );

    return PredictionPortfolioSnapshot(
      events: _predictionEvents,
      positions: _predictionPortfolioPositions,
      openOrders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      totalCurrentValue: totalCurrent,
      totalInvested: totalInvested,
      totalPnl: totalPnl,
      totalPnlPct: totalInvested == 0 ? 0 : (totalPnl / totalInvested) * 100,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionRewardsSnapshot getRewards() {
    final totalDailyPool = _predictionRewardOpportunities.fold<double>(
      0,
      (sum, reward) => sum + reward.dailyReward,
    );

    return PredictionRewardsSnapshot(
      events: _predictionEvents,
      categories: _predictionCategories,
      rewards: _predictionRewardOpportunities,
      arenaRooms: _predictionRewardArenaRooms,
      totalDailyPool: totalDailyPool,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionLeaderboardSnapshot getLeaderboard({
    PredictionLeaderboardTimeFilter timeFilter =
        PredictionLeaderboardTimeFilter.weekly,
    PredictionLeaderboardMetric metric = PredictionLeaderboardMetric.pnl,
  }) {
    final base =
        (_predictionLeaderboardData[timeFilter] ??
                _predictionLeaderboardData[PredictionLeaderboardTimeFilter
                    .weekly]!)
            .toList();
    final traders = metric == PredictionLeaderboardMetric.volume
        ? (base..sort((a, b) => b.volume.compareTo(a.volume)))
              .asMap()
              .entries
              .map((entry) => entry.value.copyWith(rank: entry.key + 1))
              .toList()
        : base;

    return PredictionLeaderboardSnapshot(
      events: _predictionEvents,
      traders: traders,
      biggestWins: traders
          .where(
            (trader) =>
                trader.biggestWin != null && trader.biggestWinMarket != null,
          )
          .take(4)
          .toList(),
      timeFilter: timeFilter,
      metric: metric,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionGlobalActivitySnapshot getGlobalActivity({double minAmount = 0}) {
    final allActivity = _generatePredictionGlobalActivity();
    final filtered = minAmount <= 0
        ? allActivity
        : allActivity
              .where((activity) => activity.amount >= minAmount)
              .toList();

    return PredictionGlobalActivitySnapshot(
      events: _predictionEvents,
      activities: filtered,
      totalVolume: allActivity.fold<double>(
        0,
        (sum, activity) => sum + activity.amount,
      ),
      buyCount: allActivity
          .where(
            (activity) =>
                activity.action == PredictionGlobalActivityAction.bought,
          )
          .length,
      sellCount: allActivity
          .where(
            (activity) =>
                activity.action == PredictionGlobalActivityAction.sold,
          )
          .length,
      minAmount: minAmount,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionOrderReceiptSnapshot getOrderReceipt(String receiptId) {
    PredictionPortfolioReceiptDraft? receipt;
    for (final candidate in _predictionPortfolioReceipts) {
      if (candidate.id == receiptId) {
        receipt = candidate;
        break;
      }
    }

    return PredictionOrderReceiptSnapshot(
      receiptId: receiptId,
      receipt: receipt,
      events: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionRiskCalculatorSnapshot getRiskCalculator() {
    return PredictionRiskCalculatorSnapshot(
      defaultEventName: 'BTC > \$100K by Dec 2026?',
      defaultOutcome: 'yes',
      defaultShares: 100,
      defaultEntryPrice: .65,
      defaultCurrentPrice: .68,
      defaultBankroll: 10000,
      events: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionMarketMakerSnapshot getMarketMaker() {
    return PredictionMarketMakerSnapshot(
      defaultEventName: 'BTC > \$100K by Dec 2026?',
      defaultSpreadBps: 50,
      defaultMinDepth: 1000,
      positions: _predictionLiquidityPositions,
      earningsHistory: _predictionEarningsHistory,
      events: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionPortfolioAnalyzerSnapshot getPortfolioAnalyzer() {
    return PredictionPortfolioAnalyzerSnapshot(
      positions: _predictionAnalyzerPositions,
      pnlHistory: _predictionAnalyzerPnlHistory,
      events: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionEventCalendarSnapshot getEventCalendar({String? category}) {
    final events = category == null
        ? _predictionCalendarEvents
        : _predictionCalendarEvents
              .where((event) => event.category == category)
              .toList();
    return PredictionEventCalendarSnapshot(
      events: events,
      categories: _predictionCalendarCategories,
      selectedCategory: category,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionSocialSnapshot getSocial() {
    return PredictionSocialSnapshot(
      eventTitle: 'BTC > \$100K by Dec 2026?',
      comments: _predictionSocialComments,
      sentiment: _predictionSocialSentiment,
      contributors: _predictionSocialContributors,
      shareUrl: 'https://app.example.com/predictions/event/pred-1',
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionAdvancedChartSnapshot getAdvancedChart(String eventId) {
    return PredictionAdvancedChartSnapshot(
      eventId: eventId,
      priceHistory: _predictionAdvancedPriceHistory,
      orderFlow: _predictionAdvancedOrderFlow,
      indicators: _predictionAdvancedIndicators,
      patterns: _predictionAdvancedPatterns,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionTournamentsSnapshot getTournaments() {
    return PredictionTournamentsSnapshot(
      tournaments: _predictionTournaments,
      leaderboard: _predictionTournamentLeaderboard,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  PredictionDataIntegrationSnapshot getDataIntegration() {
    return PredictionDataIntegrationSnapshot(
      sources: _predictionDataSources,
      apiKeys: _predictionApiKeys,
      webhooks: _predictionWebhooks,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }
}

List<PredictionEventDraft> _applyFilter(
  List<PredictionEventDraft> events,
  PredictionFilterTab filter,
) {
  final active = events
      .where((event) => event.status == PredictionEventStatus.active)
      .toList();
  switch (filter) {
    case PredictionFilterTab.trending:
      active.sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));
    case PredictionFilterTab.newEvents:
      active.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case PredictionFilterTab.popular:
      active.sort((a, b) => b.participants.compareTo(a.participants));
    case PredictionFilterTab.liquid:
      active.sort((a, b) => b.liquidity.compareTo(a.liquidity));
    case PredictionFilterTab.ending:
      active.sort((a, b) => a.endDate.compareTo(b.endDate));
    case PredictionFilterTab.competitive:
      active.sort(
        (a, b) => (a.outcomes.first.chance - 50).abs().compareTo(
          (b.outcomes.first.chance - 50).abs(),
        ),
      );
  }
  return active;
}

List<PredictionEventDraft> _sortSearchEvents(
  List<PredictionEventDraft> events,
  PredictionSearchSort sort,
) {
  final sorted = events.toList();
  switch (sort) {
    case PredictionSearchSort.trending:
      sorted.sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));
    case PredictionSearchSort.liquidity:
      sorted.sort((a, b) => b.liquidity.compareTo(a.liquidity));
    case PredictionSearchSort.volume:
      sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    case PredictionSearchSort.newest:
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case PredictionSearchSort.ending:
      sorted.sort((a, b) => a.endDate.compareTo(b.endDate));
    case PredictionSearchSort.competitive:
      sorted.sort(
        (a, b) => (a.outcomes.first.chance - 50).abs().compareTo(
          (b.outcomes.first.chance - 50).abs(),
        ),
      );
  }
  return sorted;
}

String _monthLabel(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.year}';
}

const List<String> _predictionCategories = [
  'Live Crypto',
  'Politics',
  'Sports',
  'Tech',
  'AI',
  'Finance',
  'Culture',
];

final List<PredictionEventDraft> _predictionEvents = [
  PredictionEventDraft(
    id: 'pred-1',
    title: 'Bitcoin reaches \$150K before July 2026?',
    category: 'Live Crypto',
    tags: ['BTC', 'Price Target'],
    outcomes: _yesNo(34, 66),
    volume24h: 2450000,
    totalVolume: 18700000,
    endDate: DateTime.utc(2026, 7, 1),
    liquidity: 5200000,
    participants: 12840,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 5.2,
    createdAt: DateTime.utc(2026, 1, 15),
  ),
  PredictionEventDraft(
    id: 'pred-2',
    title: 'Ethereum ETF approved in Q2 2026?',
    category: 'Live Crypto',
    tags: ['ETH', 'Regulation'],
    outcomes: _yesNo(72, 28),
    volume24h: 1830000,
    totalVolume: 14200000,
    endDate: DateTime.utc(2026, 6, 30),
    liquidity: 3800000,
    participants: 9450,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 3.8,
    createdAt: DateTime.utc(2026, 1, 20),
  ),
  PredictionEventDraft(
    id: 'pred-3',
    title: 'US Presidential approval rating above 50% by March?',
    category: 'Politics',
    tags: ['US', 'Approval'],
    outcomes: _yesNo(41, 59),
    volume24h: 980000,
    totalVolume: 8100000,
    endDate: DateTime.utc(2026, 3, 31),
    liquidity: 2100000,
    participants: 6320,
    status: PredictionEventStatus.active,
    change24h: -2.1,
    createdAt: DateTime.utc(2026, 1, 10),
  ),
  PredictionEventDraft(
    id: 'pred-4',
    title: 'Champions League Winner 2026',
    category: 'Sports',
    tags: ['Football', 'UCL'],
    outcomes: const [
      PredictionOutcomeDraft(
        label: 'Real Madrid',
        chance: 28,
        color: AppColors.warn,
      ),
      PredictionOutcomeDraft(
        label: 'Man City',
        chance: 24,
        color: Color(0xFF3B82F6),
      ),
      PredictionOutcomeDraft(
        label: 'Bayern',
        chance: 18,
        color: AppColors.sell,
      ),
      PredictionOutcomeDraft(
        label: 'Other',
        chance: 30,
        color: AppColors.accent,
      ),
    ],
    volume24h: 1250000,
    totalVolume: 11300000,
    endDate: DateTime.utc(2026, 6, 1),
    liquidity: 4500000,
    participants: 15200,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 1.5,
    createdAt: DateTime.utc(2025, 12, 1),
  ),
  PredictionEventDraft(
    id: 'pred-5',
    title: 'Apple releases AR glasses in 2026?',
    category: 'Tech',
    tags: ['Apple', 'AR/VR'],
    outcomes: _yesNo(55, 45),
    volume24h: 720000,
    totalVolume: 5400000,
    endDate: DateTime.utc(2026, 12, 31),
    liquidity: 1800000,
    participants: 4100,
    status: PredictionEventStatus.active,
    isNew: true,
    change24h: 8.3,
    createdAt: DateTime.utc(2026, 2, 20),
  ),
  PredictionEventDraft(
    id: 'pred-6',
    title: 'GPT-5 released before June 2026?',
    category: 'AI',
    tags: ['OpenAI', 'LLM'],
    outcomes: _yesNo(68, 32),
    volume24h: 1560000,
    totalVolume: 9800000,
    endDate: DateTime.utc(2026, 6, 1),
    liquidity: 3200000,
    participants: 8900,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: -1.2,
    createdAt: DateTime.utc(2026, 1, 5),
  ),
  PredictionEventDraft(
    id: 'pred-7',
    title: 'Fed cuts rates below 4% by Q3 2026?',
    category: 'Finance',
    tags: ['Fed', 'Interest Rate'],
    outcomes: _yesNo(47, 53),
    volume24h: 890000,
    totalVolume: 7200000,
    endDate: DateTime.utc(2026, 9, 30),
    liquidity: 2600000,
    participants: 5800,
    status: PredictionEventStatus.active,
    change24h: 2.4,
    createdAt: DateTime.utc(2026, 2, 1),
  ),
  PredictionEventDraft(
    id: 'pred-8',
    title: 'Next Marvel movie grosses \$1B worldwide?',
    category: 'Culture',
    tags: ['Marvel', 'Box Office'],
    outcomes: _yesNo(62, 38),
    volume24h: 340000,
    totalVolume: 2800000,
    endDate: DateTime.utc(2026, 8, 1),
    liquidity: 950000,
    participants: 3200,
    status: PredictionEventStatus.active,
    change24h: .8,
    createdAt: DateTime.utc(2026, 2, 10),
  ),
  PredictionEventDraft(
    id: 'pred-9',
    title: 'Solana price above \$500 by March 2026?',
    category: 'Live Crypto',
    tags: ['SOL', 'Price Target'],
    outcomes: _yesNo(22, 78),
    volume24h: 1120000,
    totalVolume: 6500000,
    endDate: DateTime.utc(2026, 3, 31),
    liquidity: 2900000,
    participants: 7600,
    status: PredictionEventStatus.active,
    change24h: -4.5,
    createdAt: DateTime.utc(2026, 1, 25),
  ),
  PredictionEventDraft(
    id: 'pred-10',
    title: 'Tesla stock above \$400 by mid-2026?',
    category: 'Finance',
    tags: ['TSLA', 'Stock'],
    outcomes: _yesNo(38, 62),
    volume24h: 670000,
    totalVolume: 4300000,
    endDate: DateTime.utc(2026, 6, 30),
    liquidity: 1500000,
    participants: 4800,
    status: PredictionEventStatus.active,
    isNew: true,
    change24h: 6.1,
    createdAt: DateTime.utc(2026, 2, 22),
  ),
  PredictionEventDraft(
    id: 'pred-11',
    title: 'Will AI-generated movie win an Oscar by 2027?',
    category: 'AI',
    tags: ['AI', 'Entertainment'],
    outcomes: _yesNo(12, 88),
    volume24h: 290000,
    totalVolume: 1900000,
    endDate: DateTime.utc(2027, 3, 1),
    liquidity: 680000,
    participants: 2100,
    status: PredictionEventStatus.active,
    change24h: 1.1,
    createdAt: DateTime.utc(2026, 2, 18),
  ),
  PredictionEventDraft(
    id: 'pred-12',
    title: 'Crypto total market cap reaches \$5T in 2026?',
    category: 'Live Crypto',
    tags: ['Market Cap', 'Bull Run'],
    outcomes: _yesNo(45, 55),
    volume24h: 2100000,
    totalVolume: 15600000,
    endDate: DateTime.utc(2026, 12, 31),
    liquidity: 4800000,
    participants: 11200,
    status: PredictionEventStatus.active,
    isTrending: true,
    change24h: 3.2,
    createdAt: DateTime.utc(2026, 1, 1),
  ),
  PredictionEventDraft(
    id: 'pred-r1',
    title: 'Bitcoin above \$100K by Feb 2026?',
    category: 'Live Crypto',
    tags: ['BTC', 'Price'],
    outcomes: _yesNo(100, 0),
    volume24h: 0,
    totalVolume: 22000000,
    endDate: DateTime.utc(2026, 2, 1),
    liquidity: 0,
    participants: 18500,
    status: PredictionEventStatus.resolved,
    resolvedOutcome: 'Yes',
    change24h: 0,
    createdAt: DateTime.utc(2025, 6, 1),
  ),
  PredictionEventDraft(
    id: 'pred-r2',
    title: 'Super Bowl LX Winner: Kansas City?',
    category: 'Sports',
    tags: ['NFL', 'Super Bowl'],
    outcomes: _yesNo(0, 100),
    volume24h: 0,
    totalVolume: 9800000,
    endDate: DateTime.utc(2026, 2, 9),
    liquidity: 0,
    participants: 14200,
    status: PredictionEventStatus.resolved,
    resolvedOutcome: 'No',
    change24h: 0,
    createdAt: DateTime.utc(2025, 9, 1),
  ),
];

List<PredictionOutcomeDraft> _yesNo(int yes, int no) {
  return [
    PredictionOutcomeDraft(label: 'Yes', chance: yes, color: AppColors.buy),
    PredictionOutcomeDraft(label: 'No', chance: no, color: AppColors.sell),
  ];
}

const List<PredictionPositionDraft> _predictionPositions = [
  PredictionPositionDraft(
    id: 'pos-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    shares: 500,
    avgPrice: .28,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-2',
    eventId: 'pred-2',
    outcome: 'Yes',
    shares: 120,
    avgPrice: .61,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-3',
    eventId: 'pred-4',
    outcome: 'Real Madrid',
    shares: 80,
    avgPrice: .24,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-4',
    eventId: 'pred-10',
    outcome: 'No',
    shares: 140,
    avgPrice: .58,
    status: PredictionPositionStatus.open,
  ),
  PredictionPositionDraft(
    id: 'pos-5',
    eventId: 'pred-12',
    outcome: 'Yes',
    shares: 220,
    avgPrice: .41,
    status: PredictionPositionStatus.open,
  ),
];

final List<PredictionPortfolioPositionDraft> _predictionPortfolioPositions = [
  PredictionPortfolioPositionDraft(
    id: 'pos-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    shares: 500,
    avgPrice: .28,
    currentPrice: .34,
    investedAmount: 140,
    currentValue: 170,
    pnl: 30,
    pnlPct: 21.43,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 10),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-2',
    eventId: 'pred-2',
    outcome: 'Yes',
    shares: 300,
    avgPrice: .65,
    currentPrice: .72,
    investedAmount: 195,
    currentValue: 216,
    pnl: 21,
    pnlPct: 10.77,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 5),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-3',
    eventId: 'pred-6',
    outcome: 'No',
    shares: 200,
    avgPrice: .38,
    currentPrice: .32,
    investedAmount: 76,
    currentValue: 64,
    pnl: -12,
    pnlPct: -15.79,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 15),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-4',
    eventId: 'pred-5',
    outcome: 'Yes',
    shares: 400,
    avgPrice: .42,
    currentPrice: .55,
    investedAmount: 168,
    currentValue: 220,
    pnl: 52,
    pnlPct: 30.95,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 22),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-5',
    eventId: 'pred-r1',
    outcome: 'Yes',
    shares: 1000,
    avgPrice: .55,
    currentPrice: 1,
    investedAmount: 550,
    currentValue: 1000,
    pnl: 450,
    pnlPct: 81.82,
    status: PredictionPortfolioPositionStatus.won,
    purchasedAt: DateTime.utc(2025, 8, 1),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-6',
    eventId: 'pred-r2',
    outcome: 'Yes',
    shares: 250,
    avgPrice: .45,
    currentPrice: 0,
    investedAmount: 112.5,
    currentValue: 0,
    pnl: -112.5,
    pnlPct: -100,
    status: PredictionPortfolioPositionStatus.lost,
    purchasedAt: DateTime.utc(2025, 11, 1),
  ),
  PredictionPortfolioPositionDraft(
    id: 'pos-7',
    eventId: 'pred-9',
    outcome: 'No',
    shares: 150,
    avgPrice: .70,
    currentPrice: .78,
    investedAmount: 105,
    currentValue: 117,
    pnl: 12,
    pnlPct: 11.43,
    status: PredictionPortfolioPositionStatus.open,
    purchasedAt: DateTime.utc(2026, 2, 1),
  ),
];

final List<PredictionPortfolioOrderDraft> _predictionPortfolioOrders = [
  PredictionPortfolioOrderDraft(
    id: 'oo-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    side: 'buy',
    orderType: 'limit',
    price: .30,
    shares: 200,
    filled: 0,
    total: 60,
    createdAt: DateTime.utc(2026, 2, 27, 8),
  ),
  PredictionPortfolioOrderDraft(
    id: 'oo-2',
    eventId: 'pred-2',
    outcome: 'No',
    side: 'buy',
    orderType: 'limit',
    price: .25,
    shares: 150,
    filled: 50,
    total: 37.5,
    createdAt: DateTime.utc(2026, 2, 26, 15, 30),
  ),
  PredictionPortfolioOrderDraft(
    id: 'oo-3',
    eventId: 'pred-7',
    outcome: 'Yes',
    side: 'sell',
    orderType: 'limit',
    price: .55,
    shares: 100,
    filled: 0,
    total: 55,
    createdAt: DateTime.utc(2026, 2, 27, 10),
  ),
];

const List<PredictionPortfolioReceiptDraft> _predictionPortfolioReceipts = [
  PredictionPortfolioReceiptDraft(
    id: 'po-1',
    eventId: 'pred-1',
    eventTitle: 'Bitcoin reaches \$150K before July 2026?',
    outcome: 'Yes',
    side: 'buy',
    orderType: 'limit',
    shares: 200,
    filledShares: 0,
    price: .30,
    avgPrice: 0,
    total: 60,
    fee: 1.20,
    status: 'submitted',
    createdAt: '27/02 08:00',
    updatedAt: '27/02 08:00',
    timeline: [
      PredictionReceiptTimelineDraft(
        label: 'Lệnh đã gửi',
        date: '27/02 08:00',
        done: true,
      ),
      PredictionReceiptTimelineDraft(label: 'Tiếp nhận', date: '', done: false),
      PredictionReceiptTimelineDraft(label: 'Khớp lệnh', date: '', done: false),
    ],
  ),
  PredictionPortfolioReceiptDraft(
    id: 'po-2',
    eventId: 'pred-2',
    eventTitle: 'Ethereum ETF approved in Q2 2026?',
    outcome: 'No',
    side: 'buy',
    orderType: 'limit',
    shares: 150,
    filledShares: 50,
    price: .25,
    avgPrice: .24,
    total: 37.5,
    fee: .75,
    status: 'partially_filled',
    createdAt: '26/02 15:30',
    updatedAt: '26/02 18:45',
    timeline: [
      PredictionReceiptTimelineDraft(
        label: 'Lệnh đã gửi',
        date: '26/02 15:30',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Tiếp nhận',
        date: '26/02 15:30',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Khớp một phần (50/150)',
        date: '26/02 18:45',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Chờ khớp thêm',
        date: '',
        done: false,
      ),
    ],
  ),
  PredictionPortfolioReceiptDraft(
    id: 'po-3',
    eventId: 'pred-7',
    eventTitle: 'Fed cuts rates below 4% by Q3 2026?',
    outcome: 'Yes',
    side: 'sell',
    orderType: 'limit',
    shares: 100,
    filledShares: 0,
    price: .55,
    avgPrice: 0,
    total: 55,
    fee: 1.10,
    status: 'submitted',
    createdAt: '27/02 10:00',
    updatedAt: '27/02 10:00',
    timeline: [
      PredictionReceiptTimelineDraft(
        label: 'Lệnh đã gửi',
        date: '27/02 10:00',
        done: true,
      ),
      PredictionReceiptTimelineDraft(label: 'Tiếp nhận', date: '', done: false),
      PredictionReceiptTimelineDraft(label: 'Khớp lệnh', date: '', done: false),
    ],
  ),
  PredictionPortfolioReceiptDraft(
    id: 'po-4',
    eventId: 'pred-1',
    eventTitle: 'Bitcoin reaches \$150K before July 2026?',
    outcome: 'Yes',
    side: 'buy',
    orderType: 'market',
    shares: 300,
    filledShares: 300,
    price: .42,
    avgPrice: .42,
    total: 126,
    fee: 2.52,
    status: 'filled',
    createdAt: '25/02 14:00',
    updatedAt: '25/02 14:01',
    timeline: [
      PredictionReceiptTimelineDraft(
        label: 'Lệnh đã gửi',
        date: '25/02 14:00',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Tiếp nhận',
        date: '25/02 14:00',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Đã khớp toàn bộ',
        date: '25/02 14:01',
        done: true,
      ),
    ],
  ),
  PredictionPortfolioReceiptDraft(
    id: 'po-5',
    eventId: 'pred-5',
    eventTitle: 'Apple releases AR glasses in 2026?',
    outcome: 'No',
    side: 'buy',
    orderType: 'market',
    shares: 100,
    filledShares: 100,
    price: .65,
    avgPrice: .64,
    total: 65,
    fee: 1.30,
    status: 'filled',
    createdAt: '24/02 09:30',
    updatedAt: '24/02 09:31',
    timeline: [
      PredictionReceiptTimelineDraft(
        label: 'Lệnh đã gửi',
        date: '24/02 09:30',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Tiếp nhận',
        date: '24/02 09:30',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Đã khớp toàn bộ',
        date: '24/02 09:31',
        done: true,
      ),
    ],
  ),
  PredictionPortfolioReceiptDraft(
    id: 'po-6',
    eventId: 'pred-3',
    eventTitle: 'US Presidential approval rating above 50% by March?',
    outcome: 'Yes',
    side: 'buy',
    orderType: 'limit',
    shares: 80,
    filledShares: 0,
    price: .48,
    avgPrice: 0,
    total: 38.4,
    fee: .77,
    status: 'canceled',
    createdAt: '23/02 12:00',
    updatedAt: '24/02 08:00',
    timeline: [
      PredictionReceiptTimelineDraft(
        label: 'Lệnh đã gửi',
        date: '23/02 12:00',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Tiếp nhận',
        date: '23/02 12:01',
        done: true,
      ),
      PredictionReceiptTimelineDraft(
        label: 'Đã hủy bởi bạn',
        date: '24/02 08:00',
        done: true,
      ),
    ],
  ),
];

final List<PredictionLiquidityPositionDraft> _predictionLiquidityPositions = [
  PredictionLiquidityPositionDraft(
    id: 'lp_001',
    eventName: 'BTC > \$100K by Dec 2026?',
    liquidityProvided: 5000,
    currentValue: 5240,
    feesEarned: 320,
    impermanentLoss: -80,
    apr: 24.5,
    dateAdded: DateTime.utc(2026, 3, 1),
    status: 'active',
  ),
  PredictionLiquidityPositionDraft(
    id: 'lp_002',
    eventName: 'ETH merge to PoS in 2025?',
    liquidityProvided: 3000,
    currentValue: 3150,
    feesEarned: 180,
    impermanentLoss: -30,
    apr: 18.2,
    dateAdded: DateTime.utc(2026, 2, 1),
    status: 'active',
  ),
];

const List<PredictionEarningsPointDraft> _predictionEarningsHistory = [
  PredictionEarningsPointDraft(date: '01/03', fees: 45, volume: 1200),
  PredictionEarningsPointDraft(date: '08/03', fees: 62, volume: 1580),
  PredictionEarningsPointDraft(date: '15/03', fees: 58, volume: 1420),
  PredictionEarningsPointDraft(date: '22/03', fees: 71, volume: 1890),
  PredictionEarningsPointDraft(date: '29/03', fees: 84, volume: 2150),
  PredictionEarningsPointDraft(date: '05/04', fees: 92, volume: 2340),
];

const List<PredictionAnalyzerPositionDraft> _predictionAnalyzerPositions = [
  PredictionAnalyzerPositionDraft(
    id: 'p1',
    eventName: 'BTC > \$100K by Dec 2026?',
    category: 'Crypto',
    outcome: 'yes',
    shares: 100,
    avgPrice: .65,
    currentPrice: .68,
    status: PredictionAnalyzerPositionStatus.open,
  ),
  PredictionAnalyzerPositionDraft(
    id: 'p2',
    eventName: 'ETH merge to PoS in 2025?',
    category: 'Crypto',
    outcome: 'yes',
    shares: 80,
    avgPrice: .72,
    currentPrice: .75,
    status: PredictionAnalyzerPositionStatus.open,
  ),
  PredictionAnalyzerPositionDraft(
    id: 'p3',
    eventName: 'US Election 2024 - Candidate A wins?',
    category: 'Politics',
    outcome: 'no',
    shares: 120,
    avgPrice: .45,
    currentPrice: .42,
    status: PredictionAnalyzerPositionStatus.open,
  ),
  PredictionAnalyzerPositionDraft(
    id: 'p4',
    eventName: 'AI beats human in chess 2025?',
    category: 'Tech',
    outcome: 'yes',
    shares: 50,
    avgPrice: .88,
    currentPrice: 0,
    status: PredictionAnalyzerPositionStatus.closed,
    resolvedAtLabel: '13/05/2026',
    closedPnl: -44,
  ),
  PredictionAnalyzerPositionDraft(
    id: 'p5',
    eventName: 'Global GDP growth > 3% in 2025?',
    category: 'Macro',
    outcome: 'yes',
    shares: 200,
    avgPrice: .52,
    currentPrice: 1,
    status: PredictionAnalyzerPositionStatus.closed,
    resolvedAtLabel: '06/05/2026',
    closedPnl: 96,
  ),
];

const List<PredictionAnalyzerPnlPointDraft> _predictionAnalyzerPnlHistory = [
  PredictionAnalyzerPnlPointDraft(date: '01/03', value: 0),
  PredictionAnalyzerPnlPointDraft(date: '08/03', value: 12),
  PredictionAnalyzerPnlPointDraft(date: '15/03', value: -8),
  PredictionAnalyzerPnlPointDraft(date: '22/03', value: 24),
  PredictionAnalyzerPnlPointDraft(date: '29/03', value: 35),
  PredictionAnalyzerPnlPointDraft(date: '05/04', value: 52),
];

const List<String> _predictionCalendarCategories = [
  'Crypto',
  'Politics',
  'Tech',
  'Macro',
];

final List<PredictionCalendarEventDraft> _predictionCalendarEvents = [
  PredictionCalendarEventDraft(
    id: 'pred-1',
    title: 'BTC > \$100K by Dec 2026?',
    category: 'Crypto',
    resolutionDate: DateTime.utc(2026, 12, 31),
    status: PredictionCalendarEventStatus.active,
    probability: 68,
    volume: 2340000,
    isWatching: true,
    notifyBefore: '1 week',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-12',
    title: 'SpaceX Mars landing in 2026?',
    category: 'Tech',
    resolutionDate: DateTime.utc(2026, 12, 31),
    status: PredictionCalendarEventStatus.active,
    probability: 35,
    volume: 3400000,
    isWatching: true,
    notifyBefore: '1 week',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-2',
    title: 'ETH merge to PoS in 2025?',
    category: 'Crypto',
    resolutionDate: DateTime.utc(2025, 12, 31),
    status: PredictionCalendarEventStatus.active,
    probability: 75,
    volume: 1890000,
    isWatching: true,
    notifyBefore: '1 day',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-3',
    title: 'US Election 2024 - Candidate A wins?',
    category: 'Politics',
    resolutionDate: DateTime.utc(2024, 11, 5),
    status: PredictionCalendarEventStatus.upcoming,
    probability: 42,
    volume: 5600000,
    isWatching: false,
  ),
  PredictionCalendarEventDraft(
    id: 'pred-6',
    title: 'AI beats human in chess 2025?',
    category: 'Tech',
    resolutionDate: DateTime.utc(2025, 6, 30),
    status: PredictionCalendarEventStatus.resolving,
    probability: 88,
    volume: 890000,
    isWatching: true,
    notifyBefore: '1 hour',
  ),
  PredictionCalendarEventDraft(
    id: 'pred-5',
    title: 'Global GDP growth > 3% in 2025?',
    category: 'Macro',
    resolutionDate: DateTime.utc(2025, 3, 31),
    status: PredictionCalendarEventStatus.resolved,
    probability: 52,
    volume: 1200000,
    isWatching: false,
  ),
];

const List<PredictionSocialCommentDraft> _predictionSocialComments = [
  PredictionSocialCommentDraft(
    id: 'c1',
    userName: 'CryptoAnalyst',
    userTier: PredictionSocialTier.platinum,
    content:
        'Looking at on-chain metrics, BTC accumulation by whales increased 15% this month. Strong bullish signal for \$100K target.',
    stance: PredictionSocialStance.bullish,
    upvotes: 124,
    downvotes: 8,
    createdAtLabel: '18:28 18 thg 5',
    isPinned: true,
    replies: [
      PredictionSocialCommentDraft(
        id: 'c1_r1',
        userName: 'ChartMaster',
        userTier: PredictionSocialTier.gold,
        content:
            'Agree, also RSI showing oversold conditions. Good entry point.',
        stance: PredictionSocialStance.bullish,
        upvotes: 45,
        downvotes: 2,
        createdAtLabel: '21:28 18 thg 5',
      ),
    ],
  ),
  PredictionSocialCommentDraft(
    id: 'c2',
    userName: 'MacroTrader',
    userTier: PredictionSocialTier.silver,
    content:
        'Fed policy still uncertain. I think we need to see Q4 data before making bold predictions.',
    stance: PredictionSocialStance.neutral,
    upvotes: 67,
    downvotes: 15,
    createdAtLabel: '15:28 18 thg 5',
  ),
  PredictionSocialCommentDraft(
    id: 'c3',
    userName: 'BearMarketSurvivor',
    userTier: PredictionSocialTier.bronze,
    content:
        'Too much optimism in the market. History shows corrections after such rallies.',
    stance: PredictionSocialStance.bearish,
    upvotes: 34,
    downvotes: 56,
    createdAtLabel: '11:28 18 thg 5',
  ),
];

const List<PredictionSentimentDraft> _predictionSocialSentiment = [
  PredictionSentimentDraft(name: 'Bullish', value: 58, color: AppColors.buy),
  PredictionSentimentDraft(name: 'Bearish', value: 22, color: AppColors.sell),
  PredictionSentimentDraft(name: 'Neutral', value: 20, color: AppColors.text3),
];

const List<PredictionContributorDraft> _predictionSocialContributors = [
  PredictionContributorDraft(
    name: 'CryptoAnalyst',
    tier: PredictionSocialTier.platinum,
    comments: 45,
    upvotes: 892,
  ),
  PredictionContributorDraft(
    name: 'ChartMaster',
    tier: PredictionSocialTier.gold,
    comments: 38,
    upvotes: 654,
  ),
  PredictionContributorDraft(
    name: 'MacroTrader',
    tier: PredictionSocialTier.silver,
    comments: 31,
    upvotes: 478,
  ),
];

const List<PredictionChartPointDraft> _predictionAdvancedPriceHistory = [
  PredictionChartPointDraft(
    time: '10:00',
    price: .58,
    volume: 12400,
    ma7: .56,
    ma25: .54,
    rsi: 42,
    bbUpper: .62,
    bbLower: .52,
  ),
  PredictionChartPointDraft(
    time: '11:00',
    price: .61,
    volume: 15800,
    ma7: .57,
    ma25: .55,
    rsi: 48,
    bbUpper: .63,
    bbLower: .53,
  ),
  PredictionChartPointDraft(
    time: '12:00',
    price: .59,
    volume: 11200,
    ma7: .58,
    ma25: .56,
    rsi: 45,
    bbUpper: .63,
    bbLower: .53,
  ),
  PredictionChartPointDraft(
    time: '13:00',
    price: .63,
    volume: 18900,
    ma7: .59,
    ma25: .57,
    rsi: 52,
    bbUpper: .64,
    bbLower: .54,
  ),
  PredictionChartPointDraft(
    time: '14:00',
    price: .65,
    volume: 21500,
    ma7: .60,
    ma25: .58,
    rsi: 58,
    bbUpper: .66,
    bbLower: .54,
  ),
  PredictionChartPointDraft(
    time: '15:00',
    price: .64,
    volume: 16700,
    ma7: .61,
    ma25: .59,
    rsi: 55,
    bbUpper: .66,
    bbLower: .56,
  ),
  PredictionChartPointDraft(
    time: '16:00',
    price: .67,
    volume: 24300,
    ma7: .62,
    ma25: .60,
    rsi: 61,
    bbUpper: .68,
    bbLower: .56,
  ),
  PredictionChartPointDraft(
    time: '17:00',
    price: .68,
    volume: 27800,
    ma7: .63,
    ma25: .61,
    rsi: 64,
    bbUpper: .69,
    bbLower: .57,
  ),
  PredictionChartPointDraft(
    time: '18:00',
    price: .66,
    volume: 19400,
    ma7: .64,
    ma25: .62,
    rsi: 59,
    bbUpper: .69,
    bbLower: .59,
  ),
  PredictionChartPointDraft(
    time: '19:00',
    price: .69,
    volume: 31200,
    ma7: .65,
    ma25: .63,
    rsi: 66,
    bbUpper: .71,
    bbLower: .59,
  ),
];

const List<PredictionOrderFlowDraft> _predictionAdvancedOrderFlow = [
  PredictionOrderFlowDraft(price: .72, buyVolume: 3200, sellVolume: 1400),
  PredictionOrderFlowDraft(price: .70, buyVolume: 5800, sellVolume: 2100),
  PredictionOrderFlowDraft(price: .68, buyVolume: 8900, sellVolume: 4200),
  PredictionOrderFlowDraft(price: .66, buyVolume: 6700, sellVolume: 7300),
  PredictionOrderFlowDraft(price: .64, buyVolume: 4500, sellVolume: 9800),
  PredictionOrderFlowDraft(price: .62, buyVolume: 3100, sellVolume: 11200),
];

const List<PredictionIndicatorSignalDraft> _predictionAdvancedIndicators = [
  PredictionIndicatorSignalDraft(
    name: 'Moving Average (7)',
    signal: 'BUY',
    strength: 'Strong',
    color: AppColors.buy,
    description: 'Price above MA7',
  ),
  PredictionIndicatorSignalDraft(
    name: 'Moving Average (25)',
    signal: 'BUY',
    strength: 'Moderate',
    color: AppColors.buy,
    description: 'Price above MA25',
  ),
  PredictionIndicatorSignalDraft(
    name: 'RSI',
    signal: 'NEUTRAL',
    strength: 'Weak',
    color: AppColors.warn,
    description: 'Neither overbought nor oversold',
  ),
  PredictionIndicatorSignalDraft(
    name: 'Bollinger Bands',
    signal: 'BUY',
    strength: 'Moderate',
    color: AppColors.buy,
    description: 'Price near lower band',
  ),
];

const List<PredictionPatternDraft> _predictionAdvancedPatterns = [
  PredictionPatternDraft(name: 'Ascending Triangle', confidence: 72),
  PredictionPatternDraft(name: 'Higher Lows', confidence: 68),
  PredictionPatternDraft(name: 'Volume Breakout', confidence: 54),
];

const List<PredictionTournamentDraft> _predictionTournaments = [
  PredictionTournamentDraft(
    id: 'tour1',
    name: 'Crypto Masters Q1 2026',
    description: 'Predict top crypto events this quarter. Best accuracy wins!',
    prizePool: 50000,
    participants: 1247,
    maxParticipants: 2000,
    status: TournamentStatus.active,
    entryFee: 0,
    category: 'Crypto',
    timeLabel: 'Ended',
    myRank: 34,
    myScore: 892,
    isJoined: true,
    featured: true,
  ),
  PredictionTournamentDraft(
    id: 'tour2',
    name: 'Politics Prediction Challenge',
    description: 'Forecast political outcomes worldwide',
    prizePool: 30000,
    participants: 847,
    maxParticipants: 1500,
    status: TournamentStatus.active,
    entryFee: 10,
    category: 'Politics',
    timeLabel: 'Ended',
    requiredLevel: 3,
  ),
  PredictionTournamentDraft(
    id: 'tour3',
    name: 'Tech Innovation Cup',
    description: 'Predict breakthrough tech announcements',
    prizePool: 25000,
    participants: 0,
    maxParticipants: 1000,
    status: TournamentStatus.upcoming,
    entryFee: 5,
    category: 'Tech',
    timeLabel: '42 days left',
    requiredLevel: 2,
  ),
  PredictionTournamentDraft(
    id: 'tour4',
    name: 'Macro Economics Pro',
    description: 'For expert traders: GDP, inflation, rates',
    prizePool: 100000,
    participants: 523,
    maxParticipants: 500,
    status: TournamentStatus.ended,
    entryFee: 50,
    category: 'Macro',
    timeLabel: 'Ended',
    myRank: 12,
    myScore: 1547,
    isJoined: true,
    requiredLevel: 5,
  ),
];

const List<PredictionTournamentLeaderboardEntry>
_predictionTournamentLeaderboard = [
  PredictionTournamentLeaderboardEntry(
    rank: 1,
    name: 'PredictionKing',
    score: 2341,
    prize: 15000,
  ),
  PredictionTournamentLeaderboardEntry(
    rank: 2,
    name: 'CryptoOracle',
    score: 2198,
    prize: 10000,
  ),
  PredictionTournamentLeaderboardEntry(
    rank: 3,
    name: 'ChartWizard',
    score: 2089,
    prize: 7500,
  ),
  PredictionTournamentLeaderboardEntry(
    rank: 4,
    name: 'MacroMaster',
    score: 1876,
    prize: 5000,
  ),
  PredictionTournamentLeaderboardEntry(
    rank: 5,
    name: 'TrendFollower',
    score: 1654,
    prize: 3000,
  ),
];

const List<PredictionDataSourceDraft> _predictionDataSources = [
  PredictionDataSourceDraft(
    id: 'ds1',
    name: 'CoinGecko Price Oracle',
    provider: 'CoinGecko',
    category: 'Crypto',
    status: PredictionDataSourceStatus.active,
    lastSyncLabel: '5m ago',
    eventsResolved: 1247,
    reliability: 99.8,
    apiUrl: 'https://api.coingecko.com/api/v3',
  ),
  PredictionDataSourceDraft(
    id: 'ds2',
    name: 'Chainlink Oracle Network',
    provider: 'Chainlink',
    category: 'Crypto',
    status: PredictionDataSourceStatus.active,
    lastSyncLabel: '2m ago',
    eventsResolved: 892,
    reliability: 99.9,
    apiUrl: 'https://data.chain.link',
  ),
  PredictionDataSourceDraft(
    id: 'ds3',
    name: 'Election Results API',
    provider: 'Associated Press',
    category: 'Politics',
    status: PredictionDataSourceStatus.active,
    lastSyncLabel: '1h ago',
    eventsResolved: 145,
    reliability: 100,
  ),
  PredictionDataSourceDraft(
    id: 'ds4',
    name: 'Sports Scores Feed',
    provider: 'ESPN',
    category: 'Sports',
    status: PredictionDataSourceStatus.inactive,
    lastSyncLabel: '1d ago',
    eventsResolved: 523,
    reliability: 98.5,
  ),
];

const List<PredictionApiKeyDraft> _predictionApiKeys = [
  PredictionApiKeyDraft(
    id: 'key1',
    name: 'Production API',
    key: 'pk_live_abc123xyz789def456',
    createdAtLabel: 'Created 30 days ago',
    lastUsedLabel: 'Last used 1h ago',
    permissions: ['read:events', 'write:predictions', 'read:portfolio'],
    status: PredictionApiKeyStatus.active,
  ),
  PredictionApiKeyDraft(
    id: 'key2',
    name: 'Development API',
    key: 'pk_test_xyz789abc123ghi456',
    createdAtLabel: 'Created 60 days ago',
    lastUsedLabel: 'Last used 1d ago',
    permissions: ['read:events', 'read:portfolio'],
    status: PredictionApiKeyStatus.active,
  ),
];

const List<PredictionWebhookDraft> _predictionWebhooks = [
  PredictionWebhookDraft(
    id: 'wh1',
    url: 'https://example.com/webhooks/prediction-resolved',
    events: ['event.resolved', 'position.settled'],
    status: PredictionWebhookStatus.active,
    lastTriggeredLabel: '2h ago',
    successRate: 98.5,
  ),
  PredictionWebhookDraft(
    id: 'wh2',
    url: 'https://example.com/webhooks/price-alert',
    events: ['price.changed', 'probability.threshold'],
    status: PredictionWebhookStatus.active,
    lastTriggeredLabel: '10m ago',
    successRate: 99.2,
  ),
];

const List<PredictionRewardOpportunityDraft> _predictionRewardOpportunities = [
  PredictionRewardOpportunityDraft(
    id: 'rw-1',
    eventId: 'pred-1',
    category: 'Live Crypto',
    maxSpread: .03,
    minShares: 100,
    dailyReward: 45,
    earningsPct: 12.5,
    priceChange24h: 5.2,
    isFavorite: true,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-2',
    eventId: 'pred-2',
    category: 'Live Crypto',
    maxSpread: .02,
    minShares: 50,
    dailyReward: 32,
    earningsPct: 8.3,
    priceChange24h: 3.8,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-3',
    eventId: 'pred-4',
    category: 'Sports',
    maxSpread: .04,
    minShares: 75,
    dailyReward: 28,
    earningsPct: 6.1,
    priceChange24h: 1.5,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-4',
    eventId: 'pred-6',
    category: 'AI',
    maxSpread: .02,
    minShares: 80,
    dailyReward: 55,
    earningsPct: 15.2,
    priceChange24h: -1.2,
    isFavorite: true,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-5',
    eventId: 'pred-3',
    category: 'Politics',
    maxSpread: .05,
    minShares: 60,
    dailyReward: 22,
    earningsPct: 5.8,
    priceChange24h: -2.1,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-6',
    eventId: 'pred-5',
    category: 'Tech',
    maxSpread: .03,
    minShares: 40,
    dailyReward: 38,
    earningsPct: 10.4,
    priceChange24h: 8.3,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-7',
    eventId: 'pred-7',
    category: 'Finance',
    maxSpread: .04,
    minShares: 90,
    dailyReward: 41,
    earningsPct: 9.7,
    priceChange24h: 2.4,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-8',
    eventId: 'pred-12',
    category: 'Live Crypto',
    maxSpread: .03,
    minShares: 120,
    dailyReward: 62,
    earningsPct: 18.1,
    priceChange24h: 3.2,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-9',
    eventId: 'pred-8',
    category: 'Culture',
    maxSpread: .06,
    minShares: 30,
    dailyReward: 15,
    earningsPct: 4.2,
    priceChange24h: .8,
  ),
  PredictionRewardOpportunityDraft(
    id: 'rw-10',
    eventId: 'pred-10',
    category: 'Finance',
    maxSpread: .04,
    minShares: 50,
    dailyReward: 35,
    earningsPct: 11,
    priceChange24h: 6.1,
  ),
];

const List<PredictionArenaRoomDraft> _predictionRewardArenaRooms = [
  PredictionArenaRoomDraft(
    title: 'BTC \$70K? — Tuần 9',
    slots: '38/50 slots',
    points: 100,
    badge: 'Closest Guess',
  ),
];

const Map<
  PredictionLeaderboardTimeFilter,
  List<PredictionLeaderboardTraderDraft>
>
_predictionLeaderboardData = {
  PredictionLeaderboardTimeFilter.today: [
    PredictionLeaderboardTraderDraft(
      rank: 1,
      user: 'CryptoKing',
      avatar: '👑',
      pnl: 4520,
      pnlPct: 42.3,
      volume: 28000,
      trades: 18,
      winRate: 78,
      biggestWin: 2100,
      biggestWinMarket: 'Bitcoin reaches \$150K',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 2,
      user: 'WhaleAlpha',
      avatar: '🐋',
      pnl: 3180,
      pnlPct: 31.5,
      volume: 45000,
      trades: 32,
      winRate: 72,
      biggestWin: 1800,
      biggestWinMarket: 'ETH ETF approved',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 3,
      user: 'DeFiSage',
      avatar: '🧙',
      pnl: 2740,
      pnlPct: 28.1,
      volume: 19000,
      trades: 14,
      winRate: 86,
      biggestWin: 1500,
      biggestWinMarket: 'GPT-5 released',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 4,
      user: 'AlgoTrader',
      avatar: '🤖',
      pnl: 2100,
      pnlPct: 22.8,
      volume: 35000,
      trades: 45,
      winRate: 64,
      biggestWin: 900,
      biggestWinMarket: 'Fed cuts rates',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 5,
      user: 'MoonShot',
      avatar: '🚀',
      pnl: 1850,
      pnlPct: 19.4,
      volume: 22000,
      trades: 21,
      winRate: 71,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 6,
      user: 'RiskMaster',
      avatar: '🛡️',
      pnl: 1420,
      pnlPct: 15.2,
      volume: 18000,
      trades: 12,
      winRate: 83,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 7,
      user: 'QuantDev',
      avatar: '📊',
      pnl: 1180,
      pnlPct: 12.6,
      volume: 31000,
      trades: 28,
      winRate: 68,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 8,
      user: 'SmartBeta',
      avatar: '🧠',
      pnl: 980,
      pnlPct: 10.1,
      volume: 15000,
      trades: 9,
      winRate: 78,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 9,
      user: 'YieldFarm',
      avatar: '🌾',
      pnl: 750,
      pnlPct: 8.3,
      volume: 12000,
      trades: 16,
      winRate: 63,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 10,
      user: 'DegenDAO',
      avatar: '🎰',
      pnl: 620,
      pnlPct: 6.8,
      volume: 8500,
      trades: 22,
      winRate: 55,
    ),
  ],
  PredictionLeaderboardTimeFilter.weekly: [
    PredictionLeaderboardTraderDraft(
      rank: 1,
      user: 'WhaleAlpha',
      avatar: '🐋',
      pnl: 18200,
      pnlPct: 85.4,
      volume: 210000,
      trades: 142,
      winRate: 74,
      biggestWin: 5200,
      biggestWinMarket: 'Bitcoin reaches \$150K',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 2,
      user: 'CryptoKing',
      avatar: '👑',
      pnl: 15600,
      pnlPct: 72.1,
      volume: 185000,
      trades: 98,
      winRate: 79,
      biggestWin: 4800,
      biggestWinMarket: 'Crypto \$5T market cap',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 3,
      user: 'AlgoTrader',
      avatar: '🤖',
      pnl: 12800,
      pnlPct: 58.3,
      volume: 320000,
      trades: 280,
      winRate: 66,
      biggestWin: 3500,
      biggestWinMarket: 'ETH ETF approved',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 4,
      user: 'DeFiSage',
      avatar: '🧙',
      pnl: 10400,
      pnlPct: 49.2,
      volume: 125000,
      trades: 85,
      winRate: 82,
      biggestWin: 4200,
      biggestWinMarket: 'Apple AR glasses',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 5,
      user: 'RiskMaster',
      avatar: '🛡️',
      pnl: 8900,
      pnlPct: 41.5,
      volume: 95000,
      trades: 62,
      winRate: 85,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 6,
      user: 'QuantDev',
      avatar: '📊',
      pnl: 7200,
      pnlPct: 33.8,
      volume: 180000,
      trades: 156,
      winRate: 70,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 7,
      user: 'MoonShot',
      avatar: '🚀',
      pnl: 5800,
      pnlPct: 26.4,
      volume: 72000,
      trades: 48,
      winRate: 73,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 8,
      user: 'SmartBeta',
      avatar: '🧠',
      pnl: 4500,
      pnlPct: 21.2,
      volume: 58000,
      trades: 34,
      winRate: 76,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 9,
      user: 'YieldFarm',
      avatar: '🌾',
      pnl: 3200,
      pnlPct: 15.6,
      volume: 42000,
      trades: 28,
      winRate: 68,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 10,
      user: 'DegenDAO',
      avatar: '🎰',
      pnl: 2100,
      pnlPct: 10.3,
      volume: 65000,
      trades: 88,
      winRate: 52,
    ),
  ],
  PredictionLeaderboardTimeFilter.monthly: [
    PredictionLeaderboardTraderDraft(
      rank: 1,
      user: 'WhaleAlpha',
      avatar: '🐋',
      pnl: 68500,
      pnlPct: 142.3,
      volume: 850000,
      trades: 520,
      winRate: 76,
      biggestWin: 12000,
      biggestWinMarket: 'Bitcoin above \$100K',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 2,
      user: 'AlgoTrader',
      avatar: '🤖',
      pnl: 52400,
      pnlPct: 108.5,
      volume: 1200000,
      trades: 980,
      winRate: 68,
      biggestWin: 8500,
      biggestWinMarket: 'Bitcoin reaches \$150K',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 3,
      user: 'CryptoKing',
      avatar: '👑',
      pnl: 44200,
      pnlPct: 95.1,
      volume: 620000,
      trades: 380,
      winRate: 81,
      biggestWin: 9200,
      biggestWinMarket: 'Crypto \$5T market cap',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 4,
      user: 'DeFiSage',
      avatar: '🧙',
      pnl: 38100,
      pnlPct: 82.4,
      volume: 480000,
      trades: 290,
      winRate: 84,
      biggestWin: 7800,
      biggestWinMarket: 'ETH ETF approved',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 5,
      user: 'RiskMaster',
      avatar: '🛡️',
      pnl: 31200,
      pnlPct: 68.5,
      volume: 350000,
      trades: 210,
      winRate: 87,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 6,
      user: 'QuantDev',
      avatar: '📊',
      pnl: 25800,
      pnlPct: 55.2,
      volume: 720000,
      trades: 580,
      winRate: 71,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 7,
      user: 'SmartBeta',
      avatar: '🧠',
      pnl: 19500,
      pnlPct: 42.8,
      volume: 220000,
      trades: 145,
      winRate: 78,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 8,
      user: 'MoonShot',
      avatar: '🚀',
      pnl: 14800,
      pnlPct: 33.6,
      volume: 280000,
      trades: 190,
      winRate: 72,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 9,
      user: 'YieldFarm',
      avatar: '🌾',
      pnl: 11200,
      pnlPct: 25.1,
      volume: 165000,
      trades: 120,
      winRate: 70,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 10,
      user: 'DegenDAO',
      avatar: '🎰',
      pnl: 8400,
      pnlPct: 18.9,
      volume: 310000,
      trades: 420,
      winRate: 54,
    ),
  ],
  PredictionLeaderboardTimeFilter.allTime: [
    PredictionLeaderboardTraderDraft(
      rank: 1,
      user: 'WhaleAlpha',
      avatar: '🐋',
      pnl: 245000,
      pnlPct: 412.5,
      volume: 3200000,
      trades: 2100,
      winRate: 75,
      biggestWin: 45000,
      biggestWinMarket: 'Bitcoin above \$100K',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 2,
      user: 'AlgoTrader',
      avatar: '🤖',
      pnl: 198000,
      pnlPct: 325.8,
      volume: 5800000,
      trades: 4500,
      winRate: 67,
      biggestWin: 32000,
      biggestWinMarket: 'ETH ETF approved',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 3,
      user: 'CryptoKing',
      avatar: '👑',
      pnl: 172000,
      pnlPct: 285.4,
      volume: 2100000,
      trades: 1450,
      winRate: 80,
      biggestWin: 28000,
      biggestWinMarket: 'Crypto \$5T market cap',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 4,
      user: 'DeFiSage',
      avatar: '🧙',
      pnl: 145000,
      pnlPct: 242.1,
      volume: 1800000,
      trades: 1100,
      winRate: 83,
      biggestWin: 25000,
      biggestWinMarket: 'Apple AR glasses',
    ),
    PredictionLeaderboardTraderDraft(
      rank: 5,
      user: 'RiskMaster',
      avatar: '🛡️',
      pnl: 118000,
      pnlPct: 198.3,
      volume: 1350000,
      trades: 850,
      winRate: 86,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 6,
      user: 'QuantDev',
      avatar: '📊',
      pnl: 95000,
      pnlPct: 162.5,
      volume: 2800000,
      trades: 2200,
      winRate: 70,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 7,
      user: 'SmartBeta',
      avatar: '🧠',
      pnl: 72000,
      pnlPct: 128.4,
      volume: 890000,
      trades: 580,
      winRate: 77,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 8,
      user: 'MoonShot',
      avatar: '🚀',
      pnl: 58000,
      pnlPct: 105.2,
      volume: 1100000,
      trades: 720,
      winRate: 71,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 9,
      user: 'YieldFarm',
      avatar: '🌾',
      pnl: 42000,
      pnlPct: 78.6,
      volume: 650000,
      trades: 480,
      winRate: 69,
    ),
    PredictionLeaderboardTraderDraft(
      rank: 10,
      user: 'DegenDAO',
      avatar: '🎰',
      pnl: 31000,
      pnlPct: 55.8,
      volume: 1500000,
      trades: 1800,
      winRate: 53,
    ),
  ],
};

const List<({String user, String avatar})> _predictionActivityUsers = [
  (user: 'whale_42', avatar: '🐋'),
  (user: 'defi_king', avatar: '👑'),
  (user: 'alpha_seeker', avatar: '🔍'),
  (user: 'macro_trader', avatar: '📊'),
  (user: 'moon_boy', avatar: '🚀'),
  (user: 'hedge_fund', avatar: '🏦'),
  (user: 'quant_dev', avatar: '🤖'),
  (user: 'risk_mgr', avatar: '🛡️'),
  (user: 'degen_99', avatar: '🦊'),
  (user: 'smart_money', avatar: '💰'),
  (user: 'arb_bot', avatar: '⚡'),
  (user: 'yield_max', avatar: '🌾'),
  (user: 'bull_run', avatar: '🐂'),
  (user: 'bear_trap', avatar: '🐻'),
  (user: 'long_term', avatar: '💎'),
];

const List<String> _predictionActivityTimes = [
  'Just now',
  '12s ago',
  '28s ago',
  '45s ago',
  '1m ago',
  '1m ago',
  '2m ago',
  '3m ago',
  '4m ago',
  '5m ago',
  '7m ago',
  '8m ago',
  '10m ago',
  '12m ago',
  '15m ago',
  '18m ago',
  '22m ago',
  '25m ago',
  '30m ago',
  '35m ago',
  '42m ago',
  '48m ago',
  '55m ago',
  '1h ago',
  '1h ago',
  '2h ago',
  '2h ago',
  '3h ago',
  '4h ago',
  '5h ago',
];

List<PredictionGlobalActivityDraft> _generatePredictionGlobalActivity() {
  final activeEvents = _predictionEvents
      .where((event) => event.status == PredictionEventStatus.active)
      .toList();
  return List.generate(30, (index) {
    final user =
        _predictionActivityUsers[index % _predictionActivityUsers.length];
    final event = activeEvents[index % activeEvents.length];
    final isBuy = index % 3 != 0;
    final price = (20 + (index * 7 + 13) % 70) / 100;
    final roundedPrice = (price * 100).round() / 100;
    final shares = 50 + ((index * 37 + 17) % 1500);
    final amount = (roundedPrice * shares * 100).round() / 100;

    return PredictionGlobalActivityDraft(
      id: 'ga-$index',
      user: user.user,
      avatar: user.avatar,
      action: isBuy
          ? PredictionGlobalActivityAction.bought
          : PredictionGlobalActivityAction.sold,
      outcome: isBuy ? 'Yes' : 'No',
      eventId: event.id,
      price: roundedPrice,
      amount: amount,
      shares: shares,
      timestamp: _predictionActivityTimes[index],
    );
  });
}

const List<PredictionOrderDraft> _predictionOrders = [
  PredictionOrderDraft(
    id: 'oo-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    side: 'buy',
    price: .30,
    shares: 200,
    status: 'open',
  ),
  PredictionOrderDraft(
    id: 'oo-2',
    eventId: 'pred-10',
    outcome: 'No',
    side: 'buy',
    price: .58,
    shares: 140,
    status: 'filled',
  ),
];

const List<PredictionReceiptDraft> _predictionReceipts = [
  PredictionReceiptDraft(
    id: 'po-1',
    eventId: 'pred-1',
    outcome: 'Yes',
    total: 60,
    fee: 1.2,
    status: 'submitted',
  ),
];

const List<PredictionRewardDraft> _predictionRewards = [
  PredictionRewardDraft(
    id: 'rw-1',
    eventId: 'pred-1',
    category: 'Live Crypto',
    dailyReward: 45,
    earningsPct: 12.5,
  ),
  PredictionRewardDraft(
    id: 'rw-10',
    eventId: 'pred-10',
    category: 'Finance',
    dailyReward: 35,
    earningsPct: 11,
  ),
];
