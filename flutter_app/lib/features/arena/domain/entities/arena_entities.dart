enum ArenaScreenState { loading, empty, error, offline }

enum ArenaChallengeState { open, full, live, pendingResult, resolved, canceled }

enum ArenaTemplateKind {
  prediction,
  closestGuess,
  teamBattle,
  bracket,
  vote,
  proof,
}

final class ArenaHomeSnapshot {
  const ArenaHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.templates,
    required this.featuredModes,
    required this.liveRooms,
    required this.creators,
    required this.trustSignals,
    required this.pendingNotifications,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaTemplateDraft> templates;
  final List<ArenaModeDraft> featuredModes;
  final List<ArenaChallengeDraft> liveRooms;
  final List<ArenaCreatorDraft> creators;
  final List<ArenaTrustSignalDraft> trustSignals;
  final int pendingNotifications;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaTemplateDraft {
  const ArenaTemplateDraft({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.tags,
  });

  final String id;
  final ArenaTemplateKind kind;
  final String title;
  final String description;
  final List<String> tags;
}

final class ArenaStudioSnapshot {
  const ArenaStudioSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.steps,
    required this.templates,
    required this.platformFeePct,
    required this.secondaryActions,
    required this.trustSignals,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaStudioStepDraft> steps;
  final List<ArenaStudioTemplateDraft> templates;
  final int platformFeePct;
  final List<String> secondaryActions;
  final List<ArenaTrustSignalDraft> trustSignals;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaStudioStepDraft {
  const ArenaStudioStepDraft({required this.index, required this.label});

  final int index;
  final String label;
}

final class ArenaStudioTemplateDraft {
  const ArenaStudioTemplateDraft({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.formatTags,
    required this.complexity,
    this.verifiedOnly = false,
  });

