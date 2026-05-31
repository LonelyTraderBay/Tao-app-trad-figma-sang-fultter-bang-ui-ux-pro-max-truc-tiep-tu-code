import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_common.dart';

class UnifiedDonutDistributionPainter extends CustomPainter {
  const UnifiedDonutDistributionPainter({
    required this.modules,
    required this.total,
  });

  final List<UnifiedPortfolioModuleDraft> modules;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .36;
    final stroke = AppSpacing.x6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = AppColors.surface3;
    canvas.drawCircle(center, radius, bg);

    for (final module in modules) {
      final sweep = total == 0 ? 0.0 : module.value / total * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = unifiedModuleAccent(module.id);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant UnifiedDonutDistributionPainter oldDelegate) =>
      oldDelegate.modules != modules || oldDelegate.total != total;
}

class UnifiedPnlBarPainter extends CustomPainter {
  const UnifiedPnlBarPainter({required this.modules});

  final List<UnifiedPortfolioModuleDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    if (modules.isEmpty) return;
    final maxAbs = modules
        .map((module) => module.pnl.abs())
        .reduce((value, element) => math.max(value, element));
    final chartTop = AppSpacing.x4;
    final chartBottom = size.height - AppSpacing.x6;
    final zeroY = chartTop + (chartBottom - chartTop) * .58;
    final slot = size.width / modules.length;
    final barWidth = math.min(AppSpacing.x7, slot * .55);

    final axisPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), axisPaint);

    for (var i = 0; i < modules.length; i++) {
      final module = modules[i];
      final x = slot * i + (slot - barWidth) / 2;
      final height = maxAbs == 0
          ? 0.0
          : (module.pnl.abs() / maxAbs) * AppSpacing.buttonHero;
      final top = module.pnl >= 0 ? zeroY - height : zeroY;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, height),
        const Radius.circular(AppSpacing.x2),
      );
      final paint = Paint()
        ..color = module.pnl >= 0 ? AppColors.buy : AppColors.sell;
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant UnifiedPnlBarPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

class UnifiedHistoryLinePainter extends CustomPainter {
  const UnifiedHistoryLinePainter({required this.points});

  final List<UnifiedPortfolioHistoryPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final allValues = [
      for (final point in points) ...[
        point.wallet,
        point.trading,
        point.p2p,
        point.predictions,
        point.dca,
      ],
    ];
    final minValue = allValues.reduce(math.min).toDouble();
    final maxValue = allValues.reduce(math.max).toDouble();

    void drawSeries(
      int Function(UnifiedPortfolioHistoryPoint point) valueOf,
      Color color,
    ) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = i / (points.length - 1) * size.width;
        final raw = valueOf(points[i]).toDouble();
        final normalized = (raw - minValue) / (maxValue - minValue);
        final y = size.height - normalized * (size.height - AppSpacing.x6);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSpacing.x1
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawPath(path, paint);
    }

    drawSeries((point) => point.wallet, AppModuleAccents.wallet);
    drawSeries((point) => point.trading, AppModuleAccents.trade);
    drawSeries((point) => point.p2p, AppModuleAccents.p2p);
    drawSeries((point) => point.predictions, AppModuleAccents.predictions);
    drawSeries((point) => point.dca, AppColors.accent);
  }

  @override
  bool shouldRepaint(covariant UnifiedHistoryLinePainter oldDelegate) =>
      oldDelegate.points != points;
}
