import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';

class HomeAnnouncement {
  const HomeAnnouncement({required this.text});

  final String text;
}

class HomeQuickAction {
  const HomeQuickAction({
    required this.icon,
    required this.label,
    required this.routePath,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String routePath;
  final Color accentColor;
}

class HomeCryptoPair {
  const HomeCryptoPair({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.price,
    required this.change24h,
    required this.volume24h,
    required this.sparkline,
    required this.logoColor,
    required this.isFavorite,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final double price;
  final double change24h;
  final double volume24h;
  final List<double> sparkline;
  final Color logoColor;
  final bool isFavorite;
}

class HomeMockData {
  const HomeMockData._();

  static const double totalBalance = 54276.79;
  static const double dailyPnl = 1842.31;
  static const double dailyPct = 3.52;
  static const int notifications = 3;
  static const int homeBadge = 2;

  static const announcements = [
    HomeAnnouncement(text: '🎉 Phí giao dịch 0% cho BTC/USDT trong 7 ngày!'),
    HomeAnnouncement(
      text: '⚡ Ra mắt tính năng P2P - Mua bán USDT bằng VND ngay!',
    ),
    HomeAnnouncement(text: '🔒 Bật 2FA để bảo vệ tài khoản VitTrade'),
  ];

  static const quickActions = [
    HomeQuickAction(
      icon: Icons.explore_rounded,
      label: 'Kh\u00E1m ph\u00E1',
      routePath: '/topics',
      accentColor: AppModuleAccents.markets,
    ),
    HomeQuickAction(
      icon: Icons.bolt_rounded,
      label: 'Mua nhanh',
      routePath: '/trade/btcusdt',
      accentColor: AppModuleAccents.trade,
    ),
    HomeQuickAction(
      icon: Icons.swap_horiz_rounded,
      label: 'Convert',
      routePath: '/trade/convert',
      accentColor: AppModuleAccents.trade,
    ),
    HomeQuickAction(
      icon: Icons.groups_rounded,
      label: 'P2P',
      routePath: '/p2p',
      accentColor: AppModuleAccents.wallet,
    ),
    HomeQuickAction(
      icon: Icons.rocket_launch_rounded,
      label: 'Launchpad',
      routePath: '/launchpad',
      accentColor: AppModuleAccents.home,
    ),
    HomeQuickAction(
      icon: Icons.account_balance_rounded,
      label: 'Staking',
      routePath: '/earn/staking',
      accentColor: AppModuleAccents.wallet,
    ),
    HomeQuickAction(
      icon: Icons.calculate_rounded,
      label: 'Mua \u0111\u1ECBnh k\u1EF3',
      routePath: '/dca',
      accentColor: AppModuleAccents.trade,
    ),
    HomeQuickAction(
      icon: Icons.smart_toy_rounded,
      label: 'Bot',
      routePath: '/trade/bots',
      accentColor: AppModuleAccents.trade,
    ),
    HomeQuickAction(
      icon: Icons.content_copy_rounded,
      label: 'Copy Trade',
      routePath: '/trade/copy-trading',
      accentColor: AppModuleAccents.trade,
    ),
    HomeQuickAction(
      icon: Icons.savings_rounded,
      label: 'Ti\u1EBFt ki\u1EC7m',
      routePath: '/earn/savings',
      accentColor: AppModuleAccents.wallet,
    ),
    HomeQuickAction(
      icon: Icons.card_giftcard_rounded,
      label: 'Ph\u1EA7n th\u01B0\u1EDFng',
      routePath: '/rewards',
      accentColor: AppModuleAccents.home,
    ),
    HomeQuickAction(
      icon: Icons.show_chart_rounded,
      label: 'Margin',
      routePath: '/trade/margin',
      accentColor: AppModuleAccents.trade,
    ),
    HomeQuickAction(
      icon: Icons.campaign_rounded,
      label: 'Gi\u1EDBi thi\u1EC7u',
      routePath: '/referral',
      accentColor: AppModuleAccents.home,
    ),
  ];

  static const pairs = [
    HomeCryptoPair(
      id: 'btcusdt',
      symbol: 'BTC/USDT',
      baseAsset: 'BTC',
      price: 67543.21,
      change24h: 2.34,
      volume24h: 23456789000,
      sparkline: [
        65100,
        65400,
        65200,
        65800,
        66200,
        65900,
        66500,
        67000,
        66800,
        67200,
        67100,
        67543,
      ],
      logoColor: Color(0xFFF7931A),
      isFavorite: true,
    ),
    HomeCryptoPair(
      id: 'ethusdt',
      symbol: 'ETH/USDT',
      baseAsset: 'ETH',
      price: 3521.45,
      change24h: -1.23,
      volume24h: 8765432000,
      sparkline: [
        3565,
        3555,
        3570,
        3540,
        3530,
        3545,
        3520,
        3510,
        3525,
        3515,
        3530,
        3521,
      ],
      logoColor: Color(0xFF627EEA),
      isFavorite: true,
    ),
    HomeCryptoPair(
      id: 'bnbusdt',
      symbol: 'BNB/USDT',
      baseAsset: 'BNB',
      price: 412.87,
      change24h: 3.61,
      volume24h: 1234567000,
      sparkline: [398, 400, 402, 405, 403, 407, 410, 408, 411, 413, 412.87],
      logoColor: Color(0xFFF3BA2F),
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'solusdt',
      symbol: 'SOL/USDT',
      baseAsset: 'SOL',
      price: 178.32,
      change24h: 8.07,
      volume24h: 3456789000,
      sparkline: [165, 168, 170, 172, 171, 175, 176, 179, 178, 180, 178.32],
      logoColor: Color(0xFF9945FF),
      isFavorite: true,
    ),
    HomeCryptoPair(
      id: 'xrpusdt',
      symbol: 'XRP/USDT',
      baseAsset: 'XRP',
      price: 0.6234,
      change24h: -2.59,
      volume24h: 1876543000,
      sparkline: [0.64, 0.638, 0.635, 0.632, 0.628, 0.625, 0.621, 0.6234],
      logoColor: Color(0xFF00AAE4),
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'adausdt',
      symbol: 'ADA/USDT',
      baseAsset: 'ADA',
      price: 0.4521,
      change24h: 3.22,
      volume24h: 654321000,
      sparkline: [0.438, 0.440, 0.442, 0.445, 0.448, 0.450, 0.452, 0.4521],
      logoColor: Color(0xFF0033AD),
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'dotusdt',
      symbol: 'DOT/USDT',
      baseAsset: 'DOT',
      price: 7.832,
      change24h: -3.55,
      volume24h: 432109000,
      sparkline: [8.12, 8.05, 7.98, 7.92, 7.88, 7.85, 7.83, 7.832],
      logoColor: Color(0xFFE6007A),
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'maticusdt',
      symbol: 'MATIC/USDT',
      baseAsset: 'MATIC',
      price: 0.8976,
      change24h: 5.60,
      volume24h: 789012000,
      sparkline: [0.850, 0.855, 0.862, 0.870, 0.875, 0.882, 0.890, 0.8976],
      logoColor: Color(0xFF8247E5),
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'avaxusdt',
      symbol: 'AVAX/USDT',
      baseAsset: 'AVAX',
      price: 38.54,
      change24h: 4.73,
      volume24h: 567890000,
      sparkline: [36.8, 37.0, 37.3, 37.6, 37.9, 38.1, 38.4, 38.54],
      logoColor: Color(0xFFE84142),
      isFavorite: false,
    ),
    HomeCryptoPair(
      id: 'linkusdt',
      symbol: 'LINK/USDT',
      baseAsset: 'LINK',
      price: 14.23,
      change24h: -5.76,
      volume24h: 345678000,
      sparkline: [15.10, 15.00, 14.85, 14.70, 14.55, 14.40, 14.30, 14.23],
      logoColor: Color(0xFF2A5ADA),
      isFavorite: false,
    ),
  ];
}
