part of '../repositories/mock_trade_repository.dart';

mixin _MockTradeRepositoryFuturesLeverageMethods on _MockTradeRepositoryBase {
  @override
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'}) {
    final trade = getTrade(pairId: pairId);
    return TradeFuturesSnapshot(
      trade: trade,
      pair: trade.pair,
      positions: _futuresPositions,
      leverages: const [1, 2, 3, 5, 10, 20, 50, 75, 100],
      markPrice: trade.pair.price,
      indexPrice: trade.pair.price * .9998,
      fundingRate: .01,
      accountBalance: 5000,
      usedMargin: 544,
      lastUpdatedLabel: 'realtime-refresh',
      highRiskContractId: HighRiskFlowContractIds.tradeMarginFutures,
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeFuturesLeverageSnapshot getFuturesLeverage({String pairId = 'btcusdt'}) {
    return TradeFuturesLeverageSnapshot(
      futures: getFutures(pairId: pairId),
      currentLeverage: 10,
      presets: const [1, 2, 3, 5, 10, 20, 25, 50, 75, 100],
      sliderStops: const [1, 10, 25, 50, 75, 100],
      exampleMargin: 100,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  }) {
    final trade = getTrade(pairId: pairId);
    final pair = trade.pairs.firstWhere(
      (item) => item.id == pairId,
      orElse: () => trade.pair,
    );
    return TradeMarginTradingSnapshot(
      trade: trade,
      pair: pair,
      account: _marginAccount,
      positions: _marginPositions,
      modeTabs: _marginModeTabs,
      contentTabs: _marginContentTabs,
      defaultMode: 'cross',
      defaultTab: 'trade',
      defaultSide: 'long',
      defaultLeverage: 5,
      clientCategory: _marginClientCategory,
      referencePrices: pairRouteVariant
          ? _marginPairRouteReferencePrices
          : _marginReferencePrices,
      orderDraft: _marginOrderDraft,
      riskWarning: _marginRiskWarning,
      negativeBalance: _marginNegativeBalance,
      bestExecution: _marginBestExecution,
      lastUpdatedLabel: 'realtime-refresh',
      highRiskContractId: HighRiskFlowContractIds.tradeMarginFutures,
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeMarginTradingHubSnapshot getMarginTradingHub() {
    return const TradeMarginTradingHubSnapshot(
      stats: _marginHubStats,
      menuItems: _marginHubMenuItems,
      features: _marginHubFeatures,
      compliance: _marginHubCompliance,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft) {
    final futures = getFutures(pairId: draft.pairId);
    final price = draft.limitPrice ?? futures.markPrice;
    final positionSize = draft.margin * draft.leverage;
    final liquidationDistance = 90 / draft.leverage;
    final liquidationPrice = draft.side == TradeFuturesSide.long
        ? price * (1 - liquidationDistance / 100)
        : price * (1 + liquidationDistance / 100);
    return TradeFuturesPreview(
      positionSize: positionSize,
      contractQty: price <= 0 ? 0 : positionSize / price,
      liquidationPrice: liquidationPrice,
      openFee: positionSize * .0002,
      canOpen: draft.margin > 0 && draft.margin <= 5000,
    );
  }

  @override
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft) {
    return TradeFuturesReceipt(
      orderId: 'FUT-DEMO-057',
      preview: previewFuturesOrder(draft),
      status: 'submitted',
    );
  }

  @override
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    final leverage = request.leverage.clamp(1, 100).toInt();
    final risk = _futuresLeverageRisk(leverage);
    final positionSize = request.exampleMargin * leverage;
    final onePercent = positionSize * .01;
    return TradeFuturesLeveragePreview(
      leverage: leverage,
      riskLabel: risk.label,
      riskLevel: risk.level,
      riskColorHex: risk.colorHex,
      positionSize: positionSize,
      liquidationDistancePct: 90 / leverage,
      openFee: positionSize * .0002,
      profitAtOnePct: onePercent,
      lossAtOnePct: onePercent,
      warningText: _futuresLeverageWarning(leverage),
      showRiskTips: leverage > 20,
    );
  }

  @override
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    return TradeFuturesLeverageReceipt(
      adjustmentId: 'LEV-DEMO-058',
      pairId: request.pairId,
      preview: previewFuturesLeverage(request),
      status: 'submitted',
    );
  }
}
