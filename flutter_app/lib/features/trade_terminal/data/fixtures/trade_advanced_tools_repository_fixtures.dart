part of '../repositories/mock_trade_terminal_repository.dart';

const List<TradeChartIndicator> _advancedChartIndicators = [
  TradeChartIndicator(
    id: 'ma7',
    label: 'MA(7)',
    colorHex: 0xFFF59E0B,
    enabled: true,
    period: 7,
  ),
  TradeChartIndicator(
    id: 'ma25',
    label: 'MA(25)',
    colorHex: 0xFF3B82F6,
    enabled: true,
    period: 25,
  ),
  TradeChartIndicator(
    id: 'ma99',
    label: 'MA(99)',
    colorHex: 0xFF8B5CF6,
    enabled: false,
    period: 99,
  ),
  TradeChartIndicator(
    id: 'ema',
    label: 'EMA(20)',
    colorHex: 0xFF06B6D4,
    enabled: false,
    period: 20,
  ),
  TradeChartIndicator(
    id: 'bb',
    label: 'Bollinger',
    colorHex: 0xFF10B981,
    enabled: false,
  ),
  TradeChartIndicator(
    id: 'rsi',
    label: 'RSI(14)',
    colorHex: 0xFFEF4444,
    enabled: false,
  ),
  TradeChartIndicator(
    id: 'macd',
    label: 'MACD',
    colorHex: 0xFF9945FF,
    enabled: false,
  ),
  TradeChartIndicator(
    id: 'vol',
    label: 'Volume',
    colorHex: 0xFF8B95B3,
    enabled: true,
  ),
];

const List<TradeCandle> _advancedChartCandles = [
  TradeCandle(
    time: '09:00',
    open: 64020,
    high: 64110,
    low: 63940,
    close: 64070,
    volume: 4200,
  ),
  TradeCandle(
    time: '10:00',
    open: 64070,
    high: 64145,
    low: 63980,
    close: 64010,
    volume: 3800,
  ),
  TradeCandle(
    time: '11:00',
    open: 64010,
    high: 64080,
    low: 63890,
    close: 63960,
    volume: 5200,
  ),
  TradeCandle(
    time: '12:00',
    open: 63960,
    high: 64190,
    low: 63950,
    close: 64150,
    volume: 4900,
  ),
  TradeCandle(
    time: '13:00',
    open: 64150,
    high: 64220,
    low: 64070,
    close: 64110,
    volume: 6100,
  ),
  TradeCandle(
    time: '14:00',
    open: 64110,
    high: 64260,
    low: 64090,
    close: 64210,
    volume: 6700,
  ),
  TradeCandle(
    time: '15:00',
    open: 64210,
    high: 64320,
    low: 64190,
    close: 64280,
    volume: 7400,
  ),
  TradeCandle(
    time: '16:00',
    open: 64280,
    high: 64420,
    low: 64230,
    close: 64390,
    volume: 8100,
  ),
  TradeCandle(
    time: '17:00',
    open: 64390,
    high: 64570,
    low: 64340,
    close: 64510,
    volume: 9000,
  ),
  TradeCandle(
    time: '18:00',
    open: 64510,
    high: 64640,
    low: 64480,
    close: 64590,
    volume: 8700,
  ),
  TradeCandle(
    time: '19:00',
    open: 64590,
    high: 64610,
    low: 64380,
    close: 64430,
    volume: 7800,
  ),
  TradeCandle(
    time: '20:00',
    open: 64430,
    high: 64560,
    low: 64390,
    close: 64520,
    volume: 6900,
  ),
  TradeCandle(
    time: '21:00',
    open: 64520,
    high: 64620,
    low: 64460,
    close: 64490,
    volume: 6400,
  ),
  TradeCandle(
    time: '22:00',
    open: 64490,
    high: 64570,
    low: 64320,
    close: 64380,
    volume: 7200,
  ),
  TradeCandle(
    time: '23:00',
    open: 64380,
    high: 64480,
    low: 64270,
    close: 64440,
    volume: 7700,
  ),
  TradeCandle(
    time: '00:00',
    open: 64440,
    high: 64520,
    low: 64360,
    close: 64480,
    volume: 6800,
  ),
  TradeCandle(
    time: '01:00',
    open: 64480,
    high: 64510,
    low: 64240,
    close: 64300,
    volume: 8200,
  ),
  TradeCandle(
    time: '02:00',
    open: 64300,
    high: 64440,
    low: 64270,
    close: 64390,
    volume: 7300,
  ),
  TradeCandle(
    time: '03:00',
    open: 64390,
    high: 64490,
    low: 64290,
    close: 64350,
    volume: 7600,
  ),
  TradeCandle(
    time: '04:00',
    open: 64350,
    high: 64460,
    low: 64260,
    close: 64410,
    volume: 8400,
  ),
  TradeCandle(
    time: '05:00',
    open: 64410,
    high: 64530,
    low: 64380,
    close: 64470,
    volume: 7900,
  ),
  TradeCandle(
    time: '06:00',
    open: 64470,
    high: 64500,
    low: 64230,
    close: 64320,
    volume: 8800,
  ),
  TradeCandle(
    time: '07:00',
    open: 64320,
    high: 64470,
    low: 64240,
    close: 64430,
    volume: 8300,
  ),
  TradeCandle(
    time: '08:00',
    open: 64430,
    high: 64510,
    low: 64290,
    close: 64370,
    volume: 7600,
  ),
  TradeCandle(
    time: '09:00',
    open: 64370,
    high: 64475.28,
    low: 64185.74,
    close: 64268.03,
    volume: 8000,
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

const List<TradeShortcut> _shortcuts = [
  TradeShortcut(
    id: 'buy',
    keys: 'F1',
    label: 'Quick Buy',
    description: 'Place buy order with active preset',
  ),
  TradeShortcut(
    id: 'sell',
    keys: 'F2',
    label: 'Quick Sell',
    description: 'Place sell order with active preset',
  ),
  TradeShortcut(
    id: 'cancel',
    keys: 'ESC',
    label: 'Cancel All',
    description: 'Cancel all selected or open orders',
  ),
  TradeShortcut(
    id: 'size',
    keys: '1-4',
    label: 'Lot Size',
    description: 'Switch ladder lot size presets',
  ),
];

const List<TradeRiskStatusItem> _advancedToolStatusItems = [
  TradeRiskStatusItem(label: 'Ladder Trading Component', complete: true),
  TradeRiskStatusItem(label: 'Bulk Operations Component', complete: true),
  TradeRiskStatusItem(label: 'Keyboard Shortcuts System', complete: true),
  TradeRiskStatusItem(label: 'Integration với TradePage', complete: false),
  TradeRiskStatusItem(label: 'Persistent shortcut settings', complete: false),
];
