import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trade_bot_analytics_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trading_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/repositories/trade_regulatory_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/repositories/trade_copy_trading_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/trade_futures_margin_repository.dart';

/// Union of the 6 domain repositories below. Kept for the 62 read-only
/// pages still wired through `tradeReadModelControllerProvider` and for
/// [MockTradeRepository]/[FailClosedTradeRepository], which continue to
/// implement this full surface unchanged.
///
/// This interface lives in `trade_core` (Phase 0 of the trade module
/// split). All 6 narrower interfaces it composes have now moved out of
/// `features/trade/domain/repositories/` into their own sibling modules:
/// [TradeRegulatoryRepository] moved to
/// `features/trade_compliance/domain/repositories/` in the
/// trade_compliance extraction (Batch 1 of Phase 1),
/// [TradeCopyTradingRepository] moved to
/// `features/trade_copy/domain/repositories/` in the trade_copy extraction
/// (Batch 1 of Phase 2), [TradingBotsRepository]/
/// [TradeBotAnalyticsRepository] moved to
/// `features/trade_bots/domain/repositories/` in the trade_bots extraction
/// (Batch 1 of Phase 3), and [SpotTradeRepository]/
/// [TradeFuturesMarginRepository] moved to
/// `features/trade_terminal/domain/repositories/` in the trade_terminal
/// extraction (Batch 1 of Phase 4, the final domain phase).
abstract interface class TradeRepository
    implements
        SpotTradeRepository,
        TradeFuturesMarginRepository,
        TradeCopyTradingRepository,
        TradingBotsRepository,
        TradeBotAnalyticsRepository,
        TradeRegulatoryRepository {}
