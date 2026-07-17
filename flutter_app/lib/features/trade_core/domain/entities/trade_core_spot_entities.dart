part of 'trade_core_entities.dart';

/// Direction of a spot/futures order: buy (long) or sell (short).
enum TradeOrderSide { buy, sell }

/// Execution style for an order: market, limit, or stop.
enum TradeOrderType { market, limit, stop }

/// Read-model for the main Trade terminal screen: current pair, order book,
/// trade tape, open orders/positions, and demo balances.
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
/// A tradable market pair (symbol, base/quote asset, price) — kernel entity
/// shared across spot, futures, and margin screens.
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

/// Aggregated bid/ask levels for the order book widget.
final class TradeOrderBook {
  const TradeOrderBook({required this.bids, required this.asks});

  final List<TradeBookLevel> bids;
  final List<TradeBookLevel> asks;
}

/// A single price/amount/total row of an order book side.
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

/// One recent trade print (price, amount, time, buy/sell) shown on the tape.
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

/// An order still resting on the book, as shown in the open-orders list.
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

/// Lifecycle status of a historical order: open, partial, filled, or
/// cancelled.
enum TradeOrderStatus { open, partial, filled, cancelled }

/// Read-model for the Orders & History screen: open orders plus historical
/// orders.
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

/// Post-submit status of an order receipt: submitted, pending, or partially
/// filled.
enum TradeReceiptStatus { submitted, pending, partiallyFilled }

/// Read-model for the order-receipt confirmation screen shown after an
/// order is placed.
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

/// Full detail of a submitted order receipt (fill price, fee, TP/SL,
/// slippage) shown to the user on the confirmation screen.
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

/// Read-model for the Trade Settings screen: current settings plus
/// supported UI states.
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

/// User-configurable trade terminal preferences (default order
/// type/slippage, confirmations, chart timeframe).
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

/// Market type of a position: spot, futures, or margin.
enum TradePositionType { spot, futures, margin }

/// Directional side of a position: long or short.
enum TradePositionSide { long, short }

/// Read-model for the Positions dashboard screen.
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

/// A single open position row shown on the Positions dashboard, including
/// PnL and liquidation price.
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

/// A completed or cancelled order row shown in order history.
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

/// Minimal position summary (symbol, side, notional, PnL) — kernel entity
/// used outside the full dashboard context (e.g. copy-trading, bots).
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

/// Available quote/base asset balances used for order sizing and preview.
final class TradeBalances {
  const TradeBalances({
    required this.usdtAvailable,
    required this.baseAvailable,
  });

  final double usdtAvailable;
  final double baseAvailable;
}

/// In-progress order form contract with value equality: a `TradeOrderDraft`
/// rebuilt from the same on-screen values (e.g. every keystroke re-reading
/// the same amount) resolves to the same Provider.family cache entry
/// instead of a new one each time. See PERF-HN1,
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
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

  // Value equality so a `TradeOrderDraft` rebuilt from the same on-screen
  // values (e.g. every keystroke re-reading the same amount) resolves to
  // the same Provider.family cache entry instead of a new one each time.
  // See PERF-HN1, docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradeOrderDraft &&
          other.pairId == pairId &&
          other.side == side &&
          other.type == type &&
          other.price == price &&
          other.amount == amount);

  @override
  int get hashCode => Object.hash(pairId, side, type, price, amount);
}

/// Computed cost preview (total, fee, estimated receive) for an order draft
/// before submission — financial write path, see ADR-001.
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

/// Minimal receipt returned after submitting an order (id, preview,
/// status) — financial write path, see ADR-001.
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

/// Result of a post-order action (e.g. cancel, edit) performed on an
/// existing order.
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

/// Read-model for the Advanced Trading demo screen (position, order types,
/// PnL/performance metrics).
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

/// Sample position used by the Advanced Trading demo screen.
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

/// A labelled demo action (e.g. position action, order type) shown as a
/// selectable option on the Advanced Trading demo screen.
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

/// Visual tone for a demo metric value: neutral, positive, negative,
/// warning, or accent.
enum TradeAdvancedMetricTone { neutral, positive, negative, warning, accent }

/// A labelled metric value with a visual tone, used on demo summary rows.
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

/// Read-model for the Advanced Analytics screen (stats, AI signals, risk,
/// journal, position sizing).
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

/// A single labelled analytics stat with a display color.
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

/// An AI-generated trade signal (direction, confidence, entry/target/stop,
/// reasoning) shown on the Advanced Analytics screen.
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

/// Aggregated risk metrics (VaR, Sharpe ratio, max drawdown, risk score)
/// for the Advanced Analytics screen.
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

/// Aggregated trade-journal metrics (win rate, total trades, PnL, average
/// win/loss).
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

/// Inputs and computed output of the position-sizing calculator.
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
