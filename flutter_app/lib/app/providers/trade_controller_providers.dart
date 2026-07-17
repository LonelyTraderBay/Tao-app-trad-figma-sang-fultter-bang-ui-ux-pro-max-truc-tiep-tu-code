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

typedef TradeMarginControllerRequest = ({String pairId, bool pairRouteVariant});

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

/// Notifier theo ADR-001 — family key giữ nguyên record request (PERF-HN1
/// đã cho record này value equality qua TradeOrderDraft ==), autoDispose để
/// member theo từng draft không tích lũy.
final tradeOrderControllerProvider = NotifierProvider.autoDispose
    .family<
      TradeOrderController,
      TradeOrderViewState,
      TradeOrderControllerRequest
    >(TradeOrderController.new);

/// STATE-S22: Notifier theo ADR-001, family key thu về `String pairId` —
/// nấc đòn bẩy là state trong Notifier, không còn nằm trong key (trước đây
/// mỗi nấc slider tạo một element cache riêng — leak allowlist S24).
final tradeLeverageControllerProvider = NotifierProvider.autoDispose
    .family<TradeLeverageController, TradeLeverageViewState, String>(
      TradeLeverageController.new,
    );

/// Read-model thuần (không có mutation) — giữ Provider theo chuẩn AGENTS.md;
/// autoDispose để member theo request không tích lũy.
final tradeMarginControllerProvider = Provider.autoDispose
    .family<TradeMarginController, TradeMarginControllerRequest>((
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

/// STATE-S22: Notifier theo ADR-001 (mirror tradeOrderControllerProvider).
final tradeFuturesOrderControllerProvider = NotifierProvider.autoDispose
    .family<
      TradeFuturesOrderController,
      TradeFuturesOrderViewState,
      TradeFuturesOrderControllerRequest
    >(TradeFuturesOrderController.new);
