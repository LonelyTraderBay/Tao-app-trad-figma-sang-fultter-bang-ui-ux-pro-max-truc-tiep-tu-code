import 'package:flutter/material.dart';

/// Resolves the domain-safe icon keys stored on Markets entities
/// (`MarketSector`, `MarketNewsItem`, `MarketScreenerPreset`,
/// `AdvancedDrawingTool`) to real Flutter [IconData] values. Keeps
/// `market_entities.dart` free of any Flutter UI import.
final class MarketIconTokens {
  const MarketIconTokens._();

  static const Map<String, IconData> _icons = {
    'barChart': Icons.bar_chart_rounded,
    'accountBalance': Icons.account_balance_rounded,
    'accountBalanceWallet': Icons.account_balance_wallet_rounded,
    'link': Icons.link_rounded,
    'fire': Icons.local_fire_department_rounded,
    'diamond': Icons.diamond_rounded,
    'waterDrop': Icons.water_drop_rounded,
    'upload': Icons.upload_rounded,
    'trendingUp': Icons.trending_up_rounded,
    'timeline': Icons.timeline_rounded,
    'straighten': Icons.straighten_rounded,
    'stackedLineChart': Icons.stacked_line_chart_rounded,
    'sportsEsports': Icons.sports_esports_rounded,
    'smartToy': Icons.smart_toy_rounded,
    'showChart': Icons.show_chart_rounded,
    'rocketLaunch': Icons.rocket_launch_rounded,
    'radar': Icons.radar_rounded,
    'pets': Icons.pets_rounded,
    'palette': Icons.palette_rounded,
    'notes': Icons.notes_rounded,
    'lock': Icons.lock_rounded,
    'horizontalRule': Icons.horizontal_rule_rounded,
    'formatListNumbered': Icons.format_list_numbered_rounded,
    'dateRange': Icons.date_range_rounded,
    'cropSquare': Icons.crop_square_rounded,
    'creditCard': Icons.credit_card_rounded,
    'circleOutlined': Icons.circle_outlined,
    'balance': Icons.balance_rounded,
  };

  static IconData icon(String key) => _icons[key] ?? Icons.circle_outlined;
}
