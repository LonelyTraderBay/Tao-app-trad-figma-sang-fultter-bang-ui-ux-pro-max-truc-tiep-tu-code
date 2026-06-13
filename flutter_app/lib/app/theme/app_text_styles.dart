import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

final class AppTextStyles {
  const AppTextStyles._();

  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight heavy = FontWeight.w900;

  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  static const TextStyle microTiny = TextStyle(
    color: AppColors.text2,
    fontSize: 7,
    fontWeight: normal,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle micro = TextStyle(
    color: AppColors.text2,
    fontSize: 10,
    fontWeight: normal,
    height: 1.5,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle caption = TextStyle(
    color: AppColors.text2,
    fontSize: 13,
    fontWeight: normal,
    height: 1.5,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle captionSm = TextStyle(
    color: AppColors.text2,
    fontSize: 12,
    fontWeight: normal,
    height: 1.5,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.text1,
    fontSize: 14,
    fontWeight: normal,
    height: 1.5,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle base = TextStyle(
    color: AppColors.text1,
    fontSize: 16,
    fontWeight: normal,
    height: 1.5,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle baseMedium = TextStyle(
    color: AppColors.text1,
    fontSize: 16,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.text1,
    fontSize: 21,
    fontWeight: bold,
    height: 1.272,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle sectionTitleXs = TextStyle(
    color: AppColors.text1,
    fontSize: 18,
    fontWeight: bold,
    height: 1.272,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle sectionTitleSm = TextStyle(
    color: AppColors.text1,
    fontSize: 19,
    fontWeight: bold,
    height: 1.272,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle sectionTitleMd = TextStyle(
    color: AppColors.text1,
    fontSize: 24,
    fontWeight: bold,
    height: 1.272,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle pageTitle = TextStyle(
    color: AppColors.text1,
    fontSize: 26,
    fontWeight: bold,
    height: 1.272,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle heroNumber = TextStyle(
    color: AppColors.text1,
    fontSize: 34,
    fontWeight: bold,
    height: 1.272,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle monoCode = TextStyle(
    color: AppColors.text1,
    fontSize: 13,
    fontWeight: normal,
    height: 1.42,
    letterSpacing: 0,
    fontFamily: 'monospace',
    decoration: TextDecoration.none,
  );

  static const TextStyle numericCode = TextStyle(
    color: AppColors.text1,
    fontSize: 13,
    fontWeight: medium,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle display = TextStyle(
    color: AppColors.text1,
    fontSize: 43,
    fontWeight: bold,
    height: 1.618,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle jumbo = TextStyle(
    color: AppColors.text1,
    fontSize: 55,
    fontWeight: bold,
    height: 1.618,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle badge = TextStyle(
    color: AppColors.text2,
    fontSize: 11,
    fontWeight: bold,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle control = TextStyle(
    color: AppColors.text1,
    fontSize: 14,
    fontWeight: medium,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle amountXs = TextStyle(
    color: AppColors.text1,
    fontSize: 22,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle amountBase = TextStyle(
    color: AppColors.text1,
    fontSize: 20,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle amountSm = TextStyle(
    color: AppColors.text1,
    fontSize: 18,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle amountMd = TextStyle(
    color: AppColors.text1,
    fontSize: 28,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle amountLg = TextStyle(
    color: AppColors.text1,
    fontSize: 34,
    fontWeight: bold,
    height: 1.06,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericMicro = TextStyle(
    color: AppColors.text2,
    fontSize: 10,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle chartLabelNano = TextStyle(
    color: AppColors.text2,
    fontSize: 7,
    fontWeight: normal,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle chartLabelTiny = TextStyle(
    color: AppColors.text2,
    fontSize: 8,
    fontWeight: normal,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle chartLabelXs = TextStyle(
    color: AppColors.text2,
    fontSize: 9,
    fontWeight: normal,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplaySm = TextStyle(
    color: AppColors.text1,
    fontSize: 24,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplayMd = TextStyle(
    color: AppColors.text1,
    fontSize: 26,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplayLg = TextStyle(
    color: AppColors.text1,
    fontSize: 27,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplayXl = TextStyle(
    color: AppColors.text1,
    fontSize: 30,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplay2xl = TextStyle(
    color: AppColors.text1,
    fontSize: 31,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplay3xl = TextStyle(
    color: AppColors.text1,
    fontSize: 32,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplay4xl = TextStyle(
    color: AppColors.text1,
    fontSize: 36,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplayHeroXs = TextStyle(
    color: AppColors.text1,
    fontSize: 29,
    fontWeight: bold,
    height: 1.06,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplayHeroSm = TextStyle(
    color: AppColors.text1,
    fontSize: 33,
    fontWeight: bold,
    height: 1.06,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle numericDisplayHero = TextStyle(
    color: AppColors.text1,
    fontSize: 42,
    fontWeight: bold,
    height: 1.06,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    fontFeatures: tabularFigures,
  );

  static const TextStyle avatarSm = TextStyle(
    color: AppColors.text1,
    fontSize: 15,
    fontWeight: normal,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle avatarMd = TextStyle(
    color: AppColors.text1,
    fontSize: 17,
    fontWeight: normal,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle avatarLg = TextStyle(
    color: AppColors.text1,
    fontSize: 22,
    fontWeight: normal,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );

  static const TextStyle navLabel = TextStyle(
    color: AppColors.text2,
    fontSize: 11,
    fontWeight: medium,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );
}
