part of 'arena_entities.dart';

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
