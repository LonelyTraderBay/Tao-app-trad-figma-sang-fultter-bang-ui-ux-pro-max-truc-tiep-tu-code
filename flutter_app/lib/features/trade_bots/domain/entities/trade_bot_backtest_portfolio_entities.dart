part of 'trade_bots_entities.dart';

/// A single bucket (duration label + count) in a backtest trade-duration
/// histogram.
final class TradeBotDurationDistribution {
  const TradeBotDurationDistribution({
    required this.duration,
    required this.count,
  });

  final String duration;
  final int count;
}

/// Read-model for the Bot Backtesting screen (available strategies, pairs,
/// date ranges, and default form values).
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

/// A strategy option selectable in the backtest form.
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

/// A selectable historical date range for a backtest run.
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

/// Request to run a backtest for a strategy/pair/date range with an
/// initial capital amount.
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

/// Result of kicking off a backtest run (status, report id, progress).
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

/// Read-model for the Strategy Comparison screen (compared strategies,
/// equity curves, recommendations).
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

/// A strategy entry with its performance metrics shown on the comparison
/// screen.
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

/// Performance metrics (return, Sharpe, drawdown, win rate, etc.) for one
/// strategy in the comparison screen.
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

/// One date's equity value across the compared strategies (DCA, grid,
/// momentum, martingale).
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

/// A recommended strategy with the reasoning behind the suggestion.
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

/// Read-model for the Strategy Optimization screen (optimization targets,
/// tunable parameter ranges, wizard steps).
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

/// A selectable optimization objective (e.g. maximize Sharpe ratio).
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

/// A tunable strategy parameter's min/max/step/default range for
/// optimization.
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

/// Request to run a strategy-parameter optimization job.
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

/// Result of kicking off an optimization job (status, job id, ETA).
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

/// Read-model for the Bot Portfolio dashboard screen (summary,
/// allocations, equity curve, correlations, health checklist).
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

/// Aggregate portfolio-level metrics across all bots (equity, PnL, Sharpe,
/// diversification score, active bot count).
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

/// A single strategy's allocation weight and PnL within the bot portfolio.
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

/// One date's total portfolio equity value.
final class TradeBotPortfolioEquityPoint {
  const TradeBotPortfolioEquityPoint({
    required this.date,
    required this.equity,
  });

  final String date;
  final double equity;
}

/// One bot's correlation values against every other bot in the portfolio
/// (row of the correlation matrix).
final class TradeBotCorrelationRow {
  const TradeBotCorrelationRow({required this.bot, required this.values});

  final String bot;
  final Map<String, double> values;
}

/// Read-model for the Drawdown Analyzer screen (summary, underwater curve,
/// duration buckets, drawdown events, insights).
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

/// Aggregate drawdown metrics (max/avg drawdown %, days underwater,
/// frequency).
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

/// One date's underwater (below-peak) percentage on the drawdown curve.
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

/// A histogram bucket of drawdown-event durations.
final class TradeBotDrawdownDurationBucket {
  const TradeBotDrawdownDurationBucket({
    required this.range,
    required this.count,
  });

  final String range;
  final int count;
}

/// A single historical drawdown event (start, depth, duration, recovery).
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

/// A single textual insight derived from the drawdown analysis.
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

/// Read-model for the Equity Curve screen (summary, curve points, monthly
/// returns, performance stats, analysis notes).
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

/// Bot vs. buy-and-hold return summary shown atop the equity curve
/// screen.
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

/// One date's bot equity vs. buy-and-hold value (with optional rolling
/// Sharpe ratio).
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

/// One month's bot return vs. market return and derived alpha.
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

/// A single labelled performance stat with a display color.
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

/// Read-model for the Bot Strategy Guide screen (strategy explanations,
/// best practices, common mistakes).
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

/// A single strategy's educational explanation (how it works, pros/cons,
/// worked example).
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

/// A worked numeric example (setup, duration, result, profit) for a guide
/// strategy.
final class TradeBotGuideExample {
  const TradeBotGuideExample({
    required this.setup,
    required this.duration,
    required this.result,
    required this.profit,
  });

  final String setup;
  final String duration;
  final String result;
  final String profit;
}

