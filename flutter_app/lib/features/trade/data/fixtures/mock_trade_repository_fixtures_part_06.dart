part of '../repositories/mock_trade_repository.dart';

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

const List<TradeRegulatoryTab> _regulatoryTabs = [
  TradeRegulatoryTab(id: 'mifid', label: 'MiFID II'),
  TradeRegulatoryTab(id: 'protection', label: 'Protection'),
  TradeRegulatoryTab(id: 'restrictions', label: 'Restrictions'),
  TradeRegulatoryTab(id: 'liability', label: 'Liability'),
  TradeRegulatoryTab(id: 'contact', label: 'Contact'),
];

const List<TradeRegulatoryDisclosureBlock> _regulatoryMifidArticles = [
  TradeRegulatoryDisclosureBlock(
    title: 'Article 24: Information to Clients',
    body:
        'We provide all material information about copy trading, including risks, costs, and nature of service. All disclosures are clear, accurate, and not misleading.',
  ),
  TradeRegulatoryDisclosureBlock(
    title: 'Article 25: Assessment of Suitability and Appropriateness',
    body: 'Before you can copy trade, we assess:',
    items: [
      'Your knowledge and experience with copy trading',
      'Your ability to bear financial losses',
      'Your risk tolerance level',
      'Your investment objectives',
    ],
  ),
  TradeRegulatoryDisclosureBlock(
    title: 'Article 27: Best Execution Obligation',
    body:
        'We execute your copy orders on terms most favorable to you, considering price, costs, speed, likelihood of execution, and other relevant factors. Execution quality metrics are disclosed transparently.',
  ),
  TradeRegulatoryDisclosureBlock(
    title: 'Article 58: Record Keeping',
    body:
        'All transactions, communications, and risk assessments are recorded and retained for a minimum of 5 years. You can request your complete audit trail at any time.',
  ),
];

const TradeRegulatoryProtection
_regulatoryProtection = TradeRegulatoryProtection(
  coverage: TradeRegulatoryDisclosureBlock(
    title: 'Coverage Limit',
    body:
        'Eligible claims are covered up to EUR 20,000 per user under the Investor Compensation Scheme (ICS). This protects you if we become insolvent.',
  ),
  covered: TradeRegulatoryDisclosureBlock(
    title: "What's Covered",
    body: '',
    items: [
      'Cash balances in your copy trading account',
      'Open positions at time of insolvency',
      'Uncredited deposits',
    ],
  ),
  notCovered: TradeRegulatoryDisclosureBlock(
    title: "What's NOT Covered",
    body: '',
    items: [
      'Trading losses (market risk)',
      'Poor provider performance',
      'Slippage costs',
      'Unauthorized account access (negligence)',
    ],
  ),
  claimSteps: TradeRegulatoryDisclosureBlock(
    title: 'How to File a Claim',
    body: '',
    items: [
      '1. Contact our support team within 30 days',
      '2. Complete claim form with evidence',
      '3. Submit to ICS operator',
      '4. Receive decision within 90 days',
    ],
  ),
  contactLabel: 'ICS Operator Contact',
);

const TradeRegulatoryRestrictions
_regulatoryRestrictions = TradeRegulatoryRestrictions(
  unavailableCountries: [
    'United States (US residents)',
    'China (mainland)',
    'North Korea',
    'Iran',
    'Syria',
    'Countries under OFAC sanctions',
  ],
  leverageRules: [
    TradeRegulatoryDisclosureBlock(
      title: 'EU Retail Clients:',
      body: 'Max 30:1 for major forex, 20:1 for minor',
    ),
    TradeRegulatoryDisclosureBlock(
      title: 'UK Retail Clients:',
      body: 'FCA limits apply (same as EU)',
    ),
    TradeRegulatoryDisclosureBlock(
      title: 'Professional Clients:',
      body: 'Higher leverage available (up to 100:1)',
    ),
  ],
  taxReporting: TradeRegulatoryDisclosureBlock(
    title: 'Tax Reporting Obligations',
    body:
        'You are responsible for reporting trading income to your local tax authority. We provide:',
    items: [
      'Annual tax report (P/L summary)',
      'Trade-by-trade export (CSV)',
      'Fee breakdown report',
    ],
  ),
);

