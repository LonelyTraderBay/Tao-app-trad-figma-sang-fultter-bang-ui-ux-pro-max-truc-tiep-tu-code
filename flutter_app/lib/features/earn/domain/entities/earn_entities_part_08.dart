part of 'earn_entities.dart';

final class StakingGuideMistakeDraft {
  const StakingGuideMistakeDraft({
    required this.title,
    required this.correction,
    required this.tone,
  });

  final String title;
  final String correction;
  final String tone;
}

final class StakingFAQSnapshot {
  const StakingFAQSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.supportRoute,
    required this.searchPlaceholder,
    required this.items,
    required this.supportTitle,
    required this.supportBody,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String supportRoute;
  final String searchPlaceholder;
  final List<StakingFAQItemDraft> items;
  final String supportTitle;
  final String supportBody;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingFAQItemDraft {
  const StakingFAQItemDraft({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  final String id;
  final StakingFAQCategory category;
  final String question;
  final String answer;
}

final class StakingNotificationsSnapshot {
  const StakingNotificationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.settingsActionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.settings,
    required this.channels,
    required this.history,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String settingsActionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingNotificationSettingDraft> settings;
  final List<StakingNotificationChannelDraft> channels;
  final List<StakingNotificationHistoryDraft> history;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingNotificationSettingDraft {
  const StakingNotificationSettingDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.enabled,
    required this.priority,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final bool enabled;
  final StakingNotificationPriority priority;

  StakingNotificationSettingDraft copyWith({bool? enabled}) {
    return StakingNotificationSettingDraft(
      id: id,
      title: title,
      description: description,
      iconKey: iconKey,
      enabled: enabled ?? this.enabled,
      priority: priority,
    );
  }
}

final class StakingNotificationChannelDraft {
  const StakingNotificationChannelDraft({
    required this.id,
    required this.label,
    required this.enabled,
  });

  final String id;
  final String label;
  final bool enabled;

  StakingNotificationChannelDraft copyWith({bool? enabled}) {
    return StakingNotificationChannelDraft(
      id: id,
      label: label,
      enabled: enabled ?? this.enabled,
    );
  }
}

final class StakingNotificationHistoryDraft {
  const StakingNotificationHistoryDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.read,
  });

  final String id;
  final StakingNotificationType type;
  final String title;
  final String message;
  final String time;
  final bool read;

  StakingNotificationHistoryDraft copyWith({bool? read}) {
    return StakingNotificationHistoryDraft(
      id: id,
      type: type,
      title: title,
      message: message,
      time: time,
      read: read ?? this.read,
    );
  }
}

final class StakingRecommendationsSnapshot {
  const StakingRecommendationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.riskAssessmentRoute,
    required this.stakingRoute,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.profile,
    required this.strategies,
    required this.tips,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String riskAssessmentRoute;
  final String stakingRoute;
  final String heroTitle;
  final String heroSubtitle;
  final StakingRecommendationProfileDraft profile;
  final List<StakingStrategyDraft> strategies;
  final List<StakingPersonalizedTipDraft> tips;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingRecommendationProfileDraft {
  const StakingRecommendationProfileDraft({
    required this.riskTolerance,
    required this.investmentHorizon,
    required this.liquidityNeed,
    required this.totalPortfolio,
  });

  final StakingRecommendationProfileRisk riskTolerance;
  final StakingRecommendationHorizon investmentHorizon;
  final StakingRecommendationLiquidity liquidityNeed;
  final double totalPortfolio;
}

final class StakingStrategyDraft {
  const StakingStrategyDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.expectedApy,
    required this.riskLevel,
    required this.allocation,
    required this.pros,
    required this.cons,
    required this.bestFor,
    this.recommended = false,
  });

  final String id;
  final String title;
  final String description;
  final double expectedApy;
  final StakingRecommendationRiskLevel riskLevel;
  final List<StakingRecommendationAllocationDraft> allocation;
  final List<String> pros;
  final List<String> cons;
  final List<String> bestFor;
  final bool recommended;
}

final class StakingRecommendationAllocationDraft {
  const StakingRecommendationAllocationDraft({
    required this.product,
    required this.asset,
    required this.percentage,
    required this.apy,
  });

