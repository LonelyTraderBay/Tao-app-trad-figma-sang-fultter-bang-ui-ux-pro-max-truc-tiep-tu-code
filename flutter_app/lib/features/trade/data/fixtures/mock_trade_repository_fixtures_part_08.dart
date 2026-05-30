part of '../repositories/mock_trade_repository.dart';

const TradeMarketSentiment _marketSentiment = TradeMarketSentiment(
  overall: 'greed',
  score: 68,
  components: [
    TradeSentimentComponent(
      label: 'Open Interest Trend',
      weight: '20%',
      score: 45,
      description: 'OI tang + gia tang = bullish',
    ),
    TradeSentimentComponent(
      label: 'Long/Short Ratio',
      weight: '25%',
      score: 62,
      description: 'Ty le long vs short traders',
    ),
    TradeSentimentComponent(
      label: 'Top Trader Positions',
      weight: '25%',
      score: 58,
      description: 'Whales dang long hay short',
    ),
    TradeSentimentComponent(
      label: 'Funding Rate',
      weight: '15%',
      score: -15,
      description: 'Duong = bullish pressure',
    ),
    TradeSentimentComponent(
      label: 'Price Action',
      weight: '15%',
      score: 72,
      description: 'Momentum va volatility',
    ),
  ],
  implications: [
    TradeSentimentImplication(
      condition: 'Extreme Greed (>75)',
      action: 'Can nhac chot loi. Market co the dieu chinh.',
      colorHex: 0xFFEF4444,
    ),
    TradeSentimentImplication(
      condition: 'Greed (60-75)',
      action: 'Theo trend nhung can than. Dat trailing stop.',
      colorHex: 0xFFF59E0B,
    ),
    TradeSentimentImplication(
      condition: 'Neutral (40-60)',
      action: 'Cho tin hieu ro rang hon. Khong FOMO.',
      colorHex: 0xFF3B82F6,
    ),
    TradeSentimentImplication(
      condition: 'Fear (25-40)',
      action: 'Co hoi accumulate neu fundamentals on.',
      colorHex: 0xFF84CC16,
    ),
    TradeSentimentImplication(
      condition: 'Extreme Fear (<25)',
      action: 'Capitulation co the xay ra. DCA cho long-term.',
      colorHex: 0xFF10B981,
    ),
  ],
);

const List<TradeMarginHubStat> _marginHubStats = [
  TradeMarginHubStat(
    label: 'Total Features',
    value: '27',
    colorHex: 0xFF10B981,
  ),
  TradeMarginHubStat(
    label: 'Lines of Code',
    value: '~5,100',
    colorHex: 0xFF3B82F6,
  ),
  TradeMarginHubStat(label: 'Components', value: '19', colorHex: 0xFFF59E0B),
  TradeMarginHubStat(label: 'Compliance', value: '100%', colorHex: 0xFF8B5CF6),
];

const List<TradeMarginHubMenuItem> _marginHubMenuItems = [
  TradeMarginHubMenuItem(
    id: 'margin',
    title: 'Margin Trading',
    subtitle: 'Trade voi don bay - P0 Compliance day du',
    badge: 'LIVE',
    colorHex: 0xFF10B981,
    targetPath: '/trade/margin',
  ),
  TradeMarginHubMenuItem(
    id: 'advanced-controls',
    title: 'Advanced Controls',
    subtitle: 'Partial close, Ladder TP/SL, Trailing Stop, Order types',
    badge: 'P1',
    colorHex: 0xFF3B82F6,
    targetPath: '/trade/margin/advanced-demo',
  ),
  TradeMarginHubMenuItem(
    id: 'market-analytics',
    title: 'Market Analytics',
    subtitle: 'OI, Long/Short Ratio, Liquidation Heatmap, Sentiment',
    badge: 'P2',
    colorHex: 0xFFF59E0B,
    targetPath: '/trade/margin/live-market-data-analytics',
  ),
  TradeMarginHubMenuItem(
    id: 'ai-advanced',
    title: 'AI & Advanced Analytics',
    subtitle: 'AI Signals, Risk Analysis, Trade Journal, Position Sizing',
    badge: 'P3',
    colorHex: 0xFF8B5CF6,
    targetPath: '/trade/margin/advanced-analytics',
  ),
];

