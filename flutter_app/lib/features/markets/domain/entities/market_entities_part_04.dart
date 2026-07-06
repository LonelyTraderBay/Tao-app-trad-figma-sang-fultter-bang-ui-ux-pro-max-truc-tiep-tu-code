part of 'market_entities.dart';

final class MarketBreadth {
  const MarketBreadth({
    required this.advancing,
    required this.declining,
    required this.unchanged,
    required this.newATH,
    required this.dropping10Pct,
  });

  final int advancing;
  final int declining;
  final int unchanged;
  final int newATH;
  final int dropping10Pct;
}

final class FearGreedPoint {
  const FearGreedPoint({
    required this.date,
    required this.value,
    required this.label,
  });

  final String date;
  final int value;
  final String label;
}

final class MarketSector {
  const MarketSector({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.color,
    required this.icon,
    required this.totalMarketCap,
    required this.change24h,
    required this.change7d,
    required this.change30d,
    required this.volume24h,
    required this.topCoins,
    required this.coinCount,
    required this.dominance,
  });

  final String id;
  final String name;
  final String nameVi;
  final AccentTone color;
  final String icon;
  final double totalMarketCap;
  final double change24h;
  final double change7d;
  final double change30d;
  final double volume24h;
  final List<String> topCoins;
  final int coinCount;
  final double dominance;
}

final class MarketMover {
  const MarketMover({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change1h,
    required this.change24h,
    required this.change7d,
    required this.volume24h,
    required this.volumeChange24h,
    required this.marketCap,
    required this.marketCapRank,
    required this.category,
    required this.sparkline,
    this.isNew = false,
    this.listingDate,
  });

  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change1h;
  final double change24h;
  final double change7d;
  final double volume24h;
  final double volumeChange24h;
  final double marketCap;
  final int marketCapRank;
  final String category;
  final List<double> sparkline;
  final bool isNew;
  final String? listingDate;
}

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

final class ContractAddressDraft {
  const ContractAddressDraft({required this.network, required this.address});

  final String network;
  final String address;
}
