import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_smart_suggestions_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_smart_suggestions_suggestions.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class SavingsSmartTrendList extends StatelessWidget {
  const SavingsSmartTrendList({super.key, required this.trends});

  final List<SavingsApyTrendDraft> trends;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsSmartSuggestionsKeys.trendsList,
      children: [
        for (final trend in trends) ...[
          SavingsSmartTrendCard(trend: trend),
          if (trend != trends.last) const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class SavingsSmartTrendCard extends StatelessWidget {
  const SavingsSmartTrendCard({super.key, required this.trend});

  final SavingsApyTrendDraft trend;

  @override
  Widget build(BuildContext context) {
    final color = savingsSmartTrendColor(trend.direction);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SavingsSmartSuggestionIcon(
                type: trend.direction == SavingsApyTrendDirection.down
                    ? SavingsSuggestionType.riskAlert
                    : SavingsSuggestionType.dcaTiming,
                color: color,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trend.product, style: savingsSmartCaptionBold),
                    Text(
                      '${trend.asset} · hiện tại ${trend.currentApyLabel}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              SavingsSmartMetaPill(
                label: savingsSmartTrendLabel(trend.direction),
                color: color,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.buttonHero,
            child: CustomPaint(
              painter: SavingsSmartTrendSparklinePainter(
                points: trend.points,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: SavingsSmartTrendMetric(
                  label: 'Trung bình',
                  value: trend.averageApyLabel,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: SavingsSmartTrendMetric(
                  label: 'Dự báo',
                  value: trend.predictionLabel,
                  valueColor: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SavingsSmartTrendMetric extends StatelessWidget {
  const SavingsSmartTrendMetric({
    super.key,
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
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: savingsSmartCaptionBold.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

class SavingsSmartSignalList extends StatelessWidget {
  const SavingsSmartSignalList({super.key, required this.signals});

  final List<SavingsMarketSignalDraft> signals;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsSmartSuggestionsKeys.signalsList,
      children: [
        for (final signal in signals) ...[
          SavingsSmartSignalCard(signal: signal),
          if (signal != signals.last) const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class SavingsSmartSignalCard extends StatelessWidget {
  const SavingsSmartSignalCard({super.key, required this.signal});

  final SavingsMarketSignalDraft signal;

  @override
  Widget build(BuildContext context) {
    final color = savingsSmartSignalColor(signal.type);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SavingsSmartSuggestionIcon(
                type: signal.type == SavingsMarketSignalType.bearish
                    ? SavingsSuggestionType.riskAlert
                    : SavingsSuggestionType.newOpportunity,
                color: color,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(signal.title, style: savingsSmartCaptionBold),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      signal.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            signal.impact,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final product in signal.affectedProducts)
                SavingsSmartMetaPill(label: product, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class SavingsSmartTrendSparklinePainter extends CustomPainter {
  const SavingsSmartTrendSparklinePainter({
    required this.points,
    required this.color,
  });

  final List<SavingsApyTrendPointDraft> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minValue = points
        .map((point) => point.apy)
        .reduce((value, element) => value < element ? value : element);
    final maxValue = points
        .map((point) => point.apy)
        .reduce((value, element) => value > element ? value : element);
    final range = (maxValue - minValue).abs() < .01 ? 1 : maxValue - minValue;
    final path = Path();

    for (var i = 0; i < points.length; i++) {
      final x = size.width * (i / (points.length - 1));
      final y =
          size.height - ((points[i].apy - minValue) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 1; i <= 2; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SavingsSmartTrendSparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
