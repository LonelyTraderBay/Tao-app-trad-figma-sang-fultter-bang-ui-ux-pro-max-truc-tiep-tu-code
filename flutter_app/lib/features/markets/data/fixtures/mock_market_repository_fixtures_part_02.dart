part of '../repositories/mock_market_repository.dart';

const List<MarketComparisonMetric> _comparisonMetrics = [
  MarketComparisonMetric(
    key: 'price',
    label: 'Giá hiện tại',
    format: MarketComparisonMetricFormat.price,
  ),
  MarketComparisonMetric(
    key: 'mcap',
    label: 'Vốn hóa',
    format: MarketComparisonMetricFormat.compact,
    highlight: MarketComparisonHighlight.high,
  ),
  MarketComparisonMetric(
    key: 'vol',
    label: 'Khối lượng 24h',
    format: MarketComparisonMetricFormat.compact,
    highlight: MarketComparisonHighlight.high,
  ),
  MarketComparisonMetric(
    key: 'chg',
    label: 'Thay đổi 24h',
    format: MarketComparisonMetricFormat.percent,
    highlight: MarketComparisonHighlight.high,
  ),
  MarketComparisonMetric(
    key: 'high',
    label: 'Cao nhất 24h',
    format: MarketComparisonMetricFormat.price,
  ),
  MarketComparisonMetric(
    key: 'low',
    label: 'Thấp nhất 24h',
    format: MarketComparisonMetricFormat.price,
  ),
  MarketComparisonMetric(
    key: 'range',
    label: 'Biên độ 24h',
    format: MarketComparisonMetricFormat.percent,
  ),
  MarketComparisonMetric(
    key: 'volmcap',
    label: 'Vol/MCap',
    format: MarketComparisonMetricFormat.percent,
  ),
];

const MarketScreenFilters _marketCalendarFilters = MarketScreenFilters(
  categories: [
    'Tất cả',
    'Token Unlock',
    'Nâng cấp',
    'Airdrop',
    'Đốt token',
    'Niêm yết',
    'Báo cáo',
    'Hội nghị',
  ],
  defaultCategory: 'Tất cả',
  defaultSort: 'date',
  sortOptions: [
    MarketSortOption(id: 'high', label: 'Cao'),
    MarketSortOption(id: 'medium', label: 'Trung bình'),
    MarketSortOption(id: 'low', label: 'Thấp'),
  ],
);

const List<int> _marketDepthLevels = [15, 25, 50];

const MarketScreenFilters _advancedChartsFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Xu hướng', 'Động lượng', 'Biến động', 'Khối lượng'],
  defaultCategory: 'Tất cả',
  defaultSort: 'indicators',
  sortOptions: [
    MarketSortOption(id: 'indicators', label: 'Chỉ báo'),
    MarketSortOption(id: 'drawing', label: 'Công cụ vẽ'),
    MarketSortOption(id: 'signals', label: 'Tín hiệu kỹ thuật'),
  ],
);

const List<AdvancedChartCategory> _advancedChartIndicatorCategories = [
  AdvancedChartCategory(id: 'trend', label: 'Xu hướng', color: AppColors.info),
  AdvancedChartCategory(
    id: 'momentum',
    label: 'Động lượng',
    color: AppColors.caution,
  ),
  AdvancedChartCategory(
    id: 'volatility',
    label: 'Biến động',
    color: AppAssetColors.pinkChain,
  ),
  AdvancedChartCategory(
    id: 'volume',
    label: 'Khối lượng',
    color: AppAssetColors.tealChain,
  ),
];

const List<AdvancedChartCategory> _advancedChartDrawingCategories = [
  AdvancedChartCategory(id: 'line', label: 'Đường', color: AppColors.info),
  AdvancedChartCategory(
    id: 'shape',
    label: 'Hình dạng',
    color: AppColors.accent,
  ),
  AdvancedChartCategory(
    id: 'fib',
    label: 'Fibonacci',
    color: AppColors.caution,
  ),
  AdvancedChartCategory(
    id: 'measure',
    label: 'Đo lường',
    color: AppAssetColors.tealChain,
  ),
];

