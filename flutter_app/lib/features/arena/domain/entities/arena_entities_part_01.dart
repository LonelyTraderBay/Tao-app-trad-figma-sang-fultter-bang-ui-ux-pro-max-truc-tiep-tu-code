part of 'arena_entities.dart';

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
