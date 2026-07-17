part of 'market_entities.dart';

final class MarketPortfolioSnapshot {
  const MarketPortfolioSnapshot({
    required this.stats,
    required this.holdings,
    required this.performance,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.sortBy,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final PortfolioStats stats;
  final List<PortfolioHolding> holdings;
  final List<PortfolioPerformancePoint> performance;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final MarketPortfolioSort sortBy;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class MarketNewsSnapshot {
  const MarketNewsSnapshot({
    required this.news,
    required this.breakingNews,
    required this.categories,
    required this.sentimentBadges,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.selectedCategory,
    required this.sentimentFilter,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<MarketNewsItem> news;
  final List<MarketNewsItem> breakingNews;
  final List<MarketNewsCategory> categories;
  final Map<MarketNewsSentiment, MarketNewsSentimentBadge> sentimentBadges;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String selectedCategory;
  final MarketNewsSentiment? sentimentFilter;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

final class PortfolioStats {
  const PortfolioStats({
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.totalCost,
    required this.best24hSymbol,
    required this.best24hChange,
    required this.worst24hSymbol,
    required this.worst24hChange,
    required this.stableAllocation,
  });

  final double totalValue;
  final double totalPnl;
  final double totalPnlPct;
  final double totalCost;
  final String best24hSymbol;
  final double best24hChange;
  final String worst24hSymbol;
  final double worst24hChange;
  final double stableAllocation;
}

final class PortfolioHolding {
  const PortfolioHolding({
    required this.id,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.avgBuyPrice,
    required this.currentPrice,
    required this.value,
    required this.pnl,
    required this.pnlPct,
    required this.allocation,
    required this.change24h,
    required this.sparkline,
  });

  final String id;
  final String symbol;
  final String name;
  final double quantity;
  final double avgBuyPrice;
  final double currentPrice;
  final double value;
  final double pnl;
  final double pnlPct;
  final double allocation;
  final double change24h;
  final List<double> sparkline;
}

final class PortfolioPerformancePoint {
  const PortfolioPerformancePoint({required this.date, required this.value});

  final String date;
  final double value;
}

enum MarketPortfolioSort { value, pnl, change }

final class MarketNewsItem {
  const MarketNewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.timeAgo,
    required this.category,
    required this.sentiment,
    required this.relatedTokens,
    required this.icon,
    required this.iconColor,
    required this.readTime,
    this.isBreaking = false,
  });

  final String id;
  final String title;
  final String summary;
  final String source;
  final String timeAgo;
  final String category;
  final MarketNewsSentiment sentiment;
  final List<String> relatedTokens;
  final String icon;
  final AccentTone iconColor;
  final String readTime;
  final bool isBreaking;
}

final class MarketNewsCategory {
  const MarketNewsCategory({
    required this.id,
    required this.label,
    required this.color,
  });

  final String id;
  final String label;
  final AccentTone color;
}

final class MarketNewsSentimentBadge {
  const MarketNewsSentimentBadge({required this.label, required this.color});

  final String label;
  final AccentTone color;
}

enum MarketNewsSentiment { bullish, bearish, neutral }
