part of 'trade_entities.dart';

final class TradeBotDurationDistribution {
  const TradeBotDurationDistribution({
    required this.duration,
    required this.count,
  });

  final String duration;
  final int count;
}

final class TradeBotBacktestingSnapshot {
  const TradeBotBacktestingSnapshot({
    required this.strategies,
    required this.pairs,
    required this.dateRanges,
    required this.defaultStrategyId,
    required this.defaultPair,
    required this.defaultDateRangeId,
    required this.defaultCapital,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotBacktestStrategy> strategies;
  final List<String> pairs;
  final List<TradeBotBacktestDateRange> dateRanges;
  final String defaultStrategyId;
  final String defaultPair;
  final String defaultDateRangeId;
  final double defaultCapital;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotBacktestStrategy {
  const TradeBotBacktestStrategy({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  final String id;
  final String name;
  final int colorHex;
}

final class TradeBotBacktestDateRange {
  const TradeBotBacktestDateRange({
    required this.id,
    required this.label,
    required this.periodLabel,
  });

  final String id;
  final String label;
  final String periodLabel;
}

final class TradeBotBacktestRequest {
  const TradeBotBacktestRequest({
    required this.strategyId,
    required this.pair,
    required this.dateRangeId,
    required this.initialCapital,
  });

  final String strategyId;
  final String pair;
  final String dateRangeId;
  final double initialCapital;
}

final class TradeBotBacktestResult {
  const TradeBotBacktestResult({
    required this.status,
    required this.reportId,
    required this.progress,
  });

  final String status;
  final String reportId;
  final int progress;
}

final class TradeBotStrategyCompareSnapshot {
  const TradeBotStrategyCompareSnapshot({
    required this.strategies,
    required this.equityPoints,
    required this.recommendations,
    required this.defaultSelectedIds,
    required this.analysisPeriod,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotCompareStrategy> strategies;
  final List<TradeBotCompareEquityPoint> equityPoints;
  final List<TradeBotRecommendation> recommendations;
  final List<String> defaultSelectedIds;
  final String analysisPeriod;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotCompareStrategy {
  const TradeBotCompareStrategy({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.metrics,
  });

  final String id;
  final String name;
  final int colorHex;
  final TradeBotCompareMetrics metrics;
}

final class TradeBotCompareMetrics {
  const TradeBotCompareMetrics({
    required this.totalReturn,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.winRate,
    required this.profitFactor,
    required this.totalTrades,
    required this.avgTradeDuration,
    required this.volatility,
  });

  final double totalReturn;
  final double sharpeRatio;
  final double maxDrawdown;
  final double winRate;
  final double profitFactor;
  final int totalTrades;
  final String avgTradeDuration;
  final double volatility;
}

final class TradeBotCompareEquityPoint {
  const TradeBotCompareEquityPoint({
    required this.date,
    required this.dca,
    required this.grid,
    required this.momentum,
    required this.martingale,
  });

  final String date;
  final double dca;
  final double grid;
  final double momentum;
  final double martingale;

  double valueFor(String strategyId) {
    return switch (strategyId) {
      'dca' => dca,
      'grid' => grid,
      'momentum' => momentum,
      'martingale' => martingale,
      _ => 0,
    };
  }
}

final class TradeBotRecommendation {
  const TradeBotRecommendation({
    required this.title,
    required this.strategyId,
    required this.strategy,
    required this.reason,
  });

  final String title;
  final String strategyId;
  final String strategy;
  final String reason;
}

final class TradeBotOptimizationSnapshot {
  const TradeBotOptimizationSnapshot({
    required this.targets,
    required this.parameterRanges,
    required this.steps,
    required this.defaultTargetId,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotOptimizationTarget> targets;
  final List<TradeBotOptimizationRange> parameterRanges;
  final List<String> steps;
  final String defaultTargetId;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotOptimizationTarget {
  const TradeBotOptimizationTarget({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeBotOptimizationRange {
  const TradeBotOptimizationRange({
    required this.id,
    required this.label,
    required this.min,
    required this.max,
    required this.step,
    required this.defaultValue,
    this.unit = '',
  });

  final String id;
  final String label;
  final double min;
  final double max;
  final double step;
  final double defaultValue;
  final String unit;
}

final class TradeBotOptimizationRequest {
  const TradeBotOptimizationRequest({
    required this.targetId,
    required this.gridCount,
    required this.gridRangePct,
  });

  final String targetId;
  final double gridCount;
  final double gridRangePct;
}

final class TradeBotOptimizationResult {
  const TradeBotOptimizationResult({
    required this.status,
    required this.jobId,
    required this.estimatedMinutes,
  });

  final String status;
  final String jobId;
  final int estimatedMinutes;
}

final class TradeBotPortfolioDashboardSnapshot {
  const TradeBotPortfolioDashboardSnapshot({
    required this.summary,
    required this.allocations,
    required this.equityPoints,
    required this.correlations,
    required this.healthItems,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotPortfolioSummary summary;
  final List<TradeBotPortfolioAllocation> allocations;
  final List<TradeBotPortfolioEquityPoint> equityPoints;
  final List<TradeBotCorrelationRow> correlations;
  final List<String> healthItems;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotPortfolioSummary {
  const TradeBotPortfolioSummary({
    required this.totalEquity,
    required this.totalInvestment,
    required this.totalPnl,
    required this.pnlPercent,
    required this.portfolioSharpe,
    required this.diversificationScore,
    required this.activeBots,
    required this.totalTrades,
  });

  final double totalEquity;
  final double totalInvestment;
  final double totalPnl;
  final double pnlPercent;
  final double portfolioSharpe;
  final int diversificationScore;
  final int activeBots;
  final int totalTrades;
}

final class TradeBotPortfolioAllocation {
  const TradeBotPortfolioAllocation({
    required this.strategy,
    required this.value,
    required this.pnl,
    required this.colorHex,
  });

  final String strategy;
  final double value;
  final double pnl;
  final int colorHex;
}

final class TradeBotPortfolioEquityPoint {
  const TradeBotPortfolioEquityPoint({
    required this.date,
    required this.equity,
  });

  final String date;
  final double equity;
}

final class TradeBotCorrelationRow {
  const TradeBotCorrelationRow({required this.bot, required this.values});

  final String bot;
  final Map<String, double> values;
}

final class TradeBotDrawdownAnalyzerSnapshot {
  const TradeBotDrawdownAnalyzerSnapshot({
    required this.summary,
    required this.underwaterPoints,
    required this.durationBuckets,
    required this.events,
    required this.insights,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotDrawdownSummary summary;
  final List<TradeBotUnderwaterPoint> underwaterPoints;
  final List<TradeBotDrawdownDurationBucket> durationBuckets;
  final List<TradeBotDrawdownEvent> events;
  final List<TradeBotDrawdownInsight> insights;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotDrawdownSummary {
  const TradeBotDrawdownSummary({
    required this.maxDrawdownPct,
    required this.avgDrawdownPct,
    required this.drawdownDays,
    required this.totalDays,
    required this.frequency,
  });

  final double maxDrawdownPct;
  final double avgDrawdownPct;
  final int drawdownDays;
  final int totalDays;
  final int frequency;
}

final class TradeBotUnderwaterPoint {
  const TradeBotUnderwaterPoint({
    required this.date,
    required this.monthLabel,
    required this.underwaterPct,
  });

  final String date;
  final String monthLabel;
  final double underwaterPct;
}

final class TradeBotDrawdownDurationBucket {
  const TradeBotDrawdownDurationBucket({
    required this.range,
    required this.count,
  });

  final String range;
  final int count;
}

final class TradeBotDrawdownEvent {
  const TradeBotDrawdownEvent({
    required this.id,
    required this.startLabel,
    required this.depthPct,
    required this.duration,
    required this.recovery,
    required this.severe,
  });

  final int id;
  final String startLabel;
  final double depthPct;
  final String duration;
  final String recovery;
  final bool severe;
}

final class TradeBotDrawdownInsight {
  const TradeBotDrawdownInsight({
    required this.symbol,
    required this.colorHex,
    required this.text,
  });

  final String symbol;
  final int colorHex;
  final String text;
}

final class TradeBotEquityCurveSnapshot {
  const TradeBotEquityCurveSnapshot({
    required this.summary,
    required this.equityPoints,
    required this.monthlyReturns,
    required this.performanceStats,
    required this.analysisItems,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotEquityCurveSummary summary;
  final List<TradeBotEquityCurvePoint> equityPoints;
  final List<TradeBotMonthlyReturn> monthlyReturns;
  final List<TradeBotPerformanceStat> performanceStats;
  final List<String> analysisItems;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotEquityCurveSummary {
  const TradeBotEquityCurveSummary({
    required this.botReturnPct,
    required this.buyHoldReturnPct,
    required this.alphaPct,
  });

  final double botReturnPct;
  final double buyHoldReturnPct;
  final double alphaPct;
}

final class TradeBotEquityCurvePoint {
  const TradeBotEquityCurvePoint({
    required this.date,
    required this.monthLabel,
    required this.equity,
    required this.buyHold,
    this.rollingSharpe,
  });

  final String date;
  final String monthLabel;
  final double equity;
  final double buyHold;
  final double? rollingSharpe;
}

final class TradeBotMonthlyReturn {
  const TradeBotMonthlyReturn({
    required this.month,
    required this.botReturn,
    required this.marketReturn,
    required this.alpha,
  });

  final String month;
  final double botReturn;
  final double marketReturn;
  final double alpha;
}

final class TradeBotPerformanceStat {
  const TradeBotPerformanceStat({
    required this.id,
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String id;
  final String label;
  final String value;
  final int colorHex;
}

final class TradeBotGuideSnapshot {
  const TradeBotGuideSnapshot({
    required this.strategies,
    required this.bestPractices,
    required this.mistakes,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotGuideStrategy> strategies;
  final List<TradeBotGuidePractice> bestPractices;
  final List<TradeBotGuideMistake> mistakes;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotGuideStrategy {
  const TradeBotGuideStrategy({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorHex,
    required this.difficulty,
    required this.description,
    required this.howItWorks,
    required this.pros,
    required this.cons,
    required this.bestFor,
    required this.example,
  });

  final String id;
  final String name;
  final String iconKey;
  final int colorHex;
  final String difficulty;
  final String description;
  final List<String> howItWorks;
  final List<String> pros;
  final List<String> cons;
  final String bestFor;
  final TradeBotGuideExample example;
}
