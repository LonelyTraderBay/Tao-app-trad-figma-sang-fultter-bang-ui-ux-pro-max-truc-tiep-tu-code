import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

void main() {
  test('Trade futures, risk, and order controllers own submit intents', () {
    final repository = const MockTradeRepository();
    final futures = repository.getFutures(pairId: 'btcusdt');
    final futuresDraft = TradeFuturesOrderDraft(
      pairId: futures.pair.id,
      side: TradeFuturesSide.long,
      type: TradeFuturesOrderType.market,
      margin: 100,
      leverage: 10,
    );
    final futuresController = TradeFuturesOrderController(
      repository: repository,
      state: TradeFuturesOrderViewState(
        snapshot: futures,
        draft: futuresDraft,
        preview: repository.previewFuturesOrder(futuresDraft),
      ),
    );
    expect(futuresController.canSubmit, isTrue);
    expect(futuresController.validationMessage(), isNull);
    expect(futuresController.submit().status, 'submitted');
    final riskController = TradeRiskManagementController(
      repository: repository,
      state: TradeRiskManagementViewState(
        snapshot: repository.getRiskManagement(),
      ),
    );
    expect(
      riskController.ocoValidationMessage(
        const TradeOcoOrderDraft(
          symbol: 'BTC/USDT',
          side: TradeOrderSide.buy,
          quantity: .015,
          limitPrice: 69000,
          takeProfitPrice: 72000,
          stopPrice: 66000,
        ),
      ),
      isNull,
    );
    expect(
      riskController
          .submitOcoOrder(
            const TradeOcoOrderDraft(
              symbol: 'BTC/USDT',
              side: TradeOrderSide.buy,
              quantity: .015,
              limitPrice: 69000,
              takeProfitPrice: 72000,
              stopPrice: 66000,
            ),
          )
          .status,
      isNotEmpty,
    );
    expect(
      riskController
          .calculatePositionSize(
            const TradePositionSizeRequest(
              accountBalance: 50000,
              riskPct: 1,
              entryPrice: 69000,
              stopPrice: 67500,
            ),
          )
          .suggestedAmount,
      greaterThan(0),
    );
    expect(
      riskController.positionSizeValidationMessage(
        const TradePositionSizeRequest(
          accountBalance: 50000,
          riskPct: 1,
          entryPrice: 69000,
          stopPrice: 67500,
        ),
      ),
      isNull,
    );
    final ordersController = TradeOrdersHistoryController(
      repository: repository,
      state: TradeOrdersHistoryViewState(
        snapshot: repository.getOrdersHistory(),
      ),
    );
    expect(ordersController.cancelValidationMessage('ord001'), isNull);
    expect(ordersController.cancelOrder('ord001').action, 'cancel');
  });

  test('Trade advanced tools controller owns action and amendment intents', () {
    final repository = const MockTradeRepository();
    final controller = TradeAdvancedToolsController(
      repository: repository,
      state: TradeAdvancedToolsViewState(
        snapshot: repository.getAdvancedTools(),
      ),
    );
    expect(
      controller.actionValidationMessage(
        const TradeAdvancedToolActionRequest(
          toolId: 'bulk',
          action: 'cancel',
          orderIds: ['ord001', 'ord002'],
        ),
      ),
      isNull,
    );
    expect(
      controller
          .submitAction(
            const TradeAdvancedToolActionRequest(
              toolId: 'bulk',
              action: 'cancel',
              orderIds: ['ord001', 'ord002'],
            ),
          )
          .affectedCount,
      2,
    );
    expect(
      controller
          .amendOrder(
            const TradeOrderAmendmentRequest(
              orderId: 'ord001',
              newPrice: 69000,
              newAmount: .02,
            ),
          )
          .queuePositionPreserved,
      isTrue,
    );
    expect(
      controller.amendmentValidationMessage(
        const TradeOrderAmendmentRequest(
          orderId: 'ord001',
          newPrice: 69000,
          newAmount: .02,
        ),
      ),
      isNull,
    );
  });
}
