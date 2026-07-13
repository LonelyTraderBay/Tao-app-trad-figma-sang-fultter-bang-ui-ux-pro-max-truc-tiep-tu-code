part of '../repositories/mock_trade_copy_trading_repository.dart';

// Standalone stand-in for `getTrade()` (the core spot-trading fixture, owned
// by `features/trade`'s own mock repository). Several copy-trading
// lifecycle snapshots (`getCopyTrading`, `getCopyEducation`,
// `getActiveCopies`, `getCopySettings`, `getCopyNotifications`,
// `getSafetyEducation`, `getDisputeResolution`, `getCopySafetyCenter`) embed
// a `TradeScreenSnapshot` in their response for parity with other trade
// domain snapshots. Most fields are decorative and unread, but
// `getCopyTrading`/`getCopyEducation`/`getActiveCopies`/`getCopySettings`
// tests (SC-063/SC-065/SC-066/SC-067) assert `snapshot.trade.copyProviders`
// is non-empty, so that field mirrors `getTrade()`'s real value below.
// `trade_copy` must not depend back on `trade`'s private spot-trading
// fixtures (that would invert the intended extraction direction), so this
// is a small, self-contained placeholder rather than a call to
// `getTrade()`.
const TradeScreenSnapshot _copyLifecycleTradeSnapshot = TradeScreenSnapshot(
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
  copyProviders: ['AlphaQuant', 'Delta Scalper'],
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

const List<String> _copyTradingSortOptions = [
  'Top ROI',
  'Ổn định nhất',
  'Nhiều copier',
  'AUM cao',
];

const List<TradeCopyEducationTab> _copyEducationTabs = [
  TradeCopyEducationTab(id: 'how-it-works', label: 'Cơ chế'),
  TradeCopyEducationTab(id: 'scenarios', label: 'Kịch bản'),
  TradeCopyEducationTab(id: 'fees', label: 'Phí & Chi phí'),
  TradeCopyEducationTab(id: 'mistakes', label: 'Sai lầm'),
  TradeCopyEducationTab(id: 'regulatory', label: 'Quy định'),
];

const List<TradeCopyEducationStep> _copyEducationSteps = [
  TradeCopyEducationStep(
    number: 1,
    iconName: 'users',
    title: 'Chọn provider',
    description:
        'Bạn chọn một provider (trader) dựa trên hiệu suất, chiến lược và risk level. Provider phải được xác minh và công khai thông tin.',
  ),
  TradeCopyEducationStep(
    number: 2,
    iconName: 'target',
    title: 'Cấu hình sao chép',
    description:
        'Bạn chọn số tiền copy, tỷ lệ sao chép (vd: 50% = provider mở \$1000, bạn mở \$500), và các giới hạn rủi ro (stop-loss, take-profit).',
  ),
  TradeCopyEducationStep(
    number: 3,
    iconName: 'zap',
    title: 'Sao chép tự động',
    description:
        'Khi provider mở/đóng lệnh, hệ thống tự động sao chép vào tài khoản của bạn trong vòng 0.5-3 giây. Giá có thể khác nhau (slippage).',
  ),
  TradeCopyEducationStep(
    number: 4,
    iconName: 'activity',
    title: 'Theo dõi & điều chỉnh',
    description:
        'Bạn có thể xem real-time P/L, tắt copy bất cứ lúc nào, hoặc điều chỉnh cấu hình. Các vị thế đang mở vẫn theo provider cho đến khi đóng.',
  ),
];

const List<TradeCopyModeGuide> _copyModeGuides = [
  TradeCopyModeGuide(
    title: 'Mirror Copy',
    description:
        'Sao chép chính xác tỷ lệ vị thế. Provider mở 10% portfolio, bạn cũng mở 10%.',
    pro: 'Đơn giản, rủi ro tương tự provider',
    con: 'Không linh hoạt, phụ thuộc hoàn toàn vào provider',
    colorHex: 0xFF3B82F6,
  ),
  TradeCopyModeGuide(
    title: 'Fixed Ratio',
    description:
        'Bạn đặt tỷ lệ cố định (vd: 50%). Provider mở \$1000, bạn mở \$500.',
    pro: 'Kiểm soát vốn tốt hơn, dễ tính toán',
    con: 'Vẫn phụ thuộc vào timing của provider',
    colorHex: 0xFF10B981,
  ),
  TradeCopyModeGuide(
    title: 'Smart Copy',
    description:
        'Hệ thống điều chỉnh size dựa trên volatility và risk của từng trade.',
    pro: 'Tối ưu risk-adjusted returns',
    con: 'Phức tạp hơn, kết quả khác xa provider',
    colorHex: 0xFFF59E0B,
  ),
];

const List<TradeCopyConceptGuide> _copyConceptGuides = [
  TradeCopyConceptGuide(
    term: 'Slippage',
    iconName: 'down',
    description:
        'Chênh lệch giá giữa lệnh của provider và lệnh của bạn. Thường 0.05-0.2%. Trong thị trường biến động mạnh có thể lên 0.5-1%.',
  ),
  TradeCopyConceptGuide(
    term: 'High-Water Mark',
    iconName: 'up',
    description:
        'Provider chỉ nhận performance fee trên profit mới (vượt đỉnh cũ). Nếu tài khoản \$10k → \$12k → \$11k → \$13k, fee chỉ tính trên \$1k cuối.',
  ),
  TradeCopyConceptGuide(
    term: 'Position Sizing',
    iconName: 'target',
    description:
        'Cách tính kích thước vị thế sao chép. Mirror = tỷ lệ %, Fixed = số tiền cố định, Smart = dynamic dựa trên risk.',
  ),
  TradeCopyConceptGuide(
    term: 'Execution Delay',
    iconName: 'clock',
    description:
        'Thời gian từ khi provider mở lệnh đến khi lệnh của bạn execute. Thường 0.5-3 giây. Delay cao → slippage cao.',
  ),
];

const TradeCopySettings _defaultCopySettings = TradeCopySettings(
  defaultCopyMode: TradeCopySettingsMode.fixed,
  defaultCopyRatio: 50,
  defaultStopLoss: 10,
  defaultTakeProfit: 20,
  maxPortfolioAllocation: 20,
  maxCopiesActive: 5,
  enableCircuitBreaker: true,
  circuitBreakerThreshold: 15,
  notifyNewTrades: true,
  notifyPnlChanges: true,
  notifyRiskAlerts: true,
  notifyProviderUpdates: false,
  emailNotifications: true,
  pushNotifications: true,
  emergencyContact: '',
  emergencyPhone: '',
  showPortfolioPublic: false,
);

const List<TradeCopyNotification> _copyNotifications = [
  TradeCopyNotification(
    id: 'n1',
    type: TradeCopyNotificationType.risk,
    title: 'Cảnh báo rủi ro cao',
    message: 'Copy "CryptoKing" đang lỗ -8.5%, gần ngưỡng stop-loss -10%',
    timestamp: '5 phút trước',
    read: false,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    actionPath: '/trade/copy-trading/active',
    severity: TradeCopyNotificationSeverity.critical,
  ),
  TradeCopyNotification(
    id: 'n2',
    type: TradeCopyNotificationType.trade,
    title: 'Lệnh mới được copy',
    message: 'CryptoKing đã BUY 0.05 BTC @ \$67,800',
    timestamp: '15 phút trước',
    read: false,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    severity: TradeCopyNotificationSeverity.info,
    pair: 'BTC/USDT',
    side: TradeOrderSide.buy,
  ),
  TradeCopyNotification(
    id: 'n3',
    type: TradeCopyNotificationType.trade,
    title: 'Chốt lời thành công',
    message: 'Lệnh ETH/USDT đã đóng với lợi nhuận +\$45',
    timestamp: '1 giờ trước',
    read: false,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    severity: TradeCopyNotificationSeverity.info,
    pnl: 45,
    pair: 'ETH/USDT',
    side: TradeOrderSide.sell,
  ),
  TradeCopyNotification(
    id: 'n4',
    type: TradeCopyNotificationType.update,
    title: 'Provider cập nhật chiến lược',
    message: 'SwingMaster đã thông báo: "Tăng tỷ trọng BTC lên 60% portfolio"',
    timestamp: '2 giờ trước',
    read: true,
    providerId: 'trader-2',
    providerName: 'SwingMaster',
    severity: TradeCopyNotificationSeverity.warning,
  ),
  TradeCopyNotification(
    id: 'n5',
    type: TradeCopyNotificationType.system,
    title: 'Copy mới được kích hoạt',
    message: 'Copy "AlgoTrader" đã hết thời gian chờ 24h và được kích hoạt',
    timestamp: '3 giờ trước',
    read: true,
    providerId: 'trader-3',
    providerName: 'AlgoTrader',
    copyId: 'copy-3',
    severity: TradeCopyNotificationSeverity.info,
  ),
  TradeCopyNotification(
    id: 'n6',
    type: TradeCopyNotificationType.risk,
    title: 'Đã đạt ngưỡng take-profit',
    message:
        'Copy "CryptoKing" đã đạt +13%, bạn có muốn điều chỉnh take-profit?',
    timestamp: '5 giờ trước',
    read: true,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    severity: TradeCopyNotificationSeverity.warning,
  ),
  TradeCopyNotification(
    id: 'n7',
    type: TradeCopyNotificationType.system,
    title: 'Cập nhật hệ thống',
    message:
        'Copy Trading hiện hỗ trợ Trailing Stop. Xem chi tiết tại Settings.',
    timestamp: '1 ngày trước',
    read: true,
    severity: TradeCopyNotificationSeverity.info,
  ),
];

const List<TradeActiveCopy> _activeCopies = [
  TradeActiveCopy(
    id: 'copy-1',
    providerId: 'provider001',
    providerName: 'AlphaHunter_VN',
    providerAvatar: 'A',
    providerVerified: true,
    capital: 5000,
    currentValue: 5650,
    pnl: 650,
    pnlPct: 13,
    status: TradeActiveCopyStatus.active,
    startDate: '2026-02-15',
    copyMode: TradeActiveCopyMode.fixed,
    copyRatio: 50,
    trades: 48,
    winRate: 62.5,
    hasCustomStopLoss: true,
    stopLossLevel: 10,
    recentTrades: [
      TradeCopyRecentTrade(
        id: 't1',
        pair: 'BTC/USDT',
        side: TradeOrderSide.sell,
        size: .05,
        price: 68500,
        pnl: 45,
        timestamp: '2h ago',
      ),
      TradeCopyRecentTrade(
        id: 't2',
        pair: 'ETH/USDT',
        side: TradeOrderSide.buy,
        size: 2,
        price: 3850,
        pnl: -12,
        timestamp: '5h ago',
      ),
      TradeCopyRecentTrade(
        id: 't3',
        pair: 'BTC/USDT',
        side: TradeOrderSide.buy,
        size: .05,
        price: 67800,
        pnl: 35,
        timestamp: '8h ago',
      ),
    ],
    performanceHistory: [
      TradeCopyPerformancePoint(timestamp: 'Day 0', value: 5000),
      TradeCopyPerformancePoint(timestamp: 'Day 7', value: 5135),
      TradeCopyPerformancePoint(timestamp: 'Day 14', value: 5310),
      TradeCopyPerformancePoint(timestamp: 'Day 21', value: 5485),
      TradeCopyPerformancePoint(timestamp: 'Day 30', value: 5650),
    ],
  ),
  TradeActiveCopy(
    id: 'copy-2',
    providerId: 'provider002',
    providerName: 'SteadyGains_Pro',
    providerAvatar: 'S',
    providerVerified: true,
    capital: 3000,
    currentValue: 2850,
    pnl: -150,
    pnlPct: -5,
    status: TradeActiveCopyStatus.active,
    startDate: '2026-03-01',
    copyMode: TradeActiveCopyMode.mirror,
    trades: 22,
    winRate: 45.5,
    hasCustomStopLoss: false,
    recentTrades: [
      TradeCopyRecentTrade(
        id: 't4',
        pair: 'SOL/USDT',
        side: TradeOrderSide.sell,
        size: 10,
        price: 142,
        pnl: -35,
        timestamp: '1h ago',
      ),
      TradeCopyRecentTrade(
        id: 't5',
        pair: 'AVAX/USDT',
        side: TradeOrderSide.buy,
        size: 15,
        price: 38,
        pnl: 12,
        timestamp: '4h ago',
      ),
    ],
    performanceHistory: [
      TradeCopyPerformancePoint(timestamp: 'Day 0', value: 3000),
      TradeCopyPerformancePoint(timestamp: 'Day 7', value: 2960),
      TradeCopyPerformancePoint(timestamp: 'Day 14', value: 2925),
      TradeCopyPerformancePoint(timestamp: 'Day 21', value: 2875),
      TradeCopyPerformancePoint(timestamp: 'Day 30', value: 2850),
    ],
  ),
  TradeActiveCopy(
    id: 'copy-3',
    providerId: 'provider003',
    providerName: 'RiskMaster_88',
    providerAvatar: 'R',
    providerVerified: true,
    capital: 2000,
    currentValue: 2000,
    pnl: 0,
    pnlPct: 0,
    status: TradeActiveCopyStatus.coolingOff,
    startDate: '2026-03-08',
    copyMode: TradeActiveCopyMode.smart,
    trades: 0,
    winRate: 0,
    hasCustomStopLoss: true,
    stopLossLevel: 15,
    coolingOffUntil: '2026-03-09 14:30',
    recentTrades: [],
    performanceHistory: [
      TradeCopyPerformancePoint(timestamp: 'Day 0', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 7', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 14', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 21', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 30', value: 2000),
    ],
  ),
];

const List<TradeSafetyTab> _safetyEducationTabs = [
  TradeSafetyTab(id: 'scams', label: 'Scams phổ biến'),
  TradeSafetyTab(id: 'redflags', label: 'Red Flags'),
  TradeSafetyTab(id: 'verification', label: 'Verification'),
  TradeSafetyTab(id: 'report', label: 'Report'),
];

const List<TradeSafetyScamType> _safetyScams = [
  TradeSafetyScamType(
    id: 'guaranteed-returns',
    title: 'Hứa hẹn lợi nhuận đảm bảo',
    description: 'Provider hứa "đảm bảo 100% lời" hoặc "không bao giờ thua"',
    examples: [
      '"Copy tôi = lời chắc chắn"',
      '"Strategy win rate 100%"',
      '"Không risk, chỉ có reward"',
    ],
    howToAvoid: [
      'KHÔNG CÓ lợi nhuận đảm bảo trong trading',
      'Win rate 100% là impossible',
      'Mọi trading đều có risk',
    ],
  ),
  TradeSafetyScamType(
    id: 'fake-performance',
    title: 'Giả mạo hiệu suất',
    description: 'Provider edit screenshots hoặc chọn lọc trades để hiển thị',
    examples: [
      'Screenshots không có timestamps',
      'Chỉ show winning trades',
      'Performance quá khác biệt vs verified stats',
    ],
    howToAvoid: [
      'Chỉ tin verified stats trên platform',
      'Yêu cầu audit trail đầy đủ',
      'Kiểm tra Max DD và losing trades',
    ],
  ),
  TradeSafetyScamType(
    id: 'pump-dump',
    title: 'Pump & Dump scheme',
    description:
        'Provider hold coin trước, trade để pump price, rồi dump lên followers',
    examples: [
      'Trade altcoin volume thấp',
      'Entry ngay khi announce',
      'Provider sell ngay sau khi followers buy',
    ],
    howToAvoid: [
      'Kiểm tra Conflict of Interest disclosure',
      'Tránh providers trade low-liquidity coins',
      'Đọc trade history trước khi copy',
    ],
  ),
  TradeSafetyScamType(
    id: 'identity-theft',
    title: 'Giả danh trader nổi tiếng',
    description: 'Scammer tạo tài khoản fake nhận là trader nổi tiếng',
    examples: [
      'Username gần giống (ElonMusk vs ElonMuskk)',
      'Avatar copy từ social media',
      'Claim về achievements không verify được',
    ],
    howToAvoid: [
      'Chỉ follow verified accounts',
      'Check social media links',
      'Yêu cầu video verification',
    ],
  ),
  TradeSafetyScamType(
    id: 'exit-scam',
    title: 'Exit Scam',
    description:
        'Provider tích lũy followers, rồi open positions lớn ngược xu hướng để thua lỗ chủ ý',
    examples: [
      'Đột ngột all-in vào 1 trade ngược trend',
      'Không stop-loss trong điều kiện xấu',
      'Account biến mất sau 1 trade thua lớn',
    ],
    howToAvoid: [
      'Đặt stop-loss riêng',
      'Theo dõi position sizing',
      'Dừng copy nếu behavior thay đổi đột ngột',
    ],
  ),
];

const List<TradeSafetyRedFlag> _safetyRedFlags = [
  TradeSafetyRedFlag(
    id: 'rf-1',
    category: 'performance',
    flag: 'ROI quá cao so với risk (>100% với DD <10%)',
    severity: 'critical',
    explanation:
        'Risk/reward ratio unrealistic. Có thể fake hoặc sắp exit scam.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-2',
    category: 'performance',
    flag: 'Tất cả trades đều lời (win rate 100%)',
    severity: 'critical',
    explanation: 'Impossible trong trading thực tế. Chắc chắn là scam.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-3',
    category: 'behavior',
    flag: 'Hứa lợi nhuận cố định (VD: 5% mỗi tuần)',
    severity: 'critical',
    explanation:
        'Trading không thể có lợi nhuận cố định. Dấu hiệu Ponzi scheme.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-4',
    category: 'disclosure',
    flag: 'Không công khai Max Drawdown',
    severity: 'warning',
    explanation: 'Provider đang che giấu losses. Red flag lớn.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-5',
    category: 'behavior',
    flag: 'Trade chủ yếu low-liquidity coins',
    severity: 'warning',
    explanation: 'Có thể đang chuẩn bị pump & dump.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-6',
    category: 'disclosure',
    flag: 'Không tiết lộ Conflict of Interest',
    severity: 'warning',
    explanation: 'Provider có thể đang trade coins mình hold.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-7',
    category: 'behavior',
    flag: 'Thay đổi strategy đột ngột không announce',
    severity: 'caution',
    explanation: 'Thiếu minh bạch với followers.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-8',
    category: 'performance',
    flag: 'Sample size quá nhỏ (<50 trades)',
    severity: 'caution',
    explanation: 'Chưa đủ data để đánh giá. Có thể may mắn ngắn hạn.',
  ),
];

const List<TradeSafetyVerificationTier> _safetyVerificationTiers = [
  TradeSafetyVerificationTier(
    tier: 'Pro',
    colorHex: 0xFF8B5CF6,
    requirements: [
      'KYC Level 2 (ID + Selfie + PoA)',
      'Trading history ≥12 tháng verified',
      'Vốn tối thiểu \$50,000',
      'Sharpe Ratio >1.5',
      'Performance audit hàng tháng',
    ],
  ),
  TradeSafetyVerificationTier(
    tier: 'Verified',
    colorHex: 0xFF3B82F6,
    requirements: [
      'KYC Level 2',
      'Trading history ≥6 tháng',
      'Vốn tối thiểu \$10,000',
      'Sharpe Ratio >1.0',
      'Disclosure requirements đầy đủ',
    ],
  ),
  TradeSafetyVerificationTier(
    tier: 'Basic',
    colorHex: 0xFF6B7280,
    requirements: [
      'KYC Level 1 (Email + Phone)',
      'Không có performance audit',
      'KHÔNG khuyến nghị copy',
    ],
  ),
];

const List<String> _safetyReportReasons = [
  'Provider hứa lợi nhuận đảm bảo',
  'Phát hiện fake performance',
  'Bị lừa đảo hoặc scam',
  'Provider có hành vi market manipulation',
  'Vi phạm Terms of Service',
];

const List<TradeComplaintTypeOption> _disputeComplaintTypes = [
  TradeComplaintTypeOption(
    value: 'execution_issue',
    label: 'Execution Issue',
    description: 'Slippage, delay, or fill rate problems',
  ),
  TradeComplaintTypeOption(
    value: 'fee_discrepancy',
    label: 'Fee Discrepancy',
    description: 'Incorrect fee calculation or charge',
  ),
  TradeComplaintTypeOption(
    value: 'strategy_change',
    label: 'Strategy Change Without Notice',
    description: 'Provider changed strategy without 24h notice',
  ),
  TradeComplaintTypeOption(
    value: 'performance_data',
    label: 'Performance Data Inaccuracy',
    description: 'Suspicious or fake performance stats',
  ),
  TradeComplaintTypeOption(
    value: 'misconduct',
    label: 'Provider Misconduct',
    description: 'Unethical behavior or scam',
  ),
];

const List<TradeDisputeProviderOption> _disputeProviders = [
  TradeDisputeProviderOption(id: 'trader-1', name: 'CryptoKing'),
  TradeDisputeProviderOption(id: 'trader-2', name: 'SwingMaster'),
  TradeDisputeProviderOption(id: 'trader-3', name: 'AlgoTrader'),
];

const List<TradeDisputeCase> _activeDisputeCases = [
  TradeDisputeCase(
    id: 'case-001',
    providerId: 'trader-2',
    providerName: 'SwingMaster',
    complaintType: 'execution_issue',
    subject: 'Excessive slippage on BTC trade',
    description:
        'Provider executed at \$68,500 but my copy filled at \$68,750 (0.36% slippage)',
    status: 'under_review',
    submittedDate: '2026-03-06',
    updatedDate: '2026-03-07',
    estimatedResolution: '2026-03-10',
  ),
];

const List<TradeDisputeCase> _resolvedDisputeCases = [
  TradeDisputeCase(
    id: 'case-002',
    providerId: 'trader-3',
    providerName: 'AlgoTrader',
    complaintType: 'fee_discrepancy',
    subject: 'Charged 15% instead of 10%',
    description: 'My profit was \$100 but fee charged was \$15 instead of \$10',
    status: 'resolved',
    submittedDate: '2026-02-20',
    updatedDate: '2026-02-25',
    estimatedResolution: '2026-02-25',
    outcome: 'refund',
  ),
];

const List<TradeCopySafetyCenterTab> _copySafetyCenterTabs = [
  TradeCopySafetyCenterTab(id: 'verification', label: 'Verification'),
  TradeCopySafetyCenterTab(id: 'metrics', label: 'Metrics'),
  TradeCopySafetyCenterTab(id: 'guidelines', label: 'Guidelines'),
  TradeCopySafetyCenterTab(id: 'tools', label: 'Tools'),
  TradeCopySafetyCenterTab(id: 'enforcement', label: 'Enforcement'),
];

const List<TradeCopyVerificationTier> _copyVerificationTiers = [
  TradeCopyVerificationTier(
    tier: 'Basic',
    requirements: ['Email verification', 'Phone verification', 'KYC Level 1'],
    benefits: ['Can become provider', 'Basic provider features'],
    colorHex: 0xFF6B7280,
  ),
  TradeCopyVerificationTier(
    tier: 'Verified',
    requirements: [
      'All Basic requirements',
      'KYC Level 2 (ID + Selfie)',
      '6 months trading history',
      '\$10,000 minimum capital',
      'Full disclosure obligations',
    ],
    benefits: [
      'Verified badge',
      'Higher trust from followers',
      'Advanced provider features',
    ],
    colorHex: 0xFF3B82F6,
  ),
  TradeCopyVerificationTier(
    tier: 'Pro',
    requirements: [
      'All Verified requirements',
      'KYC Level 2 + Proof of Address',
      '12 months trading history',
      '\$50,000 minimum capital',
      'Sharpe Ratio > 1.5',
      'Monthly performance audit',
    ],
    benefits: [
      'Pro badge',
      'Priority support',
      'Featured in leaderboard',
      'Premium analytics',
    ],
    colorHex: 0xFF8B5CF6,
  ),
];

const List<TradeCopyTrustMetric> _copyTrustMetrics = [
  TradeCopyTrustMetric(
    name: 'Sharpe Ratio',
    description: 'Measures risk-adjusted return. Higher is better.',
    goodRange: '> 1.5 (excellent), 1.0-1.5 (good)',
    badRange: '< 1.0 (poor)',
    whyMatters: 'Shows if provider is taking smart risks or just gambling',
  ),
  TradeCopyTrustMetric(
    name: 'Max Drawdown',
    description: 'Largest peak-to-trough decline in account value.',
    goodRange: '< 15% (excellent), 15-25% (acceptable)',
    badRange: '> 25% (risky)',
    whyMatters: 'Indicates worst-case loss scenario. Can you handle it?',
  ),
  TradeCopyTrustMetric(
    name: 'Slippage',
    description:
        "Difference between provider's price and your execution price.",
    goodRange: '< 0.2% (excellent), 0.2-0.5% (acceptable)',
    badRange: '> 0.5% (poor execution)',
    whyMatters:
        'High slippage eats into your returns, especially in volatile markets',
  ),
  TradeCopyTrustMetric(
    name: 'Win Rate',
    description: 'Percentage of profitable trades.',
    goodRange: '> 60% (excellent), 50-60% (acceptable)',
    badRange: '< 50% (risky)',
    whyMatters: 'Combined with avg win/loss, shows strategy consistency',
  ),
];

const List<String> _copyProhibitedBehaviors = [
  'Wash trading (fake volume)',
  'Fake performance data',
  'Undisclosed conflicts of interest',
  'Strategy changes without 24h notice',
  'Hidden fee structures',
  'Market manipulation',
  'Misleading claims (guaranteed profits)',
];

const List<String> _copyFollowerResponsibilities = [
  'Do your own research before copying',
  'Understand all risks involved',
  'Set appropriate stop-loss limits',
  'Monitor your copies regularly',
  'Report suspicious behavior immediately',
  'Do not over-allocate to single provider',
];

const List<TradeCopyReportingStep> _copyReportingSteps = [
  TradeCopyReportingStep(
    title: '1. Collect Evidence',
    description: 'Screenshots, trade IDs, timestamps, chat logs',
  ),
  TradeCopyReportingStep(
    title: '2. File Report',
    description: 'Use "Report Provider" form with detailed description',
  ),
  TradeCopyReportingStep(
    title: '3. Investigation',
    description: 'Team reviews within 24-48 hours',
  ),
  TradeCopyReportingStep(
    title: '4. Enforcement',
    description: 'Warning, suspension, or permanent ban if violation confirmed',
  ),
];

const List<TradeCopySafetyTool> _copySafetyTools = [
  TradeCopySafetyTool(
    id: 'block',
    title: 'Block Provider',
    description: 'Prevent provider from appearing in your feeds',
    colorHex: 0xFFF59E0B,
    routePath: '/trade/copy-trading',
  ),
  TradeCopySafetyTool(
    id: 'report',
    title: 'Report Provider',
    description: 'Submit complaint to moderation team',
    colorHex: 0xFFEF4444,
    routePath: '/trade/copy-trading/safety',
  ),
  TradeCopySafetyTool(
    id: 'emergency',
    title: 'Emergency Stop All',
    description: 'Immediately stop all copying and close positions',
    colorHex: 0xFFEF4444,
  ),
];

const List<TradeCopyEnforcementAction> _copyEnforcementActions = [
  TradeCopyEnforcementAction(
    id: 'enf-1',
    date: '2026-03-05',
    providerName: 'Provider X',
    action: 'suspended',
    reason: 'Wash trading detected (fake volume)',
  ),
  TradeCopyEnforcementAction(
    id: 'enf-2',
    date: '2026-02-28',
    providerName: 'Provider Y',
    action: 'warned',
    reason: 'Undisclosed fee changes',
  ),
  TradeCopyEnforcementAction(
    id: 'enf-3',
    date: '2026-02-20',
    providerName: 'Provider Z',
    action: 'verified',
    reason: 'Passed Pro tier audit',
  ),
];
