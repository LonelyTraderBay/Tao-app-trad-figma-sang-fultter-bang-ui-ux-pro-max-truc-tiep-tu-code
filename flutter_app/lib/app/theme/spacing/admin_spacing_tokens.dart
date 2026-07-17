import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

final class AdminSpacingTokens {
  const AdminSpacingTokens._();

  static const double adminLineHeightTight =
      LaunchpadSpacingTokens.launchpadLineHeightTight;
  static const double adminLineHeightShort =
      LaunchpadSpacingTokens.launchpadLineHeightShort;
  static const double adminLineHeightCompact = 1.3;
  static const double adminLineHeightDense =
      LaunchpadSpacingTokens.launchpadLineHeightDense;
  static const double adminDividerHeight =
      LaunchpadSpacingTokens.launchpadDividerHeight;
  static const double adminDividerThickness =
      LaunchpadSpacingTokens.launchpadDividerHeight;
  static const double adminProgressHeight =
      EarnSpacingTokens.savingsGoalMilestoneFontSize;
  static const double adminFontXs = LaunchpadSpacingTokens.launchpadFontXs;
  static const double adminFontSm = LaunchpadSpacingTokens.launchpadFontSm;
  static const double adminFontMd = LaunchpadSpacingTokens.launchpadFontMd;
  static const double adminFontLg = EarnSpacingTokens.stakingTaxDetailFontSize;
  static const double adminFontXl = LaunchpadSpacingTokens.launchpadIconLg;
  static const double adminFont2xl = DcaSpacingTokens.dcaOverviewInlineIcon;
  static const double adminFont3xl = LaunchpadSpacingTokens.launchpadIcon3xl;
  static const double adminIconXs = LaunchpadSpacingTokens.launchpadIconXs;
  static const double adminIconSm = LaunchpadSpacingTokens.launchpadIconMd;
  static const double adminIconMd = LaunchpadSpacingTokens.launchpadIconXl;
  static const double adminIconLg = DcaSpacingTokens.dcaOverviewInlineIcon;
  static const double adminIconXl = LaunchpadSpacingTokens.launchpadIcon3xl;
  static const double adminIcon2xl = LaunchpadSpacingTokens.launchpadBox24;
  static const double adminIconHero = LaunchpadSpacingTokens.launchpadBox48;
  static const double adminBox24 = LaunchpadSpacingTokens.launchpadBox24;
  static const double adminBox32 = LaunchpadSpacingTokens.launchpadBox32;
  static const double adminBox40 = LaunchpadSpacingTokens.launchpadBox40;
  static const double adminBox48 = LaunchpadSpacingTokens.launchpadBox48;
  static const double adminAnalyticsChartHeight = 260;
  static const double adminAnalyticsSparklineHeight = 180;
  static const double adminFunnelWaterfallHeight = 200;
  static const int adminGridColumns = 2;
  // A11Y-3: was 82 — raised so a 2-line funnel name + step-count label fit
  // at the app-wide 1.3x text-scaling clamp without overflowing this
  // GridView cell's fixed mainAxisExtent.
  static const double adminMetricTileExtent = 90;
  static const double adminPainterLabelMaxWidth = 42;
  static const double adminPainterWideLabelMaxWidth = 70;
  static const double adminStateRadius =
      EarnSpacingTokens.stakingTaxDetailFontSize;
  static EdgeInsets adminScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets adminCompactPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets adminCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets adminEmptyPadding = EdgeInsets.all(AppSpacing.x6);
  static const EdgeInsets adminRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets adminStatusPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets adminChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets adminHorizontalCardPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets adminSegmentButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets adminFinePadding = EdgeInsets.all(AppSpacing.x1);

  static const double devLineHeightTight = adminLineHeightTight;
  static const double devDividerHeight = adminDividerHeight;
  static const double devDividerThickness = adminDividerThickness;
  static const double devFontXs = adminFontXs;
  static const double devFontLg = adminFontLg;
  static const double devFont2xl = adminFont2xl;
  static const double devFontHero =
      AppSpacing.statusPillHeightSm + LaunchpadSpacingTokens.launchpadGapXxs;
  static const int devRouteGridColumns = 4;
  static const double devRouteGridAspect = 1.18;
  static EdgeInsets devScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets devHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x4,
    AppSpacing.contentPad,
    AppSpacing.x3,
  );
  static const EdgeInsets devCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets devCardPaddingLarge = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets devCompactPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets devTinyPadding = EdgeInsets.all(AppSpacing.x2);
  static const EdgeInsets devTokenCardPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets devInlinePillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets devChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets devCompactChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets devWideChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets devInputPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets devVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets devVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets devVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets devVerticalPaddingX5 = EdgeInsets.symmetric(
    vertical: AppSpacing.x5,
  );
  static const EdgeInsets devBottomPaddingX3 = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
}
