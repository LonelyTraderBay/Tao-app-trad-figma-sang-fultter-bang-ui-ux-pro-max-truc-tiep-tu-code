// Smoke test for MockTradeRepository (core trading getters slice): exercises
// TradeRepository's core trading getter methods against the mock
// implementation and asserts each call succeeds (doesn't throw) and returns
// a plausible result.
//
// Split from mock_trade_repository_test.dart by behavior group to keep each
// file under the repo's 400-line test-file size gate. See
// mock_trade_repository_copy_test.dart, _regulatory_test.dart, _bots_test.dart
// and _actions_test.dart for the other slices of this smoke test suite.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

void main() {
  const repo = MockTradeRepository();

  group('MockTradeRepository smoke test', () {
    group('core trading getters', () {
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

      test(
        'getTradingBots / getRiskManagement / getExecutionQuality / getAdvancedTools',
        () {
          final bots = repo.getTradingBots();
          expect(bots, isA<TradeBotsSnapshot>());
          expect(bots.activeBots, hasLength(3));
          expect(repo.getRiskManagement(), isA<TradeRiskManagementSnapshot>());
          expect(
            repo.getExecutionQuality(),
            isA<TradeExecutionQualitySnapshot>(),
          );
          expect(repo.getAdvancedTools(), isA<TradeAdvancedToolsSnapshot>());
        },
      );

      test('getMarginTrading / getTraderProfile / getAdvancedTradingDemo', () {
        expect(repo.getMarginTrading(), isA<TradeMarginTradingSnapshot>());
        expect(
          repo.getMarginTrading(pairId: 'ethusdt', pairRouteVariant: true),
          isA<TradeMarginTradingSnapshot>(),
        );
        expect(repo.getTraderProfile(), isA<TradeTraderProfileSnapshot>());
        expect(
          repo.getTraderProfile(traderId: 'trader002'),
          isA<TradeTraderProfileSnapshot>(),
        );
        expect(
          repo.getAdvancedTradingDemo(),
          isA<TradeAdvancedTradingDemoSnapshot>(),
        );
      });
    });
  });
}
