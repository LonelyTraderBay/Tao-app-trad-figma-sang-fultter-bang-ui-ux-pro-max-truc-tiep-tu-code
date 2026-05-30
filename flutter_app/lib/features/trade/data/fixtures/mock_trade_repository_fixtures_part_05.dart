part of '../repositories/mock_trade_repository.dart';

const List<TradeCopyAuditEvent> _copyAuditEvents = [
  TradeCopyAuditEvent(
    id: 'evt-1',
    type: TradeCopyAuditEventType.trade,
    timestamp: '2026-03-08 14:23:15',
    title: 'Trade Executed',
    description: 'BUY 0.05 BTC @ \$67,835 (Provider: \$67,800)',
    severity: TradeCopyAuditSeverity.info,
    metadata: TradeCopyAuditMetadata(
      pair: 'BTC/USDT',
      side: TradeOrderSide.buy,
      providerPrice: 67800,
      yourPrice: 67835,
      slippagePct: .52,
    ),
  ),
  TradeCopyAuditEvent(
    id: 'evt-2',
    type: TradeCopyAuditEventType.risk,
    timestamp: '2026-03-08 14:15:42',
    title: 'Risk Alert Triggered',
    description: 'Copy approaching stop-loss: -8.5% (threshold: -10%)',
    severity: TradeCopyAuditSeverity.warning,
  ),
  TradeCopyAuditEvent(
    id: 'evt-3',
    type: TradeCopyAuditEventType.config,
    timestamp: '2026-03-08 10:30:22',
    title: 'Stop-Loss Updated',
    description: 'User adjusted stop-loss',
    severity: TradeCopyAuditSeverity.info,
    metadata: TradeCopyAuditMetadata(oldValue: '-15%', newValue: '-10%'),
  ),
  TradeCopyAuditEvent(
    id: 'evt-4',
    type: TradeCopyAuditEventType.trade,
    timestamp: '2026-03-07 16:45:10',
    title: 'Position Closed',
    description: 'SELL 2 ETH @ \$3,848 (P/L: +\$45)',
    severity: TradeCopyAuditSeverity.info,
    metadata: TradeCopyAuditMetadata(
      pair: 'ETH/USDT',
      side: TradeOrderSide.sell,
      providerPrice: 3850,
      yourPrice: 3848,
      slippagePct: .31,
      pnl: 45,
    ),
  ),
  TradeCopyAuditEvent(
    id: 'evt-5',
    type: TradeCopyAuditEventType.system,
    timestamp: '2026-03-05 09:00:00',
    title: 'Copy Activated',
    description: 'Cooling-off period completed, copy started',
    severity: TradeCopyAuditSeverity.info,
  ),
  TradeCopyAuditEvent(
    id: 'evt-6',
    type: TradeCopyAuditEventType.config,
    timestamp: '2026-03-04 14:30:00',
    title: 'Copy Configuration Created',
    description: 'Capital: \$5,000 | Mode: Fixed 50% | SL: -10%',
    severity: TradeCopyAuditSeverity.info,
  ),
  TradeCopyAuditEvent(
    id: 'evt-7',
    type: TradeCopyAuditEventType.system,
    timestamp: '2026-03-04 14:25:00',
    title: 'Risk Assessment Completed',
    description: 'Score: 85/140 (Suitable) | Recommended allocation: 15%',
    severity: TradeCopyAuditSeverity.info,
  ),
];

const List<TradeAssetExposure> _portfolioRiskAssets = [
  TradeAssetExposure(
    asset: 'BTC',
    value: 2800,
    percent: 35,
    colorHex: 0xFFF7931A,
  ),
  TradeAssetExposure(
    asset: 'ETH',
    value: 2000,
    percent: 25,
    colorHex: 0xFF627EEA,
  ),
  TradeAssetExposure(
    asset: 'SOL',
    value: 1200,
    percent: 15,
    colorHex: 0xFF00D4AA,
  ),
  TradeAssetExposure(
    asset: 'AVAX',
    value: 800,
    percent: 10,
    colorHex: 0xFFE84142,
  ),
  TradeAssetExposure(
    asset: 'USDT',
    value: 600,
    percent: 7.5,
    colorHex: 0xFF26A17B,
  ),
  TradeAssetExposure(
    asset: 'Others',
    value: 600,
    percent: 7.5,
    colorHex: 0xFF6B7280,
  ),
];

const List<TradeStressScenario> _portfolioRiskScenarios = [
  TradeStressScenario(
    name: 'Market Crash (-30%)',
    impact: -2400,
    probability: 5,
    colorHex: 0xFFEF4444,
  ),
  TradeStressScenario(
    name: 'BTC Halving Rally',
    impact: 1800,
    probability: 20,
    colorHex: 0xFF10B981,
  ),
  TradeStressScenario(
    name: 'Regulatory Crackdown',
    impact: -1500,
    probability: 15,
    colorHex: 0xFFF59E0B,
  ),
  TradeStressScenario(
    name: 'Stable Bull Market',
    impact: 600,
    probability: 40,
    colorHex: 0xFF3B82F6,
  ),
  TradeStressScenario(
    name: 'High Volatility',
    impact: -800,
    probability: 20,
    colorHex: 0xFF8B5CF6,
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
