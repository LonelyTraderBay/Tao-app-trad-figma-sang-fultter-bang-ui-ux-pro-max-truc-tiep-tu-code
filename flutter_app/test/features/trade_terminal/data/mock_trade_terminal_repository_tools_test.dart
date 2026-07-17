// Fixture-value smoke test for MockTradeTerminalRepository's advanced
// tools slice (bracket/OCO orders, position sizing, slippage, order
// amendment, bulk actions) and conversions/utilities slice (export,
// convert) of SpotTradeRepository. Neither slice carries a
// highRiskContractId (see mock_trade_terminal_repository_core_test.dart
// for the core spot + futures/margin slice, which does).
//
// test/features/trade_terminal/mock_trade_terminal_repository_test.dart
// already exercises every method with `isA<...>()` smoke checks; this file
// complements that (TEST-HR4) with literal pins read straight from
// lib/features/trade_terminal/data/fixtures/trade_advanced_tools_repository_methods.dart
// and trade_conversions_utilities_repository_methods.dart.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';

void main() {
  const repo = MockTradeTerminalRepository(loadDelay: Duration.zero);

  group(
    'MockTradeTerminalRepository advanced tools + conversions smoke test',
    () {
      group('advanced tools getters', () {
        test(
          'getAdvancedChart / getRiskManagement return populated snapshots',
          () {
            final chart = repo.getAdvancedChart();
            expect(chart.candles, isNotEmpty);
            expect(chart.indicators, isNotEmpty);
            expect(chart.timeframes, contains('1D'));

            final risk = repo.getRiskManagement();
            expect(risk.accountBalance, 50000);
            expect(risk.currentPrice, 69000);
            expect(risk.features, isNotEmpty);
          },
        );

        test(
          'getExecutionQuality / getAdvancedTools return populated snapshots',
          () {
            final quality = repo.getExecutionQuality();
            expect(quality.features, isNotEmpty);
            expect(quality.slippageSettings, isNotNull);

            final tools = repo.getAdvancedTools();
            expect(tools.ladderOrders, isNotEmpty);
            expect(tools.bulkOrders, isNotEmpty);
            expect(tools.shortcuts, isNotEmpty);
          },
        );
      });

      group('advanced tools actions', () {
        test('submitOcoOrder pins the generated order id and status', () {
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
          expect(result.orderId, 'OCO-DEMO-060');
          expect(result.symbol, 'BTC/USDT');
          expect(result.status, 'submitted');
        });

        test('calculatePositionSize pins the risk-based computation', () {
          final result = repo.calculatePositionSize(
            const TradePositionSizeRequest(
              accountBalance: 50000,
              riskPct: 1,
              entryPrice: 69000,
              stopPrice: 67500,
            ),
          );
          expect(result.riskAmount, 500);
          expect(result.perUnitRisk, 1500);
          expect(result.suggestedAmount, closeTo(.3333, .001));
        });

        test('updateSlippageSettings echoes the settings back unchanged', () {
          final current = repo.getExecutionQuality().slippageSettings;
          final result = repo.updateSlippageSettings(current);
          expect(result, current);
        });

        test(
          'amendOrder pins the modified status and preserved queue position',
          () {
            final result = repo.amendOrder(
              const TradeOrderAmendmentRequest(
                orderId: 'ord001',
                newPrice: 69000,
                newAmount: .02,
              ),
            );
            expect(result.orderId, 'ord001');
            expect(result.status, 'modified');
            expect(result.queuePositionPreserved, isTrue);
          },
        );

        test('submitAdvancedToolAction pins the affected order count', () {
          final result = repo.submitAdvancedToolAction(
            const TradeAdvancedToolActionRequest(
              toolId: 'bulk',
              action: 'cancel',
              orderIds: ['o1', 'o2'],
            ),
          );
          expect(result.status, 'accepted');
          expect(result.affectedCount, 2);
        });
      });

      group('conversions & utilities getters', () {
        test('getTradeExport / getConvert return fixture-backed snapshots', () {
          final export = repo.getTradeExport();
          expect(export.stats.totalTrades, 847);
          expect(export.formats, isNotEmpty);

          final convert = repo.getConvert();
          expect(convert.fromAsset.symbol, 'USDT');
          expect(convert.toAsset.symbol, 'BTC');
          expect(convert.minUsd, 10);
          expect(convert.maxUsd, 500000);
        });
      });

      group('conversions & utilities actions', () {
        test('createTradeExport pins the generated export id', () {
          final result = repo.createTradeExport(
            const TradeExportRequest(
              format: 'csv',
              period: '30d',
              includeIds: ['spot', 'fees'],
            ),
          );
          expect(result.exportId, 'EXP-TRADE-054');
          expect(result.status, 'ready');
          expect(result.downloadUrl, '/exports/EXP-TRADE-054.csv');
        });

        test('previewConvert / submitConvert pin the generated convert id', () {
          const request = TradeConvertRequest(
            fromSymbol: 'USDT',
            toSymbol: 'BTC',
            amount: 500,
            slippagePct: .5,
            mode: 'market',
          );
          final quote = repo.previewConvert(request);
          expect(quote.fromSymbol, 'USDT');
          expect(quote.toSymbol, 'BTC');
          expect(quote.canSubmit, isTrue);

          final receipt = repo.submitConvert(request);
          expect(receipt.convertId, 'CVT-DEMO-056');
          expect(receipt.status, 'submitted');
        });
      });
    },
  );
}
