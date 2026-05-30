import 'package:flutter/material.dart';

final class HomeAnnouncement {
  const HomeAnnouncement({required this.text});

  final String text;
}

final class HomeQuickAction {
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

final class HomeCryptoPair {
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

final class HomeSnapshot {
  const HomeSnapshot({
    required this.totalBalance,
    required this.dailyPnl,
    required this.dailyPct,
    required this.notifications,
    required this.homeBadge,
    required this.announcements,
    required this.quickActions,
    required this.pairs,
  });

  final double totalBalance;
  final double dailyPnl;
  final double dailyPct;
  final int notifications;
  final int homeBadge;
  final List<HomeAnnouncement> announcements;
  final List<HomeQuickAction> quickActions;
  final List<HomeCryptoPair> pairs;
}
