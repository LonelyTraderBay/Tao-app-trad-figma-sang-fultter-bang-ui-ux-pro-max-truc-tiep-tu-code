import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class MarketHeatmapTreemap extends StatelessWidget {
  const MarketHeatmapTreemap({
    super.key,
    required this.coins,
    required this.totalMarketCap,
    required this.metric,
    required this.selectedCoinId,
    required this.onCoinSelected,
  });

  final List<HeatmapCoin> coins;
  final double totalMarketCap;
  final String metric;
  final String? selectedCoinId;
  final ValueChanged<HeatmapCoin> onCoinSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 360,
      clip: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final placements = _buildPlacements(coins, constraints.maxWidth);
          return Stack(
            children: [
              for (final placement in placements)
                Positioned(
                  left: placement.left,
                  top: placement.top,
                  width: placement.width,
                  height: placement.height,
                  child: _HeatmapTile(
                    placement: placement,
                    metric: metric,
                    selected: selectedCoinId == placement.coin.id,
                    onTap: () => onCoinSelected(placement.coin),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<MarketHeatmapTilePlacement> _buildPlacements(
    List<HeatmapCoin> sorted,
    double width,
  ) {
    const columns = 5;
    const cellHeight = 50.0;
    const gap = 4.0;
    final cellWidth = (width - (columns - 1) * gap) / columns;
    final occupied = <List<bool>>[];
    final placements = <MarketHeatmapTilePlacement>[];

    for (final coin in sorted) {
      final ratio = totalMarketCap <= 0 ? 0 : coin.marketCap / totalMarketCap;
      final columnSpan = ratio > 0.30
          ? 3
          : ratio > 0.10
          ? 2
          : 1;
      final rowSpan = ratio > 0.30
          ? 3
          : ratio > 0.15
          ? 2
          : 1;
      final position = _findSlot(
        occupied,
        columns: columns,
        columnSpan: columnSpan,
        rowSpan: rowSpan,
      );
      _occupy(
        occupied,
        row: position.row,
        column: position.column,
        columnSpan: columnSpan,
        rowSpan: rowSpan,
      );
      placements.add(
        MarketHeatmapTilePlacement(
          coin: coin,
          columnSpan: columnSpan,
          rowSpan: rowSpan,
          left: position.column * (cellWidth + gap),
          top: position.row * (cellHeight + gap),
          width: columnSpan * cellWidth + (columnSpan - 1) * gap,
          height: rowSpan * cellHeight + (rowSpan - 1) * gap,
        ),
      );
    }

    return placements;
  }

  MarketHeatmapGridPosition _findSlot(
    List<List<bool>> occupied, {
    required int columns,
    required int columnSpan,
    required int rowSpan,
  }) {
    for (var row = 0; ; row++) {
      _ensureRows(occupied, row + rowSpan, columns);
      for (var column = 0; column <= columns - columnSpan; column++) {
        var free = true;
        for (var dy = 0; dy < rowSpan && free; dy++) {
          for (var dx = 0; dx < columnSpan; dx++) {
            if (occupied[row + dy][column + dx]) {
              free = false;
              break;
            }
          }
        }
        if (free) return MarketHeatmapGridPosition(row: row, column: column);
      }
    }
  }

  void _occupy(
    List<List<bool>> occupied, {
    required int row,
    required int column,
    required int columnSpan,
    required int rowSpan,
  }) {
    for (var dy = 0; dy < rowSpan; dy++) {
      for (var dx = 0; dx < columnSpan; dx++) {
        occupied[row + dy][column + dx] = true;
      }
    }
  }

  void _ensureRows(List<List<bool>> occupied, int rows, int columns) {
    while (occupied.length < rows) {
      occupied.add(List<bool>.filled(columns, false));
    }
  }
}

class _HeatmapTile extends StatelessWidget {
  const _HeatmapTile({
    required this.placement,
    required this.metric,
    required this.selected,
    required this.onTap,
  });

  final MarketHeatmapTilePlacement placement;
  final String metric;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coin = placement.coin;
    final change = metric == '7d' ? coin.change7d : coin.change24h;
    final large = placement.columnSpan >= 2;

    return InkWell(
      key: MarketHeatmapKeys.tile(coin.id),
      onTap: onTap,
      borderRadius: AppRadii.xsRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: EdgeInsets.symmetric(horizontal: large ? 8 : 4, vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: marketHeatmapColor(change),
          border: Border.all(
            color: selected
                ? AppColors.onAccent
                : AppColors.onAccent.withValues(alpha: .10),
            width: selected ? 2 : 1,
          ),
          borderRadius: AppRadii.xsRadius,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                coin.symbol,
                style:
                    (large ? AppTextStyles.baseMedium : AppTextStyles.caption)
                        .copyWith(
                          color: AppColors.onAccent,
                          fontWeight: AppTextStyles.bold,
                          shadows: marketHeatmapTextShadow,
                          height: 1.08,
                        ),
              ),
              const SizedBox(height: 4),
              Text(
                marketHeatmapFormatPercent(change),
                style: (large ? AppTextStyles.captionSm : AppTextStyles.micro)
                    .copyWith(
                      color: AppColors.onAccent.withValues(alpha: .92),
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      shadows: marketHeatmapTextShadow,
                      height: 1,
                    ),
              ),
              if (large) ...[
                const SizedBox(height: 7),
                Text(
                  marketHeatmapFormatCompact(coin.marketCap),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.onAccent.withValues(alpha: .58),
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    shadows: marketHeatmapTextShadow,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
