// Spot / Futures / Margin / Convert product controller providers.
// Advanced terminal demos stay in trade_terminal_controller_providers.dart.
//
// Composition root for the `trade` feature's own domain/data/controllers
// layers (features/trade/domain, features/trade/data,
// features/trade/presentation/controllers) — no longer wired through
// `trade_core`'s 6-way TradeRepository union.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

final tradeReadModelControllerProvider = Provider<TradeRepository>((ref) {
  return ref.watch(tradeRepositoryProvider);
});

typedef TradeOrderControllerRequest = ({String pairId, TradeOrderDraft draft});
typedef TradeLeverageControllerRequest = ({String pairId, int leverage});
typedef TradeMarginControllerRequest = ({String pairId, bool pairRouteVariant});
typedef TradeFuturesOrderControllerRequest = ({
  String pairId,
  TradeFuturesOrderDraft draft,
});

final tradeScreenProvider = Provider.family<TradeScreenSnapshot, String>(
  (ref, pairId) => ref.watch(tradeRepositoryProvider).getTrade(pairId: pairId),
);

final tradeFuturesProvider = Provider.family<TradeFuturesSnapshot, String>(
  (ref, pairId) =>
      ref.watch(tradeRepositoryProvider).getFutures(pairId: pairId),
);

final tradeOrdersHistoryControllerProvider =
    Provider<TradeOrdersHistoryController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeOrdersHistoryController(
        repository: repository,
        state: TradeOrdersHistoryViewState(
          snapshot: repository.getOrdersHistory(),
        ),
      );
    });

final tradeOrderControllerProvider = Provider.autoDispose
    .family<TradeOrderController, TradeOrderControllerRequest>((ref, request) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeOrderController(
        repository: repository,
        state: TradeOrderViewState(
          snapshot: repository.getTrade(pairId: request.pairId),
          draft: request.draft,
          preview: repository.previewOrder(request.draft),
        ),
      );
    });

final tradeLeverageControllerProvider =
    Provider.family<TradeLeverageController, TradeLeverageControllerRequest>((
      ref,
      request,
    ) {
      final repository = ref.watch(tradeRepositoryProvider);
      final snapshot = repository.getFuturesLeverage(pairId: request.pairId);
      final leverage = TradeLeverageController.sanitize(request.leverage);
      final leverageRequest = TradeFuturesLeverageRequest(
        pairId: request.pairId,
        leverage: leverage,
        exampleMargin: snapshot.exampleMargin,
      );
      return TradeLeverageController(
        repository: repository,
        state: TradeLeverageViewState(
          snapshot: snapshot,
          request: leverageRequest,
          preview: repository.previewFuturesLeverage(leverageRequest),
        ),
      );
    });

final tradeMarginControllerProvider =
    Provider.family<TradeMarginController, TradeMarginControllerRequest>((
      ref,
      request,
    ) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeMarginController(
        state: TradeMarginViewState(
          snapshot: repository.getMarginTrading(
            pairId: request.pairId,
            pairRouteVariant: request.pairRouteVariant,
          ),
        ),
      );
    });

final tradeFuturesOrderControllerProvider = Provider.autoDispose
    .family<TradeFuturesOrderController, TradeFuturesOrderControllerRequest>((
      ref,
      request,
    ) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeFuturesOrderController(
        repository: repository,
        state: TradeFuturesOrderViewState(
          snapshot: repository.getFutures(pairId: request.pairId),
          draft: request.draft,
          preview: repository.previewFuturesOrder(request.draft),
        ),
      );
    });
