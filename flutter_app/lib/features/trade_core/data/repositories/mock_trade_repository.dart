import 'package:vit_trade_flutter/features/trade_bots/data/repositories/mock_trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/repositories/mock_trade_regulatory_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/repositories/mock_trade_copy_trading_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/repositories/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/repositories/mock_trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

// This class used to live at
// `features/trade/data/repositories/mock_trade_repository.dart` and own 4
// domain logic mixin groups (core spot, advanced tools, conversions &
// utilities, futures/leverage) directly, in addition to the 3 delegate
// mixins below. In the trade_terminal extraction (Batch 3 of Phase 4 of the
// trade module split — the final domain phase), those 4 mixin groups moved
// to the independent [MockTradeTerminalRepository] owned by
// `trade_terminal`, along with their fixtures. That left this class with no
// domain logic of its own — just a 4-way delegation hub satisfying the
// [TradeRepository] union by forwarding every call to one of the 4
// independent per-domain mocks. Its natural home is therefore `trade_core`
// (the module that owns the [TradeRepository] union itself), not a leaf
// domain, so it moved here in the same batch.

mixin _MockTradeRepositoryBase implements TradeRepository {}

// Delegates the whole [TradeRegulatoryRepository] surface (regulatory
// costs/disclosures/disputes + execution analytics) to the independent
// [MockTradeRegulatoryRepository] owned by `trade_compliance` (Batch 3 of
// Phase 1 of the trade module split). [TradeRepository] is still a union
// that includes [TradeRegulatoryRepository], so [MockTradeRepository] must
// keep satisfying that surface — it now does so by forwarding rather than
// implementing the methods itself, since the 4 regulatory/execution-
// analytics mixins that used to live here moved to `trade_compliance`
// along with their fixtures.
mixin _MockTradeRepositoryRegulatoryDelegate on _MockTradeRepositoryBase {
  static const MockTradeRegulatoryRepository _regulatory =
      MockTradeRegulatoryRepository();

  @override
  TradeClientMoneyProtectionSnapshot getClientMoneyProtection() =>
      _regulatory.getClientMoneyProtection();

  @override
  TradeCassReconciliationSnapshot getCassReconciliation() =>
      _regulatory.getCassReconciliation();

  @override
  TradeInvestorCompensationSnapshot getInvestorCompensation() =>
      _regulatory.getInvestorCompensation();

  @override
  TradeExAnteCostsSnapshot getExAnteCosts() => _regulatory.getExAnteCosts();

  @override
  TradeRiyCalculatorSnapshot getRiyCalculator() =>
      _regulatory.getRiyCalculator();

  @override
  TradeExPostCostsReportSnapshot getExPostCostsReport() =>
      _regulatory.getExPostCostsReport();

  @override
  TradeKidGeneratorSnapshot getKidGenerator() => _regulatory.getKidGenerator();

  @override
  TradePerformanceScenariosSnapshot getPerformanceScenarios() =>
      _regulatory.getPerformanceScenarios();

  @override
  TradeRiskIndicatorSnapshot getRiskIndicatorExplainer() =>
      _regulatory.getRiskIndicatorExplainer();

  @override
  TradeExPostCostsReportExportResult createExPostCostsReportExport({
    int year = 2025,
  }) => _regulatory.createExPostCostsReportExport(year: year);

  @override
  TradeRegulatoryDisclosuresSnapshot getRegulatoryDisclosures() =>
      _regulatory.getRegulatoryDisclosures();

  @override
  TradeTransactionReportingSnapshot getTransactionReporting() =>
      _regulatory.getTransactionReporting();

  @override
  TradeRegulatoryReportsDashboardSnapshot getRegulatoryReportsDashboard() =>
      _regulatory.getRegulatoryReportsDashboard();

  @override
  TradeClientCategorizationSnapshot getClientCategorization() =>
      _regulatory.getClientCategorization();

  @override
  TradeProductGovernanceSnapshot getProductGovernance() =>
      _regulatory.getProductGovernance();

  @override
  TradeTargetMarketDefinitionSnapshot getTargetMarketDefinition({
    String productId = 'prod-1',
  }) => _regulatory.getTargetMarketDefinition(productId: productId);

  @override
  TradeAuditTrailSnapshot getAuditTrail() => _regulatory.getAuditTrail();

  @override
  TradeRegulatoryInspectionSnapshot getRegulatoryInspectionReady() =>
      _regulatory.getRegulatoryInspectionReady();

  @override
  TradeMarketDataAnalyticsSnapshot getMarketDataAnalytics() =>
      _regulatory.getMarketDataAnalytics();

  @override
  TradeMarketDataAnalyticsSnapshot getLiveMarketDataAnalytics() =>
      _regulatory.getLiveMarketDataAnalytics();

  @override
  TradeArmIntegrationStatusSnapshot getArmIntegrationStatus() =>
      _regulatory.getArmIntegrationStatus();

  @override
  TradeBestExecutionReportsSnapshot getBestExecutionReports() =>
      _regulatory.getBestExecutionReports();

  @override
  TradeExecutionVenueAnalysisSnapshot getExecutionVenueAnalysis() =>
      _regulatory.getExecutionVenueAnalysis();

  @override
  TradeSlippageMonitoringSnapshot getSlippageMonitoring() =>
      _regulatory.getSlippageMonitoring();

  @override
  TradeComplaintsHandlingSnapshot getComplaintsHandling() =>
      _regulatory.getComplaintsHandling();

  @override
  TradeComplaintSubmissionSnapshot getComplaintSubmission() =>
      _regulatory.getComplaintSubmission();

  @override
  TradeComplaintTrackingSnapshot getComplaintTracking({String? complaintId}) =>
      _regulatory.getComplaintTracking(complaintId: complaintId);

  @override
  TradeOmbudsmanReferralSnapshot getOmbudsmanReferral() =>
      _regulatory.getOmbudsmanReferral();
}

