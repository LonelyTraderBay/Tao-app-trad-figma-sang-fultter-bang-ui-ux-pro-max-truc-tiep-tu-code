import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/repositories/fail_closed_trade_regulatory_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/repositories/mock_trade_regulatory_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/repositories/trade_regulatory_repository.dart';

// Regulatory/compliance domain repository provider (trade_compliance
// extraction, Batch 3 of Phase 1 of the trade module split). Previously a
// narrow view of `trade_core`'s `tradeRepositoryProvider`
// (`ref.watch(tradeRepositoryProvider)`); now constructs its own
// independent mock/fail-closed implementations directly, mirroring the
// exact mock-vs-fail-closed decision `trade_core`'s own provider makes
// (see `trade_core/data/providers/trade_repository_provider.dart`) via the
// same `guardedRepository` helper. When this domain gets a real backend,
// pass a `remote:` factory here — the other trade domains are unaffected.
final tradeRegulatoryRepositoryProvider = Provider<TradeRegulatoryRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'TradeRegulatory',
    mock: () => const MockTradeRegulatoryRepository(),
    failClosed: () => const FailClosedTradeRegulatoryRepository(),
  ),
);
