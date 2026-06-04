part of 'trade_entities.dart';

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

enum TradeBotRisk { low, medium, high }

enum TradeBotStatus { running, paused, stopped }

final class TradeBotsSnapshot {
  const TradeBotsSnapshot({
    required this.trade,
    required this.strategies,
    required this.activeBots,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.highRiskContractId,
  });

  final TradeScreenSnapshot trade;
  final List<TradeBotStrategy> strategies;
  final List<TradeBot> activeBots;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String? highRiskContractId;

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
