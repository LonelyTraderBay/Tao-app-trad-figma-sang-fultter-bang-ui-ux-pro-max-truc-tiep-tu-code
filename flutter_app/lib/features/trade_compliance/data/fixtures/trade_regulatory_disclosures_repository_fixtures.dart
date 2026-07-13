part of '../repositories/mock_trade_regulatory_repository.dart';

// Standalone stand-in for `getTrade()` (the core spot-trading fixture, owned
// by `features/trade`'s own mock repository). `getRegulatoryDisclosures()`
// embeds a `TradeScreenSnapshot` in its response for parity with other trade
// domain snapshots, but no page or test reads that field (verified via
// `regulatory_disclosures_page.dart`/its widget parts and
// `regulatory_disclosures_page_test.dart`) — it exists only to satisfy
// `TradeRegulatoryDisclosuresSnapshot.trade`'s type. `trade_compliance` must
// not depend back on `trade`'s private spot-trading fixtures (that would
// invert the intended extraction direction), so this is a small, self-
// contained placeholder rather than a call to `getTrade()`.
const TradeScreenSnapshot _regulatoryDisclosuresTradeSnapshot =
    TradeScreenSnapshot(
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

const List<TradeClientCategoryInfo> _clientCategorizationCategories = [
  TradeClientCategoryInfo(
    id: 'retail',
    label: 'Retail Client',
    description: 'Individual investors with maximum regulatory protection',
    protections: [
      'Full appropriateness test required',
      'Best execution obligation',
      'Investor compensation scheme up to EUR 100k',
      'Detailed cost and charges disclosure',
      'Negative balance protection',
      'Right to complain to ombudsman',
      'Cooling-off period, 14 days',
      'Product governance protection',
    ],
    requirements: [
      'Natural person',
      'Trading for personal account',
      'Not meeting professional criteria',
    ],
  ),
  TradeClientCategoryInfo(
    id: 'professional',
    label: 'Professional Client',
    description: 'Experienced investors who can waive certain protections',
    protections: [
      'Appropriateness test may be waived',
      'Best execution obligation, reduced',
      'Limited investor compensation',
      'Simplified cost disclosure',
      'Product governance, reduced',
    ],
    requirements: [
      'Portfolio over EUR 500,000',
      'Trading volume over 10 transactions per quarter',
      'Work experience in financial sector, 1+ year',
      'Hold position requiring financial knowledge',
    ],
  ),
  TradeClientCategoryInfo(
    id: 'ecp',
    label: 'Eligible Counterparty',
    description: 'Institutional entities with minimal protection',
    protections: [
      'No conduct of business rules',
      'No investor compensation',
      'Minimal disclosure requirements',
    ],
    requirements: [
      'Investment firms',
      'Credit institutions',
      'Insurance companies',
      'UCITS and pension funds',
      'Government entities',
    ],
  ),
];

const List<TradeClientCategoryHistory> _clientCategorizationHistory = [
  TradeClientCategoryHistory(
    date: '2026-03-08',
    action: 'categorized',
    toCategoryId: 'retail',
    reason: 'Initial account registration',
  ),
  TradeClientCategoryHistory(
    date: '2025-12-15',
    action: 'opt-up-requested',
    fromCategoryId: 'retail',
    toCategoryId: 'professional',
    reason: 'User submitted qualification documents',
  ),
];

const List<TradeCopyProduct> _productGovernanceProducts = [
  TradeCopyProduct(
    id: 'prod-1',
    name: 'Mirror Copy Trading',
    type: 'mirror',
    status: 'approved',
    targetMarket: [
      'Professional clients',
      'Retail with high knowledge',
      'Portfolio > EUR 10k',
    ],
    negativeTarget: [
      'Inexperienced retail',
      'Risk-averse investors',
      'Portfolio < EUR 5k',
    ],
    riskLevel: 'high',
    lastReview: '1/15/2026',
    nextReview: '1/15/2027',
    distributionChannels: ['App', 'Web Platform', 'API'],
  ),
  TradeCopyProduct(
    id: 'prod-2',
    name: 'Fixed Ratio Copy',
    type: 'fixed-ratio',
    status: 'approved',
    targetMarket: [
      'All client categories',
      'Moderate risk tolerance',
      'Portfolio > EUR 1k',
    ],
    negativeTarget: ['Ultra-high-net-worth seeking bespoke', 'Day traders'],
    riskLevel: 'medium',
    lastReview: '2/10/2026',
    nextReview: '2/10/2027',
    distributionChannels: ['App', 'Web Platform'],
  ),
  TradeCopyProduct(
    id: 'prod-3',
    name: 'Smart Allocation Copy',
    type: 'smart-allocation',
    status: 'under-review',
    targetMarket: [
      'Professional clients',
      'Sophisticated retail',
      'Portfolio > EUR 25k',
    ],
    negativeTarget: [
      'Beginners',
      'Conservative investors',
      'Short-term traders',
    ],
    riskLevel: 'high',
    lastReview: '3/1/2026',
    nextReview: '6/1/2026',
    distributionChannels: ['App (Beta)', 'API (Limited)'],
  ),
];

const List<TradeTargetMarketDimension> _targetMarketDimensions = [
  TradeTargetMarketDimension(
    id: 'client-type',
    category: 'Client Type',
    suitableFor: ['Retail (high knowledge)', 'Professional clients'],
    notSuitableFor: ['Inexperienced retail'],
  ),
  TradeTargetMarketDimension(
    id: 'knowledge-experience',
    category: 'Knowledge & Experience',
    suitableFor: ['Advanced derivatives knowledge', 'Copy trading experience'],
    notSuitableFor: ['No investment knowledge', 'First-time investors'],
  ),
  TradeTargetMarketDimension(
    id: 'financial-situation',
    category: 'Financial Situation',
    suitableFor: ['Portfolio > €10,000', 'Can afford to lose capital'],
    notSuitableFor: ['Portfolio < €5,000', 'Dependent on capital'],
  ),
  TradeTargetMarketDimension(
    id: 'risk-tolerance',
    category: 'Risk Tolerance',
    suitableFor: ['High risk appetite', 'Comfortable with volatility'],
    notSuitableFor: ['Risk-averse', 'Capital preservation focus'],
  ),
  TradeTargetMarketDimension(
    id: 'objectives',
    category: 'Objectives',
    suitableFor: ['Capital growth', 'Medium-long term (6+ months)'],
    notSuitableFor: ['Capital preservation', 'Short-term (<3 months)'],
  ),
  TradeTargetMarketDimension(
    id: 'distribution-channel',
    category: 'Distribution Channel',
    suitableFor: ['App', 'Web Platform', 'API'],
    notSuitableFor: ['Offline', 'Telephone'],
  ),
];

const List<TradeAuditStat> _auditTrailStats = [
  TradeAuditStat(label: 'Total Events', value: '3'),
  TradeAuditStat(label: 'Today', value: '12'),
  TradeAuditStat(label: 'Retention', value: '7yr', emphasized: true),
];

const List<TradeAuditTab> _auditTrailTabs = [
  TradeAuditTab(id: 'all', label: 'All Events'),
  TradeAuditTab(id: 'trades', label: 'Trades'),
  TradeAuditTab(id: 'compliance', label: 'Compliance'),
  TradeAuditTab(id: 'client', label: 'Client Actions'),
];

const List<TradeAuditEntry> _auditTrailEntries = [
  TradeAuditEntry(
    id: 'AUD-2026-001234',
    timestampLabel: '3/8/2026, 9:23:15 PM',
    category: TradeAuditCategory.trade,
    categoryLabel: 'Trade',
    action: 'Order Executed',
    details: 'BUY 0.5 BTC @ \$65,234.50 (Mirror copy from Provider #123)',
    user: 'user@example.com',
    ipAddress: '192.168.1.1',
  ),
  TradeAuditEntry(
    id: 'AUD-2026-001233',
    timestampLabel: '3/8/2026, 9:20:00 PM',
    category: TradeAuditCategory.compliance,
    categoryLabel: 'Compliance',
    action: 'Suitability Assessment Passed',
    details: 'Risk tolerance: High, Knowledge: Advanced, Portfolio: €50k+',
    user: 'user@example.com',
    ipAddress: '192.168.1.1',
  ),
  TradeAuditEntry(
    id: 'AUD-2026-001232',
    timestampLabel: '3/8/2026, 9:15:30 PM',
    category: TradeAuditCategory.clientAction,
    categoryLabel: 'Client Action',
    action: 'Copy Trading Activated',
    details: 'Provider #123 (Conservative Crypto) - Allocation: 30%',
    user: 'user@example.com',
    ipAddress: '192.168.1.1',
  ),
];

const List<TradeRegulatoryInspectionStat> _regulatoryInspectionStats = [
  TradeRegulatoryInspectionStat(
    label: 'Documents',
    value: '10',
    icon: TradeRegulatoryInspectionStatIcon.documents,
  ),
  TradeRegulatoryInspectionStat(
    label: 'Clients',
    value: '3.4k',
    icon: TradeRegulatoryInspectionStatIcon.clients,
  ),
  TradeRegulatoryInspectionStat(
    label: 'Audit Logs',
    value: '45k',
    icon: TradeRegulatoryInspectionStatIcon.auditLogs,
  ),
  TradeRegulatoryInspectionStat(
    label: 'Retention',
    value: '7yr',
    icon: TradeRegulatoryInspectionStatIcon.retention,
  ),
];

const List<TradeRegulatoryFramework> _regulatoryFrameworks = [
  TradeRegulatoryFramework(
    name: 'MiFID II',
    compliance: 98,
    requirements: [
      'Client categorization',
      'Suitability assessment',
      'Best execution',
      'Transaction reporting',
      'Record-keeping (7 years)',
      'Complaints handling',
    ],
  ),
  TradeRegulatoryFramework(
    name: 'PRIIPs Regulation',
    compliance: 100,
    requirements: [
      'KID document',
      'Ex-ante cost disclosure',
      'Ex-post reporting',
      'Performance scenarios',
      'Risk indicator (SRI)',
    ],
  ),
  TradeRegulatoryFramework(
    name: 'FCA CASS 7',
    compliance: 100,
    requirements: [
      'Segregated client money',
      'Daily reconciliation',
      'Client money letters',
      'Insolvency protection',
    ],
  ),
  TradeRegulatoryFramework(
    name: 'FCA DISP',
    compliance: 95,
    requirements: [
      'Complaints procedure',
      '8-week resolution',
      'FOS referral rights',
      'Annual reporting',
    ],
  ),
];

const List<TradeRegulatoryDocument> _regulatoryDocuments = [
  TradeRegulatoryDocument(
    name: 'Transaction Reports (ARM)',
    countLabel: '1,247 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Best Execution Reports',
    countLabel: '52 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Client Categorization Records',
    countLabel: '3,421 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Suitability Assessments',
    countLabel: '2,890 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'KID Documents',
    countLabel: '15 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Cost Disclosures (Ex-Ante)',
    countLabel: '2,890 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Cost Reports (Ex-Post)',
    countLabel: '1,834 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'CASS Reconciliations',
    countLabel: '365 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Complaints Records',
    countLabel: '127 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Audit Trail Logs',
    countLabel: '45,892 records',
    status: 'Ready',
  ),
];
