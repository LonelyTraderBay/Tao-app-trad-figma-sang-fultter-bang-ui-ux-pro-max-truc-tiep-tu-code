part of '../repositories/mock_trade_repository.dart';

const List<TradeDashboardPosition> _dashboardPositions = [
  TradeDashboardPosition(
    id: 'sp1',
    symbol: 'BTC/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: .045,
    entryPrice: 65200,
    currentPrice: 67543.21,
    pnl: 105.44,
    pnlPct: 3.59,
    takeProfit: 72000,
    stopLoss: 63000,
  ),
  TradeDashboardPosition(
    id: 'sp2',
    symbol: 'ETH/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: 1.2,
    entryPrice: 3380,
    currentPrice: 3521.45,
    pnl: 169.74,
    pnlPct: 4.18,
  ),
  TradeDashboardPosition(
    id: 'sp3',
    symbol: 'SOL/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: 25,
    entryPrice: 192,
    currentPrice: 185.32,
    pnl: -167,
    pnlPct: -3.48,
  ),
  TradeDashboardPosition(
    id: 'ft1',
    symbol: 'ETH/USDT',
    type: TradePositionType.futures,
    side: TradePositionSide.long,
    size: .5,
    entryPrice: 3480,
    currentPrice: 3521.45,
    pnl: 20.73,
    pnlPct: 1.19,
    leverage: 10,
    liquidPrice: 3150,
    margin: 174,
    takeProfit: 3800,
    stopLoss: 3300,
  ),
  TradeDashboardPosition(
    id: 'ft2',
    symbol: 'SOL/USDT',
    type: TradePositionType.futures,
    side: TradePositionSide.short,
    size: 10,
    entryPrice: 185,
    currentPrice: 178.32,
    pnl: 66.8,
    pnlPct: 3.61,
    leverage: 5,
    liquidPrice: 222,
    margin: 370,
  ),
  TradeDashboardPosition(
    id: 'mg1',
    symbol: 'BTC/USDT',
    type: TradePositionType.margin,
    side: TradePositionSide.long,
    size: .02,
    entryPrice: 66800,
    currentPrice: 67543.21,
    pnl: 14.86,
    pnlPct: 1.11,
    leverage: 3,
    margin: 445.33,
  ),
];

const List<TradeBotStrategy> _botStrategies = [
  TradeBotStrategy(
    id: 'dca',
    name: 'DCA Bot',
    description: 'Dollar Cost Averaging - Mua định kỳ, giảm rủi ro biến động',
    longDescription:
        'DCA Bot tự động mua một lượng cố định theo chu kỳ thời gian, bất kể giá tăng hay giảm.',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    risk: TradeBotRisk.low,
    avgReturn: '+8-15% / năm',
    suitableFor: 'Nhà đầu tư dài hạn, người mới',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT', 'BNB/USDT'],
      ),
      TradeBotParam(
        key: 'amount',
        label: 'Mỗi lần mua',
        type: 'number',
        defaultValue: '50',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'interval',
        label: 'Chu kỳ',
        type: 'select',
        defaultValue: 'Mỗi ngày',
        options: ['Mỗi giờ', 'Mỗi ngày', 'Mỗi tuần', 'Mỗi tháng'],
      ),
      TradeBotParam(
        key: 'totalBudget',
        label: 'Ngân sách tổng',
        type: 'number',
        defaultValue: '1000',
        unit: 'USDT',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'grid',
    name: 'Grid Bot',
    description: 'Lưới giá - Mua thấp bán cao tự động trong khoảng giá',
    longDescription:
        'Grid Bot đặt nhiều lệnh mua và bán trong khoảng giá xác định, tự động kiếm lời khi thị trường đi ngang.',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    risk: TradeBotRisk.medium,
    avgReturn: '+15-40% / năm',
    suitableFor: 'Thị trường sideway, trader kinh nghiệm',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'ETH/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'upperPrice',
        label: 'Giá trần',
        type: 'number',
        defaultValue: '4000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'lowerPrice',
        label: 'Giá sàn',
        type: 'number',
        defaultValue: '3000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'gridCount',
        label: 'Số lưới',
        type: 'number',
        defaultValue: '20',
        unit: 'lưới',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    description: 'Theo đà thị trường - Mua khi uptrend, bán khi downtrend',
    longDescription:
        'Momentum Bot sử dụng chỉ báo kỹ thuật để xác định xu hướng và tự động vào/ra lệnh.',
    icon: 'chart',
    colorHex: 0xFF10B981,
    risk: TradeBotRisk.medium,
    avgReturn: '+20-50% / năm',
    suitableFor: 'Thị trường trending, trader trung cấp',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'investment',
        label: 'Vốn giao dịch',
        type: 'number',
        defaultValue: '500',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'stopLoss',
        label: 'Stop loss',
        type: 'number',
        defaultValue: '5',
        unit: '%',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    description: 'Tăng gấp đôi khi thua - Phục hồi nhanh sau drawdown',
    longDescription:
        'Martingale tăng kích thước lệnh sau mỗi lần thua để bù đắp khi thắng. Tiềm năng lợi nhuận cao nhưng rủi ro cũng cao.',
    icon: 'target',
    colorHex: 0xFF8B5CF6,
    risk: TradeBotRisk.high,
    avgReturn: '+30-80% / năm',
    suitableFor: 'Trader chuyên nghiệp, vốn lớn',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'baseOrder',
        label: 'Lệnh cơ bản',
        type: 'number',
        defaultValue: '20',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'multiplier',
        label: 'Hệ số nhân',
        type: 'number',
        defaultValue: '2',
        unit: 'x',
      ),
    ],
  ),
];

