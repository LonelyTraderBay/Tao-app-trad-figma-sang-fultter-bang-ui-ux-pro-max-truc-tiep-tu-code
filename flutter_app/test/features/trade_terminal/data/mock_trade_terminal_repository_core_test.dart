// Fixture-value smoke test for MockTradeTerminalRepository's core spot
// trading surface (SpotTradeRepository's core-spot slice) and the
// futures/margin surface (TradeFuturesMarginRepository).
//
// test/features/trade_terminal/mock_trade_terminal_repository_test.dart
// already exercises every method on both interfaces with `isA<...>()`
// smoke checks; this file complements that coverage (TEST-HR4) by pinning
// the actual fixture literals — including the `highRiskContractId` values
// the High-Risk-State-Standard requires for the trade_spot_order and
// trade_margin_futures flows (see test/fixtures/high_risk_flow_binding.dart)
// — read straight from
// lib/features/trade_terminal/data/fixtures/trade_core_spot_repository_methods.dart
// and trade_futures_leverage_repository_methods.dart.
//
// See mock_trade_terminal_repository_tools_test.dart for the advanced
// tools + conversions/utilities slice of SpotTradeRepository (no
// highRiskContractId on that slice).
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';

void main() {
  const repo = MockTradeTerminalRepository(loadDelay: Duration.zero);

  group(
    'MockTradeTerminalRepository core spot + futures/margin smoke test',
    () {
      group('core spot getters', () {
        test('getTrade pins pair, highRiskContractId and balances', () async {
          final snapshot = await repo.getTrade();
          expect(snapshot.pair.id, 'btcusdt');
          expect(
            snapshot.highRiskContractId,
            HighRiskFlowContractIds.tradeSpotOrder,
          );
          expect(snapshot.copyProviders, hasLength(2));
          expect(snapshot.botStrategies, hasLength(3));
          expect(snapshot.balances.usdtAvailable, 10200);

          final other = await repo.getTrade(pairId: 'ethusdt');
          expect(other.pair.id, 'ethusdt');
        });

        test(
          'getOrdersHistory / getOrderReceipt pin ids and highRiskContractId',
          () async {
            final history = await repo.getOrdersHistory();
            expect(history.openOrders, isNotEmpty);
            expect(history.historyOrders, isNotEmpty);

            final receipt = await repo.getOrderReceipt();
            expect(receipt.receipt.orderId, 'ORD-98EH1ZT2');
            expect(receipt.receipt.symbol, 'BTC/USDT');
            expect(
              receipt.highRiskContractId,
              HighRiskFlowContractIds.tradeSpotOrder,
            );
            expect(receipt.supportRoute, isNotEmpty);
          },
        );

        test(
          'getTradeSettings / getTradePositions pin fixture-backed values',
          () async {
            final settings = await repo.getTradeSettings();
            expect(settings.settings.defaultOrderType, 'limit');

            final positions = await repo.getTradePositions();
            expect(positions.positions, hasLength(6));
          },
        );

        test(
          'getAdvancedTradingDemo / getAdvancedAnalytics pin default tabs',
          () async {
            final demo = await repo.getAdvancedTradingDemo();
            expect(demo.defaultTab, 'position');
            expect(demo.defaultPositionMode, 'one-way');
            expect(demo.positionActions, isNotEmpty);

            final analytics = await repo.getAdvancedAnalytics();
            expect(analytics.defaultTab, 'ai');
            expect(analytics.signals, isNotEmpty);
            expect(analytics.features, isNotEmpty);
          },
        );
      });

      group('core spot actions', () {
        test(
          'patchTradeSettings echoes the fixture-backed defaultOrderType',
          () async {
            final settings = (await repo.getTradeSettings()).settings;
            final result = await repo.patchTradeSettings(settings);
            expect(result.defaultOrderType, 'limit');
          },
        );

        test(
          'previewOrder / submitOrder pin computed total and receipt id',
          () async {
            const draft = TradeOrderDraft(
              pairId: 'btcusdt',
              side: TradeOrderSide.buy,
              type: TradeOrderType.limit,
              price: 67543.21,
              amount: .1,
            );
            final preview = await repo.previewOrder(draft);
            expect(preview.total, closeTo(6754.321, .001));
            expect(preview.feeRate, .00085);

            final receipt = await repo.submitOrder(draft);
            expect(receipt.orderId, 'ORD-DEMO-048');
            expect(receipt.status, 'submitted');
          },
        );

        test(
          'submitOrderAction echoes orderId/action with success status',
          () async {
            final result = await repo.submitOrderAction(
              orderId: 'ord-open-001',
              action: 'cancel',
            );
            expect(result.orderId, 'ord-open-001');
            expect(result.action, 'cancel');
            expect(result.status, 'success');
          },
        );
      });

      group('futures & margin getters', () {
        test(
          'getFutures pins highRiskContractId, leverages and margin',
          () async {
            final futures = await repo.getFutures();
            expect(
              futures.highRiskContractId,
              HighRiskFlowContractIds.tradeMarginFutures,
            );
            expect(futures.leverages, hasLength(9));
            expect(futures.accountBalance, 5000);
            expect(futures.usedMargin, 544);
          },
        );

        test(
          'getFuturesLeverage pins currentLeverage and preset counts',
          () async {
            final leverage = await repo.getFuturesLeverage();
            expect(leverage.currentLeverage, 10);
            expect(leverage.presets, hasLength(10));
            expect(leverage.sliderStops, hasLength(6));
          },
        );

        test(
          'getMarginTrading pins highRiskContractId and default leverage',
          () async {
            final margin = await repo.getMarginTrading();
            expect(
              margin.highRiskContractId,
              HighRiskFlowContractIds.tradeMarginFutures,
            );
            expect(margin.defaultMode, 'cross');
            expect(margin.defaultLeverage, 5);

            final routeVariant = await repo.getMarginTrading(
              pairId: 'ethusdt',
              pairRouteVariant: true,
            );
            expect(routeVariant.pair.id, 'ethusdt');
          },
        );

        test(
          'getMarginTradingHub returns populated stats and menu items',
          () async {
            final hub = await repo.getMarginTradingHub();
            expect(hub.stats, isNotEmpty);
            expect(hub.menuItems, isNotEmpty);
          },
        );
      });

      group('futures & margin actions', () {
        test(
          'previewFuturesOrder / submitFuturesOrder pin computed size and id',
          () async {
            const draft = TradeFuturesOrderDraft(
              pairId: 'btcusdt',
              side: TradeFuturesSide.long,
              type: TradeFuturesOrderType.market,
              margin: 500,
              leverage: 10,
            );
            final preview = await repo.previewFuturesOrder(draft);
            expect(preview.positionSize, 5000);
            expect(preview.openFee, closeTo(1, .0001));
            expect(preview.canOpen, isTrue);

            final receipt = await repo.submitFuturesOrder(draft);
            expect(receipt.orderId, 'FUT-DEMO-057');
            expect(receipt.status, 'submitted');
          },
        );

        test(
          'previewFuturesLeverage / submitFuturesLeverage pin computed preview',
          () async {
            const request = TradeFuturesLeverageRequest(
              pairId: 'btcusdt',
              leverage: 10,
            );
            final preview = await repo.previewFuturesLeverage(request);
            expect(preview.positionSize, 1000);
            expect(preview.liquidationDistancePct, 9);
            expect(preview.showRiskTips, isFalse);

            final receipt = await repo.submitFuturesLeverage(
              const TradeFuturesLeverageRequest(
                pairId: 'btcusdt',
                leverage: 50,
              ),
            );
            expect(receipt.adjustmentId, 'LEV-DEMO-058');
            expect(receipt.status, 'submitted');
            expect(receipt.preview.leverage, 50);
          },
        );
      });
    },
  );
}
