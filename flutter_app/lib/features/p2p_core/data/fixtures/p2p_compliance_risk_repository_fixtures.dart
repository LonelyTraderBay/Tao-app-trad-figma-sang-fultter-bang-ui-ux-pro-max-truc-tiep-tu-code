part of '../repositories/mock_p2p_repository.dart';

const List<P2PLimitUsageDraft> _p2pLimitTrackerUsages = [
  P2PLimitUsageDraft(
    period: 'daily',
    label: 'Hôm nay',
    used: 35000000,
    limit: 50000000,
    percentage: 70,
  ),
  P2PLimitUsageDraft(
    period: 'weekly',
    label: 'Tuần',
    used: 180000000,
    limit: 300000000,
    percentage: 60,
  ),
  P2PLimitUsageDraft(
    period: 'monthly',
    label: 'Tháng',
    used: 650000000,
    limit: 1000000000,
    percentage: 65,
  ),
];

const List<P2PLimitBreakdownDraft> _p2pLimitTrackerBreakdown = [
  P2PLimitBreakdownDraft(date: '05/03', buy: 20000000, sell: 15000000),
  P2PLimitBreakdownDraft(date: '04/03', buy: 30000000, sell: 10000000),
  P2PLimitBreakdownDraft(date: '03/03', buy: 25000000, sell: 20000000),
  P2PLimitBreakdownDraft(date: '02/03', buy: 15000000, sell: 25000000),
];

const P2PTransactionLimitTierDraft _p2pTransactionLimitTier1 =
    P2PTransactionLimitTierDraft(
      tier: 1,
      name: 'Basic',
      statusLabel: 'Đang dùng',
      dailyBuy: 50000000,
      dailySell: 50000000,
      weeklyTotal: 300000000,
      monthlyTotal: 1000000000,
      perTransaction: 20000000,
      requirements: ['KYC Basic (CMND/CCCD)'],
    );

const P2PTransactionLimitTierDraft _p2pTransactionLimitTier2 =
    P2PTransactionLimitTierDraft(
      tier: 2,
      name: 'Intermediate',
      statusLabel: 'Có thể nâng cấp',
      dailyBuy: 200000000,
      dailySell: 200000000,
      weeklyTotal: 1200000000,
      monthlyTotal: 4000000000,
      perTransaction: 100000000,
      requirements: [
        'KYC Intermediate',
        'Proof of Address',
        'Selfie Verification',
      ],
    );

const List<P2PTransactionLimitUsageDraft> _p2pTransactionLimitUsages = [
  P2PTransactionLimitUsageDraft(
    id: 'daily_buy',
    label: 'Mua hôm nay',
    current: 35000000,
    max: 50000000,
    toneKey: 'buy',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'daily_sell',
    label: 'Bán hôm nay',
    current: 15000000,
    max: 50000000,
    toneKey: 'sell',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'weekly',
    label: 'Tuần này',
    current: 180000000,
    max: 300000000,
    toneKey: 'accent',
  ),
  P2PTransactionLimitUsageDraft(
    id: 'monthly',
    label: 'Tháng này',
    current: 650000000,
    max: 1000000000,
    toneKey: 'warning',
  ),
];

const List<P2PTransactionLimitDetailDraft> _p2pTransactionLimitDetails = [
  P2PTransactionLimitDetailDraft(
    id: 'daily_buy',
    label: 'Mua tối đa/ngày',
    value: 50000000,
    toneKey: 'buy',
    iconKey: 'trend',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'daily_sell',
    label: 'Bán tối đa/ngày',
    value: 50000000,
    toneKey: 'sell',
    iconKey: 'trend',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'weekly',
    label: 'Tổng/tuần',
    value: 300000000,
    toneKey: 'accent',
    iconKey: 'calendar',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'monthly',
    label: 'Tổng/tháng',
    value: 1000000000,
    toneKey: 'warning',
    iconKey: 'calendar',
  ),
  P2PTransactionLimitDetailDraft(
    id: 'per_transaction',
    label: 'Tối đa/giao dịch',
    value: 20000000,
    toneKey: 'danger',
    iconKey: 'amount',
  ),
];

const List<String> _p2pTransactionLimitInfoBullets = [
  'Giới hạn reset vào 00:00 UTC+7 mỗi ngày/tuần/tháng',
  'Giới hạn áp dụng cho cả Buy và Sell orders',
  'Số tiền đang trong escrow không tính vào giới hạn',
  'Giới hạn có thể thay đổi theo chính sách compliance',
];

