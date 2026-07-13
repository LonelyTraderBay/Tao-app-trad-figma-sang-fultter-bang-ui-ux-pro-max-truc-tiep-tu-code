import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/repositories/fail_closed_trade_copy_trading_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/repositories/mock_trade_copy_trading_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/repositories/trade_copy_trading_repository.dart';

// Copy-trading domain repository provider (trade_copy extraction, Batch 3
// of Phase 2 of the trade module split). Previously a narrow view of
// `trade_core`'s `tradeRepositoryProvider`
// (`ref.watch(tradeRepositoryProvider)`); now constructs its own
// independent mock/fail-closed implementations directly, mirroring the
// exact mock-vs-fail-closed decision `trade_core`'s own provider makes
// (see `trade_core/data/providers/trade_repository_provider.dart`) via the
// same `guardedRepository` helper — the same pattern `trade_compliance`
// used in Batch 3 of Phase 1. When this domain gets a real backend, pass a
// `remote:` factory here — the other trade domains are unaffected.
final tradeCopyTradingRepositoryProvider = Provider<TradeCopyTradingRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'TradeCopyTrading',
    mock: () => const MockTradeCopyTradingRepository(),
    failClosed: () => const FailClosedTradeCopyTradingRepository(),
  ),
);
