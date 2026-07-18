part of 'trade_terminal_entities.dart';

/// Directional side of a futures position: long or short.
enum TradeFuturesSide { long, short }

/// Order execution style for futures orders: market or limit.
enum TradeFuturesOrderType { market, limit }

/// Read-model for the Futures trading screen (positions, leverage
/// options, mark/index price, funding rate).
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
    this.highRiskContractId,
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
  final String? highRiskContractId;
}

/// A single open futures position (leverage, entry/mark/liquidation price,
/// PnL, ROE).
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

/// In-progress futures order form contract with value equality: a
/// `TradeFuturesOrderDraft` rebuilt from the same on-screen values resolves
/// to the same Provider.family cache entry instead of a new one each time.
/// See PERF-HN1, docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
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

  // Value equality so a `TradeFuturesOrderDraft` rebuilt from the same
  // on-screen values resolves to the same Provider.family cache entry
  // instead of a new one each time. See PERF-HN1,
  // docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradeFuturesOrderDraft &&
          other.pairId == pairId &&
          other.side == side &&
          other.type == type &&
          other.margin == margin &&
          other.leverage == leverage &&
          other.limitPrice == limitPrice &&
          other.takeProfit == takeProfit &&
          other.stopLoss == stopLoss);

  @override
  int get hashCode => Object.hash(
    pairId,
    side,
    type,
    margin,
    leverage,
    limitPrice,
    takeProfit,
    stopLoss,
  );
}

/// Computed cost/liquidation preview for a futures order draft before
/// submission — financial write path, see ADR-001.
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

/// Receipt returned after submitting a futures order — financial write
/// path, see ADR-001.
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

/// Read-model for the Futures Leverage adjustment screen.
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

/// Request to preview/adjust the leverage for a given pair.
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

/// Computed risk preview (liquidation distance, fee, projected PnL) for a
/// candidate leverage value before it is applied.
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

/// Receipt returned after submitting a leverage adjustment — financial
/// write path, see ADR-001.
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

/// Read-model for the Margin Trading screen (account, positions, order
/// draft, and regulatory disclosures).
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
    this.highRiskContractId,
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
  final String? highRiskContractId;
}

/// Margin account equity/margin/PnL summary.
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

/// A single open margin position (leverage, entry/mark price, PnL,
/// liquidation price, margin ratio).
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

/// A selectable tab (id + label) used across the margin trading screen's
/// mode/content tab strips.
final class TradeMarginTab {
  const TradeMarginTab({required this.id, required this.label});

  final String id;
  final String label;
}

/// Regulatory client-category disclosure (e.g. retail/professional) with
/// its trading limits.
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

/// Mark/last/index reference prices used for margin position valuation.
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

/// Draft form state for a margin order (selected type, price, amount,
/// fee rate, estimated liquidation price).
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

/// Margin risk warning block (title plus bullet items) shown before order
/// submission.
final class TradeMarginRiskWarning {
  const TradeMarginRiskWarning({required this.title, required this.items});

  final String title;
  final List<String> items;
}

/// Negative-balance-protection safety disclosure shown on the margin
/// trading screen.
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

/// Best-execution regulatory disclosure shown on the margin trading
/// screen.
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

/// Read-model for the Margin Trading hub landing screen (entry stats,
/// menu items, features, compliance blurb).
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

/// A single headline stat shown on the margin trading hub.
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

/// A navigable menu entry on the margin trading hub.
final class TradeMarginHubMenuItem {
  const TradeMarginHubMenuItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.colorHex,
    required this.targetPath,
  });

  final String id;
  final String title;
  final String subtitle;

  /// Genuinely user-facing status label (e.g. `LIVE`). `null` when the menu
  /// item has no status to surface — never a dev/roadmap phase number.
  final String? badge;
  final int colorHex;
  final String targetPath;
}

/// A single feature callout card on the margin trading hub.
final class TradeMarginHubFeature {
  const TradeMarginHubFeature({
    required this.id,
    required this.title,
    required this.colorHex,
    required this.items,
  });

  final String id;
  final String title;
  final int colorHex;
  final List<String> items;
}

/// Regulatory compliance summary shown on the margin trading hub.
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
