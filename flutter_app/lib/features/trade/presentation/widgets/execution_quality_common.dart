import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const executionQualityPrimary = AppColors.primary;
const executionQualityCardBackground = AppColors.surface2;
const executionQualityChipBackground = AppColors.surface2;

const executionQualityContentKey = Key(
  'sc061_execution_quality_scroll_content',
);
const executionQualitySlippageButtonKey = Key('sc061_open_slippage');
const executionQualityExecutionButtonKey = Key('sc061_open_execution');
const executionQualityAmendmentButtonKey = Key('sc061_open_amendment');
const executionQualitySlippageSaveKey = Key('sc061_save_slippage');
const executionQualityAmendmentSaveKey = Key('sc061_save_amendment');

Key executionQualityTabKey(String id) => Key('sc061_tab_$id');
Key executionQualityFeatureKey(String id) => Key('sc061_feature_$id');
Key executionQualityToleranceKey(double value) => Key('sc061_tolerance_$value');

enum ExecutionQualityTab { slippage, execution, amendment }

class ExecutionQualityPanel extends StatelessWidget {
  const ExecutionQualityPanel({
    required this.child,
    this.padding = AppSpacing.tradeToolRiskIntroPadding,
    this.borderColor = AppColors.cardBorder,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      child: child,
    );
  }
}

class ExecutionQualityIconTile extends StatelessWidget {
  const ExecutionQualityIconTile({
    required this.icon,
    required this.color,
    required this.size,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: size,
      height: size,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: color.withValues(alpha: .28),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class ExecutionQualityGradientButton extends StatelessWidget {
  const ExecutionQualityGradientButton({
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: _executionCtaVariantFor(colors),
      leading: Icon(icon),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.control.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class ExecutionQualityStatusPill extends StatelessWidget {
  const ExecutionQualityStatusPill({required this.complete, super.key});

  final bool complete;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: complete ? 'Complete' : 'Pending',
      status: complete
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.warning,
      icon: complete ? Icons.check_rounded : Icons.schedule_rounded,
      size: VitStatusPillSize.sm,
    );
  }
}

class ExecutionQualitySuccessToast extends StatelessWidget {
  const ExecutionQualitySuccessToast({
    required this.message,
    required this.onClose,
    super.key,
  });

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: VitCard(
        padding: AppSpacing.tradeToolToastPadding,
        variant: VitCardVariant.inner,
        borderColor: AppColors.buy.withValues(alpha: .38),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.buy,
              size: AppSpacing.tradeToolBodyIcon,
            ),
            const SizedBox(width: AppSpacing.tradeToolIconGap),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Close success message',
              onPressed: onClose,
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.sm,
            ),
          ],
        ),
      ),
    );
  }
}

VitCtaButtonVariant _executionCtaVariantFor(List<Color> colors) {
  final first = colors.first;
  if (first == AppColors.buy) return VitCtaButtonVariant.success;
  if (first == AppColors.caution) return VitCtaButtonVariant.warning;
  if (first == AppColors.sell) return VitCtaButtonVariant.danger;
  return VitCtaButtonVariant.primary;
}

String formatExecutionQualityMoney(double value) {
  if (value >= 1000) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final buffer = StringBuffer();
    for (var i = 0; i < parts.first.length; i++) {
      final remaining = parts.first.length - i;
      buffer.write(parts.first[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return '${buffer.toString()}.${parts.last}';
  }
  return value.toStringAsFixed(2);
}
