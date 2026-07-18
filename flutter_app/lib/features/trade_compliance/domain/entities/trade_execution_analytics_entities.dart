part of 'trade_compliance_entities.dart';

/// Read-model for the Market Data Analytics screen (open interest,
/// long/short ratio, funding, liquidations, sentiment for a pair).
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

/// Current open-interest value plus 24h change and range.
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

/// Aggregate long vs. short account/volume ratio for a pair.
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

/// Long/short positioning of top traders, plus its 24h change.
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

/// Current/average funding rate plus recent rate history.
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

/// Aggregate liquidation stats across 24h/7d/30d windows.
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

/// A single price-level liquidation cluster (heatmap intensity).
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

/// A single recent liquidation event (pair, side, size, price, exchange).
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

/// Aggregate market sentiment (overall label, score, component
/// breakdown, actionable implications).
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

/// A single weighted component contributing to the overall sentiment
/// score.
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

/// A single "if this condition, then this action" sentiment implication.
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

/// Read-model for the ARM (Approved Reporting Mechanism) Integration
/// Status screen (connections, latency history, SLA metrics).
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

/// A single ARM provider connection (region, uptime, latency, cert
/// expiry).
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

/// One time bucket's per-provider ARM connection latency.
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

/// Aggregate ARM service-level metrics (uptime, average latency,
/// failover readiness).
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

/// Read-model for the Best Execution Reports screen (per-venue ranking,
/// quarterly archive, summary).
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

/// A single venue's best-execution ranking (fill rate, speed, cost,
/// score).
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

/// A single archived quarterly best-execution report entry.
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

/// Aggregate best-execution summary (total orders, value, average
/// score).
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

/// Read-model for the Execution Venue Analysis screen (per-venue cost/
/// speed metrics, cost trends, summary).
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

/// A single venue's detailed cost/latency/reliability metrics.
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

/// One month's per-venue execution cost trend.
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

/// Aggregate execution venue analysis summary (venue count, average
/// cost/fill time).
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

/// Read-model for the Slippage Monitoring screen (events, per-provider
/// stats, history, summary).
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

/// A single flagged slippage event (expected vs. executed price,
/// severity).
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

/// A single provider's aggregate slippage stats.
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

/// One date's average/max slippage.
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

/// Aggregate slippage summary bucketed by severity (normal/warning/
/// critical).
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
