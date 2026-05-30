part of '../repositories/mock_trade_repository.dart';

const List<TradeBotBacktestDateRange> _botBacktestDateRanges = [
  TradeBotBacktestDateRange(
    id: '1m',
    label: '1 Month',
    periodLabel: 'Feb 8 - Mar 8, 2026',
  ),
  TradeBotBacktestDateRange(
    id: '3m',
    label: '3 Months',
    periodLabel: 'Dec 8, 2025 - Mar 8, 2026',
  ),
  TradeBotBacktestDateRange(
    id: '6m',
    label: '6 Months',
    periodLabel: 'Sep 8, 2025 - Mar 8, 2026',
  ),
  TradeBotBacktestDateRange(
    id: '1y',
    label: '1 Year',
    periodLabel: 'Mar 8, 2025 - Mar 8, 2026',
  ),
];

const List<TradeBotCompareStrategy> _botCompareStrategies = [
  TradeBotCompareStrategy(
    id: 'dca',
    name: 'DCA Bot',
    colorHex: 0xFF3B82F6,
    metrics: TradeBotCompareMetrics(
      totalReturn: 42.3,
      sharpeRatio: 1.52,
      maxDrawdown: -8.4,
      winRate: 65.2,
      profitFactor: 1.87,
      totalTrades: 89,
      avgTradeDuration: '24h',
      volatility: 12.4,
    ),
  ),
  TradeBotCompareStrategy(
    id: 'grid',
    name: 'Grid Bot',
    colorHex: 0xFFF59E0B,
    metrics: TradeBotCompareMetrics(
      totalReturn: 68.7,
      sharpeRatio: 2.14,
      maxDrawdown: -12.1,
      winRate: 72.3,
      profitFactor: 2.45,
      totalTrades: 234,
      avgTradeDuration: '6h',
      volatility: 18.7,
    ),
  ),
  TradeBotCompareStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    colorHex: 0xFF10B981,
    metrics: TradeBotCompareMetrics(
      totalReturn: 55.9,
      sharpeRatio: 1.89,
      maxDrawdown: -15.3,
      winRate: 68.4,
      profitFactor: 2.12,
      totalTrades: 156,
      avgTradeDuration: '12h',
      volatility: 22.3,
    ),
  ),
  TradeBotCompareStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    colorHex: 0xFF8B5CF6,
    metrics: TradeBotCompareMetrics(
      totalReturn: 89.4,
      sharpeRatio: 1.34,
      maxDrawdown: -28.7,
      winRate: 78.9,
      profitFactor: 2.87,
      totalTrades: 312,
      avgTradeDuration: '4h',
      volatility: 34.2,
    ),
  ),
];

const List<TradeBotCompareEquityPoint> _botCompareEquityPoints = [
  TradeBotCompareEquityPoint(
    date: 'Sep',
    dca: 1042,
    grid: 1068,
    momentum: 1055,
    martingale: 1089,
  ),
  TradeBotCompareEquityPoint(
    date: 'Oct',
    dca: 1087,
    grid: 1142,
    momentum: 1128,
    martingale: 1178,
  ),
  TradeBotCompareEquityPoint(
    date: 'Nov',
    dca: 1134,
    grid: 1223,
    momentum: 1198,
    martingale: 1267,
  ),
  TradeBotCompareEquityPoint(
    date: 'Dec',
    dca: 1189,
    grid: 1298,
    momentum: 1256,
    martingale: 1345,
  ),
  TradeBotCompareEquityPoint(
    date: 'Jan',
    dca: 1245,
    grid: 1387,
    momentum: 1334,
    martingale: 1456,
  ),
  TradeBotCompareEquityPoint(
    date: 'Feb',
    dca: 1298,
    grid: 1478,
    momentum: 1412,
    martingale: 1589,
  ),
  TradeBotCompareEquityPoint(
    date: 'Mar',
    dca: 1423,
    grid: 1687,
    momentum: 1559,
    martingale: 1894,
  ),
];

