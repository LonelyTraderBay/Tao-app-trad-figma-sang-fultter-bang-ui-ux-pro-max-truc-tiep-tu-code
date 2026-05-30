part of 'predictions_entities.dart';

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