const List<P2PComplianceItemDraft> _p2pComplianceOverviewItems = [
  P2PComplianceItemDraft(
    id: 'kyc',
    label: 'KYC Status',
    value: 'Tier 1 Basic',
    status: 'active',
    iconKey: 'shield',
    route: '/p2p/kyc/status',
  ),
  P2PComplianceItemDraft(
    id: 'aml',
    label: 'AML Screening',
    value: 'Low Risk',
    status: 'active',
    iconKey: 'file',
    route: '/p2p/compliance/aml-screening',
  ),
  P2PComplianceItemDraft(
    id: 'limits',
    label: 'Transaction Limits',
    value: '50M/ngày',
    status: 'active',
    iconKey: 'trend',
    route: '/p2p/limits',
  ),
  P2PComplianceItemDraft(
    id: 'sof',
    label: 'Source of Funds',
    value: 'Đã khai báo',
    status: 'active',
    iconKey: 'money',
    route: '/p2p/compliance/source-of-funds',
  ),
];

const List<P2PAmlCheckDraft> _p2pAmlScreeningChecks = [
  P2PAmlCheckDraft(
    id: 'sanctions',
    name: 'Sanctions List',
    status: 'pass',
    detail: 'No match found',
  ),
  P2PAmlCheckDraft(
    id: 'pep',
    name: 'PEP Check',
    status: 'pass',
    detail: 'Not a PEP',
  ),
  P2PAmlCheckDraft(
    id: 'adverse_media',
    name: 'Adverse Media',
    status: 'pass',
    detail: 'No negative news',
  ),
  P2PAmlCheckDraft(
    id: 'transaction_pattern',
    name: 'Transaction Pattern',
    status: 'review',
    detail: 'Under periodic review',
  ),
];

const List<P2PFundSourceDraft> _p2pFundSources = [
  P2PFundSourceDraft(
    id: 'salary',
    label: 'Lương/Thu nhập',
    iconKey: 'briefcase',
  ),
  P2PFundSourceDraft(id: 'business', label: 'Kinh doanh', iconKey: 'trend'),
  P2PFundSourceDraft(id: 'investment', label: 'Đầu tư', iconKey: 'money'),
  P2PFundSourceDraft(id: 'property', label: 'Bất động sản', iconKey: 'home'),
  P2PFundSourceDraft(id: 'gift', label: 'Quà tặng/Thừa kế', iconKey: 'gift'),
];

const List<String> _p2pLargeTransactionPurposes = [
  'Mua crypto để đầu tư dài hạn',
  'Trading ngắn hạn',
  'Thanh toán quốc tế',
  'Chuyển đổi tài sản',
  'Khác (ghi rõ)',
];

const List<P2PRiskFactorDraft> _p2pRiskFactors = [
  P2PRiskFactorDraft(
    id: 'kyc',
    label: 'KYC Level',
    value: 'Tier 1',
    risk: 'low',
    score: 5,
  ),
  P2PRiskFactorDraft(
    id: 'history',
    label: 'Transaction History',
    value: '156 đơn, 97.2% HT',
    risk: 'low',
    score: 3,
  ),
  P2PRiskFactorDraft(
    id: 'aml',
    label: 'AML Screening',
    value: 'Passed all checks',
    risk: 'low',
    score: 2,
  ),
  P2PRiskFactorDraft(
    id: 'disputes',
    label: 'Disputes',
    value: '1 vụ/156 đơn',
    risk: 'low',
    score: 3,
  ),
  P2PRiskFactorDraft(
    id: 'velocity',
    label: 'Transaction Velocity',
    value: 'Normal',
    risk: 'low',
    score: 2,
  ),
];

const List<int> _p2pTaxYears = [2026, 2025, 2024, 2023];

const List<P2PTaxJurisdictionDraft> _p2pTaxJurisdictions = [
  P2PTaxJurisdictionDraft(code: 'US', name: 'United States', form: 'Form 1099'),
  P2PTaxJurisdictionDraft(
    code: 'EU',
    name: 'European Union',
    form: 'Tax Certificate',
  ),
  P2PTaxJurisdictionDraft(code: 'UK', name: 'United Kingdom', form: 'P60/P45'),
  P2PTaxJurisdictionDraft(code: 'VN', name: 'Vietnam', form: 'Tax Declaration'),
];

