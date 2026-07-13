part of '../repositories/mock_trade_regulatory_repository.dart';

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

const List<TradeArmConnection> _armConnections = [
  TradeArmConnection(
    id: 'arm-1',
    provider: 'REGIS-TR',
    region: 'EU (Frankfurt)',
    status: 'healthy',
    uptime: 99.97,
    avgLatency: 18,
    currentLatency: 16,
    lastCheck: '5:45:00 PM',
    isPrimary: true,
    endpoint: 'https://api.regis-tr.com/v2',
    certExpiry: '2026-12-31',
  ),
  TradeArmConnection(
    id: 'arm-2',
    provider: 'UnaVista',
    region: 'UK (London)',
    status: 'healthy',
    uptime: 99.95,
    avgLatency: 22,
    currentLatency: 20,
    lastCheck: '5:45:05 PM',
    isPrimary: false,
    endpoint: 'https://api.unavista.com/mifid',
    certExpiry: '2026-11-15',
  ),
  TradeArmConnection(
    id: 'arm-3',
    provider: 'Bloomberg',
    region: 'US (New York)',
    status: 'degraded',
    uptime: 98.50,
    avgLatency: 15,
    currentLatency: 45,
    lastCheck: '5:44:50 PM',
    isPrimary: false,
    endpoint: 'https://bpipe.bloomberg.com/arm',
    certExpiry: '2027-03-20',
  ),
];

const List<TradeArmLatencyPoint> _armLatencyHistory = [
  TradeArmLatencyPoint(time: '10:30', registr: 18, unavista: 22, bloomberg: 15),
  TradeArmLatencyPoint(time: '10:35', registr: 16, unavista: 21, bloomberg: 17),
  TradeArmLatencyPoint(time: '10:40', registr: 19, unavista: 23, bloomberg: 42),
  TradeArmLatencyPoint(time: '10:45', registr: 16, unavista: 20, bloomberg: 45),
];

const TradeArmSlaMetrics _armSlaMetrics = TradeArmSlaMetrics(
  uptime: 99.97,
  latencyAvg: 18,
  failoverReadiness: 100,
);

const List<TradeExecutionVenue> _bestExecutionVenues = [
  TradeExecutionVenue(
    rank: 1,
    venue: 'Binance',
    volume: 12450,
    value: 852000000,
    avgPrice: 68450,
    avgCost: 0.08,
    avgSpeed: 0.3,
    fillRate: 99.8,
    score: 96.5,
  ),
  TradeExecutionVenue(
    rank: 2,
    venue: 'Coinbase Pro',
    volume: 8920,
    value: 610000000,
    avgPrice: 68400,
    avgCost: 0.12,
    avgSpeed: 0.5,
    fillRate: 99.5,
    score: 94.2,
  ),
  TradeExecutionVenue(
    rank: 3,
    venue: 'Kraken',
    volume: 6780,
    value: 465000000,
    avgPrice: 68550,
    avgCost: 0.10,
    avgSpeed: 0.4,
    fillRate: 99.3,
    score: 93.8,
  ),
  TradeExecutionVenue(
    rank: 4,
    venue: 'Bybit',
    volume: 4560,
    value: 312000000,
    avgPrice: 68500,
    avgCost: 0.09,
    avgSpeed: 0.35,
    fillRate: 98.9,
    score: 92.1,
  ),
  TradeExecutionVenue(
    rank: 5,
    venue: 'OKX',
    volume: 3920,
    value: 268000000,
    avgPrice: 68600,
    avgCost: 0.11,
    avgSpeed: 0.45,
    fillRate: 98.5,
    score: 90.5,
  ),
];

const List<TradeQuarterlyReport> _bestExecutionArchive = [
  TradeQuarterlyReport(
    id: 'Q1-2026',
    quarter: 'Q1',
    year: 2026,
    period: 'Jan 1 - Mar 31, 2026',
    totalOrders: 36630,
    totalValue: 2507000000,
    publishDate: '2026-04-15',
    status: 'draft',
  ),
  TradeQuarterlyReport(
    id: 'Q4-2025',
    quarter: 'Q4',
    year: 2025,
    period: 'Oct 1 - Dec 31, 2025',
    totalOrders: 32450,
    totalValue: 2210000000,
    publishDate: '2026-01-15',
    status: 'published',
  ),
  TradeQuarterlyReport(
    id: 'Q3-2025',
    quarter: 'Q3',
    year: 2025,
    period: 'Jul 1 - Sep 30, 2025',
    totalOrders: 28900,
    totalValue: 1980000000,
    publishDate: '2025-10-15',
    status: 'published',
  ),
];

const TradeBestExecutionSummary _bestExecutionSummary =
    TradeBestExecutionSummary(
      totalOrders: 36630,
      totalValue: 2507000000,
      avgScore: 93.4,
    );

