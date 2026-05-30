part of '../repositories/mock_trade_repository.dart';

List<TradeCopyConfigurationValidation> _copyConfigurationValidations(
  TradeCopyConfigurationDraft draft,
  TradeCopyTrader? provider,
) {
  const totalPortfolio = 25000.0;
  const currentCopyAllocation = 8000.0;
  const availableCapital = totalPortfolio - currentCopyAllocation;
  final allocationPercent = draft.copyCapital / totalPortfolio * 100;
  final newTotalAllocationPercent =
      (currentCopyAllocation + draft.copyCapital) / totalPortfolio * 100;

  final issues = <TradeCopyConfigurationValidation>[];
  if (draft.copyCapital < 100) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.error,
        message: 'Số tiền copy tối thiểu là \$100',
      ),
    );
  }
  if (draft.copyCapital > availableCapital) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.error,
        message: 'Vốn khả dụng chỉ còn \$17000',
      ),
    );
  }
  if (allocationPercent > 20) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.error,
        message: 'Không được copy quá 20% tổng vốn cho 1 provider',
      ),
    );
  }
  if (newTotalAllocationPercent > 70) {
    issues.add(
      TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message:
            'Tổng vốn copy sẽ là ${newTotalAllocationPercent.toStringAsFixed(0)}%',
      ),
    );
  }
  if (allocationPercent > 15) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message: 'Phân bổ trên 15% cho 1 provider tăng rủi ro tập trung',
      ),
    );
  }
  if (provider != null &&
      provider.maxDrawdown > 30 &&
      !draft.useCustomStopLoss) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message: 'Provider có Max DD cao, nên đặt stop-loss riêng',
      ),
    );
  }
  if (provider != null &&
      provider.riskLevel == TradeCopyRiskLevel.high &&
      draft.copyMode == TradeCopyConfigurationMode.mirror) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message: 'Mirror copy với high-risk provider là rủi ro cao',
      ),
    );
  }
  if (draft.useTrailingStop) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.info,
        message: 'Trailing stop giúp bảo vệ lợi nhuận khi thị trường đảo chiều',
      ),
    );
  }
  return issues;
}

List<TradeCopyScenarioProjection> _copyScenarioProjections(
  TradeCopyConfigurationDraft draft,
  TradeCopyConfigurationFeePreview feePreview,
) {
  return [
    _copyScenarioProjection(
      id: 'optimistic',
      title: 'Kịch bản tốt',
      returnPct: 15,
      draft: draft,
      feePreview: feePreview,
    ),
    _copyScenarioProjection(
      id: 'realistic',
      title: 'Kịch bản thực tế',
      returnPct: 5,
      draft: draft,
      feePreview: feePreview,
    ),
    _copyScenarioProjection(
      id: 'pessimistic',
      title: 'Kịch bản xấu',
      returnPct: -10,
      draft: draft,
      feePreview: feePreview,
    ),
  ];
}

TradeCopyScenarioProjection _copyScenarioProjection({
  required String id,
  required String title,
  required double returnPct,
  required TradeCopyConfigurationDraft draft,
  required TradeCopyConfigurationFeePreview feePreview,
}) {
  final grossPnl = draft.copyCapital * returnPct / 100;
  final performanceFee = grossPnl > 0 ? grossPnl * 0.1 : 0.0;
  final slippageLoss = grossPnl.abs() * 0.015;
  final fixedFees = feePreview.totalFixedFees;
  final netPnl = grossPnl - performanceFee - slippageLoss - fixedFees;
  return TradeCopyScenarioProjection(
    id: id,
    title: title,
    returnPct: returnPct,
    grossPnl: grossPnl,
    performanceFee: performanceFee,
    slippageLoss: slippageLoss,
    fixedFees: fixedFees,
    netPnl: netPnl,
    netReturnPct: netPnl / draft.copyCapital * 100,
  );
}

