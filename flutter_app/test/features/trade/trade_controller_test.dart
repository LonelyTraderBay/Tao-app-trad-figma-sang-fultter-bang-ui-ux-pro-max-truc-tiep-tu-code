import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

void main() {
  test('Trade order controller previews and submits a valid order intent', () {
    final repository = const MockTradeRepository();
    final snapshot = repository.getTrade();
    final draft = TradeOrderDraft(
      pairId: snapshot.pair.id,
      side: TradeOrderSide.buy,
      type: TradeOrderType.limit,
      price: snapshot.pair.price,
      amount: .01,
    );
    final controller = TradeOrderController(
      repository: repository,
      state: TradeOrderViewState(
        snapshot: snapshot,
        draft: draft,
        preview: repository.previewOrder(draft),
      ),
    );
    expect(controller.canSubmit, isTrue);
    expect(controller.validationMessage(), isNull);
    expect(TradeHighRiskFlowStatus.confirming.isBusy, isTrue);
    expect(TradeHighRiskFlowStatus.preview.hasPreview, isTrue);
    expect(TradeHighRiskFlowStatus.validationError.isFailure, isTrue);
    expect(controller.state.preview.total, greaterThan(0));
    expect(
      TradeOrderController(
        repository: repository,
        state: TradeOrderViewState(
          snapshot: snapshot,
          draft: TradeOrderDraft(
            pairId: snapshot.pair.id,
            side: TradeOrderSide.buy,
            type: TradeOrderType.limit,
            price: 0,
            amount: .01,
          ),
          preview: repository.previewOrder(
            TradeOrderDraft(
              pairId: snapshot.pair.id,
              side: TradeOrderSide.buy,
              type: TradeOrderType.limit,
              price: 0,
              amount: .01,
            ),
          ),
        ),
      ).validationMessage(),
      'Enter a valid order price before preview.',
    );
    expect(
      TradeOrderController(
        repository: repository,
        state: TradeOrderViewState(
          snapshot: snapshot,
          draft: draft,
          preview: repository.previewOrder(draft),
          status: TradeHighRiskFlowStatus.offline,
        ),
      ).validationMessage(),
      'Offline: reconnect before previewing this order.',
    );
    final receipt = controller.submit();
    expect(receipt.orderId, 'ORD-DEMO-048');
    expect(receipt.status, 'submitted');
  });

  test(
    'Trade leverage controller clamps leverage and submits previewed risk',
    () {
      final repository = const MockTradeRepository();
      final snapshot = repository.getFuturesLeverage(pairId: 'btcusdt');
      final request = TradeFuturesLeverageRequest(
        pairId: 'btcusdt',
        leverage: 25,
        exampleMargin: snapshot.exampleMargin,
      );
      final controller = TradeLeverageController(
        repository: repository,
        state: TradeLeverageViewState(
          snapshot: snapshot,
          request: request,
          preview: repository.previewFuturesLeverage(request),
        ),
      );
      expect(controller.sanitizeLeverage(150), 100);
      expect(controller.sanitizeLeverage(0), 1);
      expect(controller.state.preview.showRiskTips, isTrue);
      expect(controller.canSubmit, isTrue);
      expect(controller.validationMessage(), isNull);
      expect(
        TradeLeverageController(
          repository: repository,
          state: TradeLeverageViewState(
            snapshot: snapshot,
            request: const TradeFuturesLeverageRequest(
              pairId: 'btcusdt',
              leverage: 101,
            ),
            preview: repository.previewFuturesLeverage(
              const TradeFuturesLeverageRequest(
                pairId: 'btcusdt',
                leverage: 100,
              ),
            ),
          ),
        ).validationMessage(),
        'Leverage must stay between 1x and 100x.',
      );
      final receipt = controller.submit();
      expect(receipt.pairId, 'btcusdt');
      expect(receipt.status, 'submitted');
    },
  );

  test(
    'Trade margin controller owns mode totals and max amount calculation',
    () {
      final repository = const MockTradeRepository();
      final snapshot = repository.getMarginTrading();
      final controller = TradeMarginController(
        state: TradeMarginViewState(snapshot: snapshot),
      );
      final positions = controller.positionsForMode(snapshot.defaultMode);
      expect(positions, isNotEmpty);
      expect(
        controller.totalPnlForMode(snapshot.defaultMode),
        positions.fold<double>(0, (total, item) => total + item.pnl),
      );
      expect(
        double.parse(
          controller.maxAmountFor(leverage: snapshot.defaultLeverage),
        ),
        greaterThan(0),
      );
      expect(
        controller.leverageValidationMessage(
          leverage: snapshot.defaultLeverage,
        ),
        isNull,
      );
      expect(
        controller.leverageValidationMessage(leverage: 0),
        'Leverage must stay between 1x and 100x.',
      );
    },
  );
}