const List<TradeBotRecommendation> _botCompareRecommendations = [
  TradeBotRecommendation(
    title: 'For Beginners',
    strategyId: 'dca',
    strategy: 'DCA Bot',
    reason:
        'Lowest risk (drawdown -8.4%), simplest to understand, steady returns over time.',
  ),
  TradeBotRecommendation(
    title: 'For Sideways Markets',
    strategyId: 'grid',
    strategy: 'Grid Bot',
    reason:
        'Best Sharpe ratio (2.14), high win rate (72.3%), optimized for range-bound trading.',
  ),
  TradeBotRecommendation(
    title: 'For Trending Markets',
    strategyId: 'momentum',
    strategy: 'Momentum Bot',
    reason:
        'Captures trends effectively, balanced risk-reward, good for bull/bear markets.',
  ),
  TradeBotRecommendation(
    title: 'For Experienced Traders',
    strategyId: 'martingale',
    strategy: 'Martingale Bot',
    reason:
        'Highest returns (+89.4%) but high risk (drawdown -28.7%). Requires large capital.',
  ),
];

const List<TradeBotOptimizationTarget> _botOptimizationTargets = [
  TradeBotOptimizationTarget(
    id: 'sharpe',
    label: 'Maximize Sharpe Ratio',
    description: 'Best risk-adjusted returns',
  ),
  TradeBotOptimizationTarget(
    id: 'returns',
    label: 'Maximize Total Returns',
    description: 'Highest absolute profit',
  ),
  TradeBotOptimizationTarget(
    id: 'drawdown',
    label: 'Minimize Drawdown',
    description: 'Lowest risk',
  ),
];

const List<TradeBotOptimizationRange> _botOptimizationRanges = [
  TradeBotOptimizationRange(
    id: 'gridCount',
    label: 'Grid Count',
    min: 10,
    max: 40,
    step: 5,
    defaultValue: 25,
  ),
  TradeBotOptimizationRange(
    id: 'gridRange',
    label: 'Grid Range (%)',
    min: 20,
    max: 50,
    step: 5,
    defaultValue: 35,
    unit: '%',
  ),
];

const List<String> _botOptimizationSteps = [
  'Tests multiple parameter combinations',
  'Backtests each combination on historical data',
  'Ranks results by target metric (Sharpe Ratio)',
  'Recommends optimal parameters',
];

const TradeBotPortfolioSummary _botPortfolioSummary = TradeBotPortfolioSummary(
  totalEquity: 3245,
  totalInvestment: 2500,
  totalPnl: 745,
  pnlPercent: 29.8,
  portfolioSharpe: 1.92,
  diversificationScore: 78,
  activeBots: 3,
  totalTrades: 479,
);

const List<TradeBotPortfolioAllocation> _botPortfolioAllocations = [
  TradeBotPortfolioAllocation(
    strategy: 'DCA',
    value: 1000,
    pnl: 84,
    colorHex: 0xFF3B82F6,
  ),
  TradeBotPortfolioAllocation(
    strategy: 'Grid',
    value: 500,
    pnl: 127,
    colorHex: 0xFFF59E0B,
  ),
  TradeBotPortfolioAllocation(
    strategy: 'Momentum',
    value: 500,
    pnl: -12,
    colorHex: 0xFF10B981,
  ),
  TradeBotPortfolioAllocation(
    strategy: 'Cash Reserve',
    value: 1245,
    pnl: 0,
    colorHex: 0xFF64748B,
  ),
];

const List<TradeBotPortfolioEquityPoint> _botPortfolioEquity = [
  TradeBotPortfolioEquityPoint(date: 'Sep', equity: 2500),
  TradeBotPortfolioEquityPoint(date: 'Oct', equity: 2587),
  TradeBotPortfolioEquityPoint(date: 'Nov', equity: 2734),
  TradeBotPortfolioEquityPoint(date: 'Dec', equity: 2898),
  TradeBotPortfolioEquityPoint(date: 'Jan', equity: 3045),
  TradeBotPortfolioEquityPoint(date: 'Feb', equity: 3178),
  TradeBotPortfolioEquityPoint(date: 'Mar', equity: 3245),
];

const List<TradeBotCorrelationRow> _botPortfolioCorrelations = [
  TradeBotCorrelationRow(
    bot: 'DCA',
    values: {'DCA': 1, 'Grid': .34, 'Momentum': .12},
  ),
  TradeBotCorrelationRow(
    bot: 'Grid',
    values: {'DCA': .34, 'Grid': 1, 'Momentum': -.08},
  ),
  TradeBotCorrelationRow(
    bot: 'Momentum',
    values: {'DCA': .12, 'Grid': -.08, 'Momentum': 1},
  ),
];

