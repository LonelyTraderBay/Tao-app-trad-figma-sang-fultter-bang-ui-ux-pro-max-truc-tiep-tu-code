import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';

enum VitStatusPillStatus {
  success,
  warning,
  error,
  info,
  neutral,
  purple,
  orange,
}

enum VitStatusPillSize { sm, md, lg }

class VitStatusPill extends StatelessWidget {
  const VitStatusPill({
    super.key,
    required this.label,
    this.status = VitStatusPillStatus.neutral,
    this.icon,
    this.size = VitStatusPillSize.md,
    this.pulse = false,
    this.outline = false,
    this.count,
    this.onTap,
  });

  final String label;
  final VitStatusPillStatus status;
  final IconData? icon;
  final VitStatusPillSize size;
  final bool pulse;
  final bool outline;
  final int? count;
  final VoidCallback? onTap;

  _StatusPalette get _palette {
    switch (status) {
      case VitStatusPillStatus.success:
        return const _StatusPalette(
          background: AppColors.buy15,
          foreground: AppColors.buy,
          border: AppColors.buy20,
        );
      case VitStatusPillStatus.warning:
      case VitStatusPillStatus.orange:
        return const _StatusPalette(
          background: AppColors.warn15,
          foreground: AppColors.warn,
          border: AppColors.warningBorder,
        );
      case VitStatusPillStatus.error:
        return const _StatusPalette(
          background: AppColors.sell15,
          foreground: AppColors.sell,
          border: AppColors.sell20,
        );
      case VitStatusPillStatus.info:
        return const _StatusPalette(
          background: AppColors.primary12,
          foreground: AppColors.primary,
          border: AppColors.primary20,
        );
      case VitStatusPillStatus.purple:
        return const _StatusPalette(
          background: AppColors.accent12,
          foreground: AppColors.accent,
          border: AppColors.accent20,
        );
      case VitStatusPillStatus.neutral:
        return const _StatusPalette(
          background: AppColors.surface2,
          foreground: AppColors.text2,
          border: AppColors.borderSolid,
        );
    }
  }

  _StatusMetrics get _metrics {
    switch (size) {
      case VitStatusPillSize.sm:
        return const _StatusMetrics(
          height: AppSpacing.statusPillHeightSm,
          labelStyle: AppTextStyles.numericMicro,
          iconSize: AppSpacing.statusPillIconSizeSm,
          paddingX: AppSpacing.statusPillHorizontalPaddingSm,
          gap: AppSpacing.statusPillGapSm,
        );
      case VitStatusPillSize.md:
        return const _StatusMetrics(
          height: AppSpacing.statusPillHeightMd,
          labelStyle: AppTextStyles.navLabel,
          iconSize: AppSpacing.statusPillIconSizeMd,
          paddingX: AppSpacing.statusPillHorizontalPaddingMd,
          gap: AppSpacing.statusPillGapMd,
        );
      case VitStatusPillSize.lg:
        return const _StatusMetrics(
          height: AppSpacing.statusPillHeightLg,
          labelStyle: AppTextStyles.navLabel,
          iconSize: AppSpacing.statusPillIconSizeLg,
          paddingX: AppSpacing.statusPillHorizontalPaddingLg,
          gap: AppSpacing.statusPillGapLg,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;
    final metrics = _metrics;
    final hasCount = count != null && count! > 0;

    Widget content = Container(
      height: metrics.height,
      padding: EdgeInsets.symmetric(horizontal: metrics.paddingX),
      decoration: BoxDecoration(
        color: outline ? AppColors.transparent : palette.background,
        border: Border.all(color: palette.border),
        borderRadius: AppRadii.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulse) ...[
            Container(
              width: metrics.iconSize * 0.6,
              height: metrics.iconSize * 0.6,
              decoration: BoxDecoration(
                color: palette.foreground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: palette.border,
                    blurRadius: AppSpacing.statusPillBadgeBlur,
                  ),
                ],
              ),
            ),
            SizedBox(width: metrics.gap),
          ] else if (icon != null) ...[
            Icon(icon, color: palette.foreground, size: metrics.iconSize),
            SizedBox(width: metrics.gap),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: metrics.labelStyle.copyWith(
                color: palette.foreground,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          if (hasCount) ...[
            SizedBox(width: metrics.gap),
            Container(
              constraints: BoxConstraints(
                minWidth:
                    metrics.height * AppSpacing.statusPillCountMinWidthFactor,
              ),
              height: metrics.height * AppSpacing.statusPillCountHeightFactor,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.statusPillCountPadding,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.foreground,
                borderRadius: AppRadii.pillRadius,
              ),
              child: Text(
                count! > 99 ? '99+' : '${count!}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontSize: AppTextStyles.navLabel.fontSize,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.pillRadius,
          child: content,
        ),
      );
    }

    return Semantics(button: onTap != null, child: content);
  }
}

class _StatusPalette {
  const _StatusPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

class _StatusMetrics {
  const _StatusMetrics({
    required this.height,
    required this.labelStyle,
    required this.iconSize,
    required this.paddingX,
    required this.gap,
  });

  final double height;
  final TextStyle labelStyle;
  final double iconSize;
  final double paddingX;
  final double gap;
}
