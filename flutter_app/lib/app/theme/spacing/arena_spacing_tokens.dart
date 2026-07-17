import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class ArenaSpacingTokens {
  const ArenaSpacingTokens._();

  static const double arenaHomeBottomInsetVisualExtra = 78;
  static const double arenaHomeBottomInsetNativeExtra = 24;
  static EdgeInsets arenaBottomScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets arenaPaddingX2 = EdgeInsets.all(AppSpacing.x2);
  static const EdgeInsets arenaPaddingX3 = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets arenaPaddingX4 = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets arenaPaddingX5 = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets arenaTopPaddingX1 = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets arenaBottomPaddingX2 = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets arenaBottomPaddingX3 = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets arenaHorizontalPaddingX4 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets arenaVerticalPaddingX1 = EdgeInsets.symmetric(
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets arenaVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaActionSheetPadding = EdgeInsets.fromLTRB(
    AppSpacing.x5,
    AppSpacing.x5,
    AppSpacing.x5,
    AppSpacing.x6,
  );
  static const EdgeInsets arenaPresetSectionTabsPadding = EdgeInsets.fromLTRB(
    AppSpacing.x5,
    AppSpacing.x3,
    AppSpacing.x5,
    AppSpacing.x3,
  );
  static const EdgeInsets arenaPresetSectionChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaPresetChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaPresetPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets arenaPresetDomainExpandedPadding =
      EdgeInsets.fromLTRB(AppSpacing.x4, 0, AppSpacing.x4, AppSpacing.x4);
  static EdgeInsets arenaPresetScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset + AppSpacing.x6);
  static const EdgeInsets arenaBridgePrincipleNumberPadding = EdgeInsets.only(
    top: arenaBridgeTinyGap,
  );
  static const EdgeInsets arenaProductionPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets arenaProductionRegistryRowPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: AppSpacing.x3);
  static const EdgeInsets arenaProductionFlowLineMarginPadding =
      EdgeInsets.symmetric(vertical: arenaProductionFlowLineMargin);
  static EdgeInsets arenaProductionFlowStepPadding(bool last) =>
      EdgeInsets.only(
        bottom: last ? 0 : AppSpacing.x4,
        left: AppSpacing.x1,
        right: AppSpacing.x1,
      );
  static EdgeInsets arenaHomeScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double arenaHomeIntroLineHeight = 1.35;
  static const EdgeInsets arenaHomeQuickChipGapPadding = EdgeInsets.only(
    right: AppSpacing.x2,
  );
  static const double arenaHomeQuickChipHeight = 36;
  static const double arenaHomeQuickChipIcon = 13;
  static const double arenaHomeQuickChipLineHeight = 1.0;
  static const double arenaHomeHeroTitleLineHeight = 1.05;
  static const int arenaHomeTemplateColumns = 2;
  // A11Y-3: was 90 — raised so a 2-line title + description + tags fit at
  // the app-wide 1.3x text-scaling clamp without overflowing this GridView
  // cell's fixed mainAxisExtent.
  static const double arenaHomeTemplateExtent = 98;
  static const double arenaHomeTemplateTitleLineHeight = 1.15;
  static const double arenaHomeTemplateDescriptionLineHeight = 1.3;
  static const double arenaHomeModeCardWidth = 220;
  static const double arenaHomeModeCardMinHeight = 132;
  static const double arenaHomeModeTitleLineHeight = 1.15;
  static const double arenaHomeDividerHeight = AppSpacing.dividerHairline;
  static const double arenaHomeRoomProgressHeight = 6;
  static const double arenaHomeCreatorCardWidth = 140;
  static const double arenaHomeCreatorCardMinHeight = 148;
  static const double arenaHomeCreatorAvatar = 40;
  static const double arenaHomeCreatorIcon = 20;
  static const double arenaHomeBridgeChevron = 18;
  static const double arenaHomeVerifiedLineHeight = 1.3;
  static const double arenaHomeFooterIcon = 16;
  static const double arenaHomeFooterShieldIcon = 17;
  static const double arenaHomeFooterLineHeight = 1.35;
  static const double arenaHomeSearchChevron = 18;
  static const double arenaHomeActionIconBox = 32;
  static const double arenaHomeActionIcon = 17;
  static const double arenaHomeCountBadgeMinWidth = 16;
  static const double arenaHomeCountBadgeHeight = 16;
  static const EdgeInsets arenaHomeCountBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
  );
  static const double arenaHomeCountBadgeLineHeight = 1.0;
  static const double myArenaBottomInsetVisualExtra =
      arenaHomeBottomInsetVisualExtra;
  static const double myArenaBottomInsetNativeExtra =
      arenaHomeBottomInsetNativeExtra;
  static EdgeInsets myArenaScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double myArenaBalanceLineHeight = 1.0;
  static const EdgeInsets myArenaBalanceSuffixPadding = EdgeInsets.only(
    bottom: AppSpacing.hairlineStroke,
  );
  static const double myArenaDividerHeight = AppSpacing.dividerHairline;
  static const double myArenaPointsDeltaDividerHeight = 36;
  static const double myArenaDeltaDot = AppSpacing.x2;
  static const double myArenaStatCardMinHeight = 116;
  static const double myArenaStatIconBox = arenaHomeActionIconBox;
  static const double myArenaStatIcon = arenaHomeActionIcon;
  static const double myArenaQuickLinkHeight = 44;
  static const double myArenaQuickLinkIcon = 14;
  static const double myArenaTabHeight = 36;
  static const double myArenaTabIcon = 14;
  static const double myArenaTextLineHeight = 1.2;
  static const double myArenaDraftIconBox = 36;
  static const double myArenaDraftIcon = 18;
  static const double myArenaSectionChevron = 20;
  static const double myArenaAnalyticsIcon = 18;
  static const double myArenaRewardMetricLineHeight = 1.0;
  static const double myArenaDistributionLabelWidth = 112;
  static const double myArenaDistributionProgressHeight = 10;
  static const double myArenaDistributionValueWidth = 30;
  static const double myArenaSafetyChevron = 20;
  static const double myArenaFooterIcon = arenaHomeFooterIcon;
  static const double myArenaFooterShieldIcon = arenaHomeFooterShieldIcon;
  static const double myArenaFooterLineHeight = arenaHomeFooterLineHeight;
  static const double myArenaEmptyIcon = 26;
  static const double myArenaActionIconBox = 40;
  static const double myArenaActionIcon = 18;
  static const double myArenaStatusPillLineHeight = 1.0;
  static const double myArenaAccentPillHeight = 44;
  static const double myArenaAccentPillIcon = 15;
  static const double myArenaAccentPillLineHeight = 1.0;
  static const double myArenaTextIconButtonIcon = 14;
  static const double arenaChallengeTitleLineHeight = 1.15;
  static const double arenaChallengeBodyLineHeight = 1.45;
  static const double arenaChallengeDividerHeight = AppSpacing.dividerHairline;
  static const double arenaChallengeSmallIcon = 15;
  static const double arenaChallengeMdIcon = 17;
  static const double arenaChallengeLgIcon = 18;
  static const double arenaChallengeCountdownHeight = 40;
  static const double arenaChallengeProgressHeight = AppSpacing.x2;
  static const double arenaChallengeClarityProgressHeight = 7;
  static const double arenaChallengeBridgeProgressHeight = 6;
  static const double arenaChallengeTeamDot = 12;
  static const double arenaChallengeMemberLineHeight = 1.2;
  static const double arenaChallengeFairPlayIcon = 11;
  static const double arenaChallengeRuleNumberWidth = 24;
  static const double arenaChallengeActivityDot = AppSpacing.x2;
  static const double arenaChallengeBridgeIcon = 14;
  static const double arenaChallengeBridgeLetterSpacing = .5;
  static const double arenaChallengeBridgeTitleLineHeight = 1.25;
  static const double arenaChallengeBridgeNoticeLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaChallengeActionShareSize = 52;
  static const double arenaChallengeCommunityIcon = arenaHomeFooterIcon;
  static const double arenaChallengeSummaryLabelWidth = 108;
  static const double arenaChallengeSummaryLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaChallengeBannerIcon = 15;
  static const double arenaChallengeBannerLineHeight = 1.4;
  static const double arenaChallengeSecondaryIcon = 14;
  static const double arenaChallengeInlineIcon = 14;
  static const double arenaChallengeLiveDot = AppSpacing.x2;
  static const double arenaChallengeIconBubble = 38;
  static const double arenaChallengeIconBubbleIcon = 19;
  static const double arenaChallengeInitialBadge = 16;
  static const double arenaChallengeInitialLineHeight = 1.0;
  static const double arenaLeaderboardPodiumSideSize = 54;
  static const double arenaLeaderboardPodiumWinnerSize = 70;
  static const double arenaLeaderboardPodiumBorderWidth =
      AppSpacing.hairlineStroke;
  static const double arenaLeaderboardPodiumShadowBlur = 18;
  static const double arenaLeaderboardPodiumShadowSpread = -2;
  static const double arenaLeaderboardPodiumIcon = 26;
  static const double arenaLeaderboardLineHeight = 1.0;
  static const double arenaLeaderboardDividerHeight =
      AppSpacing.dividerHairline;
  static const double arenaLeaderboardSectionMarkerWidth = AppSpacing.x1;
  static const double arenaLeaderboardSectionMarkerHeight = 16;
  static const double arenaLeaderboardMyRankIconBox = 42;
  static const double arenaLeaderboardMyRankIcon = 22;
  static const double arenaLeaderboardFilterIcon = AppSpacing.iconSm;
  static const double arenaLeaderboardRowRankWidth = 28;
  static const double arenaLeaderboardRowAvatar = 40;
  static const double arenaLeaderboardRowIcon = 20;
  static const double arenaLeaderboardFairPlayIcon = 10;
  static const double arenaLeaderboardRisingIcon = AppSpacing.iconSm;
  static const double arenaLeaderboardCompactIcon = 30;
  static const double arenaLeaderboardFooterIcon = arenaHomeFooterIcon;
  static const double arenaLeaderboardFooterShieldIcon =
      arenaHomeFooterShieldIcon;
  static const double arenaLeaderboardFooterLineHeight =
      arenaHomeFooterLineHeight;
  static const EdgeInsets arenaLeaderboardHeroPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaLeaderboardFilterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaLeaderboardRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets arenaLeaderboardCompactStatePadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets arenaLeaderboardFooterActionPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x2);
  static const EdgeInsets arenaLeaderboardFooterCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaLeaderboardPodiumPadding = EdgeInsets.only(
    top: AppSpacing.x2,
    bottom: AppSpacing.x4,
  );
  static const double arenaModeActionIconDefaultSize = 32;
  static const double arenaModeActionIconLargeThreshold = 40;
  static const double arenaModeActionIconLargeGlyph = 22;
  static const double arenaModeActionIconGlyph = 17;
  static const double arenaModeHeroIcon = 48;
  static const EdgeInsets arenaModeMiniStatPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x4,
  );
  static const double arenaModeTitleLineHeight = 1.08;
  static const double arenaModeCreatorIcon = 34;
  static const double arenaModeChevron = 18;
  static const double arenaModeDescriptionLineHeight = 1.55;
  static const double arenaModeRuleLabelWidth = 112;
  static const double arenaModeRuleValueLineHeight = arenaHomeFooterLineHeight;
  static const int arenaModeQualityColumns = 2;
  static const double arenaModeQualityExtent = 62;
  static const double arenaModeQualityInfoIcon = 14;
  static const double arenaModeQualityIcon = arenaHomeActionIcon;
  static const EdgeInsets arenaModeQualityCardPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const double arenaModeTrustIcon = myArenaActionIconBox;
  static const double arenaModeTrustTextLineHeight = 1.4;
  static const EdgeInsets arenaModePredictionCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double arenaModePredictionInfoIcon = AppSpacing.iconSm;
  static const double arenaModePredictionLetterSpacing =
      arenaChallengeBridgeLetterSpacing;
  static const double arenaModePredictionTitleLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaModePredictionMetricIcon = 14;
  static const double arenaModePredictionProgressHeight = 6;
  static const double arenaModePredictionActionIcon = AppSpacing.iconSm;
  static const double arenaModePredictionNoticeLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaModeRelatedDividerHeight =
      AppSpacing.dividerHairline;
  static const double arenaModeRelatedCardWidth = 184;
  static const double arenaModeRelatedCardMinHeight = 132;
  static const double arenaModeRelatedTitleLineHeight = 1.2;
  static const double arenaModeRelatedDescriptionLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaJoinInlineIcon = AppSpacing.iconSm;
  static const double arenaJoinCreatorAvatar = 44;
  static const double arenaJoinRuleNumberWidth = 24;
  static const double arenaJoinBodyLineHeight = arenaHomeFooterLineHeight;
  static const double arenaJoinNoticeLineHeight = arenaHomeFooterLineHeight;
  static const double arenaJoinAcknowledgementMinHeight = 44;
  static const double arenaJoinAcknowledgementLineHeight = 1.55;
  static const double arenaJoinCheckboxSize = 26;
  static const double arenaJoinCheckboxBorderWidth = 1.5;
  static const double arenaJoinCheckboxIcon = 18;
  static const EdgeInsets arenaJoinCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets arenaJoinInfoRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const double arenaPointsMicroIcon = AppSpacing.iconSm;
  static const double arenaPointsSmallIcon = 14;
  static const double arenaPointsInlineIcon = AppSpacing.iconSm + 3;
  static const double arenaPointsCheckInIcon = 17;
  static const double arenaPointsChevron = 22;
  static const double arenaPointsDividerHeight = AppSpacing.dividerHairline;
  static const double arenaPointsCompactLineHeight = 1.0;
  static const double arenaPointsBadgeLineHeight = 1.2;
  static const EdgeInsets arenaPointsExpiringPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaPointsCheckInTilePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaPointsFilterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaPointsLeaderboardRowPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3);
  static const EdgeInsets arenaPointsMiniBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
  );
  static const double arenaPointsBodyLineHeight = 1.35;
  static const double arenaPointsNoticeLineHeight = arenaJoinNoticeLineHeight;
  static const double arenaPointsLedgerIconBox = 36;
  static const double arenaPointsLedgerGlyph = 17;
  static const double arenaPointsLedgerBalanceArrowIcon = 9;
  static const double arenaPointsLedgerBalanceArrowGap = 2;
  static const double arenaPointsTypeBadgeVerticalPadding = 2;
  static const EdgeInsets arenaPointsLedgerCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaPointsLedgerFilterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaPointsLedgerRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.rowPy,
  );
  static const EdgeInsets arenaPointsLedgerBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: arenaPointsTypeBadgeVerticalPadding,
  );
  static const EdgeInsets arenaPointsLedgerNoticePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets arenaPointsLedgerRulesPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const double arenaPointsEntryBalanceArrowBox =
      AppSpacing.buttonCompact;
  static const double arenaPointsEntryLinkMaxWidth = 155;
  static const double arenaPointsEntrySectionMarkerWidth = 4;
  static const double arenaPointsEntrySectionMarkerHeight = 18;
  static const double arenaPointsEntryDetailLabelWidth = 105;
  static const EdgeInsets arenaPointsEntryHeroPadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets arenaPointsEntryCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaPointsEntryNoticePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets arenaPointsEntryCopyPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaPointsEntryRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaPointsEntryLinkPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
    vertical: AppSpacing.x1,
  );
  static const double arenaSafetyFooterIcon = arenaPointsSmallIcon;
  static const double arenaSafetyIconBox = 40;
  static const double arenaSafetyMarkerWidth = 4;
  static const double arenaSafetyMarkerHeight = 18;
  static const double arenaSafetySectionTitleLineHeight = 1.25;
  static const double arenaSafetyBodyLineHeight = arenaPointsBodyLineHeight;
  static const double arenaSafetyNoticeLineHeight = arenaPointsNoticeLineHeight;
  static const double arenaSafetyBannedIcon = 15;
  static const double arenaSafetyProcessColumnWidth = 30;
  static const double arenaSafetyProcessStepBox = 28;
  static const double arenaSafetyProcessLineWidth = AppSpacing.dividerHairline;
  static const double arenaSafetyProcessLineHeight = 28;
  static const double arenaSafetyInfoIcon = 18;
  static const double arenaSafetyCheckIcon = arenaPointsSmallIcon;
  static const double arenaSafetyCheckLineHeight = 1.4;
  static const double arenaSafetyDividerHeight = AppSpacing.dividerHairline;
  static const EdgeInsets arenaSafetyCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static EdgeInsets arenaSafetyProcessBodyPadding({required bool isLast}) =>
      EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3);
  static const double arenaReportSmallIcon = arenaPointsSmallIcon;
  static const double arenaReportInlineIcon = 18;
  static const double arenaReportToneIconBox = 40;
  static const double arenaReportToneIcon = 20;
  static const double arenaReportMarkerWidth = 4;
  static const double arenaReportMarkerHeight = 18;
  static const double arenaReportBodyLineHeight = arenaPointsBodyLineHeight;
  static const double arenaReportNoticeLineHeight = arenaPointsNoticeLineHeight;
  static const double arenaReportActionLineHeight = 1.5;
  static const double arenaReportTimelineColumnWidth = 20;
  static const double arenaReportTimelineDot = 12;
  static const double arenaReportTimelineBorderWidth =
      AppSpacing.hairlineStroke;
  static const double arenaReportTimelineLineWidth = AppSpacing.dividerHairline;
  static const double arenaReportTimelineLineHeight = 28;
  static const double arenaReportTimelineDateGap = 2;
  static const double arenaReportAppealCtaHeight = 36;
  static const EdgeInsets arenaReportCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaReportInnerPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets arenaReportTimelineDotMargin = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets arenaReportTimelineBodyPadding = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static EdgeInsets arenaReportRelatedItemPadding({required bool isLast}) =>
      EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x2);
  static const double myArenaReportsFilterHeight = 44;
  static const double myArenaReportsBadgeHeight = 20;
  static const double myArenaReportsBadgeMinWidth = 20;
  static const double myArenaReportsBadgePaddingHorizontal = 6;
  static const double myArenaReportsCompactLineHeight = 1.0;
  static const double myArenaReportsBodyLineHeight =
      arenaReportNoticeLineHeight;
  static const double myArenaReportsWrapRunSpacing = 2;
  static const double myArenaReportsChevron = arenaReportInlineIcon;
  static const double myArenaReportsIconBox = 40;
  static const double myArenaReportsIcon = 19;
  static const double myArenaReportsToneIcon = arenaReportInlineIcon;
  static const double myArenaReportsDividerHeight = AppSpacing.dividerHairline;
  static const EdgeInsets myArenaReportsSummaryTilePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x4);
  static const EdgeInsets myArenaReportsFilterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets myArenaReportsBadgePadding = EdgeInsets.symmetric(
    horizontal: myArenaReportsBadgePaddingHorizontal,
  );
  static const EdgeInsets myArenaReportsCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double arenaBlockedBodyLineHeight = arenaReportNoticeLineHeight;
  static const double arenaBlockedTinyGap = 2;
  static const double arenaBlockedAvatarBox = 40;
  static const double arenaBlockedAvatarIcon = arenaReportToneIcon;
  static const double arenaBlockedActionHeight = 30;
  static const double arenaBlockedActionMinWidth = 74;
  static const double arenaBlockedDialogLineHeight =
      arenaReportActionLineHeight;
  static const double arenaBlockedToneIconBox = 36;
  static const double arenaBlockedToneIcon = arenaReportInlineIcon;
  static const EdgeInsets arenaBlockedCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaBlockedRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaBlockedActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const double arenaBridgeHeroLineHeight = 1.2;
  static const double arenaBridgeTitleLineHeight =
      arenaSafetySectionTitleLineHeight;
  static const double arenaBridgeMetricLineHeight = arenaPointsBodyLineHeight;
  static const double arenaBridgeBodyLineHeight = arenaReportNoticeLineHeight;
  static const double arenaBridgeIntroLineHeight = arenaReportActionLineHeight;
  static const double arenaBridgeTabHeight = 44;
  static const double arenaBridgePrincipleMinHeight = 84;
  static const double arenaBridgeTopicMinHeight = 32;
  static const double arenaBridgeDemoMinHeight = 76;
  static const double arenaBridgeStatMinHeight = 112;
  static const double arenaBridgeBadgeMinHeight = 26;
  static const double arenaBridgeTinyGap = 2;
  static const double arenaBridgeMicroIcon = arenaPointsMicroIcon;
  static const double arenaBridgeSmallIcon = arenaPointsSmallIcon;
  static const double arenaBridgeBadgeIcon = 12;
  static const double arenaBridgeChipIcon = arenaSafetyBannedIcon;
  static const double arenaBridgeInlineIcon = arenaPointsInlineIcon;
  static const double arenaBridgeActionIcon = arenaReportInlineIcon;
  static const double arenaBridgeMetricLabelWidth = 72;
  static const double arenaBridgeCompactIconBox = 30;
  static const double arenaBridgeIconBox = 36;
  static const double arenaBridgeCompactGlyph = 15;
  static const double arenaBridgeGlyph = 17;
  static const double arenaBridgeLetterSpacing = .2;
  static const double arenaProductionHeroLineHeight = arenaBridgeHeroLineHeight;
  static const double arenaProductionTitleLineHeight =
      arenaBridgeHeroLineHeight;
  static const double arenaProductionBodyLineHeight = arenaBridgeBodyLineHeight;
  static const double arenaProductionMetricLineHeight =
      arenaBridgeMetricLineHeight;
  static const double arenaProductionCompactLineHeight =
      arenaPointsCompactLineHeight;
  static const double arenaProductionCheckLineHeight =
      arenaSafetyCheckLineHeight;
  static const double arenaProductionTabHeight = arenaBridgeTabHeight;
  static const double arenaProductionTabIcon = arenaBridgeChipIcon;
  static const double arenaProductionScreenMinHeight = 132;
  static const double arenaProductionFlowIcon = arenaBridgeGlyph;
  static const double arenaProductionFlowBarHeight = 4;
  static const double arenaProductionFlowColumnWidth =
      arenaReportTimelineColumnWidth;
  static const double arenaProductionFlowDot = arenaBridgeMicroIcon;
  static const double arenaProductionFlowBorderWidth =
      AppSpacing.hairlineStroke;
  static const double arenaProductionFlowLineWidth = AppSpacing.hairlineStroke;
  static const double arenaProductionFlowLineMargin = arenaBridgeTinyGap;
  static const double arenaProductionStatusDot = AppSpacing.x3;
  static const double arenaProductionHandoffIcon = arenaBridgeInlineIcon;
  static const double arenaProductionChecklistIcon = arenaBridgeSmallIcon;
  static const double arenaProductionStateIcon = arenaBridgeBadgeIcon;
  static const double arenaProductionStateMatrixMinWidth = 70;
  static const double arenaProductionStateMatrixIcon = 11;
  static const double arenaPresetCaptionLineHeight = 1.3;
  static const double arenaPresetBodyLineHeight = arenaPointsBodyLineHeight;
  static const double arenaPresetCheckLineHeight = arenaSafetyCheckLineHeight;
  static const double arenaPresetNoticeLineHeight = arenaPointsNoticeLineHeight;
  static const double arenaPresetSmallIcon = arenaPointsSmallIcon;
  static const double arenaPresetHeaderIcon = 15;
  static const double arenaPresetTinyIcon = arenaBridgeBadgeIcon;
  static const double arenaPresetMicroIcon = arenaBridgeMicroIcon;
  static const double arenaPresetInlineIcon = arenaBridgeInlineIcon;
  static const double arenaPresetSearchIcon = arenaReportInlineIcon;
  static const double arenaPresetChevron = arenaReportInlineIcon;
  static const double arenaPresetDomainIconBox = 40;
  static const double arenaPresetDomainIcon = arenaReportToneIcon;
  static const double arenaPresetSuggestionMaxWidth = 250;
  static const double arenaPresetTitleMaxWidth = 260;
  static const double arenaPresetProcessLabelWidth = 56;
  static const double arenaPresetStepDot = 22;
  static const double arenaPresetDividerHeight = AppSpacing.dividerHairline;
  static const double arenaEcosystemMetricLineHeight =
      arenaBridgeMetricLineHeight;
  static const double arenaEcosystemBodyLineHeight = arenaBridgeBodyLineHeight;
  static const double arenaEcosystemIntroLineHeight =
      arenaBridgeIntroLineHeight;
  static const double arenaEcosystemTitleLineHeight =
      arenaBridgeTitleLineHeight;
  static const double arenaEcosystemCheckLineHeight =
      arenaSafetyCheckLineHeight;
  static const double arenaEcosystemTabHeight = arenaBridgeTabHeight;
  static const double arenaEcosystemTabIcon = arenaBridgeChipIcon;
  static const double arenaEcosystemScreenMinHeight = 136;
  static const double arenaEcosystemFlowDot = arenaPresetStepDot;
  static const double arenaEcosystemFlowBorderWidth = AppSpacing.borderWidth;
  static const double arenaEcosystemFlowBridgeIcon =
      arenaProductionStateMatrixIcon;
  static const double arenaEcosystemFlowLineWidth = AppSpacing.borderWidth;
  static const double arenaEcosystemFlowLineHeight = 38;
  static const double arenaEcosystemCompactIcon = arenaBridgeMicroIcon;
  static const double arenaEcosystemBlockIcon = arenaBridgeChipIcon;
  static const double arenaEcosystemBoardChipHeight = 38;
  static const double arenaEcosystemSmallIcon = arenaBridgeSmallIcon;
  static const double arenaEcosystemInlineIcon = arenaBridgeInlineIcon;
  static const double arenaEcosystemPillMinHeight = arenaPresetStepDot;
  static const double arenaEcosystemTintIconBox = arenaBridgeIconBox;
  static const double arenaEcosystemTintIconBoxSmall =
      arenaBridgeCompactIconBox;
  static const double arenaEcosystemTintGlyph = arenaBridgeGlyph;
  static const double arenaEcosystemTintGlyphSmall = arenaBridgeCompactGlyph;
  static const double arenaGovernanceStepperLineHeight =
      AppSpacing.hairlineStroke;
  static const double arenaGovernanceStepActive = 31;
  static const double arenaGovernanceStepDefault = 28;
  static const double arenaGovernanceSubtitleLineHeight =
      arenaPresetCaptionLineHeight;
  static const double arenaGovernanceBodyLineHeight =
      arenaSafetyCheckLineHeight;
  static const double arenaGovernanceNoticeLineHeight =
      arenaReportNoticeLineHeight;
  static const double arenaGovernanceSmallIcon = arenaPresetSmallIcon;
  static const double arenaGovernanceAddIcon = arenaPresetHeaderIcon;
  static const double arenaGovernanceIcon = arenaBridgeInlineIcon;
  static const double arenaGovernanceLargeIcon = arenaReportInlineIcon;
  static const double arenaGovernanceFooterIcon = arenaPresetStepDot;
  static const double arenaGovernanceClarityProgressHeight = 7;
  static const double arenaGovernancePillPadCompactV = 1;
  static const double arenaGovernancePillPadV = 3;
  static const double arenaGovernanceOptionMaxWidth = 132;
  static const int arenaGovernanceGridColumns = 2;
  static const double arenaGovernanceDomainGridAspect = 3.2;
  static const double arenaGovernanceWinGridAspect = 2.45;
  static const double arenaGovernanceInputBorderWidth = 1.4;
  static const EdgeInsets arenaGovernanceStepperLineMargin = EdgeInsets.only(
    bottom: AppSpacing.x5,
  );
  static const EdgeInsets arenaGovernanceCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaGovernanceInnerPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets arenaGovernanceSummaryRowPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static EdgeInsets arenaGovernancePillPadding({required bool compact}) =>
      EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.x1 : AppSpacing.x2,
        vertical: compact
            ? arenaGovernancePillPadCompactV
            : arenaGovernancePillPadV,
      );
  static const EdgeInsets arenaGovernanceNextActionPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x2);
  static const EdgeInsets arenaGovernanceFooterPadding = EdgeInsets.fromLTRB(
    AppSpacing.x5,
    AppSpacing.x4,
    AppSpacing.x5,
    AppSpacing.x2,
  );
  static const EdgeInsets arenaGovernanceSavePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaGovernanceListItemPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets arenaGovernanceComparePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets arenaGovernancePrivacyChipPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3);
  static const EdgeInsets arenaGovernanceOptionChipPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x2);
  static const EdgeInsets arenaGovernanceEdgeFieldPadding = EdgeInsets.only(
    top: AppSpacing.x3,
  );
  static const EdgeInsets arenaGovernanceDropdownPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaGovernanceSwitchRowPadding = EdgeInsets.only(
    top: AppSpacing.x2,
  );
  static const EdgeInsets arenaGovernanceInputPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const double arenaSmartRuleStepperLineHeight =
      arenaGovernanceStepperLineHeight;
  static const double arenaSmartRuleStepDot = arenaGovernanceStepDefault;
  static const double arenaSmartRuleStepIcon = arenaGovernanceSmallIcon;
  static const double arenaSmartRuleSubtitleLineHeight =
      arenaGovernanceSubtitleLineHeight;
  static const double arenaSmartRuleIcon = arenaGovernanceIcon;
  static const double arenaSmartRuleSmallIcon = arenaGovernanceSmallIcon;
  static const double arenaSmartRuleTinyIcon = arenaGovernanceAddIcon;
  static const double arenaSmartRuleBodyLineHeight =
      arenaGovernanceBodyLineHeight;
  static const double arenaSmartRuleProgressHeight = AppSpacing.x2;
  static const double arenaSmartRuleOptionWidth = 181;
  static const double arenaSmartRuleChallengeTypeWidth = 200;
  static const double arenaSmartRuleSummaryLabelWidth = 112;
  static const EdgeInsets arenaSmartRuleStepperLineMargin = EdgeInsets.only(
    bottom: AppSpacing.x5,
  );
  static const EdgeInsets arenaSmartRuleCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaSmartRuleInnerPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets arenaSmartRuleLinkPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaSmartRuleSelectorPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets arenaSmartRuleCompactSelectorPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x3);
  static const EdgeInsets arenaSmartRuleTilePadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaSmartRuleEdgeFieldPadding = EdgeInsets.only(
    top: AppSpacing.x4,
  );
  static const EdgeInsets arenaSmartRuleSwitchRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaSmartRuleSummaryRowPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x2);
  static const double arenaStudioStepperLineHeight =
      arenaSmartRuleStepperLineHeight;
  static const double arenaStudioStepDot = arenaSmartRuleStepDot;
  static const double arenaStudioStepIcon = arenaSmartRuleStepIcon;
  static const double arenaStudioStepLabelLineHeight = 1.1;
  static const double arenaStudioStepIconBox = arenaBridgeIconBox;
  static const double arenaStudioDescriptionLineHeight =
      arenaReportNoticeLineHeight;
  static const double arenaStudioTemplateIconBox = 44;
  static const double arenaStudioTemplateGlyph = arenaPresetStepDot;
  static const double arenaStudioSelectedIcon = arenaBridgeGlyph;
  static const double arenaStudioLockIcon = arenaSmartRuleIcon;
  static const double arenaStudioTemplateLineHeight = 1.35;
  static const double arenaStudioCommunityIcon = arenaSmartRuleIcon;
  static const double arenaStudioFeeIconBox = arenaSafetyIconBox;
  static const double arenaStudioFeeBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaStudioFeeInfoIcon = AppSpacing.iconSm;
  static const double arenaStudioFeeChevron = arenaPresetHeaderIcon;
  static const double arenaStudioFeeDetailIcon = arenaSmartRuleSmallIcon;
  static const double arenaStudioFooterButton =
      AppSpacing.searchBarCompactHeight;
  static const double arenaStudioFooterContinueWidth = 148;
  static const double arenaStudioFooterSubmitWidth = 172;
  static const double arenaStudioFooterStateIcon = arenaPresetHeaderIcon;
  static const double arenaStudioFooterToolButton = arenaBridgeIconBox;
  static const EdgeInsets arenaStudioStepperPadding = EdgeInsets.only(
    top: AppSpacing.x2,
  );
  static const EdgeInsets arenaStudioStepperLineMargin = EdgeInsets.only(
    bottom: AppSpacing.x5,
  );
  static const EdgeInsets arenaStudioCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaStudioTemplatePadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaStudioFeeTogglePadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaStudioFeeDetailPadding = EdgeInsets.only(
    top: AppSpacing.x2,
  );
  static const EdgeInsets arenaStudioFooterCtaPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const double arenaCreatorEmptyIcon = arenaGovernanceStepDefault;
  static const double arenaCreatorInlineIcon = arenaSmartRuleSmallIcon;
  static const double arenaCreatorAvatar = 64;
  static const double arenaCreatorAvatarGlyph = 34;
  static const double arenaCreatorSectionMarkerWidth = 4;
  static const double arenaCreatorSectionMarkerHeight = 16;
  static const double arenaCreatorChevron = arenaSmartRuleIcon;
  static const double arenaCreatorMetricIconBox = arenaBridgeIconBox;
  static const double arenaCreatorMetricGlyph = arenaReportInlineIcon;
  static const double arenaCreatorTabButtonHeight = arenaStudioFooterButton;
  static const double arenaCreatorModeIconBox = arenaSafetyIconBox;
  static const double arenaCreatorModeGlyph = arenaReportToneIcon;
  static const double arenaCreatorModeChevron = arenaReportToneIcon;
  static const double arenaCreatorAboutLineHeight =
      arenaStudioDescriptionLineHeight;
  static const EdgeInsets arenaCreatorHeroPadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets arenaCreatorStatPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaCreatorTrustActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets arenaCreatorMetricPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaCreatorModeRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets arenaCreatorCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaCreatorEmptyPadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets arenaCreatorPolicyPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
    vertical: AppSpacing.x2,
  );
  static const double arenaGuideCtaIcon = arenaSmartRuleIcon;
  static const EdgeInsets arenaGuideTabsPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const double arenaGuideHeroIcon = arenaStudioSelectedIcon;
  static const double arenaGuideModeIcon = arenaSmartRuleIcon;
  static const EdgeInsets arenaGuideModeSwitchPadding = EdgeInsets.all(
    AppSpacing.x1,
  );
  static const double arenaGuideTimelineLeft = arenaReportInlineIcon;
  static const double arenaGuideTimelineInset = 26;
  static const double arenaGuideTimelineLineWidth = AppSpacing.hairlineStroke;
  static EdgeInsets arenaGuideTimelineStepPadding(bool last) =>
      EdgeInsets.only(bottom: last ? 0 : AppSpacing.x3);
  static const double arenaGuideStepIconBox = 38;
  static const double arenaGuideStepBorderWidth = AppSpacing.hairlineStroke;
  static const double arenaGuideStepGlyph = arenaStudioSelectedIcon;
  static const double arenaGuideStepTextTopPadding = arenaBridgeTinyGap;
  static const EdgeInsets arenaGuideStepTextPadding = EdgeInsets.only(
    top: arenaGuideStepTextTopPadding,
  );
  static const double arenaGuideStepBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaGuideStartIconBox = arenaSafetyIconBox;
  static const double arenaGuideStartGlyph = arenaReportToneIcon;
  static const double arenaGuideReasonIcon = AppSpacing.iconSm;
  static const EdgeInsets arenaGuideReasonPadding = EdgeInsets.only(
    bottom: AppSpacing.x1,
  );
  static const double arenaGuideTipsHeaderIcon = 19;
  static const double arenaGuideShowMoreIcon = arenaSmartRuleIcon;
  static const double arenaGuideChecklistIcon = arenaReportInlineIcon;
  static const double arenaGuideChecklistBox = arenaReportInlineIcon;
  static const EdgeInsets arenaGuideChecklistItemPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const double arenaGuideChecklistLineHeight =
      myArenaReportsCompactLineHeight;
  static const double arenaGuideSafetyHeroIcon = arenaGuideTipsHeaderIcon;
  static const double arenaGuideFeatureIconBox = arenaSafetyIconBox;
  static const double arenaGuideFeatureGlyph = arenaReportToneIcon;
  static const double arenaGuideSafetyTipIconBox = arenaGuideStepIconBox;
  static const double arenaGuideSafetyTipGlyph = arenaReportInlineIcon;
  static EdgeInsets arenaGuideSafetyTipPadding(bool last) =>
      EdgeInsets.only(bottom: last ? 0 : AppSpacing.x3);
  static const double arenaGuideChevron = arenaReportInlineIcon;
  static const double arenaGuideSupportChevron = arenaSmartRuleSmallIcon;
  static const double arenaGuideAccordionIconBox = arenaBridgeCompactIconBox;
  static const double arenaGuideAccordionGlyph = arenaSmartRuleIcon;
  static const double arenaGuideAccordionDot = AppSpacing.x2;
  static const double arenaGuideAccordionChevron = arenaReportInlineIcon;
  static EdgeInsets arenaGuideAccordionListPadding(bool last) =>
      EdgeInsets.only(bottom: last ? 0 : AppSpacing.x2);
  static const EdgeInsets arenaGuideAccordionBodyPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x3,
    AppSpacing.x4,
    AppSpacing.x4,
  );
  static const double arenaGuideAccordionBodyLineHeight = 1.55;
  static const double arenaGuideSmallBadgePadH = 7;
  static const double arenaGuideSmallBadgePadV = 3;
  static const EdgeInsets arenaGuideSmallBadgePadding = EdgeInsets.symmetric(
    horizontal: arenaGuideSmallBadgePadH,
    vertical: arenaGuideSmallBadgePadV,
  );
  static const double arenaGuideSmallBadgeLineHeight =
      myArenaReportsCompactLineHeight;
  static const double arenaGuideMetaChipPadH = AppSpacing.x2;
  static const double arenaGuideMetaChipPadV = AppSpacing.x1;
  static const EdgeInsets arenaGuideMetaChipPadding = EdgeInsets.symmetric(
    horizontal: arenaGuideMetaChipPadH,
    vertical: arenaGuideMetaChipPadV,
  );
  static const double arenaGuideTipPillIcon = arenaBridgeBadgeIcon;
  static const EdgeInsets arenaGuideTipPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const double arenaGuideLegendDot = AppSpacing.x2;
  static const double arenaFlowMapDividerHeight = AppSpacing.dividerHairline;
  static const double arenaFlowMapSmallIcon = arenaSmartRuleSmallIcon;
  static const double arenaFlowMapInlineIcon = arenaReportInlineIcon;
  static const double arenaFlowMapSectionIcon = arenaStudioSelectedIcon;
  static const double arenaFlowMapConnectionLineHeight =
      arenaStudioTemplateLineHeight;
  static const double arenaFlowMapHeroLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaFlowMapBodyLineHeight = arenaSafetyCheckLineHeight;
  static const double arenaFlowMapQaLineHeight = arenaStudioTemplateLineHeight;
  static const double arenaFlowMapMarkerWidth = arenaCreatorSectionMarkerWidth;
  static const double arenaFlowMapMarkerHeight = arenaStudioSelectedIcon;
  static const EdgeInsets arenaFlowMapHeroPadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets arenaFlowMapCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaFlowMapInnerPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets arenaFlowMapStatPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets arenaFlowMapSectionTogglePadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3);
  static const EdgeInsets arenaFlowMapRouteHeaderPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets arenaFlowMapRouteRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const double arenaTrustScoreBox = 72;
  static const double arenaTrustHeroLineHeight = arenaSafetyCheckLineHeight;
  static const double arenaTrustDisclaimerLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaTrustMetricIconBox = arenaCreatorMetricIconBox;
  static const double arenaTrustMetricGlyph = arenaCreatorMetricGlyph;
  static const double arenaTrustCreatorAvatar = arenaSafetyIconBox;
  static const double arenaTrustSafetyIcon = arenaGuideFeatureGlyph;
  static const EdgeInsets arenaTrustCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const double arenaVerifiedHeroTextMaxWidth = 360;
  static const double arenaVerifiedHeroIconBox = AppSpacing.x7 + AppSpacing.x5;
  static const double arenaVerifiedHeroLineHeight =
      arenaGuideAccordionBodyLineHeight;
  static const double arenaVerifiedInfoIcon = arenaStudioSelectedIcon;
  static const double arenaVerifiedFeatureIcon =
      AppSpacing.statusPillIconSizeSm;
  static const double arenaVerifiedFeatureLineHeight =
      arenaStudioDescriptionLineHeight;
  static const EdgeInsets arenaVerifiedInfoPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets arenaVerifiedFeatureIconPadding = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const double arenaResolutionBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaStateCardIcon = arenaReportInlineIcon;
  static const double arenaStateCardBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const EdgeInsets arenaStateCardPaddingCompact = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets arenaStateCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets arenaStateCardIconPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets arenaStateCardMetricPadding = EdgeInsets.only(
    top: AppSpacing.x2,
  );
  static const EdgeInsets arenaStateCardPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
}
