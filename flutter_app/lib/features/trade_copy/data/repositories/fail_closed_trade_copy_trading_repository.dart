import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/repositories/trade_copy_trading_repository.dart';

final class FailClosedTradeCopyTradingRepository
    implements TradeCopyTradingRepository {
  const FailClosedTradeCopyTradingRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TradeBackendContractMissingException();
  }
}
