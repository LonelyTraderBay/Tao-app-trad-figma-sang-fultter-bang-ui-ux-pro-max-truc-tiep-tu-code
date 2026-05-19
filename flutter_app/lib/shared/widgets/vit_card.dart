import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';

enum VitCardVariant { standard, hero, inner, ghost }

enum VitCardRadius { sm, md, lg }

class VitCard extends StatelessWidget {
  const VitCard({
    super.key,
    required this.child,
    this.variant = VitCardVariant.standard,
    this.radius = VitCardRadius.md,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.borderColor,
    this.clip = false,
    this.onTap,
  });

  final Widget child;
  final VitCardVariant variant;
  final VitCardRadius radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Color? borderColor;
  final bool clip;
  final VoidCallback? onTap;

  BorderRadius get _borderRadius {
    switch (radius) {
      case VitCardRadius.sm:
        return AppRadii.mdRadius;
      case VitCardRadius.md:
        return AppRadii.cardRadius;
      case VitCardRadius.lg:
        return AppRadii.cardLargeRadius;
    }
  }

  BoxDecoration get _decoration {
    final resolvedBorder = borderColor;
    switch (variant) {
      case VitCardVariant.hero:
        return BoxDecoration(
          gradient: AppGradients.portfolio,
          border: Border.all(
            color: resolvedBorder ?? AppColors.portfolioBorder,
          ),
          borderRadius: _borderRadius,
          boxShadow: const [
            BoxShadow(
              color: AppColors.primary08,
              blurRadius: 12,
              spreadRadius: -4,
              offset: Offset(0, 4),
            ),
          ],
        );
      case VitCardVariant.inner:
        return BoxDecoration(
          color: AppColors.surface2,
          border: resolvedBorder == null
              ? null
              : Border.all(color: resolvedBorder),
          borderRadius: _borderRadius,
        );
      case VitCardVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          border: resolvedBorder == null
              ? null
              : Border.all(color: resolvedBorder),
          borderRadius: _borderRadius,
        );
      case VitCardVariant.standard:
        return BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: resolvedBorder ?? AppColors.cardBorder),
          borderRadius: _borderRadius,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    final decorated = Container(
      width: width,
      height: height,
      constraints: constraints,
      alignment: alignment,
      margin: margin,
      decoration: _decoration,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
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

    return decorated;
  }
}

class VitCardStat extends StatelessWidget {
  const VitCardStat({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.x3),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
