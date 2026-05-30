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

const List<TradePair> _pairs = [
  TradePair(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    price: 67543.21,
    changePct: 2.34,
    logoColorHex: 0xFFE58A00,
  ),
  TradePair(
    id: 'ethusdt',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    quoteAsset: 'USDT',
    price: 3521.44,
    changePct: 1.18,
    logoColorHex: 0xFF8B5CF6,
  ),
  TradePair(
    id: 'solusdt',
    symbol: 'SOL/USDT',
    baseAsset: 'SOL',
    quoteAsset: 'USDT',
    price: 146.72,
    changePct: -0.42,
    logoColorHex: 0xFF10B981,
  ),
];

const TradeSettings _defaultTradeSettings = TradeSettings(
  defaultOrderType: 'limit',
  defaultSlippage: .5,
  confirmOrders: true,
  skipConfirmSmall: false,
  smallOrderThreshold: 50,
  soundOnFill: true,
  hapticOnFill: true,
  showTpsl: false,
  bracketMode: false,
  priceDecimals: 'auto',
  defaultPctButtons: true,
  showOrderBook: true,
  showRecentTrades: true,
  chartTimeframe: '1h',
);

const List<TradeExportFormat> _tradeExportFormats = [
  TradeExportFormat(
    id: 'csv',
    label: 'CSV',
    description: 'Excel, Google Sheets',
  ),
  TradeExportFormat(id: 'pdf', label: 'PDF', description: 'Lưu trữ, in ấn'),
];

const List<TradeExportPeriod> _tradeExportPeriods = [
  TradeExportPeriod(id: '7d', label: '7 ngày'),
  TradeExportPeriod(id: '30d', label: '30 ngày'),
  TradeExportPeriod(id: '90d', label: '90 ngày'),
  TradeExportPeriod(id: '1y', label: '1 năm'),
  TradeExportPeriod(id: 'custom', label: 'Tùy chỉnh'),
];

const List<TradeExportInclude> _tradeExportIncludes = [
  TradeExportInclude(id: 'spot', label: 'Spot Trading', checked: true),
  TradeExportInclude(id: 'futures', label: 'Futures', checked: true),
  TradeExportInclude(id: 'margin', label: 'Margin', checked: true),
  TradeExportInclude(id: 'convert', label: 'Convert', checked: true),
  TradeExportInclude(id: 'deposits', label: 'Nạp tiền', checked: false),
  TradeExportInclude(id: 'withdrawals', label: 'Rút tiền', checked: false),
  TradeExportInclude(id: 'fees', label: 'Chi tiết phí', checked: true),
  TradeExportInclude(id: 'pnl', label: 'P/L tổng hợp', checked: true),
];

const List<TradeConvertAsset> _convertAssets = [
  TradeConvertAsset(
    symbol: 'USDT',
    name: 'Tether USD',
    balance: 12450.80,
    priceUsd: 1,
    colorHex: 0xFF26A17B,
  ),
  TradeConvertAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    balance: .23451,
    priceUsd: 67543.21,
    colorHex: 0xFFF7931A,
  ),
  TradeConvertAsset(
    symbol: 'ETH',
    name: 'Ethereum',
    balance: 3.521,
    priceUsd: 3521.45,
    colorHex: 0xFF627EEA,
  ),
  TradeConvertAsset(
    symbol: 'SOL',
    name: 'Solana',
    balance: 45.8,
    priceUsd: 178.32,
    colorHex: 0xFF9945FF,
  ),
  TradeConvertAsset(
    symbol: 'BNB',
    name: 'BNB',
    balance: 12.5,
    priceUsd: 412.87,
    colorHex: 0xFFF3BA2F,
  ),
  TradeConvertAsset(
    symbol: 'ADA',
    name: 'Cardano',
    balance: 5000,
    priceUsd: .4521,
    colorHex: 0xFF0033AD,
  ),
  TradeConvertAsset(
    symbol: 'MATIC',
    name: 'Polygon',
    balance: 2340,
    priceUsd: .8976,
    colorHex: 0xFF8247E5,
  ),
  TradeConvertAsset(
    symbol: 'AVAX',
    name: 'Avalanche',
    balance: 18.5,
    priceUsd: 38.54,
    colorHex: 0xFFE84142,
  ),
];

const List<TradeConvertFavoritePair> _convertFavoritePairs = [
  TradeConvertFavoritePair(fromSymbol: 'USDT', toSymbol: 'BTC'),
  TradeConvertFavoritePair(fromSymbol: 'USDT', toSymbol: 'ETH'),
  TradeConvertFavoritePair(fromSymbol: 'BTC', toSymbol: 'ETH'),
  TradeConvertFavoritePair(fromSymbol: 'USDT', toSymbol: 'SOL'),
];

const List<TradeConvertHistoryRecord> _convertHistory = [
  TradeConvertHistoryRecord(
    id: 'tx-001',
    fromSymbol: 'USDT',
    toSymbol: 'BTC',
    fromAmount: 500,
    toAmount: .007401,
    feeUsd: .50,
    rate: 67540,
    timeLabel: '2 phút trước',
    status: 'Hoàn tất',
  ),
  TradeConvertHistoryRecord(
    id: 'tx-002',
    fromSymbol: 'ETH',
    toSymbol: 'USDT',
    fromAmount: 1,
    toAmount: 3518.93,
    feeUsd: 3.52,
    rate: 3521.45,
    timeLabel: '1 giờ trước',
    status: 'Hoàn tất',
  ),
  TradeConvertHistoryRecord(
    id: 'tx-003',
    fromSymbol: 'USDT',
    toSymbol: 'SOL',
    fromAmount: 100,
    toAmount: .5604,
    feeUsd: .10,
    rate: 178.45,
    timeLabel: '3 giờ trước',
    status: 'Hoàn tất',
  ),
];

TradeConvertAsset _convertAssetBySymbol(String symbol) {
  return _convertAssets.firstWhere(
    (asset) => asset.symbol == symbol,
    orElse: () => _convertAssets.first,
  );
}

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
