import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/comparison_tool_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class ComparisonSparklineCard extends StatelessWidget {
  const ComparisonSparklineCard({super.key, required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.comparisonToolSparklineCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biểu đồ giá 24h',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.comparisonToolSparklineGap),
          Row(
            children: [
              for (final pair in pairs) ...[
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppSpacing.comparisonToolSparklineHeight,
                        child: CustomPaint(
                          painter: ComparisonSparklinePainter(
                            values: pair.sparklineData,
                            color: pair.change24h >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.comparisonToolTokenTextGap,
                      ),
                      Text(
                        pair.baseAsset,
                        style: AppTextStyles.micro.copyWith(
                          color: AppAssetColors.forSymbol(pair.baseAsset),
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.marketLineHeightTight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (pair != pairs.last)
                  const SizedBox(
                    width: AppSpacing.comparisonToolSparklinePairGap,
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ComparisonMetricSection extends StatelessWidget {
  const ComparisonMetricSection({
    super.key,
    required this.pairs,
    required this.metrics,
  });

  final List<MarketPair> pairs;
  final List<MarketComparisonMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Material(
              color: comparisonToolAccent,
              borderRadius: AppRadii.xsRadius,
              child: const SizedBox(
                width: AppSpacing.serviceTileAccentBarThickness,
                height: AppSpacing.serviceTileSectionBarHeight,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              'So sánh chi tiết',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.comparisonToolMetricSectionGap),
        for (final metric in metrics) ...[
          _MetricCard(metric: metric, pairs: pairs),
          if (metric != metrics.last)
            const SizedBox(height: AppSpacing.comparisonToolMetricCardGap),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, required this.pairs});

  final MarketComparisonMetric metric;
  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final values = [
      for (final pair in pairs) comparisonMetricValue(pair, metric.key),
    ];
    final bestIndex = comparisonBestIndex(values, metric.highlight);

    return VitCard(
      variant: VitCardVariant.inner,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.comparisonToolMetricMinHeight,
      ),
      padding: AppSpacing.comparisonToolMetricCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
              height: AppSpacing.marketLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.comparisonToolMetricValueGap),
          Row(
            children: [
              for (var index = 0; index < pairs.length; index++) ...[
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        comparisonFormatMetric(values[index], metric.format),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color:
                              metric.format ==
                                      MarketComparisonMetricFormat.percent &&
                                  metric.key == 'chg'
                              ? (values[index] >= 0
                                    ? AppColors.buy
                                    : AppColors.sell)
                              : index == bestIndex
                              ? comparisonToolPrimary
                              : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: AppSpacing.marketLineHeightTight,
                        ),
                      ),
                      if (index == bestIndex) ...[
                        const SizedBox(
                          height: AppSpacing.comparisonToolBestGap,
                        ),
                        Text(
                          'TỐT NHẤT',
                          style: AppTextStyles.badge.copyWith(
                            color: comparisonToolPrimary,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ComparisonVolumeDistributionCard extends StatelessWidget {
  const ComparisonVolumeDistributionCard({super.key, required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final total = pairs.fold<double>(0, (sum, pair) => sum + pair.volume24h);
    return VitCard(
      padding: AppSpacing.comparisonToolDistributionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ khối lượng 24h',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.comparisonToolSparklineGap),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              height: AppSpacing.comparisonToolDistributionHeight,
              child: Row(
                children: [
                  for (final pair in pairs)
                    Expanded(
                      flex: ((pair.volume24h / total) * 1000).round(),
                      child: ColoredBox(
                        color: AppAssetColors.forSymbol(
                          pair.baseAsset,
                        ).withValues(alpha: .72),
                        child: const SizedBox.expand(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.comparisonToolDistributionGap),
          Wrap(
            spacing: AppSpacing.comparisonToolDistributionLegendGap,
            runSpacing: AppSpacing.comparisonToolDistributionLegendRunGap,
            children: [
              for (final pair in pairs)
                _LegendEntry(
                  color: AppAssetColors.forSymbol(pair.baseAsset),
                  label:
                      '${pair.baseAsset} ${((pair.volume24h / total) * 100).toStringAsFixed(1)}%',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ComparisonMarketCapDistributionCard extends StatelessWidget {
  const ComparisonMarketCapDistributionCard({super.key, required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final total = pairs.fold<double>(0, (sum, pair) => sum + pair.marketCap);
    return VitCard(
      padding: AppSpacing.comparisonToolDistributionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ vốn hóa',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.comparisonToolSparklineGap),
          for (final pair in pairs) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    pair.baseAsset,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                Text(
                  '${comparisonFormatCompactUsd(pair.marketCap)} (${((pair.marketCap / total) * 100).toStringAsFixed(1)}%)',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.comparisonToolMarketCapRowGap),
            ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: SizedBox(
                height: AppSpacing.comparisonToolMarketCapBarHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.surface3),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: pair.marketCap / total,
                      child: ColoredBox(
                        color: AppAssetColors.forSymbol(
                          pair.baseAsset,
                        ).withValues(alpha: .82),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (pair != pairs.last)
              const SizedBox(height: AppSpacing.comparisonToolDistributionGap),
          ],
        ],
      ),
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          child: const SizedBox(
            width: AppSpacing.comparisonToolLegendDot,
            height: AppSpacing.comparisonToolLegendDot,
          ),
        ),
        const SizedBox(width: AppSpacing.comparisonToolLegendGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class ComparisonNeedMoreTokensCard extends StatelessWidget {
  const ComparisonNeedMoreTokensCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.comparisonToolNeedPadding,
      child: Column(
        children: [
          const Icon(
            Icons.balance_rounded,
            color: AppColors.text3,
            size: AppSpacing.comparisonToolNeedIcon,
          ),
          const SizedBox(height: AppSpacing.comparisonToolNeedGap),
          Text(
            'Chọn ít nhất 2 token để so sánh',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}
