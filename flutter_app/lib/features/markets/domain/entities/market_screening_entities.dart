part of 'market_entities.dart';

final class MarketHeatmapSnapshot {
  const MarketHeatmapSnapshot({
    required this.coins,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.metrics,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<HeatmapCoin> coins;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final List<String> metrics;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class MarketAlertsSnapshot {
  const MarketAlertsSnapshot({
    required this.priceAlerts,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketPriceAlert> priceAlerts;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class MarketScreenerSnapshot {
  const MarketScreenerSnapshot({
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.presets,
    required this.appliedQuery,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final List<MarketScreenerPreset> presets;
  final MarketScreenerQuery appliedQuery;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class MarketComparisonSnapshot {
  const MarketComparisonSnapshot({
    required this.marketPairs,
    required this.selectedPairIds,
    required this.popularPairIds,
    required this.metrics,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketPair> marketPairs;
  final List<String> selectedPairIds;
  final List<String> popularPairIds;
  final List<MarketComparisonMetric> metrics;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class HeatmapCoin {
  const HeatmapCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.change7d,
    required this.marketCap,
    required this.volume24h,
    required this.category,
  });

  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final double change7d;
  final double marketCap;
  final double volume24h;
  final String category;
}

final class MarketPriceAlert {
  const MarketPriceAlert({
    required this.id,
    required this.pairId,
    required this.symbol,
    required this.condition,
    required this.targetPrice,
    required this.currentPrice,
    required this.isActive,
    required this.createdAt,
    this.triggeredAt,
  });

  final String id;
  final String pairId;
  final String symbol;
  final MarketAlertCondition condition;
  final double targetPrice;
  final double currentPrice;
  final bool isActive;
  final String createdAt;
  final String? triggeredAt;
}

enum MarketAlertCondition { above, below }

final class MarketScreenerPreset {
  const MarketScreenerPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.query,
  });

  final String id;
  final String name;
  final String description;
  final String icon;
  final MarketScreenerQuery query;
}

final class MarketScreenerQuery {
  const MarketScreenerQuery({
    this.searchQuery = '',
    this.categories = const [],
    this.minPrice,
    this.maxPrice,
    this.minMarketCap,
    this.maxMarketCap,
    this.minVolume24h,
    this.maxVolume24h,
    this.minChange24h,
    this.maxChange24h,
    this.sortBy = MarketScreenerSort.marketCap,
    this.sortDirection = MarketSortDirection.desc,
  });

  static const defaults = MarketScreenerQuery();

  final String searchQuery;
  final List<String> categories;
  final double? minPrice;
  final double? maxPrice;
  final double? minMarketCap;
  final double? maxMarketCap;
  final double? minVolume24h;
  final double? maxVolume24h;
  final double? minChange24h;
  final double? maxChange24h;
  final MarketScreenerSort sortBy;
  final MarketSortDirection sortDirection;

  MarketScreenerQuery copyWith({
    String? searchQuery,
    List<String>? categories,
    double? minPrice,
    double? maxPrice,
    double? minMarketCap,
    double? maxMarketCap,
    double? minVolume24h,
    double? maxVolume24h,
    double? minChange24h,
    double? maxChange24h,
    MarketScreenerSort? sortBy,
    MarketSortDirection? sortDirection,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinMarketCap = false,
    bool clearMaxMarketCap = false,
    bool clearMinVolume24h = false,
    bool clearMaxVolume24h = false,
    bool clearMinChange24h = false,
    bool clearMaxChange24h = false,
  }) {
    return MarketScreenerQuery(
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      minPrice: clearMinPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
      minMarketCap: clearMinMarketCap
          ? null
          : minMarketCap ?? this.minMarketCap,
      maxMarketCap: clearMaxMarketCap
          ? null
          : maxMarketCap ?? this.maxMarketCap,
      minVolume24h: clearMinVolume24h
          ? null
          : minVolume24h ?? this.minVolume24h,
      maxVolume24h: clearMaxVolume24h
          ? null
          : maxVolume24h ?? this.maxVolume24h,
      minChange24h: clearMinChange24h
          ? null
          : minChange24h ?? this.minChange24h,
      maxChange24h: clearMaxChange24h
          ? null
          : maxChange24h ?? this.maxChange24h,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

enum MarketScreenerSort { marketCap, volume, change24h, price }

enum MarketSortDirection { asc, desc }

final class MarketComparisonMetric {
  const MarketComparisonMetric({
    required this.key,
    required this.label,
    required this.format,
    this.highlight,
  });

  final String key;
  final String label;
  final MarketComparisonMetricFormat format;
  final MarketComparisonHighlight? highlight;
}

enum MarketComparisonMetricFormat { price, compact, percent, raw }

enum MarketComparisonHighlight { high, low }
