import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trade_bot_analytics_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trading_bots_repository.dart';

/// Combined fail-closed implementation of both [TradingBotsRepository] and
/// [TradeBotAnalyticsRepository], mirroring the single combined
/// [MockTradeBotsRepository] this domain uses (see that class's doc comment
/// for why the two interfaces share one implementation instead of two).
final class FailClosedTradeBotsRepository
    implements TradingBotsRepository, TradeBotAnalyticsRepository {
  const FailClosedTradeBotsRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TradeBackendContractMissingException();
  }
}
