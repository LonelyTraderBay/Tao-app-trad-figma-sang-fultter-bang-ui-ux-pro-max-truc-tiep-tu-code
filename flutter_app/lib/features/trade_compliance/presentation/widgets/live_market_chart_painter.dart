import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/live_market_common_widgets.dart';

class LiveMarketLinePainter extends CustomPainter {
  const LiveMarketLinePainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final span = math.max(maxValue - minValue, .001);
    final zeroY = size.height * (maxValue / span).clamp(0, 1);
    final gridPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .18)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), gridPaint);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - ((values[i] - minValue) / span * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = liveMarketRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant LiveMarketLinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
