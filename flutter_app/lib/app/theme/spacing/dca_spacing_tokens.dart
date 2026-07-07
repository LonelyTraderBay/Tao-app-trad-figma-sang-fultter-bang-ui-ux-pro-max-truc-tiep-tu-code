import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

final class DcaSpacingTokens {
  const DcaSpacingTokens._();

  static const double dcaMainInlineIcon = AppSpacing.searchBarIcon;
  static EdgeInsets dcaBottomInsetPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets dcaContentPadding = EdgeInsets.all(
    AppSpacing.contentPad,
  );
  static const EdgeInsets dcaPaddingX1 = EdgeInsets.all(AppSpacing.x1);
  static const EdgeInsets dcaPaddingX2 = EdgeInsets.all(AppSpacing.x2);
  static const EdgeInsets dcaPaddingX3 = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets dcaPaddingX4 = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets dcaPaddingX5 = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets dcaTopPaddingX1 = EdgeInsets.only(top: AppSpacing.x1);
  static const EdgeInsets dcaTopPaddingX2 = EdgeInsets.only(top: AppSpacing.x2);
  static const EdgeInsets dcaTopPaddingX3 = EdgeInsets.only(top: AppSpacing.x3);
  static const EdgeInsets dcaTopPaddingX4 = EdgeInsets.only(top: AppSpacing.x4);
  static const EdgeInsets dcaTopPaddingX5 = EdgeInsets.only(top: AppSpacing.x5);
  static const EdgeInsets dcaBottomPaddingX2 = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets dcaBottomPaddingX3 = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets dcaBottomPaddingX4 = EdgeInsets.only(
    bottom: AppSpacing.x4,
  );
  static const EdgeInsets dcaHorizontalPaddingX1 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
  );
  static const EdgeInsets dcaHorizontalPaddingX3 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets dcaVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets dcaVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets dcaChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets dcaTinyChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets dcaButtonChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets dcaScoreChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets dcaPrimaryChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets dcaMetricCellPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets dcaFrequencyTilePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets dcaSectionHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.x5,
    AppSpacing.x5,
    AppSpacing.x5,
    AppSpacing.x3,
  );
  static const EdgeInsets dcaChartPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    0,
    AppSpacing.x3,
    AppSpacing.x2,
  );
  static const EdgeInsets dcaChartFooterPadding = EdgeInsets.fromLTRB(
    AppSpacing.x5,
    0,
    AppSpacing.x5,
    AppSpacing.x4,
  );
  static EdgeInsets dcaBottomSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        0,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets dcaSheetMargin = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    0,
    AppSpacing.contentPad,
    AppSpacing.contentPad,
  );
  static const double dcaMainHeroAmountFontSize = 29;
  static const double dcaMainTightLineHeight =
      EarnSpacingTokens.savingsGoalMilestoneLineHeight;
  static const double dcaMainSparklineWidth = 96;
  static const double dcaMainStatCardHeight = 78;
  static const double dcaMainStatLabelLineHeight = 1.15;
  static const double dcaMainStatValueFontSize =
      EarnSpacingTokens.savingsConsumerProductRateFontSize;
  static const double dcaMainToolCardHeight = 98;
  static const double dcaMainToolIconBox =
      EarnSpacingTokens.earnWithdrawalProcessIconBox;
  static const double dcaMainToolIcon =
      EarnSpacingTokens.savingsConsumerProductRateFontSize;
  static const double dcaMainToolSubtitleLineHeight =
      EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight;
  static const double dcaMainPlanStatusBarHeight = AppSpacing.x1;
  static const double dcaMainActionHeight = AppSpacing.searchBarCompactHeight;
  static const double dcaMainAssetIconBox =
      EarnSpacingTokens.savingsNotificationTokenSwitchWidth;
  static const double dcaMainAssetIcon =
      EarnSpacingTokens.savingsConsumerHeroAmountFontSize + AppSpacing.x1;
  static const double dcaMainHistoryChartHeight =
      EarnSpacingTokens.stakingProductHistoryChartHeight;
  static const double dcaMultiTabIndicatorHeight = AppSpacing.hairlineStroke;
  static const double dcaMultiTabIndicatorWidth = 116;
  static const double dcaMultiTightLineHeight = dcaMainTightLineHeight;
  static const double dcaMultiIcon = dcaMainInlineIcon;
  static const double dcaMultiToggleWidth = 52;
  static const double dcaMultiToggleHeight = AppSpacing.statusPillHeightLg;
  static const double dcaMultiTogglePadding = AppSpacing.x1;
  static const double dcaMultiToggleThumb =
      EarnSpacingTokens.savingsLadderTimelineBarHeight;
  static const double dcaMultiAllocationChartHeight = 200;
  static const double dcaMultiLegendMarker =
      EarnSpacingTokens.stakingApiCopyIcon;
  static const double dcaMultiGrowthChartHeight = 240;
  static const double dcaMultiScoreFontSize =
      EarnSpacingTokens.savingsConsumerHeroAmountFontSize +
      AppSpacing.hairlineStroke;
  static const double dcaMultiScoreSuffixBottom = AppSpacing.x2;
  static const double dcaMultiProgressHeight =
      EarnSpacingTokens.savingsRebalanceTrackHeight;
  static const double dcaMultiDot = AppSpacing.statusPillIconSizeSm;
  static const double dcaRebalanceBodyLineHeight =
      EarnSpacingTokens.stakingTransactionReportingMethodLineHeight;
  static const double dcaRebalanceCompactLineHeight =
      EarnSpacingTokens.earnExportWarningLineHeight;
  static const double dcaRebalanceTightLineHeight = dcaMainTightLineHeight;
  static const double dcaRebalanceRingSize = 132;
  static const double dcaRebalanceIcon = dcaMainInlineIcon;
  static const double dcaRebalanceIconSm = AppSpacing.bottomNavBadgeMinWidth;
  static const double dcaRebalanceIconXs = AppSpacing.searchBarCompactFont;
  static const double dcaRebalanceConnectorWidth = AppSpacing.hairlineStroke;
  static const double dcaRebalanceTileIconBox = dcaMainToolIconBox;
  static const double dcaRebalanceToggleWidth = dcaMultiToggleWidth;
  static const double dcaRebalanceToggleHeight =
      AppSpacing.statusPillHeightLg - AppSpacing.hairlineStroke;
  static const double dcaRebalanceToggleThumb = dcaMultiToggleThumb;
  static const double dcaScheduleSectionIcon = dcaMainInlineIcon;
  static const double dcaScheduleSectionTitleFontSize = dcaMainInlineIcon;

  /// Deprecated: use [AppSpacing.accentIconBoxSize] for module accent icon boxes.
  static const double dcaScheduleAccentIconBox = 40;
  static const double dcaScheduleSelectedDot = dcaMultiToggleThumb;
  static const double dcaScheduleSelectedDotInner =
      EarnSpacingTokens.savingsGoalMilestoneFontSize;
  static const double dcaScheduleInfoFontSize =
      EarnSpacingTokens.stakingTaxDetailFontSize;
  static const double dcaScheduleSliderTrackHeight =
      EarnSpacingTokens.savingsRebalanceTrackHeight;
  static const double dcaSmartTabIndicatorHeight =
      AppSpacing.tabBarUnderlineHeight;
  static const double dcaSmartTabIndicatorWidth = dcaMultiTabIndicatorWidth;
  static const double dcaSmartStatsIconBox = 48;
  static const double dcaSmartStatsIcon =
      EarnSpacingTokens.savingsConsumerHeroAmountFontSize;
  static const double dcaSmartSectionFontSize = dcaMainInlineIcon;
  static const double dcaSmartInlineIcon = dcaMainInlineIcon;
  static const double dcaSmartButtonHeight = AppSpacing.statusPillHeightLg;
  static const double dcaSmartButtonIcon = AppSpacing.searchBarFont;
  static const double dcaSmartTinyIcon = EarnSpacingTokens.stakingApiCopyIcon;
  static const double dcaSmartBadgeLineHeight = dcaRebalanceTightLineHeight;
  static const double dcaOverviewMetaIcon = AppSpacing.searchBarFont;
  static const double dcaOverviewMetricIcon = AppSpacing.iconSm;
  static const double dcaOverviewMetricLabelLineHeight =
      dcaMainStatLabelLineHeight;
  static const double dcaOverviewInlineIcon = dcaMainInlineIcon;
  static const double dcaOverviewSectionTitleFontSize = dcaMainInlineIcon;
  static const double dcaOverviewHeroFontSize = 31;
  static const double dcaOverviewHeroLineHeight = dcaMainTightLineHeight;
  static const double dcaOverviewPreviewMaxWidth = 360;
  static const EdgeInsets dcaOverviewActionButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x3,
  );
  static const double dcaOverviewSkeletonTitleWidth = 160;
  static const double dcaOverviewSkeletonTitleHeight = AppSpacing.searchBarFont;
  static const double dcaOverviewSkeletonToggleSize = AppSpacing.iconMd;
  static const double dcaOverviewSkeletonChipWidth = 130;
  static const double dcaOverviewSkeletonMetaWidth = 60;
  static const double dcaOverviewSkeletonMetaHeight =
      EarnSpacingTokens.stakingTaxDetailFontSize;
  static const double dcaPerformanceCompareChartHeight = 240;
  static const double dcaPerformanceCompareProgressHeight =
      EarnSpacingTokens.savingsRebalanceTrackHeight;
  static const double dcaPerformanceCompareRadarHeight = 280;
  static const double dcaPerformanceCompareSmallIcon =
      EarnSpacingTokens.stakingApiCopyIcon;
  static const double dcaPerformanceCompareInlineIcon = dcaMainInlineIcon;
  static const double dcaPerformanceCompareTabIndicatorHeight =
      dcaSmartTabIndicatorHeight;
  static const double dcaPerformanceCompareTabIndicatorWidth =
      dcaSmartTabIndicatorWidth;
  static const double dcaPerformanceCompareLegendDot = AppSpacing.x3;
  static const double dcaPerformanceCompareRadarLabelMaxWidth = 90;
  static const double dcaDynamicCaptionLineHeight = 1.2;
  static const double dcaDynamicHistoryLineHeight = 1.25;
  static const double dcaDynamicBodyLineHeight = dcaRebalanceBodyLineHeight;
  static const double dcaDynamicDescriptionLineHeight = 1.5;
  static const double dcaDynamicExplainerLineHeight = 1.55;
  static const double dcaPortfolioOptimizerBodyLineHeight =
      dcaRebalanceCompactLineHeight;
  static const double dcaPortfolioOptimizerTightLineHeight =
      dcaRebalanceTightLineHeight;
  static const double dcaPortfolioOptimizerFrontierChartHeight = 220;
  static const double dcaPortfolioOptimizerFrontierChipListHeight = 64;
  static const double dcaPortfolioOptimizerFrontierChipWidth = 118;
  static const double dcaPortfolioOptimizerBacktestChartHeight = 210;
  static const double dcaPortfolioOptimizerDividerWidth =
      AppSpacing.hairlineStroke;
  static const int dcaPortfolioOptimizerRiskGridColumns = 2;
  static const double dcaPortfolioOptimizerRiskGridAspect = 1.25;
  static const double dcaBacktesterBodyLineHeight = dcaRebalanceBodyLineHeight;
}
