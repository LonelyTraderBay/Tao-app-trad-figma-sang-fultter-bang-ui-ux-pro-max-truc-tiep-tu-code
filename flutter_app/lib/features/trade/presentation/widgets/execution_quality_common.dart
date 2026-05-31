import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

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
    this.padding = const EdgeInsets.all(16),
    this.borderColor = AppColors.cardBorder,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: executionQualityCardBackground,
        border: Border.all(color: borderColor),
        borderRadius: AppRadii.cardRadius,
      ),
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
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: AppRadii.inputRadius,
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: .28),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onAccent, size: 17),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
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
    final color = complete ? AppColors.buy : AppColors.caution;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        complete ? 'âœ“ Complete' : 'â³ Pending',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.buy10,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.buy.withValues(alpha: .38)),
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicIslandBg.withValues(alpha: .22),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.buy,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            InkWell(
              onTap: onClose,
              borderRadius: AppRadii.xsRadius,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.text2,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
