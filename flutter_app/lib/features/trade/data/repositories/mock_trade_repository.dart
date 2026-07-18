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
  const MockTradeRepository({
    this.loadDelay = const Duration(milliseconds: 300),
    this.simulateError = false,
  });

  /// Xem [MockTradeTerminalRepository.loadDelay] — forward cho delegate.
  final Duration loadDelay;

  /// Xem [MockTradeTerminalRepository.simulateError] — forward cho delegate.
  final bool simulateError;

  // Getter (không phải field) để giữ được `const MockTradeRepository()` ở
  // mọi call site: initializer của const constructor không được dựng
  // sub-object từ tham số. Delegate stateless nên dựng mới mỗi lần gọi là
  // không đáng kể.
  MockTradeTerminalRepository get _terminal => MockTradeTerminalRepository(
    loadDelay: loadDelay,
    simulateError: simulateError,
  );

  @override
  Future<TradeScreenSnapshot> getTrade({String pairId = 'btcusdt'}) =>
      _terminal.getTrade(pairId: pairId);

  @override
  Future<TradeOrdersHistorySnapshot> getOrdersHistory() =>
      _terminal.getOrdersHistory();

  @override
  Future<TradeOrderReceiptSnapshot> getOrderReceipt() =>
      _terminal.getOrderReceipt();

  @override
  Future<TradeSettingsSnapshot> getTradeSettings() =>
      _terminal.getTradeSettings();

  @override
  Future<TradePositionsSnapshot> getTradePositions() =>
      _terminal.getTradePositions();

  // GD4 Cụm F3: trade_terminal made getAdvancedTradingDemo/getAdvancedAnalytics
  // (and 9 more advanced-tools methods below) Future<T> (ADR-001 read-path
  // async contract) — this delegate just forwards the Future untouched, no
  // domain logic changes. Only trade_terminal's own advanced-tools pages
  // consume these methods; `trade`'s own pages/controllers never call them
  // directly, so this is a pure signature-forwarding fix.
  @override
  Future<TradeAdvancedTradingDemoSnapshot> getAdvancedTradingDemo() =>
      _terminal.getAdvancedTradingDemo();

  @override
  Future<TradeAdvancedAnalyticsSnapshot> getAdvancedAnalytics() =>
      _terminal.getAdvancedAnalytics();

  @override
  Future<TradeSettings> patchTradeSettings(TradeSettings settings) =>
      _terminal.patchTradeSettings(settings);

  @override
  Future<TradeOrderPreview> previewOrder(TradeOrderDraft draft) =>
      _terminal.previewOrder(draft);

  @override
  Future<TradeOrderReceipt> submitOrder(TradeOrderDraft draft) =>
      _terminal.submitOrder(draft);

  @override
  Future<TradeOrderActionResult> submitOrderAction({
    required String orderId,
    required String action,
  }) => _terminal.submitOrderAction(orderId: orderId, action: action);

  @override
  Future<TradeAdvancedChartSnapshot> getAdvancedChart({
    String pairId = 'btcusdt',
  }) => _terminal.getAdvancedChart(pairId: pairId);

  @override
  Future<TradeRiskManagementSnapshot> getRiskManagement() =>
      _terminal.getRiskManagement();

  @override
  Future<TradeExecutionQualitySnapshot> getExecutionQuality() =>
      _terminal.getExecutionQuality();

  @override
  Future<TradeAdvancedToolsSnapshot> getAdvancedTools() =>
      _terminal.getAdvancedTools();

  @override
  Future<TradeOcoOrderResult> submitOcoOrder(TradeOcoOrderDraft draft) =>
      _terminal.submitOcoOrder(draft);

  @override
  Future<TradePositionSizeResult> calculatePositionSize(
    TradePositionSizeRequest request,
  ) => _terminal.calculatePositionSize(request);

  @override
  Future<TradeSlippageSettings> updateSlippageSettings(
    TradeSlippageSettings settings,
  ) => _terminal.updateSlippageSettings(settings);

  @override
  Future<TradeOrderAmendmentResult> amendOrder(
    TradeOrderAmendmentRequest request,
  ) => _terminal.amendOrder(request);

  @override
  Future<TradeAdvancedToolActionResult> submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  ) => _terminal.submitAdvancedToolAction(request);

  @override
  Future<TradeExportSnapshot> getTradeExport() => _terminal.getTradeExport();

  @override
  Future<TradeConvertSnapshot> getConvert() => _terminal.getConvert();

  @override
  Future<TradeExportResult> createTradeExport(TradeExportRequest request) =>
      _terminal.createTradeExport(request);

  @override
  Future<TradeConvertQuote> previewConvert(TradeConvertRequest request) =>
      _terminal.previewConvert(request);

  @override
  Future<TradeConvertReceipt> submitConvert(TradeConvertRequest request) =>
      _terminal.submitConvert(request);

  @override
  Future<TradeFuturesSnapshot> getFutures({String pairId = 'btcusdt'}) =>
      _terminal.getFutures(pairId: pairId);

  @override
  Future<TradeFuturesLeverageSnapshot> getFuturesLeverage({
    String pairId = 'btcusdt',
  }) => _terminal.getFuturesLeverage(pairId: pairId);

  @override
  Future<TradeMarginTradingSnapshot> getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  }) => _terminal.getMarginTrading(
    pairId: pairId,
    pairRouteVariant: pairRouteVariant,
  );

  @override
  Future<TradeMarginTradingHubSnapshot> getMarginTradingHub() =>
      _terminal.getMarginTradingHub();

  @override
  Future<TradeFuturesPreview> previewFuturesOrder(
    TradeFuturesOrderDraft draft,
  ) => _terminal.previewFuturesOrder(draft);

  @override
  Future<TradeFuturesReceipt> submitFuturesOrder(
    TradeFuturesOrderDraft draft,
  ) => _terminal.submitFuturesOrder(draft);

  @override
  Future<TradeFuturesLeveragePreview> previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) => _terminal.previewFuturesLeverage(request);

  @override
  Future<TradeFuturesLeverageReceipt> submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) => _terminal.submitFuturesLeverage(request);
}
