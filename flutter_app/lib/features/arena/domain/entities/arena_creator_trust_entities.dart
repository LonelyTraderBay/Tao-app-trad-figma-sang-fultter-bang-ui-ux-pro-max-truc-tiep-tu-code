part of 'arena_entities.dart';

/// A creator's public profile: trust metrics, modes, and rooms for the creator profile screen.
final class ArenaCreatorProfileSnapshot {
  const ArenaCreatorProfileSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.creator,
    required this.trustMetrics,
    required this.modes,
    required this.liveRooms,
    required this.historyRooms,
    required this.aboutRows,
    required this.policyLabel,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final ArenaCreatorProfileDraft creator;
  final List<ArenaCreatorTrustMetricDraft> trustMetrics;
  final List<ArenaModeDraft> modes;
  final List<ArenaChallengeDraft> liveRooms;
  final List<ArenaChallengeDraft> historyRooms;
  final List<ArenaRuleSummaryRow> aboutRows;
  final String policyLabel;
  final Set<ArenaScreenState> supportedStates;
}

/// A creator's identity and reputation stats shown on their profile.
final class ArenaCreatorProfileDraft {
  const ArenaCreatorProfileDraft({
    required this.id,
    required this.name,
    required this.badge,
    required this.level,
    required this.modesCreated,
    required this.completedRooms,
    required this.totalClones,
    required this.trustScore,
    required this.fairPlayBadge,
    required this.bio,
  });

  final String id;
  final String name;
  final String badge;
  final int level;
  final int modesCreated;
  final int completedRooms;
  final int totalClones;
  final int trustScore;
  final bool fairPlayBadge;
  final String bio;
}

/// A single trust metric row on a creator's profile.
final class ArenaCreatorTrustMetricDraft {
  const ArenaCreatorTrustMetricDraft({
    required this.label,
    required this.value,
    required this.kind,
  });

  final String label;
  final String value;
  final ArenaCreatorTrustMetricKind kind;
}

/// Category of trust metric shown for a creator.
enum ArenaCreatorTrustMetricKind {
  fairPlay,
  disputeRate,
  completion,
  communityRating,
}

/// Ranking data for the Arena leaderboard screen.
final class ArenaLeaderboardSnapshot {
  const ArenaLeaderboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.myRank,
    required this.metricChips,
    required this.seasonFilters,
    required this.podium,
    required this.topCreators,
    required this.risingCreators,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final ArenaLeaderboardMyRankDraft myRank;
  final List<ArenaLeaderboardFilterDraft> metricChips;
  final List<ArenaLeaderboardFilterDraft> seasonFilters;
  final List<ArenaLeaderboardEntryDraft> podium;
  final List<ArenaLeaderboardEntryDraft> topCreators;
  final List<ArenaLeaderboardEntryDraft> risingCreators;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

/// The current user's own rank and points summary on the leaderboard.
final class ArenaLeaderboardMyRankDraft {
  const ArenaLeaderboardMyRankDraft({
    required this.rank,
    required this.pointsLabel,
    required this.summary,
  });

  final int rank;
  final String pointsLabel;
  final String summary;
}

/// A single selectable metric or season filter on the leaderboard.
final class ArenaLeaderboardFilterDraft {
  const ArenaLeaderboardFilterDraft({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final ArenaLeaderboardIconKind icon;
}

/// A single ranked entry on the Arena leaderboard.
final class ArenaLeaderboardEntryDraft {
  const ArenaLeaderboardEntryDraft({
    required this.rank,
    required this.name,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.creatorId,
    this.fairPlay = false,
    this.rising = false,
  });

  final int rank;
  final String name;
  final String value;
  final String subtitle;
  final ArenaLeaderboardIconKind icon;
  final String? creatorId;
  final bool fairPlay;
  final bool rising;
}

/// Icon shown next to a leaderboard entry or filter.
enum ArenaLeaderboardIconKind {
  trophy,
  shield,
  trending,
  winRate,
  activity,
  completion,
  target,
  game,
  magic,
  crown,
  player,
  team,
}

/// Explainer content describing what a verified challenge guarantees.
final class VerifiedChallengesSnapshot {
  const VerifiedChallengesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.infoTitle,
    required this.features,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String infoTitle;
  final List<VerifiedChallengeFeatureDraft> features;
  final Set<ArenaScreenState> supportedStates;
}

/// A single guarantee feature listed on the verified challenges screen.
final class VerifiedChallengeFeatureDraft {
  const VerifiedChallengeFeatureDraft({
    required this.label,
    required this.kind,
  });

  final String label;
  final VerifiedChallengeFeatureKind kind;
}

/// Category of guarantee a verified challenge provides.
enum VerifiedChallengeFeatureKind { oracle, escrow, leaderboard, trust }

/// A user's blocked-user list for the Arena blocked users screen.
final class ArenaBlockedUsersSnapshot {
  const ArenaBlockedUsersSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.bannerTitle,
    required this.bannerDescription,
    required this.users,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String bannerTitle;
  final String bannerDescription;
  final List<ArenaBlockedUserDraft> users;
  final String emptyTitle;
  final String emptySubtitle;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

/// A single blocked user entry.
final class ArenaBlockedUserDraft {
  const ArenaBlockedUserDraft({
    required this.id,
    required this.name,
    required this.reason,
    required this.blockedAt,
    required this.source,
  });

  final String id;
  final String name;
  final String reason;
  final String blockedAt;
  final ArenaBlockedUserSource source;
}

/// How a user came to be blocked.
enum ArenaBlockedUserSource { manual, reportOutcome, system }

/// Detailed trust metric breakdown for a single creator or entity.
final class ArenaTrustBreakdownSnapshot {
  const ArenaTrustBreakdownSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.entityId,
    required this.creator,
    required this.metrics,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.safetyTitle,
    required this.safetyDescription,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String entityId;
  final ArenaCreatorProfileDraft? creator;
  final List<ArenaCreatorTrustMetricDraft> metrics;
  final String emptyTitle;
  final String emptySubtitle;
  final String safetyTitle;
  final String safetyDescription;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}
