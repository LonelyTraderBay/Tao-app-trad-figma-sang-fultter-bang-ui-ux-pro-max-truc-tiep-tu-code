import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

/// Data contract for the spot trade terminal, order lifecycle, advanced
/// tools, and conversion/export screens. Financial submit paths are async
/// per ADR-001.
abstract interface class SpotTradeRepository {
  // Core spot
  //
  // GD4 Cụm F3 (phần bổ sung): 19 method còn lại của SpotTradeRepository/
  // TradeFuturesMarginRepository async đọc thuần (ADR-001) — bao gồm cả
  // preview/patch/action/create (previewOrder/submitOrderAction/
  // patchTradeSettings/createTradeExport/previewConvert/submitConvert/
  // previewFuturesOrder/previewFuturesLeverage) vì batch này chỉ định rõ
  // trong danh sách 19 method, khác với khuôn "write path giữ sync" của
  // trade_bots Cụm F3 (xem `TradingBotsRepository` doc comment) — feature
  // `trade` migrate cả nhóm preview/mutation cùng lúc thay vì để dành.
  Future<TradeScreenSnapshot> getTrade({String pairId = 'btcusdt'});
  Future<TradeOrdersHistorySnapshot> getOrdersHistory();
  Future<TradeOrderReceiptSnapshot> getOrderReceipt();
  Future<TradeSettingsSnapshot> getTradeSettings();
  Future<TradePositionsSnapshot> getTradePositions();

  /// GD4 Cụm F3: async đọc thuần (ADR-001) — chỉ dùng bởi `trade_terminal`'s
  /// own advanced trading demo page, không chia sẻ với feature `trade`.
  Future<TradeAdvancedTradingDemoSnapshot> getAdvancedTradingDemo();

  /// GD4 Cụm F3: async đọc thuần (ADR-001) — chỉ dùng bởi `trade_terminal`'s
  /// own advanced analytics page, không chia sẻ với feature `trade`.
  Future<TradeAdvancedAnalyticsSnapshot> getAdvancedAnalytics();
  Future<TradeSettings> patchTradeSettings(TradeSettings settings);
  Future<TradeOrderPreview> previewOrder(TradeOrderDraft draft);

  /// Đường ghi tài chính là async theo ADR-001 — backend thật sẽ là network
  /// call; mock mô phỏng độ trễ/lỗi qua `loadDelay`/`simulateError`.
  Future<TradeOrderReceipt> submitOrder(TradeOrderDraft draft);
  Future<TradeOrderActionResult> submitOrderAction({
    required String orderId,
    required String action,
  });

  // Advanced tools
  //
  // GD4 Cụm F3: mọi method dưới đây async đọc thuần (ADR-001) — surface này
  // chỉ dùng bởi `trade_terminal`'s own advanced-tools demo pages
  // (risk_management/execution_quality/advanced_tools_demo), không chia sẻ
  // với feature `trade` (xem grep-audit trong PR — không call site nào
  // trong lib/features/trade/** chạm nhóm này, chỉ `trade`'s
  // MockTradeRepository delegate wrapper forward cho tương thích interface).
  Future<TradeAdvancedChartSnapshot> getAdvancedChart({
    String pairId = 'btcusdt',
  });
  Future<TradeRiskManagementSnapshot> getRiskManagement();
  Future<TradeExecutionQualitySnapshot> getExecutionQuality();
  Future<TradeAdvancedToolsSnapshot> getAdvancedTools();
  Future<TradeOcoOrderResult> submitOcoOrder(TradeOcoOrderDraft draft);
  Future<TradePositionSizeResult> calculatePositionSize(
    TradePositionSizeRequest request,
  );
  Future<TradeSlippageSettings> updateSlippageSettings(
    TradeSlippageSettings settings,
  );
  Future<TradeOrderAmendmentResult> amendOrder(
    TradeOrderAmendmentRequest request,
  );
  Future<TradeAdvancedToolActionResult> submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  );

  // Conversions & utilities
  Future<TradeExportSnapshot> getTradeExport();
  Future<TradeConvertSnapshot> getConvert();
  Future<TradeExportResult> createTradeExport(TradeExportRequest request);
  Future<TradeConvertQuote> previewConvert(TradeConvertRequest request);
  Future<TradeConvertReceipt> submitConvert(TradeConvertRequest request);

  /// GD4 Cụm F7 (REALTIME): nến realtime cho Biểu đồ giao dịch nâng cao —
  /// additive, không đổi method Future nào ở trên. Mock phát tick giả lập
  /// DETERMINISTIC (không Random/DateTime.now) qua `Stream.periodic`, cập
  /// nhật nến CUỐI CÙNG của [getAdvancedChart] mỗi tick (mô phỏng nến đang
  /// hình thành) — [timeframe] chỉ đổi biên độ dao động mô phỏng, không đổi
  /// tập nến trả về (khớp `getAdvancedChart` vốn cũng không nhận
  /// timeframe: bộ lọc khung thời gian ở UI chỉ là cosmetic phía client).
  /// UI dùng stream này làm lớp "cập-nhật-đè" trên snapshot Future đã có
  /// (xem `app/providers/trade_terminal_controller_providers.dart`).
  Stream<TradeAdvancedChartSnapshot> watchCandles(
    String pairId, {
    String timeframe = '1h',
  });
}
