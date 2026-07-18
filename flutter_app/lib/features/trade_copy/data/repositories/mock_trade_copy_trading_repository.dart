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

/// GD4-F3: `abstract class` (not `mixin`) because it now holds the
/// `simulateError`/`loadDelay` constructor fields — 3 method mixins below
/// (`on _MockTradeCopyTradingRepositoryBase`) share `_simulateNetwork()`
/// declared here in the base rather than in "the first mixin" (khuôn
/// wallet's single-mixin split) since trade_copy splits across 3 mixins
/// that all need it (GD4-Async-Playbook.md §9 bẫy mới).
abstract class _MockTradeCopyTradingRepositoryBase
    implements TradeCopyTradingRepository {
  const _MockTradeCopyTradingRepositoryBase({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  /// When `true`, every method throws a [StateError] after [loadDelay] —
  /// used to exercise error/retry UI states in tests.
  final bool simulateError;

  /// Simulated network latency before a method resolves. Tests should pass
  /// [Duration.zero] to avoid slowing down the suite.
  final Duration loadDelay;

  /// Shared network simulation for every method: awaits [loadDelay], then
  /// throws when [simulateError] is set. Khuôn MockHomeRepository.
  ///
  /// Delay 0 thì KHÔNG tạo timer — Future.delayed(Duration.zero) vẫn là
  /// timer và tester.pump() không-duration không đẩy fake clock (GD4-Async-
  /// Playbook.md §9 bẫy 9.10).
  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) {
      throw StateError('trade_copy_mock_fetch_failed');
    }
  }
}

/// Independent mock implementation of [TradeCopyTradingRepository]
/// (trade_copy extraction, Batch 3 of Phase 2 of the trade module split).
/// Owns its own fixtures under `data/fixtures/` — it no longer shares a
/// class or `part`-file library with
/// `features/trade/data/repositories/mock_trade_repository.dart`.
/// [MockTradeRepository] now delegates its [TradeCopyTradingRepository]
/// surface to an instance of this class instead of implementing it
/// directly (see `_MockTradeRepositoryCopyTradingDelegate` there).
final class MockTradeCopyTradingRepository
    extends _MockTradeCopyTradingRepositoryBase
    with
        _MockTradeCopyTradingRepositoryConfigurationMethods,
        _MockTradeCopyTradingRepositoryLifecycleMethods,
        _MockTradeCopyTradingRepositoryProviderDiscoveryMethods {
  const MockTradeCopyTradingRepository({super.simulateError, super.loadDelay});
}
