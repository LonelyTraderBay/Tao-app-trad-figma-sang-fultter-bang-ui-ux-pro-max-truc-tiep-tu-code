part of 'trade_entities.dart';

enum TradeScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
  ready,
}

enum TradeOrderSide { buy, sell }

enum TradeOrderType { market, limit, stop }

final class TradeScreenSnapshot {
  const TradeScreenSnapshot({
    required this.pair,
    required this.pairs,
    required this.orderBook,
    required this.trades,
    required this.orders,
    required this.positions,
    required this.copyProviders,
    required this.botStrategies,
    required this.balances,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.highRiskContractId,
  });

  final TradePair pair;
  final List<TradePair> pairs;
  final TradeOrderBook orderBook;
  final List<TradeTapePrint> trades;
  final List<TradeOpenOrder> orders;
  final List<TradePosition> positions;
  final List<String> copyProviders;
  final List<String> botStrategies;
  final TradeBalances balances;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String? highRiskContractId;
}

final class TradePair {
  const TradePair({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.price,
    required this.changePct,
    required this.logoColorHex,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final double price;
  final double changePct;
  final int logoColorHex;
}

final class TradeOrderBook {
  const TradeOrderBook({required this.bids, required this.asks});

  final List<TradeBookLevel> bids;
  final List<TradeBookLevel> asks;
}

final class TradeBookLevel {
  const TradeBookLevel({
    required this.price,
    required this.amount,
    required this.total,
  });

  final double price;
  final double amount;
  final double total;
}

final class TradeTapePrint {
  const TradeTapePrint({
    required this.price,
    required this.amount,
    required this.time,
    required this.isBuy,
  });

  final double price;
  final double amount;
  final String time;
  final bool isBuy;
}

final class TradeOpenOrder {
  const TradeOpenOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.createdAt,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final TradeOrderType type;
  final double price;
  final double amount;
  final double filled;
  final String createdAt;
}

enum TradeOrderStatus { open, partial, filled, cancelled }

final class TradeOrdersHistorySnapshot {
  const TradeOrdersHistorySnapshot({
    required this.trade,
    required this.openOrders,
    required this.historyOrders,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeHistoryOrder> openOrders;
  final List<TradeHistoryOrder> historyOrders;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

enum TradeReceiptStatus { submitted, pending, partiallyFilled }

final class TradeOrderReceiptSnapshot {
  const TradeOrderReceiptSnapshot({
    required this.trade,
    required this.receipt,
    required this.supportRoute,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.highRiskContractId,
  });

  final TradeScreenSnapshot trade;
  final TradeOrderReceiptDetails receipt;
  final String supportRoute;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String? highRiskContractId;
}

final class TradeOrderReceiptDetails {
  const TradeOrderReceiptDetails({
    required this.orderId,
    required this.symbol,
    required this.baseAsset,
    required this.side,
    required this.orderType,
    required this.price,
    required this.amount,
    required this.total,
    required this.fee,
    required this.feeRate,
    required this.timestamp,
    required this.status,
    this.tpPrice,
    this.slPrice,
    this.estimatedFill,
    this.slippage,
  });

  final String orderId;
  final String symbol;
  final String baseAsset;
  final TradeOrderSide side;
  final String orderType;
  final double price;
  final double amount;
  final double total;
  final double fee;
  final String feeRate;
  final String timestamp;
  final TradeReceiptStatus status;
  final double? tpPrice;
  final double? slPrice;
  final String? estimatedFill;
  final double? slippage;
}

final class TradeSettingsSnapshot {
  const TradeSettingsSnapshot({
    required this.trade,
    required this.settings,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeSettings settings;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeSettings {
  const TradeSettings({
    required this.defaultOrderType,
    required this.defaultSlippage,
    required this.confirmOrders,
    required this.skipConfirmSmall,
    required this.smallOrderThreshold,
    required this.soundOnFill,
    required this.hapticOnFill,
    required this.showTpsl,
    required this.bracketMode,
    required this.priceDecimals,
    required this.defaultPctButtons,
    required this.showOrderBook,
    required this.showRecentTrades,
    required this.chartTimeframe,
  });

  final String defaultOrderType;
  final double defaultSlippage;
  final bool confirmOrders;
  final bool skipConfirmSmall;
  final double smallOrderThreshold;
  final bool soundOnFill;
  final bool hapticOnFill;
  final bool showTpsl;
  final bool bracketMode;
  final String priceDecimals;
  final bool defaultPctButtons;
  final bool showOrderBook;
  final bool showRecentTrades;
  final String chartTimeframe;

  TradeSettings copyWith({
    String? defaultOrderType,
    double? defaultSlippage,
    bool? confirmOrders,
    bool? skipConfirmSmall,
    double? smallOrderThreshold,
    bool? soundOnFill,
    bool? hapticOnFill,
    bool? showTpsl,
    bool? bracketMode,
    String? priceDecimals,
    bool? defaultPctButtons,
    bool? showOrderBook,
    bool? showRecentTrades,
    String? chartTimeframe,
  }) {
    return TradeSettings(
      defaultOrderType: defaultOrderType ?? this.defaultOrderType,
      defaultSlippage: defaultSlippage ?? this.defaultSlippage,
      confirmOrders: confirmOrders ?? this.confirmOrders,
      skipConfirmSmall: skipConfirmSmall ?? this.skipConfirmSmall,
      smallOrderThreshold: smallOrderThreshold ?? this.smallOrderThreshold,
      soundOnFill: soundOnFill ?? this.soundOnFill,
      hapticOnFill: hapticOnFill ?? this.hapticOnFill,
      showTpsl: showTpsl ?? this.showTpsl,
      bracketMode: bracketMode ?? this.bracketMode,
      priceDecimals: priceDecimals ?? this.priceDecimals,
      defaultPctButtons: defaultPctButtons ?? this.defaultPctButtons,
      showOrderBook: showOrderBook ?? this.showOrderBook,
      showRecentTrades: showRecentTrades ?? this.showRecentTrades,
      chartTimeframe: chartTimeframe ?? this.chartTimeframe,
    );
  }
}

enum TradePositionType { spot, futures, margin }

enum TradePositionSide { long, short }

final class TradePositionsSnapshot {
  const TradePositionsSnapshot({
    required this.trade,
    required this.positions,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeDashboardPosition> positions;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExportSnapshot {
  const TradeExportSnapshot({
    required this.trade,
    required this.stats,
    required this.formats,
    required this.periods,
    required this.includes,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeExportStats stats;
  final List<TradeExportFormat> formats;
  final List<TradeExportPeriod> periods;
  final List<TradeExportInclude> includes;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExportStats {
  const TradeExportStats({
    required this.totalTrades,
    required this.totalVolume,
    required this.totalFees,
    required this.netPnl,
  });

  final int totalTrades;
  final double totalVolume;
  final double totalFees;
  final double netPnl;
}

final class TradeExportFormat {
  const TradeExportFormat({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeExportPeriod {
  const TradeExportPeriod({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeExportInclude {
  const TradeExportInclude({
    required this.id,
    required this.label,
    required this.checked,
  });

  final String id;
  final String label;
  final bool checked;

  TradeExportInclude copyWith({bool? checked}) {
    return TradeExportInclude(
      id: id,
      label: label,
      checked: checked ?? this.checked,
    );
  }
}

final class TradeExportRequest {
  const TradeExportRequest({
    required this.format,
    required this.period,
    required this.includeIds,
  });

  final String format;
  final String period;
  final List<String> includeIds;
}

final class TradeExportResult {
  const TradeExportResult({
    required this.exportId,
    required this.format,
    required this.status,
    required this.downloadUrl,
  });

  final String exportId;
  final String format;
  final String status;
  final String downloadUrl;
}

final class TradeAdvancedChartSnapshot {
  const TradeAdvancedChartSnapshot({
    required this.trade,
    required this.pair,
    required this.candles,
    required this.indicators,
    required this.timeframes,
    required this.chartTypes,
    required this.ohlcv,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradePair pair;
  final List<TradeCandle> candles;
  final List<TradeChartIndicator> indicators;
  final List<String> timeframes;
  final List<String> chartTypes;
  final TradeOhlcv ohlcv;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCandle {
  const TradeCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  final String time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
}

final class TradeChartIndicator {
  const TradeChartIndicator({
    required this.id,
    required this.label,
    required this.colorHex,
    required this.enabled,
    this.period,
  });

  final String id;
  final String label;
  final int colorHex;
  final bool enabled;
  final int? period;

  TradeChartIndicator copyWith({bool? enabled}) {
    return TradeChartIndicator(
      id: id,
      label: label,
      colorHex: colorHex,
      enabled: enabled ?? this.enabled,
      period: period,
    );
  }
}

final class TradeOhlcv {
  const TradeOhlcv({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volumeLabel,
  });

  final double open;
  final double high;
  final double low;
  final double close;
  final String volumeLabel;
}

final class TradeConvertSnapshot {
  const TradeConvertSnapshot({
    required this.trade,
    required this.assets,
    required this.favoritePairs,
    required this.history,
    required this.slippageOptions,
    required this.fromAsset,
    required this.toAsset,
    required this.rateLabel,
    required this.countdownLabel,
    required this.minUsd,
    required this.maxUsd,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeConvertAsset> assets;
  final List<TradeConvertFavoritePair> favoritePairs;
  final List<TradeConvertHistoryRecord> history;
  final List<double> slippageOptions;
  final TradeConvertAsset fromAsset;
  final TradeConvertAsset toAsset;
  final String rateLabel;
  final String countdownLabel;
  final double minUsd;
  final double maxUsd;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeConvertAsset {
  const TradeConvertAsset({
    required this.symbol,
    required this.name,
    required this.balance,
    required this.priceUsd,
    required this.colorHex,
  });

  final String symbol;
  final String name;
  final double balance;
  final double priceUsd;
  final int colorHex;
}

final class TradeConvertFavoritePair {
  const TradeConvertFavoritePair({
    required this.fromSymbol,
    required this.toSymbol,
  });

  final String fromSymbol;
  final String toSymbol;

  String get label => '$fromSymbol/$toSymbol';
}

final class TradeConvertHistoryRecord {
  const TradeConvertHistoryRecord({
    required this.id,
    required this.fromSymbol,
    required this.toSymbol,
    required this.fromAmount,
    required this.toAmount,
    required this.feeUsd,
    required this.rate,
    required this.timeLabel,
    required this.status,
  });

  final String id;
  final String fromSymbol;
  final String toSymbol;
  final double fromAmount;
  final double toAmount;
  final double feeUsd;
  final double rate;
  final String timeLabel;
  final String status;
}
