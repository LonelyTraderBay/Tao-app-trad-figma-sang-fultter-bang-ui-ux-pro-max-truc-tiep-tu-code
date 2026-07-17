// Single import surface for `trade`'s own pages/widgets — mirrors what they
// used to get transitively from `trade_core`'s `trade_controller.dart`
// mega-barrel (entities + TradeHighRiskFlowStatus + controllers), but scoped
// to only what `trade` actually owns/needs. `TradeHighRiskFlowStatus` is
// re-exported with `show` to avoid pulling in `trade_core`'s
// `TradeReadModelController`/`TradeRepository` (would clash with this
// feature's own `TradeRepository`).
export 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;

export '../../domain/entities/trade_entities.dart';
export 'trade_order_controller_models.dart';
export 'trade_futures_margin_controller_models.dart';
