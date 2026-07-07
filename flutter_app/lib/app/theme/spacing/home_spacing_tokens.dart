import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class HomeSpacingTokens {
  const HomeSpacingTokens._();

  static const double skeletonTitleWidth = 160;
  static const double skeletonSubtitleWidth = 120;
  static const double skeletonLineHeightLg = 14;
  static const double skeletonLineWidthLg = 220;
  static const double skeletonLineHeightSm = 10;

  static const int homeQuickActionCompactCount = 6;
  static const int homeQuickActionStandardCount = 9;
  static const double homeQuickActionDensityBreakpoint = 480;
  static const double homeAnnouncementAutoHideScrollOffset = 96;
  static const double homeAnnouncementIcon = 18;
  static const double homeAnnouncementChevron = 16;
  static const double homeAnnouncementIconGap = 12;
  static const double homeAnnouncementArrowGap = 8;
  static const double homeAnnouncementDotGap = 5;
  static const double homeAnnouncementDotActiveWidth = 16;
  static const double homeAnnouncementDotInactiveWidth = 5;
  static const double homeAnnouncementDotHeight = 5;
  static const double homeAnnouncementDotRadius = 3;
  // TOKEN-SPACING-01: homeAnnouncementCardPadding and homePortfolioCardPadding
  // used to share this pair of raw doubles by coincidence, not by design
  // relationship. homeCardPaddingDefault is now the single canonical source.
  static const double homeCardPaddingVerticalDefault = 10;
  static const double homeCardPaddingHorizontalDefault = 14;
  static const EdgeInsets homeCardPaddingDefault = EdgeInsets.symmetric(
    horizontal: homeCardPaddingHorizontalDefault,
    vertical: homeCardPaddingVerticalDefault,
  );
  @Deprecated(
    'Superseded by homeCardPaddingVerticalDefault after TOKEN-SPACING-01',
  )
  static const double homeAnnouncementCardVerticalPadding =
      homeCardPaddingVerticalDefault;
  @Deprecated(
    'Superseded by homeCardPaddingHorizontalDefault after TOKEN-SPACING-01',
  )
  static const double homeAnnouncementCardHorizontalPadding =
      homeCardPaddingHorizontalDefault;
  @Deprecated('Superseded by homeCardPaddingDefault after TOKEN-SPACING-01')
  static const EdgeInsets homeAnnouncementCardPadding = homeCardPaddingDefault;
  static const EdgeInsets homeAnnouncementCardPaddingCompact =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const double homeActionRowGap = 8;
  static const double homePortfolioHeaderIcon = 18;
  static const double homePortfolioHeaderActionPadding = 6;
  static const double homePortfolioBadgeHorizontalPadding = 10;
  static const double homePortfolioBadgeVerticalPadding = 4;
  static const double homePortfolioBadgeIcon = 12;
  @Deprecated('Superseded by homeCardPaddingDefault after TOKEN-SPACING-01')
  static const EdgeInsets homePortfolioCardPadding = homeCardPaddingDefault;
  static const double homePortfolioActionSpacing = 10;
  static const double homeRecentProductWidth = 146;
  static const double homeRecentProductHeight = 86;
  static const double homeHeroActionHeight = 44;
  static const double homeSectionCtaGap = 10;
  static const double homeSectionHorizontalPadding = 16;
  static const double homeSectionVerticalPadding = 14;
  static const double homeChipMinHeight = 20;
  static const double homeChipHorizontalPadding = 7;
  static const double homeChipVerticalPadding = 4;
  static const double homeCommandRowSpacing = 12;
  static const double homeNextActionCardPadding = 14;
  static const double homeNextActionIconContainer = 42;
  static const double homeNextActionIconSize = 20;
  static const double homeRecentProductIcon = 28;
  static const double homeRecentProductIconText = 15;

  /// Gap between major Home blocks. Wire once via [VitPageContent.customGap].
  static const double homeSectionGap = AppSpacing.pageRhythmCompactSectionGap;

  /// Gap from section title to body and between stacked items in a section.
  static const double homeSectionInnerGap =
      AppSpacing.pageRhythmCompactInnerGap;
  static const double homeChevronGap = 4;
  static const double homeMoreProductsSheetHandleWidth = 36;
  static const double homeMoreProductsSheetHandleHeight = 4;
  static const EdgeInsets homeMoreProductsSheetPadding = EdgeInsets.fromLTRB(
    homeSectionCtaGap,
    AppSpacing.x2,
    homeSectionCtaGap,
    homeSectionCtaGap,
  );
  @Deprecated('Use AppSpacing.pageRhythmCompactSectionGap')
  static const double homeDiscoverySectionGap =
      AppSpacing.pageRhythmCompactSectionGap;

  /// Horizontal inset on compact market product cards — not a section rhythm gap.
  static const double homeMarketSectionGap = 12;
  static const double homeSectionHeaderIconGap = 6;
  static const double homeSectionHeaderChevronSize = 14;
  static const double homeSectionActionChevronSize = 16;
  static const double homeActionChevronSize = 18;
  static const double homeSectionHeaderTitleLineHeight = 1.272;
  static const double homeMarketRowPadding = 14;
  static const double homeMarketIconGap = 12;
  static const double homeDiscoveryIconContainer = 44;
  static const double homeDiscoveryIconSize = 20;
  static const double homeDiscoveryCompactIconContainer = 34;
  static const double homeDiscoveryCompactIconSize = 16;
  static const EdgeInsets homeDiscoveryCompactPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const double homeMarketTickerCardWidth = 146;
  static const double homeMarketTickerCardMinHeight = 74;
  static const double homeMarketTickerStripGap = AppSpacing.x3;

  /// Legacy alias — Tier A strip tiles use [AppSpacing.cardTilePadding].
  static const EdgeInsetsDirectional homeMarketTickerCardPadding =
      AppSpacing.cardTilePadding;
  static const double homeDividerHeight = 1;
  static const double homeListRowPadding = 14;
  static const double homeRankedRowRankChipWidth = 20;
  static const double homeRankedRowItemGap = 12;
  static const double homeRankedRowBadgePaddingHorizontal = 12;
  static const double homeRankedRowBadgePaddingVertical = 6;
  static const double homeCoinAvatarSize = 34;
  static const double homeSparklineWidth = 64;
  static const double homeSparklineHeight = 30;
  static const double homeRankedValueColumnWidth = 85;
  static const double homeScrollShowThreshold = 8;
  static const double homeScrollHideThreshold = 24;
  static const double homeBottomSheetScrollInset = 16;
  static const double homeBottomSheetScrollInsetVisual = 40;
  static const double homeSlideOffsetUp = 0.25;
}
