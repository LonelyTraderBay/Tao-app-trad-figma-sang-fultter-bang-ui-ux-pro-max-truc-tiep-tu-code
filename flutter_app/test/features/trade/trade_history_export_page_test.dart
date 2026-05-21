import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/trade_history_export_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpTradeExport(
    WidgetTester tester, {
    TradeRepository repository = const MockTradeRepository(),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [tradeRepositoryProvider.overrideWithValue(repository)],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeExport,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-054 mock repository exposes export BE draft', () {
    final repo = const MockTradeRepository();
    final snapshot = repo.getTradeExport();
    final result = repo.createTradeExport(
      const TradeExportRequest(
        format: 'csv',
        period: '30d',
        includeIds: ['spot', 'fees'],
      ),
    );

    expect(snapshot.trade.pairs, hasLength(3));
    expect(snapshot.stats.totalTrades, 847);
    expect(snapshot.stats.totalVolume, 2458300);
    expect(snapshot.stats.totalFees, 2340.56);
    expect(snapshot.stats.netPnl, 12456.78);
    expect(snapshot.formats.map((item) => item.id), ['csv', 'pdf']);
    expect(snapshot.periods.map((item) => item.id), [
      '7d',
      '30d',
      '90d',
      '1y',
      'custom',
    ]);
    expect(snapshot.includes.where((item) => item.checked), hasLength(6));
    expect(result.status, 'ready');
    expect(result.downloadUrl, '/exports/EXP-TRADE-054.csv');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-054 renders export page inside the Trade shell', (
    tester,
  ) async {
    await pumpTradeExport(tester);

    expect(find.byType(TradeHistoryExportPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xuất lịch sử giao dịch'), findsOneWidget);
    expect(find.text('Định dạng file'), findsOneWidget);
    expect(find.text('CSV'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Khoảng thời gian'), findsOneWidget);
    expect(find.text('30 ngày'), findsOneWidget);
    expect(find.text('Bao gồm dữ liệu'), findsOneWidget);
    expect(find.text('Spot Trading'), findsOneWidget);
    expect(find.text('Xuất CSV (30d)'), findsOneWidget);
  });

  testWidgets('SC-054 format and period selections update the CTA', (
    tester,
  ) async {
    await pumpTradeExport(tester);

    await tester.tap(find.byKey(TradeHistoryExportPage.formatKey('pdf')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeHistoryExportPage.periodKey('90d')));
    await tester.pumpAndSettle();

    expect(find.text('Xuất PDF (90d)'), findsOneWidget);
  });

  testWidgets('SC-054 include toggles are sent to export request', (
    tester,
  ) async {
    final repository = _CapturingTradeRepository();
    await pumpTradeExport(tester, repository: repository);

    await tester.tap(find.byKey(TradeHistoryExportPage.includeKey('spot')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeHistoryExportPage.exportKey));
    await tester.pump();
    expect(find.text('Đang tạo file...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 260));
    await tester.pumpAndSettle();

    expect(repository.lastRequest, isNotNull);
    expect(repository.lastRequest!.format, 'csv');
    expect(repository.lastRequest!.period, '30d');
    expect(repository.lastRequest!.includeIds, isNot(contains('spot')));
    expect(repository.lastRequest!.includeIds, contains('fees'));
    expect(find.text('File đã sẵn sàng tải xuống'), findsOneWidget);
    expect(find.text('Tải CSV'), findsOneWidget);
  });

  testWidgets('SC-054 new export resets the ready state', (tester) async {
    await pumpTradeExport(tester);

    await tester.tap(find.byKey(TradeHistoryExportPage.exportKey));
    await tester.pump(const Duration(milliseconds: 260));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeHistoryExportPage.newExportKey));
    await tester.pumpAndSettle();

    expect(find.text('Xuất CSV (30d)'), findsOneWidget);
    expect(find.text('File đã sẵn sàng tải xuống'), findsNothing);
  });
}

class _CapturingTradeRepository implements TradeRepository {
  final MockTradeRepository _delegate = const MockTradeRepository();
  TradeExportRequest? lastRequest;

  @override
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'}) {
    return _delegate.getTrade(pairId: pairId);
  }

  @override
  TradeOrdersHistorySnapshot getOrdersHistory() {
    return _delegate.getOrdersHistory();
  }

  @override
  TradeOrderReceiptSnapshot getOrderReceipt() {
    return _delegate.getOrderReceipt();
  }

  @override
  TradeSettingsSnapshot getTradeSettings() {
    return _delegate.getTradeSettings();
  }

  @override
  TradePositionsSnapshot getTradePositions() {
    return _delegate.getTradePositions();
  }

  @override
  TradeExportSnapshot getTradeExport() {
    return _delegate.getTradeExport();
  }

  @override
  TradeAdvancedChartSnapshot getAdvancedChart({String pairId = 'btcusdt'}) {
    return _delegate.getAdvancedChart(pairId: pairId);
  }

  @override
  TradeConvertSnapshot getConvert() {
    return _delegate.getConvert();
  }

  @override
  TradeFuturesSnapshot getFutures({String pairId = 'btcusdt'}) {
    return _delegate.getFutures(pairId: pairId);
  }

  @override
  TradeFuturesLeverageSnapshot getFuturesLeverage({String pairId = 'btcusdt'}) {
    return _delegate.getFuturesLeverage(pairId: pairId);
  }

  @override
  TradeBotsSnapshot getTradingBots() {
    return _delegate.getTradingBots();
  }

  @override
  TradeRiskManagementSnapshot getRiskManagement() {
    return _delegate.getRiskManagement();
  }

  @override
  TradeExecutionQualitySnapshot getExecutionQuality() {
    return _delegate.getExecutionQuality();
  }

  @override
  TradeAdvancedToolsSnapshot getAdvancedTools() {
    return _delegate.getAdvancedTools();
  }

  @override
  TradeCopyTradingSnapshot getCopyTrading() {
    return _delegate.getCopyTrading();
  }

  @override
  TradeCopyTradingV2Snapshot getCopyTradingV2() {
    return _delegate.getCopyTradingV2();
  }

  @override
  TradeCopyEducationSnapshot getCopyEducation() {
    return _delegate.getCopyEducation();
  }

  @override
  TradeActiveCopiesSnapshot getActiveCopies() {
    return _delegate.getActiveCopies();
  }

  @override
  TradeCopySettingsSnapshot getCopySettings() {
    return _delegate.getCopySettings();
  }

  @override
  TradeCopyNotificationsSnapshot getCopyNotifications() {
    return _delegate.getCopyNotifications();
  }

  @override
  TradeProviderApplicationSnapshot getProviderApplication() {
    return _delegate.getProviderApplication();
  }

  @override
  TradeCopyProviderDetailSnapshot getCopyProviderDetail({
    String providerId = 'provider001',
  }) {
    return _delegate.getCopyProviderDetail(providerId: providerId);
  }

  @override
  TradePreCopyAssessmentSnapshot getPreCopyAssessment({
    String providerId = 'provider001',
  }) {
    return _delegate.getPreCopyAssessment(providerId: providerId);
  }

  @override
  TradeCopyConfigurationSnapshot getCopyConfiguration({
    String providerId = 'provider001',
  }) {
    return _delegate.getCopyConfiguration(providerId: providerId);
  }

  @override
  TradeCopyConfirmationSnapshot getCopyConfirmation({
    String providerId = 'provider001',
  }) {
    return _delegate.getCopyConfirmation(providerId: providerId);
  }

  @override
  TradeCopyPerformanceSnapshot getCopyPerformance({String copyId = 'copy001'}) {
    return _delegate.getCopyPerformance(copyId: copyId);
  }

  @override
  TradePerformanceAttributionSnapshot getPerformanceAttribution({
    String copyId = 'copy001',
  }) {
    return _delegate.getPerformanceAttribution(copyId: copyId);
  }

  @override
  TradeProviderComparisonSnapshot getProviderComparison() {
    return _delegate.getProviderComparison();
  }

  @override
  TradeCopyAuditLogSnapshot getCopyAuditLog({String copyId = 'copy001'}) {
    return _delegate.getCopyAuditLog(copyId: copyId);
  }

  @override
  TradePortfolioRiskAnalysisSnapshot getPortfolioRiskAnalysis() {
    return _delegate.getPortfolioRiskAnalysis();
  }

  @override
  TradeProviderLeaderboardSnapshot getProviderLeaderboard() {
    return _delegate.getProviderLeaderboard();
  }

  @override
  TradeSafetyEducationSnapshot getSafetyEducation() {
    return _delegate.getSafetyEducation();
  }

  @override
  TradeProviderGovernanceSnapshot getProviderGovernance() {
    return _delegate.getProviderGovernance();
  }

  @override
  TradeDisputeResolutionSnapshot getDisputeResolution() {
    return _delegate.getDisputeResolution();
  }

  @override
  TradeCopySafetyCenterSnapshot getCopySafetyCenter() {
    return _delegate.getCopySafetyCenter();
  }

  @override
  TradeRegulatoryDisclosuresSnapshot getRegulatoryDisclosures() {
    return _delegate.getRegulatoryDisclosures();
  }

  @override
  TradeMarginTradingSnapshot getMarginTrading({
    String pairId = 'btcusdt',
    bool pairRouteVariant = false,
  }) {
    return _delegate.getMarginTrading(
      pairId: pairId,
      pairRouteVariant: pairRouteVariant,
    );
  }

  @override
  TradeTraderProfileSnapshot getTraderProfile({String traderId = 'trader001'}) {
    return _delegate.getTraderProfile(traderId: traderId);
  }

  @override
  TradeAdvancedTradingDemoSnapshot getAdvancedTradingDemo() {
    return _delegate.getAdvancedTradingDemo();
  }

  @override
  TradeMarketDataAnalyticsSnapshot getMarketDataAnalytics() {
    return _delegate.getMarketDataAnalytics();
  }

  @override
  TradeMarginTradingHubSnapshot getMarginTradingHub() {
    return _delegate.getMarginTradingHub();
  }

  @override
  TradeMarketDataAnalyticsSnapshot getLiveMarketDataAnalytics() {
    return _delegate.getLiveMarketDataAnalytics();
  }

  @override
  TradeAdvancedAnalyticsSnapshot getAdvancedAnalytics() {
    return _delegate.getAdvancedAnalytics();
  }

  @override
  TradeTransactionReportingSnapshot getTransactionReporting() {
    return _delegate.getTransactionReporting();
  }

  @override
  TradeRegulatoryReportsDashboardSnapshot getRegulatoryReportsDashboard() {
    return _delegate.getRegulatoryReportsDashboard();
  }

  @override
  TradeArmIntegrationStatusSnapshot getArmIntegrationStatus() {
    return _delegate.getArmIntegrationStatus();
  }

  @override
  TradeBestExecutionReportsSnapshot getBestExecutionReports() {
    return _delegate.getBestExecutionReports();
  }

  @override
  TradeExecutionVenueAnalysisSnapshot getExecutionVenueAnalysis() {
    return _delegate.getExecutionVenueAnalysis();
  }

  @override
  TradeSlippageMonitoringSnapshot getSlippageMonitoring() {
    return _delegate.getSlippageMonitoring();
  }

  @override
  TradeClientCategorizationSnapshot getClientCategorization() {
    return _delegate.getClientCategorization();
  }

  @override
  TradeProductGovernanceSnapshot getProductGovernance() {
    return _delegate.getProductGovernance();
  }

  @override
  TradeTargetMarketDefinitionSnapshot getTargetMarketDefinition({
    String productId = 'prod-1',
  }) {
    return _delegate.getTargetMarketDefinition(productId: productId);
  }

  @override
  TradeClientMoneyProtectionSnapshot getClientMoneyProtection() {
    return _delegate.getClientMoneyProtection();
  }

  @override
  TradeCassReconciliationSnapshot getCassReconciliation() {
    return _delegate.getCassReconciliation();
  }

  @override
  TradeInvestorCompensationSnapshot getInvestorCompensation() {
    return _delegate.getInvestorCompensation();
  }

  @override
  TradeExAnteCostsSnapshot getExAnteCosts() {
    return _delegate.getExAnteCosts();
  }

  @override
  TradeRiyCalculatorSnapshot getRiyCalculator() {
    return _delegate.getRiyCalculator();
  }

  @override
  TradeExPostCostsReportSnapshot getExPostCostsReport() {
    return _delegate.getExPostCostsReport();
  }

  @override
  TradeKidGeneratorSnapshot getKidGenerator() {
    return _delegate.getKidGenerator();
  }

  @override
  TradePerformanceScenariosSnapshot getPerformanceScenarios() {
    return _delegate.getPerformanceScenarios();
  }

  @override
  TradeRiskIndicatorSnapshot getRiskIndicatorExplainer() {
    return _delegate.getRiskIndicatorExplainer();
  }

  @override
  TradeComplaintsHandlingSnapshot getComplaintsHandling() {
    return _delegate.getComplaintsHandling();
  }

  @override
  TradeSettings patchTradeSettings(TradeSettings settings) {
    return _delegate.patchTradeSettings(settings);
  }

  @override
  TradeCopySettingsSaveResult patchCopySettings(TradeCopySettings settings) {
    return _delegate.patchCopySettings(settings);
  }

  @override
  TradeProviderApplicationResult submitProviderApplication(
    TradeProviderApplicationDraft draft,
  ) {
    return _delegate.submitProviderApplication(draft);
  }

  @override
  TradeCopyAuditExportResult createCopyAuditExport(
    TradeCopyAuditExportRequest request,
  ) {
    return _delegate.createCopyAuditExport(request);
  }

  @override
  TradeDisputeSubmissionResult submitDisputeComplaint(
    TradeDisputeComplaintDraft draft,
  ) {
    return _delegate.submitDisputeComplaint(draft);
  }

  @override
  TradeCopyConfigurationPreview previewCopyConfiguration(
    TradeCopyConfigurationDraft draft,
  ) {
    return _delegate.previewCopyConfiguration(draft);
  }

  @override
  TradeCopyConfirmationResult submitCopyConfirmation(
    TradeCopyConfirmationRequest request,
  ) {
    return _delegate.submitCopyConfirmation(request);
  }

  @override
  TradeExportResult createTradeExport(TradeExportRequest request) {
    lastRequest = request;
    return _delegate.createTradeExport(request);
  }

  @override
  TradeExPostCostsReportExportResult createExPostCostsReportExport({
    int year = 2025,
  }) {
    return _delegate.createExPostCostsReportExport(year: year);
  }

  @override
  TradeConvertQuote previewConvert(TradeConvertRequest request) {
    return _delegate.previewConvert(request);
  }

  @override
  TradeConvertReceipt submitConvert(TradeConvertRequest request) {
    return _delegate.submitConvert(request);
  }

  @override
  TradeFuturesPreview previewFuturesOrder(TradeFuturesOrderDraft draft) {
    return _delegate.previewFuturesOrder(draft);
  }

  @override
  TradeFuturesReceipt submitFuturesOrder(TradeFuturesOrderDraft draft) {
    return _delegate.submitFuturesOrder(draft);
  }

  @override
  TradeFuturesLeveragePreview previewFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    return _delegate.previewFuturesLeverage(request);
  }

  @override
  TradeFuturesLeverageReceipt submitFuturesLeverage(
    TradeFuturesLeverageRequest request,
  ) {
    return _delegate.submitFuturesLeverage(request);
  }

  @override
  TradeBotActionResult submitBotAction(TradeBotActionRequest request) {
    return _delegate.submitBotAction(request);
  }

  @override
  TradeBotCreateResult createTradingBot(TradeBotCreateRequest request) {
    return _delegate.createTradingBot(request);
  }

  @override
  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft) {
    return _delegate.submitOcoOrder(draft);
  }

  @override
  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  ) {
    return _delegate.calculatePositionSize(request);
  }

  @override
  TradeSlippageSettings updateSlippageSettings(TradeSlippageSettings settings) {
    return _delegate.updateSlippageSettings(settings);
  }

  @override
  TradeOrderAmendmentResult amendOrder(TradeOrderAmendmentRequest request) {
    return _delegate.amendOrder(request);
  }

  @override
  TradeAdvancedToolActionResult submitAdvancedToolAction(
    TradeAdvancedToolActionRequest request,
  ) {
    return _delegate.submitAdvancedToolAction(request);
  }

  @override
  TradeCopyActionResult submitCopyTradingAction(
    TradeCopyActionRequest request,
  ) {
    return _delegate.submitCopyTradingAction(request);
  }

  @override
  TradeOrderPreview previewOrder(TradeOrderDraft draft) {
    return _delegate.previewOrder(draft);
  }

  @override
  TradeOrderReceipt submitOrder(TradeOrderDraft draft) {
    return _delegate.submitOrder(draft);
  }

  @override
  TradeOrderActionResult submitOrderAction({
    required String orderId,
    required String action,
  }) {
    return _delegate.submitOrderAction(orderId: orderId, action: action);
  }
}
