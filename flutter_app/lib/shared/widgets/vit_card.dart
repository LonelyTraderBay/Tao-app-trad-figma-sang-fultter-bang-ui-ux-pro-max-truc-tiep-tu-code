import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

enum VitCardVariant { standard, hero, inner, ghost }

enum VitCardRadius {
  /// 16px — standard card surface.
  standard,

  /// 24px — hero/large card surface.
  large,
}

class VitCard extends StatelessWidget {
  const VitCard({
    super.key,
    required this.child,
    this.variant = VitCardVariant.standard,
    this.radius = VitCardRadius.standard,
    this.padding,
    this.density,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.borderColor,
    this.background,
    this.clip = false,
    this.onTap,
  });

  final Widget child;
  final VitCardVariant variant;
  final VitCardRadius radius;
  final EdgeInsetsGeometry? padding;
  final VitDensity? density;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Color? borderColor;
  final Widget? background;
  final bool clip;
  final VoidCallback? onTap;

  BorderRadius get _borderRadius {
    switch (radius) {
      case VitCardRadius.standard:
        return AppRadii.cardRadius;
      case VitCardRadius.large:
        return AppRadii.cardLargeRadius;
    }
  }

  ShapeDecoration get _decoration {
    final resolvedBorder = borderColor;
    switch (variant) {
      case VitCardVariant.hero:
        return ShapeDecoration(
          gradient: AppGradients.portfolio,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
            side: BorderSide(
              color: resolvedBorder ?? AppColors.portfolioBorder,
            ),
          ),
          shadows: const [
            BoxShadow(
              color: AppColors.primary08,
              blurRadius: AppSpacing.ctaElevationBlur,
              spreadRadius: AppSpacing.ctaElevationSpread,
              offset: Offset(0, AppSpacing.ctaElevationYOffset),
            ),
          ],
        );
      case VitCardVariant.inner:
      case VitCardVariant.ghost:
        return ShapeDecoration(
          color: variant == VitCardVariant.inner
              ? AppColors.surface2
              : AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
            side: resolvedBorder == null
                ? BorderSide.none
                : BorderSide(color: resolvedBorder),
          ),
        );
      case VitCardVariant.standard:
        return ShapeDecoration(
          color: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
            side: BorderSide(color: resolvedBorder ?? AppColors.cardBorder),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    final resolvedPadding = padding ?? density?.cardPadding;
    if (resolvedPadding != null) {
      content = Padding(padding: resolvedPadding, child: content);
    }
    if (background != null) {
      content = Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(child: background!),
          content,
        ],
      );
    }

    Widget decorated = DecoratedBox(
      decoration: _decoration,
      child: Material(
        type: MaterialType.transparency,
        child: onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                borderRadius: _borderRadius,
                child: content,
              ),
      ),
    );

    if (clip) {
      decorated = ClipRRect(
        borderRadius: _borderRadius,
        clipBehavior: Clip.antiAlias,
        child: decorated,
      );
    }
    if (alignment != null) {
      decorated = Align(alignment: alignment!, child: decorated);
    }
    if (constraints != null) {
      decorated = ConstrainedBox(constraints: constraints!, child: decorated);
    }
    if (width != null || height != null) {
      decorated = SizedBox(width: width, height: height, child: decorated);
    }
    if (margin != null) {
      decorated = Padding(padding: margin!, child: decorated);
    }

    return decorated;
  }
}

class VitCardStat extends StatelessWidget {
  const VitCardStat({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.x3),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
