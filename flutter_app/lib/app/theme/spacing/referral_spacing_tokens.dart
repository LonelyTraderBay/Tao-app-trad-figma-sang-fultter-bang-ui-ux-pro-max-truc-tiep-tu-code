import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

final class ReferralSpacingTokens {
  const ReferralSpacingTokens._();

  static const double referralChartHeight = 140;
  static const double referralFinePadding =
      LaunchpadSpacingTokens.launchpadBorderWidthFocus;
  static const double referralSortIcon = LaunchpadSpacingTokens.launchpadIconLg;
  static const double referralDividerHeight =
      LaunchpadSpacingTokens.launchpadDividerHeight;
  static const double referralLineHeightTight =
      LaunchpadSpacingTokens.launchpadLineHeightTight;
  static const double referralLineHeightShort =
      LaunchpadSpacingTokens.launchpadLineHeightShort;
  static const double referralBorderWidth = AppSpacing.hairlineStroke;
  static const double referralHeroIcon = LaunchpadSpacingTokens.launchpadBox48;
  static const double referralSplitDividerWidth =
      LaunchpadSpacingTokens.launchpadDividerWidth;
  static const double referralSplitDividerHeight =
      LaunchpadSpacingTokens.launchpadBox32;
  static const double referralCtaHeight = 46;
  static const double referralRankWidth = LaunchpadSpacingTokens.launchpadBox28;
  static const double referralStepBox = LaunchpadSpacingTokens.launchpadBox28;
  static const double referralSectionMarkerWidth =
      LaunchpadSpacingTokens.launchpadSheetHandleHeight;
  static const double referralSectionMarkerHeight =
      LaunchpadSpacingTokens.launchpadBox18;
  static const double referralLeaderboardWidth = 122;
  static const double referralHistoryFilterHeight =
      LaunchpadSpacingTokens.launchpadBox44;
  static const double referralHistoryAvatarBox =
      LaunchpadSpacingTokens.launchpadBox44;
  static const double referralHistoryIconSm =
      LaunchpadSpacingTokens.launchpadIconSm;
  static const double referralHistoryIconMd =
      LaunchpadSpacingTokens.launchpadIconLg;
  static const double referralProgressHeight =
      LaunchpadSpacingTokens.launchpadDotMd;
  static const double referralCampaignIconBox =
      LaunchpadSpacingTokens.launchpadBox34;
  static EdgeInsets referralBottomScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  // Recipe B only: horizontal contentPad here requires VitPageContent fullBleed.
  // Prefer Recipe A (referralBottomScrollPadding + VitPageContent padding).
  static EdgeInsets referralPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets referralSheetPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x5,
    AppSpacing.contentPad,
    AppSpacing.x6,
  );
  static const EdgeInsets referralFriendDetailPadding = EdgeInsets.fromLTRB(
    AppSpacing.x6,
    AppSpacing.x2,
    AppSpacing.x6,
    0,
  );
  static const EdgeInsets referralCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets referralCardPaddingLarge = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets referralInnerPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets referralFineInset = EdgeInsets.all(
    referralFinePadding,
  );
  static const EdgeInsets referralHeroMetricPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets referralCompactPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets referralNoticePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets referralNoticePaddingDense = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets referralTinyPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets referralSortChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets referralTabButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );
  static const EdgeInsets referralFilterChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets referralStepRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets referralLedgerHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x3,
    AppSpacing.x4,
    AppSpacing.x3,
  );
  static const EdgeInsets referralFaqAnswerPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    0,
    AppSpacing.x4,
    AppSpacing.x4,
  );
  static const EdgeInsets referralChartPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x4,
    AppSpacing.x4,
    AppSpacing.x3,
  );
  static const EdgeInsets referralEmptyPadding = EdgeInsets.all(AppSpacing.x6);
  static const EdgeInsets referralSectionMarkerMargin = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets referralLeftDividerPadding = EdgeInsets.only(
    top: AppSpacing.x1,
  );
}
