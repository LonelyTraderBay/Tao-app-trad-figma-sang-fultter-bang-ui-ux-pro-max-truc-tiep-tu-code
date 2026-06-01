part of '../pages/bot_equity_curve_page.dart';

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
      decoration: BoxDecoration(
        color: _equityGreen.withValues(alpha: .10),
        border: Border.all(color: _equityGreen.withValues(alpha: .30)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 13,
                height: 13,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.successAccentSoft,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: AppColors.onAccent,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'Strong Outperformance',
                style: AppTextStyles.caption.copyWith(
                  color: _equityGreen,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: const BoxDecoration(
                    color: AppColors.text3,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _equityPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _equityPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _EquityPainter extends CustomPainter {
  const _EquityPainter(this.points);

  final List<TradeBotEquityCurvePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 7, size.width - 88, size.height - 39);
    _drawAxes(canvas, chart, yLabels: [1800, 1350, 900, 450, 0]);
    const tickIndices = [0, 2, 4, 6, 8, 10, 12];
    for (final index in tickIndices) {
      final x = chart.left + index / (points.length - 1) * chart.width;
      _paintText(
        canvas,
        points[index].monthLabel,
        Offset(x - 14, chart.bottom + 10),
        AppColors.text3,
        10,
        width: 30,
        align: TextAlign.center,
      );
    }

    final line = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - points[i].equity / 1800 * chart.height;
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }
    final fill = Path.from(line)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.buy.withValues(alpha: .33),
            AppColors.buy.withValues(alpha: 0),
          ],
        ).createShader(chart),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = _equityGreen
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _EquityPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _SharpePainter extends CustomPainter {
  const _SharpePainter(this.points);

  final List<TradeBotEquityCurvePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 8, size.width - 70, size.height - 36);
    final axisPaint = Paint()
      ..color = _equityAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final value = points[i].rollingSharpe ?? 0;
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - value / 2.5 * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _equityPrimary
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _SharpePainter oldDelegate) =>
      oldDelegate.points != points;
}

void _drawAxes(Canvas canvas, Rect chart, {required List<int> yLabels}) {
  final axisPaint = Paint()
    ..color = _equityAxis
    ..strokeWidth = 1;
  canvas
    ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
    ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
  for (final value in yLabels) {
    final y = chart.bottom - value / 1800 * chart.height;
    _paintText(
      canvas,
      '\$$value',
      Offset(8, y - 5),
      AppColors.text3,
      10,
      width: 48,
      align: TextAlign.right,
    );
  }
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  Color color,
  double fontSize, {
  double width = 80,
  TextAlign align = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        height: 1,
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
