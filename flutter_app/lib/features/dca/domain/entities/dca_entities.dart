enum DcaFrequency { daily, weekly, monthly }

enum DcaPlanStatus { active, paused, error }

enum DcaScreenState { loading, empty, error, offline, submitting, success }

enum DcaRebalanceStrategy { threshold, periodic, hybrid }

enum DcaRebalanceFrequency { weekly, biweekly, monthly, quarterly }

enum DcaScheduleStrategy { fixed, volatility, gasOptimized, volume, hybrid }

enum DcaScheduleTimePreference { morning, afternoon, evening, night, any }

enum DcaScheduleOptionIcon { clock, trend, bolt, chart }

enum DcaPortfolioAssetAccent { btc, eth, usdt, sol, bnb }

enum DcaPortfolioSuggestionType { increase, decrease, add, remove }

enum DcaDynamicStrategy { fixed, volatility, performance, balance, target }

enum DcaDynamicAdjustmentAction {
  normal,
  increased,
  decreased,
  skipped,
  paused,
}

enum DcaDynamicConfigAccent {
  neutral,
  primary,
  success,
  warning,
  danger,
  accent,
}

enum DcaBacktestFrequency { weekly, biweekly, monthly, daily }

enum DcaBacktestStrategy { fixed, valueAverage, buyDips }

enum DcaMultiAssetFrequency { weekly, monthly }

enum DcaPerformanceWinner { dca, lumpSum }

enum DcaSmartRuleType { entry, exit, adjust }

enum DcaSmartRuleStatus { active, paused, triggered }

enum DcaSmartRuleResult { executed, failed, pending }

class DcaOverviewDemoSnapshot {
  const DcaOverviewDemoSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.componentName,
    required this.componentLocation,
    required this.contractNotes,
    required this.scenarios,
    required this.mobilePreview,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String backRoute;
  final String componentName;
  final String componentLocation;
  final String contractNotes;
  final List<DcaOverviewDemoScenario> scenarios;
  final DcaOverviewDemoScenario mobilePreview;
}

class DcaOverviewDemoScenario {
  const DcaOverviewDemoScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.data,
    required this.sparkline,
    required this.showActions,
  });

  final String id;
  final String title;
  final String description;
  final DcaOverviewDemoData data;
  final List<double> sparkline;
  final bool showActions;
}

class DcaOverviewDemoData {
  const DcaOverviewDemoData({
    required this.currentValueVnd,
    required this.totalInvestedVnd,
    required this.profitLossVnd,
    required this.profitLossPercent,
    required this.activePlans,
    required this.pausedPlans,
    required this.errorPlans,
    required this.nextRelativeTime,
    required this.nextAmountVnd,
  });

  final int currentValueVnd;
  final int totalInvestedVnd;
  final int profitLossVnd;
  final double profitLossPercent;
  final int activePlans;
  final int pausedPlans;
  final int errorPlans;
  final String? nextRelativeTime;
  final int? nextAmountVnd;

  int get totalPlans => activePlans + pausedPlans + errorPlans;

  int get averagePerPlanVnd {
    if (totalPlans == 0) return 0;
    return (totalInvestedVnd / totalPlans).round();
  }

  bool get isProfit => profitLossVnd >= 0;
}

class DcaDashboardSnapshot {
  const DcaDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.overview,
    required this.sparkline,
    required this.tools,
    required this.plans,
    required this.history,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final DcaOverview overview;
  final List<double> sparkline;
  final List<DcaTool> tools;
  final List<DcaPlan> plans;
  final List<DcaHistoryPoint> history;
}

class DcaOverview {
  const DcaOverview({
    required this.currentValueVnd,
    required this.totalInvestedVnd,
    required this.profitLossVnd,
    required this.profitLossPercent,
    required this.activePlans,
    required this.pausedPlans,
    required this.errorPlans,
    required this.nextRelativeTime,
    required this.nextAmountVnd,
  });

  final int currentValueVnd;
  final int totalInvestedVnd;
  final int profitLossVnd;
  final double profitLossPercent;
  final int activePlans;
  final int pausedPlans;
  final int errorPlans;
  final String nextRelativeTime;
  final int nextAmountVnd;

  int get totalPlans => activePlans + pausedPlans + errorPlans;

  int get averagePerPlanVnd {
    if (totalPlans == 0) return 0;
    return (totalInvestedVnd / totalPlans).round();
  }
}

enum DcaToolIcon { target, activity, sliders, clock }

enum DcaToolAccent { purple, primary, success, warning }

