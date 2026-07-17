import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/repositories/fail_closed_trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/repositories/mock_trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/trade_futures_margin_repository.dart';

// Terminal-domain repository providers (trade_terminal extraction, Batch 3
// of Phase 4 of the trade module split — the final domain phase).
// Previously narrow views of `trade_core`'s `tradeRepositoryProvider`
// (`ref.watch(tradeRepositoryProvider)`, from Batch 1 of this phase); now
// construct their own independent mock/fail-closed implementation
// directly, mirroring the exact mock-vs-fail-closed decision `trade_core`'s
// own provider makes (see
// `trade_core/data/providers/trade_repository_provider.dart`) via the same
// `guardedRepository` helper. Both providers share one combined
// [MockTradeTerminalRepository]/[FailClosedTradeTerminalRepository] pair
// (see those classes' doc comments for why the two terminal interfaces are
// combined rather than split), so `guardedRepository` is called twice with
// the same `featureName` — once narrowed to each interface, exactly as
// `trade_bots` does for its own combined pair. When this domain gets a
// real backend, pass a `remote:` factory here — the other trade domains
// are unaffected.
//
// Phase 5 (2026-07-15): `trade_terminal`'s own advanced-tools pages now
// watch these two providers directly (via
// `app/providers/trade_terminal_controller_providers.dart`) instead of
// `trade_core`'s 6-way `TradeRepository` union — the last consumer of that
// union outside `trade_core` itself and the 62-legacy-page read model. This
// file no longer re-exports `trade_core`'s union provider.

final spotTradeRepositoryProvider = Provider<SpotTradeRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'TradeTerminal',
    mock: () => const MockTradeTerminalRepository(),
    failClosed: () => const FailClosedTradeTerminalRepository(),
  ),
);

final tradeFuturesMarginRepositoryProvider =
    Provider<TradeFuturesMarginRepository>(
      (ref) => guardedRepository(
        ref,
        featureName: 'TradeTerminal',
        mock: () => const MockTradeTerminalRepository(),
        failClosed: () => const FailClosedTradeTerminalRepository(),
      ),
    );
