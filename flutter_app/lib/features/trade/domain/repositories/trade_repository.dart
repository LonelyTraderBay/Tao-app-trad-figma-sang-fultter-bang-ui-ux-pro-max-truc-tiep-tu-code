import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';

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
  TradeCopyCardDemoSnapshot getCopyCardDemo();
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