const List<TradeMarginHubFeature> _marginHubFeatures = [
  TradeMarginHubFeature(
    phase: 'P0',
    title: 'Regulatory & Safety',
    colorHex: 0xFFEF4444,
    items: [
      'Appropriateness Test (quiz system)',
      'Regional Leverage Limits (EU 2x, UK 2x, SG 20x)',
      'Margin Call Alerts (4 thresholds)',
      'Mark Price Separation (liquidation accuracy)',
      'Total Cost Breakdown (MiFID II compliance)',
      'Negative Balance Protection',
      '50% Closeout Warning (EU/UK)',
      'Best Execution Disclosure',
    ],
  ),
  TradeMarginHubFeature(
    phase: 'P1',
    title: 'Advanced Controls',
    colorHex: 0xFF3B82F6,
    items: [
      'Partial Close Position (25%/50%/75%/100%)',
      'Ladder TP/SL (unlimited levels)',
      'Trailing Stop Loss (% or \$ based)',
      'Position Mode Toggle (One-way vs Hedge)',
      'Add/Reduce Margin dynamically',
      'Advanced Order Types (IOC, FOK, Post-Only)',
      'Iceberg Orders (hidden size)',
      'Realized vs Unrealized PnL tracking',
    ],
  ),
  TradeMarginHubFeature(
    phase: 'P2',
    title: 'Market Data & Analytics',
    colorHex: 0xFFF59E0B,
    items: [
      'Open Interest tracking',
      'Long/Short Ratio (Accounts vs Volume)',
      'Top Trader Positions',
      'Market Sentiment (Fear & Greed)',
      'Funding Rate History (24h sparkline)',
      'Liquidation Heatmap (cluster zones)',
      'Recent Liquidations Feed (live)',
      'Period Performance (24h/7d/30d)',
    ],
  ),
];

const TradeMarginHubCompliance _marginHubCompliance = TradeMarginHubCompliance(
  title: 'Fully Regulatory Compliant',
  description:
      'Dap ung MiFID II, ESMA, FCA (UK), MAS (Singapore) regulations. Production-ready cho EU, UK, SG markets.',
  regulations: ['MiFID II', 'ESMA', 'FCA (UK)', 'MAS (SG)'],
);

const List<TradeAdvancedAnalyticsStat> _advancedAnalyticsStats = [
  TradeAdvancedAnalyticsStat(
    label: 'AI Signals',
    value: '3',
    colorHex: 0xFF8B5CF6,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Risk Score',
    value: '58',
    colorHex: 0xFFF59E0B,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Win Rate',
    value: '66.7%',
    colorHex: 0xFF10B981,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Sharpe',
    value: '1.82',
    colorHex: 0xFF3B82F6,
  ),
];

const List<TradeAiSignal> _advancedAnalyticsSignals = [
  TradeAiSignal(
    id: 'sig-1',
    pair: 'BTC/USDT',
    direction: 'long',
    confidence: 85,
    timeframe: '4h',
    entryPrice: 67500,
    targetPrice: 70200,
    stopLoss: 66800,
    riskReward: 3.9,
    accuracy: 73,
    reasoning: [
      'RSI oversold bounce from 32 to 45, bullish divergence confirmed',
      'Volume spike +320% on 4h candle, strong accumulation detected',
      'Breaking above 20-day EMA with increasing volume',
      'Whale wallets accumulated +\$1.2B in last 24h',
      'Funding rate dropped to -0.02%, shorts overleveraged',
    ],
  ),
  TradeAiSignal(
    id: 'sig-2',
    pair: 'ETH/USDT',
    direction: 'short',
    confidence: 72,
    timeframe: '1h',
    entryPrice: 3245,
    targetPrice: 3180,
    stopLoss: 3270,
    riskReward: 2.6,
    accuracy: 68,
    reasoning: [
      'Double top pattern forming at \$3,250 resistance',
      'Bearish divergence: price higher but RSI lower',
      'Volume declining on each rally attempt',
      'ETH/BTC ratio weakening against BTC',
    ],
  ),
  TradeAiSignal(
    id: 'sig-3',
    pair: 'SOL/USDT',
    direction: 'long',
    confidence: 91,
    timeframe: '15m',
    entryPrice: 145,
    targetPrice: 151,
    stopLoss: 143.5,
    riskReward: 4.0,
    accuracy: 78,
    reasoning: [
      'Breakout from ascending triangle after consolidation',
      'Volume explosion +580%, institutional flow detected',
      'All moving averages aligned bullish',
      'Solana ecosystem TVL +12% this week',
      'Major airdrop announcement driving demand',
    ],
  ),
];

