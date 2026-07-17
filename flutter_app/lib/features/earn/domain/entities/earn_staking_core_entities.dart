part of 'earn_entities.dart';

/// Which top-level route (earn hub vs staking hub) a staking screen backs into.
enum StakingEarnRoute { earn, staking }

/// Subscription model of a staking/earn product: fixed term, flexible, or DeFi.
enum EarnProductType { fixed, flexible, defi }

/// Severity tier used across staking risk disclosure content.
enum StakingDisclosureRiskLevel { low, medium, high }

/// Risk tier assigned by the staking risk assessment questionnaire.
enum StakingRiskProfileLevel { conservative, moderate, aggressive }

/// Subscription model of a position shown on the staking dashboard.
enum StakingDashboardPositionType { flexible, fixed, defi }

/// Lifecycle status of a position shown on the staking dashboard.
enum StakingDashboardPositionStatus { active, maturing, completed }

/// Kind of ledger event in a staking history entry.
enum StakingHistoryTransactionType { stake, unstake, claim, compound, penalty }

/// Settlement status of a staking history transaction.
enum StakingHistoryTransactionStatus { completed, pending, failed }

/// Kind of event shown on the staking earnings calendar.
enum StakingCalendarEventType {
  dailyReward,
  maturity,
  autoCompound,
  rateChange,
}

/// Ranking tier of a validator shown in validator selection.
enum StakingValidatorTier { top, recommended, standard }

/// Data contract for the earn/staking home screen: totals, products, and
/// positions.
final class StakingEarnSnapshot {
  const StakingEarnSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.savingsRoute,
    required this.totalEarnedUsd,
    required this.activePositions,
    required this.maxApyLabel,
    required this.fundProtectionLabel,
    required this.products,
    required this.positions,
    required this.estimatedIncome,
    required this.contractNotes,
    required this.supportedStates,
    this.highRiskContractId,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String savingsRoute;
  final String totalEarnedUsd;
  final int activePositions;
  final String maxApyLabel;
  final String fundProtectionLabel;
  final List<EarnProductDraft> products;
  final List<EarnPositionDraft> positions;
  final List<EarnIncomeEstimateDraft> estimatedIncome;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
  final String? highRiskContractId;
}

/// A single earn/staking product listing shown for subscription.
final class EarnProductDraft {
  const EarnProductDraft({
    required this.id,
    required this.asset,
    required this.name,
    required this.type,
    required this.apy,
    required this.minAmount,
    required this.lockLabel,
    required this.totalStaked,
    required this.participants,
    required this.progress,
    required this.riskLevel,
    this.boostApy,
    this.isHot = false,
    this.isNew = false,
  });

  final String id;
  final String asset;
  final String name;
  final EarnProductType type;
  final String apy;
  final String? boostApy;
  final String minAmount;
  final String lockLabel;
  final String totalStaked;
  final String participants;
  final double progress;
  final EarnRiskLevel riskLevel;
  final bool isHot;
  final bool isNew;
}

/// A single user earn/staking position.
final class EarnPositionDraft {
  const EarnPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.earned,
    required this.apy,
    required this.startDate,
    required this.endDate,
    required this.type,
  });

  final String id;
  final String product;
  final String asset;
  final String amount;
  final String earned;
  final String apy;
  final String startDate;
  final String? endDate;
  final EarnProductType type;
}

/// A single projected-income line item on the earn/staking home screen.
final class EarnIncomeEstimateDraft {
  const EarnIncomeEstimateDraft({required this.label, required this.value});

  final String label;
  final String value;
}

/// Data contract for the staking terms & conditions document screen.
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

/// A single section within the staking terms document.
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

/// Data contract for the staking risk disclosure screen.
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

/// A tab entry in the staking risk disclosure screen's tab bar.
final class StakingRiskDisclosureTabDraft {
  const StakingRiskDisclosureTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// A risk-level count summary row on the staking risk disclosure screen.
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

/// A single product's risk summary on the staking risk disclosure screen.
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

/// A single risk category explainer on the staking risk disclosure screen.
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

/// A single FAQ entry on the staking risk disclosure screen.
final class StakingRiskFaqDraft {
  const StakingRiskFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// Data contract for the staking withdrawal policy screen.
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

/// A single step in the withdrawal process explainer.
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

/// Per-product withdrawal timeline (initiate/unbonding/receive) row.
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

/// A single early-withdrawal penalty rule row.
final class StakingWithdrawalPenaltyRuleDraft {
  const StakingWithdrawalPenaltyRuleDraft({
    required this.tone,
    required this.label,
  });

