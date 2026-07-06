part of '../repositories/mock_trade_repository.dart';

const List<TradeClientMoneyProtectionItem> _clientMoneyProtections = [
  TradeClientMoneyProtectionItem(
    title: 'Segregated Bank Accounts',
    description:
        'Your funds are held in trust accounts separate from company funds. '
        'This means your money is protected even if the company becomes '
        'insolvent.',
  ),
  TradeClientMoneyProtectionItem(
    title: 'Daily Reconciliation',
    description:
        'We reconcile all client money daily to ensure accuracy and '
        'compliance with FCA regulations.',
  ),
  TradeClientMoneyProtectionItem(
    title: 'FCA Supervision',
    description:
        'Our client money handling is supervised by the Financial Conduct '
        'Authority (FCA) under CASS 7 rules.',
  ),
];

const List<TradeCassReconciliationRecord> _cassReconciliationRecords = [
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-08',
    displayDate: 'March 8, 2026',
    clientLedger: 45230.50,
    bankBalance: 45230.50,
    difference: 0,
    status: TradeCassReconciliationStatus.matched,
  ),
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-07',
    displayDate: 'March 7, 2026',
    clientLedger: 44890.25,
    bankBalance: 44890.25,
    difference: 0,
    status: TradeCassReconciliationStatus.matched,
  ),
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-06',
    displayDate: 'March 6, 2026',
    clientLedger: 43500,
    bankBalance: 43520,
    difference: 20,
    status: TradeCassReconciliationStatus.discrepancyResolved,
    notes: 'Pending deposit cleared',
  ),
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-05',
    displayDate: 'March 5, 2026',
    clientLedger: 42100.75,
    bankBalance: 42100.75,
    difference: 0,
    status: TradeCassReconciliationStatus.matched,
  ),
];

const List<TradeInvestorCompensationInfo> _investorCompensationOverviewItems = [
  TradeInvestorCompensationInfo(
    title: 'Independent Protection',
    description:
        'FSCS is independent of the government and financial services industry',
  ),
  TradeInvestorCompensationInfo(
    title: 'Free to Claimants',
    description:
        'No cost to make a claim. Funded by levies on authorized firms',
  ),
  TradeInvestorCompensationInfo(
    title: 'Fast Payment',
    description: 'FSCS aims to pay compensation within 3-6 months',
  ),
];

const List<TradeInvestorCompensationCoverage>
_investorCompensationCoverageItems = [
  TradeInvestorCompensationCoverage(
    label: 'Investments',
    amount: '£85,000',
    caption: 'Per eligible person, per firm',
    emphasized: true,
  ),
  TradeInvestorCompensationCoverage(
    label: 'Deposits',
    amount: '£85,000',
    caption: 'Per eligible person, per banking institution',
    emphasized: false,
  ),
];

const List<String> _investorCompensationEligibleCustomers = [
  'Individuals (retail clients)',
  'Small businesses (turnover < £6.5M)',
  'Charities (annual income < £6.5M)',
  'Trustees of trusts (net asset value < £1M)',
];

const List<String> _investorCompensationIneligibleCustomers = [
  'Large companies',
  'Professional investors (unless opted down)',
  'Financial institutions',
  'Public sector bodies',
];

const List<TradeInvestorCompensationClaimStep> _investorCompensationClaimSteps =
    [
      TradeInvestorCompensationClaimStep(
        step: 1,
        title: 'Firm Declared in Default',
        description:
            'FSCS can only pay if the FCA declares our firm in default '
            '(unable to meet obligations)',
      ),
      TradeInvestorCompensationClaimStep(
        step: 2,
        title: 'FSCS Contacts You',
        description:
            'FSCS will write to all known eligible customers with claim forms',
      ),
      TradeInvestorCompensationClaimStep(
        step: 3,
        title: 'Complete Claim Form',
        description:
            'Fill out the claim form with details of your investment/deposit',
      ),
      TradeInvestorCompensationClaimStep(
        step: 4,
        title: 'Submit Evidence',
        description:
            'Provide proof of ownership (account statements, contracts)',
      ),
      TradeInvestorCompensationClaimStep(
        step: 5,
        title: 'Assessment',
        description: 'FSCS reviews your claim and calculates compensation',
      ),
      TradeInvestorCompensationClaimStep(
        step: 6,
        title: 'Payment',
        description:
            'If approved, FSCS pays compensation directly to you '
            '(typically within 3-6 months)',
      ),
    ];

const List<TradeExAnteCostItem> _exAnteCostItems = [
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.oneOff,
    type: 'Entry Cost',
    description: 'Platform fee charged when you start copying',
    amountEur: 50,
    percentOfInvestment: .50,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.oneOff,
    type: 'Exit Cost',
    description: 'Platform fee when you stop copying (no early exit fee)',
    amountEur: 0,
    percentOfInvestment: 0,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.recurring,
    type: 'Management Fee',
    description: 'Annual fee for copy trading service',
    amountEur: 200,
    percentOfInvestment: 2.00,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.recurring,
    type: 'Transaction Costs',
    description: 'Estimated trading fees (based on historical activity)',
    amountEur: 80,
    percentOfInvestment: .80,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.recurring,
    type: 'Other Ongoing',
    description: 'Custody, admin, and operational costs',
    amountEur: 20,
    percentOfInvestment: .20,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.incidental,
    type: 'Performance Fee',
    description: '20% of profits above high water mark',
    amountEur: 100,
    percentOfInvestment: 1.00,
  ),
];

