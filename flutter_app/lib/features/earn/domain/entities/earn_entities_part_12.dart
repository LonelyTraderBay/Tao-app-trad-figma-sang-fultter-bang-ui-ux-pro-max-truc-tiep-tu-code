part of 'earn_entities.dart';

final class SavingsWhatIfPortfolioPositionDraft {
  const SavingsWhatIfPortfolioPositionDraft({
    required this.asset,
    required this.product,
    required this.colorKey,
    required this.amountUsd,
    required this.currentApyPct,
    required this.type,
    this.lockDays,
  });

  final String asset;
  final String product;
  final String colorKey;
  final double amountUsd;
  final double currentApyPct;
  final SavingsProductType type;
  final int? lockDays;
}

final class StakingTermsSnapshot {
  const StakingTermsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.documentTitle,
    required this.lastUpdated,
    required this.version,
    required this.warning,
    required this.sections,
    required this.acceptanceText,
    required this.acceptanceFootnote,
    required this.footer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String documentTitle;
  final String lastUpdated;
  final String version;
  final String warning;
  final List<StakingTermsSectionDraft> sections;
  final String acceptanceText;
  final String acceptanceFootnote;
  final String footer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingTermsSectionDraft {
  const StakingTermsSectionDraft({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final List<String> content;
}

final class StakingRiskDisclosureSnapshot {
  const StakingRiskDisclosureSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.defaultTab,
    required this.tabs,
    required this.warningTitle,
    required this.warningBody,
    required this.summaryTitle,
    required this.summaryBody,
    required this.riskCounts,
    required this.productSectionTitle,
    required this.products,
    required this.disclaimer,
    required this.categories,
    required this.assessmentTitle,
    required this.assessmentSubtitle,
    required this.assessmentBody,
    required this.assessmentCta,
    required this.assessmentRoute,
    required this.faqTitle,
    required this.faqs,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String defaultTab;
  final List<StakingRiskDisclosureTabDraft> tabs;
  final String warningTitle;
  final String warningBody;
  final String summaryTitle;
  final String summaryBody;
  final List<StakingRiskCountDraft> riskCounts;
  final String productSectionTitle;
  final List<StakingRiskProductDraft> products;
  final String disclaimer;
  final List<StakingRiskCategoryDraft> categories;
  final String assessmentTitle;
  final String assessmentSubtitle;
  final String assessmentBody;
  final String assessmentCta;
  final String assessmentRoute;
  final String faqTitle;
  final List<StakingRiskFaqDraft> faqs;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingRiskDisclosureTabDraft {
  const StakingRiskDisclosureTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class StakingRiskCountDraft {
  const StakingRiskCountDraft({
    required this.level,
    required this.count,
    required this.label,
  });

  final StakingDisclosureRiskLevel level;
  final int count;
  final String label;
}

final class StakingRiskProductDraft {
  const StakingRiskProductDraft({
    required this.name,
    required this.level,
    required this.risks,
  });

  final String name;
  final StakingDisclosureRiskLevel level;
  final List<String> risks;
}

final class StakingRiskCategoryDraft {
  const StakingRiskCategoryDraft({
    required this.id,
    required this.title,
    required this.level,
    required this.description,
    required this.details,
    required this.examples,
    required this.mitigation,
  });

  final String id;
  final String title;
  final StakingDisclosureRiskLevel level;
  final String description;
  final List<String> details;
  final List<String> examples;
  final List<String> mitigation;
}

final class StakingRiskFaqDraft {
  const StakingRiskFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class StakingWithdrawalPolicySnapshot {
  const StakingWithdrawalPolicySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.defaultTab,
    required this.tabs,
    required this.infoTitle,
    required this.infoBody,
    required this.processTitle,
    required this.processSteps,
    required this.timelineTitle,
    required this.timelines,
    required this.timelineNote,
    required this.penaltyTitle,
    required this.penaltyBody,
    required this.penaltyRules,
    required this.penaltyExamples,
    required this.calculatorCta,
    required this.calculatorDisclaimer,
    required this.emergencyTitle,
    required this.emergencyBody,
    required this.emergencyReasons,
    required this.emergencySteps,
    required this.emergencyFees,
    required this.emergencyWarning,
    required this.supportContacts,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String defaultTab;
  final List<StakingRiskDisclosureTabDraft> tabs;
  final String infoTitle;
  final String infoBody;
  final String processTitle;
  final List<StakingWithdrawalStepDraft> processSteps;
  final String timelineTitle;
  final List<StakingWithdrawalTimelineDraft> timelines;
  final String timelineNote;
  final String penaltyTitle;
  final String penaltyBody;
  final List<StakingWithdrawalPenaltyRuleDraft> penaltyRules;
  final List<StakingWithdrawalPenaltyExampleDraft> penaltyExamples;
  final String calculatorCta;
  final String calculatorDisclaimer;
  final String emergencyTitle;
  final String emergencyBody;
  final List<String> emergencyReasons;
  final List<StakingEmergencyStepDraft> emergencySteps;
  final List<StakingEmergencyFeeDraft> emergencyFees;
  final String emergencyWarning;
  final List<StakingSupportContactDraft> supportContacts;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingWithdrawalStepDraft {
  const StakingWithdrawalStepDraft({
    required this.step,
    required this.title,
    required this.description,
    required this.tone,
  });

  final int step;
  final String title;
  final String description;
  final StakingDisclosureRiskLevel tone;
}

final class StakingWithdrawalTimelineDraft {
  const StakingWithdrawalTimelineDraft({
    required this.product,
    required this.initiate,
    required this.unbonding,
    required this.receive,
    required this.penalty,
  });

  final String product;
  final String initiate;
  final String unbonding;
  final String receive;
  final String penalty;
}

final class StakingWithdrawalPenaltyRuleDraft {
  const StakingWithdrawalPenaltyRuleDraft({
    required this.tone,
    required this.label,
  });

  final StakingDisclosureRiskLevel tone;
  final String label;
}

final class StakingWithdrawalPenaltyExampleDraft {
  const StakingWithdrawalPenaltyExampleDraft({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<StakingWithdrawalCalculationRowDraft> rows;
}

final class StakingWithdrawalCalculationRowDraft {
  const StakingWithdrawalCalculationRowDraft({
    required this.label,
    required this.value,
    this.tone,
    this.highlight = false,
  });

  final String label;
  final String value;
  final StakingDisclosureRiskLevel? tone;
  final bool highlight;
}

final class StakingEmergencyStepDraft {
  const StakingEmergencyStepDraft({
    required this.step,
    required this.text,
    required this.time,
  });

  final int step;
  final String text;
  final String time;
}

final class StakingEmergencyFeeDraft {
  const StakingEmergencyFeeDraft({required this.product, required this.fee});

  final String product;
  final String fee;
}

final class StakingSupportContactDraft {
  const StakingSupportContactDraft({required this.label, required this.value});

  final String label;
  final String value;
}

final class StakingTaxGuideSnapshot {
  const StakingTaxGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.defaultTab,
    required this.tabs,
    required this.disclaimerTitle,
    required this.disclaimerBody,
    required this.overviewTitle,
    required this.overviewBody,
    required this.incomeEvents,
    required this.summaryTitle,
    required this.countrySummaries,
    required this.toolsTitle,
    required this.historyRoute,
    required this.taxReportsRoute,
    required this.jurisdictions,
    required this.calculatorTitle,
    required this.calculatorSubtitle,
    required this.calculatorHint,
    required this.calculatorDisclaimer,
    required this.faqTitle,
    required this.faqs,
    required this.footer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String defaultTab;
  final List<StakingRiskDisclosureTabDraft> tabs;
  final String disclaimerTitle;
  final String disclaimerBody;
  final String overviewTitle;
  final String overviewBody;
  final List<StakingTaxIncomeEventDraft> incomeEvents;
  final String summaryTitle;
  final List<StakingTaxCountrySummaryDraft> countrySummaries;
  final String toolsTitle;
  final String historyRoute;
  final String taxReportsRoute;
  final List<StakingTaxJurisdictionDraft> jurisdictions;
  final String calculatorTitle;
  final String calculatorSubtitle;
  final String calculatorHint;
  final String calculatorDisclaimer;
  final String faqTitle;
  final List<StakingTaxFaqDraft> faqs;
  final String footer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingTaxIncomeEventDraft {
  const StakingTaxIncomeEventDraft({
    required this.title,
    required this.description,
    required this.example,
  });

  final String title;
  final String description;
  final String example;
}

final class StakingTaxCountrySummaryDraft {
  const StakingTaxCountrySummaryDraft({
    required this.code,
    required this.country,
    required this.treatment,
    required this.cgt,
  });

  final String code;
  final String country;
  final String treatment;
  final String cgt;
}

final class StakingTaxJurisdictionDraft {
  const StakingTaxJurisdictionDraft({
    required this.id,
    required this.code,
    required this.name,
    required this.taxAuthority,
    required this.treatment,
    required this.rate,
    required this.reportingForm,
    required this.resources,
  });

  final String id;
  final String code;
  final String name;
  final String taxAuthority;
  final String treatment;
  final String rate;
  final String reportingForm;
  final List<StakingTaxResourceDraft> resources;
}

final class StakingTaxResourceDraft {
  const StakingTaxResourceDraft({required this.label, required this.url});

  final String label;
  final String url;
}

final class StakingTaxFaqDraft {
  const StakingTaxFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class SavingsInsightDraft {
  const SavingsInsightDraft({
    required this.title,
    required this.subtitle,
    required this.tone,
    this.route,
  });

  final String title;
  final String subtitle;
  final EarnRiskLevel tone;
  final String? route;
}

final class SavingsProductDraft {
  const SavingsProductDraft({
    required this.id,
    required this.asset,
    required this.name,
    required this.type,
    required this.apy,
    required this.totalSubscribed,
    required this.remainingQuota,
    required this.participants,
    required this.progress,
    required this.riskLevel,
    this.lockDays,
    this.maxApy,
    this.isHot = false,
    this.isNew = false,
  });

  final String id;
  final String asset;
  final String name;
  final SavingsProductType type;
  final String apy;
  final int? lockDays;
  final String? maxApy;
  final String totalSubscribed;
  final String remainingQuota;
  final String participants;
  final double progress;
  final EarnRiskLevel riskLevel;
  final bool isHot;
  final bool isNew;
}

final class SavingsPositionDraft {
  const SavingsPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.earned,
    required this.apy,
    required this.startDate,
    required this.type,
    required this.riskLevel,
    this.endDate,
  });

  final String id;
  final String product;
  final String asset;
  final String amount;
  final String earned;
  final String apy;
  final String startDate;
  final String? endDate;
  final SavingsProductType type;
  final EarnRiskLevel riskLevel;
}