// Delegates the whole [TradeCopyTradingRepository] surface (provider
// discovery, configuration & performance, lifecycle & safety) to the
// independent [MockTradeCopyTradingRepository] owned by `trade_copy`
// (Batch 3 of Phase 2 of the trade module split). [TradeRepository] is
// still a union that includes [TradeCopyTradingRepository], so
// [MockTradeRepository] must keep satisfying that surface — it now does so
// by forwarding rather than implementing the methods itself, since the 3
// copy-trading mixins that used to live here moved to `trade_copy` along
// with their fixtures.
mixin _MockTradeRepositoryCopyTradingDelegate on _MockTradeRepositoryBase {
  static const MockTradeCopyTradingRepository _copyTrading =
      MockTradeCopyTradingRepository();

  @override
  TradeProviderComparisonSnapshot getProviderComparison() =>
      _copyTrading.getProviderComparison();

  @override
  TradeProviderLeaderboardSnapshot getProviderLeaderboard() =>
      _copyTrading.getProviderLeaderboard();

  @override
  TradeProviderGovernanceSnapshot getProviderGovernance() =>
      _copyTrading.getProviderGovernance();

  @override
  TradeTraderProfileSnapshot getTraderProfile({
    String traderId = 'trader001',
  }) => _copyTrading.getTraderProfile(traderId: traderId);

  @override
  TradeProviderApplicationSnapshot getProviderApplication() =>
      _copyTrading.getProviderApplication();

  @override
  TradeCopyProviderDetailSnapshot getCopyProviderDetail({
    String providerId = 'provider001',
  }) => _copyTrading.getCopyProviderDetail(providerId: providerId);

  @override
  TradePreCopyAssessmentSnapshot getPreCopyAssessment({
    String providerId = 'provider001',
  }) => _copyTrading.getPreCopyAssessment(providerId: providerId);

  @override
  TradeProviderApplicationResult submitProviderApplication(
    TradeProviderApplicationDraft draft,
  ) => _copyTrading.submitProviderApplication(draft);

  @override
  TradeCopyConfigurationSnapshot getCopyConfiguration({
    String providerId = 'provider001',
  }) => _copyTrading.getCopyConfiguration(providerId: providerId);

  @override
  TradeCopyConfirmationSnapshot getCopyConfirmation({
    String providerId = 'provider001',
  }) => _copyTrading.getCopyConfirmation(providerId: providerId);

  @override
  TradeCopyPerformanceSnapshot getCopyPerformance({
    String copyId = 'copy001',
  }) => _copyTrading.getCopyPerformance(copyId: copyId);

  @override
  TradePerformanceAttributionSnapshot getPerformanceAttribution({
    String copyId = 'copy001',
  }) => _copyTrading.getPerformanceAttribution(copyId: copyId);

  @override
  TradeCopyAuditLogSnapshot getCopyAuditLog({String copyId = 'copy001'}) =>
      _copyTrading.getCopyAuditLog(copyId: copyId);

  @override
  TradePortfolioRiskAnalysisSnapshot getPortfolioRiskAnalysis() =>
      _copyTrading.getPortfolioRiskAnalysis();

  @override
  TradeCopyConfigurationPreview previewCopyConfiguration(
    TradeCopyConfigurationDraft draft,
  ) => _copyTrading.previewCopyConfiguration(draft);

  @override
  TradeCopyConfirmationResult submitCopyConfirmation(
    TradeCopyConfirmationRequest request,
  ) => _copyTrading.submitCopyConfirmation(request);

  @override
  TradeCopyAuditExportResult createCopyAuditExport(
    TradeCopyAuditExportRequest request,
  ) => _copyTrading.createCopyAuditExport(request);

  @override
  TradeCopyTradingSnapshot getCopyTrading() => _copyTrading.getCopyTrading();

  @override
  TradeCopyCardDemoSnapshot getCopyCardDemo() => _copyTrading.getCopyCardDemo();

  @override
  TradeCopyEducationSnapshot getCopyEducation() =>
      _copyTrading.getCopyEducation();

  @override
  TradeActiveCopiesSnapshot getActiveCopies() => _copyTrading.getActiveCopies();

  @override
  TradeCopySettingsSnapshot getCopySettings() => _copyTrading.getCopySettings();

  @override
  TradeCopyNotificationsSnapshot getCopyNotifications() =>
      _copyTrading.getCopyNotifications();

  @override
  TradeSafetyEducationSnapshot getSafetyEducation() =>
      _copyTrading.getSafetyEducation();

  @override
  TradeDisputeResolutionSnapshot getDisputeResolution() =>
      _copyTrading.getDisputeResolution();

  @override
  TradeCopySafetyCenterSnapshot getCopySafetyCenter() =>
      _copyTrading.getCopySafetyCenter();

  @override
  TradeCopySettingsSaveResult patchCopySettings(TradeCopySettings settings) =>
      _copyTrading.patchCopySettings(settings);

  @override
  TradeDisputeSubmissionResult submitDisputeComplaint(
    TradeDisputeComplaintDraft draft,
  ) => _copyTrading.submitDisputeComplaint(draft);

  @override
  TradeCopyActionResult submitCopyTradingAction(
    TradeCopyActionRequest request,
  ) => _copyTrading.submitCopyTradingAction(request);
}

