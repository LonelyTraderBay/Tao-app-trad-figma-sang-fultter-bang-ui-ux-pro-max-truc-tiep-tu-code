enum EarnScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
}

enum StakingEarnRoute { earn, staking }

enum EarnProductType { fixed, flexible, defi }

enum EarnRiskLevel { low, medium, high }

enum StakingDisclosureRiskLevel { low, medium, high }

enum StakingInstitutionalBatchType { stake, unstake, claim }

enum StakingInstitutionalBatchStatus { pending, approved, executed }

enum StakingInstitutionalSignerStatus { approved, pending }

enum StakingGuideDifficulty { beginner, intermediate, advanced }

enum StakingFAQCategory { general, technical, fees, risks, advanced }

enum StakingNotificationPriority { high, medium, low }

enum StakingNotificationType { maturity, apyChange, reward, risk, system }

enum StakingRecommendationProfileRisk { conservative, moderate, aggressive }

enum StakingRecommendationHorizon { short, medium, long }

enum StakingRecommendationLiquidity { high, medium, low }

enum StakingRecommendationRiskLevel { low, medium, high }

enum StakingLicenseStatus { active, pending, expired }

enum StakingAuditReportType { smartContract, financial, security }

enum StakingAuditReportStatus { published, inProgress, scheduled }

enum StakingSuitabilityQuestionType { single, slider, quiz }

enum StakingSuitabilityProfileLevel { conservative, moderate, aggressive }

enum SavingsProductType { flexible, locked }

enum SavingsHistoryTransactionType {
  subscribe,
  redeem,
  interest,
  compound,
  earlyRedeem,
}

enum SavingsHistoryTransactionStatus { completed, pending, failed }

enum SavingsGuideDifficulty { beginner, intermediate, advanced }

enum SavingsFAQCategory { general, products, operations, fees, risks }

enum SavingsNotificationType {
  maturity,
  apy,
  interest,
  compound,
  product,
  system,
}

enum SavingsNotificationPriority { high, medium, low }

enum SavingsProfileRiskTolerance { conservative, moderate, aggressive }

enum SavingsInvestmentHorizon { short, medium, long }

enum SavingsLiquidityNeed { high, medium, low }

enum SavingsStrategyRiskLevel { low, medium, high }

enum SavingsStrategyAllocationType { flexible, locked }

enum SavingsRiskProfileLevel { conservative, moderate, aggressive }

enum StakingRiskProfileLevel { conservative, moderate, aggressive }

enum StakingDashboardPositionType { flexible, fixed, defi }

enum StakingDashboardPositionStatus { active, maturing, completed }

enum StakingHistoryTransactionType { stake, unstake, claim, compound, penalty }

enum StakingHistoryTransactionStatus { completed, pending, failed }

enum StakingCalendarEventType {
  dailyReward,
  maturity,
  autoCompound,
  rateChange,
}

enum StakingValidatorTier { top, recommended, standard }

enum SavingsGoalStatus { active, completed, paused }

enum SavingsRebalanceRiskLevel { low, medium, high }

enum SavingsRebalanceHistoryStatus { completed, partial, failed }

enum SavingsNotificationPreferenceCategory { product, transaction, system }

enum SavingsNotificationPreferenceSeverity { critical, important, info }

enum SavingsDeliveryFrequency { instant, hourly, daily, weekly }

enum SavingsDcaPlanStatus { active, paused, completed, cancelled }

enum SavingsDcaExecutionStatus { success, failed, pending }

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

enum SavingsBacktestPeriod { threeMonths, sixMonths, oneYear, twoYears }

enum SavingsBacktestPreset { conservative, balanced, aggressive, custom }

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

enum SavingsLadderPreset { monthly, quarterly, biannual, custom }

enum SavingsWhatIfScenarioId {
  apyCrash,
  apySpike,
  rateCut,
  marketStress,
  bullRun,
  custom,
}

enum SavingsWhatIfRiskLevel { low, medium, high, extreme }

enum StakingAdvancedOrderType { takeProfit, stopLoss, trailingStop }

enum StakingAdvancedOrderStatus { active, triggered, cancelled }

enum StakingChainId { ethereum, polygon, avalanche, cosmos, solana }

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
}

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

final class EarnIncomeEstimateDraft {
  const EarnIncomeEstimateDraft({required this.label, required this.value});

  final String label;
  final String value;
}

