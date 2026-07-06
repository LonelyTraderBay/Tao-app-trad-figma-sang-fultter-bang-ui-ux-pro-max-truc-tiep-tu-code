part of 'trade_entities.dart';

final class TradeMarketDataAnalyticsSnapshot {
  const TradeMarketDataAnalyticsSnapshot({
    required this.selectedPair,
    required this.markPrice,
    required this.openInterest,
    required this.longShortRatio,
    required this.topTraders,
    required this.fundingRate,
    required this.liquidationStats,
    required this.liquidationClusters,
    required this.recentLiquidations,
    required this.sentiment,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String selectedPair;
  final double markPrice;
  final TradeMarketOpenInterest openInterest;
  final TradeMarketLongShortRatio longShortRatio;
  final TradeTopTraderPositions topTraders;
  final TradeFundingRateHistory fundingRate;
  final TradeLiquidationStats liquidationStats;
  final List<TradeLiquidationCluster> liquidationClusters;
  final List<TradeRecentLiquidation> recentLiquidations;
  final TradeMarketSentiment sentiment;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeMarketOpenInterest {
  const TradeMarketOpenInterest({
    required this.current,
    required this.change24h,
    required this.change24hPct,
    required this.high24h,
    required this.low24h,
  });

  final double current;
  final double change24h;
  final double change24hPct;
  final double high24h;
  final double low24h;
}

final class TradeMarketLongShortRatio {
  const TradeMarketLongShortRatio({
    required this.longPct,
    required this.shortPct,
    required this.longAccounts,
    required this.shortAccounts,
    required this.longVolume,
    required this.shortVolume,
  });

  final double longPct;
  final double shortPct;
  final int longAccounts;
  final int shortAccounts;
  final double longVolume;
  final double shortVolume;

  double get ratio => longPct / shortPct;
}

final class TradeTopTraderPositions {
  const TradeTopTraderPositions({
    required this.longPct,
    required this.shortPct,
    required this.change24h,
  });

  final double longPct;
  final double shortPct;
  final double change24h;
}

final class TradeFundingRateHistory {
  const TradeFundingRateHistory({
    required this.currentRatePct,
    required this.avgRatePct,
    required this.rangePct,
    required this.nextFundingLabel,
    required this.historyPct,
  });

  final double currentRatePct;
  final double avgRatePct;
  final double rangePct;
  final String nextFundingLabel;
  final List<double> historyPct;
}

final class TradeLiquidationStats {
  const TradeLiquidationStats({
    required this.total24h,
    required this.long24h,
    required this.short24h,
    required this.largest24h,
    required this.avg24h,
    required this.count24h,
    required this.total7d,
    required this.count7d,
    required this.total30d,
    required this.count30d,
  });

  final double total24h;
  final double long24h;
  final double short24h;
  final double largest24h;
  final double avg24h;
  final int count24h;
  final double total7d;
  final int count7d;
  final double total30d;
  final int count30d;
}

final class TradeLiquidationCluster {
  const TradeLiquidationCluster({
    required this.price,
    required this.longLiquidations,
    required this.shortLiquidations,
    required this.total,
    required this.intensity,
  });

  final double price;
  final double longLiquidations;
  final double shortLiquidations;
  final double total;
  final int intensity;
}

final class TradeRecentLiquidation {
  const TradeRecentLiquidation({
    required this.id,
    required this.timeLabel,
    required this.pair,
    required this.side,
    required this.size,
    required this.price,
    required this.exchange,
  });

  final String id;
  final String timeLabel;
  final String pair;
  final String side;
  final double size;
  final double price;
  final String exchange;
}

final class TradeMarketSentiment {
  const TradeMarketSentiment({
    required this.overall,
    required this.score,
    required this.components,
    required this.implications,
  });

  final String overall;
  final int score;
  final List<TradeSentimentComponent> components;
  final List<TradeSentimentImplication> implications;
}

final class TradeSentimentComponent {
  const TradeSentimentComponent({
    required this.label,
    required this.weight,
    required this.score,
    required this.description,
  });

  final String label;
  final String weight;
  final int score;
  final String description;
}

final class TradeSentimentImplication {
  const TradeSentimentImplication({
    required this.condition,
    required this.action,
    required this.colorHex,
  });

  final String condition;
  final String action;
  final int colorHex;
}

final class TradeArmIntegrationStatusSnapshot {
  const TradeArmIntegrationStatusSnapshot({
    required this.connections,
    required this.latencyHistory,
    required this.sla,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeArmConnection> connections;
  final List<TradeArmLatencyPoint> latencyHistory;
  final TradeArmSlaMetrics sla;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeArmConnection {
  const TradeArmConnection({
    required this.id,
    required this.provider,
    required this.region,
    required this.status,
    required this.uptime,
    required this.avgLatency,
    required this.currentLatency,
    required this.lastCheck,
    required this.isPrimary,
    required this.endpoint,
    required this.certExpiry,
  });

  final String id;
  final String provider;
  final String region;
  final String status;
  final double uptime;
  final int avgLatency;
  final int currentLatency;
  final String lastCheck;
  final bool isPrimary;
  final String endpoint;
  final String certExpiry;
}

final class TradeArmLatencyPoint {
  const TradeArmLatencyPoint({
    required this.time,
    required this.registr,
    required this.unavista,
    required this.bloomberg,
  });

  final String time;
  final int registr;
  final int unavista;
  final int bloomberg;
}

final class TradeArmSlaMetrics {
  const TradeArmSlaMetrics({
    required this.uptime,
    required this.latencyAvg,
    required this.failoverReadiness,
  });

  final double uptime;
  final int latencyAvg;
  final int failoverReadiness;
}

final class TradeBestExecutionReportsSnapshot {
  const TradeBestExecutionReportsSnapshot({
    required this.venues,
    required this.archive,
    required this.summary,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeExecutionVenue> venues;
  final List<TradeQuarterlyReport> archive;
  final TradeBestExecutionSummary summary;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeExecutionVenue {
  const TradeExecutionVenue({
    required this.rank,
    required this.venue,
    required this.volume,
    required this.value,
    required this.avgPrice,
    required this.avgCost,
    required this.avgSpeed,
    required this.fillRate,
    required this.score,
  });

  final int rank;
  final String venue;
  final int volume;
  final double value;
  final int avgPrice;
  final double avgCost;
  final double avgSpeed;
  final double fillRate;
  final double score;
}

final class TradeQuarterlyReport {
  const TradeQuarterlyReport({
    required this.id,
    required this.quarter,
    required this.year,
    required this.period,
    required this.totalOrders,
    required this.totalValue,
    required this.publishDate,
    required this.status,
  });

  final String id;
  final String quarter;
  final int year;
  final String period;
  final int totalOrders;
  final double totalValue;
  final String publishDate;
  final String status;
}

final class TradeBestExecutionSummary {
  const TradeBestExecutionSummary({
    required this.totalOrders,
    required this.totalValue,
    required this.avgScore,
  });

  final int totalOrders;
  final double totalValue;
  final double avgScore;
}

final class TradeExecutionVenueAnalysisSnapshot {
  const TradeExecutionVenueAnalysisSnapshot({
    required this.venues,
    required this.costTrends,
    required this.summary,
    required this.defaultSort,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeExecutionVenueAnalysisMetric> venues;
  final List<TradeExecutionVenueCostTrend> costTrends;
  final TradeExecutionVenueAnalysisSummary summary;
  final String defaultSort;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeExecutionVenueAnalysisMetric {
  const TradeExecutionVenueAnalysisMetric({
    required this.venue,
    required this.volume,
    required this.value,
    required this.avgFee,
    required this.avgSpread,
    required this.marketImpact,
    required this.totalCost,
    required this.avgLatency,
    required this.avgFillTime,
    required this.fillRate,
    required this.liquidity,
    required this.reliability,
  });

  final String venue;
  final int volume;
  final double value;
  final double avgFee;
  final double avgSpread;
  final double marketImpact;
  final double totalCost;
  final int avgLatency;
  final double avgFillTime;
  final double fillRate;
  final int liquidity;
  final double reliability;
}

final class TradeExecutionVenueCostTrend {
  const TradeExecutionVenueCostTrend({
    required this.month,
    required this.binance,
    required this.coinbase,
    required this.kraken,
  });

  final String month;
  final double binance;
  final double coinbase;
  final double kraken;
}

final class TradeExecutionVenueAnalysisSummary {
  const TradeExecutionVenueAnalysisSummary({
    required this.totalVenues,
    required this.avgTotalCost,
    required this.avgFillTime,
  });

  final int totalVenues;
  final double avgTotalCost;
  final double avgFillTime;
}

final class TradeSlippageMonitoringSnapshot {
  const TradeSlippageMonitoringSnapshot({
    required this.events,
    required this.providers,
    required this.history,
    required this.summary,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeSlippageEvent> events;
  final List<TradeSlippageProviderStats> providers;
  final List<TradeSlippageHistoryPoint> history;
  final TradeSlippageSummary summary;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeSlippageEvent {
  const TradeSlippageEvent({
    required this.id,
    required this.time,
    required this.provider,
    required this.instrument,
    required this.side,
    required this.expectedPrice,
    required this.executedPrice,
    required this.slippageBps,
    required this.slippagePct,
    required this.volume,
    required this.value,
    required this.severity,
  });

  final String id;
  final String time;
  final String provider;
  final String instrument;
  final String side;
  final double expectedPrice;
  final double executedPrice;
  final double slippageBps;
  final double slippagePct;
  final double volume;
  final double value;
  final String severity;
}

final class TradeSlippageProviderStats {
  const TradeSlippageProviderStats({
    required this.provider,
    required this.avgSlippage,
    required this.maxSlippage,
    required this.eventCount,
    required this.warningCount,
    required this.criticalCount,
    required this.totalImpact,
  });

  final String provider;
  final double avgSlippage;
  final double maxSlippage;
  final int eventCount;
  final int warningCount;
  final int criticalCount;
  final double totalImpact;
}

final class TradeSlippageHistoryPoint {
  const TradeSlippageHistoryPoint({
    required this.date,
    required this.avg,
    required this.max,
  });

  final String date;
  final double avg;
  final double max;
}

final class TradeSlippageSummary {
  const TradeSlippageSummary({
    required this.total,
    required this.normal,
    required this.warning,
    required this.critical,
    required this.avgSlippage,
    required this.maxSlippage,
  });

  final int total;
  final int normal;
  final int warning;
  final int critical;
  final double avgSlippage;
  final double maxSlippage;
}
