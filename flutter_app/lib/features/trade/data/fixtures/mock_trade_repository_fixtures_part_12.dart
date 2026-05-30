part of '../repositories/mock_trade_repository.dart';

const List<TradeBotSuitabilityQuestion> _botSuitabilityQuestions = [
  TradeBotSuitabilityQuestion(
    id: 'q1',
    category: TradeBotSuitabilityCategory.experience,
    question: 'How long have you been trading cryptocurrencies?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Never traded before / Less than 3 months',
        score: 0,
      ),
      TradeBotSuitabilityOption(id: 'b', text: '3-12 months', score: 1),
      TradeBotSuitabilityOption(id: 'c', text: '1-3 years', score: 2),
      TradeBotSuitabilityOption(id: 'd', text: 'More than 3 years', score: 3),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q2',
    category: TradeBotSuitabilityCategory.experience,
    question: 'Have you ever used trading bots or algorithmic trading before?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'No, this is my first time',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Yes, but only in demo/paper trading',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Yes, with real money for less than 6 months',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Yes, extensively with real money for over 6 months',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q3',
    category: TradeBotSuitabilityCategory.knowledge,
    question: 'Do you understand how Grid Bots work?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: "No, I don't know what a Grid Bot is",
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Slightly - I have a basic idea',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Yes - I understand the concept and risks',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Expert - I can explain it and have used it before',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q4',
    category: TradeBotSuitabilityCategory.knowledge,
    question: 'Do you understand what "slippage" means in trading?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'No, never heard of it',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: "Vaguely - I've seen the term but not sure what it means",
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text:
            "Yes - I know it's the difference between expected and actual price",
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Expert - I know how to mitigate slippage',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q5',
    category: TradeBotSuitabilityCategory.risk,
    question:
        'What percentage of your total savings/investments are you planning '
        'to allocate to trading bots?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'More than 50% of my total savings',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: '20-50% of my total savings',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: '5-20% of my total savings',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Less than 5% - only money I can afford to lose',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q6',
    category: TradeBotSuitabilityCategory.risk,
    question:
        'If your bot lost 30% of its value in one week, what would you do?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Panic and sell immediately',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Feel very uncomfortable but hold',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Accept it as normal volatility and continue',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'See it as a buying opportunity and add more',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q7',
    category: TradeBotSuitabilityCategory.financial,
    question: 'What is your primary investment goal with trading bots?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Get rich quick / Double my money fast',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Earn steady income to replace my salary',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Long-term wealth accumulation over years',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Experiment and learn, with small capital',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q8',
    category: TradeBotSuitabilityCategory.knowledge,
    question:
        'Do you understand the difference between DCA, Grid, and Martingale '
        'strategies?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: "No, I don't know any of them",
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'I know DCA but not the others',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'I understand all three conceptually',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Expert - I know when to use each strategy',
        score: 3,
      ),
    ],
  ),
];

const List<TradeBotDrawdownPoint> _botRiskDrawdownPoints = [
  TradeBotDrawdownPoint(label: '00:00', value: 0),
  TradeBotDrawdownPoint(label: '04:00', value: -2.3),
  TradeBotDrawdownPoint(label: '08:00', value: -5.1),
  TradeBotDrawdownPoint(label: '12:00', value: -8.4),
  TradeBotDrawdownPoint(label: '16:00', value: -12.2),
  TradeBotDrawdownPoint(label: '20:00', value: -15.2),
  TradeBotDrawdownPoint(label: 'Now', value: -15.2),
];

const List<TradeBotExposure> _botRiskExposures = [
  TradeBotExposure(
    asset: 'BTC',
    exposure: 1250,
    percentage: 50,
    colorHex: 0xFFF7931A,
  ),
  TradeBotExposure(
    asset: 'ETH',
    exposure: 750,
    percentage: 30,
    colorHex: 0xFF627EEA,
  ),
  TradeBotExposure(
    asset: 'SOL',
    exposure: 500,
    percentage: 20,
    colorHex: 0xFF14F195,
  ),
];

const List<TradeBotVarPoint> _botRiskVarHistory = [
  TradeBotVarPoint(label: 'Mon', value: 142),
  TradeBotVarPoint(label: 'Tue', value: 156),
  TradeBotVarPoint(label: 'Wed', value: 134),
  TradeBotVarPoint(label: 'Thu', value: 167),
  TradeBotVarPoint(label: 'Fri', value: 189),
  TradeBotVarPoint(label: 'Sat', value: 201),
  TradeBotVarPoint(label: 'Sun', value: 178),
];

