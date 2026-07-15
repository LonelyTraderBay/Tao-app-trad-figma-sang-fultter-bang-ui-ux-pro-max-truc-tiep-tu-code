import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_product_tabs.dart';

/// Product tab + overflow navigation result handed to
/// [TradeProductNavigationBuilder] callers (see
/// `trade_module_layout.dart`'s `tradeShellWithProductTabs`).
///
/// This is a generic data contract only — `trade_core` has zero knowledge of
/// which routes/tabs any given caller supplies via it. The concrete factory
/// that knows about specific routes (e.g. Spot/Futures/Margin/Convert)
/// belongs in the module that owns those routes, not here. See
/// `trade/presentation/widgets/hub/trade_product_navigation.dart`'s
/// `buildTradeProductNavigation` for the one nav source `trade_terminal`
/// pages should pass in.
final class TradeProductNavigation {
  const TradeProductNavigation({required this.tabs, required this.overflow});

  final List<VitTradeProductTab> tabs;
  final List<VitTradeProductOverflowItem> overflow;
}

/// Signature for a module-owned product-tab nav source, injected explicitly
/// into `tradeShellWithProductTabs` / `VitTradeHubScaffold` /
/// `VitTradeDetailScaffold` via their `navigationBuilder` parameter.
/// `trade_core` never supplies a default implementation for this — every
/// caller that wants the product-tab bar must pass its own module-owned
/// builder (currently only `trade`'s `buildTradeProductNavigation`
/// exists). This keeps `trade_core` free of any specific-route knowledge.
typedef TradeProductNavigationBuilder =
    TradeProductNavigation Function({
      required BuildContext context,
      TradePair? pair,
      required String activeId,
      Key Function(String id)? quickNavKey,
    });
