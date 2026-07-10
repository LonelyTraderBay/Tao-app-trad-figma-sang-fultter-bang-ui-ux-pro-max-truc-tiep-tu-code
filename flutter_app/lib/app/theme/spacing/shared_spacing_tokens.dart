import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

/// Spacing/sizing tokens genuinely consumed outside their origin feature
/// module — by `lib/shared/widgets/**` and/or by other feature modules'
/// own presentation code or spacing-token files. Per
/// `Flutter-Module-Identity-Standard.md`'s Token Growth Policy, this is the
/// one place such cross-module tokens belong; a module-prefixed token file
/// (e.g. `HomeSpacingTokens`) should hold only values that module itself
/// (and no one else) consumes.
final class SharedSpacingTokens {
  const SharedSpacingTokens._();

  static const double walletAddressSwitchWidth = 48;
  static const double walletAddressSwitchHeight = 28;
  static const double walletAddressSwitchKnob = 22;
  static const EdgeInsets walletAddressSwitchKnobMargin = EdgeInsets.symmetric(
    horizontal: 2.5,
  );

  static const EdgeInsets tradeInstrumentHeroPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double tradeInstrumentHeroMetricGap = AppSpacing.x3;
  static const EdgeInsets tradeOrderRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );

  static const EdgeInsetsDirectional arenaCommunityRulesLinkPadding =
      EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      );
  static const double arenaCommunityRulesLinkIcon = AppSpacing.iconMd;
  // Mirrors ArenaSpacingTokens.arenaHomeFooterLineHeight (1.35). Duplicated
  // as a literal rather than referenced across modules because that
  // constant is still consumed internally by other Arena-only tokens.
  static const double arenaCommunityRulesLinkLineHeight = 1.35;

  static const double homeRecentProductHeight = 86;
  static const double homeRecentProductIcon = 28;
  static const double homeRecentProductIconText = 15;
  static const double homeDiscoveryIconContainer = 44;
  static const double homeDiscoveryIconSize = 20;
  static const EdgeInsets homeDiscoveryCompactPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const double homeDiscoveryCompactIconContainer = AppSpacing.x6;
  static const double homeDiscoveryCompactIconSize = 16;
  static const double homeMarketIconGap = 12;
  static const double homeSectionActionChevronSize = 16;
  static const double homeCoinAvatarSize = AppSpacing.x6;
  static const double homeChipMinHeight = 20;
  static const double homeChipHorizontalPadding = 7;
  static const double homeChipVerticalPadding = 4;
  static const double homeSectionHorizontalPadding = 16;
  static const double homeSectionVerticalPadding = 14;
  static const double homeSparklineWidth = 64;
  static const double homeSparklineHeight = 30;
  static const double homeRankedValueColumnWidth = 85;
  static const double homeNextActionCardPadding = 14;
  static const double homeNextActionIconContainer = 42;
  static const double homeNextActionIconSize = 20;
  static const double homeCommandRowSpacing = 12;

  /// Gap from section title to body and between stacked items in a section.
  static const double homeSectionInnerGap =
      AppSpacing.pageRhythmCompactInnerGap;
  static const double homeChevronGap = 4;
  static const double homeActionChevronSize = 18;
  static const double homePortfolioBadgeHorizontalPadding = 10;
  static const double homePortfolioBadgeVerticalPadding = 4;
  static const double homePortfolioBadgeIcon = 12;
  static const double homeMarketTickerStripGap = AppSpacing.x3;
  static const double homeMarketTickerCardWidth = 146;
  static const double homeMarketTickerCardMinHeight = 74;
  static const double homeSectionHeaderIconGap = 6;
  static const double homeSectionHeaderTitleLineHeight = 1.272;
  static const double homeSectionHeaderChevronSize = 14;
  static const double homeCardPaddingVerticalDefault = 10;
  static const double homeCardPaddingHorizontalDefault = 14;
  static const EdgeInsets homeCardPaddingDefault = EdgeInsets.symmetric(
    horizontal: homeCardPaddingHorizontalDefault,
    vertical: homeCardPaddingVerticalDefault,
  );
  static const EdgeInsets homeAnnouncementCardPaddingCompact =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const double homeAnnouncementIcon = 18;
  static const double homeAnnouncementIconGap = 12;
  static const double homeAnnouncementArrowGap = AppSpacing.x3;
  static const double homeAnnouncementChevron = 16;
  static const double homePortfolioHeaderIcon = 18;
  static const double homePortfolioHeaderActionPadding = 6;
  static const double homeAnnouncementDotGap = AppSpacing.x2;
  static const double homeAnnouncementDotActiveWidth = 16;
  static const double homeAnnouncementDotInactiveWidth = AppSpacing.x2;
  static const double homeAnnouncementDotHeight = AppSpacing.x2;
  static const double homeMoreProductsSheetHandleWidth = 36;
  static const double homeMoreProductsSheetHandleHeight = 4;
  static const double homeSectionCtaGap = 10;
  static const EdgeInsets homeMoreProductsSheetPadding = EdgeInsets.fromLTRB(
    homeSectionCtaGap,
    AppSpacing.x2,
    homeSectionCtaGap,
    homeSectionCtaGap,
  );
  static const double homeDividerHeight = 1;
  static const double homeHeroActionHeight = 44;

  /// Bottom scroll-content padding to clear the app's bottom nav bar.
  /// Applies when `ShellRenderMode.usesVisualQaFrame` is true (floating/visual
  /// nav state); the native-state counterpart is `bottomNavNativeClearance`.
  /// Reinvented independently as private per-page constants across
  /// launchpad/dca/earn/p2p/arena before being centralized here.
  static const double bottomNavVisualClearance = 112;
  static const double bottomNavNativeClearance = 88;
}
