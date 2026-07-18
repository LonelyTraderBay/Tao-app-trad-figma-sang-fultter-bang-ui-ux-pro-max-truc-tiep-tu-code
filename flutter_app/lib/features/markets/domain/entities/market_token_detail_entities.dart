part of 'market_entities.dart';

/// Read-model for the Advanced Charts screen (indicators, drawing tools,
/// technical signal summaries).
final class MarketAdvancedChartsSnapshot {
  const MarketAdvancedChartsSnapshot({
    required this.indicators,
    required this.drawingTools,
    required this.signalSummaries,
    required this.indicatorCategories,
    required this.drawingCategories,
    required this.activeIndicatorIds,
    required this.selectedIndicatorCategory,
    required this.selectedDrawingCategory,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TechnicalIndicator> indicators;
  final List<AdvancedDrawingTool> drawingTools;
  final List<TechSignalSummaryDraft> signalSummaries;
  final List<AdvancedChartCategory> indicatorCategories;
  final List<AdvancedChartCategory> drawingCategories;
  final Set<String> activeIndicatorIds;
  final String selectedIndicatorCategory;
  final String selectedDrawingCategory;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for the Token Unlocks screen (upcoming unlock schedule,
/// impact/category filters).
final class MarketTokenUnlocksSnapshot {
  const MarketTokenUnlocksSnapshot({
    required this.unlocks,
    required this.totalValueNext30d,
    required this.highImpactCount,
    required this.avgDilution,
    required this.impactConfigs,
    required this.categoryConfigs,
    required this.sortBy,
    required this.impactFilter,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TokenUnlockDraft> unlocks;
  final double totalValueNext30d;
  final int highImpactCount;
  final double avgDilution;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final Map<MarketUnlockCategory, UnlockCategoryConfig> categoryConfigs;
  final MarketUnlockSort sortBy;
  final MarketUnlockImpact? impactFilter;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// Read-model for a single pair's Market Detail screen (order book depth,
/// recent trades).
final class MarketPairDetailSnapshot {
  const MarketPairDetailSnapshot({
    required this.pair,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.depth,
    required this.recentTrades,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final MarketPair pair;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final MarketDepthData depth;
  final List<MarketRecentTrade> recentTrades;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;

  List<double> get activeChartSeries =>
      chartSeries[pair.id] ?? pair.sparklineData;
}

/// Read-model for the Token Info screen (project fundamentals for a
/// single pair).
final class MarketTokenInfoSnapshot {
  const MarketTokenInfoSnapshot({
    required this.pair,
    required this.fundamentals,
    required this.marketPairs,
    required this.watchlist,
    required this.alerts,
    required this.screenFilters,
    required this.chartSeries,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final MarketPair pair;
  final TokenFundamentalsDraft fundamentals;
  final List<MarketPair> marketPairs;
  final Set<String> watchlist;
  final List<MarketAlertDraft> alerts;
  final MarketScreenFilters screenFilters;
  final Map<String, List<double>> chartSeries;
  final String lastUpdatedLabel;
  final Set<MarketScreenState> supportedStates;
}

/// A selectable category tab (id, label, accent color) for indicators or
/// drawing tools.
final class AdvancedChartCategory {
  const AdvancedChartCategory({
    required this.id,
    required this.label,
    required this.color,
  });

  final String id;
  final String label;
  final AccentTone color;
}

/// A single technical chart indicator (e.g. RSI, MACD) with its tunable
/// parameters.
final class TechnicalIndicator {
  const TechnicalIndicator({
    required this.id,
    required this.name,
    required this.shortName,
    required this.categoryId,
    required this.color,
    required this.description,
    required this.params,
  });

  final String id;
  final String name;
  final String shortName;
  final String categoryId;
  final AccentTone color;
  final String description;
  final List<TechnicalIndicatorParam> params;
}

/// A single tunable parameter (label + default value) for a technical
/// indicator.
final class TechnicalIndicatorParam {
  const TechnicalIndicatorParam({required this.label, required this.value});

  final String label;
  final int value;
}

/// A selectable charting drawing tool (e.g. trendline, Fibonacci).
final class AdvancedDrawingTool {
  const AdvancedDrawingTool({
    required this.id,
    required this.name,
    required this.icon,
    required this.categoryId,
  });

  final String id;
  final String name;
  final String icon;
  final String categoryId;
}

/// Aggregated technical-analysis signal summary (moving average and
/// oscillator consensus, buy/sell/neutral counts, pivot points) for a
/// pair/timeframe.
final class TechSignalSummaryDraft {
  const TechSignalSummaryDraft({
    required this.pair,
    required this.timeframe,
    required this.overallSignal,
    required this.maSummary,
    required this.oscSummary,
    required this.buyCount,
    required this.sellCount,
    required this.neutralCount,
    required this.pivotPoints,
  });

  final String pair;
  final String timeframe;
  final TechSignal overallSignal;
  final TechSignal maSummary;
  final TechSignal oscSummary;
  final int buyCount;
  final int sellCount;
  final int neutralCount;
  final List<TechPivotPointDraft> pivotPoints;
}

/// A single labelled pivot-point price level.
final class TechPivotPointDraft {
  const TechPivotPointDraft({required this.label, required this.value});

  final String label;
  final double value;
}

/// Aggregated technical-analysis signal strength: strong buy, buy,
/// neutral, sell, or strong sell.
enum TechSignal { strongBuy, buy, neutral, sell, strongSell }

/// A single upcoming token unlock event (amount, USD value, dilution %,
/// vesting schedule).
final class TokenUnlockDraft {
  const TokenUnlockDraft({
    required this.id,
    required this.symbol,
    required this.name,
    required this.unlockDate,
    required this.unlockDateLabel,
    required this.daysUntil,
    required this.unlockAmount,
    required this.unlockValueUsd,
    required this.unlockPctCirculating,
    required this.totalLocked,
    required this.totalLockedValueUsd,
    required this.vestingType,
    required this.category,
    required this.impactLevel,
    required this.currentPrice,
    required this.priceChange7d,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.vestingSchedule,
  });

  final String id;
  final String symbol;
  final String name;
  final String unlockDate;
  final String unlockDateLabel;
  final int daysUntil;
  final double unlockAmount;
  final double unlockValueUsd;
  final double unlockPctCirculating;
  final double totalLocked;
  final double totalLockedValueUsd;
  final MarketUnlockVestingType vestingType;
  final MarketUnlockCategory category;
  final MarketUnlockImpact impactLevel;
  final double currentPrice;
  final double priceChange7d;
  final double circulatingSupply;
  final double totalSupply;
  final List<TokenVestingEventDraft> vestingSchedule;
}

/// One scheduled vesting event (date, percentage released) in a token
/// unlock's vesting schedule.
final class TokenVestingEventDraft {
  const TokenVestingEventDraft({
    required this.date,
    required this.pct,
    required this.label,
  });

  final String date;
  final double pct;
  final String label;
}

/// Display label/color for a token-unlock impact-level badge.
final class UnlockImpactConfig {
  const UnlockImpactConfig({required this.label, required this.color});

  final String label;
  final AccentTone color;
}

/// Display label/color for a token-unlock category badge.
final class UnlockCategoryConfig {
  const UnlockCategoryConfig({required this.label, required this.color});

  final String label;
  final AccentTone color;
}

/// Sort key for the token unlocks list: nearest date, value, or impact.
enum MarketUnlockSort { nearest, value, impact }

/// Market impact severity of a token unlock: high, medium, or low.
enum MarketUnlockImpact { high, medium, low }

/// Recipient category of a token unlock: team, investor, ecosystem,
/// community, or foundation.
enum MarketUnlockCategory { team, investor, ecosystem, community, foundation }

/// Vesting release pattern of a token unlock: cliff, linear, or
/// milestone-based.
enum MarketUnlockVestingType { cliff, linear, milestone }

/// A single recent trade print shown on the pair detail screen.
final class MarketRecentTrade {
  const MarketRecentTrade({
    required this.id,
    required this.price,
    required this.amount,
    required this.time,
    required this.side,
  });

  final String id;
  final double price;
  final double amount;
  final String time;
  final MarketOrderSide side;
}

/// A token's project fundamentals (supply, links, on-chain metrics,
/// distribution, contract addresses) shown on the Token Info screen.
final class TokenFundamentalsDraft {
  const TokenFundamentalsDraft({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.consensus,
    required this.network,
    required this.website,
    required this.whitepaper,
    required this.github,
    required this.twitter,
    required this.telegram,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.fullyDilutedValuation,
    required this.inflationRate,
    required this.allTimeHigh,
    required this.allTimeHighDate,
    required this.allTimeLow,
    required this.allTimeLowDate,
    required this.roi1y,
    required this.activeAddresses24h,
    required this.txCount24h,
    required this.holders,
    required this.tvl,
    required this.supplyDistribution,
    required this.contractAddresses,
  });

  final String id;
  final String symbol;
  final String name;
  final String description;
  final String consensus;
  final String network;
  final String website;
  final String whitepaper;
  final String github;
  final String twitter;
  final String telegram;
  final double circulatingSupply;
  final double totalSupply;
  final double? maxSupply;
  final double fullyDilutedValuation;
  final double inflationRate;
  final double allTimeHigh;
  final String allTimeHighDate;
  final double allTimeLow;
  final String allTimeLowDate;
  final double roi1y;
  final int activeAddresses24h;
  final int txCount24h;
  final int holders;
  final double? tvl;
  final List<SupplyDistributionDraft> supplyDistribution;
  final List<ContractAddressDraft> contractAddresses;
}

/// A single labelled supply-distribution slice (e.g. team, public) with
/// its percentage and display color.
final class SupplyDistributionDraft {
  const SupplyDistributionDraft({
    required this.label,
    required this.percentage,
    required this.color,
  });

  final String label;
  final double percentage;
  final AccentTone color;
}

/// A single deployed contract address for a token on a given network.
final class ContractAddressDraft {
  const ContractAddressDraft({required this.network, required this.address});

  final String network;
  final String address;
}
