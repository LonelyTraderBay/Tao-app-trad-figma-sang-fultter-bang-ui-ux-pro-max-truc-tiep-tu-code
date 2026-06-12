part of 'regulatory_reports_dashboard_page.dart';

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      variant: VitCardVariant.inner,
      borderColor: _dashBorder,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 17,
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
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      status: color == _dashGreen
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.error,
      size: VitStatusPillSize.sm,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _dashBorder.withValues(alpha: .7),
      onTap: onTap,
      child: child,
    );
  }
}

class _NoticePanel extends StatelessWidget {
  const _NoticePanel({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 108 + MediaQuery.paddingOf(context).bottom,
      child: Material(
        color: AppColors.transparent,
        child: VitCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          borderColor: _dashGreen.withValues(alpha: .35),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _dashGreen,
                size: 18,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.stats});

  final List<TradeRegulatoryDailyStat> stats;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = _dashBorder.withValues(alpha: .62)
      ..strokeWidth = 1;
    final axis = Paint()
      ..color = AppColors.text3.withValues(alpha: .50)
      ..strokeWidth = 1;
    final chartRect = Rect.fromLTWH(58, 8, size.width - 66, size.height - 34);
    const maxValue = 240.0;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final label in const [240, 180, 120, 60, 0]) {
      final y = chartRect.bottom - (label / maxValue) * chartRect.height;
      _drawDashedLine(
        canvas,
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        grid,
      );
      textPainter.text = TextSpan(
        text: '$label',
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartRect.left - textPainter.width - 8, y - 6),
      );
    }

    for (var i = 0; i < stats.length; i++) {
      final x = chartRect.left + chartRect.width * i / (stats.length - 1);
      _drawDashedLine(
        canvas,
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        grid,
      );
    }

    canvas.drawLine(chartRect.topLeft, chartRect.bottomLeft, axis);
    canvas.drawLine(chartRect.bottomLeft, chartRect.bottomRight, axis);

    _drawLine(
      canvas,
      chartRect,
      stats.map((item) => item.total.toDouble()).toList(),
      _dashPrimary,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      stats.map((item) => item.confirmed.toDouble()).toList(),
      _dashGreen,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      stats.map((item) => item.failed.toDouble()).toList(),
      _dashRed,
      maxValue,
    );

    for (var i = 0; i < stats.length; i++) {
      final x = chartRect.left + chartRect.width * i / (stats.length - 1);
      textPainter.text = TextSpan(
        text: stats[i].date,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartRect.bottom + 8),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 3.0;
    const gap = 3.0;
    final distance = (end - start).distance;
    if (distance == 0) {
      return;
    }
    final direction = Offset(
      (end.dx - start.dx) / distance,
      (end.dy - start.dy) / distance,
    );
    var drawn = 0.0;
    while (drawn < distance) {
      final segmentEnd = math.min(drawn + dash, distance);
      canvas.drawLine(
        start + direction * drawn,
        start + direction * segmentEnd,
        paint,
      );
      drawn += dash + gap;
    }
  }

  void _drawLine(
    Canvas canvas,
    Rect chartRect,
    List<double> values,
    Color color,
    double maxValue,
  ) {
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chartRect.left + chartRect.width * i / (values.length - 1);
      final normalized = (values[i] / maxValue).clamp(0.0, 1.0).toDouble();
      final y = chartRect.bottom - normalized * chartRect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = color);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.stats != stats;
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.items});

  final List<TradeRegulatoryDistributionItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold<int>(0, (sum, item) => sum + item.value);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 14;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;
    for (final item in items) {
      final sweep = item.value / total * math.pi * 2;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = Color(item.colorHex)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: _formatInt(total),
        style: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
