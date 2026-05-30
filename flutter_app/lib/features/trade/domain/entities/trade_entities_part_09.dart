part of 'trade_entities.dart';

final class TradeExecutionVenueAnalysisMetric {
  const TradeExecutionVenueAnalysisMetric({
    required this.venue,
    required this.volume,
    required this.value,
    required this.avgFee,
    required this.avgSpread,
    required this.marketImpact,
    required this.totalCost,
    required this.avgLatency,
    required this.avgFillTime,
    required this.fillRate,
    required this.liquidity,
    required this.reliability,
  });

  final String venue;
  final int volume;
  final double value;
  final double avgFee;
  final double avgSpread;
  final double marketImpact;
  final double totalCost;
  final int avgLatency;
  final double avgFillTime;
  final double fillRate;
  final int liquidity;
  final double reliability;
}

final class TradeExecutionVenueCostTrend {
  const TradeExecutionVenueCostTrend({
    required this.month,
    required this.binance,
    required this.coinbase,
    required this.kraken,
  });

  final String month;
  final double binance;
  final double coinbase;
  final double kraken;
}

final class TradeExecutionVenueAnalysisSummary {
  const TradeExecutionVenueAnalysisSummary({
    required this.totalVenues,
    required this.avgTotalCost,
    required this.avgFillTime,
  });

  final int totalVenues;
  final double avgTotalCost;
  final double avgFillTime;
}

