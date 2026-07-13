import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/repositories/trade_regulatory_repository.dart';

part '../fixtures/trade_regulatory_costs_repository_methods.dart';
part '../fixtures/trade_regulatory_costs_repository_fixtures.dart';
part '../fixtures/trade_regulatory_disclosures_repository_methods.dart';
part '../fixtures/trade_regulatory_disclosures_repository_fixtures.dart';
part '../fixtures/trade_regulatory_disputes_repository_methods.dart';
part '../fixtures/trade_regulatory_disputes_repository_fixtures.dart';
part '../fixtures/trade_execution_analytics_repository_methods.dart';
part '../fixtures/trade_execution_analytics_repository_fixtures.dart';

mixin _MockTradeRegulatoryRepositoryBase implements TradeRegulatoryRepository {}

/// Independent mock implementation of [TradeRegulatoryRepository]
/// (trade_compliance extraction, Batch 3 of Phase 1 of the trade module
/// split). Owns its own fixtures under `data/fixtures/` — it no longer
/// shares a class or `part`-file library with
/// `features/trade/data/repositories/mock_trade_repository.dart`.
/// [MockTradeRepository] now delegates its [TradeRegulatoryRepository]
/// surface to an instance of this class instead of implementing it
/// directly (see `_MockTradeRepositoryRegulatoryDelegate` there).
final class MockTradeRegulatoryRepository
    with
        _MockTradeRegulatoryRepositoryBase,
        _MockTradeRegulatoryRepositoryCostsMethods,
        _MockTradeRegulatoryRepositoryDisclosuresMethods,
        _MockTradeRegulatoryRepositoryDisputesMethods,
        _MockTradeRegulatoryRepositoryExecutionAnalyticsMethods {
  const MockTradeRegulatoryRepository();
}
