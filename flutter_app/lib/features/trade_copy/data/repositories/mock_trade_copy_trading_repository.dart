import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/repositories/trade_copy_trading_repository.dart';

part '../fixtures/trade_copy_configuration_repository_methods.dart';
part '../fixtures/trade_copy_configuration_repository_fixtures.dart';
part '../fixtures/trade_copy_lifecycle_repository_methods.dart';
part '../fixtures/trade_copy_lifecycle_repository_fixtures.dart';
part '../fixtures/trade_copy_provider_discovery_repository_methods.dart';
part '../fixtures/trade_copy_provider_discovery_repository_fixtures.dart';

mixin _MockTradeCopyTradingRepositoryBase
    implements TradeCopyTradingRepository {}

/// Independent mock implementation of [TradeCopyTradingRepository]
/// (trade_copy extraction, Batch 3 of Phase 2 of the trade module split).
/// Owns its own fixtures under `data/fixtures/` — it no longer shares a
/// class or `part`-file library with
/// `features/trade/data/repositories/mock_trade_repository.dart`.
/// [MockTradeRepository] now delegates its [TradeCopyTradingRepository]
/// surface to an instance of this class instead of implementing it
/// directly (see `_MockTradeRepositoryCopyTradingDelegate` there).
final class MockTradeCopyTradingRepository
    with
        _MockTradeCopyTradingRepositoryBase,
        _MockTradeCopyTradingRepositoryConfigurationMethods,
        _MockTradeCopyTradingRepositoryLifecycleMethods,
        _MockTradeCopyTradingRepositoryProviderDiscoveryMethods {
  const MockTradeCopyTradingRepository();
}
