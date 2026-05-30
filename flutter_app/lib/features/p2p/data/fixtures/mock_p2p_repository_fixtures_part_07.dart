part of '../repositories/mock_p2p_repository.dart';

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

const List<P2PDashboardFilterDraft> _p2pDashboardFilters = [
  P2PDashboardFilterDraft(id: '7d', label: '7 ngày'),
  P2PDashboardFilterDraft(id: '30d', label: '30 ngày'),
  P2PDashboardFilterDraft(id: 'all', label: 'Tất cả'),
];

const P2PDashboardStatsDraft _p2pDashboardStats = P2PDashboardStatsDraft(
  totalOrders: 78,
  completedOrders: 64,
  cancelledOrders: 8,
  disputedOrders: 2,
  completionRate: 82.1,
  avgCompletionTime: '8 phút',
  totalVolume7d: 89500000,
  totalVolume30d: 385000000,
  totalVolumeAll: 1250000000,
  buyVolume30d: 245000000,
  sellVolume30d: 140000000,
  spreadRevenue30d: 1850000,
  avgOrderSize: 16200000,
  uniqueCounterparties: 23,
  repeatCustomerRate: 34.8,
  avgRatingReceived: 4.8,
  positiveReviewRate: 95.3,
  responseTimeAvg: '4 phút',
  platformAvgCompletionRate: 94.5,
  platformAvgResponseTime: '6 phút',
);

const List<P2PDashboardSeriesPointDraft> _p2pDashboardWeeklyVolume = [
  P2PDashboardSeriesPointDraft(label: 'T1', value: 45000000),
  P2PDashboardSeriesPointDraft(label: 'T2', value: 72000000),
  P2PDashboardSeriesPointDraft(label: 'T3', value: 98000000),
  P2PDashboardSeriesPointDraft(label: 'T4', value: 120000000),
  P2PDashboardSeriesPointDraft(label: 'T5', value: 85000000),
  P2PDashboardSeriesPointDraft(label: 'T6', value: 135000000),
  P2PDashboardSeriesPointDraft(label: 'T7', value: 68000000),
  P2PDashboardSeriesPointDraft(label: 'T8', value: 89500000),
];

const List<P2PDashboardMonthlyOrdersDraft> _p2pDashboardMonthlyOrders = [
  P2PDashboardMonthlyOrdersDraft(month: 'T9', buy: 4, sell: 2),
  P2PDashboardMonthlyOrdersDraft(month: 'T10', buy: 6, sell: 5),
  P2PDashboardMonthlyOrdersDraft(month: 'T11', buy: 8, sell: 4),
  P2PDashboardMonthlyOrdersDraft(month: 'T12', buy: 10, sell: 7),
  P2PDashboardMonthlyOrdersDraft(month: 'T1', buy: 12, sell: 6),
  P2PDashboardMonthlyOrdersDraft(month: 'T2', buy: 9, sell: 5),
];

const List<P2PDashboardAssetDraft> _p2pDashboardAssetDistribution = [
  P2PDashboardAssetDraft(asset: 'USDT', percentage: 72, volume: 277200000),
  P2PDashboardAssetDraft(asset: 'BTC', percentage: 18, volume: 69300000),
  P2PDashboardAssetDraft(asset: 'ETH', percentage: 6, volume: 23100000),
  P2PDashboardAssetDraft(asset: 'BNB', percentage: 3, volume: 11550000),
  P2PDashboardAssetDraft(asset: 'SOL', percentage: 1, volume: 3850000),
];

const P2PDashboardLevelDraft _p2pDashboardCurrentLevel = P2PDashboardLevelDraft(
  id: 3,
  name: 'Advanced',
  dailyUsed: 45500000,
  dailyLimit: 500000000,
  progress: .42,
  requirements: [],
);

const P2PDashboardLevelDraft _p2pDashboardNextLevel = P2PDashboardLevelDraft(
  id: 4,
  name: 'VIP',
  dailyUsed: 45500000,
  dailyLimit: 500000000,
  progress: .42,
  requirements: [
    'KYC Lv.2',
    '2FA đã bật',
    'Volume > 5 tỷ VND',
    '200+ giao dịch hoàn tất',
  ],
);

const List<P2PDashboardComparisonDraft> _p2pDashboardPlatformComparisons = [
  P2PDashboardComparisonDraft(
    label: 'Tỷ lệ hoàn thành',
    yours: 82.1,
    platform: 94.5,
    suffix: '%',
  ),
  P2PDashboardComparisonDraft(
    label: 'Phản hồi trung bình',
    yours: 4,
    platform: 6,
    suffix: ' phút',
    lowerBetter: true,
  ),
  P2PDashboardComparisonDraft(
    label: 'Đánh giá nhận được',
    yours: 4.8,
    platform: 4.3,
    suffix: '/5.0',
  ),
  P2PDashboardComparisonDraft(
    label: 'Tỷ lệ review tích cực',
    yours: 95.3,
    platform: 91,
    suffix: '%',
  ),
];

const List<P2PDashboardMerchantDraft> _p2pDashboardTopMerchants = [
  P2PDashboardMerchantDraft(
    id: 'mc001',
    name: 'CryptoKing_VN',
    trades: 15,
    volume: 127000000,
    rating: 4.8,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc004',
    name: 'VIPTrader_HN',
    trades: 12,
    volume: 98000000,
    rating: 4.9,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc002',
    name: 'TradeMaster99',
    trades: 8,
    volume: 62000000,
    rating: 4.2,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc006',
    name: 'BTCWhale_VN',
    trades: 5,
    volume: 85750000,
    rating: 4.9,
  ),
  P2PDashboardMerchantDraft(
    id: 'mc005',
    name: 'FastTrade_SG',
    trades: 4,
    volume: 32000000,
    rating: 4.6,
  ),
];

const List<P2PDashboardActivityDraft> _p2pDashboardRecentActivity = [
  P2PDashboardActivityDraft(
    date: '23/02 11:00',
    type: 'buy',
    asset: 'USDT',
    amount: 200,
    total: 5070000,
    merchant: 'CryptoKing_VN',
    status: 'pending_payment',
  ),
  P2PDashboardActivityDraft(
    date: '23/02 09:15',
    type: 'sell',
    asset: 'USDT',
    amount: 500,
    total: 12640000,
    merchant: 'VIPTrader_HN',
    status: 'paid',
  ),
  P2PDashboardActivityDraft(
    date: '22/02 14:30',
    type: 'buy',
    asset: 'USDT',
    amount: 1000,
    total: 25300000,
    merchant: 'TradeMaster99',
    status: 'released',
  ),
  P2PDashboardActivityDraft(
    date: '21/02 16:45',
    type: 'buy',
    asset: 'USDT',
    amount: 150,
    total: 3810000,
    merchant: 'CoinHunter_HCM',
    status: 'released',
  ),
  P2PDashboardActivityDraft(
    date: '18/02 12:00',
    type: 'buy',
    asset: 'BTC',
    amount: .05,
    total: 85750000,
    merchant: 'BTCWhale_VN',
    status: 'released',
  ),
];
