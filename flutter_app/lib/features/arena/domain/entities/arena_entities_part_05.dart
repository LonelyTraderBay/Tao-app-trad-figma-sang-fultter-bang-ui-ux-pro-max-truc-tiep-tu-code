part of 'arena_entities.dart';

final class ArenaChallengeDraft {
  const ArenaChallengeDraft({
    required this.id,
    required this.title,
    required this.format,
    required this.slotsFilled,
    required this.slotsTotal,
    required this.entryPoints,
    required this.prizePool,
    required this.state,
  });

  final String id;
  final String title;
  final String format;
  final int slotsFilled;
  final int slotsTotal;
  final int entryPoints;
  final int prizePool;
  final ArenaChallengeState state;
}

final class ArenaModeDraft {
  const ArenaModeDraft({
    required this.id,
    required this.title,
    required this.creatorName,
    required this.cloneCount,
    required this.activeChallenges,
    required this.fairPlay,
    this.description = '',
    this.completionRate = 0,
    this.tags = const [],
    this.templateId = '',
  });

  final String id;
  final String title;
  final String creatorName;
  final int cloneCount;
  final int activeChallenges;
  final bool fairPlay;
  final String description;
  final int completionRate;
  final List<String> tags;
  final String templateId;
}

final class ArenaCreatorDraft {
  const ArenaCreatorDraft({
    required this.id,
    required this.name,
    required this.modesCreated,
    required this.totalChallenges,
    required this.trustScore,
    required this.fairPlay,
  });

  final String id;
  final String name;
  final int modesCreated;
  final int totalChallenges;
  final int trustScore;
  final bool fairPlay;
}

final class ArenaTrustSignalDraft {
  const ArenaTrustSignalDraft({required this.label, required this.value});

  final String label;
  final String value;
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
