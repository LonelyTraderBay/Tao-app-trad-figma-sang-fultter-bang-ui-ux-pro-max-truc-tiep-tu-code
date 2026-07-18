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

/// GD4 Cụm F3: base class (was a marker mixin) now owns [simulateError] /
/// [loadDelay] + the shared [_simulateNetwork] helper — khuôn
/// `_MockWalletRepositoryBase`, đặt trên base thay vì "mixin đầu tiên" vì
/// đây có 4 mixin `on _MockTradeRegulatoryRepositoryBase` thật sự (không
/// phải 1 mixin duy nhất như wallet's Part01) nên helper phải nằm trên kiểu
/// constraint chung để cả 4 mixin đều thấy được (xem GD4-Async-Playbook.md
/// mục 9 — bẫy mới của cụm này).
abstract class _MockTradeRegulatoryRepositoryBase
    implements TradeRegulatoryRepository {
  const _MockTradeRegulatoryRepositoryBase({
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
  /// throws when [simulateError] is set.
  ///
  /// Delay 0 thì KHÔNG tạo timer — `Future.delayed(Duration.zero)` vẫn là
  /// timer và `tester.pump()` không-duration không đẩy fake clock (GD4
  /// Async Playbook mục 9, bẫy 9.10).
  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) {
      throw StateError('trade_regulatory_mock_fetch_failed');
    }
  }
}

/// Independent mock implementation of [TradeRegulatoryRepository]
/// (trade_compliance extraction, Batch 3 of Phase 1 of the trade module
/// split). Owns its own fixtures under `data/fixtures/` — it no longer
/// shares a class or `part`-file library with
/// `features/trade/data/repositories/mock_trade_repository.dart`.
/// [MockTradeRepository] now delegates its [TradeRegulatoryRepository]
/// surface to an instance of this class instead of implementing it
/// directly (see `_MockTradeRepositoryRegulatoryDelegate` there).
final class MockTradeRegulatoryRepository
    extends _MockTradeRegulatoryRepositoryBase
    with
        _MockTradeRegulatoryRepositoryCostsMethods,
        _MockTradeRegulatoryRepositoryDisclosuresMethods,
        _MockTradeRegulatoryRepositoryDisputesMethods,
        _MockTradeRegulatoryRepositoryExecutionAnalyticsMethods {
  const MockTradeRegulatoryRepository({super.simulateError, super.loadDelay});
}
