part of '../repositories/mock_trade_copy_trading_repository.dart';

// Standalone stand-in for `getTrade()` (the core spot-trading fixture, owned
// by `features/trade`'s own mock repository). `getProviderLeaderboard()`,
// `getProviderGovernance()`, and `getProviderApplication()` each embed a
// `TradeScreenSnapshot` in their response for parity with other trade
// domain snapshots, but no page or test reads that field — it exists only
// to satisfy each snapshot's `.trade` field type. `trade_copy` must not
// depend back on `trade`'s private spot-trading fixtures (that would invert
// the intended extraction direction), so this is a small, self-contained
// placeholder rather than a call to `getTrade()`.
const TradeScreenSnapshot _providerDiscoveryTradeSnapshot = TradeScreenSnapshot(
  pair: TradePair(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    price: 67543.21,
    changePct: 1.8,
    logoColorHex: 0xFFF7931A,
  ),
  pairs: [
    TradePair(
      id: 'btcusdt',
      symbol: 'BTC/USDT',
      baseAsset: 'BTC',
      quoteAsset: 'USDT',
      price: 67543.21,
      changePct: 1.8,
      logoColorHex: 0xFFF7931A,
    ),
  ],
  orderBook: TradeOrderBook(bids: [], asks: []),
  trades: [],
  orders: [],
  positions: [],
  copyProviders: [],
  botStrategies: [],
  balances: TradeBalances(usdtAvailable: 0, baseAvailable: 0),
  lastUpdatedLabel: 'realtime-refresh',
  supportedStates: [
    TradeScreenState.loading,
    TradeScreenState.empty,
    TradeScreenState.error,
    TradeScreenState.offline,
    TradeScreenState.realtimeRefresh,
  ],
);

// The three providers currently selected for comparison. Ids/names/metrics
// mirror `_copyTraders` ct001..ct003 so the leaderboard and the comparison
// table never disagree about the same provider.
const List<TradeProviderComparisonProvider> _providerComparisonProviders = [
  TradeProviderComparisonProvider(
    id: 'ct001',
    name: 'AlphaHunter_VN',
    avatar: 'A',
  ),
  TradeProviderComparisonProvider(
    id: 'ct002',
    name: 'SteadyGains_Pro',
    avatar: 'S',
  ),
  TradeProviderComparisonProvider(
    id: 'ct003',
    name: 'RiskMaster_88',
    avatar: 'R',
  ),
];

