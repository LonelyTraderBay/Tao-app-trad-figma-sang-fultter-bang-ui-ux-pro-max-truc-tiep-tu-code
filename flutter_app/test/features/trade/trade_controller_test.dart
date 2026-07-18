import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

/// Double chỉ phục vụ nhánh offline của máy trạng thái ADR-001: đường đọc
/// forward sang mock thật, submitOrder ném [OfflineFailure].
final class _OfflineSubmitTradeRepository implements TradeRepository {
  const _OfflineSubmitTradeRepository();

  static const _mock = MockTradeRepository(loadDelay: Duration.zero);

  @override
  TradeScreenSnapshot getTrade({String pairId = 'btcusdt'}) =>
      _mock.getTrade(pairId: pairId);

  @override
  TradeOrderPreview previewOrder(TradeOrderDraft draft) =>
      _mock.previewOrder(draft);

  @override
  Future<TradeOrderReceipt> submitOrder(TradeOrderDraft draft) async {
    throw const OfflineFailure();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

void main() {
  ProviderContainer containerWith(TradeRepository repository) {
    final container = ProviderContainer(
      overrides: [tradeRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  TradeOrderDraft draftFor(
    TradeScreenSnapshot snapshot, {
    double? price,
    double amount = .01,
  }) {
    return TradeOrderDraft(
      pairId: snapshot.pair.id,
      side: TradeOrderSide.buy,
      type: TradeOrderType.limit,
      price: price ?? snapshot.pair.price,
      amount: amount,
    );
  }

  test(
    'Trade order controller đi trọn chuỗi ready→confirming→submitting→submitted→success',
    () async {
      const repository = MockTradeRepository(loadDelay: Duration.zero);
      final container = containerWith(repository);
      final snapshot = repository.getTrade();
      final request = (pairId: snapshot.pair.id, draft: draftFor(snapshot));
      final provider = tradeOrderControllerProvider(request);

      final statuses = <TradeHighRiskFlowStatus>[];
      final subscription = container.listen(
        provider,
        (previous, next) => statuses.add(next.status),
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final controller = container.read(provider.notifier);
      expect(controller.canSubmit, isTrue);
      expect(controller.validationMessage(), isNull);
      expect(container.read(provider).preview.total, greaterThan(0));
      expect(TradeHighRiskFlowStatus.confirming.isBusy, isTrue);
      expect(TradeHighRiskFlowStatus.preview.hasPreview, isTrue);
      expect(TradeHighRiskFlowStatus.validationError.isFailure, isTrue);

      await controller.submit();

      final state = container.read(provider);
      expect(state.status, TradeHighRiskFlowStatus.success);
      expect(state.receipt?.orderId, 'ORD-DEMO-048');
      expect(state.receipt?.status, 'submitted');
      expect(state.errorMessage, isNull);
      expect(statuses, const [
        TradeHighRiskFlowStatus.ready,
        TradeHighRiskFlowStatus.confirming,
        TradeHighRiskFlowStatus.submitting,
        TradeHighRiskFlowStatus.submitted,
        TradeHighRiskFlowStatus.success,
      ]);
    },
  );

  test('Trade order controller seed draft/validationError từ build()', () {
    const repository = MockTradeRepository(loadDelay: Duration.zero);
    final container = containerWith(repository);
    final snapshot = repository.getTrade();

    final emptyRequest = (
      pairId: snapshot.pair.id,
      draft: draftFor(snapshot, amount: 0),
    );
    expect(
      container.read(tradeOrderControllerProvider(emptyRequest)).status,
      TradeHighRiskFlowStatus.draft,
    );

    final invalidRequest = (
      pairId: snapshot.pair.id,
      draft: draftFor(snapshot, price: 0),
    );
    expect(
      container.read(tradeOrderControllerProvider(invalidRequest)).status,
      TradeHighRiskFlowStatus.validationError,
    );
    expect(
      container
          .read(tradeOrderControllerProvider(invalidRequest).notifier)
          .validationMessage(),
      'Enter a valid order price before preview.',
    );
  });

  test(
    'Trade order controller preview mở/đóng và nhánh error khi repo ném',
    () async {
      const repository = MockTradeRepository(
        loadDelay: Duration.zero,
        simulateError: true,
      );
      final container = containerWith(repository);
      final snapshot = repository.getTrade();
      final request = (pairId: snapshot.pair.id, draft: draftFor(snapshot));
      final provider = tradeOrderControllerProvider(request);
      // Giữ listener suốt test: provider autoDispose không có listener sẽ
      // dispose notifier ngay sau mỗi read → mutation bị reset về build().
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      final controller = container.read(provider.notifier);

      controller.enterPreview();
      expect(container.read(provider).status, TradeHighRiskFlowStatus.preview);
      controller.cancelPreview();
      expect(container.read(provider).status, TradeHighRiskFlowStatus.ready);

      await controller.submit();
      final state = container.read(provider);
      expect(state.status, TradeHighRiskFlowStatus.error);
      expect(state.errorMessage, 'Gửi lệnh thất bại. Vui lòng thử lại.');
      expect(state.receipt, isNull);
    },
  );

  test(
    'Trade order controller phân loại OfflineFailure về status offline',
    () async {
      final container = containerWith(const _OfflineSubmitTradeRepository());
      final snapshot = const _OfflineSubmitTradeRepository().getTrade();
      final request = (pairId: snapshot.pair.id, draft: draftFor(snapshot));
      final provider = tradeOrderControllerProvider(request);
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);

      await container.read(provider.notifier).submit();

      final state = container.read(provider);
      expect(state.status, TradeHighRiskFlowStatus.offline);
      expect(state.errorMessage, isNotEmpty);
    },
  );

  test(
    'Trade leverage controller clamps leverage and submits previewed risk',
    () async {
      const repository = MockTradeRepository(loadDelay: Duration.zero);
      final container = containerWith(repository);
      final provider = tradeLeverageControllerProvider('btcusdt');
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      final controller = container.read(provider.notifier);

      expect(controller.sanitizeLeverage(150), 100);
      expect(controller.sanitizeLeverage(0), 1);
      // build() seed từ snapshot.currentLeverage của read-model.
      expect(container.read(provider).request.leverage, 10);

      controller.setLeverage(25);
      expect(container.read(provider).request.leverage, 25);
      expect(container.read(provider).preview.showRiskTips, isTrue);
      expect(controller.canSubmit, isTrue);
      expect(controller.validationMessage(), isNull);

      // setLeverage sanitize tại nguồn — không thể vượt 100 qua API công khai.
      controller.setLeverage(150);
      expect(container.read(provider).request.leverage, 100);

      await controller.submit();
      final state = container.read(provider);
      expect(state.status, TradeHighRiskFlowStatus.success);
      expect(state.receipt?.pairId, 'btcusdt');
      expect(state.receipt?.status, 'submitted');
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

  test(
    'Trade futures order and orders history controllers own submit intents',
    () async {
      const repository = MockTradeRepository(loadDelay: Duration.zero);
      final container = containerWith(repository);
      final futures = repository.getFutures(pairId: 'btcusdt');
      final futuresDraft = TradeFuturesOrderDraft(
        pairId: futures.pair.id,
        side: TradeFuturesSide.long,
        type: TradeFuturesOrderType.market,
        margin: 100,
        leverage: 10,
      );
      final provider = tradeFuturesOrderControllerProvider((
        pairId: futures.pair.id,
        draft: futuresDraft,
      ));
      final statuses = <TradeHighRiskFlowStatus>[];
      final subscription = container.listen(
        provider,
        (previous, next) => statuses.add(next.status),
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      final futuresController = container.read(provider.notifier);

      expect(futuresController.canSubmit, isTrue);
      expect(futuresController.validationMessage(), isNull);

      await futuresController.submit();
      final state = container.read(provider);
      expect(state.status, TradeHighRiskFlowStatus.success);
      expect(state.receipt?.orderId, 'FUT-DEMO-057');
      expect(state.receipt?.status, 'submitted');
      expect(statuses, const [
        TradeHighRiskFlowStatus.ready,
        TradeHighRiskFlowStatus.confirming,
        TradeHighRiskFlowStatus.submitting,
        TradeHighRiskFlowStatus.submitted,
        TradeHighRiskFlowStatus.success,
      ]);

      final ordersController = TradeOrdersHistoryController(
        repository: repository,
        state: TradeOrdersHistoryViewState(
          snapshot: repository.getOrdersHistory(),
        ),
      );
      expect(ordersController.cancelValidationMessage('ord001'), isNull);
      expect(ordersController.cancelOrder('ord001').action, 'cancel');
    },
  );

  test('Trade futures order controller rẽ nhánh error khi repo ném', () async {
    const repository = MockTradeRepository(
      loadDelay: Duration.zero,
      simulateError: true,
    );
    final container = containerWith(repository);
    final futures = repository.getFutures(pairId: 'btcusdt');
    final provider = tradeFuturesOrderControllerProvider((
      pairId: futures.pair.id,
      draft: TradeFuturesOrderDraft(
        pairId: futures.pair.id,
        side: TradeFuturesSide.long,
        type: TradeFuturesOrderType.market,
        margin: 100,
        leverage: 10,
      ),
    ));
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(provider.notifier).submit();
    final state = container.read(provider);
    expect(state.status, TradeHighRiskFlowStatus.error);
    expect(state.errorMessage, 'Gửi lệnh futures thất bại. Vui lòng thử lại.');
    expect(state.receipt, isNull);
  });
}
