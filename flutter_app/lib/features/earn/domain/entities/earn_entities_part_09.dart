part of 'earn_entities.dart';

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

final class StakingSuitabilityOptionDraft {
  const StakingSuitabilityOptionDraft({
    required this.label,
    required this.weight,
  });

  final String label;
  final int weight;
}

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

final class SavingsComparisonSnapshot {
  const SavingsComparisonSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.defaultProductIds,
    required this.maxCompare,
    required this.products,
    required this.details,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<String> defaultProductIds;
  final int maxCompare;
  final List<SavingsProductDraft> products;
  final Map<String, SavingsComparisonDetailDraft> details;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsComparisonDetailDraft {
  const SavingsComparisonDetailDraft({
    required this.risk,
    required this.capacityPercent,
    required this.participants,
    required this.earlyWithdrawal,
    required this.interestPayout,
    required this.compounding,
    required this.insurance,
    required this.minAmount,
    required this.minAmountValue,
    required this.maxDeposit,
    required this.features,
  });

  final EarnRiskLevel risk;
  final int capacityPercent;
  final int participants;
  final String earlyWithdrawal;
  final String interestPayout;
  final String compounding;
  final bool insurance;
  final String minAmount;
  final double minAmountValue;
  final String maxDeposit;
  final List<String> features;
}

final class AutoCompoundSettingsSnapshot {
  const AutoCompoundSettingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.positions,
    required this.frequencies,
    required this.infoItems,
    required this.note,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<AutoCompoundPositionDraft> positions;
  final List<AutoCompoundFrequencyDraft> frequencies;
  final List<AutoCompoundInfoDraft> infoItems;
  final String note;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class AutoCompoundPositionDraft {
  const AutoCompoundPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.earned,
    required this.apy,
    required this.type,
    required this.autoCompound,
    required this.compoundFrequency,
    required this.compoundThreshold,
    required this.lastCompounded,
    required this.totalCompounded,
    required this.compoundCount,
    required this.estimatedBoost,
  });

  final String id;
  final String product;
  final String asset;
  final double amount;
  final double earned;
  final double apy;
  final SavingsProductType type;
  final bool autoCompound;
  final String compoundFrequency;
  final double compoundThreshold;
  final String lastCompounded;
  final double totalCompounded;
  final int compoundCount;
  final int estimatedBoost;
}

final class AutoCompoundFrequencyDraft {
  const AutoCompoundFrequencyDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.boostLabel,
  });

  final String id;
  final String label;
  final String description;
  final String boostLabel;
}

final class AutoCompoundInfoDraft {
  const AutoCompoundInfoDraft({
    required this.title,
    required this.description,
    required this.tone,
  });

  final String title;
  final String description;
  final EarnRiskLevel tone;
}

final class SavingsGoalsSnapshot {
  const SavingsGoalsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.goals,
    required this.templates,
    required this.tips,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<SavingsGoalDraft> goals;
  final List<SavingsGoalTemplateDraft> templates;
  final List<SavingsGoalTipDraft> tips;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsGoalDraft {
  const SavingsGoalDraft({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.currency,
    required this.iconKey,
    required this.startDate,
    required this.targetDate,
    required this.autoContribute,
    required this.monthlyContribution,
    required this.linkedProduct,
    required this.linkedProductApy,
    required this.status,
    required this.milestones,
    required this.contributions,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String currency;
  final String iconKey;
  final String startDate;
  final String targetDate;
  final bool autoContribute;
  final double monthlyContribution;
  final String linkedProduct;
  final double linkedProductApy;
  final SavingsGoalStatus status;
  final List<SavingsGoalMilestoneDraft> milestones;
  final List<SavingsGoalContributionDraft> contributions;
}

final class SavingsGoalMilestoneDraft {
  const SavingsGoalMilestoneDraft({
    required this.id,
    required this.percentage,
    required this.label,
    required this.reward,
    required this.rewardType,
    required this.rewardValue,
    required this.unlocked,
    this.claimedAt,
  });

  final String id;
  final int percentage;
  final String label;
  final String reward;
  final String rewardType;
  final String rewardValue;
  final bool unlocked;
  final String? claimedAt;
}

final class SavingsGoalContributionDraft {
  const SavingsGoalContributionDraft({
    required this.date,
    required this.amount,
    required this.source,
  });

  final String date;
  final double amount;
  final String source;
}

final class SavingsGoalTemplateDraft {
  const SavingsGoalTemplateDraft({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.suggestedTarget,
    required this.suggestedMonths,
    required this.description,
  });

  final String id;
  final String name;
  final String iconKey;
  final double suggestedTarget;
  final int suggestedMonths;
  final String description;
}

final class SavingsGoalTipDraft {
  const SavingsGoalTipDraft({
    required this.title,
    required this.description,
    required this.iconKey,
    required this.tone,
  });

  final String title;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
}

final class SavingsAnalyticsSnapshot {
  const SavingsAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.timeRanges,
    required this.defaultTab,
    required this.defaultTimeRange,
    required this.summary,
    required this.yieldHistory,
    required this.monthlyEarnings,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<String> tabs;
  final List<String> timeRanges;
  final String defaultTab;
  final String defaultTimeRange;
  final SavingsAnalyticsSummaryDraft summary;
  final List<SavingsYieldPointDraft> yieldHistory;
  final List<SavingsMonthlyEarningsPointDraft> monthlyEarnings;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsAnalyticsSummaryDraft {
  const SavingsAnalyticsSummaryDraft({
    required this.totalInvested,
    required this.totalEarned,
    required this.weightedApy,
    required this.dailyEarnings,
    required this.monthlyEarnings,
    required this.annualProjection,
    required this.yieldChange,
  });

  final double totalInvested;
  final double totalEarned;
  final double weightedApy;
  final double dailyEarnings;
  final double monthlyEarnings;
  final double annualProjection;
  final double yieldChange;
}

final class SavingsYieldPointDraft {
  const SavingsYieldPointDraft({
    required this.date,
    required this.usdt,
    required this.btc,
    required this.sol,
    required this.eth,
    required this.total,
  });

  final String date;
  final double usdt;
  final double btc;
  final double sol;
  final double eth;
  final double total;
}

final class SavingsMonthlyEarningsPointDraft {
  const SavingsMonthlyEarningsPointDraft({
    required this.month,
    required this.earned,
    required this.deposited,
    required this.withdrawn,
  });

  final String month;
  final double earned;
  final double deposited;
  final double withdrawn;
}
