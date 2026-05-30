import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';

final class AppDataVizColors {
  const AppDataVizColors._();

  static const Color axis = AppColors.sectionLabel;
  static const Color grid = AppColors.divider;
  static const Color positive = AppColors.buy;
  static const Color negative = AppColors.sell;
  static const Color neutral = AppAssetColors.neutralChain;
  static const Color warning = AppColors.caution;
  static const Color correlationVeryHigh = Color(0xFFDC2626);
  static const Color correlationHigh = AppColors.sell;
  static const Color correlationMedium = AppColors.warn;
  static const Color correlationLow = AppColors.buy;
  static const Color correlationVeryLow = AppAssetColors.cyanChain;

  static const List<Color> correlationScale = [
    correlationVeryLow,
    correlationLow,
    correlationMedium,
    correlationHigh,
    correlationVeryHigh,
  ];

  static const Color heatmapStrongNegative = Color(0xBFDC4444);
  static const Color heatmapMediumNegative = Color(0x8CEF4444);
  static const Color heatmapSoftNegative = Color(0x59EF4444);
  static const Color heatmapFaintNegative = Color(0x0DEF4444);
  static const Color heatmapNeutralNegative = Color(0x598C2E34);
  static const Color heatmapNeutralPositive = Color(0x59107861);
  static const Color heatmapSoftPositive = Color(0x5910B981);
  static const Color heatmapFaintPositive = Color(0x0D10B981);
  static const Color heatmapMediumPositive = Color(0x8C10B981);
  static const Color heatmapStrongPositive = Color(0xBF10B981);
  static const Color heatmapExtremePositive = Color(0xD9059669);
  static const Color heatmapLegendPositive = Color(0x8C109969);

  static Color correlation(double value) {
    if (value >= .85) return correlationVeryHigh;
    if (value >= .70) return correlationHigh;
    if (value >= .50) return correlationMedium;
    if (value >= .30) return correlationLow;
    if (value >= .0) return correlationVeryLow;
    return AppColors.primary;
  }
}
