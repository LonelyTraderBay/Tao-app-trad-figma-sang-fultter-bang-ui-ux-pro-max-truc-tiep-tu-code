part of 'trade_entities.dart';

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

final class TradeMarginTradingHubSnapshot {
  const TradeMarginTradingHubSnapshot({
    required this.stats,
    required this.menuItems,
    required this.features,
    required this.compliance,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeMarginHubStat> stats;
  final List<TradeMarginHubMenuItem> menuItems;
  final List<TradeMarginHubFeature> features;
  final TradeMarginHubCompliance compliance;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeMarginHubStat {
  const TradeMarginHubStat({
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String label;
  final String value;
  final int colorHex;
}

final class TradeMarginHubMenuItem {
  const TradeMarginHubMenuItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.colorHex,
    required this.targetPath,
  });

  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final int colorHex;
  final String targetPath;
}

final class TradeMarginHubFeature {
  const TradeMarginHubFeature({
    required this.phase,
    required this.title,
    required this.colorHex,
    required this.items,
  });

  final String phase;
  final String title;
  final int colorHex;
  final List<String> items;
}

final class TradeMarginHubCompliance {
  const TradeMarginHubCompliance({
    required this.title,
    required this.description,
    required this.regulations,
  });

  final String title;
  final String description;
  final List<String> regulations;
}

final class TradeAdvancedAnalyticsSnapshot {
  const TradeAdvancedAnalyticsSnapshot({
    required this.stats,
    required this.signals,
    required this.features,
    required this.risk,
    required this.journal,
    required this.sizing,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeAdvancedAnalyticsStat> stats;
  final List<TradeAiSignal> signals;
  final List<String> features;
  final TradeAdvancedRiskSummary risk;
  final TradeJournalSummary journal;
  final TradePositionSizingSummary sizing;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeAdvancedAnalyticsStat {
  const TradeAdvancedAnalyticsStat({
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String label;
  final String value;
  final int colorHex;
}

final class TradeAiSignal {
  const TradeAiSignal({
    required this.id,
    required this.pair,
    required this.direction,
    required this.confidence,
    required this.timeframe,
    required this.entryPrice,
    required this.targetPrice,
    required this.stopLoss,
    required this.riskReward,
    required this.accuracy,
    required this.reasoning,
  });

  final String id;
  final String pair;
  final String direction;
  final int confidence;
  final String timeframe;
  final double entryPrice;
  final double targetPrice;
  final double stopLoss;
  final double riskReward;
  final int accuracy;
  final List<String> reasoning;
}

final class TradeAdvancedRiskSummary {
  const TradeAdvancedRiskSummary({
    required this.var95,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.riskScore,
    required this.riskLevel,
  });

  final double var95;
  final double sharpeRatio;
  final double maxDrawdown;
  final int riskScore;
  final String riskLevel;
}

final class TradeJournalSummary {
  const TradeJournalSummary({
    required this.winRate,
    required this.totalTrades,
    required this.totalPnl,
    required this.avgWin,
    required this.avgLoss,
  });

  final double winRate;
  final int totalTrades;
  final double totalPnl;
  final double avgWin;
  final double avgLoss;
}

final class TradePositionSizingSummary {
  const TradePositionSizingSummary({
    required this.accountBalance,
    required this.entryPrice,
    required this.stopLossPrice,
    required this.takeProfitPrice,
    required this.recommendedRiskPct,
    required this.positionSize,
  });

  final double accountBalance;
  final double entryPrice;
  final double stopLossPrice;
  final double takeProfitPrice;
  final double recommendedRiskPct;
  final double positionSize;
}

final class TradeTransactionReportingSnapshot {
  const TradeTransactionReportingSnapshot({
    required this.reports,
    required this.stats,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeTransactionReport> reports;
  final TradeTransactionReportingStats stats;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;

  List<TradeTransactionReport> reportsForTab(String tab) {
    return switch (tab) {
      'queue' =>
        reports
            .where(
              (report) => [
                'pending',
                'submitting',
                'submitted',
              ].contains(report.status),
            )
            .toList(),
      'history' =>
        reports.where((report) => report.status == 'confirmed').toList(),
      'failed' => reports.where((report) => report.status == 'failed').toList(),
      _ => reports,
    };
  }
}

final class TradeTransactionReport {
  const TradeTransactionReport({
    required this.id,
    required this.transactionId,
    required this.reportType,
    required this.tradingVenue,
    required this.instrument,
    required this.side,
    required this.quantity,
    required this.price,
    required this.value,
    required this.executionTime,
    this.reportedTime,
    this.confirmedTime,
    required this.status,
    required this.armProvider,
    this.messageId,
    this.errorMessage,
    required this.retryCount,
    required this.slaStatus,
  });

  final String id;
  final String transactionId;
  final String reportType;
  final String tradingVenue;
  final String instrument;
  final String side;
  final double quantity;
  final double price;
  final double value;
  final String executionTime;
  final String? reportedTime;
  final String? confirmedTime;
  final String status;
  final String armProvider;
  final String? messageId;
  final String? errorMessage;
  final int retryCount;
  final String slaStatus;
}

final class TradeTransactionReportingStats {
  const TradeTransactionReportingStats({
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.pending,
    required this.onTime,
    required this.avgLatencySeconds,
    required this.totalValue,
    required this.mifidReports,
    required this.emirReports,
    required this.providerCounts,
  });

  final int total;
  final int confirmed;
  final int failed;
  final int pending;
  final int onTime;
  final int avgLatencySeconds;
  final double totalValue;
  final int mifidReports;
  final int emirReports;
  final Map<String, int> providerCounts;
}

final class TradeRegulatoryReportsDashboardSnapshot {
  const TradeRegulatoryReportsDashboardSnapshot({
    required this.dailyStats,
    required this.providers,
    required this.distribution,
    required this.totals,
    required this.timeRanges,
    required this.defaultRange,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final List<TradeRegulatoryDailyStat> dailyStats;
  final List<TradeRegulatoryArmProvider> providers;
  final List<TradeRegulatoryDistributionItem> distribution;
  final TradeRegulatoryDashboardTotals totals;
  final List<String> timeRanges;
  final String defaultRange;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeRegulatoryDailyStat {
  const TradeRegulatoryDailyStat({
    required this.date,
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.avgLatency,
  });

  final String date;
  final int total;
  final int confirmed;
  final int failed;
  final int avgLatency;
}

final class TradeRegulatoryArmProvider {
  const TradeRegulatoryArmProvider({
    required this.name,
    required this.reports,
    required this.successRate,
    required this.avgLatency,
    required this.status,
  });

  final String name;
  final int reports;
  final double successRate;
  final int avgLatency;
  final String status;
}

final class TradeRegulatoryDistributionItem {
  const TradeRegulatoryDistributionItem({
    required this.name,
    required this.value,
    required this.colorHex,
  });

  final String name;
  final int value;
  final int colorHex;
}

final class TradeRegulatoryDashboardTotals {
  const TradeRegulatoryDashboardTotals({
    required this.total,
    required this.confirmed,
    required this.failed,
    required this.avgLatency,
    required this.successRate,
    required this.distributionTotal,
  });

  final int total;
  final int confirmed;
  final int failed;
  final double avgLatency;
  final double successRate;
  final int distributionTotal;
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
