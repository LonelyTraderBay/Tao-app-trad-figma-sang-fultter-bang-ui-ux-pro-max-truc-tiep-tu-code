import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_charts.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DcaBacktesterAnalysis extends StatelessWidget {
  const DcaBacktesterAnalysis({
    super.key,
    required this.snapshot,
    required this.onDownloadReport,
  });

  final DcaBacktesterSnapshot snapshot;
  final VoidCallback onDownloadReport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DrawdownCard(points: snapshot.drawdowns),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _RiskMetricCard(result: snapshot.result),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          onPressed: onDownloadReport,
          variant: VitCtaButtonVariant.ghost,
          leading: const Icon(
            Icons.download_rounded,
            color: AppColors.text1,
            size: AppSpacing.iconMd,
          ),
          child: const Text('Download Report'),
        ),
      ],
    );
  }
}

class _DrawdownCard extends StatelessWidget {
  const _DrawdownCard({required this.points});

  final List<DcaDrawdownPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DcaCardTitle('Drawdown Analysis'),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: AppSpacing.buttonHero * 2,
            child: CustomPaint(
              painter: DcaDrawdownPainter(points: points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskMetricCard extends StatelessWidget {
  const _RiskMetricCard({required this.result});

  final DcaBacktestResult result;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'Max Drawdown',
        '${result.maxDrawdownPercent}%',
        'Largest peak-to-trough decline',
        AppColors.buy,
        'GOOD',
      ),
      (
        'Volatility',
        '${result.volatilityPercent}%',
        'Standard deviation of returns',
        AppColors.buy,
        'GOOD',
      ),
      (
        'Sharpe Ratio',
        result.sharpeRatio.toStringAsFixed(2),
        'Risk-adjusted return',
        AppColors.buy,
        'GOOD',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DcaSectionLabel(label: 'Risk Analysis'),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final metric in metrics) ...[
          VitCard(
            padding: AppSpacing.dcaPaddingX4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metric.$1,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        metric.$3,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                      Text(
                        metric.$2,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                DcaStatusBadge(label: metric.$5, color: metric.$4),
              ],
            ),
          ),
          if (metric != metrics.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}
