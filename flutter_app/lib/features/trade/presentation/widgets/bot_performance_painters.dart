part of '../pages/bot_performance_analytics_page.dart';

class _PnlChartPainter extends CustomPainter {
  const _PnlChartPainter(this.points);

  final List<TradeBotPnlPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 8, size.width - 72, size.height - 42);
    final axisPaint = Paint()
      ..color = _chartAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 50, 100, 150, 200]) {
      final y = chart.bottom - (value / 200) * chart.height;
      _paintText(
        canvas,
        '\$$value',
        Offset(0, y - 6),
        AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        width: 42,
        align: TextAlign.right,
      );
    }

    for (final item in [
      (label: 'Mar 2', index: 1),
      (label: 'Mar 4', index: 3),
      (label: 'Mar 6', index: 5),
      (label: 'Mar 8', index: 7),
    ]) {
      final x =
          chart.left +
          item.index / (points.length - 1).clamp(1, 999) * chart.width;
      _paintText(
        canvas,
        item.label,
        Offset(x - 18, chart.bottom + 10),
        AppTextStyles.micro.copyWith(color: AppColors.text3),
        width: 42,
        align: TextAlign.center,
      );
    }

    if (points.isEmpty) return;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x =
          chart.left + (i / (points.length - 1).clamp(1, 999)) * chart.width;
      final y = chart.bottom - (points[i].pnl / 220).clamp(0, 1) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = _analyticsGreen
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = _analyticsGreen;
    for (var i = 0; i < points.length; i++) {
      final x =
          chart.left + (i / (points.length - 1).clamp(1, 999)) * chart.width;
      final y = chart.bottom - (points[i].pnl / 220).clamp(0, 1) * chart.height;
      canvas.drawCircle(Offset(x, y), 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PnlChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _WinLossChartPainter extends CustomPainter {
  const _WinLossChartPainter(this.points);

  final List<TradeBotWinLossPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 6, size.width - 72, size.height - 46);
    final axisPaint = Paint()
      ..color = _chartAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 7, 14, 28]) {
      final y = chart.bottom - (value / 28) * chart.height;
      _paintText(
        canvas,
        '$value',
        Offset(4, y - 6),
        AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        width: 38,
        align: TextAlign.right,
      );
    }

    if (points.isEmpty) return;
    final groupWidth = chart.width / points.length;
    final barWidth = 27.0;
    const radius = AppRadii.chartBarCorner;
    final winPaint = Paint()..color = _analyticsGreen;
    final lossPaint = Paint()..color = _analyticsRed;

    for (var i = 0; i < points.length; i++) {
      final center = chart.left + groupWidth * i + groupWidth / 2;
      final winHeight = points[i].wins / 28 * chart.height;
      final lossHeight = points[i].losses / 28 * chart.height;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            center - barWidth - 3,
            chart.bottom - winHeight,
            barWidth,
            winHeight,
          ),
          topLeft: radius,
          topRight: radius,
        ),
        winPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            center + 3,
            chart.bottom - lossHeight,
            barWidth,
            lossHeight,
          ),
          topLeft: radius,
          topRight: radius,
        ),
        lossPaint,
      );
      _paintText(
        canvas,
        points[i].week,
        Offset(center - 16, chart.bottom + 10),
        AppTextStyles.micro.copyWith(color: AppColors.text3),
        width: 32,
        align: TextAlign.center,
      );
    }

    final legendY = size.height - 18;
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 38, legendY - 6, 14, 10),
      winPaint,
    );
    _paintText(
      canvas,
      'Wins',
      Offset(size.width / 2 - 20, legendY - 8),
      AppTextStyles.captionSm.copyWith(color: _analyticsGreen),
      width: 38,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 + 18, legendY - 6, 14, 10),
      lossPaint,
    );
    _paintText(
      canvas,
      'Losses',
      Offset(size.width / 2 + 36, legendY - 8),
      AppTextStyles.captionSm.copyWith(color: _analyticsRed),
      width: 54,
    );
  }

  @override
  bool shouldRepaint(covariant _WinLossChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DurationDonutPainter extends CustomPainter {
  const _DurationDonutPainter(this.distribution);

  final List<TradeBotDurationDistribution> distribution;

  @override
  void paint(Canvas canvas, Size size) {
    final total = distribution.fold<int>(0, (sum, item) => sum + item.count);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: 70);
    var start = -math.pi / 2;
    final colors = [
      AppColors.text1,
      AppColors.chartLightMid,
      AppColors.chartLightLow,
      AppColors.text1,
    ];
    for (var i = 0; i < distribution.length; i++) {
      final sweep = distribution[i].count / total * math.pi * 2;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, start + .02, math.max(0, sweep - .04), false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DurationDonutPainter oldDelegate) =>
      oldDelegate.distribution != distribution;
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  TextStyle style, {
  double width = 80,
  TextAlign align = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: style.copyWith(
        fontWeight: AppTextStyles.medium,
        height: AppSpacing.tradeBotLineHeightTight,
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
