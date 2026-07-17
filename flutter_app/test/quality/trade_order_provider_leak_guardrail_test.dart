import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

/// Regression guardrail for PERF-HN1
/// (docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv):
/// `tradeOrderControllerProvider`/`tradeFuturesOrderControllerProvider` used
/// to leak one cache element per rebuild, because their family key embeds a
/// `TradeOrderDraft`/`TradeFuturesOrderDraft` — every widget rebuild (e.g.
/// every keystroke in the amount field) constructs a brand-new draft
/// instance, and with identity-only equality that new instance never
/// compared equal to the previous one, so Riverpod treated it as a distinct
/// family member and cached it forever (no autoDispose). Fixed by giving
/// both draft classes value equality and making both providers
/// `.autoDispose.family`.
base class _CountingObserver extends ProviderObserver {
  int spotAddCount = 0;
  int futuresAddCount = 0;

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (identical(context.provider.from, tradeOrderControllerProvider)) {
      spotAddCount += 1;
    }
    if (identical(
      context.provider.from,
      tradeFuturesOrderControllerProvider,
    )) {
      futuresAddCount += 1;
    }
  }
}

void main() {
  test(
    'tradeOrderControllerProvider reuses its cache entry for two distinct '
    'TradeOrderDraft instances with identical field values',
    () {
      final observer = _CountingObserver();
      final container = ProviderContainer(observers: [observer]);
      addTearDown(container.dispose);

      // Non-const on purpose: the real widget builds a draft from runtime
      // TextEditingController/state values every build, so `const` (which
      // Dart canonicalizes to a single shared instance) would not
      // reproduce the bug — two builds with the same on-screen amount must
      // still yield two distinct object instances here.
      TradeOrderDraft buildDraft(double amount) => TradeOrderDraft(
        pairId: 'btcusdt',
        side: TradeOrderSide.buy,
        type: TradeOrderType.market,
        price: 65000,
        amount: amount,
      );

      final draftA = buildDraft(0.5);
      final draftB = buildDraft(0.5);
      expect(identical(draftA, draftB), isFalse);
      expect(draftA, equals(draftB));

      container.read(
        tradeOrderControllerProvider((pairId: 'btcusdt', draft: draftA)),
      );
      final afterFirst = observer.spotAddCount;
      expect(afterFirst, 1);

      container.read(
        tradeOrderControllerProvider((pairId: 'btcusdt', draft: draftB)),
      );

      expect(
        observer.spotAddCount,
        afterFirst,
        reason:
            'tradeOrderControllerProvider cached a second element for a '
            'value-equal draft — TradeOrderDraft value equality regressed.',
      );

      // A genuinely different amount is a genuinely different order and
      // must still get its own cache entry.
      container.read(
        tradeOrderControllerProvider((
          pairId: 'btcusdt',
          draft: buildDraft(0.75),
        )),
      );
      expect(observer.spotAddCount, afterFirst + 1);
    },
  );

  test(
    'tradeFuturesOrderControllerProvider reuses its cache entry for two '
    'distinct TradeFuturesOrderDraft instances with identical field values',
    () {
      final observer = _CountingObserver();
      final container = ProviderContainer(observers: [observer]);
      addTearDown(container.dispose);

      TradeFuturesOrderDraft buildDraft(double margin) => TradeFuturesOrderDraft(
        pairId: 'btcusdt',
        side: TradeFuturesSide.long,
        type: TradeFuturesOrderType.market,
        margin: margin,
        leverage: 10,
      );

      final draftA = buildDraft(100);
      final draftB = buildDraft(100);
      expect(identical(draftA, draftB), isFalse);
      expect(draftA, equals(draftB));

      container.read(
        tradeFuturesOrderControllerProvider((
          pairId: 'btcusdt',
          draft: draftA,
        )),
      );
      final afterFirst = observer.futuresAddCount;
      expect(afterFirst, 1);

      container.read(
        tradeFuturesOrderControllerProvider((
          pairId: 'btcusdt',
          draft: draftB,
        )),
      );

      expect(observer.futuresAddCount, afterFirst);
    },
  );
}
