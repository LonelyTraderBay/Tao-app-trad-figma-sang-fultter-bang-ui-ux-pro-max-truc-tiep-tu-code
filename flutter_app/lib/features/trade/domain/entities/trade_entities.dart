import 'dart:math' as math;

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
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeOrderReceiptDetails receipt;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
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

final class TradeConvertRequest {
  const TradeConvertRequest({
    required this.fromSymbol,
    required this.toSymbol,
    required this.amount,
    required this.slippagePct,
    required this.mode,
  });

  final String fromSymbol;
  final String toSymbol;
  final double amount;
  final double slippagePct;
  final String mode;
}

final class TradeConvertQuote {
  const TradeConvertQuote({
    required this.fromSymbol,
    required this.toSymbol,
    required this.fromAmount,
    required this.toAmount,
    required this.feeUsd,
    required this.rate,
    required this.quoteLabel,
    required this.validSeconds,
    required this.canSubmit,
  });

  final String fromSymbol;
  final String toSymbol;
  final double fromAmount;
  final double toAmount;
  final double feeUsd;
  final double rate;
  final String quoteLabel;
  final int validSeconds;
  final bool canSubmit;
}

final class TradeConvertReceipt {
  const TradeConvertReceipt({
    required this.convertId,
    required this.quote,
    required this.status,
  });

  final String convertId;
  final TradeConvertQuote quote;
  final String status;
}

enum TradeFuturesSide { long, short }

enum TradeFuturesOrderType { market, limit }

