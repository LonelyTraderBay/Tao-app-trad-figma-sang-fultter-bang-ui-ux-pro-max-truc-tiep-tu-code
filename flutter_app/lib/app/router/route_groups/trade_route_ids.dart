final class TradeRoutePaths {
  const TradeRoutePaths._();

  static String tradePair(String pairId) => '/trade/$pairId';
  static String tradeFutures(String pairId) => '/trade/$pairId/futures';
  static String tradeFuturesLeverage(String pairId) =>
      '/trade/$pairId/futures/leverage';
  static const String tradeOrderReceipt = '/trade/order-receipt';
  static const String tradeOrdersHistory = '/trade/orders-history';
  static const String tradeSettings = '/trade/settings';
  static const String tradePositions = '/trade/positions';
  static const String tradeExport = '/trade/export';
  static const String tradeConvert = '/trade/convert';
  static const String tradeCopyRegulatoryDisclosuresAlias =
      '/trade/copy-trading/regulatory-disclosures';
  static const String tradeMargin = '/trade/margin';
  static const String tradeMarginBtcusdt = '/trade/margin/btcusdt';
  static const String tradeMarginHub = '/trade/margin/hub';
  static const String trade = '/trade';
}

final class TradeRouteNames {
  const TradeRouteNames._();

  static const String sc048Trade = 'sc048Trade';
  static const String sc049TradePair = 'sc049TradePair';
  static const String sc050OrdersHistory = 'sc050OrdersHistory';
  static const String sc051OrderReceipt = 'sc051OrderReceipt';
  static const String sc052TradeSettings = 'sc052TradeSettings';
  static const String sc053PositionDashboard = 'sc053PositionDashboard';
  static const String sc054TradeHistoryExport = 'sc054TradeHistoryExport';
  static const String sc056Convert = 'sc056Convert';
  static const String sc057Futures = 'sc057Futures';
  static const String sc058Leverage = 'sc058Leverage';
  static const String sc085MarginTrading = 'sc085MarginTrading';
  static const String sc086MarginTradingPair = 'sc086MarginTradingPair';
  static const String sc090MarginTradingHub = 'sc090MarginTradingHub';
  static const String sc412TradeCopyRegulatoryDisclosuresAlias =
      'sc412TradeCopyRegulatoryDisclosuresAlias';
}