const TradeRegulatoryLiability _regulatoryLiability = TradeRegulatoryLiability(
  platformRole: TradeRegulatoryDisclosureBlock(
    title: 'Platform Role',
    body: 'We are a technology provider, not an investment advisor. We do not:',
    items: [
      'Recommend specific providers to copy',
      'Guarantee provider performance',
      'Control provider trading decisions',
      'Provide personalized investment advice',
    ],
  ),
  userResponsibility: TradeRegulatoryDisclosureBlock(
    title: 'User Responsibility',
    body: 'You are solely responsible for:',
    items: [
      'Conducting your own due diligence',
      'Risk assessment and management',
      'Investment decisions and outcomes',
      'Monitoring your copy positions',
    ],
  ),
  indemnification: TradeRegulatoryDisclosureBlock(
    title: 'Indemnification',
    body:
        'You agree to indemnify and hold us harmless from any claims, damages, or losses arising from your use of copy trading, except in cases of our gross negligence or willful misconduct.',
  ),
  limitation: TradeRegulatoryDisclosureBlock(
    title: 'Limitation of Liability',
    body:
        'Our maximum liability is limited to the fees you paid in the last 12 months, except where prohibited by law. We are not liable for consequential, indirect, or punitive damages.',
  ),
);

const List<TradeRegulatoryContact> _regulatoryContacts = [
  TradeRegulatoryContact(
    title: 'Financial Conduct Authority (FCA)',
    subtitle: 'UK regulatory authority',
    icon: 'globe',
  ),
  TradeRegulatoryContact(
    title: 'European Securities and Markets Authority (ESMA)',
    subtitle: 'EU regulatory authority',
    icon: 'shield',
  ),
  TradeRegulatoryContact(
    title: 'Financial Ombudsman Service',
    subtitle: 'Dispute resolution',
    icon: 'phone',
  ),
];

const TradeRegulatoryDisclosureBlock
_regulatoryWhistleblower = TradeRegulatoryDisclosureBlock(
  title: 'Report Regulatory Violations Confidentially',
  body:
      'If you suspect violations of financial regulations, you can report anonymously to:',
  items: [
    'Email: compliance@vittrade.com',
    'Hotline: +44 20 XXXX XXXX',
    'Secure form: vittrade.com/whistleblower',
  ],
);

const List<TradeRegulatoryDocumentLink> _regulatoryTerms = [
  TradeRegulatoryDocumentLink(
    title: 'Copy Trading Terms of Service',
    icon: 'file',
  ),
  TradeRegulatoryDocumentLink(
    title: 'Privacy Policy (Data Handling)',
    icon: 'lock',
  ),
];

const TradeMarginAccount _marginAccount = TradeMarginAccount(
  totalEquity: 12450.80,
  totalMargin: 6080,
  availableMargin: 6370.80,
  unrealizedPnl: 768.28,
  marginLevel: 204.8,
);

const List<TradeMarginPosition> _marginPositions = [
  TradeMarginPosition(
    id: 'mg001',
    pair: 'BTC/USDT',
    side: 'long',
    mode: 'cross',
    leverage: 5,
    entryPrice: 65200,
    markPrice: 67543.21,
    size: .15,
    margin: 1956,
    pnl: 351.48,
    pnlPct: 17.97,
    liquidationPrice: 52160,
    marginRatio: 12.5,
  ),
  TradeMarginPosition(
    id: 'mg002',
    pair: 'ETH/USDT',
    side: 'short',
    mode: 'isolated',
    leverage: 10,
    entryPrice: 3620,
    markPrice: 3521.45,
    size: 2,
    margin: 724,
    pnl: 197.10,
    pnlPct: 27.22,
    liquidationPrice: 3982,
    marginRatio: 8.3,
  ),
  TradeMarginPosition(
    id: 'mg003',
    pair: 'SOL/USDT',
    side: 'long',
    mode: 'cross',
    leverage: 3,
    entryPrice: 172.50,
    markPrice: 178.32,
    size: 50,
    margin: 2875,
    pnl: 291,
    pnlPct: 10.12,
    liquidationPrice: 115,
    marginRatio: 18.7,
  ),
  TradeMarginPosition(
    id: 'mg004',
    pair: 'BNB/USDT',
    side: 'long',
    mode: 'isolated',
    leverage: 8,
    entryPrice: 420,
    markPrice: 412.87,
    size: 10,
    margin: 525,
    pnl: -71.30,
    pnlPct: -13.58,
    liquidationPrice: 370,
    marginRatio: 5.2,
  ),
];

