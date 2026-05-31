import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'TB thay đổi $metric',
            value: marketHeatmapFormatPercent(averageChange),
            valueColor: averageChange >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ),
        const SizedBox(width: 12),
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
      padding: const EdgeInsets.all(13),
      height: 62,
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
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
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
        Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.lgRadius,
          ),
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
        const SizedBox(width: 9),
        Expanded(
          child: SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? marketHeatmapPrimary.withValues(alpha: 0.18)
              : AppColors.transparent,
          borderRadius: AppRadii.cardRadius,
          border: outlined
              ? Border.all(
                  color: active
                      ? marketHeatmapPrimary.withValues(alpha: 0.48)
                      : AppColors.transparent,
                )
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? marketHeatmapPrimary : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}
