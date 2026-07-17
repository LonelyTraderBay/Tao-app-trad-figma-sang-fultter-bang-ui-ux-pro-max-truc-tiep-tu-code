import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';

import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/data/repositories/fail_closed_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/data/repositories/mock_trade_repository.dart';

/// `trade` feature's own repository provider — scoped to the
/// [SpotTradeRepository] + [TradeFuturesMarginRepository] surface this
/// feature's pages actually use.
///
/// Phase 6 (2026-07-15): `trade_core`'s wider 6-way `TradeRepository` union
/// provider (the class this doc comment used to distinguish itself from)
/// has been deleted entirely — this is now the only `TradeRepository`
/// provider in the trade family.
final tradeRepositoryProvider = Provider<TradeRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Trade',
    mock: () => const MockTradeRepository(),
    failClosed: () => const FailClosedTradeRepository(),
  ),
);