const List<TradeCopyConsentItem> _copyConfirmationConsents = [
  TradeCopyConsentItem(
    id: 'risk',
    label:
        'Tôi hiểu Copy Trading có rủi ro cao và hiệu suất quá khứ không đảm bảo kết quả tương lai.',
    required: true,
  ),
  TradeCopyConsentItem(
    id: 'fees',
    label:
        'Tôi đã đọc và hiểu tất cả khoản phí gồm platform fee, trading fee, performance fee và slippage.',
    required: true,
  ),
  TradeCopyConsentItem(
    id: 'loss',
    label:
        'Tôi xác nhận số vốn copy là số tiền tôi có thể chấp nhận mất hoàn toàn.',
    required: true,
  ),
  TradeCopyConsentItem(
    id: 'terms',
    label: 'Tôi đồng ý với điều khoản sử dụng và chính sách Copy Trading.',
    required: true,
  ),
];

const List<TradeCopyEquityPoint> _copyPerformanceEquityCurve = [
  TradeCopyEquityPoint(day: 1, you: 5000, provider: 5000),
  TradeCopyEquityPoint(day: 2, you: 5038, provider: 5056),
  TradeCopyEquityPoint(day: 3, you: 5072, provider: 5108),
  TradeCopyEquityPoint(day: 4, you: 5128, provider: 5155),
  TradeCopyEquityPoint(day: 5, you: 5115, provider: 5198),
  TradeCopyEquityPoint(day: 6, you: 5162, provider: 5236),
  TradeCopyEquityPoint(day: 7, you: 5178, provider: 5288),
  TradeCopyEquityPoint(day: 8, you: 5220, provider: 5320),
  TradeCopyEquityPoint(day: 9, you: 5242, provider: 5368),
  TradeCopyEquityPoint(day: 10, you: 5280, provider: 5410),
  TradeCopyEquityPoint(day: 11, you: 5265, provider: 5460),
  TradeCopyEquityPoint(day: 12, you: 5324, provider: 5508),
  TradeCopyEquityPoint(day: 13, you: 5350, provider: 5558),
  TradeCopyEquityPoint(day: 14, you: 5310, provider: 5598),
  TradeCopyEquityPoint(day: 15, you: 5388, provider: 5632),
  TradeCopyEquityPoint(day: 16, you: 5426, provider: 5684),
  TradeCopyEquityPoint(day: 17, you: 5405, provider: 5726),
  TradeCopyEquityPoint(day: 18, you: 5484, provider: 5578),
  TradeCopyEquityPoint(day: 19, you: 5456, provider: 5606),
  TradeCopyEquityPoint(day: 20, you: 5520, provider: 5630),
  TradeCopyEquityPoint(day: 21, you: 5492, provider: 5662),
  TradeCopyEquityPoint(day: 22, you: 5568, provider: 5680),
  TradeCopyEquityPoint(day: 23, you: 5590, provider: 5718),
  TradeCopyEquityPoint(day: 24, you: 5635, provider: 5695),
  TradeCopyEquityPoint(day: 25, you: 5680, provider: 5725),
  TradeCopyEquityPoint(day: 26, you: 5664, provider: 5750),
  TradeCopyEquityPoint(day: 27, you: 5705, provider: 5768),
  TradeCopyEquityPoint(day: 28, you: 5724, provider: 5795),
  TradeCopyEquityPoint(day: 29, you: 5768, provider: 5818),
  TradeCopyEquityPoint(day: 30, you: 5650, provider: 5780),
];

const List<TradeCopySlippageBucket> _copyPerformanceSlippageBuckets = [
  TradeCopySlippageBucket(range: '0-0.5%', youPct: 45, providerPct: 52),
  TradeCopySlippageBucket(range: '0.5-1%', youPct: 30, providerPct: 28),
  TradeCopySlippageBucket(range: '1-2%', youPct: 18, providerPct: 15),
  TradeCopySlippageBucket(range: '2%+', youPct: 7, providerPct: 5),
];

