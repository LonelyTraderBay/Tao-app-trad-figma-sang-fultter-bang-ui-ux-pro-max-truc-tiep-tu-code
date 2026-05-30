import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

enum VitIconButtonVariant {
  defaultAction,
  ghost,
  primary,
  success,
  danger,
  transparent,
}

enum VitIconButtonSize { sm, md, lg }

class VitIconButton extends StatelessWidget {
  const VitIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.label,
    this.variant = VitIconButtonVariant.ghost,
    this.size = VitIconButtonSize.lg,
    this.loading = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final String? label;
  final VitIconButtonVariant variant;
  final VitIconButtonSize size;
  final bool loading;

  bool get _enabled => onPressed != null && !loading;

  _IconButtonMetrics get _metrics {
    switch (size) {
      case VitIconButtonSize.sm:
        return const _IconButtonMetrics(
          height: 28,
          iconSize: 14,
          fontSize: 11,
          gap: 4,
          paddingX: 8,
        );
      case VitIconButtonSize.md:
        return const _IconButtonMetrics(
          height: 40,
          iconSize: 21,
          fontSize: 13,
          gap: 6,
          paddingX: 12,
        );
      case VitIconButtonSize.lg:
        return const _IconButtonMetrics(
          height: 44,
          iconSize: 20,
          fontSize: 14,
          gap: 8,
          paddingX: 16,
        );
    }
  }

  _IconButtonStyle get _style {
    switch (variant) {
      case VitIconButtonVariant.defaultAction:
        return const _IconButtonStyle(
          background: AppColors.transparent,
          foreground: AppColors.text1,
        );
      case VitIconButtonVariant.ghost:
        return const _IconButtonStyle(
          background: AppColors.searchBg,
          foreground: AppColors.text2,
          border: AppColors.cardBorder,
        );
      case VitIconButtonVariant.primary:
        return const _IconButtonStyle(
          background: AppColors.primary12,
          foreground: AppColors.primary,
          border: AppColors.primary20,
        );
      case VitIconButtonVariant.success:
        return const _IconButtonStyle(
          background: AppColors.buy15,
          foreground: AppColors.buy,
          border: AppColors.buy20,
        );
      case VitIconButtonVariant.danger:
        return const _IconButtonStyle(
          background: AppColors.sell15,
          foreground: AppColors.sell,
          border: AppColors.sell20,
        );
      case VitIconButtonVariant.transparent:
        return const _IconButtonStyle(
          background: AppColors.transparent,
          foreground: AppColors.text2,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;
    final style = _enabled
        ? _style
        : const _IconButtonStyle(
            background: AppColors.surface2,
            foreground: AppColors.text3,
            border: AppColors.cardBorder,
          );
    final hasLabel = label != null && label!.isNotEmpty;
    final radius = BorderRadius.circular(size == VitIconButtonSize.sm ? 8 : 10);

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: metrics.iconSize,
            height: metrics.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(style.foreground),
            ),
          )
        else
          Icon(icon, color: style.foreground, size: metrics.iconSize),
        if (hasLabel) ...[
          SizedBox(width: metrics.gap),
          Text(
            label!,
            style: AppTextStyles.caption.copyWith(
              color: style.foreground,
              fontSize: metrics.fontSize,
              fontWeight: AppTextStyles.medium,
              height: 1,
            ),
          ),
        ],
      ],
    );

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        enabled: _enabled,
        child: SizedBox(
          width: hasLabel ? null : metrics.height,
          height: metrics.height,
          child: Material(
            color: AppColors.transparent,
            borderRadius: radius,
            child: Ink(
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: radius,
                border: style.border == null
                    ? null
                    : Border.all(color: style.border!),
              ),
              child: InkWell(
                onTap: _enabled ? onPressed : null,
                borderRadius: radius,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hasLabel ? metrics.paddingX : 0,
                  ),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButtonMetrics {
  const _IconButtonMetrics({
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.gap,
    required this.paddingX,
  });

  final double height;
  final double iconSize;
  final double fontSize;
  final double gap;
  final double paddingX;
}

class _IconButtonStyle {
  const _IconButtonStyle({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}
