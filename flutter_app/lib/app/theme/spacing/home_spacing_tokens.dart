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
  static const double homeAnnouncementDotRadius = 3;
  static const double homeActionRowGap = 8;
  static const double homePortfolioActionSpacing = 10;
  static const double homeRecentProductWidth = 146;

  /// Gap between major Home blocks. Wire once via [VitPageContent.customGap].
  static const double homeSectionGap = AppSpacing.pageRhythmCompactSectionGap;

  /// Horizontal inset on compact market product cards — not a section rhythm gap.
  static const double homeMarketSectionGap = 12;
  static const double homeMarketRowPadding = 14;

  /// Legacy alias — Tier A strip tiles use [AppSpacing.cardTilePadding].
  static const EdgeInsetsDirectional homeMarketTickerCardPadding =
      AppSpacing.cardTilePadding;
  static const double homeListRowPadding = 14;
  static const double homeRankedRowRankChipWidth = 20;
  static const double homeRankedRowItemGap = 12;
  static const double homeRankedRowBadgePaddingHorizontal = 12;
  static const double homeRankedRowBadgePaddingVertical = 6;
  static const double homeScrollShowThreshold = 8;
  static const double homeScrollHideThreshold = 24;
  static const double homeBottomSheetScrollInset = 16;
  static const double homeBottomSheetScrollInsetVisual = 40;
  static const double homeSlideOffsetUp = 0.25;
}
