import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';

import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

/// Mirrors [FailClosedTradeTerminalRepository] — `trade`'s own
/// [TradeRepository] is a subset of the same [SpotTradeRepository] +
/// [TradeFuturesMarginRepository] surface, so it fails closed the same way.
final class FailClosedTradeRepository implements TradeRepository {
  const FailClosedTradeRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TradeBackendContractMissingException();
  }
}
