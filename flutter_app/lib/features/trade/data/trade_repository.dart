import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final tradeRepositoryProvider = Provider<TradeRepository>(
  (_) => const MockTradeRepository(),
);

abstract interface class TradeRepository {
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'});
  TradeOrdersHistorySnapshot getOrdersHistory();
  TradeOrderReceiptSnapshot getOrderReceipt();
  TradeSettingsSnapshot getTradeSettings();
  TradePositionsSnapshot getTradePositions();
  TradeExportSnapshot getTradeExport();
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'});
  TradeConvertSnapshot getConvert();
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'});
  TradeFuturesLeverageSnapshot getFuturesLeverage({String pairId = 'btcusdt'});
  TradeBotsSnapshot getTradingBots();
  TradeRiskManagementSnapshot getRiskManagement();
  TradeExecutionQualitySnapshot getExecutionQuality();
  TradeAdvancedToolsSnapshot getAdvancedTools();
  TradeCopyTradingSnapshot getCopyTrading();
  TradeCopyTradingV2Snapshot getCopyTradingV2();
  TradeCopyEducationSnapshot getCopyEducation();
  TradeActiveCopiesSnapshot getActiveCopies();
  TradeCopySettingsSnapshot getCopySettings();
  TradeCopyNotificationsSnapshot getCopyNotifications();
  TradeProviderApplicationSnapshot getProviderApplication();
  TradeCopyProviderDetailSnapshot getCopyProviderDetail({
    String providerId = 'provider001',
  });
  TradePreCopyAssessmentSnapshot getPreCopyAssessment({
    String providerId = 'provider001',
  });
  TradeCopyConfigurationSnapshot getCopyConfiguration({
    String providerId = 'provider001',
  });
  TradeCopyConfirmationSnapshot getCopyConfirmation({
    String providerId = 'provider001',
  });
  TradeCopyPerformanceSnapshot getCopyPerformance({String copyId = 'copy001'});
  TradePerformanceAttributionSnapshot getPerformanceAttribution({
    String copyId = 'copy001',
  });
  TradeProviderComparisonSnapshot getProviderComparison();
  TradeCopyAuditLogSnapshot getCopyAuditLog({String copyId = 'copy001'});
  TradePortfolioRiskAnalysisSnapshot getPortfolioRiskAnalysis();
  TradeProviderLeaderboardSnapshot getProviderLeaderboard();
  TradeSafetyEducationSnapshot getSafetyEducation();
  TradeProviderGovernanceSnapshot getProviderGovernance();
  TradeDisputeResolutionSnapshot getDisputeResolution();
  TradeCopySafetyCenterSnapshot getCopySafetyCenter();
  TradeRegulatoryDisclosuresSnapshot getRegulatoryDisclosures();
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  });
  TradeTraderProfileSnapshot getTraderProfile({String traderId = 'trader001'});
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo();
  TradeMarketDataAnalyticsSnapshot getMarketDataAnalytics();
  TradeMarginTradingHubSnapshot getMarginTradingHub();
  TradeMarketDataAnalyticsSnapshot getLiveMarketDataAnalytics();
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics();
  TradeTransactionReportingSnapshot getTransactionReporting();
  TradeRegulatoryReportsDashboardSnapshot getRegulatoryReportsDashboard();
  TradeArmIntegrationStatusSnapshot getArmIntegrationStatus();
  TradeBestExecutionReportsSnapshot getBestExecutionReports();
  TradeExecutionVenueAnalysisSnapshot getExecutionVenueAnalysis();
  TradeSlippageMonitoringSnapshot getSlippageMonitoring();
  TradeClientCategorizationSnapshot getClientCategorization();
  TradeProductGovernanceSnapshot getProductGovernance();
  TradeTargetMarketDefinitionSnapshot getTargetMarketDefinition({
    String productId = 'prod-1',
  });
  TradeClientMoneyProtectionSnapshot getClientMoneyProtection();
  TradeCassReconciliationSnapshot getCassReconciliation();
  TradeInvestorCompensationSnapshot getInvestorCompensation();
  TradeExAnteCostsSnapshot getExAnteCosts();
  TradeRiyCalculatorSnapshot getRiyCalculator();
  TradeExPostCostsReportSnapshot getExPostCostsReport();
  TradeKidGeneratorSnapshot getKidGenerator();
  TradePerformanceScenariosSnapshot getPerformanceScenarios();
  TradeRiskIndicatorSnapshot getRiskIndicatorExplainer();
  TradeComplaintsHandlingSnapshot getComplaintsHandling();
  TradeComplaintSubmissionSnapshot getComplaintSubmission();
  TradeComplaintTrackingSnapshot getComplaintTracking({String? complaintId});
  TradeOmbudsmanReferralSnapshot getOmbudsmanReferral();
  TradeAuditTrailSnapshot getAuditTrail();
  TradeRegulatoryInspectionSnapshot getRegulatoryInspectionReady();
  TradeBotTermsSnapshot getBotTermsOfService();
  TradeBotRiskDisclosureSnapshot getBotRiskDisclosure();
  TradeBotSuitabilityAssessmentSnapshot getBotSuitabilityAssessment();
  TradeBotRiskDashboardSnapshot getBotRiskDashboard();
  TradeBotEmergencyStopSnapshot getBotEmergencyStop();
  TradeBotSecuritySettingsSnapshot getBotSecuritySettings();
  TradeBotHistorySnapshot getBotHistory();
  TradeBotPerformanceAnalyticsSnapshot getBotPerformanceAnalytics();
  TradeBotBacktestingSnapshot getBotBacktesting();
  TradeBotStrategyCompareSnapshot getBotStrategyCompare();
  TradeBotOptimizationSnapshot getBotOptimization();
  TradeBotPortfolioDashboardSnapshot getBotPortfolioDashboard();
  TradeBotDrawdownAnalyzerSnapshot getBotDrawdownAnalyzer();
  TradeBotEquityCurveSnapshot getBotEquityCurve();
  TradeBotGuideSnapshot getBotGuide();
  TradeBotFaqSnapshot getBotFaq();
  TradeBotTaxReportingSnapshot getBotTaxReporting();
  TradeBotApiDocumentationSnapshot getBotApiDocumentation();
  TradeSettings patchTradeSettings(TradeSettings settings);
  TradeCopySettingsSaveResult patchCopySettings(TradeCopySettings settings);
  TradeCopyConfigurationPreview previewCopyConfiguration(
    TradeCopyConfigurationDraft draft,
  );
  TradeCopyConfirmationResult submitCopyConfirmation(
    TradeCopyConfirmationRequest request,
  );
  TradeProviderApplicationResult submitProviderApplication(
    TradeProviderApplicationDraft draft,
  );
  TradeCopyAuditExportResult createCopyAuditExport(
    TradeCopyAuditExportRequest request,
  );
  TradeDisputeSubmissionResult submitDisputeComplaint(
    TradeDisputeComplaintDraft draft,
  );
  TradeExportResult createTradeExport(TradeExportRequest request);
  TradeBotTaxReportExportResult createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  );
  TradeExPostCostsReportExportResult createExPostCostsReportExport({
    int year = 2025,
  });
  TradeConvertQuote previewConvert(TradeConvertRequest request);
  TradeConvertReceipt submitConvert(TradeConvertRequest request);
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft);
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft);
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  );
  TradeBotActionResult submitBotAction(TradeBotActionRequest request);
  TradeBotEmergencyStopResult submitBotEmergencyStop(
    TradeBotEmergencyStopDraft draft,
  );
  TradeBotSecuritySettingsResult patchBotSecuritySettings(
    TradeBotSecuritySettingsDraft draft,
  );
  TradeBotHistoryExportResult createBotHistoryExport(
    TradeBotHistoryExportRequest request,
  );
  TradeBotBacktestResult runBotBacktest(TradeBotBacktestRequest request);
  TradeBotOptimizationResult runBotOptimization(
    TradeBotOptimizationRequest request,
  );
  TradeBotCreateResult createTradingBot(TradeBotCreateRequest request);
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft);
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  );
  TradeSlippageSettings updateSlippageSettings(TradeSlippageSettings settings);
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request);
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  );
  TradeCopyActionResult submitCopyTradingAction(TradeCopyActionRequest request);
  TradeOrderPreview previewOrder(TradeOrderDraft draft);
  TradeOrderReceipt submitOrder(TradeOrderDraft draft);
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  });
}

enum TradeScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
  ready,
}

enum TradeOrderSide { buy, sell }

enum TradeOrderType { market, limit, stop }

final class TradeScreenSnapshot {
  const TradeScreenSnapshot({
    required this.pair,
    required this.pairs,
    required this.orderBook,
    required this.trades,
    required this.orders,
    required this.positions,
    required this.copyProviders,
    required this.botStrategies,
    required this.balances,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradePair pair;
  final List<TradePair> pairs;
  final TradeOrderBook orderBook;
  final List<TradeTapePrint> trades;
  final List<TradeOpenOrder> orders;
  final List<TradePosition> positions;
  final List<String> copyProviders;
  final List<String> botStrategies;
  final TradeBalances balances;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradePair {
  const TradePair({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.price,
    required this.changePct,
    required this.logoColorHex,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final double price;
  final double changePct;
  final int logoColorHex;
}

final class TradeOrderBook {
  const TradeOrderBook({required this.bids, required this.asks});

  final List<TradeBookLevel> bids;
  final List<TradeBookLevel> asks;
}

final class TradeBookLevel {
  const TradeBookLevel({
    required this.price,
    required this.amount,
    required this.total,
  });

  final double price;
  final double amount;
  final double total;
}

final class TradeTapePrint {
  const TradeTapePrint({
    required this.price,
    required this.amount,
    required this.time,
    required this.isBuy,
  });

  final double price;
  final double amount;
  final String time;
  final bool isBuy;
}

final class TradeOpenOrder {
  const TradeOpenOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.createdAt,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final TradeOrderType type;
  final double price;
  final double amount;
  final double filled;
  final String createdAt;
}

enum TradeOrderStatus { open, partial, filled, cancelled }

final class TradeOrdersHistorySnapshot {
  const TradeOrdersHistorySnapshot({
    required this.trade,
    required this.openOrders,
    required this.historyOrders,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeHistoryOrder> openOrders;
  final List<TradeHistoryOrder> historyOrders;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

enum TradeReceiptStatus { submitted, pending, partiallyFilled }

final class TradeOrderReceiptSnapshot {
  const TradeOrderReceiptSnapshot({
    required this.trade,
    required this.receipt,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeOrderReceiptDetails receipt;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeOrderReceiptDetails {
  const TradeOrderReceiptDetails({
    required this.orderId,
    required this.symbol,
    required this.baseAsset,
    required this.side,
    required this.orderType,
    required this.price,
    required this.amount,
    required this.total,
    required this.fee,
    required this.feeRate,
    required this.timestamp,
    required this.status,
    this.tpPrice,
    this.slPrice,
    this.estimatedFill,
    this.slippage,
  });

  final String orderId;
  final String symbol;
  final String baseAsset;
  final TradeOrderSide side;
  final String orderType;
  final double price;
  final double amount;
  final double total;
  final double fee;
  final String feeRate;
  final String timestamp;
  final TradeReceiptStatus status;
  final double? tpPrice;
  final double? slPrice;
  final String? estimatedFill;
  final double? slippage;
}

final class TradeSettingsSnapshot {
  const TradeSettingsSnapshot({
    required this.trade,
    required this.settings,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeSettings settings;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeSettings {
  const TradeSettings({
    required this.defaultOrderType,
    required this.defaultSlippage,
    required this.confirmOrders,
    required this.skipConfirmSmall,
    required this.smallOrderThreshold,
    required this.soundOnFill,
    required this.hapticOnFill,
    required this.showTpsl,
    required this.bracketMode,
    required this.priceDecimals,
    required this.defaultPctButtons,
    required this.showOrderBook,
    required this.showRecentTrades,
    required this.chartTimeframe,
  });

  final String defaultOrderType;
  final double defaultSlippage;
  final bool confirmOrders;
  final bool skipConfirmSmall;
  final double smallOrderThreshold;
  final bool soundOnFill;
  final bool hapticOnFill;
  final bool showTpsl;
  final bool bracketMode;
  final String priceDecimals;
  final bool defaultPctButtons;
  final bool showOrderBook;
  final bool showRecentTrades;
  final String chartTimeframe;

  TradeSettings copyWith({
    String? defaultOrderType,
    double? defaultSlippage,
    bool? confirmOrders,
    bool? skipConfirmSmall,
    double? smallOrderThreshold,
    bool? soundOnFill,
    bool? hapticOnFill,
    bool? showTpsl,
    bool? bracketMode,
    String? priceDecimals,
    bool? defaultPctButtons,
    bool? showOrderBook,
    bool? showRecentTrades,
    String? chartTimeframe,
  }) {
    return TradeSettings(
      defaultOrderType: defaultOrderType ?? this.defaultOrderType,
      defaultSlippage: defaultSlippage ?? this.defaultSlippage,
      confirmOrders: confirmOrders ?? this.confirmOrders,
      skipConfirmSmall: skipConfirmSmall ?? this.skipConfirmSmall,
      smallOrderThreshold: smallOrderThreshold ?? this.smallOrderThreshold,
      soundOnFill: soundOnFill ?? this.soundOnFill,
      hapticOnFill: hapticOnFill ?? this.hapticOnFill,
      showTpsl: showTpsl ?? this.showTpsl,
      bracketMode: bracketMode ?? this.bracketMode,
      priceDecimals: priceDecimals ?? this.priceDecimals,
      defaultPctButtons: defaultPctButtons ?? this.defaultPctButtons,
      showOrderBook: showOrderBook ?? this.showOrderBook,
      showRecentTrades: showRecentTrades ?? this.showRecentTrades,
      chartTimeframe: chartTimeframe ?? this.chartTimeframe,
    );
  }
}

enum TradePositionType { spot, futures, margin }

enum TradePositionSide { long, short }

final class TradePositionsSnapshot {
  const TradePositionsSnapshot({
    required this.trade,
    required this.positions,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeDashboardPosition> positions;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExportSnapshot {
  const TradeExportSnapshot({
    required this.trade,
    required this.stats,
    required this.formats,
    required this.periods,
    required this.includes,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeExportStats stats;
  final List<TradeExportFormat> formats;
  final List<TradeExportPeriod> periods;
  final List<TradeExportInclude> includes;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExportStats {
  const TradeExportStats({
    required this.totalTrades,
    required this.totalVolume,
    required this.totalFees,
    required this.netPnl,
  });

  final int totalTrades;
  final double totalVolume;
  final double totalFees;
  final double netPnl;
}

final class TradeExportFormat {
  const TradeExportFormat({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeExportPeriod {
  const TradeExportPeriod({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeExportInclude {
  const TradeExportInclude({
    required this.id,
    required this.label,
    required this.checked,
  });

  final String id;
  final String label;
  final bool checked;

  TradeExportInclude copyWith({bool? checked}) {
    return TradeExportInclude(
      id: id,
      label: label,
      checked: checked ?? this.checked,
    );
  }
}

final class TradeExportRequest {
  const TradeExportRequest({
    required this.format,
    required this.period,
    required this.includeIds,
  });

  final String format;
  final String period;
  final List<String> includeIds;
}

final class TradeExportResult {
  const TradeExportResult({
    required this.exportId,
    required this.format,
    required this.status,
    required this.downloadUrl,
  });

  final String exportId;
  final String format;
  final String status;
  final String downloadUrl;
}

final class TradeAdvancedChartSnapshot {
  const TradeAdvancedChartSnapshot({
    required this.trade,
    required this.pair,
    required this.candles,
    required this.indicators,
    required this.timeframes,
    required this.chartTypes,
    required this.ohlcv,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradePair pair;
  final List<TradeCandle> candles;
  final List<TradeChartIndicator> indicators;
  final List<String> timeframes;
  final List<String> chartTypes;
  final TradeOhlcv ohlcv;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCandle {
  const TradeCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  final String time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
}

final class TradeChartIndicator {
  const TradeChartIndicator({
    required this.id,
    required this.label,
    required this.colorHex,
    required this.enabled,
    this.period,
  });

  final String id;
  final String label;
  final int colorHex;
  final bool enabled;
  final int? period;

  TradeChartIndicator copyWith({bool? enabled}) {
    return TradeChartIndicator(
      id: id,
      label: label,
      colorHex: colorHex,
      enabled: enabled ?? this.enabled,
      period: period,
    );
  }
}

final class TradeOhlcv {
  const TradeOhlcv({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volumeLabel,
  });

  final double open;
  final double high;
  final double low;
  final double close;
  final String volumeLabel;
}

final class TradeConvertSnapshot {
  const TradeConvertSnapshot({
    required this.trade,
    required this.assets,
    required this.favoritePairs,
    required this.history,
    required this.slippageOptions,
    required this.fromAsset,
    required this.toAsset,
    required this.rateLabel,
    required this.countdownLabel,
    required this.minUsd,
    required this.maxUsd,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeConvertAsset> assets;
  final List<TradeConvertFavoritePair> favoritePairs;
  final List<TradeConvertHistoryRecord> history;
  final List<double> slippageOptions;
  final TradeConvertAsset fromAsset;
  final TradeConvertAsset toAsset;
  final String rateLabel;
  final String countdownLabel;
  final double minUsd;
  final double maxUsd;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeConvertAsset {
  const TradeConvertAsset({
    required this.symbol,
    required this.name,
    required this.balance,
    required this.priceUsd,
    required this.colorHex,
  });

  final String symbol;
  final String name;
  final double balance;
  final double priceUsd;
  final int colorHex;
}

final class TradeConvertFavoritePair {
  const TradeConvertFavoritePair({
    required this.fromSymbol,
    required this.toSymbol,
  });

  final String fromSymbol;
  final String toSymbol;

  String get label => '$fromSymbol/$toSymbol';
}

final class TradeConvertHistoryRecord {
  const TradeConvertHistoryRecord({
    required this.id,
    required this.fromSymbol,
    required this.toSymbol,
    required this.fromAmount,
    required this.toAmount,
    required this.feeUsd,
    required this.rate,
    required this.timeLabel,
    required this.status,
  });

  final String id;
  final String fromSymbol;
  final String toSymbol;
  final double fromAmount;
  final double toAmount;
  final double feeUsd;
  final double rate;
  final String timeLabel;
  final String status;
}

final class TradeConvertRequest {
  const TradeConvertRequest({
    required this.fromSymbol,
    required this.toSymbol,
    required this.amount,
    required this.slippagePct,
    required this.mode,
  });

  final String fromSymbol;
  final String toSymbol;
  final double amount;
  final double slippagePct;
  final String mode;
}

final class TradeConvertQuote {
  const TradeConvertQuote({
    required this.fromSymbol,
    required this.toSymbol,
    required this.fromAmount,
    required this.toAmount,
    required this.feeUsd,
    required this.rate,
    required this.quoteLabel,
    required this.validSeconds,
    required this.canSubmit,
  });

  final String fromSymbol;
  final String toSymbol;
  final double fromAmount;
  final double toAmount;
  final double feeUsd;
  final double rate;
  final String quoteLabel;
  final int validSeconds;
  final bool canSubmit;
}

final class TradeConvertReceipt {
  const TradeConvertReceipt({
    required this.convertId,
    required this.quote,
    required this.status,
  });

  final String convertId;
  final TradeConvertQuote quote;
  final String status;
}

enum TradeFuturesSide { long, short }

enum TradeFuturesOrderType { market, limit }

final class TradeFuturesSnapshot {
  const TradeFuturesSnapshot({
    required this.trade,
    required this.pair,
    required this.positions,
    required this.leverages,
    required this.markPrice,
    required this.indexPrice,
    required this.fundingRate,
    required this.accountBalance,
    required this.usedMargin,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradePair pair;
  final List<TradeFuturesPosition> positions;
  final List<int> leverages;
  final double markPrice;
  final double indexPrice;
  final double fundingRate;
  final double accountBalance;
  final double usedMargin;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeFuturesPosition {
  const TradeFuturesPosition({
    required this.id,
    required this.symbol,
    required this.side,
    required this.leverage,
    required this.size,
    required this.entryPrice,
    required this.markPrice,
    required this.liquidPrice,
    required this.pnl,
    required this.pnlPct,
    required this.margin,
    required this.roe,
  });

  final String id;
  final String symbol;
  final TradeFuturesSide side;
  final int leverage;
  final double size;
  final double entryPrice;
  final double markPrice;
  final double liquidPrice;
  final double pnl;
  final double pnlPct;
  final double margin;
  final double roe;
}

final class TradeFuturesOrderDraft {
  const TradeFuturesOrderDraft({
    required this.pairId,
    required this.side,
    required this.type,
    required this.margin,
    required this.leverage,
    this.limitPrice,
    this.takeProfit,
    this.stopLoss,
  });

  final String pairId;
  final TradeFuturesSide side;
  final TradeFuturesOrderType type;
  final double margin;
  final int leverage;
  final double? limitPrice;
  final double? takeProfit;
  final double? stopLoss;
}

final class TradeFuturesPreview {
  const TradeFuturesPreview({
    required this.positionSize,
    required this.contractQty,
    required this.liquidationPrice,
    required this.openFee,
    required this.canOpen,
  });

  final double positionSize;
  final double contractQty;
  final double liquidationPrice;
  final double openFee;
  final bool canOpen;
}

final class TradeFuturesReceipt {
  const TradeFuturesReceipt({
    required this.orderId,
    required this.preview,
    required this.status,
  });

  final String orderId;
  final TradeFuturesPreview preview;
  final String status;
}

final class TradeFuturesLeverageSnapshot {
  const TradeFuturesLeverageSnapshot({
    required this.futures,
    required this.currentLeverage,
    required this.presets,
    required this.sliderStops,
    required this.exampleMargin,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeFuturesSnapshot futures;
  final int currentLeverage;
  final List<int> presets;
  final List<int> sliderStops;
  final double exampleMargin;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeFuturesLeverageRequest {
  const TradeFuturesLeverageRequest({
    required this.pairId,
    required this.leverage,
    this.exampleMargin = 100,
  });

  final String pairId;
  final int leverage;
  final double exampleMargin;
}

final class TradeFuturesLeveragePreview {
  const TradeFuturesLeveragePreview({
    required this.leverage,
    required this.riskLabel,
    required this.riskLevel,
    required this.riskColorHex,
    required this.positionSize,
    required this.liquidationDistancePct,
    required this.openFee,
    required this.profitAtOnePct,
    required this.lossAtOnePct,
    required this.warningText,
    required this.showRiskTips,
  });

  final int leverage;
  final String riskLabel;
  final int riskLevel;
  final int riskColorHex;
  final double positionSize;
  final double liquidationDistancePct;
  final double openFee;
  final double profitAtOnePct;
  final double lossAtOnePct;
  final String warningText;
  final bool showRiskTips;
}

final class TradeFuturesLeverageReceipt {
  const TradeFuturesLeverageReceipt({
    required this.adjustmentId,
    required this.pairId,
    required this.preview,
    required this.status,
  });

  final String adjustmentId;
  final String pairId;
  final TradeFuturesLeveragePreview preview;
  final String status;
}

enum TradeBotRisk { low, medium, high }

enum TradeBotStatus { running, paused, stopped }

final class TradeBotsSnapshot {
  const TradeBotsSnapshot({
    required this.trade,
    required this.strategies,
    required this.activeBots,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeBotStrategy> strategies;
  final List<TradeBot> activeBots;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  int get runningCount =>
      activeBots.where((bot) => bot.status == TradeBotStatus.running).length;

  double get totalInvestment =>
      activeBots.fold(0.0, (sum, bot) => sum + bot.investment);

  double get totalProfit =>
      activeBots.fold(0.0, (sum, bot) => sum + bot.profit);
}

final class TradeBotStrategy {
  const TradeBotStrategy({
    required this.id,
    required this.name,
    required this.description,
    required this.longDescription,
    required this.icon,
    required this.colorHex,
    required this.risk,
    required this.avgReturn,
    required this.suitableFor,
    required this.params,
  });

  final String id;
  final String name;
  final String description;
  final String longDescription;
  final String icon;
  final int colorHex;
  final TradeBotRisk risk;
  final String avgReturn;
  final String suitableFor;
  final List<TradeBotParam> params;
}

final class TradeBotParam {
  const TradeBotParam({
    required this.key,
    required this.label,
    required this.type,
    required this.defaultValue,
    this.options = const [],
    this.unit,
  });

  final String key;
  final String label;
  final String type;
  final String defaultValue;
  final List<String> options;
  final String? unit;
}

final class TradeBot {
  const TradeBot({
    required this.id,
    required this.strategyId,
    required this.strategyName,
    required this.icon,
    required this.colorHex,
    required this.pair,
    required this.status,
    required this.profit,
    required this.profitPct,
    required this.trades,
    required this.investment,
    required this.startDate,
    required this.runtime,
  });

  final String id;
  final String strategyId;
  final String strategyName;
  final String icon;
  final int colorHex;
  final String pair;
  final TradeBotStatus status;
  final double profit;
  final double profitPct;
  final int trades;
  final double investment;
  final String startDate;
  final String runtime;

  TradeBot copyWith({TradeBotStatus? status}) {
    return TradeBot(
      id: id,
      strategyId: strategyId,
      strategyName: strategyName,
      icon: icon,
      colorHex: colorHex,
      pair: pair,
      status: status ?? this.status,
      profit: profit,
      profitPct: profitPct,
      trades: trades,
      investment: investment,
      startDate: startDate,
      runtime: runtime,
    );
  }
}

final class TradeBotActionRequest {
  const TradeBotActionRequest({required this.botId, required this.action});

  final String botId;
  final String action;
}

final class TradeBotActionResult {
  const TradeBotActionResult({
    required this.botId,
    required this.action,
    required this.status,
  });

  final String botId;
  final String action;
  final String status;
}

final class TradeBotCreateRequest {
  const TradeBotCreateRequest({required this.strategyId, required this.params});

  final String strategyId;
  final Map<String, String> params;
}

final class TradeBotCreateResult {
  const TradeBotCreateResult({
    required this.botId,
    required this.strategyId,
    required this.status,
  });

  final String botId;
  final String strategyId;
  final String status;
}

enum TradeRiskPositionSide { long, short }

final class TradeRiskManagementSnapshot {
  const TradeRiskManagementSnapshot({
    required this.trade,
    required this.features,
    required this.positions,
    required this.statusItems,
    required this.accountBalance,
    required this.currentPrice,
    required this.availableBalance,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeRiskFeature> features;
  final List<TradeRiskPosition> positions;
  final List<TradeRiskStatusItem> statusItems;
  final double accountBalance;
  final double currentPrice;
  final double availableBalance;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeRiskFeature {
  const TradeRiskFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeRiskPosition {
  const TradeRiskPosition({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.logoColorHex,
    required this.side,
    required this.amount,
    required this.entryPrice,
    required this.currentPrice,
    required this.openedAtLabel,
    this.leverage,
    this.liquidationPrice,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final int logoColorHex;
  final TradeRiskPositionSide side;
  final double amount;
  final double entryPrice;
  final double currentPrice;
  final String openedAtLabel;
  final int? leverage;
  final double? liquidationPrice;

  double get pnl {
    final direction = side == TradeRiskPositionSide.long ? 1 : -1;
    return (currentPrice - entryPrice) * amount * direction;
  }

  double get pnlPct {
    final basis = entryPrice * amount;
    if (basis <= 0) return 0;
    return pnl / basis * 100;
  }
}

final class TradeRiskStatusItem {
  const TradeRiskStatusItem({required this.label, required this.complete});

  final String label;
  final bool complete;
}

final class TradeOcoOrderDraft {
  const TradeOcoOrderDraft({
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.limitPrice,
    required this.takeProfitPrice,
    required this.stopPrice,
  });

  final String symbol;
  final TradeOrderSide side;
  final double quantity;
  final double limitPrice;
  final double takeProfitPrice;
  final double stopPrice;
}

final class TradeOcoOrderResult {
  const TradeOcoOrderResult({
    required this.orderId,
    required this.symbol,
    required this.status,
  });

  final String orderId;
  final String symbol;
  final String status;
}

final class TradePositionSizeRequest {
  const TradePositionSizeRequest({
    required this.accountBalance,
    required this.riskPct,
    required this.entryPrice,
    required this.stopPrice,
  });

  final double accountBalance;
  final double riskPct;
  final double entryPrice;
  final double stopPrice;
}

final class TradePositionSizeResult {
  const TradePositionSizeResult({
    required this.riskAmount,
    required this.perUnitRisk,
    required this.suggestedAmount,
    required this.notional,
  });

  final double riskAmount;
  final double perUnitRisk;
  final double suggestedAmount;
  final double notional;
}

final class TradeExecutionQualitySnapshot {
  const TradeExecutionQualitySnapshot({
    required this.trade,
    required this.features,
    required this.report,
    required this.openOrder,
    required this.slippageSettings,
    required this.statusItems,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeExecutionFeature> features;
  final TradeExecutionReport report;
  final TradeExecutionOpenOrder openOrder;
  final TradeSlippageSettings slippageSettings;
  final List<TradeRiskStatusItem> statusItems;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeExecutionFeature {
  const TradeExecutionFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeExecutionReport {
  const TradeExecutionReport({
    required this.orderId,
    required this.symbol,
    required this.side,
    required this.requestedAmount,
    required this.filledAmount,
    required this.expectedPrice,
    required this.averageFillPrice,
    required this.bestAvailablePrice,
    required this.executionTimeMs,
    required this.slippagePct,
    required this.savingsVsSingleVenue,
    required this.executionQuality,
    required this.fills,
  });

  final String orderId;
  final String symbol;
  final TradeOrderSide side;
  final double requestedAmount;
  final double filledAmount;
  final double expectedPrice;
  final double averageFillPrice;
  final double bestAvailablePrice;
  final int executionTimeMs;
  final double slippagePct;
  final double savingsVsSingleVenue;
  final String executionQuality;
  final List<TradeExecutionFill> fills;
}

final class TradeExecutionFill {
  const TradeExecutionFill({
    required this.venue,
    required this.amount,
    required this.price,
    required this.fee,
    required this.timestampLabel,
  });

  final String venue;
  final double amount;
  final double price;
  final double fee;
  final String timestampLabel;
}

final class TradeExecutionOpenOrder {
  const TradeExecutionOpenOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.remaining,
    required this.queuePosition,
    required this.totalInQueue,
    required this.supportsAmend,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final String type;
  final double price;
  final double amount;
  final double filled;
  final double remaining;
  final int queuePosition;
  final int totalInQueue;
  final bool supportsAmend;
}

final class TradeSlippageSettings {
  const TradeSlippageSettings({
    required this.tolerancePct,
    required this.rejectOnExceed,
    required this.partialFillAllowed,
  });

  final double tolerancePct;
  final bool rejectOnExceed;
  final bool partialFillAllowed;
}

final class TradeOrderAmendmentRequest {
  const TradeOrderAmendmentRequest({
    required this.orderId,
    required this.newPrice,
    required this.newAmount,
  });

  final String orderId;
  final double newPrice;
  final double newAmount;
}

final class TradeOrderAmendmentResult {
  const TradeOrderAmendmentResult({
    required this.orderId,
    required this.status,
    required this.queuePositionPreserved,
  });

  final String orderId;
  final String status;
  final bool queuePositionPreserved;
}

final class TradeAdvancedToolsSnapshot {
  const TradeAdvancedToolsSnapshot({
    required this.trade,
    required this.features,
    required this.ladderOrders,
    required this.bulkOrders,
    required this.shortcuts,
    required this.statusItems,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeAdvancedToolFeature> features;
  final List<TradeLadderOrder> ladderOrders;
  final List<TradeBulkOrder> bulkOrders;
  final List<TradeShortcut> shortcuts;
  final List<TradeRiskStatusItem> statusItems;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeAdvancedToolFeature {
  const TradeAdvancedToolFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String iconName;
}

final class TradeLadderOrder {
  const TradeLadderOrder({
    required this.id,
    required this.price,
    required this.amount,
    required this.side,
    required this.filled,
  });

  final String id;
  final double price;
  final double amount;
  final TradeOrderSide side;
  final double filled;
}

final class TradeBulkOrder {
  const TradeBulkOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
    required this.filled,
    required this.remaining,
    required this.totalValue,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final String type;
  final double price;
  final double amount;
  final double filled;
  final double remaining;
  final double totalValue;
}

final class TradeShortcut {
  const TradeShortcut({
    required this.id,
    required this.keys,
    required this.label,
    required this.description,
  });

  final String id;
  final String keys;
  final String label;
  final String description;
}

final class TradeAdvancedToolActionRequest {
  const TradeAdvancedToolActionRequest({
    required this.toolId,
    required this.action,
    this.orderIds = const [],
  });

  final String toolId;
  final String action;
  final List<String> orderIds;
}

final class TradeAdvancedToolActionResult {
  const TradeAdvancedToolActionResult({
    required this.toolId,
    required this.action,
    required this.status,
    required this.affectedCount,
  });

  final String toolId;
  final String action;
  final String status;
  final int affectedCount;
}

enum TradeCopyRiskLevel { low, medium, high }

final class TradeCopyTradingSnapshot {
  const TradeCopyTradingSnapshot({
    required this.trade,
    required this.traders,
    required this.sortOptions,
    required this.totalCopiers,
    required this.totalAum,
    required this.aumTrendPct,
    required this.riskWarningTitle,
    required this.riskWarningText,
    required this.disclaimer,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyTrader> traders;
  final List<String> sortOptions;
  final int totalCopiers;
  final double totalAum;
  final double aumTrendPct;
  final String riskWarningTitle;
  final String riskWarningText;
  final String disclaimer;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyTradingV2Snapshot {
  const TradeCopyTradingV2Snapshot({
    required this.copyTrading,
    required this.heroVariants,
    required this.defaultHeroVariant,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeCopyTradingSnapshot copyTrading;
  final List<String> heroVariants;
  final String defaultHeroVariant;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyEducationSnapshot {
  const TradeCopyEducationSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTab,
    required this.introTitle,
    required this.introDescription,
    required this.steps,
    required this.copyModes,
    required this.concepts,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyEducationTab> tabs;
  final String defaultTab;
  final String introTitle;
  final String introDescription;
  final List<TradeCopyEducationStep> steps;
  final List<TradeCopyModeGuide> copyModes;
  final List<TradeCopyConceptGuide> concepts;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyEducationTab {
  const TradeCopyEducationTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeCopyEducationStep {
  const TradeCopyEducationStep({
    required this.number,
    required this.iconName,
    required this.title,
    required this.description,
  });

  final int number;
  final String iconName;
  final String title;
  final String description;
}

final class TradeCopyModeGuide {
  const TradeCopyModeGuide({
    required this.title,
    required this.description,
    required this.pro,
    required this.con,
    required this.colorHex,
  });

  final String title;
  final String description;
  final String pro;
  final String con;
  final int colorHex;
}

final class TradeCopyConceptGuide {
  const TradeCopyConceptGuide({
    required this.term,
    required this.description,
    required this.iconName,
  });

  final String term;
  final String description;
  final String iconName;
}

enum TradeActiveCopyStatus { active, coolingOff, paused, stopped }

enum TradeActiveCopyMode { mirror, fixed, smart }

enum TradeCopySettingsMode { mirror, fixed, smart }

final class TradeActiveCopiesSnapshot {
  const TradeActiveCopiesSnapshot({
    required this.trade,
    required this.portfolio,
    required this.tabs,
    required this.defaultTab,
    required this.copies,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeActiveCopyPortfolio portfolio;
  final List<TradeActiveCopiesTab> tabs;
  final String defaultTab;
  final List<TradeActiveCopy> copies;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeActiveCopyPortfolio {
  const TradeActiveCopyPortfolio({
    required this.totalCapital,
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.activeCopies,
    required this.totalCopies,
  });

  final double totalCapital;
  final double totalValue;
  final double totalPnl;
  final double totalPnlPct;
  final int activeCopies;
  final int totalCopies;
}

final class TradeActiveCopiesTab {
  const TradeActiveCopiesTab({
    required this.id,
    required this.label,
    this.badge,
  });

  final String id;
  final String label;
  final int? badge;
}

final class TradeActiveCopy {
  const TradeActiveCopy({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.providerVerified,
    required this.capital,
    required this.currentValue,
    required this.pnl,
    required this.pnlPct,
    required this.status,
    required this.startDate,
    required this.copyMode,
    required this.trades,
    required this.winRate,
    required this.hasCustomStopLoss,
    required this.recentTrades,
    required this.performanceHistory,
    this.copyRatio,
    this.stopLossLevel,
    this.coolingOffUntil,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final bool providerVerified;
  final double capital;
  final double currentValue;
  final double pnl;
  final double pnlPct;
  final TradeActiveCopyStatus status;
  final String startDate;
  final TradeActiveCopyMode copyMode;
  final double? copyRatio;
  final int trades;
  final double winRate;
  final bool hasCustomStopLoss;
  final double? stopLossLevel;
  final String? coolingOffUntil;
  final List<TradeCopyRecentTrade> recentTrades;
  final List<TradeCopyPerformancePoint> performanceHistory;
}

final class TradeCopyRecentTrade {
  const TradeCopyRecentTrade({
    required this.id,
    required this.pair,
    required this.side,
    required this.size,
    required this.price,
    required this.pnl,
    required this.timestamp,
  });

  final String id;
  final String pair;
  final TradeOrderSide side;
  final double size;
  final double price;
  final double pnl;
  final String timestamp;
}

final class TradeCopyPerformancePoint {
  const TradeCopyPerformancePoint({
    required this.timestamp,
    required this.value,
  });

  final String timestamp;
  final double value;
}

final class TradeCopySettingsSnapshot {
  const TradeCopySettingsSnapshot({
    required this.trade,
    required this.settings,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final TradeCopySettings settings;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopySettings {
  const TradeCopySettings({
    required this.defaultCopyMode,
    required this.defaultCopyRatio,
    required this.defaultStopLoss,
    required this.defaultTakeProfit,
    required this.maxPortfolioAllocation,
    required this.maxCopiesActive,
    required this.enableCircuitBreaker,
    required this.circuitBreakerThreshold,
    required this.notifyNewTrades,
    required this.notifyPnlChanges,
    required this.notifyRiskAlerts,
    required this.notifyProviderUpdates,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.showPortfolioPublic,
  });

  final TradeCopySettingsMode defaultCopyMode;
  final double defaultCopyRatio;
  final double defaultStopLoss;
  final double defaultTakeProfit;
  final double maxPortfolioAllocation;
  final int maxCopiesActive;
  final bool enableCircuitBreaker;
  final double circuitBreakerThreshold;
  final bool notifyNewTrades;
  final bool notifyPnlChanges;
  final bool notifyRiskAlerts;
  final bool notifyProviderUpdates;
  final bool emailNotifications;
  final bool pushNotifications;
  final String emergencyContact;
  final String emergencyPhone;
  final bool showPortfolioPublic;

  TradeCopySettings copyWith({
    TradeCopySettingsMode? defaultCopyMode,
    double? defaultCopyRatio,
    double? defaultStopLoss,
    double? defaultTakeProfit,
    double? maxPortfolioAllocation,
    int? maxCopiesActive,
    bool? enableCircuitBreaker,
    double? circuitBreakerThreshold,
    bool? notifyNewTrades,
    bool? notifyPnlChanges,
    bool? notifyRiskAlerts,
    bool? notifyProviderUpdates,
    bool? emailNotifications,
    bool? pushNotifications,
    String? emergencyContact,
    String? emergencyPhone,
    bool? showPortfolioPublic,
  }) {
    return TradeCopySettings(
      defaultCopyMode: defaultCopyMode ?? this.defaultCopyMode,
      defaultCopyRatio: defaultCopyRatio ?? this.defaultCopyRatio,
      defaultStopLoss: defaultStopLoss ?? this.defaultStopLoss,
      defaultTakeProfit: defaultTakeProfit ?? this.defaultTakeProfit,
      maxPortfolioAllocation:
          maxPortfolioAllocation ?? this.maxPortfolioAllocation,
      maxCopiesActive: maxCopiesActive ?? this.maxCopiesActive,
      enableCircuitBreaker: enableCircuitBreaker ?? this.enableCircuitBreaker,
      circuitBreakerThreshold:
          circuitBreakerThreshold ?? this.circuitBreakerThreshold,
      notifyNewTrades: notifyNewTrades ?? this.notifyNewTrades,
      notifyPnlChanges: notifyPnlChanges ?? this.notifyPnlChanges,
      notifyRiskAlerts: notifyRiskAlerts ?? this.notifyRiskAlerts,
      notifyProviderUpdates:
          notifyProviderUpdates ?? this.notifyProviderUpdates,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      showPortfolioPublic: showPortfolioPublic ?? this.showPortfolioPublic,
    );
  }
}

final class TradeCopySettingsSaveResult {
  const TradeCopySettingsSaveResult({
    required this.status,
    required this.settings,
  });

  final String status;
  final TradeCopySettings settings;
}

enum TradeCopyNotificationType { trade, risk, update, system }

enum TradeCopyNotificationSeverity { info, warning, critical }

final class TradeCopyNotificationsSnapshot {
  const TradeCopyNotificationsSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTab,
    required this.notifications,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyNotificationTab> tabs;
  final String defaultTab;
  final List<TradeCopyNotification> notifications;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyNotificationTab {
  const TradeCopyNotificationTab({
    required this.id,
    required this.label,
    this.badge,
  });

  final String id;
  final String label;
  final int? badge;
}

final class TradeCopyNotification {
  const TradeCopyNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.severity,
    this.providerId,
    this.providerName,
    this.copyId,
    this.actionPath,
    this.pnl,
    this.pair,
    this.side,
  });

  final String id;
  final TradeCopyNotificationType type;
  final String title;
  final String message;
  final String timestamp;
  final bool read;
  final TradeCopyNotificationSeverity severity;
  final String? providerId;
  final String? providerName;
  final String? copyId;
  final String? actionPath;
  final double? pnl;
  final String? pair;
  final TradeOrderSide? side;

  TradeCopyNotification copyWith({bool? read}) {
    return TradeCopyNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      read: read ?? this.read,
      severity: severity,
      providerId: providerId,
      providerName: providerName,
      copyId: copyId,
      actionPath: actionPath,
      pnl: pnl,
      pair: pair,
      side: side,
    );
  }
}

enum TradeProviderApplicationStep {
  intro,
  requirements,
  disclosure,
  fees,
  review,
}

final class TradeProviderApplicationSnapshot {
  const TradeProviderApplicationSnapshot({
    required this.trade,
    required this.steps,
    required this.defaultStep,
    required this.benefits,
    required this.requirements,
    required this.responsibilities,
    required this.defaultDraft,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderApplicationStep> steps;
  final TradeProviderApplicationStep defaultStep;
  final List<TradeProviderBenefit> benefits;
  final List<TradeProviderRequirement> requirements;
  final List<String> responsibilities;
  final TradeProviderApplicationDraft defaultDraft;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeProviderBenefit {
  const TradeProviderBenefit({
    required this.iconName,
    required this.title,
    required this.description,
  });

  final String iconName;
  final String title;
  final String description;
}

final class TradeProviderRequirement {
  const TradeProviderRequirement({required this.label, required this.met});

  final String label;
  final bool met;
}

final class TradeProviderApplicationDraft {
  const TradeProviderApplicationDraft({
    required this.hasKyc,
    required this.tradingMonths,
    required this.minCapital,
    required this.performanceFee,
    required this.agreedToDisclosure,
    required this.agreedToFiduciary,
    required this.agreedToTerms,
    required this.strategyDescription,
  });

  final bool hasKyc;
  final int tradingMonths;
  final int minCapital;
  final int performanceFee;
  final bool agreedToDisclosure;
  final bool agreedToFiduciary;
  final bool agreedToTerms;
  final String strategyDescription;

  TradeProviderApplicationDraft copyWith({
    bool? hasKyc,
    int? tradingMonths,
    int? minCapital,
    int? performanceFee,
    bool? agreedToDisclosure,
    bool? agreedToFiduciary,
    bool? agreedToTerms,
    String? strategyDescription,
  }) {
    return TradeProviderApplicationDraft(
      hasKyc: hasKyc ?? this.hasKyc,
      tradingMonths: tradingMonths ?? this.tradingMonths,
      minCapital: minCapital ?? this.minCapital,
      performanceFee: performanceFee ?? this.performanceFee,
      agreedToDisclosure: agreedToDisclosure ?? this.agreedToDisclosure,
      agreedToFiduciary: agreedToFiduciary ?? this.agreedToFiduciary,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      strategyDescription: strategyDescription ?? this.strategyDescription,
    );
  }
}

final class TradeProviderApplicationResult {
  const TradeProviderApplicationResult({
    required this.applicationId,
    required this.status,
    required this.reviewWindow,
  });

  final String applicationId;
  final String status;
  final String reviewWindow;
}

final class TradeCopyProviderDetailSnapshot {
  const TradeCopyProviderDetailSnapshot({
    required this.providerId,
    required this.provider,
    required this.supportedStates,
    required this.lastUpdatedLabel,
    this.notFoundMessage = 'Provider không tồn tại',
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
  final String notFoundMessage;

  bool get isNotFound => provider == null;
}

final class TradePreCopyAssessmentSnapshot {
  const TradePreCopyAssessmentSnapshot({
    required this.providerId,
    required this.provider,
    required this.questions,
    required this.educationDocs,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final List<TradePreCopyQuestion> questions;
  final List<TradePreCopyEducationDoc> educationDocs;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradePreCopyQuestion {
  const TradePreCopyQuestion({
    required this.id,
    required this.question,
    required this.description,
    required this.options,
  });

  final String id;
  final String question;
  final String description;
  final List<TradePreCopyOption> options;
}

final class TradePreCopyOption {
  const TradePreCopyOption({
    required this.value,
    required this.label,
    required this.score,
  });

  final String value;
  final String label;
  final int score;
}

final class TradePreCopyEducationDoc {
  const TradePreCopyEducationDoc({
    required this.id,
    required this.title,
    required this.duration,
  });

  final String id;
  final String title;
  final String duration;
}

enum TradeCopyConfigurationMode { mirror, fixed, smart }

enum TradePositionSizingMethod { percentage, fixedAmount, riskBased }

enum TradeCopyConfigurationValidationLevel { error, warning, info }

final class TradeCopyConfigurationSnapshot {
  const TradeCopyConfigurationSnapshot({
    required this.providerId,
    required this.provider,
    required this.defaultDraft,
    required this.totalPortfolio,
    required this.currentCopyAllocation,
    required this.availableCapital,
    required this.feePreview,
    required this.validations,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final TradeCopyConfigurationDraft defaultDraft;
  final double totalPortfolio;
  final double currentCopyAllocation;
  final double availableCapital;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyConfigurationValidation> validations;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradeCopyConfigurationDraft {
  const TradeCopyConfigurationDraft({
    required this.providerId,
    required this.copyCapital,
    required this.copyMode,
    required this.positionSizing,
    required this.copyRatio,
    required this.useCustomStopLoss,
    required this.customStopLoss,
    required this.useCustomTakeProfit,
    required this.customTakeProfit,
    required this.useTrailingStop,
    required this.trailingStopPercent,
  });

  final String providerId;
  final double copyCapital;
  final TradeCopyConfigurationMode copyMode;
  final TradePositionSizingMethod positionSizing;
  final double copyRatio;
  final bool useCustomStopLoss;
  final double customStopLoss;
  final bool useCustomTakeProfit;
  final double customTakeProfit;
  final bool useTrailingStop;
  final double trailingStopPercent;

  TradeCopyConfigurationDraft copyWith({
    double? copyCapital,
    TradeCopyConfigurationMode? copyMode,
    TradePositionSizingMethod? positionSizing,
    double? copyRatio,
    bool? useCustomStopLoss,
    double? customStopLoss,
    bool? useCustomTakeProfit,
    double? customTakeProfit,
    bool? useTrailingStop,
    double? trailingStopPercent,
  }) {
    return TradeCopyConfigurationDraft(
      providerId: providerId,
      copyCapital: copyCapital ?? this.copyCapital,
      copyMode: copyMode ?? this.copyMode,
      positionSizing: positionSizing ?? this.positionSizing,
      copyRatio: copyRatio ?? this.copyRatio,
      useCustomStopLoss: useCustomStopLoss ?? this.useCustomStopLoss,
      customStopLoss: customStopLoss ?? this.customStopLoss,
      useCustomTakeProfit: useCustomTakeProfit ?? this.useCustomTakeProfit,
      customTakeProfit: customTakeProfit ?? this.customTakeProfit,
      useTrailingStop: useTrailingStop ?? this.useTrailingStop,
      trailingStopPercent: trailingStopPercent ?? this.trailingStopPercent,
    );
  }
}

final class TradeCopyConfigurationFeePreview {
  const TradeCopyConfigurationFeePreview({
    required this.platformFee,
    required this.estimatedTradingFees,
    required this.performanceFeeNote,
  });

  final double platformFee;
  final double estimatedTradingFees;
  final String performanceFeeNote;

  double get totalFixedFees => platformFee + estimatedTradingFees;
}

final class TradeCopyConfigurationValidation {
  const TradeCopyConfigurationValidation({
    required this.level,
    required this.message,
  });

  final TradeCopyConfigurationValidationLevel level;
  final String message;
}

final class TradeCopyConfigurationPreview {
  const TradeCopyConfigurationPreview({
    required this.providerId,
    required this.status,
    required this.draft,
    required this.feePreview,
    required this.validations,
  });

  final String providerId;
  final String status;
  final TradeCopyConfigurationDraft draft;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyConfigurationValidation> validations;

  bool get hasBlockingErrors => validations.any(
    (item) => item.level == TradeCopyConfigurationValidationLevel.error,
  );
}

final class TradeCopyConfirmationSnapshot {
  const TradeCopyConfirmationSnapshot({
    required this.providerId,
    required this.provider,
    required this.configuration,
    required this.feePreview,
    required this.scenarios,
    required this.maxLossAmount,
    required this.consentItems,
    required this.coolingOffHours,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String providerId;
  final TradeCopyTrader? provider;
  final TradeCopyConfigurationDraft configuration;
  final TradeCopyConfigurationFeePreview feePreview;
  final List<TradeCopyScenarioProjection> scenarios;
  final double maxLossAmount;
  final List<TradeCopyConsentItem> consentItems;
  final int coolingOffHours;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;

  bool get isNotFound => provider == null;
}

final class TradeCopyScenarioProjection {
  const TradeCopyScenarioProjection({
    required this.id,
    required this.title,
    required this.returnPct,
    required this.grossPnl,
    required this.performanceFee,
    required this.slippageLoss,
    required this.fixedFees,
    required this.netPnl,
    required this.netReturnPct,
  });

  final String id;
  final String title;
  final double returnPct;
  final double grossPnl;
  final double performanceFee;
  final double slippageLoss;
  final double fixedFees;
  final double netPnl;
  final double netReturnPct;
}

final class TradeCopyConsentItem {
  const TradeCopyConsentItem({
    required this.id,
    required this.label,
    required this.required,
  });

  final String id;
  final String label;
  final bool required;
}

final class TradeCopyConfirmationRequest {
  const TradeCopyConfirmationRequest({
    required this.providerId,
    required this.configuration,
    required this.acceptedConsentIds,
  });

  final String providerId;
  final TradeCopyConfigurationDraft configuration;
  final List<String> acceptedConsentIds;
}

final class TradeCopyConfirmationResult {
  const TradeCopyConfirmationResult({
    required this.providerId,
    required this.status,
    required this.auditTrailId,
    required this.coolingOffHours,
    required this.activeCopiesPath,
  });

  final String providerId;
  final String status;
  final String auditTrailId;
  final int coolingOffHours;
  final String activeCopiesPath;
}

final class TradeCopyPerformanceSnapshot {
  const TradeCopyPerformanceSnapshot({
    required this.copyId,
    required this.initialCapital,
    required this.yourReturnPct,
    required this.providerReturnPct,
    required this.yourCurrentValue,
    required this.providerTheoreticalValue,
    required this.performanceGapPct,
    required this.avgSlippagePct,
    required this.providerAvgSlippagePct,
    required this.totalCosts,
    required this.equityCurve,
    required this.slippageBuckets,
    required this.costAttribution,
    required this.tradeComparisons,
    required this.metrics,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final String copyId;
  final double initialCapital;
  final double yourReturnPct;
  final double providerReturnPct;
  final double yourCurrentValue;
  final double providerTheoreticalValue;
  final double performanceGapPct;
  final double avgSlippagePct;
  final double providerAvgSlippagePct;
  final double totalCosts;
  final List<TradeCopyEquityPoint> equityCurve;
  final List<TradeCopySlippageBucket> slippageBuckets;
  final List<TradeCopyCostAttribution> costAttribution;
  final List<TradeCopyTradeComparison> tradeComparisons;
  final List<TradeCopyMetricComparison> metrics;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopyEquityPoint {
  const TradeCopyEquityPoint({
    required this.day,
    required this.you,
    required this.provider,
  });

  final int day;
  final double you;
  final double provider;
}

final class TradeCopySlippageBucket {
  const TradeCopySlippageBucket({
    required this.range,
    required this.youPct,
    required this.providerPct,
  });

  final String range;
  final double youPct;
  final double providerPct;
}

final class TradeCopyCostAttribution {
  const TradeCopyCostAttribution({
    required this.name,
    required this.value,
    required this.colorHex,
  });

  final String name;
  final double value;
  final int colorHex;
}

final class TradeCopyTradeComparison {
  const TradeCopyTradeComparison({
    required this.id,
    required this.pair,
    required this.side,
    required this.providerEntry,
    required this.yourEntry,
    required this.providerExit,
    required this.yourExit,
    required this.providerPnl,
    required this.yourPnl,
    required this.slippagePct,
    required this.delay,
    required this.timestamp,
  });

  final String id;
  final String pair;
  final TradeOrderSide side;
  final double providerEntry;
  final double yourEntry;
  final double providerExit;
  final double yourExit;
  final double providerPnl;
  final double yourPnl;
  final double slippagePct;
  final String delay;
  final String timestamp;
}

final class TradeCopyMetricComparison {
  const TradeCopyMetricComparison({
    required this.name,
    required this.you,
    required this.provider,
    required this.higherIsBetter,
    this.suffix = '',
  });

  final String name;
  final double you;
  final double provider;
  final bool higherIsBetter;
  final String suffix;
}

final class TradePerformanceAttributionSnapshot {
  const TradePerformanceAttributionSnapshot({
    required this.copyId,
    required this.totalReturnPct,
    required this.alphaPct,
    required this.beta,
    required this.rSquared,
    required this.returns,
    required this.drawdowns,
    required this.monteCarloPaths,
    required this.correlationPoints,
    required this.marketContributionPct,
    required this.skillContributionPct,
    required this.maxDrawdownPct,
    required this.avgDrawdownPct,
    required this.medianProjection,
    required this.worstProjection,
    required this.bestProjection,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String copyId;
  final double totalReturnPct;
  final double alphaPct;
  final double beta;
  final double rSquared;
  final List<TradePerformanceReturnPoint> returns;
  final List<TradePerformanceDrawdownPoint> drawdowns;
  final List<List<TradePerformanceProjectionPoint>> monteCarloPaths;
  final List<TradePerformanceCorrelationPoint> correlationPoints;
  final double marketContributionPct;
  final double skillContributionPct;
  final double maxDrawdownPct;
  final double avgDrawdownPct;
  final double medianProjection;
  final double worstProjection;
  final double bestProjection;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradePerformanceReturnPoint {
  const TradePerformanceReturnPoint({
    required this.day,
    required this.market,
    required this.alpha,
  });

  final int day;
  final double market;
  final double alpha;

  double get total => market + alpha;
}

final class TradePerformanceDrawdownPoint {
  const TradePerformanceDrawdownPoint({
    required this.day,
    required this.drawdown,
  });

  final int day;
  final double drawdown;
}

final class TradePerformanceProjectionPoint {
  const TradePerformanceProjectionPoint({
    required this.day,
    required this.value,
  });

  final int day;
  final double value;
}

final class TradePerformanceCorrelationPoint {
  const TradePerformanceCorrelationPoint({
    required this.day,
    required this.marketReturn,
    required this.yourReturn,
  });

  final int day;
  final double marketReturn;
  final double yourReturn;
}

final class TradeProviderComparisonSnapshot {
  const TradeProviderComparisonSnapshot({
    required this.selectedCount,
    required this.maxProviders,
    required this.providers,
    required this.metrics,
    required this.disclaimer,
    required this.legend,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final int selectedCount;
  final int maxProviders;
  final List<TradeProviderComparisonProvider> providers;
  final List<TradeProviderComparisonMetric> metrics;
  final String disclaimer;
  final String legend;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderComparisonProvider {
  const TradeProviderComparisonProvider({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;
}

final class TradeProviderComparisonMetric {
  const TradeProviderComparisonMetric({
    required this.label,
    required this.category,
    required this.higherIsBetter,
    required this.values,
  });

  final String label;
  final TradeProviderComparisonCategory category;
  final bool higherIsBetter;
  final Map<String, String> values;
}

enum TradeProviderComparisonCategory { performance, risk, execution, cost }

enum TradeCopyAuditEventType { trade, config, risk, system }

enum TradeCopyAuditSeverity { info, warning, critical }

final class TradeCopyAuditLogSnapshot {
  const TradeCopyAuditLogSnapshot({
    required this.copyId,
    required this.complianceTitle,
    required this.complianceDescription,
    required this.tabs,
    required this.events,
    required this.exportFormats,
    required this.retentionYears,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final String copyId;
  final String complianceTitle;
  final String complianceDescription;
  final List<TradeCopyAuditTab> tabs;
  final List<TradeCopyAuditEvent> events;
  final List<TradeCopyAuditExportFormat> exportFormats;
  final int retentionYears;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeCopyAuditTab {
  const TradeCopyAuditTab({
    required this.id,
    required this.label,
    required this.badge,
    this.type,
  });

  final String id;
  final String label;
  final int badge;
  final TradeCopyAuditEventType? type;
}

final class TradeCopyAuditEvent {
  const TradeCopyAuditEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.severity,
    this.metadata,
  });

  final String id;
  final TradeCopyAuditEventType type;
  final String timestamp;
  final String title;
  final String description;
  final TradeCopyAuditSeverity severity;
  final TradeCopyAuditMetadata? metadata;
}

final class TradeCopyAuditMetadata {
  const TradeCopyAuditMetadata({
    this.pair,
    this.side,
    this.providerPrice,
    this.yourPrice,
    this.slippagePct,
    this.pnl,
    this.oldValue,
    this.newValue,
  });

  final String? pair;
  final TradeOrderSide? side;
  final double? providerPrice;
  final double? yourPrice;
  final double? slippagePct;
  final double? pnl;
  final String? oldValue;
  final String? newValue;
}

final class TradeCopyAuditExportFormat {
  const TradeCopyAuditExportFormat({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeCopyAuditExportRequest {
  const TradeCopyAuditExportRequest({
    required this.copyId,
    required this.format,
    required this.filterId,
    required this.searchQuery,
  });

  final String copyId;
  final String format;
  final String filterId;
  final String searchQuery;
}

final class TradeCopyAuditExportResult {
  const TradeCopyAuditExportResult({
    required this.exportId,
    required this.format,
    required this.status,
    required this.downloadUrl,
  });

  final String exportId;
  final String format;
  final String status;
  final String downloadUrl;
}

final class TradePortfolioRiskAnalysisSnapshot {
  const TradePortfolioRiskAnalysisSnapshot({
    required this.totalExposure,
    required this.var95,
    required this.var99,
    required this.diversificationScore,
    required this.assetExposures,
    required this.riskAlerts,
    required this.tabs,
    required this.scenarios,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final double totalExposure;
  final double var95;
  final double var99;
  final int diversificationScore;
  final List<TradeAssetExposure> assetExposures;
  final List<String> riskAlerts;
  final List<TradePortfolioRiskTab> tabs;
  final List<TradeStressScenario> scenarios;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeAssetExposure {
  const TradeAssetExposure({
    required this.asset,
    required this.value,
    required this.percent,
    required this.colorHex,
  });

  final String asset;
  final double value;
  final double percent;
  final int colorHex;
}

final class TradePortfolioRiskTab {
  const TradePortfolioRiskTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeStressScenario {
  const TradeStressScenario({
    required this.name,
    required this.impact,
    required this.probability,
    required this.colorHex,
  });

  final String name;
  final double impact;
  final int probability;
  final int colorHex;
}

final class TradeProviderLeaderboardSnapshot {
  const TradeProviderLeaderboardSnapshot({
    required this.trade,
    required this.providers,
    required this.sortOptions,
    required this.riskFilters,
    required this.defaultSortId,
    required this.defaultRiskFilterId,
    required this.defaultVerifiedOnly,
    required this.warningTitle,
    required this.warningText,
    required this.verifiedOnlyLabel,
    required this.disclaimer,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopyTrader> providers;
  final List<TradeProviderLeaderboardSort> sortOptions;
  final List<TradeProviderLeaderboardRiskFilter> riskFilters;
  final String defaultSortId;
  final String defaultRiskFilterId;
  final bool defaultVerifiedOnly;
  final String warningTitle;
  final String warningText;
  final String verifiedOnlyLabel;
  final String disclaimer;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderLeaderboardSort {
  const TradeProviderLeaderboardSort({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeProviderLeaderboardRiskFilter {
  const TradeProviderLeaderboardRiskFilter({
    required this.id,
    required this.label,
    this.riskLevel,
  });

  final String id;
  final String label;
  final TradeCopyRiskLevel? riskLevel;
}

final class TradeSafetyEducationSnapshot {
  const TradeSafetyEducationSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.scams,
    required this.redFlags,
    required this.verificationTiers,
    required this.reportReasons,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeSafetyTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final List<TradeSafetyScamType> scams;
  final List<TradeSafetyRedFlag> redFlags;
  final List<TradeSafetyVerificationTier> verificationTiers;
  final List<String> reportReasons;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeSafetyTab {
  const TradeSafetyTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeSafetyScamType {
  const TradeSafetyScamType({
    required this.id,
    required this.title,
    required this.description,
    required this.examples,
    required this.howToAvoid,
  });

  final String id;
  final String title;
  final String description;
  final List<String> examples;
  final List<String> howToAvoid;
}

final class TradeSafetyRedFlag {
  const TradeSafetyRedFlag({
    required this.id,
    required this.category,
    required this.flag,
    required this.severity,
    required this.explanation,
  });

  final String id;
  final String category;
  final String flag;
  final String severity;
  final String explanation;
}

final class TradeSafetyVerificationTier {
  const TradeSafetyVerificationTier({
    required this.tier,
    required this.colorHex,
    required this.requirements,
  });

  final String tier;
  final int colorHex;
  final List<String> requirements;
}

final class TradeProviderGovernanceSnapshot {
  const TradeProviderGovernanceSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.stats,
    required this.warning,
    required this.modifications,
    required this.messages,
    required this.feeContributors,
    required this.complianceItems,
    required this.lastUpdatedLabel,
    required this.supportedStates,
  });

  final TradeScreenSnapshot trade;
  final List<TradeProviderGovernanceTab> tabs;
  final String defaultTabId;
  final TradeProviderGovernanceStats stats;
  final String warning;
  final List<TradeStrategyModification> modifications;
  final List<TradeFollowerMessage> messages;
  final List<TradeFeeContributor> feeContributors;
  final List<TradeComplianceItem> complianceItems;
  final String lastUpdatedLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeProviderGovernanceTab {
  const TradeProviderGovernanceTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeProviderGovernanceStats {
  const TradeProviderGovernanceStats({
    required this.followers,
    required this.aum,
    required this.monthlyFeesEarned,
    required this.allTimeFeesEarned,
    required this.complianceScore,
  });

  final int followers;
  final double aum;
  final double monthlyFeesEarned;
  final double allTimeFeesEarned;
  final int complianceScore;
}

final class TradeStrategyModification {
  const TradeStrategyModification({
    required this.id,
    required this.date,
    required this.type,
    required this.oldValue,
    required this.newValue,
    required this.notificationSent,
    required this.followerImpact,
  });

  final String id;
  final String date;
  final String type;
  final String oldValue;
  final String newValue;
  final bool notificationSent;
  final int followerImpact;
}

final class TradeFollowerMessage {
  const TradeFollowerMessage({
    required this.id,
    required this.date,
    required this.subject,
    required this.body,
    required this.recipients,
    required this.openRate,
  });

  final String id;
  final String date;
  final String subject;
  final String body;
  final int recipients;
  final int openRate;
}

final class TradeFeeContributor {
  const TradeFeeContributor({
    required this.name,
    required this.profit,
    required this.fee,
  });

  final String name;
  final double profit;
  final double fee;
}

final class TradeComplianceItem {
  const TradeComplianceItem({
    required this.item,
    required this.status,
    required this.lastCheck,
  });

  final String item;
  final bool status;
  final String lastCheck;
}

final class TradeDisputeResolutionSnapshot {
  const TradeDisputeResolutionSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.noticeTitle,
    required this.noticeBody,
    required this.complaintTypes,
    required this.providers,
    required this.activeCases,
    required this.resolvedCases,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeDisputeTab> tabs;
  final String defaultTabId;
  final String noticeTitle;
  final String noticeBody;
  final List<TradeComplaintTypeOption> complaintTypes;
  final List<TradeDisputeProviderOption> providers;
  final List<TradeDisputeCase> activeCases;
  final List<TradeDisputeCase> resolvedCases;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeDisputeTab {
  const TradeDisputeTab({
    required this.id,
    required this.label,
    this.badgeCount,
  });

  final String id;
  final String label;
  final int? badgeCount;
}

final class TradeComplaintTypeOption {
  const TradeComplaintTypeOption({
    required this.value,
    required this.label,
    required this.description,
  });

  final String value;
  final String label;
  final String description;
}

final class TradeDisputeProviderOption {
  const TradeDisputeProviderOption({required this.id, required this.name});

  final String id;
  final String name;
}

final class TradeDisputeCase {
  const TradeDisputeCase({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.complaintType,
    required this.subject,
    required this.description,
    required this.status,
    required this.submittedDate,
    required this.updatedDate,
    required this.estimatedResolution,
    this.outcome,
  });

  final String id;
  final String providerId;
  final String providerName;
  final String complaintType;
  final String subject;
  final String description;
  final String status;
  final String submittedDate;
  final String updatedDate;
  final String estimatedResolution;
  final String? outcome;
}

final class TradeDisputeComplaintDraft {
  const TradeDisputeComplaintDraft({
    required this.complaintType,
    required this.providerId,
    required this.subject,
    required this.description,
    this.evidenceNames = const [],
  });

  final String complaintType;
  final String providerId;
  final String subject;
  final String description;
  final List<String> evidenceNames;
}

final class TradeDisputeSubmissionResult {
  const TradeDisputeSubmissionResult({
    required this.caseId,
    required this.status,
    required this.message,
  });

  final String caseId;
  final String status;
  final String message;
}

final class TradeCopySafetyCenterSnapshot {
  const TradeCopySafetyCenterSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.verificationIntro,
    required this.verificationTiers,
    required this.trustMetrics,
    required this.prohibitedBehaviors,
    required this.followerResponsibilities,
    required this.reportingSteps,
    required this.safetyTools,
    required this.enforcementActions,
    required this.warningText,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeCopySafetyCenterTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final String verificationIntro;
  final List<TradeCopyVerificationTier> verificationTiers;
  final List<TradeCopyTrustMetric> trustMetrics;
  final List<String> prohibitedBehaviors;
  final List<String> followerResponsibilities;
  final List<TradeCopyReportingStep> reportingSteps;
  final List<TradeCopySafetyTool> safetyTools;
  final List<TradeCopyEnforcementAction> enforcementActions;
  final String warningText;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeCopySafetyCenterTab {
  const TradeCopySafetyCenterTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeCopyVerificationTier {
  const TradeCopyVerificationTier({
    required this.tier,
    required this.requirements,
    required this.benefits,
    required this.colorHex,
  });

  final String tier;
  final List<String> requirements;
  final List<String> benefits;
  final int colorHex;
}

final class TradeCopyTrustMetric {
  const TradeCopyTrustMetric({
    required this.name,
    required this.description,
    required this.goodRange,
    required this.badRange,
    required this.whyMatters,
  });

  final String name;
  final String description;
  final String goodRange;
  final String badRange;
  final String whyMatters;
}

final class TradeCopyReportingStep {
  const TradeCopyReportingStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeCopySafetyTool {
  const TradeCopySafetyTool({
    required this.id,
    required this.title,
    required this.description,
    required this.colorHex,
    this.routePath,
  });

  final String id;
  final String title;
  final String description;
  final int colorHex;
  final String? routePath;
}

final class TradeCopyEnforcementAction {
  const TradeCopyEnforcementAction({
    required this.id,
    required this.date,
    required this.providerName,
    required this.action,
    required this.reason,
  });

  final String id;
  final String date;
  final String providerName;
  final String action;
  final String reason;
}

final class TradeRegulatoryDisclosuresSnapshot {
  const TradeRegulatoryDisclosuresSnapshot({
    required this.trade,
    required this.tabs,
    required this.defaultTabId,
    required this.heroTitle,
    required this.heroDescription,
    required this.mifidTitle,
    required this.mifidArticles,
    required this.commitmentText,
    required this.protection,
    required this.restrictions,
    required this.liability,
    required this.contacts,
    required this.whistleblower,
    required this.terms,
    required this.supportedStates,
    required this.lastUpdatedLabel,
  });

  final TradeScreenSnapshot trade;
  final List<TradeRegulatoryTab> tabs;
  final String defaultTabId;
  final String heroTitle;
  final String heroDescription;
  final String mifidTitle;
  final List<TradeRegulatoryDisclosureBlock> mifidArticles;
  final String commitmentText;
  final TradeRegulatoryProtection protection;
  final TradeRegulatoryRestrictions restrictions;
  final TradeRegulatoryLiability liability;
  final List<TradeRegulatoryContact> contacts;
  final TradeRegulatoryDisclosureBlock whistleblower;
  final List<TradeRegulatoryDocumentLink> terms;
  final List<TradeScreenState> supportedStates;
  final String lastUpdatedLabel;
}

final class TradeRegulatoryTab {
  const TradeRegulatoryTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeRegulatoryDisclosureBlock {
  const TradeRegulatoryDisclosureBlock({
    required this.title,
    required this.body,
    this.items = const [],
  });

  final String title;
  final String body;
  final List<String> items;
}

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

final class TradeClientCategorizationSnapshot {
  const TradeClientCategorizationSnapshot({
    required this.categories,
    required this.history,
    required this.currentCategoryId,
    required this.defaultTab,
    required this.supportedStates,
  });

  final List<TradeClientCategoryInfo> categories;
  final List<TradeClientCategoryHistory> history;
  final String currentCategoryId;
  final String defaultTab;
  final List<TradeScreenState> supportedStates;
}

final class TradeClientCategoryInfo {
  const TradeClientCategoryInfo({
    required this.id,
    required this.label,
    required this.description,
    required this.protections,
    required this.requirements,
  });

  final String id;
  final String label;
  final String description;
  final List<String> protections;
  final List<String> requirements;
}

final class TradeClientCategoryHistory {
  const TradeClientCategoryHistory({
    required this.date,
    required this.action,
    required this.toCategoryId,
    required this.reason,
    this.fromCategoryId,
  });

  final String date;
  final String action;
  final String? fromCategoryId;
  final String toCategoryId;
  final String reason;
}

final class TradeProductGovernanceSnapshot {
  const TradeProductGovernanceSnapshot({
    required this.products,
    required this.defaultTab,
    required this.nextReviewLabel,
    required this.supportedStates,
  });

  final List<TradeCopyProduct> products;
  final String defaultTab;
  final String nextReviewLabel;
  final List<TradeScreenState> supportedStates;
}

final class TradeCopyProduct {
  const TradeCopyProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.targetMarket,
    required this.negativeTarget,
    required this.riskLevel,
    required this.lastReview,
    required this.nextReview,
    required this.distributionChannels,
  });

  final String id;
  final String name;
  final String type;
  final String status;
  final List<String> targetMarket;
  final List<String> negativeTarget;
  final String riskLevel;
  final String lastReview;
  final String nextReview;
  final List<String> distributionChannels;
}

final class TradeTargetMarketDefinitionSnapshot {
  const TradeTargetMarketDefinitionSnapshot({
    required this.product,
    required this.dimensions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeCopyProduct product;
  final List<TradeTargetMarketDimension> dimensions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeTargetMarketDimension {
  const TradeTargetMarketDimension({
    required this.id,
    required this.category,
    required this.suitableFor,
    required this.notSuitableFor,
  });

  final String id;
  final String category;
  final List<String> suitableFor;
  final List<String> notSuitableFor;
}

final class TradeClientMoneyProtectionSnapshot {
  const TradeClientMoneyProtectionSnapshot({
    required this.balance,
    required this.trustAccount,
    required this.lastReconciled,
    required this.protections,
    required this.insolvencySummary,
    required this.insolvencyDetail,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double balance;
  final String trustAccount;
  final String lastReconciled;
  final List<TradeClientMoneyProtectionItem> protections;
  final String insolvencySummary;
  final String insolvencyDetail;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeClientMoneyProtectionItem {
  const TradeClientMoneyProtectionItem({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeCassReconciliationSnapshot {
  const TradeCassReconciliationSnapshot({
    required this.reconciledCount,
    required this.resolvedCount,
    required this.outstandingCount,
    required this.records,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int reconciledCount;
  final int resolvedCount;
  final int outstandingCount;
  final List<TradeCassReconciliationRecord> records;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeCassReconciliationRecord {
  const TradeCassReconciliationRecord({
    required this.id,
    required this.displayDate,
    required this.clientLedger,
    required this.bankBalance,
    required this.difference,
    required this.status,
    this.notes,
  });

  final String id;
  final String displayDate;
  final double clientLedger;
  final double bankBalance;
  final double difference;
  final TradeCassReconciliationStatus status;
  final String? notes;
}

enum TradeCassReconciliationStatus { matched, discrepancyResolved, discrepancy }

final class TradeInvestorCompensationSnapshot {
  const TradeInvestorCompensationSnapshot({
    required this.coverageLimit,
    required this.summary,
    required this.coveredMessage,
    required this.automaticProtection,
    required this.overviewDescription,
    required this.overviewItems,
    required this.coverageItems,
    required this.warning,
    required this.eligibleCustomers,
    required this.ineligibleCustomers,
    required this.claimSteps,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String coverageLimit;
  final String summary;
  final String coveredMessage;
  final String automaticProtection;
  final String overviewDescription;
  final List<TradeInvestorCompensationInfo> overviewItems;
  final List<TradeInvestorCompensationCoverage> coverageItems;
  final String warning;
  final List<String> eligibleCustomers;
  final List<String> ineligibleCustomers;
  final List<TradeInvestorCompensationClaimStep> claimSteps;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeInvestorCompensationInfo {
  const TradeInvestorCompensationInfo({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeInvestorCompensationCoverage {
  const TradeInvestorCompensationCoverage({
    required this.label,
    required this.amount,
    required this.caption,
    required this.emphasized,
  });

  final String label;
  final String amount;
  final String caption;
  final bool emphasized;
}

final class TradeInvestorCompensationClaimStep {
  const TradeInvestorCompensationClaimStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

final class TradeExAnteCostsSnapshot {
  const TradeExAnteCostsSnapshot({
    required this.investmentAmount,
    required this.holdingPeriodYears,
    required this.costs,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investmentAmount;
  final int holdingPeriodYears;
  final List<TradeExAnteCostItem> costs;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  double get oneOffCosts => totalForCategory(TradeExAnteCostCategory.oneOff);
  double get recurringCosts =>
      totalForCategory(TradeExAnteCostCategory.recurring);
  double get incidentalCosts =>
      totalForCategory(TradeExAnteCostCategory.incidental);
  double get totalFirstYear => oneOffCosts + recurringCosts + incidentalCosts;
  double get totalPercentage => (totalFirstYear / investmentAmount) * 100;
  double get reductionInYield => totalPercentage / holdingPeriodYears;

  double totalForCategory(TradeExAnteCostCategory category) {
    return costs
        .where((cost) => cost.category == category)
        .fold<double>(0, (sum, cost) => sum + cost.amountEur);
  }
}

final class TradeExAnteCostItem {
  const TradeExAnteCostItem({
    required this.category,
    required this.type,
    required this.description,
    required this.amountEur,
    required this.percentOfInvestment,
  });

  final TradeExAnteCostCategory category;
  final String type;
  final String description;
  final double amountEur;
  final double percentOfInvestment;
}

enum TradeExAnteCostCategory { oneOff, recurring, incidental }

final class TradeRiyCalculatorSnapshot {
  const TradeRiyCalculatorSnapshot({
    required this.investmentAmount,
    required this.expectedReturnPct,
    required this.totalCostsPct,
    required this.holdingPeriodYears,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investmentAmount;
  final double expectedReturnPct;
  final double totalCostsPct;
  final int holdingPeriodYears;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRiyProjection {
  const TradeRiyProjection({
    required this.year,
    required this.withoutCosts,
    required this.withCosts,
  });

  final int year;
  final double withoutCosts;
  final double withCosts;
}

final class TradeExPostCostsReportSnapshot {
  const TradeExPostCostsReportSnapshot({
    required this.reports,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeExPostCostReport> reports;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  TradeExPostCostReport reportForYear(int year) {
    return reports.firstWhere(
      (report) => report.year == year,
      orElse: () => reports.first,
    );
  }
}

final class TradeExPostCostReport {
  const TradeExPostCostReport({
    required this.year,
    required this.oneOff,
    required this.recurring,
    required this.incidental,
    required this.estimatedOneOff,
    required this.estimatedRecurring,
    required this.estimatedIncidental,
  });

  final int year;
  final double oneOff;
  final double recurring;
  final double incidental;
  final double estimatedOneOff;
  final double estimatedRecurring;
  final double estimatedIncidental;

  double get totalActual => oneOff + recurring + incidental;
  double get totalEstimated =>
      estimatedOneOff + estimatedRecurring + estimatedIncidental;
  double get variance => totalActual - totalEstimated;
}

final class TradeExPostCostsReportExportResult {
  const TradeExPostCostsReportExportResult({
    required this.status,
    required this.year,
    required this.downloadUrl,
  });

  final String status;
  final int year;
  final String downloadUrl;
}

final class TradeKidGeneratorSnapshot {
  const TradeKidGeneratorSnapshot({
    required this.document,
    required this.sections,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeKidDocument document;
  final List<TradeKidSection> sections;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeKidDocument {
  const TradeKidDocument({
    required this.title,
    required this.lastUpdated,
    required this.version,
    required this.documentType,
    required this.pages,
    required this.maxPages,
  });

  final String title;
  final String lastUpdated;
  final String version;
  final String documentType;
  final int pages;
  final int maxPages;
}

final class TradeKidSection {
  const TradeKidSection({
    required this.title,
    required this.icon,
    required this.status,
  });

  final String title;
  final TradeKidSectionIcon icon;
  final String status;
}

enum TradeKidSectionIcon { info, target, warning, chart, costs, clock, help }

final class TradePerformanceScenariosSnapshot {
  const TradePerformanceScenariosSnapshot({
    required this.investment,
    required this.holdingPeriods,
    required this.defaultHoldingPeriod,
    required this.scenarios,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final double investment;
  final List<int> holdingPeriods;
  final int defaultHoldingPeriod;
  final List<TradePerformanceScenario> scenarios;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradePerformanceScenario {
  const TradePerformanceScenario({
    required this.type,
    required this.label,
    required this.annualReturnPct,
  });

  final TradePerformanceScenarioType type;
  final String label;
  final double annualReturnPct;

  double outcomeFor(double investment, int years) {
    return investment * math.pow(1 + annualReturnPct / 100, years).toDouble();
  }

  double profitFor(double investment, int years) {
    return outcomeFor(investment, years) - investment;
  }
}

enum TradePerformanceScenarioType { stress, unfavorable, moderate, favorable }

final class TradeRiskIndicatorSnapshot {
  const TradeRiskIndicatorSnapshot({
    required this.productName,
    required this.productSri,
    required this.holdingPeriodYears,
    required this.levels,
    required this.additionalRisks,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String productName;
  final int productSri;
  final int holdingPeriodYears;
  final List<TradeRiskIndicatorLevel> levels;
  final List<TradeRiskIndicatorAdditionalRisk> additionalRisks;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRiskIndicatorLevel {
  const TradeRiskIndicatorLevel({
    required this.level,
    required this.label,
    required this.tier,
    required this.description,
    required this.examples,
  });

  final int level;
  final String label;
  final TradeRiskIndicatorTier tier;
  final String description;
  final List<String> examples;
}

final class TradeRiskIndicatorAdditionalRisk {
  const TradeRiskIndicatorAdditionalRisk({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

enum TradeRiskIndicatorTier { low, medium, elevated, high }

final class TradeComplaintsHandlingSnapshot {
  const TradeComplaintsHandlingSnapshot({
    required this.activeCount,
    required this.resolvedCount,
    required this.averageResolutionDays,
    required this.categories,
    required this.timeline,
    required this.complaints,
    required this.processSteps,
    required this.ombudsman,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int activeCount;
  final int resolvedCount;
  final int averageResolutionDays;
  final List<TradeComplaintCategory> categories;
  final List<TradeComplaintTimelineStep> timeline;
  final List<TradeComplaint> complaints;
  final List<TradeComplaintProcessStep> processSteps;
  final TradeOmbudsmanInfo ombudsman;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintSubmissionSnapshot {
  const TradeComplaintSubmissionSnapshot({
    required this.processTitle,
    required this.processDescription,
    required this.categories,
    required this.subjectMinLength,
    required this.subjectMaxLength,
    required this.descriptionMinLength,
    required this.descriptionMaxLength,
    required this.termsIntro,
    required this.terms,
    required this.confirmationComplaintId,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String processTitle;
  final String processDescription;
  final List<String> categories;
  final int subjectMinLength;
  final int subjectMaxLength;
  final int descriptionMinLength;
  final int descriptionMaxLength;
  final String termsIntro;
  final List<String> terms;
  final String confirmationComplaintId;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingSnapshot {
  const TradeComplaintTrackingSnapshot({
    required this.complaintId,
    required this.statusLabel,
    required this.submittedLabel,
    required this.responseDueLabel,
    required this.daysRemaining,
    required this.deadlineNotice,
    required this.timeline,
    required this.actions,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String complaintId;
  final String statusLabel;
  final String submittedLabel;
  final String responseDueLabel;
  final int daysRemaining;
  final String deadlineNotice;
  final List<TradeComplaintTrackingStep> timeline;
  final List<TradeComplaintTrackingAction> actions;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeComplaintTrackingStep {
  const TradeComplaintTrackingStep({
    required this.title,
    required this.description,
    required this.dateLabel,
    required this.state,
  });

  final String title;
  final String description;
  final String dateLabel;
  final TradeComplaintTrackingStepState state;
}

final class TradeComplaintTrackingAction {
  const TradeComplaintTrackingAction({
    required this.id,
    required this.label,
    required this.icon,
    this.routePath,
  });

  final String id;
  final String label;
  final TradeComplaintTrackingActionIcon icon;
  final String? routePath;
}

enum TradeComplaintTrackingStepState { completed, current, pending }

enum TradeComplaintTrackingActionIcon { message, document, warning }

final class TradeOmbudsmanReferralSnapshot {
  const TradeOmbudsmanReferralSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.eligibility,
    required this.contacts,
    required this.processSteps,
    required this.ctaLabel,
    required this.externalUrl,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final List<TradeOmbudsmanEligibility> eligibility;
  final List<TradeOmbudsmanContact> contacts;
  final List<TradeOmbudsmanProcessStep> processSteps;
  final String ctaLabel;
  final String externalUrl;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeOmbudsmanEligibility {
  const TradeOmbudsmanEligibility({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanContact {
  const TradeOmbudsmanContact({
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
  });

  final String label;
  final String value;
  final TradeOmbudsmanContactIcon icon;
  final String? detail;
}

final class TradeOmbudsmanProcessStep {
  const TradeOmbudsmanProcessStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final int step;
  final String title;
  final String description;
}

enum TradeOmbudsmanContactIcon { phone, website, address }

final class TradeAuditTrailSnapshot {
  const TradeAuditTrailSnapshot({
    required this.noticeTitle,
    required this.noticeDescription,
    required this.stats,
    required this.searchPlaceholder,
    required this.tabs,
    required this.entries,
    required this.exportFormats,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String noticeTitle;
  final String noticeDescription;
  final List<TradeAuditStat> stats;
  final String searchPlaceholder;
  final List<TradeAuditTab> tabs;
  final List<TradeAuditEntry> entries;
  final List<String> exportFormats;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeAuditStat {
  const TradeAuditStat({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;
}

final class TradeAuditTab {
  const TradeAuditTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeAuditEntry {
  const TradeAuditEntry({
    required this.id,
    required this.timestampLabel,
    required this.category,
    required this.categoryLabel,
    required this.action,
    required this.details,
    this.user,
    this.ipAddress,
  });

  final String id;
  final String timestampLabel;
  final TradeAuditCategory category;
  final String categoryLabel;
  final String action;
  final String details;
  final String? user;
  final String? ipAddress;
}

enum TradeAuditCategory { trade, compliance, clientAction, system }

final class TradeRegulatoryInspectionSnapshot {
  const TradeRegulatoryInspectionSnapshot({
    required this.complianceScore,
    required this.scoreLabel,
    required this.readyTitle,
    required this.readyDescription,
    required this.stats,
    required this.frameworks,
    required this.documents,
    required this.portalTitle,
    required this.portalDescription,
    required this.portalCta,
    required this.reportCta,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int complianceScore;
  final String scoreLabel;
  final String readyTitle;
  final String readyDescription;
  final List<TradeRegulatoryInspectionStat> stats;
  final List<TradeRegulatoryFramework> frameworks;
  final List<TradeRegulatoryDocument> documents;
  final String portalTitle;
  final String portalDescription;
  final String portalCta;
  final String reportCta;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeRegulatoryInspectionStat {
  const TradeRegulatoryInspectionStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final TradeRegulatoryInspectionStatIcon icon;
}

enum TradeRegulatoryInspectionStatIcon {
  documents,
  clients,
  auditLogs,
  retention,
}

final class TradeRegulatoryFramework {
  const TradeRegulatoryFramework({
    required this.name,
    required this.compliance,
    required this.requirements,
  });

  final String name;
  final int compliance;
  final List<String> requirements;
}

final class TradeRegulatoryDocument {
  const TradeRegulatoryDocument({
    required this.name,
    required this.countLabel,
    required this.status,
  });

  final String name;
  final String countLabel;
  final String status;
}

final class TradeBotTermsSnapshot {
  const TradeBotTermsSnapshot({
    required this.infoTitle,
    required this.infoDescription,
    required this.title,
    required this.lastUpdatedLabel,
    required this.sections,
    required this.acceptSectionLabel,
    required this.scrollWarning,
    required this.agreementTitle,
    required this.agreementDescription,
    required this.disabledCta,
    required this.enabledCta,
    required this.complianceTitle,
    required this.complianceDescription,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String infoTitle;
  final String infoDescription;
  final String title;
  final String lastUpdatedLabel;
  final List<TradeBotTermsSection> sections;
  final String acceptSectionLabel;
  final String scrollWarning;
  final String agreementTitle;
  final String agreementDescription;
  final String disabledCta;
  final String enabledCta;
  final String complianceTitle;
  final String complianceDescription;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotTermsSection {
  const TradeBotTermsSection({
    required this.title,
    required this.paragraphs,
    this.warningTitle,
    this.warningBody,
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final String? warningTitle;
  final String? warningBody;
  final List<String> bullets;
}

final class TradeBotRiskDisclosureSnapshot {
  const TradeBotRiskDisclosureSnapshot({
    required this.highRiskTitle,
    required this.highRiskBody,
    required this.pastPerformanceTitle,
    required this.pastPerformanceBody,
    required this.riskSectionLabel,
    required this.categories,
    required this.additionalWarningsLabel,
    required this.additionalWarnings,
    required this.regulatoryNoticeLabel,
    required this.regulatoryTitle,
    required this.regulatoryBody,
    required this.regulatoryNotes,
    required this.acknowledgmentLabel,
    required this.acknowledgmentTitle,
    required this.acknowledgmentDescription,
    required this.disabledCta,
    required this.enabledCta,
    required this.helpTitle,
    required this.helpDescription,
    required this.helpCta,
    required this.nextPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String highRiskTitle;
  final String highRiskBody;
  final String pastPerformanceTitle;
  final String pastPerformanceBody;
  final String riskSectionLabel;
  final List<TradeBotRiskCategory> categories;
  final String additionalWarningsLabel;
  final List<TradeBotRiskWarning> additionalWarnings;
  final String regulatoryNoticeLabel;
  final String regulatoryTitle;
  final String regulatoryBody;
  final List<String> regulatoryNotes;
  final String acknowledgmentLabel;
  final String acknowledgmentTitle;
  final String acknowledgmentDescription;
  final String disabledCta;
  final String enabledCta;
  final String helpTitle;
  final String helpDescription;
  final String helpCta;
  final String nextPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotRiskCategory {
  const TradeBotRiskCategory({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.examples,
    required this.mitigation,
  });

  final String id;
  final TradeBotRiskKind kind;
  final String title;
  final String description;
  final List<String> examples;
  final String mitigation;
}

enum TradeBotRiskKind {
  market,
  leverage,
  liquidity,
  technical,
  timing,
  regulatory,
}

final class TradeBotRiskWarning {
  const TradeBotRiskWarning({required this.title, required this.text});

  final String title;
  final String text;
}

final class TradeBotSuitabilityAssessmentSnapshot {
  const TradeBotSuitabilityAssessmentSnapshot({
    required this.questions,
    required this.infoTitle,
    required this.infoDescription,
    required this.pass,
    required this.warning,
    required this.fail,
    required this.regulatoryTitle,
    required this.regulatoryDescription,
    required this.completionPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotSuitabilityQuestion> questions;
  final String infoTitle;
  final String infoDescription;
  final TradeBotSuitabilityOutcomeCopy pass;
  final TradeBotSuitabilityOutcomeCopy warning;
  final TradeBotSuitabilityOutcomeCopy fail;
  final String regulatoryTitle;
  final String regulatoryDescription;
  final String completionPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  int get maxScore => questions.length * 3;
}

final class TradeBotSuitabilityQuestion {
  const TradeBotSuitabilityQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
  });

  final String id;
  final TradeBotSuitabilityCategory category;
  final String question;
  final List<TradeBotSuitabilityOption> options;
}

final class TradeBotSuitabilityOption {
  const TradeBotSuitabilityOption({
    required this.id,
    required this.text,
    required this.score,
  });

  final String id;
  final String text;
  final int score;
}

enum TradeBotSuitabilityCategory { experience, knowledge, risk, financial }

enum TradeBotSuitabilityOutcome { pass, warning, fail }

final class TradeBotSuitabilityOutcomeCopy {
  const TradeBotSuitabilityOutcomeCopy({
    required this.outcome,
    required this.title,
    required this.message,
    required this.recommendations,
    required this.ctaLabel,
  });

  final TradeBotSuitabilityOutcome outcome;
  final String title;
  final String message;
  final List<String> recommendations;
  final String ctaLabel;
}

final class TradeBotRiskDashboardSnapshot {
  const TradeBotRiskDashboardSnapshot({
    required this.riskScore,
    required this.riskLabel,
    required this.riskMessage,
    required this.currentDrawdown,
    required this.maxDrawdownLimit,
    required this.dailyLoss,
    required this.dailyLossLimit,
    required this.totalExposure,
    required this.maxExposure,
    required this.var95,
    required this.runningBots,
    required this.drawdownPoints,
    required this.exposures,
    required this.varHistory,
    required this.safetyControls,
    required this.emergencyPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final int riskScore;
  final String riskLabel;
  final String riskMessage;
  final double currentDrawdown;
  final double maxDrawdownLimit;
  final double dailyLoss;
  final double dailyLossLimit;
  final double totalExposure;
  final double maxExposure;
  final double var95;
  final int runningBots;
  final List<TradeBotDrawdownPoint> drawdownPoints;
  final List<TradeBotExposure> exposures;
  final List<TradeBotVarPoint> varHistory;
  final List<TradeBotSafetyControl> safetyControls;
  final String emergencyPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotDrawdownPoint {
  const TradeBotDrawdownPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class TradeBotExposure {
  const TradeBotExposure({
    required this.asset,
    required this.exposure,
    required this.percentage,
    required this.colorHex,
  });

  final String asset;
  final double exposure;
  final int percentage;
  final int colorHex;
}

final class TradeBotVarPoint {
  const TradeBotVarPoint({required this.label, required this.value});

  final String label;
  final double value;
}

final class TradeBotSafetyControl {
  const TradeBotSafetyControl({required this.label, required this.value});

  final String label;
  final String value;
}

final class TradeBotEmergencyStopSnapshot {
  const TradeBotEmergencyStopSnapshot({
    required this.warningTitle,
    required this.warningDescription,
    required this.bots,
    required this.reasons,
    required this.closePositionsTitle,
    required this.closePositionsDescription,
    required this.confirmationTitle,
    required this.confirmationDescription,
    required this.supportTitle,
    required this.supportDescription,
    required this.completionPath,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final String warningTitle;
  final String warningDescription;
  final List<TradeBotEmergencyBot> bots;
  final List<TradeBotEmergencyReason> reasons;
  final String closePositionsTitle;
  final String closePositionsDescription;
  final String confirmationTitle;
  final String confirmationDescription;
  final String supportTitle;
  final String supportDescription;
  final String completionPath;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotEmergencyBot {
  const TradeBotEmergencyBot({
    required this.id,
    required this.name,
    required this.pair,
    required this.profit,
    required this.statusLabel,
  });

  final String id;
  final String name;
  final String pair;
  final double profit;
  final String statusLabel;
}

final class TradeBotEmergencyReason {
  const TradeBotEmergencyReason({
    required this.id,
    required this.label,
    required this.iconName,
  });

  final String id;
  final String label;
  final String iconName;
}

final class TradeBotEmergencyStopDraft {
  const TradeBotEmergencyStopDraft({
    required this.reasonId,
    required this.closePositions,
    required this.confirmed,
  });

  final String reasonId;
  final bool closePositions;
  final bool confirmed;
}

final class TradeBotEmergencyStopResult {
  const TradeBotEmergencyStopResult({
    required this.status,
    required this.stoppedBotCount,
    required this.redirectPath,
  });

  final String status;
  final int stoppedBotCount;
  final String redirectPath;
}

final class TradeBotSecuritySettingsSnapshot {
  const TradeBotSecuritySettingsSnapshot({
    required this.twoFaEnabled,
    required this.apiKeys,
    required this.ipWhitelist,
    required this.recentActivity,
    required this.securityTips,
    required this.generatedApiKeyPreview,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final bool twoFaEnabled;
  final List<TradeBotApiKey> apiKeys;
  final List<TradeBotIpWhitelistEntry> ipWhitelist;
  final List<TradeBotSecurityActivity> recentActivity;
  final List<String> securityTips;
  final String generatedApiKeyPreview;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotApiKey {
  const TradeBotApiKey({
    required this.id,
    required this.name,
    required this.permissions,
    required this.lastUsed,
    required this.created,
  });

  final String id;
  final String name;
  final String permissions;
  final String lastUsed;
  final String created;
}

final class TradeBotIpWhitelistEntry {
  const TradeBotIpWhitelistEntry({
    required this.id,
    required this.ip,
    required this.label,
    required this.added,
  });

  final String id;
  final String ip;
  final String label;
  final String added;
}

enum TradeBotSecurityActivityStatus { success, warning }

final class TradeBotSecurityActivity {
  const TradeBotSecurityActivity({
    required this.id,
    required this.action,
    required this.time,
    required this.status,
  });

  final String id;
  final String action;
  final String time;
  final TradeBotSecurityActivityStatus status;
}

final class TradeBotSecuritySettingsDraft {
  const TradeBotSecuritySettingsDraft({required this.twoFaEnabled});

  final bool twoFaEnabled;
}

final class TradeBotSecuritySettingsResult {
  const TradeBotSecuritySettingsResult({
    required this.status,
    required this.twoFaEnabled,
  });

  final String status;
  final bool twoFaEnabled;
}

final class TradeBotHistorySnapshot {
  const TradeBotHistorySnapshot({
    required this.trades,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotHistoryTrade> trades;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

enum TradeBotHistorySide { buy, sell }

final class TradeBotHistoryTrade {
  const TradeBotHistoryTrade({
    required this.id,
    required this.timestamp,
    required this.botName,
    required this.strategy,
    required this.pair,
    required this.side,
    required this.qty,
    required this.price,
    required this.fee,
    required this.pnl,
    required this.status,
  });

  final String id;
  final String timestamp;
  final String botName;
  final String strategy;
  final String pair;
  final TradeBotHistorySide side;
  final double qty;
  final double price;
  final double fee;
  final double pnl;
  final String status;
}

final class TradeBotHistoryExportRequest {
  const TradeBotHistoryExportRequest({required this.format});

  final String format;
}

final class TradeBotHistoryExportResult {
  const TradeBotHistoryExportResult({
    required this.status,
    required this.downloadUrl,
  });

  final String status;
  final String downloadUrl;
}

final class TradeBotPerformanceAnalyticsSnapshot {
  const TradeBotPerformanceAnalyticsSnapshot({
    required this.metrics,
    required this.pnlPoints,
    required this.winLossPoints,
    required this.strategyPerformance,
    required this.durationDistribution,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotPerformanceMetrics metrics;
  final List<TradeBotPnlPoint> pnlPoints;
  final List<TradeBotWinLossPoint> winLossPoints;
  final List<TradeBotStrategyPerformance> strategyPerformance;
  final List<TradeBotDurationDistribution> durationDistribution;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotPerformanceMetrics {
  const TradeBotPerformanceMetrics({
    required this.totalPnl,
    required this.winRate,
    required this.sharpeRatio,
    required this.avgWin,
    required this.avgLoss,
    required this.profitFactor,
    required this.totalTrades,
    required this.bestTrade,
    required this.worstTrade,
  });

  final double totalPnl;
  final double winRate;
  final double sharpeRatio;
  final double avgWin;
  final double avgLoss;
  final double profitFactor;
  final int totalTrades;
  final double bestTrade;
  final double worstTrade;
}

final class TradeBotPnlPoint {
  const TradeBotPnlPoint({required this.date, required this.pnl});

  final String date;
  final double pnl;
}

final class TradeBotWinLossPoint {
  const TradeBotWinLossPoint({
    required this.week,
    required this.wins,
    required this.losses,
  });

  final String week;
  final int wins;
  final int losses;
}

final class TradeBotStrategyPerformance {
  const TradeBotStrategyPerformance({
    required this.strategy,
    required this.pnl,
    required this.colorHex,
  });

  final String strategy;
  final double pnl;
  final int colorHex;
}

final class TradeBotDurationDistribution {
  const TradeBotDurationDistribution({
    required this.duration,
    required this.count,
  });

  final String duration;
  final int count;
}

final class TradeBotBacktestingSnapshot {
  const TradeBotBacktestingSnapshot({
    required this.strategies,
    required this.pairs,
    required this.dateRanges,
    required this.defaultStrategyId,
    required this.defaultPair,
    required this.defaultDateRangeId,
    required this.defaultCapital,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotBacktestStrategy> strategies;
  final List<String> pairs;
  final List<TradeBotBacktestDateRange> dateRanges;
  final String defaultStrategyId;
  final String defaultPair;
  final String defaultDateRangeId;
  final double defaultCapital;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotBacktestStrategy {
  const TradeBotBacktestStrategy({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  final String id;
  final String name;
  final int colorHex;
}

final class TradeBotBacktestDateRange {
  const TradeBotBacktestDateRange({
    required this.id,
    required this.label,
    required this.periodLabel,
  });

  final String id;
  final String label;
  final String periodLabel;
}

final class TradeBotBacktestRequest {
  const TradeBotBacktestRequest({
    required this.strategyId,
    required this.pair,
    required this.dateRangeId,
    required this.initialCapital,
  });

  final String strategyId;
  final String pair;
  final String dateRangeId;
  final double initialCapital;
}

final class TradeBotBacktestResult {
  const TradeBotBacktestResult({
    required this.status,
    required this.reportId,
    required this.progress,
  });

  final String status;
  final String reportId;
  final int progress;
}

final class TradeBotStrategyCompareSnapshot {
  const TradeBotStrategyCompareSnapshot({
    required this.strategies,
    required this.equityPoints,
    required this.recommendations,
    required this.defaultSelectedIds,
    required this.analysisPeriod,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotCompareStrategy> strategies;
  final List<TradeBotCompareEquityPoint> equityPoints;
  final List<TradeBotRecommendation> recommendations;
  final List<String> defaultSelectedIds;
  final String analysisPeriod;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotCompareStrategy {
  const TradeBotCompareStrategy({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.metrics,
  });

  final String id;
  final String name;
  final int colorHex;
  final TradeBotCompareMetrics metrics;
}

final class TradeBotCompareMetrics {
  const TradeBotCompareMetrics({
    required this.totalReturn,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.winRate,
    required this.profitFactor,
    required this.totalTrades,
    required this.avgTradeDuration,
    required this.volatility,
  });

  final double totalReturn;
  final double sharpeRatio;
  final double maxDrawdown;
  final double winRate;
  final double profitFactor;
  final int totalTrades;
  final String avgTradeDuration;
  final double volatility;
}

final class TradeBotCompareEquityPoint {
  const TradeBotCompareEquityPoint({
    required this.date,
    required this.dca,
    required this.grid,
    required this.momentum,
    required this.martingale,
  });

  final String date;
  final double dca;
  final double grid;
  final double momentum;
  final double martingale;

  double valueFor(String strategyId) {
    return switch (strategyId) {
      'dca' => dca,
      'grid' => grid,
      'momentum' => momentum,
      'martingale' => martingale,
      _ => 0,
    };
  }
}

final class TradeBotRecommendation {
  const TradeBotRecommendation({
    required this.title,
    required this.strategyId,
    required this.strategy,
    required this.reason,
  });

  final String title;
  final String strategyId;
  final String strategy;
  final String reason;
}

final class TradeBotOptimizationSnapshot {
  const TradeBotOptimizationSnapshot({
    required this.targets,
    required this.parameterRanges,
    required this.steps,
    required this.defaultTargetId,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotOptimizationTarget> targets;
  final List<TradeBotOptimizationRange> parameterRanges;
  final List<String> steps;
  final String defaultTargetId;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotOptimizationTarget {
  const TradeBotOptimizationTarget({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

final class TradeBotOptimizationRange {
  const TradeBotOptimizationRange({
    required this.id,
    required this.label,
    required this.min,
    required this.max,
    required this.step,
    required this.defaultValue,
    this.unit = '',
  });

  final String id;
  final String label;
  final double min;
  final double max;
  final double step;
  final double defaultValue;
  final String unit;
}

final class TradeBotOptimizationRequest {
  const TradeBotOptimizationRequest({
    required this.targetId,
    required this.gridCount,
    required this.gridRangePct,
  });

  final String targetId;
  final double gridCount;
  final double gridRangePct;
}

final class TradeBotOptimizationResult {
  const TradeBotOptimizationResult({
    required this.status,
    required this.jobId,
    required this.estimatedMinutes,
  });

  final String status;
  final String jobId;
  final int estimatedMinutes;
}

final class TradeBotPortfolioDashboardSnapshot {
  const TradeBotPortfolioDashboardSnapshot({
    required this.summary,
    required this.allocations,
    required this.equityPoints,
    required this.correlations,
    required this.healthItems,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotPortfolioSummary summary;
  final List<TradeBotPortfolioAllocation> allocations;
  final List<TradeBotPortfolioEquityPoint> equityPoints;
  final List<TradeBotCorrelationRow> correlations;
  final List<String> healthItems;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotPortfolioSummary {
  const TradeBotPortfolioSummary({
    required this.totalEquity,
    required this.totalInvestment,
    required this.totalPnl,
    required this.pnlPercent,
    required this.portfolioSharpe,
    required this.diversificationScore,
    required this.activeBots,
    required this.totalTrades,
  });

  final double totalEquity;
  final double totalInvestment;
  final double totalPnl;
  final double pnlPercent;
  final double portfolioSharpe;
  final int diversificationScore;
  final int activeBots;
  final int totalTrades;
}

final class TradeBotPortfolioAllocation {
  const TradeBotPortfolioAllocation({
    required this.strategy,
    required this.value,
    required this.pnl,
    required this.colorHex,
  });

  final String strategy;
  final double value;
  final double pnl;
  final int colorHex;
}

final class TradeBotPortfolioEquityPoint {
  const TradeBotPortfolioEquityPoint({
    required this.date,
    required this.equity,
  });

  final String date;
  final double equity;
}

final class TradeBotCorrelationRow {
  const TradeBotCorrelationRow({required this.bot, required this.values});

  final String bot;
  final Map<String, double> values;
}

final class TradeBotDrawdownAnalyzerSnapshot {
  const TradeBotDrawdownAnalyzerSnapshot({
    required this.summary,
    required this.underwaterPoints,
    required this.durationBuckets,
    required this.events,
    required this.insights,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotDrawdownSummary summary;
  final List<TradeBotUnderwaterPoint> underwaterPoints;
  final List<TradeBotDrawdownDurationBucket> durationBuckets;
  final List<TradeBotDrawdownEvent> events;
  final List<TradeBotDrawdownInsight> insights;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotDrawdownSummary {
  const TradeBotDrawdownSummary({
    required this.maxDrawdownPct,
    required this.avgDrawdownPct,
    required this.drawdownDays,
    required this.totalDays,
    required this.frequency,
  });

  final double maxDrawdownPct;
  final double avgDrawdownPct;
  final int drawdownDays;
  final int totalDays;
  final int frequency;
}

final class TradeBotUnderwaterPoint {
  const TradeBotUnderwaterPoint({
    required this.date,
    required this.monthLabel,
    required this.underwaterPct,
  });

  final String date;
  final String monthLabel;
  final double underwaterPct;
}

final class TradeBotDrawdownDurationBucket {
  const TradeBotDrawdownDurationBucket({
    required this.range,
    required this.count,
  });

  final String range;
  final int count;
}

final class TradeBotDrawdownEvent {
  const TradeBotDrawdownEvent({
    required this.id,
    required this.startLabel,
    required this.depthPct,
    required this.duration,
    required this.recovery,
    required this.severe,
  });

  final int id;
  final String startLabel;
  final double depthPct;
  final String duration;
  final String recovery;
  final bool severe;
}

final class TradeBotDrawdownInsight {
  const TradeBotDrawdownInsight({
    required this.symbol,
    required this.colorHex,
    required this.text,
  });

  final String symbol;
  final int colorHex;
  final String text;
}

final class TradeBotEquityCurveSnapshot {
  const TradeBotEquityCurveSnapshot({
    required this.summary,
    required this.equityPoints,
    required this.monthlyReturns,
    required this.performanceStats,
    required this.analysisItems,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final TradeBotEquityCurveSummary summary;
  final List<TradeBotEquityCurvePoint> equityPoints;
  final List<TradeBotMonthlyReturn> monthlyReturns;
  final List<TradeBotPerformanceStat> performanceStats;
  final List<String> analysisItems;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotEquityCurveSummary {
  const TradeBotEquityCurveSummary({
    required this.botReturnPct,
    required this.buyHoldReturnPct,
    required this.alphaPct,
  });

  final double botReturnPct;
  final double buyHoldReturnPct;
  final double alphaPct;
}

final class TradeBotEquityCurvePoint {
  const TradeBotEquityCurvePoint({
    required this.date,
    required this.monthLabel,
    required this.equity,
    required this.buyHold,
    this.rollingSharpe,
  });

  final String date;
  final String monthLabel;
  final double equity;
  final double buyHold;
  final double? rollingSharpe;
}

final class TradeBotMonthlyReturn {
  const TradeBotMonthlyReturn({
    required this.month,
    required this.botReturn,
    required this.marketReturn,
    required this.alpha,
  });

  final String month;
  final double botReturn;
  final double marketReturn;
  final double alpha;
}

final class TradeBotPerformanceStat {
  const TradeBotPerformanceStat({
    required this.id,
    required this.label,
    required this.value,
    required this.colorHex,
  });

  final String id;
  final String label;
  final String value;
  final int colorHex;
}

final class TradeBotGuideSnapshot {
  const TradeBotGuideSnapshot({
    required this.strategies,
    required this.bestPractices,
    required this.mistakes,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotGuideStrategy> strategies;
  final List<TradeBotGuidePractice> bestPractices;
  final List<TradeBotGuideMistake> mistakes;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotGuideStrategy {
  const TradeBotGuideStrategy({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorHex,
    required this.difficulty,
    required this.description,
    required this.howItWorks,
    required this.pros,
    required this.cons,
    required this.bestFor,
    required this.example,
  });

  final String id;
  final String name;
  final String iconKey;
  final int colorHex;
  final String difficulty;
  final String description;
  final List<String> howItWorks;
  final List<String> pros;
  final List<String> cons;
  final String bestFor;
  final TradeBotGuideExample example;
}

final class TradeBotGuideExample {
  const TradeBotGuideExample({
    required this.setup,
    required this.duration,
    required this.result,
    required this.profit,
  });

  final String setup;
  final String duration;
  final String result;
  final String profit;
}

final class TradeBotGuidePractice {
  const TradeBotGuidePractice({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
}

final class TradeBotGuideMistake {
  const TradeBotGuideMistake({
    required this.mistake,
    required this.why,
    required this.fix,
  });

  final String mistake;
  final String why;
  final String fix;
}

final class TradeBotFaqSnapshot {
  const TradeBotFaqSnapshot({
    required this.categories,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotFaqCategory> categories;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;

  int get totalFaqs =>
      categories.fold<int>(0, (sum, category) => sum + category.items.length);
}

final class TradeBotFaqCategory {
  const TradeBotFaqCategory({
    required this.id,
    required this.label,
    required this.items,
  });

  final String id;
  final String label;
  final List<TradeBotFaqItem> items;
}

final class TradeBotFaqItem {
  const TradeBotFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

final class TradeBotTaxReportingSnapshot {
  const TradeBotTaxReportingSnapshot({
    required this.taxYears,
    required this.defaultYear,
    required this.defaultCostBasisMethod,
    required this.summary,
    required this.reportTypes,
    required this.breakdown,
    required this.taxNotes,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<String> taxYears;
  final String defaultYear;
  final String defaultCostBasisMethod;
  final TradeBotTaxSummary summary;
  final List<TradeBotTaxReportType> reportTypes;
  final TradeBotTaxBreakdown breakdown;
  final List<String> taxNotes;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotTaxSummary {
  const TradeBotTaxSummary({
    required this.totalTrades,
    required this.realizedGains,
    required this.realizedLosses,
    required this.netGainLoss,
    required this.shortTermGains,
    required this.longTermGains,
    required this.totalFees,
  });

  final int totalTrades;
  final double realizedGains;
  final double realizedLosses;
  final double netGainLoss;
  final double shortTermGains;
  final double longTermGains;
  final double totalFees;
}

final class TradeBotTaxReportType {
  const TradeBotTaxReportType({
    required this.id,
    required this.name,
    required this.description,
    required this.format,
    required this.recommended,
    required this.selectedByDefault,
  });

  final String id;
  final String name;
  final String description;
  final String format;
  final bool recommended;
  final bool selectedByDefault;
}

final class TradeBotTaxBreakdown {
  const TradeBotTaxBreakdown({
    required this.shortTermLabel,
    required this.shortTermDescription,
    required this.longTermLabel,
    required this.longTermDescription,
  });

  final String shortTermLabel;
  final String shortTermDescription;
  final String longTermLabel;
  final String longTermDescription;
}

final class TradeBotTaxReportExportRequest {
  const TradeBotTaxReportExportRequest({
    required this.year,
    required this.reportTypeIds,
    required this.costBasisMethod,
  });

  final String year;
  final List<String> reportTypeIds;
  final String costBasisMethod;
}

final class TradeBotTaxReportExportResult {
  const TradeBotTaxReportExportResult({
    required this.status,
    required this.year,
    required this.reportCount,
    required this.exportId,
  });

  final String status;
  final String year;
  final int reportCount;
  final String exportId;
}

final class TradeBotApiDocumentationSnapshot {
  const TradeBotApiDocumentationSnapshot({
    required this.tabs,
    required this.defaultView,
    required this.defaultLanguage,
    required this.endpoints,
    required this.websocketUrl,
    required this.websocketEvents,
    required this.codeExamples,
    required this.rateLimits,
    required this.authenticationHeader,
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
  });

  final List<TradeBotApiTab> tabs;
  final String defaultView;
  final String defaultLanguage;
  final List<TradeBotApiEndpoint> endpoints;
  final String websocketUrl;
  final List<TradeBotWebSocketEvent> websocketEvents;
  final List<TradeBotCodeExample> codeExamples;
  final List<TradeBotRateLimit> rateLimits;
  final String authenticationHeader;
  final String endpoint;
  final String actionDraft;
  final List<TradeScreenState> supportedStates;
}

final class TradeBotApiTab {
  const TradeBotApiTab({required this.id, required this.label});

  final String id;
  final String label;
}

final class TradeBotApiEndpoint {
  const TradeBotApiEndpoint({
    required this.method,
    required this.path,
    required this.description,
    required this.params,
    required this.response,
  });

  final String method;
  final String path;
  final String description;
  final List<TradeBotApiParameter> params;
  final String response;
}

final class TradeBotApiParameter {
  const TradeBotApiParameter({
    required this.name,
    required this.type,
    required this.required,
    required this.description,
  });

  final String name;
  final String type;
  final bool required;
  final String description;
}

final class TradeBotWebSocketEvent {
  const TradeBotWebSocketEvent({
    required this.event,
    required this.description,
    required this.payload,
  });

  final String event;
  final String description;
  final String payload;
}

final class TradeBotCodeExample {
  const TradeBotCodeExample({
    required this.language,
    required this.label,
    required this.title,
    required this.source,
  });

  final String language;
  final String label;
  final String title;
  final String source;
}

final class TradeBotRateLimit {
  const TradeBotRateLimit({required this.label, required this.value});

  final String label;
  final String value;
}

final class TradeComplaintCategory {
  const TradeComplaintCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final TradeComplaintCategoryIcon icon;
}

final class TradeComplaintTimelineStep {
  const TradeComplaintTimelineStep({
    required this.step,
    required this.label,
    required this.time,
  });

  final int step;
  final String label;
  final String time;
}

final class TradeComplaint {
  const TradeComplaint({
    required this.id,
    required this.category,
    required this.status,
    required this.submittedDate,
    required this.deadline,
    required this.subject,
  });

  final String id;
  final String category;
  final TradeComplaintStatus status;
  final String submittedDate;
  final String deadline;
  final String subject;
}

final class TradeComplaintProcessStep {
  const TradeComplaintProcessStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

final class TradeOmbudsmanInfo {
  const TradeOmbudsmanInfo({
    required this.description,
    required this.phone,
    required this.website,
  });

  final String description;
  final String phone;
  final String website;
}

enum TradeComplaintCategoryIcon {
  trade,
  account,
  payment,
  service,
  fees,
  other,
}

enum TradeComplaintStatus { submitted, underReview, resolved, escalated }

final class TradeCopyTrader {
  const TradeCopyTrader({
    required this.id,
    required this.name,
    required this.avatar,
    required this.winRate,
    required this.totalPnl,
    required this.totalPnlPct,
    required this.aum,
    required this.copiers,
    required this.maxCopiers,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.totalTrades,
    required this.avgHoldingTime,
    required this.weeklyPnl,
    required this.tags,
    required this.isFollowing,
    required this.riskLevel,
  });

  final String id;
  final String name;
  final String avatar;
  final double winRate;
  final double totalPnl;
  final double totalPnlPct;
  final double aum;
  final int copiers;
  final int maxCopiers;
  final double sharpeRatio;
  final double maxDrawdown;
  final int totalTrades;
  final String avgHoldingTime;
  final List<double> weeklyPnl;
  final List<String> tags;
  final bool isFollowing;
  final TradeCopyRiskLevel riskLevel;

  TradeCopyTrader copyWith({bool? isFollowing}) {
    return TradeCopyTrader(
      id: id,
      name: name,
      avatar: avatar,
      winRate: winRate,
      totalPnl: totalPnl,
      totalPnlPct: totalPnlPct,
      aum: aum,
      copiers: copiers,
      maxCopiers: maxCopiers,
      sharpeRatio: sharpeRatio,
      maxDrawdown: maxDrawdown,
      totalTrades: totalTrades,
      avgHoldingTime: avgHoldingTime,
      weeklyPnl: weeklyPnl,
      tags: tags,
      isFollowing: isFollowing ?? this.isFollowing,
      riskLevel: riskLevel,
    );
  }
}

final class TradeCopyActionRequest {
  const TradeCopyActionRequest({
    required this.providerId,
    required this.action,
  });

  final String providerId;
  final String action;
}

final class TradeCopyActionResult {
  const TradeCopyActionResult({
    required this.providerId,
    required this.action,
    required this.status,
  });

  final String providerId;
  final String action;
  final String status;
}

final class TradeDashboardPosition {
  const TradeDashboardPosition({
    required this.id,
    required this.symbol,
    required this.type,
    required this.side,
    required this.size,
    required this.entryPrice,
    required this.currentPrice,
    required this.pnl,
    required this.pnlPct,
    this.leverage,
    this.liquidPrice,
    this.takeProfit,
    this.stopLoss,
    this.margin,
  });

  final String id;
  final String symbol;
  final TradePositionType type;
  final TradePositionSide side;
  final double size;
  final double entryPrice;
  final double currentPrice;
  final double pnl;
  final double pnlPct;
  final int? leverage;
  final double? liquidPrice;
  final double? takeProfit;
  final double? stopLoss;
  final double? margin;

  double get notional => size * currentPrice;
}

final class TradeHistoryOrder {
  const TradeHistoryOrder({
    required this.id,
    required this.symbol,
    required this.side,
    required this.type,
    required this.status,
    required this.price,
    required this.amount,
    required this.filled,
    required this.fee,
    required this.createdAt,
  });

  final String id;
  final String symbol;
  final TradeOrderSide side;
  final TradeOrderType type;
  final TradeOrderStatus status;
  final double price;
  final double amount;
  final double filled;
  final double fee;
  final String createdAt;
}

final class TradePosition {
  const TradePosition({
    required this.symbol,
    required this.side,
    required this.notional,
    required this.pnl,
  });

  final String symbol;
  final TradeOrderSide side;
  final double notional;
  final double pnl;
}

final class TradeBalances {
  const TradeBalances({
    required this.usdtAvailable,
    required this.baseAvailable,
  });

  final double usdtAvailable;
  final double baseAvailable;
}

final class TradeOrderDraft {
  const TradeOrderDraft({
    required this.pairId,
    required this.side,
    required this.type,
    required this.price,
    required this.amount,
  });

  final String pairId;
  final TradeOrderSide side;
  final TradeOrderType type;
  final double price;
  final double amount;
}

final class TradeOrderPreview {
  const TradeOrderPreview({
    required this.total,
    required this.fee,
    required this.feeRate,
    required this.estimatedReceive,
  });

  final double total;
  final double fee;
  final double feeRate;
  final double estimatedReceive;
}

final class TradeOrderReceipt {
  const TradeOrderReceipt({
    required this.orderId,
    required this.preview,
    required this.status,
  });

  final String orderId;
  final TradeOrderPreview preview;
  final String status;
}

final class TradeOrderActionResult {
  const TradeOrderActionResult({
    required this.orderId,
    required this.action,
    required this.status,
  });

  final String orderId;
  final String action;
  final String status;
}

final class MockTradeRepository implements TradeRepository {
  const MockTradeRepository();

  @override
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'}) {
    final pair = _pairs.firstWhere(
      (pair) => pair.id == pairId,
      orElse: () => _pairs.first,
    );
    return TradeScreenSnapshot(
      pair: pair,
      pairs: _pairs,
      orderBook: _orderBook,
      trades: _trades,
      orders: _orders,
      positions: _positions,
      copyProviders: const ['AlphaQuant', 'Delta Scalper'],
      botStrategies: const ['Grid BTC', 'DCA ETH', 'Momentum SOL'],
      balances: const TradeBalances(usdtAvailable: 10200, baseAvailable: 0.84),
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeOrdersHistorySnapshot getOrdersHistory() {
    return TradeOrdersHistorySnapshot(
      trade: getTrade(),
      openOrders: _historyOpenOrders,
      historyOrders: _historyOrders,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeOrderReceiptSnapshot getOrderReceipt() {
    return TradeOrderReceiptSnapshot(
      trade: getTrade(),
      receipt: const TradeOrderReceiptDetails(
        orderId: 'ORD-98EH1ZT2',
        symbol: 'BTC/USDT',
        baseAsset: 'BTC',
        side: TradeOrderSide.buy,
        orderType: 'Giới hạn',
        price: 67543.21,
        amount: .015,
        total: 1013.15,
        fee: .96,
        feeRate: '0.095% (VIP 1, -5%)',
        timestamp: '23:29:21 18/5/2026',
        status: TradeReceiptStatus.submitted,
        tpPrice: 72000,
        slPrice: 65000,
        estimatedFill: '< 2 phút',
      ),
      lastUpdatedLabel: 'success',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeSettingsSnapshot getTradeSettings() {
    return TradeSettingsSnapshot(
      trade: getTrade(),
      settings: _defaultTradeSettings,
      lastUpdatedLabel: 'success',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePositionsSnapshot getTradePositions() {
    return TradePositionsSnapshot(
      trade: getTrade(),
      positions: _dashboardPositions,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExportSnapshot getTradeExport() {
    return TradeExportSnapshot(
      trade: getTrade(),
      stats: const TradeExportStats(
        totalTrades: 847,
        totalVolume: 2458300,
        totalFees: 2340.56,
        netPnl: 12456.78,
      ),
      formats: _tradeExportFormats,
      periods: _tradeExportPeriods,
      includes: _tradeExportIncludes,
      lastUpdatedLabel: 'success',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'}) {
    final trade = getTrade(pairId: pairId);
    return TradeAdvancedChartSnapshot(
      trade: trade,
      pair: trade.pair,
      candles: _advancedChartCandles,
      indicators: _advancedChartIndicators,
      timeframes: const ['1m', '5m', '15m', '1h', '4h', '1D', '1W'],
      chartTypes: const ['candle', 'line', 'area'],
      ohlcv: const TradeOhlcv(
        open: 64312.26,
        high: 64475.28,
        low: 64185.74,
        close: 64268.03,
        volumeLabel: '8.0K',
      ),
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeConvertSnapshot getConvert() {
    return TradeConvertSnapshot(
      trade: getTrade(),
      assets: _convertAssets,
      favoritePairs: _convertFavoritePairs,
      history: _convertHistory,
      slippageOptions: const [.5, 1, 2],
      fromAsset: _convertAssetBySymbol('USDT'),
      toAsset: _convertAssetBySymbol('BTC'),
      rateLabel: '1 USDT = 0.000015 BTC',
      countdownLabel: '14s',
      minUsd: 10,
      maxUsd: 500000,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'}) {
    final trade = getTrade(pairId: pairId);
    return TradeFuturesSnapshot(
      trade: trade,
      pair: trade.pair,
      positions: _futuresPositions,
      leverages: const [1, 2, 3, 5, 10, 20, 50, 75, 100],
      markPrice: trade.pair.price,
      indexPrice: trade.pair.price * .9998,
      fundingRate: .01,
      accountBalance: 5000,
      usedMargin: 544,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeFuturesLeverageSnapshot getFuturesLeverage({String pairId = 'btcusdt'}) {
    return TradeFuturesLeverageSnapshot(
      futures: getFutures(pairId: pairId),
      currentLeverage: 10,
      presets: const [1, 2, 3, 5, 10, 20, 25, 50, 75, 100],
      sliderStops: const [1, 10, 25, 50, 75, 100],
      exampleMargin: 100,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeBotsSnapshot getTradingBots() {
    return TradeBotsSnapshot(
      trade: getTrade(),
      strategies: _botStrategies,
      activeBots: _activeBots,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeRiskManagementSnapshot getRiskManagement() {
    return TradeRiskManagementSnapshot(
      trade: getTrade(),
      features: _riskFeatures,
      positions: _riskPositions,
      statusItems: _riskStatusItems,
      accountBalance: 50000,
      currentPrice: 69000,
      availableBalance: 50000,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeExecutionQualitySnapshot getExecutionQuality() {
    return TradeExecutionQualitySnapshot(
      trade: getTrade(),
      features: _executionFeatures,
      report: _executionReport,
      openOrder: _executionOpenOrder,
      slippageSettings: _defaultSlippageSettings,
      statusItems: _executionStatusItems,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeAdvancedToolsSnapshot getAdvancedTools() {
    return TradeAdvancedToolsSnapshot(
      trade: getTrade(),
      features: _advancedToolFeatures,
      ladderOrders: _ladderOrders,
      bulkOrders: _bulkOrders,
      shortcuts: _shortcuts,
      statusItems: _advancedToolStatusItems,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyTradingSnapshot getCopyTrading() {
    return TradeCopyTradingSnapshot(
      trade: getTrade(),
      traders: _copyTraders,
      sortOptions: _copyTradingSortOptions,
      totalCopiers: _copyTraders.fold<int>(
        0,
        (total, trader) => total + trader.copiers,
      ),
      totalAum: _copyTraders.fold<double>(
        0,
        (total, trader) => total + trader.aum,
      ),
      aumTrendPct: 12.3,
      riskWarningTitle: 'Cảnh báo rủi ro',
      riskWarningText:
          'Copy Trading có rủi ro cao. Hiệu suất quá khứ không đảm bảo lợi nhuận tương lai. Bạn có thể mất toàn bộ vốn đầu tư.',
      disclaimer:
          'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Tất cả chỉ số mang tính tham khảo. Copy Trading có rủi ro cao, chỉ đầu tư với số tiền bạn có thể chấp nhận mất.',
      lastUpdatedLabel: '2 mins ago',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyTradingV2Snapshot getCopyTradingV2() {
    return TradeCopyTradingV2Snapshot(
      copyTrading: getCopyTrading(),
      heroVariants: const ['clean', 'bold', 'glass'],
      defaultHeroVariant: 'clean',
      lastUpdatedLabel: '2 mins ago',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyEducationSnapshot getCopyEducation() {
    return TradeCopyEducationSnapshot(
      trade: getTrade(),
      tabs: _copyEducationTabs,
      defaultTab: 'how-it-works',
      introTitle: 'Học trước khi đầu tư',
      introDescription:
          'Trang này giúp bạn hiểu rõ cơ chế, rủi ro và chi phí của Copy Trading. Không có gì thay thế được hiểu biết đầy đủ.',
      steps: _copyEducationSteps,
      copyModes: _copyModeGuides,
      concepts: _copyConceptGuides,
      lastUpdatedLabel: '2 mins ago',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeActiveCopiesSnapshot getActiveCopies() {
    return TradeActiveCopiesSnapshot(
      trade: getTrade(),
      portfolio: const TradeActiveCopyPortfolio(
        totalCapital: 10000,
        totalValue: 10500,
        totalPnl: 500,
        totalPnlPct: 5,
        activeCopies: 2,
        totalCopies: 3,
      ),
      tabs: const [
        TradeActiveCopiesTab(id: 'all', label: 'Tất cả', badge: 3),
        TradeActiveCopiesTab(id: 'active', label: 'Đang chạy', badge: 2),
        TradeActiveCopiesTab(id: 'paused', label: 'Tạm dừng'),
        TradeActiveCopiesTab(id: 'history', label: 'Lịch sử'),
      ],
      defaultTab: 'all',
      copies: _activeCopies,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopySettingsSnapshot getCopySettings() {
    return TradeCopySettingsSnapshot(
      trade: getTrade(),
      settings: _defaultCopySettings,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyNotificationsSnapshot getCopyNotifications() {
    final unreadCount = _copyNotifications
        .where((notification) => !notification.read)
        .length;
    final tradeCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.trade &&
              !notification.read,
        )
        .length;
    final riskCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.risk &&
              !notification.read,
        )
        .length;
    final updateCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.update &&
              !notification.read,
        )
        .length;
    final systemCount = _copyNotifications
        .where(
          (notification) =>
              notification.type == TradeCopyNotificationType.system &&
              !notification.read,
        )
        .length;

    return TradeCopyNotificationsSnapshot(
      trade: getTrade(),
      defaultTab: 'all',
      tabs: [
        TradeCopyNotificationTab(
          id: 'all',
          label: 'Tất cả',
          badge: unreadCount == 0 ? null : unreadCount,
        ),
        TradeCopyNotificationTab(
          id: 'unread',
          label: 'Chưa đọc',
          badge: unreadCount == 0 ? null : unreadCount,
        ),
        TradeCopyNotificationTab(
          id: 'trade',
          label: 'Trades',
          badge: tradeCount == 0 ? null : tradeCount,
        ),
        TradeCopyNotificationTab(
          id: 'risk',
          label: 'Rủi ro',
          badge: riskCount == 0 ? null : riskCount,
        ),
        TradeCopyNotificationTab(
          id: 'update',
          label: 'Cập nhật',
          badge: updateCount == 0 ? null : updateCount,
        ),
        TradeCopyNotificationTab(
          id: 'system',
          label: 'Hệ thống',
          badge: systemCount == 0 ? null : systemCount,
        ),
      ],
      notifications: _copyNotifications,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeProviderApplicationSnapshot getProviderApplication() {
    return TradeProviderApplicationSnapshot(
      trade: getTrade(),
      steps: const [
        TradeProviderApplicationStep.intro,
        TradeProviderApplicationStep.requirements,
        TradeProviderApplicationStep.disclosure,
        TradeProviderApplicationStep.fees,
        TradeProviderApplicationStep.review,
      ],
      defaultStep: TradeProviderApplicationStep.intro,
      benefits: _providerApplicationBenefits,
      requirements: _providerApplicationRequirements,
      responsibilities: _providerApplicationResponsibilities,
      defaultDraft: _defaultProviderApplicationDraft,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyProviderDetailSnapshot getCopyProviderDetail({
    String providerId = 'provider001',
  }) {
    TradeCopyTrader? provider;
    for (final trader in _copyTraders) {
      if (trader.id == providerId) {
        provider = trader;
        break;
      }
    }

    return TradeCopyProviderDetailSnapshot(
      providerId: providerId,
      provider: provider,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePreCopyAssessmentSnapshot getPreCopyAssessment({
    String providerId = 'provider001',
  }) {
    final detail = getCopyProviderDetail(providerId: providerId);
    return TradePreCopyAssessmentSnapshot(
      providerId: providerId,
      provider: detail.provider,
      questions: _preCopyQuestions,
      educationDocs: _preCopyEducationDocs,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyConfigurationSnapshot getCopyConfiguration({
    String providerId = 'provider001',
  }) {
    final detail = getCopyProviderDetail(providerId: providerId);
    final defaultDraft = TradeCopyConfigurationDraft(
      providerId: providerId,
      copyCapital: 5000,
      copyMode: TradeCopyConfigurationMode.fixed,
      positionSizing: TradePositionSizingMethod.percentage,
      copyRatio: 50,
      useCustomStopLoss: false,
      customStopLoss: 10,
      useCustomTakeProfit: false,
      customTakeProfit: 20,
      useTrailingStop: false,
      trailingStopPercent: 5,
    );

    return TradeCopyConfigurationSnapshot(
      providerId: providerId,
      provider: detail.provider,
      defaultDraft: defaultDraft,
      totalPortfolio: 25000,
      currentCopyAllocation: 8000,
      availableCapital: 17000,
      feePreview: _copyConfigurationFeePreview(defaultDraft),
      validations: _copyConfigurationValidations(defaultDraft, detail.provider),
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyConfirmationSnapshot getCopyConfirmation({
    String providerId = 'provider001',
  }) {
    final configuration = getCopyConfiguration(providerId: providerId);
    return TradeCopyConfirmationSnapshot(
      providerId: providerId,
      provider: configuration.provider,
      configuration: configuration.defaultDraft,
      feePreview: configuration.feePreview,
      scenarios: _copyScenarioProjections(
        configuration.defaultDraft,
        configuration.feePreview,
      ),
      maxLossAmount: configuration.defaultDraft.useCustomStopLoss
          ? configuration.defaultDraft.copyCapital *
                configuration.defaultDraft.customStopLoss /
                100
          : configuration.defaultDraft.copyCapital,
      consentItems: _copyConfirmationConsents,
      coolingOffHours: 24,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopyPerformanceSnapshot getCopyPerformance({String copyId = 'copy001'}) {
    return TradeCopyPerformanceSnapshot(
      copyId: copyId,
      initialCapital: 5000,
      yourReturnPct: 13,
      providerReturnPct: 15.6,
      yourCurrentValue: 5650,
      providerTheoreticalValue: 5780,
      performanceGapPct: 2.6,
      avgSlippagePct: .68,
      providerAvgSlippagePct: .48,
      totalCosts: 290,
      equityCurve: _copyPerformanceEquityCurve,
      slippageBuckets: _copyPerformanceSlippageBuckets,
      costAttribution: _copyPerformanceCostAttribution,
      tradeComparisons: _copyPerformanceTrades,
      metrics: _copyPerformanceMetrics,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePerformanceAttributionSnapshot getPerformanceAttribution({
    String copyId = 'copy001',
  }) {
    return TradePerformanceAttributionSnapshot(
      copyId: copyId,
      totalReturnPct: 9.2,
      alphaPct: -4.1,
      beta: 1.15,
      rSquared: .72,
      returns: _performanceAttributionReturns,
      drawdowns: _performanceAttributionDrawdowns,
      monteCarloPaths: _performanceAttributionProjectionPaths,
      correlationPoints: _performanceAttributionCorrelation,
      marketContributionPct: 13.4,
      skillContributionPct: -4.1,
      maxDrawdownPct: -8.7,
      avgDrawdownPct: -3.2,
      medianProjection: 5630,
      worstProjection: 4920,
      bestProjection: 6425,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeProviderComparisonSnapshot getProviderComparison() {
    return const TradeProviderComparisonSnapshot(
      selectedCount: 3,
      maxProviders: 5,
      providers: [],
      metrics: _providerComparisonMetrics,
      disclaimer:
          'So sánh dựa trên hiệu suất lịch sử. Hiệu suất quá khứ không đảm bảo kết quả tương lai.',
      legend:
          '"Tốt nhất" không có nghĩa là "phù hợp nhất". Xem xét risk tolerance và mục tiêu đầu tư của bạn.',
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
  TradeCopyAuditLogSnapshot getCopyAuditLog({String copyId = 'copy001'}) {
    int countFor(TradeCopyAuditEventType type) =>
        _copyAuditEvents.where((event) => event.type == type).length;

    return TradeCopyAuditLogSnapshot(
      copyId: copyId,
      complianceTitle: 'MiFID II Compliant Audit Trail',
      complianceDescription:
          'Tất cả hành động được ghi log và lưu trữ 5 năm. Bạn có thể export bất cứ lúc nào.',
      tabs: [
        TradeCopyAuditTab(
          id: 'all',
          label: 'Tất cả',
          badge: _copyAuditEvents.length,
        ),
        TradeCopyAuditTab(
          id: 'trade',
          label: 'Trades',
          badge: countFor(TradeCopyAuditEventType.trade),
          type: TradeCopyAuditEventType.trade,
        ),
        TradeCopyAuditTab(
          id: 'config',
          label: 'Config',
          badge: countFor(TradeCopyAuditEventType.config),
          type: TradeCopyAuditEventType.config,
        ),
        TradeCopyAuditTab(
          id: 'risk',
          label: 'Risk',
          badge: countFor(TradeCopyAuditEventType.risk),
          type: TradeCopyAuditEventType.risk,
        ),
        TradeCopyAuditTab(
          id: 'system',
          label: 'System',
          badge: countFor(TradeCopyAuditEventType.system),
          type: TradeCopyAuditEventType.system,
        ),
      ],
      events: _copyAuditEvents,
      exportFormats: _copyAuditExportFormats,
      retentionYears: 5,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradePortfolioRiskAnalysisSnapshot getPortfolioRiskAnalysis() {
    return const TradePortfolioRiskAnalysisSnapshot(
      totalExposure: 8000,
      var95: -273,
      var99: -424,
      diversificationScore: 93,
      assetExposures: _portfolioRiskAssets,
      riskAlerts: [
        'BTC chiếm 35% (khuyến nghị <30%)',
        'High correlation: CryptoKing ↔ cryptoKing (1.00)',
        'High correlation: SwingMaster ↔ swingMaster (1.00)',
      ],
      tabs: [
        TradePortfolioRiskTab(id: 'exposure', label: 'Exposure'),
        TradePortfolioRiskTab(id: 'correlation', label: 'Correlation'),
        TradePortfolioRiskTab(id: 'var', label: 'VaR'),
        TradePortfolioRiskTab(id: 'scenarios', label: 'Stress Test'),
      ],
      scenarios: _portfolioRiskScenarios,
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
  TradeProviderLeaderboardSnapshot getProviderLeaderboard() {
    return TradeProviderLeaderboardSnapshot(
      trade: getTrade(),
      providers: _copyTraders,
      sortOptions: _providerLeaderboardSortOptions,
      riskFilters: _providerLeaderboardRiskFilters,
      defaultSortId: 'roi',
      defaultRiskFilterId: 'all',
      defaultVerifiedOnly: false,
      warningTitle: 'Survivorship Bias Warning',
      warningText:
          'Leaderboard chỉ hiển thị providers đang active. Nhiều traders đã thua lỗ và dừng không xuất hiện ở đây. Hiệu suất thực tế của ngành có thể thấp hơn nhiều.',
      verifiedOnlyLabel: 'Chỉ hiện Verified providers',
      disclaimer:
          'Rankings dựa trên hiệu suất lịch sử và không đảm bảo kết quả tương lai. Provider xếp hạng cao vẫn có thể thua lỗ trong tương lai. Luôn đọc kỹ risk disclosure trước khi copy.',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeSafetyEducationSnapshot getSafetyEducation() {
    return TradeSafetyEducationSnapshot(
      trade: getTrade(),
      tabs: _safetyEducationTabs,
      defaultTabId: 'scams',
      heroTitle: 'Bảo vệ bản thân khỏi scams',
      heroDescription:
          'Copy trading có nhiều rủi ro từ scammers. Đọc kỹ guide này trước khi copy bất kỳ ai.',
      scams: _safetyScams,
      redFlags: _safetyRedFlags,
      verificationTiers: _safetyVerificationTiers,
      reportReasons: _safetyReportReasons,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeProviderGovernanceSnapshot getProviderGovernance() {
    return TradeProviderGovernanceSnapshot(
      trade: getTrade(),
      tabs: _providerGovernanceTabs,
      defaultTabId: 'modifications',
      stats: const TradeProviderGovernanceStats(
        followers: 245,
        aum: 125000,
        monthlyFeesEarned: 1850,
        allTimeFeesEarned: 12400,
        complianceScore: 95,
      ),
      warning:
          '24-Hour Notice Required: You must notify all followers at least 24 hours before implementing major strategy changes.',
      modifications: _strategyModifications,
      messages: _followerMessages,
      feeContributors: _feeContributors,
      complianceItems: _complianceItems,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeDisputeResolutionSnapshot getDisputeResolution() {
    return TradeDisputeResolutionSnapshot(
      trade: getTrade(),
      tabs: const [
        TradeDisputeTab(id: 'file', label: 'File Complaint'),
        TradeDisputeTab(id: 'active', label: 'Active Cases', badgeCount: 1),
        TradeDisputeTab(id: 'history', label: 'History', badgeCount: 1),
      ],
      defaultTabId: 'file',
      noticeTitle: 'Fair Dispute Resolution',
      noticeBody:
          'We investigate all complaints fairly. Most cases are resolved within 48 hours.',
      complaintTypes: _disputeComplaintTypes,
      providers: _disputeProviders,
      activeCases: _activeDisputeCases,
      resolvedCases: _resolvedDisputeCases,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeCopySafetyCenterSnapshot getCopySafetyCenter() {
    return TradeCopySafetyCenterSnapshot(
      trade: getTrade(),
      tabs: _copySafetyCenterTabs,
      defaultTabId: 'verification',
      heroTitle: 'Your Safety is Our Priority',
      heroDescription:
          'Learn how to identify trustworthy providers and protect yourself from scams.',
      verificationIntro: 'Provider verification tiers explained:',
      verificationTiers: _copyVerificationTiers,
      trustMetrics: _copyTrustMetrics,
      prohibitedBehaviors: _copyProhibitedBehaviors,
      followerResponsibilities: _copyFollowerResponsibilities,
      reportingSteps: _copyReportingSteps,
      safetyTools: _copySafetyTools,
      enforcementActions: _copyEnforcementActions,
      warningText:
          'Important: Verification badges confirm identity and track record, but DO NOT guarantee future performance. Always check risk metrics before copying.',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeRegulatoryDisclosuresSnapshot getRegulatoryDisclosures() {
    return TradeRegulatoryDisclosuresSnapshot(
      trade: getTrade(),
      tabs: _regulatoryTabs,
      defaultTabId: 'mifid',
      heroTitle: 'Legal & Regulatory Framework',
      heroDescription:
          'Understanding your rights and protections under MiFID II',
      mifidTitle: 'MiFID II Compliance Statement',
      mifidArticles: _regulatoryMifidArticles,
      commitmentText:
          'Our Commitment: We comply with all MiFID II requirements to protect retail investors. Our compliance is audited annually by independent third parties.',
      protection: _regulatoryProtection,
      restrictions: _regulatoryRestrictions,
      liability: _regulatoryLiability,
      contacts: _regulatoryContacts,
      whistleblower: _regulatoryWhistleblower,
      terms: _regulatoryTerms,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  }) {
    final trade = getTrade(pairId: pairId);
    final pair = trade.pairs.firstWhere(
      (item) => item.id == pairId,
      orElse: () => trade.pair,
    );
    return TradeMarginTradingSnapshot(
      trade: trade,
      pair: pair,
      account: _marginAccount,
      positions: _marginPositions,
      modeTabs: _marginModeTabs,
      contentTabs: _marginContentTabs,
      defaultMode: 'cross',
      defaultTab: 'trade',
      defaultSide: 'long',
      defaultLeverage: 5,
      clientCategory: _marginClientCategory,
      referencePrices: pairRouteVariant
          ? _marginPairRouteReferencePrices
          : _marginReferencePrices,
      orderDraft: _marginOrderDraft,
      riskWarning: _marginRiskWarning,
      negativeBalance: _marginNegativeBalance,
      bestExecution: _marginBestExecution,
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeTraderProfileSnapshot getTraderProfile({String traderId = 'trader001'}) {
    final trader = _copyTraders.firstWhere(
      (item) => item.id == traderId,
      orElse: () => _copyTraders.first,
    );
    return TradeTraderProfileSnapshot(
      traderId: traderId,
      trader: trader,
      pnlHistory: _traderProfilePnlHistory,
      recentTrades: _traderProfileRecentTrades,
      defaultTab: 'overview',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo() {
    return TradeAdvancedTradingDemoSnapshot(
      position: _advancedDemoPosition,
      positionActions: _advancedDemoPositionActions,
      orderTypes: _advancedDemoOrderTypes,
      timeInForce: _advancedDemoTimeInForce,
      orderSummary: _advancedDemoOrderSummary,
      pnlSummary: _advancedDemoPnlSummary,
      performanceMetrics: _advancedDemoPerformanceMetrics,
      defaultTab: 'position',
      defaultPositionMode: 'one-way',
      lastUpdatedLabel: 'realtime-refresh',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

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
  TradeMarginTradingHubSnapshot getMarginTradingHub() {
    return const TradeMarginTradingHubSnapshot(
      stats: _marginHubStats,
      menuItems: _marginHubMenuItems,
      features: _marginHubFeatures,
      compliance: _marginHubCompliance,
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
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics() {
    return const TradeAdvancedAnalyticsSnapshot(
      stats: _advancedAnalyticsStats,
      signals: _advancedAnalyticsSignals,
      features: _advancedAnalyticsFeatures,
      risk: _advancedAnalyticsRisk,
      journal: _advancedAnalyticsJournal,
      sizing: _advancedAnalyticsSizing,
      defaultTab: 'ai',
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
  TradeTransactionReportingSnapshot getTransactionReporting() {
    return const TradeTransactionReportingSnapshot(
      reports: _transactionReports,
      stats: _transactionReportingStats,
      defaultTab: 'queue',
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
  TradeRegulatoryReportsDashboardSnapshot getRegulatoryReportsDashboard() {
    return const TradeRegulatoryReportsDashboardSnapshot(
      dailyStats: _regulatoryDailyStats,
      providers: _regulatoryArmProviders,
      distribution: _regulatoryReportDistribution,
      totals: _regulatoryDashboardTotals,
      timeRanges: ['24H', '7D', '30D', '90D'],
      defaultRange: '7D',
      defaultTab: 'overview',
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

  @override
  TradeClientCategorizationSnapshot getClientCategorization() {
    return const TradeClientCategorizationSnapshot(
      categories: _clientCategorizationCategories,
      history: _clientCategorizationHistory,
      currentCategoryId: 'retail',
      defaultTab: 'overview',
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
  TradeProductGovernanceSnapshot getProductGovernance() {
    return const TradeProductGovernanceSnapshot(
      products: _productGovernanceProducts,
      defaultTab: 'products',
      nextReviewLabel: 'June 2026',
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
  TradeTargetMarketDefinitionSnapshot getTargetMarketDefinition({
    String productId = 'prod-1',
  }) {
    final product = _productGovernanceProducts.firstWhere(
      (item) => item.id == productId,
      orElse: () => _productGovernanceProducts.first,
    );

    return TradeTargetMarketDefinitionSnapshot(
      product: product,
      dimensions: _targetMarketDimensions,
      endpoint: '/api/mobile/trade/trade-copy-trading-target-market-definition',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeClientMoneyProtectionSnapshot getClientMoneyProtection() {
    return const TradeClientMoneyProtectionSnapshot(
      balance: 45230.50,
      trustAccount: 'Barclays UK',
      lastReconciled: 'Today 09:00 UTC',
      protections: _clientMoneyProtections,
      insolvencySummary:
          'If we become insolvent, your segregated funds will be '
          'distributed to clients proportionally, not used to pay company '
          'debts.',
      insolvencyDetail:
          "Segregated client money is held on trust and is not available to "
          "general creditors. The FCA's client money rules ensure you have "
          'priority access to your funds in an insolvency scenario.',
      endpoint: '/api/mobile/trade/trade-copy-trading-client-money-protection',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeCassReconciliationSnapshot getCassReconciliation() {
    return const TradeCassReconciliationSnapshot(
      reconciledCount: 3,
      resolvedCount: 1,
      outstandingCount: 0,
      records: _cassReconciliationRecords,
      endpoint: '/api/mobile/trade/trade-copy-trading-cass-reconciliation',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeInvestorCompensationSnapshot getInvestorCompensation() {
    return const TradeInvestorCompensationSnapshot(
      coverageLimit: '£85,000',
      summary:
          'Your investments are protected by the UK Financial Services '
          'Compensation Scheme (FSCS)',
      coveredMessage:
          "You're covered: If our firm fails, FSCS may pay compensation for "
          'claims up to £85,000 per eligible person.',
      automaticProtection:
          'FSCS protection is automatic for eligible claimants. No '
          'registration required. Coverage applies if we cannot meet our '
          'obligations.',
      overviewDescription:
          "The Financial Services Compensation Scheme (FSCS) is the UK's "
          'statutory deposit insurance and investors compensation scheme for '
          'customers of authorised financial services firms.',
      overviewItems: _investorCompensationOverviewItems,
      coverageItems: _investorCompensationCoverageItems,
      warning:
          'Note: Some products may not be covered. Check eligibility for each '
          'product type.',
      eligibleCustomers: _investorCompensationEligibleCustomers,
      ineligibleCustomers: _investorCompensationIneligibleCustomers,
      claimSteps: _investorCompensationClaimSteps,
      endpoint: '/api/mobile/trade/trade-copy-trading-investor-compensation',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeExAnteCostsSnapshot getExAnteCosts() {
    return const TradeExAnteCostsSnapshot(
      investmentAmount: 10000,
      holdingPeriodYears: 3,
      costs: _exAnteCostItems,
      endpoint: '/api/mobile/trade/trade-copy-trading-ex-ante-costs',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeRiyCalculatorSnapshot getRiyCalculator() {
    return const TradeRiyCalculatorSnapshot(
      investmentAmount: 10000,
      expectedReturnPct: 8,
      totalCostsPct: 4.5,
      holdingPeriodYears: 5,
      endpoint: '/api/mobile/trade/trade-copy-trading-riy-calculator',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeExPostCostsReportSnapshot getExPostCostsReport() {
    return const TradeExPostCostsReportSnapshot(
      reports: _exPostCostReports,
      endpoint: '/api/mobile/trade/trade-copy-trading-ex-post-costs-report',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable; '
          'POST /exports',
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
  TradeKidGeneratorSnapshot getKidGenerator() {
    return const TradeKidGeneratorSnapshot(
      document: TradeKidDocument(
        title: 'Mirror Copy Trading - KID',
        lastUpdated: 'March 8, 2026',
        version: '2.1',
        documentType: 'PRIIPs KID',
        pages: 3,
        maxPages: 3,
      ),
      sections: _kidSections,
      endpoint: '/api/mobile/trade/trade-copy-trading-kid-generator',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradePerformanceScenariosSnapshot getPerformanceScenarios() {
    return const TradePerformanceScenariosSnapshot(
      investment: 10000,
      holdingPeriods: [1, 3, 5],
      defaultHoldingPeriod: 3,
      scenarios: _performanceScenarios,
      endpoint: '/api/mobile/trade/trade-copy-trading-performance-scenarios',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeRiskIndicatorSnapshot getRiskIndicatorExplainer() {
    return const TradeRiskIndicatorSnapshot(
      productName: 'Mirror Copy Trading',
      productSri: 6,
      holdingPeriodYears: 3,
      levels: _riskIndicatorLevels,
      additionalRisks: _riskIndicatorAdditionalRisks,
      endpoint: '/api/mobile/trade/trade-copy-trading-risk-indicator-explainer',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeComplaintsHandlingSnapshot getComplaintsHandling() {
    return const TradeComplaintsHandlingSnapshot(
      activeCount: 1,
      resolvedCount: 1,
      averageResolutionDays: 12,
      categories: _complaintCategories,
      timeline: _complaintTimeline,
      complaints: _complaints,
      processSteps: _complaintProcessSteps,
      ombudsman: TradeOmbudsmanInfo(
        description:
            'The Financial Ombudsman Service is a free, independent service '
            'that settles complaints between consumers and businesses that '
            'provide financial services.',
        phone: '0800 023 4567',
        website: 'www.financial-ombudsman.org.uk',
      ),
      endpoint: '/api/mobile/trade/trade-copy-trading-complaints-handling',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeComplaintSubmissionSnapshot getComplaintSubmission() {
    return const TradeComplaintSubmissionSnapshot(
      processTitle: 'Complaint Process',
      processDescription:
          "We'll acknowledge your complaint within 5 business days and "
          'provide a final response within 8 weeks.',
      categories: [
        'Trade Execution',
        'Account Management',
        'Payments & Withdrawals',
        'Customer Service',
        'Fees & Charges',
        'Other',
      ],
      subjectMinLength: 10,
      subjectMaxLength: 100,
      descriptionMinLength: 50,
      descriptionMaxLength: 2000,
      termsIntro:
          'I confirm that the information provided is accurate and I understand:',
      terms: [
        'We will respond within 8 weeks',
        'I can refer to the Financial Ombudsman if not satisfied',
        'My complaint will be investigated fairly',
      ],
      confirmationComplaintId: 'COMP-2026-NEW',
      endpoint: '/api/mobile/trade/trade-copy-trading-complaint-submission',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeComplaintTrackingSnapshot getComplaintTracking({String? complaintId}) {
    return TradeComplaintTrackingSnapshot(
      complaintId: complaintId ?? 'undefined',
      statusLabel: 'Under Review',
      submittedLabel: 'Feb 15, 2026',
      responseDueLabel: 'Apr 12, 2026',
      daysRemaining: 34,
      deadlineNotice:
          'We must provide a final response by April 12, 2026 '
          '(8 weeks from submission).',
      timeline: _complaintTrackingTimeline,
      actions: _complaintTrackingActions,
      endpoint: '/api/mobile/trade/trade-copy-trading-complaint-tracking',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
      supportedStates: const [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeOmbudsmanReferralSnapshot getOmbudsmanReferral() {
    return const TradeOmbudsmanReferralSnapshot(
      infoTitle: 'Free & Independent',
      infoDescription:
          'The Financial Ombudsman Service (FOS) is a free service that '
          'settles complaints between consumers and financial businesses.',
      eligibility: _ombudsmanEligibility,
      contacts: _ombudsmanContacts,
      processSteps: _ombudsmanProcessSteps,
      ctaLabel: 'Visit FOS Website',
      externalUrl: 'https://www.financial-ombudsman.org.uk',
      endpoint: '/api/mobile/trade/trade-copy-trading-ombudsman-referral',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeAuditTrailSnapshot getAuditTrail() {
    return const TradeAuditTrailSnapshot(
      noticeTitle: 'Complete Record-Keeping',
      noticeDescription:
          'All actions are logged for 7 years as required by MiFID II. '
          'This audit trail is available for regulatory inspection.',
      stats: _auditTrailStats,
      searchPlaceholder: 'Search audit trail...',
      tabs: _auditTrailTabs,
      entries: _auditTrailEntries,
      exportFormats: ['CSV', 'PDF'],
      endpoint: '/api/mobile/trade/trade-copy-trading-audit-trail',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeRegulatoryInspectionSnapshot getRegulatoryInspectionReady() {
    return const TradeRegulatoryInspectionSnapshot(
      complianceScore: 97,
      scoreLabel: 'Overall Compliance Score',
      readyTitle: 'Inspection Ready:',
      readyDescription:
          'All regulatory requirements met. Full documentation available '
          'for FCA/ESMA inspection.',
      stats: _regulatoryInspectionStats,
      frameworks: _regulatoryFrameworks,
      documents: _regulatoryDocuments,
      portalTitle: 'Secure Inspector Portal',
      portalDescription:
          'FCA/ESMA inspectors can access all required documents through '
          'our secure portal with audit logging.',
      portalCta: 'Inspector Portal Access',
      reportCta: 'Download Full Compliance Report (PDF)',
      endpoint:
          '/api/mobile/trade/trade-copy-trading-regulatory-inspection-ready',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /copy-trading/follow|configure|stop where applicable',
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
  TradeBotTermsSnapshot getBotTermsOfService() {
    return const TradeBotTermsSnapshot(
      infoTitle: 'Legal Agreement Required',
      infoDescription:
          'You must read and accept these terms before using Trading Bots. '
          'Scroll to the bottom to enable acceptance.',
      title: 'Trading Bots Terms of Service',
      lastUpdatedLabel: 'Last Updated: March 8, 2026',
      sections: _botTermsSections,
      acceptSectionLabel: 'Accept Terms',
      scrollWarning:
          'Please scroll to the bottom of the terms to enable acceptance.',
      agreementTitle:
          'I have read and agree to the Trading Bots Terms of Service',
      agreementDescription:
          'By checking this box, you acknowledge that you understand the '
          'risks of automated trading and accept the terms outlined above.',
      disabledCta: 'Read Terms to Continue',
      enabledCta: 'Accept & Continue',
      complianceTitle: 'Regulatory Compliance',
      complianceDescription:
          'These terms comply with MiFID II (EU), SEC regulations (US), '
          'FCA guidelines (UK), and other applicable financial regulations. '
          'Acceptance is recorded and auditable.',
      endpoint: '/api/mobile/trade/trade-bots-terms-of-service',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotRiskDisclosureSnapshot getBotRiskDisclosure() {
    return const TradeBotRiskDisclosureSnapshot(
      highRiskTitle: 'HIGH RISK WARNING',
      highRiskBody:
          'Trading Bots are complex financial products involving significant '
          'risk of loss. You may lose your entire investment. Only use '
          'capital you can afford to lose completely.',
      pastPerformanceTitle: 'Past Performance Disclaimer',
      pastPerformanceBody:
          'Backtest results and historical performance do not guarantee '
          'future results. Market conditions change, and strategies that '
          'worked in the past may fail in the future. Always assume actual '
          'performance will be worse than backtests due to slippage, fees, '
          'and execution delays.',
      riskSectionLabel: 'Risk Categories',
      categories: _botRiskCategories,
      additionalWarningsLabel: 'Additional Warnings',
      additionalWarnings: _botRiskWarnings,
      regulatoryNoticeLabel: 'Regulatory Notice',
      regulatoryTitle: 'MiFID II / ESMA / SEC Compliance',
      regulatoryBody:
          'Trading Bots are classified as complex financial products under '
          'European (MiFID II) and US (SEC) regulations. You must complete '
          'an appropriateness assessment to ensure you understand the risks '
          'before using this service.',
      regulatoryNotes: [
        'EU residents: Subject to ESMA leverage limits and negative balance protection',
        'US residents: May be restricted based on accredited investor status',
        'UK residents: FCA appropriateness test required for complex products',
      ],
      acknowledgmentLabel: 'Acknowledgment',
      acknowledgmentTitle: 'I acknowledge and accept all risks disclosed above',
      acknowledgmentDescription:
          'I understand that Trading Bots are high-risk, I may lose my '
          'entire investment, and past performance does not guarantee future '
          'results. I accept full responsibility for my trading decisions.',
      disabledCta: 'Acknowledge Risks to Continue',
      enabledCta: 'I Understand the Risks - Continue',
      helpTitle: 'Need Help Understanding Risks?',
      helpDescription:
          "If you don't fully understand these risks, we recommend consulting "
          'a financial advisor before proceeding.',
      helpCta: 'View Risk Education Guide ->',
      nextPath: '/trade/bots/suitability-assessment',
      endpoint: '/api/mobile/trade/trade-bots-risk-disclosure',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotSuitabilityAssessmentSnapshot getBotSuitabilityAssessment() {
    return const TradeBotSuitabilityAssessmentSnapshot(
      questions: _botSuitabilityQuestions,
      infoTitle: 'Why we ask:',
      infoDescription:
          'These questions help determine if Trading Bots are suitable for '
          'your experience level and risk profile. Answer honestly for '
          'accurate results.',
      pass: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.pass,
        title: 'Suitable for Trading Bots',
        message:
            'Based on your responses, you have sufficient knowledge and risk '
            'tolerance to use Trading Bots.',
        recommendations: [
          'You may use all bot strategies (DCA, Grid, Momentum, Martingale)',
          'Still recommended to start with small amounts (\$100-500)',
          'Monitor performance daily and adjust parameters as needed',
        ],
        ctaLabel: 'Continue to Trading Bots',
      ),
      warning: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.warning,
        title: 'Proceed with Caution',
        message:
            'You have some experience, but we recommend starting with small '
            'amounts and simpler strategies like DCA. Avoid high-risk '
            'strategies like Martingale.',
        recommendations: [
          'Start with DCA Bot only - avoid Grid and Martingale',
          'Use small amounts (\$50-200 maximum per bot)',
          'Complete the Bot Guide tutorial before creating your first bot',
        ],
        ctaLabel: 'Continue to Trading Bots',
      ),
      fail: TradeBotSuitabilityOutcomeCopy(
        outcome: TradeBotSuitabilityOutcome.fail,
        title: 'Not Recommended',
        message:
            'Based on your responses, Trading Bots may not be suitable for '
            'you at this time. We recommend gaining more trading experience '
            'and knowledge before using automated strategies.',
        recommendations: [
          'Not recommended to proceed at this time',
          'Gain more manual trading experience first (3-6 months)',
          'Review educational materials and retake assessment later',
        ],
        ctaLabel: 'Review Educational Materials',
      ),
      regulatoryTitle: 'Regulatory Compliance (MiFID II)',
      regulatoryDescription:
          'This appropriateness assessment is required under European '
          'regulations for complex financial products. Your responses have '
          'been recorded for compliance purposes.',
      completionPath: '/trade/bots',
      endpoint: '/api/mobile/trade/trade-bots-suitability-assessment',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotRiskDashboardSnapshot getBotRiskDashboard() {
    return const TradeBotRiskDashboardSnapshot(
      riskScore: 68,
      riskLabel: 'Medium Risk',
      riskMessage:
          'Moderate risk detected. Consider reducing position sizes or '
          'stopping high-risk bots.',
      currentDrawdown: -15.2,
      maxDrawdownLimit: -20,
      dailyLoss: -127,
      dailyLossLimit: -500,
      totalExposure: 2500,
      maxExposure: 5000,
      var95: 178,
      runningBots: 3,
      drawdownPoints: _botRiskDrawdownPoints,
      exposures: _botRiskExposures,
      varHistory: _botRiskVarHistory,
      safetyControls: _botRiskSafetyControls,
      emergencyPath: '/trade/bots/emergency-stop',
      endpoint: '/api/mobile/trade/trade-bots-risk-dashboard',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotEmergencyStopSnapshot getBotEmergencyStop() {
    return const TradeBotEmergencyStopSnapshot(
      warningTitle: 'EMERGENCY STOP',
      warningDescription:
          'This will immediately stop all running bots and cancel pending '
          'orders. Use this only in emergency situations (market crash, '
          'technical issues, unauthorized activity).',
      bots: _botEmergencyStopBots,
      reasons: _botEmergencyStopReasons,
      closePositionsTitle: 'Also close all open positions (market sell)',
      closePositionsDescription:
          'WARNING: This will sell all holdings at market price. Only use if '
          'you need to exit immediately. May incur slippage.',
      confirmationTitle: 'I understand this is a destructive action',
      confirmationDescription:
          'All running bots will stop immediately. Pending orders will be '
          'cancelled. This action cannot be undone. I take full '
          'responsibility for this decision.',
      supportTitle: 'Support Will Be Notified',
      supportDescription:
          'Our security team will be automatically notified of this emergency '
          'stop for review and assistance. You will receive a confirmation '
          'email within 5 minutes.',
      completionPath: '/trade/bots',
      endpoint: '/api/mobile/trade/trade-bots-emergency-stop',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeBotSecuritySettingsSnapshot getBotSecuritySettings() {
    return const TradeBotSecuritySettingsSnapshot(
      twoFaEnabled: true,
      apiKeys: _botSecurityApiKeys,
      ipWhitelist: _botSecurityIpWhitelist,
      recentActivity: _botSecurityRecentActivity,
      securityTips: _botSecurityTips,
      generatedApiKeyPreview: 'sk_live_vittrade_demo_122',
      endpoint: '/api/mobile/trade/trade-bots-security-settings',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'PATCH /user/settings or module settings',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeBotHistorySnapshot getBotHistory() {
    return const TradeBotHistorySnapshot(
      trades: _botHistoryTrades,
      endpoint: '/api/mobile/trade/trade-bots-history',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotPerformanceAnalyticsSnapshot getBotPerformanceAnalytics() {
    return const TradeBotPerformanceAnalyticsSnapshot(
      metrics: TradeBotPerformanceMetrics(
        totalPnl: 199.30,
        winRate: 68.2,
        sharpeRatio: 1.87,
        avgWin: 12.30,
        avgLoss: -8.50,
        profitFactor: 2.14,
        totalTrades: 96,
        bestTrade: 42.80,
        worstTrade: -24.50,
      ),
      pnlPoints: _botPerformancePnlPoints,
      winLossPoints: _botPerformanceWinLossPoints,
      strategyPerformance: _botStrategyPerformance,
      durationDistribution: _botDurationDistribution,
      endpoint: '/api/mobile/trade/trade-bots-performance-analytics',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotBacktestingSnapshot getBotBacktesting() {
    return const TradeBotBacktestingSnapshot(
      strategies: _botBacktestStrategies,
      pairs: _botBacktestPairs,
      dateRanges: _botBacktestDateRanges,
      defaultStrategyId: 'grid',
      defaultPair: 'BTC/USDT',
      defaultDateRangeId: '6m',
      defaultCapital: 1000,
      endpoint: '/api/mobile/trade/trade-bots-backtesting',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'POST /bots/backtest/run',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeBotStrategyCompareSnapshot getBotStrategyCompare() {
    return const TradeBotStrategyCompareSnapshot(
      strategies: _botCompareStrategies,
      equityPoints: _botCompareEquityPoints,
      recommendations: _botCompareRecommendations,
      defaultSelectedIds: ['grid', 'momentum'],
      analysisPeriod:
          'All strategies backtested on BTC/USDT from Sep 2025 - Mar 2026 '
          'with \$1,000 initial capital. Results assume same market '
          'conditions - actual performance will vary.',
      endpoint: '/api/mobile/trade/trade-bots-strategy-compare',
      actionDraft:
          'GET /bots/strategy-compare?strategies=grid,momentum; '
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotOptimizationSnapshot getBotOptimization() {
    return const TradeBotOptimizationSnapshot(
      targets: _botOptimizationTargets,
      parameterRanges: _botOptimizationRanges,
      steps: _botOptimizationSteps,
      defaultTargetId: 'sharpe',
      endpoint: '/api/mobile/trade/trade-bots-optimization',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'POST /bots/optimization/run',
      supportedStates: [
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ],
    );
  }

  @override
  TradeBotPortfolioDashboardSnapshot getBotPortfolioDashboard() {
    return const TradeBotPortfolioDashboardSnapshot(
      summary: _botPortfolioSummary,
      allocations: _botPortfolioAllocations,
      equityPoints: _botPortfolioEquity,
      correlations: _botPortfolioCorrelations,
      healthItems: _botPortfolioHealthItems,
      endpoint: '/api/mobile/trade/trade-bots-portfolio-dashboard',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotDrawdownAnalyzerSnapshot getBotDrawdownAnalyzer() {
    return const TradeBotDrawdownAnalyzerSnapshot(
      summary: _botDrawdownSummary,
      underwaterPoints: _botUnderwaterPoints,
      durationBuckets: _botDrawdownDurationBuckets,
      events: _botDrawdownEvents,
      insights: _botDrawdownInsights,
      endpoint: '/api/mobile/trade/trade-bots-drawdown-analyzer',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotEquityCurveSnapshot getBotEquityCurve() {
    return const TradeBotEquityCurveSnapshot(
      summary: _botEquityCurveSummary,
      equityPoints: _botEquityCurvePoints,
      monthlyReturns: _botEquityMonthlyReturns,
      performanceStats: _botEquityPerformanceStats,
      analysisItems: _botEquityAnalysisItems,
      endpoint: '/api/mobile/trade/trade-bots-equity-curve',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotGuideSnapshot getBotGuide() {
    return const TradeBotGuideSnapshot(
      strategies: _botGuideStrategies,
      bestPractices: _botGuideBestPractices,
      mistakes: _botGuideMistakes,
      endpoint: '/api/mobile/trade/trade-bots-guide',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotFaqSnapshot getBotFaq() {
    return const TradeBotFaqSnapshot(
      categories: _botFaqCategories,
      endpoint: '/api/mobile/trade/trade-bots-faq',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeBotTaxReportingSnapshot getBotTaxReporting() {
    return const TradeBotTaxReportingSnapshot(
      taxYears: ['2026', '2025', '2024', '2023'],
      defaultYear: '2025',
      defaultCostBasisMethod: 'FIFO',
      summary: _botTaxSummary,
      reportTypes: _botTaxReportTypes,
      breakdown: _botTaxBreakdown,
      taxNotes: _botTaxNotes,
      endpoint: '/api/mobile/trade/trade-bots-tax-reporting',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable; '
          'POST /exports',
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
  TradeBotApiDocumentationSnapshot getBotApiDocumentation() {
    return const TradeBotApiDocumentationSnapshot(
      tabs: [
        TradeBotApiTab(id: 'endpoints', label: 'endpoints'),
        TradeBotApiTab(id: 'websocket', label: 'websocket'),
        TradeBotApiTab(id: 'examples', label: 'examples'),
      ],
      defaultView: 'endpoints',
      defaultLanguage: 'javascript',
      endpoints: _botApiEndpoints,
      websocketUrl: 'wss://ws.tradingplatform.com/bots?apiKey=YOUR_API_KEY',
      websocketEvents: _botApiWebSocketEvents,
      codeExamples: _botApiCodeExamples,
      rateLimits: _botApiRateLimits,
      authenticationHeader: 'Authorization: Bearer YOUR_API_KEY',
      endpoint: '/api/mobile/trade/trade-bots-api-documentation',
      actionDraft:
          'POST /trade/order-preview + POST /trade/orders; '
          'POST /bots/create|pause|stop|optimize where applicable',
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
  TradeSettings patchTradeSettings(TradeSettings settings) {
    return settings;
  }

  @override
  TradeCopySettingsSaveResult patchCopySettings(TradeCopySettings settings) {
    return TradeCopySettingsSaveResult(status: 'saved', settings: settings);
  }

  @override
  TradeCopyConfigurationPreview previewCopyConfiguration(
    TradeCopyConfigurationDraft draft,
  ) {
    final detail = getCopyProviderDetail(providerId: draft.providerId);
    final validations = _copyConfigurationValidations(draft, detail.provider);
    return TradeCopyConfigurationPreview(
      providerId: draft.providerId,
      status:
          validations.any(
            (item) => item.level == TradeCopyConfigurationValidationLevel.error,
          )
          ? 'blocked'
          : 'ready',
      draft: draft,
      feePreview: _copyConfigurationFeePreview(draft),
      validations: validations,
    );
  }

  @override
  TradeCopyConfirmationResult submitCopyConfirmation(
    TradeCopyConfirmationRequest request,
  ) {
    final accepted = request.acceptedConsentIds.toSet();
    final missingRequiredConsent = _copyConfirmationConsents.any(
      (item) => item.required && !accepted.contains(item.id),
    );
    return TradeCopyConfirmationResult(
      providerId: request.providerId,
      status: missingRequiredConsent ? 'blocked' : 'pending_cooling_off',
      auditTrailId: 'AUD-COPY-073-${request.providerId.toUpperCase()}',
      coolingOffHours: missingRequiredConsent ? 0 : 24,
      activeCopiesPath: '/trade/copy-trading/active',
    );
  }

  @override
  TradeProviderApplicationResult submitProviderApplication(
    TradeProviderApplicationDraft draft,
  ) {
    return const TradeProviderApplicationResult(
      applicationId: 'CPA-069-DEMO',
      status: 'submitted',
      reviewWindow: '2-3 ngày làm việc',
    );
  }

  @override
  TradeCopyAuditExportResult createCopyAuditExport(
    TradeCopyAuditExportRequest request,
  ) {
    return TradeCopyAuditExportResult(
      exportId: 'EXP-COPY-AUDIT-077-${request.copyId.toUpperCase()}',
      format: request.format,
      status: 'ready',
      downloadUrl: '/exports/copy-audit-${request.copyId}.${request.format}',
    );
  }

  @override
  TradeDisputeSubmissionResult submitDisputeComplaint(
    TradeDisputeComplaintDraft draft,
  ) {
    return const TradeDisputeSubmissionResult(
      caseId: 'case-003',
      status: 'submitted',
      message: 'Complaint submitted successfully',
    );
  }

  @override
  TradeExportResult createTradeExport(TradeExportRequest request) {
    return TradeExportResult(
      exportId: 'EXP-TRADE-054',
      format: request.format,
      status: 'ready',
      downloadUrl: '/exports/EXP-TRADE-054.${request.format}',
    );
  }

  @override
  TradeBotTaxReportExportResult createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  ) {
    return TradeBotTaxReportExportResult(
      status: request.reportTypeIds.isEmpty ? 'blocked' : 'ready',
      year: request.year,
      reportCount: request.reportTypeIds.length,
      exportId:
          'BOT-TAX-${request.year}-${request.costBasisMethod.toUpperCase()}',
    );
  }

  @override
  TradeExPostCostsReportExportResult createExPostCostsReportExport({
    int year = 2025,
  }) {
    return TradeExPostCostsReportExportResult(
      status: 'ready',
      year: year,
      downloadUrl: '/exports/ex-post-cost-report-$year.pdf',
    );
  }

  @override
  TradeConvertQuote previewConvert(TradeConvertRequest request) {
    final fromAsset = _convertAssetBySymbol(request.fromSymbol);
    final toAsset = _convertAssetBySymbol(request.toSymbol);
    final grossRate = fromAsset.priceUsd / toAsset.priceUsd;
    const feeRate = .001;
    final effectiveRate = grossRate * (1 - feeRate);
    final toAmount = request.amount <= 0 ? 0.0 : request.amount * effectiveRate;
    final feeUsd = request.amount <= 0
        ? 0.0
        : request.amount * fromAsset.priceUsd * feeRate;
    final ratePrecision = toAsset.priceUsd >= 1000 ? 6 : 4;
    return TradeConvertQuote(
      fromSymbol: fromAsset.symbol,
      toSymbol: toAsset.symbol,
      fromAmount: request.amount,
      toAmount: toAmount,
      feeUsd: feeUsd,
      rate: effectiveRate,
      quoteLabel:
          '1 ${fromAsset.symbol} = ${effectiveRate.toStringAsFixed(ratePrecision)} ${toAsset.symbol}',
      validSeconds: 14,
      canSubmit: request.amount * fromAsset.priceUsd >= 10,
    );
  }

  @override
  TradeConvertReceipt submitConvert(TradeConvertRequest request) {
    return TradeConvertReceipt(
      convertId: 'CVT-DEMO-056',
      quote: previewConvert(request),
      status: 'submitted',
    );
  }

  @override
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft) {
    final futures = getFutures(pairId: draft.pairId);
    final price = draft.limitPrice ?? futures.markPrice;
    final positionSize = draft.margin * draft.leverage;
    final liquidationDistance = 90 / draft.leverage;
    final liquidationPrice = draft.side == TradeFuturesSide.long
        ? price * (1 - liquidationDistance / 100)
        : price * (1 + liquidationDistance / 100);
    return TradeFuturesPreview(
      positionSize: positionSize,
      contractQty: price <= 0 ? 0 : positionSize / price,
      liquidationPrice: liquidationPrice,
      openFee: positionSize * .0002,
      canOpen: draft.margin > 0 && draft.margin <= 5000,
    );
  }

  @override
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft) {
    return TradeFuturesReceipt(
      orderId: 'FUT-DEMO-057',
      preview: previewFuturesOrder(draft),
      status: 'submitted',
    );
  }

  @override
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    final leverage = request.leverage.clamp(1, 100).toInt();
    final risk = _futuresLeverageRisk(leverage);
    final positionSize = request.exampleMargin * leverage;
    final onePercent = positionSize * .01;
    return TradeFuturesLeveragePreview(
      leverage: leverage,
      riskLabel: risk.label,
      riskLevel: risk.level,
      riskColorHex: risk.colorHex,
      positionSize: positionSize,
      liquidationDistancePct: 90 / leverage,
      openFee: positionSize * .0002,
      profitAtOnePct: onePercent,
      lossAtOnePct: onePercent,
      warningText: _futuresLeverageWarning(leverage),
      showRiskTips: leverage > 20,
    );
  }

  @override
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    return TradeFuturesLeverageReceipt(
      adjustmentId: 'LEV-DEMO-058',
      pairId: request.pairId,
      preview: previewFuturesLeverage(request),
      status: 'submitted',
    );
  }

  @override
  TradeBotActionResult submitBotAction(TradeBotActionRequest request) {
    return TradeBotActionResult(
      botId: request.botId,
      action: request.action,
      status: 'accepted',
    );
  }

  @override
  TradeBotEmergencyStopResult submitBotEmergencyStop(
    TradeBotEmergencyStopDraft draft,
  ) {
    final snapshot = getBotEmergencyStop();
    return TradeBotEmergencyStopResult(
      status: draft.confirmed ? 'accepted' : 'rejected',
      stoppedBotCount: draft.confirmed ? snapshot.bots.length : 0,
      redirectPath: snapshot.completionPath,
    );
  }

  @override
  TradeBotSecuritySettingsResult patchBotSecuritySettings(
    TradeBotSecuritySettingsDraft draft,
  ) {
    return TradeBotSecuritySettingsResult(
      status: 'saved',
      twoFaEnabled: draft.twoFaEnabled,
    );
  }

  @override
  TradeBotHistoryExportResult createBotHistoryExport(
    TradeBotHistoryExportRequest request,
  ) {
    return TradeBotHistoryExportResult(
      status: 'ready',
      downloadUrl: '/exports/BOT-HISTORY-123.${request.format}',
    );
  }

  @override
  TradeBotBacktestResult runBotBacktest(TradeBotBacktestRequest request) {
    return const TradeBotBacktestResult(
      status: 'queued',
      reportId: 'BOT-BACKTEST-125',
      progress: 0,
    );
  }

  @override
  TradeBotOptimizationResult runBotOptimization(
    TradeBotOptimizationRequest request,
  ) {
    return const TradeBotOptimizationResult(
      status: 'queued',
      jobId: 'BOT-OPT-127',
      estimatedMinutes: 3,
    );
  }

  @override
  TradeBotCreateResult createTradingBot(TradeBotCreateRequest request) {
    return TradeBotCreateResult(
      botId: 'BOT-DEMO-059',
      strategyId: request.strategyId,
      status: 'created',
    );
  }

  @override
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft) {
    return TradeOcoOrderResult(
      orderId: 'OCO-DEMO-060',
      symbol: draft.symbol,
      status: 'submitted',
    );
  }

  @override
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  ) {
    final riskAmount = request.accountBalance * request.riskPct / 100;
    final perUnitRisk = (request.entryPrice - request.stopPrice).abs();
    final suggestedAmount = perUnitRisk <= 0 ? 0.0 : riskAmount / perUnitRisk;
    return TradePositionSizeResult(
      riskAmount: riskAmount,
      perUnitRisk: perUnitRisk,
      suggestedAmount: suggestedAmount,
      notional: suggestedAmount * request.entryPrice,
    );
  }

  @override
  TradeSlippageSettings updateSlippageSettings(TradeSlippageSettings settings) {
    return settings;
  }

  @override
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request) {
    return TradeOrderAmendmentResult(
      orderId: request.orderId,
      status: 'modified',
      queuePositionPreserved: true,
    );
  }

  @override
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  ) {
    return TradeAdvancedToolActionResult(
      toolId: request.toolId,
      action: request.action,
      status: 'accepted',
      affectedCount: request.orderIds.isEmpty ? 1 : request.orderIds.length,
    );
  }

  @override
  TradeCopyActionResult submitCopyTradingAction(
    TradeCopyActionRequest request,
  ) {
    return TradeCopyActionResult(
      providerId: request.providerId,
      action: request.action,
      status: 'accepted',
    );
  }

  @override
  TradeOrderPreview previewOrder(TradeOrderDraft draft) {
    final total = draft.price * draft.amount;
    const feeRate = .00085;
    final fee = total * feeRate;
    return TradeOrderPreview(
      total: total,
      fee: fee,
      feeRate: feeRate,
      estimatedReceive: total - fee,
    );
  }

  @override
  TradeOrderReceipt submitOrder(TradeOrderDraft draft) {
    return TradeOrderReceipt(
      orderId: 'ORD-DEMO-048',
      preview: previewOrder(draft),
      status: 'submitted',
    );
  }

  @override
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  }) {
    return TradeOrderActionResult(
      orderId: orderId,
      action: action,
      status: 'success',
    );
  }
}

final class _FuturesLeverageRisk {
  const _FuturesLeverageRisk({
    required this.label,
    required this.colorHex,
    required this.level,
  });

  final String label;
  final int colorHex;
  final int level;
}

_FuturesLeverageRisk _futuresLeverageRisk(int leverage) {
  if (leverage <= 3) {
    return const _FuturesLeverageRisk(
      label: 'Rất thấp',
      colorHex: 0xFF10B981,
      level: 1,
    );
  }
  if (leverage <= 5) {
    return const _FuturesLeverageRisk(
      label: 'Thấp',
      colorHex: 0xFF10B981,
      level: 2,
    );
  }
  if (leverage <= 10) {
    return const _FuturesLeverageRisk(
      label: 'Trung bình thấp',
      colorHex: 0xFF84CC16,
      level: 3,
    );
  }
  if (leverage <= 20) {
    return const _FuturesLeverageRisk(
      label: 'Trung bình',
      colorHex: 0xFFF59E0B,
      level: 4,
    );
  }
  if (leverage <= 50) {
    return const _FuturesLeverageRisk(
      label: 'Cao',
      colorHex: 0xFFF97316,
      level: 5,
    );
  }
  return const _FuturesLeverageRisk(
    label: 'Rất cao',
    colorHex: 0xFFEF4444,
    level: 6,
  );
}

String _futuresLeverageWarning(int leverage) {
  if (leverage > 50) {
    return 'Đòn bẩy cực kỳ cao! Giá chỉ cần biến động nhỏ cũng có thể thanh lý toàn bộ vị thế. Chỉ dành cho trader có kinh nghiệm.';
  }
  if (leverage > 20) {
    return 'Đòn bẩy cao làm tăng đáng kể rủi ro thanh lý. Hãy đảm bảo quản lý rủi ro chặt chẽ với Stop Loss.';
  }
  return 'Đòn bẩy giúp khuếch đại lợi nhuận nhưng cũng tăng rủi ro. Luôn sử dụng Take Profit và Stop Loss.';
}

const List<TradePair> _pairs = [
  TradePair(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    price: 67543.21,
    changePct: 2.34,
    logoColorHex: 0xFFE58A00,
  ),
  TradePair(
    id: 'ethusdt',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    quoteAsset: 'USDT',
    price: 3521.44,
    changePct: 1.18,
    logoColorHex: 0xFF8B5CF6,
  ),
  TradePair(
    id: 'solusdt',
    symbol: 'SOL/USDT',
    baseAsset: 'SOL',
    quoteAsset: 'USDT',
    price: 146.72,
    changePct: -0.42,
    logoColorHex: 0xFF10B981,
  ),
];

const TradeSettings _defaultTradeSettings = TradeSettings(
  defaultOrderType: 'limit',
  defaultSlippage: .5,
  confirmOrders: true,
  skipConfirmSmall: false,
  smallOrderThreshold: 50,
  soundOnFill: true,
  hapticOnFill: true,
  showTpsl: false,
  bracketMode: false,
  priceDecimals: 'auto',
  defaultPctButtons: true,
  showOrderBook: true,
  showRecentTrades: true,
  chartTimeframe: '1h',
);

const List<TradeExportFormat> _tradeExportFormats = [
  TradeExportFormat(
    id: 'csv',
    label: 'CSV',
    description: 'Excel, Google Sheets',
  ),
  TradeExportFormat(id: 'pdf', label: 'PDF', description: 'Lưu trữ, in ấn'),
];

const List<TradeExportPeriod> _tradeExportPeriods = [
  TradeExportPeriod(id: '7d', label: '7 ngày'),
  TradeExportPeriod(id: '30d', label: '30 ngày'),
  TradeExportPeriod(id: '90d', label: '90 ngày'),
  TradeExportPeriod(id: '1y', label: '1 năm'),
  TradeExportPeriod(id: 'custom', label: 'Tùy chỉnh'),
];

const List<TradeExportInclude> _tradeExportIncludes = [
  TradeExportInclude(id: 'spot', label: 'Spot Trading', checked: true),
  TradeExportInclude(id: 'futures', label: 'Futures', checked: true),
  TradeExportInclude(id: 'margin', label: 'Margin', checked: true),
  TradeExportInclude(id: 'convert', label: 'Convert', checked: true),
  TradeExportInclude(id: 'deposits', label: 'Nạp tiền', checked: false),
  TradeExportInclude(id: 'withdrawals', label: 'Rút tiền', checked: false),
  TradeExportInclude(id: 'fees', label: 'Chi tiết phí', checked: true),
  TradeExportInclude(id: 'pnl', label: 'P/L tổng hợp', checked: true),
];

const List<TradeConvertAsset> _convertAssets = [
  TradeConvertAsset(
    symbol: 'USDT',
    name: 'Tether USD',
    balance: 12450.80,
    priceUsd: 1,
    colorHex: 0xFF26A17B,
  ),
  TradeConvertAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    balance: .23451,
    priceUsd: 67543.21,
    colorHex: 0xFFF7931A,
  ),
  TradeConvertAsset(
    symbol: 'ETH',
    name: 'Ethereum',
    balance: 3.521,
    priceUsd: 3521.45,
    colorHex: 0xFF627EEA,
  ),
  TradeConvertAsset(
    symbol: 'SOL',
    name: 'Solana',
    balance: 45.8,
    priceUsd: 178.32,
    colorHex: 0xFF9945FF,
  ),
  TradeConvertAsset(
    symbol: 'BNB',
    name: 'BNB',
    balance: 12.5,
    priceUsd: 412.87,
    colorHex: 0xFFF3BA2F,
  ),
  TradeConvertAsset(
    symbol: 'ADA',
    name: 'Cardano',
    balance: 5000,
    priceUsd: .4521,
    colorHex: 0xFF0033AD,
  ),
  TradeConvertAsset(
    symbol: 'MATIC',
    name: 'Polygon',
    balance: 2340,
    priceUsd: .8976,
    colorHex: 0xFF8247E5,
  ),
  TradeConvertAsset(
    symbol: 'AVAX',
    name: 'Avalanche',
    balance: 18.5,
    priceUsd: 38.54,
    colorHex: 0xFFE84142,
  ),
];

const List<TradeConvertFavoritePair> _convertFavoritePairs = [
  TradeConvertFavoritePair(fromSymbol: 'USDT', toSymbol: 'BTC'),
  TradeConvertFavoritePair(fromSymbol: 'USDT', toSymbol: 'ETH'),
  TradeConvertFavoritePair(fromSymbol: 'BTC', toSymbol: 'ETH'),
  TradeConvertFavoritePair(fromSymbol: 'USDT', toSymbol: 'SOL'),
];

const List<TradeConvertHistoryRecord> _convertHistory = [
  TradeConvertHistoryRecord(
    id: 'tx-001',
    fromSymbol: 'USDT',
    toSymbol: 'BTC',
    fromAmount: 500,
    toAmount: .007401,
    feeUsd: .50,
    rate: 67540,
    timeLabel: '2 phút trước',
    status: 'Hoàn tất',
  ),
  TradeConvertHistoryRecord(
    id: 'tx-002',
    fromSymbol: 'ETH',
    toSymbol: 'USDT',
    fromAmount: 1,
    toAmount: 3518.93,
    feeUsd: 3.52,
    rate: 3521.45,
    timeLabel: '1 giờ trước',
    status: 'Hoàn tất',
  ),
  TradeConvertHistoryRecord(
    id: 'tx-003',
    fromSymbol: 'USDT',
    toSymbol: 'SOL',
    fromAmount: 100,
    toAmount: .5604,
    feeUsd: .10,
    rate: 178.45,
    timeLabel: '3 giờ trước',
    status: 'Hoàn tất',
  ),
];

TradeConvertAsset _convertAssetBySymbol(String symbol) {
  return _convertAssets.firstWhere(
    (asset) => asset.symbol == symbol,
    orElse: () => _convertAssets.first,
  );
}

const List<TradeChartIndicator> _advancedChartIndicators = [
  TradeChartIndicator(
    id: 'ma7',
    label: 'MA(7)',
    colorHex: 0xFFF59E0B,
    enabled: true,
    period: 7,
  ),
  TradeChartIndicator(
    id: 'ma25',
    label: 'MA(25)',
    colorHex: 0xFF3B82F6,
    enabled: true,
    period: 25,
  ),
  TradeChartIndicator(
    id: 'ma99',
    label: 'MA(99)',
    colorHex: 0xFF8B5CF6,
    enabled: false,
    period: 99,
  ),
  TradeChartIndicator(
    id: 'ema',
    label: 'EMA(20)',
    colorHex: 0xFF06B6D4,
    enabled: false,
    period: 20,
  ),
  TradeChartIndicator(
    id: 'bb',
    label: 'Bollinger',
    colorHex: 0xFF10B981,
    enabled: false,
  ),
  TradeChartIndicator(
    id: 'rsi',
    label: 'RSI(14)',
    colorHex: 0xFFEF4444,
    enabled: false,
  ),
  TradeChartIndicator(
    id: 'macd',
    label: 'MACD',
    colorHex: 0xFF9945FF,
    enabled: false,
  ),
  TradeChartIndicator(
    id: 'vol',
    label: 'Volume',
    colorHex: 0xFF8B95B3,
    enabled: true,
  ),
];

const List<TradeCandle> _advancedChartCandles = [
  TradeCandle(
    time: '09:00',
    open: 64020,
    high: 64110,
    low: 63940,
    close: 64070,
    volume: 4200,
  ),
  TradeCandle(
    time: '10:00',
    open: 64070,
    high: 64145,
    low: 63980,
    close: 64010,
    volume: 3800,
  ),
  TradeCandle(
    time: '11:00',
    open: 64010,
    high: 64080,
    low: 63890,
    close: 63960,
    volume: 5200,
  ),
  TradeCandle(
    time: '12:00',
    open: 63960,
    high: 64190,
    low: 63950,
    close: 64150,
    volume: 4900,
  ),
  TradeCandle(
    time: '13:00',
    open: 64150,
    high: 64220,
    low: 64070,
    close: 64110,
    volume: 6100,
  ),
  TradeCandle(
    time: '14:00',
    open: 64110,
    high: 64260,
    low: 64090,
    close: 64210,
    volume: 6700,
  ),
  TradeCandle(
    time: '15:00',
    open: 64210,
    high: 64320,
    low: 64190,
    close: 64280,
    volume: 7400,
  ),
  TradeCandle(
    time: '16:00',
    open: 64280,
    high: 64420,
    low: 64230,
    close: 64390,
    volume: 8100,
  ),
  TradeCandle(
    time: '17:00',
    open: 64390,
    high: 64570,
    low: 64340,
    close: 64510,
    volume: 9000,
  ),
  TradeCandle(
    time: '18:00',
    open: 64510,
    high: 64640,
    low: 64480,
    close: 64590,
    volume: 8700,
  ),
  TradeCandle(
    time: '19:00',
    open: 64590,
    high: 64610,
    low: 64380,
    close: 64430,
    volume: 7800,
  ),
  TradeCandle(
    time: '20:00',
    open: 64430,
    high: 64560,
    low: 64390,
    close: 64520,
    volume: 6900,
  ),
  TradeCandle(
    time: '21:00',
    open: 64520,
    high: 64620,
    low: 64460,
    close: 64490,
    volume: 6400,
  ),
  TradeCandle(
    time: '22:00',
    open: 64490,
    high: 64570,
    low: 64320,
    close: 64380,
    volume: 7200,
  ),
  TradeCandle(
    time: '23:00',
    open: 64380,
    high: 64480,
    low: 64270,
    close: 64440,
    volume: 7700,
  ),
  TradeCandle(
    time: '00:00',
    open: 64440,
    high: 64520,
    low: 64360,
    close: 64480,
    volume: 6800,
  ),
  TradeCandle(
    time: '01:00',
    open: 64480,
    high: 64510,
    low: 64240,
    close: 64300,
    volume: 8200,
  ),
  TradeCandle(
    time: '02:00',
    open: 64300,
    high: 64440,
    low: 64270,
    close: 64390,
    volume: 7300,
  ),
  TradeCandle(
    time: '03:00',
    open: 64390,
    high: 64490,
    low: 64290,
    close: 64350,
    volume: 7600,
  ),
  TradeCandle(
    time: '04:00',
    open: 64350,
    high: 64460,
    low: 64260,
    close: 64410,
    volume: 8400,
  ),
  TradeCandle(
    time: '05:00',
    open: 64410,
    high: 64530,
    low: 64380,
    close: 64470,
    volume: 7900,
  ),
  TradeCandle(
    time: '06:00',
    open: 64470,
    high: 64500,
    low: 64230,
    close: 64320,
    volume: 8800,
  ),
  TradeCandle(
    time: '07:00',
    open: 64320,
    high: 64470,
    low: 64240,
    close: 64430,
    volume: 8300,
  ),
  TradeCandle(
    time: '08:00',
    open: 64430,
    high: 64510,
    low: 64290,
    close: 64370,
    volume: 7600,
  ),
  TradeCandle(
    time: '09:00',
    open: 64370,
    high: 64475.28,
    low: 64185.74,
    close: 64268.03,
    volume: 8000,
  ),
];

const List<TradeDashboardPosition> _dashboardPositions = [
  TradeDashboardPosition(
    id: 'sp1',
    symbol: 'BTC/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: .045,
    entryPrice: 65200,
    currentPrice: 67543.21,
    pnl: 105.44,
    pnlPct: 3.59,
    takeProfit: 72000,
    stopLoss: 63000,
  ),
  TradeDashboardPosition(
    id: 'sp2',
    symbol: 'ETH/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: 1.2,
    entryPrice: 3380,
    currentPrice: 3521.45,
    pnl: 169.74,
    pnlPct: 4.18,
  ),
  TradeDashboardPosition(
    id: 'sp3',
    symbol: 'SOL/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: 25,
    entryPrice: 192,
    currentPrice: 185.32,
    pnl: -167,
    pnlPct: -3.48,
  ),
  TradeDashboardPosition(
    id: 'ft1',
    symbol: 'ETH/USDT',
    type: TradePositionType.futures,
    side: TradePositionSide.long,
    size: .5,
    entryPrice: 3480,
    currentPrice: 3521.45,
    pnl: 20.73,
    pnlPct: 1.19,
    leverage: 10,
    liquidPrice: 3150,
    margin: 174,
    takeProfit: 3800,
    stopLoss: 3300,
  ),
  TradeDashboardPosition(
    id: 'ft2',
    symbol: 'SOL/USDT',
    type: TradePositionType.futures,
    side: TradePositionSide.short,
    size: 10,
    entryPrice: 185,
    currentPrice: 178.32,
    pnl: 66.8,
    pnlPct: 3.61,
    leverage: 5,
    liquidPrice: 222,
    margin: 370,
  ),
  TradeDashboardPosition(
    id: 'mg1',
    symbol: 'BTC/USDT',
    type: TradePositionType.margin,
    side: TradePositionSide.long,
    size: .02,
    entryPrice: 66800,
    currentPrice: 67543.21,
    pnl: 14.86,
    pnlPct: 1.11,
    leverage: 3,
    margin: 445.33,
  ),
];

const List<TradeBotStrategy> _botStrategies = [
  TradeBotStrategy(
    id: 'dca',
    name: 'DCA Bot',
    description: 'Dollar Cost Averaging - Mua định kỳ, giảm rủi ro biến động',
    longDescription:
        'DCA Bot tự động mua một lượng cố định theo chu kỳ thời gian, bất kể giá tăng hay giảm.',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    risk: TradeBotRisk.low,
    avgReturn: '+8-15% / năm',
    suitableFor: 'Nhà đầu tư dài hạn, người mới',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT', 'BNB/USDT'],
      ),
      TradeBotParam(
        key: 'amount',
        label: 'Mỗi lần mua',
        type: 'number',
        defaultValue: '50',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'interval',
        label: 'Chu kỳ',
        type: 'select',
        defaultValue: 'Mỗi ngày',
        options: ['Mỗi giờ', 'Mỗi ngày', 'Mỗi tuần', 'Mỗi tháng'],
      ),
      TradeBotParam(
        key: 'totalBudget',
        label: 'Ngân sách tổng',
        type: 'number',
        defaultValue: '1000',
        unit: 'USDT',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'grid',
    name: 'Grid Bot',
    description: 'Lưới giá - Mua thấp bán cao tự động trong khoảng giá',
    longDescription:
        'Grid Bot đặt nhiều lệnh mua và bán trong khoảng giá xác định, tự động kiếm lời khi thị trường đi ngang.',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    risk: TradeBotRisk.medium,
    avgReturn: '+15-40% / năm',
    suitableFor: 'Thị trường sideway, trader kinh nghiệm',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'ETH/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'upperPrice',
        label: 'Giá trần',
        type: 'number',
        defaultValue: '4000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'lowerPrice',
        label: 'Giá sàn',
        type: 'number',
        defaultValue: '3000',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'gridCount',
        label: 'Số lưới',
        type: 'number',
        defaultValue: '20',
        unit: 'lưới',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    description: 'Theo đà thị trường - Mua khi uptrend, bán khi downtrend',
    longDescription:
        'Momentum Bot sử dụng chỉ báo kỹ thuật để xác định xu hướng và tự động vào/ra lệnh.',
    icon: 'chart',
    colorHex: 0xFF10B981,
    risk: TradeBotRisk.medium,
    avgReturn: '+20-50% / năm',
    suitableFor: 'Thị trường trending, trader trung cấp',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'investment',
        label: 'Vốn giao dịch',
        type: 'number',
        defaultValue: '500',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'stopLoss',
        label: 'Stop loss',
        type: 'number',
        defaultValue: '5',
        unit: '%',
      ),
    ],
  ),
  TradeBotStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    description: 'Tăng gấp đôi khi thua - Phục hồi nhanh sau drawdown',
    longDescription:
        'Martingale tăng kích thước lệnh sau mỗi lần thua để bù đắp khi thắng. Tiềm năng lợi nhuận cao nhưng rủi ro cũng cao.',
    icon: 'target',
    colorHex: 0xFF8B5CF6,
    risk: TradeBotRisk.high,
    avgReturn: '+30-80% / năm',
    suitableFor: 'Trader chuyên nghiệp, vốn lớn',
    params: [
      TradeBotParam(
        key: 'pair',
        label: 'Cặp giao dịch',
        type: 'select',
        defaultValue: 'BTC/USDT',
        options: ['BTC/USDT', 'ETH/USDT', 'SOL/USDT'],
      ),
      TradeBotParam(
        key: 'baseOrder',
        label: 'Lệnh cơ bản',
        type: 'number',
        defaultValue: '20',
        unit: 'USDT',
      ),
      TradeBotParam(
        key: 'multiplier',
        label: 'Hệ số nhân',
        type: 'number',
        defaultValue: '2',
        unit: 'x',
      ),
    ],
  ),
];

const List<TradeBot> _activeBots = [
  TradeBot(
    id: 'bot1',
    strategyId: 'dca',
    strategyName: 'DCA Bot',
    icon: 'calendar',
    colorHex: 0xFF3B82F6,
    pair: 'BTC/USDT',
    status: TradeBotStatus.running,
    profit: 84.20,
    profitPct: 8.42,
    trades: 47,
    investment: 1000,
    startDate: '01/01/2026',
    runtime: '52 ngày',
  ),
  TradeBot(
    id: 'bot2',
    strategyId: 'grid',
    strategyName: 'Grid Bot',
    icon: 'bolt',
    colorHex: 0xFFF59E0B,
    pair: 'ETH/USDT',
    status: TradeBotStatus.running,
    profit: 127.40,
    profitPct: 25.48,
    trades: 234,
    investment: 500,
    startDate: '15/01/2026',
    runtime: '38 ngày',
  ),
  TradeBot(
    id: 'bot3',
    strategyId: 'momentum',
    strategyName: 'Momentum Bot',
    icon: 'chart',
    colorHex: 0xFF10B981,
    pair: 'SOL/USDT',
    status: TradeBotStatus.paused,
    profit: -12.30,
    profitPct: -2.46,
    trades: 18,
    investment: 500,
    startDate: '10/02/2026',
    runtime: '13 ngày',
  ),
];

const List<TradeRiskFeature> _riskFeatures = [
  TradeRiskFeature(
    id: 'oco',
    title: 'OCO Orders',
    description:
        'Đặt Take Profit + Stop Loss cùng lúc. Khi 1 lệnh khớp, lệnh còn lại tự động hủy.',
    colorHex: 0xFF10B981,
    iconName: 'trending',
  ),
  TradeRiskFeature(
    id: 'positions',
    title: 'Position Dashboard',
    description:
        'Theo dõi P&L thời gian thực, entry price, break-even và liquidation risk.',
    colorHex: 0xFFF59E0B,
    iconName: 'check',
  ),
  TradeRiskFeature(
    id: 'calculator',
    title: 'Position Sizing Calculator',
    description:
        'Tính toán khối lượng lệnh tối ưu dựa trên risk % và stop loss.',
    colorHex: 0xFF8B5CF6,
    iconName: 'calculator',
  ),
];

const List<TradeRiskPosition> _riskPositions = [
  TradeRiskPosition(
    id: '1',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    logoColorHex: 0xFFF7931A,
    side: TradeRiskPositionSide.long,
    amount: 2.5,
    entryPrice: 67200,
    currentPrice: 69000,
    openedAtLabel: '10/03/2026 08:30',
  ),
  TradeRiskPosition(
    id: '2',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    logoColorHex: 0xFF627EEA,
    side: TradeRiskPositionSide.long,
    amount: 15,
    entryPrice: 3180,
    currentPrice: 3300,
    openedAtLabel: '09/03/2026 14:20',
  ),
  TradeRiskPosition(
    id: '3',
    symbol: 'SOL/USDT',
    baseAsset: 'SOL',
    logoColorHex: 0xFF14F195,
    side: TradeRiskPositionSide.short,
    amount: 100,
    entryPrice: 145,
    currentPrice: 142,
    leverage: 5,
    liquidationPrice: 155,
    openedAtLabel: '11/03/2026 09:00',
  ),
];

const List<TradeRiskStatusItem> _riskStatusItems = [
  TradeRiskStatusItem(label: 'OCO Order Form', complete: true),
  TradeRiskStatusItem(label: 'Position Dashboard', complete: true),
  TradeRiskStatusItem(label: 'Position Sizing Calculator', complete: true),
  TradeRiskStatusItem(label: 'Integration với TradePage', complete: false),
  TradeRiskStatusItem(label: 'Backend API Integration', complete: false),
];

const List<TradeExecutionFeature> _executionFeatures = [
  TradeExecutionFeature(
    id: 'slippage',
    title: 'Slippage Protection',
    description:
        'Set max slippage tolerance. Auto-reject orders nếu giá thực tế vượt ngưỡng.',
    colorHex: 0xFF10B981,
    iconName: 'shield',
  ),
  TradeExecutionFeature(
    id: 'execution',
    title: 'Execution Report',
    description:
        'Chi tiết multi-venue execution: slippage, savings, execution time, quality score.',
    colorHex: 0xFFF59E0B,
    iconName: 'report',
  ),
  TradeExecutionFeature(
    id: 'amendment',
    title: 'Order Amendment',
    description:
        'Modify open orders (price/quantity) mà không mất queue position.',
    colorHex: 0xFF8B5CF6,
    iconName: 'edit',
  ),
];

const TradeExecutionReport _executionReport = TradeExecutionReport(
  orderId: 'ORD-2026-03-11-A8F3D2',
  symbol: 'BTC/USDT',
  side: TradeOrderSide.buy,
  requestedAmount: 1,
  filledAmount: 1,
  expectedPrice: 69000,
  averageFillPrice: 69000.3,
  bestAvailablePrice: 69000,
  executionTimeMs: 480,
  slippagePct: .0004,
  savingsVsSingleVenue: 2.50,
  executionQuality: 'A',
  fills: [
    TradeExecutionFill(
      venue: 'Binance',
      amount: .5,
      price: 69001,
      fee: 34.50,
      timestampLabel: '10:15:32.120',
    ),
    TradeExecutionFill(
      venue: 'OKX',
      amount: .3,
      price: 69000,
      fee: 20.70,
      timestampLabel: '10:15:32.245',
    ),
    TradeExecutionFill(
      venue: 'Kraken',
      amount: .2,
      price: 68999,
      fee: 13.80,
      timestampLabel: '10:15:32.380',
    ),
  ],
);

const TradeExecutionOpenOrder _executionOpenOrder = TradeExecutionOpenOrder(
  id: 'ORD-2026-03-11-B9G4E3',
  symbol: 'BTC/USDT',
  side: TradeOrderSide.buy,
  type: 'limit',
  price: 68500,
  amount: .5,
  filled: .1,
  remaining: .4,
  queuePosition: 42,
  totalInQueue: 1250,
  supportsAmend: true,
);

const TradeSlippageSettings _defaultSlippageSettings = TradeSlippageSettings(
  tolerancePct: .5,
  rejectOnExceed: true,
  partialFillAllowed: false,
);

const List<TradeRiskStatusItem> _executionStatusItems = [
  TradeRiskStatusItem(label: 'Slippage Control Component', complete: true),
  TradeRiskStatusItem(label: 'Execution Report Component', complete: true),
  TradeRiskStatusItem(label: 'Order Amendment Component', complete: true),
  TradeRiskStatusItem(label: 'Integration với TradePage', complete: false),
  TradeRiskStatusItem(label: 'Multi-venue routing backend', complete: false),
  TradeRiskStatusItem(label: 'Order amendment API', complete: false),
];

const List<TradeAdvancedToolFeature> _advancedToolFeatures = [
  TradeAdvancedToolFeature(
    id: 'ladder',
    title: 'Ladder Trading',
    description:
        'Click bất kỳ giá nào trên order book để đặt lệnh ngay. One-click trading trên DOM.',
    colorHex: 0xFF10B981,
    iconName: 'target',
  ),
  TradeAdvancedToolFeature(
    id: 'bulk',
    title: 'Bulk Operations',
    description:
        'Select nhiều lệnh, cancel tất cả hoặc shift giá hàng loạt. Tiết kiệm thời gian.',
    colorHex: 0xFFF59E0B,
    iconName: 'bulk',
  ),
  TradeAdvancedToolFeature(
    id: 'shortcuts',
    title: 'Keyboard Shortcuts',
    description:
        'F1=Buy, F2=Sell, ESC=Cancel All. Trade nhanh hơn 3x với shortcuts tùy chỉnh.',
    colorHex: 0xFF8B5CF6,
    iconName: 'keyboard',
  ),
];

const List<TradeLadderOrder> _ladderOrders = [
  TradeLadderOrder(
    id: '1',
    price: 68800,
    amount: .5,
    side: TradeOrderSide.buy,
    filled: .1,
  ),
  TradeLadderOrder(
    id: '2',
    price: 69200,
    amount: .3,
    side: TradeOrderSide.sell,
    filled: 0,
  ),
];

const List<TradeBulkOrder> _bulkOrders = [
  TradeBulkOrder(
    id: 'o1',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: 'limit',
    price: 68500,
    amount: 1,
    filled: .2,
    remaining: .8,
    totalValue: 68500,
  ),
  TradeBulkOrder(
    id: 'o2',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: 'limit',
    price: 69500,
    amount: .8,
    filled: 0,
    remaining: .8,
    totalValue: 55600,
  ),
  TradeBulkOrder(
    id: 'o3',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.buy,
    type: 'limit',
    price: 3200,
    amount: 10,
    filled: 3,
    remaining: 7,
    totalValue: 32000,
  ),
  TradeBulkOrder(
    id: 'o4',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: 'limit',
    price: 68000,
    amount: .5,
    filled: 0,
    remaining: .5,
    totalValue: 34000,
  ),
];

const List<TradeShortcut> _shortcuts = [
  TradeShortcut(
    id: 'buy',
    keys: 'F1',
    label: 'Quick Buy',
    description: 'Place buy order with active preset',
  ),
  TradeShortcut(
    id: 'sell',
    keys: 'F2',
    label: 'Quick Sell',
    description: 'Place sell order with active preset',
  ),
  TradeShortcut(
    id: 'cancel',
    keys: 'ESC',
    label: 'Cancel All',
    description: 'Cancel all selected or open orders',
  ),
  TradeShortcut(
    id: 'size',
    keys: '1-4',
    label: 'Lot Size',
    description: 'Switch ladder lot size presets',
  ),
];

const List<TradeRiskStatusItem> _advancedToolStatusItems = [
  TradeRiskStatusItem(label: 'Ladder Trading Component', complete: true),
  TradeRiskStatusItem(label: 'Bulk Operations Component', complete: true),
  TradeRiskStatusItem(label: 'Keyboard Shortcuts System', complete: true),
  TradeRiskStatusItem(label: 'Integration với TradePage', complete: false),
  TradeRiskStatusItem(label: 'Persistent shortcut settings', complete: false),
];

const List<String> _copyTradingSortOptions = [
  'Top ROI',
  'Ổn định nhất',
  'Nhiều copier',
  'AUM cao',
];

const List<TradeCopyEducationTab> _copyEducationTabs = [
  TradeCopyEducationTab(id: 'how-it-works', label: 'Cơ chế'),
  TradeCopyEducationTab(id: 'scenarios', label: 'Kịch bản'),
  TradeCopyEducationTab(id: 'fees', label: 'Phí & Chi phí'),
  TradeCopyEducationTab(id: 'mistakes', label: 'Sai lầm'),
  TradeCopyEducationTab(id: 'regulatory', label: 'Quy định'),
];

const List<TradeCopyEducationStep> _copyEducationSteps = [
  TradeCopyEducationStep(
    number: 1,
    iconName: 'users',
    title: 'Chọn provider',
    description:
        'Bạn chọn một provider (trader) dựa trên hiệu suất, chiến lược và risk level. Provider phải được xác minh và công khai thông tin.',
  ),
  TradeCopyEducationStep(
    number: 2,
    iconName: 'target',
    title: 'Cấu hình sao chép',
    description:
        'Bạn chọn số tiền copy, tỷ lệ sao chép (vd: 50% = provider mở \$1000, bạn mở \$500), và các giới hạn rủi ro (stop-loss, take-profit).',
  ),
  TradeCopyEducationStep(
    number: 3,
    iconName: 'zap',
    title: 'Sao chép tự động',
    description:
        'Khi provider mở/đóng lệnh, hệ thống tự động sao chép vào tài khoản của bạn trong vòng 0.5-3 giây. Giá có thể khác nhau (slippage).',
  ),
  TradeCopyEducationStep(
    number: 4,
    iconName: 'activity',
    title: 'Theo dõi & điều chỉnh',
    description:
        'Bạn có thể xem real-time P/L, tắt copy bất cứ lúc nào, hoặc điều chỉnh cấu hình. Các vị thế đang mở vẫn theo provider cho đến khi đóng.',
  ),
];

const List<TradeCopyModeGuide> _copyModeGuides = [
  TradeCopyModeGuide(
    title: 'Mirror Copy',
    description:
        'Sao chép chính xác tỷ lệ vị thế. Provider mở 10% portfolio, bạn cũng mở 10%.',
    pro: 'Đơn giản, rủi ro tương tự provider',
    con: 'Không linh hoạt, phụ thuộc hoàn toàn vào provider',
    colorHex: 0xFF3B82F6,
  ),
  TradeCopyModeGuide(
    title: 'Fixed Ratio',
    description:
        'Bạn đặt tỷ lệ cố định (vd: 50%). Provider mở \$1000, bạn mở \$500.',
    pro: 'Kiểm soát vốn tốt hơn, dễ tính toán',
    con: 'Vẫn phụ thuộc vào timing của provider',
    colorHex: 0xFF10B981,
  ),
  TradeCopyModeGuide(
    title: 'Smart Copy',
    description:
        'Hệ thống điều chỉnh size dựa trên volatility và risk của từng trade.',
    pro: 'Tối ưu risk-adjusted returns',
    con: 'Phức tạp hơn, kết quả khác xa provider',
    colorHex: 0xFFF59E0B,
  ),
];

const List<TradeCopyConceptGuide> _copyConceptGuides = [
  TradeCopyConceptGuide(
    term: 'Slippage',
    iconName: 'down',
    description:
        'Chênh lệch giá giữa lệnh của provider và lệnh của bạn. Thường 0.05-0.2%. Trong thị trường biến động mạnh có thể lên 0.5-1%.',
  ),
  TradeCopyConceptGuide(
    term: 'High-Water Mark',
    iconName: 'up',
    description:
        'Provider chỉ nhận performance fee trên profit mới (vượt đỉnh cũ). Nếu tài khoản \$10k → \$12k → \$11k → \$13k, fee chỉ tính trên \$1k cuối.',
  ),
  TradeCopyConceptGuide(
    term: 'Position Sizing',
    iconName: 'target',
    description:
        'Cách tính kích thước vị thế sao chép. Mirror = tỷ lệ %, Fixed = số tiền cố định, Smart = dynamic dựa trên risk.',
  ),
  TradeCopyConceptGuide(
    term: 'Execution Delay',
    iconName: 'clock',
    description:
        'Thời gian từ khi provider mở lệnh đến khi lệnh của bạn execute. Thường 0.5-3 giây. Delay cao → slippage cao.',
  ),
];

const TradeCopySettings _defaultCopySettings = TradeCopySettings(
  defaultCopyMode: TradeCopySettingsMode.fixed,
  defaultCopyRatio: 50,
  defaultStopLoss: 10,
  defaultTakeProfit: 20,
  maxPortfolioAllocation: 20,
  maxCopiesActive: 5,
  enableCircuitBreaker: true,
  circuitBreakerThreshold: 15,
  notifyNewTrades: true,
  notifyPnlChanges: true,
  notifyRiskAlerts: true,
  notifyProviderUpdates: false,
  emailNotifications: true,
  pushNotifications: true,
  emergencyContact: '',
  emergencyPhone: '',
  showPortfolioPublic: false,
);

const List<TradeCopyNotification> _copyNotifications = [
  TradeCopyNotification(
    id: 'n1',
    type: TradeCopyNotificationType.risk,
    title: 'Cảnh báo rủi ro cao',
    message: 'Copy "CryptoKing" đang lỗ -8.5%, gần ngưỡng stop-loss -10%',
    timestamp: '5 phút trước',
    read: false,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    actionPath: '/trade/copy-trading/active',
    severity: TradeCopyNotificationSeverity.critical,
  ),
  TradeCopyNotification(
    id: 'n2',
    type: TradeCopyNotificationType.trade,
    title: 'Lệnh mới được copy',
    message: 'CryptoKing đã BUY 0.05 BTC @ \$67,800',
    timestamp: '15 phút trước',
    read: false,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    severity: TradeCopyNotificationSeverity.info,
    pair: 'BTC/USDT',
    side: TradeOrderSide.buy,
  ),
  TradeCopyNotification(
    id: 'n3',
    type: TradeCopyNotificationType.trade,
    title: 'Chốt lời thành công',
    message: 'Lệnh ETH/USDT đã đóng với lợi nhuận +\$45',
    timestamp: '1 giờ trước',
    read: false,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    severity: TradeCopyNotificationSeverity.info,
    pnl: 45,
    pair: 'ETH/USDT',
    side: TradeOrderSide.sell,
  ),
  TradeCopyNotification(
    id: 'n4',
    type: TradeCopyNotificationType.update,
    title: 'Provider cập nhật chiến lược',
    message: 'SwingMaster đã thông báo: "Tăng tỷ trọng BTC lên 60% portfolio"',
    timestamp: '2 giờ trước',
    read: true,
    providerId: 'trader-2',
    providerName: 'SwingMaster',
    severity: TradeCopyNotificationSeverity.warning,
  ),
  TradeCopyNotification(
    id: 'n5',
    type: TradeCopyNotificationType.system,
    title: 'Copy mới được kích hoạt',
    message: 'Copy "AlgoTrader" đã hết thời gian chờ 24h và được kích hoạt',
    timestamp: '3 giờ trước',
    read: true,
    providerId: 'trader-3',
    providerName: 'AlgoTrader',
    copyId: 'copy-3',
    severity: TradeCopyNotificationSeverity.info,
  ),
  TradeCopyNotification(
    id: 'n6',
    type: TradeCopyNotificationType.risk,
    title: 'Đã đạt ngưỡng take-profit',
    message:
        'Copy "CryptoKing" đã đạt +13%, bạn có muốn điều chỉnh take-profit?',
    timestamp: '5 giờ trước',
    read: true,
    providerId: 'trader-1',
    providerName: 'CryptoKing',
    copyId: 'copy-1',
    severity: TradeCopyNotificationSeverity.warning,
  ),
  TradeCopyNotification(
    id: 'n7',
    type: TradeCopyNotificationType.system,
    title: 'Cập nhật hệ thống',
    message:
        'Copy Trading hiện hỗ trợ Trailing Stop. Xem chi tiết tại Settings.',
    timestamp: '1 ngày trước',
    read: true,
    severity: TradeCopyNotificationSeverity.info,
  ),
];

const List<TradeProviderBenefit> _providerApplicationBenefits = [
  TradeProviderBenefit(
    iconName: 'dollar',
    title: 'Performance Fee',
    description: 'Nhận 10-30% từ lợi nhuận của copiers',
  ),
  TradeProviderBenefit(
    iconName: 'users',
    title: 'Xây dựng danh tiếng',
    description: 'Trở thành trader được công nhận',
  ),
  TradeProviderBenefit(
    iconName: 'trend',
    title: 'Không giới hạn thu nhập',
    description: 'Thu nhập tăng theo số người copy',
  ),
];

const List<String> _providerApplicationResponsibilities = [
  'Bạn phải công khai tất cả rủi ro và strategy changes',
  'Bạn chịu trách nhiệm với chất lượng trading',
  'Không được market manipulation hoặc wash trading',
  'Vi phạm sẽ bị cấm vĩnh viễn và xử lý pháp lý',
];

const List<TradeProviderRequirement> _providerApplicationRequirements = [
  TradeProviderRequirement(label: 'KYC Level 2', met: false),
  TradeProviderRequirement(label: 'Trading history ≥6 tháng', met: false),
  TradeProviderRequirement(label: 'Vốn tối thiểu \$10,000', met: false),
  TradeProviderRequirement(label: 'Sharpe Ratio >1.0', met: false),
];

const TradeProviderApplicationDraft _defaultProviderApplicationDraft =
    TradeProviderApplicationDraft(
      hasKyc: false,
      tradingMonths: 0,
      minCapital: 10000,
      performanceFee: 10,
      agreedToDisclosure: false,
      agreedToFiduciary: false,
      agreedToTerms: false,
      strategyDescription: '',
    );

const List<TradePreCopyQuestion> _preCopyQuestions = [
  TradePreCopyQuestion(
    id: 'experience',
    question: 'Kinh nghiệm giao dịch của bạn?',
    description: 'Đánh giá mức độ am hiểu về thị trường crypto',
    options: [
      TradePreCopyOption(
        value: 'none',
        label: 'Chưa từng giao dịch crypto',
        score: 0,
      ),
      TradePreCopyOption(
        value: 'beginner',
        label: 'Mới bắt đầu dưới 6 tháng',
        score: 5,
      ),
      TradePreCopyOption(
        value: 'intermediate',
        label: 'Trung bình 6 tháng - 2 năm',
        score: 12,
      ),
      TradePreCopyOption(
        value: 'advanced',
        label: 'Có kinh nghiệm trên 2 năm',
        score: 20,
      ),
    ],
  ),
  TradePreCopyQuestion(
    id: 'loss_awareness',
    question: 'Bạn hiểu rủi ro mất vốn như thế nào?',
    description: 'Copy Trading có thể làm mất toàn bộ số tiền đầu tư',
    options: [
      TradePreCopyOption(
        value: 'no_loss',
        label: 'Provider ROI cao nên chắc chắn lời',
        score: 0,
      ),
      TradePreCopyOption(
        value: 'partial',
        label: 'Có thể mất một phần vốn',
        score: 5,
      ),
      TradePreCopyOption(
        value: 'understand',
        label: 'Có thể mất toàn bộ vốn',
        score: 20,
      ),
    ],
  ),
];

const List<TradePreCopyEducationDoc> _preCopyEducationDocs = [
  TradePreCopyEducationDoc(
    id: 'how_it_works',
    title: 'Copy Trading hoạt động như thế nào?',
    duration: '2 phút',
  ),
  TradePreCopyEducationDoc(
    id: 'risks',
    title: 'Rủi ro của Copy Trading',
    duration: '2 phút',
  ),
  TradePreCopyEducationDoc(
    id: 'best_practices',
    title: 'Nguyên tắc đầu tư an toàn',
    duration: '2 phút',
  ),
];

const List<TradeActiveCopy> _activeCopies = [
  TradeActiveCopy(
    id: 'copy-1',
    providerId: 'provider001',
    providerName: 'AlphaHunter_VN',
    providerAvatar: 'A',
    providerVerified: true,
    capital: 5000,
    currentValue: 5650,
    pnl: 650,
    pnlPct: 13,
    status: TradeActiveCopyStatus.active,
    startDate: '2026-02-15',
    copyMode: TradeActiveCopyMode.fixed,
    copyRatio: 50,
    trades: 48,
    winRate: 62.5,
    hasCustomStopLoss: true,
    stopLossLevel: 10,
    recentTrades: [
      TradeCopyRecentTrade(
        id: 't1',
        pair: 'BTC/USDT',
        side: TradeOrderSide.sell,
        size: .05,
        price: 68500,
        pnl: 45,
        timestamp: '2h ago',
      ),
      TradeCopyRecentTrade(
        id: 't2',
        pair: 'ETH/USDT',
        side: TradeOrderSide.buy,
        size: 2,
        price: 3850,
        pnl: -12,
        timestamp: '5h ago',
      ),
      TradeCopyRecentTrade(
        id: 't3',
        pair: 'BTC/USDT',
        side: TradeOrderSide.buy,
        size: .05,
        price: 67800,
        pnl: 35,
        timestamp: '8h ago',
      ),
    ],
    performanceHistory: [
      TradeCopyPerformancePoint(timestamp: 'Day 0', value: 5000),
      TradeCopyPerformancePoint(timestamp: 'Day 7', value: 5135),
      TradeCopyPerformancePoint(timestamp: 'Day 14', value: 5310),
      TradeCopyPerformancePoint(timestamp: 'Day 21', value: 5485),
      TradeCopyPerformancePoint(timestamp: 'Day 30', value: 5650),
    ],
  ),
  TradeActiveCopy(
    id: 'copy-2',
    providerId: 'provider002',
    providerName: 'SteadyGains_Pro',
    providerAvatar: 'S',
    providerVerified: true,
    capital: 3000,
    currentValue: 2850,
    pnl: -150,
    pnlPct: -5,
    status: TradeActiveCopyStatus.active,
    startDate: '2026-03-01',
    copyMode: TradeActiveCopyMode.mirror,
    trades: 22,
    winRate: 45.5,
    hasCustomStopLoss: false,
    recentTrades: [
      TradeCopyRecentTrade(
        id: 't4',
        pair: 'SOL/USDT',
        side: TradeOrderSide.sell,
        size: 10,
        price: 142,
        pnl: -35,
        timestamp: '1h ago',
      ),
      TradeCopyRecentTrade(
        id: 't5',
        pair: 'AVAX/USDT',
        side: TradeOrderSide.buy,
        size: 15,
        price: 38,
        pnl: 12,
        timestamp: '4h ago',
      ),
    ],
    performanceHistory: [
      TradeCopyPerformancePoint(timestamp: 'Day 0', value: 3000),
      TradeCopyPerformancePoint(timestamp: 'Day 7', value: 2960),
      TradeCopyPerformancePoint(timestamp: 'Day 14', value: 2925),
      TradeCopyPerformancePoint(timestamp: 'Day 21', value: 2875),
      TradeCopyPerformancePoint(timestamp: 'Day 30', value: 2850),
    ],
  ),
  TradeActiveCopy(
    id: 'copy-3',
    providerId: 'provider003',
    providerName: 'RiskMaster_88',
    providerAvatar: 'R',
    providerVerified: true,
    capital: 2000,
    currentValue: 2000,
    pnl: 0,
    pnlPct: 0,
    status: TradeActiveCopyStatus.coolingOff,
    startDate: '2026-03-08',
    copyMode: TradeActiveCopyMode.smart,
    trades: 0,
    winRate: 0,
    hasCustomStopLoss: true,
    stopLossLevel: 15,
    coolingOffUntil: '2026-03-09 14:30',
    recentTrades: [],
    performanceHistory: [
      TradeCopyPerformancePoint(timestamp: 'Day 0', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 7', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 14', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 21', value: 2000),
      TradeCopyPerformancePoint(timestamp: 'Day 30', value: 2000),
    ],
  ),
];

TradeCopyConfigurationFeePreview _copyConfigurationFeePreview(
  TradeCopyConfigurationDraft draft,
) {
  final platformFee = draft.copyCapital * 0.001;
  const estimatedMonthlyTrades = 50;
  final averageTradeSize = draft.copyCapital / 10;
  final tradingFees = estimatedMonthlyTrades * 2 * 0.0025 * averageTradeSize;
  return TradeCopyConfigurationFeePreview(
    platformFee: platformFee,
    estimatedTradingFees: tradingFees,
    performanceFeeNote: 'Chỉ tính khi có lợi nhuận',
  );
}

List<TradeCopyConfigurationValidation> _copyConfigurationValidations(
  TradeCopyConfigurationDraft draft,
  TradeCopyTrader? provider,
) {
  const totalPortfolio = 25000.0;
  const currentCopyAllocation = 8000.0;
  const availableCapital = totalPortfolio - currentCopyAllocation;
  final allocationPercent = draft.copyCapital / totalPortfolio * 100;
  final newTotalAllocationPercent =
      (currentCopyAllocation + draft.copyCapital) / totalPortfolio * 100;

  final issues = <TradeCopyConfigurationValidation>[];
  if (draft.copyCapital < 100) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.error,
        message: 'Số tiền copy tối thiểu là \$100',
      ),
    );
  }
  if (draft.copyCapital > availableCapital) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.error,
        message: 'Vốn khả dụng chỉ còn \$17000',
      ),
    );
  }
  if (allocationPercent > 20) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.error,
        message: 'Không được copy quá 20% tổng vốn cho 1 provider',
      ),
    );
  }
  if (newTotalAllocationPercent > 70) {
    issues.add(
      TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message:
            'Tổng vốn copy sẽ là ${newTotalAllocationPercent.toStringAsFixed(0)}%',
      ),
    );
  }
  if (allocationPercent > 15) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message: 'Phân bổ trên 15% cho 1 provider tăng rủi ro tập trung',
      ),
    );
  }
  if (provider != null &&
      provider.maxDrawdown > 30 &&
      !draft.useCustomStopLoss) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message: 'Provider có Max DD cao, nên đặt stop-loss riêng',
      ),
    );
  }
  if (provider != null &&
      provider.riskLevel == TradeCopyRiskLevel.high &&
      draft.copyMode == TradeCopyConfigurationMode.mirror) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.warning,
        message: 'Mirror copy với high-risk provider là rủi ro cao',
      ),
    );
  }
  if (draft.useTrailingStop) {
    issues.add(
      const TradeCopyConfigurationValidation(
        level: TradeCopyConfigurationValidationLevel.info,
        message: 'Trailing stop giúp bảo vệ lợi nhuận khi thị trường đảo chiều',
      ),
    );
  }
  return issues;
}

List<TradeCopyScenarioProjection> _copyScenarioProjections(
  TradeCopyConfigurationDraft draft,
  TradeCopyConfigurationFeePreview feePreview,
) {
  return [
    _copyScenarioProjection(
      id: 'optimistic',
      title: 'Kịch bản tốt',
      returnPct: 15,
      draft: draft,
      feePreview: feePreview,
    ),
    _copyScenarioProjection(
      id: 'realistic',
      title: 'Kịch bản thực tế',
      returnPct: 5,
      draft: draft,
      feePreview: feePreview,
    ),
    _copyScenarioProjection(
      id: 'pessimistic',
      title: 'Kịch bản xấu',
      returnPct: -10,
      draft: draft,
      feePreview: feePreview,
    ),
  ];
}

TradeCopyScenarioProjection _copyScenarioProjection({
  required String id,
  required String title,
  required double returnPct,
  required TradeCopyConfigurationDraft draft,
  required TradeCopyConfigurationFeePreview feePreview,
}) {
  final grossPnl = draft.copyCapital * returnPct / 100;
  final performanceFee = grossPnl > 0 ? grossPnl * 0.1 : 0.0;
  final slippageLoss = grossPnl.abs() * 0.015;
  final fixedFees = feePreview.totalFixedFees;
  final netPnl = grossPnl - performanceFee - slippageLoss - fixedFees;
  return TradeCopyScenarioProjection(
    id: id,
    title: title,
    returnPct: returnPct,
    grossPnl: grossPnl,
    performanceFee: performanceFee,
    slippageLoss: slippageLoss,
    fixedFees: fixedFees,
    netPnl: netPnl,
    netReturnPct: netPnl / draft.copyCapital * 100,
  );
}

const List<TradeCopyConsentItem> _copyConfirmationConsents = [
  TradeCopyConsentItem(
    id: 'risk',
    label:
        'Tôi hiểu Copy Trading có rủi ro cao và hiệu suất quá khứ không đảm bảo kết quả tương lai.',
    required: true,
  ),
  TradeCopyConsentItem(
    id: 'fees',
    label:
        'Tôi đã đọc và hiểu tất cả khoản phí gồm platform fee, trading fee, performance fee và slippage.',
    required: true,
  ),
  TradeCopyConsentItem(
    id: 'loss',
    label:
        'Tôi xác nhận số vốn copy là số tiền tôi có thể chấp nhận mất hoàn toàn.',
    required: true,
  ),
  TradeCopyConsentItem(
    id: 'terms',
    label: 'Tôi đồng ý với điều khoản sử dụng và chính sách Copy Trading.',
    required: true,
  ),
];

const List<TradeCopyEquityPoint> _copyPerformanceEquityCurve = [
  TradeCopyEquityPoint(day: 1, you: 5000, provider: 5000),
  TradeCopyEquityPoint(day: 2, you: 5038, provider: 5056),
  TradeCopyEquityPoint(day: 3, you: 5072, provider: 5108),
  TradeCopyEquityPoint(day: 4, you: 5128, provider: 5155),
  TradeCopyEquityPoint(day: 5, you: 5115, provider: 5198),
  TradeCopyEquityPoint(day: 6, you: 5162, provider: 5236),
  TradeCopyEquityPoint(day: 7, you: 5178, provider: 5288),
  TradeCopyEquityPoint(day: 8, you: 5220, provider: 5320),
  TradeCopyEquityPoint(day: 9, you: 5242, provider: 5368),
  TradeCopyEquityPoint(day: 10, you: 5280, provider: 5410),
  TradeCopyEquityPoint(day: 11, you: 5265, provider: 5460),
  TradeCopyEquityPoint(day: 12, you: 5324, provider: 5508),
  TradeCopyEquityPoint(day: 13, you: 5350, provider: 5558),
  TradeCopyEquityPoint(day: 14, you: 5310, provider: 5598),
  TradeCopyEquityPoint(day: 15, you: 5388, provider: 5632),
  TradeCopyEquityPoint(day: 16, you: 5426, provider: 5684),
  TradeCopyEquityPoint(day: 17, you: 5405, provider: 5726),
  TradeCopyEquityPoint(day: 18, you: 5484, provider: 5578),
  TradeCopyEquityPoint(day: 19, you: 5456, provider: 5606),
  TradeCopyEquityPoint(day: 20, you: 5520, provider: 5630),
  TradeCopyEquityPoint(day: 21, you: 5492, provider: 5662),
  TradeCopyEquityPoint(day: 22, you: 5568, provider: 5680),
  TradeCopyEquityPoint(day: 23, you: 5590, provider: 5718),
  TradeCopyEquityPoint(day: 24, you: 5635, provider: 5695),
  TradeCopyEquityPoint(day: 25, you: 5680, provider: 5725),
  TradeCopyEquityPoint(day: 26, you: 5664, provider: 5750),
  TradeCopyEquityPoint(day: 27, you: 5705, provider: 5768),
  TradeCopyEquityPoint(day: 28, you: 5724, provider: 5795),
  TradeCopyEquityPoint(day: 29, you: 5768, provider: 5818),
  TradeCopyEquityPoint(day: 30, you: 5650, provider: 5780),
];

const List<TradeCopySlippageBucket> _copyPerformanceSlippageBuckets = [
  TradeCopySlippageBucket(range: '0-0.5%', youPct: 45, providerPct: 52),
  TradeCopySlippageBucket(range: '0.5-1%', youPct: 30, providerPct: 28),
  TradeCopySlippageBucket(range: '1-2%', youPct: 18, providerPct: 15),
  TradeCopySlippageBucket(range: '2%+', youPct: 7, providerPct: 5),
];

const List<TradeCopyCostAttribution> _copyPerformanceCostAttribution = [
  TradeCopyCostAttribution(
    name: 'Trading Fees',
    value: 125,
    colorHex: 0xFFEF4444,
  ),
  TradeCopyCostAttribution(
    name: 'Performance Fee',
    value: 65,
    colorHex: 0xFFF59E0B,
  ),
  TradeCopyCostAttribution(name: 'Slippage', value: 95, colorHex: 0xFF6B7280),
  TradeCopyCostAttribution(
    name: 'Platform Fee',
    value: 5,
    colorHex: 0xFF3B82F6,
  ),
];

const List<TradeCopyTradeComparison> _copyPerformanceTrades = [
  TradeCopyTradeComparison(
    id: 't1',
    pair: 'BTC/USDT',
    side: TradeOrderSide.buy,
    providerEntry: 67800,
    yourEntry: 67835,
    providerExit: 68500,
    yourExit: 68480,
    providerPnl: 35,
    yourPnl: 32,
    slippagePct: .52,
    delay: '2.1s',
    timestamp: '2024-03-05 14:23',
  ),
  TradeCopyTradeComparison(
    id: 't2',
    pair: 'ETH/USDT',
    side: TradeOrderSide.sell,
    providerEntry: 3850,
    yourEntry: 3848,
    providerExit: 3825,
    yourExit: 3822,
    providerPnl: 50,
    yourPnl: 52,
    slippagePct: .31,
    delay: '1.8s',
    timestamp: '2024-03-04 09:15',
  ),
  TradeCopyTradeComparison(
    id: 't3',
    pair: 'SOL/USDT',
    side: TradeOrderSide.buy,
    providerEntry: 142,
    yourEntry: 142.5,
    providerExit: 138,
    yourExit: 138.2,
    providerPnl: -40,
    yourPnl: -43,
    slippagePct: .71,
    delay: '3.2s',
    timestamp: '2024-03-03 16:42',
  ),
];

const List<TradeCopyMetricComparison> _copyPerformanceMetrics = [
  TradeCopyMetricComparison(
    name: 'Sharpe Ratio',
    you: 1.82,
    provider: 2.15,
    higherIsBetter: true,
  ),
  TradeCopyMetricComparison(
    name: 'Max Drawdown',
    you: -8.5,
    provider: -6.2,
    higherIsBetter: false,
    suffix: '%',
  ),
  TradeCopyMetricComparison(
    name: 'Win Rate',
    you: 62.5,
    provider: 68.3,
    higherIsBetter: true,
    suffix: '%',
  ),
  TradeCopyMetricComparison(
    name: 'Avg Win/Loss',
    you: 1.42,
    provider: 1.68,
    higherIsBetter: true,
  ),
];

const List<TradePerformanceReturnPoint> _performanceAttributionReturns = [
  TradePerformanceReturnPoint(day: 1, market: .3, alpha: .4),
  TradePerformanceReturnPoint(day: 2, market: .7, alpha: .1),
  TradePerformanceReturnPoint(day: 3, market: 1.2, alpha: -.2),
  TradePerformanceReturnPoint(day: 4, market: 1.8, alpha: -.5),
  TradePerformanceReturnPoint(day: 5, market: 2.5, alpha: -.8),
  TradePerformanceReturnPoint(day: 6, market: 3.8, alpha: -1.1),
  TradePerformanceReturnPoint(day: 7, market: 3.1, alpha: -.4),
  TradePerformanceReturnPoint(day: 8, market: 4.4, alpha: -.9),
  TradePerformanceReturnPoint(day: 9, market: 4.7, alpha: -.6),
  TradePerformanceReturnPoint(day: 10, market: 5.6, alpha: -1.2),
  TradePerformanceReturnPoint(day: 11, market: 6.4, alpha: -.3),
  TradePerformanceReturnPoint(day: 12, market: 5.1, alpha: .2),
  TradePerformanceReturnPoint(day: 13, market: 4.8, alpha: -.2),
  TradePerformanceReturnPoint(day: 14, market: 6.2, alpha: -.8),
  TradePerformanceReturnPoint(day: 15, market: 8.4, alpha: -.3),
  TradePerformanceReturnPoint(day: 16, market: 8.1, alpha: -.7),
  TradePerformanceReturnPoint(day: 17, market: 9.2, alpha: -1.4),
  TradePerformanceReturnPoint(day: 18, market: 10.6, alpha: -2.1),
  TradePerformanceReturnPoint(day: 19, market: 10.7, alpha: -1.8),
  TradePerformanceReturnPoint(day: 20, market: 11.5, alpha: -1.9),
  TradePerformanceReturnPoint(day: 21, market: 9.8, alpha: .1),
  TradePerformanceReturnPoint(day: 22, market: 10.2, alpha: -.2),
  TradePerformanceReturnPoint(day: 23, market: 10.1, alpha: -.1),
  TradePerformanceReturnPoint(day: 24, market: 11.7, alpha: .9),
  TradePerformanceReturnPoint(day: 25, market: 13.5, alpha: .1),
  TradePerformanceReturnPoint(day: 26, market: 13.0, alpha: -.8),
  TradePerformanceReturnPoint(day: 27, market: 11.6, alpha: -2.4),
  TradePerformanceReturnPoint(day: 28, market: 11.2, alpha: -2.1),
  TradePerformanceReturnPoint(day: 29, market: 12.0, alpha: -2.8),
  TradePerformanceReturnPoint(day: 30, market: 13.4, alpha: -4.1),
];

const List<TradePerformanceDrawdownPoint> _performanceAttributionDrawdowns = [
  TradePerformanceDrawdownPoint(day: 1, drawdown: 0),
  TradePerformanceDrawdownPoint(day: 2, drawdown: -.4),
  TradePerformanceDrawdownPoint(day: 3, drawdown: -1.1),
  TradePerformanceDrawdownPoint(day: 4, drawdown: -2.3),
  TradePerformanceDrawdownPoint(day: 5, drawdown: -1.6),
  TradePerformanceDrawdownPoint(day: 6, drawdown: -3.8),
  TradePerformanceDrawdownPoint(day: 7, drawdown: -2.9),
  TradePerformanceDrawdownPoint(day: 8, drawdown: -4.4),
  TradePerformanceDrawdownPoint(day: 9, drawdown: -5.1),
  TradePerformanceDrawdownPoint(day: 10, drawdown: -3.7),
  TradePerformanceDrawdownPoint(day: 11, drawdown: -2.5),
  TradePerformanceDrawdownPoint(day: 12, drawdown: -6.2),
  TradePerformanceDrawdownPoint(day: 13, drawdown: -7.6),
  TradePerformanceDrawdownPoint(day: 14, drawdown: -5.8),
  TradePerformanceDrawdownPoint(day: 15, drawdown: -4.2),
  TradePerformanceDrawdownPoint(day: 16, drawdown: -8.7),
  TradePerformanceDrawdownPoint(day: 17, drawdown: -7.9),
  TradePerformanceDrawdownPoint(day: 18, drawdown: -6.4),
  TradePerformanceDrawdownPoint(day: 19, drawdown: -5.6),
  TradePerformanceDrawdownPoint(day: 20, drawdown: -4.0),
  TradePerformanceDrawdownPoint(day: 21, drawdown: -3.3),
  TradePerformanceDrawdownPoint(day: 22, drawdown: -5.2),
  TradePerformanceDrawdownPoint(day: 23, drawdown: -4.7),
  TradePerformanceDrawdownPoint(day: 24, drawdown: -3.1),
  TradePerformanceDrawdownPoint(day: 25, drawdown: -2.0),
  TradePerformanceDrawdownPoint(day: 26, drawdown: -3.6),
  TradePerformanceDrawdownPoint(day: 27, drawdown: -4.8),
  TradePerformanceDrawdownPoint(day: 28, drawdown: -2.8),
  TradePerformanceDrawdownPoint(day: 29, drawdown: -1.5),
  TradePerformanceDrawdownPoint(day: 30, drawdown: -2.2),
];

const List<List<TradePerformanceProjectionPoint>>
_performanceAttributionProjectionPaths = [
  [
    TradePerformanceProjectionPoint(day: 1, value: 5000),
    TradePerformanceProjectionPoint(day: 5, value: 5085),
    TradePerformanceProjectionPoint(day: 10, value: 5220),
    TradePerformanceProjectionPoint(day: 15, value: 5350),
    TradePerformanceProjectionPoint(day: 20, value: 5480),
    TradePerformanceProjectionPoint(day: 25, value: 5575),
    TradePerformanceProjectionPoint(day: 30, value: 5630),
  ],
  [
    TradePerformanceProjectionPoint(day: 1, value: 5000),
    TradePerformanceProjectionPoint(day: 5, value: 4925),
    TradePerformanceProjectionPoint(day: 10, value: 5050),
    TradePerformanceProjectionPoint(day: 15, value: 4980),
    TradePerformanceProjectionPoint(day: 20, value: 5120),
    TradePerformanceProjectionPoint(day: 25, value: 5060),
    TradePerformanceProjectionPoint(day: 30, value: 4920),
  ],
  [
    TradePerformanceProjectionPoint(day: 1, value: 5000),
    TradePerformanceProjectionPoint(day: 5, value: 5155),
    TradePerformanceProjectionPoint(day: 10, value: 5340),
    TradePerformanceProjectionPoint(day: 15, value: 5590),
    TradePerformanceProjectionPoint(day: 20, value: 5840),
    TradePerformanceProjectionPoint(day: 25, value: 6120),
    TradePerformanceProjectionPoint(day: 30, value: 6425),
  ],
];

const List<TradePerformanceCorrelationPoint>
_performanceAttributionCorrelation = [
  TradePerformanceCorrelationPoint(day: 1, marketReturn: -2, yourReturn: -1.8),
  TradePerformanceCorrelationPoint(day: 2, marketReturn: 1.5, yourReturn: 1.2),
  TradePerformanceCorrelationPoint(day: 3, marketReturn: -.5, yourReturn: -.3),
  TradePerformanceCorrelationPoint(day: 4, marketReturn: 2, yourReturn: 2.5),
  TradePerformanceCorrelationPoint(day: 5, marketReturn: .8, yourReturn: .6),
  TradePerformanceCorrelationPoint(day: 6, marketReturn: -1, yourReturn: -.8),
  TradePerformanceCorrelationPoint(day: 7, marketReturn: 1.2, yourReturn: 1.5),
  TradePerformanceCorrelationPoint(day: 8, marketReturn: -.3, yourReturn: .2),
  TradePerformanceCorrelationPoint(day: 9, marketReturn: 1.8, yourReturn: 1.6),
  TradePerformanceCorrelationPoint(
    day: 10,
    marketReturn: -1.5,
    yourReturn: -1.2,
  ),
];

const List<TradeProviderComparisonMetric> _providerComparisonMetrics = [
  TradeProviderComparisonMetric(
    label: 'Total ROI',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: '30D Return',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Win Rate',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Trade',
    category: TradeProviderComparisonCategory.performance,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Sharpe Ratio',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Max Drawdown',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Volatility',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Risk Score',
    category: TradeProviderComparisonCategory.risk,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Slippage',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Avg Delay',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Fill Rate',
    category: TradeProviderComparisonCategory.execution,
    higherIsBetter: true,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Performance Fee',
    category: TradeProviderComparisonCategory.cost,
    higherIsBetter: false,
    values: {},
  ),
  TradeProviderComparisonMetric(
    label: 'Est. Monthly Cost',
    category: TradeProviderComparisonCategory.cost,
    higherIsBetter: false,
    values: {},
  ),
];

const List<TradeCopyAuditExportFormat> _copyAuditExportFormats = [
  TradeCopyAuditExportFormat(
    id: 'csv',
    label: 'CSV',
    description: 'Excel-compatible spreadsheet',
  ),
  TradeCopyAuditExportFormat(
    id: 'pdf',
    label: 'PDF',
    description: 'Printable document',
  ),
  TradeCopyAuditExportFormat(
    id: 'json',
    label: 'JSON',
    description: 'Raw data for developers',
  ),
];

const List<TradeCopyAuditEvent> _copyAuditEvents = [
  TradeCopyAuditEvent(
    id: 'evt-1',
    type: TradeCopyAuditEventType.trade,
    timestamp: '2026-03-08 14:23:15',
    title: 'Trade Executed',
    description: 'BUY 0.05 BTC @ \$67,835 (Provider: \$67,800)',
    severity: TradeCopyAuditSeverity.info,
    metadata: TradeCopyAuditMetadata(
      pair: 'BTC/USDT',
      side: TradeOrderSide.buy,
      providerPrice: 67800,
      yourPrice: 67835,
      slippagePct: .52,
    ),
  ),
  TradeCopyAuditEvent(
    id: 'evt-2',
    type: TradeCopyAuditEventType.risk,
    timestamp: '2026-03-08 14:15:42',
    title: 'Risk Alert Triggered',
    description: 'Copy approaching stop-loss: -8.5% (threshold: -10%)',
    severity: TradeCopyAuditSeverity.warning,
  ),
  TradeCopyAuditEvent(
    id: 'evt-3',
    type: TradeCopyAuditEventType.config,
    timestamp: '2026-03-08 10:30:22',
    title: 'Stop-Loss Updated',
    description: 'User adjusted stop-loss',
    severity: TradeCopyAuditSeverity.info,
    metadata: TradeCopyAuditMetadata(oldValue: '-15%', newValue: '-10%'),
  ),
  TradeCopyAuditEvent(
    id: 'evt-4',
    type: TradeCopyAuditEventType.trade,
    timestamp: '2026-03-07 16:45:10',
    title: 'Position Closed',
    description: 'SELL 2 ETH @ \$3,848 (P/L: +\$45)',
    severity: TradeCopyAuditSeverity.info,
    metadata: TradeCopyAuditMetadata(
      pair: 'ETH/USDT',
      side: TradeOrderSide.sell,
      providerPrice: 3850,
      yourPrice: 3848,
      slippagePct: .31,
      pnl: 45,
    ),
  ),
  TradeCopyAuditEvent(
    id: 'evt-5',
    type: TradeCopyAuditEventType.system,
    timestamp: '2026-03-05 09:00:00',
    title: 'Copy Activated',
    description: 'Cooling-off period completed, copy started',
    severity: TradeCopyAuditSeverity.info,
  ),
  TradeCopyAuditEvent(
    id: 'evt-6',
    type: TradeCopyAuditEventType.config,
    timestamp: '2026-03-04 14:30:00',
    title: 'Copy Configuration Created',
    description: 'Capital: \$5,000 | Mode: Fixed 50% | SL: -10%',
    severity: TradeCopyAuditSeverity.info,
  ),
  TradeCopyAuditEvent(
    id: 'evt-7',
    type: TradeCopyAuditEventType.system,
    timestamp: '2026-03-04 14:25:00',
    title: 'Risk Assessment Completed',
    description: 'Score: 85/140 (Suitable) | Recommended allocation: 15%',
    severity: TradeCopyAuditSeverity.info,
  ),
];

const List<TradeAssetExposure> _portfolioRiskAssets = [
  TradeAssetExposure(
    asset: 'BTC',
    value: 2800,
    percent: 35,
    colorHex: 0xFFF7931A,
  ),
  TradeAssetExposure(
    asset: 'ETH',
    value: 2000,
    percent: 25,
    colorHex: 0xFF627EEA,
  ),
  TradeAssetExposure(
    asset: 'SOL',
    value: 1200,
    percent: 15,
    colorHex: 0xFF00D4AA,
  ),
  TradeAssetExposure(
    asset: 'AVAX',
    value: 800,
    percent: 10,
    colorHex: 0xFFE84142,
  ),
  TradeAssetExposure(
    asset: 'USDT',
    value: 600,
    percent: 7.5,
    colorHex: 0xFF26A17B,
  ),
  TradeAssetExposure(
    asset: 'Others',
    value: 600,
    percent: 7.5,
    colorHex: 0xFF6B7280,
  ),
];

const List<TradeStressScenario> _portfolioRiskScenarios = [
  TradeStressScenario(
    name: 'Market Crash (-30%)',
    impact: -2400,
    probability: 5,
    colorHex: 0xFFEF4444,
  ),
  TradeStressScenario(
    name: 'BTC Halving Rally',
    impact: 1800,
    probability: 20,
    colorHex: 0xFF10B981,
  ),
  TradeStressScenario(
    name: 'Regulatory Crackdown',
    impact: -1500,
    probability: 15,
    colorHex: 0xFFF59E0B,
  ),
  TradeStressScenario(
    name: 'Stable Bull Market',
    impact: 600,
    probability: 40,
    colorHex: 0xFF3B82F6,
  ),
  TradeStressScenario(
    name: 'High Volatility',
    impact: -800,
    probability: 20,
    colorHex: 0xFF8B5CF6,
  ),
];

const List<TradeProviderLeaderboardSort> _providerLeaderboardSortOptions = [
  TradeProviderLeaderboardSort(id: 'roi', label: 'ROI'),
  TradeProviderLeaderboardSort(id: 'sharpe', label: 'Sharpe'),
  TradeProviderLeaderboardSort(id: 'followers', label: 'Followers'),
  TradeProviderLeaderboardSort(id: 'recent', label: '30D'),
];

const List<TradeProviderLeaderboardRiskFilter> _providerLeaderboardRiskFilters =
    [
      TradeProviderLeaderboardRiskFilter(id: 'all', label: 'All'),
      TradeProviderLeaderboardRiskFilter(
        id: 'low',
        label: 'Low',
        riskLevel: TradeCopyRiskLevel.low,
      ),
      TradeProviderLeaderboardRiskFilter(
        id: 'medium',
        label: 'Medium',
        riskLevel: TradeCopyRiskLevel.medium,
      ),
      TradeProviderLeaderboardRiskFilter(
        id: 'high',
        label: 'High',
        riskLevel: TradeCopyRiskLevel.high,
      ),
    ];

const List<TradeSafetyTab> _safetyEducationTabs = [
  TradeSafetyTab(id: 'scams', label: 'Scams phổ biến'),
  TradeSafetyTab(id: 'redflags', label: 'Red Flags'),
  TradeSafetyTab(id: 'verification', label: 'Verification'),
  TradeSafetyTab(id: 'report', label: 'Report'),
];

const List<TradeSafetyScamType> _safetyScams = [
  TradeSafetyScamType(
    id: 'guaranteed-returns',
    title: 'Hứa hẹn lợi nhuận đảm bảo',
    description: 'Provider hứa "đảm bảo 100% lời" hoặc "không bao giờ thua"',
    examples: [
      '"Copy tôi = lời chắc chắn"',
      '"Strategy win rate 100%"',
      '"Không risk, chỉ có reward"',
    ],
    howToAvoid: [
      'KHÔNG CÓ lợi nhuận đảm bảo trong trading',
      'Win rate 100% là impossible',
      'Mọi trading đều có risk',
    ],
  ),
  TradeSafetyScamType(
    id: 'fake-performance',
    title: 'Giả mạo hiệu suất',
    description: 'Provider edit screenshots hoặc chọn lọc trades để hiển thị',
    examples: [
      'Screenshots không có timestamps',
      'Chỉ show winning trades',
      'Performance quá khác biệt vs verified stats',
    ],
    howToAvoid: [
      'Chỉ tin verified stats trên platform',
      'Yêu cầu audit trail đầy đủ',
      'Kiểm tra Max DD và losing trades',
    ],
  ),
  TradeSafetyScamType(
    id: 'pump-dump',
    title: 'Pump & Dump scheme',
    description:
        'Provider hold coin trước, trade để pump price, rồi dump lên followers',
    examples: [
      'Trade altcoin volume thấp',
      'Entry ngay khi announce',
      'Provider sell ngay sau khi followers buy',
    ],
    howToAvoid: [
      'Kiểm tra Conflict of Interest disclosure',
      'Tránh providers trade low-liquidity coins',
      'Đọc trade history trước khi copy',
    ],
  ),
  TradeSafetyScamType(
    id: 'identity-theft',
    title: 'Giả danh trader nổi tiếng',
    description: 'Scammer tạo tài khoản fake nhận là trader nổi tiếng',
    examples: [
      'Username gần giống (ElonMusk vs ElonMuskk)',
      'Avatar copy từ social media',
      'Claim về achievements không verify được',
    ],
    howToAvoid: [
      'Chỉ follow verified accounts',
      'Check social media links',
      'Yêu cầu video verification',
    ],
  ),
  TradeSafetyScamType(
    id: 'exit-scam',
    title: 'Exit Scam',
    description:
        'Provider tích lũy followers, rồi open positions lớn ngược xu hướng để thua lỗ chủ ý',
    examples: [
      'Đột ngột all-in vào 1 trade ngược trend',
      'Không stop-loss trong điều kiện xấu',
      'Account biến mất sau 1 trade thua lớn',
    ],
    howToAvoid: [
      'Đặt stop-loss riêng',
      'Theo dõi position sizing',
      'Dừng copy nếu behavior thay đổi đột ngột',
    ],
  ),
];

const List<TradeSafetyRedFlag> _safetyRedFlags = [
  TradeSafetyRedFlag(
    id: 'rf-1',
    category: 'performance',
    flag: 'ROI quá cao so với risk (>100% với DD <10%)',
    severity: 'critical',
    explanation:
        'Risk/reward ratio unrealistic. Có thể fake hoặc sắp exit scam.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-2',
    category: 'performance',
    flag: 'Tất cả trades đều lời (win rate 100%)',
    severity: 'critical',
    explanation: 'Impossible trong trading thực tế. Chắc chắn là scam.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-3',
    category: 'behavior',
    flag: 'Hứa lợi nhuận cố định (VD: 5% mỗi tuần)',
    severity: 'critical',
    explanation:
        'Trading không thể có lợi nhuận cố định. Dấu hiệu Ponzi scheme.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-4',
    category: 'disclosure',
    flag: 'Không công khai Max Drawdown',
    severity: 'warning',
    explanation: 'Provider đang che giấu losses. Red flag lớn.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-5',
    category: 'behavior',
    flag: 'Trade chủ yếu low-liquidity coins',
    severity: 'warning',
    explanation: 'Có thể đang chuẩn bị pump & dump.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-6',
    category: 'disclosure',
    flag: 'Không tiết lộ Conflict of Interest',
    severity: 'warning',
    explanation: 'Provider có thể đang trade coins mình hold.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-7',
    category: 'behavior',
    flag: 'Thay đổi strategy đột ngột không announce',
    severity: 'caution',
    explanation: 'Thiếu minh bạch với followers.',
  ),
  TradeSafetyRedFlag(
    id: 'rf-8',
    category: 'performance',
    flag: 'Sample size quá nhỏ (<50 trades)',
    severity: 'caution',
    explanation: 'Chưa đủ data để đánh giá. Có thể may mắn ngắn hạn.',
  ),
];

const List<TradeSafetyVerificationTier> _safetyVerificationTiers = [
  TradeSafetyVerificationTier(
    tier: 'Pro',
    colorHex: 0xFF8B5CF6,
    requirements: [
      'KYC Level 2 (ID + Selfie + PoA)',
      'Trading history ≥12 tháng verified',
      'Vốn tối thiểu \$50,000',
      'Sharpe Ratio >1.5',
      'Performance audit hàng tháng',
    ],
  ),
  TradeSafetyVerificationTier(
    tier: 'Verified',
    colorHex: 0xFF3B82F6,
    requirements: [
      'KYC Level 2',
      'Trading history ≥6 tháng',
      'Vốn tối thiểu \$10,000',
      'Sharpe Ratio >1.0',
      'Disclosure requirements đầy đủ',
    ],
  ),
  TradeSafetyVerificationTier(
    tier: 'Basic',
    colorHex: 0xFF6B7280,
    requirements: [
      'KYC Level 1 (Email + Phone)',
      'Không có performance audit',
      'KHÔNG khuyến nghị copy',
    ],
  ),
];

const List<String> _safetyReportReasons = [
  'Provider hứa lợi nhuận đảm bảo',
  'Phát hiện fake performance',
  'Bị lừa đảo hoặc scam',
  'Provider có hành vi market manipulation',
  'Vi phạm Terms of Service',
];

const List<TradeProviderGovernanceTab> _providerGovernanceTabs = [
  TradeProviderGovernanceTab(id: 'modifications', label: 'Modifications'),
  TradeProviderGovernanceTab(id: 'communication', label: 'Communication'),
  TradeProviderGovernanceTab(id: 'fees', label: 'Fees'),
  TradeProviderGovernanceTab(id: 'compliance', label: 'Compliance'),
];

const List<TradeStrategyModification> _strategyModifications = [
  TradeStrategyModification(
    id: 'mod-1',
    date: '2026-03-05',
    type: 'strategy_change',
    oldValue: 'Swing Trading',
    newValue: 'Scalping',
    notificationSent: true,
    followerImpact: 245,
  ),
  TradeStrategyModification(
    id: 'mod-2',
    date: '2026-02-15',
    type: 'risk_level',
    oldValue: 'Medium',
    newValue: 'High',
    notificationSent: true,
    followerImpact: 180,
  ),
  TradeStrategyModification(
    id: 'mod-3',
    date: '2026-01-20',
    type: 'fee_structure',
    oldValue: '15% performance fee',
    newValue: '10% performance fee',
    notificationSent: true,
    followerImpact: 320,
  ),
];

const List<TradeFollowerMessage> _followerMessages = [
  TradeFollowerMessage(
    id: 'msg-1',
    date: '2026-03-04',
    subject: 'Strategy Change Notification: Swing → Scalping',
    body:
        'Dear followers, effective March 5, I will be switching from swing trading to scalping...',
    recipients: 245,
    openRate: 78,
  ),
  TradeFollowerMessage(
    id: 'msg-2',
    date: '2026-02-14',
    subject: 'Risk Level Adjustment Notice',
    body:
        'I am increasing my risk level to capture more opportunities in the current market...',
    recipients: 180,
    openRate: 85,
  ),
];

const List<TradeFeeContributor> _feeContributors = [
  TradeFeeContributor(name: 'Follower #001', profit: 450, fee: 45),
  TradeFeeContributor(name: 'Follower #023', profit: 380, fee: 38),
  TradeFeeContributor(name: 'Follower #045', profit: 320, fee: 32),
  TradeFeeContributor(name: 'Follower #067', profit: 280, fee: 28),
  TradeFeeContributor(name: 'Follower #089', profit: 250, fee: 25),
];

const List<TradeComplianceItem> _complianceItems = [
  TradeComplianceItem(
    item: 'KYC verification up-to-date',
    status: true,
    lastCheck: '2026-03-01',
  ),
  TradeComplianceItem(
    item: 'Risk disclosure accurate',
    status: true,
    lastCheck: '2026-03-05',
  ),
  TradeComplianceItem(
    item: 'Fee structure transparent',
    status: true,
    lastCheck: '2026-02-28',
  ),
  TradeComplianceItem(
    item: 'No conflicts of interest undisclosed',
    status: true,
    lastCheck: '2026-03-01',
  ),
  TradeComplianceItem(
    item: 'Strategy description current',
    status: true,
    lastCheck: '2026-03-05',
  ),
  TradeComplianceItem(
    item: 'Communication obligations met',
    status: true,
    lastCheck: '2026-03-08',
  ),
];

const List<TradeComplaintTypeOption> _disputeComplaintTypes = [
  TradeComplaintTypeOption(
    value: 'execution_issue',
    label: 'Execution Issue',
    description: 'Slippage, delay, or fill rate problems',
  ),
  TradeComplaintTypeOption(
    value: 'fee_discrepancy',
    label: 'Fee Discrepancy',
    description: 'Incorrect fee calculation or charge',
  ),
  TradeComplaintTypeOption(
    value: 'strategy_change',
    label: 'Strategy Change Without Notice',
    description: 'Provider changed strategy without 24h notice',
  ),
  TradeComplaintTypeOption(
    value: 'performance_data',
    label: 'Performance Data Inaccuracy',
    description: 'Suspicious or fake performance stats',
  ),
  TradeComplaintTypeOption(
    value: 'misconduct',
    label: 'Provider Misconduct',
    description: 'Unethical behavior or scam',
  ),
];

const List<TradeDisputeProviderOption> _disputeProviders = [
  TradeDisputeProviderOption(id: 'trader-1', name: 'CryptoKing'),
  TradeDisputeProviderOption(id: 'trader-2', name: 'SwingMaster'),
  TradeDisputeProviderOption(id: 'trader-3', name: 'AlgoTrader'),
];

const List<TradeDisputeCase> _activeDisputeCases = [
  TradeDisputeCase(
    id: 'case-001',
    providerId: 'trader-2',
    providerName: 'SwingMaster',
    complaintType: 'execution_issue',
    subject: 'Excessive slippage on BTC trade',
    description:
        'Provider executed at \$68,500 but my copy filled at \$68,750 (0.36% slippage)',
    status: 'under_review',
    submittedDate: '2026-03-06',
    updatedDate: '2026-03-07',
    estimatedResolution: '2026-03-10',
  ),
];

const List<TradeDisputeCase> _resolvedDisputeCases = [
  TradeDisputeCase(
    id: 'case-002',
    providerId: 'trader-3',
    providerName: 'AlgoTrader',
    complaintType: 'fee_discrepancy',
    subject: 'Charged 15% instead of 10%',
    description: 'My profit was \$100 but fee charged was \$15 instead of \$10',
    status: 'resolved',
    submittedDate: '2026-02-20',
    updatedDate: '2026-02-25',
    estimatedResolution: '2026-02-25',
    outcome: 'refund',
  ),
];

const List<TradeCopySafetyCenterTab> _copySafetyCenterTabs = [
  TradeCopySafetyCenterTab(id: 'verification', label: 'Verification'),
  TradeCopySafetyCenterTab(id: 'metrics', label: 'Metrics'),
  TradeCopySafetyCenterTab(id: 'guidelines', label: 'Guidelines'),
  TradeCopySafetyCenterTab(id: 'tools', label: 'Tools'),
  TradeCopySafetyCenterTab(id: 'enforcement', label: 'Enforcement'),
];

const List<TradeCopyVerificationTier> _copyVerificationTiers = [
  TradeCopyVerificationTier(
    tier: 'Basic',
    requirements: ['Email verification', 'Phone verification', 'KYC Level 1'],
    benefits: ['Can become provider', 'Basic provider features'],
    colorHex: 0xFF6B7280,
  ),
  TradeCopyVerificationTier(
    tier: 'Verified',
    requirements: [
      'All Basic requirements',
      'KYC Level 2 (ID + Selfie)',
      '6 months trading history',
      '\$10,000 minimum capital',
      'Full disclosure obligations',
    ],
    benefits: [
      'Verified badge',
      'Higher trust from followers',
      'Advanced provider features',
    ],
    colorHex: 0xFF3B82F6,
  ),
  TradeCopyVerificationTier(
    tier: 'Pro',
    requirements: [
      'All Verified requirements',
      'KYC Level 2 + Proof of Address',
      '12 months trading history',
      '\$50,000 minimum capital',
      'Sharpe Ratio > 1.5',
      'Monthly performance audit',
    ],
    benefits: [
      'Pro badge',
      'Priority support',
      'Featured in leaderboard',
      'Premium analytics',
    ],
    colorHex: 0xFF8B5CF6,
  ),
];

const List<TradeCopyTrustMetric> _copyTrustMetrics = [
  TradeCopyTrustMetric(
    name: 'Sharpe Ratio',
    description: 'Measures risk-adjusted return. Higher is better.',
    goodRange: '> 1.5 (excellent), 1.0-1.5 (good)',
    badRange: '< 1.0 (poor)',
    whyMatters: 'Shows if provider is taking smart risks or just gambling',
  ),
  TradeCopyTrustMetric(
    name: 'Max Drawdown',
    description: 'Largest peak-to-trough decline in account value.',
    goodRange: '< 15% (excellent), 15-25% (acceptable)',
    badRange: '> 25% (risky)',
    whyMatters: 'Indicates worst-case loss scenario. Can you handle it?',
  ),
  TradeCopyTrustMetric(
    name: 'Slippage',
    description:
        "Difference between provider's price and your execution price.",
    goodRange: '< 0.2% (excellent), 0.2-0.5% (acceptable)',
    badRange: '> 0.5% (poor execution)',
    whyMatters:
        'High slippage eats into your returns, especially in volatile markets',
  ),
  TradeCopyTrustMetric(
    name: 'Win Rate',
    description: 'Percentage of profitable trades.',
    goodRange: '> 60% (excellent), 50-60% (acceptable)',
    badRange: '< 50% (risky)',
    whyMatters: 'Combined with avg win/loss, shows strategy consistency',
  ),
];

const List<String> _copyProhibitedBehaviors = [
  'Wash trading (fake volume)',
  'Fake performance data',
  'Undisclosed conflicts of interest',
  'Strategy changes without 24h notice',
  'Hidden fee structures',
  'Market manipulation',
  'Misleading claims (guaranteed profits)',
];

const List<String> _copyFollowerResponsibilities = [
  'Do your own research before copying',
  'Understand all risks involved',
  'Set appropriate stop-loss limits',
  'Monitor your copies regularly',
  'Report suspicious behavior immediately',
  'Do not over-allocate to single provider',
];

const List<TradeCopyReportingStep> _copyReportingSteps = [
  TradeCopyReportingStep(
    title: '1. Collect Evidence',
    description: 'Screenshots, trade IDs, timestamps, chat logs',
  ),
  TradeCopyReportingStep(
    title: '2. File Report',
    description: 'Use "Report Provider" form with detailed description',
  ),
  TradeCopyReportingStep(
    title: '3. Investigation',
    description: 'Team reviews within 24-48 hours',
  ),
  TradeCopyReportingStep(
    title: '4. Enforcement',
    description: 'Warning, suspension, or permanent ban if violation confirmed',
  ),
];

const List<TradeCopySafetyTool> _copySafetyTools = [
  TradeCopySafetyTool(
    id: 'block',
    title: 'Block Provider',
    description: 'Prevent provider from appearing in your feeds',
    colorHex: 0xFFF59E0B,
    routePath: '/trade/copy-trading',
  ),
  TradeCopySafetyTool(
    id: 'report',
    title: 'Report Provider',
    description: 'Submit complaint to moderation team',
    colorHex: 0xFFEF4444,
    routePath: '/trade/copy-trading/safety',
  ),
  TradeCopySafetyTool(
    id: 'emergency',
    title: 'Emergency Stop All',
    description: 'Immediately stop all copying and close positions',
    colorHex: 0xFFEF4444,
  ),
];

const List<TradeCopyEnforcementAction> _copyEnforcementActions = [
  TradeCopyEnforcementAction(
    id: 'enf-1',
    date: '2026-03-05',
    providerName: 'Provider X',
    action: 'suspended',
    reason: 'Wash trading detected (fake volume)',
  ),
  TradeCopyEnforcementAction(
    id: 'enf-2',
    date: '2026-02-28',
    providerName: 'Provider Y',
    action: 'warned',
    reason: 'Undisclosed fee changes',
  ),
  TradeCopyEnforcementAction(
    id: 'enf-3',
    date: '2026-02-20',
    providerName: 'Provider Z',
    action: 'verified',
    reason: 'Passed Pro tier audit',
  ),
];

const List<TradeRegulatoryTab> _regulatoryTabs = [
  TradeRegulatoryTab(id: 'mifid', label: 'MiFID II'),
  TradeRegulatoryTab(id: 'protection', label: 'Protection'),
  TradeRegulatoryTab(id: 'restrictions', label: 'Restrictions'),
  TradeRegulatoryTab(id: 'liability', label: 'Liability'),
  TradeRegulatoryTab(id: 'contact', label: 'Contact'),
];

const List<TradeRegulatoryDisclosureBlock> _regulatoryMifidArticles = [
  TradeRegulatoryDisclosureBlock(
    title: 'Article 24: Information to Clients',
    body:
        'We provide all material information about copy trading, including risks, costs, and nature of service. All disclosures are clear, accurate, and not misleading.',
  ),
  TradeRegulatoryDisclosureBlock(
    title: 'Article 25: Assessment of Suitability and Appropriateness',
    body: 'Before you can copy trade, we assess:',
    items: [
      'Your knowledge and experience with copy trading',
      'Your ability to bear financial losses',
      'Your risk tolerance level',
      'Your investment objectives',
    ],
  ),
  TradeRegulatoryDisclosureBlock(
    title: 'Article 27: Best Execution Obligation',
    body:
        'We execute your copy orders on terms most favorable to you, considering price, costs, speed, likelihood of execution, and other relevant factors. Execution quality metrics are disclosed transparently.',
  ),
  TradeRegulatoryDisclosureBlock(
    title: 'Article 58: Record Keeping',
    body:
        'All transactions, communications, and risk assessments are recorded and retained for a minimum of 5 years. You can request your complete audit trail at any time.',
  ),
];

const TradeRegulatoryProtection
_regulatoryProtection = TradeRegulatoryProtection(
  coverage: TradeRegulatoryDisclosureBlock(
    title: 'Coverage Limit',
    body:
        'Eligible claims are covered up to EUR 20,000 per user under the Investor Compensation Scheme (ICS). This protects you if we become insolvent.',
  ),
  covered: TradeRegulatoryDisclosureBlock(
    title: "What's Covered",
    body: '',
    items: [
      'Cash balances in your copy trading account',
      'Open positions at time of insolvency',
      'Uncredited deposits',
    ],
  ),
  notCovered: TradeRegulatoryDisclosureBlock(
    title: "What's NOT Covered",
    body: '',
    items: [
      'Trading losses (market risk)',
      'Poor provider performance',
      'Slippage costs',
      'Unauthorized account access (negligence)',
    ],
  ),
  claimSteps: TradeRegulatoryDisclosureBlock(
    title: 'How to File a Claim',
    body: '',
    items: [
      '1. Contact our support team within 30 days',
      '2. Complete claim form with evidence',
      '3. Submit to ICS operator',
      '4. Receive decision within 90 days',
    ],
  ),
  contactLabel: 'ICS Operator Contact',
);

const TradeRegulatoryRestrictions
_regulatoryRestrictions = TradeRegulatoryRestrictions(
  unavailableCountries: [
    'United States (US residents)',
    'China (mainland)',
    'North Korea',
    'Iran',
    'Syria',
    'Countries under OFAC sanctions',
  ],
  leverageRules: [
    TradeRegulatoryDisclosureBlock(
      title: 'EU Retail Clients:',
      body: 'Max 30:1 for major forex, 20:1 for minor',
    ),
    TradeRegulatoryDisclosureBlock(
      title: 'UK Retail Clients:',
      body: 'FCA limits apply (same as EU)',
    ),
    TradeRegulatoryDisclosureBlock(
      title: 'Professional Clients:',
      body: 'Higher leverage available (up to 100:1)',
    ),
  ],
  taxReporting: TradeRegulatoryDisclosureBlock(
    title: 'Tax Reporting Obligations',
    body:
        'You are responsible for reporting trading income to your local tax authority. We provide:',
    items: [
      'Annual tax report (P/L summary)',
      'Trade-by-trade export (CSV)',
      'Fee breakdown report',
    ],
  ),
);

const TradeRegulatoryLiability _regulatoryLiability = TradeRegulatoryLiability(
  platformRole: TradeRegulatoryDisclosureBlock(
    title: 'Platform Role',
    body: 'We are a technology provider, not an investment advisor. We do not:',
    items: [
      'Recommend specific providers to copy',
      'Guarantee provider performance',
      'Control provider trading decisions',
      'Provide personalized investment advice',
    ],
  ),
  userResponsibility: TradeRegulatoryDisclosureBlock(
    title: 'User Responsibility',
    body: 'You are solely responsible for:',
    items: [
      'Conducting your own due diligence',
      'Risk assessment and management',
      'Investment decisions and outcomes',
      'Monitoring your copy positions',
    ],
  ),
  indemnification: TradeRegulatoryDisclosureBlock(
    title: 'Indemnification',
    body:
        'You agree to indemnify and hold us harmless from any claims, damages, or losses arising from your use of copy trading, except in cases of our gross negligence or willful misconduct.',
  ),
  limitation: TradeRegulatoryDisclosureBlock(
    title: 'Limitation of Liability',
    body:
        'Our maximum liability is limited to the fees you paid in the last 12 months, except where prohibited by law. We are not liable for consequential, indirect, or punitive damages.',
  ),
);

const List<TradeRegulatoryContact> _regulatoryContacts = [
  TradeRegulatoryContact(
    title: 'Financial Conduct Authority (FCA)',
    subtitle: 'UK regulatory authority',
    icon: 'globe',
  ),
  TradeRegulatoryContact(
    title: 'European Securities and Markets Authority (ESMA)',
    subtitle: 'EU regulatory authority',
    icon: 'shield',
  ),
  TradeRegulatoryContact(
    title: 'Financial Ombudsman Service',
    subtitle: 'Dispute resolution',
    icon: 'phone',
  ),
];

const TradeRegulatoryDisclosureBlock
_regulatoryWhistleblower = TradeRegulatoryDisclosureBlock(
  title: 'Report Regulatory Violations Confidentially',
  body:
      'If you suspect violations of financial regulations, you can report anonymously to:',
  items: [
    'Email: compliance@vittrade.com',
    'Hotline: +44 20 XXXX XXXX',
    'Secure form: vittrade.com/whistleblower',
  ],
);

const List<TradeRegulatoryDocumentLink> _regulatoryTerms = [
  TradeRegulatoryDocumentLink(
    title: 'Copy Trading Terms of Service',
    icon: 'file',
  ),
  TradeRegulatoryDocumentLink(
    title: 'Privacy Policy (Data Handling)',
    icon: 'lock',
  ),
];

const TradeMarginAccount _marginAccount = TradeMarginAccount(
  totalEquity: 12450.80,
  totalMargin: 6080,
  availableMargin: 6370.80,
  unrealizedPnl: 768.28,
  marginLevel: 204.8,
);

const List<TradeMarginPosition> _marginPositions = [
  TradeMarginPosition(
    id: 'mg001',
    pair: 'BTC/USDT',
    side: 'long',
    mode: 'cross',
    leverage: 5,
    entryPrice: 65200,
    markPrice: 67543.21,
    size: .15,
    margin: 1956,
    pnl: 351.48,
    pnlPct: 17.97,
    liquidationPrice: 52160,
    marginRatio: 12.5,
  ),
  TradeMarginPosition(
    id: 'mg002',
    pair: 'ETH/USDT',
    side: 'short',
    mode: 'isolated',
    leverage: 10,
    entryPrice: 3620,
    markPrice: 3521.45,
    size: 2,
    margin: 724,
    pnl: 197.10,
    pnlPct: 27.22,
    liquidationPrice: 3982,
    marginRatio: 8.3,
  ),
  TradeMarginPosition(
    id: 'mg003',
    pair: 'SOL/USDT',
    side: 'long',
    mode: 'cross',
    leverage: 3,
    entryPrice: 172.50,
    markPrice: 178.32,
    size: 50,
    margin: 2875,
    pnl: 291,
    pnlPct: 10.12,
    liquidationPrice: 115,
    marginRatio: 18.7,
  ),
  TradeMarginPosition(
    id: 'mg004',
    pair: 'BNB/USDT',
    side: 'long',
    mode: 'isolated',
    leverage: 8,
    entryPrice: 420,
    markPrice: 412.87,
    size: 10,
    margin: 525,
    pnl: -71.30,
    pnlPct: -13.58,
    liquidationPrice: 370,
    marginRatio: 5.2,
  ),
];

const List<TradeMarginTab> _marginModeTabs = [
  TradeMarginTab(id: 'cross', label: 'Cross Margin'),
  TradeMarginTab(id: 'isolated', label: 'Isolated Margin'),
];

const List<TradeMarginTab> _marginContentTabs = [
  TradeMarginTab(id: 'trade', label: 'Giao dịch'),
  TradeMarginTab(id: 'positions', label: 'Vị thế'),
  TradeMarginTab(id: 'orders', label: 'Lệnh chờ'),
];

const TradeMarginClientCategory _marginClientCategory =
    TradeMarginClientCategory(
      title: 'Retail Client',
      description: 'Bạn được hưởng bảo vệ cao nhất theo quy định MiFID II/FCA',
      badgeLabel: 'Nâng cấp',
      limits: [
        'Leverage tối đa: 30x (crypto)',
        'Negative balance protection',
        'Best execution guarantee',
      ],
    );

const TradeMarginReferencePrices _marginReferencePrices =
    TradeMarginReferencePrices(
      markPrice: 67543.21,
      lastPrice: 67572.63,
      indexPrice: 67529.70,
    );

const TradeMarginReferencePrices _marginPairRouteReferencePrices =
    TradeMarginReferencePrices(
      markPrice: 67543.21,
      lastPrice: 67516.13,
      indexPrice: 67529.70,
    );

const TradeMarginOrderDraft _marginOrderDraft = TradeMarginOrderDraft(
  orderTypes: [
    TradeMarginTab(id: 'limit', label: 'Limit Order'),
    TradeMarginTab(id: 'market', label: 'Market Order'),
  ],
  selectedOrderType: 'limit',
  price: '67543.21',
  amount: '0.00',
  tradingFeeRate: .0005,
  liquidationPriceLabel: '--',
);

const TradeMarginRiskWarning _marginRiskWarning = TradeMarginRiskWarning(
  title: 'Rủi ro đòn bẩy 5x',
  items: [
    'Giá chỉ cần biến động 20.00% ngược chiều là bạn bị thanh lý toàn bộ vị thế',
    'Đòn bẩy cao = rủi ro cao. Chỉ giao dịch số tiền bạn có thể chấp nhận mất',
  ],
);

const TradeMarginSafetyDisclosure
_marginNegativeBalance = TradeMarginSafetyDisclosure(
  title: 'Bảo vệ số dư âm',
  body:
      'Nền tảng cam kết bảo vệ 100% số dư âm. Bạn không bao giờ mất nhiều hơn số tiền đã nạp vào tài khoản, ngay cả trong trường hợp thanh lý.',
  footer: 'Insurance Fund: \$12,450,000 | Cập nhật: Hàng ngày',
);

const TradeMarginBestExecutionDisclosure
_marginBestExecution = TradeMarginBestExecutionDisclosure(
  title: 'Best Execution Policy',
  body:
      'Chúng tôi cam kết thực hiện lệnh của bạn theo Best Execution theo quy định MiFID II:',
  items: [
    'Giá tốt nhất có sẵn trên nhiều exchanges',
    'Tốc độ khớp lệnh nhanh nhất',
    'Chi phí thấp nhất (phí + slippage)',
    'Khả năng settlement và size phù hợp',
  ],
  actionLabel: 'Xem Best Execution Report',
);

const List<TradeCopyTrader> _copyTraders = [
  TradeCopyTrader(
    id: 'ct001',
    name: 'AlphaHunter_VN',
    avatar: 'A',
    winRate: 78.5,
    totalPnl: 125430,
    totalPnlPct: 342.5,
    aum: 2450000,
    copiers: 1243,
    maxCopiers: 2000,
    sharpeRatio: 2.31,
    maxDrawdown: -12.4,
    totalTrades: 4521,
    avgHoldingTime: '4.2h',
    weeklyPnl: [2.1, -0.8, 3.4, 1.2, -0.3, 2.8, 1.5],
    tags: ['Top ROI', 'Scalper'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.medium,
  ),
  TradeCopyTrader(
    id: 'ct002',
    name: 'SteadyGains_Pro',
    avatar: 'S',
    winRate: 82.3,
    totalPnl: 89200,
    totalPnlPct: 187.2,
    aum: 5120000,
    copiers: 3421,
    maxCopiers: 5000,
    sharpeRatio: 3.12,
    maxDrawdown: -8.1,
    totalTrades: 2890,
    avgHoldingTime: '12h',
    weeklyPnl: [0.8, 1.1, 0.5, 1.3, 0.7, 0.9, 1.0],
    tags: ['Stable', 'Swing'],
    isFollowing: true,
    riskLevel: TradeCopyRiskLevel.low,
  ),
  TradeCopyTrader(
    id: 'ct003',
    name: 'RiskMaster_88',
    avatar: 'R',
    winRate: 65.2,
    totalPnl: 234100,
    totalPnlPct: 567.8,
    aum: 890000,
    copiers: 567,
    maxCopiers: 1000,
    sharpeRatio: 1.85,
    maxDrawdown: -28.3,
    totalTrades: 8934,
    avgHoldingTime: '1.5h',
    weeklyPnl: [5.2, -3.1, 8.4, -2.1, 6.3, -1.8, 4.7],
    tags: ['High ROI', 'Aggressive'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.high,
  ),
  TradeCopyTrader(
    id: 'ct004',
    name: 'CryptoSensei',
    avatar: 'C',
    winRate: 71.8,
    totalPnl: 67890,
    totalPnlPct: 156.3,
    aum: 1890000,
    copiers: 892,
    maxCopiers: 1500,
    sharpeRatio: 2.67,
    maxDrawdown: -15.2,
    totalTrades: 3456,
    avgHoldingTime: '8h',
    weeklyPnl: [1.5, 2.0, -0.5, 1.8, 1.2, 2.3, 0.9],
    tags: ['Balanced', 'BTC Focus'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.medium,
  ),
  TradeCopyTrader(
    id: 'ct005',
    name: 'WhaleWatcher',
    avatar: 'W',
    winRate: 74.1,
    totalPnl: 312500,
    totalPnlPct: 423.1,
    aum: 8900000,
    copiers: 4890,
    maxCopiers: 5000,
    sharpeRatio: 2.89,
    maxDrawdown: -10.5,
    totalTrades: 1234,
    avgHoldingTime: '3d',
    weeklyPnl: [0.3, 0.5, -0.1, 0.8, 0.2, 0.6, 0.4],
    tags: ['Top AUM', 'Long-term'],
    isFollowing: false,
    riskLevel: TradeCopyRiskLevel.low,
  ),
];

const List<TradeTraderPnlPoint> _traderProfilePnlHistory = [
  TradeTraderPnlPoint(day: '0', pnl: 1800, cumPnl: 1800),
  TradeTraderPnlPoint(day: '1', pnl: -640, cumPnl: 1160),
  TradeTraderPnlPoint(day: '2', pnl: 4280, cumPnl: 5440),
  TradeTraderPnlPoint(day: '3', pnl: 3150, cumPnl: 8590),
  TradeTraderPnlPoint(day: '4', pnl: -720, cumPnl: 7870),
  TradeTraderPnlPoint(day: '5', pnl: 5170, cumPnl: 13040),
  TradeTraderPnlPoint(day: '6', pnl: 2460, cumPnl: 15500),
  TradeTraderPnlPoint(day: '7', pnl: 6100, cumPnl: 21600),
  TradeTraderPnlPoint(day: '8', pnl: -1220, cumPnl: 20380),
  TradeTraderPnlPoint(day: '9', pnl: 5380, cumPnl: 25760),
  TradeTraderPnlPoint(day: '10', pnl: 3920, cumPnl: 29680),
  TradeTraderPnlPoint(day: '11', pnl: 7440, cumPnl: 37120),
  TradeTraderPnlPoint(day: '12', pnl: -2180, cumPnl: 34940),
  TradeTraderPnlPoint(day: '13', pnl: 5040, cumPnl: 39980),
  TradeTraderPnlPoint(day: '14', pnl: 8300, cumPnl: 48280),
  TradeTraderPnlPoint(day: '15', pnl: 4160, cumPnl: 52440),
  TradeTraderPnlPoint(day: '16', pnl: -1780, cumPnl: 50660),
  TradeTraderPnlPoint(day: '17', pnl: 6840, cumPnl: 57500),
  TradeTraderPnlPoint(day: '18', pnl: 9120, cumPnl: 66620),
  TradeTraderPnlPoint(day: '19', pnl: -2640, cumPnl: 63980),
  TradeTraderPnlPoint(day: '20', pnl: 7580, cumPnl: 71560),
  TradeTraderPnlPoint(day: '21', pnl: 6420, cumPnl: 77980),
  TradeTraderPnlPoint(day: '22', pnl: 9050, cumPnl: 87030),
  TradeTraderPnlPoint(day: '23', pnl: -3340, cumPnl: 83690),
  TradeTraderPnlPoint(day: '24', pnl: 7480, cumPnl: 91170),
  TradeTraderPnlPoint(day: '25', pnl: 9660, cumPnl: 100830),
  TradeTraderPnlPoint(day: '26', pnl: 5140, cumPnl: 105970),
  TradeTraderPnlPoint(day: '27', pnl: -2480, cumPnl: 103490),
  TradeTraderPnlPoint(day: '28', pnl: 8720, cumPnl: 112210),
  TradeTraderPnlPoint(day: '29', pnl: 6320, cumPnl: 118530),
  TradeTraderPnlPoint(day: '30', pnl: 6900, cumPnl: 125430),
];

const List<TradeTraderRecentTrade> _traderProfileRecentTrades = [
  TradeTraderRecentTrade(
    id: 't1',
    pair: 'BTC/USDT',
    side: 'long',
    entry: 65200,
    exit: 67543,
    pnl: 2343,
    pnlPct: 3.59,
    time: '2h trước',
    status: 'closed',
  ),
  TradeTraderRecentTrade(
    id: 't2',
    pair: 'ETH/USDT',
    side: 'short',
    entry: 3620,
    exit: 3521,
    pnl: 990,
    pnlPct: 2.73,
    time: '5h trước',
    status: 'closed',
  ),
  TradeTraderRecentTrade(
    id: 't3',
    pair: 'SOL/USDT',
    side: 'long',
    entry: 172,
    exit: null,
    pnl: 316,
    pnlPct: 3.37,
    time: '1d trước',
    status: 'open',
  ),
  TradeTraderRecentTrade(
    id: 't4',
    pair: 'BNB/USDT',
    side: 'long',
    entry: 405,
    exit: 398,
    pnl: -700,
    pnlPct: -1.73,
    time: '2d trước',
    status: 'closed',
  ),
  TradeTraderRecentTrade(
    id: 't5',
    pair: 'BTC/USDT',
    side: 'long',
    entry: 63800,
    exit: 65200,
    pnl: 1400,
    pnlPct: 2.19,
    time: '3d trước',
    status: 'closed',
  ),
];

const TradeAdvancedDemoPosition _advancedDemoPosition =
    TradeAdvancedDemoPosition(
      id: 'pos1',
      pair: 'BTC/USDT',
      side: 'long',
      currentSize: .5,
      currentPnl: 1250,
      markPrice: 67543.21,
      entryPrice: 65200,
      currentMargin: 6520,
      availableBalance: 5000,
      liquidationPrice: 52160,
    );

const List<TradeAdvancedDemoAction> _advancedDemoPositionActions = [
  TradeAdvancedDemoAction(
    id: 'partial-close',
    label: 'Partial Close Position (25%/50%/75%/100%)',
    description: 'Close a controlled percentage of the current position.',
  ),
  TradeAdvancedDemoAction(
    id: 'ladder-tpsl',
    label: 'Ladder TP/SL (Multiple Levels)',
    description: 'Split take-profit and stop-loss into multiple levels.',
  ),
  TradeAdvancedDemoAction(
    id: 'trailing-stop',
    label: 'Trailing Stop Loss',
    description: 'Move stop distance automatically as price moves.',
  ),
  TradeAdvancedDemoAction(
    id: 'margin-adjust',
    label: 'Add/Reduce Margin',
    description: 'Adjust margin allocation without leaving the position.',
  ),
];

const List<TradeAdvancedDemoAction> _advancedDemoOrderTypes = [
  TradeAdvancedDemoAction(
    id: 'market',
    label: 'Market',
    description: 'Khớp ngay lập tức với giá tốt nhất',
  ),
  TradeAdvancedDemoAction(
    id: 'limit',
    label: 'Limit',
    description: 'Đặt giá mong muốn, chờ khớp',
  ),
  TradeAdvancedDemoAction(
    id: 'stop-market',
    label: 'Stop Market',
    description: 'Kích hoạt Market khi chạm trigger',
  ),
  TradeAdvancedDemoAction(
    id: 'stop-limit',
    label: 'Stop Limit',
    description: 'Kích hoạt Limit khi chạm trigger',
  ),
];

const List<TradeAdvancedDemoAction> _advancedDemoTimeInForce = [
  TradeAdvancedDemoAction(
    id: 'GTC',
    label: 'GTC',
    description: 'Good Till Cancel',
  ),
  TradeAdvancedDemoAction(
    id: 'IOC',
    label: 'IOC',
    description: 'Immediate or Cancel',
  ),
  TradeAdvancedDemoAction(id: 'FOK', label: 'FOK', description: 'Fill or Kill'),
  TradeAdvancedDemoAction(
    id: 'GTX',
    label: 'Post-Only',
    description: 'Maker only',
  ),
];

const List<TradeAdvancedDemoMetric> _advancedDemoOrderSummary = [
  TradeAdvancedDemoMetric(label: 'Order Type', value: 'LIMIT'),
  TradeAdvancedDemoMetric(label: 'Time In Force', value: 'GTC'),
  TradeAdvancedDemoMetric(label: 'Reduce-Only', value: 'No'),
  TradeAdvancedDemoMetric(label: 'Iceberg', value: 'Disabled'),
];

const List<TradeAdvancedDemoMetric> _advancedDemoPnlSummary = [
  TradeAdvancedDemoMetric(
    label: 'Realized PnL',
    value: '+\$3,250.50',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Unrealized PnL',
    value: '+\$1,250.00',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Equity',
    value: '\$15,000.00',
    tone: TradeAdvancedMetricTone.accent,
  ),
];

const List<TradeAdvancedDemoMetric> _advancedDemoPerformanceMetrics = [
  TradeAdvancedDemoMetric(label: 'Total Trades', value: '47'),
  TradeAdvancedDemoMetric(
    label: 'Win Rate',
    value: '68.1%',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Profit',
    value: '+\$8,450.00',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Loss',
    value: '-\$3,200.00',
    tone: TradeAdvancedMetricTone.negative,
  ),
  TradeAdvancedDemoMetric(label: 'Avg Win', value: '\$264.06'),
  TradeAdvancedDemoMetric(label: 'Avg Loss', value: '-\$213.33'),
];

const TradeMarketOpenInterest _marketOpenInterest = TradeMarketOpenInterest(
  current: 25680000000,
  change24h: 1250000000,
  change24hPct: 5.12,
  high24h: 26100000000,
  low24h: 24500000000,
);

const TradeMarketLongShortRatio _marketLongShortRatio =
    TradeMarketLongShortRatio(
      longPct: 62.5,
      shortPct: 37.5,
      longAccounts: 125400,
      shortAccounts: 75200,
      longVolume: 18500000000,
      shortVolume: 11200000000,
    );

const TradeTopTraderPositions _marketTopTraders = TradeTopTraderPositions(
  longPct: 58.3,
  shortPct: 41.7,
  change24h: 3.2,
);

const TradeFundingRateHistory _marketFundingRate = TradeFundingRateHistory(
  currentRatePct: .010,
  avgRatePct: -.001,
  rangePct: .014,
  nextFundingLabel: '02:00',
  historyPct: [
    .006,
    .001,
    -.003,
    .010,
    .009,
    .006,
    .006,
    .004,
    .001,
    -.002,
    .010,
    .003,
    .002,
    .005,
    .007,
    -.003,
    .002,
    .005,
    .001,
    -.001,
    .008,
    .001,
    .002,
    .002,
  ],
);

const TradeMarketOpenInterest _liveMarketOpenInterest = TradeMarketOpenInterest(
  current: 25433440000,
  change24h: -246560000,
  change24hPct: -.96,
  high24h: 25433440000,
  low24h: 25433440000,
);

const TradeMarketLongShortRatio _liveMarketLongShortRatio =
    TradeMarketLongShortRatio(
      longPct: 61.6,
      shortPct: 38.4,
      longAccounts: 127093,
      shortAccounts: 79033,
      longVolume: 18020000000,
      shortVolume: 11240000000,
    );

const TradeTopTraderPositions _liveMarketTopTraders = TradeTopTraderPositions(
  longPct: 57.7,
  shortPct: 42.3,
  change24h: -.6,
);

const TradeFundingRateHistory _liveMarketFundingRate = TradeFundingRateHistory(
  currentRatePct: .010,
  avgRatePct: -.003,
  rangePct: .014,
  nextFundingLabel: '01:29',
  historyPct: [
    .007,
    .003,
    .006,
    -.003,
    -.002,
    .000,
    .003,
    .008,
    -.004,
    .003,
    -.001,
    -.003,
    -.003,
    .004,
    -.001,
    -.004,
    .005,
    -.001,
    .001,
    -.001,
    .008,
    -.003,
    .002,
    -.002,
  ],
);

const TradeLiquidationStats _marketLiquidationStats = TradeLiquidationStats(
  total24h: 320000000,
  long24h: 185000000,
  short24h: 135000000,
  largest24h: 2500000,
  avg24h: 45000,
  count24h: 7120,
  total7d: 1850000000,
  count7d: 42300,
  total30d: 6200000000,
  count30d: 158000,
);

const List<TradeLiquidationCluster> _marketLiquidationClusters = [
  TradeLiquidationCluster(
    price: 70000,
    longLiquidations: 45000000,
    shortLiquidations: 12000000,
    total: 57000000,
    intensity: 95,
  ),
  TradeLiquidationCluster(
    price: 68500,
    longLiquidations: 32000000,
    shortLiquidations: 8000000,
    total: 40000000,
    intensity: 70,
  ),
  TradeLiquidationCluster(
    price: 67543,
    longLiquidations: 0,
    shortLiquidations: 0,
    total: 0,
    intensity: 0,
  ),
  TradeLiquidationCluster(
    price: 66000,
    longLiquidations: 15000000,
    shortLiquidations: 28000000,
    total: 43000000,
    intensity: 75,
  ),
  TradeLiquidationCluster(
    price: 65000,
    longLiquidations: 8000000,
    shortLiquidations: 52000000,
    total: 60000000,
    intensity: 100,
  ),
  TradeLiquidationCluster(
    price: 64000,
    longLiquidations: 12000000,
    shortLiquidations: 35000000,
    total: 47000000,
    intensity: 80,
  ),
];

const List<TradeRecentLiquidation> _marketRecentLiquidations = [
  TradeRecentLiquidation(
    id: 'liq-1',
    timeLabel: '45s ago',
    pair: 'BTC/USDT',
    side: 'long',
    size: 486000,
    price: 67180,
    exchange: 'Binance',
  ),
  TradeRecentLiquidation(
    id: 'liq-2',
    timeLabel: '1m ago',
    pair: 'ETH/USDT',
    side: 'short',
    size: 224000,
    price: 3538,
    exchange: 'Binance',
  ),
  TradeRecentLiquidation(
    id: 'liq-3',
    timeLabel: '2m ago',
    pair: 'BTC/USDT',
    side: 'short',
    size: 128000,
    price: 67810,
    exchange: 'Binance',
  ),
];

const TradeMarketSentiment _marketSentiment = TradeMarketSentiment(
  overall: 'greed',
  score: 68,
  components: [
    TradeSentimentComponent(
      label: 'Open Interest Trend',
      weight: '20%',
      score: 45,
      description: 'OI tang + gia tang = bullish',
    ),
    TradeSentimentComponent(
      label: 'Long/Short Ratio',
      weight: '25%',
      score: 62,
      description: 'Ty le long vs short traders',
    ),
    TradeSentimentComponent(
      label: 'Top Trader Positions',
      weight: '25%',
      score: 58,
      description: 'Whales dang long hay short',
    ),
    TradeSentimentComponent(
      label: 'Funding Rate',
      weight: '15%',
      score: -15,
      description: 'Duong = bullish pressure',
    ),
    TradeSentimentComponent(
      label: 'Price Action',
      weight: '15%',
      score: 72,
      description: 'Momentum va volatility',
    ),
  ],
  implications: [
    TradeSentimentImplication(
      condition: 'Extreme Greed (>75)',
      action: 'Can nhac chot loi. Market co the dieu chinh.',
      colorHex: 0xFFEF4444,
    ),
    TradeSentimentImplication(
      condition: 'Greed (60-75)',
      action: 'Theo trend nhung can than. Dat trailing stop.',
      colorHex: 0xFFF59E0B,
    ),
    TradeSentimentImplication(
      condition: 'Neutral (40-60)',
      action: 'Cho tin hieu ro rang hon. Khong FOMO.',
      colorHex: 0xFF3B82F6,
    ),
    TradeSentimentImplication(
      condition: 'Fear (25-40)',
      action: 'Co hoi accumulate neu fundamentals on.',
      colorHex: 0xFF84CC16,
    ),
    TradeSentimentImplication(
      condition: 'Extreme Fear (<25)',
      action: 'Capitulation co the xay ra. DCA cho long-term.',
      colorHex: 0xFF10B981,
    ),
  ],
);

const List<TradeMarginHubStat> _marginHubStats = [
  TradeMarginHubStat(
    label: 'Total Features',
    value: '27',
    colorHex: 0xFF10B981,
  ),
  TradeMarginHubStat(
    label: 'Lines of Code',
    value: '~5,100',
    colorHex: 0xFF3B82F6,
  ),
  TradeMarginHubStat(label: 'Components', value: '19', colorHex: 0xFFF59E0B),
  TradeMarginHubStat(label: 'Compliance', value: '100%', colorHex: 0xFF8B5CF6),
];

const List<TradeMarginHubMenuItem> _marginHubMenuItems = [
  TradeMarginHubMenuItem(
    id: 'margin',
    title: 'Margin Trading',
    subtitle: 'Trade voi don bay - P0 Compliance day du',
    badge: 'LIVE',
    colorHex: 0xFF10B981,
    targetPath: '/trade/margin',
  ),
  TradeMarginHubMenuItem(
    id: 'advanced-controls',
    title: 'Advanced Controls',
    subtitle: 'Partial close, Ladder TP/SL, Trailing Stop, Order types',
    badge: 'P1',
    colorHex: 0xFF3B82F6,
    targetPath: '/trade/margin/advanced-demo',
  ),
  TradeMarginHubMenuItem(
    id: 'market-analytics',
    title: 'Market Analytics',
    subtitle: 'OI, Long/Short Ratio, Liquidation Heatmap, Sentiment',
    badge: 'P2',
    colorHex: 0xFFF59E0B,
    targetPath: '/trade/margin/live-market-data-analytics',
  ),
  TradeMarginHubMenuItem(
    id: 'ai-advanced',
    title: 'AI & Advanced Analytics',
    subtitle: 'AI Signals, Risk Analysis, Trade Journal, Position Sizing',
    badge: 'P3',
    colorHex: 0xFF8B5CF6,
    targetPath: '/trade/margin/advanced-analytics',
  ),
];

const List<TradeMarginHubFeature> _marginHubFeatures = [
  TradeMarginHubFeature(
    phase: 'P0',
    title: 'Regulatory & Safety',
    colorHex: 0xFFEF4444,
    items: [
      'Appropriateness Test (quiz system)',
      'Regional Leverage Limits (EU 2x, UK 2x, SG 20x)',
      'Margin Call Alerts (4 thresholds)',
      'Mark Price Separation (liquidation accuracy)',
      'Total Cost Breakdown (MiFID II compliance)',
      'Negative Balance Protection',
      '50% Closeout Warning (EU/UK)',
      'Best Execution Disclosure',
    ],
  ),
  TradeMarginHubFeature(
    phase: 'P1',
    title: 'Advanced Controls',
    colorHex: 0xFF3B82F6,
    items: [
      'Partial Close Position (25%/50%/75%/100%)',
      'Ladder TP/SL (unlimited levels)',
      'Trailing Stop Loss (% or \$ based)',
      'Position Mode Toggle (One-way vs Hedge)',
      'Add/Reduce Margin dynamically',
      'Advanced Order Types (IOC, FOK, Post-Only)',
      'Iceberg Orders (hidden size)',
      'Realized vs Unrealized PnL tracking',
    ],
  ),
  TradeMarginHubFeature(
    phase: 'P2',
    title: 'Market Data & Analytics',
    colorHex: 0xFFF59E0B,
    items: [
      'Open Interest tracking',
      'Long/Short Ratio (Accounts vs Volume)',
      'Top Trader Positions',
      'Market Sentiment (Fear & Greed)',
      'Funding Rate History (24h sparkline)',
      'Liquidation Heatmap (cluster zones)',
      'Recent Liquidations Feed (live)',
      'Period Performance (24h/7d/30d)',
    ],
  ),
];

const TradeMarginHubCompliance _marginHubCompliance = TradeMarginHubCompliance(
  title: 'Fully Regulatory Compliant',
  description:
      'Dap ung MiFID II, ESMA, FCA (UK), MAS (Singapore) regulations. Production-ready cho EU, UK, SG markets.',
  regulations: ['MiFID II', 'ESMA', 'FCA (UK)', 'MAS (SG)'],
);

const List<TradeAdvancedAnalyticsStat> _advancedAnalyticsStats = [
  TradeAdvancedAnalyticsStat(
    label: 'AI Signals',
    value: '3',
    colorHex: 0xFF8B5CF6,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Risk Score',
    value: '58',
    colorHex: 0xFFF59E0B,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Win Rate',
    value: '66.7%',
    colorHex: 0xFF10B981,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Sharpe',
    value: '1.82',
    colorHex: 0xFF3B82F6,
  ),
];

const List<TradeAiSignal> _advancedAnalyticsSignals = [
  TradeAiSignal(
    id: 'sig-1',
    pair: 'BTC/USDT',
    direction: 'long',
    confidence: 85,
    timeframe: '4h',
    entryPrice: 67500,
    targetPrice: 70200,
    stopLoss: 66800,
    riskReward: 3.9,
    accuracy: 73,
    reasoning: [
      'RSI oversold bounce from 32 to 45, bullish divergence confirmed',
      'Volume spike +320% on 4h candle, strong accumulation detected',
      'Breaking above 20-day EMA with increasing volume',
      'Whale wallets accumulated +\$1.2B in last 24h',
      'Funding rate dropped to -0.02%, shorts overleveraged',
    ],
  ),
  TradeAiSignal(
    id: 'sig-2',
    pair: 'ETH/USDT',
    direction: 'short',
    confidence: 72,
    timeframe: '1h',
    entryPrice: 3245,
    targetPrice: 3180,
    stopLoss: 3270,
    riskReward: 2.6,
    accuracy: 68,
    reasoning: [
      'Double top pattern forming at \$3,250 resistance',
      'Bearish divergence: price higher but RSI lower',
      'Volume declining on each rally attempt',
      'ETH/BTC ratio weakening against BTC',
    ],
  ),
  TradeAiSignal(
    id: 'sig-3',
    pair: 'SOL/USDT',
    direction: 'long',
    confidence: 91,
    timeframe: '15m',
    entryPrice: 145,
    targetPrice: 151,
    stopLoss: 143.5,
    riskReward: 4.0,
    accuracy: 78,
    reasoning: [
      'Breakout from ascending triangle after consolidation',
      'Volume explosion +580%, institutional flow detected',
      'All moving averages aligned bullish',
      'Solana ecosystem TVL +12% this week',
      'Major airdrop announcement driving demand',
    ],
  ),
];

const TradeAdvancedRiskSummary _advancedAnalyticsRisk =
    TradeAdvancedRiskSummary(
      var95: 5.2,
      sharpeRatio: 1.82,
      maxDrawdown: 18.5,
      riskScore: 58,
      riskLevel: 'medium',
    );

const TradeJournalSummary _advancedAnalyticsJournal = TradeJournalSummary(
  winRate: 66.7,
  totalTrades: 6,
  totalPnl: 7400,
  avgWin: 2210,
  avgLoss: 415,
);

const TradePositionSizingSummary _advancedAnalyticsSizing =
    TradePositionSizingSummary(
      accountBalance: 50000,
      entryPrice: 67500,
      stopLossPrice: 66800,
      takeProfitPrice: 70200,
      recommendedRiskPct: 2,
      positionSize: 1.43,
    );

const List<String> _advancedAnalyticsFeatures = [
  'AI Trading Signals',
  'Risk Score Dashboard',
  'VaR Calculator',
  'Sharpe/Sortino Ratios',
  'Trade Journal',
  'Win/Loss Analytics',
  'Kelly Criterion',
  'Position Sizing',
  'Performance Attribution',
  'Setup Classification',
  'Drawdown Analysis',
  'Beta Calculation',
];

const List<TradeTransactionReport> _transactionReports = [
  TradeTransactionReport(
    id: 'RPT-001',
    transactionId: 'TXN-2026-03-08-001',
    reportType: 'both',
    tradingVenue: 'Binance',
    instrument: 'BTC/USDT',
    side: 'buy',
    quantity: .5,
    price: 68500,
    value: 34250,
    executionTime: '2026-03-08T10:15:23Z',
    reportedTime: '2026-03-08T10:15:45Z',
    confirmedTime: '2026-03-08T10:16:12Z',
    status: 'confirmed',
    armProvider: 'REGIS-TR',
    messageId: 'MSG-REGIS-TR-20260308-001',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
  TradeTransactionReport(
    id: 'RPT-002',
    transactionId: 'TXN-2026-03-08-002',
    reportType: 'mifid2',
    tradingVenue: 'OKX',
    instrument: 'ETH/USDT',
    side: 'sell',
    quantity: 10,
    price: 3825,
    value: 38250,
    executionTime: '2026-03-08T10:22:11Z',
    reportedTime: '2026-03-08T10:22:34Z',
    status: 'submitted',
    armProvider: 'UnaVista',
    messageId: 'MSG-UnaVista-20260308-002',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
  TradeTransactionReport(
    id: 'RPT-003',
    transactionId: 'TXN-2026-03-08-003',
    reportType: 'both',
    tradingVenue: 'Binance',
    instrument: 'SOL/USDT',
    side: 'buy',
    quantity: 100,
    price: 125.5,
    value: 12550,
    executionTime: '2026-03-08T10:30:45Z',
    reportedTime: '2026-03-08T10:31:02Z',
    status: 'failed',
    armProvider: 'REGIS-TR',
    errorMessage: 'Field validation error: Invalid LEI format',
    retryCount: 2,
    slaStatus: 'warning',
  ),
  TradeTransactionReport(
    id: 'RPT-004',
    transactionId: 'TXN-2026-03-08-004',
    reportType: 'mifid2',
    tradingVenue: 'Bybit',
    instrument: 'BTC/USDT',
    side: 'buy',
    quantity: .25,
    price: 68600,
    value: 17150,
    executionTime: '2026-03-08T10:35:12Z',
    status: 'pending',
    armProvider: 'Bloomberg',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
  TradeTransactionReport(
    id: 'RPT-005',
    transactionId: 'TXN-2026-03-08-005',
    reportType: 'emir',
    tradingVenue: 'Binance',
    instrument: 'BTC-PERP',
    side: 'sell',
    quantity: 1.5,
    price: 68550,
    value: 102825,
    executionTime: '2026-03-08T10:40:33Z',
    status: 'submitting',
    armProvider: 'REGIS-TR',
    retryCount: 0,
    slaStatus: 'on-time',
  ),
];

const TradeTransactionReportingStats _transactionReportingStats =
    TradeTransactionReportingStats(
      total: 5,
      confirmed: 1,
      failed: 1,
      pending: 3,
      onTime: 4,
      avgLatencySeconds: 22,
      totalValue: 205025,
      mifidReports: 4,
      emirReports: 3,
      providerCounts: {'REGIS-TR': 3, 'UnaVista': 1, 'Bloomberg': 1},
    );

const List<TradeRegulatoryDailyStat> _regulatoryDailyStats = [
  TradeRegulatoryDailyStat(
    date: '03-02',
    total: 145,
    confirmed: 142,
    failed: 3,
    avgLatency: 18,
  ),
  TradeRegulatoryDailyStat(
    date: '03-03',
    total: 167,
    confirmed: 164,
    failed: 3,
    avgLatency: 21,
  ),
  TradeRegulatoryDailyStat(
    date: '03-04',
    total: 189,
    confirmed: 186,
    failed: 3,
    avgLatency: 19,
  ),
  TradeRegulatoryDailyStat(
    date: '03-05',
    total: 203,
    confirmed: 198,
    failed: 5,
    avgLatency: 23,
  ),
  TradeRegulatoryDailyStat(
    date: '03-06',
    total: 221,
    confirmed: 217,
    failed: 4,
    avgLatency: 20,
  ),
  TradeRegulatoryDailyStat(
    date: '03-07',
    total: 198,
    confirmed: 195,
    failed: 3,
    avgLatency: 22,
  ),
  TradeRegulatoryDailyStat(
    date: '03-08',
    total: 156,
    confirmed: 153,
    failed: 3,
    avgLatency: 19,
  ),
];

const List<TradeRegulatoryArmProvider> _regulatoryArmProviders = [
  TradeRegulatoryArmProvider(
    name: 'REGIS-TR',
    reports: 512,
    successRate: 98.4,
    avgLatency: 18,
    status: 'healthy',
  ),
  TradeRegulatoryArmProvider(
    name: 'UnaVista',
    reports: 389,
    successRate: 97.8,
    avgLatency: 22,
    status: 'healthy',
  ),
  TradeRegulatoryArmProvider(
    name: 'Bloomberg',
    reports: 234,
    successRate: 99.1,
    avgLatency: 15,
    status: 'healthy',
  ),
  TradeRegulatoryArmProvider(
    name: 'DTCC',
    reports: 89,
    successRate: 96.5,
    avgLatency: 28,
    status: 'degraded',
  ),
];

const List<TradeRegulatoryDistributionItem> _regulatoryReportDistribution = [
  TradeRegulatoryDistributionItem(
    name: 'MiFID II',
    value: 678,
    colorHex: 0xFF3B82F6,
  ),
  TradeRegulatoryDistributionItem(
    name: 'EMIR',
    value: 345,
    colorHex: 0xFF10B981,
  ),
  TradeRegulatoryDistributionItem(
    name: 'SEC',
    value: 123,
    colorHex: 0xFFF59E0B,
  ),
  TradeRegulatoryDistributionItem(
    name: 'Other',
    value: 78,
    colorHex: 0xFF94A3B8,
  ),
];

const TradeRegulatoryDashboardTotals _regulatoryDashboardTotals =
    TradeRegulatoryDashboardTotals(
      total: 1279,
      confirmed: 1255,
      failed: 24,
      avgLatency: 20.2857142857,
      successRate: 98.123533,
      distributionTotal: 1224,
    );

const List<TradeArmConnection> _armConnections = [
  TradeArmConnection(
    id: 'arm-1',
    provider: 'REGIS-TR',
    region: 'EU (Frankfurt)',
    status: 'healthy',
    uptime: 99.97,
    avgLatency: 18,
    currentLatency: 16,
    lastCheck: '5:45:00 PM',
    isPrimary: true,
    endpoint: 'https://api.regis-tr.com/v2',
    certExpiry: '2026-12-31',
  ),
  TradeArmConnection(
    id: 'arm-2',
    provider: 'UnaVista',
    region: 'UK (London)',
    status: 'healthy',
    uptime: 99.95,
    avgLatency: 22,
    currentLatency: 20,
    lastCheck: '5:45:05 PM',
    isPrimary: false,
    endpoint: 'https://api.unavista.com/mifid',
    certExpiry: '2026-11-15',
  ),
  TradeArmConnection(
    id: 'arm-3',
    provider: 'Bloomberg',
    region: 'US (New York)',
    status: 'degraded',
    uptime: 98.50,
    avgLatency: 15,
    currentLatency: 45,
    lastCheck: '5:44:50 PM',
    isPrimary: false,
    endpoint: 'https://bpipe.bloomberg.com/arm',
    certExpiry: '2027-03-20',
  ),
];

const List<TradeArmLatencyPoint> _armLatencyHistory = [
  TradeArmLatencyPoint(time: '10:30', registr: 18, unavista: 22, bloomberg: 15),
  TradeArmLatencyPoint(time: '10:35', registr: 16, unavista: 21, bloomberg: 17),
  TradeArmLatencyPoint(time: '10:40', registr: 19, unavista: 23, bloomberg: 42),
  TradeArmLatencyPoint(time: '10:45', registr: 16, unavista: 20, bloomberg: 45),
];

const TradeArmSlaMetrics _armSlaMetrics = TradeArmSlaMetrics(
  uptime: 99.97,
  latencyAvg: 18,
  failoverReadiness: 100,
);

const List<TradeExecutionVenue> _bestExecutionVenues = [
  TradeExecutionVenue(
    rank: 1,
    venue: 'Binance',
    volume: 12450,
    value: 852000000,
    avgPrice: 68450,
    avgCost: 0.08,
    avgSpeed: 0.3,
    fillRate: 99.8,
    score: 96.5,
  ),
  TradeExecutionVenue(
    rank: 2,
    venue: 'Coinbase Pro',
    volume: 8920,
    value: 610000000,
    avgPrice: 68400,
    avgCost: 0.12,
    avgSpeed: 0.5,
    fillRate: 99.5,
    score: 94.2,
  ),
  TradeExecutionVenue(
    rank: 3,
    venue: 'Kraken',
    volume: 6780,
    value: 465000000,
    avgPrice: 68550,
    avgCost: 0.10,
    avgSpeed: 0.4,
    fillRate: 99.3,
    score: 93.8,
  ),
  TradeExecutionVenue(
    rank: 4,
    venue: 'Bybit',
    volume: 4560,
    value: 312000000,
    avgPrice: 68500,
    avgCost: 0.09,
    avgSpeed: 0.35,
    fillRate: 98.9,
    score: 92.1,
  ),
  TradeExecutionVenue(
    rank: 5,
    venue: 'OKX',
    volume: 3920,
    value: 268000000,
    avgPrice: 68600,
    avgCost: 0.11,
    avgSpeed: 0.45,
    fillRate: 98.5,
    score: 90.5,
  ),
];

const List<TradeQuarterlyReport> _bestExecutionArchive = [
  TradeQuarterlyReport(
    id: 'Q1-2026',
    quarter: 'Q1',
    year: 2026,
    period: 'Jan 1 - Mar 31, 2026',
    totalOrders: 36630,
    totalValue: 2507000000,
    publishDate: '2026-04-15',
    status: 'draft',
  ),
  TradeQuarterlyReport(
    id: 'Q4-2025',
    quarter: 'Q4',
    year: 2025,
    period: 'Oct 1 - Dec 31, 2025',
    totalOrders: 32450,
    totalValue: 2210000000,
    publishDate: '2026-01-15',
    status: 'published',
  ),
  TradeQuarterlyReport(
    id: 'Q3-2025',
    quarter: 'Q3',
    year: 2025,
    period: 'Jul 1 - Sep 30, 2025',
    totalOrders: 28900,
    totalValue: 1980000000,
    publishDate: '2025-10-15',
    status: 'published',
  ),
];

const TradeBestExecutionSummary _bestExecutionSummary =
    TradeBestExecutionSummary(
      totalOrders: 36630,
      totalValue: 2507000000,
      avgScore: 93.4,
    );

const List<TradeExecutionVenueAnalysisMetric> _executionVenueMetrics = [
  TradeExecutionVenueAnalysisMetric(
    venue: 'Binance',
    volume: 12450,
    value: 852000000,
    avgFee: 0.08,
    avgSpread: 2.5,
    marketImpact: 1.2,
    totalCost: 3.88,
    avgLatency: 45,
    avgFillTime: 0.3,
    fillRate: 99.8,
    liquidity: 250,
    reliability: 99.95,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'Coinbase Pro',
    volume: 8920,
    value: 610000000,
    avgFee: 0.12,
    avgSpread: 3.0,
    marketImpact: 1.5,
    totalCost: 4.82,
    avgLatency: 65,
    avgFillTime: 0.5,
    fillRate: 99.5,
    liquidity: 180,
    reliability: 99.90,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'Kraken',
    volume: 6780,
    value: 465000000,
    avgFee: 0.10,
    avgSpread: 2.8,
    marketImpact: 1.3,
    totalCost: 4.30,
    avgLatency: 55,
    avgFillTime: 0.4,
    fillRate: 99.3,
    liquidity: 150,
    reliability: 99.85,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'Bybit',
    volume: 4560,
    value: 312000000,
    avgFee: 0.09,
    avgSpread: 2.6,
    marketImpact: 1.4,
    totalCost: 4.19,
    avgLatency: 50,
    avgFillTime: 0.35,
    fillRate: 98.9,
    liquidity: 120,
    reliability: 99.80,
  ),
  TradeExecutionVenueAnalysisMetric(
    venue: 'OKX',
    volume: 3920,
    value: 268000000,
    avgFee: 0.11,
    avgSpread: 3.2,
    marketImpact: 1.6,
    totalCost: 5.01,
    avgLatency: 60,
    avgFillTime: 0.45,
    fillRate: 98.5,
    liquidity: 100,
    reliability: 99.75,
  ),
];

const List<TradeExecutionVenueCostTrend> _executionVenueCostTrends = [
  TradeExecutionVenueCostTrend(
    month: 'Nov',
    binance: 3.9,
    coinbase: 4.9,
    kraken: 4.4,
  ),
  TradeExecutionVenueCostTrend(
    month: 'Dec',
    binance: 3.85,
    coinbase: 4.85,
    kraken: 4.35,
  ),
  TradeExecutionVenueCostTrend(
    month: 'Jan',
    binance: 3.88,
    coinbase: 4.82,
    kraken: 4.30,
  ),
];

const TradeExecutionVenueAnalysisSummary _executionVenueSummary =
    TradeExecutionVenueAnalysisSummary(
      totalVenues: 5,
      avgTotalCost: 4.44,
      avgFillTime: 0.40,
    );

const List<TradeSlippageEvent> _slippageEvents = [
  TradeSlippageEvent(
    id: 'slip-1',
    time: '5:45:23 PM',
    provider: 'AlphaTrader',
    instrument: 'BTC/USDT',
    side: 'buy',
    expectedPrice: 68500,
    executedPrice: 68550,
    slippageBps: 7.3,
    slippagePct: 0.073,
    volume: 0.5,
    value: 34275,
    severity: 'normal',
  ),
  TradeSlippageEvent(
    id: 'slip-2',
    time: '5:42:11 PM',
    provider: 'BetaTrader',
    instrument: 'ETH/USDT',
    side: 'sell',
    expectedPrice: 3825,
    executedPrice: 3780,
    slippageBps: 117.6,
    slippagePct: 1.176,
    volume: 10,
    value: 37800,
    severity: 'critical',
  ),
  TradeSlippageEvent(
    id: 'slip-3',
    time: '5:40:45 PM',
    provider: 'AlphaTrader',
    instrument: 'SOL/USDT',
    side: 'buy',
    expectedPrice: 125.5,
    executedPrice: 125.8,
    slippageBps: 23.9,
    slippagePct: 0.239,
    volume: 100,
    value: 12580,
    severity: 'normal',
  ),
  TradeSlippageEvent(
    id: 'slip-4',
    time: '5:38:33 PM',
    provider: 'GammaTrader',
    instrument: 'BTC/USDT',
    side: 'sell',
    expectedPrice: 68600,
    executedPrice: 68250,
    slippageBps: 51.0,
    slippagePct: 0.510,
    volume: 0.25,
    value: 17062.5,
    severity: 'warning',
  ),
  TradeSlippageEvent(
    id: 'slip-5',
    time: '5:35:12 PM',
    provider: 'AlphaTrader',
    instrument: 'BTC/USDT',
    side: 'buy',
    expectedPrice: 68550,
    executedPrice: 68570,
    slippageBps: 2.9,
    slippagePct: 0.029,
    volume: 1.0,
    value: 68570,
    severity: 'normal',
  ),
];

const List<TradeSlippageProviderStats> _slippageProviderStats = [
  TradeSlippageProviderStats(
    provider: 'AlphaTrader',
    avgSlippage: 11.4,
    maxSlippage: 23.9,
    eventCount: 145,
    warningCount: 8,
    criticalCount: 1,
    totalImpact: 2450,
  ),
  TradeSlippageProviderStats(
    provider: 'BetaTrader',
    avgSlippage: 45.2,
    maxSlippage: 117.6,
    eventCount: 89,
    warningCount: 15,
    criticalCount: 5,
    totalImpact: 8920,
  ),
  TradeSlippageProviderStats(
    provider: 'GammaTrader',
    avgSlippage: 28.3,
    maxSlippage: 51.0,
    eventCount: 67,
    warningCount: 12,
    criticalCount: 2,
    totalImpact: 4560,
  ),
];

const List<TradeSlippageHistoryPoint> _slippageHistory = [
  TradeSlippageHistoryPoint(date: '03-02', avg: 15.2, max: 48.5),
  TradeSlippageHistoryPoint(date: '03-03', avg: 18.3, max: 52.1),
  TradeSlippageHistoryPoint(date: '03-04', avg: 22.1, max: 68.9),
  TradeSlippageHistoryPoint(date: '03-05', avg: 19.7, max: 55.3),
  TradeSlippageHistoryPoint(date: '03-06', avg: 16.8, max: 45.2),
  TradeSlippageHistoryPoint(date: '03-07', avg: 21.5, max: 62.7),
  TradeSlippageHistoryPoint(date: '03-08', avg: 28.3, max: 117.6),
];

const TradeSlippageSummary _slippageSummary = TradeSlippageSummary(
  total: 5,
  normal: 3,
  warning: 1,
  critical: 1,
  avgSlippage: 40.5,
  maxSlippage: 117.6,
);

const List<TradeClientCategoryInfo> _clientCategorizationCategories = [
  TradeClientCategoryInfo(
    id: 'retail',
    label: 'Retail Client',
    description: 'Individual investors with maximum regulatory protection',
    protections: [
      'Full appropriateness test required',
      'Best execution obligation',
      'Investor compensation scheme up to EUR 100k',
      'Detailed cost and charges disclosure',
      'Negative balance protection',
      'Right to complain to ombudsman',
      'Cooling-off period, 14 days',
      'Product governance protection',
    ],
    requirements: [
      'Natural person',
      'Trading for personal account',
      'Not meeting professional criteria',
    ],
  ),
  TradeClientCategoryInfo(
    id: 'professional',
    label: 'Professional Client',
    description: 'Experienced investors who can waive certain protections',
    protections: [
      'Appropriateness test may be waived',
      'Best execution obligation, reduced',
      'Limited investor compensation',
      'Simplified cost disclosure',
      'Product governance, reduced',
    ],
    requirements: [
      'Portfolio over EUR 500,000',
      'Trading volume over 10 transactions per quarter',
      'Work experience in financial sector, 1+ year',
      'Hold position requiring financial knowledge',
    ],
  ),
  TradeClientCategoryInfo(
    id: 'ecp',
    label: 'Eligible Counterparty',
    description: 'Institutional entities with minimal protection',
    protections: [
      'No conduct of business rules',
      'No investor compensation',
      'Minimal disclosure requirements',
    ],
    requirements: [
      'Investment firms',
      'Credit institutions',
      'Insurance companies',
      'UCITS and pension funds',
      'Government entities',
    ],
  ),
];

const List<TradeClientCategoryHistory> _clientCategorizationHistory = [
  TradeClientCategoryHistory(
    date: '2026-03-08',
    action: 'categorized',
    toCategoryId: 'retail',
    reason: 'Initial account registration',
  ),
  TradeClientCategoryHistory(
    date: '2025-12-15',
    action: 'opt-up-requested',
    fromCategoryId: 'retail',
    toCategoryId: 'professional',
    reason: 'User submitted qualification documents',
  ),
];

const List<TradeCopyProduct> _productGovernanceProducts = [
  TradeCopyProduct(
    id: 'prod-1',
    name: 'Mirror Copy Trading',
    type: 'mirror',
    status: 'approved',
    targetMarket: [
      'Professional clients',
      'Retail with high knowledge',
      'Portfolio > EUR 10k',
    ],
    negativeTarget: [
      'Inexperienced retail',
      'Risk-averse investors',
      'Portfolio < EUR 5k',
    ],
    riskLevel: 'high',
    lastReview: '1/15/2026',
    nextReview: '1/15/2027',
    distributionChannels: ['App', 'Web Platform', 'API'],
  ),
  TradeCopyProduct(
    id: 'prod-2',
    name: 'Fixed Ratio Copy',
    type: 'fixed-ratio',
    status: 'approved',
    targetMarket: [
      'All client categories',
      'Moderate risk tolerance',
      'Portfolio > EUR 1k',
    ],
    negativeTarget: ['Ultra-high-net-worth seeking bespoke', 'Day traders'],
    riskLevel: 'medium',
    lastReview: '2/10/2026',
    nextReview: '2/10/2027',
    distributionChannels: ['App', 'Web Platform'],
  ),
  TradeCopyProduct(
    id: 'prod-3',
    name: 'Smart Allocation Copy',
    type: 'smart-allocation',
    status: 'under-review',
    targetMarket: [
      'Professional clients',
      'Sophisticated retail',
      'Portfolio > EUR 25k',
    ],
    negativeTarget: [
      'Beginners',
      'Conservative investors',
      'Short-term traders',
    ],
    riskLevel: 'high',
    lastReview: '3/1/2026',
    nextReview: '6/1/2026',
    distributionChannels: ['App (Beta)', 'API (Limited)'],
  ),
];

const List<TradeTargetMarketDimension> _targetMarketDimensions = [
  TradeTargetMarketDimension(
    id: 'client-type',
    category: 'Client Type',
    suitableFor: ['Retail (high knowledge)', 'Professional clients'],
    notSuitableFor: ['Inexperienced retail'],
  ),
  TradeTargetMarketDimension(
    id: 'knowledge-experience',
    category: 'Knowledge & Experience',
    suitableFor: ['Advanced derivatives knowledge', 'Copy trading experience'],
    notSuitableFor: ['No investment knowledge', 'First-time investors'],
  ),
  TradeTargetMarketDimension(
    id: 'financial-situation',
    category: 'Financial Situation',
    suitableFor: ['Portfolio > \u20AC10,000', 'Can afford to lose capital'],
    notSuitableFor: ['Portfolio < \u20AC5,000', 'Dependent on capital'],
  ),
  TradeTargetMarketDimension(
    id: 'risk-tolerance',
    category: 'Risk Tolerance',
    suitableFor: ['High risk appetite', 'Comfortable with volatility'],
    notSuitableFor: ['Risk-averse', 'Capital preservation focus'],
  ),
  TradeTargetMarketDimension(
    id: 'objectives',
    category: 'Objectives',
    suitableFor: ['Capital growth', 'Medium-long term (6+ months)'],
    notSuitableFor: ['Capital preservation', 'Short-term (<3 months)'],
  ),
  TradeTargetMarketDimension(
    id: 'distribution-channel',
    category: 'Distribution Channel',
    suitableFor: ['App', 'Web Platform', 'API'],
    notSuitableFor: ['Offline', 'Telephone'],
  ),
];

const List<TradeClientMoneyProtectionItem> _clientMoneyProtections = [
  TradeClientMoneyProtectionItem(
    title: 'Segregated Bank Accounts',
    description:
        'Your funds are held in trust accounts separate from company funds. '
        'This means your money is protected even if the company becomes '
        'insolvent.',
  ),
  TradeClientMoneyProtectionItem(
    title: 'Daily Reconciliation',
    description:
        'We reconcile all client money daily to ensure accuracy and '
        'compliance with FCA regulations.',
  ),
  TradeClientMoneyProtectionItem(
    title: 'FCA Supervision',
    description:
        'Our client money handling is supervised by the Financial Conduct '
        'Authority (FCA) under CASS 7 rules.',
  ),
];

const List<TradeCassReconciliationRecord> _cassReconciliationRecords = [
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-08',
    displayDate: 'March 8, 2026',
    clientLedger: 45230.50,
    bankBalance: 45230.50,
    difference: 0,
    status: TradeCassReconciliationStatus.matched,
  ),
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-07',
    displayDate: 'March 7, 2026',
    clientLedger: 44890.25,
    bankBalance: 44890.25,
    difference: 0,
    status: TradeCassReconciliationStatus.matched,
  ),
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-06',
    displayDate: 'March 6, 2026',
    clientLedger: 43500,
    bankBalance: 43520,
    difference: 20,
    status: TradeCassReconciliationStatus.discrepancyResolved,
    notes: 'Pending deposit cleared',
  ),
  TradeCassReconciliationRecord(
    id: 'cass-2026-03-05',
    displayDate: 'March 5, 2026',
    clientLedger: 42100.75,
    bankBalance: 42100.75,
    difference: 0,
    status: TradeCassReconciliationStatus.matched,
  ),
];

const List<TradeInvestorCompensationInfo> _investorCompensationOverviewItems = [
  TradeInvestorCompensationInfo(
    title: 'Independent Protection',
    description:
        'FSCS is independent of the government and financial services industry',
  ),
  TradeInvestorCompensationInfo(
    title: 'Free to Claimants',
    description:
        'No cost to make a claim. Funded by levies on authorized firms',
  ),
  TradeInvestorCompensationInfo(
    title: 'Fast Payment',
    description: 'FSCS aims to pay compensation within 3-6 months',
  ),
];

const List<TradeInvestorCompensationCoverage>
_investorCompensationCoverageItems = [
  TradeInvestorCompensationCoverage(
    label: 'Investments',
    amount: '£85,000',
    caption: 'Per eligible person, per firm',
    emphasized: true,
  ),
  TradeInvestorCompensationCoverage(
    label: 'Deposits',
    amount: '£85,000',
    caption: 'Per eligible person, per banking institution',
    emphasized: false,
  ),
];

const List<String> _investorCompensationEligibleCustomers = [
  'Individuals (retail clients)',
  'Small businesses (turnover < £6.5M)',
  'Charities (annual income < £6.5M)',
  'Trustees of trusts (net asset value < £1M)',
];

const List<String> _investorCompensationIneligibleCustomers = [
  'Large companies',
  'Professional investors (unless opted down)',
  'Financial institutions',
  'Public sector bodies',
];

const List<TradeInvestorCompensationClaimStep> _investorCompensationClaimSteps =
    [
      TradeInvestorCompensationClaimStep(
        step: 1,
        title: 'Firm Declared in Default',
        description:
            'FSCS can only pay if the FCA declares our firm in default '
            '(unable to meet obligations)',
      ),
      TradeInvestorCompensationClaimStep(
        step: 2,
        title: 'FSCS Contacts You',
        description:
            'FSCS will write to all known eligible customers with claim forms',
      ),
      TradeInvestorCompensationClaimStep(
        step: 3,
        title: 'Complete Claim Form',
        description:
            'Fill out the claim form with details of your investment/deposit',
      ),
      TradeInvestorCompensationClaimStep(
        step: 4,
        title: 'Submit Evidence',
        description:
            'Provide proof of ownership (account statements, contracts)',
      ),
      TradeInvestorCompensationClaimStep(
        step: 5,
        title: 'Assessment',
        description: 'FSCS reviews your claim and calculates compensation',
      ),
      TradeInvestorCompensationClaimStep(
        step: 6,
        title: 'Payment',
        description:
            'If approved, FSCS pays compensation directly to you '
            '(typically within 3-6 months)',
      ),
    ];

const List<TradeExAnteCostItem> _exAnteCostItems = [
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.oneOff,
    type: 'Entry Cost',
    description: 'Platform fee charged when you start copying',
    amountEur: 50,
    percentOfInvestment: .50,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.oneOff,
    type: 'Exit Cost',
    description: 'Platform fee when you stop copying (no early exit fee)',
    amountEur: 0,
    percentOfInvestment: 0,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.recurring,
    type: 'Management Fee',
    description: 'Annual fee for copy trading service',
    amountEur: 200,
    percentOfInvestment: 2.00,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.recurring,
    type: 'Transaction Costs',
    description: 'Estimated trading fees (based on historical activity)',
    amountEur: 80,
    percentOfInvestment: .80,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.recurring,
    type: 'Other Ongoing',
    description: 'Custody, admin, and operational costs',
    amountEur: 20,
    percentOfInvestment: .20,
  ),
  TradeExAnteCostItem(
    category: TradeExAnteCostCategory.incidental,
    type: 'Performance Fee',
    description: '20% of profits above high water mark',
    amountEur: 100,
    percentOfInvestment: 1.00,
  ),
];

const List<TradeExPostCostReport> _exPostCostReports = [
  TradeExPostCostReport(
    year: 2025,
    oneOff: 50,
    recurring: 285,
    incidental: 120,
    estimatedOneOff: 50,
    estimatedRecurring: 300,
    estimatedIncidental: 100,
  ),
  TradeExPostCostReport(
    year: 2024,
    oneOff: 45,
    recurring: 272,
    incidental: 84,
    estimatedOneOff: 50,
    estimatedRecurring: 280,
    estimatedIncidental: 90,
  ),
  TradeExPostCostReport(
    year: 2023,
    oneOff: 40,
    recurring: 248,
    incidental: 72,
    estimatedOneOff: 45,
    estimatedRecurring: 260,
    estimatedIncidental: 80,
  ),
];

const List<TradeKidSection> _kidSections = [
  TradeKidSection(
    title: 'Product Overview',
    icon: TradeKidSectionIcon.info,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Investment Objectives',
    icon: TradeKidSectionIcon.target,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Risk & Reward Profile',
    icon: TradeKidSectionIcon.warning,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Performance Scenarios',
    icon: TradeKidSectionIcon.chart,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Costs',
    icon: TradeKidSectionIcon.costs,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Holding Period',
    icon: TradeKidSectionIcon.clock,
    status: 'complete',
  ),
  TradeKidSection(
    title: 'Additional Information',
    icon: TradeKidSectionIcon.help,
    status: 'complete',
  ),
];

const List<TradePerformanceScenario> _performanceScenarios = [
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.stress,
    label: 'Stress',
    annualReturnPct: -25,
  ),
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.unfavorable,
    label: 'Unfavorable',
    annualReturnPct: -5,
  ),
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.moderate,
    label: 'Moderate',
    annualReturnPct: 8,
  ),
  TradePerformanceScenario(
    type: TradePerformanceScenarioType.favorable,
    label: 'Favorable',
    annualReturnPct: 22,
  ),
];

const List<TradeRiskIndicatorLevel> _riskIndicatorLevels = [
  TradeRiskIndicatorLevel(
    level: 1,
    label: 'Lowest Risk',
    tier: TradeRiskIndicatorTier.low,
    description: 'Capital protected products. Very low volatility.',
    examples: ['Money market funds', 'Cash deposits'],
  ),
  TradeRiskIndicatorLevel(
    level: 2,
    label: 'Low Risk',
    tier: TradeRiskIndicatorTier.low,
    description: 'Low volatility. Small chance of loss.',
    examples: ['Government bonds', 'High-grade corporate bonds'],
  ),
  TradeRiskIndicatorLevel(
    level: 3,
    label: 'Low-Medium Risk',
    tier: TradeRiskIndicatorTier.medium,
    description: 'Some volatility. Moderate chance of loss.',
    examples: ['Mixed bond funds', 'Conservative balanced funds'],
  ),
  TradeRiskIndicatorLevel(
    level: 4,
    label: 'Medium Risk',
    tier: TradeRiskIndicatorTier.medium,
    description: 'Moderate volatility. Balanced risk/reward.',
    examples: ['Balanced funds', 'Index funds'],
  ),
  TradeRiskIndicatorLevel(
    level: 5,
    label: 'Medium-High Risk',
    tier: TradeRiskIndicatorTier.elevated,
    description: 'Higher volatility. Significant loss possible.',
    examples: ['Equity funds', 'Emerging market bonds'],
  ),
  TradeRiskIndicatorLevel(
    level: 6,
    label: 'High Risk',
    tier: TradeRiskIndicatorTier.high,
    description: 'High volatility. Substantial loss possible.',
    examples: ['Small-cap equities', 'High-yield bonds', 'Copy trading'],
  ),
  TradeRiskIndicatorLevel(
    level: 7,
    label: 'Highest Risk',
    tier: TradeRiskIndicatorTier.high,
    description: 'Extreme volatility. Total loss possible.',
    examples: ['Leveraged products', 'Complex derivatives', 'Crypto'],
  ),
];

const List<TradeRiskIndicatorAdditionalRisk> _riskIndicatorAdditionalRisks = [
  TradeRiskIndicatorAdditionalRisk(
    title: 'Provider Risk',
    description:
        'The trader you copy may underperform or take excessive risks.',
  ),
  TradeRiskIndicatorAdditionalRisk(
    title: 'Liquidity Risk',
    description:
        'In extreme market conditions, you may not be able to exit positions '
        'quickly.',
  ),
  TradeRiskIndicatorAdditionalRisk(
    title: 'Operational Risk',
    description: 'Technical failures or errors in trade copying may occur.',
  ),
];

const List<TradeComplaintCategory> _complaintCategories = [
  TradeComplaintCategory(
    id: 'trade',
    label: 'Trade Execution',
    icon: TradeComplaintCategoryIcon.trade,
  ),
  TradeComplaintCategory(
    id: 'account',
    label: 'Account Management',
    icon: TradeComplaintCategoryIcon.account,
  ),
  TradeComplaintCategory(
    id: 'payment',
    label: 'Payments & Withdrawals',
    icon: TradeComplaintCategoryIcon.payment,
  ),
  TradeComplaintCategory(
    id: 'service',
    label: 'Customer Service',
    icon: TradeComplaintCategoryIcon.service,
  ),
  TradeComplaintCategory(
    id: 'fees',
    label: 'Fees & Charges',
    icon: TradeComplaintCategoryIcon.fees,
  ),
  TradeComplaintCategory(
    id: 'other',
    label: 'Other',
    icon: TradeComplaintCategoryIcon.other,
  ),
];

const List<TradeComplaintTimelineStep> _complaintTimeline = [
  TradeComplaintTimelineStep(step: 1, label: 'Submit Complaint', time: 'Day 0'),
  TradeComplaintTimelineStep(
    step: 2,
    label: 'Acknowledgement',
    time: 'Within 5 days',
  ),
  TradeComplaintTimelineStep(
    step: 3,
    label: 'Investigation',
    time: 'Up to 8 weeks',
  ),
  TradeComplaintTimelineStep(
    step: 4,
    label: 'Final Response',
    time: 'By deadline',
  ),
];

const List<TradeComplaint> _complaints = [
  TradeComplaint(
    id: 'COMP-2026-001',
    category: 'Trade Execution',
    status: TradeComplaintStatus.underReview,
    submittedDate: '2026-02-15',
    deadline: '2026-04-12',
    subject: 'Order not executed at expected price',
  ),
  TradeComplaint(
    id: 'COMP-2025-089',
    category: 'Customer Service',
    status: TradeComplaintStatus.resolved,
    submittedDate: '2025-11-20',
    deadline: '2026-01-15',
    subject: 'Delayed response to support ticket',
  ),
];

const List<TradeComplaintProcessStep> _complaintProcessSteps = [
  TradeComplaintProcessStep(
    title: 'Fair Investigation',
    description: 'We investigate all complaints fairly and independently',
  ),
  TradeComplaintProcessStep(
    title: '8-Week Deadline',
    description: "We'll send a final response within 8 weeks (FCA requirement)",
  ),
  TradeComplaintProcessStep(
    title: 'Ombudsman Rights',
    description:
        "If you're not satisfied, you can refer to the Financial Ombudsman "
        'Service (free)',
  ),
];

const List<TradeComplaintTrackingStep> _complaintTrackingTimeline = [
  TradeComplaintTrackingStep(
    title: 'Complaint Submitted',
    description: 'Your complaint has been received',
    dateLabel: 'February 15, 2026',
    state: TradeComplaintTrackingStepState.completed,
  ),
  TradeComplaintTrackingStep(
    title: 'Acknowledgement Sent',
    description: 'We acknowledged your complaint within 5 business days',
    dateLabel: 'February 16, 2026',
    state: TradeComplaintTrackingStepState.completed,
  ),
  TradeComplaintTrackingStep(
    title: 'Investigation Started',
    description: 'Our compliance team is investigating',
    dateLabel: 'February 20, 2026',
    state: TradeComplaintTrackingStepState.completed,
  ),
  TradeComplaintTrackingStep(
    title: 'Under Review',
    description: 'Currently reviewing evidence and preparing response',
    dateLabel: 'March 10, 2026',
    state: TradeComplaintTrackingStepState.current,
  ),
  TradeComplaintTrackingStep(
    title: 'Final Response',
    description: 'Deadline for our final response',
    dateLabel: 'April 12, 2026',
    state: TradeComplaintTrackingStepState.pending,
  ),
];

const List<TradeComplaintTrackingAction> _complaintTrackingActions = [
  TradeComplaintTrackingAction(
    id: 'add-info',
    label: 'Add Information',
    icon: TradeComplaintTrackingActionIcon.message,
  ),
  TradeComplaintTrackingAction(
    id: 'correspondence',
    label: 'View Correspondence',
    icon: TradeComplaintTrackingActionIcon.document,
  ),
  TradeComplaintTrackingAction(
    id: 'ombudsman',
    label: 'Ombudsman Referral Info',
    icon: TradeComplaintTrackingActionIcon.warning,
    routePath: '/trade/copy-trading/ombudsman-referral',
  ),
];

const List<TradeOmbudsmanEligibility> _ombudsmanEligibility = [
  TradeOmbudsmanEligibility(
    title: 'After 8 Weeks',
    description: "If we haven't sent you a final response within 8 weeks",
  ),
  TradeOmbudsmanEligibility(
    title: 'Not Satisfied',
    description: "If you're not satisfied with our final response",
  ),
  TradeOmbudsmanEligibility(
    title: 'Within 6 Months',
    description: 'You must refer within 6 months of our final response',
  ),
];

const List<TradeOmbudsmanContact> _ombudsmanContacts = [
  TradeOmbudsmanContact(
    label: 'Phone',
    value: '0800 023 4567',
    detail: 'Monday to Friday, 8am to 8pm - Saturday, 9am to 1pm',
    icon: TradeOmbudsmanContactIcon.phone,
  ),
  TradeOmbudsmanContact(
    label: 'Website',
    value: 'www.financial-ombudsman.org.uk',
    icon: TradeOmbudsmanContactIcon.website,
  ),
  TradeOmbudsmanContact(
    label: 'Address',
    value: 'Financial Ombudsman Service\nExchange Tower\nLondon E14 9SR',
    icon: TradeOmbudsmanContactIcon.address,
  ),
];

const List<TradeOmbudsmanProcessStep> _ombudsmanProcessSteps = [
  TradeOmbudsmanProcessStep(
    step: 1,
    title: 'Submit Your Complaint',
    description: 'Contact FOS with your complaint details',
  ),
  TradeOmbudsmanProcessStep(
    step: 2,
    title: 'FOS Reviews',
    description: 'They review both sides of the story',
  ),
  TradeOmbudsmanProcessStep(
    step: 3,
    title: 'Investigation',
    description: 'Independent investigation of the facts',
  ),
  TradeOmbudsmanProcessStep(
    step: 4,
    title: 'Decision',
    description: 'FOS makes a binding decision (for us, not you)',
  ),
];

const List<TradeAuditStat> _auditTrailStats = [
  TradeAuditStat(label: 'Total Events', value: '3'),
  TradeAuditStat(label: 'Today', value: '12'),
  TradeAuditStat(label: 'Retention', value: '7yr', emphasized: true),
];

const List<TradeAuditTab> _auditTrailTabs = [
  TradeAuditTab(id: 'all', label: 'All Events'),
  TradeAuditTab(id: 'trades', label: 'Trades'),
  TradeAuditTab(id: 'compliance', label: 'Compliance'),
  TradeAuditTab(id: 'client', label: 'Client Actions'),
];

const List<TradeAuditEntry> _auditTrailEntries = [
  TradeAuditEntry(
    id: 'AUD-2026-001234',
    timestampLabel: '3/8/2026, 9:23:15 PM',
    category: TradeAuditCategory.trade,
    categoryLabel: 'Trade',
    action: 'Order Executed',
    details: 'BUY 0.5 BTC @ \$65,234.50 (Mirror copy from Provider #123)',
    user: 'user@example.com',
    ipAddress: '192.168.1.1',
  ),
  TradeAuditEntry(
    id: 'AUD-2026-001233',
    timestampLabel: '3/8/2026, 9:20:00 PM',
    category: TradeAuditCategory.compliance,
    categoryLabel: 'Compliance',
    action: 'Suitability Assessment Passed',
    details: 'Risk tolerance: High, Knowledge: Advanced, Portfolio: \u20ac50k+',
    user: 'user@example.com',
    ipAddress: '192.168.1.1',
  ),
  TradeAuditEntry(
    id: 'AUD-2026-001232',
    timestampLabel: '3/8/2026, 9:15:30 PM',
    category: TradeAuditCategory.clientAction,
    categoryLabel: 'Client Action',
    action: 'Copy Trading Activated',
    details: 'Provider #123 (Conservative Crypto) - Allocation: 30%',
    user: 'user@example.com',
    ipAddress: '192.168.1.1',
  ),
];

const List<TradeRegulatoryInspectionStat> _regulatoryInspectionStats = [
  TradeRegulatoryInspectionStat(
    label: 'Documents',
    value: '10',
    icon: TradeRegulatoryInspectionStatIcon.documents,
  ),
  TradeRegulatoryInspectionStat(
    label: 'Clients',
    value: '3.4k',
    icon: TradeRegulatoryInspectionStatIcon.clients,
  ),
  TradeRegulatoryInspectionStat(
    label: 'Audit Logs',
    value: '45k',
    icon: TradeRegulatoryInspectionStatIcon.auditLogs,
  ),
  TradeRegulatoryInspectionStat(
    label: 'Retention',
    value: '7yr',
    icon: TradeRegulatoryInspectionStatIcon.retention,
  ),
];

const List<TradeRegulatoryFramework> _regulatoryFrameworks = [
  TradeRegulatoryFramework(
    name: 'MiFID II',
    compliance: 98,
    requirements: [
      'Client categorization',
      'Suitability assessment',
      'Best execution',
      'Transaction reporting',
      'Record-keeping (7 years)',
      'Complaints handling',
    ],
  ),
  TradeRegulatoryFramework(
    name: 'PRIIPs Regulation',
    compliance: 100,
    requirements: [
      'KID document',
      'Ex-ante cost disclosure',
      'Ex-post reporting',
      'Performance scenarios',
      'Risk indicator (SRI)',
    ],
  ),
  TradeRegulatoryFramework(
    name: 'FCA CASS 7',
    compliance: 100,
    requirements: [
      'Segregated client money',
      'Daily reconciliation',
      'Client money letters',
      'Insolvency protection',
    ],
  ),
  TradeRegulatoryFramework(
    name: 'FCA DISP',
    compliance: 95,
    requirements: [
      'Complaints procedure',
      '8-week resolution',
      'FOS referral rights',
      'Annual reporting',
    ],
  ),
];

const List<TradeRegulatoryDocument> _regulatoryDocuments = [
  TradeRegulatoryDocument(
    name: 'Transaction Reports (ARM)',
    countLabel: '1,247 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Best Execution Reports',
    countLabel: '52 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Client Categorization Records',
    countLabel: '3,421 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Suitability Assessments',
    countLabel: '2,890 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'KID Documents',
    countLabel: '15 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Cost Disclosures (Ex-Ante)',
    countLabel: '2,890 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Cost Reports (Ex-Post)',
    countLabel: '1,834 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'CASS Reconciliations',
    countLabel: '365 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Complaints Records',
    countLabel: '127 records',
    status: 'Ready',
  ),
  TradeRegulatoryDocument(
    name: 'Audit Trail Logs',
    countLabel: '45,892 records',
    status: 'Ready',
  ),
];

const List<TradeBotTermsSection> _botTermsSections = [
  TradeBotTermsSection(
    title: '1. Acceptance of Terms',
    paragraphs: [
      'By using our Trading Bots service ("Service"), you agree to be bound '
          'by these Terms of Service ("Terms"). If you do not agree to these '
          'Terms, you must not use the Service.',
      'These Terms constitute a legally binding agreement between you and the '
          'Company. Your use of automated trading algorithms is subject to '
          'additional regulatory requirements which you acknowledge and accept.',
    ],
  ),
  TradeBotTermsSection(
    title: '2. No Profit Guarantee',
    warningTitle: 'CRITICAL WARNING:',
    warningBody:
        'Trading Bots do NOT guarantee profits. Past performance does not '
        'predict future results. You may lose some or all of your invested '
        'capital.',
    paragraphs: [
      'Automated trading carries significant risk. Market conditions, '
          'volatility, liquidity, technical failures, and other factors can '
          'result in substantial losses. You should only invest capital you '
          'can afford to lose entirely.',
    ],
  ),
  TradeBotTermsSection(
    title: '3. Risk Acknowledgment',
    paragraphs: ['You acknowledge and accept the following risks:'],
    bullets: [
      'Market Risk: Cryptocurrency markets are highly volatile.',
      'Liquidity Risk: Orders may not execute at desired prices.',
      'Slippage Risk: Execution prices may differ from expected prices.',
      'Technical Risk: System failures may cause unexpected behavior.',
    ],
  ),
  TradeBotTermsSection(
    title: '4. User Responsibilities',
    paragraphs: [
      'You are solely responsible for configuring bot parameters, monitoring '
          'performance, maintaining sufficient balance, understanding each '
          'strategy, and complying with applicable laws.',
    ],
  ),
  TradeBotTermsSection(
    title: '5. Liability Limitation',
    paragraphs: [
      'To the maximum extent permitted by law, the Company shall not be liable '
          'for trading losses, inaccurate projections, downtime, exchange '
          'failures, or regulatory changes affecting your trading ability.',
    ],
  ),
  TradeBotTermsSection(
    title: '6. Service Modifications & Termination',
    paragraphs: [
      'We reserve the right to modify, suspend, or terminate the Service at '
          'any time to comply with regulations or protect user interests.',
    ],
  ),
  TradeBotTermsSection(
    title: '7. Dispute Resolution',
    paragraphs: [
      'Any disputes arising from these Terms or your use of the Service shall '
          'be resolved through binding arbitration in accordance with the '
          'applicable rules.',
    ],
  ),
  TradeBotTermsSection(
    title: '8. Regulatory Compliance',
    paragraphs: [
      'Trading Bots may be classified as complex financial products under '
          'MiFID II, requiring appropriateness assessment and local compliance.',
    ],
  ),
  TradeBotTermsSection(
    title: '9. Data Usage & Privacy',
    paragraphs: [
      'We collect and process trading data, bot performance metrics, and '
          'account information to provide and improve the Service.',
    ],
  ),
  TradeBotTermsSection(
    title: '10. Contact Information',
    paragraphs: [
      'For questions about these Terms, contact legal@tradingplatform.com or '
          'support@tradingplatform.com.',
    ],
  ),
];

const List<TradeBotRiskCategory> _botRiskCategories = [
  TradeBotRiskCategory(
    id: 'market',
    kind: TradeBotRiskKind.market,
    title: 'Market Volatility Risk',
    description:
        'Cryptocurrency markets are extremely volatile and can move rapidly '
        'against your positions.',
    examples: [
      'Bitcoin dropped 30% in a single day during flash crashes',
      'Altcoins can lose 50-90% of value in bear markets',
      'News events can cause sudden price swings of 10-20% in minutes',
    ],
    mitigation:
        'Use stop-loss orders, diversify across assets, and never invest '
        'more than you can afford to lose.',
  ),
  TradeBotRiskCategory(
    id: 'leverage',
    kind: TradeBotRiskKind.leverage,
    title: 'Leverage & Martingale Risk',
    description:
        'Strategies that increase position size (like Martingale) can '
        'amplify losses exponentially.',
    examples: [
      'Martingale can require 10x initial capital after 3-4 consecutive losses',
      'Liquidation can occur if market moves against you before recovery',
      'Compound losses can exceed total account balance',
    ],
    mitigation:
        'Set strict maximum position size limits, use conservative '
        'multipliers, and monitor drawdown closely.',
  ),
  TradeBotRiskCategory(
    id: 'liquidity',
    kind: TradeBotRiskKind.liquidity,
    title: 'Liquidity & Slippage Risk',
    description:
        'Low liquidity markets may not execute your orders at expected prices.',
    examples: [
      'Limit orders may not fill during volatile periods',
      'Market orders can execute 2-5% worse than displayed price',
      'Large orders can move the market against you',
    ],
    mitigation:
        'Trade liquid pairs (BTC/USDT, ETH/USDT), use limit orders, and '
        'split large orders into smaller chunks.',
  ),
  TradeBotRiskCategory(
    id: 'technical',
    kind: TradeBotRiskKind.technical,
    title: 'Technical Failure Risk',
    description:
        'System bugs, network issues, or exchange downtime can cause '
        'unexpected bot behavior.',
    examples: [
      'Exchange API failures can prevent bot execution',
      'Network latency can cause missed opportunities or double orders',
      'Software bugs may execute unintended trades',
    ],
    mitigation:
        'Enable emergency stop alerts, monitor bot activity regularly, and '
        'test strategies in demo mode first.',
  ),
  TradeBotRiskCategory(
    id: 'timing',
    kind: TradeBotRiskKind.timing,
    title: 'Execution & Timing Risk',
    description:
        'Delays between signal generation and order execution can reduce '
        'profitability.',
    examples: [
      'Backtest results assume instant execution (unrealistic)',
      'Real trading incurs 0.1-1 second delays affecting entry/exit prices',
      'High-frequency strategies are most sensitive to timing issues',
    ],
    mitigation:
        'Account for realistic execution delays in backtests, avoid '
        'over-optimized strategies, and use VPS for stable connectivity.',
  ),
  TradeBotRiskCategory(
    id: 'regulatory',
    kind: TradeBotRiskKind.regulatory,
    title: 'Regulatory & Legal Risk',
    description:
        'Changes in regulations may affect your ability to trade or access '
        'funds.',
    examples: [
      'Automated trading may be restricted in certain jurisdictions',
      'KYC/AML requirements can freeze withdrawals pending verification',
      'Tax reporting obligations apply to all bot trades',
    ],
    mitigation:
        'Ensure compliance with local laws, keep detailed trade records, and '
        'consult a tax professional.',
  ),
];

const List<TradeBotRiskWarning> _botRiskWarnings = [
  TradeBotRiskWarning(
    title: 'No Guarantee of Profit',
    text:
        'Bots can lose money consistently. A strategy that works in '
        'backtests may fail in live trading due to changing market conditions.',
  ),
  TradeBotRiskWarning(
    title: 'Fees Compound Losses',
    text:
        'Every trade incurs exchange fees (0.1-0.5%). High-frequency bots can '
        'lose money purely from fees even if price moves are neutral.',
  ),
  TradeBotRiskWarning(
    title: 'Market Manipulation',
    text:
        'Cryptocurrency markets are less regulated and more susceptible to '
        'manipulation, wash trading, and pump-and-dump schemes.',
  ),
  TradeBotRiskWarning(
    title: 'Account Liquidation',
    text:
        'If using margin or leverage, your entire account can be liquidated '
        'if the market moves against you before stop-loss triggers.',
  ),
  TradeBotRiskWarning(
    title: 'No Recourse for Losses',
    text:
        'Unlike traditional finance, crypto trading is largely uninsured. '
        'Lost funds cannot be recovered through deposit insurance schemes.',
  ),
];

const List<TradeBotSuitabilityQuestion> _botSuitabilityQuestions = [
  TradeBotSuitabilityQuestion(
    id: 'q1',
    category: TradeBotSuitabilityCategory.experience,
    question: 'How long have you been trading cryptocurrencies?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Never traded before / Less than 3 months',
        score: 0,
      ),
      TradeBotSuitabilityOption(id: 'b', text: '3-12 months', score: 1),
      TradeBotSuitabilityOption(id: 'c', text: '1-3 years', score: 2),
      TradeBotSuitabilityOption(id: 'd', text: 'More than 3 years', score: 3),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q2',
    category: TradeBotSuitabilityCategory.experience,
    question: 'Have you ever used trading bots or algorithmic trading before?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'No, this is my first time',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Yes, but only in demo/paper trading',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Yes, with real money for less than 6 months',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Yes, extensively with real money for over 6 months',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q3',
    category: TradeBotSuitabilityCategory.knowledge,
    question: 'Do you understand how Grid Bots work?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: "No, I don't know what a Grid Bot is",
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Slightly - I have a basic idea',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Yes - I understand the concept and risks',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Expert - I can explain it and have used it before',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q4',
    category: TradeBotSuitabilityCategory.knowledge,
    question: 'Do you understand what "slippage" means in trading?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'No, never heard of it',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: "Vaguely - I've seen the term but not sure what it means",
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text:
            "Yes - I know it's the difference between expected and actual price",
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Expert - I know how to mitigate slippage',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q5',
    category: TradeBotSuitabilityCategory.risk,
    question:
        'What percentage of your total savings/investments are you planning '
        'to allocate to trading bots?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'More than 50% of my total savings',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: '20-50% of my total savings',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: '5-20% of my total savings',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Less than 5% - only money I can afford to lose',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q6',
    category: TradeBotSuitabilityCategory.risk,
    question:
        'If your bot lost 30% of its value in one week, what would you do?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Panic and sell immediately',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Feel very uncomfortable but hold',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Accept it as normal volatility and continue',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'See it as a buying opportunity and add more',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q7',
    category: TradeBotSuitabilityCategory.financial,
    question: 'What is your primary investment goal with trading bots?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: 'Get rich quick / Double my money fast',
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'Earn steady income to replace my salary',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'Long-term wealth accumulation over years',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Experiment and learn, with small capital',
        score: 3,
      ),
    ],
  ),
  TradeBotSuitabilityQuestion(
    id: 'q8',
    category: TradeBotSuitabilityCategory.knowledge,
    question:
        'Do you understand the difference between DCA, Grid, and Martingale '
        'strategies?',
    options: [
      TradeBotSuitabilityOption(
        id: 'a',
        text: "No, I don't know any of them",
        score: 0,
      ),
      TradeBotSuitabilityOption(
        id: 'b',
        text: 'I know DCA but not the others',
        score: 1,
      ),
      TradeBotSuitabilityOption(
        id: 'c',
        text: 'I understand all three conceptually',
        score: 2,
      ),
      TradeBotSuitabilityOption(
        id: 'd',
        text: 'Expert - I know when to use each strategy',
        score: 3,
      ),
    ],
  ),
];

const List<TradeBotDrawdownPoint> _botRiskDrawdownPoints = [
  TradeBotDrawdownPoint(label: '00:00', value: 0),
  TradeBotDrawdownPoint(label: '04:00', value: -2.3),
  TradeBotDrawdownPoint(label: '08:00', value: -5.1),
  TradeBotDrawdownPoint(label: '12:00', value: -8.4),
  TradeBotDrawdownPoint(label: '16:00', value: -12.2),
  TradeBotDrawdownPoint(label: '20:00', value: -15.2),
  TradeBotDrawdownPoint(label: 'Now', value: -15.2),
];

const List<TradeBotExposure> _botRiskExposures = [
  TradeBotExposure(
    asset: 'BTC',
    exposure: 1250,
    percentage: 50,
    colorHex: 0xFFF7931A,
  ),
  TradeBotExposure(
    asset: 'ETH',
    exposure: 750,
    percentage: 30,
    colorHex: 0xFF627EEA,
  ),
  TradeBotExposure(
    asset: 'SOL',
    exposure: 500,
    percentage: 20,
    colorHex: 0xFF14F195,
  ),
];

const List<TradeBotVarPoint> _botRiskVarHistory = [
  TradeBotVarPoint(label: 'Mon', value: 142),
  TradeBotVarPoint(label: 'Tue', value: 156),
  TradeBotVarPoint(label: 'Wed', value: 134),
  TradeBotVarPoint(label: 'Thu', value: 167),
  TradeBotVarPoint(label: 'Fri', value: 189),
  TradeBotVarPoint(label: 'Sat', value: 201),
  TradeBotVarPoint(label: 'Sun', value: 178),
];

const List<TradeBotSafetyControl> _botRiskSafetyControls = [
  TradeBotSafetyControl(label: 'Drawdown limit', value: '-20%'),
  TradeBotSafetyControl(label: 'Daily loss limit', value: '-\$500'),
  TradeBotSafetyControl(label: 'Max position size', value: '\$1,000'),
  TradeBotSafetyControl(label: 'Emergency stop', value: 'Enabled'),
];

const List<TradeBotEmergencyBot> _botEmergencyStopBots = [
  TradeBotEmergencyBot(
    id: 'bot1',
    name: 'DCA Bot #1',
    pair: 'BTC/USDT',
    profit: 84.20,
    statusLabel: 'Running',
  ),
  TradeBotEmergencyBot(
    id: 'bot2',
    name: 'Grid Bot #1',
    pair: 'ETH/USDT',
    profit: 127.40,
    statusLabel: 'Running',
  ),
  TradeBotEmergencyBot(
    id: 'bot3',
    name: 'Momentum Bot #1',
    pair: 'SOL/USDT',
    profit: -12.30,
    statusLabel: 'Running',
  ),
];

const List<TradeBotEmergencyReason> _botEmergencyStopReasons = [
  TradeBotEmergencyReason(
    id: 'crash',
    label: 'Market crash / extreme volatility',
    iconName: 'crash',
  ),
  TradeBotEmergencyReason(
    id: 'bug',
    label: 'Technical bug / unexpected behavior',
    iconName: 'bug',
  ),
  TradeBotEmergencyReason(
    id: 'unauthorized',
    label: 'Unauthorized access detected',
    iconName: 'unauthorized',
  ),
  TradeBotEmergencyReason(
    id: 'drawdown',
    label: 'Drawdown limit approaching',
    iconName: 'drawdown',
  ),
  TradeBotEmergencyReason(
    id: 'other',
    label: 'Other reason',
    iconName: 'other',
  ),
];

const List<TradeBotApiKey> _botSecurityApiKeys = [
  TradeBotApiKey(
    id: '1',
    name: 'Trading Bot Key #1',
    permissions: 'Trade + Read',
    lastUsed: '2 hours ago',
    created: '2026-01-15',
  ),
  TradeBotApiKey(
    id: '2',
    name: 'Analytics Key',
    permissions: 'Read Only',
    lastUsed: '1 day ago',
    created: '2026-02-20',
  ),
];

const List<TradeBotIpWhitelistEntry> _botSecurityIpWhitelist = [
  TradeBotIpWhitelistEntry(
    id: '1',
    ip: '192.168.1.100',
    label: 'Home Network',
    added: '2026-03-01',
  ),
  TradeBotIpWhitelistEntry(
    id: '2',
    ip: '203.0.113.42',
    label: 'VPS Server',
    added: '2026-03-05',
  ),
];

const List<TradeBotSecurityActivity> _botSecurityRecentActivity = [
  TradeBotSecurityActivity(
    id: '1',
    action: 'Bot created: DCA Bot #1',
    time: '2 hours ago',
    status: TradeBotSecurityActivityStatus.success,
  ),
  TradeBotSecurityActivity(
    id: '2',
    action: 'API key generated',
    time: '1 day ago',
    status: TradeBotSecurityActivityStatus.success,
  ),
  TradeBotSecurityActivity(
    id: '3',
    action: 'Failed login attempt',
    time: '3 days ago',
    status: TradeBotSecurityActivityStatus.warning,
  ),
  TradeBotSecurityActivity(
    id: '4',
    action: 'Bot stopped: Grid Bot #2',
    time: '5 days ago',
    status: TradeBotSecurityActivityStatus.success,
  ),
];

const List<String> _botSecurityTips = [
  'Never share your API keys with anyone',
  'Use Read-Only keys for analytics, Trade keys only for bots',
  'Restrict API access to specific IP addresses',
  'Enable 2FA for all bot-related actions',
  'Regularly review activity log for suspicious behavior',
];

const List<TradeBotHistoryTrade> _botHistoryTrades = [
  TradeBotHistoryTrade(
    id: 't1',
    timestamp: '2026-03-08 14:32:15',
    botName: 'DCA Bot #1',
    strategy: 'DCA',
    pair: 'BTC/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.001,
    price: 68450,
    fee: 0.034,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't2',
    timestamp: '2026-03-08 13:15:08',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.sell,
    qty: 0.05,
    price: 3850,
    fee: 0.096,
    pnl: 12.50,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't3',
    timestamp: '2026-03-08 12:00:42',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.05,
    price: 3800,
    fee: 0.095,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't4',
    timestamp: '2026-03-08 10:45:30',
    botName: 'Momentum Bot #1',
    strategy: 'Momentum',
    pair: 'SOL/USDT',
    side: TradeBotHistorySide.buy,
    qty: 5,
    price: 142.30,
    fee: 0.356,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't5',
    timestamp: '2026-03-08 09:20:15',
    botName: 'DCA Bot #1',
    strategy: 'DCA',
    pair: 'BTC/USDT',
    side: TradeBotHistorySide.buy,
    qty: 0.001,
    price: 68200,
    fee: 0.034,
    pnl: 0,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't6',
    timestamp: '2026-03-07 18:30:22',
    botName: 'Grid Bot #1',
    strategy: 'Grid',
    pair: 'ETH/USDT',
    side: TradeBotHistorySide.sell,
    qty: 0.05,
    price: 3820,
    fee: 0.096,
    pnl: 8.75,
    status: 'filled',
  ),
  TradeBotHistoryTrade(
    id: 't7',
    timestamp: '2026-03-07 16:15:10',
    botName: 'Momentum Bot #1',
    strategy: 'Momentum',
    pair: 'SOL/USDT',
    side: TradeBotHistorySide.sell,
    qty: 5,
    price: 138.50,
    fee: 0.346,
    pnl: -19.75,
    status: 'filled',
  ),
];

const List<TradeBotPnlPoint> _botPerformancePnlPoints = [
  TradeBotPnlPoint(date: 'Mar 1', pnl: 12.5),
  TradeBotPnlPoint(date: 'Mar 2', pnl: 28.3),
  TradeBotPnlPoint(date: 'Mar 3', pnl: 45.7),
  TradeBotPnlPoint(date: 'Mar 4', pnl: 32.1),
  TradeBotPnlPoint(date: 'Mar 5', pnl: 58.9),
  TradeBotPnlPoint(date: 'Mar 6', pnl: 91.2),
  TradeBotPnlPoint(date: 'Mar 7', pnl: 127.4),
  TradeBotPnlPoint(date: 'Mar 8', pnl: 199.3),
];

const List<TradeBotWinLossPoint> _botPerformanceWinLossPoints = [
  TradeBotWinLossPoint(week: 'W1', wins: 18, losses: 7),
  TradeBotWinLossPoint(week: 'W2', wins: 22, losses: 5),
  TradeBotWinLossPoint(week: 'W3', wins: 15, losses: 12),
  TradeBotWinLossPoint(week: 'W4', wins: 25, losses: 8),
];

const List<TradeBotStrategyPerformance> _botStrategyPerformance = [
  TradeBotStrategyPerformance(strategy: 'DCA', pnl: 84.2, colorHex: 0xFF3B82F6),
  TradeBotStrategyPerformance(
    strategy: 'Grid',
    pnl: 127.4,
    colorHex: 0xFFF59E0B,
  ),
  TradeBotStrategyPerformance(
    strategy: 'Momentum',
    pnl: -12.3,
    colorHex: 0xFF10B981,
  ),
];

const List<TradeBotDurationDistribution> _botDurationDistribution = [
  TradeBotDurationDistribution(duration: '<1h', count: 45),
  TradeBotDurationDistribution(duration: '1-6h', count: 28),
  TradeBotDurationDistribution(duration: '6-24h', count: 15),
  TradeBotDurationDistribution(duration: '>24h', count: 8),
];

const List<TradeBotBacktestStrategy> _botBacktestStrategies = [
  TradeBotBacktestStrategy(id: 'dca', name: 'DCA Bot', colorHex: 0xFF3B82F6),
  TradeBotBacktestStrategy(id: 'grid', name: 'Grid Bot', colorHex: 0xFFF59E0B),
  TradeBotBacktestStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    colorHex: 0xFF10B981,
  ),
  TradeBotBacktestStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    colorHex: 0xFF8B5CF6,
  ),
];

const List<String> _botBacktestPairs = [
  'BTC/USDT',
  'ETH/USDT',
  'SOL/USDT',
  'BNB/USDT',
  'ADA/USDT',
];

const List<TradeBotBacktestDateRange> _botBacktestDateRanges = [
  TradeBotBacktestDateRange(
    id: '1m',
    label: '1 Month',
    periodLabel: 'Feb 8 - Mar 8, 2026',
  ),
  TradeBotBacktestDateRange(
    id: '3m',
    label: '3 Months',
    periodLabel: 'Dec 8, 2025 - Mar 8, 2026',
  ),
  TradeBotBacktestDateRange(
    id: '6m',
    label: '6 Months',
    periodLabel: 'Sep 8, 2025 - Mar 8, 2026',
  ),
  TradeBotBacktestDateRange(
    id: '1y',
    label: '1 Year',
    periodLabel: 'Mar 8, 2025 - Mar 8, 2026',
  ),
];

const List<TradeBotCompareStrategy> _botCompareStrategies = [
  TradeBotCompareStrategy(
    id: 'dca',
    name: 'DCA Bot',
    colorHex: 0xFF3B82F6,
    metrics: TradeBotCompareMetrics(
      totalReturn: 42.3,
      sharpeRatio: 1.52,
      maxDrawdown: -8.4,
      winRate: 65.2,
      profitFactor: 1.87,
      totalTrades: 89,
      avgTradeDuration: '24h',
      volatility: 12.4,
    ),
  ),
  TradeBotCompareStrategy(
    id: 'grid',
    name: 'Grid Bot',
    colorHex: 0xFFF59E0B,
    metrics: TradeBotCompareMetrics(
      totalReturn: 68.7,
      sharpeRatio: 2.14,
      maxDrawdown: -12.1,
      winRate: 72.3,
      profitFactor: 2.45,
      totalTrades: 234,
      avgTradeDuration: '6h',
      volatility: 18.7,
    ),
  ),
  TradeBotCompareStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    colorHex: 0xFF10B981,
    metrics: TradeBotCompareMetrics(
      totalReturn: 55.9,
      sharpeRatio: 1.89,
      maxDrawdown: -15.3,
      winRate: 68.4,
      profitFactor: 2.12,
      totalTrades: 156,
      avgTradeDuration: '12h',
      volatility: 22.3,
    ),
  ),
  TradeBotCompareStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    colorHex: 0xFF8B5CF6,
    metrics: TradeBotCompareMetrics(
      totalReturn: 89.4,
      sharpeRatio: 1.34,
      maxDrawdown: -28.7,
      winRate: 78.9,
      profitFactor: 2.87,
      totalTrades: 312,
      avgTradeDuration: '4h',
      volatility: 34.2,
    ),
  ),
];

const List<TradeBotCompareEquityPoint> _botCompareEquityPoints = [
  TradeBotCompareEquityPoint(
    date: 'Sep',
    dca: 1042,
    grid: 1068,
    momentum: 1055,
    martingale: 1089,
  ),
  TradeBotCompareEquityPoint(
    date: 'Oct',
    dca: 1087,
    grid: 1142,
    momentum: 1128,
    martingale: 1178,
  ),
  TradeBotCompareEquityPoint(
    date: 'Nov',
    dca: 1134,
    grid: 1223,
    momentum: 1198,
    martingale: 1267,
  ),
  TradeBotCompareEquityPoint(
    date: 'Dec',
    dca: 1189,
    grid: 1298,
    momentum: 1256,
    martingale: 1345,
  ),
  TradeBotCompareEquityPoint(
    date: 'Jan',
    dca: 1245,
    grid: 1387,
    momentum: 1334,
    martingale: 1456,
  ),
  TradeBotCompareEquityPoint(
    date: 'Feb',
    dca: 1298,
    grid: 1478,
    momentum: 1412,
    martingale: 1589,
  ),
  TradeBotCompareEquityPoint(
    date: 'Mar',
    dca: 1423,
    grid: 1687,
    momentum: 1559,
    martingale: 1894,
  ),
];

const List<TradeBotRecommendation> _botCompareRecommendations = [
  TradeBotRecommendation(
    title: 'For Beginners',
    strategyId: 'dca',
    strategy: 'DCA Bot',
    reason:
        'Lowest risk (drawdown -8.4%), simplest to understand, steady returns over time.',
  ),
  TradeBotRecommendation(
    title: 'For Sideways Markets',
    strategyId: 'grid',
    strategy: 'Grid Bot',
    reason:
        'Best Sharpe ratio (2.14), high win rate (72.3%), optimized for range-bound trading.',
  ),
  TradeBotRecommendation(
    title: 'For Trending Markets',
    strategyId: 'momentum',
    strategy: 'Momentum Bot',
    reason:
        'Captures trends effectively, balanced risk-reward, good for bull/bear markets.',
  ),
  TradeBotRecommendation(
    title: 'For Experienced Traders',
    strategyId: 'martingale',
    strategy: 'Martingale Bot',
    reason:
        'Highest returns (+89.4%) but high risk (drawdown -28.7%). Requires large capital.',
  ),
];

const List<TradeBotOptimizationTarget> _botOptimizationTargets = [
  TradeBotOptimizationTarget(
    id: 'sharpe',
    label: 'Maximize Sharpe Ratio',
    description: 'Best risk-adjusted returns',
  ),
  TradeBotOptimizationTarget(
    id: 'returns',
    label: 'Maximize Total Returns',
    description: 'Highest absolute profit',
  ),
  TradeBotOptimizationTarget(
    id: 'drawdown',
    label: 'Minimize Drawdown',
    description: 'Lowest risk',
  ),
];

const List<TradeBotOptimizationRange> _botOptimizationRanges = [
  TradeBotOptimizationRange(
    id: 'gridCount',
    label: 'Grid Count',
    min: 10,
    max: 40,
    step: 5,
    defaultValue: 25,
  ),
  TradeBotOptimizationRange(
    id: 'gridRange',
    label: 'Grid Range (%)',
    min: 20,
    max: 50,
    step: 5,
    defaultValue: 35,
    unit: '%',
  ),
];

const List<String> _botOptimizationSteps = [
  'Tests multiple parameter combinations',
  'Backtests each combination on historical data',
  'Ranks results by target metric (Sharpe Ratio)',
  'Recommends optimal parameters',
];

const TradeBotPortfolioSummary _botPortfolioSummary = TradeBotPortfolioSummary(
  totalEquity: 3245,
  totalInvestment: 2500,
  totalPnl: 745,
  pnlPercent: 29.8,
  portfolioSharpe: 1.92,
  diversificationScore: 78,
  activeBots: 3,
  totalTrades: 479,
);

const List<TradeBotPortfolioAllocation> _botPortfolioAllocations = [
  TradeBotPortfolioAllocation(
    strategy: 'DCA',
    value: 1000,
    pnl: 84,
    colorHex: 0xFF3B82F6,
  ),
  TradeBotPortfolioAllocation(
    strategy: 'Grid',
    value: 500,
    pnl: 127,
    colorHex: 0xFFF59E0B,
  ),
  TradeBotPortfolioAllocation(
    strategy: 'Momentum',
    value: 500,
    pnl: -12,
    colorHex: 0xFF10B981,
  ),
  TradeBotPortfolioAllocation(
    strategy: 'Cash Reserve',
    value: 1245,
    pnl: 0,
    colorHex: 0xFF64748B,
  ),
];

const List<TradeBotPortfolioEquityPoint> _botPortfolioEquity = [
  TradeBotPortfolioEquityPoint(date: 'Sep', equity: 2500),
  TradeBotPortfolioEquityPoint(date: 'Oct', equity: 2587),
  TradeBotPortfolioEquityPoint(date: 'Nov', equity: 2734),
  TradeBotPortfolioEquityPoint(date: 'Dec', equity: 2898),
  TradeBotPortfolioEquityPoint(date: 'Jan', equity: 3045),
  TradeBotPortfolioEquityPoint(date: 'Feb', equity: 3178),
  TradeBotPortfolioEquityPoint(date: 'Mar', equity: 3245),
];

const List<TradeBotCorrelationRow> _botPortfolioCorrelations = [
  TradeBotCorrelationRow(
    bot: 'DCA',
    values: {'DCA': 1, 'Grid': .34, 'Momentum': .12},
  ),
  TradeBotCorrelationRow(
    bot: 'Grid',
    values: {'DCA': .34, 'Grid': 1, 'Momentum': -.08},
  ),
  TradeBotCorrelationRow(
    bot: 'Momentum',
    values: {'DCA': .12, 'Grid': -.08, 'Momentum': 1},
  ),
];

const List<String> _botPortfolioHealthItems = [
  'Strong diversification (correlation < 0.4)',
  'Healthy cash reserve (38% allocation)',
  'Portfolio Sharpe above 1.5 (excellent risk-adjusted returns)',
];

const TradeBotDrawdownSummary _botDrawdownSummary = TradeBotDrawdownSummary(
  maxDrawdownPct: -10.3,
  avgDrawdownPct: -5.2,
  drawdownDays: 9,
  totalDays: 15,
  frequency: 5,
);

const List<TradeBotUnderwaterPoint> _botUnderwaterPoints = [
  TradeBotUnderwaterPoint(
    date: '2025-09-01',
    monthLabel: 'Sep',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-09-15',
    monthLabel: 'Sep',
    underwaterPct: -2.3,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-10-01',
    monthLabel: 'Oct',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-10-15',
    monthLabel: 'Oct',
    underwaterPct: -4.5,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-10-30',
    monthLabel: 'Oct',
    underwaterPct: -8.2,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-11-10',
    monthLabel: 'Nov',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-11-25',
    monthLabel: 'Nov',
    underwaterPct: -3.1,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-12-05',
    monthLabel: 'Dec',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2025-12-20',
    monthLabel: 'Dec',
    underwaterPct: -6.7,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-01-05',
    monthLabel: 'Jan',
    underwaterPct: -10.3,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-01-20',
    monthLabel: 'Jan',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-02-01',
    monthLabel: 'Feb',
    underwaterPct: -2.8,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-02-15',
    monthLabel: 'Feb',
    underwaterPct: 0,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-03-01',
    monthLabel: 'Mar',
    underwaterPct: -5.4,
  ),
  TradeBotUnderwaterPoint(
    date: '2026-03-08',
    monthLabel: 'Mar',
    underwaterPct: -3.2,
  ),
];

const List<TradeBotDrawdownDurationBucket> _botDrawdownDurationBuckets = [
  TradeBotDrawdownDurationBucket(range: '<1 week', count: 8),
  TradeBotDrawdownDurationBucket(range: '1-2 weeks', count: 5),
  TradeBotDrawdownDurationBucket(range: '2-4 weeks', count: 3),
  TradeBotDrawdownDurationBucket(range: '>1 month', count: 1),
];

const List<TradeBotDrawdownEvent> _botDrawdownEvents = [
  TradeBotDrawdownEvent(
    id: 1,
    startLabel: 'Sep 10',
    depthPct: -2.3,
    duration: '20 days',
    recovery: '21 days',
    severe: false,
  ),
  TradeBotDrawdownEvent(
    id: 2,
    startLabel: 'Oct 10',
    depthPct: -8.2,
    duration: '29 days',
    recovery: '2 days',
    severe: true,
  ),
  TradeBotDrawdownEvent(
    id: 3,
    startLabel: 'Nov 20',
    depthPct: -3.1,
    duration: '13 days',
    recovery: '2 days',
    severe: false,
  ),
  TradeBotDrawdownEvent(
    id: 4,
    startLabel: 'Dec 15',
    depthPct: -10.3,
    duration: '34 days',
    recovery: '2 days',
    severe: true,
  ),
  TradeBotDrawdownEvent(
    id: 5,
    startLabel: 'Feb 28',
    depthPct: -5.4,
    duration: '8 days',
    recovery: 'Ongoing',
    severe: false,
  ),
];

const List<TradeBotDrawdownInsight> _botDrawdownInsights = [
  TradeBotDrawdownInsight(
    symbol: 'check',
    colorHex: 0xFF10B981,
    text: 'Max drawdown (-10.3%) is within acceptable range (<15%)',
  ),
  TradeBotDrawdownInsight(
    symbol: 'check',
    colorHex: 0xFF10B981,
    text: 'Average recovery time is short (2-21 days)',
  ),
  TradeBotDrawdownInsight(
    symbol: 'alert',
    colorHex: 0xFFF59E0B,
    text: 'Currently in drawdown (-3.2%), monitor closely',
  ),
  TradeBotDrawdownInsight(
    symbol: 'check',
    colorHex: 0xFF10B981,
    text: 'Most drawdowns are short-term (<1 week)',
  ),
];

const TradeBotEquityCurveSummary _botEquityCurveSummary =
    TradeBotEquityCurveSummary(
      botReturnPct: 74.5,
      buyHoldReturnPct: 62.1,
      alphaPct: 12.4,
    );

const List<TradeBotEquityCurvePoint> _botEquityCurvePoints = [
  TradeBotEquityCurvePoint(
    date: '2025-09-01',
    monthLabel: 'Sep',
    equity: 1000,
    buyHold: 1000,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-09-15',
    monthLabel: 'Sep',
    equity: 1042,
    buyHold: 1035,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-10-01',
    monthLabel: 'Oct',
    equity: 1087,
    buyHold: 1098,
    rollingSharpe: 1.52,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-10-15',
    monthLabel: 'Oct',
    equity: 1134,
    buyHold: 1076,
    rollingSharpe: 1.67,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-11-01',
    monthLabel: 'Nov',
    equity: 1189,
    buyHold: 1142,
    rollingSharpe: 1.89,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-11-15',
    monthLabel: 'Nov',
    equity: 1245,
    buyHold: 1198,
    rollingSharpe: 2.01,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-12-01',
    monthLabel: 'Dec',
    equity: 1298,
    buyHold: 1256,
    rollingSharpe: 2.14,
  ),
  TradeBotEquityCurvePoint(
    date: '2025-12-15',
    monthLabel: 'Dec',
    equity: 1356,
    buyHold: 1289,
    rollingSharpe: 2.07,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-01-01',
    monthLabel: 'Jan',
    equity: 1423,
    buyHold: 1334,
    rollingSharpe: 1.94,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-01-15',
    monthLabel: 'Jan',
    equity: 1489,
    buyHold: 1412,
    rollingSharpe: 1.89,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-02-01',
    monthLabel: 'Feb',
    equity: 1556,
    buyHold: 1478,
    rollingSharpe: 1.92,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-02-15',
    monthLabel: 'Feb',
    equity: 1623,
    buyHold: 1534,
    rollingSharpe: 1.97,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-03-01',
    monthLabel: 'Mar',
    equity: 1689,
    buyHold: 1589,
    rollingSharpe: 2.02,
  ),
  TradeBotEquityCurvePoint(
    date: '2026-03-08',
    monthLabel: 'Mar',
    equity: 1745,
    buyHold: 1621,
    rollingSharpe: 2.08,
  ),
];

const List<TradeBotMonthlyReturn> _botEquityMonthlyReturns = [
  TradeBotMonthlyReturn(
    month: 'Sep 2025',
    botReturn: 4.2,
    marketReturn: 3.5,
    alpha: .7,
  ),
  TradeBotMonthlyReturn(
    month: 'Oct 2025',
    botReturn: 4.3,
    marketReturn: 6.1,
    alpha: -1.8,
  ),
  TradeBotMonthlyReturn(
    month: 'Nov 2025',
    botReturn: 4.9,
    marketReturn: 4.0,
    alpha: .9,
  ),
  TradeBotMonthlyReturn(
    month: 'Dec 2025',
    botReturn: 4.4,
    marketReturn: 3.7,
    alpha: .7,
  ),
  TradeBotMonthlyReturn(
    month: 'Jan 2026',
    botReturn: 4.8,
    marketReturn: 5.1,
    alpha: -.3,
  ),
  TradeBotMonthlyReturn(
    month: 'Feb 2026',
    botReturn: 4.7,
    marketReturn: 4.5,
    alpha: .2,
  ),
  TradeBotMonthlyReturn(
    month: 'Mar 2026',
    botReturn: 4.2,
    marketReturn: 3.8,
    alpha: .4,
  ),
];

const List<TradeBotPerformanceStat> _botEquityPerformanceStats = [
  TradeBotPerformanceStat(
    id: 'total',
    label: 'Total Return',
    value: '+74.5%',
    colorHex: 0xFF10B981,
  ),
  TradeBotPerformanceStat(
    id: 'annualized',
    label: 'Annualized Return',
    value: '+52.3%',
    colorHex: 0xFF10B981,
  ),
  TradeBotPerformanceStat(
    id: 'outperformance',
    label: 'Outperformance',
    value: '+12.4%',
    colorHex: 0xFF10B981,
  ),
  TradeBotPerformanceStat(
    id: 'average',
    label: 'Avg Monthly',
    value: '+4.5%',
    colorHex: 0xFFF5F7FA,
  ),
];

const List<String> _botEquityAnalysisItems = [
  'Bot returned +74.5% vs buy & hold +62.1% (alpha: +12.4%)',
  'Consistent positive alpha in 5 out of 7 months',
  'Rolling Sharpe ratio stayed above 1.5 (excellent risk-adjusted returns)',
];

const List<TradeBotGuideStrategy> _botGuideStrategies = [
  TradeBotGuideStrategy(
    id: 'dca',
    name: 'DCA Bot (Dollar Cost Averaging)',
    iconKey: 'trending',
    colorHex: 0xFF3B82F6,
    difficulty: 'Beginner',
    description:
        'Automatically buy crypto at regular intervals regardless of price.',
    howItWorks: [
      'Set investment amount (e.g., \$100)',
      'Choose frequency (daily, weekly, monthly)',
      'Bot buys automatically on schedule',
      'Averages out market volatility',
      'Best for long-term accumulation',
    ],
    pros: [
      'Simplest strategy to understand',
      'Removes emotion from buying decisions',
      'Reduces timing risk',
      'Good for volatile markets',
    ],
    cons: [
      'No profit taking mechanism',
      'Continues buying in downtrends',
      'Requires consistent capital',
    ],
    bestFor: 'Long-term investors, beginners, volatile markets',
    example: TradeBotGuideExample(
      setup: 'Buy \$100 BTC every Monday',
      duration: '6 months',
      result: 'Average buy price: \$67,500 vs spot price: \$68,450',
      profit: '+\$127 (1.8%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'grid',
    name: 'Grid Bot',
    iconKey: 'grid',
    colorHex: 0xFFF59E0B,
    difficulty: 'Intermediate',
    description:
        'Place buy and sell orders at multiple price levels to profit from price fluctuations.',
    howItWorks: [
      'Define price range (e.g., \$65,000 - \$70,000)',
      'Set number of grids (e.g., 20 grids)',
      'Bot places buy/sell orders at each grid level',
      'Profits from each price swing',
      'Works best in sideways markets',
    ],
    pros: [
      'Profits from volatility',
      'No need to predict direction',
      'Automated 24/7 trading',
      'High win rate (70-80%)',
    ],
    cons: [
      'Loses money in strong trends',
      'Requires sufficient capital for all grids',
      'Can miss big moves outside range',
    ],
    bestFor: 'Sideways/ranging markets, active traders, volatility lovers',
    example: TradeBotGuideExample(
      setup: '20 grids, \$65K-\$70K range, \$1,000 capital',
      duration: '1 month',
      result: '156 trades executed, 72.3% win rate',
      profit: '+\$127.40 (12.7%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'momentum',
    name: 'Momentum Bot',
    iconKey: 'bolt',
    colorHex: 0xFF10B981,
    difficulty: 'Advanced',
    description:
        'Follow trends by buying when price rises and selling when it falls.',
    howItWorks: [
      'Monitor price movement and indicators',
      'Buy when uptrend detected (e.g., price > MA)',
      'Sell when downtrend detected',
      'Trail stop-loss to protect profits',
      'Best for trending markets',
    ],
    pros: [
      'Captures large trend movements',
      'Built-in stop-loss protection',
      'Can make big profits in trends',
      'Adapts to market conditions',
    ],
    cons: [
      'Frequent false signals in choppy markets',
      'Requires parameter tuning',
      'Can whipsaw in sideways markets',
    ],
    bestFor: 'Trending markets (bull/bear), experienced traders',
    example: TradeBotGuideExample(
      setup: 'MA crossover strategy, 3% stop-loss',
      duration: '2 months',
      result: '23 trades, 68.4% win rate',
      profit: '+\$559 (55.9%)',
    ),
  ),
  TradeBotGuideStrategy(
    id: 'martingale',
    name: 'Martingale Bot',
    iconKey: 'alert',
    colorHex: 0xFFEF4444,
    difficulty: 'Expert',
    description:
        'Double position size after each loss to recover all losses with one win.',
    howItWorks: [
      'Start with base position (e.g., \$100)',
      'If loss, double next position (\$200)',
      'If loss again, double again (\$400)',
      'One win recovers all previous losses',
      'High risk - can blow up account',
    ],
    pros: ['High win rate (78%+)', 'Recovers losses quickly', 'Simple logic'],
    cons: [
      'Catastrophic risk if many losses',
      'Requires large capital',
      'Can hit max drawdown (-30%+)',
      'Not suitable for beginners',
    ],
    bestFor: 'Experienced traders with large capital, high risk tolerance',
    example: TradeBotGuideExample(
      setup: 'Base \$100, 2x multiplier, max 5 doublings',
      duration: '1 month',
      result: '312 trades, 78.9% win rate, max DD -28.7%',
      profit: '+\$894 (89.4%) - High risk',
    ),
  ),
];

const List<TradeBotGuidePractice> _botGuideBestPractices = [
  TradeBotGuidePractice(
    id: 'small',
    title: 'Start Small',
    description: 'Begin with \$50-200 to test strategies before scaling up.',
    iconKey: 'idea',
  ),
  TradeBotGuidePractice(
    id: 'backtest',
    title: 'Backtest First',
    description:
        'Always backtest your strategy on historical data before deploying.',
    iconKey: 'chart',
  ),
  TradeBotGuidePractice(
    id: 'stop-loss',
    title: 'Set Stop-Loss',
    description: 'Use drawdown limits and emergency stops to protect capital.',
    iconKey: 'shield',
  ),
  TradeBotGuidePractice(
    id: 'monitor',
    title: 'Monitor Daily',
    description: 'Check bot performance at least once a day for anomalies.',
    iconKey: 'eye',
  ),
  TradeBotGuidePractice(
    id: 'diversify',
    title: 'Diversify',
    description:
        "Don't put all capital in one bot - spread across multiple strategies.",
    iconKey: 'target',
  ),
  TradeBotGuidePractice(
    id: 'fomo',
    title: 'Avoid FOMO',
    description: "Don't create bots during extreme market conditions.",
    iconKey: 'warning',
  ),
];

const List<TradeBotGuideMistake> _botGuideMistakes = [
  TradeBotGuideMistake(
    mistake: 'Over-optimizing parameters',
    why: 'Parameters optimized on past data may not work in future.',
    fix: 'Use simple, robust parameters. Test walk-forward validation.',
  ),
  TradeBotGuideMistake(
    mistake: 'Ignoring fees',
    why: 'High-frequency bots can lose money purely from trading fees.',
    fix: 'Calculate fee impact. Aim for profit > 2x fees per trade.',
  ),
  TradeBotGuideMistake(
    mistake: 'No risk management',
    why: 'Bots can compound losses without stop-loss limits.',
    fix: 'Set max drawdown (-20%), daily loss limits, use emergency stop.',
  ),
  TradeBotGuideMistake(
    mistake: 'Changing strategy mid-run',
    why: 'Interrupts strategy logic, can cause losses.',
    fix: 'Let bot run for full cycle (7-30 days) before adjusting.',
  ),
  TradeBotGuideMistake(
    mistake: 'Using demo results as guarantee',
    why: 'Demo has no slippage, instant fills, no network issues.',
    fix: 'Expect real results to be 10-20% worse than demo.',
  ),
];

const List<TradeBotFaqCategory> _botFaqCategories = [
  TradeBotFaqCategory(
    id: 'general',
    label: 'General',
    items: [
      TradeBotFaqItem(
        question: 'What is a trading bot?',
        answer:
            'A trading bot is an automated program that executes buy and sell orders based on predefined rules and strategies. It trades 24/7 without human intervention, following your configured parameters.',
      ),
      TradeBotFaqItem(
        question: 'Are trading bots profitable?',
        answer:
            'Profitability depends on market conditions, strategy, and parameters. Bots can be profitable but are NOT guaranteed to make money. Past performance does not predict future results. You may lose some or all of your capital.',
      ),
      TradeBotFaqItem(
        question: 'How much money do I need to start?',
        answer:
            'You can start with as little as \$50-100 for testing. For serious trading, we recommend \$500-1,000 minimum to handle market volatility and trading fees. Grid bots need more capital.',
      ),
      TradeBotFaqItem(
        question: 'Do I need coding skills?',
        answer:
            'No coding required. Our bots use a simple configuration interface. Just select strategy, set parameters, and start. Advanced users can use API for custom strategies.',
      ),
      TradeBotFaqItem(
        question: 'Can I lose more than I invest?',
        answer:
            'No. Bots only trade with your available balance. You cannot lose more than your deposited amount. However, you can lose your entire investment if the market moves against you.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'safety',
    label: 'Safety',
    items: [
      TradeBotFaqItem(
        question: 'What happens if the exchange goes down?',
        answer:
            'If the exchange API fails, the bot stops executing new orders until connection is restored. Open orders remain on exchange books. Use exchanges with 99.9%+ uptime.',
      ),
      TradeBotFaqItem(
        question: 'Can hackers steal my funds?',
        answer:
            'We never have custody of your funds. They stay on the exchange. We only use API keys with trade permissions, not withdrawal permissions.',
      ),
      TradeBotFaqItem(
        question: 'How do I stop a bot in emergency?',
        answer:
            'Go to Risk Dashboard > Emergency Stop, or use the stop button on bot detail page. This immediately stops new orders and can optionally close open positions.',
      ),
      TradeBotFaqItem(
        question: 'What if I find a bug?',
        answer:
            'Use the emergency stop immediately. Report the bug to support@tradingplatform.com with screenshots and bot ID. We review verified bugs and related losses.',
      ),
      TradeBotFaqItem(
        question: 'Are my API keys stored securely?',
        answer:
            'Yes. API keys are encrypted using AES-256 and stored in secure vaults. Keys are never logged or displayed in plain text after creation.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'technical',
    label: 'Technical',
    items: [
      TradeBotFaqItem(
        question: 'How accurate is backtesting?',
        answer:
            'Backtests use historical data but cannot predict future performance. Expect real results to be 10-20% worse due to slippage, fees, network delays, and partial fills.',
      ),
      TradeBotFaqItem(
        question: 'What fees apply to bot trading?',
        answer:
            'Exchange trading fees apply to every order. Our platform charges no extra fees for bot usage. High-frequency strategies can rack up fees quickly.',
      ),
      TradeBotFaqItem(
        question: 'Can I edit a running bot?',
        answer:
            'No. You must stop the bot, edit parameters, then restart. This prevents strategy corruption mid-cycle and keeps audit history clear.',
      ),
      TradeBotFaqItem(
        question: 'Why did my order not fill?',
        answer:
            'Common reasons include insufficient liquidity, fast price moves, exchange balance or limit rejection, and network latency. Check order history for the exact message.',
      ),
      TradeBotFaqItem(
        question: 'What is slippage and how do I reduce it?',
        answer:
            'Slippage is the difference between expected and actual execution price. Reduce it by trading liquid pairs, using limit orders, splitting large orders, and avoiding low-volume periods.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'strategies',
    label: 'Strategies',
    items: [
      TradeBotFaqItem(
        question: 'Which bot strategy is best for beginners?',
        answer:
            'DCA is simplest and safest for beginners. It removes emotion, reduces timing risk, and works well long-term. Avoid Martingale until experienced.',
      ),
      TradeBotFaqItem(
        question: 'When should I use a Grid Bot?',
        answer:
            'Use Grid Bots in sideways or ranging markets where price bounces inside a channel. They are not recommended during strong bull or bear runs.',
      ),
      TradeBotFaqItem(
        question: 'What is the Martingale risk?',
        answer:
            'Martingale doubles position after each loss and requires exponential capital. After 5 losses, you need 32x initial capital and max drawdown can exceed -30%.',
      ),
      TradeBotFaqItem(
        question: 'How do I choose the right parameters?',
        answer:
            'Start with recommended defaults, then adjust based on backtest results, your risk tolerance, and market conditions. Avoid over-optimizing.',
      ),
      TradeBotFaqItem(
        question: 'Can I run multiple bots at once?',
        answer:
            'Yes. Free tier supports 1 bot, Pro tier supports 5 bots, and Enterprise supports unlimited bots. Diversify across strategies and pairs for lower risk.',
      ),
    ],
  ),
  TradeBotFaqCategory(
    id: 'troubleshooting',
    label: 'Troubleshooting',
    items: [
      TradeBotFaqItem(
        question: 'My bot is losing money - what should I do?',
        answer:
            'First check whether losses are within expected drawdown. If limits are exceeded, stop the bot, review backtest results, and check whether market conditions changed.',
      ),
      TradeBotFaqItem(
        question: 'Bot stopped working after I changed settings',
        answer:
            'You likely have insufficient balance for new parameters. Check wallet balance, locked funds in other bots, and min or max order sizes.',
      ),
      TradeBotFaqItem(
        question: 'Why is my Grid Bot not executing trades?',
        answer:
            'Grid Bots only trade when price crosses grid levels. If price is stable, no trades execute. Check range, grid spacing, and liquidity.',
      ),
      TradeBotFaqItem(
        question: 'How long should I run a bot before stopping?',
        answer:
            'Minimum 7 days for DCA and 30 days for Grid or Momentum. Bots need time to complete cycles and recover from temporary drawdowns.',
      ),
      TradeBotFaqItem(
        question: 'Can I transfer funds while bot is running?',
        answer:
            'Withdrawing funds may cause a bot to stop if balance drops below minimum. Depositing is safe. Keep a 20% extra buffer for volatility and fees.',
      ),
    ],
  ),
];

const TradeBotTaxSummary _botTaxSummary = TradeBotTaxSummary(
  totalTrades: 1247,
  realizedGains: 3842.50,
  realizedLosses: -1127.30,
  netGainLoss: 2715.20,
  shortTermGains: 2318.40,
  longTermGains: 396.80,
  totalFees: 287.60,
);

const List<TradeBotTaxReportType> _botTaxReportTypes = [
  TradeBotTaxReportType(
    id: 'irs-8949',
    name: 'IRS Form 8949',
    description: 'US tax form for capital gains/losses',
    format: 'PDF',
    recommended: true,
    selectedByDefault: true,
  ),
  TradeBotTaxReportType(
    id: 'turbotax',
    name: 'TurboTax CSV',
    description: 'Import directly into TurboTax software',
    format: 'CSV',
    recommended: true,
    selectedByDefault: true,
  ),
  TradeBotTaxReportType(
    id: 'detailed-csv',
    name: 'Detailed Trade Log',
    description: 'All trades with timestamps, fees, PnL',
    format: 'CSV',
    recommended: false,
    selectedByDefault: false,
  ),
  TradeBotTaxReportType(
    id: 'summary-pdf',
    name: 'Summary Report',
    description: 'Overview of yearly gains/losses',
    format: 'PDF',
    recommended: false,
    selectedByDefault: false,
  ),
];

const TradeBotTaxBreakdown _botTaxBreakdown = TradeBotTaxBreakdown(
  shortTermLabel: 'Short-Term Gains',
  shortTermDescription: 'Held < 1 year (taxed as income)',
  longTermLabel: 'Long-Term Gains',
  longTermDescription: 'Held > 1 year (lower tax rate)',
);

const List<String> _botTaxNotes = [
  'Bot trades are taxable events (buy/sell, not just withdrawal)',
  'Trading fees can be deducted from capital gains',
  'Crypto-to-crypto trades (BTC->ETH) are taxable',
  'Consult a tax professional for accurate filing',
  'Keep reports for 7 years (IRS audit protection)',
];

const List<TradeBotApiEndpoint> _botApiEndpoints = [
  TradeBotApiEndpoint(
    method: 'GET',
    path: '/api/v1/bots',
    description: 'List all user bots',
    params: [
      TradeBotApiParameter(
        name: 'status',
        type: 'string',
        required: false,
        description: 'Filter by status (running, stopped, paused)',
      ),
      TradeBotApiParameter(
        name: 'limit',
        type: 'number',
        required: false,
        description: 'Max results (default: 20)',
      ),
    ],
    response: r'''{
  "bots": [
    {
      "id": "bot_abc123",
      "name": "DCA Bot #1",
      "strategy": "dca",
      "status": "running",
      "profit": 84.20,
      "createdAt": "2026-01-15T10:30:00Z"
    }
  ],
  "total": 3
}''',
  ),
  TradeBotApiEndpoint(
    method: 'POST',
    path: '/api/v1/bots',
    description: 'Create a new bot',
    params: [
      TradeBotApiParameter(
        name: 'name',
        type: 'string',
        required: true,
        description: 'Bot name',
      ),
      TradeBotApiParameter(
        name: 'strategy',
        type: 'string',
        required: true,
        description: 'dca | grid | momentum | martingale',
      ),
      TradeBotApiParameter(
        name: 'pair',
        type: 'string',
        required: true,
        description: 'Trading pair (e.g., BTC/USDT)',
      ),
      TradeBotApiParameter(
        name: 'config',
        type: 'object',
        required: true,
        description: 'Strategy-specific parameters',
      ),
    ],
    response: r'''{
  "bot": {
    "id": "bot_xyz789",
    "name": "My Grid Bot",
    "strategy": "grid",
    "status": "running",
    "createdAt": "2026-03-08T14:23:00Z"
  }
}''',
  ),
  TradeBotApiEndpoint(
    method: 'DELETE',
    path: '/api/v1/bots/:botId',
    description: 'Stop and delete a bot',
    params: [],
    response: r'''{
  "success": true,
  "message": "Bot stopped and deleted"
}''',
  ),
  TradeBotApiEndpoint(
    method: 'GET',
    path: '/api/v1/bots/:botId/history',
    description: 'Get bot trade history',
    params: [
      TradeBotApiParameter(
        name: 'startDate',
        type: 'string',
        required: false,
        description: 'ISO date',
      ),
      TradeBotApiParameter(
        name: 'endDate',
        type: 'string',
        required: false,
        description: 'ISO date',
      ),
      TradeBotApiParameter(
        name: 'limit',
        type: 'number',
        required: false,
        description: 'Max results',
      ),
    ],
    response: r'''{
  "trades": [
    {
      "id": "trade_123",
      "side": "buy",
      "price": 68450,
      "qty": 0.001,
      "fee": 0.034,
      "timestamp": "2026-03-08T14:32:15Z"
    }
  ],
  "total": 247
}''',
  ),
];

const List<TradeBotWebSocketEvent> _botApiWebSocketEvents = [
  TradeBotWebSocketEvent(
    event: 'bot.status',
    description: 'Bot status changed',
    payload: r'''{
  "botId": "bot_abc123",
  "status": "stopped",
  "reason": "manual_stop",
  "timestamp": "2026-03-08T15:00:00Z"
}''',
  ),
  TradeBotWebSocketEvent(
    event: 'bot.trade',
    description: 'New trade executed',
    payload: r'''{
  "botId": "bot_abc123",
  "tradeId": "trade_xyz",
  "side": "buy",
  "price": 68450,
  "qty": 0.001,
  "fee": 0.034
}''',
  ),
  TradeBotWebSocketEvent(
    event: 'bot.profit',
    description: 'Profit/loss update',
    payload: r'''{
  "botId": "bot_abc123",
  "profit": 127.40,
  "profitPercent": 12.74,
  "totalTrades": 156
}''',
  ),
];

const List<TradeBotCodeExample> _botApiCodeExamples = [
  TradeBotCodeExample(
    language: 'javascript',
    label: 'JavaScript',
    title: 'JavaScript SDK',
    source: r'''// Install SDK
npm install @tradingplatform/bot-sdk

// Import and initialize
const BotSDK = require('@tradingplatform/bot-sdk');
const client = new BotSDK({
  apiKey: 'YOUR_API_KEY',
  apiSecret: 'YOUR_API_SECRET'
});

// List all bots
const bots = await client.bots.list();
console.log(bots);

// Create a new Grid Bot
const newBot = await client.bots.create({
  name: 'My Grid Bot',
  strategy: 'grid',
  pair: 'BTC/USDT',
  config: {
    gridCount: 20,
    upperPrice: 70000,
    lowerPrice: 65000,
    investment: 1000
  }
});

// Subscribe to bot events
client.on('bot.trade', (data) => {
  console.log('New trade:', data);
});''',
  ),
  TradeBotCodeExample(
    language: 'python',
    label: 'Python',
    title: 'Python SDK',
    source: r'''# Install SDK
pip install tradingplatform-bot-sdk

# Import and initialize
from tradingplatform import BotClient

client = BotClient(
    api_key='YOUR_API_KEY',
    api_secret='YOUR_API_SECRET'
)

# List all bots
bots = client.bots.list()
print(bots)

# Create a new DCA Bot
new_bot = client.bots.create(
    name='My DCA Bot',
    strategy='dca',
    pair='BTC/USDT',
    config={
        'amount': 100,
        'frequency': 'weekly'
    }
)

# Subscribe to WebSocket events
@client.on('bot.trade')
def on_trade(data):
    print(f"New trade: {data}")''',
  ),
  TradeBotCodeExample(
    language: 'curl',
    label: 'cURL',
    title: 'cURL Commands',
    source: r'''# List all bots
curl -X GET https://api.tradingplatform.com/v1/bots \
  -H "Authorization: Bearer YOUR_API_KEY"

# Create a new bot
curl -X POST https://api.tradingplatform.com/v1/bots \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Grid Bot",
    "strategy": "grid",
    "pair": "BTC/USDT",
    "config": {
      "gridCount": 20,
      "upperPrice": 70000,
      "lowerPrice": 65000,
      "investment": 1000
    }
  }'

# Get bot history
curl -X GET https://api.tradingplatform.com/v1/bots/bot_abc123/history \
  -H "Authorization: Bearer YOUR_API_KEY"''',
  ),
];

const List<TradeBotRateLimit> _botApiRateLimits = [
  TradeBotRateLimit(label: 'REST API:', value: '100 requests / minute'),
  TradeBotRateLimit(label: 'WebSocket:', value: 'Unlimited subscriptions'),
  TradeBotRateLimit(label: 'Max bots (API):', value: 'Enterprise tier only'),
];

const List<TradeFuturesPosition> _futuresPositions = [
  TradeFuturesPosition(
    id: 'fp1',
    symbol: 'ETH/USDT',
    side: TradeFuturesSide.long,
    leverage: 10,
    size: .5,
    entryPrice: 3480,
    markPrice: 3521.45,
    liquidPrice: 3150,
    pnl: 20.73,
    pnlPct: 1.19,
    margin: 174,
    roe: 11.9,
  ),
  TradeFuturesPosition(
    id: 'fp2',
    symbol: 'SOL/USDT',
    side: TradeFuturesSide.short,
    leverage: 5,
    size: 10,
    entryPrice: 185,
    markPrice: 178.32,
    liquidPrice: 222,
    pnl: 66.80,
    pnlPct: 3.61,
    margin: 370,
    roe: 18.05,
  ),
];

const TradeOrderBook _orderBook = TradeOrderBook(
  bids: [
    TradeBookLevel(price: 67524.13, amount: 0.812, total: 54829),
    TradeBookLevel(price: 67518.80, amount: 1.204, total: 81308),
    TradeBookLevel(price: 67510.42, amount: 0.533, total: 35982),
  ],
  asks: [
    TradeBookLevel(price: 67545.13, amount: 0.628, total: 42416),
    TradeBookLevel(price: 67551.90, amount: 0.904, total: 61067),
    TradeBookLevel(price: 67563.44, amount: 1.118, total: 75540),
  ],
);

const List<TradeTapePrint> _trades = [
  TradeTapePrint(price: 67543.21, amount: 0.036, time: '23:29:14', isBuy: true),
  TradeTapePrint(
    price: 67541.88,
    amount: 0.082,
    time: '23:29:12',
    isBuy: false,
  ),
  TradeTapePrint(price: 67544.09, amount: 0.024, time: '23:29:09', isBuy: true),
];

const List<TradeOpenOrder> _orders = [
  TradeOpenOrder(
    id: 'ord001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    price: 67050,
    amount: .12,
    filled: .04,
    createdAt: '23/02 09:24',
  ),
  TradeOpenOrder(
    id: 'ord002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    price: 3580,
    amount: 1.4,
    filled: 0,
    createdAt: '23/02 08:11',
  ),
];

const List<TradeHistoryOrder> _historyOpenOrders = [
  TradeHistoryOrder(
    id: 'ord-open-001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.open,
    price: 65000,
    amount: .05,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 09:32:11',
  ),
  TradeHistoryOrder(
    id: 'ord-open-002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.partial,
    price: 3650,
    amount: 1.5,
    filled: .8,
    fee: .24,
    createdAt: '2024-02-21 10:15:44',
  ),
  TradeHistoryOrder(
    id: 'ord-open-003',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.stop,
    status: TradeOrderStatus.open,
    price: 170,
    amount: 10,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 11:02:33',
  ),
  TradeHistoryOrder(
    id: 'ord-open-004',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.market,
    status: TradeOrderStatus.open,
    price: 67500,
    amount: .02,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 12:18:07',
  ),
];

const List<TradeHistoryOrder> _historyOrders = [
  TradeHistoryOrder(
    id: 'ord-history-001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.filled,
    price: 64220,
    amount: .08,
    filled: .08,
    fee: 3.71,
    createdAt: '2024-02-20 18:21:44',
  ),
  TradeHistoryOrder(
    id: 'ord-history-002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.market,
    status: TradeOrderStatus.filled,
    price: 3588,
    amount: 1.2,
    filled: 1.2,
    fee: 2.89,
    createdAt: '2024-02-20 16:09:12',
  ),
  TradeHistoryOrder(
    id: 'ord-history-003',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.stop,
    status: TradeOrderStatus.cancelled,
    price: 154,
    amount: 12,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-19 22:40:03',
  ),
  TradeHistoryOrder(
    id: 'ord-history-004',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.filled,
    price: 67120,
    amount: .03,
    filled: .03,
    fee: 1.71,
    createdAt: '2024-02-19 14:35:10',
  ),
  TradeHistoryOrder(
    id: 'ord-history-005',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.cancelled,
    price: 3400,
    amount: .9,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-18 09:12:40',
  ),
];

const List<TradePosition> _positions = [
  TradePosition(
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    notional: 8105.19,
    pnl: 142.44,
  ),
];
