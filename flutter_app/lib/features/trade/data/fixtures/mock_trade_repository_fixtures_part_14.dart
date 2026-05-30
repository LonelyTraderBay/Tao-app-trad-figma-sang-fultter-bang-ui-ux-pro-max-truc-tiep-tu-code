part of '../repositories/mock_trade_repository.dart';

const List<TradeBotEquityCurvePoint> _botEquityCurvePoints = [
  TradeBotEquityCurvePoint(
    date: '2025-09-01',
    monthLabel: 'Sep',
    equity: 1000,
    buyHold: 1000,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-09-15',
    monthLabel: 'Sep',
    equity: 1042,
    buyHold: 1035,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-10-01',
    monthLabel: 'Oct',
    equity: 1087,
    buyHold: 1098,
    rollingSharpe: 1.52,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-10-15',
    monthLabel: 'Oct',
    equity: 1134,
    buyHold: 1076,
    rollingSharpe: 1.67,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-11-01',
    monthLabel: 'Nov',
    equity: 1189,
    buyHold: 1142,
    rollingSharpe: 1.89,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-11-15',
    monthLabel: 'Nov',
    equity: 1245,
    buyHold: 1198,
    rollingSharpe: 2.01,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-12-01',
    monthLabel: 'Dec',
    equity: 1298,
    buyHold: 1256,
    rollingSharpe: 2.14,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-12-15',
    monthLabel: 'Dec',
    equity: 1356,
    buyHold: 1289,
    rollingSharpe: 2.07,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-01-01',
    monthLabel: 'Jan',
    equity: 1423,
    buyHold: 1334,
    rollingSharpe: 1.94,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-01-15',
    monthLabel: 'Jan',
    equity: 1489,
    buyHold: 1412,
    rollingSharpe: 1.89,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-02-01',
    monthLabel: 'Feb',
    equity: 1556,
    buyHold: 1478,
    rollingSharpe: 1.92,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-02-15',
    monthLabel: 'Feb',
    equity: 1623,
    buyHold: 1534,
    rollingSharpe: 1.97,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-03-01',
    monthLabel: 'Mar',
    equity: 1689,
    buyHold: 1589,
    rollingSharpe: 2.02,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-03-08',
    monthLabel: 'Mar',
    equity: 1745,
    buyHold: 1621,
    rollingSharpe: 2.08,
  ),
];

const List<TradeBotMonthlyReturn> _botEquityMonthlyReturns = [
  TradeBotMonthlyReturn(
    month: 'Sep 2025',
    botReturn: 4.2,
    marketReturn: 3.5,
    alpha: .7,
  ),
  TradeBotMonthlyReturn(
    month: 'Oct 2025',
    botReturn: 4.3,
    marketReturn: 6.1,
    alpha: -1.8,
  ),
  TradeBotMonthlyReturn(
    month: 'Nov 2025',
    botReturn: 4.9,
    marketReturn: 4.0,
    alpha: .9,
  ),
  TradeBotMonthlyReturn(
    month: 'Dec 2025',
    botReturn: 4.4,
    marketReturn: 3.7,
    alpha: .7,
  ),
  TradeBotMonthlyReturn(
    month: 'Jan 2026',
    botReturn: 4.8,
    marketReturn: 5.1,
    alpha: -.3,
  ),
  TradeBotMonthlyReturn(
    month: 'Feb 2026',
    botReturn: 4.7,
    marketReturn: 4.5,
    alpha: .2,
  ),
  TradeBotMonthlyReturn(
    month: 'Mar 2026',
    botReturn: 4.2,
    marketReturn: 3.8,
    alpha: .4,
  ),
];

const List<TradeBotPerformanceStat> _botEquityPerformanceStats = [
  TradeBotPerformanceStat(
    id: 'total',
    label: 'Total Return',
    value: '+74.5%',
    colorHex: 0xFF10B981,
  ),
  TradeBotPerformanceStat(
    id: 'annualized',
    label: 'Annualized Return',
    value: '+52.3%',
    colorHex: 0xFF10B981,
  ),
  TradeBotPerformanceStat(
    id: 'outperformance',
    label: 'Outperformance',
    value: '+12.4%',
    colorHex: 0xFF10B981,
  ),
  TradeBotPerformanceStat(
    id: 'average',
    label: 'Avg Monthly',
    value: '+4.5%',
    colorHex: 0xFFF5F7FA,
  ),
];

const List<String> _botEquityAnalysisItems = [
  'Bot returned +74.5% vs buy & hold +62.1% (alpha: +12.4%)',
  'Consistent positive alpha in 5 out of 7 months',
  'Rolling Sharpe ratio stayed above 1.5 (excellent risk-adjusted returns)',
];

