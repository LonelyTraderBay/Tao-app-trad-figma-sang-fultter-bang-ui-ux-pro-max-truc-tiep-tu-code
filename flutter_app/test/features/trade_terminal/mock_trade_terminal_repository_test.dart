// Smoke test for MockTradeTerminalRepository: exercises SpotTradeRepository
// and TradeFuturesMarginRepository's getters/actions against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Phase 6 (2026-07-15): redistributed here from the deleted
// `trade_core`/`MockTradeRepository` union's
// mock_trade_repository_core_test.dart / _regulatory_test.dart /
// _actions_test.dart — this file now covers every method the old union
// delegated to its terminal slice (`trade`'s own `MockTradeRepository`
// delegates to this exact same class, so this coverage applies to both).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';

void main() {
  const repo = MockTradeTerminalRepository(loadDelay: Duration.zero);

  group('MockTradeTerminalRepository smoke test', () {
    group('getters', () {
      test('getTrade / getOrdersHistory / getOrderReceipt', () {
        expect(repo.getTrade(), isA<TradeScreenSnapshot>());
        expect(repo.getTrade(pairId: 'ethusdt'), isA<TradeScreenSnapshot>());
        expect(repo.getOrdersHistory(), isA<TradeOrdersHistorySnapshot>());
        expect(repo.getOrderReceipt(), isA<TradeOrderReceiptSnapshot>());
      });

      test('getTradeSettings / getTradePositions / getTradeExport', () {
        expect(repo.getTradeSettings(), isA<TradeSettingsSnapshot>());
        final positions = repo.getTradePositions();
        expect(positions, isA<TradePositionsSnapshot>());
        expect(positions.positions, hasLength(6));
        expect(repo.getTradeExport(), isA<TradeExportSnapshot>());
      });

      test(
        'getAdvancedChart / getConvert / getFutures / getFuturesLeverage',
        () {
          expect(repo.getAdvancedChart(), isA<TradeAdvancedChartSnapshot>());
          expect(
            repo.getAdvancedChart(pairId: 'ethusdt'),
            isA<TradeAdvancedChartSnapshot>(),
          );
          expect(repo.getConvert(), isA<TradeConvertSnapshot>());
          final futures = repo.getFutures();
          expect(futures, isA<TradeFuturesSnapshot>());
          expect(futures.positions, hasLength(2));
          expect(
            repo.getFutures(pairId: 'ethusdt'),
            isA<TradeFuturesSnapshot>(),
          );
          expect(
            repo.getFuturesLeverage(),
            isA<TradeFuturesLeverageSnapshot>(),
          );
          expect(
            repo.getFuturesLeverage(pairId: 'ethusdt'),
            isA<TradeFuturesLeverageSnapshot>(),
          );
        },
      );

      test('getRiskManagement / getExecutionQuality / getAdvancedTools', () {
        expect(repo.getRiskManagement(), isA<TradeRiskManagementSnapshot>());
        expect(
          repo.getExecutionQuality(),
          isA<TradeExecutionQualitySnapshot>(),
        );
        expect(repo.getAdvancedTools(), isA<TradeAdvancedToolsSnapshot>());
      });

      test(
        'getMarginTrading / getMarginTradingHub / getAdvancedTradingDemo / getAdvancedAnalytics',
        () {
          expect(repo.getMarginTrading(), isA<TradeMarginTradingSnapshot>());
          expect(
            repo.getMarginTrading(pairId: 'ethusdt', pairRouteVariant: true),
            isA<TradeMarginTradingSnapshot>(),
          );
          expect(
            repo.getMarginTradingHub(),
            isA<TradeMarginTradingHubSnapshot>(),
          );
          expect(
            repo.getAdvancedTradingDemo(),
            isA<TradeAdvancedTradingDemoSnapshot>(),
          );
          expect(
            repo.getAdvancedAnalytics(),
            isA<TradeAdvancedAnalyticsSnapshot>(),
          );
        },
      );
    });

    group('write / action methods', () {
      test('patchTradeSettings', () {
        final settings = repo.getTradeSettings().settings;
        final result = repo.patchTradeSettings(settings);
        expect(result, isA<TradeSettings>());
        expect(result.defaultOrderType, 'limit');
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

      test('previewFuturesOrder / submitFuturesOrder', () async {
        const draft = TradeFuturesOrderDraft(
          pairId: 'btcusdt',
          side: TradeFuturesSide.long,
          type: TradeFuturesOrderType.market,
          margin: 500,
          leverage: 10,
        );
        expect(repo.previewFuturesOrder(draft), isA<TradeFuturesPreview>());
        expect(
          await repo.submitFuturesOrder(draft),
          isA<TradeFuturesReceipt>(),
        );
      });

      test('previewFuturesLeverage / submitFuturesLeverage', () async {
        expect(
          repo.previewFuturesLeverage(
            const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 10),
          ),
          isA<TradeFuturesLeveragePreview>(),
        );
        expect(
          await repo.submitFuturesLeverage(
            const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 50),
          ),
          isA<TradeFuturesLeverageReceipt>(),
        );
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

      test('previewOrder / submitOrder', () async {
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
        final receipt = await repo.submitOrder(draft);
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