const List<TradeProviderComparisonMetric> _providerComparisonMetrics = [
  TradeProviderComparisonMetric(
    label: 'Total ROI',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {'ct001': '+342.5%', 'ct002': '+187.2%', 'ct003': '+567.8%'},
  ),
  TradeProviderComparisonMetric(
    label: '30D Return',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {'ct001': '+18.4%', 'ct002': '+9.6%', 'ct003': '+32.1%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Win Rate',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {'ct001': '78.5%', 'ct002': '82.3%', 'ct003': '65.2%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Trade',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {'ct001': '+1.2%', 'ct002': '+0.9%', 'ct003': '+2.6%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Sharpe Ratio',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: true,
    values: {'ct001': '2.31', 'ct002': '3.12', 'ct003': '1.85'},
  ),
  // Drawdown values are signed (app-wide display convention), so the value
  // closest to zero is numerically the HIGHEST: -8.1% > -28.3%.
  TradeProviderComparisonMetric(
    label: 'Max Drawdown',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: true,
    values: {'ct001': '-12.4%', 'ct002': '-8.1%', 'ct003': '-28.3%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Volatility',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {'ct001': '4.2%', 'ct002': '1.8%', 'ct003': '9.6%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Risk Score',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {'ct001': '6.5', 'ct002': '3.2', 'ct003': '8.7'},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Slippage',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: false,
    values: {'ct001': '0.08%', 'ct002': '0.05%', 'ct003': '0.15%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Delay',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: false,
    values: {'ct001': '0.8s', 'ct002': '0.5s', 'ct003': '1.2s'},
  ),
  TradeProviderComparisonMetric(
    label: 'Fill Rate',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: true,
    values: {'ct001': '98.2%', 'ct002': '99.1%', 'ct003': '96.5%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Performance Fee',
    category: TradeProviderComparisonCategory.cost,
    higherIsBetter: false,
    values: {'ct001': '10%', 'ct002': '8%', 'ct003': '15%'},
  ),
  TradeProviderComparisonMetric(
    label: 'Est. Monthly Cost',
    category: TradeProviderComparisonCategory.cost,
    higherIsBetter: false,
    values: {'ct001': '\$24.50', 'ct002': '\$18.20', 'ct003': '\$45.80'},
  ),
];

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

const List<TradeProviderLeaderboardSort> _providerLeaderboardSortOptions = [
  TradeProviderLeaderboardSort(id: 'roi', label: 'ROI'),
  TradeProviderLeaderboardSort(id: 'sharpe', label: 'Sharpe'),
  TradeProviderLeaderboardSort(id: 'followers', label: 'Followers'),
  TradeProviderLeaderboardSort(id: 'recent', label: '30D'),
];

const List<TradeProviderLeaderboardRiskFilter> _providerLeaderboardRiskFilters =
    [
      TradeProviderLeaderboardRiskFilter(id: 'all', label: 'All'),
      TradeProviderLeaderboardRiskFilter(
        id: 'low',
        label: 'Low',
        riskLevel: TradeCopyRiskLevel.low,
      ),
      TradeProviderLeaderboardRiskFilter(
        id: 'medium',
        label: 'Medium',
        riskLevel: TradeCopyRiskLevel.medium,
      ),
      TradeProviderLeaderboardRiskFilter(
        id: 'high',
        label: 'High',
        riskLevel: TradeCopyRiskLevel.high,
      ),
    ];

const List<TradeProviderGovernanceTab> _providerGovernanceTabs = [
  TradeProviderGovernanceTab(id: 'modifications', label: 'Modifications'),
  TradeProviderGovernanceTab(id: 'communication', label: 'Communication'),
  TradeProviderGovernanceTab(id: 'fees', label: 'Fees'),
  TradeProviderGovernanceTab(id: 'compliance', label: 'Compliance'),
];

const List<TradeStrategyModification> _strategyModifications = [
  TradeStrategyModification(
    id: 'mod-1',
    date: '2026-03-05',
    type: 'strategy_change',
    oldValue: 'Swing Trading',
    newValue: 'Scalping',
    notificationSent: true,
    followerImpact: 245,
  ),
  TradeStrategyModification(
    id: 'mod-2',
    date: '2026-02-15',
    type: 'risk_level',
    oldValue: 'Medium',
    newValue: 'High',
    notificationSent: true,
    followerImpact: 180,
  ),
  TradeStrategyModification(
    id: 'mod-3',
    date: '2026-01-20',
    type: 'fee_structure',
    oldValue: '15% performance fee',
    newValue: '10% performance fee',
    notificationSent: true,
    followerImpact: 320,
  ),
];

const List<TradeFollowerMessage> _followerMessages = [
  TradeFollowerMessage(
    id: 'msg-1',
    date: '2026-03-04',
    subject: 'Strategy Change Notification: Swing → Scalping',
    body:
        'Dear followers, effective March 5, I will be switching from swing trading to scalping...',
    recipients: 245,
    openRate: 78,
  ),
  TradeFollowerMessage(
    id: 'msg-2',
    date: '2026-02-14',
    subject: 'Risk Level Adjustment Notice',
    body:
        'I am increasing my risk level to capture more opportunities in the current market...',
    recipients: 180,
    openRate: 85,
  ),
];

const List<TradeFeeContributor> _feeContributors = [
  TradeFeeContributor(name: 'Follower #001', profit: 450, fee: 45),
  TradeFeeContributor(name: 'Follower #023', profit: 380, fee: 38),
  TradeFeeContributor(name: 'Follower #045', profit: 320, fee: 32),
  TradeFeeContributor(name: 'Follower #067', profit: 280, fee: 28),
  TradeFeeContributor(name: 'Follower #089', profit: 250, fee: 25),
];

const List<TradeComplianceItem> _complianceItems = [
  TradeComplianceItem(
    item: 'KYC verification up-to-date',
    status: true,
    lastCheck: '2026-03-01',
  ),
  TradeComplianceItem(
    item: 'Risk disclosure accurate',
    status: true,
    lastCheck: '2026-03-05',
  ),
  TradeComplianceItem(
    item: 'Fee structure transparent',
    status: true,
    lastCheck: '2026-02-28',
  ),
  TradeComplianceItem(
    item: 'No conflicts of interest undisclosed',
    status: true,
    lastCheck: '2026-03-01',
  ),
  TradeComplianceItem(
    item: 'Strategy description current',
    status: true,
    lastCheck: '2026-03-05',
  ),
  TradeComplianceItem(
    item: 'Communication obligations met',
    status: true,
    lastCheck: '2026-03-08',
  ),
];

const List<TradeProviderBenefit> _providerApplicationBenefits = [
  TradeProviderBenefit(
    iconName: 'dollar',
    title: 'Performance Fee',
    description: 'Nhận 10-30% từ lợi nhuận của copiers',
  ),
  TradeProviderBenefit(
    iconName: 'users',
    title: 'Xây dựng danh tiếng',
    description: 'Trở thành trader được công nhận',
  ),
  TradeProviderBenefit(
    iconName: 'trend',
    title: 'Không giới hạn thu nhập',
    description: 'Thu nhập tăng theo số người copy',
  ),
];

const List<String> _providerApplicationResponsibilities = [
  'Bạn phải công khai tất cả rủi ro và strategy changes',
  'Bạn chịu trách nhiệm với chất lượng trading',
  'Không được market manipulation hoặc wash trading',
  'Vi phạm sẽ bị cấm vĩnh viễn và xử lý pháp lý',
];

const List<TradeProviderRequirement> _providerApplicationRequirements = [
  TradeProviderRequirement(label: 'KYC Level 2', met: false),
  TradeProviderRequirement(label: 'Trading history ≥6 tháng', met: false),
  TradeProviderRequirement(label: 'Vốn tối thiểu \$10,000', met: false),
  TradeProviderRequirement(label: 'Sharpe Ratio >1.0', met: false),
];

const TradeProviderApplicationDraft _defaultProviderApplicationDraft =
    TradeProviderApplicationDraft(
      hasKyc: false,
      tradingMonths: 0,
      minCapital: 10000,
      performanceFee: 10,
      agreedToDisclosure: false,
      agreedToFiduciary: false,
      agreedToTerms: false,
      strategyDescription: '',
    );

const List<TradePreCopyQuestion> _preCopyQuestions = [
  TradePreCopyQuestion(
    id: 'experience',
    question: 'Kinh nghiệm giao dịch của bạn?',
    description: 'Đánh giá mức độ am hiểu về thị trường crypto',
    options: [
      TradePreCopyOption(
        value: 'none',
        label: 'Chưa từng giao dịch crypto',
        score: 0,
      ),
      TradePreCopyOption(
        value: 'beginner',
        label: 'Mới bắt đầu dưới 6 tháng',
        score: 5,
      ),
      TradePreCopyOption(
        value: 'intermediate',
        label: 'Trung bình 6 tháng - 2 năm',
        score: 12,
      ),
      TradePreCopyOption(
        value: 'advanced',
        label: 'Có kinh nghiệm trên 2 năm',
        score: 20,
      ),
    ],
  ),
  TradePreCopyQuestion(
    id: 'loss_awareness',
    question: 'Bạn hiểu rủi ro mất vốn như thế nào?',
    description: 'Copy Trading có thể làm mất toàn bộ số tiền đầu tư',
    options: [
      TradePreCopyOption(
        value: 'no_loss',
        label: 'Provider ROI cao nên chắc chắn lời',
        score: 0,
      ),
      TradePreCopyOption(
        value: 'partial',
        label: 'Có thể mất một phần vốn',
        score: 5,
      ),
      TradePreCopyOption(
        value: 'understand',
        label: 'Có thể mất toàn bộ vốn',
        score: 20,
      ),
    ],
  ),
];

const List<TradePreCopyEducationDoc> _preCopyEducationDocs = [
  TradePreCopyEducationDoc(
    id: 'how_it_works',
    title: 'Copy Trading hoạt động như thế nào?',
    duration: '2 phút',
  ),
  TradePreCopyEducationDoc(
    id: 'risks',
    title: 'Rủi ro của Copy Trading',
    duration: '2 phút',
  ),
  TradePreCopyEducationDoc(
    id: 'best_practices',
    title: 'Nguyên tắc đầu tư an toàn',
    duration: '2 phút',
  ),
];
