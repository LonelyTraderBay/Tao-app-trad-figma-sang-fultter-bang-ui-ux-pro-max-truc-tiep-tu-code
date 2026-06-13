import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
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
          const SizedBox(height: 14),
          Row(
            children: [
              for (final pair in pairs) ...[
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 48,
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
                      const SizedBox(height: 9),
                      Text(
                        pair.baseAsset,
                        style: AppTextStyles.micro.copyWith(
                          color: pair.logoColor,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (pair != pairs.last) const SizedBox(width: 18),
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
            Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                color: comparisonToolAccent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'So sánh chi tiết',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final metric in metrics) ...[
          _MetricCard(metric: metric, pairs: pairs),
          if (metric != metrics.last) const SizedBox(height: 4),
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

    return Container(
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
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
                          height: 1,
                        ),
                      ),
                      if (index == bestIndex) ...[
                        const SizedBox(height: 9),
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
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  for (final pair in pairs)
                    Expanded(
                      flex: ((pair.volume24h / total) * 1000).round(),
                      child: ColoredBox(
                        color: pair.logoColor.withValues(alpha: .72),
                        child: const SizedBox.expand(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              for (final pair in pairs)
                _LegendEntry(
                  color: pair.logoColor,
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
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 14),
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
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.surface3),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: pair.marketCap / total,
                      child: ColoredBox(
                        color: pair.logoColor.withValues(alpha: .82),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (pair != pairs.last) const SizedBox(height: 12),
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
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.balance_rounded, color: AppColors.text3, size: 42),
          const SizedBox(height: 12),
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
