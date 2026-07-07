import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class SupportSpacingTokens {
  const SupportSpacingTokens._();

  static EdgeInsets supportScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets supportContentPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const EdgeInsets supportSectionMargin = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const EdgeInsets supportQuickLinksPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x4,
    AppSpacing.contentPad,
    AppSpacing.x4,
  );
  static const EdgeInsets supportCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets supportQuickCardPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets supportFilterRailPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x5,
    AppSpacing.contentPad,
    AppSpacing.x1,
  );
  static const EdgeInsets supportFilterChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const double supportTinyGap = 2;
  static const double supportLineHeightFilter = 1.1;
  static const double supportLineHeightTight = 1.25;
  static const double supportLineHeightReadable = 1.35;
  static const double supportLineHeightBody = 1.45;
  static const double supportLineHeightExpanded = 1.55;
  static const double supportContextIconBox = 34;
  static const double supportContextIcon = 19;
  static const double supportTimelineRailWidth = 24;
  static const double supportTimelineDotSize = 18;
  static const double supportTimelineLineWidth = AppSpacing.dividerHairline;
  static EdgeInsets supportTimelineLabelPadding(bool isLast) =>
      EdgeInsets.only(bottom: isLast ? AppSpacing.zero : AppSpacing.x3);
  static const double supportFaqToggleIconBox = 24;
  static const int supportCategoryGridColumns = 2;
  static const double supportCategoryGridAspectRatio = 1.9;
  static const double supportCategoryIcon = 24;
  static const double supportArticleIcon = 21;
  static const double supportFilterChipHeight = 34;
  static const double supportAnnouncementIconBox = 42;
  static const double supportAnnouncementIcon = 20;
}
