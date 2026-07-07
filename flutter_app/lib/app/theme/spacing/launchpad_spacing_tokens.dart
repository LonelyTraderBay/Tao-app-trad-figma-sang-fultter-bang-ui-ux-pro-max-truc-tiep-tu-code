import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

final class LaunchpadSpacingTokens {
  const LaunchpadSpacingTokens._();

  static const double launchpadSwapStickyCtaClearance =
      TradeSpacingTokens.convertStickyCtaClearance;
  static const double launchpadLineHeightTight =
      DcaSpacingTokens.dcaRebalanceTightLineHeight;
  static const double launchpadLineHeightMicro = 1.05;
  static const double launchpadLineHeightCompact = 1.1;
  static const double launchpadLineHeightLabel =
      DcaSpacingTokens.dcaOverviewMetricLabelLineHeight;
  static const double launchpadLineHeightShort =
      DcaSpacingTokens.dcaDynamicCaptionLineHeight;
  static const double launchpadLineHeightEvent = 1.24;
  static const double launchpadLineHeightBody =
      DcaSpacingTokens.dcaDynamicHistoryLineHeight;
  static const double launchpadLineHeightDense =
      DcaSpacingTokens.dcaPortfolioOptimizerBodyLineHeight;
  static const double launchpadLineHeightReadable =
      DcaSpacingTokens.dcaBacktesterBodyLineHeight;
  static const double launchpadLineHeightLong =
      DcaSpacingTokens.dcaDynamicDescriptionLineHeight;
  static const double launchpadLineHeightLoose =
      DcaSpacingTokens.dcaDynamicExplainerLineHeight;
  static const double launchpadGapXxs = AppSpacing.hairlineStroke * 2;
  static const double launchpadGapXs = AppSpacing.x1;
  static const double launchpadDividerWidth = AppSpacing.hairlineStroke;
  static const double launchpadDividerHeight = AppSpacing.hairlineStroke;
  static const double launchpadRadiusXxs = AppSpacing.hairlineStroke / 2;
  static const double launchpadBorderWidthFocus = 1.5;
  static const double launchpadBorderWidthStrong =
      AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double launchpadVerticalMarkerWidth = AppSpacing.x1;
  static const double launchpadSheetMaxWidth = 440;
  static const double launchpadSheetHandleWidth = 40;
  static const double launchpadSheetHandleWide = 44;
  static const double launchpadSheetHandleHeight =
      AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double launchpadDotXs = AppSpacing.x2;
  static const double launchpadDotSm =
      EarnSpacingTokens.savingsRebalanceTrackHeight;
  static const double launchpadDotMd = AppSpacing.x3;
  static const double launchpadFontXxs = AppSpacing.serviceTileBadgeFont;
  static const double launchpadFontXs =
      EarnSpacingTokens.stakingAutoCompoundAxisFontSize;
  static const double launchpadFontSm = 10;
  static const double launchpadFontMd =
      ArenaSpacingTokens.arenaModePredictionActionIcon;
  static const double launchpadFontLg =
      EarnSpacingTokens.stakingTaxDetailFontSize;
  static const double launchpadFontXl = DcaSpacingTokens.dcaMainInlineIcon;
  static const double launchpadFont2xl = DcaSpacingTokens.dcaMainToolIcon;
  static const double launchpadFont3xl =
      AppSpacing.statusPillHeightMd + launchpadGapXxs;
  static const double launchpadFont4xl = 36;
  static const double launchpadIconXxs = launchpadFontSm;
  static const double launchpadIconXs = EarnSpacingTokens.stakingApiCopyIcon;
  static const double launchpadIconSm = AppSpacing.iconSm;
  static const double launchpadIconMd = AppSpacing.searchBarFont;
  static const double launchpadIconLg =
      ArenaSpacingTokens.myArenaAccentPillIcon;
  static const double launchpadIconXl = AppSpacing.bottomNavBadgeMinWidth;
  static const double launchpadIcon2xl = DcaSpacingTokens.dcaMainInlineIcon;
  static const double launchpadIcon3xl = DcaSpacingTokens.dcaMainToolIcon;
  static const double launchpadIcon4xl = AppSpacing.iconMd;
  static const double launchpadIcon5xl =
      EarnSpacingTokens.savingsConsumerHeroAmountFontSize;
  static const double launchpadIcon6xl =
      DcaSpacingTokens.dcaOverviewInlineIcon + launchpadGapXs;
  static const double launchpadIcon7xl = AppSpacing.buttonCompact;
  static const double launchpadIconHuge = AppSpacing.statusPillHeightLg;
  static const double launchpadBox12 = launchpadIconXs;
  static const double launchpadBox17 =
      launchpadIconXl + AppSpacing.hairlineStroke;
  static const double launchpadBox18 = launchpadIcon2xl;
  static const double launchpadBox24 = DcaSpacingTokens.dcaMultiToggleThumb;
  static const double launchpadBox28 =
      AppSpacing.statusPillHeightMd + launchpadGapXxs;
  static const double launchpadBox30 =
      EarnSpacingTokens.savingsPortfolioEarningsFontSize;
  static const double launchpadBox31 =
      launchpadBox30 + AppSpacing.hairlineStroke;
  static const double launchpadBox32 = AppSpacing.statusPillHeightLg;
  static const double launchpadBox34 = AppSpacing.buttonCompact;
  static const double launchpadBox36 =
      EarnSpacingTokens.stakingRiskDashboardScoreFontSize;
  static const double launchpadBox40 =
      DcaSpacingTokens.dcaScheduleAccentIconBox;
  static const double launchpadBox42 = DcaSpacingTokens.dcaRebalanceTileIconBox;
  static const double launchpadBox44 = AppSpacing.searchBarCompactHeight;
  static const double launchpadBox48 = DcaSpacingTokens.dcaSmartStatsIconBox;
  static const double launchpadBox56 =
      AppSpacing.x7 + AppSpacing.hairlineStroke;
  static const double launchpadBox58 = launchpadBox56 + launchpadGapXxs;
  static const double launchpadBox60 = launchpadBox58 + launchpadGapXxs;
  static const double launchpadBox64 = 64;
  static const double launchpadBox68 =
      launchpadBox64 + launchpadSheetHandleHeight;
  static const double launchpadBox76 =
      DcaSpacingTokens.dcaMainStatCardHeight - launchpadGapXxs;
  static const double launchpadBox104 = 104;
  static const double launchpadBox150 = 150;
  static const double launchpadDcaHistoryChartHeight = 170;
  static const double launchpadPerformanceChartHeight =
      DcaSpacingTokens.dcaPortfolioOptimizerBacktestChartHeight;
  static const double launchpadPerformanceSparklineHeight = 190;
  static const double launchpadGasChartHeight = 160;
  static const double launchpadRiskChartHeight = 250;
  static const double launchpadSoundBarBaseHeight = launchpadDotMd;
  static const double launchpadSoundBarHeightStep = launchpadGapXxs;
  static const int launchpadGridColumns = 2;
  static const double launchpadGridAspectCompact = 1.65;
  static const double launchpadGridAspectTile = 1.72;
  static const double launchpadGridAspectWide = 2.15;
  static const double launchpadGridAspectAction = 3.7;
  static const double launchpadGridAspectReport = 5.2;
  static const EdgeInsets launchpadPaddingX2 = EdgeInsets.all(AppSpacing.x2);
  static const EdgeInsets launchpadPaddingX3 = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets launchpadPaddingX4 = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets launchpadPaddingX5 = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets launchpadPaddingX6 = EdgeInsets.all(AppSpacing.x6);
  static const EdgeInsets launchpadEmptyStatePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x5,
    vertical: AppSpacing.x6,
  );
  static const EdgeInsets launchpadMetricCardPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets launchpadTierChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets launchpadHorizontalPaddingX1 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
  );
  static const EdgeInsets launchpadHorizontalPaddingX3 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets launchpadHorizontalContentPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.contentPad);
  static const EdgeInsets launchpadVerticalPaddingX1 = EdgeInsets.symmetric(
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets launchpadVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets launchpadVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets launchpadVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets launchpadBottomPaddingX2 = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets launchpadBottomPaddingX1 = EdgeInsets.only(
    bottom: AppSpacing.x1,
  );
  static const EdgeInsets launchpadBottomPaddingX3 = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets launchpadTopPaddingX1 = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets launchpadTopPaddingX2 = EdgeInsets.only(
    top: AppSpacing.x2,
  );
  static const EdgeInsets launchpadTopPaddingX3 = EdgeInsets.only(
    top: AppSpacing.x3,
  );
  static const EdgeInsets launchpadTopPaddingX4 = EdgeInsets.only(
    top: AppSpacing.x4,
  );
  static const EdgeInsets launchpadRightPaddingX2 = EdgeInsets.only(
    right: AppSpacing.x2,
  );
  static const EdgeInsets launchpadRightMarginXxs = EdgeInsets.only(
    right: launchpadGapXxs,
  );
  static const EdgeInsets launchpadTinyChipPadding = EdgeInsets.symmetric(
    horizontal: 5,
    vertical: 2,
  );
  static const EdgeInsets launchpadMiniChipPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );
  static const EdgeInsets launchpadCompactChipPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 3,
  );
  static const EdgeInsets launchpadBadgePadding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets launchpadPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets launchpadInlinePillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets launchpadTimelineMarkerPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets launchpadLiveBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: 2,
  );
  static const EdgeInsets launchpadEventLevelPadding = EdgeInsets.symmetric(
    vertical: 1,
  );
  static const EdgeInsets launchpadEventFooterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets launchpadHeaderStatsPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x3,
    AppSpacing.contentPad,
    AppSpacing.x2,
  );
  static const EdgeInsets launchpadStatsStripPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    0,
    AppSpacing.contentPad,
    AppSpacing.x2,
  );
  static const EdgeInsets launchpadCreateSheetPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x3,
    AppSpacing.contentPad,
    AppSpacing.x6,
  );
  static const EdgeInsets launchpadActionButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets launchpadSupportButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const double launchpadTabIndicatorWidth = 116;
  static const EdgeInsets launchpadSheetHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x2,
    AppSpacing.x4,
    AppSpacing.x6,
  );
  static const EdgeInsets launchpadConfirmSheetPadding = EdgeInsets.fromLTRB(
    AppSpacing.x5,
    AppSpacing.x4,
    AppSpacing.x5,
    AppSpacing.x6,
  );
  static const EdgeInsets launchpadSheetHandleMargin = EdgeInsets.only(
    bottom: AppSpacing.x4,
  );
  static EdgeInsets launchpadSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x2,
        AppSpacing.x4,
        bottomInset,
      );
  static EdgeInsets launchpadClaimSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        AppSpacing.x5 + bottomInset,
      );
  static const EdgeInsets discoveryOfflineBannerPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x4,
    AppSpacing.contentPad,
    AppSpacing.x2,
  );
  static EdgeInsets discoveryContentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets discoverySearchBandPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x4,
    AppSpacing.contentPad,
    AppSpacing.x4,
  );
  static const EdgeInsets discoveryRailPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets discoveryCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets discoveryChipHorizontalPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets discoveryPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets discoveryBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets discoveryMiniBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets discoveryInlineActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets discoveryHeroStatPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets discoveryLeftIndentedCopyPadding = EdgeInsets.only(
    left: AppSpacing.x7,
  );
  static const double discoveryCreatorAvatarBox = launchpadBox24;

  /// Deprecated: use [AppSpacing.accentIconBoxSize] for module accent icon boxes.
  static const double discoveryAccentIconBox = launchpadBox42;
  static const double discoveryPredictionTitleLineHeight = 1.32;
}