const List<TradeMarginTab> _marginModeTabs = [
  TradeMarginTab(id: 'cross', label: 'Cross Margin'),
  TradeMarginTab(id: 'isolated', label: 'Isolated Margin'),
];

const List<TradeMarginTab> _marginContentTabs = [
  TradeMarginTab(id: 'trade', label: 'Giao dịch'),
  TradeMarginTab(id: 'positions', label: 'Vị thế'),
  TradeMarginTab(id: 'orders', label: 'Lệnh chờ'),
];

const TradeMarginClientCategory _marginClientCategory =
    TradeMarginClientCategory(
      title: 'Retail Client',
      description: 'Bạn được hưởng bảo vệ cao nhất theo quy định MiFID II/FCA',
      badgeLabel: 'Nâng cấp',
      limits: [
        'Leverage tối đa: 30x (crypto)',
        'Negative balance protection',
        'Best execution guarantee',
      ],
    );

const TradeMarginReferencePrices _marginReferencePrices =
    TradeMarginReferencePrices(
      markPrice: 67543.21,
      lastPrice: 67572.63,
      indexPrice: 67529.70,
    );

const TradeMarginReferencePrices _marginPairRouteReferencePrices =
    TradeMarginReferencePrices(
      markPrice: 67543.21,
      lastPrice: 67516.13,
      indexPrice: 67529.70,
    );

const TradeMarginOrderDraft _marginOrderDraft = TradeMarginOrderDraft(
  orderTypes: [
    TradeMarginTab(id: 'limit', label: 'Limit Order'),
    TradeMarginTab(id: 'market', label: 'Market Order'),
  ],
  selectedOrderType: 'limit',
  price: '67543.21',
  amount: '0.00',
  tradingFeeRate: .0005,
  liquidationPriceLabel: '--',
);

const TradeMarginRiskWarning _marginRiskWarning = TradeMarginRiskWarning(
  title: 'Rủi ro đòn bẩy 5x',
  items: [
    'Giá chỉ cần biến động 20.00% ngược chiều là bạn bị thanh lý toàn bộ vị thế',
    'Đòn bẩy cao = rủi ro cao. Chỉ giao dịch số tiền bạn có thể chấp nhận mất',
  ],
);

const TradeMarginSafetyDisclosure
_marginNegativeBalance = TradeMarginSafetyDisclosure(
  title: 'Bảo vệ số dư âm',
  body:
      'Nền tảng cam kết bảo vệ 100% số dư âm. Bạn không bao giờ mất nhiều hơn số tiền đã nạp vào tài khoản, ngay cả trong trường hợp thanh lý.',
  footer: 'Insurance Fund: \$12,450,000 | Cập nhật: Hàng ngày',
);

const TradeMarginBestExecutionDisclosure
_marginBestExecution = TradeMarginBestExecutionDisclosure(
  title: 'Best Execution Policy',
  body:
      'Chúng tôi cam kết thực hiện lệnh của bạn theo Best Execution theo quy định MiFID II:',
  items: [
    'Giá tốt nhất có sẵn trên nhiều exchanges',
    'Tốc độ khớp lệnh nhanh nhất',
    'Chi phí thấp nhất (phí + slippage)',
    'Khả năng settlement và size phù hợp',
  ],
  actionLabel: 'Xem Best Execution Report',
);
