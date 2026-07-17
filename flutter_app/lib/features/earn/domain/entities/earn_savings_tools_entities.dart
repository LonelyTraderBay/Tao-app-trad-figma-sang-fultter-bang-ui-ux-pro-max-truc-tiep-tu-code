part of 'earn_entities.dart';

final class SavingsGuideSnapshot {
  const SavingsGuideSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.savingsRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.tutorials,
    required this.quickTips,
    required this.terms,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String savingsRoute;
  final List<SavingsGuideTabDraft> tabs;
  final String defaultTab;
  final String heroTitle;
  final String heroSubtitle;
  final List<SavingsGuideTutorialDraft> tutorials;
  final List<SavingsGuideQuickTipDraft> quickTips;
  final List<SavingsGuideTermDraft> terms;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsGuideTabDraft {
  const SavingsGuideTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class SavingsGuideTutorialDraft {
  const SavingsGuideTutorialDraft({
    required this.id,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.description,
    required this.steps,
  });

  final String id;
  final String title;
  final String duration;
  final SavingsGuideDifficulty difficulty;
  final String description;
  final List<SavingsGuideStepDraft> steps;
}

final class SavingsGuideStepDraft {
  const SavingsGuideStepDraft({
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

final class SavingsGuideQuickTipDraft {
  const SavingsGuideQuickTipDraft({
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

final class SavingsGuideTermDraft {
  const SavingsGuideTermDraft({required this.term, required this.definition});

  final String term;
  final String definition;
}

enum SavingsGuideDifficulty { beginner, intermediate, advanced }

final class SavingsFAQSnapshot {
  const SavingsFAQSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.supportRoute,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.searchPlaceholder,
    required this.categories,
    required this.items,
    required this.supportTitle,
    required this.supportSubtitle,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String supportRoute;
  final String heroTitle;
  final String heroSubtitle;
  final String searchPlaceholder;
  final List<SavingsFAQCategoryDraft> categories;
  final List<SavingsFAQItemDraft> items;
  final String supportTitle;
  final String supportSubtitle;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsFAQCategoryDraft {
  const SavingsFAQCategoryDraft({
    required this.id,
    required this.label,
    required this.category,
  });

  final String id;
  final String label;
  final SavingsFAQCategory? category;
}

final class SavingsFAQItemDraft {
  const SavingsFAQItemDraft({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  final String id;
  final SavingsFAQCategory category;
  final String question;
  final String answer;
}

enum SavingsFAQCategory { general, products, operations, fees, risks }

final class SavingsNotificationsSnapshot {
  const SavingsNotificationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.settingsActionDraft,
    required this.clearActionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.history,
    required this.settings,
    required this.settingsTitle,
    required this.settingsSubtitle,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String settingsActionDraft;
  final String clearActionDraft;
  final String title;
  final String backRoute;
  final List<SavingsNotificationTabDraft> tabs;
  final String defaultTab;
  final List<SavingsNotificationDraft> history;
  final List<SavingsNotificationSettingDraft> settings;
  final String settingsTitle;
  final String settingsSubtitle;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsNotificationTabDraft {
  const SavingsNotificationTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class SavingsNotificationDraft {
  const SavingsNotificationDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.read,
  });

  final String id;
  final SavingsNotificationType type;
  final String title;
  final String message;
  final String time;
  final bool read;

  SavingsNotificationDraft copyWith({bool? read}) {
    return SavingsNotificationDraft(
      id: id,
      type: type,
      title: title,
      message: message,
      time: time,
      read: read ?? this.read,
    );
  }
}

final class SavingsNotificationSettingDraft {
  const SavingsNotificationSettingDraft({
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
  final SavingsNotificationPriority priority;

  SavingsNotificationSettingDraft copyWith({bool? enabled}) {
    return SavingsNotificationSettingDraft(
      id: id,
      title: title,
      description: description,
      iconKey: iconKey,
      enabled: enabled ?? this.enabled,
      priority: priority,
    );
  }
}

enum SavingsNotificationType {
  maturity,
  apy,
  interest,
  compound,
  product,
  system,
}

enum SavingsNotificationPriority { high, medium, low }

final class SavingsRecommendationsSnapshot {
  const SavingsRecommendationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.riskAssessmentRoute,
    required this.savingsRoute,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.profile,
    required this.strategies,
    required this.insights,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String riskAssessmentRoute;
  final String savingsRoute;
  final String heroTitle;
  final String heroSubtitle;
  final SavingsUserProfileDraft profile;
  final List<SavingsStrategyDraft> strategies;
  final List<SavingsRecommendationInsightDraft> insights;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsUserProfileDraft {
  const SavingsUserProfileDraft({
    required this.riskTolerance,
    required this.investmentHorizon,
    required this.liquidityNeed,
    required this.totalAvailable,
    required this.preferredAssets,
    required this.hasCompletedAssessment,
    required this.assessmentDate,
  });

  final SavingsProfileRiskTolerance riskTolerance;
  final SavingsInvestmentHorizon investmentHorizon;
  final SavingsLiquidityNeed liquidityNeed;
  final double totalAvailable;
  final List<String> preferredAssets;
  final bool hasCompletedAssessment;
  final String assessmentDate;
}

final class SavingsStrategyDraft {
  const SavingsStrategyDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.matchScore,
    required this.expectedApy,
    required this.riskLevel,
    required this.liquidityRatio,
    required this.allocation,
    required this.pros,
    required this.cons,
    required this.bestFor,
    this.recommended = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int matchScore;
  final double expectedApy;
  final SavingsStrategyRiskLevel riskLevel;
  final int liquidityRatio;
  final List<SavingsStrategyAllocationDraft> allocation;
  final List<String> pros;
  final List<String> cons;
  final List<String> bestFor;
  final bool recommended;
}

final class SavingsStrategyAllocationDraft {
  const SavingsStrategyAllocationDraft({
    required this.product,
    required this.asset,
    required this.type,
    required this.percentage,
    required this.apy,
    this.lockDays,
  });

  final String product;
  final String asset;
  final SavingsStrategyAllocationType type;
  final int percentage;
  final double apy;
  final int? lockDays;
}

final class SavingsRecommendationInsightDraft {
  const SavingsRecommendationInsightDraft({
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

enum SavingsProfileRiskTolerance { conservative, moderate, aggressive }

enum SavingsInvestmentHorizon { short, medium, long }

enum SavingsLiquidityNeed { high, medium, low }

enum SavingsStrategyRiskLevel { low, medium, high }

enum SavingsStrategyAllocationType { flexible, locked }

final class SavingsRiskAssessmentSnapshot {
  const SavingsRiskAssessmentSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.resultTitle,
    required this.backRoute,
    required this.savingsRoute,
    required this.recommendationsRoute,
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
  final String savingsRoute;
  final String recommendationsRoute;
  final List<SavingsRiskQuestionDraft> questions;
  final List<SavingsRiskProfileResultDraft> results;
  final String infoText;
  final String footerDisclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsRiskQuestionDraft {
  const SavingsRiskQuestionDraft({
    required this.id,
    required this.question,
    required this.options,
    this.helpText,
  });

  final String id;
  final String question;
  final String? helpText;
  final List<SavingsRiskOptionDraft> options;
}

final class SavingsRiskOptionDraft {
  const SavingsRiskOptionDraft({
    required this.label,
    required this.value,
    this.description,
  });

  final String label;
  final int value;
  final String? description;
}

final class SavingsRiskProfileResultDraft {
  const SavingsRiskProfileResultDraft({
    required this.level,
    required this.minScore,
    required this.maxScore,
    required this.label,
    required this.description,
    required this.strategyMatch,
    required this.recommendations,
    required this.products,
    required this.warnings,
  });

  final SavingsRiskProfileLevel level;
  final int minScore;
  final int maxScore;
  final String label;
  final String description;
  final String strategyMatch;
  final List<String> recommendations;
  final List<SavingsRiskProductDraft> products;
  final List<String> warnings;
}

final class SavingsRiskProductDraft {
  const SavingsRiskProductDraft({
    required this.name,
    required this.apy,
    required this.risk,
    required this.type,
    required this.asset,
  });

  final String name;
  final String apy;
  final String risk;
  final SavingsStrategyAllocationType type;
  final String asset;
}

enum SavingsRiskProfileLevel { conservative, moderate, aggressive }

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

final class SavingsAutoRebalanceSnapshot {
  const SavingsAutoRebalanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.defaultStrategyId,
    required this.totalPortfolio,
    required this.positions,
    required this.strategies,
    required this.driftHistory,
    required this.history,
    required this.settings,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<String> tabs;
  final String defaultTab;
  final String defaultStrategyId;
  final double totalPortfolio;
  final List<SavingsRebalancePositionDraft> positions;
  final List<SavingsRebalanceStrategyDraft> strategies;
  final List<SavingsRebalanceDriftPointDraft> driftHistory;
  final List<SavingsRebalanceHistoryDraft> history;
  final SavingsRebalanceSettingsDraft settings;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsRebalancePositionDraft {
  const SavingsRebalancePositionDraft({
    required this.id,
    required this.asset,
    required this.product,
    required this.currentValue,
    required this.currentPct,
    required this.targetPct,
    required this.apy,
    required this.colorName,
    required this.locked,
    required this.rebalanceable,
    this.lockDays,
    this.daysRemaining,
  });

  final String id;
  final String asset;
  final String product;
  final double currentValue;
  final double currentPct;
  final double targetPct;
  final double apy;
  final String colorName;
  final bool locked;
  final bool rebalanceable;
  final int? lockDays;
  final int? daysRemaining;
}

final class SavingsRebalanceStrategyDraft {
  const SavingsRebalanceStrategyDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.expectedApy,
    required this.allocations,
  });

  final String id;
  final String name;
  final String description;
  final SavingsRebalanceRiskLevel riskLevel;
  final double expectedApy;
  final Map<String, double> allocations;
}

final class SavingsRebalanceDriftPointDraft {
  const SavingsRebalanceDriftPointDraft({
    required this.date,
    required this.drift,
  });

  final String date;
  final double drift;
}

final class SavingsRebalanceHistoryDraft {
  const SavingsRebalanceHistoryDraft({
    required this.id,
    required this.date,
    required this.strategy,
    required this.actions,
    required this.totalMoved,
    required this.status,
    required this.driftBefore,
    required this.driftAfter,
  });

  final String id;
  final String date;
  final String strategy;
  final int actions;
  final double totalMoved;
  final SavingsRebalanceHistoryStatus status;
  final double driftBefore;
  final double driftAfter;
}

final class SavingsRebalanceSettingsDraft {
  const SavingsRebalanceSettingsDraft({
    required this.autoEnabled,
    required this.frequencyLabel,
    required this.driftThreshold,
    required this.skipLocked,
    required this.minTradeSize,
  });

  final bool autoEnabled;
  final String frequencyLabel;
  final double driftThreshold;
  final bool skipLocked;
  final double minTradeSize;
}

enum SavingsRebalanceRiskLevel { low, medium, high }

enum SavingsRebalanceHistoryStatus { completed, partial, failed }

final class SavingsNotificationPreferencesSnapshot {
  const SavingsNotificationPreferencesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.masterEnabled,
    required this.alerts,
    required this.productAlerts,
    required this.channels,
    required this.digestFrequency,
    required this.quietHours,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final bool masterEnabled;
  final List<SavingsNotificationAlertDraft> alerts;
  final List<SavingsProductNotificationDraft> productAlerts;
  final List<SavingsDeliveryChannelDraft> channels;
  final SavingsDeliveryFrequency digestFrequency;
  final SavingsQuietHoursDraft quietHours;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsPreferenceTabDraft {
  const SavingsPreferenceTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class SavingsNotificationAlertDraft {
  const SavingsNotificationAlertDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.enabled,
    required this.category,
    required this.severity,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final bool enabled;
  final SavingsNotificationPreferenceCategory category;
  final SavingsNotificationPreferenceSeverity severity;
}

final class SavingsProductNotificationDraft {
  const SavingsProductNotificationDraft({
    required this.id,
    required this.productName,
    required this.asset,
    required this.typeLabel,
    required this.enabledCount,
    required this.totalCount,
    required this.alertLabels,
  });

  final String id;
  final String productName;
  final String asset;
  final String typeLabel;
  final int enabledCount;
  final int totalCount;
  final List<String> alertLabels;
}

final class SavingsDeliveryChannelDraft {
  const SavingsDeliveryChannelDraft({
    required this.id,
    required this.label,
    required this.detail,
    required this.iconKey,
    required this.enabled,
    this.locked = false,
  });

  final String id;
  final String label;
  final String detail;
  final String iconKey;
  final bool enabled;
  final bool locked;
}

final class SavingsQuietHoursDraft {
  const SavingsQuietHoursDraft({
    required this.enabled,
    required this.startHour,
    required this.endHour,
    required this.allowCritical,
  });

  final bool enabled;
  final int startHour;
  final int endHour;
  final bool allowCritical;
}

enum SavingsNotificationPreferenceCategory { product, transaction, system }

enum SavingsNotificationPreferenceSeverity { critical, important, info }

enum SavingsDeliveryFrequency { instant, hourly, daily, weekly }

final class SavingsDcaSnapshot {
  const SavingsDcaSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.totalInvestedUsd,
    required this.totalCurrentUsd,
    required this.gainUsd,
    required this.gainLabel,
    required this.activePlanCount,
    required this.strategyLabel,
    required this.infoText,
    required this.plans,
    required this.executions,
    required this.products,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final String heroLabel;
  final String totalInvestedUsd;
  final String totalCurrentUsd;
  final String gainUsd;
  final String gainLabel;
  final int activePlanCount;
  final String strategyLabel;
  final String infoText;
  final List<SavingsDcaPlanDraft> plans;
  final List<SavingsDcaExecutionDraft> executions;
  final List<SavingsDcaProductDraft> products;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsDcaPlanDraft {
  const SavingsDcaPlanDraft({
    required this.id,
    required this.productName,
    required this.asset,
    required this.assetLabel,
    required this.amountPerPeriodLabel,
    required this.frequencyLabel,
    required this.status,
    required this.statusLabel,
    required this.totalInvestedLabel,
    required this.currentValueLabel,
    required this.gainLabel,
    required this.gainPositive,
    required this.nextExecution,
    required this.currentApyLabel,
  });

  final String id;
  final String productName;
  final String asset;
  final String assetLabel;
  final String amountPerPeriodLabel;
  final String frequencyLabel;
  final SavingsDcaPlanStatus status;
  final String statusLabel;
  final String totalInvestedLabel;
  final String currentValueLabel;
  final String gainLabel;
  final bool gainPositive;
  final String nextExecution;
  final String currentApyLabel;
}

final class SavingsDcaExecutionDraft {
  const SavingsDcaExecutionDraft({
    required this.id,
    required this.planName,
    required this.date,
    required this.amountLabel,
    required this.asset,
    required this.status,
    required this.apyLabel,
  });

  final String id;
  final String planName;
  final String date;
  final String amountLabel;
  final String asset;
  final SavingsDcaExecutionStatus status;
  final String apyLabel;
}

final class SavingsDcaProductDraft {
  const SavingsDcaProductDraft({
    required this.id,
    required this.name,
    required this.asset,
    required this.apyLabel,
    required this.balanceLabel,
  });

  final String id;
  final String name;
  final String asset;
  final String apyLabel;
  final String balanceLabel;
}

enum SavingsDcaPlanStatus { active, paused, completed, cancelled }

enum SavingsDcaExecutionStatus { success, failed, pending }

final class SavingsSmartSuggestionsSnapshot {
  const SavingsSmartSuggestionsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.filters,
    required this.heroLabel,
    required this.pendingCount,
    required this.potentialApyGainLabel,
    required this.highPriorityCount,
    required this.upTrendCount,
    required this.signalCount,
    required this.suggestions,
    required this.trends,
    required this.signals,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final List<SavingsPreferenceTabDraft> filters;
  final String heroLabel;
  final int pendingCount;
  final String potentialApyGainLabel;
  final int highPriorityCount;
  final int upTrendCount;
  final int signalCount;
  final List<SavingsSuggestionDraft> suggestions;
  final List<SavingsApyTrendDraft> trends;
  final List<SavingsMarketSignalDraft> signals;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsSuggestionDraft {
  const SavingsSuggestionDraft({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.priority,
    required this.priorityLabel,
    required this.status,
    required this.title,
    required this.description,
    required this.reasoning,
    required this.impact,
    required this.impactPositive,
    required this.actionLabel,
    required this.confidence,
    required this.createdAt,
    required this.tags,
    this.actionRoute,
    this.expiresAt,
  });

  final String id;
  final SavingsSuggestionType type;
  final String typeLabel;
  final SavingsSuggestionPriority priority;
  final String priorityLabel;
  final SavingsSuggestionStatus status;
  final String title;
  final String description;
  final String reasoning;
  final String impact;
  final bool impactPositive;
  final String actionLabel;
  final String? actionRoute;
  final int confidence;
  final String createdAt;
  final String? expiresAt;
  final List<String> tags;
}

final class SavingsApyTrendDraft {
  const SavingsApyTrendDraft({
    required this.product,
    required this.asset,
    required this.currentApyLabel,
    required this.averageApyLabel,
    required this.predictionLabel,
    required this.direction,
    required this.points,
  });

  final String product;
  final String asset;
  final String currentApyLabel;
  final String averageApyLabel;
  final String predictionLabel;
  final SavingsApyTrendDirection direction;
  final List<SavingsApyTrendPointDraft> points;
}

final class SavingsApyTrendPointDraft {
  const SavingsApyTrendPointDraft({required this.date, required this.apy});

  final String date;
  final double apy;
}

final class SavingsMarketSignalDraft {
  const SavingsMarketSignalDraft({
    required this.id,
    required this.title,
    required this.type,
    required this.impact,
    required this.affectedProducts,
    required this.timestamp,
  });

  final String id;
  final String title;
  final SavingsMarketSignalType type;
  final String impact;
  final List<String> affectedProducts;
  final String timestamp;
}

enum SavingsSuggestionType {
  dcaTiming,
  productSwitch,
  rebalance,
  newOpportunity,
  riskAlert,
  compoundBoost,
}

enum SavingsSuggestionPriority { high, medium, low }

enum SavingsSuggestionStatus { newItem, viewed, applied, dismissed }

enum SavingsApyTrendDirection { up, down, stable }

enum SavingsMarketSignalType { bullish, bearish, neutral }

final class SavingsExportSnapshot {
  const SavingsExportSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.createdReports,
    required this.reportTypeCountLabel,
    required this.formatSummary,
    required this.retentionLabel,
    required this.reportTypes,
    required this.formats,
    required this.periods,
    required this.scopes,
    required this.options,
    required this.defaultReportType,
    required this.defaultFormat,
    required this.defaultPeriod,
    required this.defaultScope,
    required this.defaultEnabledOptions,
    required this.summaryRows,
    required this.summaryFileSize,
    required this.sensitiveNotice,
    required this.ctaLabel,
    required this.history,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final String heroLabel;
  final int createdReports;
  final String reportTypeCountLabel;
  final String formatSummary;
  final String retentionLabel;
  final List<SavingsExportReportDraft> reportTypes;
  final List<SavingsExportFormatDraft> formats;
  final List<SavingsExportPeriodDraft> periods;
  final List<SavingsExportScopeDraft> scopes;
  final List<SavingsExportOptionDraft> options;
  final SavingsExportReportType defaultReportType;
  final SavingsExportFormat defaultFormat;
  final SavingsExportPeriod defaultPeriod;
  final SavingsExportScope defaultScope;
  final Set<String> defaultEnabledOptions;
  final String summaryRows;
  final String summaryFileSize;
  final String sensitiveNotice;
  final String ctaLabel;
  final List<SavingsExportHistoryDraft> history;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsExportReportDraft {
  const SavingsExportReportDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.rowsLabel,
  });

  final SavingsExportReportType id;
  final String title;
  final String description;
  final String iconKey;
  final String rowsLabel;
}

final class SavingsExportFormatDraft {
  const SavingsExportFormatDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final SavingsExportFormat id;
  final String label;
  final String description;
}

final class SavingsExportPeriodDraft {
  const SavingsExportPeriodDraft({required this.id, required this.label});

  final SavingsExportPeriod id;
  final String label;
}

final class SavingsExportScopeDraft {
  const SavingsExportScopeDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final SavingsExportScope id;
  final String label;
  final String iconKey;
}

final class SavingsExportOptionDraft {
  const SavingsExportOptionDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconKey;
}

final class SavingsExportHistoryDraft {
  const SavingsExportHistoryDraft({
    required this.id,
    required this.fileName,
    required this.format,
    required this.reportType,
    required this.period,
    required this.rowsLabel,
    required this.fileSize,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
  });

  final String id;
  final String fileName;
  final SavingsExportFormat format;
  final SavingsExportReportType reportType;
  final String period;
  final String rowsLabel;
  final String fileSize;
  final SavingsExportStatus status;
  final String createdAt;
  final String expiresAt;
}

enum SavingsExportFormat { csv, pdf, xlsx }

enum SavingsExportScope { all, subscribe, redeem, interest, compound }

enum SavingsExportPeriod {
  sevenDays,
  thirtyDays,
  ninetyDays,
  sixMonths,
  oneYear,
  all,
}

enum SavingsExportReportType { transaction, tax, portfolio, performance }

enum SavingsExportStatus { ready, generating, completed, failed }

final class SavingsBacktestSnapshot {
  const SavingsBacktestSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.recommendationsRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.defaultAmountUsd,
    required this.quickAmounts,
    required this.defaultPeriod,
    required this.periods,
    required this.defaultPreset,
    required this.presets,
    required this.disclaimer,
    required this.result,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String recommendationsRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final String heroLabel;
  final int defaultAmountUsd;
  final List<int> quickAmounts;
  final SavingsBacktestPeriod defaultPeriod;
  final List<SavingsBacktestPeriodDraft> periods;
  final SavingsBacktestPreset defaultPreset;
  final List<SavingsBacktestPresetDraft> presets;
  final String disclaimer;
  final SavingsBacktestResultDraft result;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsBacktestPeriodDraft {
  const SavingsBacktestPeriodDraft({
    required this.id,
    required this.label,
    required this.months,
  });

  final SavingsBacktestPeriod id;
  final String label;
  final int months;
}

final class SavingsBacktestPresetDraft {
  const SavingsBacktestPresetDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.riskLabel,
    required this.slots,
  });

  final SavingsBacktestPreset id;
  final String label;
  final String description;
  final String iconKey;
  final String riskLabel;
  final List<SavingsBacktestSlotDraft> slots;
}

final class SavingsBacktestSlotDraft {
  const SavingsBacktestSlotDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.typeLabel,
    required this.percentage,
    required this.avgApy,
    required this.colorKey,
    this.lockDays,
  });

  final String id;
  final String product;
  final String asset;
  final String typeLabel;
  final int percentage;
  final double avgApy;
  final String colorKey;
  final int? lockDays;
}

final class SavingsBacktestResultDraft {
  const SavingsBacktestResultDraft({
    required this.totalReturnUsd,
    required this.totalReturnPct,
    required this.annualizedReturnPct,
    required this.maxDrawdownPct,
    required this.sharpeRatio,
    required this.finalValueUsd,
    required this.bestMonthUsd,
    required this.worstMonthUsd,
    required this.monthsPositive,
    required this.monthsNegative,
    required this.points,
  });

  final double totalReturnUsd;
  final double totalReturnPct;
  final double annualizedReturnPct;
  final double maxDrawdownPct;
  final double sharpeRatio;
  final double finalValueUsd;
  final double bestMonthUsd;
  final double worstMonthUsd;
  final int monthsPositive;
  final int monthsNegative;
  final List<SavingsBacktestPointDraft> points;
}

final class SavingsBacktestPointDraft {
  const SavingsBacktestPointDraft({
    required this.month,
    required this.valueUsd,
    required this.interestUsd,
  });

  final String month;
  final double valueUsd;
  final double interestUsd;
}

enum SavingsBacktestPeriod { threeMonths, sixMonths, oneYear, twoYears }

enum SavingsBacktestPreset { conservative, balanced, aggressive, custom }

final class SavingsAutoPilotSnapshot {
  const SavingsAutoPilotSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.defaultTab,
    required this.heroLabel,
    required this.config,
    required this.modes,
    required this.metrics,
    required this.modules,
    required this.actions,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final String heroLabel;
  final SavingsAutoPilotConfigDraft config;
  final List<SavingsAutoPilotModeDraft> modes;
  final List<SavingsAutoPilotMetricDraft> metrics;
  final List<SavingsAutoPilotModuleDraft> modules;
  final List<SavingsAutoPilotActionDraft> actions;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsAutoPilotConfigDraft {
  const SavingsAutoPilotConfigDraft({
    required this.mode,
    required this.status,
    required this.monthlyBudgetUsd,
    required this.dcaEnabled,
    required this.dcaFrequencyLabel,
    required this.rebalanceEnabled,
    required this.rebalanceThresholdPct,
    required this.smartSwitchEnabled,
    required this.switchMinApyGainPct,
    required this.compoundEnabled,
    required this.riskGuardEnabled,
    required this.maxSingleAssetPct,
    required this.notificationsEnabled,
    required this.approvalRequired,
  });

  final SavingsAutoPilotMode mode;
  final SavingsAutoPilotStatus status;
  final int monthlyBudgetUsd;
  final bool dcaEnabled;
  final String dcaFrequencyLabel;
  final bool rebalanceEnabled;
  final int rebalanceThresholdPct;
  final bool smartSwitchEnabled;
  final double switchMinApyGainPct;
  final bool compoundEnabled;
  final bool riskGuardEnabled;
  final int maxSingleAssetPct;
  final bool notificationsEnabled;
  final bool approvalRequired;
}

final class SavingsAutoPilotModeDraft {
  const SavingsAutoPilotModeDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.tone,
    required this.dcaFrequency,
    required this.rebalanceThreshold,
    required this.switchMinGain,
    required this.maxConcentration,
  });

  final SavingsAutoPilotMode id;
  final String label;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
  final String dcaFrequency;
  final String rebalanceThreshold;
  final String switchMinGain;
  final String maxConcentration;
}

final class SavingsAutoPilotMetricDraft {
  const SavingsAutoPilotMetricDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.deltaLabel,
    required this.iconKey,
    required this.tone,
  });

  final String id;
  final String label;
  final String value;
  final String deltaLabel;
  final String iconKey;
  final EarnRiskLevel tone;
}

final class SavingsAutoPilotModuleDraft {
  const SavingsAutoPilotModuleDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.enabled,
    required this.iconKey,
    required this.tone,
    required this.route,
  });

  final String id;
  final String label;
  final String description;
  final bool enabled;
  final String iconKey;
  final EarnRiskLevel tone;
  final String route;
}

final class SavingsAutoPilotActionDraft {
  const SavingsAutoPilotActionDraft({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.impact,
    required this.impactValue,
    required this.details,
  });

  final String id;
  final SavingsAutoPilotActionType type;
  final SavingsAutoPilotActionStatus status;
  final String title;
  final String description;
  final String timestamp;
  final String impact;
  final double impactValue;
  final Map<String, String> details;
}

enum SavingsAutoPilotStatus { inactive, active, paused }

enum SavingsAutoPilotMode { conservative, balanced, growth }

enum SavingsAutoPilotActionType {
  dcaExecuted,
  rebalanced,
  switchProduct,
  compoundActivated,
  apyOptimized,
  riskAdjusted,
}

enum SavingsAutoPilotActionStatus { executed, pending, skipped, needsApproval }

final class SavingsLadderSnapshot {
  const SavingsLadderSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroLabel,
    required this.tabs,
    required this.defaultTab,
    required this.defaultAmountUsd,
    required this.quickAmounts,
    required this.defaultPreset,
    required this.templates,
    required this.availableProducts,
    required this.disclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroLabel;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final int defaultAmountUsd;
  final List<int> quickAmounts;
  final SavingsLadderPreset defaultPreset;
  final List<SavingsLadderTemplateDraft> templates;
  final List<SavingsLadderProductDraft> availableProducts;
  final String disclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsLadderTemplateDraft {
  const SavingsLadderTemplateDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.tone,
    required this.intervals,
  });

  final SavingsLadderPreset id;
  final String label;
  final String description;
  final String iconKey;
  final EarnRiskLevel tone;
  final List<SavingsLadderIntervalDraft> intervals;
}

final class SavingsLadderIntervalDraft {
  const SavingsLadderIntervalDraft({
    required this.lockDays,
    required this.allocationPct,
    required this.product,
    required this.asset,
    required this.apyPct,
    required this.colorKey,
  });

  final int lockDays;
  final int allocationPct;
  final String product;
  final String asset;
  final double apyPct;
  final String colorKey;
}

final class SavingsLadderRungDraft {
  const SavingsLadderRungDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.colorKey,
    required this.lockDays,
    required this.apyPct,
    required this.amountUsd,
    required this.startDate,
    required this.maturityDate,
    required this.autoRenew,
  });

  final String id;
  final String product;
  final String asset;
  final String colorKey;
  final int lockDays;
  final double apyPct;
  final double amountUsd;
  final String startDate;
  final String maturityDate;
  final bool autoRenew;
}

final class SavingsLadderProductDraft {
  const SavingsLadderProductDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.colorKey,
    required this.lockDays,
    required this.apyPct,
  });

  final String id;
  final String product;
  final String asset;
  final String colorKey;
  final int lockDays;
  final double apyPct;
}

enum SavingsLadderPreset { monthly, quarterly, biannual, custom }

final class SavingsWhatIfSnapshot {
  const SavingsWhatIfSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroLabel,
    required this.tabs,
    required this.defaultTab,
    required this.defaultScenario,
    required this.defaultCustomMultiplier,
    required this.defaultCustomVolatility,
    required this.scenarios,
    required this.portfolio,
    required this.disclaimer,
    required this.stressDisclaimer,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroLabel;
  final List<SavingsPreferenceTabDraft> tabs;
  final String defaultTab;
  final SavingsWhatIfScenarioId defaultScenario;
  final double defaultCustomMultiplier;
  final double defaultCustomVolatility;
  final List<SavingsWhatIfScenarioDraft> scenarios;
  final List<SavingsWhatIfPortfolioPositionDraft> portfolio;
  final String disclaimer;
  final String stressDisclaimer;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsWhatIfScenarioDraft {
  const SavingsWhatIfScenarioDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.iconKey,
    required this.apyMultiplier,
    required this.volatility,
    required this.durationMonths,
    required this.riskLevel,
  });

  final SavingsWhatIfScenarioId id;
  final String label;
  final String description;
  final String iconKey;
  final double apyMultiplier;
  final double volatility;
  final int durationMonths;
  final SavingsWhatIfRiskLevel riskLevel;
}

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

enum SavingsWhatIfScenarioId {
  apyCrash,
  apySpike,
  rateCut,
  marketStress,
  bullRun,
  custom,
}

enum SavingsWhatIfRiskLevel { low, medium, high, extreme }