const List<TradeBotGuideStrategy> _botGuideStrategies = [
  TradeBotGuideStrategy(
    id: 'dca',
    name: 'DCA Bot (Dollar Cost Averaging)',
    iconKey: 'trending',
    colorHex: 0xFF3B82F6,
    difficulty: 'Beginner',
    description:
        'Automatically buy crypto at regular intervals regardless of price.',
    howItWorks: [
      'Set investment amount (e.g., \$100)',
      'Choose frequency (daily, weekly, monthly)',
      'Bot buys automatically on schedule',
      'Averages out market volatility',
      'Best for long-term accumulation',
    ],
    pros: [
      'Simplest strategy to understand',
      'Removes emotion from buying decisions',
      'Reduces timing risk',
      'Good for volatile markets',
    ],
    cons: [
      'No profit taking mechanism',
      'Continues buying in downtrends',
      'Requires consistent capital',
    ],
    bestFor: 'Long-term investors, beginners, volatile markets',
    example: TradeBotGuideExample(
      setup: 'Buy \$100 BTC every Monday',
      duration: '6 months',
      result: 'Average buy price: \$67,500 vs spot price: \$68,450',
      profit: '+\$127 (1.8%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'grid',
    name: 'Grid Bot',
    iconKey: 'grid',
    colorHex: 0xFFF59E0B,
    difficulty: 'Intermediate',
    description:
        'Place buy and sell orders at multiple price levels to profit from price fluctuations.',
    howItWorks: [
      'Define price range (e.g., \$65,000 - \$70,000)',
      'Set number of grids (e.g., 20 grids)',
      'Bot places buy/sell orders at each grid level',
      'Profits from each price swing',
      'Works best in sideways markets',
    ],
    pros: [
      'Profits from volatility',
      'No need to predict direction',
      'Automated 24/7 trading',
      'High win rate (70-80%)',
    ],
    cons: [
      'Loses money in strong trends',
      'Requires sufficient capital for all grids',
      'Can miss big moves outside range',
    ],
    bestFor: 'Sideways/ranging markets, active traders, volatility lovers',
    example: TradeBotGuideExample(
      setup: '20 grids, \$65K-\$70K range, \$1,000 capital',
      duration: '1 month',
      result: '156 trades executed, 72.3% win rate',
      profit: '+\$127.40 (12.7%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    iconKey: 'bolt',
    colorHex: 0xFF10B981,
    difficulty: 'Advanced',
    description:
        'Follow trends by buying when price rises and selling when it falls.',
    howItWorks: [
      'Monitor price movement and indicators',
      'Buy when uptrend detected (e.g., price > MA)',
      'Sell when downtrend detected',
      'Trail stop-loss to protect profits',
      'Best for trending markets',
    ],
    pros: [
      'Captures large trend movements',
      'Built-in stop-loss protection',
      'Can make big profits in trends',
      'Adapts to market conditions',
    ],
    cons: [
      'Frequent false signals in choppy markets',
      'Requires parameter tuning',
      'Can whipsaw in sideways markets',
    ],
    bestFor: 'Trending markets (bull/bear), experienced traders',
    example: TradeBotGuideExample(
      setup: 'MA crossover strategy, 3% stop-loss',
      duration: '2 months',
      result: '23 trades, 68.4% win rate',
      profit: '+\$559 (55.9%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    iconKey: 'alert',
    colorHex: 0xFFEF4444,
    difficulty: 'Expert',
    description:
        'Double position size after each loss to recover all losses with one win.',
    howItWorks: [
      'Start with base position (e.g., \$100)',
      'If loss, double next position (\$200)',
      'If loss again, double again (\$400)',
      'One win recovers all previous losses',
      'High risk - can blow up account',
    ],
    pros: ['High win rate (78%+)', 'Recovers losses quickly', 'Simple logic'],
    cons: [
      'Catastrophic risk if many losses',
      'Requires large capital',
      'Can hit max drawdown (-30%+)',
      'Not suitable for beginners',
    ],
    bestFor: 'Experienced traders with large capital, high risk tolerance',
    example: TradeBotGuideExample(
      setup: 'Base \$100, 2x multiplier, max 5 doublings',
      duration: '1 month',
      result: '312 trades, 78.9% win rate, max DD -28.7%',
      profit: '+\$894 (89.4%) - High risk',
    ),
  ),
];

const List<TradeBotGuidePractice> _botGuideBestPractices = [
  TradeBotGuidePractice(
    id: 'small',
    title: 'Start Small',
    description: 'Begin with \$50-200 to test strategies before scaling up.',
    iconKey: 'idea',
  ),
  TradeBotGuidePractice(
    id: 'backtest',
    title: 'Backtest First',
    description:
        'Always backtest your strategy on historical data before deploying.',
    iconKey: 'chart',
  ),
  TradeBotGuidePractice(
    id: 'stop-loss',
    title: 'Set Stop-Loss',
    description: 'Use drawdown limits and emergency stops to protect capital.',
    iconKey: 'shield',
  ),
  TradeBotGuidePractice(
    id: 'monitor',
    title: 'Monitor Daily',
    description: 'Check bot performance at least once a day for anomalies.',
    iconKey: 'eye',
  ),
  TradeBotGuidePractice(
    id: 'diversify',
    title: 'Diversify',
    description:
        "Don't put all capital in one bot - spread across multiple strategies.",
    iconKey: 'target',
  ),
  TradeBotGuidePractice(
    id: 'fomo',
    title: 'Avoid FOMO',
    description: "Don't create bots during extreme market conditions.",
    iconKey: 'warning',
  ),
];

const List<TradeBotGuideMistake> _botGuideMistakes = [
  TradeBotGuideMistake(
    mistake: 'Over-optimizing parameters',
    why: 'Parameters optimized on past data may not work in future.',
    fix: 'Use simple, robust parameters. Test walk-forward validation.',
  ),
  TradeBotGuideMistake(
    mistake: 'Ignoring fees',
    why: 'High-frequency bots can lose money purely from trading fees.',
    fix: 'Calculate fee impact. Aim for profit > 2x fees per trade.',
  ),
  TradeBotGuideMistake(
    mistake: 'No risk management',
    why: 'Bots can compound losses without stop-loss limits.',
    fix: 'Set max drawdown (-20%), daily loss limits, use emergency stop.',
  ),
  TradeBotGuideMistake(
    mistake: 'Changing strategy mid-run',
    why: 'Interrupts strategy logic, can cause losses.',
    fix: 'Let bot run for full cycle (7-30 days) before adjusting.',
  ),
  TradeBotGuideMistake(
    mistake: 'Using demo results as guarantee',
    why: 'Demo has no slippage, instant fills, no network issues.',
    fix: 'Expect real results to be 10-20% worse than demo.',
  ),
];

const List<TradeBotFaqCategory> _botFaqCategories = [
  TradeBotFaqCategory(
    id: 'general',
    label: 'General',
    items: [
      TradeBotFaqItem(
        question: 'What is a trading bot?',
        answer:
            'A trading bot is an automated program that executes buy and sell orders based on predefined rules and strategies. It trades 24/7 without human intervention, following your configured parameters.',
      ),
      TradeBotFaqItem(
        question: 'Are trading bots profitable?',
        answer:
            'Profitability depends on market conditions, strategy, and parameters. Bots can be profitable but are NOT guaranteed to make money. Past performance does not predict future results. You may lose some or all of your capital.',
      ),
      TradeBotFaqItem(
        question: 'How much money do I need to start?',
        answer:
            'You can start with as little as \$50-100 for testing. For serious trading, we recommend \$500-1,000 minimum to handle market volatility and trading fees. Grid bots need more capital.',
      ),
      TradeBotFaqItem(
        question: 'Do I need coding skills?',
        answer:
            'No coding required. Our bots use a simple configuration interface. Just select strategy, set parameters, and start. Advanced users can use API for custom strategies.',
      ),
      TradeBotFaqItem(
        question: 'Can I lose more than I invest?',
        answer:
            'No. Bots only trade with your available balance. You cannot lose more than your deposited amount. However, you can lose your entire investment if the market moves against you.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'safety',
    label: 'Safety',
    items: [
      TradeBotFaqItem(
        question: 'What happens if the exchange goes down?',
        answer:
            'If the exchange API fails, the bot stops executing new orders until connection is restored. Open orders remain on exchange books. Use exchanges with 99.9%+ uptime.',
      ),
      TradeBotFaqItem(
        question: 'Can hackers steal my funds?',
        answer:
            'We never have custody of your funds. They stay on the exchange. We only use API keys with trade permissions, not withdrawal permissions.',
      ),
      TradeBotFaqItem(
        question: 'How do I stop a bot in emergency?',
        answer:
            'Go to Risk Dashboard > Emergency Stop, or use the stop button on bot detail page. This immediately stops new orders and can optionally close open positions.',
      ),
      TradeBotFaqItem(
        question: 'What if I find a bug?',
        answer:
            'Use the emergency stop immediately. Report the bug to support@tradingplatform.com with screenshots and bot ID. We review verified bugs and related losses.',
      ),
      TradeBotFaqItem(
        question: 'Are my API keys stored securely?',
        answer:
            'Yes. API keys are encrypted using AES-256 and stored in secure vaults. Keys are never logged or displayed in plain text after creation.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'technical',
    label: 'Technical',
    items: [
      TradeBotFaqItem(
        question: 'How accurate is backtesting?',
        answer:
            'Backtests use historical data but cannot predict future performance. Expect real results to be 10-20% worse due to slippage, fees, network delays, and partial fills.',
      ),
      TradeBotFaqItem(
        question: 'What fees apply to bot trading?',
        answer:
            'Exchange trading fees apply to every order. Our platform charges no extra fees for bot usage. High-frequency strategies can rack up fees quickly.',
      ),
      TradeBotFaqItem(
        question: 'Can I edit a running bot?',
        answer:
            'No. You must stop the bot, edit parameters, then restart. This prevents strategy corruption mid-cycle and keeps audit history clear.',
      ),
      TradeBotFaqItem(
        question: 'Why did my order not fill?',
        answer:
            'Common reasons include insufficient liquidity, fast price moves, exchange balance or limit rejection, and network latency. Check order history for the exact message.',
      ),
      TradeBotFaqItem(
        question: 'What is slippage and how do I reduce it?',
        answer:
            'Slippage is the difference between expected and actual execution price. Reduce it by trading liquid pairs, using limit orders, splitting large orders, and avoiding low-volume periods.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'strategies',
    label: 'Strategies',
    items: [
      TradeBotFaqItem(
        question: 'Which bot strategy is best for beginners?',
        answer:
            'DCA is simplest and safest for beginners. It removes emotion, reduces timing risk, and works well long-term. Avoid Martingale until experienced.',
      ),
      TradeBotFaqItem(
        question: 'When should I use a Grid Bot?',
        answer:
            'Use Grid Bots in sideways or ranging markets where price bounces inside a channel. They are not recommended during strong bull or bear runs.',
      ),
      TradeBotFaqItem(
        question: 'What is the Martingale risk?',
        answer:
            'Martingale doubles position after each loss and requires exponential capital. After 5 losses, you need 32x initial capital and max drawdown can exceed -30%.',
      ),
      TradeBotFaqItem(
        question: 'How do I choose the right parameters?',
        answer:
            'Start with recommended defaults, then adjust based on backtest results, your risk tolerance, and market conditions. Avoid over-optimizing.',
      ),
      TradeBotFaqItem(
        question: 'Can I run multiple bots at once?',
        answer:
            'Yes. Free tier supports 1 bot, Pro tier supports 5 bots, and Enterprise supports unlimited bots. Diversify across strategies and pairs for lower risk.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'troubleshooting',
    label: 'Troubleshooting',
    items: [
      TradeBotFaqItem(
        question: 'My bot is losing money - what should I do?',
        answer:
            'First check whether losses are within expected drawdown. If limits are exceeded, stop the bot, review backtest results, and check whether market conditions changed.',
      ),
      TradeBotFaqItem(
        question: 'Bot stopped working after I changed settings',
        answer:
            'You likely have insufficient balance for new parameters. Check wallet balance, locked funds in other bots, and min or max order sizes.',
      ),
      TradeBotFaqItem(
        question: 'Why is my Grid Bot not executing trades?',
        answer:
            'Grid Bots only trade when price crosses grid levels. If price is stable, no trades execute. Check range, grid spacing, and liquidity.',
      ),
      TradeBotFaqItem(
        question: 'How long should I run a bot before stopping?',
        answer:
            'Minimum 7 days for DCA and 30 days for Grid or Momentum. Bots need time to complete cycles and recover from temporary drawdowns.',
      ),
      TradeBotFaqItem(
        question: 'Can I transfer funds while bot is running?',
        answer:
            'Withdrawing funds may cause a bot to stop if balance drops below minimum. Depositing is safe. Keep a 20% extra buffer for volatility and fees.',
      ),
    ],
  ),
];

const TradeBotTaxSummary _botTaxSummary = TradeBotTaxSummary(
  totalTrades: 1247,
  realizedGains: 3842.50,
  realizedLosses: -1127.30,
  netGainLoss: 2715.20,
  shortTermGains: 2318.40,
  longTermGains: 396.80,
  totalFees: 287.60,
);