class DcaTool {
  const DcaTool({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String route;
  final DcaToolIcon icon;
  final DcaToolAccent accent;
}

class DcaPlan {
  const DcaPlan({
    required this.id,
    required this.coinSymbol,
    required this.coinName,
    required this.frequency,
    required this.amountPerPurchaseVnd,
    required this.nextExecutionLabel,
    required this.status,
    required this.totalInvestedVnd,
    required this.currentHoldings,
    required this.profitLossPercent,
  });

  final String id;
  final String coinSymbol;
  final String coinName;
  final DcaFrequency frequency;
  final int amountPerPurchaseVnd;
  final String nextExecutionLabel;
  final DcaPlanStatus status;
  final int totalInvestedVnd;
  final double currentHoldings;
  final double profitLossPercent;
}

class DcaHistoryPoint {
  const DcaHistoryPoint({
    required this.day,
    required this.portfolioValueM,
    required this.investedM,
  });

  final String day;
  final double portfolioValueM;
  final double investedM;
}

class DcaRebalanceConfigSnapshot {
  const DcaRebalanceConfigSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalPortfolioUsd,
    required this.driftThreshold,
    required this.minTradeAmountUsd,
    required this.strategy,
    required this.frequency,
    required this.targets,
    required this.strategyOptions,
    required this.frequencyOptions,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int totalPortfolioUsd;
  final double driftThreshold;
  final int minTradeAmountUsd;
  final DcaRebalanceStrategy strategy;
  final DcaRebalanceFrequency frequency;
  final List<DcaRebalanceTarget> targets;
  final List<DcaRebalanceStrategyOption> strategyOptions;
  final List<DcaRebalanceFrequencyOption> frequencyOptions;
}

enum DcaRebalanceAccent { primary, accent, success, warning }

class DcaRebalanceTarget {
  const DcaRebalanceTarget({
    required this.id,
    required this.symbol,
    required this.assetName,
    required this.currentPercent,
    required this.targetPercent,
    required this.tolerance,
    required this.currentValueUsd,
    required this.unitPriceUsd,
    required this.accent,
  });

  final String id;
  final String symbol;
  final String assetName;
  final double currentPercent;
  final double targetPercent;
  final double tolerance;
  final int currentValueUsd;
  final int unitPriceUsd;
  final DcaRebalanceAccent accent;

  DcaRebalanceTarget copyWith({double? targetPercent, double? tolerance}) {
    return DcaRebalanceTarget(
      id: id,
      symbol: symbol,
      assetName: assetName,
      currentPercent: currentPercent,
      targetPercent: targetPercent ?? this.targetPercent,
      tolerance: tolerance ?? this.tolerance,
      currentValueUsd: currentValueUsd,
      unitPriceUsd: unitPriceUsd,
      accent: accent,
    );
  }
}

enum DcaRebalanceOptionIcon { zap, clock, combine }

class DcaRebalanceStrategyOption {
  const DcaRebalanceStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final DcaRebalanceStrategy strategy;
  final String title;
  final String subtitle;
  final DcaRebalanceOptionIcon icon;
}

class DcaRebalanceFrequencyOption {
  const DcaRebalanceFrequencyOption({
    required this.frequency,
    required this.title,
    required this.subtitle,
  });

  final DcaRebalanceFrequency frequency;
  final String title;
  final String subtitle;
}

class DcaRebalanceDashboardSnapshot {
  const DcaRebalanceDashboardSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.configId,
    required this.configFound,
    required this.message,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final String configId;
  final bool configFound;
  final String message;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaScheduleConfigSnapshot {
  const DcaScheduleConfigSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.strategy,
    required this.timePreference,
    required this.maxDelayHours,
    required this.maxAdvanceHours,
    required this.volatilityThreshold,
    required this.gasPriceThreshold,
    required this.enabled,
    required this.strategies,
    required this.timePreferences,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final DcaScheduleStrategy strategy;
  final DcaScheduleTimePreference timePreference;
  final int maxDelayHours;
  final int maxAdvanceHours;
  final double volatilityThreshold;
  final int gasPriceThreshold;
  final bool enabled;
  final List<DcaScheduleStrategyOption> strategies;
  final List<DcaScheduleTimePreferenceOption> timePreferences;
}

class DcaScheduleAnalyticsSnapshot {
  const DcaScheduleAnalyticsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.configId,
    required this.configFound,
    required this.message,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final String configId;
  final bool configFound;
  final String message;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaScheduleStrategyOption {
  const DcaScheduleStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  final DcaScheduleStrategy strategy;
  final String title;
  final String subtitle;
  final DcaScheduleOptionIcon icon;
  final DcaRebalanceAccent accent;
}

class DcaScheduleTimePreferenceOption {
  const DcaScheduleTimePreferenceOption({
    required this.preference,
    required this.title,
    required this.subtitle,
  });

  final DcaScheduleTimePreference preference;
  final String title;
  final String subtitle;
}

class DcaPortfolioOptimizerSnapshot {
  const DcaPortfolioOptimizerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.score,
    required this.driftPercent,
    required this.driftThresholdPercent,
    required this.optimalSharpe,
    required this.optimalReturnPercent,
    required this.optimalRiskPercent,
    required this.currentAllocations,
    required this.frontier,
    required this.suggestions,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int score;
  final double driftPercent;
  final double driftThresholdPercent;
  final double optimalSharpe;
  final double optimalReturnPercent;
  final double optimalRiskPercent;
  final List<DcaPortfolioAllocation> currentAllocations;
  final List<DcaFrontierPoint> frontier;
  final List<DcaPortfolioSuggestion> suggestions;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaPortfolioAllocation {
  const DcaPortfolioAllocation({
    required this.symbol,
    required this.name,
    required this.currentPercent,
    required this.optimalPercent,
    required this.accent,
  });

  final String symbol;
  final String name;
  final double currentPercent;
  final double optimalPercent;
  final DcaPortfolioAssetAccent accent;

  double get diffPercent => optimalPercent - currentPercent;
}

class DcaFrontierPoint {
  const DcaFrontierPoint({
    required this.label,
    required this.riskPercent,
    required this.returnPercent,
    required this.sharpe,
  });

  final String label;
  final double riskPercent;
  final double returnPercent;
  final double sharpe;
}

class DcaPortfolioSuggestion {
  const DcaPortfolioSuggestion({
    required this.type,
    required this.symbol,
    required this.currentPercent,
    required this.suggestedPercent,
    required this.reason,
  });

  final DcaPortfolioSuggestionType type;
  final String symbol;
  final double currentPercent;
  final double suggestedPercent;
  final String reason;
}

class DcaDynamicAmountSnapshot {
  const DcaDynamicAmountSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.activeStrategy,
    required this.adjustment,
    required this.strategies,
    required this.volatilityHistory,
    required this.amountHistory,
    required this.configItems,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final DcaDynamicStrategy activeStrategy;
  final DcaDynamicAdjustment adjustment;
  final List<DcaDynamicStrategyOption> strategies;
  final List<DcaVolatilitySnapshot> volatilityHistory;
  final List<DcaAmountHistoryEntry> amountHistory;
  final List<DcaDynamicConfigItem> configItems;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaDynamicAdjustment {
  const DcaDynamicAdjustment({
    required this.originalAmountVnd,
    required this.adjustedAmountVnd,
    required this.multiplier,
    required this.reason,
    required this.action,
  });

  final int originalAmountVnd;
  final int adjustedAmountVnd;
  final double multiplier;
  final String reason;
  final DcaDynamicAdjustmentAction action;
}

class DcaDynamicStrategyOption {
  const DcaDynamicStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final DcaDynamicStrategy strategy;
  final String title;
  final String subtitle;
  final String description;
  final DcaScheduleOptionIcon icon;
  final DcaDynamicConfigAccent accent;
}

class DcaVolatilitySnapshot {
  const DcaVolatilitySnapshot({
    required this.date,
    required this.volatilityPercent,
    required this.multiplier,
    required this.amountVnd,
  });

  final String date;
  final double volatilityPercent;
  final double multiplier;
  final int amountVnd;
}

class DcaAmountHistoryEntry {
  const DcaAmountHistoryEntry({
    required this.date,
    required this.baseAmountVnd,
    required this.adjustedAmountVnd,
    required this.strategy,
    required this.reason,
  });

  final String date;
  final int baseAmountVnd;
  final int adjustedAmountVnd;
  final DcaDynamicStrategy strategy;
  final String reason;

  double get changePercent {
    if (baseAmountVnd == 0) return 0;
    return ((adjustedAmountVnd - baseAmountVnd) / baseAmountVnd) * 100;
  }
}

class DcaDynamicConfigItem {
  const DcaDynamicConfigItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final DcaScheduleOptionIcon icon;
  final DcaDynamicConfigAccent accent;
}

class DcaBacktesterSnapshot {
  const DcaBacktesterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.assets,
    required this.startDate,
    required this.endDate,
    required this.investmentAmountUsd,
    required this.activeFrequency,
    required this.activeStrategy,
    required this.frequencies,
    required this.strategies,
    required this.result,
    required this.historicalData,
    required this.drawdowns,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final List<String> assets;
  final String startDate;
  final String endDate;
  final int investmentAmountUsd;
  final DcaBacktestFrequency activeFrequency;
  final DcaBacktestStrategy activeStrategy;
  final List<DcaBacktestFrequencyOption> frequencies;
  final List<DcaBacktestStrategyOption> strategies;
  final DcaBacktestResult result;
  final List<DcaBacktestPoint> historicalData;
  final List<DcaDrawdownPoint> drawdowns;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;
}

class DcaBacktestFrequencyOption {
  const DcaBacktestFrequencyOption({
    required this.frequency,
    required this.label,
  });

  final DcaBacktestFrequency frequency;
  final String label;
}

class DcaBacktestStrategyOption {
  const DcaBacktestStrategyOption({
    required this.strategy,
    required this.title,
    required this.subtitle,
  });

  final DcaBacktestStrategy strategy;
  final String title;
  final String subtitle;
}

class DcaBacktestResult {
  const DcaBacktestResult({
    required this.totalInvestedUsd,
    required this.finalValueUsd,
    required this.totalReturnUsd,
    required this.returnPercent,
    required this.avgBuyPriceUsd,
    required this.totalShares,
    required this.maxDrawdownPercent,
    required this.sharpeRatio,
    required this.volatilityPercent,
    required this.winRatePercent,
    required this.numberOfBuys,
  });

  final int totalInvestedUsd;
  final int finalValueUsd;
  final int totalReturnUsd;
  final double returnPercent;
  final int avgBuyPriceUsd;
  final double totalShares;
  final double maxDrawdownPercent;
  final double sharpeRatio;
  final double volatilityPercent;
  final double winRatePercent;
  final int numberOfBuys;
}

class DcaBacktestPoint {
  const DcaBacktestPoint({
    required this.date,
    required this.priceUsd,
    required this.dcaValueUsd,
    required this.lumpValueUsd,
  });

  final String date;
  final int priceUsd;
  final int dcaValueUsd;
  final int lumpValueUsd;
}

class DcaDrawdownPoint {
  const DcaDrawdownPoint({required this.date, required this.drawdownPercent});

  final String date;
  final double drawdownPercent;
}

class DcaMultiAssetSnapshot {
  const DcaMultiAssetSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.totalBudgetUsd,
    required this.activeFrequency,
    required this.rebalanceEnabled,
    required this.rebalanceThresholdPercent,
    required this.allocations,
    required this.performance,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int totalBudgetUsd;
  final DcaMultiAssetFrequency activeFrequency;
  final bool rebalanceEnabled;
  final double rebalanceThresholdPercent;
  final List<DcaMultiAssetAllocation> allocations;
  final List<DcaMultiAssetPerformancePoint> performance;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  int get totalInvestedUsd {
    return allocations.fold(0, (sum, asset) => sum + asset.totalInvestedUsd);
  }

  int get currentValueUsd {
    return allocations.fold(0, (sum, asset) => sum + asset.currentValueUsd);
  }

  int get totalReturnUsd => currentValueUsd - totalInvestedUsd;

  double get totalReturnPercent {
    if (totalInvestedUsd == 0) return 0;
    return totalReturnUsd / totalInvestedUsd * 100;
  }

  bool get needsRebalance {
    return allocations.any(
      (asset) =>
          (asset.currentPercent - asset.targetPercent).abs() >
          rebalanceThresholdPercent,
    );
  }
}

class DcaMultiAssetAllocation {
  const DcaMultiAssetAllocation({
    required this.id,
    required this.symbol,
    required this.assetName,
    required this.targetPercent,
    required this.currentPercent,
    required this.amountPerPeriodUsd,
    required this.totalInvestedUsd,
    required this.currentValueUsd,
    required this.shares,
    required this.averagePriceUsd,
  });

  final String id;
  final String symbol;
  final String assetName;
  final double targetPercent;
  final double currentPercent;
  final int amountPerPeriodUsd;
  final int totalInvestedUsd;
  final int currentValueUsd;
  final double shares;
  final int averagePriceUsd;

  int get returnUsd => currentValueUsd - totalInvestedUsd;

  double get returnPercent {
    if (totalInvestedUsd == 0) return 0;
    return returnUsd / totalInvestedUsd * 100;
  }
}

class DcaMultiAssetPerformancePoint {
  const DcaMultiAssetPerformancePoint({
    required this.month,
    required this.btcUsd,
    required this.ethUsd,
    required this.bnbUsd,
    required this.solUsd,
  });

  final String month;
  final int btcUsd;
  final int ethUsd;
  final int bnbUsd;
  final int solUsd;

  int get totalUsd => btcUsd + ethUsd + bnbUsd + solUsd;
}

class DcaPerformanceCompareSnapshot {
  const DcaPerformanceCompareSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.investedUsd,
    required this.comparison,
    required this.metrics,
    required this.scenarios,
    required this.radar,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int investedUsd;
  final List<DcaPerformancePoint> comparison;
  final List<DcaComparisonMetric> metrics;
  final List<DcaVolatilityScenario> scenarios;
  final List<DcaRadarMetric> radar;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  DcaPerformancePoint get finalPoint => comparison.last;

  int get dcaFinalValueUsd => finalPoint.dcaValueUsd;

  int get lumpSumFinalValueUsd => finalPoint.lumpSumValueUsd;

  double get dcaReturnPercent {
    if (investedUsd == 0) return 0;
    return (dcaFinalValueUsd - investedUsd) / investedUsd * 100;
  }

  double get lumpSumReturnPercent {
    if (investedUsd == 0) return 0;
    return (lumpSumFinalValueUsd - investedUsd) / investedUsd * 100;
  }

  double get advantagePercent => dcaReturnPercent - lumpSumReturnPercent;

  DcaPerformanceWinner get winner {
    return advantagePercent >= 0
        ? DcaPerformanceWinner.dca
        : DcaPerformanceWinner.lumpSum;
  }
}

class DcaPerformancePoint {
  const DcaPerformancePoint({
    required this.month,
    required this.dcaValueUsd,
    required this.lumpSumValueUsd,
    required this.priceUsd,
  });

  final String month;
  final int dcaValueUsd;
  final int lumpSumValueUsd;
  final int priceUsd;
}

class DcaComparisonMetric {
  const DcaComparisonMetric({
    required this.label,
    required this.dcaValue,
    required this.lumpSumValue,
    required this.winner,
  });

  final String label;
  final String dcaValue;
  final String lumpSumValue;
  final DcaPerformanceWinner winner;
}

class DcaVolatilityScenario {
  const DcaVolatilityScenario({
    required this.name,
    required this.scenario,
    required this.description,
    required this.dcaAdvantage,
    required this.lumpSumAdvantage,
  });

  final String name;
  final String scenario;
  final String description;
  final int dcaAdvantage;
  final int lumpSumAdvantage;
}

class DcaRadarMetric {
  const DcaRadarMetric({
    required this.metric,
    required this.dcaScore,
    required this.lumpSumScore,
  });

  final String metric;
  final int dcaScore;
  final int lumpSumScore;
}

class DcaSmartRulesSnapshot {
  const DcaSmartRulesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.successPercent,
    required this.smartRules,
    required this.templates,
    required this.history,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int successPercent;
  final List<DcaSmartRule> smartRules;
  final List<DcaRuleTemplate> templates;
  final List<DcaRuleHistoryEntry> history;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  int get activeRules {
    return smartRules
        .where((rule) => rule.status == DcaSmartRuleStatus.active)
        .length;
  }

  int get totalTriggers {
    return smartRules.fold(0, (sum, rule) => sum + rule.triggeredCount);
  }
}

class DcaSmartRule {
  const DcaSmartRule({
    required this.id,
    required this.name,
    required this.type,
    required this.condition,
    required this.action,
    required this.status,
    required this.triggeredCount,
    this.lastTriggeredLabel,
  });

  final String id;
  final String name;
  final DcaSmartRuleType type;
  final String condition;
  final String action;
  final DcaSmartRuleStatus status;
  final int triggeredCount;
  final String? lastTriggeredLabel;
}

class DcaRuleTemplate {
  const DcaRuleTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
    required this.action,
    required this.popularityPercent,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final String condition;
  final String action;
  final int popularityPercent;
}

class DcaRuleHistoryEntry {
  const DcaRuleHistoryEntry({
    required this.id,
    required this.ruleName,
    required this.triggeredAtLabel,
    required this.condition,
    required this.action,
    required this.result,
  });

  final String id;
  final String ruleName;
  final String triggeredAtLabel;
  final String condition;
  final String action;
  final DcaSmartRuleResult result;
}

class DcaRebalanceTradePreview {
  const DcaRebalanceTradePreview({
    required this.symbol,
    required this.action,
    required this.currentPercent,
    required this.targetPercent,
    required this.tradeAmountUsd,
    required this.tradeQuantity,
  });

  final String symbol;
  final DcaRebalanceTradeAction action;
  final double currentPercent;
  final double targetPercent;
  final double tradeAmountUsd;
  final double tradeQuantity;
}

enum DcaRebalanceTradeAction { buy, sell, hold }
