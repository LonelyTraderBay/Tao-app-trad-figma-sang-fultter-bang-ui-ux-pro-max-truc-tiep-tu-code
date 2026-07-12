// Smoke test for MockTradeRepository (write / action methods slice):
// exercises TradeRepository's mutating/action methods against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Split from mock_trade_repository_test.dart by behavior group to keep each
// file under the repo's 400-line test-file size gate. See
// mock_trade_repository_core_test.dart, _copy_test.dart, _regulatory_test.dart
// and _bots_test.dart for the other slices of this smoke test suite.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

void main() {
  const repo = MockTradeRepository();

  group('MockTradeRepository smoke test', () {
    group('write / action methods', () {
      test('patchTradeSettings', () {
        final settings = repo.getTradeSettings().settings;
        final result = repo.patchTradeSettings(settings);
        expect(result, isA<TradeSettings>());
        expect(result.defaultOrderType, 'limit');
      });

      test('patchCopySettings', () {
        final snapshot = repo.getCopySettings();
        final updated = snapshot.settings.copyWith(defaultCopyRatio: 60);
        final result = repo.patchCopySettings(updated);
        expect(result, isA<TradeCopySettingsSaveResult>());
        expect(result.status, 'saved');
      });

      test('previewCopyConfiguration', () {
        final found = repo.getCopyConfiguration(providerId: 'provider001');
        final preview = repo.previewCopyConfiguration(found.defaultDraft);
        expect(preview, isA<TradeCopyConfigurationPreview>());
        expect(preview.status, 'ready');
      });

      test('submitCopyConfirmation', () {
        final found = repo.getCopyConfirmation(providerId: 'ct001');
        final accepted = repo.submitCopyConfirmation(
          TradeCopyConfirmationRequest(
            providerId: 'ct001',
            configuration: found.configuration,
            acceptedConsentIds: found.consentItems
                .map((item) => item.id)
                .toList(),
          ),
        );
        expect(accepted, isA<TradeCopyConfirmationResult>());
      });

      test('submitProviderApplication', () {
        final snapshot = repo.getProviderApplication();
        final result = repo.submitProviderApplication(snapshot.defaultDraft);
        expect(result, isA<TradeProviderApplicationResult>());
        expect(result.status, 'submitted');
      });

      test('createCopyAuditExport', () {
        final result = repo.createCopyAuditExport(
          const TradeCopyAuditExportRequest(
            copyId: 'copy001',
            format: 'csv',
            filterId: 'all',
            searchQuery: '',
          ),
        );
        expect(result, isA<TradeCopyAuditExportResult>());
      });

      test('submitDisputeComplaint', () {
        final result = repo.submitDisputeComplaint(
          const TradeDisputeComplaintDraft(
            complaintType: 'execution_issue',
            providerId: 'trader-2',
            subject: 'Excessive slippage',
            description: 'Provider executed at a materially different price.',
          ),
        );
        expect(result, isA<TradeDisputeSubmissionResult>());
        expect(result.status, 'submitted');
      });

      test('createTradeExport', () {
        final result = repo.createTradeExport(
          const TradeExportRequest(
            format: 'csv',
            period: '30d',
            includeIds: ['spot', 'fees'],
          ),
        );
        expect(result, isA<TradeExportResult>());
      });

      test('createBotTaxReportExport', () {
        final result = repo.createBotTaxReportExport(
          const TradeBotTaxReportExportRequest(
            year: '2025',
            reportTypeIds: ['irs-8949', 'turbotax'],
            costBasisMethod: 'FIFO',
          ),
        );
        expect(result, isA<TradeBotTaxReportExportResult>());
      });

      test('createExPostCostsReportExport', () {
        final result = repo.createExPostCostsReportExport();
        expect(result, isA<TradeExPostCostsReportExportResult>());
        expect(
          repo.createExPostCostsReportExport(year: 2024),
          isA<TradeExPostCostsReportExportResult>(),
        );
      });

      test('previewConvert / submitConvert', () {
        const request = TradeConvertRequest(
          fromSymbol: 'USDT',
          toSymbol: 'BTC',
          amount: 500,
          slippagePct: .5,
          mode: 'market',
        );
        expect(repo.previewConvert(request), isA<TradeConvertQuote>());
        expect(repo.submitConvert(request), isA<TradeConvertReceipt>());
      });

      test('previewFuturesOrder / submitFuturesOrder', () {
        const draft = TradeFuturesOrderDraft(
          pairId: 'btcusdt',
          side: TradeFuturesSide.long,
          type: TradeFuturesOrderType.market,
          margin: 500,
          leverage: 10,
        );
        expect(repo.previewFuturesOrder(draft), isA<TradeFuturesPreview>());
        expect(repo.submitFuturesOrder(draft), isA<TradeFuturesReceipt>());
      });

      test('previewFuturesLeverage / submitFuturesLeverage', () {
        expect(
          repo.previewFuturesLeverage(
            const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 10),
          ),
          isA<TradeFuturesLeveragePreview>(),
        );
        expect(
          repo.submitFuturesLeverage(
            const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 50),
          ),
          isA<TradeFuturesLeverageReceipt>(),
        );
      });

      test('submitBotAction / createTradingBot', () {
        final action = repo.submitBotAction(
          const TradeBotActionRequest(botId: 'bot1', action: 'pause'),
        );
        expect(action, isA<TradeBotActionResult>());
        final created = repo.createTradingBot(
          const TradeBotCreateRequest(
            strategyId: 'dca',
            params: {'pair': 'BTC/USDT'},
          ),
        );
        expect(created, isA<TradeBotCreateResult>());
      });

      test('submitBotEmergencyStop', () {
        final result = repo.submitBotEmergencyStop(
          const TradeBotEmergencyStopDraft(
            reasonId: 'crash',
            closePositions: true,
            confirmed: true,
          ),
        );
        expect(result, isA<TradeBotEmergencyStopResult>());
      });

      test('patchBotSecuritySettings', () {
        final result = repo.patchBotSecuritySettings(
          const TradeBotSecuritySettingsDraft(twoFaEnabled: false),
        );
        expect(result, isA<TradeBotSecuritySettingsResult>());
        expect(result.status, 'saved');
      });

      test('createBotHistoryExport', () {
        final export = repo.createBotHistoryExport(
          const TradeBotHistoryExportRequest(format: 'csv'),
        );
        expect(export, isA<TradeBotHistoryExportResult>());
      });

      test('runBotBacktest', () {
        final result = repo.runBotBacktest(
          const TradeBotBacktestRequest(
            strategyId: 'grid',
            pair: 'BTC/USDT',
            dateRangeId: '6m',
            initialCapital: 1000,
          ),
        );
        expect(result, isA<TradeBotBacktestResult>());
      });

      test('runBotOptimization', () {
        final result = repo.runBotOptimization(
          const TradeBotOptimizationRequest(
            targetId: 'sharpe',
            gridCount: 25,
            gridRangePct: 35,
          ),
        );
        expect(result, isA<TradeBotOptimizationResult>());
      });

      test('submitOcoOrder', () {
        final result = repo.submitOcoOrder(
          const TradeOcoOrderDraft(
            symbol: 'BTC/USDT',
            side: TradeOrderSide.buy,
            quantity: .015,
            limitPrice: 69000,
            takeProfitPrice: 72000,
            stopPrice: 66000,
          ),
        );
        expect(result, isA<TradeOcoOrderResult>());
        expect(result.status, isNotEmpty);
      });

      test('calculatePositionSize', () {
        final result = repo.calculatePositionSize(
          const TradePositionSizeRequest(
            accountBalance: 50000,
            riskPct: 1,
            entryPrice: 69000,
            stopPrice: 67500,
          ),
        );
        expect(result, isA<TradePositionSizeResult>());
        expect(result.suggestedAmount, greaterThan(0));
      });

      test('updateSlippageSettings', () {
        final current = repo.getExecutionQuality().slippageSettings;
        final result = repo.updateSlippageSettings(current);
        expect(result, isA<TradeSlippageSettings>());
      });

      test('amendOrder', () {
        final result = repo.amendOrder(
          const TradeOrderAmendmentRequest(
            orderId: 'ord001',
            newPrice: 69000,
            newAmount: .02,
          ),
        );
        expect(result, isA<TradeOrderAmendmentResult>());
        expect(result.queuePositionPreserved, isTrue);
      });

      test('submitAdvancedToolAction', () {
        final result = repo.submitAdvancedToolAction(
          const TradeAdvancedToolActionRequest(
            toolId: 'bulk',
            action: 'cancel',
            orderIds: ['o1', 'o2'],
          ),
        );
        expect(result, isA<TradeAdvancedToolActionResult>());
      });

      test('submitCopyTradingAction', () {
        final result = repo.submitCopyTradingAction(
          const TradeCopyActionRequest(providerId: 'ct001', action: 'follow'),
        );
        expect(result, isA<TradeCopyActionResult>());
      });

      test('previewOrder / submitOrder', () {
        const draft = TradeOrderDraft(
          pairId: 'btcusdt',
          side: TradeOrderSide.buy,
          type: TradeOrderType.limit,
          price: 67543.21,
          amount: .1,
        );
        final preview = repo.previewOrder(draft);
        expect(preview, isA<TradeOrderPreview>());
        expect(preview.total, closeTo(6754.321, .001));
        final receipt = repo.submitOrder(draft);
        expect(receipt, isA<TradeOrderReceipt>());
      });

      test('submitOrderAction', () {
        final result = repo.submitOrderAction(
          orderId: 'ord-open-001',
          action: 'cancel',
        );
        expect(result, isA<TradeOrderActionResult>());
        expect(result.status, 'success');
      });
    });
  });
}
