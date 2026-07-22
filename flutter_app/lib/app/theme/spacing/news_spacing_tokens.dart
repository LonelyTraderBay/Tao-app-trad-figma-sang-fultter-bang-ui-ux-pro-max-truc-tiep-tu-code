import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class NewsSpacingTokens {
  const NewsSpacingTokens._();

  static const double newsFeedGap = 12;
  static const double newsSectionBreak = 18;
  static const double newsFilterBarHeight = 60;
  static const double newsFilterChipHeight = 32;
  static const double newsArticleAvatarSize = 40;
  static const double newsSheetMaxWidth = 440;
  static const double newsSheetMaxHeightFactor = .85;
  static const double newsSheetHandleWidth = 48;
  static const double newsSheetHandleHeight = 4;
  static const double newsEmptyIconSize = 48;
  static const double newsChevronIconSize = 22;
  static const double newsCalendarIconSize = 10;
  static const double newsSheetCalendarIconSize = AppSpacing.x4;
  static const double newsSectionIconSize = 15;
  static const double newsTagIconSize = 11;
  static const double newsLineHeightTight = 1;
  static const double newsTitleLineHeight = 1.25;
  static const double newsSummaryLineHeight = 1.34;
  static const double newsSheetTitleLineHeight = 1.3;
  static const double newsSheetSummaryLineHeight = 1.45;
  static const double newsSheetBodyLineHeight = 1.7;
  static EdgeInsets newsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets newsFilterBarPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    newsFeedGap,
    AppSpacing.contentPad,
    newsFeedGap,
  );
  static const EdgeInsets newsFilterChipPadding = EdgeInsets.symmetric(
    horizontal: newsFeedGap,
  );
  static const EdgeInsets newsCardPadding = EdgeInsets.all(
    AppSpacing.sectionGapCompact,
  );
  static const EdgeInsets newsBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets newsTagPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1 + 1,
  );
  static const EdgeInsets newsEmptyPadding = EdgeInsets.symmetric(vertical: 80);
  static const EdgeInsets newsChevronPadding = EdgeInsets.only(
    top: AppSpacing.x2 + 1,
  );
  static const EdgeInsets newsSheetHandleMargin = EdgeInsets.symmetric(
    vertical: AppSpacing.x4 + 1,
  );
  static const EdgeInsets newsSheetPadding = EdgeInsets.fromLTRB(
    AppSpacing.x5 + AppSpacing.x1,
    AppSpacing.zero,
    AppSpacing.x5 + AppSpacing.x1,
    AppSpacing.x5 + AppSpacing.x1,
  );
  static const EdgeInsets newsSheetBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3 + 2,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets newsSheetSummaryPadding = EdgeInsets.all(
    AppSpacing.x4 + 1,
  );
}
