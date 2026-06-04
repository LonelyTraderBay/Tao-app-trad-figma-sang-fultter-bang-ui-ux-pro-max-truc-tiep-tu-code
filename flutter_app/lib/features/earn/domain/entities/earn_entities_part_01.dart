part of 'earn_entities.dart';

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
