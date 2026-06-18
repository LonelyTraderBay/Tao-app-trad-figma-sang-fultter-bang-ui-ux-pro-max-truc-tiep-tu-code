part of 'savings_backtest_page.dart';

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warningBg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.warningBorder),
        ),
      ),
      child: Padding(
        padding: AppSpacing.earnPaddingX4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.savingsBacktestWarningLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.savingsBacktestSelectionDot,
      height: AppSpacing.savingsBacktestSelectionDot,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(color: selected ? color : AppColors.borderSolid),
          ),
        ),
        child: selected
            ? Center(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color,
                    shape: const CircleBorder(),
                  ),
                  child: const SizedBox(
                    width: AppSpacing.savingsBacktestSelectionDotInner,
                    height: AppSpacing.savingsBacktestSelectionDotInner,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _AllocationRingPainter extends CustomPainter {
  const _AllocationRingPainter({required this.slots});

  final List<SavingsBacktestSlotDraft> slots;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const stroke = 16.0;
    var start = -math.pi / 2;
    for (final slot in slots) {
      final sweep = math.pi * 2 * slot.percentage / 100;
      final paint = Paint()
        ..color = _slotColor(slot.colorKey)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect.deflate(stroke / 2), start, sweep, false, paint);
      start += sweep;
    }
    final inner = Paint()..color = AppColors.surface;
    canvas.drawCircle(size.center(Offset.zero), size.width * 0.25, inner);
  }

  @override
  bool shouldRepaint(covariant _AllocationRingPainter oldDelegate) {
    return oldDelegate.slots != slots;
  }
}

class _GrowthPainter extends CustomPainter {
  const _GrowthPainter({required this.points, required this.initialAmount});

  final List<SavingsBacktestPointDraft> points;
  final double initialAmount;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minValue = points.map((p) => p.valueUsd).reduce(math.min);
    final maxValue = points.map((p) => p.valueUsd).reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final chartRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = chartRect.top + chartRect.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final baselineY =
        chartRect.bottom -
        ((initialAmount - minValue) / range) * chartRect.height;
    final baselinePaint = Paint()
      ..color = AppColors.warn
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, baselineY.clamp(0, size.height)),
      Offset(size.width, baselineY.clamp(0, size.height)),
      baselinePaint,
    );

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      final y =
          chartRect.bottom -
          ((points[i].valueUsd - minValue) / range) * chartRect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = AppColors.buy10);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.buy
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _GrowthPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.initialAmount != initialAmount;
  }
}

SavingsBacktestPresetDraft _presetById(
  SavingsBacktestSnapshot snapshot,
  SavingsBacktestPreset id,
) {
  return snapshot.presets.firstWhere(
    (preset) => preset.id == id,
    orElse: () => snapshot.presets.first,
  );
}

SavingsBacktestPeriodDraft _periodById(
  SavingsBacktestSnapshot snapshot,
  SavingsBacktestPeriod id,
) {
  return snapshot.periods.firstWhere(
    (period) => period.id == id,
    orElse: () => snapshot.periods.first,
  );
}

double _weightedApy(List<SavingsBacktestSlotDraft> slots) {
  return slots.fold<double>(
    0,
    (total, slot) => total + (slot.avgApy * slot.percentage / 100),
  );
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'shield' => Icons.shield_outlined,
    'target' => Icons.center_focus_strong_rounded,
    'bolt' => Icons.bolt_outlined,
    'sliders' => Icons.tune_rounded,
    _ => Icons.savings_outlined,
  };
}

Color _presetColor(SavingsBacktestPreset preset) {
  return switch (preset) {
    SavingsBacktestPreset.conservative => AppColors.buy,
    SavingsBacktestPreset.balanced => AppColors.primary,
    SavingsBacktestPreset.aggressive => AppColors.warn,
    SavingsBacktestPreset.custom => AppColors.accent,
  };
}

Color _slotColor(String colorKey) {
  return switch (colorKey) {
    'buy' => AppColors.buy,
    'primary' => AppColors.primary,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'sell' => AppColors.sell,
    _ => AppColors.text3,
  };
}

String _usd(num value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '\$$buffer.${parts.last}';
}

String _compactAmount(int value) {
  if (value >= 1000) return '${value ~/ 1000}K';
  return '$value';
}
