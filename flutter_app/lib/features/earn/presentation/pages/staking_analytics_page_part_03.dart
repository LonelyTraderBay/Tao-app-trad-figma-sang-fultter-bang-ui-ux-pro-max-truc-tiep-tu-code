part of 'staking_analytics_page.dart';

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.entries});

  final List<_LegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x2,
      children: [
        for (final entry in entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: entry.color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.swatchRadius,
                  ),
                ),
                child: const SizedBox(
                  width: EarnSpacingTokens.earnAnalyticsLegendMarkerWidth,
                  height: _stakingAnalyticsLegendMarkerHeight,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                entry.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LegendEntry {
  const _LegendEntry({required this.label, required this.color});

  final String label;
  final Color color;
}

class _StackedAreaPainter extends CustomPainter {
  const _StackedAreaPainter({required this.points});

  final List<StakingEarningsPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    if (points.length < 2) return;

    const series = [
      _SeriesSpec(color: _AssetPalette.btc, selector: _SeriesValue.btc),
      _SeriesSpec(color: _AssetPalette.usdt, selector: _SeriesValue.usdt),
      _SeriesSpec(color: _AssetPalette.eth, selector: _SeriesValue.eth),
      _SeriesSpec(color: _AssetPalette.sol, selector: _SeriesValue.sol),
      _SeriesSpec(color: _AssetPalette.lp, selector: _SeriesValue.lp),
    ];
    final maxValue = math.max(
      320.0,
      points.map((p) => p.total).reduce(math.max),
    );
    var previous = List<double>.filled(points.length, 0);

    for (final spec in series) {
      final next = <double>[
        for (var i = 0; i < points.length; i++)
          previous[i] + spec.value(points[i]),
      ];
      final topPath = _linePath(size, next, maxValue);
      final areaPath = Path.from(topPath);
      for (var i = points.length - 1; i >= 0; i--) {
        areaPath.lineTo(
          _x(size, i, points.length),
          _y(size, previous[i], maxValue),
        );
      }
      areaPath.close();

      canvas.drawPath(
        areaPath,
        Paint()
          ..color = spec.color.withValues(alpha: 0.62)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        topPath,
        Paint()
          ..color = spec.color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
      previous = next;
    }
  }

  @override
  bool shouldRepaint(covariant _StackedAreaPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _ApyTrendPainter extends CustomPainter {
  const _ApyTrendPainter({required this.points});

  final List<StakingApyTrendPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.flexible).toList(),
      maxValue: 25,
      color: AppColors.buy,
    );
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.fixed).toList(),
      maxValue: 25,
      color: AppColors.primarySoft,
    );
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.defi).toList(),
      maxValue: 25,
      color: AppColors.warn,
    );
  }

  @override
  bool shouldRepaint(covariant _ApyTrendPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RoiBarPainter extends CustomPainter {
  const _RoiBarPainter({required this.points});

  final List<StakingRoiComparisonPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    if (points.isEmpty) return;

    final baselineY = _y(size, 0, 16, minValue: -4);
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      Paint()
        ..color = AppColors.borderSolid
        ..strokeWidth = 1,
    );

    final groupWidth = size.width / points.length;
    final barWidth = math.min(15.0, groupWidth * 0.25);
    for (var i = 0; i < points.length; i++) {
      final center = groupWidth * i + groupWidth / 2;
      _paintBar(
        canvas,
        size,
        x: center - barWidth - 2,
        width: barWidth,
        value: points[i].staking,
        color: AppColors.buy,
      );
      _paintBar(
        canvas,
        size,
        x: center + 2,
        width: barWidth,
        value: points[i].holding,
        color: AppColors.sell,
      );
    }
  }

  void _paintBar(
    Canvas canvas,
    Size size, {
    required double x,
    required double width,
    required double value,
    required Color color,
  }) {
    final baselineY = _y(size, 0, 16, minValue: -4);
    final valueY = _y(size, value, 16, minValue: -4);
    final top = math.min(baselineY, valueY);
    final height = (baselineY - valueY).abs().clamp(3.0, size.height);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, top, width, height),
      AppRadii.xsCorner,
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RoiBarPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _SeriesSpec {
  const _SeriesSpec({required this.color, required this.selector});

  final Color color;
  final _SeriesValue selector;

  double value(StakingEarningsPointDraft point) {
    return switch (selector) {
      _SeriesValue.btc => point.btc,
      _SeriesValue.usdt => point.usdt,
      _SeriesValue.eth => point.eth,
      _SeriesValue.sol => point.sol,
      _SeriesValue.lp => point.lp,
    };
  }
}

enum _SeriesValue { btc, usdt, eth, sol, lp }

final class _AssetPalette {
  const _AssetPalette._();

  static const Color btc = AppColors.primary;
  static const Color usdt = AppColors.buy;
  static const Color eth = AppColors.accent;
  static const Color sol = AppColors.primarySoft;
  static const Color lp = AppColors.sell;
}

void _paintGrid(Canvas canvas, Size size, int lines) {
  final paint = Paint()
    ..color = AppColors.divider
    ..strokeWidth = 1;
  for (var i = 0; i <= lines; i++) {
    final y = size.height * i / lines;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
}

void _drawLine(
  Canvas canvas,
  Size size, {
  required List<double> values,
  required double maxValue,
  required Color color,
}) {
  if (values.length < 2) return;
  final path = _linePath(size, values, maxValue);
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  canvas.drawPath(path, paint);
  final dotPaint = Paint()..color = color;
  for (var i = 0; i < values.length; i++) {
    canvas.drawCircle(
      Offset(_x(size, i, values.length), _y(size, values[i], maxValue)),
      3,
      dotPaint,
    );
  }
}

Path _linePath(Size size, List<double> values, double maxValue) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final point = Offset(
      _x(size, i, values.length),
      _y(size, values[i], maxValue),
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  return path;
}

double _x(Size size, int index, int length) {
  if (length <= 1) return 0;
  return size.width * index / (length - 1);
}

double _y(Size size, double value, double maxValue, {double minValue = 0}) {
  final safeRange = math.max(1, maxValue - minValue);
  final normalized = ((value - minValue) / safeRange).clamp(0.0, 1.0);
  return size.height - normalized * size.height;
}

Color _assetColor(int index) {
  return switch (index) {
    0 => _AssetPalette.btc,
    1 => _AssetPalette.usdt,
    2 => _AssetPalette.eth,
    3 => _AssetPalette.sol,
    _ => _AssetPalette.lp,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return '\$${buffer.toString()}.${parts.last}';
}
