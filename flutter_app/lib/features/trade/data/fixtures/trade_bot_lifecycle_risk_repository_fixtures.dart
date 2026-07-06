part of '../repositories/mock_trade_repository.dart';

const List<TradeBotStrategy> _botStrategies = [
  TradeBotStrategy(
    id: 'dca',
    name: 'DCA Bot',
    description: 'Dollar Cost Averaging - Mua định kỳ, giảm rủi ro biến động',
    longDescription:
        'DCA Bot tự động mua một lượng cố định theo chu kỳ thời gian, bất kể giá tăng hay giảm.',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    risk: TradeBotRisk.low,
    avgReturn: '+8-15% / năm',
    suitableFor: 'Nhà đầu tư dài hạn, người mới',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT', 'BNB/USDT'],
      ),
      TradeBotParam(
        key: 'amount',
        label: 'Mỗi lần mua',
        type: 'number',
        defaultValue: '50',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'interval',
        label: 'Chu kỳ',
        type: 'select',
        defaultValue: 'Mỗi ngày',
        options: ['Mỗi giờ', 'Mỗi ngày', 'Mỗi tuần', 'Mỗi tháng'],
      ),
      TradeBotParam(
        key: 'totalBudget',
        label: 'Ngân sách tổng',
        type: 'number',
        defaultValue: '1000',
        unit: 'USDT',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'grid',
    name: 'Grid Bot',
    description: 'Lưới giá - Mua thấp bán cao tự động trong khoảng giá',
    longDescription:
        'Grid Bot đặt nhiều lệnh mua và bán trong khoảng giá xác định, tự động kiếm lời khi thị trường đi ngang.',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    risk: TradeBotRisk.medium,
    avgReturn: '+15-40% / năm',
    suitableFor: 'Thị trường sideway, trader kinh nghiệm',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'ETH/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'upperPrice',
        label: 'Giá trần',
        type: 'number',
        defaultValue: '4000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'lowerPrice',
        label: 'Giá sàn',
        type: 'number',
        defaultValue: '3000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'gridCount',
        label: 'Số lưới',
        type: 'number',
        defaultValue: '20',
        unit: 'lưới',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    description: 'Theo đà thị trường - Mua khi uptrend, bán khi downtrend',
    longDescription:
        'Momentum Bot sử dụng chỉ báo kỹ thuật để xác định xu hướng và tự động vào/ra lệnh.',
    icon: 'chart',
    colorHex: 0xFF10B981,
    risk: TradeBotRisk.medium,
    avgReturn: '+20-50% / năm',
    suitableFor: 'Thị trường trending, trader trung cấp',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'investment',
        label: 'Vốn giao dịch',
        type: 'number',
        defaultValue: '500',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'stopLoss',
        label: 'Stop loss',
        type: 'number',
        defaultValue: '5',
        unit: '%',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    description: 'Tăng gấp đôi khi thua - Phục hồi nhanh sau drawdown',
    longDescription:
        'Martingale tăng kích thước lệnh sau mỗi lần thua để bù đắp khi thắng. Tiềm năng lợi nhuận cao nhưng rủi ro cũng cao.',
    icon: 'target',
    colorHex: 0xFF8B5CF6,
    risk: TradeBotRisk.high,
    avgReturn: '+30-80% / năm',
    suitableFor: 'Trader chuyên nghiệp, vốn lớn',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'baseOrder',
        label: 'Lệnh cơ bản',
        type: 'number',
        defaultValue: '20',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'multiplier',
        label: 'Hệ số nhân',
        type: 'number',
        defaultValue: '2',
        unit: 'x',
      ),
    ],
  ),
];

const List<TradeBot> _activeBots = [
  TradeBot(
    id: 'bot1',
    strategyId: 'dca',
    strategyName: 'DCA Bot',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    pair: 'BTC/USDT',
    status: TradeBotStatus.running,
    profit: 84.20,
    profitPct: 8.42,
    trades: 47,
    investment: 1000,
    startDate: '01/01/2026',
    runtime: '52 ngày',
  ),
  TradeBot(
    id: 'bot2',
    strategyId: 'grid',
    strategyName: 'Grid Bot',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    pair: 'ETH/USDT',
    status: TradeBotStatus.running,
    profit: 127.40,
    profitPct: 25.48,
    trades: 234,
    investment: 500,
    startDate: '15/01/2026',
    runtime: '38 ngày',
  ),
  TradeBot(
    id: 'bot3',
    strategyId: 'momentum',
    strategyName: 'Momentum Bot',
    icon: 'chart',
    colorHex: 0xFF10B981,
    pair: 'SOL/USDT',
    status: TradeBotStatus.paused,
    profit: -12.30,
    profitPct: -2.46,
    trades: 18,
    investment: 500,
    startDate: '10/02/2026',
    runtime: '13 ngày',
  ),
];

