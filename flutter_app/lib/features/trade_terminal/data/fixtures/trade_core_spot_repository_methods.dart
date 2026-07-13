part of '../repositories/mock_trade_terminal_repository.dart';

mixin _MockTradeTerminalRepositoryCoreSpotMethods
    on _MockTradeTerminalRepositoryBase {
  @override
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'}) {
    final pair = _pairs.firstWhere(
      (pair) => pair.id == pairId,
      orElse: () => _pairs.first,
    );
    return TradeScreenSnapshot(
      pair: pair,
      pairs: _pairs,
      orderBook: _orderBook,
      trades: _trades,
      orders: _orders,
      positions: _positions,
      copyProviders: const ['AlphaQuant', 'Delta Scalper'],
      botStrategies: const ['Grid BTC', 'DCA ETH', 'Momentum SOL'],
      balances: const TradeBalances(usdtAvailable: 10200, baseAvailable: 0.84),
      lastUpdatedLabel: 'realtime-refresh',
      highRiskContractId: HighRiskFlowContractIds.tradeSpotOrder,
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
  TradeOrdersHistorySnapshot getOrdersHistory() {
    return TradeOrdersHistorySnapshot(
      trade: getTrade(),
      openOrders: _historyOpenOrders,
      historyOrders: _historyOrders,
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
  TradeOrderReceiptSnapshot getOrderReceipt() {
    return TradeOrderReceiptSnapshot(
      trade: getTrade(),
      receipt: const TradeOrderReceiptDetails(
        orderId: 'ORD-98EH1ZT2',
        symbol: 'BTC/USDT',
        baseAsset: 'BTC',
        side: TradeOrderSide.buy,
        orderType: 'Giới hạn',
        price: 67543.21,
        amount: .015,
        total: 1013.15,
        fee: .96,
        feeRate: '0.095% (VIP 1, -5%)',
        timestamp: '23:29:21 18/5/2026',
        status: TradeReceiptStatus.submitted,
        tpPrice: 72000,
        slPrice: 65000,
        estimatedFill: '< 2 phút',
      ),
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.order,
        referenceId: 'ORD-98EH1ZT2',
        sourceRoute: '/trade/order-receipt',
        issueLabel: 'Trading order receipt support',
      ),
      lastUpdatedLabel: 'success',
      highRiskContractId: HighRiskFlowContractIds.tradeSpotOrder,
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
  TradeSettingsSnapshot getTradeSettings() {
    return TradeSettingsSnapshot(
      trade: getTrade(),
      settings: _defaultTradeSettings,
      lastUpdatedLabel: 'success',
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
  TradePositionsSnapshot getTradePositions() {
    return TradePositionsSnapshot(
      trade: getTrade(),
      positions: _dashboardPositions,
      lastUpdatedLabel: 'realtime-refresh',
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
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo() {
    return TradeAdvancedTradingDemoSnapshot(
      position: _advancedDemoPosition,
      positionActions: _advancedDemoPositionActions,
      orderTypes: _advancedDemoOrderTypes,
      timeInForce: _advancedDemoTimeInForce,
      orderSummary: _advancedDemoOrderSummary,
      pnlSummary: _advancedDemoPnlSummary,
      performanceMetrics: _advancedDemoPerformanceMetrics,
      defaultTab: 'position',
      defaultPositionMode: 'one-way',
      lastUpdatedLabel: 'realtime-refresh',
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
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics() {
    return const TradeAdvancedAnalyticsSnapshot(
      stats: _advancedAnalyticsStats,
      signals: _advancedAnalyticsSignals,
      features: _advancedAnalyticsFeatures,
      risk: _advancedAnalyticsRisk,
      journal: _advancedAnalyticsJournal,
      sizing: _advancedAnalyticsSizing,
      defaultTab: 'ai',
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
  TradeSettings patchTradeSettings(TradeSettings settings) {
    return settings;
  }

  @override
  TradeOrderPreview previewOrder(TradeOrderDraft draft) {
    final total = draft.price * draft.amount;
    const feeRate = .00085;
    final fee = total * feeRate;
    return TradeOrderPreview(
      total: total,
      fee: fee,
      feeRate: feeRate,
      estimatedReceive: total - fee,
    );
  }

  @override
  TradeOrderReceipt submitOrder(TradeOrderDraft draft) {
    return TradeOrderReceipt(
      orderId: 'ORD-DEMO-048',
      preview: previewOrder(draft),
      status: 'submitted',
    );
  }

  @override
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  }) {
    return TradeOrderActionResult(
      orderId: orderId,
      action: action,
      status: 'success',
    );
  }
}
