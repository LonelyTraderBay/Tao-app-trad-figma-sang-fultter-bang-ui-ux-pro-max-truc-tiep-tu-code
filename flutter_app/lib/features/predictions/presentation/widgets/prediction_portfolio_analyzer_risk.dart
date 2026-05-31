part of '../pages/prediction_portfolio_analyzer_page.dart';

class _RiskMetricsSection extends StatelessWidget {
  const _RiskMetricsSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Risk Exposure',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk by Category',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.buy, size: 16),
              const SizedBox(width: 8),
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
                    const SizedBox(height: 4),
                    Text(
                      'Portfolio da phan tan hop ly qua ${snapshot.categories.length} categories',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '7.2',
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.buy,
                  fontSize: 25,
                  height: 1,
                ),
              ),
              const SizedBox(width: 5),
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
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Phan tich rui ro dua tren du lieu lich su. Hieu suat qua khu khong dam bao ket qua tuong lai. Luon quan ly rui ro va phan tan dau tu.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 5),
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
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 11,
                ),
              ),
              Text(
                '${category.pnl >= 0 ? '+' : ''}${_formatMoney(category.pnl)}',
                style: AppTextStyles.micro.copyWith(
                  color: category.pnl >= 0 ? AppColors.buy : AppColors.sell,
                  fontSize: 10,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.text3, size: 16),
          const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height.toDouble(),
            decoration: BoxDecoration(
              color: _predictionPrimary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
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
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
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
