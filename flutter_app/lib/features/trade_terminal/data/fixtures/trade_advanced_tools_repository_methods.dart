part of '../repositories/mock_trade_terminal_repository.dart';

mixin _MockTradeTerminalRepositoryAdvancedToolsMethods
    on _MockTradeTerminalRepositoryBase {
  @override
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'}) {
    final trade = getTrade(pairId: pairId);
    return TradeAdvancedChartSnapshot(
      trade: trade,
      pair: trade.pair,
      candles: _advancedChartCandles,
      indicators: _advancedChartIndicators,
      timeframes: const ['1m', '5m', '15m', '1h', '4h', '1D', '1W'],
      chartTypes: const ['candle', 'line', 'area'],
      ohlcv: const TradeOhlcv(
        open: 64312.26,
        high: 64475.28,
        low: 64185.74,
        close: 64268.03,
        volumeLabel: '8.0K',
      ),
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
  TradeRiskManagementSnapshot getRiskManagement() {
    return TradeRiskManagementSnapshot(
      trade: getTrade(),
      features: _riskFeatures,
      positions: _riskPositions,
      statusItems: _riskStatusItems,
      accountBalance: 50000,
      currentPrice: 69000,
      availableBalance: 50000,
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
  TradeExecutionQualitySnapshot getExecutionQuality() {
    return TradeExecutionQualitySnapshot(
      trade: getTrade(),
      features: _executionFeatures,
      report: _executionReport,
      openOrder: _executionOpenOrder,
      slippageSettings: _defaultSlippageSettings,
      statusItems: _executionStatusItems,
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
  TradeAdvancedToolsSnapshot getAdvancedTools() {
    return TradeAdvancedToolsSnapshot(
      trade: getTrade(),
      features: _advancedToolFeatures,
      ladderOrders: _ladderOrders,
      bulkOrders: _bulkOrders,
      shortcuts: _shortcuts,
      statusItems: _advancedToolStatusItems,
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
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft) {
    return TradeOcoOrderResult(
      orderId: 'OCO-DEMO-060',
      symbol: draft.symbol,
      status: 'submitted',
    );
  }

  @override
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  ) {
    final riskAmount = request.accountBalance * request.riskPct / 100;
    final perUnitRisk = (request.entryPrice - request.stopPrice).abs();
    final suggestedAmount = perUnitRisk <= 0 ? 0.0 : riskAmount / perUnitRisk;
    return TradePositionSizeResult(
      riskAmount: riskAmount,
      perUnitRisk: perUnitRisk,
      suggestedAmount: suggestedAmount,
      notional: suggestedAmount * request.entryPrice,
    );
  }

  @override
  TradeSlippageSettings updateSlippageSettings(TradeSlippageSettings settings) {
    return settings;
  }

  @override
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request) {
    return TradeOrderAmendmentResult(
      orderId: request.orderId,
      status: 'modified',
      queuePositionPreserved: true,
    );
  }

  @override
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  ) {
    return TradeAdvancedToolActionResult(
      toolId: request.toolId,
      action: request.action,
      status: 'accepted',
      affectedCount: request.orderIds.isEmpty ? 1 : request.orderIds.length,
    );
  }
}
