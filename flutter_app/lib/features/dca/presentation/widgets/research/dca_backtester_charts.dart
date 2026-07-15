import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_common.dart';

class DcaBacktestGrowthPainter extends CustomPainter {
  const DcaBacktestGrowthPainter({required this.points});

  final List<DcaBacktestPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxValue = points
        .map((point) => math.max(point.dcaValueUsd, point.lumpValueUsd))
        .reduce(math.max)
        .toDouble();
    _drawGrid(canvas, size, maxValue);
    _drawValueLine(
      canvas,
      size,
      points.map((point) => point.dcaValueUsd / maxValue).toList(),
      AppColors.buy,
      fill: true,
    );
    _drawValueLine(
      canvas,
      size,
      points.map((point) => point.lumpValueUsd / maxValue).toList(),
      AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant DcaBacktestGrowthPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class DcaDrawdownPainter extends CustomPainter {
  const DcaDrawdownPainter({required this.points});

  final List<DcaDrawdownPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    _drawGrid(canvas, size, 10);
    _drawValueLine(
      canvas,
      size,
      points
          .map(
            (point) =>
                1.0 -
                (point.drawdownPercent.abs() / 12).clamp(0.0, 1.0).toDouble(),
          )
          .toList(),
      AppColors.sell,
      fill: true,
    );
  }

  @override
  bool shouldRepaint(covariant DcaDrawdownPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawGrid(Canvas canvas, Size size, double maxValue) {
  final rect = Rect.fromLTWH(
    AppSpacing.x6,
    AppSpacing.x2,
    size.width - AppSpacing.x7,
    size.height - AppSpacing.x6,
  );
  final grid = Paint()
    ..color = AppColors.borderSolid.withValues(alpha: .45)
    ..strokeWidth = 1;
  final style = AppTextStyles.micro.copyWith(color: AppColors.text3);
  for (var i = 0; i <= 4; i++) {
    final y = rect.top + rect.height * i / 4;
    canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), grid);
    _paintText(
      canvas,
      dcaFormatCompact((maxValue * (1 - i / 4)).round()),
      Offset(AppSpacing.x2, y - AppSpacing.x3),
      style,
    );
  }
  for (var i = 0; i <= 5; i++) {
    final x = rect.left + rect.width * i / 5;
    canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), grid);
  }
}

void _drawValueLine(
  Canvas canvas,
  Size size,
  List<double> values,
  Color color, {
  bool fill = false,
}) {
  final rect = Rect.fromLTWH(
    AppSpacing.x6,
    AppSpacing.x2,
    size.width - AppSpacing.x7,
    size.height - AppSpacing.x6,
  );
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = rect.left + rect.width * i / (values.length - 1);
    final y = rect.bottom - rect.height * values[i].clamp(0, 1);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: .12)
        ..style = PaintingStyle.fill,
    );
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2,
  );
}

void _paintText(Canvas canvas, String text, Offset offset, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}