// Delegates the whole [TradingBotsRepository] + [TradeBotAnalyticsRepository]
// surface (bot lifecycle, risk management, security, backtesting, portfolio
// analytics, guides/docs) to the independent [MockTradeBotsRepository] owned
// by `trade_bots` (Batch 3 of Phase 3 of the trade module split).
// [TradeRepository] is still a union that includes both interfaces, so
// [MockTradeRepository] must keep satisfying that surface — it now does so
// by forwarding rather than implementing the methods itself, since the 2 bot
// mixins that used to live here moved to `trade_bots` along with their
// fixtures.
mixin _MockTradeRepositoryBotsDelegate on _MockTradeRepositoryBase {
  static const MockTradeBotsRepository _bots = MockTradeBotsRepository();

  @override
  TradeBotsSnapshot getTradingBots() => _bots.getTradingBots();

  @override
  TradeBotTermsSnapshot getBotTermsOfService() => _bots.getBotTermsOfService();

  @override
  TradeBotRiskDisclosureSnapshot getBotRiskDisclosure() =>
      _bots.getBotRiskDisclosure();

  @override
  TradeBotSuitabilityAssessmentSnapshot getBotSuitabilityAssessment() =>
      _bots.getBotSuitabilityAssessment();

  @override
  TradeBotRiskDashboardSnapshot getBotRiskDashboard() =>
      _bots.getBotRiskDashboard();

  @override
  TradeBotEmergencyStopSnapshot getBotEmergencyStop() =>
      _bots.getBotEmergencyStop();

  @override
  TradeBotSecuritySettingsSnapshot getBotSecuritySettings() =>
      _bots.getBotSecuritySettings();

  @override
  TradeBotHistorySnapshot getBotHistory() => _bots.getBotHistory();

  @override
  TradeBotPerformanceAnalyticsSnapshot getBotPerformanceAnalytics() =>
      _bots.getBotPerformanceAnalytics();

  @override
  TradeBotActionResult submitBotAction(TradeBotActionRequest request) =>
      _bots.submitBotAction(request);

  @override
  TradeBotEmergencyStopResult submitBotEmergencyStop(
    TradeBotEmergencyStopDraft draft,
  ) => _bots.submitBotEmergencyStop(draft);

  @override
  TradeBotSecuritySettingsResult patchBotSecuritySettings(
    TradeBotSecuritySettingsDraft draft,
  ) => _bots.patchBotSecuritySettings(draft);

  @override
  TradeBotHistoryExportResult createBotHistoryExport(
    TradeBotHistoryExportRequest request,
  ) => _bots.createBotHistoryExport(request);

  @override
  TradeBotCreateResult createTradingBot(TradeBotCreateRequest request) =>
      _bots.createTradingBot(request);

  @override
  TradeBotBacktestingSnapshot getBotBacktesting() => _bots.getBotBacktesting();

  @override
  TradeBotStrategyCompareSnapshot getBotStrategyCompare() =>
      _bots.getBotStrategyCompare();

  @override
  TradeBotOptimizationSnapshot getBotOptimization() =>
      _bots.getBotOptimization();

  @override
  TradeBotPortfolioDashboardSnapshot getBotPortfolioDashboard() =>
      _bots.getBotPortfolioDashboard();

  @override
  TradeBotDrawdownAnalyzerSnapshot getBotDrawdownAnalyzer() =>
      _bots.getBotDrawdownAnalyzer();

  @override
  TradeBotEquityCurveSnapshot getBotEquityCurve() => _bots.getBotEquityCurve();

  @override
  TradeBotGuideSnapshot getBotGuide() => _bots.getBotGuide();

  @override
  TradeBotFaqSnapshot getBotFaq() => _bots.getBotFaq();

  @override
  TradeBotTaxReportingSnapshot getBotTaxReporting() =>
      _bots.getBotTaxReporting();

  @override
  TradeBotApiDocumentationSnapshot getBotApiDocumentation() =>
      _bots.getBotApiDocumentation();

  @override
  TradeBotBacktestResult runBotBacktest(TradeBotBacktestRequest request) =>
      _bots.runBotBacktest(request);

  @override
  TradeBotOptimizationResult runBotOptimization(
    TradeBotOptimizationRequest request,
  ) => _bots.runBotOptimization(request);

  @override
  TradeBotTaxReportExportResult createBotTaxReportExport(
    TradeBotTaxReportExportRequest request,
  ) => _bots.createBotTaxReportExport(request);
}