final class TradeSlippageMonitoringSnapshot {
  const TradeSlippageMonitoringSnapshot({
    required this.events,
    required this.providers,
    required this.history,
    required this.summary,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeSlippageEvent> events;
  final List<TradeSlippageProviderStats> providers;
  final List<TradeSlippageHistoryPoint> history;
  final TradeSlippageSummary summary;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeSlippageEvent {
  const TradeSlippageEvent({
    required this.id,
    required this.time,
    required this.provider,
    required this.instrument,
    required this.side,
    required this.expectedPrice,
    required this.executedPrice,
    required this.slippageBps,
    required this.slippagePct,
    required this.volume,
    required this.value,
    required this.severity,
  });

  final String id;
  final String time;
  final String provider;
  final String instrument;
  final String side;
  final double expectedPrice;
  final double executedPrice;
  final double slippageBps;
  final double slippagePct;
  final double volume;
  final double value;
  final String severity;
}

final class TradeSlippageProviderStats {
  const TradeSlippageProviderStats({
    required this.provider,
    required this.avgSlippage,
    required this.maxSlippage,
    required this.eventCount,
    required this.warningCount,
    required this.criticalCount,
    required this.totalImpact,
  });

  final String provider;
  final double avgSlippage;
  final double maxSlippage;
  final int eventCount;
  final int warningCount;
  final int criticalCount;
  final double totalImpact;
}

final class TradeSlippageHistoryPoint {
  const TradeSlippageHistoryPoint({
    required this.date,
    required this.avg,
    required this.max,
  });

  final String date;
  final double avg;
  final double max;
}

final class TradeSlippageSummary {
  const TradeSlippageSummary({
    required this.total,
    required this.normal,
    required this.warning,
    required this.critical,
    required this.avgSlippage,
    required this.maxSlippage,
  });

  final int total;
  final int normal;
  final int warning;
  final int critical;
  final double avgSlippage;
  final double maxSlippage;
}

final class TradeClientCategorizationSnapshot {
  const TradeClientCategorizationSnapshot({
    required this.categories,
    required this.history,
    required this.currentCategoryId,
    required this.defaultTab,
    required this.supportedStates,
  });

  final List<TradeClientCategoryInfo> categories;
  final List<TradeClientCategoryHistory> history;
  final String currentCategoryId;
  final String defaultTab;
  final List<TradeScreenState> supportedStates;
}

final class TradeClientCategoryInfo {
  const TradeClientCategoryInfo({
    required this.id,
    required this.label,
    required this.description,
    required this.protections,
    required this.requirements,
  });

  final String id;
  final String label;
  final String description;
  final List<String> protections;
  final List<String> requirements;
}

final class TradeClientCategoryHistory {
  const TradeClientCategoryHistory({
    required this.date,
    required this.action,
    required this.toCategoryId,
    required this.reason,
    this.fromCategoryId,
  });

  final String date;
  final String action;
  final String? fromCategoryId;
  final String toCategoryId;
  final String reason;
}

final class TradeProductGovernanceSnapshot {
  const TradeProductGovernanceSnapshot({
    required this.products,
    required this.defaultTab,
    required this.nextReviewLabel,
    required this.supportedStates,
  });

  final List<TradeCopyProduct> products;
  final String defaultTab;
  final String nextReviewLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeCopyProduct {
  const TradeCopyProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.targetMarket,
    required this.negativeTarget,
    required this.riskLevel,
    required this.lastReview,
    required this.nextReview,
    required this.distributionChannels,
  });

  final String id;
  final String name;
  final String type;
  final String status;
  final List<String> targetMarket;
  final List<String> negativeTarget;
  final String riskLevel;
  final String lastReview;
  final String nextReview;
  final List<String> distributionChannels;
}

final class TradeTargetMarketDefinitionSnapshot {
  const TradeTargetMarketDefinitionSnapshot({
    required this.product,
    required this.dimensions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeCopyProduct product;
  final List<TradeTargetMarketDimension> dimensions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeTargetMarketDimension {
  const TradeTargetMarketDimension({
    required this.id,
    required this.category,
    required this.suitableFor,
    required this.notSuitableFor,
  });

  final String id;
  final String category;
  final List<String> suitableFor;
  final List<String> notSuitableFor;
}

final class TradeClientMoneyProtectionSnapshot {
  const TradeClientMoneyProtectionSnapshot({
    required this.balance,
    required this.trustAccount,
    required this.lastReconciled,
    required this.protections,
    required this.insolvencySummary,
    required this.insolvencyDetail,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double balance;
  final String trustAccount;
  final String lastReconciled;
  final List<TradeClientMoneyProtectionItem> protections;
  final String insolvencySummary;
  final String insolvencyDetail;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeClientMoneyProtectionItem {
  const TradeClientMoneyProtectionItem({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeCassReconciliationSnapshot {
  const TradeCassReconciliationSnapshot({
    required this.reconciledCount,
    required this.resolvedCount,
    required this.outstandingCount,
    required this.records,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int reconciledCount;
  final int resolvedCount;
  final int outstandingCount;
  final List<TradeCassReconciliationRecord> records;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeCassReconciliationRecord {
  const TradeCassReconciliationRecord({
    required this.id,
    required this.displayDate,
    required this.clientLedger,
    required this.bankBalance,
    required this.difference,
    required this.status,
    this.notes,
  });

  final String id;
  final String displayDate;
  final double clientLedger;
  final double bankBalance;
  final double difference;
  final TradeCassReconciliationStatus status;
  final String? notes;
}

enum TradeCassReconciliationStatus { matched, discrepancyResolved, discrepancy }

final class TradeInvestorCompensationSnapshot {
  const TradeInvestorCompensationSnapshot({
    required this.coverageLimit,
    required this.summary,
    required this.coveredMessage,
    required this.automaticProtection,
    required this.overviewDescription,
    required this.overviewItems,
    required this.coverageItems,
    required this.warning,
    required this.eligibleCustomers,
    required this.ineligibleCustomers,
    required this.claimSteps,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String coverageLimit;
  final String summary;
  final String coveredMessage;
  final String automaticProtection;
  final String overviewDescription;
  final List<TradeInvestorCompensationInfo> overviewItems;
  final List<TradeInvestorCompensationCoverage> coverageItems;
  final String warning;
  final List<String> eligibleCustomers;
  final List<String> ineligibleCustomers;
  final List<TradeInvestorCompensationClaimStep> claimSteps;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeInvestorCompensationInfo {
  const TradeInvestorCompensationInfo({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeInvestorCompensationCoverage {
  const TradeInvestorCompensationCoverage({
    required this.label,
    required this.amount,
    required this.caption,
    required this.emphasized,
  });

  final String label;
  final String amount;
  final String caption;
  final bool emphasized;
}

final class TradeInvestorCompensationClaimStep {
  const TradeInvestorCompensationClaimStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class TradeExAnteCostsSnapshot {
  const TradeExAnteCostsSnapshot({
    required this.investmentAmount,
    required this.holdingPeriodYears,
    required this.costs,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investmentAmount;
  final int holdingPeriodYears;
  final List<TradeExAnteCostItem> costs;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  double get oneOffCosts => totalForCategory(TradeExAnteCostCategory.oneOff);
  double get recurringCosts =>
      totalForCategory(TradeExAnteCostCategory.recurring);
  double get incidentalCosts =>
      totalForCategory(TradeExAnteCostCategory.incidental);
  double get totalFirstYear => oneOffCosts + recurringCosts + incidentalCosts;
  double get totalPercentage => (totalFirstYear / investmentAmount) * 100;
  double get reductionInYield => totalPercentage / holdingPeriodYears;

  double totalForCategory(TradeExAnteCostCategory category) {
    return costs
        .where((cost) => cost.category == category)
        .fold<double>(0, (sum, cost) => sum + cost.amountEur);
  }
}

final class TradeExAnteCostItem {
  const TradeExAnteCostItem({
    required this.category,
    required this.type,
    required this.description,
    required this.amountEur,
    required this.percentOfInvestment,
  });

  final TradeExAnteCostCategory category;
  final String type;
  final String description;
  final double amountEur;
  final double percentOfInvestment;
}

enum TradeExAnteCostCategory { oneOff, recurring, incidental }

final class TradeRiyCalculatorSnapshot {
  const TradeRiyCalculatorSnapshot({
    required this.investmentAmount,
    required this.expectedReturnPct,
    required this.totalCostsPct,
    required this.holdingPeriodYears,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investmentAmount;
  final double expectedReturnPct;
  final double totalCostsPct;
  final int holdingPeriodYears;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRiyProjection {
  const TradeRiyProjection({
    required this.year,
    required this.withoutCosts,
    required this.withCosts,
  });

  final int year;
  final double withoutCosts;
  final double withCosts;
}

final class TradeExPostCostsReportSnapshot {
  const TradeExPostCostsReportSnapshot({
    required this.reports,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeExPostCostReport> reports;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  TradeExPostCostReport reportForYear(int year) {
    return reports.firstWhere(
      (report) => report.year == year,
      orElse: () => reports.first,
    );
  }
}

final class TradeExPostCostReport {
  const TradeExPostCostReport({
    required this.year,
    required this.oneOff,
    required this.recurring,
    required this.incidental,
    required this.estimatedOneOff,
    required this.estimatedRecurring,
    required this.estimatedIncidental,
  });

  final int year;
  final double oneOff;
  final double recurring;
  final double incidental;
  final double estimatedOneOff;
  final double estimatedRecurring;
  final double estimatedIncidental;

  double get totalActual => oneOff + recurring + incidental;
  double get totalEstimated =>
      estimatedOneOff + estimatedRecurring + estimatedIncidental;
  double get variance => totalActual - totalEstimated;
}