final class TradeFuturesSnapshot {
  const TradeFuturesSnapshot({
    required this.trade,
    required this.pair,
    required this.positions,
    required this.leverages,
    required this.markPrice,
    required this.indexPrice,
    required this.fundingRate,
    required this.accountBalance,
    required this.usedMargin,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradePair pair;
  final List<TradeFuturesPosition> positions;
  final List<int> leverages;
  final double markPrice;
  final double indexPrice;
  final double fundingRate;
  final double accountBalance;
  final double usedMargin;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeFuturesPosition {
  const TradeFuturesPosition({
    required this.id,
    required this.symbol,
    required this.side,
    required this.leverage,
    required this.size,
    required this.entryPrice,
    required this.markPrice,
    required this.liquidPrice,
    required this.pnl,
    required this.pnlPct,
    required this.margin,
    required this.roe,
  });

  final String id;
  final String symbol;
  final TradeFuturesSide side;
  final int leverage;
  final double size;
  final double entryPrice;
  final double markPrice;
  final double liquidPrice;
  final double pnl;
  final double pnlPct;
  final double margin;
  final double roe;
}

final class TradeFuturesOrderDraft {
  const TradeFuturesOrderDraft({
    required this.pairId,
    required this.side,
    required this.type,
    required this.margin,
    required this.leverage,
    this.limitPrice,
    this.takeProfit,
    this.stopLoss,
  });

  final String pairId;
  final TradeFuturesSide side;
  final TradeFuturesOrderType type;
  final double margin;
  final int leverage;
  final double? limitPrice;
  final double? takeProfit;
  final double? stopLoss;
}

final class TradeFuturesPreview {
  const TradeFuturesPreview({
    required this.positionSize,
    required this.contractQty,
    required this.liquidationPrice,
    required this.openFee,
    required this.canOpen,
  });

  final double positionSize;
  final double contractQty;
  final double liquidationPrice;
  final double openFee;
  final bool canOpen;
}

final class TradeFuturesReceipt {
  const TradeFuturesReceipt({
    required this.orderId,
    required this.preview,
    required this.status,
  });

  final String orderId;
  final TradeFuturesPreview preview;
  final String status;
}

final class TradeFuturesLeverageSnapshot {
  const TradeFuturesLeverageSnapshot({
    required this.futures,
    required this.currentLeverage,
    required this.presets,
    required this.sliderStops,
    required this.exampleMargin,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeFuturesSnapshot futures;
  final int currentLeverage;
  final List<int> presets;
  final List<int> sliderStops;
  final double exampleMargin;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeFuturesLeverageRequest {
  const TradeFuturesLeverageRequest({
    required this.pairId,
    required this.leverage,
    this.exampleMargin = 100,
  });

  final String pairId;
  final int leverage;
  final double exampleMargin;
}

final class TradeFuturesLeveragePreview {
  const TradeFuturesLeveragePreview({
    required this.leverage,
    required this.riskLabel,
    required this.riskLevel,
    required this.riskColorHex,
    required this.positionSize,
    required this.liquidationDistancePct,
    required this.openFee,
    required this.profitAtOnePct,
    required this.lossAtOnePct,
    required this.warningText,
    required this.showRiskTips,
  });

  final int leverage;
  final String riskLabel;
  final int riskLevel;
  final int riskColorHex;
  final double positionSize;
  final double liquidationDistancePct;
  final double openFee;
  final double profitAtOnePct;
  final double lossAtOnePct;
  final String warningText;
  final bool showRiskTips;
}

final class TradeFuturesLeverageReceipt {
  const TradeFuturesLeverageReceipt({
    required this.adjustmentId,
    required this.pairId,
    required this.preview,
    required this.status,
  });

  final String adjustmentId;
  final String pairId;
  final TradeFuturesLeveragePreview preview;
  final String status;
}

enum TradeBotRisk { low, medium, high }

enum TradeBotStatus { running, paused, stopped }

final class TradeBotsSnapshot {
  const TradeBotsSnapshot({
    required this.trade,
    required this.strategies,
    required this.activeBots,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeBotStrategy> strategies;
  final List<TradeBot> activeBots;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  int get runningCount =>
      activeBots.where((bot) => bot.status == TradeBotStatus.running).length;

  double get totalInvestment =>
      activeBots.fold(0.0, (sum, bot) => sum + bot.investment);

  double get totalProfit =>
      activeBots.fold(0.0, (sum, bot) => sum + bot.profit);
}

final class TradeBotStrategy {
  const TradeBotStrategy({
    required this.id,
    required this.name,
    required this.description,
    required this.longDescription,
    required this.icon,
    required this.colorHex,
    required this.risk,
    required this.avgReturn,
    required this.suitableFor,
    required this.params,
  });

  final String id;
  final String name;
  final String description;
  final String longDescription;
  final String icon;
  final int colorHex;
  final TradeBotRisk risk;
  final String avgReturn;
  final String suitableFor;
  final List<TradeBotParam> params;
}

final class TradeBotParam {
  const TradeBotParam({
    required this.key,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.options = const [],
    this.unit,
  });

  final String key;
  final String label;
  final String type;
  final String defaultValue;
  final List<String> options;
  final String? unit;
}

final class TradeBot {
  const TradeBot({
    required this.id,
    required this.strategyId,
    required this.strategyName,
    required this.icon,
    required this.colorHex,
    required this.pair,
    required this.status,
    required this.profit,
    required this.profitPct,
    required this.trades,
    required this.investment,
    required this.startDate,
    required this.runtime,
  });

  final String id;
  final String strategyId;
  final String strategyName;
  final String icon;
  final int colorHex;
  final String pair;
  final TradeBotStatus status;
  final double profit;
  final double profitPct;
  final int trades;
  final double investment;
  final String startDate;
  final String runtime;

  TradeBot copyWith({TradeBotStatus? status}) {
    return TradeBot(
      id: id,
      strategyId: strategyId,
      strategyName: strategyName,
      icon: icon,
      colorHex: colorHex,
      pair: pair,
      status: status ?? this.status,
      profit: profit,
      profitPct: profitPct,
      trades: trades,
      investment: investment,
      startDate: startDate,
      runtime: runtime,
    );
  }
}

final class TradeBotActionRequest {
  const TradeBotActionRequest({required this.botId, required this.action});

  final String botId;
  final String action;
}

final class TradeBotActionResult {
  const TradeBotActionResult({
    required this.botId,
    required this.action,
    required this.status,
  });

  final String botId;
  final String action;
  final String status;
}

final class TradeBotCreateRequest {
  const TradeBotCreateRequest({required this.strategyId, required this.params});

  final String strategyId;
  final Map<String, String> params;
}

final class TradeBotCreateResult {
  const TradeBotCreateResult({
    required this.botId,
    required this.strategyId,
    required this.status,
  });

  final String botId;
  final String strategyId;
  final String status;
}

enum TradeRiskPositionSide { long, short }

final class TradeRiskManagementSnapshot {
  const TradeRiskManagementSnapshot({
    required this.trade,
    required this.features,
    required this.positions,
    required this.statusItems,
    required this.accountBalance,
    required this.currentPrice,
    required this.availableBalance,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeRiskFeature> features;
  final List<TradeRiskPosition> positions;
  final List<TradeRiskStatusItem> statusItems;
  final double accountBalance;
  final double currentPrice;
  final double availableBalance;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeRiskFeature {
  const TradeRiskFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeRiskPosition {
  const TradeRiskPosition({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.logoColorHex,
    required this.side,
    required this.amount,
    required this.entryPrice,
    required this.currentPrice,
    required this.openedAtLabel,
    this.leverage,
    this.liquidationPrice,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final int logoColorHex;
  final TradeRiskPositionSide side;
  final double amount;
  final double entryPrice;
  final double currentPrice;
  final String openedAtLabel;
  final int? leverage;
  final double? liquidationPrice;

  double get pnl {
    final direction = side == TradeRiskPositionSide.long ? 1 : -1;
    return (currentPrice - entryPrice) * amount * direction;
  }

  double get pnlPct {
    final basis = entryPrice * amount;
    if (basis <= 0) return 0;
    return pnl / basis * 100;
  }
}

final class TradeRiskStatusItem {
  const TradeRiskStatusItem({required this.label, required this.complete});

  final String label;
  final bool complete;
}

final class TradeOcoOrderDraft {
  const TradeOcoOrderDraft({
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.limitPrice,
    required this.takeProfitPrice,
    required this.stopPrice,
  });

  final String symbol;
  final TradeOrderSide side;
  final double quantity;
  final double limitPrice;
  final double takeProfitPrice;
  final double stopPrice;
}

final class TradeOcoOrderResult {
  const TradeOcoOrderResult({
    required this.orderId,
    required this.symbol,
    required this.status,
  });

  final String orderId;
  final String symbol;
  final String status;
}

final class TradePositionSizeRequest {
  const TradePositionSizeRequest({
    required this.accountBalance,
    required this.riskPct,
    required this.entryPrice,
    required this.stopPrice,
  });

  final double accountBalance;
  final double riskPct;
  final double entryPrice;
  final double stopPrice;
}

final class TradePositionSizeResult {
  const TradePositionSizeResult({
    required this.riskAmount,
    required this.perUnitRisk,
    required this.suggestedAmount,
    required this.notional,
  });

  final double riskAmount;
  final double perUnitRisk;
  final double suggestedAmount;
  final double notional;
}

final class TradeExecutionQualitySnapshot {
  const TradeExecutionQualitySnapshot({
    required this.trade,
    required this.features,
    required this.report,
    required this.openOrder,
    required this.slippageSettings,
    required this.statusItems,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeExecutionFeature> features;
  final TradeExecutionReport report;
  final TradeExecutionOpenOrder openOrder;
  final TradeSlippageSettings slippageSettings;
  final List<TradeRiskStatusItem> statusItems;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExecutionFeature {
  const TradeExecutionFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeExecutionReport {
  const TradeExecutionReport({
    required this.orderId,
    required this.symbol,
    required this.side,
    required this.requestedAmount,
    required this.filledAmount,
    required this.expectedPrice,
    required this.averageFillPrice,
    required this.bestAvailablePrice,
    required this.executionTimeMs,
    required this.slippagePct,
    required this.savingsVsSingleVenue,
    required this.executionQuality,
    required this.fills,
  });

  final String orderId;
  final String symbol;
  final TradeOrderSide side;
  final double requestedAmount;
  final double filledAmount;
  final double expectedPrice;
  final double averageFillPrice;
  final double bestAvailablePrice;
  final int executionTimeMs;
  final double slippagePct;
  final double savingsVsSingleVenue;
  final String executionQuality;
  final List<TradeExecutionFill> fills;
}

final class TradeExecutionFill {
  const TradeExecutionFill({
    required this.venue,
    required this.amount,
    required this.price,
    required this.fee,
    required this.timestampLabel,
  });

  final String venue;
  final double amount;
  final double price;
  final double fee;
  final String timestampLabel;
}

final class TradeExecutionOpenOrder {
  const TradeExecutionOpenOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.remaining,
    required this.queuePosition,
    required this.totalInQueue,
    required this.supportsAmend,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final String type;
  final double price;
  final double amount;
  final double filled;
  final double remaining;
  final int queuePosition;
  final int totalInQueue;
  final bool supportsAmend;
}

final class TradeSlippageSettings {
  const TradeSlippageSettings({
    required this.tolerancePct,
    required this.rejectOnExceed,
    required this.partialFillAllowed,
  });

  final double tolerancePct;
  final bool rejectOnExceed;
  final bool partialFillAllowed;
}

final class TradeOrderAmendmentRequest {
  const TradeOrderAmendmentRequest({
    required this.orderId,
    required this.newPrice,
    required this.newAmount,
  });

  final String orderId;
  final double newPrice;
  final double newAmount;
}

final class TradeOrderAmendmentResult {
  const TradeOrderAmendmentResult({
    required this.orderId,
    required this.status,
    required this.queuePositionPreserved,
  });

  final String orderId;
  final String status;
  final bool queuePositionPreserved;
}

final class TradeAdvancedToolsSnapshot {
  const TradeAdvancedToolsSnapshot({
    required this.trade,
    required this.features,
    required this.ladderOrders,
    required this.bulkOrders,
    required this.shortcuts,
    required this.statusItems,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeAdvancedToolFeature> features;
  final List<TradeLadderOrder> ladderOrders;
  final List<TradeBulkOrder> bulkOrders;
  final List<TradeShortcut> shortcuts;
  final List<TradeRiskStatusItem> statusItems;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeAdvancedToolFeature {
  const TradeAdvancedToolFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeLadderOrder {
  const TradeLadderOrder({
    required this.id,
    required this.price,
    required this.amount,
    required this.side,
    required this.filled,
  });

  final String id;
  final double price;
  final double amount;
  final TradeOrderSide side;
  final double filled;
}

final class TradeBulkOrder {
  const TradeBulkOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.remaining,
    required this.totalValue,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final String type;
  final double price;
  final double amount;
  final double filled;
  final double remaining;
  final double totalValue;
}

final class TradeShortcut {
  const TradeShortcut({
    required this.id,
    required this.keys,
    required this.label,
    required this.description,
  });

  final String id;
  final String keys;
  final String label;
  final String description;
}

final class TradeAdvancedToolActionRequest {
  const TradeAdvancedToolActionRequest({
    required this.toolId,
    required this.action,
    this.orderIds = const [],
  });

  final String toolId;
  final String action;
  final List<String> orderIds;
}

final class TradeAdvancedToolActionResult {
  const TradeAdvancedToolActionResult({
    required this.toolId,
    required this.action,
    required this.status,
    required this.affectedCount,
  });

  final String toolId;
  final String action;
  final String status;
  final int affectedCount;
}

enum TradeCopyRiskLevel { low, medium, high }

final class TradeCopyTradingSnapshot {
  const TradeCopyTradingSnapshot({
    required this.trade,
    required this.traders,
    required this.sortOptions,
    required this.totalCopiers,
    required this.totalAum,
    required this.aumTrendPct,
    required this.riskWarningTitle,
    required this.riskWarningText,
    required this.disclaimer,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyTrader> traders;
  final List<String> sortOptions;
  final int totalCopiers;
  final double totalAum;
  final double aumTrendPct;
  final String riskWarningTitle;
  final String riskWarningText;
  final String disclaimer;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyTradingV2Snapshot {
  const TradeCopyTradingV2Snapshot({
    required this.copyTrading,
    required this.heroVariants,
    required this.defaultHeroVariant,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeCopyTradingSnapshot copyTrading;
  final List<String> heroVariants;
  final String defaultHeroVariant;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

enum TradeCopyCardCompliance { pass, warn, fail }

final class TradeCopyCardDemoSnapshot {
  const TradeCopyCardDemoSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.backRoute,
    required this.metrics,
    required this.improvements,
    required this.variants,
    required this.issues,
    required this.originalIssues,
    required this.recommendation,
    required this.recommendationReasons,
    required this.guidelines,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
  final String title;
  final String backRoute;
  final TradeCopyCardMetrics metrics;
  final List<String> improvements;
  final List<TradeCopyCardVariantDraft> variants;
  final List<TradeCopyCardIssue> issues;
  final List<TradeCopyCardTextBlock> originalIssues;
  final String recommendation;
  final List<String> recommendationReasons;
  final List<TradeCopyCardTextBlock> guidelines;
  final String contractNotes;
}

final class TradeCopyCardMetrics {
  const TradeCopyCardMetrics({
    required this.traders,
    required this.copiers,
    required this.aumUsd,
    required this.aumTrendPercent,
    required this.lastUpdated,
  });

  final int traders;
  final int copiers;
  final int aumUsd;
  final double aumTrendPercent;
  final String lastUpdated;
}

final class TradeCopyCardVariantDraft {
  const TradeCopyCardVariantDraft({
    required this.id,
    required this.title,
    required this.badge,
    required this.notesTitle,
    required this.notes,
  });

  final String id;
  final String title;
  final String? badge;
  final String notesTitle;
  final List<String> notes;
}

final class TradeCopyCardIssue {
  const TradeCopyCardIssue({
    required this.category,
    required this.description,
    required this.original,
    required this.variantA,
    required this.variantB,
    required this.variantC,
  });

  final String category;
  final String description;
  final TradeCopyCardCompliance original;
  final TradeCopyCardCompliance variantA;
  final TradeCopyCardCompliance variantB;
  final TradeCopyCardCompliance variantC;
}

final class TradeCopyCardTextBlock {
  const TradeCopyCardTextBlock({required this.title, required this.body});

  final String title;
  final String body;
}

final class TradeCopyEducationSnapshot {
  const TradeCopyEducationSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTab,
    required this.introTitle,
    required this.introDescription,
    required this.steps,
    required this.copyModes,
    required this.concepts,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyEducationTab> tabs;
  final String defaultTab;
  final String introTitle;
  final String introDescription;
  final List<TradeCopyEducationStep> steps;
  final List<TradeCopyModeGuide> copyModes;
  final List<TradeCopyConceptGuide> concepts;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyEducationTab {
  const TradeCopyEducationTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeCopyEducationStep {
  const TradeCopyEducationStep({
    required this.number,
    required this.iconName,
    required this.title,
    required this.description,
  });

  final int number;
  final String iconName;
  final String title;
  final String description;
}

final class TradeCopyModeGuide {
  const TradeCopyModeGuide({
    required this.title,
    required this.description,
    required this.pro,
    required this.con,
    required this.colorHex,
  });

  final String title;
  final String description;
  final String pro;
  final String con;
  final int colorHex;
}

final class TradeCopyConceptGuide {
  const TradeCopyConceptGuide({
    required this.term,
    required this.description,
    required this.iconName,
  });

  final String term;
  final String description;
  final String iconName;
}

enum TradeActiveCopyStatus { active, coolingOff, paused, stopped }

enum TradeActiveCopyMode { mirror, fixed, smart }

enum TradeCopySettingsMode { mirror, fixed, smart }

final class TradeActiveCopiesSnapshot {
  const TradeActiveCopiesSnapshot({
    required this.trade,
    required this.portfolio,
    required this.tabs,
    required this.defaultTab,
    required this.copies,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeActiveCopyPortfolio portfolio;
  final List<TradeActiveCopiesTab> tabs;
  final String defaultTab;
  final List<TradeActiveCopy> copies;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeActiveCopyPortfolio {
  const TradeActiveCopyPortfolio({
    required this.totalCapital,
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.activeCopies,
    required this.totalCopies,
  });

  final double totalCapital;
  final double totalValue;
  final double totalPnl;
  final double totalPnlPct;
  final int activeCopies;
  final int totalCopies;
}

final class TradeActiveCopiesTab {
  const TradeActiveCopiesTab({
    required this.id,
    required this.label,
    this.badge,
  });

  final String id;
  final String label;
  final int? badge;
}

final class TradeActiveCopy {
  const TradeActiveCopy({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.providerVerified,
    required this.capital,
    required this.currentValue,
    required this.pnl,
    required this.pnlPct,
    required this.status,
    required this.startDate,
    required this.copyMode,
    required this.trades,
    required this.winRate,
    required this.hasCustomStopLoss,
    required this.recentTrades,
    required this.performanceHistory,
    this.copyRatio,
    this.stopLossLevel,
    this.coolingOffUntil,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final bool providerVerified;
  final double capital;
  final double currentValue;
  final double pnl;
  final double pnlPct;
  final TradeActiveCopyStatus status;
  final String startDate;
  final TradeActiveCopyMode copyMode;
  final double? copyRatio;
  final int trades;
  final double winRate;
  final bool hasCustomStopLoss;
  final double? stopLossLevel;
  final String? coolingOffUntil;
  final List<TradeCopyRecentTrade> recentTrades;
  final List<TradeCopyPerformancePoint> performanceHistory;
}

final class TradeCopyRecentTrade {
  const TradeCopyRecentTrade({
    required this.id,
    required this.pair,
    required this.side,
    required this.size,
    required this.price,
    required this.pnl,
    required this.timestamp,
  });

  final String id;
  final String pair;
  final TradeOrderSide side;
  final double size;
  final double price;
  final double pnl;
  final String timestamp;
}

final class TradeCopyPerformancePoint {
  const TradeCopyPerformancePoint({
    required this.timestamp,
    required this.value,
  });

  final String timestamp;
  final double value;
}

final class TradeCopySettingsSnapshot {
  const TradeCopySettingsSnapshot({
    required this.trade,
    required this.settings,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeCopySettings settings;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopySettings {
  const TradeCopySettings({
    required this.defaultCopyMode,
    required this.defaultCopyRatio,
    required this.defaultStopLoss,
    required this.defaultTakeProfit,
    required this.maxPortfolioAllocation,
    required this.maxCopiesActive,
    required this.enableCircuitBreaker,
    required this.circuitBreakerThreshold,
    required this.notifyNewTrades,
    required this.notifyPnlChanges,
    required this.notifyRiskAlerts,
    required this.notifyProviderUpdates,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.showPortfolioPublic,
  });

  final TradeCopySettingsMode defaultCopyMode;
  final double defaultCopyRatio;
  final double defaultStopLoss;
  final double defaultTakeProfit;
  final double maxPortfolioAllocation;
  final int maxCopiesActive;
  final bool enableCircuitBreaker;
  final double circuitBreakerThreshold;
  final bool notifyNewTrades;
  final bool notifyPnlChanges;
  final bool notifyRiskAlerts;
  final bool notifyProviderUpdates;
  final bool emailNotifications;
  final bool pushNotifications;
  final String emergencyContact;
  final String emergencyPhone;
  final bool showPortfolioPublic;

  TradeCopySettings copyWith({
    TradeCopySettingsMode? defaultCopyMode,
    double? defaultCopyRatio,
    double? defaultStopLoss,
    double? defaultTakeProfit,
    double? maxPortfolioAllocation,
    int? maxCopiesActive,
    bool? enableCircuitBreaker,
    double? circuitBreakerThreshold,
    bool? notifyNewTrades,
    bool? notifyPnlChanges,
    bool? notifyRiskAlerts,
    bool? notifyProviderUpdates,
    bool? emailNotifications,
    bool? pushNotifications,
    String? emergencyContact,
    String? emergencyPhone,
    bool? showPortfolioPublic,
  }) {
    return TradeCopySettings(
      defaultCopyMode: defaultCopyMode ?? this.defaultCopyMode,
      defaultCopyRatio: defaultCopyRatio ?? this.defaultCopyRatio,
      defaultStopLoss: defaultStopLoss ?? this.defaultStopLoss,
      defaultTakeProfit: defaultTakeProfit ?? this.defaultTakeProfit,
      maxPortfolioAllocation:
          maxPortfolioAllocation ?? this.maxPortfolioAllocation,
      maxCopiesActive: maxCopiesActive ?? this.maxCopiesActive,
      enableCircuitBreaker: enableCircuitBreaker ?? this.enableCircuitBreaker,
      circuitBreakerThreshold:
          circuitBreakerThreshold ?? this.circuitBreakerThreshold,
      notifyNewTrades: notifyNewTrades ?? this.notifyNewTrades,
      notifyPnlChanges: notifyPnlChanges ?? this.notifyPnlChanges,
      notifyRiskAlerts: notifyRiskAlerts ?? this.notifyRiskAlerts,
      notifyProviderUpdates:
          notifyProviderUpdates ?? this.notifyProviderUpdates,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      showPortfolioPublic: showPortfolioPublic ?? this.showPortfolioPublic,
    );
  }
}

final class TradeCopySettingsSaveResult {
  const TradeCopySettingsSaveResult({
    required this.status,
    required this.settings,
  });

  final String status;
  final TradeCopySettings settings;
}

enum TradeCopyNotificationType { trade, risk, update, system }

enum TradeCopyNotificationSeverity { info, warning, critical }

final class TradeCopyNotificationsSnapshot {
  const TradeCopyNotificationsSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTab,
    required this.notifications,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyNotificationTab> tabs;
  final String defaultTab;
  final List<TradeCopyNotification> notifications;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyNotificationTab {
  const TradeCopyNotificationTab({
    required this.id,
    required this.label,
    this.badge,
  });

  final String id;
  final String label;
  final int? badge;
}

final class TradeCopyNotification {
  const TradeCopyNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.severity,
    this.providerId,
    this.providerName,
    this.copyId,
    this.actionPath,
    this.pnl,
    this.pair,
    this.side,
  });

  final String id;
  final TradeCopyNotificationType type;
  final String title;
  final String message;
  final String timestamp;
  final bool read;
  final TradeCopyNotificationSeverity severity;
  final String? providerId;
  final String? providerName;
  final String? copyId;
  final String? actionPath;
  final double? pnl;
  final String? pair;
  final TradeOrderSide? side;

  TradeCopyNotification copyWith({bool? read}) {
    return TradeCopyNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      read: read ?? this.read,
      severity: severity,
      providerId: providerId,
      providerName: providerName,
      copyId: copyId,
      actionPath: actionPath,
      pnl: pnl,
      pair: pair,
      side: side,
    );
  }
}

enum TradeProviderApplicationStep {
  intro,
  requirements,
  disclosure,
  fees,
  review,
}

final class TradeProviderApplicationSnapshot {
  const TradeProviderApplicationSnapshot({
    required this.trade,
    required this.steps,
    required this.defaultStep,
    required this.benefits,
    required this.requirements,
    required this.responsibilities,
    required this.defaultDraft,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderApplicationStep> steps;
  final TradeProviderApplicationStep defaultStep;
  final List<TradeProviderBenefit> benefits;
  final List<TradeProviderRequirement> requirements;
  final List<String> responsibilities;
  final TradeProviderApplicationDraft defaultDraft;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeProviderBenefit {
  const TradeProviderBenefit({
    required this.iconName,
    required this.title,
    required this.description,
  });

  final String iconName;
  final String title;
  final String description;
}

final class TradeProviderRequirement {
  const TradeProviderRequirement({required this.label, required this.met});

  final String label;
  final bool met;
}

final class TradeProviderApplicationDraft {
  const TradeProviderApplicationDraft({
    required this.hasKyc,
    required this.tradingMonths,
    required this.minCapital,
    required this.performanceFee,
    required this.agreedToDisclosure,
    required this.agreedToFiduciary,
    required this.agreedToTerms,
    required this.strategyDescription,
  });

  final bool hasKyc;
  final int tradingMonths;
  final int minCapital;
  final int performanceFee;
  final bool agreedToDisclosure;
  final bool agreedToFiduciary;
  final bool agreedToTerms;
  final String strategyDescription;

  TradeProviderApplicationDraft copyWith({
    bool? hasKyc,
    int? tradingMonths,
    int? minCapital,
    int? performanceFee,
    bool? agreedToDisclosure,
    bool? agreedToFiduciary,
    bool? agreedToTerms,
    String? strategyDescription,
  }) {
    return TradeProviderApplicationDraft(
      hasKyc: hasKyc ?? this.hasKyc,
      tradingMonths: tradingMonths ?? this.tradingMonths,
      minCapital: minCapital ?? this.minCapital,
      performanceFee: performanceFee ?? this.performanceFee,
      agreedToDisclosure: agreedToDisclosure ?? this.agreedToDisclosure,
      agreedToFiduciary: agreedToFiduciary ?? this.agreedToFiduciary,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      strategyDescription: strategyDescription ?? this.strategyDescription,
    );
  }
}

final class TradeProviderApplicationResult {
  const TradeProviderApplicationResult({
    required this.applicationId,
    required this.status,
    required this.reviewWindow,
  });

  final String applicationId;
  final String status;
  final String reviewWindow;
}

final class TradeCopyProviderDetailSnapshot {
  const TradeCopyProviderDetailSnapshot({
    required this.providerId,
    required this.provider,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.notFoundMessage = 'Provider không tồn tại',
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String notFoundMessage;

  bool get isNotFound => provider == null;
}

final class TradePreCopyAssessmentSnapshot {
  const TradePreCopyAssessmentSnapshot({
    required this.providerId,
    required this.provider,
    required this.questions,
    required this.educationDocs,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradePreCopyQuestion> questions;
  final List<TradePreCopyEducationDoc> educationDocs;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradePreCopyQuestion {
  const TradePreCopyQuestion({
    required this.id,
    required this.question,
    required this.description,
    required this.options,
  });

  final String id;
  final String question;
  final String description;
  final List<TradePreCopyOption> options;
}

final class TradePreCopyOption {
  const TradePreCopyOption({
    required this.value,
    required this.label,
    required this.score,
  });

  final String value;
  final String label;
  final int score;
}

final class TradePreCopyEducationDoc {
  const TradePreCopyEducationDoc({
    required this.id,
    required this.title,
    required this.duration,
  });

  final String id;
  final String title;
  final String duration;
}

enum TradeCopyConfigurationMode { mirror, fixed, smart }

enum TradePositionSizingMethod { percentage, fixedAmount, riskBased }

enum TradeCopyConfigurationValidationLevel { error, warning, info }

final class TradeCopyConfigurationSnapshot {
  const TradeCopyConfigurationSnapshot({
    required this.providerId,
    required this.provider,
    required this.defaultDraft,
    required this.totalPortfolio,
    required this.currentCopyAllocation,
    required this.availableCapital,
    required this.feePreview,
    required this.validations,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final TradeCopyConfigurationDraft defaultDraft;
  final double totalPortfolio;
  final double currentCopyAllocation;
  final double availableCapital;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyConfigurationValidation> validations;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradeCopyConfigurationDraft {
  const TradeCopyConfigurationDraft({
    required this.providerId,
    required this.copyCapital,
    required this.copyMode,
    required this.positionSizing,
    required this.copyRatio,
    required this.useCustomStopLoss,
    required this.customStopLoss,
    required this.useCustomTakeProfit,
    required this.customTakeProfit,
    required this.useTrailingStop,
    required this.trailingStopPercent,
  });

  final String providerId;
  final double copyCapital;
  final TradeCopyConfigurationMode copyMode;
  final TradePositionSizingMethod positionSizing;
  final double copyRatio;
  final bool useCustomStopLoss;
  final double customStopLoss;
  final bool useCustomTakeProfit;
  final double customTakeProfit;
  final bool useTrailingStop;
  final double trailingStopPercent;

  TradeCopyConfigurationDraft copyWith({
    double? copyCapital,
    TradeCopyConfigurationMode? copyMode,
    TradePositionSizingMethod? positionSizing,
    double? copyRatio,
    bool? useCustomStopLoss,
    double? customStopLoss,
    bool? useCustomTakeProfit,
    double? customTakeProfit,
    bool? useTrailingStop,
    double? trailingStopPercent,
  }) {
    return TradeCopyConfigurationDraft(
      providerId: providerId,
      copyCapital: copyCapital ?? this.copyCapital,
      copyMode: copyMode ?? this.copyMode,
      positionSizing: positionSizing ?? this.positionSizing,
      copyRatio: copyRatio ?? this.copyRatio,
      useCustomStopLoss: useCustomStopLoss ?? this.useCustomStopLoss,
      customStopLoss: customStopLoss ?? this.customStopLoss,
      useCustomTakeProfit: useCustomTakeProfit ?? this.useCustomTakeProfit,
      customTakeProfit: customTakeProfit ?? this.customTakeProfit,
      useTrailingStop: useTrailingStop ?? this.useTrailingStop,
      trailingStopPercent: trailingStopPercent ?? this.trailingStopPercent,
    );
  }
}

final class TradeCopyConfigurationFeePreview {
  const TradeCopyConfigurationFeePreview({
    required this.platformFee,
    required this.estimatedTradingFees,
    required this.performanceFeeNote,
  });

  final double platformFee;
  final double estimatedTradingFees;
  final String performanceFeeNote;

  double get totalFixedFees => platformFee + estimatedTradingFees;
}

final class TradeCopyConfigurationValidation {
  const TradeCopyConfigurationValidation({
    required this.level,
    required this.message,
  });

  final TradeCopyConfigurationValidationLevel level;
  final String message;
}

final class TradeCopyConfigurationPreview {
  const TradeCopyConfigurationPreview({
    required this.providerId,
    required this.status,
    required this.draft,
    required this.feePreview,
    required this.validations,
  });

  final String providerId;
  final String status;
  final TradeCopyConfigurationDraft draft;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyConfigurationValidation> validations;

  bool get hasBlockingErrors => validations.any(
    (item) => item.level == TradeCopyConfigurationValidationLevel.error,
  );
}

final class TradeCopyConfirmationSnapshot {
  const TradeCopyConfirmationSnapshot({
    required this.providerId,
    required this.provider,
    required this.configuration,
    required this.feePreview,
    required this.scenarios,
    required this.maxLossAmount,
    required this.consentItems,
    required this.coolingOffHours,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final TradeCopyConfigurationDraft configuration;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyScenarioProjection> scenarios;
  final double maxLossAmount;
  final List<TradeCopyConsentItem> consentItems;
  final int coolingOffHours;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradeCopyScenarioProjection {
  const TradeCopyScenarioProjection({
    required this.id,
    required this.title,
    required this.returnPct,
    required this.grossPnl,
    required this.performanceFee,
    required this.slippageLoss,
    required this.fixedFees,
    required this.netPnl,
    required this.netReturnPct,
  });

  final String id;
  final String title;
  final double returnPct;
  final double grossPnl;
  final double performanceFee;
  final double slippageLoss;
  final double fixedFees;
  final double netPnl;
  final double netReturnPct;
}

final class TradeCopyConsentItem {
  const TradeCopyConsentItem({
    required this.id,
    required this.label,
    required this.required,
  });

  final String id;
  final String label;
  final bool required;
}

final class TradeCopyConfirmationRequest {
  const TradeCopyConfirmationRequest({
    required this.providerId,
    required this.configuration,
    required this.acceptedConsentIds,
  });

  final String providerId;
  final TradeCopyConfigurationDraft configuration;
  final List<String> acceptedConsentIds;
}

final class TradeCopyConfirmationResult {
  const TradeCopyConfirmationResult({
    required this.providerId,
    required this.status,
    required this.auditTrailId,
    required this.coolingOffHours,
    required this.activeCopiesPath,
  });

  final String providerId;
  final String status;
  final String auditTrailId;
  final int coolingOffHours;
  final String activeCopiesPath;
}

final class TradeCopyPerformanceSnapshot {
  const TradeCopyPerformanceSnapshot({
    required this.copyId,
    required this.initialCapital,
    required this.yourReturnPct,
    required this.providerReturnPct,
    required this.yourCurrentValue,
    required this.providerTheoreticalValue,
    required this.performanceGapPct,
    required this.avgSlippagePct,
    required this.providerAvgSlippagePct,
    required this.totalCosts,
    required this.equityCurve,
    required this.slippageBuckets,
    required this.costAttribution,
    required this.tradeComparisons,
    required this.metrics,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String copyId;
  final double initialCapital;
  final double yourReturnPct;
  final double providerReturnPct;
  final double yourCurrentValue;
  final double providerTheoreticalValue;
  final double performanceGapPct;
  final double avgSlippagePct;
  final double providerAvgSlippagePct;
  final double totalCosts;
  final List<TradeCopyEquityPoint> equityCurve;
  final List<TradeCopySlippageBucket> slippageBuckets;
  final List<TradeCopyCostAttribution> costAttribution;
  final List<TradeCopyTradeComparison> tradeComparisons;
  final List<TradeCopyMetricComparison> metrics;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyEquityPoint {
  const TradeCopyEquityPoint({
    required this.day,
    required this.you,
    required this.provider,
  });

  final int day;
  final double you;
  final double provider;
}

final class TradeCopySlippageBucket {
  const TradeCopySlippageBucket({
    required this.range,
    required this.youPct,
    required this.providerPct,
  });

  final String range;
  final double youPct;
  final double providerPct;
}

final class TradeCopyCostAttribution {
  const TradeCopyCostAttribution({
    required this.name,
    required this.value,
    required this.colorHex,
  });

  final String name;
  final double value;
  final int colorHex;
}

final class TradeCopyTradeComparison {
  const TradeCopyTradeComparison({
    required this.id,
    required this.pair,
    required this.side,
    required this.providerEntry,
    required this.yourEntry,
    required this.providerExit,
    required this.yourExit,
    required this.providerPnl,
    required this.yourPnl,
    required this.slippagePct,
    required this.delay,
    required this.timestamp,
  });

  final String id;
  final String pair;
  final TradeOrderSide side;
  final double providerEntry;
  final double yourEntry;
  final double providerExit;
  final double yourExit;
  final double providerPnl;
  final double yourPnl;
  final double slippagePct;
  final String delay;
  final String timestamp;
}

final class TradeCopyMetricComparison {
  const TradeCopyMetricComparison({
    required this.name,
    required this.you,
    required this.provider,
    required this.higherIsBetter,
    this.suffix = '',
  });

  final String name;
  final double you;
  final double provider;
  final bool higherIsBetter;
  final String suffix;
}

final class TradePerformanceAttributionSnapshot {
  const TradePerformanceAttributionSnapshot({
    required this.copyId,
    required this.totalReturnPct,
    required this.alphaPct,
    required this.beta,
    required this.rSquared,
    required this.returns,
    required this.drawdowns,
    required this.monteCarloPaths,
    required this.correlationPoints,
    required this.marketContributionPct,
    required this.skillContributionPct,
    required this.maxDrawdownPct,
    required this.avgDrawdownPct,
    required this.medianProjection,
    required this.worstProjection,
    required this.bestProjection,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String copyId;
  final double totalReturnPct;
  final double alphaPct;
  final double beta;
  final double rSquared;
  final List<TradePerformanceReturnPoint> returns;
  final List<TradePerformanceDrawdownPoint> drawdowns;
  final List<List<TradePerformanceProjectionPoint>> monteCarloPaths;
  final List<TradePerformanceCorrelationPoint> correlationPoints;
  final double marketContributionPct;
  final double skillContributionPct;
  final double maxDrawdownPct;
  final double avgDrawdownPct;
  final double medianProjection;
  final double worstProjection;
  final double bestProjection;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradePerformanceReturnPoint {
  const TradePerformanceReturnPoint({
    required this.day,
    required this.market,
    required this.alpha,
  });

  final int day;
  final double market;
  final double alpha;

  double get total => market + alpha;
}

final class TradePerformanceDrawdownPoint {
  const TradePerformanceDrawdownPoint({
    required this.day,
    required this.drawdown,
  });

  final int day;
  final double drawdown;
}

final class TradePerformanceProjectionPoint {
  const TradePerformanceProjectionPoint({
    required this.day,
    required this.value,
  });

  final int day;
  final double value;
}

final class TradePerformanceCorrelationPoint {
  const TradePerformanceCorrelationPoint({
    required this.day,
    required this.marketReturn,
    required this.yourReturn,
  });

  final int day;
  final double marketReturn;
  final double yourReturn;
}

final class TradeProviderComparisonSnapshot {
  const TradeProviderComparisonSnapshot({
    required this.selectedCount,
    required this.maxProviders,
    required this.providers,
    required this.metrics,
    required this.disclaimer,
    required this.legend,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final int selectedCount;
  final int maxProviders;
  final List<TradeProviderComparisonProvider> providers;
  final List<TradeProviderComparisonMetric> metrics;
  final String disclaimer;
  final String legend;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderComparisonProvider {
  const TradeProviderComparisonProvider({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;
}

final class TradeProviderComparisonMetric {
  const TradeProviderComparisonMetric({
    required this.label,
    required this.category,
    required this.higherIsBetter,
    required this.values,
  });

  final String label;
  final TradeProviderComparisonCategory category;
  final bool higherIsBetter;
  final Map<String, String> values;
}

enum TradeProviderComparisonCategory { performance, risk, execution, cost }

enum TradeCopyAuditEventType { trade, config, risk, system }

enum TradeCopyAuditSeverity { info, warning, critical }

final class TradeCopyAuditLogSnapshot {
  const TradeCopyAuditLogSnapshot({
    required this.copyId,
    required this.complianceTitle,
    required this.complianceDescription,
    required this.tabs,
    required this.events,
    required this.exportFormats,
    required this.retentionYears,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String copyId;
  final String complianceTitle;
  final String complianceDescription;
  final List<TradeCopyAuditTab> tabs;
  final List<TradeCopyAuditEvent> events;
  final List<TradeCopyAuditExportFormat> exportFormats;
  final int retentionYears;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeCopyAuditTab {
  const TradeCopyAuditTab({
    required this.id,
    required this.label,
    required this.badge,
    this.type,
  });

  final String id;
  final String label;
  final int badge;
  final TradeCopyAuditEventType? type;
}

final class TradeCopyAuditEvent {
  const TradeCopyAuditEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.severity,
    this.metadata,
  });

  final String id;
  final TradeCopyAuditEventType type;
  final String timestamp;
  final String title;
  final String description;
  final TradeCopyAuditSeverity severity;
  final TradeCopyAuditMetadata? metadata;
}

final class TradeCopyAuditMetadata {
  const TradeCopyAuditMetadata({
    this.pair,
    this.side,
    this.providerPrice,
    this.yourPrice,
    this.slippagePct,
    this.pnl,
    this.oldValue,
    this.newValue,
  });

  final String? pair;
  final TradeOrderSide? side;
  final double? providerPrice;
  final double? yourPrice;
  final double? slippagePct;
  final double? pnl;
  final String? oldValue;
  final String? newValue;
}

final class TradeCopyAuditExportFormat {
  const TradeCopyAuditExportFormat({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeCopyAuditExportRequest {
  const TradeCopyAuditExportRequest({
    required this.copyId,
    required this.format,
    required this.filterId,
    required this.searchQuery,
  });

  final String copyId;
  final String format;
  final String filterId;
  final String searchQuery;
}

final class TradeCopyAuditExportResult {
  const TradeCopyAuditExportResult({
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

final class TradePortfolioRiskAnalysisSnapshot {
  const TradePortfolioRiskAnalysisSnapshot({
    required this.totalExposure,
    required this.var95,
    required this.var99,
    required this.diversificationScore,
    required this.assetExposures,
    required this.riskAlerts,
    required this.tabs,
    required this.scenarios,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final double totalExposure;
  final double var95;
  final double var99;
  final int diversificationScore;
  final List<TradeAssetExposure> assetExposures;
  final List<String> riskAlerts;
  final List<TradePortfolioRiskTab> tabs;
  final List<TradeStressScenario> scenarios;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeAssetExposure {
  const TradeAssetExposure({
    required this.asset,
    required this.value,
    required this.percent,
    required this.colorHex,
  });

  final String asset;
  final double value;
  final double percent;
  final int colorHex;
}

final class TradePortfolioRiskTab {
  const TradePortfolioRiskTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeStressScenario {
  const TradeStressScenario({
    required this.name,
    required this.impact,
    required this.probability,
    required this.colorHex,
  });

  final String name;
  final double impact;
  final int probability;
  final int colorHex;
}

final class TradeProviderLeaderboardSnapshot {
  const TradeProviderLeaderboardSnapshot({
    required this.trade,
    required this.providers,
    required this.sortOptions,
    required this.riskFilters,
    required this.defaultSortId,
    required this.defaultRiskFilterId,
    required this.defaultVerifiedOnly,
    required this.warningTitle,
    required this.warningText,
    required this.verifiedOnlyLabel,
    required this.disclaimer,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyTrader> providers;
  final List<TradeProviderLeaderboardSort> sortOptions;
  final List<TradeProviderLeaderboardRiskFilter> riskFilters;
  final String defaultSortId;
  final String defaultRiskFilterId;
  final bool defaultVerifiedOnly;
  final String warningTitle;
  final String warningText;
  final String verifiedOnlyLabel;
  final String disclaimer;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderLeaderboardSort {
  const TradeProviderLeaderboardSort({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeProviderLeaderboardRiskFilter {
  const TradeProviderLeaderboardRiskFilter({
    required this.id,
    required this.label,
    this.riskLevel,
  });

  final String id;
  final String label;
  final TradeCopyRiskLevel? riskLevel;
}

final class TradeSafetyEducationSnapshot {
  const TradeSafetyEducationSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.scams,
    required this.redFlags,
    required this.verificationTiers,
    required this.reportReasons,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeSafetyTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final List<TradeSafetyScamType> scams;
  final List<TradeSafetyRedFlag> redFlags;
  final List<TradeSafetyVerificationTier> verificationTiers;
  final List<String> reportReasons;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeSafetyTab {
  const TradeSafetyTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeSafetyScamType {
  const TradeSafetyScamType({
    required this.id,
    required this.title,
    required this.description,
    required this.examples,
    required this.howToAvoid,
  });

  final String id;
  final String title;
  final String description;
  final List<String> examples;
  final List<String> howToAvoid;
}

final class TradeSafetyRedFlag {
  const TradeSafetyRedFlag({
    required this.id,
    required this.category,
    required this.flag,
    required this.severity,
    required this.explanation,
  });

  final String id;
  final String category;
  final String flag;
  final String severity;
  final String explanation;
}

final class TradeSafetyVerificationTier {
  const TradeSafetyVerificationTier({
    required this.tier,
    required this.colorHex,
    required this.requirements,
  });

  final String tier;
  final int colorHex;
  final List<String> requirements;
}

final class TradeProviderGovernanceSnapshot {
  const TradeProviderGovernanceSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.stats,
    required this.warning,
    required this.modifications,
    required this.messages,
    required this.feeContributors,
    required this.complianceItems,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderGovernanceTab> tabs;
  final String defaultTabId;
  final TradeProviderGovernanceStats stats;
  final String warning;
  final List<TradeStrategyModification> modifications;
  final List<TradeFollowerMessage> messages;
  final List<TradeFeeContributor> feeContributors;
  final List<TradeComplianceItem> complianceItems;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderGovernanceTab {
  const TradeProviderGovernanceTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeProviderGovernanceStats {
  const TradeProviderGovernanceStats({
    required this.followers,
    required this.aum,
    required this.monthlyFeesEarned,
    required this.allTimeFeesEarned,
    required this.complianceScore,
  });

  final int followers;
  final double aum;
  final double monthlyFeesEarned;
  final double allTimeFeesEarned;
  final int complianceScore;
}

final class TradeStrategyModification {
  const TradeStrategyModification({
    required this.id,
    required this.date,
    required this.type,
    required this.oldValue,
    required this.newValue,
    required this.notificationSent,
    required this.followerImpact,
  });

  final String id;
  final String date;
  final String type;
  final String oldValue;
  final String newValue;
  final bool notificationSent;
  final int followerImpact;
}

final class TradeFollowerMessage {
  const TradeFollowerMessage({
    required this.id,
    required this.date,
    required this.subject,
    required this.body,
    required this.recipients,
    required this.openRate,
  });

  final String id;
  final String date;
  final String subject;
  final String body;
  final int recipients;
  final int openRate;
}

final class TradeFeeContributor {
  const TradeFeeContributor({
    required this.name,
    required this.profit,
    required this.fee,
  });

  final String name;
  final double profit;
  final double fee;
}

final class TradeComplianceItem {
  const TradeComplianceItem({
    required this.item,
    required this.status,
    required this.lastCheck,
  });

  final String item;
  final bool status;
  final String lastCheck;
}

final class TradeDisputeResolutionSnapshot {
  const TradeDisputeResolutionSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.noticeTitle,
    required this.noticeBody,
    required this.complaintTypes,
    required this.providers,
    required this.activeCases,
    required this.resolvedCases,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeDisputeTab> tabs;
  final String defaultTabId;
  final String noticeTitle;
  final String noticeBody;
  final List<TradeComplaintTypeOption> complaintTypes;
  final List<TradeDisputeProviderOption> providers;
  final List<TradeDisputeCase> activeCases;
  final List<TradeDisputeCase> resolvedCases;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeDisputeTab {
  const TradeDisputeTab({
    required this.id,
    required this.label,
    this.badgeCount,
  });

  final String id;
  final String label;
  final int? badgeCount;
}

final class TradeComplaintTypeOption {
  const TradeComplaintTypeOption({
    required this.value,
    required this.label,
    required this.description,
  });

  final String value;
  final String label;
  final String description;
}

final class TradeDisputeProviderOption {
  const TradeDisputeProviderOption({required this.id, required this.name});

  final String id;
  final String name;
}

final class TradeDisputeCase {
  const TradeDisputeCase({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.complaintType,
    required this.subject,
    required this.description,
    required this.status,
    required this.submittedDate,
    required this.updatedDate,
    required this.estimatedResolution,
    this.outcome,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String complaintType;
  final String subject;
  final String description;
  final String status;
  final String submittedDate;
  final String updatedDate;
  final String estimatedResolution;
  final String? outcome;
}

final class TradeDisputeComplaintDraft {
  const TradeDisputeComplaintDraft({
    required this.complaintType,
    required this.providerId,
    required this.subject,
    required this.description,
    this.evidenceNames = const [],
  });

  final String complaintType;
  final String providerId;
  final String subject;
  final String description;
  final List<String> evidenceNames;
}

final class TradeDisputeSubmissionResult {
  const TradeDisputeSubmissionResult({
    required this.caseId,
    required this.status,
    required this.message,
  });

  final String caseId;
  final String status;
  final String message;
}

final class TradeCopySafetyCenterSnapshot {
  const TradeCopySafetyCenterSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.verificationIntro,
    required this.verificationTiers,
    required this.trustMetrics,
    required this.prohibitedBehaviors,
    required this.followerResponsibilities,
    required this.reportingSteps,
    required this.safetyTools,
    required this.enforcementActions,
    required this.warningText,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopySafetyCenterTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final String verificationIntro;
  final List<TradeCopyVerificationTier> verificationTiers;
  final List<TradeCopyTrustMetric> trustMetrics;
  final List<String> prohibitedBehaviors;
  final List<String> followerResponsibilities;
  final List<TradeCopyReportingStep> reportingSteps;
  final List<TradeCopySafetyTool> safetyTools;
  final List<TradeCopyEnforcementAction> enforcementActions;
  final String warningText;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopySafetyCenterTab {
  const TradeCopySafetyCenterTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeCopyVerificationTier {
  const TradeCopyVerificationTier({
    required this.tier,
    required this.requirements,
    required this.benefits,
    required this.colorHex,
  });

  final String tier;
  final List<String> requirements;
  final List<String> benefits;
  final int colorHex;
}

final class TradeCopyTrustMetric {
  const TradeCopyTrustMetric({
    required this.name,
    required this.description,
    required this.goodRange,
    required this.badRange,
    required this.whyMatters,
  });

  final String name;
  final String description;
  final String goodRange;
  final String badRange;
  final String whyMatters;
}

final class TradeCopyReportingStep {
  const TradeCopyReportingStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeCopySafetyTool {
  const TradeCopySafetyTool({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    this.routePath,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String? routePath;
}

final class TradeCopyEnforcementAction {
  const TradeCopyEnforcementAction({
    required this.id,
    required this.date,
    required this.providerName,
    required this.action,
    required this.reason,
  });

  final String id;
  final String date;
  final String providerName;
  final String action;
  final String reason;
}

final class TradeRegulatoryDisclosuresSnapshot {
  const TradeRegulatoryDisclosuresSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.mifidTitle,
    required this.mifidArticles,
    required this.commitmentText,
    required this.protection,
    required this.restrictions,
    required this.liability,
    required this.contacts,
    required this.whistleblower,
    required this.terms,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeRegulatoryTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final String mifidTitle;
  final List<TradeRegulatoryDisclosureBlock> mifidArticles;
  final String commitmentText;
  final TradeRegulatoryProtection protection;
  final TradeRegulatoryRestrictions restrictions;
  final TradeRegulatoryLiability liability;
  final List<TradeRegulatoryContact> contacts;
  final TradeRegulatoryDisclosureBlock whistleblower;
  final List<TradeRegulatoryDocumentLink> terms;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeRegulatoryTab {
  const TradeRegulatoryTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeRegulatoryDisclosureBlock {
  const TradeRegulatoryDisclosureBlock({
    required this.title,
    required this.body,
    this.items = const [],
  });

  final String title;
  final String body;
  final List<String> items;
}

final class TradeRegulatoryProtection {
  const TradeRegulatoryProtection({
    required this.coverage,
    required this.covered,
    required this.notCovered,
    required this.claimSteps,
    required this.contactLabel,
  });

  final TradeRegulatoryDisclosureBlock coverage;
  final TradeRegulatoryDisclosureBlock covered;
  final TradeRegulatoryDisclosureBlock notCovered;
  final TradeRegulatoryDisclosureBlock claimSteps;
  final String contactLabel;
}

final class TradeRegulatoryRestrictions {
  const TradeRegulatoryRestrictions({
    required this.unavailableCountries,
    required this.leverageRules,
    required this.taxReporting,
  });

  final List<String> unavailableCountries;
  final List<TradeRegulatoryDisclosureBlock> leverageRules;
  final TradeRegulatoryDisclosureBlock taxReporting;
}

final class TradeRegulatoryLiability {
  const TradeRegulatoryLiability({
    required this.platformRole,
    required this.userResponsibility,
    required this.indemnification,
    required this.limitation,
  });

  final TradeRegulatoryDisclosureBlock platformRole;
  final TradeRegulatoryDisclosureBlock userResponsibility;
  final TradeRegulatoryDisclosureBlock indemnification;
  final TradeRegulatoryDisclosureBlock limitation;
}

final class TradeRegulatoryContact {
  const TradeRegulatoryContact({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String icon;
}

final class TradeRegulatoryDocumentLink {
  const TradeRegulatoryDocumentLink({required this.title, required this.icon});

  final String title;
  final String icon;
}

final class TradeMarginTradingSnapshot {
  const TradeMarginTradingSnapshot({
    required this.trade,
    required this.pair,
    required this.account,
    required this.positions,
    required this.modeTabs,
    required this.contentTabs,
    required this.defaultMode,
    required this.defaultTab,
    required this.defaultSide,
    required this.defaultLeverage,
    required this.clientCategory,
    required this.referencePrices,
    required this.orderDraft,
    required this.riskWarning,
    required this.negativeBalance,
    required this.bestExecution,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradePair pair;
  final TradeMarginAccount account;
  final List<TradeMarginPosition> positions;
  final List<TradeMarginTab> modeTabs;
  final List<TradeMarginTab> contentTabs;
  final String defaultMode;
  final String defaultTab;
  final String defaultSide;
  final int defaultLeverage;
  final TradeMarginClientCategory clientCategory;
  final TradeMarginReferencePrices referencePrices;
  final TradeMarginOrderDraft orderDraft;
  final TradeMarginRiskWarning riskWarning;
  final TradeMarginSafetyDisclosure negativeBalance;
  final TradeMarginBestExecutionDisclosure bestExecution;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeMarginAccount {
  const TradeMarginAccount({
    required this.totalEquity,
    required this.totalMargin,
    required this.availableMargin,
    required this.unrealizedPnl,
    required this.marginLevel,
  });

  final double totalEquity;
  final double totalMargin;
  final double availableMargin;
  final double unrealizedPnl;
  final double marginLevel;
}

final class TradeMarginPosition {
  const TradeMarginPosition({
    required this.id,
    required this.pair,
    required this.side,
    required this.mode,
    required this.leverage,
    required this.entryPrice,
    required this.markPrice,
    required this.size,
    required this.margin,
    required this.pnl,
    required this.pnlPct,
    required this.liquidationPrice,
    required this.marginRatio,
  });

  final String id;
  final String pair;
  final String side;
  final String mode;
  final int leverage;
  final double entryPrice;
  final double markPrice;
  final double size;
  final double margin;
  final double pnl;
  final double pnlPct;
  final double liquidationPrice;
  final double marginRatio;
}

final class TradeMarginTab {
  const TradeMarginTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeMarginClientCategory {
  const TradeMarginClientCategory({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.limits,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final List<String> limits;
}

final class TradeMarginReferencePrices {
  const TradeMarginReferencePrices({
    required this.markPrice,
    required this.lastPrice,
    required this.indexPrice,
  });

  final double markPrice;
  final double lastPrice;
  final double indexPrice;
}

final class TradeMarginOrderDraft {
  const TradeMarginOrderDraft({
    required this.orderTypes,
    required this.selectedOrderType,
    required this.price,
    required this.amount,
    required this.tradingFeeRate,
    required this.liquidationPriceLabel,
  });

  final List<TradeMarginTab> orderTypes;
  final String selectedOrderType;
  final String price;
  final String amount;
  final double tradingFeeRate;
  final String liquidationPriceLabel;
}

final class TradeMarginRiskWarning {
  const TradeMarginRiskWarning({required this.title, required this.items});

  final String title;
  final List<String> items;
}

final class TradeMarginSafetyDisclosure {
  const TradeMarginSafetyDisclosure({
    required this.title,
    required this.body,
    required this.footer,
  });

  final String title;
  final String body;
  final String footer;
}

final class TradeMarginBestExecutionDisclosure {
  const TradeMarginBestExecutionDisclosure({
    required this.title,
    required this.body,
    required this.items,
    required this.actionLabel,
  });

  final String title;
  final String body;
  final List<String> items;
  final String actionLabel;
}

final class TradeTraderProfileSnapshot {
  const TradeTraderProfileSnapshot({
    required this.traderId,
    required this.trader,
    required this.pnlHistory,
    required this.recentTrades,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String traderId;
  final TradeCopyTrader trader;
  final List<TradeTraderPnlPoint> pnlHistory;
  final List<TradeTraderRecentTrade> recentTrades;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeTraderPnlPoint {
  const TradeTraderPnlPoint({
    required this.day,
    required this.pnl,
    required this.cumPnl,
  });

  final String day;
  final double pnl;
  final double cumPnl;
}

final class TradeTraderRecentTrade {
  const TradeTraderRecentTrade({
    required this.id,
    required this.pair,
    required this.side,
    required this.entry,
    required this.exit,
    required this.pnl,
    required this.pnlPct,
    required this.time,
    required this.status,
  });

  final String id;
  final String pair;
  final String side;
  final double entry;
  final double? exit;
  final double pnl;
  final double pnlPct;
  final String time;
  final String status;
}

final class TradeAdvancedTradingDemoSnapshot {
  const TradeAdvancedTradingDemoSnapshot({
    required this.position,
    required this.positionActions,
    required this.orderTypes,
    required this.timeInForce,
    required this.orderSummary,
    required this.pnlSummary,
    required this.performanceMetrics,
    required this.defaultTab,
    required this.defaultPositionMode,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeAdvancedDemoPosition position;
  final List<TradeAdvancedDemoAction> positionActions;
  final List<TradeAdvancedDemoAction> orderTypes;
  final List<TradeAdvancedDemoAction> timeInForce;
  final List<TradeAdvancedDemoMetric> orderSummary;
  final List<TradeAdvancedDemoMetric> pnlSummary;
  final List<TradeAdvancedDemoMetric> performanceMetrics;
  final String defaultTab;
  final String defaultPositionMode;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeAdvancedDemoPosition {
  const TradeAdvancedDemoPosition({
    required this.id,
    required this.pair,
    required this.side,
    required this.currentSize,
    required this.currentPnl,
    required this.markPrice,
    required this.entryPrice,
    required this.currentMargin,
    required this.availableBalance,
    required this.liquidationPrice,
  });

  final String id;
  final String pair;
  final String side;
  final double currentSize;
  final double currentPnl;
  final double markPrice;
  final double entryPrice;
  final double currentMargin;
  final double availableBalance;
  final double liquidationPrice;
}

final class TradeAdvancedDemoAction {
  const TradeAdvancedDemoAction({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

enum TradeAdvancedMetricTone { neutral, positive, negative, warning, accent }

final class TradeAdvancedDemoMetric {
  const TradeAdvancedDemoMetric({
    required this.label,
    required this.value,
    this.tone = TradeAdvancedMetricTone.neutral,
  });

  final String label;
  final String value;
  final TradeAdvancedMetricTone tone;
}

final class TradeMarketDataAnalyticsSnapshot {
  const TradeMarketDataAnalyticsSnapshot({
    required this.selectedPair,
    required this.markPrice,
    required this.openInterest,
    required this.longShortRatio,
    required this.topTraders,
    required this.fundingRate,
    required this.liquidationStats,
    required this.liquidationClusters,
    required this.recentLiquidations,
    required this.sentiment,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String selectedPair;
  final double markPrice;
  final TradeMarketOpenInterest openInterest;
  final TradeMarketLongShortRatio longShortRatio;
  final TradeTopTraderPositions topTraders;
  final TradeFundingRateHistory fundingRate;
  final TradeLiquidationStats liquidationStats;
  final List<TradeLiquidationCluster> liquidationClusters;
  final List<TradeRecentLiquidation> recentLiquidations;
  final TradeMarketSentiment sentiment;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeMarketOpenInterest {
  const TradeMarketOpenInterest({
    required this.current,
    required this.change24h,
    required this.change24hPct,
    required this.high24h,
    required this.low24h,
  });

  final double current;
  final double change24h;
  final double change24hPct;
  final double high24h;
  final double low24h;
}

final class TradeMarketLongShortRatio {
  const TradeMarketLongShortRatio({
    required this.longPct,
    required this.shortPct,
    required this.longAccounts,
    required this.shortAccounts,
    required this.longVolume,
    required this.shortVolume,
  });

  final double longPct;
  final double shortPct;
  final int longAccounts;
  final int shortAccounts;
  final double longVolume;
  final double shortVolume;

  double get ratio => longPct / shortPct;
}

final class TradeTopTraderPositions {
  const TradeTopTraderPositions({
    required this.longPct,
    required this.shortPct,
    required this.change24h,
  });

  final double longPct;
  final double shortPct;
  final double change24h;
}

final class TradeFundingRateHistory {
  const TradeFundingRateHistory({
    required this.currentRatePct,
    required this.avgRatePct,
    required this.rangePct,
    required this.nextFundingLabel,
    required this.historyPct,
  });

  final double currentRatePct;
  final double avgRatePct;
  final double rangePct;
  final String nextFundingLabel;
  final List<double> historyPct;
}

final class TradeLiquidationStats {
  const TradeLiquidationStats({
    required this.total24h,
    required this.long24h,
    required this.short24h,
    required this.largest24h,
    required this.avg24h,
    required this.count24h,
    required this.total7d,
    required this.count7d,
    required this.total30d,
    required this.count30d,
  });

  final double total24h;
  final double long24h;
  final double short24h;
  final double largest24h;
  final double avg24h;
  final int count24h;
  final double total7d;
  final int count7d;
  final double total30d;
  final int count30d;
}

final class TradeLiquidationCluster {
  const TradeLiquidationCluster({
    required this.price,
    required this.longLiquidations,
    required this.shortLiquidations,
    required this.total,
    required this.intensity,
  });

  final double price;
  final double longLiquidations;
  final double shortLiquidations;
  final double total;
  final int intensity;
}

final class TradeRecentLiquidation {
  const TradeRecentLiquidation({
    required this.id,
    required this.timeLabel,
    required this.pair,
    required this.side,
    required this.size,
    required this.price,
    required this.exchange,
  });

  final String id;
  final String timeLabel;
  final String pair;
  final String side;
  final double size;
  final double price;
  final String exchange;
}

final class TradeMarketSentiment {
  const TradeMarketSentiment({
    required this.overall,
    required this.score,
    required this.components,
    required this.implications,
  });

  final String overall;
  final int score;
  final List<TradeSentimentComponent> components;
  final List<TradeSentimentImplication> implications;
}

final class TradeSentimentComponent {
  const TradeSentimentComponent({
    required this.label,
    required this.weight,
    required this.score,
    required this.description,
  });

  final String label;
  final String weight;
  final int score;
  final String description;
}

final class TradeSentimentImplication {
  const TradeSentimentImplication({
    required this.condition,
    required this.action,
    required this.colorHex,
  });

  final String condition;
  final String action;
  final int colorHex;
}

final class TradeMarginTradingHubSnapshot {
  const TradeMarginTradingHubSnapshot({
    required this.stats,
    required this.menuItems,
    required this.features,
    required this.compliance,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeMarginHubStat> stats;
  final List<TradeMarginHubMenuItem> menuItems;
  final List<TradeMarginHubFeature> features;
  final TradeMarginHubCompliance compliance;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeMarginHubStat {
  const TradeMarginHubStat({
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String label;
  final String value;
  final int colorHex;
}

final class TradeMarginHubMenuItem {
  const TradeMarginHubMenuItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.colorHex,
    required this.targetPath,
  });

  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final int colorHex;
  final String targetPath;
}

final class TradeMarginHubFeature {
  const TradeMarginHubFeature({
    required this.phase,
    required this.title,
    required this.colorHex,
    required this.items,
  });

  final String phase;
  final String title;
  final int colorHex;
  final List<String> items;
}

final class TradeMarginHubCompliance {
  const TradeMarginHubCompliance({
    required this.title,
    required this.description,
    required this.regulations,
  });

  final String title;
  final String description;
  final List<String> regulations;
}

final class TradeAdvancedAnalyticsSnapshot {
  const TradeAdvancedAnalyticsSnapshot({
    required this.stats,
    required this.signals,
    required this.features,
    required this.risk,
    required this.journal,
    required this.sizing,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeAdvancedAnalyticsStat> stats;
  final List<TradeAiSignal> signals;
  final List<String> features;
  final TradeAdvancedRiskSummary risk;
  final TradeJournalSummary journal;
  final TradePositionSizingSummary sizing;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeAdvancedAnalyticsStat {
  const TradeAdvancedAnalyticsStat({
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String label;
  final String value;
  final int colorHex;
}

final class TradeAiSignal {
  const TradeAiSignal({
    required this.id,
    required this.pair,
    required this.direction,
    required this.confidence,
    required this.timeframe,
    required this.entryPrice,
    required this.targetPrice,
    required this.stopLoss,
    required this.riskReward,
    required this.accuracy,
    required this.reasoning,
  });

  final String id;
  final String pair;
  final String direction;
  final int confidence;
  final String timeframe;
  final double entryPrice;
  final double targetPrice;
  final double stopLoss;
  final double riskReward;
  final int accuracy;
  final List<String> reasoning;
}

final class TradeAdvancedRiskSummary {
  const TradeAdvancedRiskSummary({
    required this.var95,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.riskScore,
    required this.riskLevel,
  });

  final double var95;
  final double sharpeRatio;
  final double maxDrawdown;
  final int riskScore;
  final String riskLevel;
}

final class TradeJournalSummary {
  const TradeJournalSummary({
    required this.winRate,
    required this.totalTrades,
    required this.totalPnl,
    required this.avgWin,
    required this.avgLoss,
  });

  final double winRate;
  final int totalTrades;
  final double totalPnl;
  final double avgWin;
  final double avgLoss;
}

final class TradePositionSizingSummary {
  const TradePositionSizingSummary({
    required this.accountBalance,
    required this.entryPrice,
    required this.stopLossPrice,
    required this.takeProfitPrice,
    required this.recommendedRiskPct,
    required this.positionSize,
  });

  final double accountBalance;
  final double entryPrice;
  final double stopLossPrice;
  final double takeProfitPrice;
  final double recommendedRiskPct;
  final double positionSize;
}

final class TradeTransactionReportingSnapshot {
  const TradeTransactionReportingSnapshot({
    required this.reports,
    required this.stats,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeTransactionReport> reports;
  final TradeTransactionReportingStats stats;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;

  List<TradeTransactionReport> reportsForTab(String tab) {
    return switch (tab) {
      'queue' =>
        reports
            .where(
              (report) => [
                'pending',
                'submitting',
                'submitted',
              ].contains(report.status),
            )
            .toList(),
      'history' =>
        reports.where((report) => report.status == 'confirmed').toList(),
      'failed' => reports.where((report) => report.status == 'failed').toList(),
      _ => reports,
    };
  }
}

final class TradeTransactionReport {
  const TradeTransactionReport({
    required this.id,
    required this.transactionId,
    required this.reportType,
    required this.tradingVenue,
    required this.instrument,
    required this.side,
    required this.quantity,
    required this.price,
    required this.value,
    required this.executionTime,
    this.reportedTime,
    this.confirmedTime,
    required this.status,
    required this.armProvider,
    this.messageId,
    this.errorMessage,
    required this.retryCount,
    required this.slaStatus,
  });

  final String id;
  final String transactionId;
  final String reportType;
  final String tradingVenue;
  final String instrument;
  final String side;
  final double quantity;
  final double price;
  final double value;
  final String executionTime;
  final String? reportedTime;
  final String? confirmedTime;
  final String status;
  final String armProvider;
  final String? messageId;
  final String? errorMessage;
  final int retryCount;
  final String slaStatus;
}

final class TradeTransactionReportingStats {
  const TradeTransactionReportingStats({
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.pending,
    required this.onTime,
    required this.avgLatencySeconds,
    required this.totalValue,
    required this.mifidReports,
    required this.emirReports,
    required this.providerCounts,
  });

  final int total;
  final int confirmed;
  final int failed;
  final int pending;
  final int onTime;
  final int avgLatencySeconds;
  final double totalValue;
  final int mifidReports;
  final int emirReports;
  final Map<String, int> providerCounts;
}

final class TradeRegulatoryReportsDashboardSnapshot {
  const TradeRegulatoryReportsDashboardSnapshot({
    required this.dailyStats,
    required this.providers,
    required this.distribution,
    required this.totals,
    required this.timeRanges,
    required this.defaultRange,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeRegulatoryDailyStat> dailyStats;
  final List<TradeRegulatoryArmProvider> providers;
  final List<TradeRegulatoryDistributionItem> distribution;
  final TradeRegulatoryDashboardTotals totals;
  final List<String> timeRanges;
  final String defaultRange;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeRegulatoryDailyStat {
  const TradeRegulatoryDailyStat({
    required this.date,
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.avgLatency,
  });

  final String date;
  final int total;
  final int confirmed;
  final int failed;
  final int avgLatency;
}

final class TradeRegulatoryArmProvider {
  const TradeRegulatoryArmProvider({
    required this.name,
    required this.reports,
    required this.successRate,
    required this.avgLatency,
    required this.status,
  });

  final String name;
  final int reports;
  final double successRate;
  final int avgLatency;
  final String status;
}

final class TradeRegulatoryDistributionItem {
  const TradeRegulatoryDistributionItem({
    required this.name,
    required this.value,
    required this.colorHex,
  });

  final String name;
  final int value;
  final int colorHex;
}

final class TradeRegulatoryDashboardTotals {
  const TradeRegulatoryDashboardTotals({
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.avgLatency,
    required this.successRate,
    required this.distributionTotal,
  });

  final int total;
  final int confirmed;
  final int failed;
  final double avgLatency;
  final double successRate;
  final int distributionTotal;
}

final class TradeArmIntegrationStatusSnapshot {
  const TradeArmIntegrationStatusSnapshot({
    required this.connections,
    required this.latencyHistory,
    required this.sla,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeArmConnection> connections;
  final List<TradeArmLatencyPoint> latencyHistory;
  final TradeArmSlaMetrics sla;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeArmConnection {
  const TradeArmConnection({
    required this.id,
    required this.provider,
    required this.region,
    required this.status,
    required this.uptime,
    required this.avgLatency,
    required this.currentLatency,
    required this.lastCheck,
    required this.isPrimary,
    required this.endpoint,
    required this.certExpiry,
  });

  final String id;
  final String provider;
  final String region;
  final String status;
  final double uptime;
  final int avgLatency;
  final int currentLatency;
  final String lastCheck;
  final bool isPrimary;
  final String endpoint;
  final String certExpiry;
}

final class TradeArmLatencyPoint {
  const TradeArmLatencyPoint({
    required this.time,
    required this.registr,
    required this.unavista,
    required this.bloomberg,
  });

  final String time;
  final int registr;
  final int unavista;
  final int bloomberg;
}

final class TradeArmSlaMetrics {
  const TradeArmSlaMetrics({
    required this.uptime,
    required this.latencyAvg,
    required this.failoverReadiness,
  });

  final double uptime;
  final int latencyAvg;
  final int failoverReadiness;
}

final class TradeBestExecutionReportsSnapshot {
  const TradeBestExecutionReportsSnapshot({
    required this.venues,
    required this.archive,
    required this.summary,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeExecutionVenue> venues;
  final List<TradeQuarterlyReport> archive;
  final TradeBestExecutionSummary summary;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeExecutionVenue {
  const TradeExecutionVenue({
    required this.rank,
    required this.venue,
    required this.volume,
    required this.value,
    required this.avgPrice,
    required this.avgCost,
    required this.avgSpeed,
    required this.fillRate,
    required this.score,
  });

  final int rank;
  final String venue;
  final int volume;
  final double value;
  final int avgPrice;
  final double avgCost;
  final double avgSpeed;
  final double fillRate;
  final double score;
}

final class TradeQuarterlyReport {
  const TradeQuarterlyReport({
    required this.id,
    required this.quarter,
    required this.year,
    required this.period,
    required this.totalOrders,
    required this.totalValue,
    required this.publishDate,
    required this.status,
  });

  final String id;
  final String quarter;
  final int year;
  final String period;
  final int totalOrders;
  final double totalValue;
  final String publishDate;
  final String status;
}

final class TradeBestExecutionSummary {
  const TradeBestExecutionSummary({
    required this.totalOrders,
    required this.totalValue,
    required this.avgScore,
  });

  final int totalOrders;
  final double totalValue;
  final double avgScore;
}

final class TradeExecutionVenueAnalysisSnapshot {
  const TradeExecutionVenueAnalysisSnapshot({
    required this.venues,
    required this.costTrends,
    required this.summary,
    required this.defaultSort,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeExecutionVenueAnalysisMetric> venues;
  final List<TradeExecutionVenueCostTrend> costTrends;
  final TradeExecutionVenueAnalysisSummary summary;
  final String defaultSort;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeExecutionVenueAnalysisMetric {
  const TradeExecutionVenueAnalysisMetric({
    required this.venue,
    required this.volume,
    required this.value,
    required this.avgFee,
    required this.avgSpread,
    required this.marketImpact,
    required this.totalCost,
    required this.avgLatency,
    required this.avgFillTime,
    required this.fillRate,
    required this.liquidity,
    required this.reliability,
  });

  final String venue;
  final int volume;
  final double value;
  final double avgFee;
  final double avgSpread;
  final double marketImpact;
  final double totalCost;
  final int avgLatency;
  final double avgFillTime;
  final double fillRate;
  final int liquidity;
  final double reliability;
}

final class TradeExecutionVenueCostTrend {
  const TradeExecutionVenueCostTrend({
    required this.month,
    required this.binance,
    required this.coinbase,
    required this.kraken,
  });

  final String month;
  final double binance;
  final double coinbase;
  final double kraken;
}

final class TradeExecutionVenueAnalysisSummary {
  const TradeExecutionVenueAnalysisSummary({
    required this.totalVenues,
    required this.avgTotalCost,
    required this.avgFillTime,
  });

  final int totalVenues;
  final double avgTotalCost;
  final double avgFillTime;
}

final class TradeSlippageMonitoringSnapshot {
  const TradeSlippageMonitoringSnapshot({
    required this.events,
    required this.providers,
    required this.history,
    required this.summary,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeSlippageEvent> events;
  final List<TradeSlippageProviderStats> providers;
  final List<TradeSlippageHistoryPoint> history;
  final TradeSlippageSummary summary;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeSlippageEvent {
  const TradeSlippageEvent({
    required this.id,
    required this.time,
    required this.provider,
    required this.instrument,
    required this.side,
    required this.expectedPrice,
    required this.executedPrice,
    required this.slippageBps,
    required this.slippagePct,
    required this.volume,
    required this.value,
    required this.severity,
  });

  final String id;
  final String time;
  final String provider;
  final String instrument;
  final String side;
  final double expectedPrice;
  final double executedPrice;
  final double slippageBps;
  final double slippagePct;
  final double volume;
  final double value;
  final String severity;
}

final class TradeSlippageProviderStats {
  const TradeSlippageProviderStats({
    required this.provider,
    required this.avgSlippage,
    required this.maxSlippage,
    required this.eventCount,
    required this.warningCount,
    required this.criticalCount,
    required this.totalImpact,
  });

  final String provider;
  final double avgSlippage;
  final double maxSlippage;
  final int eventCount;
  final int warningCount;
  final int criticalCount;
  final double totalImpact;
}

final class TradeSlippageHistoryPoint {
  const TradeSlippageHistoryPoint({
    required this.date,
    required this.avg,
    required this.max,
  });

  final String date;
  final double avg;
  final double max;
}

final class TradeSlippageSummary {
  const TradeSlippageSummary({
    required this.total,
    required this.normal,
    required this.warning,
    required this.critical,
    required this.avgSlippage,
    required this.maxSlippage,
  });

  final int total;
  final int normal;
  final int warning;
  final int critical;
  final double avgSlippage;
  final double maxSlippage;
}

final class TradeClientCategorizationSnapshot {
  const TradeClientCategorizationSnapshot({
    required this.categories,
    required this.history,
    required this.currentCategoryId,
    required this.defaultTab,
    required this.supportedStates,
  });

  final List<TradeClientCategoryInfo> categories;
  final List<TradeClientCategoryHistory> history;
  final String currentCategoryId;
  final String defaultTab;
  final List<TradeScreenState> supportedStates;
}

final class TradeClientCategoryInfo {
  const TradeClientCategoryInfo({
    required this.id,
    required this.label,
    required this.description,
    required this.protections,
    required this.requirements,
  });

  final String id;
  final String label;
  final String description;
  final List<String> protections;
  final List<String> requirements;
}

final class TradeClientCategoryHistory {
  const TradeClientCategoryHistory({
    required this.date,
    required this.action,
    required this.toCategoryId,
    required this.reason,
    this.fromCategoryId,
  });

  final String date;
  final String action;
  final String? fromCategoryId;
  final String toCategoryId;
  final String reason;
}

final class TradeProductGovernanceSnapshot {
  const TradeProductGovernanceSnapshot({
    required this.products,
    required this.defaultTab,
    required this.nextReviewLabel,
    required this.supportedStates,
  });

  final List<TradeCopyProduct> products;
  final String defaultTab;
  final String nextReviewLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeCopyProduct {
  const TradeCopyProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.targetMarket,
    required this.negativeTarget,
    required this.riskLevel,
    required this.lastReview,
    required this.nextReview,
    required this.distributionChannels,
  });

  final String id;
  final String name;
  final String type;
  final String status;
  final List<String> targetMarket;
  final List<String> negativeTarget;
  final String riskLevel;
  final String lastReview;
  final String nextReview;
  final List<String> distributionChannels;
}

final class TradeTargetMarketDefinitionSnapshot {
  const TradeTargetMarketDefinitionSnapshot({
    required this.product,
    required this.dimensions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeCopyProduct product;
  final List<TradeTargetMarketDimension> dimensions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeTargetMarketDimension {
  const TradeTargetMarketDimension({
    required this.id,
    required this.category,
    required this.suitableFor,
    required this.notSuitableFor,
  });

  final String id;
  final String category;
  final List<String> suitableFor;
  final List<String> notSuitableFor;
}

final class TradeClientMoneyProtectionSnapshot {
  const TradeClientMoneyProtectionSnapshot({
    required this.balance,
    required this.trustAccount,
    required this.lastReconciled,
    required this.protections,
    required this.insolvencySummary,
    required this.insolvencyDetail,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double balance;
  final String trustAccount;
  final String lastReconciled;
  final List<TradeClientMoneyProtectionItem> protections;
  final String insolvencySummary;
  final String insolvencyDetail;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeClientMoneyProtectionItem {
  const TradeClientMoneyProtectionItem({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeCassReconciliationSnapshot {
  const TradeCassReconciliationSnapshot({
    required this.reconciledCount,
    required this.resolvedCount,
    required this.outstandingCount,
    required this.records,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int reconciledCount;
  final int resolvedCount;
  final int outstandingCount;
  final List<TradeCassReconciliationRecord> records;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeCassReconciliationRecord {
  const TradeCassReconciliationRecord({
    required this.id,
    required this.displayDate,
    required this.clientLedger,
    required this.bankBalance,
    required this.difference,
    required this.status,
    this.notes,
  });

  final String id;
  final String displayDate;
  final double clientLedger;
  final double bankBalance;
  final double difference;
  final TradeCassReconciliationStatus status;
  final String? notes;
}

enum TradeCassReconciliationStatus { matched, discrepancyResolved, discrepancy }

final class TradeInvestorCompensationSnapshot {
  const TradeInvestorCompensationSnapshot({
    required this.coverageLimit,
    required this.summary,
    required this.coveredMessage,
    required this.automaticProtection,
    required this.overviewDescription,
    required this.overviewItems,
    required this.coverageItems,
    required this.warning,
    required this.eligibleCustomers,
    required this.ineligibleCustomers,
    required this.claimSteps,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String coverageLimit;
  final String summary;
  final String coveredMessage;
  final String automaticProtection;
  final String overviewDescription;
  final List<TradeInvestorCompensationInfo> overviewItems;
  final List<TradeInvestorCompensationCoverage> coverageItems;
  final String warning;
  final List<String> eligibleCustomers;
  final List<String> ineligibleCustomers;
  final List<TradeInvestorCompensationClaimStep> claimSteps;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeInvestorCompensationInfo {
  const TradeInvestorCompensationInfo({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeInvestorCompensationCoverage {
  const TradeInvestorCompensationCoverage({
    required this.label,
    required this.amount,
    required this.caption,
    required this.emphasized,
  });

  final String label;
  final String amount;
  final String caption;
  final bool emphasized;
}

final class TradeInvestorCompensationClaimStep {
  const TradeInvestorCompensationClaimStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class TradeExAnteCostsSnapshot {
  const TradeExAnteCostsSnapshot({
    required this.investmentAmount,
    required this.holdingPeriodYears,
    required this.costs,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investmentAmount;
  final int holdingPeriodYears;
  final List<TradeExAnteCostItem> costs;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  double get oneOffCosts => totalForCategory(TradeExAnteCostCategory.oneOff);
  double get recurringCosts =>
      totalForCategory(TradeExAnteCostCategory.recurring);
  double get incidentalCosts =>
      totalForCategory(TradeExAnteCostCategory.incidental);
  double get totalFirstYear => oneOffCosts + recurringCosts + incidentalCosts;
  double get totalPercentage => (totalFirstYear / investmentAmount) * 100;
  double get reductionInYield => totalPercentage / holdingPeriodYears;

  double totalForCategory(TradeExAnteCostCategory category) {
    return costs
        .where((cost) => cost.category == category)
        .fold<double>(0, (sum, cost) => sum + cost.amountEur);
  }
}

final class TradeExAnteCostItem {
  const TradeExAnteCostItem({
    required this.category,
    required this.type,
    required this.description,
    required this.amountEur,
    required this.percentOfInvestment,
  });

  final TradeExAnteCostCategory category;
  final String type;
  final String description;
  final double amountEur;
  final double percentOfInvestment;
}

enum TradeExAnteCostCategory { oneOff, recurring, incidental }

final class TradeRiyCalculatorSnapshot {
  const TradeRiyCalculatorSnapshot({
    required this.investmentAmount,
    required this.expectedReturnPct,
    required this.totalCostsPct,
    required this.holdingPeriodYears,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investmentAmount;
  final double expectedReturnPct;
  final double totalCostsPct;
  final int holdingPeriodYears;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRiyProjection {
  const TradeRiyProjection({
    required this.year,
    required this.withoutCosts,
    required this.withCosts,
  });

  final int year;
  final double withoutCosts;
  final double withCosts;
}

final class TradeExPostCostsReportSnapshot {
  const TradeExPostCostsReportSnapshot({
    required this.reports,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeExPostCostReport> reports;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  TradeExPostCostReport reportForYear(int year) {
    return reports.firstWhere(
      (report) => report.year == year,
      orElse: () => reports.first,
    );
  }
}

final class TradeExPostCostReport {
  const TradeExPostCostReport({
    required this.year,
    required this.oneOff,
    required this.recurring,
    required this.incidental,
    required this.estimatedOneOff,
    required this.estimatedRecurring,
    required this.estimatedIncidental,
  });

  final int year;
  final double oneOff;
  final double recurring;
  final double incidental;
  final double estimatedOneOff;
  final double estimatedRecurring;
  final double estimatedIncidental;

  double get totalActual => oneOff + recurring + incidental;
  double get totalEstimated =>
      estimatedOneOff + estimatedRecurring + estimatedIncidental;
  double get variance => totalActual - totalEstimated;
}

final class TradeExPostCostsReportExportResult {
  const TradeExPostCostsReportExportResult({
    required this.status,
    required this.year,
    required this.downloadUrl,
  });

  final String status;
  final int year;
  final String downloadUrl;
}

final class TradeKidGeneratorSnapshot {
  const TradeKidGeneratorSnapshot({
    required this.document,
    required this.sections,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeKidDocument document;
  final List<TradeKidSection> sections;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeKidDocument {
  const TradeKidDocument({
    required this.title,
    required this.lastUpdated,
    required this.version,
    required this.documentType,
    required this.pages,
    required this.maxPages,
  });

  final String title;
  final String lastUpdated;
  final String version;
  final String documentType;
  final int pages;
  final int maxPages;
}

final class TradeKidSection {
  const TradeKidSection({
    required this.title,
    required this.icon,
    required this.status,
  });

  final String title;
  final TradeKidSectionIcon icon;
  final String status;
}

enum TradeKidSectionIcon { info, target, warning, chart, costs, clock, help }

final class TradePerformanceScenariosSnapshot {
  const TradePerformanceScenariosSnapshot({
    required this.investment,
    required this.holdingPeriods,
    required this.defaultHoldingPeriod,
    required this.scenarios,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investment;
  final List<int> holdingPeriods;
  final int defaultHoldingPeriod;
  final List<TradePerformanceScenario> scenarios;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradePerformanceScenario {
  const TradePerformanceScenario({
    required this.type,
    required this.label,
    required this.annualReturnPct,
  });

  final TradePerformanceScenarioType type;
  final String label;
  final double annualReturnPct;

  double outcomeFor(double investment, int years) {
    return investment * math.pow(1 + annualReturnPct / 100, years).toDouble();
  }

  double profitFor(double investment, int years) {
    return outcomeFor(investment, years) - investment;
  }
}

enum TradePerformanceScenarioType { stress, unfavorable, moderate, favorable }

final class TradeRiskIndicatorSnapshot {
  const TradeRiskIndicatorSnapshot({
    required this.productName,
    required this.productSri,
    required this.holdingPeriodYears,
    required this.levels,
    required this.additionalRisks,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String productName;
  final int productSri;
  final int holdingPeriodYears;
  final List<TradeRiskIndicatorLevel> levels;
  final List<TradeRiskIndicatorAdditionalRisk> additionalRisks;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRiskIndicatorLevel {
  const TradeRiskIndicatorLevel({
    required this.level,
    required this.label,
    required this.tier,
    required this.description,
    required this.examples,
  });

  final int level;
  final String label;
  final TradeRiskIndicatorTier tier;
  final String description;
  final List<String> examples;
}

final class TradeRiskIndicatorAdditionalRisk {
  const TradeRiskIndicatorAdditionalRisk({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

enum TradeRiskIndicatorTier { low, medium, elevated, high }

final class TradeComplaintsHandlingSnapshot {
  const TradeComplaintsHandlingSnapshot({
    required this.activeCount,
    required this.resolvedCount,
    required this.averageResolutionDays,
    required this.categories,
    required this.timeline,
    required this.complaints,
    required this.processSteps,
    required this.ombudsman,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int activeCount;
  final int resolvedCount;
  final int averageResolutionDays;
  final List<TradeComplaintCategory> categories;
  final List<TradeComplaintTimelineStep> timeline;
  final List<TradeComplaint> complaints;
  final List<TradeComplaintProcessStep> processSteps;
  final TradeOmbudsmanInfo ombudsman;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintSubmissionSnapshot {
  const TradeComplaintSubmissionSnapshot({
    required this.processTitle,
    required this.processDescription,
    required this.categories,
    required this.subjectMinLength,
    required this.subjectMaxLength,
    required this.descriptionMinLength,
    required this.descriptionMaxLength,
    required this.termsIntro,
    required this.terms,
    required this.confirmationComplaintId,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String processTitle;
  final String processDescription;
  final List<String> categories;
  final int subjectMinLength;
  final int subjectMaxLength;
  final int descriptionMinLength;
  final int descriptionMaxLength;
  final String termsIntro;
  final List<String> terms;
  final String confirmationComplaintId;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingSnapshot {
  const TradeComplaintTrackingSnapshot({
    required this.complaintId,
    required this.statusLabel,
    required this.submittedLabel,
    required this.responseDueLabel,
    required this.daysRemaining,
    required this.deadlineNotice,
    required this.timeline,
    required this.actions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String complaintId;
  final String statusLabel;
  final String submittedLabel;
  final String responseDueLabel;
  final int daysRemaining;
  final String deadlineNotice;
  final List<TradeComplaintTrackingStep> timeline;
  final List<TradeComplaintTrackingAction> actions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingStep {
  const TradeComplaintTrackingStep({
    required this.title,
    required this.description,
    required this.dateLabel,
    required this.state,
  });

  final String title;
  final String description;
  final String dateLabel;
  final TradeComplaintTrackingStepState state;
}

final class TradeComplaintTrackingAction {
  const TradeComplaintTrackingAction({
    required this.id,
    required this.label,
    required this.icon,
    this.routePath,
  });

  final String id;
  final String label;
  final TradeComplaintTrackingActionIcon icon;
  final String? routePath;
}

enum TradeComplaintTrackingStepState { completed, current, pending }

enum TradeComplaintTrackingActionIcon { message, document, warning }

final class TradeOmbudsmanReferralSnapshot {
  const TradeOmbudsmanReferralSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.eligibility,
    required this.contacts,
    required this.processSteps,
    required this.ctaLabel,
    required this.externalUrl,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final List<TradeOmbudsmanEligibility> eligibility;
  final List<TradeOmbudsmanContact> contacts;
  final List<TradeOmbudsmanProcessStep> processSteps;
  final String ctaLabel;
  final String externalUrl;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeOmbudsmanEligibility {
  const TradeOmbudsmanEligibility({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanContact {
  const TradeOmbudsmanContact({
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
  });

  final String label;
  final String value;
  final TradeOmbudsmanContactIcon icon;
  final String? detail;
}

final class TradeOmbudsmanProcessStep {
  const TradeOmbudsmanProcessStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

enum TradeOmbudsmanContactIcon { phone, website, address }

final class TradeAuditTrailSnapshot {
  const TradeAuditTrailSnapshot({
    required this.noticeTitle,
    required this.noticeDescription,
    required this.stats,
    required this.searchPlaceholder,
    required this.tabs,
    required this.entries,
    required this.exportFormats,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String noticeTitle;
  final String noticeDescription;
  final List<TradeAuditStat> stats;
  final String searchPlaceholder;
  final List<TradeAuditTab> tabs;
  final List<TradeAuditEntry> entries;
  final List<String> exportFormats;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeAuditStat {
  const TradeAuditStat({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;
}

final class TradeAuditTab {
  const TradeAuditTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeAuditEntry {
  const TradeAuditEntry({
    required this.id,
    required this.timestampLabel,
    required this.category,
    required this.categoryLabel,
    required this.action,
    required this.details,
    this.user,
    this.ipAddress,
  });

  final String id;
  final String timestampLabel;
  final TradeAuditCategory category;
  final String categoryLabel;
  final String action;
  final String details;
  final String? user;
  final String? ipAddress;
}

enum TradeAuditCategory { trade, compliance, clientAction, system }

final class TradeRegulatoryInspectionSnapshot {
  const TradeRegulatoryInspectionSnapshot({
    required this.complianceScore,
    required this.scoreLabel,
    required this.readyTitle,
    required this.readyDescription,
    required this.stats,
    required this.frameworks,
    required this.documents,
    required this.portalTitle,
    required this.portalDescription,
    required this.portalCta,
    required this.reportCta,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int complianceScore;
  final String scoreLabel;
  final String readyTitle;
  final String readyDescription;
  final List<TradeRegulatoryInspectionStat> stats;
  final List<TradeRegulatoryFramework> frameworks;
  final List<TradeRegulatoryDocument> documents;
  final String portalTitle;
  final String portalDescription;
  final String portalCta;
  final String reportCta;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRegulatoryInspectionStat {
  const TradeRegulatoryInspectionStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final TradeRegulatoryInspectionStatIcon icon;
}

enum TradeRegulatoryInspectionStatIcon {
  documents,
  clients,
  auditLogs,
  retention,
}

final class TradeRegulatoryFramework {
  const TradeRegulatoryFramework({
    required this.name,
    required this.compliance,
    required this.requirements,
  });

  final String name;
  final int compliance;
  final List<String> requirements;
}

final class TradeRegulatoryDocument {
  const TradeRegulatoryDocument({
    required this.name,
    required this.countLabel,
    required this.status,
  });

  final String name;
  final String countLabel;
  final String status;
}

final class TradeBotTermsSnapshot {
  const TradeBotTermsSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.title,
    required this.lastUpdatedLabel,
    required this.sections,
    required this.acceptSectionLabel,
    required this.scrollWarning,
    required this.agreementTitle,
    required this.agreementDescription,
    required this.disabledCta,
    required this.enabledCta,
    required this.complianceTitle,
    required this.complianceDescription,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final String title;
  final String lastUpdatedLabel;
  final List<TradeBotTermsSection> sections;
  final String acceptSectionLabel;
  final String scrollWarning;
  final String agreementTitle;
  final String agreementDescription;
  final String disabledCta;
  final String enabledCta;
  final String complianceTitle;
  final String complianceDescription;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotTermsSection {
  const TradeBotTermsSection({
    required this.title,
    required this.paragraphs,
    this.warningTitle,
    this.warningBody,
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final String? warningTitle;
  final String? warningBody;
  final List<String> bullets;
}

final class TradeBotRiskDisclosureSnapshot {
  const TradeBotRiskDisclosureSnapshot({
    required this.highRiskTitle,
    required this.highRiskBody,
    required this.pastPerformanceTitle,
    required this.pastPerformanceBody,
    required this.riskSectionLabel,
    required this.categories,
    required this.additionalWarningsLabel,
    required this.additionalWarnings,
    required this.regulatoryNoticeLabel,
    required this.regulatoryTitle,
    required this.regulatoryBody,
    required this.regulatoryNotes,
    required this.acknowledgmentLabel,
    required this.acknowledgmentTitle,
    required this.acknowledgmentDescription,
    required this.disabledCta,
    required this.enabledCta,
    required this.helpTitle,
    required this.helpDescription,
    required this.helpCta,
    required this.nextPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String highRiskTitle;
  final String highRiskBody;
  final String pastPerformanceTitle;
  final String pastPerformanceBody;
  final String riskSectionLabel;
  final List<TradeBotRiskCategory> categories;
  final String additionalWarningsLabel;
  final List<TradeBotRiskWarning> additionalWarnings;
  final String regulatoryNoticeLabel;
  final String regulatoryTitle;
  final String regulatoryBody;
  final List<String> regulatoryNotes;
  final String acknowledgmentLabel;
  final String acknowledgmentTitle;
  final String acknowledgmentDescription;
  final String disabledCta;
  final String enabledCta;
  final String helpTitle;
  final String helpDescription;
  final String helpCta;
  final String nextPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotRiskCategory {
  const TradeBotRiskCategory({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.examples,
    required this.mitigation,
  });

  final String id;
  final TradeBotRiskKind kind;
  final String title;
  final String description;
  final List<String> examples;
  final String mitigation;
}

enum TradeBotRiskKind {
  market,
  leverage,
  liquidity,
  technical,
  timing,
  regulatory,
}

final class TradeBotRiskWarning {
  const TradeBotRiskWarning({required this.title, required this.text});

  final String title;
  final String text;
}

final class TradeBotSuitabilityAssessmentSnapshot {
  const TradeBotSuitabilityAssessmentSnapshot({
    required this.questions,
    required this.infoTitle,
    required this.infoDescription,
    required this.pass,
    required this.warning,
    required this.fail,
    required this.regulatoryTitle,
    required this.regulatoryDescription,
    required this.completionPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotSuitabilityQuestion> questions;
  final String infoTitle;
  final String infoDescription;
  final TradeBotSuitabilityOutcomeCopy pass;
  final TradeBotSuitabilityOutcomeCopy warning;
  final TradeBotSuitabilityOutcomeCopy fail;
  final String regulatoryTitle;
  final String regulatoryDescription;
  final String completionPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  int get maxScore => questions.length * 3;
}

final class TradeBotSuitabilityQuestion {
  const TradeBotSuitabilityQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
  });

  final String id;
  final TradeBotSuitabilityCategory category;
  final String question;
  final List<TradeBotSuitabilityOption> options;
}

final class TradeBotSuitabilityOption {
  const TradeBotSuitabilityOption({
    required this.id,
    required this.text,
    required this.score,
  });

  final String id;
  final String text;
  final int score;
}

enum TradeBotSuitabilityCategory { experience, knowledge, risk, financial }

enum TradeBotSuitabilityOutcome { pass, warning, fail }

final class TradeBotSuitabilityOutcomeCopy {
  const TradeBotSuitabilityOutcomeCopy({
    required this.outcome,
    required this.title,
    required this.message,
    required this.recommendations,
    required this.ctaLabel,
  });

  final TradeBotSuitabilityOutcome outcome;
  final String title;
  final String message;
  final List<String> recommendations;
  final String ctaLabel;
}

final class TradeBotRiskDashboardSnapshot {
  const TradeBotRiskDashboardSnapshot({
    required this.riskScore,
    required this.riskLabel,
    required this.riskMessage,
    required this.currentDrawdown,
    required this.maxDrawdownLimit,
    required this.dailyLoss,
    required this.dailyLossLimit,
    required this.totalExposure,
    required this.maxExposure,
    required this.var95,
    required this.runningBots,
    required this.drawdownPoints,
    required this.exposures,
    required this.varHistory,
    required this.safetyControls,
    required this.emergencyPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int riskScore;
  final String riskLabel;
  final String riskMessage;
  final double currentDrawdown;
  final double maxDrawdownLimit;
  final double dailyLoss;
  final double dailyLossLimit;
  final double totalExposure;
  final double maxExposure;
  final double var95;
  final int runningBots;
  final List<TradeBotDrawdownPoint> drawdownPoints;
  final List<TradeBotExposure> exposures;
  final List<TradeBotVarPoint> varHistory;
  final List<TradeBotSafetyControl> safetyControls;
  final String emergencyPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotDrawdownPoint {
  const TradeBotDrawdownPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class TradeBotExposure {
  const TradeBotExposure({
    required this.asset,
    required this.exposure,
    required this.percentage,
    required this.colorHex,
  });

  final String asset;
  final double exposure;
  final int percentage;
  final int colorHex;
}

final class TradeBotVarPoint {
  const TradeBotVarPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class TradeBotSafetyControl {
  const TradeBotSafetyControl({required this.label, required this.value});

  final String label;
  final String value;
}

final class TradeBotEmergencyStopSnapshot {
  const TradeBotEmergencyStopSnapshot({
    required this.warningTitle,
    required this.warningDescription,
    required this.bots,
    required this.reasons,
    required this.closePositionsTitle,
    required this.closePositionsDescription,
    required this.confirmationTitle,
    required this.confirmationDescription,
    required this.supportTitle,
    required this.supportDescription,
    required this.completionPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String warningTitle;
  final String warningDescription;
  final List<TradeBotEmergencyBot> bots;
  final List<TradeBotEmergencyReason> reasons;
  final String closePositionsTitle;
  final String closePositionsDescription;
  final String confirmationTitle;
  final String confirmationDescription;
  final String supportTitle;
  final String supportDescription;
  final String completionPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotEmergencyBot {
  const TradeBotEmergencyBot({
    required this.id,
    required this.name,
    required this.pair,
    required this.profit,
    required this.statusLabel,
  });

  final String id;
  final String name;
  final String pair;
  final double profit;
  final String statusLabel;
}

final class TradeBotEmergencyReason {
  const TradeBotEmergencyReason({
    required this.id,
    required this.label,
    required this.iconName,
  });

  final String id;
  final String label;
  final String iconName;
}

final class TradeBotEmergencyStopDraft {
  const TradeBotEmergencyStopDraft({
    required this.reasonId,
    required this.closePositions,
    required this.confirmed,
  });

  final String reasonId;
  final bool closePositions;
  final bool confirmed;
}

final class TradeBotEmergencyStopResult {
  const TradeBotEmergencyStopResult({
    required this.status,
    required this.stoppedBotCount,
    required this.redirectPath,
  });

  final String status;
  final int stoppedBotCount;
  final String redirectPath;
}

final class TradeBotSecuritySettingsSnapshot {
  const TradeBotSecuritySettingsSnapshot({
    required this.twoFaEnabled,
    required this.apiKeys,
    required this.ipWhitelist,
    required this.recentActivity,
    required this.securityTips,
    required this.generatedApiKeyPreview,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final bool twoFaEnabled;
  final List<TradeBotApiKey> apiKeys;
  final List<TradeBotIpWhitelistEntry> ipWhitelist;
  final List<TradeBotSecurityActivity> recentActivity;
  final List<String> securityTips;
  final String generatedApiKeyPreview;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotApiKey {
  const TradeBotApiKey({
    required this.id,
    required this.name,
    required this.permissions,
    required this.lastUsed,
    required this.created,
  });

  final String id;
  final String name;
  final String permissions;
  final String lastUsed;
  final String created;
}

final class TradeBotIpWhitelistEntry {
  const TradeBotIpWhitelistEntry({
    required this.id,
    required this.ip,
    required this.label,
    required this.added,
  });

  final String id;
  final String ip;
  final String label;
  final String added;
}

enum TradeBotSecurityActivityStatus { success, warning }

final class TradeBotSecurityActivity {
  const TradeBotSecurityActivity({
    required this.id,
    required this.action,
    required this.time,
    required this.status,
  });

  final String id;
  final String action;
  final String time;
  final TradeBotSecurityActivityStatus status;
}

final class TradeBotSecuritySettingsDraft {
  const TradeBotSecuritySettingsDraft({required this.twoFaEnabled});

  final bool twoFaEnabled;
}

final class TradeBotSecuritySettingsResult {
  const TradeBotSecuritySettingsResult({
    required this.status,
    required this.twoFaEnabled,
  });

  final String status;
  final bool twoFaEnabled;
}

final class TradeBotHistorySnapshot {
  const TradeBotHistorySnapshot({
    required this.trades,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotHistoryTrade> trades;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

enum TradeBotHistorySide { buy, sell }

final class TradeBotHistoryTrade {
  const TradeBotHistoryTrade({
    required this.id,
    required this.timestamp,
    required this.botName,
    required this.strategy,
    required this.pair,
    required this.side,
    required this.qty,
    required this.price,
    required this.fee,
    required this.pnl,
    required this.status,
  });

  final String id;
  final String timestamp;
  final String botName;
  final String strategy;
  final String pair;
  final TradeBotHistorySide side;
  final double qty;
  final double price;
  final double fee;
  final double pnl;
  final String status;
}

final class TradeBotHistoryExportRequest {
  const TradeBotHistoryExportRequest({required this.format});

  final String format;
}

final class TradeBotHistoryExportResult {
  const TradeBotHistoryExportResult({
    required this.status,
    required this.downloadUrl,
  });

  final String status;
  final String downloadUrl;
}

final class TradeBotPerformanceAnalyticsSnapshot {
  const TradeBotPerformanceAnalyticsSnapshot({
    required this.metrics,
    required this.pnlPoints,
    required this.winLossPoints,
    required this.strategyPerformance,
    required this.durationDistribution,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotPerformanceMetrics metrics;
  final List<TradeBotPnlPoint> pnlPoints;
  final List<TradeBotWinLossPoint> winLossPoints;
  final List<TradeBotStrategyPerformance> strategyPerformance;
  final List<TradeBotDurationDistribution> durationDistribution;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotPerformanceMetrics {
  const TradeBotPerformanceMetrics({
    required this.totalPnl,
    required this.winRate,
    required this.sharpeRatio,
    required this.avgWin,
    required this.avgLoss,
    required this.profitFactor,
    required this.totalTrades,
    required this.bestTrade,
    required this.worstTrade,
  });

  final double totalPnl;
  final double winRate;
  final double sharpeRatio;
  final double avgWin;
  final double avgLoss;
  final double profitFactor;
  final int totalTrades;
  final double bestTrade;
  final double worstTrade;
}

final class TradeBotPnlPoint {
  const TradeBotPnlPoint({required this.date, required this.pnl});

  final String date;
  final double pnl;
}

final class TradeBotWinLossPoint {
  const TradeBotWinLossPoint({
    required this.week,
    required this.wins,
    required this.losses,
  });

  final String week;
  final int wins;
  final int losses;
}

final class TradeBotStrategyPerformance {
  const TradeBotStrategyPerformance({
    required this.strategy,
    required this.pnl,
    required this.colorHex,
  });

  final String strategy;
  final double pnl;
  final int colorHex;
}

final class TradeBotDurationDistribution {
  const TradeBotDurationDistribution({
    required this.duration,
    required this.count,
  });

  final String duration;
  final int count;
}

final class TradeBotBacktestingSnapshot {
  const TradeBotBacktestingSnapshot({
    required this.strategies,
    required this.pairs,
    required this.dateRanges,
    required this.defaultStrategyId,
    required this.defaultPair,
    required this.defaultDateRangeId,
    required this.defaultCapital,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotBacktestStrategy> strategies;
  final List<String> pairs;
  final List<TradeBotBacktestDateRange> dateRanges;
  final String defaultStrategyId;
  final String defaultPair;
  final String defaultDateRangeId;
  final double defaultCapital;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotBacktestStrategy {
  const TradeBotBacktestStrategy({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  final String id;
  final String name;
  final int colorHex;
}

final class TradeBotBacktestDateRange {
  const TradeBotBacktestDateRange({
    required this.id,
    required this.label,
    required this.periodLabel,
  });

  final String id;
  final String label;
  final String periodLabel;
}

final class TradeBotBacktestRequest {
  const TradeBotBacktestRequest({
    required this.strategyId,
    required this.pair,
    required this.dateRangeId,
    required this.initialCapital,
  });

  final String strategyId;
  final String pair;
  final String dateRangeId;
  final double initialCapital;
}

final class TradeBotBacktestResult {
  const TradeBotBacktestResult({
    required this.status,
    required this.reportId,
    required this.progress,
  });

  final String status;
  final String reportId;
  final int progress;
}

final class TradeBotStrategyCompareSnapshot {
  const TradeBotStrategyCompareSnapshot({
    required this.strategies,
    required this.equityPoints,
    required this.recommendations,
    required this.defaultSelectedIds,
    required this.analysisPeriod,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotCompareStrategy> strategies;
  final List<TradeBotCompareEquityPoint> equityPoints;
  final List<TradeBotRecommendation> recommendations;
  final List<String> defaultSelectedIds;
  final String analysisPeriod;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotCompareStrategy {
  const TradeBotCompareStrategy({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.metrics,
  });

  final String id;
  final String name;
  final int colorHex;
  final TradeBotCompareMetrics metrics;
}

final class TradeBotCompareMetrics {
  const TradeBotCompareMetrics({
    required this.totalReturn,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.winRate,
    required this.profitFactor,
    required this.totalTrades,
    required this.avgTradeDuration,
    required this.volatility,
  });

  final double totalReturn;
  final double sharpeRatio;
  final double maxDrawdown;
  final double winRate;
  final double profitFactor;
  final int totalTrades;
  final String avgTradeDuration;
  final double volatility;
}

final class TradeBotCompareEquityPoint {
  const TradeBotCompareEquityPoint({
    required this.date,
    required this.dca,
    required this.grid,
    required this.momentum,
    required this.martingale,
  });

  final String date;
  final double dca;
  final double grid;
  final double momentum;
  final double martingale;

  double valueFor(String strategyId) {
    return switch (strategyId) {
      'dca' => dca,
      'grid' => grid,
      'momentum' => momentum,
      'martingale' => martingale,
      _ => 0,
    };
  }
}

final class TradeBotRecommendation {
  const TradeBotRecommendation({
    required this.title,
    required this.strategyId,
    required this.strategy,
    required this.reason,
  });

  final String title;
  final String strategyId;
  final String strategy;
  final String reason;
}

final class TradeBotOptimizationSnapshot {
  const TradeBotOptimizationSnapshot({
    required this.targets,
    required this.parameterRanges,
    required this.steps,
    required this.defaultTargetId,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotOptimizationTarget> targets;
  final List<TradeBotOptimizationRange> parameterRanges;
  final List<String> steps;
  final String defaultTargetId;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotOptimizationTarget {
  const TradeBotOptimizationTarget({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeBotOptimizationRange {
  const TradeBotOptimizationRange({
    required this.id,
    required this.label,
    required this.min,
    required this.max,
    required this.step,
    required this.defaultValue,
    this.unit = '',
  });

  final String id;
  final String label;
  final double min;
  final double max;
  final double step;
  final double defaultValue;
  final String unit;
}

final class TradeBotOptimizationRequest {
  const TradeBotOptimizationRequest({
    required this.targetId,
    required this.gridCount,
    required this.gridRangePct,
  });

  final String targetId;
  final double gridCount;
  final double gridRangePct;
}

final class TradeBotOptimizationResult {
  const TradeBotOptimizationResult({
    required this.status,
    required this.jobId,
    required this.estimatedMinutes,
  });

  final String status;
  final String jobId;
  final int estimatedMinutes;
}

final class TradeBotPortfolioDashboardSnapshot {
  const TradeBotPortfolioDashboardSnapshot({
    required this.summary,
    required this.allocations,
    required this.equityPoints,
    required this.correlations,
    required this.healthItems,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotPortfolioSummary summary;
  final List<TradeBotPortfolioAllocation> allocations;
  final List<TradeBotPortfolioEquityPoint> equityPoints;
  final List<TradeBotCorrelationRow> correlations;
  final List<String> healthItems;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotPortfolioSummary {
  const TradeBotPortfolioSummary({
    required this.totalEquity,
    required this.totalInvestment,
    required this.totalPnl,
    required this.pnlPercent,
    required this.portfolioSharpe,
    required this.diversificationScore,
    required this.activeBots,
    required this.totalTrades,
  });

  final double totalEquity;
  final double totalInvestment;
  final double totalPnl;
  final double pnlPercent;
  final double portfolioSharpe;
  final int diversificationScore;
  final int activeBots;
  final int totalTrades;
}

final class TradeBotPortfolioAllocation {
  const TradeBotPortfolioAllocation({
    required this.strategy,
    required this.value,
    required this.pnl,
    required this.colorHex,
  });

  final String strategy;
  final double value;
  final double pnl;
  final int colorHex;
}

final class TradeBotPortfolioEquityPoint {
  const TradeBotPortfolioEquityPoint({
    required this.date,
    required this.equity,
  });

  final String date;
  final double equity;
}

final class TradeBotCorrelationRow {
  const TradeBotCorrelationRow({required this.bot, required this.values});

  final String bot;
  final Map<String, double> values;
}

final class TradeBotDrawdownAnalyzerSnapshot {
  const TradeBotDrawdownAnalyzerSnapshot({
    required this.summary,
    required this.underwaterPoints,
    required this.durationBuckets,
    required this.events,
    required this.insights,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotDrawdownSummary summary;
  final List<TradeBotUnderwaterPoint> underwaterPoints;
  final List<TradeBotDrawdownDurationBucket> durationBuckets;
  final List<TradeBotDrawdownEvent> events;
  final List<TradeBotDrawdownInsight> insights;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotDrawdownSummary {
  const TradeBotDrawdownSummary({
    required this.maxDrawdownPct,
    required this.avgDrawdownPct,
    required this.drawdownDays,
    required this.totalDays,
    required this.frequency,
  });

  final double maxDrawdownPct;
  final double avgDrawdownPct;
  final int drawdownDays;
  final int totalDays;
  final int frequency;
}

final class TradeBotUnderwaterPoint {
  const TradeBotUnderwaterPoint({
    required this.date,
    required this.monthLabel,
    required this.underwaterPct,
  });

  final String date;
  final String monthLabel;
  final double underwaterPct;
}

final class TradeBotDrawdownDurationBucket {
  const TradeBotDrawdownDurationBucket({
    required this.range,
    required this.count,
  });

  final String range;
  final int count;
}

final class TradeBotDrawdownEvent {
  const TradeBotDrawdownEvent({
    required this.id,
    required this.startLabel,
    required this.depthPct,
    required this.duration,
    required this.recovery,
    required this.severe,
  });

  final int id;
  final String startLabel;
  final double depthPct;
  final String duration;
  final String recovery;
  final bool severe;
}

final class TradeBotDrawdownInsight {
  const TradeBotDrawdownInsight({
    required this.symbol,
    required this.colorHex,
    required this.text,
  });

  final String symbol;
  final int colorHex;
  final String text;
}

final class TradeBotEquityCurveSnapshot {
  const TradeBotEquityCurveSnapshot({
    required this.summary,
    required this.equityPoints,
    required this.monthlyReturns,
    required this.performanceStats,
    required this.analysisItems,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotEquityCurveSummary summary;
  final List<TradeBotEquityCurvePoint> equityPoints;
  final List<TradeBotMonthlyReturn> monthlyReturns;
  final List<TradeBotPerformanceStat> performanceStats;
  final List<String> analysisItems;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotEquityCurveSummary {
  const TradeBotEquityCurveSummary({
    required this.botReturnPct,
    required this.buyHoldReturnPct,
    required this.alphaPct,
  });

  final double botReturnPct;
  final double buyHoldReturnPct;
  final double alphaPct;
}

final class TradeBotEquityCurvePoint {
  const TradeBotEquityCurvePoint({
    required this.date,
    required this.monthLabel,
    required this.equity,
    required this.buyHold,
    this.rollingSharpe,
  });

  final String date;
  final String monthLabel;
  final double equity;
  final double buyHold;
  final double? rollingSharpe;
}

final class TradeBotMonthlyReturn {
  const TradeBotMonthlyReturn({
    required this.month,
    required this.botReturn,
    required this.marketReturn,
    required this.alpha,
  });

  final String month;
  final double botReturn;
  final double marketReturn;
  final double alpha;
}

final class TradeBotPerformanceStat {
  const TradeBotPerformanceStat({
    required this.id,
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String id;
  final String label;
  final String value;
  final int colorHex;
}

final class TradeBotGuideSnapshot {
  const TradeBotGuideSnapshot({
    required this.strategies,
    required this.bestPractices,
    required this.mistakes,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotGuideStrategy> strategies;
  final List<TradeBotGuidePractice> bestPractices;
  final List<TradeBotGuideMistake> mistakes;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotGuideStrategy {
  const TradeBotGuideStrategy({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorHex,
    required this.difficulty,
    required this.description,
    required this.howItWorks,
    required this.pros,
    required this.cons,
    required this.bestFor,
    required this.example,
  });

  final String id;
  final String name;
  final String iconKey;
  final int colorHex;
  final String difficulty;
  final String description;
  final List<String> howItWorks;
  final List<String> pros;
  final List<String> cons;
  final String bestFor;
  final TradeBotGuideExample example;
}

final class TradeBotGuideExample {
  const TradeBotGuideExample({
    required this.setup,
    required this.duration,
    required this.result,
    required this.profit,
  });

  final String setup;
  final String duration;
  final String result;
  final String profit;
}

final class TradeBotGuidePractice {
  const TradeBotGuidePractice({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
}

final class TradeBotGuideMistake {
  const TradeBotGuideMistake({
    required this.mistake,
    required this.why,
    required this.fix,
  });

  final String mistake;
  final String why;
  final String fix;
}

final class TradeBotFaqSnapshot {
  const TradeBotFaqSnapshot({
    required this.categories,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotFaqCategory> categories;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  int get totalFaqs =>
      categories.fold<int>(0, (sum, category) => sum + category.items.length);
}

final class TradeBotFaqCategory {
  const TradeBotFaqCategory({
    required this.id,
    required this.label,
    required this.items,
  });

  final String id;
  final String label;
  final List<TradeBotFaqItem> items;
}

final class TradeBotFaqItem {
  const TradeBotFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class TradeBotTaxReportingSnapshot {
  const TradeBotTaxReportingSnapshot({
    required this.taxYears,
    required this.defaultYear,
    required this.defaultCostBasisMethod,
    required this.summary,
    required this.reportTypes,
    required this.breakdown,
    required this.taxNotes,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<String> taxYears;
  final String defaultYear;
  final String defaultCostBasisMethod;
  final TradeBotTaxSummary summary;
  final List<TradeBotTaxReportType> reportTypes;
  final TradeBotTaxBreakdown breakdown;
  final List<String> taxNotes;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotTaxSummary {
  const TradeBotTaxSummary({
    required this.totalTrades,
    required this.realizedGains,
    required this.realizedLosses,
    required this.netGainLoss,
    required this.shortTermGains,
    required this.longTermGains,
    required this.totalFees,
  });

  final int totalTrades;
  final double realizedGains;
  final double realizedLosses;
  final double netGainLoss;
  final double shortTermGains;
  final double longTermGains;
  final double totalFees;
}

final class TradeBotTaxReportType {
  const TradeBotTaxReportType({
    required this.id,
    required this.name,
    required this.description,
    required this.format,
    required this.recommended,
    required this.selectedByDefault,
  });

  final String id;
  final String name;
  final String description;
  final String format;
  final bool recommended;
  final bool selectedByDefault;
}

final class TradeBotTaxBreakdown {
  const TradeBotTaxBreakdown({
    required this.shortTermLabel,
    required this.shortTermDescription,
    required this.longTermLabel,
    required this.longTermDescription,
  });

  final String shortTermLabel;
  final String shortTermDescription;
  final String longTermLabel;
  final String longTermDescription;
}

final class TradeBotTaxReportExportRequest {
  const TradeBotTaxReportExportRequest({
    required this.year,
    required this.reportTypeIds,
    required this.costBasisMethod,
  });

  final String year;
  final List<String> reportTypeIds;
  final String costBasisMethod;
}

final class TradeBotTaxReportExportResult {
  const TradeBotTaxReportExportResult({
    required this.status,
    required this.year,
    required this.reportCount,
    required this.exportId,
  });

  final String status;
  final String year;
  final int reportCount;
  final String exportId;
}

final class TradeBotApiDocumentationSnapshot {
  const TradeBotApiDocumentationSnapshot({
    required this.tabs,
    required this.defaultView,
    required this.defaultLanguage,
    required this.endpoints,
    required this.websocketUrl,
    required this.websocketEvents,
    required this.codeExamples,
    required this.rateLimits,
    required this.authenticationHeader,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotApiTab> tabs;
  final String defaultView;
  final String defaultLanguage;
  final List<TradeBotApiEndpoint> endpoints;
  final String websocketUrl;
  final List<TradeBotWebSocketEvent> websocketEvents;
  final List<TradeBotCodeExample> codeExamples;
  final List<TradeBotRateLimit> rateLimits;
  final String authenticationHeader;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotApiTab {
  const TradeBotApiTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeBotApiEndpoint {
  const TradeBotApiEndpoint({
    required this.method,
    required this.path,
    required this.description,
    required this.params,
    required this.response,
  });

  final String method;
  final String path;
  final String description;
  final List<TradeBotApiParameter> params;
  final String response;
}

final class TradeBotApiParameter {
  const TradeBotApiParameter({
    required this.name,
    required this.type,
    required this.required,
    required this.description,
  });

  final String name;
  final String type;
  final bool required;
  final String description;
}

final class TradeBotWebSocketEvent {
  const TradeBotWebSocketEvent({
    required this.event,
    required this.description,
    required this.payload,
  });

  final String event;
  final String description;
  final String payload;
}

final class TradeBotCodeExample {
  const TradeBotCodeExample({
    required this.language,
    required this.label,
    required this.title,
    required this.source,
  });

  final String language;
  final String label;
  final String title;
  final String source;
}

final class TradeBotRateLimit {
  const TradeBotRateLimit({required this.label, required this.value});

  final String label;
  final String value;
}

final class TradeComplaintCategory {
  const TradeComplaintCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final TradeComplaintCategoryIcon icon;
}

final class TradeComplaintTimelineStep {
  const TradeComplaintTimelineStep({
    required this.step,
    required this.label,
    required this.time,
  });

  final int step;
  final String label;
  final String time;
}

final class TradeComplaint {
  const TradeComplaint({
    required this.id,
    required this.category,
    required this.status,
    required this.submittedDate,
    required this.deadline,
    required this.subject,
  });

  final String id;
  final String category;
  final TradeComplaintStatus status;
  final String submittedDate;
  final String deadline;
  final String subject;
}

final class TradeComplaintProcessStep {
  const TradeComplaintProcessStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanInfo {
  const TradeOmbudsmanInfo({
    required this.description,
    required this.phone,
    required this.website,
  });

  final String description;
  final String phone;
  final String website;
}

enum TradeComplaintCategoryIcon {
  trade,
  account,
  payment,
  service,
  fees,
  other,
}

enum TradeComplaintStatus { submitted, underReview, resolved, escalated }

final class TradeCopyTrader {
  const TradeCopyTrader({
    required this.id,
    required this.name,
    required this.avatar,
    required this.winRate,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.aum,
    required this.copiers,
    required this.maxCopiers,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.totalTrades,
    required this.avgHoldingTime,
    required this.weeklyPnl,
    required this.tags,
    required this.isFollowing,
    required this.riskLevel,
  });

  final String id;
  final String name;
  final String avatar;
  final double winRate;
  final double totalPnl;
  final double totalPnlPct;
  final double aum;
  final int copiers;
  final int maxCopiers;
  final double sharpeRatio;
  final double maxDrawdown;
  final int totalTrades;
  final String avgHoldingTime;
  final List<double> weeklyPnl;
  final List<String> tags;
  final bool isFollowing;
  final TradeCopyRiskLevel riskLevel;

  TradeCopyTrader copyWith({bool? isFollowing}) {
    return TradeCopyTrader(
      id: id,
      name: name,
      avatar: avatar,
      winRate: winRate,
      totalPnl: totalPnl,
      totalPnlPct: totalPnlPct,
      aum: aum,
      copiers: copiers,
      maxCopiers: maxCopiers,
      sharpeRatio: sharpeRatio,
      maxDrawdown: maxDrawdown,
      totalTrades: totalTrades,
      avgHoldingTime: avgHoldingTime,
      weeklyPnl: weeklyPnl,
      tags: tags,
      isFollowing: isFollowing ?? this.isFollowing,
      riskLevel: riskLevel,
    );
  }
}

final class TradeCopyActionRequest {
  const TradeCopyActionRequest({
    required this.providerId,
    required this.action,
  });

  final String providerId;
  final String action;
}

final class TradeCopyActionResult {
  const TradeCopyActionResult({
    required this.providerId,
    required this.action,
    required this.status,
  });

  final String providerId;
  final String action;
  final String status;
}

final class TradeDashboardPosition {
  const TradeDashboardPosition({
    required this.id,
    required this.symbol,
    required this.type,
    required this.side,
    required this.size,
    required this.entryPrice,
    required this.currentPrice,
    required this.pnl,
    required this.pnlPct,
    this.leverage,
    this.liquidPrice,
    this.takeProfit,
    this.stopLoss,
    this.margin,
  });

  final String id;
  final String symbol;
  final TradePositionType type;
  final TradePositionSide side;
  final double size;
  final double entryPrice;
  final double currentPrice;
  final double pnl;
  final double pnlPct;
  final int? leverage;
  final double? liquidPrice;
  final double? takeProfit;
  final double? stopLoss;
  final double? margin;

  double get notional => size * currentPrice;
}

final class TradeHistoryOrder {
  const TradeHistoryOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.status,
    required this.price,
    required this.amount,
    required this.filled,
    required this.fee,
    required this.createdAt,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final TradeOrderType type;
  final TradeOrderStatus status;
  final double price;
  final double amount;
  final double filled;
  final double fee;
  final String createdAt;
}

final class TradePosition {
  const TradePosition({
    required this.symbol,
    required this.side,
    required this.notional,
    required this.pnl,
  });

  final String symbol;
  final TradeOrderSide side;
  final double notional;
  final double pnl;
}

final class TradeBalances {
  const TradeBalances({
    required this.usdtAvailable,
    required this.baseAvailable,
  });

  final double usdtAvailable;
  final double baseAvailable;
}

final class TradeOrderDraft {
  const TradeOrderDraft({
    required this.pairId,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
  });

  final String pairId;
  final TradeOrderSide side;
  final TradeOrderType type;
  final double price;
  final double amount;
}

final class TradeOrderPreview {
  const TradeOrderPreview({
    required this.total,
    required this.fee,
    required this.feeRate,
    required this.estimatedReceive,
  });

  final double total;
  final double fee;
  final double feeRate;
  final double estimatedReceive;
}

final class TradeOrderReceipt {
  const TradeOrderReceipt({
    required this.orderId,
    required this.preview,
    required this.status,
  });

  final String orderId;
  final TradeOrderPreview preview;
  final String status;
}

final class TradeOrderActionResult {
  const TradeOrderActionResult({
    required this.orderId,
    required this.action,
    required this.status,
  });

  final String orderId;
  final String action;
  final String status;
}
