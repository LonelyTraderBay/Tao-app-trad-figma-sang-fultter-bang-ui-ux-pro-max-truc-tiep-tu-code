part of '../repositories/mock_trade_regulatory_repository.dart';

mixin _MockTradeRegulatoryRepositoryExecutionAnalyticsMethods
    on _MockTradeRegulatoryRepositoryBase {
  @override
  TradeMarketDataAnalyticsSnapshot getMarketDataAnalytics() {
    return const TradeMarketDataAnalyticsSnapshot(
      selectedPair: 'BTC/USDT',
      markPrice: 67543.21,
      openInterest: _marketOpenInterest,
      longShortRatio: _marketLongShortRatio,
      topTraders: _marketTopTraders,
      fundingRate: _marketFundingRate,
      liquidationStats: _marketLiquidationStats,
      liquidationClusters: _marketLiquidationClusters,
      recentLiquidations: _marketRecentLiquidations,
      sentiment: _marketSentiment,
      defaultTab: 'market',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeMarketDataAnalyticsSnapshot getLiveMarketDataAnalytics() {
    return const TradeMarketDataAnalyticsSnapshot(
      selectedPair: 'BTC/USDT',
      markPrice: 67543.21,
      openInterest: _liveMarketOpenInterest,
      longShortRatio: _liveMarketLongShortRatio,
      topTraders: _liveMarketTopTraders,
      fundingRate: _liveMarketFundingRate,
      liquidationStats: _marketLiquidationStats,
      liquidationClusters: _marketLiquidationClusters,
      recentLiquidations: _marketRecentLiquidations,
      sentiment: _marketSentiment,
      defaultTab: 'market',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeArmIntegrationStatusSnapshot getArmIntegrationStatus() {
    return const TradeArmIntegrationStatusSnapshot(
      connections: _armConnections,
      latencyHistory: _armLatencyHistory,
      sla: _armSlaMetrics,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeBestExecutionReportsSnapshot getBestExecutionReports() {
    return const TradeBestExecutionReportsSnapshot(
      venues: _bestExecutionVenues,
      archive: _bestExecutionArchive,
      summary: _bestExecutionSummary,
      defaultTab: 'current',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExecutionVenueAnalysisSnapshot getExecutionVenueAnalysis() {
    return const TradeExecutionVenueAnalysisSnapshot(
      venues: _executionVenueMetrics,
      costTrends: _executionVenueCostTrends,
      summary: _executionVenueSummary,
      defaultSort: 'volume',
      defaultTab: 'comparison',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeSlippageMonitoringSnapshot getSlippageMonitoring() {
    return const TradeSlippageMonitoringSnapshot(
      events: _slippageEvents,
      providers: _slippageProviderStats,
      history: _slippageHistory,
      summary: _slippageSummary,
      defaultTab: 'realtime',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }
}