const List<TradeBotTermsSection> _botTermsSections = [
  TradeBotTermsSection(
    title: '1. Acceptance of Terms',
    paragraphs: [
      'By using our Trading Bots service ("Service"), you agree to be bound '
          'by these Terms of Service ("Terms"). If you do not agree to these '
          'Terms, you must not use the Service.',
      'These Terms constitute a legally binding agreement between you and the '
          'Company. Your use of automated trading algorithms is subject to '
          'additional regulatory requirements which you acknowledge and accept.',
    ],
  ),
  TradeBotTermsSection(
    title: '2. No Profit Guarantee',
    warningTitle: 'CRITICAL WARNING:',
    warningBody:
        'Trading Bots do NOT guarantee profits. Past performance does not '
        'predict future results. You may lose some or all of your invested '
        'capital.',
    paragraphs: [
      'Automated trading carries significant risk. Market conditions, '
          'volatility, liquidity, technical failures, and other factors can '
          'result in substantial losses. You should only invest capital you '
          'can afford to lose entirely.',
    ],
  ),
  TradeBotTermsSection(
    title: '3. Risk Acknowledgment',
    paragraphs: ['You acknowledge and accept the following risks:'],
    bullets: [
      'Market Risk: Cryptocurrency markets are highly volatile.',
      'Liquidity Risk: Orders may not execute at desired prices.',
      'Slippage Risk: Execution prices may differ from expected prices.',
      'Technical Risk: System failures may cause unexpected behavior.',
    ],
  ),
  TradeBotTermsSection(
    title: '4. User Responsibilities',
    paragraphs: [
      'You are solely responsible for configuring bot parameters, monitoring '
          'performance, maintaining sufficient balance, understanding each '
          'strategy, and complying with applicable laws.',
    ],
  ),
  TradeBotTermsSection(
    title: '5. Liability Limitation',
    paragraphs: [
      'To the maximum extent permitted by law, the Company shall not be liable '
          'for trading losses, inaccurate projections, downtime, exchange '
          'failures, or regulatory changes affecting your trading ability.',
    ],
  ),
  TradeBotTermsSection(
    title: '6. Service Modifications & Termination',
    paragraphs: [
      'We reserve the right to modify, suspend, or terminate the Service at '
          'any time to comply with regulations or protect user interests.',
    ],
  ),
  TradeBotTermsSection(
    title: '7. Dispute Resolution',
    paragraphs: [
      'Any disputes arising from these Terms or your use of the Service shall '
          'be resolved through binding arbitration in accordance with the '
          'applicable rules.',
    ],
  ),
  TradeBotTermsSection(
    title: '8. Regulatory Compliance',
    paragraphs: [
      'Trading Bots may be classified as complex financial products under '
          'MiFID II, requiring appropriateness assessment and local compliance.',
    ],
  ),
  TradeBotTermsSection(
    title: '9. Data Usage & Privacy',
    paragraphs: [
      'We collect and process trading data, bot performance metrics, and '
          'account information to provide and improve the Service.',
    ],
  ),
  TradeBotTermsSection(
    title: '10. Contact Information',
    paragraphs: [
      'For questions about these Terms, contact legal@tradingplatform.com or '
          'support@tradingplatform.com.',
    ],
  ),
];

