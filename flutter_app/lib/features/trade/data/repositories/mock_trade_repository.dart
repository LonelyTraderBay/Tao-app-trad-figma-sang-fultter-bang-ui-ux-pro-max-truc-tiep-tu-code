import 'package:vit_trade_flutter/features/trade_terminal/data/repositories/mock_trade_terminal_repository.dart';

import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

/// Delegates the whole [SpotTradeRepository] + [TradeFuturesMarginRepository]
/// surface (core spot trading, advanced tools, conversions & utilities,
/// futures/leverage/margin) to the independent [MockTradeTerminalRepository]
/// owned by `trade_terminal`. `trade`'s own [TradeRepository] contract is
/// scoped narrower than `trade_core`'s 6-way union, but Dart still requires
/// every method of the two parent interfaces to be implemented — this class
/// forwards every call, no domain logic of its own, mirroring the same
/// delegation pattern `trade_core`'s own `MockTradeRepository` already uses
/// for its terminal slice.
final class MockTradeRepository implements TradeRepository {
  const MockTradeRepository();

  static const MockTradeTerminalRepository _terminal =
      MockTradeTerminalRepository();

  @override
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'}) =>
      _terminal.getTrade(pairId: pairId);

  @override
  TradeOrdersHistorySnapshot getOrdersHistory() => _terminal.getOrdersHistory();

  @override
  TradeOrderReceiptSnapshot getOrderReceipt() => _terminal.getOrderReceipt();

  @override
  TradeSettingsSnapshot getTradeSettings() => _terminal.getTradeSettings();

  @override
  TradePositionsSnapshot getTradePositions() => _terminal.getTradePositions();

  @override
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo() =>
      _terminal.getAdvancedTradingDemo();

  @override
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics() =>
      _terminal.getAdvancedAnalytics();

  @override
  TradeSettings patchTradeSettings(TradeSettings settings) =>
      _terminal.patchTradeSettings(settings);

  @override
  TradeOrderPreview previewOrder(TradeOrderDraft draft) =>
      _terminal.previewOrder(draft);

  @override
  TradeOrderReceipt submitOrder(TradeOrderDraft draft) =>
      _terminal.submitOrder(draft);

  @override
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  }) => _terminal.submitOrderAction(orderId: orderId, action: action);

  @override
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'}) =>
      _terminal.getAdvancedChart(pairId: pairId);

  @override
  TradeRiskManagementSnapshot getRiskManagement() =>
      _terminal.getRiskManagement();

  @override
  TradeExecutionQualitySnapshot getExecutionQuality() =>
      _terminal.getExecutionQuality();

  @override
  TradeAdvancedToolsSnapshot getAdvancedTools() => _terminal.getAdvancedTools();

  @override
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft) =>
      _terminal.submitOcoOrder(draft);

  @override
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  ) => _terminal.calculatePositionSize(request);

  @override
  TradeSlippageSettings updateSlippageSettings(
    TradeSlippageSettings settings,
  ) => _terminal.updateSlippageSettings(settings);

  @override
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request) =>
      _terminal.amendOrder(request);

  @override
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  ) => _terminal.submitAdvancedToolAction(request);

  @override
  TradeExportSnapshot getTradeExport() => _terminal.getTradeExport();

  @override
  TradeConvertSnapshot getConvert() => _terminal.getConvert();

  @override
  TradeExportResult createTradeExport(TradeExportRequest request) =>
      _terminal.createTradeExport(request);

  @override
  TradeConvertQuote previewConvert(TradeConvertRequest request) =>
      _terminal.previewConvert(request);

  @override
  TradeConvertReceipt submitConvert(TradeConvertRequest request) =>
      _terminal.submitConvert(request);

  @override
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'}) =>
      _terminal.getFutures(pairId: pairId);

  @override
  TradeFuturesLeverageSnapshot getFuturesLeverage({
    String pairId = 'btcusdt',
  }) => _terminal.getFuturesLeverage(pairId: pairId);

  @override
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  }) => _terminal.getMarginTrading(
    pairId: pairId,
    pairRouteVariant: pairRouteVariant,
  );

  @override
  TradeMarginTradingHubSnapshot getMarginTradingHub() =>
      _terminal.getMarginTradingHub();

  @override
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft) =>
      _terminal.previewFuturesOrder(draft);

  @override
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft) =>
      _terminal.submitFuturesOrder(draft);

  @override
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) => _terminal.previewFuturesLeverage(request);

  @override
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) => _terminal.submitFuturesLeverage(request);
}
