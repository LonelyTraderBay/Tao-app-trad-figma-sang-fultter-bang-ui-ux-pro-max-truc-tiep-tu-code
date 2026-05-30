part of 'earn_entities.dart';

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

final class StakingAnalyticsTabDraft {
  const StakingAnalyticsTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

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
