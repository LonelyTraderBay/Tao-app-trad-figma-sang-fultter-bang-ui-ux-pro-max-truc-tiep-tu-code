part of 'trade_compliance_entities.dart';

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

final class TradeExPostCostsReportExportResult {
  const TradeExPostCostsReportExportResult({
    required this.status,
    required this.year,
    required this.downloadUrl,
  });

  final String status;
  final int year;
  final String downloadUrl;
}

final class TradeKidGeneratorSnapshot {
  const TradeKidGeneratorSnapshot({
    required this.document,
    required this.sections,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeKidDocument document;
  final List<TradeKidSection> sections;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeKidDocument {
  const TradeKidDocument({
    required this.title,
    required this.lastUpdated,
    required this.version,
    required this.documentType,
    required this.pages,
    required this.maxPages,
  });

  final String title;
  final String lastUpdated;
  final String version;
  final String documentType;
  final int pages;
  final int maxPages;
}

final class TradeKidSection {
  const TradeKidSection({
    required this.title,
    required this.icon,
    required this.status,
  });

  final String title;
  final TradeKidSectionIcon icon;
  final String status;
}

enum TradeKidSectionIcon { info, target, warning, chart, costs, clock, help }

final class TradePerformanceScenariosSnapshot {
  const TradePerformanceScenariosSnapshot({
    required this.investment,
    required this.holdingPeriods,
    required this.defaultHoldingPeriod,
    required this.scenarios,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investment;
  final List<int> holdingPeriods;
  final int defaultHoldingPeriod;
  final List<TradePerformanceScenario> scenarios;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradePerformanceScenario {
  const TradePerformanceScenario({
    required this.type,
    required this.label,
    required this.annualReturnPct,
  });

  final TradePerformanceScenarioType type;
  final String label;
  final double annualReturnPct;

  double outcomeFor(double investment, int years) {
    return investment * math.pow(1 + annualReturnPct / 100, years).toDouble();
  }

  double profitFor(double investment, int years) {
    return outcomeFor(investment, years) - investment;
  }
}

enum TradePerformanceScenarioType { stress, unfavorable, moderate, favorable }

final class TradeRiskIndicatorSnapshot {
  const TradeRiskIndicatorSnapshot({
    required this.productName,
    required this.productSri,
    required this.holdingPeriodYears,
    required this.levels,
    required this.additionalRisks,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String productName;
  final int productSri;
  final int holdingPeriodYears;
  final List<TradeRiskIndicatorLevel> levels;
  final List<TradeRiskIndicatorAdditionalRisk> additionalRisks;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRiskIndicatorLevel {
  const TradeRiskIndicatorLevel({
    required this.level,
    required this.label,
    required this.tier,
    required this.description,
    required this.examples,
  });

  final int level;
  final String label;
  final TradeRiskIndicatorTier tier;
  final String description;
  final List<String> examples;
}

final class TradeRiskIndicatorAdditionalRisk {
  const TradeRiskIndicatorAdditionalRisk({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

enum TradeRiskIndicatorTier { low, medium, elevated, high }
