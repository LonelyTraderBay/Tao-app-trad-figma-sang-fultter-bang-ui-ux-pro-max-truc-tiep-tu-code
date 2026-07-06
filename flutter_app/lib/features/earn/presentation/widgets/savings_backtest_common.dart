import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_backtest_formatters.dart';

class RoundIcon extends StatelessWidget {
  const RoundIcon({super.key, required this.icon, required this.color});

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

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color});

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

class SelectionDot extends StatelessWidget {
  const SelectionDot({super.key, required this.selected, required this.color});

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

class AllocationRingPainter extends CustomPainter {
  const AllocationRingPainter({required this.slots});

  final List<SavingsBacktestSlotDraft> slots;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const stroke = 16.0;
    var start = -math.pi / 2;
    for (final slot in slots) {
      final sweep = math.pi * 2 * slot.percentage / 100;
      final paint = Paint()
        ..color = slotColor(slot.colorKey)
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
  bool shouldRepaint(covariant AllocationRingPainter oldDelegate) {
    return oldDelegate.slots != slots;
  }
}
