part of '../repositories/mock_trade_repository.dart';

final class _FuturesLeverageRisk {
  const _FuturesLeverageRisk({
    required this.label,
    required this.colorHex,
    required this.level,
  });

  final String label;
  final int colorHex;
  final int level;
}

_FuturesLeverageRisk _futuresLeverageRisk(int leverage) {
  if (leverage <= 3) {
    return const _FuturesLeverageRisk(
      label: 'Rất thấp',
      colorHex: 0xFF10B981,
      level: 1,
    );
  }
  if (leverage <= 5) {
    return const _FuturesLeverageRisk(
      label: 'Thấp',
      colorHex: 0xFF10B981,
      level: 2,
    );
  }
  if (leverage <= 10) {
    return const _FuturesLeverageRisk(
      label: 'Trung bình thấp',
      colorHex: 0xFF84CC16,
      level: 3,
    );
  }
  if (leverage <= 20) {
    return const _FuturesLeverageRisk(
      label: 'Trung bình',
      colorHex: 0xFFF59E0B,
      level: 4,
    );
  }
  if (leverage <= 50) {
    return const _FuturesLeverageRisk(
      label: 'Cao',
      colorHex: 0xFFF97316,
      level: 5,
    );
  }
  return const _FuturesLeverageRisk(
    label: 'Rất cao',
    colorHex: 0xFFEF4444,
    level: 6,
  );
}

String _futuresLeverageWarning(int leverage) {
  if (leverage > 50) {
    return 'Đòn bẩy cực kỳ cao! Giá chỉ cần biến động nhỏ cũng có thể thanh lý toàn bộ vị thế. Chỉ dành cho trader có kinh nghiệm.';
  }
  if (leverage > 20) {
    return 'Đòn bẩy cao làm tăng đáng kể rủi ro thanh lý. Hãy đảm bảo quản lý rủi ro chặt chẽ với Stop Loss.';
  }
  return 'Đòn bẩy giúp khuếch đại lợi nhuận nhưng cũng tăng rủi ro. Luôn sử dụng Take Profit và Stop Loss.';
}

const List<TradeFuturesPosition> _futuresPositions = [
  TradeFuturesPosition(
    id: 'fp1',
    symbol: 'ETH/USDT',
    side: TradeFuturesSide.long,
    leverage: 10,
    size: .5,
    entryPrice: 3480,
    markPrice: 3521.45,
    liquidPrice: 3150,
    pnl: 20.73,
    pnlPct: 1.19,
    margin: 174,
    roe: 11.9,
  ),
  TradeFuturesPosition(
    id: 'fp2',
    symbol: 'SOL/USDT',
    side: TradeFuturesSide.short,
    leverage: 5,
    size: 10,
    entryPrice: 185,
    markPrice: 178.32,
    liquidPrice: 222,
    pnl: 66.80,
    pnlPct: 3.61,
    margin: 370,
    roe: 18.05,
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

const List<TradeMarginHubStat> _marginHubStats = [
  TradeMarginHubStat(
    label: 'Total Features',
    value: '27',
    colorHex: 0xFF10B981,
  ),
  TradeMarginHubStat(
    label: 'Lines of Code',
    value: '~5,100',
    colorHex: 0xFF3B82F6,
  ),
  TradeMarginHubStat(label: 'Components', value: '19', colorHex: 0xFFF59E0B),
  TradeMarginHubStat(label: 'Compliance', value: '100%', colorHex: 0xFF8B5CF6),
];

const List<TradeMarginHubMenuItem> _marginHubMenuItems = [
  TradeMarginHubMenuItem(
    id: 'margin',
    title: 'Margin Trading',
    subtitle: 'Trade voi don bay - P0 Compliance day du',
    badge: 'LIVE',
    colorHex: 0xFF10B981,
    targetPath: '/trade/margin',
  ),
  TradeMarginHubMenuItem(
    id: 'advanced-controls',
    title: 'Advanced Controls',
    subtitle: 'Partial close, Ladder TP/SL, Trailing Stop, Order types',
    badge: 'P1',
    colorHex: 0xFF3B82F6,
    targetPath: '/trade/margin/advanced-demo',
  ),
  TradeMarginHubMenuItem(
    id: 'market-analytics',
    title: 'Market Analytics',
    subtitle: 'OI, Long/Short Ratio, Liquidation Heatmap, Sentiment',
    badge: 'P2',
    colorHex: 0xFFF59E0B,
    targetPath: '/trade/margin/live-market-data-analytics',
  ),
  TradeMarginHubMenuItem(
    id: 'ai-advanced',
    title: 'AI & Advanced Analytics',
    subtitle: 'AI Signals, Risk Analysis, Trade Journal, Position Sizing',
    badge: 'P3',
    colorHex: 0xFF8B5CF6,
    targetPath: '/trade/margin/advanced-analytics',
  ),
];

const List<TradeMarginHubFeature> _marginHubFeatures = [
  TradeMarginHubFeature(
    phase: 'P0',
    title: 'Regulatory & Safety',
    colorHex: 0xFFEF4444,
    items: [
      'Appropriateness Test (quiz system)',
      'Regional Leverage Limits (EU 2x, UK 2x, SG 20x)',
      'Margin Call Alerts (4 thresholds)',
      'Mark Price Separation (liquidation accuracy)',
      'Total Cost Breakdown (MiFID II compliance)',
      'Negative Balance Protection',
      '50% Closeout Warning (EU/UK)',
      'Best Execution Disclosure',
    ],
  ),
  TradeMarginHubFeature(
    phase: 'P1',
    title: 'Advanced Controls',
    colorHex: 0xFF3B82F6,
    items: [
      'Partial Close Position (25%/50%/75%/100%)',
      'Ladder TP/SL (unlimited levels)',
      'Trailing Stop Loss (% or \$ based)',
      'Position Mode Toggle (One-way vs Hedge)',
      'Add/Reduce Margin dynamically',
      'Advanced Order Types (IOC, FOK, Post-Only)',
      'Iceberg Orders (hidden size)',
      'Realized vs Unrealized PnL tracking',
    ],
  ),
  TradeMarginHubFeature(
    phase: 'P2',
    title: 'Market Data & Analytics',
    colorHex: 0xFFF59E0B,
    items: [
      'Open Interest tracking',
      'Long/Short Ratio (Accounts vs Volume)',
      'Top Trader Positions',
      'Market Sentiment (Fear & Greed)',
      'Funding Rate History (24h sparkline)',
      'Liquidation Heatmap (cluster zones)',
      'Recent Liquidations Feed (live)',
      'Period Performance (24h/7d/30d)',
    ],
  ),
];

const TradeMarginHubCompliance _marginHubCompliance = TradeMarginHubCompliance(
  title: 'Fully Regulatory Compliant',
  description:
      'Dap ung MiFID II, ESMA, FCA (UK), MAS (Singapore) regulations. Production-ready cho EU, UK, SG markets.',
  regulations: ['MiFID II', 'ESMA', 'FCA (UK)', 'MAS (SG)'],
);
