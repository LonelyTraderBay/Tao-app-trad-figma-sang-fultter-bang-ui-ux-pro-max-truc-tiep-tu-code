part of 'trade_entities.dart';

final class TradeRegulatoryProtection {
  const TradeRegulatoryProtection({
    required this.coverage,
    required this.covered,
    required this.notCovered,
    required this.claimSteps,
    required this.contactLabel,
  });

  final TradeRegulatoryDisclosureBlock coverage;
  final TradeRegulatoryDisclosureBlock covered;
  final TradeRegulatoryDisclosureBlock notCovered;
  final TradeRegulatoryDisclosureBlock claimSteps;
  final String contactLabel;
}

final class TradeRegulatoryRestrictions {
  const TradeRegulatoryRestrictions({
    required this.unavailableCountries,
    required this.leverageRules,
    required this.taxReporting,
  });

  final List<String> unavailableCountries;
  final List<TradeRegulatoryDisclosureBlock> leverageRules;
  final TradeRegulatoryDisclosureBlock taxReporting;
}

final class TradeRegulatoryLiability {
  const TradeRegulatoryLiability({
    required this.platformRole,
    required this.userResponsibility,
    required this.indemnification,
    required this.limitation,
  });

  final TradeRegulatoryDisclosureBlock platformRole;
  final TradeRegulatoryDisclosureBlock userResponsibility;
  final TradeRegulatoryDisclosureBlock indemnification;
  final TradeRegulatoryDisclosureBlock limitation;
}

