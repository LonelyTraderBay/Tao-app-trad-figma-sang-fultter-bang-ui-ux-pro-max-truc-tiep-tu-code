// Delegation-wiring smoke test for MockTradeRepository (trade feature's own
// repository). `MockTradeRepository` forwards every call untouched to an
// internal `MockTradeTerminalRepository` (see its own doc comment) — so the
// deep fixture-value coverage already lives in
// test/features/trade_terminal/data/mock_trade_terminal_repository_core_test.dart
// and mock_trade_terminal_repository_tools_test.dart. This file instead
// exercises every method through the `trade` facade at least once (TEST-HR4)
// and confirms the delegation itself preserves the two high-risk contract
// ids surfaced through this feature's routes
// (test/fixtures/high_risk_flow_binding.dart: trade_spot_order,
// trade_margin_futures) plus a representative sample of the pinned fixture
// literals, so a future regression in the forwarding wiring (not just the
// underlying mock) would be caught here.
//
// test/features/trade/mock_trade_repository_test.dart already covers every
// method with `isA<...>()` smoke checks and a handful of pins; this file
// adds the highRiskContractId assertions the High-Risk-State-Standard
// requires and does not duplicate its per-method isA<> coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

void main() {
  const repo = MockTradeRepository(loadDelay: Duration.zero);

  group('MockTradeRepository delegation smoke test', () {
    test(
      'getTrade / getOrderReceipt propagate the spot order contract id',
      () async {
        final trade = await repo.getTrade();
        expect(
          trade.highRiskContractId,
          HighRiskFlowContractIds.tradeSpotOrder,
        );
        expect(trade.pair.id, 'btcusdt');

        final receipt = await repo.getOrderReceipt();
        expect(
          receipt.highRiskContractId,
          HighRiskFlowContractIds.tradeSpotOrder,
        );
        expect(receipt.receipt.orderId, 'ORD-98EH1ZT2');

        expect((await repo.getOrdersHistory()).openOrders, isNotEmpty);
        expect(
          (await repo.getTradeSettings()).settings.defaultOrderType,
          'limit',
        );
        expect((await repo.getTradePositions()).positions, hasLength(6));
        expect((await repo.getAdvancedTradingDemo()).defaultTab, 'position');
        expect((await repo.getAdvancedAnalytics()).defaultTab, 'ai');
      },
    );

    test(
      'getFutures / getMarginTrading propagate the margin/futures contract id',
      () async {
        final futures = await repo.getFutures();
        expect(
          futures.highRiskContractId,
          HighRiskFlowContractIds.tradeMarginFutures,
        );
        expect(futures.leverages, hasLength(9));

        final margin = await repo.getMarginTrading();
        expect(
          margin.highRiskContractId,
          HighRiskFlowContractIds.tradeMarginFutures,
        );

        expect((await repo.getFuturesLeverage()).currentLeverage, 10);
        expect((await repo.getMarginTradingHub()).stats, isNotEmpty);
      },
    );

    test(
      'spot & margin/futures write actions delegate and return receipts',
      () async {
        const draft = TradeOrderDraft(
          pairId: 'btcusdt',
          side: TradeOrderSide.buy,
          type: TradeOrderType.limit,
          price: 67543.21,
          amount: .1,
        );
        expect((await repo.previewOrder(draft)).total, closeTo(6754.321, .001));
        expect((await repo.submitOrder(draft)).orderId, 'ORD-DEMO-048');
        expect(
          (await repo.submitOrderAction(
            orderId: 'ord-open-001',
            action: 'cancel',
          )).status,
          'success',
        );
        expect(
          (await repo.patchTradeSettings(
            (await repo.getTradeSettings()).settings,
          )).defaultOrderType,
          'limit',
        );

        const futuresDraft = TradeFuturesOrderDraft(
          pairId: 'btcusdt',
          side: TradeFuturesSide.long,
          type: TradeFuturesOrderType.market,
          margin: 500,
          leverage: 10,
        );
        expect(
          (await repo.previewFuturesOrder(futuresDraft)).positionSize,
          5000,
        );
        expect(
          (await repo.submitFuturesOrder(futuresDraft)).orderId,
          'FUT-DEMO-057',
        );

        const leverageRequest = TradeFuturesLeverageRequest(
          pairId: 'btcusdt',
          leverage: 10,
        );
        expect(
          (await repo.previewFuturesLeverage(leverageRequest)).positionSize,
          1000,
        );
        expect(
          (await repo.submitFuturesLeverage(leverageRequest)).adjustmentId,
          'LEV-DEMO-058',
        );
      },
    );

    test(
      'advanced tools & conversions/utilities getters/actions all delegate',
      () async {
        expect((await repo.getAdvancedChart()).candles, isNotEmpty);
        expect((await repo.getRiskManagement()).accountBalance, 50000);
        expect((await repo.getExecutionQuality()).features, isNotEmpty);
        expect((await repo.getAdvancedTools()).shortcuts, isNotEmpty);
        expect(
          (await repo.submitOcoOrder(
            const TradeOcoOrderDraft(
              symbol: 'BTC/USDT',
              side: TradeOrderSide.buy,
              quantity: .015,
              limitPrice: 69000,
              takeProfitPrice: 72000,
              stopPrice: 66000,
            ),
          )).orderId,
          'OCO-DEMO-060',
        );
        expect(
          (await repo.calculatePositionSize(
            const TradePositionSizeRequest(
              accountBalance: 50000,
              riskPct: 1,
              entryPrice: 69000,
              stopPrice: 67500,
            ),
          )).suggestedAmount,
          closeTo(.3333, .001),
        );
        final slippage = (await repo.getExecutionQuality()).slippageSettings;
        expect(await repo.updateSlippageSettings(slippage), slippage);
        expect(
          (await repo.amendOrder(
            const TradeOrderAmendmentRequest(
              orderId: 'ord001',
              newPrice: 69000,
              newAmount: .02,
            ),
          )).queuePositionPreserved,
          isTrue,
        );
        expect(
          (await repo.submitAdvancedToolAction(
            const TradeAdvancedToolActionRequest(
              toolId: 'bulk',
              action: 'cancel',
              orderIds: ['o1', 'o2'],
            ),
          )).affectedCount,
          2,
        );

        expect((await repo.getTradeExport()).stats.totalTrades, 847);
        expect((await repo.getConvert()).fromAsset.symbol, 'USDT');
        expect(
          (await repo.createTradeExport(
            const TradeExportRequest(
              format: 'csv',
              period: '30d',
              includeIds: ['spot', 'fees'],
            ),
          )).exportId,
          'EXP-TRADE-054',
        );

        const convertRequest = TradeConvertRequest(
          fromSymbol: 'USDT',
          toSymbol: 'BTC',
          amount: 500,
          slippagePct: .5,
          mode: 'market',
        );
        expect((await repo.previewConvert(convertRequest)).canSubmit, isTrue);
        expect(
          (await repo.submitConvert(convertRequest)).convertId,
          'CVT-DEMO-056',
        );
      },
    );
  });
}
