// DEBT-89 (A-Plus GD3): tach tu trade_spacing_tokens.dart (2261 dong) —
// literal cua khu Trading Bots; facade TradeSpacingTokens giu alias cung ten nen
// call site khong doi. Const co tham chieu xuyen nhom van o lai facade.
import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

final class TradeBotsSpacingTokens {
  const TradeBotsSpacingTokens._();

  static const EdgeInsets tradeBotHeroSecondaryPadding = EdgeInsets.only(
    left: AppSpacing.x4,
  );
  static const EdgeInsets tradeBotFaqAnswerPadding = EdgeInsets.fromLTRB(
    tradeBotQuestionIconBox + AppSpacing.x3,
    0,
    AppSpacing.x3,
    AppSpacing.x3,
  );
  static const double tradeBottomInsetVisual = 54;
  static const double tradeBottomInsetNative = 20;
  static const double tradeBotBottomInsetVisual = 92;
  static const double tradeBotBottomInsetNative = 28;
  static const double tradeBotFooterBottomInsetVisual = 128;
  static const double tradeBotFooterBottomInsetNative = 96;
  static const double tradeBotTinyGap = 5;
  static const double tradeBotHairline = AppSpacing.dividerHairline;
  static const double tradeBotSectionMarkerWidth = 4;
  static const double tradeBotNoticeIconTop = 1;
  static const double tradeBotIntroIconTop = 2;
  static const double tradeBotRecordIconTop = 4;
  static const double tradeBotCardIconGap = 12;
  static const double tradeBotInlineIconGap = 8;
  static const double tradeBotMetricGap = 5;
  static const double tradeBotLabelGap = 7;
  static const double tradeBotDisclosureGap = 9;
  static const double tradeBotStatusGap = 14;
  static const double tradeBotControlHeight = 46;
  static const double tradeBotControlTall = 82;
  static const double tradeBotControlCompact = 44;
  static const double tradeBotLanguageTabWidth = 86;
  static const double tradeBotFooterButtonHeight = 42;
  static const double tradeBotMethodTextIndent = 25;
  static const double tradeBotSelectionDot = 16;
  static const double tradeBotSelectionDotInner = 8;
  static const double tradeBotCardIcon = 21;
  static const double tradeBotHeroIcon = 25;
  static const double tradeBotProgressHeight = 8;
  static const double tradeBotScoreProgressHeight = 12;
  static const double tradeBotCompactProgressHeight = 6;
  static const int tradeBotGridColumns = 2;
  static const double tradeBotGridAspectRatio = 1.47;
  static const double tradeBotStrategyGridAspectRatio = 2.36;
  static const double tradeBotAnalyticsMetricAspectRatio = 1.05;
  static const double tradeBotPortfolioMetricAspectRatio = 1.18;
  static const double tradeBotRiskMetricAspectRatio = 1.26;
  static const double tradeBotCriticalMetricAspectRatio = 1.85;
  static const double tradeBotEquityPerformanceAspectRatio = 2.85;
  static const double tradeBotAllocationLegendAspectRatio = 4.8;
  static const double tradeBotResultIconBox = 96;
  static const double tradeBotResultIcon = 48;
  static const double tradeBotQuestionIconBox = 40;
  static const double tradeBotQuestionIcon = 20;
  static const double tradeBotOptionMinHeight = 58;
  static const double tradeBotSecurityCardMinHeight = 72;
  static const double tradeBotApiKeyCardMinHeight = 114;
  static const double tradeBotIpCardMinHeight = 63;
  static const double tradeBotAnalyticsChartHeight = 220;
  static const double tradeBotRadarChartHeight = 280;
  static const double tradeBotTermsCardHeight = 575;
  static const double tradeBotDistributionChartHeight = 200;
  static const double tradeBotDashboardChartHeight = 180;
  static const double tradeBotEquityChartHeight = 214;
  static const double tradeBotEquitySharpeChartHeight =
      tradeBotDashboardChartHeight;
  static const double tradeBotEquitySummaryMetricHeight = 52;
  static const double tradeBotCompactChartHeight = 140;
  static const double tradeBotRiskRingSize = 96;
  static const double tradeBotRiskRingInnerSize = 80;
  static const double tradeBotCorrelationColumnWidth = 74;
  static const double tradeBotDisclosureIconBox = 48;
  static const double tradeBotCorrelationLegendDot = 9;
  static const double tradeBotChartLegendSwatchWidth = 14;
  static const double tradeBotChartLegendSwatchHeight = 10;
  static const double tradeBotRecommendationIconBox = 40;
  static const double tradeBotMetricTableColumnWidth = 100;
  static const double tradeBotCassSummaryHeight = 89;
  static const double tradeBotCassTabsHeight = 53;
  static const double tradeBotClientQuickLinkHeight = 45;
  static const double tradeBotClientMetricHeight = 49;
  static const double tradeBotClientCategoryHeroIcon = 56;
  static const double tradeBotClientCategoryHeroIconGlyph = 28;
  static const double tradeBotClientCategoryIcon = 48;
  static const double tradeBotClientCategoryIconGlyph = 23;
  static const double tradeBotClientHistoryIcon = 40;
  static const double tradeBotClientHistoryIconGlyph = 19;
  static const double tradeBotClientMarker = 12;
  static const double tradeBotClientCurrentIcon = 21;
  static const double tradeBotClientMoneyRiskGap = AppSpacing.rowGap;
  static const double tradeBotClientMoneyNoticeIcon = 16;
  static const double tradeBotClientMoneyBalanceIcon = 56;
  static const double tradeBotClientMoneyBalanceGlyph = 28;
  static const double tradeBotClientMoneyMetricHeight = 53;
  static const double tradeBotClientMoneyDocumentIcon = 40;
  static const double tradeBotClientMoneyDocumentGlyph = 18;
  static const double tradeBotClientMoneyInsolvencyIcon = 14;
  static const double tradeBotClientMoneyProtectionGap = 22;
  static const double tradeBotDisputeTabsHeight = 54;
  static const double tradeBotDisputeFileTopGap = 13;
  static const double tradeBotDisputeCasesTopGap = 18;
  static const double tradeBotDisputeFileBottomGap = 24;
  static const double tradeBotDisputeCasesBottomGap = 20;
  static const double tradeBotDisputeFooterNativeGap = 18;
  static const double tradeBotDisputeFooterVisualGap = 17;
  static const double tradeBotDisputeUploadTallGap = 82;
  static const double tradeBotDisputeUploadCompactGap = 16;
  static const double tradeBotDisputeTabIndicatorWidth = 70;
  static const double tradeBotDisputeComplaintHeight = 62;
  static const double tradeBotDisputeProviderHeight = 46;
  static const double tradeBotDisputeDropdownIcon = 22;
  static const double tradeBotDisputeEvidenceHeight = 45;
  static const double tradeBotDisputeEscalateHeight = 36;
  static const double tradeBotAttributionMetricAspectRatio = 2.18;
  static const double tradeBotAttributionTabHeight = 54;
  static const double tradeBotAttributionTabIndicatorWidth = 70;
  // Target sizes for PerformanceAttributionPage's four tab charts, pending
  // product/design review — see tradeBotAttributionCompactChartHeight and
  // tradeBotAttributionReturnsCompactChartHeight below for the values the
  // page currently ships at (roughly half of these).
  static const double tradeBotAttributionReturnsChartHeight = 260;
  static const double tradeBotAttributionDrawdownChartHeight = 252;
  static const double tradeBotAttributionProjectionChartHeight = 270;
  static const double tradeBotAttributionCorrelationChartHeight = 250;
  // Current (pre-review) chart heights actually rendered by
  // PerformanceAttributionPage's Drawdown/Projection/Correlation tabs
  // (compact) and its Attribution/Returns tab (returns). Do not swap these
  // for the *ChartHeight tokens above without a design sign-off, since that
  // would roughly double the on-screen chart size.
  static const double tradeBotAttributionCompactChartHeight = 132;
  static const double tradeBotAttributionReturnsCompactChartHeight = 148;
  static const double tradeBotAttributionProgressHeight = 8;
  static const double tradeBotAttributionLegendLineWidth = 18;
  static const double tradeBotAttributionLegendLineHeight =
      AppSpacing.hairlineStroke;
  static const double tradeBotAttributionLegendItemGap = 4;
  static const double tradeBotAttributionLegendGroupGap = 12;
  static const double tradeBotMiniStatHeight =
      LaunchpadSpacingTokens.launchpadBox56;
  static const double tradeBotSuitabilityResultTitleLineHeight = 1.1;
  static const double tradeBotLineHeightLoose = 1.5;
  static const double tradeBotLineHeightRelaxed = 1.55;
  static const double tradeBotLineHeightLong = 1.6;
  static const double tradeBotLineHeightLegal = 1.68;
  static const double tradeBotTermsReadThreshold = 50;
  static const double tradeBotSheetActionHeight = 44;
  static const double tradeBotFooterTopOffset = 10;
  static const EdgeInsets tradeBotPageBodyPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x5,
    AppSpacing.contentPad,
    0,
  );
  static const EdgeInsets tradeBotHeroPadding = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets tradeBotTabShellPadding = EdgeInsets.all(
    AppSpacing.x1,
  );
  static const EdgeInsets tradeBotCardPadding = AppSpacing.cardPadding;
  static const EdgeInsets tradeBotCardPaddingLoose = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const EdgeInsets tradeBotCardPaddingTall = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    18,
  );
  static const EdgeInsets tradeBotStrategyCardPadding = EdgeInsets.fromLTRB(
    13,
    13,
    13,
    12,
  );
  static const EdgeInsets tradeBotInnerPanelPadding = EdgeInsets.all(12);
  static const EdgeInsets tradeBotCompactPanelPadding = EdgeInsets.all(6);
  static const EdgeInsets tradeBotControlPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    10,
  );
  static const EdgeInsets tradeBotCompactCardPadding = EdgeInsets.fromLTRB(
    12,
    11,
    12,
    11,
  );
  static const EdgeInsets tradeBotMetricBoxPadding = EdgeInsets.fromLTRB(
    8,
    9,
    8,
    8,
  );
  static const EdgeInsets tradeBotMiniStatPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets tradeBotClientMetricPadding = EdgeInsets.fromLTRB(
    10,
    8,
    10,
    8,
  );
  static const EdgeInsets tradeBotClientMoneyNoticePadding =
      EdgeInsets.fromLTRB(12, 0, 8, 0);
  static const EdgeInsets tradeBotClientMoneyBalancePadding =
      EdgeInsets.fromLTRB(16, 17, 16, 17);
  static const EdgeInsets tradeBotClientMoneyOverviewPadding =
      EdgeInsets.fromLTRB(16, 17, 16, 16);
  static const EdgeInsets tradeBotClientMoneyInsolvencyPadding =
      EdgeInsets.fromLTRB(16, 28, 16, 16);
  static const EdgeInsets tradeBotClientMoneyMetricPadding =
      EdgeInsets.fromLTRB(12, 10, 12, 9);
  static const EdgeInsets tradeBotClientMoneyRowPadding = EdgeInsets.fromLTRB(
    10,
    10,
    10,
    9,
  );
  static const EdgeInsets tradeBotClientMoneyDocumentsPadding = EdgeInsets.all(
    13,
  );
  static const EdgeInsets tradeBotDisputeNoticePadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    11,
  );
  static const EdgeInsets tradeBotDisputeComplaintPadding = EdgeInsets.fromLTRB(
    14,
    11,
    14,
    9,
  );
  static const EdgeInsets tradeBotDisputeProviderPadding = EdgeInsets.only(
    left: 16,
    right: 10,
  );
  static const EdgeInsets tradeBotDisputeTextFieldPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const EdgeInsets tradeBotAttributionMetricPadding =
      EdgeInsets.fromLTRB(12, 12, 12, 10);
  static const EdgeInsets tradeBotAttributionPanelPadding = EdgeInsets.all(13);
  static const EdgeInsets tradeBotAttributionProjectionPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 12);
  static const EdgeInsets tradeBotCopyDemoPanelPadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets tradeBotCopyDemoCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets tradeBotCopyDemoCompactPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets tradeBotCopyDemoInlinePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets tradeBotCopyDemoBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets tradeBotCopyDemoLinePadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets tradeBotCopyDemoCompactLinePadding = EdgeInsets.only(
    bottom: AppSpacing.x1,
  );
  static const EdgeInsets tradeBotCopyDemoDividerPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const EdgeInsets tradeBotCopyDemoRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets tradeBotCopyDemoSectionBottomPadding =
      EdgeInsets.only(bottom: AppSpacing.x3);
  static const EdgeInsets tradeBotCopyDemoHeaderBottomPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets tradeBotTermsScrollPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    22,
    AppSpacing.contentPad,
    22,
  );
  static const EdgeInsets tradeBotTermsWarningPadding = EdgeInsets.fromLTRB(
    13,
    14,
    13,
    13,
  );
  static const EdgeInsets tradeBotAgreementPadding = EdgeInsets.fromLTRB(
    12,
    14,
    12,
    14,
  );
  static const EdgeInsets tradeBotAgreementIconMargin = EdgeInsets.only(
    top: tradeBotIntroIconTop,
  );
  static const EdgeInsets tradeBotIntroIconTopPadding = EdgeInsets.only(
    top: tradeBotIntroIconTop,
  );
  static const EdgeInsets tradeBotNoticeIconTopPadding = EdgeInsets.only(
    top: tradeBotNoticeIconTop,
  );
  static const EdgeInsets tradeBotRecordIconTopPadding = EdgeInsets.only(
    top: tradeBotRecordIconTop,
  );
  static const EdgeInsets tradeBotMetricTableStarGap = EdgeInsets.only(
    left: AppSpacing.dividerHairline,
  );
  static const EdgeInsets tradeBotClientQuickLinkPadding = EdgeInsets.symmetric(
    horizontal: tradeBotStatusGap,
  );
  static const EdgeInsets tradeBotOptionPadding = EdgeInsets.fromLTRB(
    16,
    13,
    16,
    13,
  );
  static const EdgeInsets tradeBotFooterPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    10,
    AppSpacing.contentPad,
    10,
  );
  static const EdgeInsets tradeBotSheetPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.contentPad,
    AppSpacing.contentPad,
    24,
  );
  static const EdgeInsets tradeBotChipPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const EdgeInsets tradeBotCodeBlockPadding = EdgeInsets.fromLTRB(
    12,
    13,
    12,
    13,
  );
  static const EdgeInsets tradeBotCodeBlockCompactPadding = EdgeInsets.fromLTRB(
    12,
    11,
    12,
    11,
  );
}