const List<TradeCopyCostAttribution> _copyPerformanceCostAttribution = [
  TradeCopyCostAttribution(
    name: 'Trading Fees',
    value: 125,
    colorHex: 0xFFEF4444,
  ),
  TradeCopyCostAttribution(
    name: 'Performance Fee',
    value: 65,
    colorHex: 0xFFF59E0B,
  ),
  TradeCopyCostAttribution(name: 'Slippage', value: 95, colorHex: 0xFF6B7280),
  TradeCopyCostAttribution(
    name: 'Platform Fee',
    value: 5,
    colorHex: 0xFF3B82F6,
  ),
];

const List<TradeCopyTradeComparison> _copyPerformanceTrades = [
  TradeCopyTradeComparison(
    id: 't1',
    pair: 'BTC/USDT',
    side: TradeOrderSide.buy,
    providerEntry: 67800,
    yourEntry: 67835,
    providerExit: 68500,
    yourExit: 68480,
    providerPnl: 35,
    yourPnl: 32,
    slippagePct: .52,
    delay: '2.1s',
    timestamp: '2024-03-05 14:23',
  ),
  TradeCopyTradeComparison(
    id: 't2',
    pair: 'ETH/USDT',
    side: TradeOrderSide.sell,
    providerEntry: 3850,
    yourEntry: 3848,
    providerExit: 3825,
    yourExit: 3822,
    providerPnl: 50,
    yourPnl: 52,
    slippagePct: .31,
    delay: '1.8s',
    timestamp: '2024-03-04 09:15',
  ),
  TradeCopyTradeComparison(
    id: 't3',
    pair: 'SOL/USDT',
    side: TradeOrderSide.buy,
    providerEntry: 142,
    yourEntry: 142.5,
    providerExit: 138,
    yourExit: 138.2,
    providerPnl: -40,
    yourPnl: -43,
    slippagePct: .71,
    delay: '3.2s',
    timestamp: '2024-03-03 16:42',
  ),
];

const List<TradeCopyMetricComparison> _copyPerformanceMetrics = [
  TradeCopyMetricComparison(
    name: 'Sharpe Ratio',
    you: 1.82,
    provider: 2.15,
    higherIsBetter: true,
  ),
  TradeCopyMetricComparison(
    name: 'Max Drawdown',
    you: -8.5,
    provider: -6.2,
    higherIsBetter: false,
    suffix: '%',
  ),
  TradeCopyMetricComparison(
    name: 'Win Rate',
    you: 62.5,
    provider: 68.3,
    higherIsBetter: true,
    suffix: '%',
  ),
  TradeCopyMetricComparison(
    name: 'Avg Win/Loss',
    you: 1.42,
    provider: 1.68,
    higherIsBetter: true,
  ),
];