  final String id;
  final ArenaTemplateKind kind;
  final String title;
  final String description;
  final List<String> formatTags;
  final String complexity;
  final bool verifiedOnly;
}

final class ArenaSmartRulesSnapshot {
  const ArenaSmartRulesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.steps,
    required this.domains,
    required this.challengeTypes,
    required this.subjects,
    required this.actions,
    required this.metrics,
    required this.winTypes,
    required this.deadlineContexts,
    required this.tieRules,
    required this.voidRules,
    required this.resultDeadlines,
    required this.titleSuggestions,
    required this.defaultEndDate,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaStudioStepDraft> steps;
  final List<ArenaSmartOptionDraft> domains;
  final List<ArenaSmartOptionDraft> challengeTypes;
  final List<String> subjects;
  final List<String> actions;
  final List<String> metrics;
  final List<String> winTypes;
  final List<String> deadlineContexts;
  final List<String> tieRules;
  final List<String> voidRules;
  final List<String> resultDeadlines;
  final List<String> titleSuggestions;
  final String defaultEndDate;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaSmartOptionDraft {
  const ArenaSmartOptionDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class ArenaPresetLibrarySnapshot {
  const ArenaPresetLibrarySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.sections,
    required this.domainPacks,
    required this.suggestionsByDomain,
    required this.dropdownGroups,
    required this.demoFlows,
    required this.titleSuggestions,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaPresetSectionDraft> sections;
  final List<ArenaDomainPackDraft> domainPacks;
  final Map<String, List<ArenaPresetSuggestionDraft>> suggestionsByDomain;
  final List<ArenaPresetDropdownGroupDraft> dropdownGroups;
  final List<ArenaPresetDemoFlowDraft> demoFlows;
  final List<String> titleSuggestions;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaPresetSectionDraft {
  const ArenaPresetSectionDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class ArenaDomainPackDraft {
  const ArenaDomainPackDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.supportedTypes,
    required this.examples,
  });

  final String id;
  final String title;
  final String description;
  final List<String> supportedTypes;
  final List<String> examples;
}

final class ArenaPresetSuggestionDraft {
  const ArenaPresetSuggestionDraft({required this.text, required this.type});

  final String text;
  final String type;
}

final class ArenaPresetDropdownGroupDraft {
  const ArenaPresetDropdownGroupDraft({
    required this.label,
    required this.options,
    this.disabled = false,
  });

  final String label;
  final List<String> options;
  final bool disabled;
}

final class ArenaPresetDemoFlowDraft {
  const ArenaPresetDemoFlowDraft({
    required this.domainId,
    required this.domainLabel,
    required this.typeLabel,
    required this.suggestions,
    required this.generatedRule,
  });

  final String domainId;
  final String domainLabel;
  final String typeLabel;
  final List<String> suggestions;
  final String generatedRule;
}

final class ArenaGovernanceSnapshot {
  const ArenaGovernanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.steps,
    required this.privacyOptions,
    required this.domains,
    required this.challengeTypes,
    required this.subjects,
    required this.actions,
    required this.metrics,
    required this.winTypes,
    required this.deadlineContexts,
    required this.resolutionSources,
    required this.tieRules,
    required this.voidRules,
    required this.resultDeadlines,
    required this.suggestionActions,
    required this.defaultEndDate,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaStudioStepDraft> steps;
  final List<ArenaPrivacyOptionDraft> privacyOptions;
  final List<ArenaSmartOptionDraft> domains;
  final List<ArenaSmartOptionDraft> challengeTypes;
  final List<String> subjects;
  final List<String> actions;
  final List<String> metrics;
  final List<String> winTypes;
  final List<String> deadlineContexts;
  final List<String> resolutionSources;
  final List<String> tieRules;
  final List<String> voidRules;
  final List<String> resultDeadlines;
  final List<ArenaGovernanceSuggestionDraft> suggestionActions;
  final String defaultEndDate;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaPrivacyOptionDraft {
  const ArenaPrivacyOptionDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class ArenaGovernanceSuggestionDraft {
  const ArenaGovernanceSuggestionDraft({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

final class ArenaModeDetailSnapshot {
  const ArenaModeDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.mode,
    required this.template,
    required this.creator,
    required this.ruleRows,
    required this.qualityMetrics,
    required this.relatedRooms,
    required this.relatedModes,
    required this.predictionContext,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final ArenaModeDetailDraft mode;
  final ArenaTemplateDetailDraft template;
  final ArenaModeCreatorDetailDraft creator;
  final List<ArenaRuleSummaryRow> ruleRows;
  final List<ArenaQualityMetricDraft> qualityMetrics;
  final List<ArenaChallengeDraft> relatedRooms;
  final List<ArenaModeDraft> relatedModes;
  final ArenaPredictionContextDraft predictionContext;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaModeDetailDraft {
  const ArenaModeDetailDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.cloneCount,
    required this.activeChallenges,
    required this.completionRate,
    required this.fairPlay,
    required this.disputeRiskLevel,
    required this.reportRate,
    required this.repeatUsage,
  });

  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final int cloneCount;
  final int activeChallenges;
  final int completionRate;
  final bool fairPlay;
  final String disputeRiskLevel;
  final double reportRate;
  final int repeatUsage;
}

final class ArenaTemplateDetailDraft {
  const ArenaTemplateDetailDraft({
    required this.id,
    required this.kind,
    required this.title,
    required this.complexity,
    required this.formatTags,
  });

  final String id;
  final ArenaTemplateKind kind;
  final String title;
  final String complexity;
  final List<String> formatTags;
}

final class ArenaModeCreatorDetailDraft {
  const ArenaModeCreatorDetailDraft({
    required this.id,
    required this.name,
    required this.trustScore,
    required this.fairPlayBadge,
    required this.badge,
  });

  final String id;
  final String name;
  final int trustScore;
  final bool fairPlayBadge;
  final String badge;
}

final class ArenaRuleSummaryRow {
  const ArenaRuleSummaryRow({required this.label, required this.value});

  final String label;
  final String value;
}

final class ArenaQualityMetricDraft {
  const ArenaQualityMetricDraft({
    required this.label,
    required this.value,
    required this.description,
    required this.status,
  });

  final String label;
  final String value;
  final String description;
  final VitArenaMetricStatus status;
}

enum VitArenaMetricStatus { success, warning, info, neutral }

final class ArenaPredictionContextDraft {
  const ArenaPredictionContextDraft({
    required this.eventId,
    required this.title,
    required this.outcomeName,
    required this.probability,
  });

  final String eventId;
  final String title;
  final String outcomeName;
  final int probability;
}

final class ArenaChallengeDetailSnapshot {
  const ArenaChallengeDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.challenge,
    required this.creator,
    required this.teams,
    required this.rewardTiers,
    required this.ruleRows,
    required this.governanceRows,
    required this.rules,
    required this.activity,
    required this.safetyRows,
    required this.predictionContext,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final ArenaChallengeDetailDraft challenge;
  final ArenaChallengeCreatorDraft creator;
  final List<ArenaTeamDraft> teams;
  final List<ArenaRewardTierDraft> rewardTiers;
  final List<ArenaRuleSummaryRow> ruleRows;
  final List<ArenaRuleSummaryRow> governanceRows;
  final List<String> rules;
  final List<String> activity;
  final List<ArenaRuleSummaryRow> safetyRows;
  final ArenaPredictionContextDraft predictionContext;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaJoinSnapshot {
  const ArenaJoinSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.challenge,
    required this.creator,
    required this.rules,
    required this.currentBalance,
    required this.refundNotice,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final ArenaChallengeDetailDraft challenge;
  final ArenaChallengeCreatorDraft creator;
  final List<String> rules;
  final int currentBalance;
  final String refundNotice;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaResolutionCenterSnapshot {
  const ArenaResolutionCenterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String emptyTitle;
  final String emptySubtitle;
  final Set<ArenaScreenState> supportedStates;
}

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
    required this.usdtClaimed,
    required this.currentBalance,
    required this.lockedBalance,
    required this.rank,
    required this.topPercent,
    required this.claimedCount,
    required this.pendingCount,
    required this.pendingUsdt,
    required this.pendingPoints,
    required this.expiringCount,
    required this.completionLabel,
    required this.tierLabel,
  });

  final String usdtClaimed;
  final int currentBalance;
  final int lockedBalance;
  final int rank;
  final int topPercent;
  final int claimedCount;
  final int pendingCount;
  final String pendingUsdt;
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

enum ArenaBlockedUserSource { manual, reportOutcome, system }

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

final class ArenaReportCaseSnapshot {
  const ArenaReportCaseSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.caseId,
    required this.reportCase,
    required this.relatedReports,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String caseId;
  final ArenaReportCaseDraft? reportCase;
  final List<ArenaReportCaseDraft> relatedReports;
  final String emptyTitle;
  final String emptySubtitle;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class MyArenaReportsSnapshot {
  const MyArenaReportsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.summary,
    required this.filters,
    required this.reports,
    required this.bannerTitle,
    required this.bannerDescription,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final MyArenaReportsSummaryDraft summary;
  final List<MyArenaReportsFilterDraft> filters;
  final List<ArenaReportCaseDraft> reports;
  final String bannerTitle;
  final String bannerDescription;
  final String emptyTitle;
  final String emptySubtitle;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class MyArenaReportsSummaryDraft {
  const MyArenaReportsSummaryDraft({
    required this.total,
    required this.inReview,
    required this.resolved,
  });

  final int total;
  final int inReview;
  final int resolved;
}

final class MyArenaReportsFilterDraft {
  const MyArenaReportsFilterDraft({
    required this.id,
    required this.label,
    required this.count,
    this.status,
  });

  final String id;
  final String label;
  final int count;
  final ArenaReportCaseStatus? status;
}

final class ArenaReportCaseDraft {
  const ArenaReportCaseDraft({
    required this.id,
    required this.status,
    required this.reason,
    required this.targetName,
    required this.targetType,
    required this.targetId,
    required this.createdAt,
    required this.updatedAt,
    required this.timeline,
    this.actionTaken,
    this.systemNote,
    this.relatedChallengeId,
  });

  final String id;
  final ArenaReportCaseStatus status;
  final String reason;
  final String targetName;
  final ArenaReportTargetType targetType;
  final String targetId;
  final String createdAt;
  final String updatedAt;
  final List<ArenaReportTimelineStepDraft> timeline;
  final String? actionTaken;
  final String? systemNote;
  final String? relatedChallengeId;
}

final class ArenaReportTimelineStepDraft {
  const ArenaReportTimelineStepDraft({
    required this.label,
    required this.date,
    required this.done,
  });

  final String label;
  final String date;
  final bool done;
}

enum ArenaReportCaseStatus {
  submitted,
  underReview,
  actionTaken,
  closed,
  appealOpen,
}

enum ArenaReportTargetType { user, challenge, mode }

final class ArenaChallengeDetailDraft {
  const ArenaChallengeDetailDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.modeId,
    required this.modeName,
    required this.state,
    required this.statusLabel,
    required this.layoutLabel,
    required this.privacyLabel,
    required this.entryPoints,
    required this.prizePool,
    required this.netPrizePool,
    required this.teamWinnerPool,
    required this.slotsFilled,
    required this.slotsTotal,
    required this.fillPercent,
    required this.countdownLabel,
    required this.winCondition,
    required this.resolutionMethod,
    required this.evidenceRequirement,
    required this.voidRule,
    required this.refundPolicy,
    required this.platformFeePercent,
    required this.creatorCutPercent,
    required this.clarityScore,
    required this.trustRiskLabel,
    required this.policyVersion,
  });

  final String id;
  final String title;
  final String description;
  final String modeId;
  final String modeName;
  final ArenaChallengeState state;
  final String statusLabel;
  final String layoutLabel;
  final String privacyLabel;
  final int entryPoints;
  final int prizePool;
  final int netPrizePool;
  final int teamWinnerPool;
  final int slotsFilled;
  final int slotsTotal;
  final int fillPercent;
  final String countdownLabel;
  final String winCondition;
  final String resolutionMethod;
  final String evidenceRequirement;
  final String voidRule;
  final String refundPolicy;
  final int platformFeePercent;
  final int creatorCutPercent;
  final int clarityScore;
  final String trustRiskLabel;
  final String policyVersion;
}

final class ArenaChallengeCreatorDraft {
  const ArenaChallengeCreatorDraft({
    required this.id,
    required this.name,
    required this.trustScore,
    required this.fairPlayBadge,
    required this.role,
  });

  final String id;
  final String name;
  final int trustScore;
  final bool fairPlayBadge;
  final String role;
}

final class ArenaTeamDraft {
  const ArenaTeamDraft({
    required this.id,
    required this.name,
    required this.accent,
    required this.members,
  });

  final String id;
  final String name;
  final VitArenaTeamAccent accent;
  final List<ArenaTeamMemberDraft> members;
}

final class ArenaTeamMemberDraft {
  const ArenaTeamMemberDraft({
    required this.id,
    required this.name,
    required this.role,
  });

  final String id;
  final String name;
  final String role;
}

enum VitArenaTeamAccent { sol, avax }

final class ArenaRewardTierDraft {
  const ArenaRewardTierDraft({required this.label, required this.value});

  final String label;
  final String value;
}

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

enum ArenaProductionScreenStatus { live, future, qaOnly, archived }

enum ArenaProductionScreenState {
  defaultView,
  loading,
  empty,
  error,
  offline,
  underReview,
  reported,
  hidden,
  resolved,
  canceled,
  expired,
}

final class ArenaProductionReadySnapshot {
  const ArenaProductionReadySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.canonicalScreens,
    required this.supportingScreens,
    required this.flows,
    required this.components,
    required this.dictionaries,
    required this.qaItems,
    required this.disclaimer,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaProductionScreenDraft> canonicalScreens;
  final List<ArenaProductionScreenDraft> supportingScreens;
  final List<ArenaProductionFlowDraft> flows;
  final List<ArenaProductionComponentDraft> components;
  final List<ArenaProductionDictionaryDraft> dictionaries;
  final List<String> qaItems;
  final String disclaimer;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaProductionScreenDraft {
  const ArenaProductionScreenDraft({
    required this.name,
    required this.route,
    required this.status,
    required this.version,
    required this.states,
    required this.notes,
  });

  final String name;
  final String route;
  final ArenaProductionScreenStatus status;
  final String version;
  final List<ArenaProductionScreenState> states;
  final String notes;
}

final class ArenaProductionFlowDraft {
  const ArenaProductionFlowDraft({
    required this.id,
    required this.name,
    required this.steps,
  });

  final String id;
  final String name;
  final List<ArenaProductionFlowStepDraft> steps;
}

final class ArenaProductionFlowStepDraft {
  const ArenaProductionFlowStepDraft({
    required this.label,
    required this.route,
    required this.description,
  });

  final String label;
  final String route;
  final String description;
}

final class ArenaProductionComponentDraft {
  const ArenaProductionComponentDraft({
    required this.name,
    required this.file,
    required this.type,
    required this.description,
  });

  final String name;
  final String file;
  final String type;
  final String description;
}

final class ArenaProductionDictionaryDraft {
  const ArenaProductionDictionaryDraft({
    required this.category,
    required this.items,
  });

  final String category;
  final List<ArenaProductionDictionaryItemDraft> items;
}

final class ArenaProductionDictionaryItemDraft {
  const ArenaProductionDictionaryItemDraft({
    required this.code,
    required this.label,
    required this.description,
  });

  final String code;
  final String label;
  final String description;
}

enum ArenaBridgeTone {
  content,
  arena,
  prediction,
  disclosure,
  danger,
  blocked,
  neutral,
}

enum ArenaBridgeExampleStatus { correct, blocked }

final class ArenaPredictionBridgeSnapshot {
  const ArenaPredictionBridgeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.principles,
    required this.allowedItems,
    required this.notAllowedItems,
    required this.topics,
    required this.boundaryBanners,
    required this.badges,
    required this.infoRows,
    required this.bridgeComponents,
    required this.examples,
    required this.dualStats,
    required this.footerDisclosure,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaBridgePrincipleDraft> principles;
  final List<ArenaBridgeRuleDraft> allowedItems;
  final List<ArenaBridgeRuleDraft> notAllowedItems;
  final List<ArenaBridgeTopicDraft> topics;
  final List<ArenaBridgeBoundaryDraft> boundaryBanners;
  final List<ArenaBridgeBadgeDraft> badges;
  final List<ArenaBridgeInfoRowDraft> infoRows;
  final List<ArenaBridgeComponentDraft> bridgeComponents;
  final List<ArenaBridgeExampleDraft> examples;
  final ArenaBridgeDualStatsDraft dualStats;
  final String footerDisclosure;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaBridgePrincipleDraft {
  const ArenaBridgePrincipleDraft({
    required this.number,
    required this.title,
    required this.description,
    required this.tone,
  });

  final int number;
  final String title;
  final String description;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeRuleDraft {
  const ArenaBridgeRuleDraft({
    required this.label,
    required this.description,
    required this.allowed,
  });

  final String label;
  final String description;
  final bool allowed;
}

final class ArenaBridgeTopicDraft {
  const ArenaBridgeTopicDraft({
    required this.id,
    required this.label,
    required this.predictionUsage,
    required this.arenaUsage,
    required this.bridgeUsage,
    required this.tone,
  });

  final String id;
  final String label;
  final String predictionUsage;
  final String arenaUsage;
  final String bridgeUsage;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeBoundaryDraft {
  const ArenaBridgeBoundaryDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.tone,
  });

  final String id;
  final String title;
  final String description;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeBadgeDraft {
  const ArenaBridgeBadgeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.tone,
  });

  final String id;
  final String label;
  final String description;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeInfoRowDraft {
  const ArenaBridgeInfoRowDraft({required this.text, required this.tone});

  final String text;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeComponentDraft {
  const ArenaBridgeComponentDraft({
    required this.name,
    required this.badgeLabel,
    required this.description,
    required this.sampleTitle,
    required this.sampleMeta,
    required this.tone,
  });

  final String name;
  final String badgeLabel;
  final String description;
  final String sampleTitle;
  final String sampleMeta;
  final ArenaBridgeTone tone;
}

final class ArenaBridgeExampleDraft {
  const ArenaBridgeExampleDraft({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.frameTitle,
    required this.evidenceRows,
  });

  final String id;
  final ArenaBridgeExampleStatus status;
  final String title;
  final String description;
  final String frameTitle;
  final List<String> evidenceRows;
}

final class ArenaBridgeDualStatsDraft {
  const ArenaBridgeDualStatsDraft({
    required this.predictionPositions,
    required this.predictionPnlLabel,
    required this.predictionPnlPositive,
    required this.arenaPointsLabel,
    required this.arenaRooms,
  });

  final int predictionPositions;
  final String predictionPnlLabel;
  final bool predictionPnlPositive;
  final String arenaPointsLabel;
  final int arenaRooms;
}

enum ConnectedEcosystemScreenStatus { vFinal, live, needsReview, archived }

enum ConnectedBridgeType { none, source, target, bidirectional }

enum ConnectedRuleSeverity { critical, high, medium }

enum ConnectedQaSeverity { must, should, may }

enum ArenaGuideTone { arena, info, success, warning, danger, accent, neutral }

enum ArenaGuideImpact { high, medium }

final class ConnectedEcosystemProductionSnapshot {
  const ConnectedEcosystemProductionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.canonicalScreens,
    required this.bridgeStates,
    required this.connectedFlows,
    required this.sharedItems,
    required this.separateItems,
    required this.forbiddenPatterns,
    required this.routeRegistry,
    required this.componentRegistry,
    required this.bridgeRules,
    required this.qaChecklist,
    required this.footerDisclosure,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ConnectedScreenDraft> canonicalScreens;
  final List<ConnectedBridgeStateDraft> bridgeStates;
  final List<ConnectedFlowDraft> connectedFlows;
  final List<ConnectedRegistryItemDraft> sharedItems;
  final List<ConnectedRegistryItemDraft> separateItems;
  final List<ConnectedForbiddenPatternDraft> forbiddenPatterns;
  final List<ConnectedRouteEntryDraft> routeRegistry;
  final List<ConnectedComponentEntryDraft> componentRegistry;
  final List<ConnectedBridgeRuleDraft> bridgeRules;
  final List<ConnectedQaCheckDraft> qaChecklist;
  final String footerDisclosure;
  final Set<ArenaScreenState> supportedStates;
}

final class ConnectedScreenDraft {
  const ConnectedScreenDraft({
    required this.name,
    required this.route,
    required this.status,
    required this.source,
    required this.bridgeComponents,
    required this.notes,
  });

  final String name;
  final String route;
  final ConnectedEcosystemScreenStatus status;
  final String source;
  final List<String> bridgeComponents;
  final String notes;
}

final class ConnectedBridgeStateDraft {
  const ConnectedBridgeStateDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.tone,
    required this.affectedScreens,
    required this.behavior,
  });

  final String id;
  final String label;
  final String description;
  final ArenaBridgeTone tone;
  final List<String> affectedScreens;
  final String behavior;
}

final class ConnectedFlowDraft {
  const ConnectedFlowDraft({
    required this.id,
    required this.name,
    required this.tone,
    required this.steps,
  });

  final String id;
  final String name;
  final ArenaBridgeTone tone;
  final List<ConnectedFlowStepDraft> steps;
}

final class ConnectedFlowStepDraft {
  const ConnectedFlowStepDraft({
    required this.label,
    required this.route,
    required this.description,
    this.isBridge = false,
  });

  final String label;
  final String route;
  final String description;
  final bool isBridge;
}

final class ConnectedRegistryItemDraft {
  const ConnectedRegistryItemDraft({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

final class ConnectedForbiddenPatternDraft {
  const ConnectedForbiddenPatternDraft({
    required this.pattern,
    required this.reason,
    required this.severity,
  });

  final String pattern;
  final String reason;
  final ConnectedRuleSeverity severity;
}

final class ConnectedRouteEntryDraft {
  const ConnectedRouteEntryDraft({
    required this.route,
    required this.page,
    required this.bridgeType,
    required this.bridgeComponents,
  });

  final String route;
  final String page;
  final ConnectedBridgeType bridgeType;
  final List<String> bridgeComponents;
}

final class ConnectedComponentEntryDraft {
  const ConnectedComponentEntryDraft({
    required this.name,
    required this.file,
    required this.module,
    required this.usedIn,
    required this.disclosure,
  });

  final String name;
  final String file;
  final String module;
  final List<String> usedIn;
  final String disclosure;
}

final class ConnectedBridgeRuleDraft {
  const ConnectedBridgeRuleDraft({
    required this.field,
    required this.allowed,
    required this.reason,
  });

  final String field;
  final bool allowed;
  final String reason;
}

final class ConnectedQaCheckDraft {
  const ConnectedQaCheckDraft({
    required this.id,
    required this.category,
    required this.check,
    required this.severity,
  });

  final String id;
  final String category;
  final String check;
  final ConnectedQaSeverity severity;
}

final class ArenaGuideSnapshot {
  const ArenaGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.createSteps,
    required this.joinSteps,
    required this.proTips,
    required this.safetyTips,
    required this.faqs,
    required this.examples,
    required this.keyConcepts,
    required this.checklist,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String heroTitle;
  final String heroSubtitle;
  final List<ArenaGuideStepDraft> createSteps;
  final List<ArenaGuideStepDraft> joinSteps;
  final List<ArenaGuideTipDraft> proTips;
  final List<ArenaGuideSafetyTipDraft> safetyTips;
  final List<ArenaGuideFaqDraft> faqs;
  final List<ArenaGuideExampleDraft> examples;
  final List<ArenaGuideConceptDraft> keyConcepts;
  final List<String> checklist;
  final Set<ArenaScreenState> supportedStates;
}

final class ArenaGuideStepDraft {
  const ArenaGuideStepDraft({
    required this.step,
    required this.iconKey,
    required this.title,
    required this.description,
    required this.tip,
    required this.tone,
  });

  final int step;
  final String iconKey;
  final String title;
  final String description;
  final String tip;
  final ArenaGuideTone tone;
}

final class ArenaGuideTipDraft {
  const ArenaGuideTipDraft({
    required this.iconKey,
    required this.title,
    required this.description,
    required this.category,
    required this.impact,
  });

  final String iconKey;
  final String title;
  final String description;
  final String category;
  final ArenaGuideImpact impact;
}

final class ArenaGuideSafetyTipDraft {
  const ArenaGuideSafetyTipDraft({
    required this.iconKey,
    required this.title,
    required this.description,
    required this.tone,
  });

  final String iconKey;
  final String title;
  final String description;
  final ArenaGuideTone tone;
}

final class ArenaGuideFaqDraft {
  const ArenaGuideFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class ArenaGuideExampleDraft {
  const ArenaGuideExampleDraft({
    required this.title,
    required this.template,
    required this.entryPoints,
    required this.format,
    required this.resolution,
    required this.rating,
    required this.tone,
    required this.reasons,
  });

  final String title;
  final String template;
  final int entryPoints;
  final String format;
  final String resolution;
  final String rating;
  final ArenaGuideTone tone;
  final List<String> reasons;
}

final class ArenaGuideConceptDraft {
  const ArenaGuideConceptDraft({required this.term, required this.definition});

  final String term;
  final String definition;
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