final class TradeRegulatoryContact {
  const TradeRegulatoryContact({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String icon;
}

final class TradeRegulatoryDocumentLink {
  const TradeRegulatoryDocumentLink({required this.title, required this.icon});

  final String title;
  final String icon;
}

final class TradeMarginTradingSnapshot {
  const TradeMarginTradingSnapshot({
    required this.trade,
    required this.pair,
    required this.account,
    required this.positions,
    required this.modeTabs,
    required this.contentTabs,
    required this.defaultMode,
    required this.defaultTab,
    required this.defaultSide,
    required this.defaultLeverage,
    required this.clientCategory,
    required this.referencePrices,
    required this.orderDraft,
    required this.riskWarning,
    required this.negativeBalance,
    required this.bestExecution,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.highRiskContractId,
  });

  final TradeScreenSnapshot trade;
  final TradePair pair;
  final TradeMarginAccount account;
  final List<TradeMarginPosition> positions;
  final List<TradeMarginTab> modeTabs;
  final List<TradeMarginTab> contentTabs;
  final String defaultMode;
  final String defaultTab;
  final String defaultSide;
  final int defaultLeverage;
  final TradeMarginClientCategory clientCategory;
  final TradeMarginReferencePrices referencePrices;
  final TradeMarginOrderDraft orderDraft;
  final TradeMarginRiskWarning riskWarning;
  final TradeMarginSafetyDisclosure negativeBalance;
  final TradeMarginBestExecutionDisclosure bestExecution;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String? highRiskContractId;
}

final class TradeMarginAccount {
  const TradeMarginAccount({
    required this.totalEquity,
    required this.totalMargin,
    required this.availableMargin,
    required this.unrealizedPnl,
    required this.marginLevel,
  });

  final double totalEquity;
  final double totalMargin;
  final double availableMargin;
  final double unrealizedPnl;
  final double marginLevel;
}

final class TradeMarginPosition {
  const TradeMarginPosition({
    required this.id,
    required this.pair,
    required this.side,
    required this.mode,
    required this.leverage,
    required this.entryPrice,
    required this.markPrice,
    required this.size,
    required this.margin,
    required this.pnl,
    required this.pnlPct,
    required this.liquidationPrice,
    required this.marginRatio,
  });

  final String id;
  final String pair;
  final String side;
  final String mode;
  final int leverage;
  final double entryPrice;
  final double markPrice;
  final double size;
  final double margin;
  final double pnl;
  final double pnlPct;
  final double liquidationPrice;
  final double marginRatio;
}

final class TradeMarginTab {
  const TradeMarginTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeMarginClientCategory {
  const TradeMarginClientCategory({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.limits,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final List<String> limits;
}

final class TradeMarginReferencePrices {
  const TradeMarginReferencePrices({
    required this.markPrice,
    required this.lastPrice,
    required this.indexPrice,
  });

  final double markPrice;
  final double lastPrice;
  final double indexPrice;
}

final class TradeMarginOrderDraft {
  const TradeMarginOrderDraft({
    required this.orderTypes,
    required this.selectedOrderType,
    required this.price,
    required this.amount,
    required this.tradingFeeRate,
    required this.liquidationPriceLabel,
  });

  final List<TradeMarginTab> orderTypes;
  final String selectedOrderType;
  final String price;
  final String amount;
  final double tradingFeeRate;
  final String liquidationPriceLabel;
}

final class TradeMarginRiskWarning {
  const TradeMarginRiskWarning({required this.title, required this.items});

  final String title;
  final List<String> items;
}

final class TradeMarginSafetyDisclosure {
  const TradeMarginSafetyDisclosure({
    required this.title,
    required this.body,
    required this.footer,
  });

  final String title;
  final String body;
  final String footer;
}

final class TradeMarginBestExecutionDisclosure {
  const TradeMarginBestExecutionDisclosure({
    required this.title,
    required this.body,
    required this.items,
    required this.actionLabel,
  });

  final String title;
  final String body;
  final List<String> items;
  final String actionLabel;
}

final class TradeTraderProfileSnapshot {
  const TradeTraderProfileSnapshot({
    required this.traderId,
    required this.trader,
    required this.pnlHistory,
    required this.recentTrades,
    required this.defaultTab,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String traderId;
  final TradeCopyTrader trader;
  final List<TradeTraderPnlPoint> pnlHistory;
  final List<TradeTraderRecentTrade> recentTrades;
  final String defaultTab;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeTraderPnlPoint {
  const TradeTraderPnlPoint({
    required this.day,
    required this.pnl,
    required this.cumPnl,
  });

  final String day;
  final double pnl;
  final double cumPnl;
}

final class TradeTraderRecentTrade {
  const TradeTraderRecentTrade({
    required this.id,
    required this.pair,
    required this.side,
    required this.entry,
    required this.exit,
    required this.pnl,
    required this.pnlPct,
    required this.time,
    required this.status,
  });

  final String id;
  final String pair;
  final String side;
  final double entry;
  final double? exit;
  final double pnl;
  final double pnlPct;
  final String time;
  final String status;
}

final class TradeAdvancedTradingDemoSnapshot {
  const TradeAdvancedTradingDemoSnapshot({
    required this.position,
    required this.positionActions,
    required this.orderTypes,
    required this.timeInForce,
    required this.orderSummary,
    required this.pnlSummary,
    required this.performanceMetrics,
    required this.defaultTab,
    required this.defaultPositionMode,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeAdvancedDemoPosition position;
  final List<TradeAdvancedDemoAction> positionActions;
  final List<TradeAdvancedDemoAction> orderTypes;
  final List<TradeAdvancedDemoAction> timeInForce;
  final List<TradeAdvancedDemoMetric> orderSummary;
  final List<TradeAdvancedDemoMetric> pnlSummary;
  final List<TradeAdvancedDemoMetric> performanceMetrics;
  final String defaultTab;
  final String defaultPositionMode;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeAdvancedDemoPosition {
  const TradeAdvancedDemoPosition({
    required this.id,
    required this.pair,
    required this.side,
    required this.currentSize,
    required this.currentPnl,
    required this.markPrice,
    required this.entryPrice,
    required this.currentMargin,
    required this.availableBalance,
    required this.liquidationPrice,
  });

  final String id;
  final String pair;
  final String side;
  final double currentSize;
  final double currentPnl;
  final double markPrice;
  final double entryPrice;
  final double currentMargin;
  final double availableBalance;
  final double liquidationPrice;
}

final class TradeAdvancedDemoAction {
  const TradeAdvancedDemoAction({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

enum TradeAdvancedMetricTone { neutral, positive, negative, warning, accent }

final class TradeAdvancedDemoMetric {
  const TradeAdvancedDemoMetric({
    required this.label,
    required this.value,
    this.tone = TradeAdvancedMetricTone.neutral,
  });

  final String label;
  final String value;
  final TradeAdvancedMetricTone tone;
}

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
