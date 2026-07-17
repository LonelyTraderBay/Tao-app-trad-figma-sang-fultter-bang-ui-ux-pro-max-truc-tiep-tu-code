import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_product_tabs.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_product_hub.dart';

/// Product tab + overflow navigation result handed to
/// [TradeProductNavigationBuilder] callers (see
/// `trade_module_layout.dart`'s `tradeShellWithProductTabs`).
///
/// This is a generic data contract only — `trade_core` has zero knowledge of
/// which routes/tabs any given caller supplies via it. The concrete factory
/// that knows about specific routes (e.g. Spot/Futures/Margin/Convert) is
/// [buildTradeProductNavigation] below, also owned by this file.
///
/// ARCH-A1 (2026-07-17) note: the old rule of thumb ("the factory belongs in
/// the module that owns the routes it points to") does not apply here.
/// `trade_core` is the kernel of the trade family — every sibling module
/// already depends on it, so keeping the one shared nav source here (instead
/// of in `trade`) removes a `trade_terminal` -> `trade` -> `trade_terminal`
/// import cycle without inventing a new shared module. This is a deliberate
/// DRIFT from the original migration manifest, which assumed the two
/// `trade_product_navigation.dart` files (this one and the now-deleted
/// `trade/presentation/widgets/hub/trade_product_navigation.dart`) were
/// duplicates of each other; they were not — one was a generic contract, the
/// other a route-aware factory — so "de-duplicating" them means merging, not
/// picking either file as-is.
final class TradeProductNavigation {
  const TradeProductNavigation({required this.tabs, required this.overflow});

  final List<VitTradeProductTab> tabs;
  final List<VitTradeProductOverflowItem> overflow;
}

/// Signature for a module-owned product-tab nav source, injected explicitly
/// into `tradeShellWithProductTabs` / `VitTradeHubScaffold` /
/// `VitTradeDetailScaffold` via their `navigationBuilder` parameter.
/// `trade_core` supplies the one nav source in active use
/// ([buildTradeProductNavigation], below) — see the ARCH-A1 note on
/// [TradeProductNavigation] for why it lives here rather than in `trade`.
typedef TradeProductNavigationBuilder =
    TradeProductNavigation Function({
      required BuildContext context,
      TradePair? pair,
      required String activeId,
      Key Function(String id)? quickNavKey,
    });

/// Default instrument context for product tabs on hub/detail pages.
const TradePair kTradeShellDefaultPair = TradePair(
  id: 'btcusdt',
  symbol: 'BTC/USDT',
  baseAsset: 'BTC',
  quoteAsset: 'USDT',
  price: 67543.21,
  changePct: 2.5,
  logoColorHex: 0xFFF7931A,
);

/// `trade` product tab + overflow navigation source (Spot/Futures/Margin/Convert).
///
/// This is the ONE nav-bar source `trade_core`'s `tradeShellWithProductTabs`
/// (via its `navigationBuilder` parameter) is meant to be pointed at. It only
/// knows about the 4 `trade`-domain routes (Spot/Futures/Margin/
/// Convert) — `trade_copy`, `trade_bots`, and `trade_compliance` pages must
/// NOT pass this as their nav source (there is no shared "trade" product
/// switcher across modules; each module either leaves `showProductTabs` at
/// its default `false` or builds its own domain-appropriate nav source).
///
/// See the ARCH-A1 note on [TradeProductNavigation] for why this factory —
/// despite knowing about `trade`-owned routes — lives in `trade_core`
/// instead of `trade`.
TradeProductNavigation buildTradeProductNavigation({
  required BuildContext context,
  TradePair? pair,
  required String activeId,
  Key Function(String id)? quickNavKey,
}) {
  final resolvedPair = pair ?? kTradeShellDefaultPair;
  final hubItems = _tradeHubItems(
    context,
    resolvedPair,
    quickNavKey: quickNavKey,
  );
  const primaryIds = ['spot', 'futures', 'margin', 'convert'];

  VitTradeProductTab tabFor(VitTradeHubItem item) => VitTradeProductTab(
    id: item.id,
    label: item.label,
    tabKey: item.tileKey,
    onTap: item.onTap,
  );

  VitTradeProductOverflowItem overflowFor(VitTradeHubItem item) =>
      VitTradeProductOverflowItem(
        id: item.id,
        label: item.label,
        badge: item.badge,
        icon: item.icon,
        accentColor: item.accentColor,
        tileKey: item.tileKey,
        onTap: item.onTap,
      );

  return TradeProductNavigation(
    tabs: [
      for (final id in primaryIds)
        tabFor(hubItems.firstWhere((item) => item.id == id)),
    ],
    overflow: [
      for (final item in hubItems)
        if (!primaryIds.contains(item.id)) overflowFor(item),
    ],
  );
}

List<VitTradeHubItem> _tradeHubItems(
  BuildContext context,
  TradePair pair, {
  Key Function(String id)? quickNavKey,
}) {
  Key navKey(String id) => quickNavKey?.call(id) ?? Key('trade_nav_$id');

  // L1 trade modes only. Overflow tiles (Bot, Copy, Wallet, …) live on Home
  // quick actions and Wallet bottom nav — no duplicate "Thêm" sheet entries.
  return [
    VitTradeHubItem(
      id: 'spot',
      label: 'Spot',
      badge: 'Core',
      icon: Icons.show_chart_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: navKey('spot'),
      onTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
    ),
    VitTradeHubItem(
      id: 'convert',
      label: 'Convert',
      badge: 'Core',
      icon: Icons.swap_horiz_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: navKey('convert'),
      onTap: () => context.go(AppRoutePaths.tradeConvert),
    ),
    VitTradeHubItem(
      id: 'futures',
      label: 'Futures',
      badge: 'Risk',
      icon: Icons.bar_chart_rounded,
      accentColor: AppColors.sell,
      tileKey: navKey('futures'),
      onTap: () => context.go(AppRoutePaths.tradeFutures(pair.id)),
    ),
    VitTradeHubItem(
      id: 'margin',
      label: 'Margin',
      badge: 'Pro',
      icon: Icons.trending_up_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: navKey('margin'),
      onTap: () => context.go(AppRoutePaths.tradeMargin),
    ),
  ];
}