const List<TradeBot> _activeBots = [
  TradeBot(
    id: 'bot1',
    strategyId: 'dca',
    strategyName: 'DCA Bot',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    pair: 'BTC/USDT',
    status: TradeBotStatus.running,
    profit: 84.20,
    profitPct: 8.42,
    trades: 47,
    investment: 1000,
    startDate: '01/01/2026',
    runtime: '52 ngày',
  ),
  TradeBot(
    id: 'bot2',
    strategyId: 'grid',
    strategyName: 'Grid Bot',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    pair: 'ETH/USDT',
    status: TradeBotStatus.running,
    profit: 127.40,
    profitPct: 25.48,
    trades: 234,
    investment: 500,
    startDate: '15/01/2026',
    runtime: '38 ngày',
  ),
  TradeBot(
    id: 'bot3',
    strategyId: 'momentum',
    strategyName: 'Momentum Bot',
    icon: 'chart',
    colorHex: 0xFF10B981,
    pair: 'SOL/USDT',
    status: TradeBotStatus.paused,
    profit: -12.30,
    profitPct: -2.46,
    trades: 18,
    investment: 500,
    startDate: '10/02/2026',
    runtime: '13 ngày',
  ),
];

const List<TradeRiskFeature> _riskFeatures = [
  TradeRiskFeature(
    id: 'oco',
    title: 'OCO Orders',
    description:
        'Đặt Take Profit + Stop Loss cùng lúc. Khi 1 lệnh khớp, lệnh còn lại tự động hủy.',
    colorHex: 0xFF10B981,
    iconName: 'trending',
  ),
  TradeRiskFeature(
    id: 'positions',
    title: 'Position Dashboard',
    description:
        'Theo dõi P&L thời gian thực, entry price, break-even và liquidation risk.',
    colorHex: 0xFFF59E0B,
    iconName: 'check',
  ),
  TradeRiskFeature(
    id: 'calculator',
    title: 'Position Sizing Calculator',
    description:
        'Tính toán khối lượng lệnh tối ưu dựa trên risk % và stop loss.',
    colorHex: 0xFF8B5CF6,
    iconName: 'calculator',
  ),
];

const List<TradeRiskPosition> _riskPositions = [
  TradeRiskPosition(
    id: '1',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    logoColorHex: 0xFFF7931A,
    side: TradeRiskPositionSide.long,
    amount: 2.5,
    entryPrice: 67200,
    currentPrice: 69000,
    openedAtLabel: '10/03/2026 08:30',
  ),
  TradeRiskPosition(
    id: '2',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    logoColorHex: 0xFF627EEA,
    side: TradeRiskPositionSide.long,
    amount: 15,
    entryPrice: 3180,
    currentPrice: 3300,
    openedAtLabel: '09/03/2026 14:20',
  ),
  TradeRiskPosition(
    id: '3',
    symbol: 'SOL/USDT',
    baseAsset: 'SOL',
    logoColorHex: 0xFF14F195,
    side: TradeRiskPositionSide.short,
    amount: 100,
    entryPrice: 145,
    currentPrice: 142,
    leverage: 5,
    liquidationPrice: 155,
    openedAtLabel: '11/03/2026 09:00',
  ),
];

const List<TradeRiskStatusItem> _riskStatusItems = [
  TradeRiskStatusItem(label: 'OCO Order Form', complete: true),
  TradeRiskStatusItem(label: 'Position Dashboard', complete: true),
  TradeRiskStatusItem(label: 'Position Sizing Calculator', complete: true),
  TradeRiskStatusItem(label: 'Integration với TradePage', complete: false),
  TradeRiskStatusItem(label: 'Backend API Integration', complete: false),
];

const List<TradeExecutionFeature> _executionFeatures = [
  TradeExecutionFeature(
    id: 'slippage',
    title: 'Slippage Protection',
    description:
        'Set max slippage tolerance. Auto-reject orders nếu giá thực tế vượt ngưỡng.',
    colorHex: 0xFF10B981,
    iconName: 'shield',
  ),
  TradeExecutionFeature(
    id: 'execution',
    title: 'Execution Report',
    description:
        'Chi tiết multi-venue execution: slippage, savings, execution time, quality score.',
    colorHex: 0xFFF59E0B,
    iconName: 'report',
  ),
  TradeExecutionFeature(
    id: 'amendment',
    title: 'Order Amendment',
    description:
        'Modify open orders (price/quantity) mà không mất queue position.',
    colorHex: 0xFF8B5CF6,
    iconName: 'edit',
  ),
];

