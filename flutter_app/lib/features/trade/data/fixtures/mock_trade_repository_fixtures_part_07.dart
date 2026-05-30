part of '../repositories/mock_trade_repository.dart';

const List<TradeCopyTrader> _copyTraders = [
  TradeCopyTrader(
    id: 'ct001',
    name: 'AlphaHunter_VN',
    avatar: 'A',
    winRate: 78.5,
    totalPnl: 125430,
    totalPnlPct: 342.5,
    aum: 2450000,
    copiers: 1243,
    maxCopiers: 2000,
    sharpeRatio: 2.31,
    maxDrawdown: -12.4,
    totalTrades: 4521,
    avgHoldingTime: '4.2h',
    weeklyPnl: [2.1, -0.8, 3.4, 1.2, -0.3, 2.8, 1.5],
    tags: ['Top ROI', 'Scalper'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.medium,
  ),
  TradeCopyTrader(
    id: 'ct002',
    name: 'SteadyGains_Pro',
    avatar: 'S',
    winRate: 82.3,
    totalPnl: 89200,
    totalPnlPct: 187.2,
    aum: 5120000,
    copiers: 3421,
    maxCopiers: 5000,
    sharpeRatio: 3.12,
    maxDrawdown: -8.1,
    totalTrades: 2890,
    avgHoldingTime: '12h',
    weeklyPnl: [0.8, 1.1, 0.5, 1.3, 0.7, 0.9, 1.0],
    tags: ['Stable', 'Swing'],
    isFollowing: true,
    riskLevel: TradeCopyRiskLevel.low,
  ),
  TradeCopyTrader(
    id: 'ct003',
    name: 'RiskMaster_88',
    avatar: 'R',
    winRate: 65.2,
    totalPnl: 234100,
    totalPnlPct: 567.8,
    aum: 890000,
    copiers: 567,
    maxCopiers: 1000,
    sharpeRatio: 1.85,
    maxDrawdown: -28.3,
    totalTrades: 8934,
    avgHoldingTime: '1.5h',
    weeklyPnl: [5.2, -3.1, 8.4, -2.1, 6.3, -1.8, 4.7],
    tags: ['High ROI', 'Aggressive'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.high,
  ),
  TradeCopyTrader(
    id: 'ct004',
    name: 'CryptoSensei',
    avatar: 'C',
    winRate: 71.8,
    totalPnl: 67890,
    totalPnlPct: 156.3,
    aum: 1890000,
    copiers: 892,
    maxCopiers: 1500,
    sharpeRatio: 2.67,
    maxDrawdown: -15.2,
    totalTrades: 3456,
    avgHoldingTime: '8h',
    weeklyPnl: [1.5, 2.0, -0.5, 1.8, 1.2, 2.3, 0.9],
    tags: ['Balanced', 'BTC Focus'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.medium,
  ),
  TradeCopyTrader(
    id: 'ct005',
    name: 'WhaleWatcher',
    avatar: 'W',
    winRate: 74.1,
    totalPnl: 312500,
    totalPnlPct: 423.1,
    aum: 8900000,
    copiers: 4890,
    maxCopiers: 5000,
    sharpeRatio: 2.89,
    maxDrawdown: -10.5,
    totalTrades: 1234,
    avgHoldingTime: '3d',
    weeklyPnl: [0.3, 0.5, -0.1, 0.8, 0.2, 0.6, 0.4],
    tags: ['Top AUM', 'Long-term'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.low,
  ),
];

const List<TradeTraderPnlPoint> _traderProfilePnlHistory = [
  TradeTraderPnlPoint(day: '0', pnl: 1800, cumPnl: 1800),
  TradeTraderPnlPoint(day: '1', pnl: -640, cumPnl: 1160),
  TradeTraderPnlPoint(day: '2', pnl: 4280, cumPnl: 5440),
  TradeTraderPnlPoint(day: '3', pnl: 3150, cumPnl: 8590),
  TradeTraderPnlPoint(day: '4', pnl: -720, cumPnl: 7870),
  TradeTraderPnlPoint(day: '5', pnl: 5170, cumPnl: 13040),
  TradeTraderPnlPoint(day: '6', pnl: 2460, cumPnl: 15500),
  TradeTraderPnlPoint(day: '7', pnl: 6100, cumPnl: 21600),
  TradeTraderPnlPoint(day: '8', pnl: -1220, cumPnl: 20380),
  TradeTraderPnlPoint(day: '9', pnl: 5380, cumPnl: 25760),
  TradeTraderPnlPoint(day: '10', pnl: 3920, cumPnl: 29680),
  TradeTraderPnlPoint(day: '11', pnl: 7440, cumPnl: 37120),
  TradeTraderPnlPoint(day: '12', pnl: -2180, cumPnl: 34940),
  TradeTraderPnlPoint(day: '13', pnl: 5040, cumPnl: 39980),
  TradeTraderPnlPoint(day: '14', pnl: 8300, cumPnl: 48280),
  TradeTraderPnlPoint(day: '15', pnl: 4160, cumPnl: 52440),
  TradeTraderPnlPoint(day: '16', pnl: -1780, cumPnl: 50660),
  TradeTraderPnlPoint(day: '17', pnl: 6840, cumPnl: 57500),
  TradeTraderPnlPoint(day: '18', pnl: 9120, cumPnl: 66620),
  TradeTraderPnlPoint(day: '19', pnl: -2640, cumPnl: 63980),
  TradeTraderPnlPoint(day: '20', pnl: 7580, cumPnl: 71560),
  TradeTraderPnlPoint(day: '21', pnl: 6420, cumPnl: 77980),
  TradeTraderPnlPoint(day: '22', pnl: 9050, cumPnl: 87030),
  TradeTraderPnlPoint(day: '23', pnl: -3340, cumPnl: 83690),
  TradeTraderPnlPoint(day: '24', pnl: 7480, cumPnl: 91170),
  TradeTraderPnlPoint(day: '25', pnl: 9660, cumPnl: 100830),
  TradeTraderPnlPoint(day: '26', pnl: 5140, cumPnl: 105970),
  TradeTraderPnlPoint(day: '27', pnl: -2480, cumPnl: 103490),
  TradeTraderPnlPoint(day: '28', pnl: 8720, cumPnl: 112210),
  TradeTraderPnlPoint(day: '29', pnl: 6320, cumPnl: 118530),
  TradeTraderPnlPoint(day: '30', pnl: 6900, cumPnl: 125430),
];

const List<TradeTraderRecentTrade> _traderProfileRecentTrades = [
  TradeTraderRecentTrade(
    id: 't1',
    pair: 'BTC/USDT',
    side: 'long',
    entry: 65200,
    exit: 67543,
    pnl: 2343,
    pnlPct: 3.59,
    time: '2h trước',
    status: 'closed',
  ),
  TradeTraderRecentTrade(
    id: 't2',
    pair: 'ETH/USDT',
    side: 'short',
    entry: 3620,
    exit: 3521,
    pnl: 990,
    pnlPct: 2.73,
    time: '5h trước',
    status: 'closed',
  ),
  TradeTraderRecentTrade(
    id: 't3',
    pair: 'SOL/USDT',
    side: 'long',
    entry: 172,
    exit: null,
    pnl: 316,
    pnlPct: 3.37,
    time: '1d trước',
    status: 'open',
  ),
  TradeTraderRecentTrade(
    id: 't4',
    pair: 'BNB/USDT',
    side: 'long',
    entry: 405,
    exit: 398,
    pnl: -700,
    pnlPct: -1.73,
    time: '2d trước',
    status: 'closed',
  ),
  TradeTraderRecentTrade(
    id: 't5',
    pair: 'BTC/USDT',
    side: 'long',
    entry: 63800,
    exit: 65200,
    pnl: 1400,
    pnlPct: 2.19,
    time: '3d trước',
    status: 'closed',
  ),
];

const TradeAdvancedDemoPosition _advancedDemoPosition =
    TradeAdvancedDemoPosition(
      id: 'pos1',
      pair: 'BTC/USDT',
      side: 'long',
      currentSize: .5,
      currentPnl: 1250,
      markPrice: 67543.21,
      entryPrice: 65200,
      currentMargin: 6520,
      availableBalance: 5000,
      liquidationPrice: 52160,
    );

const List<TradeAdvancedDemoAction> _advancedDemoPositionActions = [
  TradeAdvancedDemoAction(
    id: 'partial-close',
    label: 'Partial Close Position (25%/50%/75%/100%)',
    description: 'Close a controlled percentage of the current position.',
  ),
  TradeAdvancedDemoAction(
    id: 'ladder-tpsl',
    label: 'Ladder TP/SL (Multiple Levels)',
    description: 'Split take-profit and stop-loss into multiple levels.',
  ),
  TradeAdvancedDemoAction(
    id: 'trailing-stop',
    label: 'Trailing Stop Loss',
    description: 'Move stop distance automatically as price moves.',
  ),
  TradeAdvancedDemoAction(
    id: 'margin-adjust',
    label: 'Add/Reduce Margin',
    description: 'Adjust margin allocation without leaving the position.',
  ),
];

const List<TradeAdvancedDemoAction> _advancedDemoOrderTypes = [
  TradeAdvancedDemoAction(
    id: 'market',
    label: 'Market',
    description: 'Khớp ngay lập tức với giá tốt nhất',
  ),
  TradeAdvancedDemoAction(
    id: 'limit',
    label: 'Limit',
    description: 'Đặt giá mong muốn, chờ khớp',
  ),
  TradeAdvancedDemoAction(
    id: 'stop-market',
    label: 'Stop Market',
    description: 'Kích hoạt Market khi chạm trigger',
  ),
  TradeAdvancedDemoAction(
    id: 'stop-limit',
    label: 'Stop Limit',
    description: 'Kích hoạt Limit khi chạm trigger',
  ),
];

const List<TradeAdvancedDemoAction> _advancedDemoTimeInForce = [
  TradeAdvancedDemoAction(
    id: 'GTC',
    label: 'GTC',
    description: 'Good Till Cancel',
  ),
  TradeAdvancedDemoAction(
    id: 'IOC',
    label: 'IOC',
    description: 'Immediate or Cancel',
  ),
  TradeAdvancedDemoAction(id: 'FOK', label: 'FOK', description: 'Fill or Kill'),
  TradeAdvancedDemoAction(
    id: 'GTX',
    label: 'Post-Only',
    description: 'Maker only',
  ),
];

const List<TradeAdvancedDemoMetric> _advancedDemoOrderSummary = [
  TradeAdvancedDemoMetric(label: 'Order Type', value: 'LIMIT'),
  TradeAdvancedDemoMetric(label: 'Time In Force', value: 'GTC'),
  TradeAdvancedDemoMetric(label: 'Reduce-Only', value: 'No'),
  TradeAdvancedDemoMetric(label: 'Iceberg', value: 'Disabled'),
];

const List<TradeAdvancedDemoMetric> _advancedDemoPnlSummary = [
  TradeAdvancedDemoMetric(
    label: 'Realized PnL',
    value: '+\$3,250.50',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Unrealized PnL',
    value: '+\$1,250.00',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Equity',
    value: '\$15,000.00',
    tone: TradeAdvancedMetricTone.accent,
  ),
];

const List<TradeAdvancedDemoMetric> _advancedDemoPerformanceMetrics = [
  TradeAdvancedDemoMetric(label: 'Total Trades', value: '47'),
  TradeAdvancedDemoMetric(
    label: 'Win Rate',
    value: '68.1%',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Profit',
    value: '+\$8,450.00',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Loss',
    value: '-\$3,200.00',
    tone: TradeAdvancedMetricTone.negative,
  ),
  TradeAdvancedDemoMetric(label: 'Avg Win', value: '\$264.06'),
  TradeAdvancedDemoMetric(label: 'Avg Loss', value: '-\$213.33'),
];

const TradeMarketOpenInterest _marketOpenInterest = TradeMarketOpenInterest(
  current: 25680000000,
  change24h: 1250000000,
  change24hPct: 5.12,
  high24h: 26100000000,
  low24h: 24500000000,
);

const TradeMarketLongShortRatio _marketLongShortRatio =
    TradeMarketLongShortRatio(
      longPct: 62.5,
      shortPct: 37.5,
      longAccounts: 125400,
      shortAccounts: 75200,
      longVolume: 18500000000,
      shortVolume: 11200000000,
    );

const TradeTopTraderPositions _marketTopTraders = TradeTopTraderPositions(
  longPct: 58.3,
  shortPct: 41.7,
  change24h: 3.2,
);

const TradeFundingRateHistory _marketFundingRate = TradeFundingRateHistory(
  currentRatePct: .010,
  avgRatePct: -.001,
  rangePct: .014,
  nextFundingLabel: '02:00',
  historyPct: [
    .006,
    .001,
    -.003,
    .010,
    .009,
    .006,
    .006,
    .004,
    .001,
    -.002,
    .010,
    .003,
    .002,
    .005,
    .007,
    -.003,
    .002,
    .005,
    .001,
    -.001,
    .008,
    .001,
    .002,
    .002,
  ],
);

const TradeMarketOpenInterest _liveMarketOpenInterest = TradeMarketOpenInterest(
  current: 25433440000,
  change24h: -246560000,
  change24hPct: -.96,
  high24h: 25433440000,
  low24h: 25433440000,
);

const TradeMarketLongShortRatio _liveMarketLongShortRatio =
    TradeMarketLongShortRatio(
      longPct: 61.6,
      shortPct: 38.4,
      longAccounts: 127093,
      shortAccounts: 79033,
      longVolume: 18020000000,
      shortVolume: 11240000000,
    );

const TradeTopTraderPositions _liveMarketTopTraders = TradeTopTraderPositions(
  longPct: 57.7,
  shortPct: 42.3,
  change24h: -.6,
);

const TradeFundingRateHistory _liveMarketFundingRate = TradeFundingRateHistory(
  currentRatePct: .010,
  avgRatePct: -.003,
  rangePct: .014,
  nextFundingLabel: '01:29',
  historyPct: [
    .007,
    .003,
    .006,
    -.003,
    -.002,
    .000,
    .003,
    .008,
    -.004,
    .003,
    -.001,
    -.003,
    -.003,
    .004,
    -.001,
    -.004,
    .005,
    -.001,
    .001,
    -.001,
    .008,
    -.003,
    .002,
    -.002,
  ],
);

const TradeLiquidationStats _marketLiquidationStats = TradeLiquidationStats(
  total24h: 320000000,
  long24h: 185000000,
  short24h: 135000000,
  largest24h: 2500000,
  avg24h: 45000,
  count24h: 7120,
  total7d: 1850000000,
  count7d: 42300,
  total30d: 6200000000,
  count30d: 158000,
);

const List<TradeLiquidationCluster> _marketLiquidationClusters = [
  TradeLiquidationCluster(
    price: 70000,
    longLiquidations: 45000000,
    shortLiquidations: 12000000,
    total: 57000000,
    intensity: 95,
  ),
  TradeLiquidationCluster(
    price: 68500,
    longLiquidations: 32000000,
    shortLiquidations: 8000000,
    total: 40000000,
    intensity: 70,
  ),
  TradeLiquidationCluster(
    price: 67543,
    longLiquidations: 0,
    shortLiquidations: 0,
    total: 0,
    intensity: 0,
  ),
  TradeLiquidationCluster(
    price: 66000,
    longLiquidations: 15000000,
    shortLiquidations: 28000000,
    total: 43000000,
    intensity: 75,
  ),
  TradeLiquidationCluster(
    price: 65000,
    longLiquidations: 8000000,
    shortLiquidations: 52000000,
    total: 60000000,
    intensity: 100,
  ),
  TradeLiquidationCluster(
    price: 64000,
    longLiquidations: 12000000,
    shortLiquidations: 35000000,
    total: 47000000,
    intensity: 80,
  ),
];

const List<TradeRecentLiquidation> _marketRecentLiquidations = [
  TradeRecentLiquidation(
    id: 'liq-1',
    timeLabel: '45s ago',
    pair: 'BTC/USDT',
    side: 'long',
    size: 486000,
    price: 67180,
    exchange: 'Binance',
  ),
  TradeRecentLiquidation(
    id: 'liq-2',
    timeLabel: '1m ago',
    pair: 'ETH/USDT',
    side: 'short',
    size: 224000,
    price: 3538,
    exchange: 'Binance',
  ),
  TradeRecentLiquidation(
    id: 'liq-3',
    timeLabel: '2m ago',
    pair: 'BTC/USDT',
    side: 'short',
    size: 128000,
    price: 67810,
    exchange: 'Binance',
  ),
];
