part of '../repositories/mock_trade_repository.dart';

const List<TradeShortcut> _shortcuts = [
  TradeShortcut(
    id: 'buy',
    keys: 'F1',
    label: 'Quick Buy',
    description: 'Place buy order with active preset',
  ),
  TradeShortcut(
    id: 'sell',
    keys: 'F2',
    label: 'Quick Sell',
    description: 'Place sell order with active preset',
  ),
  TradeShortcut(
    id: 'cancel',
    keys: 'ESC',
    label: 'Cancel All',
    description: 'Cancel all selected or open orders',
  ),
  TradeShortcut(
    id: 'size',
    keys: '1-4',
    label: 'Lot Size',
    description: 'Switch ladder lot size presets',
  ),
];

const List<TradeRiskStatusItem> _advancedToolStatusItems = [
  TradeRiskStatusItem(label: 'Ladder Trading Component', complete: true),
  TradeRiskStatusItem(label: 'Bulk Operations Component', complete: true),
  TradeRiskStatusItem(label: 'Keyboard Shortcuts System', complete: true),
  TradeRiskStatusItem(label: 'Integration với TradePage', complete: false),
  TradeRiskStatusItem(label: 'Persistent shortcut settings', complete: false),
];

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

TradeCopyConfigurationFeePreview _copyConfigurationFeePreview(
  TradeCopyConfigurationDraft draft,
) {
  final platformFee = draft.copyCapital * 0.001;
  const estimatedMonthlyTrades = 50;
  final averageTradeSize = draft.copyCapital / 10;
  final tradingFees = estimatedMonthlyTrades * 2 * 0.0025 * averageTradeSize;
  return TradeCopyConfigurationFeePreview(
    platformFee: platformFee,
    estimatedTradingFees: tradingFees,
    performanceFeeNote: 'Chỉ tính khi có lợi nhuận',
  );
}
