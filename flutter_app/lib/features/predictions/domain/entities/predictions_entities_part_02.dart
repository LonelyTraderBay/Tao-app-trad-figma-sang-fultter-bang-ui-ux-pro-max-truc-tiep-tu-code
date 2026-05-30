part of 'predictions_entities.dart';

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
