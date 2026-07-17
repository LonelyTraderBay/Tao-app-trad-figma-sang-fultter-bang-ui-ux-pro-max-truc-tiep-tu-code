import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_product_tabs.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_product_hub.dart';

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
