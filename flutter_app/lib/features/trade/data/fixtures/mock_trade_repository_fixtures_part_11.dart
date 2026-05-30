part of '../repositories/mock_trade_repository.dart';

const List<TradeOmbudsmanEligibility> _ombudsmanEligibility = [
  TradeOmbudsmanEligibility(
    title: 'After 8 Weeks',
    description: "If we haven't sent you a final response within 8 weeks",
  ),
  TradeOmbudsmanEligibility(
    title: 'Not Satisfied',
    description: "If you're not satisfied with our final response",
  ),
  TradeOmbudsmanEligibility(
    title: 'Within 6 Months',
    description: 'You must refer within 6 months of our final response',
  ),
];

const List<TradeOmbudsmanContact> _ombudsmanContacts = [
  TradeOmbudsmanContact(
    label: 'Phone',
    value: '0800 023 4567',
    detail: 'Monday to Friday, 8am to 8pm - Saturday, 9am to 1pm',
    icon: TradeOmbudsmanContactIcon.phone,
  ),
  TradeOmbudsmanContact(
    label: 'Website',
    value: 'www.financial-ombudsman.org.uk',
    icon: TradeOmbudsmanContactIcon.website,
  ),
  TradeOmbudsmanContact(
    label: 'Address',
    value: 'Financial Ombudsman Service\nExchange Tower\nLondon E14 9SR',
    icon: TradeOmbudsmanContactIcon.address,
  ),
];

const List<TradeOmbudsmanProcessStep> _ombudsmanProcessSteps = [
  TradeOmbudsmanProcessStep(
    step: 1,
    title: 'Submit Your Complaint',
    description: 'Contact FOS with your complaint details',
  ),
  TradeOmbudsmanProcessStep(
    step: 2,
    title: 'FOS Reviews',
    description: 'They review both sides of the story',
  ),
  TradeOmbudsmanProcessStep(
    step: 3,
    title: 'Investigation',
    description: 'Independent investigation of the facts',
  ),
  TradeOmbudsmanProcessStep(
    step: 4,
    title: 'Decision',
    description: 'FOS makes a binding decision (for us, not you)',
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
    details: 'Risk tolerance: High, Knowledge: Advanced, Portfolio: \u20ac50k+',
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
