part of 'arena_entities.dart';

final class MyArenaSnapshot {
  const MyArenaSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.stats,
    required this.myRooms,
    required this.joinedChallenges,
    required this.savedModes,
    required this.drafts,
    required this.history,
    required this.rewardHistory,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final MyArenaStats stats;
  final List<ArenaChallengeDraft> myRooms;
  final List<ArenaChallengeDraft> joinedChallenges;
  final List<ArenaModeDraft> savedModes;
  final List<ArenaDraftChallenge> drafts;
  final List<ArenaChallengeDraft> history;
  final ArenaRewardHistory rewardHistory;
  final Set<ArenaScreenState> supportedStates;

  MyArenaSnapshot copyWith({String? endpoint}) {
    return MyArenaSnapshot(
      endpoint: endpoint ?? this.endpoint,
      actionDraft: actionDraft,
      stats: stats,
      myRooms: myRooms,
      joinedChallenges: joinedChallenges,
      savedModes: savedModes,
      drafts: drafts,
      history: history,
      rewardHistory: rewardHistory,
      supportedStates: supportedStates,
    );
  }
}

final class MyArenaStats {
  const MyArenaStats({
    required this.currentBalance,
    required this.pointsEarned,
    required this.pointsSpent,
    required this.activeChallenges,
    required this.modesCreated,
    required this.creatorScore,
    required this.rank,
    required this.pendingNotifications,
  });

  final int currentBalance;
  final int pointsEarned;
  final int pointsSpent;
  final int activeChallenges;
  final int modesCreated;
  final int creatorScore;
  final int rank;
  final int pendingNotifications;
}

final class ArenaDraftChallenge {
  const ArenaDraftChallenge({
    required this.id,
    required this.title,
    required this.format,
    required this.updatedAt,
    required this.entryPoints,
  });

  final String id;
  final String title;
  final String format;
  final String updatedAt;
  final int entryPoints;
}

final class ArenaRewardHistory {
  const ArenaRewardHistory({
    required this.totalReceipts,
    required this.averageReceiveRate,
    required this.largestReceipt,
    required this.distribution,
  });

  final int totalReceipts;
  final int averageReceiveRate;
  final int largestReceipt;
  final List<ArenaRewardDistribution> distribution;
}

final class ArenaRewardDistribution {
  const ArenaRewardDistribution({
    required this.label,
    required this.wins,
    required this.total,
  });

  final String label;
  final int wins;
  final int total;
}
