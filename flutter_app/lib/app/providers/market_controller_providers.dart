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

/// PERF-HN4: view-state bất biến của Danh sách thị trường (SC-008) —
/// query/category/sort/favoriteIds sống ở Notifier (một nguồn sự thật).
/// `visiblePairs` được lọc + sắp xếp + memoize NGAY khi input đổi (trong
/// `copyWithFilters`), KHÔNG tính lại mỗi lần widget build().
final class MarketListViewState {
  const MarketListViewState({
    required this.snapshot,
    required this.query,
    required this.category,
    required this.sort,
    required this.favoriteIds,
    required this.visiblePairs,
  });

  factory MarketListViewState.fromSnapshot(MarketListSnapshot snapshot) {
    return MarketListViewState._recomputed(
      snapshot: snapshot,
      query: '',
      category: snapshot.screenFilters.defaultCategory,
      sort: snapshot.screenFilters.defaultSort,
      favoriteIds: Set<String>.unmodifiable(snapshot.watchlist),
    );
  }

  final MarketListSnapshot snapshot;
  final String query;
  final String category;
  final String sort;
  final Set<String> favoriteIds;
  final List<MarketPair> visiblePairs;

  static const _visibleLimit = 8;

  static MarketListViewState _recomputed({
    required MarketListSnapshot snapshot,
    required String query,
    required String category,
    required String sort,
    required Set<String> favoriteIds,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    Iterable<MarketPair> list = snapshot.marketPairs;

    if (normalizedQuery.isNotEmpty) {
      list = list.where((pair) {
        return pair.symbol.toLowerCase().contains(normalizedQuery) ||
            pair.baseAsset.toLowerCase().contains(normalizedQuery);
      });
    }
    if (category != snapshot.screenFilters.defaultCategory) {
      list = list.where((pair) => pair.category == category);
    }

    final sorted = list.toList();
    switch (sort) {
      case 'price_desc':
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case 'price_asc':
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case 'change_desc':
        sorted.sort((a, b) => b.change24h.compareTo(a.change24h));
      case 'change_asc':
        sorted.sort((a, b) => a.change24h.compareTo(b.change24h));
      case 'volume_desc':
        sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
      case 'default':
      default:
        break;
    }

    return MarketListViewState(
      snapshot: snapshot,
      query: query,
      category: category,
      sort: sort,
      favoriteIds: favoriteIds,
      visiblePairs: List.unmodifiable(sorted.take(_visibleLimit)),
    );
  }

  MarketListViewState copyWithFilters({
    String? query,
    String? category,
    String? sort,
    Set<String>? favoriteIds,
  }) {
    return MarketListViewState._recomputed(
      snapshot: snapshot,
      query: query ?? this.query,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

/// PERF-HN4 (khuôn MarketWatchlistStateController): build() seed từ repo,
/// method setQuery/setCategory/setSort/toggleFavorite mutate
/// `state = state.copyWithFilters(...)` — lọc/sắp xếp tính TRONG notifier,
/// không trong build() của widget. KHÔNG autoDispose — trạng thái tìm
/// kiếm/lọc/yêu thích của Danh sách thị trường giữ nguyên khi điều hướng
/// đi/về trong phiên.
final class MarketListStateController extends Notifier<MarketListViewState> {
  @override
  MarketListViewState build() {
    return MarketListViewState.fromSnapshot(
      ref.watch(marketControllerProvider).getMarketList(),
    );
  }

  void setQuery(String value) {
    if (value == state.query) return;
    state = state.copyWithFilters(query: value);
  }

  void setCategory(String value) {
    if (value == state.category) return;
    state = state.copyWithFilters(category: value);
  }

  void setSort(String value) {
    if (value == state.sort) return;
    state = state.copyWithFilters(sort: value);
  }

  void toggleFavorite(String id) {
    final next = Set<String>.of(state.favoriteIds);
    if (!next.remove(id)) next.add(id);
    state = state.copyWithFilters(favoriteIds: Set.unmodifiable(next));
  }

  /// Xóa bộ lọc: đưa query/category/sort về mặc định. Giữ nguyên
  /// favoriteIds — khớp hành vi trang cũ (nút "Xóa bộ lọc" không đụng tới
  /// danh sách yêu thích).
  void resetFilters() {
    state = state.copyWithFilters(
      query: '',
      category: state.snapshot.screenFilters.defaultCategory,
      sort: state.snapshot.screenFilters.defaultSort,
    );
  }
}

final marketListStateControllerProvider =
    NotifierProvider<MarketListStateController, MarketListViewState>(
      MarketListStateController.new,
    );
