import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

enum DcaBacktesterTab { setup, results, analysis }

class DcaReadOnlyField extends StatelessWidget {
  const DcaReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(color: AppColors.cardBorder),
            ),
          ),
          child: Padding(
            padding: AppSpacing.dcaPrimaryChipPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                if (icon != null)
                  Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DcaSelectionButton extends StatelessWidget {
  const DcaSelectionButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 160),
        tween: Tween<double>(end: selected ? 1 : 0),
        builder: (context, value, _) {
          final background = Color.lerp(
            AppColors.surface2,
            AppColors.primary,
            value,
          )!;
          final borderColor = Color.lerp(
            AppColors.cardBorder,
            AppColors.primary,
            value,
          )!;
          final textColor = Color.lerp(
            AppColors.text1,
            AppColors.onAccent,
            value,
          )!;
          return SizedBox(
            height: AppSpacing.ctaHeight - AppSpacing.x4,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: background,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.inputRadius,
                  side: BorderSide(color: borderColor),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: textColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DcaNoResultsCard extends StatelessWidget {
  const DcaNoResultsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.dcaPaddingX5,
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chưa có kết quả backtest',
            style: AppTextStyles.base.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Vào tab "Cài đặt" để chạy backtest',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class DcaStatusBadge extends StatelessWidget {
  const DcaStatusBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.dcaChipPadding,
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

class DcaSectionLabel extends StatelessWidget {
  const DcaSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: AppSpacing.x1,
          height: AppSpacing.x4,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class DcaCardTitle extends StatelessWidget {
  const DcaCardTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

String dcaFormatUsd(int value) {
  return '\$${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
}

String dcaFormatCompact(int value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return value.toString();
}
