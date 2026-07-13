import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/repositories/trade_repository.dart';

final class FailClosedTradeRepository implements TradeRepository {
  const FailClosedTradeRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TradeBackendContractMissingException();
  }
}