const List<TradePerformanceReturnPoint> _performanceAttributionReturns = [
  TradePerformanceReturnPoint(day: 1, market: .3, alpha: .4),
  TradePerformanceReturnPoint(day: 2, market: .7, alpha: .1),
  TradePerformanceReturnPoint(day: 3, market: 1.2, alpha: -.2),
  TradePerformanceReturnPoint(day: 4, market: 1.8, alpha: -.5),
  TradePerformanceReturnPoint(day: 5, market: 2.5, alpha: -.8),
  TradePerformanceReturnPoint(day: 6, market: 3.8, alpha: -1.1),
  TradePerformanceReturnPoint(day: 7, market: 3.1, alpha: -.4),
  TradePerformanceReturnPoint(day: 8, market: 4.4, alpha: -.9),
  TradePerformanceReturnPoint(day: 9, market: 4.7, alpha: -.6),
  TradePerformanceReturnPoint(day: 10, market: 5.6, alpha: -1.2),
  TradePerformanceReturnPoint(day: 11, market: 6.4, alpha: -.3),
  TradePerformanceReturnPoint(day: 12, market: 5.1, alpha: .2),
  TradePerformanceReturnPoint(day: 13, market: 4.8, alpha: -.2),
  TradePerformanceReturnPoint(day: 14, market: 6.2, alpha: -.8),
  TradePerformanceReturnPoint(day: 15, market: 8.4, alpha: -.3),
  TradePerformanceReturnPoint(day: 16, market: 8.1, alpha: -.7),
  TradePerformanceReturnPoint(day: 17, market: 9.2, alpha: -1.4),
  TradePerformanceReturnPoint(day: 18, market: 10.6, alpha: -2.1),
  TradePerformanceReturnPoint(day: 19, market: 10.7, alpha: -1.8),
  TradePerformanceReturnPoint(day: 20, market: 11.5, alpha: -1.9),
  TradePerformanceReturnPoint(day: 21, market: 9.8, alpha: .1),
  TradePerformanceReturnPoint(day: 22, market: 10.2, alpha: -.2),
  TradePerformanceReturnPoint(day: 23, market: 10.1, alpha: -.1),
  TradePerformanceReturnPoint(day: 24, market: 11.7, alpha: .9),
  TradePerformanceReturnPoint(day: 25, market: 13.5, alpha: .1),
  TradePerformanceReturnPoint(day: 26, market: 13.0, alpha: -.8),
  TradePerformanceReturnPoint(day: 27, market: 11.6, alpha: -2.4),
  TradePerformanceReturnPoint(day: 28, market: 11.2, alpha: -2.1),
  TradePerformanceReturnPoint(day: 29, market: 12.0, alpha: -2.8),
  TradePerformanceReturnPoint(day: 30, market: 13.4, alpha: -4.1),
];

const List<TradePerformanceDrawdownPoint> _performanceAttributionDrawdowns = [
  TradePerformanceDrawdownPoint(day: 1, drawdown: 0),
  TradePerformanceDrawdownPoint(day: 2, drawdown: -.4),
  TradePerformanceDrawdownPoint(day: 3, drawdown: -1.1),
  TradePerformanceDrawdownPoint(day: 4, drawdown: -2.3),
  TradePerformanceDrawdownPoint(day: 5, drawdown: -1.6),
  TradePerformanceDrawdownPoint(day: 6, drawdown: -3.8),
  TradePerformanceDrawdownPoint(day: 7, drawdown: -2.9),
  TradePerformanceDrawdownPoint(day: 8, drawdown: -4.4),
  TradePerformanceDrawdownPoint(day: 9, drawdown: -5.1),
  TradePerformanceDrawdownPoint(day: 10, drawdown: -3.7),
  TradePerformanceDrawdownPoint(day: 11, drawdown: -2.5),
  TradePerformanceDrawdownPoint(day: 12, drawdown: -6.2),
  TradePerformanceDrawdownPoint(day: 13, drawdown: -7.6),
  TradePerformanceDrawdownPoint(day: 14, drawdown: -5.8),
  TradePerformanceDrawdownPoint(day: 15, drawdown: -4.2),
  TradePerformanceDrawdownPoint(day: 16, drawdown: -8.7),
  TradePerformanceDrawdownPoint(day: 17, drawdown: -7.9),
  TradePerformanceDrawdownPoint(day: 18, drawdown: -6.4),
  TradePerformanceDrawdownPoint(day: 19, drawdown: -5.6),
  TradePerformanceDrawdownPoint(day: 20, drawdown: -4.0),
  TradePerformanceDrawdownPoint(day: 21, drawdown: -3.3),
  TradePerformanceDrawdownPoint(day: 22, drawdown: -5.2),
  TradePerformanceDrawdownPoint(day: 23, drawdown: -4.7),
  TradePerformanceDrawdownPoint(day: 24, drawdown: -3.1),
  TradePerformanceDrawdownPoint(day: 25, drawdown: -2.0),
  TradePerformanceDrawdownPoint(day: 26, drawdown: -3.6),
  TradePerformanceDrawdownPoint(day: 27, drawdown: -4.8),
  TradePerformanceDrawdownPoint(day: 28, drawdown: -2.8),
  TradePerformanceDrawdownPoint(day: 29, drawdown: -1.5),
  TradePerformanceDrawdownPoint(day: 30, drawdown: -2.2),
];

