import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

class VitCarouselDots extends StatelessWidget {
  const VitCarouselDots({
    super.key,
    required this.itemCount,
    required this.activeIndex,
    this.activeColor = AppColors.primary,
    this.inactiveColor,
    this.duration = const Duration(milliseconds: 180),
    this.onDotTap,
    this.dotKeyBuilder,
  }) : assert(itemCount >= 0),
       assert(activeIndex >= 0),
       assert(itemCount == 0 || activeIndex < itemCount);

  final int itemCount;
  final int activeIndex;
  final Color activeColor;
  final Color? inactiveColor;
  final Duration duration;
  final ValueChanged<int>? onDotTap;
  final Key Function(int index)? dotKeyBuilder;

  @override
  Widget build(BuildContext context) {
    final resolvedInactiveColor =
        inactiveColor ?? AppColors.text3.withValues(alpha: 0.35);

    return Semantics(
      label: itemCount == 0
          ? 'Carousel has no pages'
          : 'Carousel page ${activeIndex + 1} of $itemCount',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < itemCount; index++) ...[
            _CarouselDot(
              key:
                  dotKeyBuilder?.call(index) ??
                  ValueKey('vit_carousel_dot_$index'),
              active: index == activeIndex,
              activeColor: activeColor,
              inactiveColor: resolvedInactiveColor,
              duration: duration,
              onTap: onDotTap == null ? null : () => onDotTap!(index),
              semanticLabel: 'Go to carousel page ${index + 1}',
            ),
            if (index < itemCount - 1)
              const SizedBox(
                width: SharedSpacingTokens.homeAnnouncementDotGap,
              ),
          ],
        ],
      ),
    );
  }
}

class _CarouselDot extends StatelessWidget {
  const _CarouselDot({
    super.key,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.duration,
    required this.semanticLabel,
    this.onTap,
  });

  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final targetColor = active ? activeColor : inactiveColor;
    final targetWidth = active
        ? SharedSpacingTokens.homeAnnouncementDotActiveWidth
        : SharedSpacingTokens.homeAnnouncementDotInactiveWidth;
    final dot = TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(end: targetWidth),
      builder: (context, width, child) {
        return TweenAnimationBuilder<Color?>(
          duration: duration,
          tween: ColorTween(end: targetColor),
          builder: (context, color, child) {
            return SizedBox(
              width: width,
              height: SharedSpacingTokens.homeAnnouncementDotHeight,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color ?? targetColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.pillRadius,
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (onTap == null) return dot;

    return Semantics(
      button: true,
      selected: active,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pillRadius,
        child: dot,
      ),
    );
  }
}
