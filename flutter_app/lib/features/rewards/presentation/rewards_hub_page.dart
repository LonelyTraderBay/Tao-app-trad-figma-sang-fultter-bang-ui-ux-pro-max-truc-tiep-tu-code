import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/arena/data/arena_repository.dart';
import '../../../features/arena/presentation/arena_points_page.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../data/rewards_repository.dart';

class RewardsHubPage extends ConsumerWidget {
  const RewardsHubPage({super.key, this.shellRenderMode});

  static const contentKey = ArenaPointsPage.contentKey;
  static const claimAllKey = ArenaPointsPage.claimAllKey;
  static const referralKey = ArenaPointsPage.referralKey;
  static const leaderboardKey = ArenaPointsPage.leaderboardKey;

  static Key filterKey(String label) => ArenaPointsPage.filterKey(label);
  static Key taskKey(String id) => ArenaPointsPage.taskKey(id);

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(rewardsRepositoryProvider).getHub();

    // Delegates the visual composition to the migrated rewards hub scaffold
    // in ArenaPointsPage, which owns the VitPageLayout and VitPageContent tree.
    return ArenaPointsPage(
      shellRenderMode: shellRenderMode,
      snapshotOverride: _toArenaSnapshot(snapshot),
      semanticLabel: 'SC-319 RewardsHubPage',
      backRoute: snapshot.backRoute,
      referralRoute: snapshot.referralRoute,
      leaderboardRoute: snapshot.leaderboardRoute,
    );
  }
}

ArenaPointsSnapshot _toArenaSnapshot(RewardsHubSnapshot snapshot) {
  return ArenaPointsSnapshot(
    endpoint: snapshot.endpoint,
    actionDraft: snapshot.actionDraft,
    summary: ArenaPointsSummaryDraft(
      usdtClaimed: snapshot.summary.usdtClaimed,
      currentBalance: snapshot.summary.currentPoints,
      lockedBalance: snapshot.summary.lockedPoints,
      rank: snapshot.summary.rank,
      topPercent: snapshot.summary.topPercent,
      claimedCount: snapshot.summary.claimedCount,
      pendingCount: snapshot.summary.pendingCount,
      pendingUsdt: snapshot.summary.pendingUsdt,
      pendingPoints: snapshot.summary.pendingPoints,
      expiringCount: snapshot.summary.expiringCount,
      completionLabel: snapshot.summary.completionLabel,
      tierLabel: snapshot.summary.tierLabel,
    ),
    categories: snapshot.categories
        .map(
          (category) => ArenaPointsCategoryDraft(
            id: category.id,
            label: category.label,
            done: category.done,
            total: category.total,
            pending: category.pending,
            kind: _toArenaAccentKind(category.kind),
          ),
        )
        .toList(growable: false),
    checkIns: snapshot.checkIns
        .map(
          (checkIn) => ArenaDailyCheckInDraft(
            day: checkIn.day,
            label: checkIn.label,
            reward: checkIn.reward,
            claimed: checkIn.claimed,
            today: checkIn.today,
          ),
        )
        .toList(growable: false),
    filters: snapshot.filters,
    tasks: snapshot.tasks
        .map(
          (task) => ArenaRewardTaskDraft(
            id: task.id,
            title: task.title,
            subtitle: task.subtitle,
            filter: task.filter,
            status: _toArenaTaskStatus(task.status),
            progress: task.progress,
            rewardLabel: task.rewardLabel,
            kind: _toArenaAccentKind(task.kind),
          ),
        )
        .toList(growable: false),
    bonusRows: snapshot.bonusRows
        .map(
          (row) => ArenaBonusRowDraft(
            title: row.title,
            subtitle: row.subtitle,
            rewardLabel: row.rewardLabel,
            kind: _toArenaAccentKind(row.kind),
          ),
        )
        .toList(growable: false),
    leaderboard: snapshot.leaderboard
        .map(
          (entry) => ArenaPointsLeaderboardDraft(
            rank: entry.rank,
            name: entry.name,
            pointsLabel: entry.pointsLabel,
          ),
        )
        .toList(growable: false),
    disclaimer: snapshot.disclaimer,
    supportedStates: const {
      ArenaScreenState.loading,
      ArenaScreenState.empty,
      ArenaScreenState.error,
      ArenaScreenState.offline,
    },
  );
}

ArenaRewardTaskStatus _toArenaTaskStatus(RewardTaskStatus status) {
  switch (status) {
    case RewardTaskStatus.active:
      return ArenaRewardTaskStatus.active;
    case RewardTaskStatus.completed:
      return ArenaRewardTaskStatus.completed;
    case RewardTaskStatus.claimed:
      return ArenaRewardTaskStatus.claimed;
  }
}

ArenaRewardAccentKind _toArenaAccentKind(RewardAccentKind kind) {
  switch (kind) {
    case RewardAccentKind.daily:
      return ArenaRewardAccentKind.daily;
    case RewardAccentKind.weekly:
      return ArenaRewardAccentKind.weekly;
    case RewardAccentKind.flash:
      return ArenaRewardAccentKind.flash;
    case RewardAccentKind.learn:
      return ArenaRewardAccentKind.learn;
    case RewardAccentKind.achievement:
      return ArenaRewardAccentKind.achievement;
    case RewardAccentKind.arena:
      return ArenaRewardAccentKind.arena;
    case RewardAccentKind.p2p:
      return ArenaRewardAccentKind.p2p;
    case RewardAccentKind.referral:
      return ArenaRewardAccentKind.referral;
    case RewardAccentKind.neutral:
      return ArenaRewardAccentKind.neutral;
  }
}
