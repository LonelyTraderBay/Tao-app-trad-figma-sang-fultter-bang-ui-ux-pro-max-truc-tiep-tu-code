import 'package:flutter/material.dart';

class VitSparkline extends StatelessWidget {
  const VitSparkline({
    super.key,
    required this.values,
    required this.color,
    this.showFill = true,
    this.strokeWidth = 1.5,
  });

  final List<double> values;
  final Color color;
  final bool showFill;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VitSparklinePainter(
        values: values,
        color: color,
        showFill: showFill,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _VitSparklinePainter extends CustomPainter {
  const _VitSparklinePainter({
    required this.values,
    required this.color,
    required this.showFill,
    required this.strokeWidth,
  });

  final List<double> values;
  final Color color;
  final bool showFill;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.isEmpty) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y =
          size.height -
          ((values[i] - minValue) / range * (size.height - 6)) -
          3;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    if (showFill) {
      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size)
        ..style = PaintingStyle.fill;
      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _VitSparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.color != color ||
        oldDelegate.showFill != showFill ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
