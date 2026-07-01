part of '../pages/prediction_portfolio_analyzer_page.dart';

class _RiskMetricsSection extends StatelessWidget {
  const _RiskMetricsSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Risk Exposure',
          variant: VitSectionHeaderVariant.accentBar,
          density: VitDensity.compact,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: const [
              _RiskMetricRow(
                icon: Icons.shield_outlined,
                label: 'Max Drawdown',
                value: '-12.4%',
                valueColor: AppColors.sell,
              ),
              _RiskMetricRow(
                icon: Icons.monitor_heart_outlined,
                label: 'Portfolio Volatility',
                value: '18.2%',
              ),
              _RiskMetricRow(
                icon: Icons.donut_small_rounded,
                label: 'Concentration (Top 3)',
                value: '62.3%',
              ),
              _RiskMetricRow(
                icon: Icons.percent_rounded,
                label: 'Sharpe Ratio',
                value: '1.42',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryRiskCard extends StatelessWidget {
  const _CategoryRiskCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Risk by Category',
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            height: AppSpacing.x7 * 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final category in snapshot.categories)
                  Expanded(child: _CategoryRiskBar(category: category)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiversificationCard extends StatelessWidget {
  const _DiversificationCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: AppSpacing.predictionAnalyzerRiskIcon,
              ),
              const SizedBox(width: AppSpacing.predictionAnalyzerRiskIconGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diversification Score',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Portfolio da phan tan hop ly qua ${snapshot.categories.length} categories',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '7.2',
                style: AppTextStyles.amountMd.copyWith(color: AppColors.buy),
              ),
              const SizedBox(
                width: AppSpacing.predictionAnalyzerScoreSuffixGap,
              ),
              Text(
                '/ 10',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return const VitAnnouncementBanner(
      message:
          'Phan tich rui ro dua tren du lieu lich su. Hieu suat qua khu khong dam bao ket qua tuong lai. Luon quan ly rui ro va phan tan dau tu.',
      icon: Icons.info_outline_rounded,
      accentColor: AppColors.warn,
      variant: VitAnnouncementBannerVariant.compact,
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: (small ? AppTextStyles.caption : AppTextStyles.baseMedium)
              .copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
        ),
      ],
    );
  }
}

class _CategoryLegendItem extends StatelessWidget {
  const _CategoryLegendItem({required this.category, required this.color});

  final PredictionAnalyzerCategoryDraft category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.predictionAnalyzerLegendSwatchMargin,
          child: SizedBox(
            width: AppSpacing.predictionAnalyzerLegendSwatch,
            height: AppSpacing.predictionAnalyzerLegendSwatch,
            child: Material(color: color, borderRadius: AppRadii.swatchRadius),
          ),
        ),
        const SizedBox(width: AppSpacing.predictionAnalyzerLegendItemGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: AppTextStyles.numericMicro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '${category.pnl >= 0 ? '+' : ''}${_formatMoney(category.pnl)}',
                style: AppTextStyles.numericMicro.copyWith(
                  color: category.pnl >= 0 ? AppColors.buy : AppColors.sell,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskMetricRow extends StatelessWidget {
  const _RiskMetricRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.predictionAnalyzerRiskMetricPadding,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.text3,
            size: AppSpacing.predictionAnalyzerRiskIcon,
          ),
          const SizedBox(width: AppSpacing.predictionAnalyzerRiskIconGap),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRiskBar extends StatelessWidget {
  const _CategoryRiskBar({required this.category});

  final PredictionAnalyzerCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    final height = 30 + category.invested.clamp(0, 95);
    return Padding(
      padding: AppSpacing.predictionAnalyzerRiskBarPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: height.toDouble(),
            width: double.infinity,
            child: const Material(
              color: _predictionPrimary,
              borderRadius: BorderRadius.vertical(top: AppRadii.smCorner),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({required this.categories});

  final List<PredictionAnalyzerCategoryDraft> categories;

  @override
  void paint(Canvas canvas, Size size) {
    final total = categories.fold<double>(
      0,
      (sum, category) => sum + category.invested,
    );
    if (total <= 0) return;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: math.min(size.width, size.height) / 2 - 16,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.butt;
    var start = 0.0;
    for (var i = 0; i < categories.length; i += 1) {
      final sweep = -(categories[i].invested / total) * math.pi * 2;
      paint.color = _categoryColor(i);
      canvas.drawArc(rect, start, sweep + .025, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}

class _PnlLinePainter extends CustomPainter {
  const _PnlLinePainter({required this.points});

  final List<PredictionAnalyzerPnlPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = AppColors.buy
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = AppColors.buy;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    const left = 30.0;
    const bottom = 28.0;
    final chart = Rect.fromLTWH(
      left,
      4,
      size.width - left - 6,
      size.height - bottom - 8,
    );
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final values = points.map((point) => point.value).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final path = Path();
    for (var i = 0; i < points.length; i += 1) {
      final x = chart.left + (chart.width / (points.length - 1)) * i;
      final y =
          chart.bottom - ((points[i].value - minValue) / range) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3.6, dotPaint);
      textPainter.text = TextSpan(
        text: points[i].date,
        style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chart.bottom + 8),
      );
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _PnlLinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

Color _categoryColor(int index) {
  return const [
    _predictionPrimary,
    AppColors.buy,
    AppColors.warn,
    _purple,
    AppColors.sell,
  ][index % 5];
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatMoneyCompact(double value) => '\$${value.round()}';
