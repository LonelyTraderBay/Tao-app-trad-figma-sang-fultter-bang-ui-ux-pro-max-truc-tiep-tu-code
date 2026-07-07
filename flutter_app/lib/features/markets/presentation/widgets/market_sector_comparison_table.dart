import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_sector_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketSectorComparisonTable extends StatelessWidget {
  const MarketSectorComparisonTable({
    required this.sectors,
    this.highlightedSectorId,
    super.key,
  });

  final List<MarketSector> sectors;
  final String? highlightedSectorId;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'So sánh nhanh',
      accentColor: marketSectorPrimary,
      children: [
        VitCard(
          padding: MarketsSpacingTokens.marketSectorComparisonPadding,
          child: Column(
            children: [
              const _ComparisonHeader(),
              const SizedBox(
                height: MarketsSpacingTokens.marketSectorComparisonHeaderGap,
              ),
              for (final sector in sectors) ...[
                _ComparisonRow(
                  sector: sector,
                  highlighted: sector.id == highlightedSectorId,
                ),
                if (sector != sectors.last) const TableDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class MarketSectorDataRefreshFooter extends StatelessWidget {
  const MarketSectorDataRefreshFooter({
    required this.count,
    required this.label,
    super.key,
  });

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.marketSectorRefreshFooterPadding,
      child: Text(
        '$count ngành · $label',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class TableDivider extends StatelessWidget {
  const TableDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: AppSpacing.dividerHairline,
      color: AppColors.divider,
    );
  }
}

class _ComparisonHeader extends StatelessWidget {
  const _ComparisonHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Ngành',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        for (final label in const ['24h', '7d', '30d'])
          SizedBox(
            width: MarketsSpacingTokens.marketSectorComparisonCellWidth,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.sector, required this.highlighted});

  final MarketSector sector;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted
          ? sector.color.resolve().withValues(alpha: 0.10)
          : AppColors.transparent,
      borderRadius: AppRadii.smRadius,
      child: SizedBox(
        height: MarketsSpacingTokens.marketSectorComparisonRowHeight,
        child: Padding(
          padding: MarketsSpacingTokens.marketSectorComparisonRowPadding,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Material(
                      color: sector.color.resolve(),
                      shape: const CircleBorder(),
                      child: const SizedBox.square(
                        dimension:
                            MarketsSpacingTokens.marketSectorComparisonMarker,
                      ),
                    ),
                    const SizedBox(
                      width:
                          MarketsSpacingTokens.marketSectorComparisonMarkerGap,
                    ),
                    Expanded(
                      child: Text(
                        sector.nameVi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
                          fontWeight: highlighted
                              ? AppTextStyles.bold
                              : AppTextStyles.medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _PercentCell(value: sector.change24h),
              _PercentCell(value: sector.change7d),
              _PercentCell(value: sector.change30d),
            ],
          ),
        ),
      ),
    );
  }
}

class _PercentCell extends StatelessWidget {
  const _PercentCell({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return SizedBox(
      width: MarketsSpacingTokens.marketSectorComparisonCellWidth,
      child: Text(
        formatMarketSectorPercent(value),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}
