part of 'arena_entities.dart';

final class ArenaPointsSnapshot {
  const ArenaPointsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.summary,
    required this.categories,
    required this.checkIns,
    required this.filters,
    required this.tasks,
    required this.bonusRows,
    required this.leaderboard,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final ArenaPointsSummaryDraft summary;
  final List<ArenaPointsCategoryDraft> categories;
  final List<ArenaDailyCheckInDraft> checkIns;
  final List<String> filters;
  final List<ArenaRewardTaskDraft> tasks;
  final List<ArenaBonusRowDraft> bonusRows;
  final List<ArenaPointsLeaderboardDraft> leaderboard;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaPointsSummaryDraft {
  const ArenaPointsSummaryDraft({
    required this.bonusPointsClaimed,
    required this.currentBalance,
    required this.lockedBalance,
    required this.rank,
    required this.topPercent,
    required this.claimedCount,
    required this.pendingCount,
    required this.pendingBonusPoints,
    required this.pendingPoints,
    required this.expiringCount,
    required this.completionLabel,
    required this.tierLabel,
  });

  final String bonusPointsClaimed;
  final int currentBalance;
  final int lockedBalance;
  final int rank;
  final int topPercent;
  final int claimedCount;
  final int pendingCount;
  final String pendingBonusPoints;
  final int pendingPoints;
  final int expiringCount;
  final String completionLabel;
  final String tierLabel;
}

final class ArenaPointsCategoryDraft {
  const ArenaPointsCategoryDraft({
    required this.id,
    required this.label,
    required this.done,
    required this.total,
    required this.pending,
    required this.kind,
  });

  final String id;
  final String label;
  final int done;
  final int total;
  final int pending;
  final ArenaRewardAccentKind kind;
}

final class ArenaDailyCheckInDraft {
  const ArenaDailyCheckInDraft({
    required this.day,
    required this.label,
    required this.reward,
    required this.claimed,
    required this.today,
  });

  final int day;
  final String label;
  final String reward;
  final bool claimed;
  final bool today;
}

final class ArenaRewardTaskDraft {
  const ArenaRewardTaskDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.filter,
    required this.status,
    required this.progress,
    required this.rewardLabel,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final String filter;
  final ArenaRewardTaskStatus status;
  final double progress;
  final String rewardLabel;
  final ArenaRewardAccentKind kind;
}

final class ArenaBonusRowDraft {
  const ArenaBonusRowDraft({
    required this.title,
    required this.subtitle,
    required this.rewardLabel,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final String rewardLabel;
  final ArenaRewardAccentKind kind;
}

final class ArenaPointsLeaderboardDraft {
  const ArenaPointsLeaderboardDraft({
    required this.rank,
    required this.name,
    required this.pointsLabel,
  });

  final int rank;
  final String name;
  final String pointsLabel;
}

enum ArenaRewardTaskStatus { active, completed, claimed }

enum ArenaRewardAccentKind {
  daily,
  weekly,
  flash,
  learn,
  achievement,
  arena,
  p2p,
  referral,
  neutral,
}

final class ArenaPointsEntryDetailSnapshot {
  const ArenaPointsEntryDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.entryId,
    required this.entry,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String entryId;
  final ArenaPointsEntryDraft? entry;
  final String emptyTitle;
  final String emptySubtitle;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaPointsLedgerSnapshot {
  const ArenaPointsLedgerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.summary,
    required this.filters,
    required this.entries,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final ArenaPointsLedgerSummaryDraft summary;
  final List<ArenaPointsLedgerFilterDraft> filters;
  final List<ArenaPointsLedgerEntryDraft> entries;
  final String emptyTitle;
  final String emptySubtitle;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaPointsLedgerSummaryDraft {
  const ArenaPointsLedgerSummaryDraft({
    required this.currentBalance,
    required this.pointsEarned,
    required this.pointsSpent,
  });

  final int currentBalance;
  final int pointsEarned;
  final int pointsSpent;
}

final class ArenaPointsLedgerFilterDraft {
  const ArenaPointsLedgerFilterDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class ArenaPointsLedgerEntryDraft {
  const ArenaPointsLedgerEntryDraft({
    required this.id,
    required this.typeId,
    required this.typeLabel,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.statusLabel,
    required this.statusKind,
    required this.time,
    required this.reasonCode,
    required this.title,
    required this.refId,
    this.linkedChallengeId,
    this.linkedChallengeName,
    this.linkedModeId,
    this.linkedModeName,
  });

  final String id;
  final String typeId;
  final String typeLabel;
  final int amount;
  final int balanceBefore;
  final int balanceAfter;
  final String statusLabel;
  final ArenaPointsEntryStatus statusKind;
  final String time;
  final String reasonCode;
  final String title;
  final String refId;
  final String? linkedChallengeId;
  final String? linkedChallengeName;
  final String? linkedModeId;
  final String? linkedModeName;
}

final class ArenaPointsEntryDraft {
  const ArenaPointsEntryDraft({
    required this.id,
    required this.amount,
    required this.typeLabel,
    required this.typeKind,
    required this.statusLabel,
    required this.statusKind,
    required this.note,
    required this.reasonCode,
    required this.time,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.refId,
    this.linkedChallengeId,
    this.linkedChallengeName,
    this.linkedModeId,
    this.linkedModeName,
  });

  final String id;
  final int amount;
  final String typeLabel;
  final ArenaPointsEntryKind typeKind;
  final String statusLabel;
  final ArenaPointsEntryStatus statusKind;
  final String note;
  final String reasonCode;
  final String time;
  final int balanceBefore;
  final int balanceAfter;
  final String refId;
  final String? linkedChallengeId;
  final String? linkedChallengeName;
  final String? linkedModeId;
  final String? linkedModeName;
}

enum ArenaPointsEntryKind { reward, spend, refund, adjustment }

enum ArenaPointsEntryStatus { completed, pending, reversed }
