part of 'arena_entities.dart';

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
