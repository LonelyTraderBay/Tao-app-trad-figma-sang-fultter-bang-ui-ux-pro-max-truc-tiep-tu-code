import 'package:flutter/material.dart';

final class AppSpacing {
  const AppSpacing._();

  static const double x1 = 3;
  static const double x2 = 5;
  static const double x3 = 8;
  static const double x4 = 13;
  static const double x5 = 21;
  static const double x6 = 34;
  static const double x7 = 55;

  static const double zero = 0;
  static const EdgeInsets zeroInsets = EdgeInsets.zero;

  /// Minimum tap target (WCAG 2.5.5 / Material minimum) for any interactive
  /// control whose visible box is smaller than this — expand the hit-test
  /// region to this size while keeping the visible box unchanged. See
  /// A11Y-2, docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  static const double minTapTarget = 44;

  static const double contentPad = 20;
  static const double sectionGap = 20;
  static const double rowPy = 14;

  static const double inputHeight = 52;
  static const double ctaHeight = 52;
  static const double ctaLoadingIcon = 18;
  static const double ctaStrokeWidth = 2;
  static const double ctaElevationBlur = 16;
  static const double ctaElevationSpread = -4;
  static const double ctaElevationYOffset = 4;
  static const double buttonCompact = 34;
  static const double buttonStandard = 55;
  static const double hairlineStroke = 2;
  static const double dividerHairline = 1;
  static const double borderWidth = 1.5;
  static const double formFieldLabelGap = 6;
  static const double buttonHero = 89;

  static const double iconSm = 13;
  static const double iconMd = 21;
  static const double iconLg = 34;

  static const EdgeInsets contentInsets = EdgeInsets.symmetric(
    horizontal: contentPad,
  );

  static const double pageContentTopCompact = x3;
  static const double pageContentTopDefault = 12;
  static const double pageContentTopRelaxed = 16;
  static const double pageContentGapTight = x3;
  static const double pageContentGapDefault = 16;
  static const double pageContentGapRelaxed = 24;
  static const double pageContentGapLoose = 32;

  // Page rhythm — cross-app section / inner gaps (see VitPageRhythm).
  /// Feed / tab root: Home, Markets list, Predictions feed, Arena leaderboard.
  static const double pageRhythmCompactSectionGap = x3;

  /// Title → body on compact feed pages.
  static const double pageRhythmCompactInnerGap = x2;

  /// Standard scroll pages: Wallet, Profile, Earn, P2P lists.
  static const double pageRhythmStandardSectionGap = x4;

  /// Title → body on standard scroll pages.
  static const double pageRhythmStandardInnerGap = x3;

  /// Hero / onboarding / marketing blocks.
  static const double pageRhythmRelaxedSectionGap = pageContentGapRelaxed;

  /// Title → body on relaxed hero pages.
  static const double pageRhythmRelaxedInnerGap = x4;

  /// Long forms, wizards, KYC flows.
  static const double pageRhythmFormSectionGap = pageContentGapDefault;

  /// Label → field groups on form pages.
  static const double pageRhythmFormInnerGap = x3;

  static const double pageSectionAccentWidth = x1 + dividerHairline;
  static const double rowGap = 8;
  static const double pageSectionAccentHeight = rowPy;
  static const double pageSectionLabelGap = formFieldLabelGap;
  static const double pageSectionLabelBottomGap = rowGap;

  // Cross-app layout tokens (Vit* primitives, shared chrome).
  static const double sectionGapCompact = 13;
  static const double cardGap = sectionGapCompact;
  static const double sectionGapRegular = 21;
  static const double sectionGapRelaxed = 34;

  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(12);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPaddingHero = EdgeInsets.fromLTRB(20, 24, 20, 20);