const List<TradeExecutionVenueAnalysisMetric> _executionVenueMetrics = [
  TradeExecutionVenueAnalysisMetric(
    venue: 'Binance',
    volume: 12450,
    value: 852000000,
    avgFee: 0.08,
    avgSpread: 2.5,
    marketImpact: 1.2,
    totalCost: 3.88,
    avgLatency: 45,
    avgFillTime: 0.3,
    fillRate: 99.8,
    liquidity: 250,
    reliability: 99.95,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'Coinbase Pro',
    volume: 8920,
    value: 610000000,
    avgFee: 0.12,
    avgSpread: 3.0,
    marketImpact: 1.5,
    totalCost: 4.82,
    avgLatency: 65,
    avgFillTime: 0.5,
    fillRate: 99.5,
    liquidity: 180,
    reliability: 99.90,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'Kraken',
    volume: 6780,
    value: 465000000,
    avgFee: 0.10,
    avgSpread: 2.8,
    marketImpact: 1.3,
    totalCost: 4.30,
    avgLatency: 55,
    avgFillTime: 0.4,
    fillRate: 99.3,
    liquidity: 150,
    reliability: 99.85,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'Bybit',
    volume: 4560,
    value: 312000000,
    avgFee: 0.09,
    avgSpread: 2.6,
    marketImpact: 1.4,
    totalCost: 4.19,
    avgLatency: 50,
    avgFillTime: 0.35,
    fillRate: 98.9,
    liquidity: 120,
    reliability: 99.80,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'OKX',
    volume: 3920,
    value: 268000000,
    avgFee: 0.11,
    avgSpread: 3.2,
    marketImpact: 1.6,
    totalCost: 5.01,
    avgLatency: 60,
    avgFillTime: 0.45,
    fillRate: 98.5,
    liquidity: 100,
    reliability: 99.75,
  ),
];

const List<TradeExecutionVenueCostTrend> _executionVenueCostTrends = [
  TradeExecutionVenueCostTrend(
    month: 'Nov',
    binance: 3.9,
    coinbase: 4.9,
    kraken: 4.4,
  ),
  TradeExecutionVenueCostTrend(
    month: 'Dec',
    binance: 3.85,
    coinbase: 4.85,
    kraken: 4.35,
  ),
  TradeExecutionVenueCostTrend(
    month: 'Jan',
    binance: 3.88,
    coinbase: 4.82,
    kraken: 4.30,
  ),
];

const TradeExecutionVenueAnalysisSummary _executionVenueSummary =
    TradeExecutionVenueAnalysisSummary(
      totalVenues: 5,
      avgTotalCost: 4.44,
      avgFillTime: 0.40,
    );

const List<TradeSlippageEvent> _slippageEvents = [
  TradeSlippageEvent(
    id: 'slip-1',
    time: '5:45:23 PM',
    provider: 'AlphaTrader',
    instrument: 'BTC/USDT',
    side: 'buy',
    expectedPrice: 68500,
    executedPrice: 68550,
    slippageBps: 7.3,
    slippagePct: 0.073,
    volume: 0.5,
    value: 34275,
    severity: 'normal',
  ),
  TradeSlippageEvent(
    id: 'slip-2',
    time: '5:42:11 PM',
    provider: 'BetaTrader',
    instrument: 'ETH/USDT',
    side: 'sell',
    expectedPrice: 3825,
    executedPrice: 3780,
    slippageBps: 117.6,
    slippagePct: 1.176,
    volume: 10,
    value: 37800,
    severity: 'critical',
  ),
  TradeSlippageEvent(
    id: 'slip-3',
    time: '5:40:45 PM',
    provider: 'AlphaTrader',
    instrument: 'SOL/USDT',
    side: 'buy',
    expectedPrice: 125.5,
    executedPrice: 125.8,
    slippageBps: 23.9,
    slippagePct: 0.239,
    volume: 100,
    value: 12580,
    severity: 'normal',
  ),
  TradeSlippageEvent(
    id: 'slip-4',
    time: '5:38:33 PM',
    provider: 'GammaTrader',
    instrument: 'BTC/USDT',
    side: 'sell',
    expectedPrice: 68600,
    executedPrice: 68250,
    slippageBps: 51.0,
    slippagePct: 0.510,
    volume: 0.25,
    value: 17062.5,
    severity: 'warning',
  ),
  TradeSlippageEvent(
    id: 'slip-5',
    time: '5:35:12 PM',
    provider: 'AlphaTrader',
    instrument: 'BTC/USDT',
    side: 'buy',
    expectedPrice: 68550,
    executedPrice: 68570,
    slippageBps: 2.9,
    slippagePct: 0.029,
    volume: 1.0,
    value: 68570,
    severity: 'normal',
  ),
];

const List<TradeSlippageProviderStats> _slippageProviderStats = [
  TradeSlippageProviderStats(
    provider: 'AlphaTrader',
    avgSlippage: 11.4,
    maxSlippage: 23.9,
    eventCount: 145,
    warningCount: 8,
    criticalCount: 1,
    totalImpact: 2450,
  ),
  TradeSlippageProviderStats(
    provider: 'BetaTrader',
    avgSlippage: 45.2,
    maxSlippage: 117.6,
    eventCount: 89,
    warningCount: 15,
    criticalCount: 5,
    totalImpact: 8920,
  ),
  TradeSlippageProviderStats(
    provider: 'GammaTrader',
    avgSlippage: 28.3,
    maxSlippage: 51.0,
    eventCount: 67,
    warningCount: 12,
    criticalCount: 2,
    totalImpact: 4560,
  ),
];

const List<TradeSlippageHistoryPoint> _slippageHistory = [
  TradeSlippageHistoryPoint(date: '03-02', avg: 15.2, max: 48.5),
  TradeSlippageHistoryPoint(date: '03-03', avg: 18.3, max: 52.1),
  TradeSlippageHistoryPoint(date: '03-04', avg: 22.1, max: 68.9),
  TradeSlippageHistoryPoint(date: '03-05', avg: 19.7, max: 55.3),
  TradeSlippageHistoryPoint(date: '03-06', avg: 16.8, max: 45.2),
  TradeSlippageHistoryPoint(date: '03-07', avg: 21.5, max: 62.7),
  TradeSlippageHistoryPoint(date: '03-08', avg: 28.3, max: 117.6),
];

const TradeSlippageSummary _slippageSummary = TradeSlippageSummary(
  total: 5,
  normal: 3,
  warning: 1,
  critical: 1,
  avgSlippage: 40.5,
  maxSlippage: 117.6,
);