// Delegates the whole [SpotTradeRepository] + [TradeFuturesMarginRepository]
// surface (core spot trading, advanced tools, conversions & utilities,
// futures/leverage/margin) to the independent [MockTradeTerminalRepository]
// owned by `trade_terminal` (Batch 3 of Phase 4 of the trade module split —
// the final domain phase). [TradeRepository] is still a union that
// includes both interfaces, so [MockTradeRepository] must keep satisfying
// that surface — it now does so by forwarding rather than implementing the
// methods itself, since the 4 terminal mixins that used to live here moved
// to `trade_terminal` along with their fixtures. This was the last domain
// still implemented directly on this class, so [MockTradeRepository] is
// now a pure 4-way delegation hub with no domain logic of its own.
mixin _MockTradeRepositoryTerminalDelegate on _MockTradeRepositoryBase {
  static const MockTradeTerminalRepository _terminal =
      MockTradeTerminalRepository();

  @override
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'}) =>
      _terminal.getTrade(pairId: pairId);

  @override
  TradeOrdersHistorySnapshot getOrdersHistory() => _terminal.getOrdersHistory();

  @override
  TradeOrderReceiptSnapshot getOrderReceipt() => _terminal.getOrderReceipt();

  @override
  TradeSettingsSnapshot getTradeSettings() => _terminal.getTradeSettings();

  @override
  TradePositionsSnapshot getTradePositions() => _terminal.getTradePositions();

  @override
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo() =>
      _terminal.getAdvancedTradingDemo();

  @override
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics() =>
      _terminal.getAdvancedAnalytics();

  @override
  TradeSettings patchTradeSettings(TradeSettings settings) =>
      _terminal.patchTradeSettings(settings);

  @override
  TradeOrderPreview previewOrder(TradeOrderDraft draft) =>
      _terminal.previewOrder(draft);

  @override
  TradeOrderReceipt submitOrder(TradeOrderDraft draft) =>
      _terminal.submitOrder(draft);

  @override
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  }) => _terminal.submitOrderAction(orderId: orderId, action: action);

  @override
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'}) =>
      _terminal.getAdvancedChart(pairId: pairId);

  @override
  TradeRiskManagementSnapshot getRiskManagement() =>
      _terminal.getRiskManagement();

  @override
  TradeExecutionQualitySnapshot getExecutionQuality() =>
      _terminal.getExecutionQuality();

  @override
  TradeAdvancedToolsSnapshot getAdvancedTools() => _terminal.getAdvancedTools();

  @override
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft) =>
      _terminal.submitOcoOrder(draft);

  @override
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  ) => _terminal.calculatePositionSize(request);

  @override
  TradeSlippageSettings updateSlippageSettings(
    TradeSlippageSettings settings,
  ) => _terminal.updateSlippageSettings(settings);

  @override
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request) =>
      _terminal.amendOrder(request);

  @override
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  ) => _terminal.submitAdvancedToolAction(request);

  @override
  TradeExportSnapshot getTradeExport() => _terminal.getTradeExport();

  @override
  TradeConvertSnapshot getConvert() => _terminal.getConvert();

  @override
  TradeExportResult createTradeExport(TradeExportRequest request) =>
      _terminal.createTradeExport(request);

  @override
  TradeConvertQuote previewConvert(TradeConvertRequest request) =>
      _terminal.previewConvert(request);

  @override
  TradeConvertReceipt submitConvert(TradeConvertRequest request) =>
      _terminal.submitConvert(request);

  @override
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'}) =>
      _terminal.getFutures(pairId: pairId);

  @override
  TradeFuturesLeverageSnapshot getFuturesLeverage({
    String pairId = 'btcusdt',
  }) => _terminal.getFuturesLeverage(pairId: pairId);

  @override
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  }) => _terminal.getMarginTrading(
    pairId: pairId,
    pairRouteVariant: pairRouteVariant,
  );

  @override
  TradeMarginTradingHubSnapshot getMarginTradingHub() =>
      _terminal.getMarginTradingHub();

  @override
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft) =>
      _terminal.previewFuturesOrder(draft);

  @override
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft) =>
      _terminal.submitFuturesOrder(draft);

  @override
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) => _terminal.previewFuturesLeverage(request);

  @override
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) => _terminal.submitFuturesLeverage(request);
}

final class MockTradeRepository
    with
        _MockTradeRepositoryBase,
        _MockTradeRepositoryBotsDelegate,
        _MockTradeRepositoryCopyTradingDelegate,
        _MockTradeRepositoryRegulatoryDelegate,
        _MockTradeRepositoryTerminalDelegate {
  const MockTradeRepository();
}
