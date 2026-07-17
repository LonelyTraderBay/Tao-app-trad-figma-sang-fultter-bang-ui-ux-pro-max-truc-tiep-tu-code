import 'package:vit_trade_flutter/features/markets/domain/entities/market_errors.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

final class FailClosedMarketRepository implements MarketRepository {
  const FailClosedMarketRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const MarketBackendContractMissingException();
  }
}
