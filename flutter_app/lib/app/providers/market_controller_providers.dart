import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/comparison_tool_common.dart'
    show comparisonToolMaxCompare;

export 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';

final marketControllerProvider = Provider<MarketController>((ref) {
  return MarketController(ref.watch(marketRepositoryProvider));
});

/// STATE-S23: view-state bất biến của Danh sách theo dõi — entries sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class MarketWatchlistViewState {
  const MarketWatchlistViewState({
    required this.snapshot,
    required this.entries,
  });

  factory MarketWatchlistViewState.fromSnapshot(
    MarketWatchlistSnapshot snapshot,
  ) {
    return MarketWatchlistViewState(
      snapshot: snapshot,
      entries: List.unmodifiable(snapshot.entries),
    );
  }

  final MarketWatchlistSnapshot snapshot;
  final List<MarketWatchlistEntry> entries;

  MarketWatchlistViewState copyWith({List<MarketWatchlistEntry>? entries}) {
    return MarketWatchlistViewState(
      snapshot: snapshot,
      entries: entries == null ? this.entries : List.unmodifiable(entries),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — state danh mục
/// giữ nguyên khi điều hướng đi/về trong phiên.
final class MarketWatchlistStateController
    extends Notifier<MarketWatchlistViewState> {
  @override
  MarketWatchlistViewState build() {
    return MarketWatchlistViewState.fromSnapshot(
      ref.watch(marketControllerProvider).getMarketWatchlist(),
    );
  }

  void removeEntry(String entryId) {
    state = state.copyWith(
      entries: state.entries
          .where((entry) => entry.id != entryId)
          .toList(growable: false),
    );
  }

  void setNote(String entryId, String? note) {
    state = state.copyWith(
      entries: [
        for (final entry in state.entries)
          if (entry.id == entryId)
            MarketWatchlistEntry(id: entry.id, pairId: entry.pairId, note: note)
          else
            entry,
      ],
    );
  }
}

final marketWatchlistStateControllerProvider =
    NotifierProvider<MarketWatchlistStateController, MarketWatchlistViewState>(
      MarketWatchlistStateController.new,
    );

/// STATE-S23: view-state bất biến của Công cụ so sánh — selectedIds sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class MarketComparisonViewState {
  const MarketComparisonViewState({
    required this.snapshot,
    required this.selectedIds,
  });

  factory MarketComparisonViewState.fromSnapshot(
    MarketComparisonSnapshot snapshot,
  ) {
    return MarketComparisonViewState(
      snapshot: snapshot,
      selectedIds: List.unmodifiable(snapshot.selectedPairIds),
    );
  }

  final MarketComparisonSnapshot snapshot;
  final List<String> selectedIds;

  MarketComparisonViewState copyWith({List<String>? selectedIds}) {
    return MarketComparisonViewState(
      snapshot: snapshot,
      selectedIds: selectedIds == null
          ? this.selectedIds
          : List.unmodifiable(selectedIds),
    );
  }
}

/// STATE-S23 (khuôn MarketWatchlistStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — danh sách token
/// đang so sánh giữ nguyên khi điều hướng đi/về trong phiên.
final class MarketComparisonStateController
    extends Notifier<MarketComparisonViewState> {
  @override
  MarketComparisonViewState build() {
    return MarketComparisonViewState.fromSnapshot(
      ref.watch(marketControllerProvider).getMarketComparison(),
    );
  }

  /// Trả về `true` nếu token được thêm; `false` khi đã đạt giới hạn so sánh
  /// hoặc token đã có trong danh sách (giữ nguyên guard của trang cũ).
  bool addToken(String id) {
    if (state.selectedIds.length >= comparisonToolMaxCompare ||
        state.selectedIds.contains(id)) {
      return false;
    }
    state = state.copyWith(selectedIds: [...state.selectedIds, id]);
    return true;
  }

  void removeToken(String id) {
    if (state.selectedIds.length <= 2) return;
    state = state.copyWith(
      selectedIds: state.selectedIds
          .where((value) => value != id)
          .toList(growable: false),
    );
  }
}

final marketComparisonStateControllerProvider =
    NotifierProvider<
      MarketComparisonStateController,
      MarketComparisonViewState
    >(MarketComparisonStateController.new);

/// STATE-S23: view-state bất biến của Cảnh báo giá — alerts sống ở Notifier
/// (một nguồn sự thật), trang chỉ watch + gọi method.
final class MarketPriceAlertsViewState {
  const MarketPriceAlertsViewState({
    required this.snapshot,
    required this.alerts,
  });

  factory MarketPriceAlertsViewState.fromSnapshot(
    MarketAlertsSnapshot snapshot,
  ) {
    return MarketPriceAlertsViewState(
      snapshot: snapshot,
      alerts: List.unmodifiable(snapshot.priceAlerts),
    );
  }

  final MarketAlertsSnapshot snapshot;
  final List<MarketPriceAlert> alerts;

  MarketPriceAlertsViewState copyWith({List<MarketPriceAlert>? alerts}) {
    return MarketPriceAlertsViewState(
      snapshot: snapshot,
      alerts: alerts == null ? this.alerts : List.unmodifiable(alerts),
    );
  }
}

/// STATE-S23 (khuôn MarketWatchlistStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — danh sách cảnh
/// báo giá giữ nguyên khi điều hướng đi/về trong phiên.
final class MarketPriceAlertsStateController
    extends Notifier<MarketPriceAlertsViewState> {
  @override
  MarketPriceAlertsViewState build() {
    return MarketPriceAlertsViewState.fromSnapshot(
      ref.watch(marketControllerProvider).getPriceAlerts(),
    );
  }

  void toggleAlert(String id) {
    state = state.copyWith(
      alerts: [
        for (final alert in state.alerts)
          if (alert.id == id)
            MarketPriceAlert(
              id: alert.id,
              pairId: alert.pairId,
              symbol: alert.symbol,
              condition: alert.condition,
              targetPrice: alert.targetPrice,
              currentPrice: alert.currentPrice,
              isActive: !alert.isActive,
              createdAt: alert.createdAt,
              triggeredAt: alert.triggeredAt,
            )
          else
            alert,
      ],
    );
  }

  void deleteAlert(String id) {
    state = state.copyWith(
      alerts: state.alerts
          .where((alert) => alert.id != id)
          .toList(growable: false),
    );
  }
}

final marketPriceAlertsStateControllerProvider =
    NotifierProvider<
      MarketPriceAlertsStateController,
      MarketPriceAlertsViewState
    >(MarketPriceAlertsStateController.new);
