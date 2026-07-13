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

mixin _MockTradeBotsRepositoryBase
    implements TradingBotsRepository, TradeBotAnalyticsRepository {}

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
final class MockTradeBotsRepository
    with
        _MockTradeBotsRepositoryBase,
        _MockTradeBotsRepositoryBacktestPortfolioMethods,
        _MockTradeBotsRepositoryLifecycleRiskMethods {
  const MockTradeBotsRepository();
}