const TradeAdvancedRiskSummary _advancedAnalyticsRisk =
    TradeAdvancedRiskSummary(
      var95: 5.2,
      sharpeRatio: 1.82,
      maxDrawdown: 18.5,
      riskScore: 58,
      riskLevel: 'medium',
    );

const TradeJournalSummary _advancedAnalyticsJournal = TradeJournalSummary(
  winRate: 66.7,
  totalTrades: 6,
  totalPnl: 7400,
  avgWin: 2210,
  avgLoss: 415,
);

const TradePositionSizingSummary _advancedAnalyticsSizing =
    TradePositionSizingSummary(
      accountBalance: 50000,
      entryPrice: 67500,
      stopLossPrice: 66800,
      takeProfitPrice: 70200,
      recommendedRiskPct: 2,
      positionSize: 1.43,
    );

const List<String> _advancedAnalyticsFeatures = [
  'AI Trading Signals',
  'Risk Score Dashboard',
  'VaR Calculator',
  'Sharpe/Sortino Ratios',
  'Trade Journal',
  'Win/Loss Analytics',
  'Kelly Criterion',
  'Position Sizing',
  'Performance Attribution',
  'Setup Classification',
  'Drawdown Analysis',
  'Beta Calculation',
];

const List<TradeTransactionReport> _transactionReports = [
  TradeTransactionReport(
    id: 'RPT-001',
    transactionId: 'TXN-2026-03-08-001',
    reportType: 'both',
    tradingVenue: 'Binance',
    instrument: 'BTC/USDT',
    side: 'buy',
    quantity: .5,
    price: 68500,
    value: 34250,
    executionTime: '2026-03-08T10:15:23Z',
    reportedTime: '2026-03-08T10:15:45Z',
    confirmedTime: '2026-03-08T10:16:12Z',
    status: 'confirmed',
    armProvider: 'REGIS-TR',
    messageId: 'MSG-REGIS-TR-20260308-001',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
  TradeTransactionReport(
    id: 'RPT-002',
    transactionId: 'TXN-2026-03-08-002',
    reportType: 'mifid2',
    tradingVenue: 'OKX',
    instrument: 'ETH/USDT',
    side: 'sell',
    quantity: 10,
    price: 3825,
    value: 38250,
    executionTime: '2026-03-08T10:22:11Z',
    reportedTime: '2026-03-08T10:22:34Z',
    status: 'submitted',
    armProvider: 'UnaVista',
    messageId: 'MSG-UnaVista-20260308-002',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
  TradeTransactionReport(
    id: 'RPT-003',
    transactionId: 'TXN-2026-03-08-003',
    reportType: 'both',
    tradingVenue: 'Binance',
    instrument: 'SOL/USDT',
    side: 'buy',
    quantity: 100,
    price: 125.5,
    value: 12550,
    executionTime: '2026-03-08T10:30:45Z',
    reportedTime: '2026-03-08T10:31:02Z',
    status: 'failed',
    armProvider: 'REGIS-TR',
    errorMessage: 'Field validation error: Invalid LEI format',
    retryCount: 2,
    slaStatus: 'warning',
  ),
  TradeTransactionReport(
    id: 'RPT-004',
    transactionId: 'TXN-2026-03-08-004',
    reportType: 'mifid2',
    tradingVenue: 'Bybit',
    instrument: 'BTC/USDT',
    side: 'buy',
    quantity: .25,
    price: 68600,
    value: 17150,
    executionTime: '2026-03-08T10:35:12Z',
    status: 'pending',
    armProvider: 'Bloomberg',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
  TradeTransactionReport(
    id: 'RPT-005',
    transactionId: 'TXN-2026-03-08-005',
    reportType: 'emir',
    tradingVenue: 'Binance',
    instrument: 'BTC-PERP',
    side: 'sell',
    quantity: 1.5,
    price: 68550,
    value: 102825,
    executionTime: '2026-03-08T10:40:33Z',
    status: 'submitting',
    armProvider: 'REGIS-TR',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
];

const TradeTransactionReportingStats _transactionReportingStats =
    TradeTransactionReportingStats(
      total: 5,
      confirmed: 1,
      failed: 1,
      pending: 3,
      onTime: 4,
      avgLatencySeconds: 22,
      totalValue: 205025,
      mifidReports: 4,
      emirReports: 3,
      providerCounts: {'REGIS-TR': 3, 'UnaVista': 1, 'Bloomberg': 1},
    );

const List<TradeRegulatoryDailyStat> _regulatoryDailyStats = [
  TradeRegulatoryDailyStat(
    date: '03-02',
    total: 145,
    confirmed: 142,
    failed: 3,
    avgLatency: 18,
  ),
  TradeRegulatoryDailyStat(
    date: '03-03',
    total: 167,
    confirmed: 164,
    failed: 3,
    avgLatency: 21,
  ),
  TradeRegulatoryDailyStat(
    date: '03-04',
    total: 189,
    confirmed: 186,
    failed: 3,
    avgLatency: 19,
  ),
  TradeRegulatoryDailyStat(
    date: '03-05',
    total: 203,
    confirmed: 198,
    failed: 5,
    avgLatency: 23,
  ),
  TradeRegulatoryDailyStat(
    date: '03-06',
    total: 221,
    confirmed: 217,
    failed: 4,
    avgLatency: 20,
  ),
  TradeRegulatoryDailyStat(
    date: '03-07',
    total: 198,
    confirmed: 195,
    failed: 3,
    avgLatency: 22,
  ),
  TradeRegulatoryDailyStat(
    date: '03-08',
    total: 156,
    confirmed: 153,
    failed: 3,
    avgLatency: 19,
  ),
];

const List<TradeRegulatoryArmProvider> _regulatoryArmProviders = [
  TradeRegulatoryArmProvider(
    name: 'REGIS-TR',
    reports: 512,
    successRate: 98.4,
    avgLatency: 18,
    status: 'healthy',
  ),
  TradeRegulatoryArmProvider(
    name: 'UnaVista',
    reports: 389,
    successRate: 97.8,
    avgLatency: 22,
    status: 'healthy',
  ),
  TradeRegulatoryArmProvider(
    name: 'Bloomberg',
    reports: 234,
    successRate: 99.1,
    avgLatency: 15,
    status: 'healthy',
  ),
  TradeRegulatoryArmProvider(
    name: 'DTCC',
    reports: 89,
    successRate: 96.5,
    avgLatency: 28,
    status: 'degraded',
  ),
];

const List<TradeRegulatoryDistributionItem> _regulatoryReportDistribution = [
  TradeRegulatoryDistributionItem(
    name: 'MiFID II',
    value: 678,
    colorHex: 0xFF3B82F6,
  ),
  TradeRegulatoryDistributionItem(
    name: 'EMIR',
    value: 345,
    colorHex: 0xFF10B981,
  ),
  TradeRegulatoryDistributionItem(
    name: 'SEC',
    value: 123,
    colorHex: 0xFFF59E0B,
  ),
  TradeRegulatoryDistributionItem(
    name: 'Other',
    value: 78,
    colorHex: 0xFF94A3B8,
  ),
];

const TradeRegulatoryDashboardTotals _regulatoryDashboardTotals =
    TradeRegulatoryDashboardTotals(
      total: 1279,
      confirmed: 1255,
      failed: 24,
      avgLatency: 20.2857142857,
      successRate: 98.123533,
      distributionTotal: 1224,
    );