const List<String> _botPortfolioHealthItems = [
  'Strong diversification (correlation < 0.4)',
  'Healthy cash reserve (38% allocation)',
  'Portfolio Sharpe above 1.5 (excellent risk-adjusted returns)',
];

const TradeBotDrawdownSummary _botDrawdownSummary = TradeBotDrawdownSummary(
  maxDrawdownPct: -10.3,
  avgDrawdownPct: -5.2,
  drawdownDays: 9,
  totalDays: 15,
  frequency: 5,
);

const List<TradeBotUnderwaterPoint> _botUnderwaterPoints = [
  TradeBotUnderwaterPoint(
    date: '2025-09-01',
    monthLabel: 'Sep',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-09-15',
    monthLabel: 'Sep',
    underwaterPct: -2.3,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-10-01',
    monthLabel: 'Oct',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-10-15',
    monthLabel: 'Oct',
    underwaterPct: -4.5,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-10-30',
    monthLabel: 'Oct',
    underwaterPct: -8.2,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-11-10',
    monthLabel: 'Nov',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-11-25',
    monthLabel: 'Nov',
    underwaterPct: -3.1,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-12-05',
    monthLabel: 'Dec',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-12-20',
    monthLabel: 'Dec',
    underwaterPct: -6.7,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-01-05',
    monthLabel: 'Jan',
    underwaterPct: -10.3,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-01-20',
    monthLabel: 'Jan',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-02-01',
    monthLabel: 'Feb',
    underwaterPct: -2.8,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-02-15',
    monthLabel: 'Feb',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-03-01',
    monthLabel: 'Mar',
    underwaterPct: -5.4,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-03-08',
    monthLabel: 'Mar',
    underwaterPct: -3.2,
  ),
];

const List<TradeBotDrawdownDurationBucket> _botDrawdownDurationBuckets = [
  TradeBotDrawdownDurationBucket(range: '<1 week', count: 8),
  TradeBotDrawdownDurationBucket(range: '1-2 weeks', count: 5),
  TradeBotDrawdownDurationBucket(range: '2-4 weeks', count: 3),
  TradeBotDrawdownDurationBucket(range: '>1 month', count: 1),
];

const List<TradeBotDrawdownEvent> _botDrawdownEvents = [
  TradeBotDrawdownEvent(
    id: 1,
    startLabel: 'Sep 10',
    depthPct: -2.3,
    duration: '20 days',
    recovery: '21 days',
    severe: false,
  ),
  TradeBotDrawdownEvent(
    id: 2,
    startLabel: 'Oct 10',
    depthPct: -8.2,
    duration: '29 days',
    recovery: '2 days',
    severe: true,
  ),
  TradeBotDrawdownEvent(
    id: 3,
    startLabel: 'Nov 20',
    depthPct: -3.1,
    duration: '13 days',
    recovery: '2 days',
    severe: false,
  ),
  TradeBotDrawdownEvent(
    id: 4,
    startLabel: 'Dec 15',
    depthPct: -10.3,
    duration: '34 days',
    recovery: '2 days',
    severe: true,
  ),
  TradeBotDrawdownEvent(
    id: 5,
    startLabel: 'Feb 28',
    depthPct: -5.4,
    duration: '8 days',
    recovery: 'Ongoing',
    severe: false,
  ),
];

const List<TradeBotDrawdownInsight> _botDrawdownInsights = [
  TradeBotDrawdownInsight(
    symbol: 'check',
    colorHex: 0xFF10B981,
    text: 'Max drawdown (-10.3%) is within acceptable range (<15%)',
  ),
  TradeBotDrawdownInsight(
    symbol: 'check',
    colorHex: 0xFF10B981,
    text: 'Average recovery time is short (2-21 days)',
  ),
  TradeBotDrawdownInsight(
    symbol: 'alert',
    colorHex: 0xFFF59E0B,
    text: 'Currently in drawdown (-3.2%), monitor closely',
  ),
  TradeBotDrawdownInsight(
    symbol: 'check',
    colorHex: 0xFF10B981,
    text: 'Most drawdowns are short-term (<1 week)',
  ),
];

const TradeBotEquityCurveSummary _botEquityCurveSummary =
    TradeBotEquityCurveSummary(
      botReturnPct: 74.5,
      buyHoldReturnPct: 62.1,
      alphaPct: 12.4,
    );
