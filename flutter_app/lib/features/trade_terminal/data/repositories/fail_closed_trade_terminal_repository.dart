import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/trade_futures_margin_repository.dart';

/// Combined fail-closed implementation of both [SpotTradeRepository] and
/// [TradeFuturesMarginRepository], mirroring the single combined
/// [MockTradeTerminalRepository] this domain uses (see that class's doc
/// comment for why the two interfaces share one implementation instead of
/// two).
final class FailClosedTradeTerminalRepository
    implements SpotTradeRepository, TradeFuturesMarginRepository {
  const FailClosedTradeTerminalRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TradeBackendContractMissingException();
  }
}