const List<TechnicalIndicator> _advancedChartIndicators = [
  TechnicalIndicator(
    id: 'sma',
    name: 'Simple Moving Average',
    shortName: 'SMA',
    categoryId: 'trend',
    color: AppColors.info,
    description: 'Trung bình giá đóng cửa trong N kỳ',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 20)],
  ),
  TechnicalIndicator(
    id: 'ema',
    name: 'Exponential Moving Average',
    shortName: 'EMA',
    categoryId: 'trend',
    color: AppColors.accent,
    description: 'Trung bình trọng số hàm mũ, phản ứng nhanh hơn SMA',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 12)],
  ),
  TechnicalIndicator(
    id: 'boll',
    name: 'Bollinger Bands',
    shortName: 'BOLL',
    categoryId: 'volatility',
    color: AppAssetColors.pinkChain,
    description: 'Dải biến động quanh SMA +/- 2 độ lệch chuẩn',
    params: [
      TechnicalIndicatorParam(label: 'Chu kỳ', value: 20),
      TechnicalIndicatorParam(label: 'Sigma', value: 2),
    ],
  ),
  TechnicalIndicator(
    id: 'rsi',
    name: 'Relative Strength Index',
    shortName: 'RSI',
    categoryId: 'momentum',
    color: AppColors.caution,
    description: 'Chỉ số sức mạnh tương đối, quá mua >70, quá bán <30',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 14)],
  ),
  TechnicalIndicator(
    id: 'macd',
    name: 'MACD',
    shortName: 'MACD',
    categoryId: 'momentum',
    color: AppColors.buy,
    description: 'Chênh lệch EMA nhanh và EMA chậm, phát hiện đảo chiều',
    params: [
      TechnicalIndicatorParam(label: 'Nhanh', value: 12),
      TechnicalIndicatorParam(label: 'Chậm', value: 26),
      TechnicalIndicatorParam(label: 'Signal', value: 9),
    ],
  ),
  TechnicalIndicator(
    id: 'stoch',
    name: 'Stochastic Oscillator',
    shortName: 'STOCH',
    categoryId: 'momentum',
    color: AppAssetColors.cyanChain,
    description: 'So sánh giá đóng cửa với phạm vi giá trong kỳ',
    params: [
      TechnicalIndicatorParam(label: 'K', value: 14),
      TechnicalIndicatorParam(label: 'D', value: 3),
    ],
  ),
  TechnicalIndicator(
    id: 'atr',
    name: 'Average True Range',
    shortName: 'ATR',
    categoryId: 'volatility',
    color: AppColors.sell,
    description: 'Đo lường biến động trung bình, dùng đặt stop-loss',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 14)],
  ),
  TechnicalIndicator(
    id: 'vwap',
    name: 'Volume Weighted Average Price',
    shortName: 'VWAP',
    categoryId: 'volume',
    color: AppAssetColors.tealChain,
    description: 'Giá trung bình trọng số khối lượng trong phiên',
    params: [],
  ),
  TechnicalIndicator(
    id: 'obv',
    name: 'On-Balance Volume',
    shortName: 'OBV',
    categoryId: 'volume',
    color: AppAssetColors.violetChain,
    description: 'Tích lũy khối lượng theo chiều giá, phát hiện phân kỳ',
    params: [],
  ),
  TechnicalIndicator(
    id: 'ichimoku',
    name: 'Ichimoku Cloud',
    shortName: 'ICHI',
    categoryId: 'trend',
    color: AppColors.buyDark,
    description: 'Hệ thống đa chỉ số: xu hướng, hỗ trợ/kháng cự, động lượng',
    params: [
      TechnicalIndicatorParam(label: 'Tenkan', value: 9),
      TechnicalIndicatorParam(label: 'Kijun', value: 26),
      TechnicalIndicatorParam(label: 'Senkou', value: 52),
    ],
  ),
];

const List<AdvancedDrawingTool> _advancedChartDrawingTools = [
  AdvancedDrawingTool(
    id: 'trendline',
    name: 'Đường xu hướng',
    icon: Icons.timeline_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'hline',
    name: 'Đường ngang',
    icon: Icons.horizontal_rule_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'channel',
    name: 'Kênh giá',
    icon: Icons.stacked_line_chart_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'ray',
    name: 'Tia',
    icon: Icons.trending_up_rounded,
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'rect',
    name: 'Hình chữ nhật',
    icon: Icons.crop_square_rounded,
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'circle',
    name: 'Hình tròn',
    icon: Icons.circle_outlined,
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'text',
    name: 'Ghi chú',
    icon: Icons.notes_rounded,
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'fib_ret',
    name: 'Fibonacci Retracement',
    icon: Icons.format_list_numbered_rounded,
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'fib_ext',
    name: 'Fibonacci Extension',
    icon: Icons.bar_chart_rounded,
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'fib_fan',
    name: 'Fibonacci Fan',
    icon: Icons.radar_rounded,
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'measure',
    name: 'Đo khoảng cách',
    icon: Icons.straighten_rounded,
    categoryId: 'measure',
  ),
  AdvancedDrawingTool(
    id: 'daterange',
    name: 'Đo thời gian',
    icon: Icons.date_range_rounded,
    categoryId: 'measure',
  ),
];

