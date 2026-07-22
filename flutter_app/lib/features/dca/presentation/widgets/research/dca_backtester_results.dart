import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_charts.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';

class DcaBacktesterResults extends StatelessWidget {
  const DcaBacktesterResults({super.key, required this.snapshot});

  final DcaBacktesterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ResultSummary(result: snapshot.result),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _GrowthChartCard(points: snapshot.historicalData),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _MetricsCard(result: snapshot.result),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _DcaAdvantageCard(result: snapshot.result),
      ],
    );
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Total Invested',
        dcaFormatUsd(result.totalInvestedUsd),
        AppColors.text1,
      ),
      ('Final Value', dcaFormatUsd(result.finalValueUsd), AppColors.buy),
      (
        'Total Return',
        '+${dcaFormatUsd(result.totalReturnUsd)}',
        AppColors.buy,
      ),
      (
        'Return %',
        '+${result.returnPercent.toStringAsFixed(2)}%',
        AppColors.buy,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpacing.x3) / 2;
        return Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: VitCard(
                  padding: DcaSpacingTokens.dcaPaddingX4,
                  borderColor: item.$3 == AppColors.buy
                      ? AppColors.buy20
                      : AppColors.cardBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      Text(
                        item.$2,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: item.$3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GrowthChartCard extends StatelessWidget {
  const _GrowthChartCard({required this.points});

  final List<DcaBacktestPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DcaCardTitle('Portfolio Growth (DCA vs Lump Sum)'),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: AppSpacing.buttonHero * 2 + AppSpacing.x6,
            child: CustomPaint(
              painter: DcaBacktestGrowthPainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'Avg Buy Price',
        dcaFormatUsd(result.avgBuyPriceUsd),
        Icons.attach_money,
      ),
      ('Total Shares', result.totalShares.toStringAsFixed(4), Icons.bar_chart),
      ('Number of Buys', result.numberOfBuys.toString(), Icons.event_rounded),
      (
        'Max Drawdown',
        '${result.maxDrawdownPercent}%',
        Icons.trending_down_rounded,
      ),
      (
        'Sharpe Ratio',
        result.sharpeRatio.toStringAsFixed(2),
        Icons.track_changes,
      ),
      ('Volatility', '${result.volatilityPercent}%', Icons.show_chart),
      ('Win Rate', '${result.winRatePercent}%', Icons.percent_rounded),
    ];

    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DcaSectionLabel(label: 'Performance Metrics'),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final metric in metrics) ...[
            Row(
              children: [
                Icon(
                  metric.$3,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    metric.$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  metric.$2,
                  style: AppTextStyles.caption.copyWith(
                    color: metric.$1 == 'Max Drawdown'
                        ? AppColors.sell
                        : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            if (metric != metrics.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _DcaAdvantageCard extends StatelessWidget {
  const _DcaAdvantageCard({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.trending_up_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'DCA strategy outperformed lump sum by +${(result.returnPercent - 54.76).toStringAsFixed(2)}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: DcaSpacingTokens.dcaBacktesterBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
