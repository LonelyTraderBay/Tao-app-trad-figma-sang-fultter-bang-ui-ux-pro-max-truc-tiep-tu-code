import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketHeatmapSummaryStrip extends StatelessWidget {
  const MarketHeatmapSummaryStrip({
    super.key,
    required this.totalMarketCap,
    required this.averageChange,
    required this.metric,
    required this.count,
  });

  final double totalMarketCap;
  final double averageChange;
  final String metric;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Tổng Market Cap',
            value: marketHeatmapFormatCompact(totalMarketCap),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketHeatmapSummaryGap),
        Expanded(
          child: _SummaryCard(
            label: 'TB thay đổi $metric',
            value: marketHeatmapFormatPercent(averageChange),
            valueColor: averageChange >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketHeatmapSummaryGap),
        Expanded(
          child: _SummaryCard(
            label: 'Số coin',
            value: '$count',
            valueColor: marketHeatmapPrimary,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      radius: VitCardRadius.standard,
      padding: MarketsSpacingTokens.marketHeatmapSummaryPadding,
      height: MarketsSpacingTokens.marketHeatmapSummaryHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: MarketsSpacingTokens.marketLineHeightShort,
            ),
          ),
          const SizedBox(
            height: MarketsSpacingTokens.marketAnalyticsCompactGap,
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: MarketsSpacingTokens.marketLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class MarketHeatmapControls extends StatelessWidget {
  const MarketHeatmapControls({
    super.key,
    required this.metrics,
    required this.activeMetric,
    required this.categories,
    required this.activeCategory,
    required this.onMetricSelected,
    required this.onCategorySelected,
  });

  final List<String> metrics;
  final String activeMetric;
  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onMetricSelected;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AppColors.surface2,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
          child: SizedBox(
            height: MarketsSpacingTokens.marketHeatmapControlsHeight,
            child: Padding(
              padding: MarketsSpacingTokens.marketHeatmapControlsPadding,
              child: Row(
                children: [
                  for (final metric in metrics)
                    VitFilterChip(
                      key: metric == '7d'
                          ? MarketHeatmapKeys.metric7d
                          : MarketHeatmapKeys.metric24h,
                      label: metric,
                      active: metric == activeMetric,
                      onTap: () => onMetricSelected(metric),
                      color: marketHeatmapPrimary,
                      height: MarketsSpacingTokens.marketHeatmapFilterHeight,
                      padding: MarketsSpacingTokens.marketHeatmapFilterPadding,
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsBreadthGap),
        Expanded(
          child: SizedBox(
            height: MarketsSpacingTokens.marketHeatmapControlsHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(
                width: MarketsSpacingTokens.marketAnalyticsCompactGap,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return VitFilterChip(
                  key: MarketHeatmapKeys.category(category),
                  label: category,
                  active: category == activeCategory,
                  onTap: () => onCategorySelected(category),
                  color: marketHeatmapPrimary,
                  height: MarketsSpacingTokens.marketHeatmapFilterHeight,
                  padding: MarketsSpacingTokens.marketHeatmapFilterPadding,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
