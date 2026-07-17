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

final tradeRiskManagementControllerProvider =
    Provider<TradeRiskManagementController>((ref) {
      final repository = ref.watch(spotTradeRepositoryProvider);
      return TradeRiskManagementController(
        repository: repository,
        state: TradeRiskManagementViewState(
          snapshot: repository.getRiskManagement(),
        ),
      );
    });

final tradeAdvancedToolsControllerProvider =
    Provider<TradeAdvancedToolsController>((ref) {
      final repository = ref.watch(spotTradeRepositoryProvider);
      return TradeAdvancedToolsController(
        repository: repository,
        state: TradeAdvancedToolsViewState(
          snapshot: repository.getAdvancedTools(),
        ),
      );
    });

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
final class AdvancedChartStateController
    extends Notifier<AdvancedChartViewState> {
  AdvancedChartStateController(this.pairId);

  final String pairId;

  @override
  AdvancedChartViewState build() {
    final repository = ref.watch(tradeReadModelControllerProvider);
    return AdvancedChartViewState.fromIndicators(
      repository.getAdvancedChart(pairId: pairId).indicators,
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
