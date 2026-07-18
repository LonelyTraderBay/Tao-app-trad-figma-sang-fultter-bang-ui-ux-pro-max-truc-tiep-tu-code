// Advanced terminal demo controller providers only.
// Spot / Futures / Margin / Convert live in trade_controller_providers.dart.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_terminal/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/controllers/trade_controller_models.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

/// Shared read-model used by advanced terminal demos (chart / quality / etc.).
final tradeReadModelControllerProvider = Provider<SpotTradeRepository>((ref) {
  return ref.watch(spotTradeRepositoryProvider);
});

// GD4 Cụm F3: getRiskManagement/getAdvancedTools/getAdvancedChart/
// getAdvancedTradingDemo/getAdvancedAnalytics/getExecutionQuality are now
// Future<T> (ADR-001 read-path async contract) — each direct-in-build()
// repo call from a page becomes its own intermediate FutureProvider
// (playbook mục 3, bước A+B gộp vì contract đã đổi cùng lúc).

final tradeRiskManagementSnapshotProvider =
    FutureProvider<TradeRiskManagementSnapshot>(
      (ref) => ref.watch(tradeReadModelControllerProvider).getRiskManagement(),
    );

/// STATE-S25 pattern (mục 4): `Provider<AsyncValue<XController>>` thay vì
/// `FutureProvider<XController>` — `.whenData()` map đồng bộ, consumer vẫn
/// gọi `.when()` giống các snapshot provider khác.
final tradeRiskManagementControllerProvider =
    Provider<AsyncValue<TradeRiskManagementController>>((ref) {
      final repository = ref.watch(tradeReadModelControllerProvider);
      return ref
          .watch(tradeRiskManagementSnapshotProvider)
          .whenData(
            (snapshot) => TradeRiskManagementController(
              repository: repository,
              state: TradeRiskManagementViewState(snapshot: snapshot),
            ),
          );
    });

final tradeAdvancedToolsSnapshotProvider =
    FutureProvider<TradeAdvancedToolsSnapshot>(
      (ref) => ref.watch(tradeReadModelControllerProvider).getAdvancedTools(),
    );

final tradeAdvancedToolsControllerProvider =
    Provider<AsyncValue<TradeAdvancedToolsController>>((ref) {
      final repository = ref.watch(tradeReadModelControllerProvider);
      return ref
          .watch(tradeAdvancedToolsSnapshotProvider)
          .whenData(
            (snapshot) => TradeAdvancedToolsController(
              repository: repository,
              state: TradeAdvancedToolsViewState(snapshot: snapshot),
            ),
          );
    });

/// family theo `pairId` (khuôn `advancedChartStateControllerProvider`);
/// autoDispose vì mỗi phiên xem biểu đồ nâng cao là tạm thời — provider mới
/// dựng riêng cho GD4, không có semantics cũ nào cần giữ.
final tradeAdvancedChartSnapshotProvider = FutureProvider.autoDispose
    .family<TradeAdvancedChartSnapshot, String>(
      (ref, pairId) => ref
          .watch(tradeReadModelControllerProvider)
          .getAdvancedChart(pairId: pairId),
    );

/// GD4 Cụm F7 (REALTIME): lớp "cập-nhật-đè" trên
/// [tradeAdvancedChartSnapshotProvider] — xem dartdoc
/// [SpotTradeRepository.watchCandles]. Family theo `pairId` (khớp
/// snapshot Future ở trên; timeframe của mock chỉ đổi biên độ mô phỏng,
/// không đổi tập nến — không cần vào key). `.autoDispose` vì
/// `watchCandles()` là `Stream.periodic` — timer sống mãi nếu không giải
/// phóng khi rời trang Biểu đồ giao dịch nâng cao.
final tradeCandleStreamProvider = StreamProvider.autoDispose
    .family<TradeAdvancedChartSnapshot, String>(
      (ref, pairId) =>
          ref.watch(tradeReadModelControllerProvider).watchCandles(pairId),
    );

final tradeAdvancedTradingDemoSnapshotProvider =
    FutureProvider<TradeAdvancedTradingDemoSnapshot>(
      (ref) =>
          ref.watch(tradeReadModelControllerProvider).getAdvancedTradingDemo(),
    );

final tradeAdvancedAnalyticsSnapshotProvider =
    FutureProvider<TradeAdvancedAnalyticsSnapshot>(
      (ref) =>
          ref.watch(tradeReadModelControllerProvider).getAdvancedAnalytics(),
    );

final tradeExecutionQualitySnapshotProvider =
    FutureProvider<TradeExecutionQualitySnapshot>(
      (ref) =>
          ref.watch(tradeReadModelControllerProvider).getExecutionQuality(),
    );

/// STATE-S23: view-state bất biến của Biểu đồ nâng cao — danh sách chỉ báo
/// sống ở Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class AdvancedChartViewState {
  const AdvancedChartViewState({required this.indicators});

  factory AdvancedChartViewState.fromIndicators(
    List<TradeChartIndicator> indicators,
  ) {
    return AdvancedChartViewState(indicators: List.unmodifiable(indicators));
  }

  final List<TradeChartIndicator> indicators;

  AdvancedChartViewState copyWith({List<TradeChartIndicator>? indicators}) {
    return AdvancedChartViewState(
      indicators: indicators == null
          ? this.indicators
          : List.unmodifiable(indicators),
    );
  }
}

/// STATE-S23 (khuôn MarketWatchlistStateController), family theo `pairId`
/// (khuôn tradeLeverageControllerProvider) — mỗi cặp có bộ chỉ báo bật/tắt
/// riêng; autoDispose vì mỗi phiên xem biểu đồ nâng cao là tạm thời.
///
/// GD4 Cụm F3: `getAdvancedChart` giờ là `Future<T>` — Notifier này có
/// mutation cục bộ (`toggleIndicator`) nên GIỮ Notifier sync (mục 6 Biến
/// thể A), seed từ `AsyncValue.value` + fallback rỗng (page tự gate qua
/// `tradeAdvancedChartSnapshotProvider.when()` trước khi build() này chạy
/// trong luồng UI thật — xem `advanced_chart_page.dart`).
final class AdvancedChartStateController
    extends Notifier<AdvancedChartViewState> {
  AdvancedChartStateController(this.pairId);

  final String pairId;

  @override
  AdvancedChartViewState build() {
    final snapshot = ref
        .watch(tradeAdvancedChartSnapshotProvider(pairId))
        .value;
    return AdvancedChartViewState.fromIndicators(
      snapshot?.indicators ?? const [],
    );
  }

  void toggleIndicator(String id) {
    state = state.copyWith(
      indicators: [
        for (final indicator in state.indicators)
          indicator.id == id
              ? indicator.copyWith(enabled: !indicator.enabled)
              : indicator,
      ],
    );
  }
}

final advancedChartStateControllerProvider = NotifierProvider.autoDispose
    .family<AdvancedChartStateController, AdvancedChartViewState, String>(
      AdvancedChartStateController.new,
    );
