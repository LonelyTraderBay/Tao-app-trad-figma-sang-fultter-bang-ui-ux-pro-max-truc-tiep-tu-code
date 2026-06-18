import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
        const SizedBox(width: AppSpacing.marketHeatmapSummaryGap),
        Expanded(
          child: _SummaryCard(
            label: 'TB thay đổi $metric',
            value: marketHeatmapFormatPercent(averageChange),
            valueColor: averageChange >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ),
        const SizedBox(width: AppSpacing.marketHeatmapSummaryGap),
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
    return VitCard(
      radius: VitCardRadius.sm,
      padding: AppSpacing.marketHeatmapSummaryPadding,
      height: AppSpacing.marketHeatmapSummaryHeight,
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
              height: AppSpacing.marketLineHeightShort,
            ),
          ),
          const SizedBox(height: AppSpacing.marketAnalyticsCompactGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.marketLineHeightTight,
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
            height: AppSpacing.marketHeatmapControlsHeight,
            child: Padding(
              padding: AppSpacing.marketHeatmapControlsPadding,
              child: Row(
                children: [
                  for (final metric in metrics)
                    _FilterChip(
                      key: metric == '7d'
                          ? MarketHeatmapKeys.metric7d
                          : MarketHeatmapKeys.metric24h,
                      label: metric,
                      active: metric == activeMetric,
                      onTap: () => onMetricSelected(metric),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.marketAnalyticsBreadthGap),
        Expanded(
          child: SizedBox(
            height: AppSpacing.marketHeatmapControlsHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: categories.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.marketAnalyticsCompactGap),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _FilterChip(
                  key: MarketHeatmapKeys.category(category),
                  label: category,
                  active: category == activeCategory,
                  onTap: () => onCategorySelected(category),
                  outlined: true,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.outlined = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Material(
        color: active
            ? marketHeatmapPrimary.withValues(alpha: 0.18)
            : AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: outlined
              ? BorderSide(
                  color: active
                      ? marketHeatmapPrimary.withValues(alpha: 0.48)
                      : AppColors.transparent,
                )
              : BorderSide.none,
        ),
        child: SizedBox(
          height: AppSpacing.marketHeatmapFilterHeight,
          child: Padding(
            padding: AppSpacing.marketHeatmapFilterPadding,
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: active ? marketHeatmapPrimary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.marketLineHeightTight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