final class SavingsSnapshot {
  const SavingsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.portfolioRoute,
    required this.guideRoute,
    required this.exportRoute,
    required this.productDetailRoute,
    required this.totalDepositedUsd,
    required this.gainLabel,
    required this.insights,
    required this.products,
    required this.positions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String portfolioRoute;
  final String guideRoute;
  final String exportRoute;
  final String productDetailRoute;
  final String totalDepositedUsd;
  final String gainLabel;
  final List<SavingsInsightDraft> insights;
  final List<SavingsProductDraft> products;
  final List<SavingsPositionDraft> positions;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsProductDetailSnapshot {
  const SavingsProductDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.productId,
    required this.product,
    required this.notFoundMessage,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String productId;
  final SavingsProductDraft? product;
  final String notFoundMessage;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsRedeemSnapshot {
  const SavingsRedeemSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.receiptRoute,
    required this.positionId,
    required this.position,
    required this.notFoundMessage,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String receiptRoute;
  final String positionId;
  final SavingsPositionDraft? position;
  final String notFoundMessage;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsReceiptSnapshot {
  const SavingsReceiptSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.earnRoute,
    required this.receipt,
    required this.emptyMessage,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String earnRoute;
  final SavingsReceiptDraft? receipt;
  final String emptyMessage;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsReceiptDraft {
  const SavingsReceiptDraft({
    required this.referenceId,
    required this.type,
    required this.product,
    required this.asset,
    required this.amount,
    required this.timestamp,
  });

  final String referenceId;
  final String type;
  final String product;
  final String asset;
  final String amount;
  final String timestamp;
}

final class SavingsPortfolioSnapshot {
  const SavingsPortfolioSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.savingsRoute,
    required this.historyRoute,
    required this.totalDepositedUsd,
    required this.gainLabel,
    required this.weightedApy,
    required this.flexibleTotalUsd,
    required this.lockedTotalUsd,
    required this.activePositions,
    required this.maturingPositions,
    required this.positions,
    required this.incomeProjections,
    required this.maturityEvents,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String savingsRoute;
  final String historyRoute;
  final String totalDepositedUsd;
  final String gainLabel;
  final String weightedApy;
  final String flexibleTotalUsd;
  final String lockedTotalUsd;
  final int activePositions;
  final int maturingPositions;
  final List<SavingsPortfolioPositionDraft> positions;
  final List<SavingsIncomeProjectionDraft> incomeProjections;
  final List<SavingsMaturityEventDraft> maturityEvents;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsPortfolioPositionDraft {
  const SavingsPortfolioPositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.type,
    required this.amount,
    required this.usdValue,
    required this.allocationLabel,
    required this.earned,
    required this.apy,
    required this.startDate,
    required this.status,
    required this.progress,
    required this.tone,
    this.endDate,
    this.daysLeft,
  });

  final String id;
  final String product;
  final String asset;
  final SavingsProductType type;
  final String amount;
  final String usdValue;
  final String allocationLabel;
  final String earned;
  final String apy;
  final String startDate;
  final String? endDate;
  final String status;
  final double progress;
  final EarnRiskLevel tone;
  final int? daysLeft;
}

final class SavingsIncomeProjectionDraft {
  const SavingsIncomeProjectionDraft({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final String icon;
}

final class SavingsMaturityEventDraft {
  const SavingsMaturityEventDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.apy,
    required this.progress,
    required this.date,
    required this.daysLeft,
    required this.elapsedLabel,
    required this.tone,
  });

  final String id;
  final String product;
  final String asset;
  final String amount;
  final String usdValue;
  final String apy;
  final double progress;
  final String date;
  final int daysLeft;
  final String elapsedLabel;
  final EarnRiskLevel tone;
}

final class SavingsHistorySnapshot {
  const SavingsHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.receiptRoute,
    required this.totalSubscribed,
    required this.totalInterest,
    required this.totalRedeemed,
    required this.searchPlaceholder,
    required this.transactions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String receiptRoute;
  final String totalSubscribed;
  final String totalInterest;
  final String totalRedeemed;
  final String searchPlaceholder;
  final List<SavingsHistoryTransactionDraft> transactions;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class SavingsHistoryTransactionDraft {
  const SavingsHistoryTransactionDraft({
    required this.id,
    required this.type,
    required this.status,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.product,
    required this.date,
    required this.time,
    required this.referenceId,
    this.note,
  });

  final String id;
  final SavingsHistoryTransactionType type;
  final SavingsHistoryTransactionStatus status;
  final String asset;
  final String amount;
  final String usdValue;
  final String product;
  final String date;
  final String time;
  final String referenceId;
  final String? note;
}

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

final class StakingInsuranceSnapshot {
  const StakingInsuranceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.plans,
    required this.positions,
    required this.claims,
    required this.benefits,
    required this.warningTitle,
    required this.warningBullets,
    required this.claimReasons,
    required this.claimEvidenceNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingInsurancePlanDraft> plans;
  final List<StakingInsurancePositionDraft> positions;
  final List<StakingInsuranceClaimDraft> claims;
  final List<StakingInsuranceBenefitDraft> benefits;
  final String warningTitle;
  final List<String> warningBullets;
  final List<String> claimReasons;
  final String claimEvidenceNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingInsurancePlanDraft {
  const StakingInsurancePlanDraft({
    required this.id,
    required this.name,
    required this.coverage,
    required this.premium,
    required this.maxClaim,
    required this.cooldownDays,
    required this.features,
  });

  final String id;
  final String name;
  final int coverage;
  final double premium;
  final double maxClaim;
  final int cooldownDays;
  final List<String> features;
}

final class StakingInsurancePositionDraft {
  const StakingInsurancePositionDraft({
    required this.id,
    required this.product,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.insured,
    this.insurancePlanId,
  });

  final String id;
  final String product;
  final String asset;
  final double amount;
  final double usdValue;
  final bool insured;
  final String? insurancePlanId;
}

final class StakingInsuranceClaimDraft {
  const StakingInsuranceClaimDraft({
    required this.id,
    required this.date,
    required this.position,
    required this.reason,
    required this.loss,
    required this.coverage,
    required this.payout,
    required this.status,
  });

  final String id;
  final String date;
  final String position;
  final String reason;
  final double loss;
  final int coverage;
  final double payout;
  final String status;
}

final class StakingInsuranceBenefitDraft {
  const StakingInsuranceBenefitDraft({
    required this.icon,
    required this.label,
    required this.description,
  });

  final String icon;
  final String label;
  final String description;
}

final class StakingInsuranceFundTransparencySnapshot {
  const StakingInsuranceFundTransparencySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.totalBalance,
    required this.targetRatio,
    required this.currentRatio,
    required this.liabilities,
    required this.surplus,
    required this.lastUpdated,
    required this.assets,
    required this.claims,
    required this.history,
    required this.stakingFeeContribution,
    required this.monthlyContribution,
    required this.ytdContributions,
    required this.totalContributed,
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
  final double totalBalance;
  final int targetRatio;
  final int currentRatio;
  final double liabilities;
  final double surplus;
  final String lastUpdated;
  final List<StakingInsuranceFundAssetDraft> assets;
  final List<StakingInsuranceFundClaimDraft> claims;
  final List<StakingInsuranceFundHistoryDraft> history;
  final int stakingFeeContribution;
  final double monthlyContribution;
  final double ytdContributions;
  final double totalContributed;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingInsuranceFundAssetDraft {
  const StakingInsuranceFundAssetDraft({
    required this.asset,
    required this.value,
    required this.percentage,
    required this.colorKey,
  });

  final String asset;
  final double value;
  final int percentage;
  final String colorKey;
}

final class StakingInsuranceFundClaimDraft {
  const StakingInsuranceFundClaimDraft({
    required this.id,
    required this.date,
    required this.user,
    required this.reason,
    required this.loss,
    required this.coverage,
    required this.payout,
    required this.status,
    required this.processingDays,
  });

  final String id;
  final String date;
  final String user;
  final String reason;
  final double loss;
  final int coverage;
  final double payout;
  final String status;
  final int processingDays;
}

final class StakingInsuranceFundHistoryDraft {
  const StakingInsuranceFundHistoryDraft({
    required this.month,
    required this.balance,
    required this.ratio,
  });

  final String month;
  final double balance;
  final int ratio;
}

final class StakingTransactionReportingSnapshot {
  const StakingTransactionReportingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.years,
    required this.defaultYear,
    required this.defaultCostBasis,
    required this.summary,
    required this.transactions,
    required this.costBasisMethods,
    required this.taxForms,
    required this.integrations,
    required this.rawDataFormats,
    required this.resources,
    required this.taxNotice,
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
  final List<String> years;
  final String defaultYear;
  final String defaultCostBasis;
  final StakingTaxSummaryDraft summary;
  final List<StakingTaxTransactionDraft> transactions;
  final List<StakingCostBasisMethodDraft> costBasisMethods;
  final List<StakingTaxExportOptionDraft> taxForms;
  final List<StakingTaxExportOptionDraft> integrations;
  final List<StakingTaxExportOptionDraft> rawDataFormats;
  final List<StakingTaxResourceDraft> resources;
  final String taxNotice;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingTaxSummaryDraft {
  const StakingTaxSummaryDraft({
    required this.totalStakingIncome,
    required this.totalCapitalGains,
    required this.costBasis,
    required this.proceeds,
    required this.shortTermGains,
    required this.longTermGains,
    required this.rewardsByAsset,
  });

  final double totalStakingIncome;
  final double totalCapitalGains;
  final double costBasis;
  final double proceeds;
  final double shortTermGains;
  final double longTermGains;
  final List<StakingTaxRewardAssetDraft> rewardsByAsset;
}

final class StakingTaxRewardAssetDraft {
  const StakingTaxRewardAssetDraft({
    required this.asset,
    required this.amount,
    required this.usdValue,
  });

  final String asset;
  final double amount;
  final double usdValue;
}

final class StakingTaxTransactionDraft {
  const StakingTaxTransactionDraft({
    required this.date,
    required this.type,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.taxable,
    this.costBasis,
  });

  final String date;
  final String type;
  final String asset;
  final double amount;
  final double usdValue;
  final bool taxable;
  final double? costBasis;
}

final class StakingCostBasisMethodDraft {
  const StakingCostBasisMethodDraft({
    required this.value,
    required this.label,
    required this.description,
  });

  final String value;
  final String label;
  final String description;
}

final class StakingTaxExportOptionDraft {
  const StakingTaxExportOptionDraft({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

final class StakingApiDocumentationSnapshot {
  const StakingApiDocumentationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.stats,
    required this.defaultTab,
    required this.defaultLanguage,
    required this.endpoints,
    required this.codeExamples,
    required this.sandboxBaseUrl,
    required this.authHeaderExample,
    required this.rateLimits,
    required this.errorCodes,
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
  final List<StakingApiStatDraft> stats;
  final String defaultTab;
  final String defaultLanguage;
  final List<StakingApiEndpointDraft> endpoints;
  final List<StakingApiCodeExampleDraft> codeExamples;
  final String sandboxBaseUrl;
  final String authHeaderExample;
  final List<StakingApiRateLimitDraft> rateLimits;
  final List<StakingApiErrorCodeDraft> errorCodes;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingApiStatDraft {
  const StakingApiStatDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

final class StakingApiEndpointDraft {
  const StakingApiEndpointDraft({
    required this.method,
    required this.path,
    required this.name,
    required this.description,
    required this.params,
    required this.responseJson,
  });

  final String method;
  final String path;
  final String name;
  final String description;
  final List<StakingApiParameterDraft> params;
  final String responseJson;
}

final class StakingApiParameterDraft {
  const StakingApiParameterDraft({
    required this.name,
    required this.type,
    required this.required,
    required this.description,
  });

  final String name;
  final String type;
  final bool required;
  final String description;
}

final class StakingApiCodeExampleDraft {
  const StakingApiCodeExampleDraft({
    required this.language,
    required this.label,
    required this.source,
  });

  final String language;
  final String label;
  final String source;
}

final class StakingApiRateLimitDraft {
  const StakingApiRateLimitDraft({
    required this.tier,
    required this.requests,
    required this.window,
    required this.price,
    required this.recommended,
  });

  final String tier;
  final int requests;
  final String window;
  final String price;
  final bool recommended;
}

final class StakingApiErrorCodeDraft {
  const StakingApiErrorCodeDraft({required this.code, required this.message});

  final int code;
  final String message;
}

final class StakingProofOfReservesSnapshot {
  const StakingProofOfReservesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.overall,
    required this.assets,
    required this.auditReports,
    required this.history,
    required this.verifySteps,
    required this.verifyInfo,
    required this.privacyNote,
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
  final StakingReserveOverallDraft overall;
  final List<StakingAssetReserveDraft> assets;
  final List<StakingReserveAuditReportDraft> auditReports;
  final List<StakingReserveHistoryPointDraft> history;
  final List<StakingReserveVerifyStepDraft> verifySteps;
  final String verifyInfo;
  final String privacyNote;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingReserveOverallDraft {
  const StakingReserveOverallDraft({
    required this.totalAssetsUsd,
    required this.totalLiabilitiesUsd,
    required this.reserveRatio,
    required this.lastAudit,
    required this.lastUpdated,
  });

  final double totalAssetsUsd;
  final double totalLiabilitiesUsd;
  final double reserveRatio;
  final String lastAudit;
  final String lastUpdated;
}

final class StakingAssetReserveDraft {
  const StakingAssetReserveDraft({
    required this.asset,
    required this.onChainBalance,
    required this.userLiabilities,
    required this.reserveRatio,
    required this.lastUpdated,
    required this.walletAddress,
    required this.explorer,
  });

  final String asset;
  final double onChainBalance;
  final double userLiabilities;
  final double reserveRatio;
  final String lastUpdated;
  final String walletAddress;
  final String explorer;
}

final class StakingReserveAuditReportDraft {
  const StakingReserveAuditReportDraft({
    required this.id,
    required this.auditor,
    required this.dateLabel,
    required this.status,
    required this.reportUrl,
    required this.findings,
  });

  final String id;
  final String auditor;
  final String dateLabel;
  final String status;
  final String reportUrl;
  final String findings;
}

final class StakingReserveHistoryPointDraft {
  const StakingReserveHistoryPointDraft({
    required this.month,
    required this.ratio,
  });

  final String month;
  final double ratio;
}

final class StakingReserveVerifyStepDraft {
  const StakingReserveVerifyStepDraft({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class StakingMerkleProofDraft {
  const StakingMerkleProofDraft({
    required this.userId,
    required this.balance,
    required this.leaf,
    required this.root,
    required this.siblings,
    required this.verified,
  });

  final String userId;
  final double balance;
  final String leaf;
  final String root;
  final List<String> siblings;
  final bool verified;
}

final class StakingRiskDashboardSnapshot {
  const StakingRiskDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.overallScore,
    required this.totalStakedUsd,
    required this.atRiskUsd,
    required this.protectedPercent,
    required this.riskMetrics,
    required this.exposures,
    required this.events,
    required this.actions,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final int overallScore;
  final double totalStakedUsd;
  final double atRiskUsd;
  final int protectedPercent;
  final List<StakingRiskMetricDraft> riskMetrics;
  final List<StakingRiskExposureDraft> exposures;
  final List<StakingRiskEventDraft> events;
  final List<StakingRiskActionDraft> actions;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingRiskMetricDraft {
  const StakingRiskMetricDraft({
    required this.category,
    required this.score,
    required this.status,
    required this.description,
    this.actionRoute,
  });

  final String category;
  final int score;
  final String status;
  final String description;
  final String? actionRoute;
}

final class StakingRiskExposureDraft {
  const StakingRiskExposureDraft({
    required this.asset,
    required this.valueUsd,
    required this.percentage,
    required this.risk,
  });

  final String asset;
  final double valueUsd;
  final int percentage;
  final String risk;
}

final class StakingRiskEventDraft {
  const StakingRiskEventDraft({
    required this.id,
    required this.dateLabel,
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
  });

  final String id;
  final String dateLabel;
  final String type;
  final String title;
  final String description;
  final String severity;
}

final class StakingRiskActionDraft {
  const StakingRiskActionDraft({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final String route;
  final String tone;
}

final class StakingSlashingHistorySnapshot {
  const StakingSlashingHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.stats,
    required this.events,
    required this.trend,
    required this.networkBreakdown,
    required this.reasonBreakdown,
    required this.preventionMeasures,
    required this.exportLabel,
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
  final StakingSlashingStatsDraft stats;
  final List<StakingSlashingEventDraft> events;
  final List<StakingSlashingTrendPointDraft> trend;
  final List<StakingSlashingNetworkDraft> networkBreakdown;
  final List<StakingSlashingReasonDraft> reasonBreakdown;
  final List<StakingSlashingPreventionDraft> preventionMeasures;
  final String exportLabel;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingSlashingStatsDraft {
  const StakingSlashingStatsDraft({
    required this.totalEvents,
    required this.totalSlashedEth,
    required this.totalCoveredEth,
    required this.coverageRate,
    required this.avgRecoveryTime,
    required this.lastEvent,
  });

  final int totalEvents;
  final double totalSlashedEth;
  final double totalCoveredEth;
  final double coverageRate;
  final String avgRecoveryTime;
  final String lastEvent;
}

final class StakingSlashingEventDraft {
  const StakingSlashingEventDraft({
    required this.id,
    required this.dateLabel,
    required this.validator,
    required this.network,
    required this.reason,
    required this.slashedAmount,
    required this.affectedUsers,
    required this.insuranceCoverage,
    required this.status,
  });

  final String id;
  final String dateLabel;
  final String validator;
  final String network;
  final String reason;
  final double slashedAmount;
  final int affectedUsers;
  final int insuranceCoverage;
  final String status;
}

final class StakingSlashingTrendPointDraft {
  const StakingSlashingTrendPointDraft({
    required this.month,
    required this.events,
    required this.amountEth,
  });

  final String month;
  final int events;
  final double amountEth;
}

final class StakingSlashingNetworkDraft {
  const StakingSlashingNetworkDraft({
    required this.network,
    required this.events,
    required this.amount,
    required this.unit,
    required this.coverage,
  });

  final String network;
  final int events;
  final double amount;
  final String unit;
  final int coverage;
}

final class StakingSlashingReasonDraft {
  const StakingSlashingReasonDraft({
    required this.reason,
    required this.events,
    required this.severity,
  });

  final String reason;
  final int events;
  final String severity;
}

final class StakingSlashingPreventionDraft {
  const StakingSlashingPreventionDraft({
    required this.measure,
    required this.status,
    required this.description,
  });

  final String measure;
  final String status;
  final String description;
}

final class StakingValidatorHealthMonitorSnapshot {
  const StakingValidatorHealthMonitorSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.validators,
    required this.uptimeHistory,
    required this.actionTitle,
    required this.actionBody,
    required this.actionLabel,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<StakingValidatorHealthDraft> validators;
  final List<StakingUptimeHistoryPointDraft> uptimeHistory;
  final String actionTitle;
  final String actionBody;
  final String actionLabel;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;

  int get healthyCount =>
      validators.where((validator) => validator.status == 'healthy').length;

  int get warningCount =>
      validators.where((validator) => validator.status == 'warning').length;

  double get averageUptime =>
      validators.fold<double>(0, (sum, validator) => sum + validator.uptime) /
      validators.length;
}

final class StakingValidatorHealthDraft {
  const StakingValidatorHealthDraft({
    required this.id,
    required this.name,
    required this.address,
    required this.uptime,
    required this.apr,
    required this.totalStakedEth,
    required this.commission,
    required this.status,
    required this.lastBlock,
    required this.missedBlocks,
  });

  final String id;
  final String name;
  final String address;
  final double uptime;
  final double apr;
  final double totalStakedEth;
  final int commission;
  final String status;
  final String lastBlock;
  final int missedBlocks;
}

final class StakingUptimeHistoryPointDraft {
  const StakingUptimeHistoryPointDraft({
    required this.dateLabel,
    required this.validatorOne,
    required this.validatorTwo,
    required this.validatorThree,
  });

  final String dateLabel;
  final double validatorOne;
  final double validatorTwo;
  final double validatorThree;
}

final class StakingRiskScoreCalculatorSnapshot {
  const StakingRiskScoreCalculatorSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.defaultAmountUsd,
    required this.defaultAsset,
    required this.defaultDuration,
    required this.defaultValidators,
    required this.assetOptions,
    required this.durationOptions,
    required this.recommendations,
    required this.proceedLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final double defaultAmountUsd;
  final String defaultAsset;
  final String defaultDuration;
  final int defaultValidators;
  final List<StakingRiskScoreOptionDraft> assetOptions;
  final List<StakingRiskScoreOptionDraft> durationOptions;
  final List<StakingRiskScoreRecommendationDraft> recommendations;
  final String proceedLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingRiskScoreOptionDraft {
  const StakingRiskScoreOptionDraft({required this.value, required this.label});

  final String value;
  final String label;
}

final class StakingRiskScoreRecommendationDraft {
  const StakingRiskScoreRecommendationDraft({
    required this.trigger,
    required this.title,
    required this.body,
    required this.tone,
  });

  final String trigger;
  final String title;
  final String body;
  final String tone;
}

final class StakingEmergencyActionsSnapshot {
  const StakingEmergencyActionsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.warningTitle,
    required this.warningBody,
    required this.actions,
    required this.useCases,
    required this.statusCards,
    required this.pauseSheet,
    required this.withdrawSheet,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String warningTitle;
  final String warningBody;
  final List<StakingEmergencyActionDraft> actions;
  final List<StakingEmergencyUseCaseDraft> useCases;
  final List<StakingEmergencyStatusDraft> statusCards;
  final StakingEmergencySheetDraft pauseSheet;
  final StakingEmergencySheetDraft withdrawSheet;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingEmergencyActionDraft {
  const StakingEmergencyActionDraft({
    required this.id,
    required this.title,
    required this.body,
    required this.impact,
    required this.tone,
  });

  final String id;
  final String title;
  final String body;
  final String impact;
  final String tone;
}

final class StakingEmergencyUseCaseDraft {
  const StakingEmergencyUseCaseDraft({
    required this.title,
    required this.severity,
    required this.description,
  });

  final String title;
  final String severity;
  final String description;
}

final class StakingEmergencyStatusDraft {
  const StakingEmergencyStatusDraft({
    required this.title,
    required this.value,
    required this.body,
    required this.tone,
  });

  final String title;
  final String value;
  final String body;
  final String tone;
}

final class StakingEmergencySheetDraft {
  const StakingEmergencySheetDraft({
    required this.title,
    required this.body,
    required this.bullets,
    required this.confirmLabel,
    required this.tone,
  });

  final String title;
  final String body;
  final List<String> bullets;
  final String confirmLabel;
  final String tone;
}

final class StakingContingencyPlanSnapshot {
  const StakingContingencyPlanSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.metrics,
    required this.scenarios,
    required this.validationItems,
    required this.validationBody,
    required this.documents,
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
  final List<StakingContingencyMetricDraft> metrics;
  final List<StakingContingencyScenarioDraft> scenarios;
  final List<StakingContingencyValidationDraft> validationItems;
  final String validationBody;
  final List<StakingContingencyDocumentDraft> documents;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingContingencyMetricDraft {
  const StakingContingencyMetricDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

final class StakingContingencyScenarioDraft {
  const StakingContingencyScenarioDraft({
    required this.scenario,
    required this.likelihood,
    required this.impact,
    required this.response,
    required this.preventative,
  });

  final String scenario;
  final String likelihood;
  final String impact;
  final List<String> response;
  final List<String> preventative;
}

final class StakingContingencyValidationDraft {
  const StakingContingencyValidationDraft({
    required this.title,
    required this.dateLabel,
    required this.tone,
  });

  final String title;
  final String dateLabel;
  final String tone;
}

final class StakingContingencyDocumentDraft {
  const StakingContingencyDocumentDraft({
    required this.name,
    required this.size,
    required this.updatedLabel,
  });

  final String name;
  final String size;
  final String updatedLabel;
}

final class StakingSocialFeedSnapshot {
  const StakingSocialFeedSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.composerPlaceholder,
    required this.tabs,
    required this.defaultTabId,
    required this.posts,
    required this.stats,
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
  final String composerPlaceholder;
  final List<StakingSocialFeedTabDraft> tabs;
  final String defaultTabId;
  final List<StakingSocialFeedPostDraft> posts;
  final List<StakingSocialFeedStatDraft> stats;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingSocialFeedTabDraft {
  const StakingSocialFeedTabDraft({
    required this.id,
    required this.label,
    required this.sectionTitle,
  });

  final String id;
  final String label;
  final String sectionTitle;
}

final class StakingSocialFeedPostDraft {
  const StakingSocialFeedPostDraft({
    required this.id,
    required this.author,
    required this.avatarLabel,
    this.badge,
    required this.timestamp,
    required this.content,
    required this.type,
    required this.likes,
    required this.comments,
    this.asset,
    this.apy,
  });

  final String id;
  final String author;
  final String avatarLabel;
  final String? badge;
  final String timestamp;
  final String content;
  final String type;
  final int likes;
  final int comments;
  final String? asset;
  final String? apy;
}

final class StakingSocialFeedStatDraft {
  const StakingSocialFeedStatDraft({
    required this.value,
    required this.label,
    required this.tone,
  });

  final String value;
  final String label;
  final String tone;
}

final class StakingCommunityGovernanceSnapshot {
  const StakingCommunityGovernanceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.proposalsRoute,
    required this.forumRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.statsTitle,
    required this.stats,
    required this.activeProposal,
    required this.recentDecisions,
    required this.governanceSteps,
    required this.votingPower,
    required this.footerNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String proposalsRoute;
  final String forumRoute;
  final String infoTitle;
  final String infoBody;
  final String statsTitle;
  final List<StakingGovernanceStatDraft> stats;
  final StakingGovernanceActiveProposalDraft activeProposal;
  final List<StakingGovernanceDecisionDraft> recentDecisions;
  final List<StakingGovernanceStepDraft> governanceSteps;
  final StakingGovernanceVotingPowerDraft votingPower;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingGovernanceStatDraft {
  const StakingGovernanceStatDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

final class StakingGovernanceActiveProposalDraft {
  const StakingGovernanceActiveProposalDraft({
    required this.title,
    required this.body,
    required this.badge,
  });

  final String title;
  final String body;
  final String badge;
}

final class StakingGovernanceDecisionDraft {
  const StakingGovernanceDecisionDraft({
    required this.proposal,
    required this.status,
    required this.votes,
    required this.dateLabel,
  });

  final String proposal;
  final String status;
  final String votes;
  final String dateLabel;
}

final class StakingGovernanceStepDraft {
  const StakingGovernanceStepDraft({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class StakingGovernanceVotingPowerDraft {
  const StakingGovernanceVotingPowerDraft({
    required this.title,
    required this.body,
    required this.value,
    required this.share,
  });

  final String title;
  final String body;
  final String value;
  final String share;
}

final class StakingProposalsSnapshot {
  const StakingProposalsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.createLabel,
    required this.proposals,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String createLabel;
  final List<StakingProposalDraft> proposals;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingProposalDraft {
  const StakingProposalDraft({
    required this.id,
    required this.title,
    required this.status,
    required this.yesVotes,
    required this.noVotes,
    required this.quorum,
    required this.endsIn,
    required this.category,
    required this.votingRoute,
  });

  final String id;
  final String title;
  final String status;
  final int yesVotes;
  final int noVotes;
  final int quorum;
  final String endsIn;
  final String category;
  final String votingRoute;

  int get totalVotes => yesVotes + noVotes;

  double get yesPercent => totalVotes == 0 ? 0 : yesVotes / totalVotes * 100;

  double get noPercent => 100 - yesPercent;
}

final class StakingVotingSnapshot {
  const StakingVotingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.category,
    required this.proposalTitle,
    required this.proposalBody,
    required this.proposedByLabel,
    required this.proposedBy,
    required this.resultsTitle,
    required this.results,
    required this.voteTitle,
    required this.options,
    required this.votingPowerPrefix,
    required this.votingPower,
    required this.votingPowerSuffix,
    required this.submitLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String category;
  final String proposalTitle;
  final String proposalBody;
  final String proposedByLabel;
  final String proposedBy;
  final String resultsTitle;
  final List<StakingVotingResultDraft> results;
  final String voteTitle;
  final List<StakingVotingOptionDraft> options;
  final String votingPowerPrefix;
  final String votingPower;
  final String votingPowerSuffix;
  final String submitLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingVotingResultDraft {
  const StakingVotingResultDraft({
    required this.id,
    required this.label,
    required this.percent,
    required this.votes,
    required this.tone,
  });

  final String id;
  final String label;
  final int percent;
  final int votes;
  final String tone;
}

final class StakingVotingOptionDraft {
  const StakingVotingOptionDraft({
    required this.id,
    required this.label,
    required this.tone,
  });

  final String id;
  final String label;
  final String tone;
}

final class StakingForumSnapshot {
  const StakingForumSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.categoriesTitle,
    required this.categories,
    required this.threadsTitle,
    required this.threads,
    required this.createLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String categoriesTitle;
  final List<StakingForumCategoryDraft> categories;
  final String threadsTitle;
  final List<StakingForumThreadDraft> threads;
  final String createLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingForumCategoryDraft {
  const StakingForumCategoryDraft({
    required this.name,
    required this.threads,
    required this.posts,
  });

  final String name;
  final int threads;
  final int posts;
}

final class StakingForumThreadDraft {
  const StakingForumThreadDraft({
    required this.title,
    required this.replies,
    required this.views,
    required this.pinned,
    required this.author,
  });

  final String title;
  final int replies;
  final int views;
  final bool pinned;
  final String author;
}

final class StakingWebhooksSnapshot {
  const StakingWebhooksSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.createLabel,
    required this.activeTitle,
    required this.webhooks,
    required this.eventsTitle,
    required this.availableEvents,
    required this.sheetTitle,
    required this.urlLabel,
    required this.urlPlaceholder,
    required this.eventsLabel,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String createLabel;
  final String activeTitle;
  final List<StakingWebhookDraft> webhooks;
  final String eventsTitle;
  final List<String> availableEvents;
  final String sheetTitle;
  final String urlLabel;
  final String urlPlaceholder;
  final String eventsLabel;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingWebhookDraft {
  const StakingWebhookDraft({
    required this.id,
    required this.url,
    required this.events,
    required this.active,
    required this.lastTriggered,
  });

  final String id;
  final String url;
  final List<String> events;
  final bool active;
  final String lastTriggered;
}

final class StakingDataExportSnapshot {
  const StakingDataExportSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.quickTitle,
    required this.quickExports,
    required this.customTitle,
    required this.dateRangeLabel,
    required this.startPlaceholder,
    required this.endPlaceholder,
    required this.formatLabel,
    required this.formatOptions,
    required this.defaultFormat,
    required this.exportLabel,
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
  final String quickTitle;
  final List<StakingQuickExportDraft> quickExports;
  final String customTitle;
  final String dateRangeLabel;
  final String startPlaceholder;
  final String endPlaceholder;
  final String formatLabel;
  final List<String> formatOptions;
  final String defaultFormat;
  final String exportLabel;
  final String footerNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingQuickExportDraft {
  const StakingQuickExportDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String name;
  final String description;
  final String iconKey;
}

final class StakingThirdPartyIntegrationsSnapshot {
  const StakingThirdPartyIntegrationsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.sectionTitle,
    required this.integrations,
    required this.apiTitle,
    required this.apiBody,
    required this.apiActionLabel,
    required this.apiDocsRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String sectionTitle;
  final List<StakingIntegrationDraft> integrations;
  final String apiTitle;
  final String apiBody;
  final String apiActionLabel;
  final String apiDocsRoute;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingIntegrationDraft {
  const StakingIntegrationDraft({
    required this.id,
    required this.name,
    required this.description,
    required this.connected,
    required this.iconKey,
  });

  final String id;
  final String name;
  final String description;
  final bool connected;
  final String iconKey;
}

final class StakingDeveloperConsoleSnapshot {
  const StakingDeveloperConsoleSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.heroTitle,
    required this.heroBody,
    required this.defaultTab,
    required this.tabs,
    required this.stats,
    required this.keysTitle,
    required this.apiKeys,
    required this.createKeyLabel,
    required this.logsTitle,
    required this.recentRequests,
    required this.docsTitle,
    required this.docs,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String heroTitle;
  final String heroBody;
  final String defaultTab;
  final List<StakingConsoleTabDraft> tabs;
  final List<StakingConsoleStatDraft> stats;
  final String keysTitle;
  final List<StakingApiKeyDraft> apiKeys;
  final String createKeyLabel;
  final String logsTitle;
  final List<StakingApiRequestDraft> recentRequests;
  final String docsTitle;
  final List<StakingConsoleDocDraft> docs;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingConsoleTabDraft {
  const StakingConsoleTabDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class StakingConsoleStatDraft {
  const StakingConsoleStatDraft({
    required this.id,
    required this.value,
    required this.label,
    required this.tone,
  });

  final String id;
  final String value;
  final String label;
  final String tone;
}

final class StakingApiKeyDraft {
  const StakingApiKeyDraft({
    required this.id,
    required this.name,
    required this.keyPreview,
    required this.created,
    required this.lastUsed,
    required this.requests,
  });

  final String id;
  final String name;
  final String keyPreview;
  final String created;
  final String lastUsed;
  final int requests;
}

final class StakingApiRequestDraft {
  const StakingApiRequestDraft({
    required this.endpoint,
    required this.status,
    required this.time,
    required this.timestamp,
  });

  final String endpoint;
  final int status;
  final String time;
  final String timestamp;
}

final class StakingConsoleDocDraft {
  const StakingConsoleDocDraft({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class StakingAdvancedOrdersSnapshot {
  const StakingAdvancedOrdersSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.activeOrders,
    required this.orderHistory,
    required this.statCards,
    required this.orderTypeOptions,
    required this.assetOptions,
    required this.currentPriceLabel,
    required this.availableLabel,
    required this.orderTypeWarnings,
    required this.howItWorks,
    required this.riskTitle,
    required this.riskBody,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingAdvancedOrderDraft> activeOrders;
  final List<StakingAdvancedOrderDraft> orderHistory;
  final List<StakingAdvancedOrderStatDraft> statCards;
  final List<StakingAdvancedOrderType> orderTypeOptions;
  final List<String> assetOptions;
  final String currentPriceLabel;
  final String availableLabel;
  final Map<StakingAdvancedOrderType, String> orderTypeWarnings;
  final List<StakingAdvancedOrderInfoDraft> howItWorks;
  final String riskTitle;
  final String riskBody;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingAdvancedOrderDraft {
  const StakingAdvancedOrderDraft({
    required this.id,
    required this.type,
    required this.asset,
    required this.trigger,
    required this.amount,
    required this.status,
    required this.created,
  });

  final String id;
  final StakingAdvancedOrderType type;
  final String asset;
  final double trigger;
  final double amount;
  final StakingAdvancedOrderStatus status;
  final String created;
}

final class StakingAdvancedOrderStatDraft {
  const StakingAdvancedOrderStatDraft({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final String tone;
}

final class StakingAdvancedOrderInfoDraft {
  const StakingAdvancedOrderInfoDraft({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class StakingMultiChainSnapshot {
  const StakingMultiChainSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.dashboardRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.totalValue,
    required this.totalGainLabel,
    required this.totalRewards24h,
    required this.avgApy,
    required this.activeChains,
    required this.positions,
    required this.quickActions,
    required this.benefits,
    required this.technicalNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String dashboardRoute;
  final String infoTitle;
  final String infoBody;
  final double totalValue;
  final String totalGainLabel;
  final double totalRewards24h;
  final double avgApy;
  final int activeChains;
  final List<StakingChainPositionDraft> positions;
  final List<StakingMultiChainInfoDraft> quickActions;
  final List<StakingMultiChainInfoDraft> benefits;
  final String technicalNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingChainPositionDraft {
  const StakingChainPositionDraft({
    required this.chainId,
    required this.chain,
    required this.asset,
    required this.staked,
    required this.value,
    required this.apy,
  });

  final StakingChainId chainId;
  final String chain;
  final String asset;
  final double staked;
  final double value;
  final double apy;
}

final class StakingMultiChainInfoDraft {
  const StakingMultiChainInfoDraft({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;
}

final class StakingInstitutionalSnapshot {
  const StakingInstitutionalSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.infoTitle,
    required this.infoBody,
    required this.stats,
    required this.pendingBatches,
    required this.executedBatches,
    required this.signers,
    required this.features,
    required this.complianceTitle,
    required this.complianceBody,
    required this.operationTypes,
    required this.csvFormatNote,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String infoTitle;
  final String infoBody;
  final List<StakingInstitutionalStatDraft> stats;
  final List<StakingInstitutionalBatchDraft> pendingBatches;
  final List<StakingInstitutionalBatchDraft> executedBatches;
  final List<StakingInstitutionalSignerDraft> signers;
  final List<StakingInstitutionalFeatureDraft> features;
  final String complianceTitle;
  final String complianceBody;
  final List<String> operationTypes;
  final String csvFormatNote;
  final String contractNotes;
  final Set<EarnScreenState> supportedStates;
}

final class StakingInstitutionalStatDraft {
  const StakingInstitutionalStatDraft({
    required this.label,
    required this.value,
    required this.tone,
    required this.icon,
  });

  final String label;
  final String value;
  final String tone;
  final String icon;
}

final class StakingInstitutionalBatchDraft {
  const StakingInstitutionalBatchDraft({
    required this.id,
    required this.type,
    required this.operations,
    required this.totalAmount,
    required this.status,
    required this.created,
    required this.approvals,
    required this.requiredApprovals,
  });

  final String id;
  final StakingInstitutionalBatchType type;
  final int operations;
  final double totalAmount;
  final StakingInstitutionalBatchStatus status;
  final String created;
  final int approvals;
  final int requiredApprovals;
}

final class StakingInstitutionalSignerDraft {
  const StakingInstitutionalSignerDraft({
    required this.name,
    required this.role,
    required this.address,
    required this.status,
  });

  final String name;
  final String role;
  final String address;
  final StakingInstitutionalSignerStatus status;
}

final class StakingInstitutionalFeatureDraft {
  const StakingInstitutionalFeatureDraft({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;
}

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