const List<TechSignalSummaryDraft> _advancedChartSignalSummaries = [
  TechSignalSummaryDraft(
    pair: 'BTC/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.strongBuy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.buy,
    buyCount: 9,
    sellCount: 2,
    neutralCount: 1,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 62100),
      TechPivotPointDraft(label: 'S2', value: 64200),
      TechPivotPointDraft(label: 'S1', value: 65800),
      TechPivotPointDraft(label: 'Pivot', value: 67000),
      TechPivotPointDraft(label: 'R1', value: 68500),
      TechPivotPointDraft(label: 'R2', value: 70100),
      TechPivotPointDraft(label: 'R3', value: 72300),
    ],
  ),
  TechSignalSummaryDraft(
    pair: 'ETH/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.buy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.neutral,
    buyCount: 7,
    sellCount: 3,
    neutralCount: 2,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 3220),
      TechPivotPointDraft(label: 'S2', value: 3340),
      TechPivotPointDraft(label: 'S1', value: 3420),
      TechPivotPointDraft(label: 'Pivot', value: 3500),
      TechPivotPointDraft(label: 'R1', value: 3580),
      TechPivotPointDraft(label: 'R2', value: 3680),
      TechPivotPointDraft(label: 'R3', value: 3800),
    ],
  ),
  TechSignalSummaryDraft(
    pair: 'SOL/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.strongBuy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.buy,
    buyCount: 10,
    sellCount: 1,
    neutralCount: 1,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 155),
      TechPivotPointDraft(label: 'S2', value: 162),
      TechPivotPointDraft(label: 'S1', value: 168),
      TechPivotPointDraft(label: 'Pivot', value: 175),
      TechPivotPointDraft(label: 'R1', value: 182),
      TechPivotPointDraft(label: 'R2', value: 190),
      TechPivotPointDraft(label: 'R3', value: 198),
    ],
  ),
];

const MarketScreenFilters _tokenUnlockFilters = MarketScreenFilters(
  categories: ['Sắp mở khóa', 'Phân tích', 'Lịch trình'],
  defaultCategory: 'Sắp mở khóa',
  defaultSort: 'nearest',
  sortOptions: [
    MarketSortOption(id: 'nearest', label: 'Gần nhất'),
    MarketSortOption(id: 'value', label: 'Giá trị cao'),
    MarketSortOption(id: 'impact', label: 'Tác động lớn'),
  ],
);

const Map<MarketUnlockImpact, UnlockImpactConfig> _unlockImpactConfigs = {
  MarketUnlockImpact.high: UnlockImpactConfig(
    label: 'Cao',
    color: AppColors.sell,
  ),
  MarketUnlockImpact.medium: UnlockImpactConfig(
    label: 'Trung bình',
    color: AppColors.warn,
  ),
  MarketUnlockImpact.low: UnlockImpactConfig(
    label: 'Thấp',
    color: AppColors.buy,
  ),
};

const Map<MarketUnlockCategory, UnlockCategoryConfig> _unlockCategoryConfigs = {
  MarketUnlockCategory.team: UnlockCategoryConfig(
    label: 'Team',
    color: AppColors.info,
  ),
  MarketUnlockCategory.investor: UnlockCategoryConfig(
    label: 'Nhà đầu tư',
    color: AppColors.sell,
  ),
  MarketUnlockCategory.ecosystem: UnlockCategoryConfig(
    label: 'Hệ sinh thái',
    color: AppColors.buy,
  ),
  MarketUnlockCategory.community: UnlockCategoryConfig(
    label: 'Cộng đồng',
    color: AppColors.warn,
  ),
  MarketUnlockCategory.foundation: UnlockCategoryConfig(
    label: 'Quỹ',
    color: AppColors.accent,
  ),
};
