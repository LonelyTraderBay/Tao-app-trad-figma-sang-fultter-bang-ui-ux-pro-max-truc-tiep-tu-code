part of 'trade_entities.dart';

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

// Also referenced by trade_futures_leverage (futures/margin pair selection).
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
