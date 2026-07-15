import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketSectorDistributionCard extends StatelessWidget {
  const MarketSectorDistributionCard({required this.sectors, super.key});

  final List<MarketSector> sectors;

  @override
  Widget build(BuildContext context) {
    final total = sectors.fold<double>(
      0,
      (sum, sector) => sum + sector.totalMarketCap,
    );
    final visible = sectors
        .where((sector) => _allocation(sector, total) >= 1)
        .toList();

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: MarketsSpacingTokens.marketSectorDistributionHeight,
      padding: MarketsSpacingTokens.marketSectorCardPadding,
      borderColor: marketSectorAccent.withValues(alpha: 0.20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: marketSectorAccent.withValues(alpha: 0.16),
                borderRadius: AppRadii.smRadius,
                child: const SizedBox.square(
                  dimension: MarketsSpacingTokens.marketSectorDistributionIcon,
                  child: Icon(
                    Icons.pie_chart_rounded,
                    color: marketSectorAccent,
                    size:
                        MarketsSpacingTokens.marketSectorDistributionIconGlyph,
                  ),
                ),
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketSectorDistributionHeaderGap,
              ),
              Expanded(
                child: Text(
                  'Phân bổ vốn hóa theo ngành',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: MarketsSpacingTokens.marketSectorLineHeightTitle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Material(
            color: AppColors.surface3,
            borderRadius: AppRadii.pillRadius,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: MarketsSpacingTokens.marketSectorDistributionBarHeight,
              child: Row(
                children: [
                  for (final sector in visible)
                    Expanded(
                      flex: math.max(
                        1,
                        (_allocation(sector, total) * 10).round(),
                      ),
                      child: ColoredBox(color: sector.color.resolve()),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: MarketsSpacingTokens.marketSectorDistributionBarGap,
          ),
          Expanded(
            child: Wrap(
              spacing: MarketsSpacingTokens.marketSectorCardHeaderGap,
              runSpacing: MarketsSpacingTokens.marketSectorChipGap,
              children: [
                for (final sector in visible)
                  _LegendItem(
                    color: sector.color.resolve(),
                    label:
                        '${sector.nameVi} ${_allocation(sector, total).toStringAsFixed(1)}%',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _allocation(MarketSector sector, double total) {
    if (total <= 0) return 0;
    return sector.totalMarketCap / total * 100;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          borderRadius: AppRadii.hairlineRadius,
          child: const SizedBox.square(
            dimension: MarketsSpacingTokens.marketSectorLegendDot,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketSectorLegendGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}
