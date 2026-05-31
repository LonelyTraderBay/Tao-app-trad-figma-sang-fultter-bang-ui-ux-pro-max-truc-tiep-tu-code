part of '../pages/dca_performance_compare_page.dart';

class _ProsConsCard extends StatelessWidget {
  const _ProsConsCard.dca()
    : title = 'DCA Strategy',
      color = AppColors.buy,
      pros = const [
        'Lower timing risk',
        'Easier emotionally',
        'Flexible budget',
      ],
      cons = const ['May miss rallies', 'Lower upside'];

  const _ProsConsCard.lumpSum()
    : title = 'Lump Sum',
      color = AppColors.primary,
      pros = const ['Max time in market', 'Higher upside'],
      cons = const ['High timing risk', 'Emotional stress', 'Large capital'];

  final String title;
  final Color color;
  final List<String> pros;
  final List<String> cons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ProsConsList(title: 'Pros', items: pros, icon: Icons.check_rounded),
          const SizedBox(height: AppSpacing.x4),
          _ProsConsList(
            title: 'Cons',
            items: cons,
            icon: Icons.warning_amber_rounded,
            warning: true,
          ),
        ],
      ),
    );
  }
}

class _ProsConsList extends StatelessWidget {
  const _ProsConsList({
    required this.title,
    required this.items,
    required this.icon,
    this.warning = false,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: warning ? AppColors.warn : AppColors.buy,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text2,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }
}

class _PerformanceLinePainter extends CustomPainter {
  const _PerformanceLinePainter(this.points);

  final List<DcaPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 36.0;
    const bottom = 24.0;
    final chart = Rect.fromLTWH(0, 0, size.width, size.height - bottom);
    final maxValue = points
        .map((point) => math.max(point.dcaValueUsd, point.lumpSumValueUsd))
        .reduce(math.max)
        .toDouble();
    _drawGrid(canvas, chart, maxValue, left);
    _drawLine(
      canvas,
      chart,
      values: points.map((point) => point.dcaValueUsd / maxValue).toList(),
      color: AppColors.buy,
      leftInset: left,
      fill: true,
    );
    _drawLine(
      canvas,
      chart,
      values: points.map((point) => point.lumpSumValueUsd / maxValue).toList(),
      color: AppColors.primary,
      leftInset: left,
    );
    for (var i = 1; i < points.length; i += 2) {
      _drawAxisLabel(
        canvas,
        points[i].month,
        Offset(
          left + (chart.width - left) * i / (points.length - 1),
          chart.bottom + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformanceLinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter(this.metrics);

  final List<DcaRadarMetric> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    if (metrics.length < 3) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    final grid = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var step = 1; step <= 4; step++) {
      final path = _radarPath(
        center,
        radius * step / 4,
        List<double>.filled(metrics.length, 1),
      );
      canvas.drawPath(path, grid);
    }
    for (var i = 0; i < metrics.length; i++) {
      final angle = -math.pi / 2 + math.pi * 2 * i / metrics.length;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(center, point, grid);
      _drawRadarLabel(canvas, metrics[i].metric, center, radius + 20, angle);
    }
    _drawRadarSeries(
      canvas,
      center,
      radius,
      metrics.map((metric) => metric.dcaScore / 200).toList(),
      AppColors.buy,
    );
    _drawRadarSeries(
      canvas,
      center,
      radius,
      metrics.map((metric) => metric.lumpSumScore / 200).toList(),
      AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.metrics != metrics;
  }
}

void _drawGrid(Canvas canvas, Rect chart, double maxValue, double leftInset) {
  final grid = Paint()
    ..color = AppColors.border
    ..strokeWidth = 1;
  for (var i = 0; i <= 4; i++) {
    final y = chart.bottom - chart.height * i / 4;
    canvas.drawLine(Offset(leftInset, y), Offset(chart.right, y), grid);
    _drawAxisLabel(canvas, '${(maxValue * i / 4).round()}', Offset(0, y - 7));
  }
}

void _drawLine(
  Canvas canvas,
  Rect chart, {
  required List<double> values,
  required Color color,
  required double leftInset,
  bool fill = false,
}) {
  if (values.isEmpty) return;
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = leftInset + (chart.width - leftInset) * i / (values.length - 1);
    final y = chart.bottom - chart.height * values[i];
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(leftInset, chart.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );
}

Path _radarPath(Offset center, double radius, List<double> values) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final angle = -math.pi / 2 + math.pi * 2 * i / values.length;
    final point = Offset(
      center.dx + math.cos(angle) * radius * values[i],
      center.dy + math.sin(angle) * radius * values[i],
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  return path;
}

void _drawRadarSeries(
  Canvas canvas,
  Offset center,
  double radius,
  List<double> values,
  Color color,
) {
  final path = _radarPath(center, radius, values);
  canvas.drawPath(
    path,
    Paint()
      ..color = color.withValues(alpha: 0.24)
      ..style = PaintingStyle.fill,
  );
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );
}

void _drawRadarLabel(
  Canvas canvas,
  String label,
  Offset center,
  double radius,
  double angle,
) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text2),
    ),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: 90);
  final offset = Offset(
    center.dx + math.cos(angle) * radius - textPainter.width / 2,
    center.dy + math.sin(angle) * radius - textPainter.height / 2,
  );
  textPainter.paint(canvas, offset);
}

void _drawAxisLabel(Canvas canvas, String label, Offset offset) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(canvas, offset);
}

String _formatUsd(num value) => '\$${value.round()}';

String _formatSignedPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
