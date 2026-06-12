part of '../pages/bot_risk_dashboard_page.dart';

class _DrawdownChartCard extends StatelessWidget {
  const _DrawdownChartCard({required this.points});

  final List<TradeBotDrawdownPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 19, 16, 15),
      child: SizedBox(
        height: 178,
        child: CustomPaint(
          painter: _DrawdownChartPainter(points),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _VarChartCard extends StatelessWidget {
  const _VarChartCard({required this.points});

  final List<TradeBotVarPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _VarChartPainter(points),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _DrawdownChartPainter extends CustomPainter {
  const _DrawdownChartPainter(this.points);

  final List<TradeBotDrawdownPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(66, 4, size.width - 74, size.height - 36);
    final path = Path();
    final area = Path();
    for (var i = 0; i < points.length; i++) {
      final x = plot.left + plot.width * i / (points.length - 1);
      final y = plot.top + plot.height * (points[i].value / -16).clamp(0, 1);
      if (i == 0) {
        path.moveTo(x, y);
        area.moveTo(x, plot.top);
        area.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        area.lineTo(x, y);
      }
    }
    area.lineTo(plot.right, plot.top);
    area.close();
    canvas.drawPath(area, Paint()..color = _riskRed.withValues(alpha: .18));
    canvas.drawPath(
      path,
      Paint()
        ..color = _riskRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawAxes(
      canvas,
      plot,
      ['0%', '-8%', '-12%', '-16%'],
      ['00:00', '04:00', '08:00', '12:00', '16:00', 'Now'],
    );
  }

  @override
  bool shouldRepaint(covariant _DrawdownChartPainter oldDelegate) => false;
}

class _VarChartPainter extends CustomPainter {
  const _VarChartPainter(this.points);

  final List<TradeBotVarPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(66, 10, size.width - 78, size.height - 34);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = plot.left + plot.width * i / (points.length - 1);
      final y = plot.bottom - plot.height * (points[i].value / 220).clamp(0, 1);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4.5, Paint()..color = _riskPurple);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _riskPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawAxes(
      canvas,
      plot,
      ['\$220', '\$110', '\$0'],
      [for (final point in points) point.label],
    );
  }

  @override
  bool shouldRepaint(covariant _VarChartPainter oldDelegate) => false;
}

void _drawAxes(
  Canvas canvas,
  Rect plot,
  List<String> yLabels,
  List<String> xLabels,
) {
  final axisPaint = Paint()
    ..color = AppColors.text3.withValues(alpha: .55)
    ..strokeWidth = 1;
  canvas.drawLine(plot.bottomLeft, plot.topLeft, axisPaint);
  canvas.drawLine(plot.bottomLeft, plot.bottomRight, axisPaint);

  for (var i = 0; i < yLabels.length; i++) {
    final y = plot.top + plot.height * i / (yLabels.length - 1);
    _drawSmallText(
      canvas,
      yLabels[i],
      Offset(plot.left - 8, y),
      alignRight: true,
    );
  }
  for (var i = 0; i < xLabels.length; i++) {
    final x = plot.left + plot.width * i / (xLabels.length - 1);
    _drawSmallText(
      canvas,
      xLabels[i],
      Offset(x, plot.bottom + 10),
      center: true,
    );
  }
}

void _drawSmallText(
  Canvas canvas,
  String text,
  Offset offset, {
  bool alignRight = false,
  bool center = false,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3, height: 1),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  var dx = offset.dx;
  if (alignRight) dx -= painter.width;
  if (center) dx -= painter.width / 2;
  painter.paint(canvas, Offset(dx, offset.dy - painter.height / 2));
}

Color _riskColor(int score) {
  if (score < 40) return _riskGreen;
  if (score < 70) return _riskAmber;
  return _riskRed;
}

String _formatCompact(double value) {
  final text = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
