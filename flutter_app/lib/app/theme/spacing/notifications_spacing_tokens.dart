import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class NotificationsSpacingTokens {
  const NotificationsSpacingTokens._();

  static EdgeInsets notificationsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets notificationsToolbarPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x3,
    AppSpacing.contentPad,
    AppSpacing.x3,
  );
  static const EdgeInsets notificationsRowPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x2,
    AppSpacing.contentPad,
    AppSpacing.x2,
  );
  static const double notificationsUnreadDotSize = AppSpacing.x3;
  static const EdgeInsets notificationsUnreadDotMargin = EdgeInsets.only(
    left: AppSpacing.x2,
  );
  static const double notificationsMessageLineHeight = 1.25;
  static const double notificationsPillLineHeight = 1.1;
  static const double notificationsTypeIconBox = 38;
  static const EdgeInsets notificationsTypeIconMargin = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const double notificationsTypeIcon = 19;
  static const EdgeInsets notificationsFooterPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const double notificationsFooterDividerWidth = 36;
  static const double notificationsFooterDividerHeight =
      AppSpacing.dividerHairline;
}
