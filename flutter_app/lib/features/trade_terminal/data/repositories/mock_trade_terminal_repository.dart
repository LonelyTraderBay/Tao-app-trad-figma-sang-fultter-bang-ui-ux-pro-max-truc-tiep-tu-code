import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/trade_futures_margin_repository.dart';

part '../fixtures/trade_advanced_tools_repository_methods.dart';
part '../fixtures/trade_advanced_tools_repository_fixtures.dart';
part '../fixtures/trade_conversions_utilities_repository_methods.dart';
part '../fixtures/trade_conversions_utilities_repository_fixtures.dart';
part '../fixtures/trade_core_spot_repository_methods.dart';
part '../fixtures/trade_core_spot_repository_fixtures.dart';
part '../fixtures/trade_futures_leverage_repository_methods.dart';
part '../fixtures/trade_futures_leverage_repository_fixtures.dart';

mixin _MockTradeTerminalRepositoryBase
    implements SpotTradeRepository, TradeFuturesMarginRepository {
  /// Độ trễ mô phỏng cho các đường ghi async (ADR-001); test truyền
  /// `Duration.zero`.
  Duration get loadDelay;

  /// Khi bật, các đường ghi async ném [StateError] để test nhánh lỗi.
  bool get simulateError;
}

/// Independent mock implementation of both [SpotTradeRepository] and
/// [TradeFuturesMarginRepository] (trade_terminal extraction, Batch 3 of
/// Phase 4 of the trade module split — the final domain phase). Owns its
/// own fixtures under `data/fixtures/` — it no longer shares a class or
/// `part`-file library with
/// `features/trade_core/data/repositories/mock_trade_repository.dart`
/// (formerly `features/trade/data/repositories/mock_trade_repository.dart`,
/// relocated to `trade_core` in this same batch since it became a pure
/// delegation hub once this class took over the terminal-domain logic).
/// [MockTradeRepository] now delegates its [SpotTradeRepository] and
/// [TradeFuturesMarginRepository] surface to an instance of this class
/// instead of implementing it directly (see
/// `_MockTradeRepositoryTerminalDelegate` there).
///
/// Both terminal repository interfaces are combined into a single mock
/// class (rather than two independent ones, the way `trade_compliance` and
/// `trade_copy` each only had one interface to decouple) because that
/// mirrors how the pre-extraction union already composed them — and how
/// `trade_bots` combined its own two interfaces in Batch 3 of Phase 3 (see
/// `MockTradeBotsRepository`'s doc comment for the same reasoning). The
/// base `TradeRepository`/`MockTradeRepository` never treated
/// [SpotTradeRepository] and [TradeFuturesMarginRepository] as one merged
/// surface, but it did always implement both on the *same* final class via
/// 4 distinct per-interface mixin groups: core spot
/// (`_MockTradeRepositoryCoreSpotMethods`), advanced tools
/// (`_MockTradeRepositoryAdvancedToolsMethods`) and conversions/utilities
/// (`_MockTradeRepositoryConversionsUtilitiesMethods`) composing
/// [SpotTradeRepository], and futures/leverage
/// (`_MockTradeRepositoryFuturesLeverageMethods`) composing
/// [TradeFuturesMarginRepository]. This class keeps that same "4 mixin
/// groups, one class" shape under its new name.
final class MockTradeTerminalRepository
    with
        _MockTradeTerminalRepositoryBase,
        _MockTradeTerminalRepositoryAdvancedToolsMethods,
        _MockTradeTerminalRepositoryConversionsUtilitiesMethods,
        _MockTradeTerminalRepositoryCoreSpotMethods,
        _MockTradeTerminalRepositoryFuturesLeverageMethods {
  const MockTradeTerminalRepository({
    this.loadDelay = const Duration(milliseconds: 300),
    this.simulateError = false,
  });

  @override
  final Duration loadDelay;

  @override
  final bool simulateError;
}
