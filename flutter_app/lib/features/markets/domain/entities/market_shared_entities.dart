part of 'market_entities.dart';

/// A single tradable market pair (price, 24h stats, sparkline) — kernel
/// entity shared across every markets screen.
final class MarketPair {
  const MarketPair({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.price,
    required this.prevPrice,
    required this.change24h,
    required this.high24h,
    required this.low24h,
    required this.volume24h,
    required this.marketCap,
    required this.sparklineData,
    required this.isFavorite,
    required this.category,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final double price;
  final double prevPrice;
  final double change24h;
  final double high24h;
  final double low24h;
  final double volume24h;
  final double marketCap;
  final List<double> sparklineData;
  final bool isFavorite;
  final String category;
}

/// A pending/created price-alert draft for a market pair.
final class MarketAlertDraft {
  const MarketAlertDraft({
    required this.id,
    required this.pairId,
    required this.label,
  });

  final String id;
  final String pairId;
  final String label;
}

/// Available category/sort options and defaults shared by market list
/// screens' filter bar.
final class MarketScreenFilters {
  const MarketScreenFilters({
    required this.categories,
    required this.sortOptions,
    required this.defaultCategory,
    required this.defaultSort,
  });

  final List<String> categories;
  final List<MarketSortOption> sortOptions;
  final String defaultCategory;
  final String defaultSort;
}

/// A single selectable sort option (id + label) in a market filter bar.
final class MarketSortOption {
  const MarketSortOption({required this.id, required this.label});

  final String id;
  final String label;
}

/// Supported UI states (loading/empty/error/offline/realtime-refresh)
/// shared by market screen read-model snapshots.
enum MarketScreenState { loading, empty, error, offline, realtimeRefresh }
