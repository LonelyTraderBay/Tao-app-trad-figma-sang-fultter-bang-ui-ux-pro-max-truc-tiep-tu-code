part of 'trade_entities.dart';

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
