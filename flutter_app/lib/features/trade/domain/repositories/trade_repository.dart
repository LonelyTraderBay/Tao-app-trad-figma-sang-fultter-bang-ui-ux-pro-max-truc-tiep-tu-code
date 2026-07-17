import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/trade_futures_margin_repository.dart';

/// Repository contract owned by the `trade` feature itself (spot / futures /
/// margin / convert basic trading surface).
///
/// Scoped to exactly what `trade`'s own pages need: [SpotTradeRepository] +
/// [TradeFuturesMarginRepository], both owned by `trade_terminal`. The old
/// 6-way `TradeRepository` union in `trade_core` this used to sit alongside
/// has been removed — every trade-family sibling now has its own narrow
/// repository barrel instead of routing through a shared hub.
abstract interface class TradeRepository
    implements SpotTradeRepository, TradeFuturesMarginRepository {}