const P2PTaxSummaryDraft _p2pTaxSummary2025 = P2PTaxSummaryDraft(
  totalTransactions: 156,
  totalVolumeLabel: '1.250M',
  capitalGainsLabel: '+45M',
  capitalLossesLabel: '-12M',
  netGainsLabel: '33M VND',
  generatedAt: '2026-01-15',
);

const List<P2PTaxDocumentDraft> _p2pTaxDocuments2025 = [
  P2PTaxDocumentDraft(
    id: 'form',
    title: 'Form 1099',
    subtitle: 'Generated 2026-01-15',
    format: 'PDF',
    toneKey: 'success',
  ),
  P2PTaxDocumentDraft(
    id: 'csv',
    title: 'Transaction History (CSV)',
    subtitle: 'All transactions for 2025',
    format: 'CSV',
    toneKey: 'primary',
  ),
  P2PTaxDocumentDraft(
    id: 'txf',
    title: 'TurboTax Export (TXF)',
    subtitle: 'Import to TurboTax/TaxAct',
    format: 'TXF',
    toneKey: 'warning',
  ),
];

const List<P2POrderBookMarketDraft> _p2pOrderBookMarkets = [
  P2POrderBookMarketDraft(
    asset: 'USDT',
    lastPriceVnd: 25300,
    changePct: .80,
    high24hVnd: 25450,
    low24hVnd: 25180,
    volume24hLabel: '2.45B',
    trades24h: 1243,
  ),
  P2POrderBookMarketDraft(
    asset: 'BTC',
    lastPriceVnd: 1715000000,
    changePct: -2.30,
    high24hVnd: 1755000000,
    low24hVnd: 1698000000,
    volume24hLabel: '85B',
    trades24h: 892,
  ),
  P2POrderBookMarketDraft(
    asset: 'ETH',
    lastPriceVnd: 89000000,
    changePct: 3.50,
    high24hVnd: 91200000,
    low24hVnd: 86500000,
    volume24hLabel: '12.5B',
    trades24h: 654,
  ),
  P2POrderBookMarketDraft(
    asset: 'BNB',
    lastPriceVnd: 15200000,
    changePct: 1.20,
    high24hVnd: 15450000,
    low24hVnd: 15050000,
    volume24hLabel: '4.2B',
    trades24h: 421,
  ),
  P2POrderBookMarketDraft(
    asset: 'SOL',
    lastPriceVnd: 4800000,
    changePct: -1.50,
    high24hVnd: 4920000,
    low24hVnd: 4750000,
    volume24hLabel: '1.85B',
    trades24h: 387,
  ),
];

const List<P2POrderBookEntryDraft> _p2pOrderBookBids = [
  P2POrderBookEntryDraft(
    priceVnd: 25224.1,
    volume: 149.9880,
    total: 149.9880,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25200,
    volume: 161.2992,
    total: 311.2872,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25180,
    volume: 153.1690,
    total: 464.4562,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25160,
    volume: 122.1745,
    total: 586.6307,
    orders: 5,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25130,
    volume: 530.8145,
    total: 1117.4452,
    orders: 7,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25110,
    volume: 308.5426,
    total: 1425.9878,
    orders: 6,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25090,
    volume: 113.8138,
    total: 1539.8016,
    orders: 2,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25060,
    volume: 496.5048,
    total: 2036.3064,
    orders: 8,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25040,
    volume: 221.2488,
    total: 2257.5552,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25020,
    volume: 189.4260,
    total: 2446.9812,
    orders: 5,
  ),
];

const List<P2POrderBookEntryDraft> _p2pOrderBookAsks = [
  P2POrderBookEntryDraft(
    priceVnd: 25375.9,
    volume: 228.1104,
    total: 228.1104,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25400,
    volume: 238.2529,
    total: 466.3633,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25420,
    volume: 537.6315,
    total: 1003.9948,
    orders: 7,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25440,
    volume: 239.3836,
    total: 1243.3784,
    orders: 5,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25470,
    volume: 204.2349,
    total: 1447.6133,
    orders: 4,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25490,
    volume: 139.0445,
    total: 1586.6578,
    orders: 2,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25510,
    volume: 193.9158,
    total: 1780.5736,
    orders: 3,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25540,
    volume: 374.8984,
    total: 2155.4720,
    orders: 6,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25560,
    volume: 351.3147,
    total: 2506.7867,
    orders: 7,
  ),
  P2POrderBookEntryDraft(
    priceVnd: 25580,
    volume: 516.0706,
    total: 3022.8573,
    orders: 9,
  ),
];
