part of 'savings_what_if_page.dart';

class _AssetImpactList extends StatelessWidget {
  const _AssetImpactList({required this.result});

  final _ScenarioResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsWhatIfPage.assetImpactKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final impact in result.assetImpact) ...[
            Row(
              children: [
                _AssetBadge(asset: impact.asset, color: impact.color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        impact.asset,
                        style: _captionBold.copyWith(color: AppColors.text1),
                      ),
                      Text(
                        'Baseline ${_money(impact.baseInterest)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${impact.diff >= 0 ? '+' : ''}${_money(impact.diff)}',
                  style: _captionBold.copyWith(
                    color: impact.diff >= 0 ? AppColors.buy : AppColors.sell,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            if (impact != result.assetImpact.last)
              const Divider(color: AppColors.divider, height: AppSpacing.x5),
          ],
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: _captionBold.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactBadge extends StatelessWidget {
  const _ImpactBadge({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              positive
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: color,
              size: 13,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '${positive ? '+' : ''}${value.toStringAsFixed(2)}%',
              style: _microBold.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.level});

  final SavingsWhatIfRiskLevel level;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(level);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: 2,
        ),
        child: Text(
          _riskLabel(level),
          style: _microBold.copyWith(color: color, height: 1.2),
        ),
      ),
    );
  }
}

class _MicroMetric extends StatelessWidget {
  const _MicroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.isEmpty ? value : '$label: $value',
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 31,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          asset,
          style: _microBold.copyWith(color: color, fontSize: 8),
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text, required this.tone});

  final String text;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: tone.withValues(alpha: .25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: tone, size: 18),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCallout extends StatelessWidget {
  const _InfoCallout({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: color.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _RingPainter(score: score, color: color),
        child: Center(
          child: Text(
            '$score',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.points});

  final List<_MonthlyPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final values = [
      for (final point in points) point.baseline,
      for (final point in points) point.scenario,
    ];
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(1, maxValue - minValue);

    Path pathFor(double Function(_MonthlyPoint point) selector) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = points.length == 1
            ? 0.0
            : size.width * i / (points.length - 1);
        final value = selector(points[i]);
        final y = size.height - ((value - minValue) / span * size.height);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final baselinePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final scenarioPaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(pathFor((point) => point.baseline), baselinePaint);
    canvas.drawPath(pathFor((point) => point.scenario), scenarioPaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    final base = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, base);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * score / 100,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.color != color;
}

final class _ScenarioResult {
  const _ScenarioResult({
    required this.scenarioValue,
    required this.baselineValue,
    required this.difference,
    required this.differencePct,
    required this.baselineInterest,
    required this.scenarioInterest,
    required this.maxDrawdown,
    required this.recoveryMonths,
    required this.monthlyData,
    required this.assetImpact,
  });

  final double scenarioValue;
  final double baselineValue;
  final double difference;
  final double differencePct;
  final double baselineInterest;
  final double scenarioInterest;
  final double maxDrawdown;
  final int recoveryMonths;
  final List<_MonthlyPoint> monthlyData;
  final List<_AssetImpact> assetImpact;
}

final class _MonthlyPoint {
  const _MonthlyPoint({required this.baseline, required this.scenario});

  final double baseline;
  final double scenario;
}

final class _AssetImpact {
  const _AssetImpact({
    required this.asset,
    required this.color,
    required this.baseInterest,
    required this.scenarioInterest,
    required this.diff,
  });

  final String asset;
  final Color color;
  final double baseInterest;
  final double scenarioInterest;
  final double diff;
}

final class _StressScenarioResult {
  const _StressScenarioResult({required this.scenario, required this.result});

  final SavingsWhatIfScenarioDraft scenario;
  final _ScenarioResult result;
}

SavingsWhatIfScenarioDraft _scenarioById(
  SavingsWhatIfSnapshot snapshot,
  SavingsWhatIfScenarioId id,
) {
  return snapshot.scenarios.firstWhere((scenario) => scenario.id == id);
}

double _totalPortfolioValue(
  List<SavingsWhatIfPortfolioPositionDraft> positions,
) {
  return positions.fold<double>(0, (sum, position) => sum + position.amountUsd);
}