  final StakingDisclosureRiskLevel tone;
  final String label;
}

/// A worked penalty calculation example shown on the withdrawal policy
/// screen.
final class StakingWithdrawalPenaltyExampleDraft {
  const StakingWithdrawalPenaltyExampleDraft({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<StakingWithdrawalCalculationRowDraft> rows;
}

/// A single row in a [StakingWithdrawalPenaltyExampleDraft] calculation
/// table.
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

/// A single step in the emergency withdrawal process explainer.
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

/// Per-product emergency withdrawal fee row.
final class StakingEmergencyFeeDraft {
  const StakingEmergencyFeeDraft({required this.product, required this.fee});

  final String product;
  final String fee;
}

/// A support contact entry shown on the withdrawal policy screen.
final class StakingSupportContactDraft {
  const StakingSupportContactDraft({required this.label, required this.value});

  final String label;
  final String value;
}

/// Data contract for the staking tax guide screen.
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

/// A single taxable income event type explained in the tax guide.
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

/// Per-country tax treatment summary row in the tax guide.
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

/// Detailed per-jurisdiction tax guidance entry.
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

/// A reference link within a [StakingTaxJurisdictionDraft].
final class StakingTaxResourceDraft {
  const StakingTaxResourceDraft({required this.label, required this.url});

  final String label;
  final String url;
}

/// A single FAQ entry on the staking tax guide screen.
final class StakingTaxFaqDraft {
  const StakingTaxFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// Data contract for the staking risk assessment questionnaire screen.
final class StakingRiskAssessmentSnapshot {
  const StakingRiskAssessmentSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.resultTitle,
    required this.backRoute,
    required this.stakingRoute,
    required this.questions,
    required this.results,
    required this.infoText,
    required this.footerDisclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String resultTitle;
  final String backRoute;
  final String stakingRoute;
  final List<StakingRiskQuestionDraft> questions;
  final List<StakingRiskProfileResultDraft> results;
  final String infoText;
  final String footerDisclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single question in the staking risk assessment questionnaire.
final class StakingRiskQuestionDraft {
  const StakingRiskQuestionDraft({
    required this.id,
    required this.question,
    required this.options,
    this.helpText,
  });

  final String id;
  final String question;
  final String? helpText;
  final List<StakingRiskOptionDraft> options;
}

/// A single answer option for a [StakingRiskQuestionDraft].
final class StakingRiskOptionDraft {
  const StakingRiskOptionDraft({
    required this.label,
    required this.value,
    this.description,
  });

  final String label;
  final int value;
  final String? description;
}

/// A scored risk profile result band shown after completing the staking
/// assessment.
final class StakingRiskProfileResultDraft {
  const StakingRiskProfileResultDraft({
    required this.level,
    required this.minScore,
    required this.maxScore,
    required this.label,
    required this.description,
    required this.recommendations,
    required this.products,
    required this.warnings,
  });

  final StakingRiskProfileLevel level;
  final int minScore;
  final int maxScore;
  final String label;
  final String description;
  final List<String> recommendations;
  final List<StakingRiskAssessmentProductDraft> products;
  final List<String> warnings;
}

/// A recommended product shown within a [StakingRiskProfileResultDraft].
final class StakingRiskAssessmentProductDraft {
  const StakingRiskAssessmentProductDraft({
    required this.name,
    required this.apy,
    required this.risk,
  });

  final String name;
  final String apy;
  final String risk;
}

/// Data contract for the staking dashboard screen: totals, performance,
/// allocations, and positions.
final class StakingDashboardSnapshot {
  const StakingDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.stakingRoute,
    required this.analyticsRoute,
    required this.historyRoute,
    required this.calendarRoute,
    required this.totalStakedUsd,
    required this.totalEarnedUsd,
    required this.weightedApy,
    required this.dailyEarningsUsd,
    required this.monthlyEarningsUsd,
    required this.yearlyProjectionUsd,
    required this.activePositions,
    required this.maturingSoon,
    required this.performance,
    required this.allocations,
    required this.positions,
    required this.alertTitle,
    required this.alertBody,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String stakingRoute;
  final String analyticsRoute;
  final String historyRoute;
  final String calendarRoute;
  final double totalStakedUsd;
  final double totalEarnedUsd;
  final double weightedApy;
  final double dailyEarningsUsd;
  final double monthlyEarningsUsd;
  final double yearlyProjectionUsd;
  final int activePositions;
  final int maturingSoon;
  final List<StakingPerformancePointDraft> performance;
  final List<StakingAllocationDraft> allocations;
  final List<StakingPositionDraft> positions;
  final String alertTitle;
  final String alertBody;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single data point in the staking dashboard's performance chart.
final class StakingPerformancePointDraft {
  const StakingPerformancePointDraft({
    required this.date,
    required this.valueUsd,
    required this.earnedUsd,
  });

  final String date;
  final double valueUsd;
  final double earnedUsd;
}

/// A single asset slice in the staking dashboard's allocation chart.
final class StakingAllocationDraft {
  const StakingAllocationDraft({
    required this.asset,
    required this.valueUsd,
    required this.colorIndex,
  });

  final String asset;
  final double valueUsd;
  final int colorIndex;
}

/// A single position row on the staking dashboard.
final class StakingPositionDraft {
  const StakingPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.type,
    required this.amount,
    required this.usdValue,
    required this.earned,
    required this.earnedUsd,
    required this.apy,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.colorIndex,
    this.daysUntilMaturity,
  });

  final String id;
  final String product;
  final String asset;
  final StakingDashboardPositionType type;
  final double amount;
  final double usdValue;
  final double earned;
  final double earnedUsd;
  final double apy;
  final String startDate;
  final String? endDate;
  final StakingDashboardPositionStatus status;
  final int colorIndex;
  final int? daysUntilMaturity;
}

/// Data contract for the staking analytics screen.
final class StakingAnalyticsSnapshot {
  const StakingAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.summary,
    required this.earningsBreakdown,
    required this.apyTrends,
    required this.roiComparison,
    required this.productPerformance,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<StakingAnalyticsTabDraft> tabs;
  final String defaultTab;
  final StakingAnalyticsSummaryDraft summary;
  final List<StakingEarningsPointDraft> earningsBreakdown;
  final List<StakingApyTrendPointDraft> apyTrends;
  final List<StakingRoiComparisonPointDraft> roiComparison;
  final List<StakingProductPerformanceDraft> productPerformance;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A tab entry in the staking analytics screen's tab bar.
final class StakingAnalyticsTabDraft {
  const StakingAnalyticsTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

/// Summary metrics card on the staking analytics screen.
final class StakingAnalyticsSummaryDraft {
  const StakingAnalyticsSummaryDraft({
    required this.totalEarned,
    required this.averageApy,
    required this.bestRoi,
  });

  final double totalEarned;
  final double averageApy;
  final double bestRoi;
}

/// A single data point in the staking analytics earnings breakdown chart.
final class StakingEarningsPointDraft {
  const StakingEarningsPointDraft({
    required this.date,
    required this.btc,
    required this.usdt,
    required this.eth,
    required this.sol,
    required this.lp,
    required this.total,
  });

  final String date;
  final double btc;
  final double usdt;
  final double eth;
  final double sol;
  final double lp;
  final double total;
}

/// A single data point in the staking analytics APY trend chart.
final class StakingApyTrendPointDraft {
  const StakingApyTrendPointDraft({
    required this.date,
    required this.flexible,
    required this.fixed,
    required this.defi,
  });

  final String date;
  final double flexible;
  final double fixed;
  final double defi;
}

/// A single data point comparing staking vs holding ROI.
final class StakingRoiComparisonPointDraft {
  const StakingRoiComparisonPointDraft({
    required this.month,
    required this.staking,
    required this.holding,
  });

  final String month;
  final double staking;
  final double holding;
}

/// A single product's performance row on the staking analytics screen.
final class StakingProductPerformanceDraft {
  const StakingProductPerformanceDraft({
    required this.product,
    required this.asset,
    required this.investedUsd,
    required this.earnedUsd,
    required this.roi,
    required this.apy,
    required this.colorIndex,
  });

  final String product;
  final String asset;
  final double investedUsd;
  final double earnedUsd;
  final double roi;
  final double apy;
  final int colorIndex;
}

/// Data contract for the staking transaction history screen.
final class StakingHistorySnapshot {
  const StakingHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.totalStakedUsd,
    required this.totalEarnedUsd,
    required this.totalUnstakedUsd,
    required this.searchPlaceholder,
    required this.transactions,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final double totalStakedUsd;
  final double totalEarnedUsd;
  final double totalUnstakedUsd;
  final String searchPlaceholder;
  final List<StakingHistoryTransactionDraft> transactions;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single row in the staking transaction history list.
final class StakingHistoryTransactionDraft {
  const StakingHistoryTransactionDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.amountLabel,
    required this.usdValue,
    required this.product,
    required this.date,
    required this.time,
    required this.status,
    this.txHash,
    this.note,
  });

  final String id;
  final StakingHistoryTransactionType type;
  final String asset;
  final String amountLabel;
  final double usdValue;
  final String product;
  final String date;
  final String time;
  final StakingHistoryTransactionStatus status;
  final String? txHash;
  final String? note;
}

/// Data contract for the staking earnings calendar screen.
final class StakingEarningsCalendarSnapshot {
  const StakingEarningsCalendarSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.currentMonthLabel,
    required this.currentYear,
    required this.currentMonth,
    required this.todayIso,
    required this.totalUpcomingUsd,
    required this.events,
    required this.infoTitle,
    required this.infoBullets,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<StakingAnalyticsTabDraft> tabs;
  final String defaultTab;
  final String currentMonthLabel;
  final int currentYear;
  final int currentMonth;
  final String todayIso;
  final double totalUpcomingUsd;
  final List<StakingCalendarEventDraft> events;
  final String infoTitle;
  final List<String> infoBullets;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single event entry on the staking earnings calendar.
final class StakingCalendarEventDraft {
  const StakingCalendarEventDraft({
    required this.id,
    required this.dateIso,
    required this.type,
    required this.product,
    required this.asset,
    required this.description,
    this.amount,
    this.usdValue,
    this.oldRate,
    this.newRate,
  });

  final String id;
  final String dateIso;
  final StakingCalendarEventType type;
  final String product;
  final String asset;
  final String description;
  final double? amount;
  final double? usdValue;
  final double? oldRate;
  final double? newRate;
}

/// Data contract for the validator selection screen.
final class StakingValidatorSelectionSnapshot {
  const StakingValidatorSelectionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.validators,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingValidatorDraft> validators;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single selectable validator listing.
final class StakingValidatorDraft {
  const StakingValidatorDraft({
    required this.id,
    required this.name,
    required this.address,
    required this.commission,
    required this.apy,
    required this.uptime,
    required this.totalStaked,
    required this.delegators,
    required this.slashingHistory,
    required this.verified,
    required this.tier,
    required this.description,
    required this.features,
    this.website,
  });

  final String id;
  final String name;
  final String address;
  final double commission;
  final double apy;
  final double uptime;
  final double totalStaked;
  final int delegators;
  final int slashingHistory;
  final bool verified;
  final StakingValidatorTier tier;
  final String description;
  final List<String> features;
  final String? website;
}

/// Data contract for the staking auto-compound settings screen.
final class StakingAutoCompoundSnapshot {
  const StakingAutoCompoundSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.frequencies,
    required this.positions,
    required this.suggestion,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingAutoCompoundFrequencyDraft> frequencies;
  final List<StakingAutoCompoundPositionDraft> positions;
  final String suggestion;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A selectable auto-compound frequency option.
final class StakingAutoCompoundFrequencyDraft {
  const StakingAutoCompoundFrequencyDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

/// A single position row on the staking auto-compound settings screen.
final class StakingAutoCompoundPositionDraft {
  const StakingAutoCompoundPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.autoCompound,
  });

  final String id;
  final String product;
  final String asset;
  final double amount;
  final bool autoCompound;
}

/// A single data point comparing compounded vs non-compounded projections.
final class StakingAutoCompoundPointDraft {
  const StakingAutoCompoundPointDraft({
    required this.month,
    required this.withCompound,
    required this.withoutCompound,
  });

  final int month;
  final double withCompound;
  final double withoutCompound;
}

/// Data contract for the liquid staking (swap to LST) screen.
final class StakingLiquidStakingSnapshot {
  const StakingLiquidStakingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.tokens,
    required this.swapFromOptions,
    required this.swapToOptions,
    required this.slippageTolerance,
    required this.estimatedGasFee,
    required this.holdingsValue,
    required this.riskNote,
    required this.swapNote,
    required this.benefits,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingLiquidTokenDraft> tokens;
  final List<String> swapFromOptions;
  final List<String> swapToOptions;
  final double slippageTolerance;
  final double estimatedGasFee;
  final double holdingsValue;
  final String riskNote;
  final String swapNote;
  final List<StakingLiquidBenefitDraft> benefits;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

/// A single liquid staking token listing.
final class StakingLiquidTokenDraft {
  const StakingLiquidTokenDraft({
    required this.id,
    required this.name,
    required this.symbol,
    required this.underlyingAsset,
    required this.exchangeRate,
    required this.apy,
    required this.totalSupply,
    required this.tvl,
    required this.protocol,
    required this.risks,
    required this.benefits,
  });

  final String id;
  final String name;
  final String symbol;
  final String underlyingAsset;
  final double exchangeRate;
  final double apy;
  final double totalSupply;
  final double tvl;
  final String protocol;
  final List<String> risks;
  final List<String> benefits;
}

/// A single benefit card shown on the liquid staking screen.
final class StakingLiquidBenefitDraft {
  const StakingLiquidBenefitDraft({
    required this.icon,
    required this.label,
    required this.description,
  });

  final String icon;
  final String label;
  final String description;
}
