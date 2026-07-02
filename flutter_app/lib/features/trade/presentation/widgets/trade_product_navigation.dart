import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_product_tabs.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_product_hub.dart';

/// Product tab + overflow navigation shared by Spot, Futures, and Margin L1.
final class TradeProductNavigation {
  const TradeProductNavigation({required this.tabs, required this.overflow});

  final List<VitTradeProductTab> tabs;
  final List<VitTradeProductOverflowItem> overflow;
}

TradeProductNavigation buildTradeProductNavigation({
  required BuildContext context,
  required TradePair pair,
  required String activeId,
  Key Function(String id)? quickNavKey,
}) {
  final hubItems = _tradeHubItems(context, pair, quickNavKey: quickNavKey);
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
    VitTradeHubItem(
      id: 'bots',
      label: 'Bot',
      badge: 'Auto',
      icon: Icons.smart_toy_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: navKey('bots'),
      onTap: () => context.go(AppRoutePaths.tradeBots),
    ),
    VitTradeHubItem(
      id: 'copy',
      label: 'Copy',
      badge: 'Social',
      icon: Icons.content_copy_rounded,
      accentColor: AppModuleAccents.trade,
      tileKey: navKey('copy'),
      onTap: () => context.go(AppRoutePaths.tradeCopyTrading),
    ),
    VitTradeHubItem(
      id: 'dca',
      label: 'DCA',
      badge: 'Plan',
      icon: Icons.repeat_rounded,
      accentColor: AppModuleAccents.dca,
      tileKey: navKey('dca'),
      onTap: () => context.go(AppRoutePaths.dca),
    ),
    VitTradeHubItem(
      id: 'wallet',
      label: 'Wallet',
      badge: 'Funds',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: AppModuleAccents.wallet,
      tileKey: navKey('wallet'),
      onTap: () => context.go(AppRoutePaths.wallet),
    ),
    VitTradeHubItem(
      id: 'p2p',
      label: 'P2P',
      badge: 'Escrow',
      icon: Icons.groups_rounded,
      accentColor: AppModuleAccents.p2p,
      tileKey: navKey('p2p'),
      onTap: () => context.go(AppRoutePaths.p2p),
    ),
    VitTradeHubItem(
      id: 'earn',
      label: 'Earn',
      badge: 'Yield',
      icon: Icons.account_balance_rounded,
      accentColor: AppModuleAccents.earn,
      tileKey: navKey('earn'),
      onTap: () => context.go(AppRoutePaths.earnStaking),
    ),
    VitTradeHubItem(
      id: 'launchpad',
      label: 'Launchpad',
      badge: 'Token',
      icon: Icons.rocket_launch_rounded,
      accentColor: AppModuleAccents.launchpad,
      tileKey: navKey('launchpad'),
      onTap: () => context.go(AppRoutePaths.launchpad),
    ),
    VitTradeHubItem(
      id: 'predictions',
      label: 'Dự đoán',
      badge: 'Market',
      icon: Icons.adjust_rounded,
      accentColor: AppModuleAccents.predictions,
      tileKey: navKey('predictions'),
      onTap: () => context.go(AppRoutePaths.marketsPredictions),
    ),
    VitTradeHubItem(
      id: 'arena',
      label: 'Arena',
      badge: 'Points',
      icon: Icons.sports_esports_outlined,
      accentColor: AppModuleAccents.arena,
      tileKey: navKey('arena'),
      onTap: () => context.go(AppRoutePaths.arena),
    ),
    VitTradeHubItem(
      id: 'rewards',
      label: 'Rewards',
      badge: 'Growth',
      icon: Icons.card_giftcard_rounded,
      accentColor: AppModuleAccents.rewards,
      tileKey: navKey('rewards'),
      onTap: () => context.go(AppRoutePaths.rewards),
    ),
    VitTradeHubItem(
      id: 'support',
      label: 'Hỗ trợ',
      badge: 'Help',
      icon: Icons.support_agent_rounded,
      accentColor: AppModuleAccents.support,
      tileKey: navKey('support'),
      onTap: () => context.go(AppRoutePaths.support),
    ),
  ];
}