const List<List<TradePerformanceProjectionPoint>>
_performanceAttributionProjectionPaths = [
  [
    TradePerformanceProjectionPoint(day: 1, value: 5000),
    TradePerformanceProjectionPoint(day: 5, value: 5085),
    TradePerformanceProjectionPoint(day: 10, value: 5220),
    TradePerformanceProjectionPoint(day: 15, value: 5350),
    TradePerformanceProjectionPoint(day: 20, value: 5480),
    TradePerformanceProjectionPoint(day: 25, value: 5575),
    TradePerformanceProjectionPoint(day: 30, value: 5630),
  ],
  [
    TradePerformanceProjectionPoint(day: 1, value: 5000),
    TradePerformanceProjectionPoint(day: 5, value: 4925),
    TradePerformanceProjectionPoint(day: 10, value: 5050),
    TradePerformanceProjectionPoint(day: 15, value: 4980),
    TradePerformanceProjectionPoint(day: 20, value: 5120),
    TradePerformanceProjectionPoint(day: 25, value: 5060),
    TradePerformanceProjectionPoint(day: 30, value: 4920),
  ],
  [
    TradePerformanceProjectionPoint(day: 1, value: 5000),
    TradePerformanceProjectionPoint(day: 5, value: 5155),
    TradePerformanceProjectionPoint(day: 10, value: 5340),
    TradePerformanceProjectionPoint(day: 15, value: 5590),
    TradePerformanceProjectionPoint(day: 20, value: 5840),
    TradePerformanceProjectionPoint(day: 25, value: 6120),
    TradePerformanceProjectionPoint(day: 30, value: 6425),
  ],
];

const List<TradePerformanceCorrelationPoint>
_performanceAttributionCorrelation = [
  TradePerformanceCorrelationPoint(day: 1, marketReturn: -2, yourReturn: -1.8),
  TradePerformanceCorrelationPoint(day: 2, marketReturn: 1.5, yourReturn: 1.2),
  TradePerformanceCorrelationPoint(day: 3, marketReturn: -.5, yourReturn: -.3),
  TradePerformanceCorrelationPoint(day: 4, marketReturn: 2, yourReturn: 2.5),
  TradePerformanceCorrelationPoint(day: 5, marketReturn: .8, yourReturn: .6),
  TradePerformanceCorrelationPoint(day: 6, marketReturn: -1, yourReturn: -.8),
  TradePerformanceCorrelationPoint(day: 7, marketReturn: 1.2, yourReturn: 1.5),
  TradePerformanceCorrelationPoint(day: 8, marketReturn: -.3, yourReturn: .2),
  TradePerformanceCorrelationPoint(day: 9, marketReturn: 1.8, yourReturn: 1.6),
  TradePerformanceCorrelationPoint(
    day: 10,
    marketReturn: -1.5,
    yourReturn: -1.2,
  ),
];

const List<TradeProviderComparisonMetric> _providerComparisonMetrics = [
  TradeProviderComparisonMetric(
    label: 'Total ROI',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: '30D Return',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Win Rate',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Trade',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Sharpe Ratio',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Max Drawdown',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Volatility',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Risk Score',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Slippage',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Delay',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Fill Rate',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Performance Fee',
    category: TradeProviderComparisonCategory.cost,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Est. Monthly Cost',
    category: TradeProviderComparisonCategory.cost,
    higherIsBetter: false,
    values: {},
  ),
];

const List<TradeCopyAuditExportFormat> _copyAuditExportFormats = [
  TradeCopyAuditExportFormat(
    id: 'csv',
    label: 'CSV',
    description: 'Excel-compatible spreadsheet',
  ),
  TradeCopyAuditExportFormat(
    id: 'pdf',
    label: 'PDF',
    description: 'Printable document',
  ),
  TradeCopyAuditExportFormat(
    id: 'json',
    label: 'JSON',
    description: 'Raw data for developers',
  ),
];