const List<TradeExPostCostReport> _exPostCostReports = [
  TradeExPostCostReport(
    year: 2025,
    oneOff: 50,
    recurring: 285,
    incidental: 120,
    estimatedOneOff: 50,
    estimatedRecurring: 300,
    estimatedIncidental: 100,
  ),
  TradeExPostCostReport(
    year: 2024,
    oneOff: 45,
    recurring: 272,
    incidental: 84,
    estimatedOneOff: 50,
    estimatedRecurring: 280,
    estimatedIncidental: 90,
  ),
  TradeExPostCostReport(
    year: 2023,
    oneOff: 40,
    recurring: 248,
    incidental: 72,
    estimatedOneOff: 45,
    estimatedRecurring: 260,
    estimatedIncidental: 80,
  ),
];

const List<TradeKidSection> _kidSections = [
  TradeKidSection(
    title: 'Product Overview',
    icon: TradeKidSectionIcon.info,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Investment Objectives',
    icon: TradeKidSectionIcon.target,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Risk & Reward Profile',
    icon: TradeKidSectionIcon.warning,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Performance Scenarios',
    icon: TradeKidSectionIcon.chart,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Costs',
    icon: TradeKidSectionIcon.costs,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Holding Period',
    icon: TradeKidSectionIcon.clock,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Additional Information',
    icon: TradeKidSectionIcon.help,
    status: 'complete',
  ),
];

const List<TradePerformanceScenario> _performanceScenarios = [
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.stress,
    label: 'Stress',
    annualReturnPct: -25,
  ),
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.unfavorable,
    label: 'Unfavorable',
    annualReturnPct: -5,
  ),
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.moderate,
    label: 'Moderate',
    annualReturnPct: 8,
  ),
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.favorable,
    label: 'Favorable',
    annualReturnPct: 22,
  ),
];

const List<TradeRiskIndicatorLevel> _riskIndicatorLevels = [
  TradeRiskIndicatorLevel(
    level: 1,
    label: 'Lowest Risk',
    tier: TradeRiskIndicatorTier.low,
    description: 'Capital protected products. Very low volatility.',
    examples: ['Money market funds', 'Cash deposits'],
  ),
  TradeRiskIndicatorLevel(
    level: 2,
    label: 'Low Risk',
    tier: TradeRiskIndicatorTier.low,
    description: 'Low volatility. Small chance of loss.',
    examples: ['Government bonds', 'High-grade corporate bonds'],
  ),
  TradeRiskIndicatorLevel(
    level: 3,
    label: 'Low-Medium Risk',
    tier: TradeRiskIndicatorTier.medium,
    description: 'Some volatility. Moderate chance of loss.',
    examples: ['Mixed bond funds', 'Conservative balanced funds'],
  ),
  TradeRiskIndicatorLevel(
    level: 4,
    label: 'Medium Risk',
    tier: TradeRiskIndicatorTier.medium,
    description: 'Moderate volatility. Balanced risk/reward.',
    examples: ['Balanced funds', 'Index funds'],
  ),
  TradeRiskIndicatorLevel(
    level: 5,
    label: 'Medium-High Risk',
    tier: TradeRiskIndicatorTier.elevated,
    description: 'Higher volatility. Significant loss possible.',
    examples: ['Equity funds', 'Emerging market bonds'],
  ),
  TradeRiskIndicatorLevel(
    level: 6,
    label: 'High Risk',
    tier: TradeRiskIndicatorTier.high,
    description: 'High volatility. Substantial loss possible.',
    examples: ['Small-cap equities', 'High-yield bonds', 'Copy trading'],
  ),
  TradeRiskIndicatorLevel(
    level: 7,
    label: 'Highest Risk',
    tier: TradeRiskIndicatorTier.high,
    description: 'Extreme volatility. Total loss possible.',
    examples: ['Leveraged products', 'Complex derivatives', 'Crypto'],
  ),
];

const List<TradeRiskIndicatorAdditionalRisk> _riskIndicatorAdditionalRisks = [
  TradeRiskIndicatorAdditionalRisk(
    title: 'Provider Risk',
    description:
        'The trader you copy may underperform or take excessive risks.',
  ),
  TradeRiskIndicatorAdditionalRisk(
    title: 'Liquidity Risk',
    description:
        'In extreme market conditions, you may not be able to exit positions '
        'quickly.',
  ),
  TradeRiskIndicatorAdditionalRisk(
    title: 'Operational Risk',
    description: 'Technical failures or errors in trade copying may occur.',
  ),
];
