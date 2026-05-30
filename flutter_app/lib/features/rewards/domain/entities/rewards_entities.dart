enum RewardsScreenState { loading, empty, error, offline }

enum RewardTaskStatus { active, completed, claimed }

enum RewardAccentKind {
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

final class RewardsHubSnapshot {
  const RewardsHubSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.referralRoute,
    required this.leaderboardRoute,
    required this.summary,
    required this.categories,
    required this.checkIns,
    required this.filters,
    required this.tasks,
    required this.bonusRows,
    required this.leaderboard,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String referralRoute;
  final String leaderboardRoute;
  final RewardSummaryDraft summary;
  final List<RewardCategoryDraft> categories;
  final List<RewardCheckInDraft> checkIns;
  final List<String> filters;
  final List<RewardTaskDraft> tasks;
  final List<RewardBonusDraft> bonusRows;
  final List<RewardLeaderboardDraft> leaderboard;
  final String disclaimer;
  final String contractNotes;
  final Set<RewardsScreenState> supportedStates;
}

final class RewardSummaryDraft {
  const RewardSummaryDraft({
    required this.bonusPointsClaimed,
    required this.currentPoints,
    required this.lockedPoints,
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
  final int currentPoints;
  final int lockedPoints;
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

final class RewardCategoryDraft {
  const RewardCategoryDraft({
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
  final RewardAccentKind kind;
}

final class RewardCheckInDraft {
  const RewardCheckInDraft({
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

final class RewardTaskDraft {
  const RewardTaskDraft({
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
  final RewardTaskStatus status;
  final double progress;
  final String rewardLabel;
  final RewardAccentKind kind;
}

final class RewardBonusDraft {
  const RewardBonusDraft({
    required this.title,
    required this.subtitle,
    required this.rewardLabel,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final String rewardLabel;
  final RewardAccentKind kind;
}

final class RewardLeaderboardDraft {
  const RewardLeaderboardDraft({
    required this.rank,
    required this.name,
    required this.pointsLabel,
  });

  final int rank;
  final String name;
  final String pointsLabel;
}
