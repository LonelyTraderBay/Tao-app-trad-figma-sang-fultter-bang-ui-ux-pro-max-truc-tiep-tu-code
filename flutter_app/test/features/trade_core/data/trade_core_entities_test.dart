// trade_core has no repository of its own: `lib/features/trade_core/data/`
// contains only a `.gitkeep` (confirmed via `find`) — the module's data
// layer is entirely `domain/entities/` value types shared by every other
// trade-family feature, plus the fail-closed exception contract each
// sibling's `FailClosedTrade*Repository.noSuchMethod` throws. Per the
// TEST-HR4 instructions, no repository is fabricated here; instead this is
// a smoke test for trade_core's two exports that carry real behavior worth
// pinning (constructor + value equality), matching the
// `docs/.../High-Risk-State-Standard.md` PERF-HN1 rationale documented on
// `TradeOrderDraft` itself:
//
// - `TradeOrderDraft` (lib/features/trade_core/domain/entities/
//   trade_core_entities.dart): overrides `==`/`hashCode` so a draft rebuilt
//   from the same on-screen values resolves to the same
//   `Provider.family` cache entry instead of a new one every keystroke.
// - `TradeBackendContractMissingException` (lib/features/trade_core/domain/
//   entities/trade_errors.dart): the exception every trade-family
//   `FailClosedTrade*Repository` throws via `noSuchMethod` when the mock
//   data flag is off and no production backend is wired yet (see
//   lib/features/trade/data/repositories/fail_closed_trade_repository.dart).
//
// The mock-repository smoke tests for the 5 trade-family siblings live
// under their own `data/` folders (trade, trade_terminal, trade_compliance,
// trade_bots) and exercise the value classes defined here indirectly
// through every getter/action call.
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';

void main() {
  group('TradeOrderDraft value equality', () {
    const draft = TradeOrderDraft(
      pairId: 'btcusdt',
      side: TradeOrderSide.buy,
      type: TradeOrderType.limit,
      price: 67543.21,
      amount: .1,
    );

    test('two drafts built from the same values are ==', () {
      const rebuilt = TradeOrderDraft(
        pairId: 'btcusdt',
        side: TradeOrderSide.buy,
        type: TradeOrderType.limit,
        price: 67543.21,
        amount: .1,
      );
      expect(rebuilt, draft);
      expect(rebuilt.hashCode, draft.hashCode);
    });

    test('a draft differing by a single field is not ==', () {
      const differentAmount = TradeOrderDraft(
        pairId: 'btcusdt',
        side: TradeOrderSide.buy,
        type: TradeOrderType.limit,
        price: 67543.21,
        amount: .2,
      );
      expect(differentAmount, isNot(draft));

      const differentSide = TradeOrderDraft(
        pairId: 'btcusdt',
        side: TradeOrderSide.sell,
        type: TradeOrderType.limit,
        price: 67543.21,
        amount: .1,
      );
      expect(differentSide, isNot(draft));
    });

    test('constructor exposes every field unchanged', () {
      expect(draft.pairId, 'btcusdt');
      expect(draft.side, TradeOrderSide.buy);
      expect(draft.type, TradeOrderType.limit);
      expect(draft.price, 67543.21);
      expect(draft.amount, .1);
    });
  });

  group('TradeBackendContractMissingException', () {
    const exception = TradeBackendContractMissingException();

    test('is an Exception with a stable message contract', () {
      expect(exception, isA<Exception>());
      expect(
        exception.message,
        'Trade remote repository is required when mock data is disabled.',
      );
    });

    test('userMessage is a distinct, user-facing string', () {
      expect(
        exception.userMessage,
        'Trade service is unavailable because the production backend is '
        'not configured yet.',
      );
    });

    test('toString includes the type name and message', () {
      expect(
        exception.toString(),
        'TradeBackendContractMissingException: '
        'Trade remote repository is required when mock data is disabled.',
      );
    });
  });
}
