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
      test('getTrade / getOrdersHistory / getOrderReceipt', () async {
        expect(await repo.getTrade(), isA<TradeScreenSnapshot>());
        expect(
          await repo.getTrade(pairId: 'ethusdt'),
          isA<TradeScreenSnapshot>(),
        );
        expect(
          await repo.getOrdersHistory(),
          isA<TradeOrdersHistorySnapshot>(),
        );
        expect(await repo.getOrderReceipt(), isA<TradeOrderReceiptSnapshot>());
      });

      test('getTradeSettings / getTradePositions / getTradeExport', () async {
        expect(await repo.getTradeSettings(), isA<TradeSettingsSnapshot>());
        final positions = await repo.getTradePositions();
        expect(positions, isA<TradePositionsSnapshot>());
        expect(positions.positions, hasLength(6));
        expect(await repo.getTradeExport(), isA<TradeExportSnapshot>());
      });

      test(
        'getAdvancedChart / getConvert / getFutures / getFuturesLeverage',
        () async {
          expect(
            await repo.getAdvancedChart(),
            isA<TradeAdvancedChartSnapshot>(),
          );
          expect(
            await repo.getAdvancedChart(pairId: 'ethusdt'),
            isA<TradeAdvancedChartSnapshot>(),
          );
          expect(await repo.getConvert(), isA<TradeConvertSnapshot>());
          final futures = await repo.getFutures();
          expect(futures, isA<TradeFuturesSnapshot>());
          expect(futures.positions, hasLength(2));
          expect(
            await repo.getFutures(pairId: 'ethusdt'),
            isA<TradeFuturesSnapshot>(),
          );
          expect(
            await repo.getFuturesLeverage(),
            isA<TradeFuturesLeverageSnapshot>(),
          );
          expect(
            await repo.getFuturesLeverage(pairId: 'ethusdt'),
            isA<TradeFuturesLeverageSnapshot>(),
          );
        },
      );

      test(
        'getRiskManagement / getExecutionQuality / getAdvancedTools',
        () async {
          expect(
            await repo.getRiskManagement(),
            isA<TradeRiskManagementSnapshot>(),
          );
          expect(
            await repo.getExecutionQuality(),
            isA<TradeExecutionQualitySnapshot>(),
          );
          expect(
            await repo.getAdvancedTools(),
            isA<TradeAdvancedToolsSnapshot>(),
          );
        },
      );

      test(
        'getMarginTrading / getMarginTradingHub / getAdvancedTradingDemo / getAdvancedAnalytics',
        () async {
          expect(
            await repo.getMarginTrading(),
            isA<TradeMarginTradingSnapshot>(),
          );
          expect(
            await repo.getMarginTrading(
              pairId: 'ethusdt',
              pairRouteVariant: true,
            ),
            isA<TradeMarginTradingSnapshot>(),
          );
          expect(
            await repo.getMarginTradingHub(),
            isA<TradeMarginTradingHubSnapshot>(),
          );
          expect(
            await repo.getAdvancedTradingDemo(),
            isA<TradeAdvancedTradingDemoSnapshot>(),
          );
          expect(
            await repo.getAdvancedAnalytics(),
            isA<TradeAdvancedAnalyticsSnapshot>(),
          );
        },
      );
    });

    group('write / action methods', () {
      test('patchTradeSettings', () async {
        final settings = (await repo.getTradeSettings()).settings;
        final result = await repo.patchTradeSettings(settings);
        expect(result, isA<TradeSettings>());
        expect(result.defaultOrderType, 'limit');
      });

      test('createTradeExport', () async {
        final result = await repo.createTradeExport(
          const TradeExportRequest(
            format: 'csv',
            period: '30d',
            includeIds: ['spot', 'fees'],
          ),
        );
        expect(result, isA<TradeExportResult>());
      });

      test('previewConvert / submitConvert', () async {
        const request = TradeConvertRequest(
          fromSymbol: 'USDT',
          toSymbol: 'BTC',
          amount: 500,
          slippagePct: .5,
          mode: 'market',
        );
        expect(await repo.previewConvert(request), isA<TradeConvertQuote>());
        expect(await repo.submitConvert(request), isA<TradeConvertReceipt>());
      });

      test('previewFuturesOrder / submitFuturesOrder', () async {
        const draft = TradeFuturesOrderDraft(
          pairId: 'btcusdt',
          side: TradeFuturesSide.long,
          type: TradeFuturesOrderType.market,
          margin: 500,
          leverage: 10,
        );
        expect(
          await repo.previewFuturesOrder(draft),
          isA<TradeFuturesPreview>(),
        );
        expect(
          await repo.submitFuturesOrder(draft),
          isA<TradeFuturesReceipt>(),
        );
      });

      test('previewFuturesLeverage / submitFuturesLeverage', () async {
        expect(
          await repo.previewFuturesLeverage(
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

      test('submitOcoOrder', () async {
        final result = await repo.submitOcoOrder(
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

      test('calculatePositionSize', () async {
        final result = await repo.calculatePositionSize(
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

      test('updateSlippageSettings', () async {
        final current = (await repo.getExecutionQuality()).slippageSettings;
        final result = await repo.updateSlippageSettings(current);
        expect(result, isA<TradeSlippageSettings>());
      });

      test('amendOrder', () async {
        final result = await repo.amendOrder(
          const TradeOrderAmendmentRequest(
            orderId: 'ord001',
            newPrice: 69000,
            newAmount: .02,
          ),
        );
        expect(result, isA<TradeOrderAmendmentResult>());
        expect(result.queuePositionPreserved, isTrue);
      });

      test('submitAdvancedToolAction', () async {
        final result = await repo.submitAdvancedToolAction(
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
        final preview = await repo.previewOrder(draft);
        expect(preview, isA<TradeOrderPreview>());
        expect(preview.total, closeTo(6754.321, .001));
        final receipt = await repo.submitOrder(draft);
        expect(receipt, isA<TradeOrderReceipt>());
      });

      test('submitOrderAction', () async {
        final result = await repo.submitOrderAction(
          orderId: 'ord-open-001',
          action: 'cancel',
        );
        expect(result, isA<TradeOrderActionResult>());
        expect(result.status, 'success');
      });
    });
  });
}
