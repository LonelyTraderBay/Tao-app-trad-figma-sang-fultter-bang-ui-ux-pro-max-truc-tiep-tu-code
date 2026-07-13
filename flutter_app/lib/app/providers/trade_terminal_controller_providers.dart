// Trade-terminal domain controller providers (trade_terminal extraction,
// Batch 4 of Phase 4 of the trade module split — the final domain phase).
// Pages must not import `features/trade_terminal/data/providers/` directly
// (architecture rule — presentation depends on `app/providers/*`, not
// feature data facades); this file re-exports [spotTradeRepositoryProvider]
// and [tradeFuturesMarginRepositoryProvider] below, and now also hosts every
// spot/futures-margin controller provider that previously lived in
// `trade_controller_providers.dart` (renamed/relocated here in this batch,
// mirroring the trade_bots/trade_copy pattern).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_core/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/controllers/trade_controller_models.dart';

export 'package:vit_trade_flutter/features/trade_terminal/data/providers/trade_repository_provider.dart';

final tradeReadModelControllerProvider = Provider<TradeReadModelController>((
  ref,
) {
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

final tradeRiskManagementControllerProvider =
    Provider<TradeRiskManagementController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeRiskManagementController(
        repository: repository,
        state: TradeRiskManagementViewState(
          snapshot: repository.getRiskManagement(),
        ),
      );
    });

final tradeAdvancedToolsControllerProvider =
    Provider<TradeAdvancedToolsController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeAdvancedToolsController(
        repository: repository,
        state: TradeAdvancedToolsViewState(
          snapshot: repository.getAdvancedTools(),
        ),
      );
    });

final tradeOrderControllerProvider =
    Provider.family<TradeOrderController, TradeOrderControllerRequest>((
      ref,
      request,
    ) {
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

final tradeFuturesOrderControllerProvider =
    Provider.family<
      TradeFuturesOrderController,
      TradeFuturesOrderControllerRequest
    >((ref, request) {
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
