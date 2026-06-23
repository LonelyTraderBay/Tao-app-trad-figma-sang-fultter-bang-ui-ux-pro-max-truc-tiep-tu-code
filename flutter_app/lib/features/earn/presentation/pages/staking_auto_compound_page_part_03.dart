part of 'staking_auto_compound_page.dart';

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.successToastKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: AppSpacing.earnPaddingX4,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Đã lưu cài đặt auto-compound',
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ),
          VitIconButton(
            icon: Icons.close_rounded,
            tooltip: 'Close',
            onPressed: onDismiss,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.md,
          ),
        ],
      ),
    );
  }
}

class _CheckBoxIndicator extends StatelessWidget {
  const _CheckBoxIndicator({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.x5,
      child: Material(
        color: checked ? AppColors.buy : AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.smRadius,
          side: BorderSide(
            color: checked ? AppColors.buy : AppColors.borderSolid,
            width: AppSpacing.stakingAutoCompoundCheckBorderWidth,
          ),
        ),
        child: checked
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.iconSm,
              )
            : null,
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: enabled,
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.lg,
        padding: AppSpacing.zeroInsets,
        onTap: onTap,
        child: VitTogglePill(
          enabled: enabled,
          width: AppSpacing.stakingAutoCompoundToggleWidth,
          height: AppSpacing.stakingAutoCompoundToggleHeight,
          knobSize: AppSpacing.x5,
          knobMargin: AppSpacing.earnPaddingX1,
          activeColor: AppColors.buy,
          inactiveColor: AppColors.surface3,
          inactiveKnobColor: AppColors.onAccent,
          inactiveBorderColor: AppColors.surface3,
          duration: const Duration(milliseconds: 180),
        ),
      ),
    );
  }
}

class _CompoundChartPainter extends CustomPainter {
  const _CompoundChartPainter({required this.points});

  final List<StakingAutoCompoundPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final chart = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width - AppSpacing.x7,
      size.height - AppSpacing.x6,
    );
    final values = [
      for (final point in points) point.withCompound,
      for (final point in points) point.withoutCompound,
      0.0,
    ];
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(maxValue - minValue, 1);

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final value = minValue + span * i / 4;
      labelPainter.text = TextSpan(
        text: '\$${(value / 1000).toStringAsFixed(1)}k',
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      );
      labelPainter.layout(maxWidth: AppSpacing.x6 - AppSpacing.x2);
      labelPainter.paint(
        canvas,
        Offset(
          chart.left - labelPainter.width - AppSpacing.x3,
          y - labelPainter.height / 2,
        ),
      );
    }

    Path buildPath(double Function(StakingAutoCompoundPointDraft point) value) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final point = points[i];
        final x = chart.left + chart.width * i / (points.length - 1);
        final y =
            chart.bottom - ((value(point) - minValue) / span) * chart.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final withoutPaint = Paint()
      ..color = AppColors.sell
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final withPaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(buildPath((point) => point.withoutCompound), withoutPaint);
    canvas.drawPath(buildPath((point) => point.withCompound), withPaint);
  }

  @override
  bool shouldRepaint(covariant _CompoundChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

final class _CompoundSimulation {
  const _CompoundSimulation({
    required this.points,
    required this.withCompound,
    required this.withoutCompound,
    required this.difference,
    required this.percentageGain,
  });

  final List<StakingAutoCompoundPointDraft> points;
  final double withCompound;
  final double withoutCompound;
  final double difference;
  final double percentageGain;
}

String _frequencyLabel(String frequency) {
  return switch (frequency) {
    'daily' => 'Hàng ngày',
    'weekly' => 'Hàng tuần',
    'monthly' => 'Hàng tháng',
    _ => frequency,
  };
}

String _formatAmount(double value) {
  if (value >= 1000) return value.toStringAsFixed(0);
  if (value >= 1) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }
  return value.toString();
}

String _formatCurrency(double value, {bool compact = false}) {
  final fractionDigits = compact ? 0 : 2;
  final rounded = value.toStringAsFixed(fractionDigits);
  final parts = rounded.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return '\$${buffer.toString()}';
}

double _parseDouble(String value, double fallback) {
  return double.tryParse(value.replaceAll(',', '').trim()) ?? fallback;
}

int _parseInt(String value, int fallback) {
  return int.tryParse(value.trim()) ?? fallback;
}
