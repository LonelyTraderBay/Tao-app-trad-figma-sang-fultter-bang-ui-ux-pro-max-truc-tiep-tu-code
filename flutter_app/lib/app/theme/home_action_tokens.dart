import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';

/// Resolves the domain-safe icon/accent keys stored on Home entities
/// (`HomeQuickAction`, `HomeNextAction`, `HomeRecentProduct`) to real
/// Flutter [IconData]/[Color] values. Keeps `home_entities.dart` free of
/// any Flutter UI import.
final class HomeActionTokens {
  const HomeActionTokens._();

  static const Map<String, IconData> _icons = {
    'quickBuy': Icons.bolt_rounded,
    'convert': Icons.swap_horiz_rounded,
    'wallet': Icons.account_balance_wallet_rounded,
    'p2p': Icons.groups_rounded,
    'dca': Icons.calculate_rounded,
    'staking': Icons.account_balance_rounded,
    'savings': Icons.savings_rounded,
    'launchpad': Icons.rocket_launch_rounded,
    'predictions': Icons.adjust_rounded,
    'arena': Icons.sports_esports_outlined,
    'rewards': Icons.card_giftcard_rounded,
    'support': Icons.support_agent_rounded,
    'margin': Icons.show_chart_rounded,
    'bot': Icons.smart_toy_rounded,
    'copyTrade': Icons.content_copy_rounded,
    'discover': Icons.explore_rounded,
    'referral': Icons.campaign_rounded,
    'withdraw': Icons.file_upload_outlined,
  };

  static const Map<String, Color> _accents = {
    'trade': AppModuleAccents.trade,
    'info': AppColors.info,
    'successBright': AppColors.successAccentBright,
    'caution': AppColors.caution,
    'buy': AppColors.buy,
    'riskHigh': AppColors.riskHigh,
    'predictions': AppModuleAccents.predictions,
    'crash': AppColors.crashAccent,
    'medalGold': AppColors.medalGold,
    'accentDark': AppColors.accentDark,
    'discovery': AppModuleAccents.discovery,
    'wallet': AppModuleAccents.wallet,
    'p2p': AppModuleAccents.p2p,
    'earn': AppModuleAccents.earn,
  };

  static IconData icon(String key) => _icons[key] ?? Icons.circle_outlined;

  static Color accent(String key) => _accents[key] ?? AppColors.text2;
}
