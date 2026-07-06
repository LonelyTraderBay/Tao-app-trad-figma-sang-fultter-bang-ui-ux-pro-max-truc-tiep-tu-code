part of 'arena_entities.dart';

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
