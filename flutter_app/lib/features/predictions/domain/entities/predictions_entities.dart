import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';

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
    required this.endpoint,
    required this.profileEndpoint,
    required this.actionDraft,
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

  final String endpoint;
  final String profileEndpoint;
  final String actionDraft;
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