/// A single best-practice tip shown on the strategy guide screen.
final class TradeBotGuidePractice {
  const TradeBotGuidePractice({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
}

/// A common mistake plus why it happens and how to fix it.
final class TradeBotGuideMistake {
  const TradeBotGuideMistake({
    required this.mistake,
    required this.why,
    required this.fix,
  });

  final String mistake;
  final String why;
  final String fix;
}

/// Read-model for the Bot FAQ screen (grouped question categories).
final class TradeBotFaqSnapshot {
  const TradeBotFaqSnapshot({
    required this.categories,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotFaqCategory> categories;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  int get totalFaqs =>
      categories.fold<int>(0, (sum, category) => sum + category.items.length);
}

/// A labelled group of FAQ items.
final class TradeBotFaqCategory {
  const TradeBotFaqCategory({
    required this.id,
    required this.label,
    required this.items,
  });

  final String id;
  final String label;
  final List<TradeBotFaqItem> items;
}

/// A single question/answer FAQ entry.
final class TradeBotFaqItem {
  const TradeBotFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// Read-model for the Tax Reporting screen (available tax years, summary,
/// report types, gain/loss breakdown).
final class TradeBotTaxReportingSnapshot {
  const TradeBotTaxReportingSnapshot({
    required this.taxYears,
    required this.defaultYear,
    required this.defaultCostBasisMethod,
    required this.summary,
    required this.reportTypes,
    required this.breakdown,
    required this.taxNotes,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<String> taxYears;
  final String defaultYear;
  final String defaultCostBasisMethod;
  final TradeBotTaxSummary summary;
  final List<TradeBotTaxReportType> reportTypes;
  final TradeBotTaxBreakdown breakdown;
  final List<String> taxNotes;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

/// Aggregate realized gain/loss tax summary for the selected tax year.
final class TradeBotTaxSummary {
  const TradeBotTaxSummary({
    required this.totalTrades,
    required this.realizedGains,
    required this.realizedLosses,
    required this.netGainLoss,
    required this.shortTermGains,
    required this.longTermGains,
    required this.totalFees,
  });

  final int totalTrades;
  final double realizedGains;
  final double realizedLosses;
  final double netGainLoss;
  final double shortTermGains;
  final double longTermGains;
  final double totalFees;
}

/// A selectable tax report type/format (e.g. IRS Form 8949, CSV).
final class TradeBotTaxReportType {
  const TradeBotTaxReportType({
    required this.id,
    required this.name,
    required this.description,
    required this.format,
    required this.recommended,
    required this.selectedByDefault,
  });

  final String id;
  final String name;
  final String description;
  final String format;
  final bool recommended;
  final bool selectedByDefault;
}

/// Short-term vs. long-term gain labels/descriptions shown on the tax
/// reporting screen.
final class TradeBotTaxBreakdown {
  const TradeBotTaxBreakdown({
    required this.shortTermLabel,
    required this.shortTermDescription,
    required this.longTermLabel,
    required this.longTermDescription,
  });

  final String shortTermLabel;
  final String shortTermDescription;
  final String longTermLabel;
  final String longTermDescription;
}

/// Request to export tax reports for a given year/report types/cost-basis
/// method.
final class TradeBotTaxReportExportRequest {
  const TradeBotTaxReportExportRequest({
    required this.year,
    required this.reportTypeIds,
    required this.costBasisMethod,
  });

  final String year;
  final List<String> reportTypeIds;
  final String costBasisMethod;
}

/// Result of exporting tax reports.
final class TradeBotTaxReportExportResult {
  const TradeBotTaxReportExportResult({
    required this.status,
    required this.year,
    required this.reportCount,
    required this.exportId,
  });

  final String status;
  final String year;
  final int reportCount;
  final String exportId;
}

/// Read-model for the API Documentation screen (REST endpoints,
/// WebSocket events, code examples, rate limits).
final class TradeBotApiDocumentationSnapshot {
  const TradeBotApiDocumentationSnapshot({
    required this.tabs,
    required this.defaultView,
    required this.defaultLanguage,
    required this.endpoints,
    required this.websocketUrl,
    required this.websocketEvents,
    required this.codeExamples,
    required this.rateLimits,
    required this.authenticationHeader,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotApiTab> tabs;
  final String defaultView;
  final String defaultLanguage;
  final List<TradeBotApiEndpoint> endpoints;
  final String websocketUrl;
  final List<TradeBotWebSocketEvent> websocketEvents;
  final List<TradeBotCodeExample> codeExamples;
  final List<TradeBotRateLimit> rateLimits;
  final String authenticationHeader;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

/// A selectable tab on the API Documentation screen.
final class TradeBotApiTab {
  const TradeBotApiTab({required this.id, required this.label});

  final String id;
  final String label;
}

/// A single documented REST API endpoint (method, path, params,
/// response shape).
final class TradeBotApiEndpoint {
  const TradeBotApiEndpoint({
    required this.method,
    required this.path,
    required this.description,
    required this.params,
    required this.response,
  });

  final String method;
  final String path;
  final String description;
  final List<TradeBotApiParameter> params;
  final String response;
}

/// A single documented request parameter for an API endpoint.
final class TradeBotApiParameter {
  const TradeBotApiParameter({
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

/// A single documented WebSocket event and its payload shape.
final class TradeBotWebSocketEvent {
  const TradeBotWebSocketEvent({
    required this.event,
    required this.description,
    required this.payload,
  });

  final String event;
  final String description;
  final String payload;
}

/// A language-specific code sample shown on the API Documentation screen.
final class TradeBotCodeExample {
  const TradeBotCodeExample({
    required this.language,
    required this.label,
    required this.title,
    required this.source,
  });

  final String language;
  final String label;
  final String title;
  final String source;
}

/// A single documented API rate-limit entry (label + value).
final class TradeBotRateLimit {
  const TradeBotRateLimit({required this.label, required this.value});

  final String label;
  final String value;
}
