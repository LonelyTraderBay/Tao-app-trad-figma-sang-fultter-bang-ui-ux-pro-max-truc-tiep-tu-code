import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/repositories/trade_repository.dart';

import '../repositories/fail_closed_trade_repository.dart';
import '../repositories/mock_trade_repository.dart';

/// Base trade repository provider (Phase 0 of the trade module split).
///
/// All 6 narrow, per-domain views of this provider (spot, futures/margin,
/// copy-trading, bots, bot analytics, regulatory) have now moved to their
/// own domain modules and construct their own independent mock/fail-closed
/// implementations directly instead of narrowing this provider — this one
/// remains only for the 62 read-only pages still wired through the full
/// [TradeRepository] union. [MockTradeRepository] itself moved here from
/// `features/trade/data/repositories/` in the trade_terminal extraction
/// (Batch 3 of Phase 4 of the trade module split — the final domain phase),
/// once it became a pure delegation hub with no domain logic of its own
/// (see that class's doc comment).
final tradeRepositoryProvider = Provider<TradeRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Trade',
    mock: () => const MockTradeRepository(),
    failClosed: () => const FailClosedTradeRepository(),
  ),
);
