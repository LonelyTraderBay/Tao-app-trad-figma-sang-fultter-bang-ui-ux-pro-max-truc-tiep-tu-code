import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

final class AppModuleAccents {
  const AppModuleAccents._();

  static const Color neutral = AppColors.text2;

  static const Color home = AppColors.primary;
  static const Color markets = AppColors.accent;
  static const Color trade = AppColors.primary;
  static const Color wallet = AppColors.primarySoft;
  static const Color profile = AppColors.text2;
  static const Color earn = AppColors.primarySoft;
  static const Color predictions = AppColors.accent;
  static const Color arena = AppColors.moduleAccentAmber;
  static const Color p2p = AppColors.moduleAccentAmber;
  static const Color referral = AppColors.primary;
  static const Color rewards = referral;
  static const Color support = AppColors.primary;
  static const Color launchpad = AppColors.primary;
  static const Color dca = trade;
  static const Color discovery = markets;
  static const Color news = markets;
  static const Color notifications = AppColors.primary;
  static const Color onboarding = AppColors.primary;
  static const Color admin = neutral;
  static const Color auth = AppColors.primary;
  static const Color crossModule = AppColors.accent;
  static const Color dev = neutral;
  static const Color enterpriseStates = neutral;

  static const Map<String, Color> registry = {
    'admin': admin,
    'arena': arena,
    'auth': auth,
    'cross_module': crossModule,
    'dca': dca,
    'dev': dev,
    'discovery': discovery,
    'earn': earn,
    'enterprise_states': enterpriseStates,
    'home': home,
    'launchpad': launchpad,
    'markets': markets,
    'news': news,
    'notifications': notifications,
    'onboarding': onboarding,
    'p2p': p2p,
    'predictions': predictions,
    'profile': profile,
    'referral': referral,
    'rewards': rewards,
    'support': support,
    'trade': trade,
    'wallet': wallet,
  };

  static const Map<String, String> aliases = {
    'crossmodule': 'cross_module',
    'enterprise': 'enterprise_states',
    'open_arena': 'arena',
    'prediction': 'predictions',
    'prediction_markets': 'predictions',
    'trading': 'trade',
  };

  static Iterable<String> get keys => registry.keys;

  static Color forKey(String key, {Color? fallback}) {
    final normalized = key.trim().toLowerCase().replaceAll('-', '_');
    final canonical = aliases[normalized] ?? normalized;
    return registry[canonical] ?? fallback ?? neutral;
  }
}
