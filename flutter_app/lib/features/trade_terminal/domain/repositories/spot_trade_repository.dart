import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

abstract interface class SpotTradeRepository {
  // Core spot
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'});
  TradeOrdersHistorySnapshot getOrdersHistory();
  TradeOrderReceiptSnapshot getOrderReceipt();
  TradeSettingsSnapshot getTradeSettings();
  TradePositionsSnapshot getTradePositions();
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo();
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics();
  TradeSettings patchTradeSettings(TradeSettings settings);
  TradeOrderPreview previewOrder(TradeOrderDraft draft);
  TradeOrderReceipt submitOrder(TradeOrderDraft draft);
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  });

  // Advanced tools
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'});
  TradeRiskManagementSnapshot getRiskManagement();
  TradeExecutionQualitySnapshot getExecutionQuality();
  TradeAdvancedToolsSnapshot getAdvancedTools();
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft);
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  );
  TradeSlippageSettings updateSlippageSettings(TradeSlippageSettings settings);
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request);
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  );

  // Conversions & utilities
  TradeExportSnapshot getTradeExport();
  TradeConvertSnapshot getConvert();
  TradeExportResult createTradeExport(TradeExportRequest request);
  TradeConvertQuote previewConvert(TradeConvertRequest request);
  TradeConvertReceipt submitConvert(TradeConvertRequest request);
}
