// Entities the `trade` feature's own repository/controllers depend on
// (spot order/history/settings/positions from `trade_core`, futures/margin/
// leverage from `trade_terminal`) — the same two libraries
// `SpotTradeRepository`/`TradeFuturesMarginRepository` themselves import.
export 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
export 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