const List<TradeBotSafetyControl> _botRiskSafetyControls = [
  TradeBotSafetyControl(label: 'Drawdown limit', value: '-20%'),
  TradeBotSafetyControl(label: 'Daily loss limit', value: '-\$500'),
  TradeBotSafetyControl(label: 'Max position size', value: '\$1,000'),
  TradeBotSafetyControl(label: 'Emergency stop', value: 'Enabled'),
];

const List<TradeBotEmergencyBot> _botEmergencyStopBots = [
  TradeBotEmergencyBot(
    id: 'bot1',
    name: 'DCA Bot #1',
    pair: 'BTC/USDT',
    profit: 84.20,
    statusLabel: 'Running',
  ),
  TradeBotEmergencyBot(
    id: 'bot2',
    name: 'Grid Bot #1',
    pair: 'ETH/USDT',
    profit: 127.40,
    statusLabel: 'Running',
  ),
  TradeBotEmergencyBot(
    id: 'bot3',
    name: 'Momentum Bot #1',
    pair: 'SOL/USDT',
    profit: -12.30,
    statusLabel: 'Running',
  ),
];

const List<TradeBotEmergencyReason> _botEmergencyStopReasons = [
  TradeBotEmergencyReason(
    id: 'crash',
    label: 'Market crash / extreme volatility',
    iconName: 'crash',
  ),
  TradeBotEmergencyReason(
    id: 'bug',
    label: 'Technical bug / unexpected behavior',
    iconName: 'bug',
  ),
  TradeBotEmergencyReason(
    id: 'unauthorized',
    label: 'Unauthorized access detected',
    iconName: 'unauthorized',
  ),
  TradeBotEmergencyReason(
    id: 'drawdown',
    label: 'Drawdown limit approaching',
    iconName: 'drawdown',
  ),
  TradeBotEmergencyReason(
    id: 'other',
    label: 'Other reason',
    iconName: 'other',
  ),
];

const List<TradeBotApiKey> _botSecurityApiKeys = [
  TradeBotApiKey(
    id: '1',
    name: 'Trading Bot Key #1',
    permissions: 'Trade + Read',
    lastUsed: '2 hours ago',
    created: '2026-01-15',
  ),
  TradeBotApiKey(
    id: '2',
    name: 'Analytics Key',
    permissions: 'Read Only',
    lastUsed: '1 day ago',
    created: '2026-02-20',
  ),
];

const List<TradeBotIpWhitelistEntry> _botSecurityIpWhitelist = [
  TradeBotIpWhitelistEntry(
    id: '1',
    ip: '192.168.1.100',
    label: 'Home Network',
    added: '2026-03-01',
  ),
  TradeBotIpWhitelistEntry(
    id: '2',
    ip: '203.0.113.42',
    label: 'VPS Server',
    added: '2026-03-05',
  ),
];

const List<TradeBotSecurityActivity> _botSecurityRecentActivity = [
  TradeBotSecurityActivity(
    id: '1',
    action: 'Bot created: DCA Bot #1',
    time: '2 hours ago',
    status: TradeBotSecurityActivityStatus.success,
  ),
  TradeBotSecurityActivity(
    id: '2',
    action: 'API key generated',
    time: '1 day ago',
    status: TradeBotSecurityActivityStatus.success,
  ),
  TradeBotSecurityActivity(
    id: '3',
    action: 'Failed login attempt',
    time: '3 days ago',
    status: TradeBotSecurityActivityStatus.warning,
  ),
  TradeBotSecurityActivity(
    id: '4',
    action: 'Bot stopped: Grid Bot #2',
    time: '5 days ago',
    status: TradeBotSecurityActivityStatus.success,
  ),
];

const List<String> _botSecurityTips = [
  'Never share your API keys with anyone',
  'Use Read-Only keys for analytics, Trade keys only for bots',
  'Restrict API access to specific IP addresses',
  'Enable 2FA for all bot-related actions',
  'Regularly review activity log for suspicious behavior',
];