  final String product;
  final String asset;
  final int percentage;
  final double apy;
}

final class StakingPersonalizedTipDraft {
  const StakingPersonalizedTipDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
}

final class StakingRegulatoryFrameworkSnapshot {
  const StakingRegulatoryFrameworkSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroBody,
    required this.licenses,
    required this.protectionSchemes,
    required this.complaintSteps,
    required this.authorityContacts,
    required this.licenseNote,
    required this.protectionWarning,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<StakingRegulatoryTabDraft> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroBody;
  final List<StakingLicenseDraft> licenses;
  final List<StakingProtectionSchemeDraft> protectionSchemes;
  final List<StakingComplaintStepDraft> complaintSteps;
  final List<StakingAuthorityContactDraft> authorityContacts;
  final String licenseNote;
  final String protectionWarning;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingRegulatoryTabDraft {
  const StakingRegulatoryTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class StakingLicenseDraft {
  const StakingLicenseDraft({
    required this.jurisdiction,
    required this.regulator,
    required this.licenseNumber,
    required this.status,
    required this.issuedDate,
    required this.scope,
    required this.website,
    this.expiryDate,
  });

  final String jurisdiction;
  final String regulator;
  final String licenseNumber;
  final StakingLicenseStatus status;
  final String issuedDate;
  final String? expiryDate;
  final List<String> scope;
  final String website;
}

final class StakingProtectionSchemeDraft {
  const StakingProtectionSchemeDraft({
    required this.jurisdiction,
    required this.scheme,
    required this.coverage,
    required this.description,
    required this.eligibility,
  });

  final String jurisdiction;
  final String scheme;
  final String coverage;
  final String description;
  final String eligibility;
}

final class StakingComplaintStepDraft {
  const StakingComplaintStepDraft({
    required this.step,
    required this.title,
    required this.description,
    required this.action,
  });

  final int step;
  final String title;
  final String description;
  final String action;
}

final class StakingAuthorityContactDraft {
  const StakingAuthorityContactDraft({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;
}

final class StakingAuditReportsSnapshot {
  const StakingAuditReportsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroBody,
    required this.stats,
    required this.reports,
    required this.bugBounty,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<StakingAuditTabDraft> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroBody;
  final List<StakingAuditStatDraft> stats;
  final List<StakingAuditReportDraft> reports;
  final StakingBugBountyDraft bugBounty;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingAuditTabDraft {
  const StakingAuditTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class StakingAuditStatDraft {
  const StakingAuditStatDraft({
    required this.label,
    required this.value,
    required this.tone,
    this.caption,
  });

  final String label;
  final String value;
  final EarnRiskLevel tone;
  final String? caption;
}

final class StakingAuditReportDraft {
  const StakingAuditReportDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.auditor,
    required this.dateLabel,
    required this.status,
    required this.findings,
    required this.summary,
    required this.scope,
    this.pdfUrl,
  });

  final String id;
  final StakingAuditReportType type;
  final String title;
  final String auditor;
  final String dateLabel;
  final StakingAuditReportStatus status;
  final StakingAuditFindingsDraft findings;
  final String summary;
  final List<String> scope;
  final String? pdfUrl;
}

final class StakingAuditFindingsDraft {
  const StakingAuditFindingsDraft({
    required this.critical,
    required this.high,
    required this.medium,
    required this.low,
    required this.informational,
  });

  final int critical;
  final int high;
  final int medium;
  final int low;
  final int informational;

  int get resolvedFindings => critical + high + medium + low;
}

final class StakingBugBountyDraft {
  const StakingBugBountyDraft({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.programUrl,
    required this.payouts,
  });

  final String title;
  final String subtitle;
  final String body;
  final String programUrl;
  final List<StakingBugBountyPayoutDraft> payouts;
}

final class StakingBugBountyPayoutDraft {
  const StakingBugBountyPayoutDraft({
    required this.severity,
    required this.amount,
    required this.tone,
  });

  final String severity;
  final String amount;
  final EarnRiskLevel tone;
}

final class StakingCustodySnapshot {
  const StakingCustodySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.custodian,
    required this.segregationBody,
    required this.segregation,
    required this.segregationLegend,
    required this.hotColdBody,
    required this.hotCold,
    required this.reconciliationBody,
    required this.reconciliationLogs,
    required this.transparencyBody,
    required this.transparencyAddresses,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final StakingCustodianDraft custodian;
  final String segregationBody;
  final List<StakingCustodyAllocationDraft> segregation;
  final List<StakingCustodyLegendDraft> segregationLegend;
  final String hotColdBody;
  final List<StakingCustodyAllocationDraft> hotCold;
  final String reconciliationBody;
  final List<StakingReconciliationLogDraft> reconciliationLogs;
  final String transparencyBody;
  final List<StakingTransparencyAddressDraft> transparencyAddresses;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}
