import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class CrossModuleSpacingTokens {
  const CrossModuleSpacingTokens._();

  static EdgeInsets crossModuleScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets crossModuleTabBarPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const EdgeInsets crossModuleTabLabelPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets crossModuleCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets crossModulePanelPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets crossModulePillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets crossModuleSelectorPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets crossModulePresetButtonPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets crossModuleFormatButtonPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets crossModuleTrailingRowPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets crossModuleTogglePadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets crossModuleTextButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x2,
  );
  static const double crossModuleLineHeightBody = 1.45;
}
