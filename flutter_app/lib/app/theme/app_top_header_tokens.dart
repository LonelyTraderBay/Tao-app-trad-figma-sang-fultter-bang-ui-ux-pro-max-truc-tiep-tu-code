import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class AppTopHeaderTokens {
  const AppTopHeaderTokens._();

  static const double detailMinHeight = 52;
  static const double rootMinHeight = 56;
  static const double instrumentMinHeight = 52;

  static const double horizontalPadding = AppSpacing.contentPad;
  static const double rootTopPadding = 8;
  static const double rootBottomPadding = 12;
  static const double detailVerticalPaddingWithSubtitle = 8;

  static const double actionGap = 8;
  static const double titleGap = 2;
  static const double leadingGap = 12;
  static const double instrumentGap = 12;

  static const double buttonSize = 40;
  static const double compactButtonSize = 36;
  static const double buttonIconSize = 20;
  static const double compactButtonIconSize = 18;
  static const double standardEmptyActionWidth = buttonSize;
  static const double standardEmptyBackWidth = compactButtonSize;

  static const double badgeMinSize = 16;
  static const double badgeHeight = 16;
  static const double badgeHorizontalPadding = 4;
  static const double badgeBorderWidth = 1.5;
  static const double badgeOffset = -4;
  static const double badgeRadius = 999;
  static const double titleBadgeGap = 6;
  static const double titleBadgeRadius = 8;
  static const double titleBadgeFontSize = 9;
  static const double actionBadgeFontSize = 10;

  static const Color surfaceColor = AppColors.navBg;
  static const Color elevatedSurfaceColor = AppColors.surface;
  static const Color transparentSurfaceColor = AppColors.transparent;
  static const Color dividerColor = AppColors.border;
}
