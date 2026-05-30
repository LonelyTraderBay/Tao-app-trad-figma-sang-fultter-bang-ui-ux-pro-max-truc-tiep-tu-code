part of 'trade_entities.dart';

final class TradeExPostCostsReportExportResult {
  const TradeExPostCostsReportExportResult({
    required this.status,
    required this.year,
    required this.downloadUrl,
  });

  final String status;
  final int year;
  final String downloadUrl;
}

final class TradeKidGeneratorSnapshot {
  const TradeKidGeneratorSnapshot({
    required this.document,
    required this.sections,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeKidDocument document;
  final List<TradeKidSection> sections;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeKidDocument {
  const TradeKidDocument({
    required this.title,
    required this.lastUpdated,
    required this.version,
    required this.documentType,
    required this.pages,
    required this.maxPages,
  });

  final String title;
  final String lastUpdated;
  final String version;
  final String documentType;
  final int pages;
  final int maxPages;
}

final class TradeKidSection {
  const TradeKidSection({
    required this.title,
    required this.icon,
    required this.status,
  });

  final String title;
  final TradeKidSectionIcon icon;
  final String status;
}

enum TradeKidSectionIcon { info, target, warning, chart, costs, clock, help }

final class TradePerformanceScenariosSnapshot {
  const TradePerformanceScenariosSnapshot({
    required this.investment,
    required this.holdingPeriods,
    required this.defaultHoldingPeriod,
    required this.scenarios,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investment;
  final List<int> holdingPeriods;
  final int defaultHoldingPeriod;
  final List<TradePerformanceScenario> scenarios;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradePerformanceScenario {
  const TradePerformanceScenario({
    required this.type,
    required this.label,
    required this.annualReturnPct,
  });

  final TradePerformanceScenarioType type;
  final String label;
  final double annualReturnPct;

  double outcomeFor(double investment, int years) {
    return investment * math.pow(1 + annualReturnPct / 100, years).toDouble();
  }

  double profitFor(double investment, int years) {
    return outcomeFor(investment, years) - investment;
  }
}

enum TradePerformanceScenarioType { stress, unfavorable, moderate, favorable }

final class TradeRiskIndicatorSnapshot {
  const TradeRiskIndicatorSnapshot({
    required this.productName,
    required this.productSri,
    required this.holdingPeriodYears,
    required this.levels,
    required this.additionalRisks,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String productName;
  final int productSri;
  final int holdingPeriodYears;
  final List<TradeRiskIndicatorLevel> levels;
  final List<TradeRiskIndicatorAdditionalRisk> additionalRisks;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRiskIndicatorLevel {
  const TradeRiskIndicatorLevel({
    required this.level,
    required this.label,
    required this.tier,
    required this.description,
    required this.examples,
  });

  final int level;
  final String label;
  final TradeRiskIndicatorTier tier;
  final String description;
  final List<String> examples;
}

final class TradeRiskIndicatorAdditionalRisk {
  const TradeRiskIndicatorAdditionalRisk({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

enum TradeRiskIndicatorTier { low, medium, elevated, high }

final class TradeComplaintsHandlingSnapshot {
  const TradeComplaintsHandlingSnapshot({
    required this.activeCount,
    required this.resolvedCount,
    required this.averageResolutionDays,
    required this.categories,
    required this.timeline,
    required this.complaints,
    required this.processSteps,
    required this.ombudsman,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int activeCount;
  final int resolvedCount;
  final int averageResolutionDays;
  final List<TradeComplaintCategory> categories;
  final List<TradeComplaintTimelineStep> timeline;
  final List<TradeComplaint> complaints;
  final List<TradeComplaintProcessStep> processSteps;
  final TradeOmbudsmanInfo ombudsman;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintSubmissionSnapshot {
  const TradeComplaintSubmissionSnapshot({
    required this.processTitle,
    required this.processDescription,
    required this.categories,
    required this.subjectMinLength,
    required this.subjectMaxLength,
    required this.descriptionMinLength,
    required this.descriptionMaxLength,
    required this.termsIntro,
    required this.terms,
    required this.confirmationComplaintId,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String processTitle;
  final String processDescription;
  final List<String> categories;
  final int subjectMinLength;
  final int subjectMaxLength;
  final int descriptionMinLength;
  final int descriptionMaxLength;
  final String termsIntro;
  final List<String> terms;
  final String confirmationComplaintId;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingSnapshot {
  const TradeComplaintTrackingSnapshot({
    required this.complaintId,
    required this.statusLabel,
    required this.submittedLabel,
    required this.responseDueLabel,
    required this.daysRemaining,
    required this.deadlineNotice,
    required this.timeline,
    required this.actions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String complaintId;
  final String statusLabel;
  final String submittedLabel;
  final String responseDueLabel;
  final int daysRemaining;
  final String deadlineNotice;
  final List<TradeComplaintTrackingStep> timeline;
  final List<TradeComplaintTrackingAction> actions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingStep {
  const TradeComplaintTrackingStep({
    required this.title,
    required this.description,
    required this.dateLabel,
    required this.state,
  });

  final String title;
  final String description;
  final String dateLabel;
  final TradeComplaintTrackingStepState state;
}

final class TradeComplaintTrackingAction {
  const TradeComplaintTrackingAction({
    required this.id,
    required this.label,
    required this.icon,
    this.routePath,
  });

  final String id;
  final String label;
  final TradeComplaintTrackingActionIcon icon;
  final String? routePath;
}

enum TradeComplaintTrackingStepState { completed, current, pending }

enum TradeComplaintTrackingActionIcon { message, document, warning }

final class TradeOmbudsmanReferralSnapshot {
  const TradeOmbudsmanReferralSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.eligibility,
    required this.contacts,
    required this.processSteps,
    required this.ctaLabel,
    required this.externalUrl,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final List<TradeOmbudsmanEligibility> eligibility;
  final List<TradeOmbudsmanContact> contacts;
  final List<TradeOmbudsmanProcessStep> processSteps;
  final String ctaLabel;
  final String externalUrl;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeOmbudsmanEligibility {
  const TradeOmbudsmanEligibility({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanContact {
  const TradeOmbudsmanContact({
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
  });

  final String label;
  final String value;
  final TradeOmbudsmanContactIcon icon;
  final String? detail;
}

final class TradeOmbudsmanProcessStep {
  const TradeOmbudsmanProcessStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

enum TradeOmbudsmanContactIcon { phone, website, address }

final class TradeAuditTrailSnapshot {
  const TradeAuditTrailSnapshot({
    required this.noticeTitle,
    required this.noticeDescription,
    required this.stats,
    required this.searchPlaceholder,
    required this.tabs,
    required this.entries,
    required this.exportFormats,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String noticeTitle;
  final String noticeDescription;
  final List<TradeAuditStat> stats;
  final String searchPlaceholder;
  final List<TradeAuditTab> tabs;
  final List<TradeAuditEntry> entries;
  final List<String> exportFormats;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeAuditStat {
  const TradeAuditStat({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;
}

final class TradeAuditTab {
  const TradeAuditTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeAuditEntry {
  const TradeAuditEntry({
    required this.id,
    required this.timestampLabel,
    required this.category,
    required this.categoryLabel,
    required this.action,
    required this.details,
    this.user,
    this.ipAddress,
  });

  final String id;
  final String timestampLabel;
  final TradeAuditCategory category;
  final String categoryLabel;
  final String action;
  final String details;
  final String? user;
  final String? ipAddress;
}

enum TradeAuditCategory { trade, compliance, clientAction, system }

final class TradeRegulatoryInspectionSnapshot {
  const TradeRegulatoryInspectionSnapshot({
    required this.complianceScore,
    required this.scoreLabel,
    required this.readyTitle,
    required this.readyDescription,
    required this.stats,
    required this.frameworks,
    required this.documents,
    required this.portalTitle,
    required this.portalDescription,
    required this.portalCta,
    required this.reportCta,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int complianceScore;
  final String scoreLabel;
  final String readyTitle;
  final String readyDescription;
  final List<TradeRegulatoryInspectionStat> stats;
  final List<TradeRegulatoryFramework> frameworks;
  final List<TradeRegulatoryDocument> documents;
  final String portalTitle;
  final String portalDescription;
  final String portalCta;
  final String reportCta;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRegulatoryInspectionStat {
  const TradeRegulatoryInspectionStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final TradeRegulatoryInspectionStatIcon icon;
}

enum TradeRegulatoryInspectionStatIcon {
  documents,
  clients,
  auditLogs,
  retention,
}

final class TradeRegulatoryFramework {
  const TradeRegulatoryFramework({
    required this.name,
    required this.compliance,
    required this.requirements,
  });

  final String name;
  final int compliance;
  final List<String> requirements;
}

final class TradeRegulatoryDocument {
  const TradeRegulatoryDocument({
    required this.name,
    required this.countLabel,
    required this.status,
  });

  final String name;
  final String countLabel;
  final String status;
}

final class TradeBotTermsSnapshot {
  const TradeBotTermsSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.title,
    required this.lastUpdatedLabel,
    required this.sections,
    required this.acceptSectionLabel,
    required this.scrollWarning,
    required this.agreementTitle,
    required this.agreementDescription,
    required this.disabledCta,
    required this.enabledCta,
    required this.complianceTitle,
    required this.complianceDescription,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final String title;
  final String lastUpdatedLabel;
  final List<TradeBotTermsSection> sections;
  final String acceptSectionLabel;
  final String scrollWarning;
  final String agreementTitle;
  final String agreementDescription;
  final String disabledCta;
  final String enabledCta;
  final String complianceTitle;
  final String complianceDescription;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotTermsSection {
  const TradeBotTermsSection({
    required this.title,
    required this.paragraphs,
    this.warningTitle,
    this.warningBody,
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final String? warningTitle;
  final String? warningBody;
  final List<String> bullets;
}
