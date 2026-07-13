import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/repositories/fail_closed_trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/repositories/mock_trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trade_bot_analytics_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trading_bots_repository.dart';

// Trading-bots domain repository providers (trade_bots extraction, Batch 3
// of Phase 3 of the trade module split). Previously narrow views of
// `trade_core`'s `tradeRepositoryProvider`
// (`ref.watch(tradeRepositoryProvider)`); now construct their own
// independent mock/fail-closed implementation directly, mirroring the exact
// mock-vs-fail-closed decision `trade_core`'s own provider makes (see
// `trade_core/data/providers/trade_repository_provider.dart`) via the same
// `guardedRepository` helper. Both providers share one combined
// [MockTradeBotsRepository]/[FailClosedTradeBotsRepository] pair (see those
// classes' doc comments for why the two bot interfaces are combined rather
// than split), so `guardedRepository` is called twice with the same
// `featureName` — once narrowed to each interface. When this domain gets a
// real backend, pass a `remote:` factory here — the other trade domains are
// unaffected.
final tradingBotsRepositoryProvider = Provider<TradingBotsRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'TradeBots',
    mock: () => const MockTradeBotsRepository(),
    failClosed: () => const FailClosedTradeBotsRepository(),
  ),
);

final tradeBotAnalyticsRepositoryProvider =
    Provider<TradeBotAnalyticsRepository>(
      (ref) => guardedRepository(
        ref,
        featureName: 'TradeBots',
        mock: () => const MockTradeBotsRepository(),
        failClosed: () => const FailClosedTradeBotsRepository(),
      ),
    );
