import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';

enum VitCtaButtonVariant {
  primary,
  secondary,
  success,
  danger,
  destructive,
  warning,
  ghost,
  auth,
}

class VitCtaButton extends StatelessWidget {
  const VitCtaButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = VitCtaButtonVariant.primary,
    this.loading = false,
    this.fullWidth = true,
    this.height = AppSpacing.ctaHeight,
    this.density = VitDensity.standard,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final VitCtaButtonVariant variant;
  final bool loading;
  final bool fullWidth;
  final double height;
  final VitDensity density;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  bool get _enabled => onPressed != null && !loading;

  _CtaStyle get _style {
    switch (variant) {
      case VitCtaButtonVariant.primary:
        return const _CtaStyle(
          gradient: AppGradients.navCenter,
          foreground: AppColors.onAccent,
          shadow: AppColors.primary30,
        );
      case VitCtaButtonVariant.secondary:
        return const _CtaStyle(
          background: AppColors.portfolioBtnGhost,
          foreground: AppColors.portfolioBtnGhostText,
          border: AppColors.portfolioBtnGhostBorder,
        );
      case VitCtaButtonVariant.success:
        return const _CtaStyle(
          background: AppColors.buy,
          foreground: AppColors.onAccent,
          shadow: AppColors.buy20,
        );
      case VitCtaButtonVariant.danger:
      case VitCtaButtonVariant.destructive:
        return const _CtaStyle(
          background: AppColors.sell,
          foreground: AppColors.onAccent,
          shadow: AppColors.sell20,
        );
      case VitCtaButtonVariant.warning:
        return const _CtaStyle(
          background: AppColors.warn,
          foreground: AppColors.onAccent,
          shadow: AppColors.warn15,
        );
      case VitCtaButtonVariant.ghost:
        return const _CtaStyle(
          background: AppColors.transparent,
          foreground: AppColors.text1,
          border: AppColors.borderSolid,
        );
      case VitCtaButtonVariant.auth:
        return const _CtaStyle(
          gradient: AppGradients.navCenter,
          foreground: AppColors.onAccent,
          shadow: AppColors.primary30,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _enabled
        ? _style
        : const _CtaStyle(
            background: AppColors.surface2,
            foreground: AppColors.text3,
          );
    final resolvedHeight = height == AppSpacing.ctaHeight
        ? density.controlHeight
        : height;

    final button = SizedBox(
      width: fullWidth ? double.infinity : null,
      height: resolvedHeight,
      child: Material(
        color: AppColors.transparent,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: style.background,
            gradient: style.gradient,
            borderRadius: AppRadii.inputRadius,
            border: style.border == null
                ? null
                : Border.all(color: style.border!),
            boxShadow: style.shadow == null
                ? null
                : [
                    BoxShadow(
                      color: style.shadow!,
                      blurRadius: AppSpacing.ctaElevationBlur,
                      offset: const Offset(0, AppSpacing.ctaElevationYOffset),
                    ),
                  ],
          ),
          child: InkWell(
            onTap: _enabled ? onPressed : null,
            borderRadius: AppRadii.inputRadius,
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (loading) ...[
                    SizedBox(
                      width: AppSpacing.ctaLoadingIcon,
                      height: AppSpacing.ctaLoadingIcon,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSpacing.ctaStrokeWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          style.foreground,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                  ] else if (leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: style.foreground,
                        size: AppSpacing.iconMd,
                      ),
                      child: leading!,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                  ],
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: DefaultTextStyle.merge(
                        style: AppTextStyles.control.copyWith(
                          color: style.foreground,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSpacing.x3),
                    IconTheme(
                      data: IconThemeData(
                        color: style.foreground,
                        size: AppSpacing.iconMd,
                      ),
                      child: trailing!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _enabled || loading ? 1 : 0.55,
        child: button,
      ),
    );
  }
}

class _CtaStyle {
  const _CtaStyle({
    this.background,
    this.gradient,
    required this.foreground,
    this.border,
    this.shadow,
  });

  final Color? background;
  final Gradient? gradient;
  final Color foreground;
  final Color? border;
  final Color? shadow;
}