const List<TradeBotRiskCategory> _botRiskCategories = [
  TradeBotRiskCategory(
    id: 'market',
    kind: TradeBotRiskKind.market,
    title: 'Market Volatility Risk',
    description:
        'Cryptocurrency markets are extremely volatile and can move rapidly '
        'against your positions.',
    examples: [
      'Bitcoin dropped 30% in a single day during flash crashes',
      'Altcoins can lose 50-90% of value in bear markets',
      'News events can cause sudden price swings of 10-20% in minutes',
    ],
    mitigation:
        'Use stop-loss orders, diversify across assets, and never invest '
        'more than you can afford to lose.',
  ),
  TradeBotRiskCategory(
    id: 'leverage',
    kind: TradeBotRiskKind.leverage,
    title: 'Leverage & Martingale Risk',
    description:
        'Strategies that increase position size (like Martingale) can '
        'amplify losses exponentially.',
    examples: [
      'Martingale can require 10x initial capital after 3-4 consecutive losses',
      'Liquidation can occur if market moves against you before recovery',
      'Compound losses can exceed total account balance',
    ],
    mitigation:
        'Set strict maximum position size limits, use conservative '
        'multipliers, and monitor drawdown closely.',
  ),
  TradeBotRiskCategory(
    id: 'liquidity',
    kind: TradeBotRiskKind.liquidity,
    title: 'Liquidity & Slippage Risk',
    description:
        'Low liquidity markets may not execute your orders at expected prices.',
    examples: [
      'Limit orders may not fill during volatile periods',
      'Market orders can execute 2-5% worse than displayed price',
      'Large orders can move the market against you',
    ],
    mitigation:
        'Trade liquid pairs (BTC/USDT, ETH/USDT), use limit orders, and '
        'split large orders into smaller chunks.',
  ),
  TradeBotRiskCategory(
    id: 'technical',
    kind: TradeBotRiskKind.technical,
    title: 'Technical Failure Risk',
    description:
        'System bugs, network issues, or exchange downtime can cause '
        'unexpected bot behavior.',
    examples: [
      'Exchange API failures can prevent bot execution',
      'Network latency can cause missed opportunities or double orders',
      'Software bugs may execute unintended trades',
    ],
    mitigation:
        'Enable emergency stop alerts, monitor bot activity regularly, and '
        'test strategies in demo mode first.',
  ),
  TradeBotRiskCategory(
    id: 'timing',
    kind: TradeBotRiskKind.timing,
    title: 'Execution & Timing Risk',
    description:
        'Delays between signal generation and order execution can reduce '
        'profitability.',
    examples: [
      'Backtest results assume instant execution (unrealistic)',
      'Real trading incurs 0.1-1 second delays affecting entry/exit prices',
      'High-frequency strategies are most sensitive to timing issues',
    ],
    mitigation:
        'Account for realistic execution delays in backtests, avoid '
        'over-optimized strategies, and use VPS for stable connectivity.',
  ),
  TradeBotRiskCategory(
    id: 'regulatory',
    kind: TradeBotRiskKind.regulatory,
    title: 'Regulatory & Legal Risk',
    description:
        'Changes in regulations may affect your ability to trade or access '
        'funds.',
    examples: [
      'Automated trading may be restricted in certain jurisdictions',
      'KYC/AML requirements can freeze withdrawals pending verification',
      'Tax reporting obligations apply to all bot trades',
    ],
    mitigation:
        'Ensure compliance with local laws, keep detailed trade records, and '
        'consult a tax professional.',
  ),
];

const List<TradeBotRiskWarning> _botRiskWarnings = [
  TradeBotRiskWarning(
    title: 'No Guarantee of Profit',
    text:
        'Bots can lose money consistently. A strategy that works in '
        'backtests may fail in live trading due to changing market conditions.',
  ),
  TradeBotRiskWarning(
    title: 'Fees Compound Losses',
    text:
        'Every trade incurs exchange fees (0.1-0.5%). High-frequency bots can '
        'lose money purely from fees even if price moves are neutral.',
  ),
  TradeBotRiskWarning(
    title: 'Market Manipulation',
    text:
        'Cryptocurrency markets are less regulated and more susceptible to '
        'manipulation, wash trading, and pump-and-dump schemes.',
  ),
  TradeBotRiskWarning(
    title: 'Account Liquidation',
    text:
        'If using margin or leverage, your entire account can be liquidated '
        'if the market moves against you before stop-loss triggers.',
  ),
  TradeBotRiskWarning(
    title: 'No Recourse for Losses',
    text:
        'Unlike traditional finance, crypto trading is largely uninsured. '
        'Lost funds cannot be recovered through deposit insurance schemes.',
  ),
];

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