const List<TradeBotHistoryTrade> _botHistoryTrades = [
  TradeBotHistoryTrade(
    id: 't1',
    timestamp: '2026-03-08 14:32:15',
    botName: 'DCA Bot #1',
    strategy: 'DCA',
    pair: 'BTC/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.001,
    price: 68450,
    fee: 0.034,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't2',
    timestamp: '2026-03-08 13:15:08',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.sell,
    qty: 0.05,
    price: 3850,
    fee: 0.096,
    pnl: 12.50,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't3',
    timestamp: '2026-03-08 12:00:42',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.05,
    price: 3800,
    fee: 0.095,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't4',
    timestamp: '2026-03-08 10:45:30',
    botName: 'Momentum Bot #1',
    strategy: 'Momentum',
    pair: 'SOL/USDT',
    side: TradeBotHistorySide.buy,
    qty: 5,
    price: 142.30,
    fee: 0.356,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't5',
    timestamp: '2026-03-08 09:20:15',
    botName: 'DCA Bot #1',
    strategy: 'DCA',
    pair: 'BTC/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.001,
    price: 68200,
    fee: 0.034,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't6',
    timestamp: '2026-03-07 18:30:22',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.sell,
    qty: 0.05,
    price: 3820,
    fee: 0.096,
    pnl: 8.75,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't7',
    timestamp: '2026-03-07 16:15:10',
    botName: 'Momentum Bot #1',
    strategy: 'Momentum',
    pair: 'SOL/USDT',
    side: TradeBotHistorySide.sell,
    qty: 5,
    price: 138.50,
    fee: 0.346,
    pnl: -19.75,
    status: 'filled',
  ),
];

const List<TradeBotPnlPoint> _botPerformancePnlPoints = [
  TradeBotPnlPoint(date: 'Mar 1', pnl: 12.5),
  TradeBotPnlPoint(date: 'Mar 2', pnl: 28.3),
  TradeBotPnlPoint(date: 'Mar 3', pnl: 45.7),
  TradeBotPnlPoint(date: 'Mar 4', pnl: 32.1),
  TradeBotPnlPoint(date: 'Mar 5', pnl: 58.9),
  TradeBotPnlPoint(date: 'Mar 6', pnl: 91.2),
  TradeBotPnlPoint(date: 'Mar 7', pnl: 127.4),
  TradeBotPnlPoint(date: 'Mar 8', pnl: 199.3),
];

const List<TradeBotWinLossPoint> _botPerformanceWinLossPoints = [
  TradeBotWinLossPoint(week: 'W1', wins: 18, losses: 7),
  TradeBotWinLossPoint(week: 'W2', wins: 22, losses: 5),
  TradeBotWinLossPoint(week: 'W3', wins: 15, losses: 12),
  TradeBotWinLossPoint(week: 'W4', wins: 25, losses: 8),
];

const List<TradeBotStrategyPerformance> _botStrategyPerformance = [
  TradeBotStrategyPerformance(strategy: 'DCA', pnl: 84.2, colorHex: 0xFF3B82F6),
  TradeBotStrategyPerformance(
    strategy: 'Grid',
    pnl: 127.4,
    colorHex: 0xFFF59E0B,
  ),
  TradeBotStrategyPerformance(
    strategy: 'Momentum',
    pnl: -12.3,
    colorHex: 0xFF10B981,
  ),
];

const List<TradeBotDurationDistribution> _botDurationDistribution = [
  TradeBotDurationDistribution(duration: '<1h', count: 45),
  TradeBotDurationDistribution(duration: '1-6h', count: 28),
  TradeBotDurationDistribution(duration: '6-24h', count: 15),
  TradeBotDurationDistribution(duration: '>24h', count: 8),
];

const List<TradeBotBacktestStrategy> _botBacktestStrategies = [
  TradeBotBacktestStrategy(id: 'dca', name: 'DCA Bot', colorHex: 0xFF3B82F6),
  TradeBotBacktestStrategy(id: 'grid', name: 'Grid Bot', colorHex: 0xFFF59E0B),
  TradeBotBacktestStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    colorHex: 0xFF10B981,
  ),
  TradeBotBacktestStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    colorHex: 0xFF8B5CF6,
  ),
];

const List<String> _botBacktestPairs = [
  'BTC/USDT',
  'ETH/USDT',
  'SOL/USDT',
  'BNB/USDT',
  'ADA/USDT',
];
