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

  static const TextStyle navLabel = TextStyle(
    color: AppColors.text2,
    fontSize: 11,
    fontWeight: medium,
    height: 1,
    letterSpacing: 0,
    decoration: TextDecoration.none,
  );
}
