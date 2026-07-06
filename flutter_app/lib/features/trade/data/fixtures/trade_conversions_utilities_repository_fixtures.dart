part of '../repositories/mock_trade_repository.dart';

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
