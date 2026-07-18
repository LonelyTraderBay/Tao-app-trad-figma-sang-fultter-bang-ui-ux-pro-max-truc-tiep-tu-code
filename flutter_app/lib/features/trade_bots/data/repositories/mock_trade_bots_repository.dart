import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trade_bot_analytics_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trading_bots_repository.dart';

part '../fixtures/trade_bot_backtest_portfolio_repository_methods.dart';
part '../fixtures/trade_bot_backtest_portfolio_repository_fixtures.dart';
part '../fixtures/trade_bot_guide_docs_repository_fixtures.dart';
part '../fixtures/trade_bot_lifecycle_risk_repository_methods.dart';
part '../fixtures/trade_bot_lifecycle_risk_repository_fixtures.dart';

abstract class _MockTradeBotsRepositoryBase
    implements TradingBotsRepository, TradeBotAnalyticsRepository {
  const _MockTradeBotsRepositoryBase({
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
  /// Declared here (on the base class, not inside either method mixin) so
  /// both `_MockTradeBotsRepositoryBacktestPortfolioMethods` and
  /// `_MockTradeBotsRepositoryLifecycleRiskMethods` can call it without one
  /// mixin depending on the other's `on` clause (GD4-F3 bẫy — the F2 pilot
  /// only ever had a single method-mixin per mock repo).
  ///
  /// Delay 0 thì KHÔNG tạo timer — Future.delayed(Duration.zero) vẫn là
  /// timer và tester.pump() không-duration không đẩy fake clock (bẫy F2,
  /// xem GD4-Async-Playbook §9).
  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) {
      throw StateError('trade_bots_mock_fetch_failed');
    }
  }
}

/// Independent mock implementation of both [TradingBotsRepository] and
/// [TradeBotAnalyticsRepository] (trade_bots extraction, Batch 3 of Phase 3
/// of the trade module split). Owns its own fixtures under `data/fixtures/`
/// — it no longer shares a class or `part`-file library with
/// `features/trade/data/repositories/mock_trade_repository.dart`.
/// [MockTradeRepository] now delegates its [TradingBotsRepository] and
/// [TradeBotAnalyticsRepository] surface to an instance of this class
/// instead of implementing it directly (see
/// `_MockTradeRepositoryBotsDelegate` there).
///
/// Both bot repository interfaces are combined into a single mock class
/// (rather than two independent ones, the way `trade_compliance` and
/// `trade_copy` each only had one interface to decouple) because that
/// mirrors how the pre-extraction union already composed them: the base
/// `TradeRepository`/`MockTradeRepository` never treated
/// `TradingBotsRepository` and `TradeBotAnalyticsRepository` as one merged
/// surface, but it did always implement both on the *same* final class via
/// two distinct per-interface mixin groups
/// (`_MockTradeRepositoryBotLifecycleRiskMethods` for the former,
/// `_MockTradeRepositoryBotBacktestPortfolioMethods` for the latter). This
/// class keeps that same "two mixin groups, one class" shape under its new
/// name.
final class MockTradeBotsRepository extends _MockTradeBotsRepositoryBase
    with
        _MockTradeBotsRepositoryBacktestPortfolioMethods,
        _MockTradeBotsRepositoryLifecycleRiskMethods {
  const MockTradeBotsRepository({super.simulateError, super.loadDelay});
}
