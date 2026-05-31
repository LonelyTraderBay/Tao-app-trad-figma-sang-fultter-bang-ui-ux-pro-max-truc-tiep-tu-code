import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_data_viz_colors.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';

const marketHeatmapPrimary = AppColors.primary;

final class MarketHeatmapKeys {
  const MarketHeatmapKeys._();

  static const content = Key('sc013_market_heatmap_scroll_content');
  static const metric24h = Key('sc013_metric_24h');
  static const metric7d = Key('sc013_metric_7d');
  static const detailButton = Key('sc013_heatmap_detail_button');

  static Key category(String category) => Key('sc013_category_$category');

  static Key tile(String id) => Key('sc013_heatmap_tile_$id');
}

final class MarketHeatmapTilePlacement {
  const MarketHeatmapTilePlacement({
    required this.coin,
    required this.columnSpan,
    required this.rowSpan,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final HeatmapCoin coin;
  final int columnSpan;
  final int rowSpan;
  final double left;
  final double top;
  final double width;
  final double height;
}

final class MarketHeatmapGridPosition {
  const MarketHeatmapGridPosition({required this.row, required this.column});

  final int row;
  final int column;
}

final class MarketHeatmapLegendSpec {
  const MarketHeatmapLegendSpec({required this.label, required this.color});

  final String label;
  final Color color;
}

const marketHeatmapTextShadow = [
  Shadow(color: AppColors.modalScrim, blurRadius: 2, offset: Offset(0, 1)),
];

HeatmapCoin? marketHeatmapFindCoin(List<HeatmapCoin> coins, String? id) {
  if (id == null) return null;
  for (final coin in coins) {
    if (coin.id == id) return coin;
  }
  return null;
}

Color marketHeatmapColor(double change) {
  if (change >= 8) return AppDataVizColors.heatmapExtremePositive;
  if (change >= 5) return AppDataVizColors.heatmapStrongPositive;
  if (change >= 2) return AppDataVizColors.heatmapMediumPositive;
  if (change >= 0) return AppDataVizColors.heatmapSoftPositive;
  if (change >= -2) return AppDataVizColors.heatmapSoftNegative;
  if (change >= -5) return AppDataVizColors.heatmapMediumNegative;
  return AppDataVizColors.heatmapStrongNegative;
}

String marketHeatmapFormatCompact(double value) {
  return '\$${_formatNumber(value / 1000000000, 2)}B';
}

String marketHeatmapFormatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String marketHeatmapFormatPrice(double value) {
  if (value >= 1000) return '\$${_formatNumber(value, 2)}';
  if (value < 1) return '\$${value.toStringAsFixed(4)}';
  return '\$${value.toStringAsFixed(2)}';
}

String _formatNumber(double value, int fractionDigits) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length == 1 || fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
