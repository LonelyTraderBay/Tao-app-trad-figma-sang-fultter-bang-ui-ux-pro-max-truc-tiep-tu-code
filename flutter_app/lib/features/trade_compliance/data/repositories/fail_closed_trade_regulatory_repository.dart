import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/repositories/trade_regulatory_repository.dart';

final class FailClosedTradeRegulatoryRepository
    implements TradeRegulatoryRepository {
  const FailClosedTradeRegulatoryRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TradeBackendContractMissingException();
  }
}
