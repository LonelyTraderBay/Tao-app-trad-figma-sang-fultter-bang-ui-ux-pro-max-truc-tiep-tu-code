import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';

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
