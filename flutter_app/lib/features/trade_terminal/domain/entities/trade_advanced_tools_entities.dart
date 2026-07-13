part of 'trade_terminal_entities.dart';

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