const TradeExecutionReport _executionReport = TradeExecutionReport(
  orderId: 'ORD-2026-03-11-A8F3D2',
  symbol: 'BTC/USDT',
  side: TradeOrderSide.buy,
  requestedAmount: 1,
  filledAmount: 1,
  expectedPrice: 69000,
  averageFillPrice: 69000.3,
  bestAvailablePrice: 69000,
  executionTimeMs: 480,
  slippagePct: .0004,
  savingsVsSingleVenue: 2.50,
  executionQuality: 'A',
  fills: [
    TradeExecutionFill(
      venue: 'Binance',
      amount: .5,
      price: 69001,
      fee: 34.50,
      timestampLabel: '10:15:32.120',
    ),
    TradeExecutionFill(
      venue: 'OKX',
      amount: .3,
      price: 69000,
      fee: 20.70,
      timestampLabel: '10:15:32.245',
    ),
    TradeExecutionFill(
      venue: 'Kraken',
      amount: .2,
      price: 68999,
      fee: 13.80,
      timestampLabel: '10:15:32.380',
    ),
  ],
);

const TradeExecutionOpenOrder _executionOpenOrder = TradeExecutionOpenOrder(
  id: 'ORD-2026-03-11-B9G4E3',
  symbol: 'BTC/USDT',
  side: TradeOrderSide.buy,
  type: 'limit',
  price: 68500,
  amount: .5,
  filled: .1,
  remaining: .4,
  queuePosition: 42,
  totalInQueue: 1250,
  supportsAmend: true,
);

const TradeSlippageSettings _defaultSlippageSettings = TradeSlippageSettings(
  tolerancePct: .5,
  rejectOnExceed: true,
  partialFillAllowed: false,
);

const List<TradeRiskStatusItem> _executionStatusItems = [
  TradeRiskStatusItem(label: 'Slippage Control Component', complete: true),
  TradeRiskStatusItem(label: 'Execution Report Component', complete: true),
  TradeRiskStatusItem(label: 'Order Amendment Component', complete: true),
  TradeRiskStatusItem(label: 'Integration với TradePage', complete: false),
  TradeRiskStatusItem(label: 'Multi-venue routing backend', complete: false),
  TradeRiskStatusItem(label: 'Order amendment API', complete: false),
];

const List<TradeAdvancedToolFeature> _advancedToolFeatures = [
  TradeAdvancedToolFeature(
    id: 'ladder',
    title: 'Ladder Trading',
    description:
        'Click bất kỳ giá nào trên order book để đặt lệnh ngay. One-click trading trên DOM.',
    colorHex: 0xFF10B981,
    iconName: 'target',
  ),
  TradeAdvancedToolFeature(
    id: 'bulk',
    title: 'Bulk Operations',
    description:
        'Select nhiều lệnh, cancel tất cả hoặc shift giá hàng loạt. Tiết kiệm thời gian.',
    colorHex: 0xFFF59E0B,
    iconName: 'bulk',
  ),
  TradeAdvancedToolFeature(
    id: 'shortcuts',
    title: 'Keyboard Shortcuts',
    description:
        'F1=Buy, F2=Sell, ESC=Cancel All. Trade nhanh hơn 3x với shortcuts tùy chỉnh.',
    colorHex: 0xFF8B5CF6,
    iconName: 'keyboard',
  ),
];

const List<TradeLadderOrder> _ladderOrders = [
  TradeLadderOrder(
    id: '1',
    price: 68800,
    amount: .5,
    side: TradeOrderSide.buy,
    filled: .1,
  ),
  TradeLadderOrder(
    id: '2',
    price: 69200,
    amount: .3,
    side: TradeOrderSide.sell,
    filled: 0,
  ),
];

const List<TradeBulkOrder> _bulkOrders = [
  TradeBulkOrder(
    id: 'o1',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: 'limit',
    price: 68500,
    amount: 1,
    filled: .2,
    remaining: .8,
    totalValue: 68500,
  ),
  TradeBulkOrder(
    id: 'o2',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: 'limit',
    price: 69500,
    amount: .8,
    filled: 0,
    remaining: .8,
    totalValue: 55600,
  ),
  TradeBulkOrder(
    id: 'o3',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.buy,
    type: 'limit',
    price: 3200,
    amount: 10,
    filled: 3,
    remaining: 7,
    totalValue: 32000,
  ),
  TradeBulkOrder(
    id: 'o4',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: 'limit',
    price: 68000,
    amount: .5,
    filled: 0,
    remaining: .5,
    totalValue: 34000,
  ),
];
