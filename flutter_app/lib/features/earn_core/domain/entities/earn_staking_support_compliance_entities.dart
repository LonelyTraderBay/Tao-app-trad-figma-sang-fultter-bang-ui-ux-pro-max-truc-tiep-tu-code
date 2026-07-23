part of 'earn_entities.dart';

/// Difficulty level of a staking guide tutorial.
enum StakingGuideDifficulty { beginner, intermediate, advanced }

/// Topic category of a staking FAQ item.
enum StakingFAQCategory { general, technical, fees, risks, advanced }

/// Urgency level of a staking notification.
enum StakingNotificationPriority { high, medium, low }

/// Category of a staking notification event.
enum StakingNotificationType { maturity, apyChange, reward, risk, system }

/// The user's self-reported risk tolerance for staking recommendations.
enum StakingRecommendationProfileRisk { conservative, moderate, aggressive }

/// The user's preferred investment time horizon for staking recommendations.
enum StakingRecommendationHorizon { short, medium, long }

/// The user's liquidity requirement for staking recommendations.
enum StakingRecommendationLiquidity { high, medium, low }

/// Risk tier of a recommended staking strategy.
enum StakingRecommendationRiskLevel { low, medium, high }

/// Regulatory status of a staking license.
enum StakingLicenseStatus { active, pending, expired }

/// Kind of staking audit report (smart contract, financial, security).
enum StakingAuditReportType { smartContract, financial, security }

/// Publication status of a staking audit report.
enum StakingAuditReportStatus { published, inProgress, scheduled }

/// Input widget kind for a staking suitability questionnaire question.
enum StakingSuitabilityQuestionType { single, slider, quiz }

/// Risk tier assigned by the staking suitability assessment.
enum StakingSuitabilityProfileLevel { conservative, moderate, aggressive }

/// Data contract for the staking beginner's guide screen.
final class StakingGuideSnapshot {
  const StakingGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.stakingRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.tutorials,
    required this.quickTips,
    required this.mistakes,
    required this.ctaTitle,
    required this.ctaBody,
    required this.ctaLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String stakingRoute;
  final String heroTitle;
  final String heroBody;
  final List<StakingGuideTutorialDraft> tutorials;
  final List<StakingGuideQuickTipDraft> quickTips;
  final List<StakingGuideMistakeDraft> mistakes;
  final String ctaTitle;
  final String ctaBody;
  final String ctaLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single tutorial entry in the staking guide.
final class StakingGuideTutorialDraft {
  const StakingGuideTutorialDraft({
    required this.id,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.steps,
  });

