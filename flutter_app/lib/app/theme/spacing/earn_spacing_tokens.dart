import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

final class EarnSpacingTokens {
  const EarnSpacingTokens._();

  static const EdgeInsets earnHeroSecondaryPadding = EdgeInsets.only(
    left: AppSpacing.x4,
  );
  static const EdgeInsets earnPaddingX1 = EdgeInsets.all(AppSpacing.x1);
  static const EdgeInsets earnPaddingX2 = EdgeInsets.all(AppSpacing.x2);
  static const EdgeInsets earnPaddingX3 = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets earnPaddingX4 = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets earnPaddingX5 = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets earnPaddingX6 = EdgeInsets.all(AppSpacing.x6);
  static const EdgeInsets earnHorizontalPaddingX2 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );
  static const EdgeInsets earnHorizontalPaddingX3 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets earnHorizontalPaddingX4 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets earnPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets earnPillPaddingLarge = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets earnSmallPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets earnCardPaddingX5 = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets earnCardPaddingX4 = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets earnCardPaddingX3 = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets earnCardPaddingX4TopX5 = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x5,
    AppSpacing.x4,
    AppSpacing.x4,
  );
  static const EdgeInsets earnCardPaddingX4X3 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets earnCardPaddingX4X7 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x7,
  );
  static const EdgeInsets earnCardPaddingX2X3 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets earnCardPaddingX2X4 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets earnCardPaddingX3X2 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets earnCardPaddingX3X4 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets earnWidePillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets earnStaticSelectPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets earnVerticalPaddingX1 = EdgeInsets.symmetric(
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets earnVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets earnVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets earnVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets earnTopPaddingX1 = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets earnTopPaddingX2 = EdgeInsets.only(
    top: AppSpacing.x2,
  );
  static const EdgeInsets earnTopPaddingX3 = EdgeInsets.only(
    top: AppSpacing.x3,
  );
  static const EdgeInsets earnTopPaddingX4 = EdgeInsets.only(
    top: AppSpacing.x4,
  );
  static const EdgeInsets earnTopPaddingX5 = EdgeInsets.only(
    top: AppSpacing.x5,
  );
  static const EdgeInsets earnBottomPaddingX1 = EdgeInsets.only(
    bottom: AppSpacing.x1,
  );
  static const EdgeInsets earnBottomPaddingX2 = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets earnBottomPaddingX3 = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets earnContentMargin = EdgeInsets.all(
    AppSpacing.contentPad,
  );
  static const EdgeInsets earnContentHorizontalPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const EdgeInsets earnSheetContentPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x5,
    AppSpacing.contentPad,
    AppSpacing.x6,
  );
  static const EdgeInsets earnSurfaceTabsPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x4,
    AppSpacing.contentPad,
    AppSpacing.zero,
  );
  static const EdgeInsets earnInlineMarginX1 = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
  );
  static EdgeInsets earnLeftPaddingX2(bool enabled) =>
      EdgeInsets.only(left: enabled ? AppSpacing.x2 : AppSpacing.zero);
  static const EdgeInsets earnBulletTopMarginX3 = EdgeInsets.only(
    top: AppSpacing.x3,
  );
  static const EdgeInsets earnDisclosurePanelPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x3,
    AppSpacing.x4,
    AppSpacing.x4,
  );
  static const EdgeInsets earnDisclosureDetailsPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x4,
    AppSpacing.x4,
    AppSpacing.x3,
  );
  static EdgeInsets earnBottomInsetPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets earnSheetPadding(double bottomInset) => EdgeInsets.fromLTRB(
    AppSpacing.x5,
    AppSpacing.x4,
    AppSpacing.x5,
    bottomInset + AppSpacing.x6,
  );
  static const double earnTermsHeroIconBox = 48;
  static const double earnTermsHeroBorderWidth = AppSpacing.borderWidth;
  static const double earnTermsHeroIcon = 24;
  static const double earnTermsActionHeight = AppSpacing.searchBarCompactHeight;
  static const double earnTermsMetaIcon = AppSpacing.iconSm;
  static const double earnTermsNoticeIcon =
      ArenaSpacingTokens.arenaStudioSelectedIcon;
  static const double earnTermsSectionChevron =
      ArenaSpacingTokens.arenaPresetStepDot;
  static const double earnTermsParagraphLineHeight = 1.7;
  static const double earnTermsAcceptanceBox =
      ArenaSpacingTokens.arenaPresetStepDot;
  static const double earnTermsAcceptanceTopMargin =
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const double earnTermsAcceptanceIcon =
      ArenaSpacingTokens.arenaPresetHeaderIcon;
  static const double earnWithdrawalInfoMinHeight = 104;
  static const double earnWithdrawalTabMinHeight = 54;
  static const double earnWithdrawalBorderWidth = AppSpacing.borderWidth;
  static const double earnWithdrawalInfoIcon = earnTermsHeroIcon;
  static const double earnWithdrawalInfoLineHeight = 1.6;
  static const double earnWithdrawalProcessIconBox = 42;
  static const double earnWithdrawalProcessIcon = 21;
  static const double earnWithdrawalProcessLineHeight =
      ArenaSpacingTokens.arenaReportActionLineHeight;
  static const double earnWithdrawalTimelineMinHeight = 122;
  static const double earnWithdrawalTimelineMinHeightTall = 152;
  static const double earnWithdrawalTimelineValueLineHeight =
      ArenaSpacingTokens.arenaVerifiedFeatureLineHeight;
  static const double earnWithdrawalPenaltyBodyLineHeight = 1.65;
  static const double earnWithdrawalFormulaIcon =
      ArenaSpacingTokens.arenaGuideFeatureGlyph;
  static const double earnWithdrawalEmergencyIconBox = earnTermsHeroIconBox;
  static const double earnWithdrawalEmergencyStepBox = AppSpacing.buttonCompact;
  static const double earnWithdrawalEmergencyStepLineHeight =
      ArenaSpacingTokens.arenaVerifiedFeatureLineHeight;
  static const double earnWithdrawalTimerIcon =
      ArenaSpacingTokens.arenaSmartRuleSmallIcon;
  static const double earnWithdrawalFeeTileWidth = 174;
  static const double earnWithdrawalFeeTileMinHeight = 84;
  static const double earnWithdrawalFeeLineHeight =
      ArenaSpacingTokens.arenaStudioTemplateLineHeight;
  static const double earnWithdrawalSheetRadius = 28;
  static const double earnWithdrawalSheetHandleWidth = 42;
  static const double earnWithdrawalSheetHandleHeight = AppSpacing.x1;
  static const double earnWithdrawalSheetHandleRadius =
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const double earnWithdrawalNoticeIcon =
      ArenaSpacingTokens.arenaReportInlineIcon;
  static const double earnWithdrawalNoticeLineHeight =
      ArenaSpacingTokens.arenaGuideAccordionBodyLineHeight;
  static const double earnWithdrawalBulletTopPadding = 7;
  static const double earnWithdrawalBulletSize = 5;
  static const double earnWithdrawalBulletLineHeight =
      ArenaSpacingTokens.arenaReportActionLineHeight;
  static const double earnWithdrawalBadgePadV =
      ArenaSpacingTokens.arenaGuideSmallBadgePadV;
  static const double earnWithdrawalBadgeLineHeight =
      ArenaSpacingTokens.arenaStudioStepLabelLineHeight;
  static const EdgeInsets earnWithdrawalBulletPadding = EdgeInsets.only(
    top: earnWithdrawalBulletTopPadding,
  );
  static const EdgeInsets earnWithdrawalBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: earnWithdrawalBadgePadV,
  );
  static const double earnAnalyticsActionHeight =
      ArenaSpacingTokens.arenaSafetyIconBox;
  static const double earnAnalyticsSummaryIcon =
      ArenaSpacingTokens.arenaPresetHeaderIcon;
  static const double earnAnalyticsInlineIcon =
      ArenaSpacingTokens.arenaReportInlineIcon;
  static const double earnAnalyticsCaptionLineHeight =
      ArenaSpacingTokens.arenaStudioTemplateLineHeight;
  static const double earnAnalyticsEarningsChartHeight = 214;
  static const int earnAnalyticsGridColumns = 2;
  static const double earnAnalyticsAssetDot = AppSpacing.x2;
  static const double earnAnalyticsChartHeight = 220;
  static const double earnAnalyticsRoiFontSize = 19;
  static const double earnAnalyticsProgressMinHeight = 6;
  static const double earnAnalyticsAvatarBox = earnWithdrawalProcessIconBox;
  static const double earnAnalyticsInsightIcon =
      ArenaSpacingTokens.arenaStudioSelectedIcon;
  static const double earnAnalyticsInsightLineHeight =
      ArenaSpacingTokens.arenaVerifiedFeatureLineHeight;
  static const double earnAnalyticsFooterLineHeight =
      ArenaSpacingTokens.arenaReportActionLineHeight;
  static const double earnAnalyticsAxisWidth = earnWithdrawalProcessIconBox;
  static const double earnAnalyticsLegendMarkerWidth =
      AppSpacing.statusPillIconSizeSm;
  static const double earnAnalyticsLegendMarkerHeight =
      ArenaSpacingTokens.arenaBridgeTinyGap + AppSpacing.dividerHairline;
  static const double savingsWhatIfHeroIcon =
      ArenaSpacingTokens.arenaGuideFeatureGlyph;
  static const double savingsWhatIfBadgeIcon = AppSpacing.iconSm;
  static const double savingsWhatIfSectionMarkerWidth =
      ArenaSpacingTokens.arenaCreatorSectionMarkerWidth;
  static const double savingsWhatIfSectionMarkerHeight =
      ArenaSpacingTokens.arenaCreatorSectionMarkerHeight;
  static const double savingsWhatIfRiskPillPadV =
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const double savingsWhatIfRiskPillLineHeight =
      ArenaSpacingTokens.arenaBridgeHeroLineHeight;
  static const double savingsWhatIfRoundIconBox =
      ArenaSpacingTokens.arenaSafetyIconBox;
  static const double savingsWhatIfInlineIcon =
      ArenaSpacingTokens.arenaReportInlineIcon;
  static const double savingsWhatIfScoreRing =
      ArenaSpacingTokens.arenaCreatorAvatar;
  static const double savingsWhatIfLegendDot = 9;
  static const double savingsWhatIfAssetBadge = 31;
  static const double savingsWhatIfAssetFontSize = 8;
  static const double savingsWhatIfStressLabelWidth = 88;
  static const double savingsWhatIfStressProgressHeight = AppSpacing.x2;
  static const double savingsWhatIfStressValueWidth = 52;
  static const double savingsWhatIfEmptyIcon =
      AppSpacing.searchBarCompactHeight;
  static const double savingsWhatIfComparisonChartHeight = 150;
  static const double savingsRebalanceInlineIcon =
      ArenaSpacingTokens.arenaReportInlineIcon;
  static const double savingsRebalanceAssetBadge = 32;
  static const double savingsRebalanceLockIcon =
      ArenaSpacingTokens.arenaPresetHeaderIcon;
  static const double savingsRebalanceTrackHeight = 6;
  static const double savingsRebalanceIconBox =
      ArenaSpacingTokens.arenaSafetyIconBox;
  static const double savingsRebalanceIcon =
      ArenaSpacingTokens.arenaGuideFeatureGlyph;
  static const double savingsRebalanceDriftChartHeight = 160;
  static const double savingsRebalanceSelectedIcon =
      ArenaSpacingTokens.arenaSmartRuleIcon;
  static const double savingsRebalanceCompareLabelWidth = 74;
  static const double savingsRebalanceLegendDot = 7;
  static const double stakingRiskDisclosureWarningMinHeight = 144;
  static const double stakingRiskDisclosureBorderWidth = AppSpacing.borderWidth;
  static const double stakingRiskDisclosureWarningIcon = 26;
  static const double stakingRiskDisclosureBodyLineHeight =
      earnWithdrawalInfoLineHeight;
  static const double stakingRiskDisclosureTabsMinHeight =
      earnWithdrawalTabMinHeight;
  static const double stakingRiskDisclosureNoticeLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double stakingRiskDisclosureSummaryLineHeight =
      earnTermsParagraphLineHeight;
  static const double stakingRiskDisclosureCountMinHeight = 70;
  static const double stakingRiskDisclosureCompactLineHeight =
      ArenaSpacingTokens.myArenaReportsCompactLineHeight;
  static const double stakingRiskDisclosureProductMinHeight = 94;
  static const double stakingRiskDisclosureProductMinHeightTall = 125;
  static const double stakingRiskDisclosureCategoryIconBox =
      AppSpacing.searchBarCompactHeight;
  static const double stakingRiskDisclosureCategoryIcon =
      ArenaSpacingTokens.arenaPresetStepDot;
  static const double stakingRiskDisclosureDetailBulletTop =
      earnWithdrawalBulletTopPadding;
  static const EdgeInsets stakingRiskDisclosureDetailBulletPadding =
      EdgeInsets.only(top: stakingRiskDisclosureDetailBulletTop);
  static const double stakingRiskDisclosureDetailBullet =
      ArenaSpacingTokens.arenaCreatorSectionMarkerWidth;
  static const double stakingRiskDisclosureAssessmentIconBox =
      earnTermsHeroIconBox;
  static const double stakingRiskDisclosureAssessmentIcon = earnTermsHeroIcon;
  static const double stakingRiskDisclosureCtaHeight =
      AppSpacing.searchBarCompactHeight;
  static const double stakingRiskDisclosureSectionMarkerWidth =
      ArenaSpacingTokens.arenaCreatorSectionMarkerWidth;
  static const double stakingRiskDisclosureSectionMarkerHeight =
      ArenaSpacingTokens.arenaPresetHeaderIcon;
  static const double stakingRiskDisclosureSectionMarkerRadius =
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const double stakingRiskDashboardFooterLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double stakingRiskDashboardScoreRing = 128;
  static const double stakingRiskDashboardScoreBorderWidth = 4;
  static const double stakingRiskDashboardScoreFontSize = 36;
  static const double stakingRiskDashboardSummaryLineHeight =
      earnWithdrawalProcessLineHeight;
  static const double stakingRiskDashboardMetricLineHeight =
      ArenaSpacingTokens.arenaStudioTemplateLineHeight;
  static const double stakingRiskDashboardExposureChartHeight = 180;
  static const double stakingRiskDashboardExposurePieSize = 148;
  static const double stakingRiskDashboardEventLineHeight =
      ArenaSpacingTokens.arenaSafetyCheckLineHeight;
  static const int stakingRiskDashboardActionGridColumns = 2;
  static const double stakingRiskDashboardActionGridAspect = 1.55;
  static const double savingsLadderHeroDot = savingsRebalanceTrackHeight;
  static const double savingsLadderTemplateLineHeight = 1.25;
  static const double savingsLadderRungIndexBox =
      ArenaSpacingTokens.arenaGovernanceStepDefault;
  static const double savingsLadderAllocationProgressWidth = 96;
  static const double savingsLadderProgressHeight = savingsRebalanceTrackHeight;
  static const double savingsLadderTimelineLabelWidth = 58;
  static const double savingsLadderTimelineBarHeight = 24;
  static const double savingsLadderMaturityBadgeWidth =
      earnWithdrawalProcessIconBox;
  static const double savingsLadderMaturityBadgeHeight = 52;
  static const int savingsLadderMetricGridColumns = 2;
  static const double savingsLadderBreakdownDot = savingsWhatIfLegendDot;
  static const double savingsLadderLiquidityRing = 66;
  static const double savingsLadderLiquidityLineHeight =
      ArenaSpacingTokens.arenaPresetCaptionLineHeight;
  static const double savingsLadderSectionMarkerWidth =
      ArenaSpacingTokens.arenaCreatorSectionMarkerWidth;
  static const double savingsLadderSectionMarkerHeight =
      ArenaSpacingTokens.arenaPresetHeaderIcon;
  static const double savingsLadderRoundIcon =
      ArenaSpacingTokens.arenaSafetyIconBox;
  static const double savingsLadderDisclaimerLineHeight =
      ArenaSpacingTokens.arenaStudioTemplateLineHeight;
  static const double savingsLadderSheetRadius = 24;
  static const double savingsNotificationSummaryBorderWidth =
      AppSpacing.borderWidth;
  static const double savingsNotificationSummaryLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double savingsNotificationCardLineHeight =
      ArenaSpacingTokens.arenaSafetyCheckLineHeight;
  static const double savingsNotificationAlertLineHeight = 1.32;
  static const double savingsNotificationHistoryTitleLineHeight =
      savingsLadderTemplateLineHeight;
  static const double savingsNotificationHistoryBodyLineHeight =
      ArenaSpacingTokens.arenaReportActionLineHeight;
  static const double savingsNotificationIconBox = 40;
  static const double savingsNotificationSummaryIconBox =
      AppSpacing.searchBarCompactHeight;
  static const double savingsNotificationSummaryIcon = 22;
  static const double savingsNotificationInlineIcon =
      ArenaSpacingTokens.arenaReportInlineIcon;
  static const double savingsNotificationAlertIcon = 19;
  static const double savingsNotificationActionIcon = 20;
  static const double savingsNotificationSeverityPadV =
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const double savingsNotificationSwitchWidth =
      AppSpacing.searchBarCompactHeight;
  static const double savingsNotificationSwitchHeight =
      savingsLadderTimelineBarHeight;
  static const double savingsNotificationSwitchPadding =
      savingsNotificationSeverityPadV + ArenaSpacingTokens.arenaBridgeTinyGap;
  static const EdgeInsets savingsNotificationSwitchInset = EdgeInsets.all(
    savingsNotificationSwitchPadding,
  );
  static const double savingsNotificationSwitchThumb =
      ArenaSpacingTokens.arenaPresetHeaderIcon;
  static const double savingsNotificationTokenSwitchWidth = 46;
  static const double savingsNotificationTokenSwitchHeight =
      AppSpacing.statusPillHeightMd;
  static const double savingsNotificationTokenSwitchPadding =
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const EdgeInsets savingsNotificationTokenSwitchInset = EdgeInsets.all(
    savingsNotificationTokenSwitchPadding,
  );
  static const double savingsNotificationTokenSwitchThumb =
      AppSpacing.bottomNavBadgeMinWidth + savingsNotificationSeverityPadV * 2;
  static const double stakingEmergencySheetBodyLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double stakingEmergencyActionLineHeight =
      ArenaSpacingTokens.arenaReportActionLineHeight;
  static const double stakingEmergencyUseCaseIcon =
      ArenaSpacingTokens.arenaPresetHeaderIcon +
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const double stakingInsuranceTabIndicatorHeight =
      AppSpacing.tabBarUnderlineHeight;
  static const double stakingInsuranceShieldIconBox = 60;
  static const double stakingInsuranceShieldBorderWidth =
      AppSpacing.hairlineStroke;
  static const int stakingInsuranceBenefitGridColumns = 2;
  static const double stakingInsuranceBenefitGridAspect =
      stakingRiskDashboardActionGridAspect;
  static const double stakingProofInfoLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double stakingProofTabIndicatorHeight =
      AppSpacing.tabBarUnderlineHeight;
  static const double stakingProofTrendChartHeight = 210;
  static const double stakingProofBodyLineHeight =
      ArenaSpacingTokens.arenaReportActionLineHeight;
  static const double stakingProofReportLineHeight =
      earnWithdrawalProcessLineHeight;
  static const double stakingProofProgressRing = 160;
  static const double stakingProofProgressBorderWidth = AppSpacing.x1;
  static const double stakingProofExternalIcon =
      ArenaSpacingTokens.arenaSmartRuleIcon;
  static const double earnGuideProgressHeight = earnAnalyticsProgressMinHeight;
  static const double earnGuideParagraphLineHeight = 1.65;
  static const double earnGuideHeroLineHeight = stakingProofInfoLineHeight;
  static const double earnGuideCardLineHeight =
      stakingRiskDashboardMetricLineHeight;
  static const double earnGuideBodyLineHeight =
      stakingEmergencyActionLineHeight;
  static const double earnGuideTipLineHeight = stakingProofReportLineHeight;
  static const double earnGuideBulletTop = earnWithdrawalBulletTopPadding;
  static const double earnGuideBulletSize =
      ArenaSpacingTokens.arenaCreatorSectionMarkerWidth;
  static const double earnGuidePillLineHeight = 1;
  static const double earnFaqQuestionLineHeight =
      savingsLadderTemplateLineHeight;
  static const double earnFaqAnswerLineHeight = earnWithdrawalInfoLineHeight;
  static const double earnFaqDividerHeight = AppSpacing.dividerHairline;
  static const double savingsAutoPilotApprovalButtonHeight =
      savingsNotificationIconBox;
  static const int savingsAutoPilotMetricGridColumns = 2;
  static const double savingsAutoPilotMetricGridAspect = 1.95;
  static const double savingsAutoPilotRiskProgressHeight =
      earnWithdrawalBulletSize;
  static const double savingsAutoPilotIconBadge = savingsNotificationIconBox;
  static const double savingsAutoPilotSectionMarkerWidth = earnGuideBulletSize;
  static const double savingsAutoPilotSectionMarkerHeight =
      AppSpacing.iconSm + earnWithdrawalBulletSize;
  static const double savingsPortfolioHeroFontSize = 27;
  static const double savingsPortfolioEarningsFontSize = 30;
  static const double savingsPortfolioHeroIconButton = 32;
  static const double savingsPortfolioActionHeight =
      AppSpacing.searchBarCompactHeight;
  static const double savingsPortfolioSectionMarkerWidth = earnGuideBulletSize;
  static const double savingsPortfolioSectionMarkerHeight =
      AppSpacing.iconSm + AppSpacing.x1;
  static const double savingsPortfolioDaysLineHeight = 1.1;
  static const double savingsPortfolioSecondaryButtonHeight = 38;
  static const double savingsPortfolioDonutHeight = 150;
  static const double savingsPortfolioDonutDiameter = 116;
  static const double savingsPortfolioDonutStrokeWidth =
      AppSpacing.statusPillHeightMd;
  static const double savingsPortfolioAllocationDot = AppSpacing.iconSm;
  static const double savingsPortfolioAllocationPercentWidth =
      earnWithdrawalProcessIconBox;
  static const double stakingTaxWarningIcon = savingsNotificationInlineIcon;
  static const double stakingTaxWarningLineHeight = stakingProofInfoLineHeight;
  static const double stakingTaxFooterLineHeight = earnFaqAnswerLineHeight;
  static const double stakingTaxOverviewLineHeight =
      earnTermsParagraphLineHeight;
  static const double stakingTaxDetailFontSize = 12;
  static const double stakingTaxEventLineHeight = stakingProofInfoLineHeight;
  static const double stakingTaxExampleLineHeight =
      stakingProofReportLineHeight;
  static const double stakingTaxToolIcon = savingsNotificationSummaryIcon;
  static const double stakingTaxExternalIcon = stakingProofExternalIcon;
  static const double stakingTaxCalculatorIconBox = 50;
  static const double stakingTaxBorderWidth = AppSpacing.borderWidth;
  static const double stakingTaxCalculatorIcon = AppSpacing.statusPillHeightMd;
  static const double stakingTaxResultFontSize = AppSpacing.searchBarFont;
  static const double stakingTaxResultFontSizeLarge =
      ArenaSpacingTokens.arenaSmartRuleIcon;
  static const double stakingTaxJurisdictionMetricMinHeight = 96;
  static const double stakingTaxJurisdictionMetricLineHeight =
      ArenaSpacingTokens.arenaSafetyCheckLineHeight;
  static const double stakingTaxResourceIcon =
      AppSpacing.iconSm + ArenaSpacingTokens.arenaBridgeTinyGap * 2;
  static const double stakingTaxResourceExternalIcon =
      ArenaSpacingTokens.arenaPresetHeaderIcon;
  static const double stakingTaxDisclaimerMinHeight = 136;
  static const double stakingTaxTabsMinHeight =
      stakingRiskDisclosureTabsMinHeight;
  static const double stakingTaxDisclaimerIcon = earnTermsHeroIcon;
  static const double stakingTaxCodeBadgeSmall = savingsLadderTimelineBarHeight;
  static const double stakingTaxCodeBadgeRegular = 36;
  static const double stakingTaxCodeBadgeLarge = earnTermsHeroIconBox;
  static const double stakingTaxCodeFontSmall = AppSpacing.statusPillIconSizeSm;
  static const double stakingTaxCodeFontRegular = AppSpacing.searchBarFont;
  static const double stakingTaxCodeFontLarge =
      ArenaSpacingTokens.arenaSmartRuleIcon;
  static const double stakingGovernanceVotingPowerFontSize =
      AppSpacing.statusPillHeightMd;
  static const double stakingGovernancePillLineHeight = earnGuidePillLineHeight;
  static const double stakingGovernanceInfoLineHeight =
      stakingProofInfoLineHeight;
  static const int stakingGovernanceGridColumns = 2;
  static const double stakingGovernanceGridAspect = 1.75;
  static const double stakingGovernanceStatFontSize =
      savingsNotificationTokenSwitchThumb;
  static const double stakingGovernanceDividerHeight =
      AppSpacing.dividerHairline;
  static const double stakingGovernanceStepLineHeight = earnGuideBodyLineHeight;
  static const double stakingRegulatoryBodyLineHeight =
      stakingProofInfoLineHeight;
  static const double stakingRegulatoryNoteLineHeight = earnGuideBodyLineHeight;
  static const double stakingRegulatoryFooterLineHeight =
      stakingProofReportLineHeight;
  static const double stakingRegulatoryIconBox = savingsNotificationIconBox;
  static const double stakingRegulatoryContactDividerHeight =
      savingsLadderTimelineBarHeight;
  static const double stakingAssessmentScoreRing = 120;
  static const double stakingAssessmentScoreBorderWidth = AppSpacing.x1;
  static const double stakingAssessmentBodyLineHeight =
      stakingProofInfoLineHeight;
  static const double stakingAssessmentFooterLineHeight =
      stakingProofReportLineHeight;
  static const double stakingAssessmentQuestionFontSize =
      savingsNotificationInlineIcon;
  static const double stakingAssessmentQuestionLineHeight =
      stakingRiskDashboardMetricLineHeight;
  static const double stakingAssessmentOptionBorderWidth =
      AppSpacing.borderWidth;
  static const double stakingAssessmentOptionLineHeight = 1.3;
  static const double stakingAssessmentHelpLineHeight = earnGuideBodyLineHeight;
  static const double stakingRiskScoreBorderWidth =
      stakingRiskDashboardScoreBorderWidth;
  static const double stakingRiskScorePillIcon = stakingEmergencyUseCaseIcon;
  static const double stakingRiskScoreRadarHeight = earnAnalyticsChartHeight;
  static const double stakingNotificationsSwitchWidth = earnTermsHeroIconBox;
  static const double stakingNotificationsSwitchHeight =
      AppSpacing.statusPillHeightMd;
  static const double stakingNotificationsSwitchPadding =
      savingsNotificationSwitchPadding;
  static const double stakingNotificationsSwitchThumb =
      savingsNotificationInlineIcon;
  static const double stakingNotificationsLineHeight = earnGuideBodyLineHeight;
  static const double stakingNotificationsPillLineHeight =
      earnGuidePillLineHeight;
  static const double stakingHistoryDetailLabelWidth =
      savingsWhatIfStressLabelWidth;
  static const double stakingHistoryIconBox = savingsNotificationIconBox;
  static const double stakingHistoryIcon = savingsNotificationTokenSwitchThumb;
  static const double stakingHistoryPillPadV = AppSpacing.x1;
  static const double stakingHistoryPillLineHeight = earnGuidePillLineHeight;
  static const double stakingHistoryFooterLineHeight =
      stakingProofReportLineHeight;
  static const double stakingAuditBodyLineHeight = stakingProofInfoLineHeight;
  static const int stakingAuditPayoutGridColumns = 2;
  static const double stakingAuditPayoutGridAspect = 2.55;
  static const double stakingAuditFooterLineHeight =
      stakingProofReportLineHeight;
  static const double stakingAuditRoundIconBox = earnTermsHeroIconBox;
  static const double earnExportHeroStatFontSize = AppSpacing.x6;
  static const double earnExportTitleMarkerWidth =
      ArenaSpacingTokens.arenaBridgeTinyGap;
  static const double earnExportTitleMarkerHeight =
      AppSpacing.statusPillIconSizeLg + AppSpacing.dividerHairline;
  static const double earnExportFormatIcon = earnTermsHeroIcon;
  static const double earnExportCardLineHeight =
      savingsLadderTemplateLineHeight;
  static const double earnExportDescriptionLineHeight =
      stakingAssessmentOptionLineHeight - 0.02;
  static const double earnExportWarningLineHeight =
      stakingRiskDashboardActionGridAspect - 0.2;
  static const double earnExportSelectionDot = savingsNotificationActionIcon;
  static const double earnExportSelectionDotInner =
      AppSpacing.statusPillIconSizeSm;
  static const double stakingDataExportBodyLineHeight =
      stakingProofInfoLineHeight;
  static const int stakingDataExportGridColumns = 2;
  static const double stakingDataExportGridAspect =
      savingsAutoPilotMetricGridAspect;
  static const double stakingDataExportQuickIcon =
      savingsNotificationActionIcon;
  static const double stakingTransactionReportingBodyLineHeight =
      stakingProofInfoLineHeight;
  static const double stakingTransactionReportingCardMinHeight =
      earnWithdrawalFeeTileMinHeight;
  static const double stakingTransactionReportingTabIndicatorHeight =
      AppSpacing.tabBarUnderlineHeight;
  static const double stakingTransactionReportingDividerHeight =
      AppSpacing.dividerHairline;
  static const double stakingTransactionReportingMetricLineHeight =
      stakingRiskDashboardActionGridAspect - 0.05;
  static const double stakingTransactionReportingMethodLineHeight =
      stakingRiskDashboardActionGridAspect - 0.1;
  static const double stakingTransactionReportingNoticeLineHeight =
      stakingProofReportLineHeight;
  static const double savingsGoalHeroProgressRing = 76;
  static const double savingsGoalHeroProgressStroke = AppSpacing.x2;
  static const double savingsGoalCardProgressRing = 52;
  static const double savingsGoalCardProgressStroke =
      ArenaSpacingTokens.arenaBridgeTinyGap + AppSpacing.dividerHairline;
  static const double savingsGoalDetailProgressRing =
      earnWithdrawalFeeTileMinHeight;
  static const double savingsGoalDetailProgressStroke =
      savingsRebalanceTrackHeight;
  static const double savingsGoalTimelineDividerHeight =
      AppSpacing.dividerHairline;
  static const double savingsGoalMilestoneBorderWidth = AppSpacing.borderWidth;
  static const double savingsGoalMilestoneFontSize = 7;
  static const double savingsGoalMilestoneLineHeight = 1;
  static const double savingsGoalTipFontSize = 12;
  static const double savingsBacktestSectionMarkerWidth =
      earnExportTitleMarkerWidth;
  static const double savingsBacktestSectionMarkerHeight =
      earnExportTitleMarkerHeight;
  static const double savingsBacktestAllocationRing = 86;
  static const double savingsBacktestLegendDot = 9;
  static const double savingsBacktestProgressHeight = 7;
  static const double savingsBacktestGrowthChartHeight = 150;
  static const double savingsBacktestWarningLineHeight =
      earnExportWarningLineHeight;
  static const double savingsBacktestSelectionDot = earnExportSelectionDot;
  static const double savingsBacktestSelectionDotInner =
      earnExportSelectionDotInner;
  static const double savingsRecommendationsMatrixLabelWidth =
      savingsGoalHeroProgressRing;
  static const double savingsRecommendationsBulletTop = 7;
  static const EdgeInsets savingsRecommendationsBulletPadding = EdgeInsets.only(
    top: savingsRecommendationsBulletTop,
  );
  static const double savingsRecommendationsItemLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double savingsRecommendationsInsightLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double savingsRecommendationsNoteLineHeight =
      stakingTransactionReportingBodyLineHeight;
  static const double savingsRecommendationsDividerHeight =
      AppSpacing.dividerHairline;
  static const double savingsRecommendationsAssetLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double autoCompoundSettingsWarningLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double autoCompoundSettingsBodyLineHeight =
      stakingTransactionReportingBodyLineHeight;
  static const double autoCompoundSettingsInfoLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double autoCompoundSettingsSwitchWidth =
      savingsNotificationSwitchWidth;
  static const double autoCompoundSettingsSwitchHeight =
      savingsNotificationSwitchHeight;
  static const double autoCompoundSettingsAssetLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double autoCompoundSettingsDividerHeight =
      AppSpacing.dividerHairline;
  static const double stakingAutoCompoundPlanBorderWidth =
      AppSpacing.borderWidth;
  static const double stakingAutoCompoundChartHeight = 190;
  static const double stakingAutoCompoundAxisFontSize = 9;
  static const double stakingAutoCompoundResultMarkerHeight =
      AppSpacing.hairlineStroke;
  static const double stakingAutoCompoundHeroStatFontSize =
      savingsPortfolioEarningsFontSize;
  static const double stakingAutoCompoundHeroIconBorderWidth = AppSpacing.x1;
  static const double stakingAutoCompoundCheckBorderWidth =
      AppSpacing.borderWidth;
  static const double stakingAutoCompoundToggleWidth = earnTermsHeroIconBox;
  static const double stakingAutoCompoundToggleHeight =
      AppSpacing.statusPillHeightMd + AppSpacing.hairlineStroke;
  static const double stakingEarnHeroAmountFontSize = earnTermsHeroIcon;
  static const double stakingEarnHeroActiveFontSize =
      savingsNotificationActionIcon;
  static const double stakingEarnHeroCaptionFontSize = stakingTaxDetailFontSize;
  static const double stakingEarnHeroTabLabelLineHeight = 1.2;
  static const double stakingEarnPositionTitleLineHeight = 1.2;
  static const double stakingEarnPositionCaptionLineHeight = 1.2;
  static const double stakingEarnPositionMetricLabelLineHeight = 1.15;
  static const double stakingEarnPositionMetricValueLineHeight = 1.2;
  static const double stakingEarnPositionAssetBadgeLineHeight = 1;
  static const double stakingCustodyActionIconBox = 64;
  static const double stakingCustodyActionIcon = AppSpacing.x6;
  static const double stakingCustodyActionBorderWidth = AppSpacing.borderWidth;
  static const double stakingCustodyFooterLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingCustodyBodyLineHeight =
      stakingTransactionReportingBodyLineHeight;
  static const double stakingCustodyMetricValueLineHeight =
      savingsLadderTemplateLineHeight;
  static const double stakingCustodyDescriptionLineHeight = 1.4;
  static const double stakingCustodyStatusDot = savingsRebalanceTrackHeight;
  static const double stakingCustodySegregationChart =
      stakingAutoCompoundChartHeight;
  static const double stakingCustodyHotColdChart = 170;
  static const int stakingCustodyMetricGridColumns = 2;
  static const double stakingCustodyMetricGridAspect =
      savingsAutoPilotMetricGridAspect;
  static const double stakingContingencyBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const int stakingContingencyMetricGridColumns = 2;
  static const double stakingContingencyMetricGridAspect =
      stakingAuditPayoutGridAspect;
  static const double stakingContingencyResponseLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double stakingContingencyExternalIcon =
      savingsNotificationAlertIcon - AppSpacing.hairlineStroke;
  static const double stakingContingencyFooterLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingSlashingBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const int stakingSlashingStatsGridColumns = 2;
  static const double stakingSlashingStatsGridAspect = 1.65;
  static const double stakingSlashingMeasureLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double stakingSlashingTabIndicatorHeight =
      AppSpacing.tabBarUnderlineHeight;
  static const double stakingSlashingFooterLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingApiBodyLineHeight = stakingCustodyBodyLineHeight;
  static const double stakingApiStatTileHeight = 66;
  static const double stakingApiTabIndicatorHeight =
      AppSpacing.tabBarUnderlineHeight;
  static const double stakingApiCopyIcon = stakingTaxDetailFontSize;
  static const double stakingApiFooterLineHeight = stakingCustodyBodyLineHeight;
  static const double stakingApiEndpointBodyLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingApiEndpointDescriptionLineHeight =
      stakingCustodyDescriptionLineHeight;
  static const double stakingApiDividerHeight = AppSpacing.dividerHairline;
  static const double stakingApiSandboxLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double stakingIntegrationBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingDeveloperConsoleBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double savingsHistoryFilterButton = 38;
  static const double savingsHistoryTransactionIcon = AppSpacing.searchBarIcon;
  static const double savingsHistoryMetaFontSize = stakingTaxDetailFontSize;
  static const double savingsHistoryBadgeLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double savingsHistoryDividerHeight = AppSpacing.dividerHairline;
  static const double stakingEarningsEventIcon = savingsNotificationAlertIcon;
  static const double stakingEarningsPillLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double stakingEarningsInfoLineHeight =
      earnExportWarningLineHeight;
  static const double stakingEarningsTabHeight = 53;
  static const int stakingEarningsCalendarColumns = 7;
  static const double stakingEarningsEventDotGap = AppSpacing.hairlineStroke;
  static const double stakingEarningsLegendWidth = 148;
  static const double stakingValidatorHealthBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingValidatorHealthDividerHeight =
      AppSpacing.dividerHairline;
  static const double stakingValidatorHealthTrendHeight = 196;
  static const double stakingValidatorHealthFooterLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingRecommendationsAssetLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double stakingRecommendationsDescriptionLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double stakingRecommendationsBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingRecommendationsBulletTop =
      savingsRecommendationsBulletTop;
  static const EdgeInsets stakingRecommendationsBulletPadding = EdgeInsets.only(
    top: stakingRecommendationsBulletTop,
  );
  static const double stakingRecommendationsBulletLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingValidatorSelectionSearchIcon =
      savingsNotificationActionIcon;
  static const double stakingValidatorSelectionBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingValidatorSelectionIcon = earnTermsHeroIcon;
  static const double stakingValidatorSelectionDividerHeight =
      AppSpacing.dividerHairline;
  static const double stakingValidatorSelectionPillLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double stakingValidatorSelectionDetailLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingProductMetricFontSize =
      savingsPortfolioEarningsFontSize;
  static const double stakingProductTabIndicatorHeight =
      AppSpacing.tabBarUnderlineHeight;
  static const double stakingProductDividerHeight = AppSpacing.dividerHairline;
  static const double stakingProductBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingProductCompactBodyLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingProductDonutChartHeight =
      stakingCustodyHotColdChart;
  static const double stakingProductHistoryChartHeight =
      earnAnalyticsChartHeight;
  static const double stakingProductLegendWidth = 160;
  static const double stakingProductIconBorderWidth = AppSpacing.hairlineStroke;
  static const int stakingProductGridColumns = 2;
  static const double stakingProductLiquidBenefitAspect = 1.35;
  static const double stakingProductInstitutionalFeatureAspect =
      stakingRiskDashboardActionGridAspect;
  static const double savingsConsumerHeroAmountFontSize =
      AppSpacing.statusPillHeightMd;
  static const double savingsConsumerCaptionFontSize = stakingTaxDetailFontSize;
  static const double savingsConsumerProductRateFontSize =
      savingsNotificationSummaryIcon;
  static const double savingsConsumerActionHeight = stakingTaxCodeBadgeRegular;
  static const double savingsConsumerStatFontSize =
      savingsPortfolioHeroIconButton;
  static const double savingsConsumerDividerHeight = AppSpacing.dividerHairline;
  static const double savingsConsumerPillLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double savingsConsumerBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double savingsConsumerCompactBodyLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double savingsConsumerDescriptionLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double savingsConsumerBorderWidth = AppSpacing.borderWidth;
  static const double savingsConsumerYieldChartHeight = 226;
  static const double savingsConsumerMonthlyChartHeight = 184;
  static const double savingsConsumerChartLabelLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double stakingCommunityBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingCommunityDescriptionLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double stakingCommunityPillLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double stakingCommunityDividerHeight =
      AppSpacing.dividerHairline;
  static const double stakingCommunityProductCaptionFontSize =
      stakingTaxDetailFontSize;
  static const double stakingCommunityProductRateFontSize =
      savingsNotificationSummaryIcon;
  static const int stakingCommunityGridColumns = 2;
  static const double stakingCommunityPositionsGridAspect = 2.7;
  static const double stakingCommunityForumGridAspect = 2.9;
  static const double stakingCommunityFaqQuestionLineHeight =
      earnExportWarningLineHeight;
  static const double stakingCommunityFaqAnswerLineHeight =
      earnGuideParagraphLineHeight;
  static const double savingsFlowHeroHeight =
      AppSpacing.searchBarCompactHeight + AppSpacing.dividerHairline;
  static const double savingsGoalSheetTitleLineHeight =
      stakingEarnHeroTabLabelLineHeight;
  static const double savingsLadderGridAspect = 1.72;
  static const double stakingApiAuthLineHeight =
      stakingApiEndpointBodyLineHeight;
  static const double stakingSlashingStatsChartHeight = 172;
  static const double stakingAnalyticsMetricGridAspect =
      stakingAuditPayoutGridAspect;
}
