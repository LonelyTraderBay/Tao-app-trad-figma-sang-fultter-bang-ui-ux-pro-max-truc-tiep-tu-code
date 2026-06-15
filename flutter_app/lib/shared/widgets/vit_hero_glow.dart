import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

class VitHeroGlow extends StatelessWidget {
  const VitHeroGlow({
    super.key,
    this.center = const Alignment(0.92, -0.96),
    this.radius = 1.28,
    this.colors,
    this.stops = const [0, 0.5, 1],
  });

  final AlignmentGeometry center;
  final double radius;
  final List<Color>? colors;
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: center,
          radius: radius,
          colors:
              colors ??
              [
                AppColors.primary08,
                AppColors.primary08.withValues(alpha: 0.03),
                AppColors.transparent,
              ],
          stops: stops,
        ),
      ),
    );
  }
}
