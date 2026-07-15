import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';

class TraderProfileAreaChartPainter extends CustomPainter {
  const TraderProfileAreaChartPainter({required this.points});

  final List<TradeTraderPnlPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    const padding = 4.0;
    final values = points.map((point) => point.cumPnl).toList(growable: false);
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(1, maxValue - minValue);
    final linePath = Path();
    final areaPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = padding + (size.width - padding * 2) * i / (values.length - 1);
      final y =
          padding +
          (size.height - padding * 2) * (1 - (values[i] - minValue) / span);
      if (i == 0) {
        linePath.moveTo(x, y);
        areaPath.moveTo(x, size.height - padding);
        areaPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        areaPath.lineTo(x, y);
      }
    }
    areaPath
      ..lineTo(size.width - padding, size.height - padding)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.buy.withValues(alpha: .30),
          AppColors.buy.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    final linePaint = Paint()
      ..color = AppColors.buy
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(areaPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant TraderProfileAreaChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class TraderProfileDailyBarsPainter extends CustomPainter {
  const TraderProfileDailyBarsPainter({required this.points});

  final List<TradeTraderPnlPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxAbs = points
        .map((point) => point.pnl.abs())
        .fold<double>(0, math.max)
        .clamp(1, double.infinity);
    final zeroY = size.height * .58;
    final gap = 5.0;
    final barWidth = (size.width - gap * (points.length - 1)) / points.length;

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final height = (point.pnl.abs() / maxAbs) * (size.height * .46);
      final left = i * (barWidth + gap);
      final top = point.pnl >= 0 ? zeroY - height : zeroY;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, height.clamp(3, size.height)),
        AppRadii.swatchCorner,
      );
      final paint = Paint()
        ..color = point.pnl >= 0 ? AppColors.buy : AppColors.sell;
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TraderProfileDailyBarsPainter oldDelegate) =>
      oldDelegate.points != points;
}
