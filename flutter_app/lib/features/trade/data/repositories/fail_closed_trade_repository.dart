import 'package:vit_trade_flutter/features/trade/domain/entities/trade_errors.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

final class FailClosedTradeRepository implements TradeRepository {
  const FailClosedTradeRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TradeBackendContractMissingException();
  }
}
