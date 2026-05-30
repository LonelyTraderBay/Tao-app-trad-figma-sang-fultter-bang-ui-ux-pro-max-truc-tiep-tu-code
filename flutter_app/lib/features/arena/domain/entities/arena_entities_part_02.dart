part of 'arena_entities.dart';

enum ArenaCreatorTrustMetricKind {
  fairPlay,
  disputeRate,
  completion,
  communityRating,
}

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

final class VerifiedChallengeFeatureDraft {
  const VerifiedChallengeFeatureDraft({
    required this.label,
    required this.kind,
  });

  final String label;
  final VerifiedChallengeFeatureKind kind;
}

enum VerifiedChallengeFeatureKind { oracle, escrow, leaderboard, trust }

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

final class ArenaFlowMapSnapshot {
  const ArenaFlowMapSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.stats,
    required this.routes,
    required this.groups,
    required this.components,
    required this.handoffNotes,
    required this.qaItems,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaFlowStatDraft> stats;
  final List<ArenaFlowRouteDraft> routes;
  final List<ArenaFlowGroupDraft> groups;
  final List<ArenaFlowComponentDraft> components;
  final List<ArenaFlowNoteDraft> handoffNotes;
  final List<ArenaFlowQaDraft> qaItems;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaFlowStatDraft {
  const ArenaFlowStatDraft({
    required this.value,
    required this.label,
    required this.kind,
  });

  final String value;
  final String label;
  final ArenaFlowKind kind;
}

final class ArenaFlowRouteDraft {
  const ArenaFlowRouteDraft({
    required this.path,
    required this.page,
    required this.status,
  });

  final String path;
  final String page;
  final String status;
}

final class ArenaFlowGroupDraft {
  const ArenaFlowGroupDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.nodes,
    required this.connectionNote,
  });

  final String id;
  final String title;
  final String subtitle;
  final ArenaFlowKind kind;
  final List<ArenaFlowNodeDraft> nodes;
  final String connectionNote;
}

final class ArenaFlowNodeDraft {
  const ArenaFlowNodeDraft({
    required this.label,
    required this.sublabel,
    required this.kind,
    this.route,
    this.stateLabel,
  });

  final String label;
  final String sublabel;
  final ArenaFlowKind kind;
  final String? route;
  final String? stateLabel;
}

final class ArenaFlowComponentDraft {
  const ArenaFlowComponentDraft({
    required this.file,
    required this.description,
    required this.exports,
  });

  final String file;
  final String description;
  final List<String> exports;
}

final class ArenaFlowNoteDraft {
  const ArenaFlowNoteDraft({
    required this.title,
    required this.detail,
    required this.kind,
  });

  final String title;
  final String detail;
  final ArenaFlowKind kind;
}

final class ArenaFlowQaDraft {
  const ArenaFlowQaDraft({
    required this.id,
    required this.category,
    required this.label,
  });

  final String id;
  final String category;
  final String label;
}

enum ArenaFlowKind {
  core,
  discovery,
  creator,
  participant,
  owner,
  points,
  verified,
  safety,
  neutral,
}

final class ArenaSafetyCenterSnapshot {
  const ArenaSafetyCenterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.bannerTitle,
    required this.bannerDescription,
    required this.communityRules,
    required this.bannedContent,
    required this.reportActions,
    required this.violationProcess,
    required this.resolution,
    required this.offPlatform,
    required this.pointsDisclaimer,
    required this.quickLinks,
    required this.ctaLabel,
    required this.footerLabel,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String bannerTitle;
  final String bannerDescription;
  final List<ArenaSafetyRuleDraft> communityRules;
  final List<String> bannedContent;
  final List<ArenaSafetyRuleDraft> reportActions;
  final List<ArenaSafetyProcessDraft> violationProcess;
  final ArenaSafetyInfoDraft resolution;
  final ArenaSafetyInfoDraft offPlatform;
  final ArenaSafetyInfoDraft pointsDisclaimer;
  final List<ArenaSafetyQuickLinkDraft> quickLinks;
  final String ctaLabel;
  final String footerLabel;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaSafetyRuleDraft {
  const ArenaSafetyRuleDraft({
    required this.title,
    required this.description,
    required this.kind,
  });

  final String title;
  final String description;
  final ArenaSafetyKind kind;
}

final class ArenaSafetyProcessDraft {
  const ArenaSafetyProcessDraft({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class ArenaSafetyInfoDraft {
  const ArenaSafetyInfoDraft({
    required this.title,
    required this.description,
    required this.kind,
    required this.items,
  });

  final String title;
  final String description;
  final ArenaSafetyKind kind;
  final List<ArenaSafetyCheckDraft> items;
}

final class ArenaSafetyCheckDraft {
  const ArenaSafetyCheckDraft({required this.text, required this.allowed});

  final String text;
  final bool allowed;
}

final class ArenaSafetyQuickLinkDraft {
  const ArenaSafetyQuickLinkDraft({
    required this.title,
    required this.route,
    required this.kind,
  });

  final String title;
  final String route;
  final ArenaSafetyKind kind;
}

enum ArenaSafetyKind {
  respect,
  offPlatform,
  civil,
  privacy,
  report,
  block,
  process,
  resolution,
  points,
}

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