  /// Fixed-height tile cards (recent product, market ticker strips).
  /// Pair with [VitCardContentAlign.center] on [VitCard].
  static const EdgeInsetsDirectional cardTilePadding =
      EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: x2);

  /// Row gap inside fixed-height tile cards (icon → title → subtitle).
  static const double cardTileInnerGap = pageRhythmCompactInnerGap;

  /// Module accent icon box ([VitAccentIconBox]) — list/bonus/task row icons.
  static const double accentIconBoxSize = buttonCompact;
  static const double accentIconFillAlpha = 0.14;
  static const double accentIconBorderAlpha = 0.24;

  /// Tier E task cards ([VitTaskCard]) — intrinsic-height mission list rows.
  static const EdgeInsets taskCardPadding = EdgeInsets.all(x4);
  static const double taskCardIconSize = accentIconBoxSize;
  static const double taskCardProgressHeight = x3;
  static const int taskCardSubtitleMaxLines = 3;
  static const double taskCardTitleSubtitleGap = x1;
  static const double taskCardProgressSectionGap = pageRhythmStandardSectionGap;
  static const double taskCardRewardRowGap = x3;
  static const double taskCardListGap = x3;

  static const double pageHorizontalPadding = contentPad;
  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(
    horizontal: pageHorizontalPadding,
  );
  static const double gridGap = 8;
  static const double rowGapCompact = rowGap;
  static const double rowGapRegular = 11;
  static const double rowGapRelaxed = 13;
  static const double bottomContentInset = 88;
  static const EdgeInsets bottomContentPadding = EdgeInsets.only(
    bottom: bottomContentInset,
  );
  static const double homeNativeShellCustomGap = 12;
  static const double searchBarCompactHeight = 44;
  static const double searchBarCompactFont = 13;
  static const double searchBarFont = 14;
  static const double searchBarHorizontalPadding = 12;
  static const double searchBarHorizontalTrailingPadding = 8;
  static const double searchBarFocusBorder = 1.5;
  static const double searchBarNormalBorder = 1;
  static const double searchBarIcon = 18;
  static const double tabBarPillVertical = 7;
  static const double tabBarPillRadius = 1;
  static const double tabBarUnderlineHeight = 2;
  static const double tabBarUnderlineWidth = 28;
  static const double statusPillHeightSm = 20;
  static const double statusPillHeightMd = 26;
  static const double statusPillHeightLg = 32;
  static const double statusPillGapSm = 3;
  static const double statusPillGapMd = 4;
  static const double statusPillGapLg = 5;
  static const double statusPillHorizontalPaddingSm = 6;
  static const double statusPillHorizontalPaddingMd = 10;
  static const double statusPillHorizontalPaddingLg = 12;
  static const double statusPillIconSizeSm = 10;
  static const double statusPillIconSizeMd = 12;
  static const double statusPillIconSizeLg = 14;
  static const double statusPillBadgeOffset = 3;
  static const double statusPillBadgeBlur = 4;
  static const double statusPillCountPadding = 3;
  static const double statusPillCountMinWidthFactor = 0.65;

  static const double serviceTileTopStripeHeight = 2;
  static const double serviceTileContentPadding = 8;
  static const double serviceTileContentPaddingCompact = 6;
  static const double serviceTileBadgeOffset = 2;
  static const double serviceTileBadgeMaxWidth = 52;
  // Wider than serviceTileBadgeMaxWidth: risk labels ('Rủi ro cao') run
  // longer than the single-word state labels (New/Hot/Pro) the narrower
  // badge was sized for.
  static const double serviceTileRiskBadgeMaxWidth = 76;
  static const double serviceTileBadgePaddingHorizontal = 5;
  static const double serviceTileBadgePaddingVertical = 2;
  static const double serviceTileBadgeFont = 8;
  // Clears corner badges for the centered icon + label stack (Tier B tiles).
  static const double serviceTileBadgeReserveVertical =
      serviceTileBadgePaddingVertical * 2 +
      serviceTileBadgeFont +
      serviceTileBadgeOffset;
  // Minimal horizontal nudge — not half badge width (over-shrinks the label cell).
  static const double serviceTileBadgeReserveHorizontal = x3;
  static const double serviceTileIconContainer = 26;
  static const double serviceTileIconContainerCompact = 22;
  static const double serviceTileIconSize = 20;
  static const double serviceTileIconSizeCompact = 16;
  static const double serviceTileGridAspectStandard = 1.42;
  static const double serviceTileGridAspectCompact = 1.40;
  static const double serviceTileLabelGap = 3;
  static const double serviceTileLabelGapCompact = 2;
  static const int serviceTileCrossAxisCount = 3;
  static const double serviceTileAccentBarThickness = 4;
  static const double serviceTileAccentBarHeight = 28;
  static const double serviceTileSectionBarHeight = 18;
  static const double serviceTileMinHeight = 54;
  static const double serviceTileCompactLabelHeight = 28;
  static const double bottomNavHorizontalInset = contentPad;
  static const double bottomNavCapsuleHeightNative = 56;
  static const double bottomNavCapsuleHeightVisual = 58;
  static const double bottomNavBottomGapNative = 8;
  static const double bottomNavBottomGapVisual = 20;
  static const double bottomNavHorizontalPadCompact = 3;
  static const double bottomNavHorizontalPad = 6;
  static const double bottomNavCenterButtonSizeNative = 50;
  static const double bottomNavCenterButtonSizeVisual = 54;
  static const double bottomNavCenterButtonTopNative = -18;
  static const double bottomNavCenterButtonTopVisual = -22;
  static const double bottomNavCenterLabelBottomOffsetNative = 4;
  static const double bottomNavCenterLabelBottomOffsetVisual = 2;
  static const double bottomNavCenterIconSize = 22;
  static const double bottomNavItemHeight = 52;
  static const double bottomNavActiveDotOffset = -5;
  static const double bottomNavActiveDotSize = 4;
  static const double bottomNavLabelGap = 2;
  static const double bottomNavBadgeMinWidth = 16;
  static const double bottomNavBadgeHeight = 16;
  static const double bottomNavBadgeHorizontalPadding = 4;
  static const double bottomNavBadgeFontSize = 9;
  static const double bottomNavBadgeTopOffset = -6;
  static const double bottomNavBadgeRightOffset = -10;
  static const double bottomNavBottomOffsetCompact = 2;
  static const double bottomNavBottomOffsetRegular = 4;
  static const double bottomNavSurfaceShadowBlur = 22;
  static const double bottomNavSurfaceShadowOffsetY = 10;
  static const double bottomNavPrimaryShadowBlur = 28;
  static const double bottomNavPrimaryShadowOffsetY = -1;
  static const double bottomNavCenterGlowBlur = 16;
  static const double bottomNavCenterGlowOffsetY = 4;
  static const double bottomNavCenterGlowWeakBlur = 32;
  static const double bottomNavActiveDotBlur = 8;

  static const double statusPillCountHeightFactor = 0.65;

  static const double vitPresetChipRowGap = x1;
  static const double vitPresetChipRowHeight = buttonCompact;
  static const EdgeInsets vitChoicePillCompactPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets vitChoicePillComfortablePadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets vitFilterChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const double sheetPanelMaxHeightFactor = 0.72;
  static const double inputPrefixIcon = 18;

  // Module-prefixed screen tokens migrated to lib/app/theme/spacing/ (finding #15, complete).
}