  final String id;
  final String title;
  final String duration;
  final StakingGuideDifficulty difficulty;
  final List<StakingGuideStepDraft> steps;
}

/// A single step within a staking guide tutorial.
final class StakingGuideStepDraft {
  const StakingGuideStepDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tips,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final List<String> tips;
}

/// A quick tip card shown in the staking guide.
final class StakingGuideQuickTipDraft {
  const StakingGuideQuickTipDraft({
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String title;
  final String description;
  final String iconKey;
  final String tone;
}

/// A common-mistake-and-correction card shown in the staking guide.
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

/// Data contract for the staking FAQ screen.
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

/// A single question/answer entry on the staking FAQ screen.
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

/// Data contract for the staking notifications (settings + history) screen.
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

/// A single toggleable notification setting on the staking notifications
/// screen.
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

/// A selectable notification delivery channel.
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

/// A single notification entry in the staking notifications history.
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

/// Data contract for the staking recommendations screen.
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

/// The user's risk profile used to drive staking recommendations.
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

/// A single recommended staking allocation strategy.
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

/// A single product allocation slice within a [StakingStrategyDraft].
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

/// A personalized tip card shown on the staking recommendations screen.
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

/// Data contract for the staking regulatory framework screen.
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

/// A tab entry in the regulatory framework screen's tab bar.
final class StakingRegulatoryTabDraft {
  const StakingRegulatoryTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single jurisdiction's staking license entry.
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

/// A single investor-protection scheme entry.
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

/// A single step in the regulatory complaint process explainer.
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

/// A regulatory authority contact entry.
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

/// Data contract for the staking audit reports screen.
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

/// A tab entry in the audit reports screen's tab bar.
final class StakingAuditTabDraft {
  const StakingAuditTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single summary stat card on the audit reports screen.
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

/// A single third-party audit report entry.
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

/// Severity breakdown of findings within a [StakingAuditReportDraft].
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

/// Bug bounty program details shown on the audit reports screen.
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

/// A single payout tier row within a [StakingBugBountyDraft].
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

/// Data contract for the staking custody & fund safety screen.
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

/// The third-party custodian holding staked assets.
final class StakingCustodianDraft {
  const StakingCustodianDraft({
    required this.name,
    required this.type,
    required this.founded,
    required this.headquarters,
    required this.licenses,
    required this.insurance,
    required this.clients,
    required this.aum,
  });

  final String name;
  final String type;
  final String founded;
  final String headquarters;
  final List<String> licenses;
  final String insurance;
  final String clients;
  final String aum;
}

/// A single allocation slice in a custody breakdown chart.
final class StakingCustodyAllocationDraft {
  const StakingCustodyAllocationDraft({
    required this.name,
    required this.value,
    required this.tone,
  });

  final String name;
  final int value;
  final EarnRiskLevel tone;
}

/// A legend entry for a custody breakdown chart.
final class StakingCustodyLegendDraft {
  const StakingCustodyLegendDraft({
    required this.iconKey,
    required this.label,
    required this.description,
    required this.tone,
  });

  final String iconKey;
  final String label;
  final String description;
  final EarnRiskLevel tone;
}

/// A single on-chain vs custody reconciliation log entry.
final class StakingReconciliationLogDraft {
  const StakingReconciliationLogDraft({
    required this.dateLabel,
    required this.onChainUsd,
    required this.custodyUsd,
    required this.discrepancyUsd,
  });

  final String dateLabel;
  final double onChainUsd;
  final double custodyUsd;
  final double discrepancyUsd;
}

/// A single publicly verifiable custody wallet address entry.
final class StakingTransparencyAddressDraft {
  const StakingTransparencyAddressDraft({
    required this.label,
    required this.address,
    required this.explorer,
  });

  final String label;
  final String address;
  final String explorer;
}

/// Data contract for the staking suitability assessment screen.
final class StakingSuitabilityAssessmentSnapshot {
  const StakingSuitabilityAssessmentSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.resultTitle,
    required this.backRoute,
    required this.stakingRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.questions,
    required this.profiles,
    required this.validUntil,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String resultTitle;
  final String backRoute;
  final String stakingRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingSuitabilityQuestionDraft> questions;
  final List<StakingSuitabilityProfileDraft> profiles;
  final String validUntil;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single question in the staking suitability questionnaire.
final class StakingSuitabilityQuestionDraft {
  const StakingSuitabilityQuestionDraft({
    required this.id,
    required this.question,
    required this.type,
    this.options = const [],
    this.min,
    this.max,
    this.weight,
    this.quizQuestions = const [],
  });

  final String id;
  final String question;
  final StakingSuitabilityQuestionType type;
  final List<StakingSuitabilityOptionDraft> options;
  final int? min;
  final int? max;
  final int? weight;
  final List<StakingSuitabilityQuizDraft> quizQuestions;
}

/// A single weighted answer option for a [StakingSuitabilityQuestionDraft].
final class StakingSuitabilityOptionDraft {
  const StakingSuitabilityOptionDraft({
    required this.label,
    required this.weight,
  });

  final String label;
  final int weight;
}

/// A single knowledge-check quiz question within the suitability
/// assessment.
final class StakingSuitabilityQuizDraft {
  const StakingSuitabilityQuizDraft({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
}

/// A scored suitability profile result band.
final class StakingSuitabilityProfileDraft {
  const StakingSuitabilityProfileDraft({
    required this.level,
    required this.minScore,
    required this.maxScore,
    required this.label,
    required this.description,
    required this.products,
    required this.warning,
  });

  final StakingSuitabilityProfileLevel level;
  final int minScore;
  final int maxScore;
  final String label;
  final String description;
  final List<String> products;
  final String? warning;
}
