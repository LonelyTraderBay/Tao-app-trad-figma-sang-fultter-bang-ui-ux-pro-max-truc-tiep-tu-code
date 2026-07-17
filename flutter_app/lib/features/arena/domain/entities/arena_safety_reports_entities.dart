part of 'arena_entities.dart';

/// Community rules, reporting guidance, and disclaimers for the Arena safety center screen.
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

/// A single community rule or reportable action listed on the safety center screen.
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

/// A single step in the report/violation review process explainer.
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

/// A single informational block (with checklist items) on the safety center screen.
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

/// A single allowed/not-allowed statement in a safety info checklist.
final class ArenaSafetyCheckDraft {
  const ArenaSafetyCheckDraft({required this.text, required this.allowed});

  final String text;
  final bool allowed;
}

/// A single quick-link shortcut on the safety center screen.
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

/// Category used to group and style safety center content.
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

/// Full detail of a single moderation report case.
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

/// A user's submitted moderation reports for the 'My Reports' screen.
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

/// Totals by status for a user's submitted reports.
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

/// A single selectable status filter on the 'My Reports' screen.
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

/// A single moderation report case with its target, reason, and timeline.
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

/// A single step in a moderation report's review timeline.
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

/// Review status of a moderation report case.
enum ArenaReportCaseStatus {
  submitted,
  underReview,
  actionTaken,
  closed,
  appealOpen,
}

/// Type of entity a moderation report targets.
enum ArenaReportTargetType { user, challenge, mode }
