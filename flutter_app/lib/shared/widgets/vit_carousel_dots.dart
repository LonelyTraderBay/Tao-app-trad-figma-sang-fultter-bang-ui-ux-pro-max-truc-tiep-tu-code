import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

class VitCarouselDots extends StatelessWidget {
  const VitCarouselDots({
    super.key,
    required this.itemCount,
    required this.activeIndex,
    this.activeColor = AppColors.primary,
    this.inactiveColor,
    this.duration = const Duration(milliseconds: 180),
  }) : assert(itemCount >= 0),
       assert(activeIndex >= 0),
       assert(itemCount == 0 || activeIndex < itemCount);

  final int itemCount;
  final int activeIndex;
  final Color activeColor;
  final Color? inactiveColor;
  final Duration duration;

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
            AnimatedContainer(
              key: ValueKey('vit_carousel_dot_$index'),
              duration: duration,
              width: index == activeIndex
                  ? AppSpacing.homeAnnouncementDotActiveWidth
                  : AppSpacing.homeAnnouncementDotInactiveWidth,
              height: AppSpacing.homeAnnouncementDotHeight,
              decoration: BoxDecoration(
                color: index == activeIndex
                    ? activeColor
                    : resolvedInactiveColor,
                borderRadius: AppRadii.pillRadius,
              ),
            ),
            if (index < itemCount - 1)
              const SizedBox(width: AppSpacing.homeAnnouncementDotGap),
          ],
        ],
      ),
    );
  }
}
