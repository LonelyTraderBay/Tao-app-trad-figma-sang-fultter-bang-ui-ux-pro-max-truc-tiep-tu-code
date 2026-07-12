import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/referral_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

final class TradeSpacingTokens {
  const TradeSpacingTokens._();

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
  static const double tradeHistoryBottomInsetVisual = 42;
  static const double tradeHistoryBottomInsetNative = 20;
  static const double tradeHorizontalPadding = AppSpacing.contentPad;
  static const EdgeInsets tradeMarketPanelPadding = EdgeInsets.fromLTRB(
    tradeHorizontalPadding,
    0,
    tradeHorizontalPadding,
    12,
  );
  static const EdgeInsets tradeHorizontalInsets = EdgeInsets.symmetric(
    horizontal: tradeHorizontalPadding,
  );
  static const EdgeInsets tradeRiskPanelPadding = tradeMarketPanelPadding;

  /// Home-aligned section rhythm for L2 trade pages (8px).
  static const double tradePageContentGap = AppSpacing.x3;

  @Deprecated(
    'Use AppSpacing.sectionGap or AppSpacing.pageRhythmStandardSectionGap',
  )
  static const double tradeSectionGap = AppSpacing.sectionGap;
  static const double tradeHeaderLogo = 32;
  static const EdgeInsets tradeHeaderBodyPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: AppSpacing.rowGap,
  );
  static const double tradeHeaderChevronGap = AppSpacing.x2;
  static const double tradeHeaderChevron = 18;
  static const double tradeHeaderTrailingWidth = 128;
  static const double tradeQuickNavHeight = 74;
  static const EdgeInsets tradeQuickNavPadding = EdgeInsets.symmetric(
    horizontal: tradeHorizontalPadding,
    vertical: 6,
  );
  static const double tradeQuickNavGap = AppSpacing.rowGap;
  static const double tradeQuickChipWidth = 96;
  static const EdgeInsets tradeQuickChipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: WalletSpacingTokens.walletAssetSmallGap,
  );
  static const double tradeQuickChipIcon = 15;
  static const double tradeQuickChipIconGap = AppSpacing.x2;
  static const double tradeQuickChipBadgeGap = 6;
  static const double tradeQuickChipBadgeMaxWidth = 74;
  static const EdgeInsets tradeQuickChipBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.hairlineStroke,
  );
  static const EdgeInsets tradeDataTabsPadding = EdgeInsets.fromLTRB(
    tradeHorizontalPadding,
    4,
    tradeHorizontalPadding,
    AppSpacing.rowGap,
  );
  static const double tradeDataTabsHeight = 34;
  static const double tradeChartHeight = 122;
  static const double tradeChartOverlayInset = 10;
  static const double tradeChartOverlayTop = 12;
  static const double tradeChartLogoSize = 44;
  static const double copyTradingBottomInsetVisual = 126;
  static const double copyTradingBottomInsetNative = 28;
  static const double copyTradingHeroPanelPaddingValue = AppSpacing.contentPad;
  static const double copyTradingHeroAumPaddingValue = 16;
  static const double copyTradingHeroMetricPaddingValue = AppSpacing.rowPy;
  static const double copyTradingHeroGap = AppSpacing.cardGap - AppSpacing.x1;
  static const double copyTradingHeroMetricGap = AppSpacing.x4 - AppSpacing.x1;
  static const double copyTradingHeroLabelGap = AppSpacing.x4 - AppSpacing.x1;
  static const double copyTradingMetricIcon =
      tradeBotSmallIcon + AppSpacing.hairlineStroke / 2;
  static const double copyTradingMetricIconGap = tradeBotNarrowIconGap;
  static const double copyTradingMetricCellGap = AppSpacing.hairlineStroke;
  static const double copyTradingWeeklyTitleGap = tradeBotNarrowIconGap;
  static const double copyTradingWeeklyChartHeight =
      AppSpacing.buttonCompact - tradeBotNarrowIconGap;
  static const double copyTradingWeeklyStrokeWidth = AppSpacing.borderWidth;
  static const double copyTradingDisclaimerLineHeight = 1.5;
  static const double copyTradingDisclaimerTopPad = AppSpacing.hairlineStroke;
  static const double copyTradingDisclaimerBottomPad =
      AppSpacing.hairlineStroke * 2;
  static const EdgeInsets copyTradingHeroPanelPadding = EdgeInsets.all(
    copyTradingHeroPanelPaddingValue,
  );
  static const EdgeInsets copyTradingHeroAumPadding = EdgeInsets.all(
    copyTradingHeroAumPaddingValue,
  );
  static const EdgeInsets copyTradingHeroMetricPadding = EdgeInsets.all(
    copyTradingHeroMetricPaddingValue,
  );
  static const EdgeInsets copyTradingDisclaimerPadding = EdgeInsets.only(
    top: copyTradingDisclaimerTopPad,
    bottom: copyTradingDisclaimerBottomPad,
  );
  static EdgeInsets copyTradingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double preCopyAssessmentBottomInsetVisualExtra = 104;
  static const double preCopyAssessmentBottomInsetNativeExtra = 28;
  static const double preCopyAssessmentContentTopPadding =
      AppSpacing.x4 + AppSpacing.x1;
  static const double preCopyAssessmentContentGap =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double preCopyAssessmentCtaGap = 12;
  static const EdgeInsets preCopyAssessmentCardPadding = EdgeInsets.all(
    AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets preCopyAssessmentOptionMargin = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets preCopyAssessmentOptionCardPadding = EdgeInsets.all(
    AppSpacing.x4 - AppSpacing.x1,
  );
  static EdgeInsets preCopyAssessmentScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: preCopyAssessmentContentTopPadding,
        bottom: bottomInset,
      );
  static const double copyProviderDetailBottomInsetVisualExtra = 104;
  static const double copyProviderDetailBottomInsetNativeExtra = 28;
  static const double copyProviderDetailDisclaimerLineHeight =
      tradeBotLineHeightReadable;
  static const double copyProviderDetailRiskLineHeight =
      tradeBotLineHeightMedium;
  static const int copyProviderDetailMetricColumns = 3;
  static const double copyProviderDetailMetricAspectRatio = 1.22;
  static const EdgeInsets copyProviderDetailNotFoundPadding = EdgeInsets.only(
    top: WalletSpacingTokens.walletAddressEmptyIconSize,
  );
  static EdgeInsets copyProviderDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double positionDashboardLabelLineHeight = 1.1;
  static const double positionDashboardTightLineHeight =
      tradeBotLineHeightTight;
  static const double futuresPriceLineHeight = tradeBotLineHeightTight;
  static const double futuresMarketStatCardHeight =
      WalletSpacingTokens.walletAddressStatsHeight;
  static const double futuresSideSwitchHeight = 56;
  static const double futuresOrderTypeSelectorHeight =
      AppSpacing.searchBarCompactHeight;
  static const double futuresPercentButtonLineHeight = tradeBotLineHeightTight;
  static const double futuresSafetyTitleLineHeight = 1.1;
  static const double convertPairSparklineWidth = 72;
  static const double convertPairSparklineHeight = 31;
  static const double convertSlippageCardHeight = 108;
  static const double convertModeTabHeight = AppSpacing.searchBarCompactHeight;
  static const double convertControlHeight =
      AppSpacing.buttonCompact + AppSpacing.x1;
  static const double convertChipHeight =
      AppSpacing.buttonCompact - AppSpacing.x3;
  static const double convertFavoriteChipHeight =
      AppSpacing.searchBarCompactHeight;
  static const double convertHeroFlipSize =
      AppSpacing.buttonCompact + AppSpacing.x1;
  static const double convertSubmitHeight = AppSpacing.searchBarCompactHeight;
  static const double convertStickyCtaClearance =
      AppSpacing.ctaHeight + AppSpacing.x5;
  static const double leverageControlButtonLineHeight = tradeBotLineHeightTight;
  static const double leverageImpactRowLineHeight = tradeBotLineHeightShort;
  static const double leverageHeroHeight = 178;
  static const double leverageHeroValueLineHeight = tradeBotLineHeightTight;
  static const int leveragePresetGridColumns = 5;
  static const double leveragePresetGridAspectRatio = 1.78;
  static const double botDrawdownUnderwaterChartHeight = 200;
  static const double botDrawdownDurationChartHeight = 160;
  static const double copyPerformanceBottomInsetVisualExtra = 26;
  static const double copyPerformanceBottomInsetNativeExtra = 14;
  static const double copyPerformanceReturnCardHeight = 92;
  static const double copyPerformanceTabsHeight = 52;
  static const double copyPerformanceEquityChartHeight = 258;
  static const double copyPerformanceInfoLineHeight = tradeBotLineHeightCompact;
  static EdgeInsets copyPerformanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.cardGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets copyPerformanceTradeCardPadding = EdgeInsets.all(
    AppSpacing.rowPy,
  );
  static const EdgeInsets copyPerformanceCostItemPadding = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets copyPerformanceMetricItemPadding = EdgeInsets.only(
    bottom: WalletSpacingTokens.walletAssetPillGap,
  );
  static const EdgeInsets copyPerformanceInfoBoxPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets copyPerformanceInfoLinePadding = EdgeInsets.only(
    bottom: AppSpacing.x1,
  );
  static const EdgeInsets copyPerformanceReturnCardPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.rowGapRegular,
      );
  static const double providerComparisonBottomInsetVisualExtra = 26;
  static const double providerComparisonBottomInsetNativeExtra = 14;
  static const double providerComparisonWarningLineHeight =
      tradeBotLineHeightReadable;
  static const double providerComparisonLegendLineHeight =
      tradeBotLineHeightBody;
  static EdgeInsets providerComparisonScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: AppSpacing.x4 - AppSpacing.x1,
        bottom: bottomInset,
      );
  static const EdgeInsets providerComparisonPanelPadding = EdgeInsets.all(
    AppSpacing.x4 - AppSpacing.x1,
  );
  static const EdgeInsets providerComparisonMetricHeaderPadding =
      EdgeInsets.only(
        left: AppSpacing.x4 - AppSpacing.x1,
        bottom: AppSpacing.ctaLoadingIcon,
      );
  static const EdgeInsets providerComparisonMetricLabelPadding =
      EdgeInsets.only(left: AppSpacing.x4 - AppSpacing.x1);
  static const EdgeInsets providerComparisonCategoryPadding = EdgeInsets.only(
    left: AppSpacing.x3,
  );
  static const double bestExecutionActionButtonHeight = 40;
  static const double bestExecutionSummaryLineHeight = 1;
  static const double bestExecutionReportTitleLineHeight =
      tradeBotLineHeightCaption;
  static const double bestExecutionReportMetaLineHeight =
      tradeBotLineHeightBody;
  static const EdgeInsets bestExecutionSummaryCardPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x4,
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x4 - AppSpacing.x1,
  );
  static const EdgeInsets bestExecutionReportActionsPadding = EdgeInsets.all(
    AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets bestExecutionArchiveReportPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets bestExecutionNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x3 + AppSpacing.x1,
    AppSpacing.x3,
    AppSpacing.x3 + AppSpacing.x1,
  );
  static const double providerApplicationIntroTitleLineHeight = 1.18;
  static const double providerApplicationIntroDescriptionLineHeight = 1.42;
  static const double providerApplicationBenefitDescriptionLineHeight = 1.25;
  static const double providerApplicationResponsibilityLineHeight = 1.3;
  static const double providerApplicationConsentLineHeight = 1.5;
  static const double providerApplicationPanelDescriptionLineHeight = 1.45;
  static const BoxConstraints providerApplicationBenefitCardConstraints =
      BoxConstraints(minHeight: 64);
  static EdgeInsets providerApplicationFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets providerApplicationStepTitlePadding = EdgeInsets.only(
    bottom: AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets providerApplicationConsentPadding = EdgeInsets.all(
    AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke,
  );
  static const EdgeInsets providerApplicationPanelPadding = EdgeInsets.all(
    AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets providerApplicationInputContentPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke,
        vertical: AppSpacing.x4 - AppSpacing.x1,
      );
  static const EdgeInsets providerApplicationBenefitCardPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.x4 - AppSpacing.x1,
        vertical: AppSpacing.x3 + AppSpacing.hairlineStroke,
      );
  static const EdgeInsets providerApplicationResponsibilityItemPadding =
      EdgeInsets.only(bottom: AppSpacing.x1);
  static const EdgeInsets providerApplicationRequirementPreviewPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4 - AppSpacing.x1);
  static const double copyAuditBottomInsetVisualExtra = 118;
  static const double copyAuditBottomInsetNativeExtra = 28;
  static EdgeInsets copyAuditScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets copyAuditSheetPadding =
      WalletSpacingTokens.transferSheetPadding;
  static const EdgeInsets copyAuditNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.cardGap,
    AppSpacing.cardGap,
    AppSpacing.cardGap,
    AppSpacing.rowGapRegular,
  );
  static const EdgeInsets copyAuditSummaryTitlePadding = EdgeInsets.only(
    left: WalletSpacingTokens.walletAssetPillGap,
  );
  static const EdgeInsets copyAuditMetadataConfigPadding = EdgeInsets.symmetric(
    horizontal: WalletSpacingTokens.walletAssetPillGap,
  );
  static const EdgeInsets copyAuditMetadataPanelPadding = EdgeInsets.all(
    WalletSpacingTokens.walletAssetPillGap,
  );
  static const EdgeInsets copyAuditExportButtonPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double copyAuditNoticeLineHeight = tradeBotLineHeightBody;
  static const double copyAuditSheetTitleLineHeight = tradeBotLineHeightCompact;
  static const double copyAuditEventTitleLineHeight = tradeBotLineHeightCaption;
  static const double copyAuditEventDescriptionLineHeight =
      tradeBotLineHeightCompact;
  static const double copyAuditMetaLineHeight = tradeBotLineHeightTight;
  static const double copyAuditExportLineHeight = tradeBotLineHeightShort;
  static const double copyAuditMetadataConfigHeight =
      WalletSpacingTokens.walletTransactionSummaryStatusIcon;
  static const double copyAuditSummaryCardHeight = 69;
  static const double exPostCostsReportNoticeIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double exPostCostsReportNoticeIconGap =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double exPostCostsReportNoticeBodyGap = AppSpacing.x3;
  static const double exPostCostsReportSummaryHeight = 46;
  static const double exPostCostsReportSummaryLineHeight =
      tradeBotLineHeightCaption;
  static const double exPostCostsReportBreakdownTitleTop =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double exPostCostsReportBreakdownEstimateGap =
      AppSpacing.rowGap + AppSpacing.dividerHairline;
  static const double exPostCostsReportBreakdownNoteGap =
      AppSpacing.x5 + AppSpacing.dividerHairline;
  static const double exPostCostsReportVarianceNoteIcon =
      AppSpacing.rowGap + AppSpacing.x1;
  static const double exPostCostsReportVarianceNoteIconGap =
      AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double exPostCostsReportLineHeightTight =
      tradeBotLineHeightTight;
  static const double exPostCostsReportLineHeightBody = tradeBotLineHeightBody;
  static const double exPostCostsReportVarianceGap = AppSpacing.contentPad;
  static const EdgeInsets exPostCostsReportNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x3 + AppSpacing.hairlineStroke,
    0,
    AppSpacing.x3,
    0,
  );
  static const EdgeInsets exPostCostsReportSummaryPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3 + AppSpacing.hairlineStroke,
    AppSpacing.x4 + AppSpacing.hairlineStroke,
    AppSpacing.x3 + AppSpacing.hairlineStroke,
    AppSpacing.x4,
  );
  static const EdgeInsets exPostCostsReportBreakdownPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.hairlineStroke,
      );
  static const EdgeInsets exPostCostsReportBreakdownTitlePadding =
      EdgeInsets.only(top: exPostCostsReportBreakdownTitleTop);
  static const EdgeInsets exPostCostsReportVarianceNoteHigherPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x3 + AppSpacing.hairlineStroke,
        AppSpacing.x3,
        AppSpacing.x3 + AppSpacing.hairlineStroke,
        AppSpacing.x3,
      );
  static const EdgeInsets exPostCostsReportVarianceNoteLowerPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x3,
        AppSpacing.x3,
        AppSpacing.x3 + AppSpacing.hairlineStroke,
        AppSpacing.x3,
      );
  static const EdgeInsets exPostCostsReportVariancePadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x5,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.x1,
      );
  static const EdgeInsets exPostCostsReportVarianceBodyPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4,
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4 - AppSpacing.x1,
      );
  static const double copySettingsBottomInsetVisual = 112;
  static const double copySettingsBottomInsetNative = 28;
  static const double copySettingsCircuitBreakerExpandedHeight = 122;
  static const double copySettingsCircuitBreakerCollapsedHeight = 72;
  static const double copySettingsNotificationRowHeight = 56;
  static const double copySettingsModeCardHeight = 84;
  static const double copySettingsSliderCardHeight = 76;
  static const double copySettingsSliderCardWithSubtextHeight = 93;
  static const double copySettingsPrivacyCardHeight = 84;
  static const double copySettingsLineHeightTight = 1.1;
  static const double copySettingsLineHeightDense = 1.15;
  static const double copySettingsLineHeightCompact = 1.2;
  static const double copySettingsLineHeightBody = 1.4;
  static const double copySettingsLineHeightReadable = 1.45;
  static const double copySettingsLineHeightLoose = 1.5;
  static const EdgeInsets copySettingsSectionPadding = EdgeInsets.only(
    bottom: AppSpacing.sectionGapRegular,
  );
  static const EdgeInsets copySettingsModeButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets copySettingsNotificationPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.cardGap,
        vertical: WalletSpacingTokens.walletAssetPillGap,
      );
  static const EdgeInsets copySettingsToggleKnobMargin = EdgeInsets.all(
    AppSpacing.x1,
  );
  static const EdgeInsets copySettingsChannelPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.cardGap,
  );
  static EdgeInsets copySettingsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double complaintSubmissionBottomInsetVisual =
      AppSpacing.buttonCompact - AppSpacing.x2;
  static const double complaintSubmissionBottomInsetNative =
      AppSpacing.x5 + AppSpacing.x1;
  static const double complaintSubmissionTopInset =
      AppSpacing.x5 + AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double complaintSubmissionSectionGap = AppSpacing.rowPy;
  static const double complaintSubmissionFooterHeight =
      AppSpacing.x7 + AppSpacing.x4;
  static const double complaintSubmissionLineHeightTight = 1;
  static const double complaintSubmissionLineHeightShort = 1.2;
  static const double complaintSubmissionLineHeightBody = 1.35;
  static const double complaintSubmissionLineHeightHint = 1.4;
  static const double complaintSubmissionLineHeightReadable = 1.45;
  static const double complaintSubmissionLineHeightLong = 1.5;
  static const double complaintSubmissionMultilineHeight =
      WalletSpacingTokens.walletAddressCardHeight + AppSpacing.dividerHairline;
  static const double complaintSubmissionSingleLineHeight =
      WalletSpacingTokens.walletTransactionExplorerHeight;
  static const double complaintSubmissionEvidenceHeight =
      WalletSpacingTokens.walletDepositWarningCardMinHeight + tradeBotRowGap;
  static const double complaintSubmissionCheckboxSize =
      AppSpacing.iconMd + AppSpacing.dividerHairline;
  static const EdgeInsets complaintSubmissionFooterPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        AppSpacing.x1,
      );
  static const EdgeInsets complaintSubmissionNoticePadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets complaintSubmissionCategoryPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4);
  static const EdgeInsets complaintSubmissionEvidencePadding = EdgeInsets.all(
    copyTradingHeroAumPaddingValue,
  );
  static const EdgeInsets complaintSubmissionTermsPadding = EdgeInsets.fromLTRB(
    copyTradingHeroAumPaddingValue,
    tradeQuickChipIcon,
    copyTradingHeroAumPaddingValue,
    tradeQuickChipIcon,
  );
  static const EdgeInsets complaintSubmissionMultilineContentPadding =
      EdgeInsets.fromLTRB(
        tradeBotCardGap,
        tradeBotSectionMarkerHeight,
        tradeBotCardGap,
        tradeBotCardGap,
      );
  static const EdgeInsets complaintSubmissionSingleLineContentPadding =
      EdgeInsets.symmetric(horizontal: tradeBotCardGap);
  static EdgeInsets complaintSubmissionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        complaintSubmissionTopInset,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets complaintSubmissionFooterInset(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double complaintCaseBottomInsetVisual =
      AppSpacing.buttonCompact + AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double complaintCaseBottomInsetNative =
      AppSpacing.x5 + AppSpacing.x1;
  static const double complaintCaseCompactGap =
      AppSpacing.contentPad - AppSpacing.x3;
  static const double complaintCaseLineHeightTight = 1;
  static const double complaintCaseLineHeightSlight = 1.1;
  static const double complaintCaseLineHeightTitle = 1.15;
  static const double complaintCaseLineHeightBody =
      complaintSubmissionLineHeightShort;
  static const double complaintCaseLineHeightDense = 1.25;
  static const double complaintCaseLineHeightReadable =
      complaintSubmissionLineHeightHint;
  static const double complaintCaseIconNudge = AppSpacing.dividerHairline;
  static const double complaintCaseSmallIcon =
      WalletSpacingTokens.walletAddressActionIcon;
  static const double complaintCaseActionIcon =
      WalletSpacingTokens.walletAddressAddAgreementIcon;
  static const double complaintCaseTrailingIcon = tradeBotDisputeTabBadgeSize;
  static const EdgeInsets complaintCaseCardPadding =
      AppSpacing.cardPaddingCompact;
  static const EdgeInsets complaintCaseTitleNudgePadding = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets complaintCaseIconNudgePadding = EdgeInsets.only(
    top: complaintCaseIconNudge,
  );
  static EdgeInsets complaintTrackingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.sectionGapCompact,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double complaintTrackingSectionGap =
      AppSpacing.sectionGapCompact;
  static const double complaintTrackingActionHeight =
      AppSpacing.buttonCompact + AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double complaintTrackingTimelineRailWidth = 32;
  static const double complaintTrackingTimelineConnectorHeight =
      WalletSpacingTokens.walletTokenHeroIcon;
  static const EdgeInsets complaintTrackingStatusCardPadding =
      EdgeInsets.fromLTRB(
        WalletSpacingTokens.walletAddressActionIcon,
        WalletSpacingTokens.walletAddressActionIcon,
        WalletSpacingTokens.walletAddressActionIcon,
        copyTradingHeroAumPaddingValue,
      );
  static const EdgeInsets complaintTrackingMetricPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x3,
    AppSpacing.x4,
    AppSpacing.x3,
  );
  static const EdgeInsets complaintTrackingConnectorPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.dividerHairline);
  static const EdgeInsets complaintTrackingStepContentPadding = EdgeInsets.only(
    top: AppSpacing.hairlineStroke,
    bottom: AppSpacing.contentPad,
  );
  static EdgeInsets ombudsmanScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double ombudsmanSectionGap = complaintCaseCompactGap;
  static const EdgeInsets ombudsmanEligibilityPadding = EdgeInsets.fromLTRB(
    copyTradingHeroAumPaddingValue,
    AppSpacing.contentPad - AppSpacing.x2,
    copyTradingHeroAumPaddingValue,
    AppSpacing.rowPy,
  );
  static const EdgeInsets ombudsmanProcessPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double ombudsmanContactIconBox =
      AppSpacing.buttonCompact + AppSpacing.formFieldLabelGap;
  static const double complaintsHandlingBottomInsetVisual =
      AppSpacing.x7 +
      AppSpacing.sectionGapCompact +
      AppSpacing.x2 -
      AppSpacing.x1;
  static const double complaintsHandlingBottomInsetNative =
      AppSpacing.x5 + AppSpacing.x2 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double complaintsHandlingTopInset =
      AppSpacing.buttonCompact -
      AppSpacing.formFieldLabelGap -
      AppSpacing.hairlineStroke;
  static const double complaintsHandlingPrimaryGap = AppSpacing.x5;
  static const double complaintsHandlingReviewGap = AppSpacing.x4;
  static const double complaintsHandlingStatsGap = AppSpacing.x6;
  static const double complaintsHandlingTabGap = AppSpacing.x5;
  static const double complaintsHandlingGridGap = complaintCaseCompactGap;
  static const double complaintsHandlingCategoryWidth = 194;
  static const double complaintsHandlingCategoryHeight =
      WalletSpacingTokens.walletAddressSecurityCardHeight + AppSpacing.x3;
  static const double complaintsHandlingTimelineStepSize =
      AppSpacing.buttonCompact - AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double complaintsHandlingTimelineItemGap =
      copyTradingHeroAumPaddingValue;
  static const double complaintsHandlingTimelineLabelGap =
      AppSpacing.formFieldLabelGap;
  static const double complaintsHandlingRightsIconGap = 10;
  static const double complaintsHandlingRightsBodyLineHeight =
      complaintSubmissionLineHeightBody;
  static const double complaintsHandlingOmbudsmanLineHeight =
      complaintSubmissionLineHeightReadable;
  static const EdgeInsets complaintsHandlingRightsPadding = EdgeInsets.fromLTRB(
    complaintCaseCompactGap,
    0,
    AppSpacing.x3,
    0,
  );
  static const EdgeInsets complaintsHandlingCategoryPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4,
        WalletSpacingTokens.walletAddressActionIcon + AppSpacing.hairlineStroke,
        AppSpacing.x4,
        AppSpacing.x4,
      );
  static const EdgeInsets complaintsHandlingTimelinePadding =
      EdgeInsets.fromLTRB(
        copyTradingHeroAumPaddingValue,
        WalletSpacingTokens.walletAddressActionIcon,
        copyTradingHeroAumPaddingValue,
        WalletSpacingTokens.walletAddressActionIcon,
      );
  static EdgeInsets complaintsHandlingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        complaintsHandlingTopInset,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double copyTradingV2GlassHeroHeight = 300;
  static const double copyTradingV2BoldHeroHeight = 256;
  static const double copyTradingV2VariantMinHeight = 56;
  static const double copyTradingV2VariantButtonHeight =
      WalletSpacingTokens.walletHistoryActionHeight;
  static const double copyTradingV2VariantButtonMinWidth =
      WalletSpacingTokens.walletAssetLogoSize;
  static const double copyTradingV2SortTopRoiWidth = 78;
  static const double copyTradingV2SortAumWidth = 82;
  static const double copyTradingV2SortCopiersWidth = 108;
  static const double copyTradingV2SortDefaultWidth = 106;
  static const double copyTradingV2SortChipHeight =
      AppSpacing.statusPillHeightLg;
  static const double copyTradingV2TraderCardHeight = 158;
  static const double copyTradingV2TraderAvatarStackWidth =
      WalletSpacingTokens.walletTransactionExplorerHeight;
  static const double copyTradingV2TraderAvatarStackHeight =
      AppSpacing.inputHeight;
  static const double copyTradingV2TraderAvatarSize =
      WalletSpacingTokens.walletTransactionExplorerHeight;
  static const double copyTradingV2TraderTierBadgeSize =
      SharedSpacingTokens.homeChipMinHeight;
  static const double copyTradingV2TraderTierBadgeIcon =
      AppSpacing.statusPillIconSizeMd - AppSpacing.hairlineStroke / 2;
  static const double copyTradingV2RoiMaxWidth = copyTradingV2SortDefaultWidth;
  static const double copyTradingV2DetailsButtonHeight =
      WalletSpacingTokens.walletAddressIconSize;
  static const double copyTradingV2HeroIconBox =
      WalletSpacingTokens.walletTransactionExplorerHeight;
  static const double copyTradingV2HeroIconGlyph =
      WalletSpacingTokens.walletAssetActionIconInner +
      AppSpacing.hairlineStroke / 2;
  static const double copyTradingV2GlassStatHeight = 112;
  static const double copyTradingV2GlassStatIconBox =
      SharedSpacingTokens.walletAddressSwitchHeight;
  static const double copyTradingV2GlassStatIconGlyph =
      WalletSpacingTokens.walletDepositCopyIcon;
  static const double copyTradingV2BoldStatHeight =
      WalletSpacingTokens.walletAddressStatsHeight;
  static const double copyEducationIntroMinHeight = 96;
  static const double copyEducationModeMinHeight = 116;
  static const double copyEducationTabHeight =
      AppSpacing.buttonStandard + AppSpacing.statusPillGapLg;
  static const EdgeInsets copyEducationStepNumberPadding = EdgeInsets.only(
    top: AppSpacing.rowGapRegular,
  );
  static const double marginTradingHubHeroStatHeight = 85;
  static const double marginTradingHubMenuItemMinHeight = 92;
  static const double marginTradingHubNavIconSize =
      AppSpacing.iconMd + AppSpacing.hairlineStroke / 2;
  static const double marginTradingHubChevronIcon =
      AppSpacing.iconMd + AppSpacing.hairlineStroke;
  static const double marginTradingHubFeatureCheckIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double marginTradingHubComplianceIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double marginTradingHubComplianceGap =
      AppSpacing.rowGap + AppSpacing.dividerHairline;
  static const double marginTradingHubComplianceBodyGap = tradeBotNarrowIconGap;
  static const int marginTradingHubComplianceGridColumns = 2;
  static const double marginTradingHubComplianceGridExtent =
      AppSpacing.buttonCompact + AppSpacing.hairlineStroke;
  static const double marginTradingHubComplianceGridCrossGap = tradeBotRowGap;
  static const double marginTradingHubComplianceGridMainGap = AppSpacing.x3;
  static const double marginTradingHubLineHeightTight = tradeBotLineHeightTight;
  static const double marginTradingHubLineHeightTitle = 1.1;
  static const double marginTradingHubLineHeightCaption =
      tradeBotLineHeightCaption;
  static const double marginTradingHubLineHeightBody =
      tradeBotLineHeightReadable;
  static const EdgeInsets marginTradingHubComplianceInfoPadding =
      tradeToolAlertPadding;
  static EdgeInsets transactionReportingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets transactionReportingStatsPanelPadding =
      EdgeInsets.all(AppSpacing.contentPad - AppSpacing.x1);
  static const EdgeInsets transactionReportingStatCardPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.rowGapRegular,
        AppSpacing.rowGapRegular + AppSpacing.x1,
      );
  static const EdgeInsets transactionReportingReportCardPadding =
      EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets transactionReportingErrorPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x3);
  static const EdgeInsets transactionReportingActionPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3);
  static const EdgeInsets transactionReportingQuickActionCardPadding =
      EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets transactionReportingComplianceNoticePadding =
      EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets transactionReportingNoticePanelPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.rowPy,
        AppSpacing.x4,
        AppSpacing.rowGapRegular,
        AppSpacing.x4,
      );
  static const double transactionReportingLineHeightTight =
      tradeBotLineHeightTight;
  static const double transactionReportingNoticeLineHeight =
      tradeBotLineHeightMedium;
  static const double transactionReportingErrorLineHeight = 1.3;
  static const double transactionReportingStatIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double transactionReportingStatusIcon =
      AppSpacing.x4 + AppSpacing.x3;
  static const double transactionReportingErrorIcon =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const EdgeInsets tradeBodyReviewCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static EdgeInsets copySafetyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double copySafetyHeroMinHeight = 95;
  static const double copySafetyTierBasicMinHeight = 207;
  static const double copySafetyTierVerifiedMinHeight = 260;
  static const double copySafetyTierProMinHeight = 296;
  static const EdgeInsets copySafetyHeroPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 + AppSpacing.x1,
    WalletSpacingTokens.walletTokenApprovalActionIcon,
    AppSpacing.x4 + AppSpacing.x1,
    AppSpacing.rowPy,
  );
  static const EdgeInsets copySafetyTierPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 + AppSpacing.x1,
    AppSpacing.x4 + AppSpacing.x1,
    AppSpacing.x4 + AppSpacing.x1,
    WalletSpacingTokens.walletTokenApprovalActionIcon,
  );
  static const EdgeInsets copySafetyListIndentPadding = EdgeInsets.only(
    left: AppSpacing.dividerHairline,
  );
  static const EdgeInsets copySafetyListItemPadding = EdgeInsets.only(
    left: AppSpacing.rowPy,
  );
  static const EdgeInsets copySafetyMetricExpandedPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 + AppSpacing.x1,
    0,
    AppSpacing.x4 + AppSpacing.x1,
    AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets copySafetyMetricInfoPadding = EdgeInsets.all(
    WalletSpacingTokens.walletAssetPillGap,
  );
  static const EdgeInsets copySafetyActionCardPadding = EdgeInsets.all(
    AppSpacing.rowPy,
  );
  static const EdgeInsets copySafetyIconTextPadding = EdgeInsets.all(10);
  static const double copySafetyHeroTitleLineHeight = 1.05;
  static const double copySafetyListItemLineHeight = tradeBotLineHeightCaption;
  static const double copySafetyDescriptionLineHeight =
      tradeBotLineHeightCompact;
  static const double copySafetyBodyLineHeight = tradeBotLineHeightBody;
  static const double copySafetyIntroLineHeight = tradeBotLineHeightMedium;
  static const double copySafetyLineHeightTight = tradeBotLineHeightTight;
  static const double copySafetyTierIcon = AppSpacing.x5;
  static const double copySafetyIconTextIcon = AppSpacing.x3 + AppSpacing.x2;
  static const double copySafetyIconTextGap =
      AppSpacing.rowGap + AppSpacing.hairlineStroke;
  static const double tradeChartTvLeft = 12;
  static const double tradeChartTvBottom = AppSpacing.rowGap;
  static const double tradeChartPriceRight = AppSpacing.rowGap;
  static const double tradeChartPriceTopDefault = 38;
  static const double tradeChartPriceTopDefaultSecond = 60;
  static const double tradeChartPriceTopPair = 18;
  static const double tradeChartPriceTopPairSecond = 40;
  static const double tradeChartPriceRightTop = 46;
  static const double tradeChartPriceRightBottom = 22;
  static const EdgeInsets tradePriceBadgePadding = EdgeInsets.symmetric(
    horizontal: WalletSpacingTokens.walletAssetSmallGap,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets tradeMarketListPadding = EdgeInsets.all(14);
  static const double tradeBookRowTopGap =
      WalletSpacingTokens.walletAssetSmallGap;
  static const double tradeBookDividerHeight = 16;
  static const double tradeTapeRowBottomGap = AppSpacing.rowGap;
  static const int tradeHubPrimaryCount = 6;
  static const double tradeHubTileExtent =
      AppSpacing.buttonCompact + AppSpacing.x2;
  static const double tradeChartPanelHeight =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x4;
  static const double tradeOrderTabsHeight = 44;
  static const EdgeInsets tradeOrderTabsInnerPadding = EdgeInsets.all(4);
  static const double tradeFormGap = 16;
  static const double tradeFormSmallGap = 14;
  static const double tradePctGap = 10;
  static const double tradeSideSwitchHeight = 46;
  static const double tradeOrderTypeSize = 39;
  static const double tradePctButtonHeight = 38;
  static const double tradeTpslHeight = 38;
  static const EdgeInsets tradeTpslPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const double tradeTpslIcon = 16;
  static const double tradeTpslGap = AppSpacing.rowGap;
  static const EdgeInsets tradeFeeCardPadding = EdgeInsets.all(16);
  static const double tradeFeeRowGap = 10;
  static const EdgeInsets tradeFeeBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.hairlineStroke,
  );
  static const double tradeCtaHeight = AppSpacing.ctaHeight;
  static const double tradeListGap = 12;
  static const EdgeInsets tradeListCardPadding = EdgeInsets.all(14);
  static const double tradeHistoryTabGap = AppSpacing.rowGap;
  static const EdgeInsets tradeHistoryTopTabsPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    12,
  );
  static const double tradeHistoryTopTabHeight = 40;
  static const EdgeInsets tradeHistoryBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
    vertical: 4,
  );
  static const double tradeHistoryTypeBadgeMinWidth = 18;
  static const double tradeHistoryInfoGap = AppSpacing.x2;
  static const EdgeInsets tradeHistoryEmptyPadding = EdgeInsets.symmetric(
    vertical: 84,
  );
  static const double tradeHistoryEmptyIcon = 48;
  static const double tradeHistoryEmptyGap = 12;
  static const EdgeInsets tradeHistoryFilterPadding = EdgeInsets.fromLTRB(
    16,
    AppSpacing.rowGap,
    16,
    AppSpacing.rowGap,
  );
  static const double tradeHistoryFilterGap = 10;
  static const double tradeHistoryFilterHeight = 34;
  static const double tradeHistoryFilterWidth = 58;
  static const double tradeHistoryFilterCompactWidth = 61;
  static const EdgeInsets tradeHistoryFilterPaddingCompact =
      EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets tradeHistoryTilePadding = EdgeInsets.fromLTRB(
    tradeHorizontalPadding,
    14,
    tradeHorizontalPadding,
    12,
  );
  static const double tradeHistorySymbolGap = AppSpacing.rowGap;
  static const double tradeHistoryTypeGap = 6;
  static const double tradeHistoryStatusWidth = 118;
  static const double tradeHistoryStatusIcon = 15;
  static const double tradeHistoryStatusGap = AppSpacing.x2;
  static const double tradeHistoryTileGap = 12;
  static const double tradeHistoryTileSmallGap = 10;
  static const double tradeHistoryProgressHeight = AppSpacing.x2;
  static const double tradeHistoryCancelHeight = 36;
  static const double tradeReceiptScrollBottom = 22;
  static const EdgeInsets tradeReceiptRiskPadding = EdgeInsets.all(12);
  static const EdgeInsets tradeReceiptHeroPadding = EdgeInsets.fromLTRB(
    40,
    34,
    40,
    38,
  );
  static const double tradeReceiptHeroIconBox = 64;
  static const double tradeReceiptHeroIcon = 34;
  static const double tradeReceiptHeroGlowSpread = 12;
  static const double tradeReceiptHeroTitleGap = 22;
  static const double tradeReceiptHeroSubtitleGap = 4;
  static const EdgeInsets tradeReceiptHorizontalMargin = EdgeInsets.symmetric(
    horizontal: 40,
  );
  static const EdgeInsets tradeReceiptCardPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    17,
  );
  static const double tradeReceiptHeaderGap = 10;
  static const double tradeReceiptSectionGap = 13;
  static const double tradeReceiptDividerGap = 15;
  static const double tradeReceiptSmallDividerGap = 4;
  static const double tradeReceiptTotalGap = 9;
  static const double tradeReceiptRiskTitleGap = 11;
  static const double tradeReceiptRiskColumnGap = 12;
  static const EdgeInsets tradeReceiptSideBadgePadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const EdgeInsets tradeReceiptStatusBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
    vertical: 6,
  );
  static const double tradeReceiptStatusIcon = 12;
  static const double tradeReceiptStatusGap = 4;
  static const EdgeInsets tradeReceiptDetailPadding = EdgeInsets.symmetric(
    vertical: 6,
  );
  static const double tradeReceiptDetailLabelWidth = 116;
  static const double tradeReceiptDetailGap = 10;
  static const double tradeReceiptDetailTrailingGap = 4;
  static const double tradeReceiptCopyButton = 18;
  static const double tradeReceiptCopyIcon = 12;
  static const double tradeReceiptRiskBoxHeight = 62;
  static const EdgeInsets tradeReceiptRiskBoxPadding = EdgeInsets.fromLTRB(
    12,
    10,
    10,
    AppSpacing.rowGap,
  );
  static const double tradeReceiptRiskValueGap = AppSpacing.x2;
  static const EdgeInsets tradeReceiptNoticePadding = EdgeInsets.fromLTRB(
    12,
    10,
    12,
    10,
  );
  static const double tradeReceiptNoticeIconTop = 2;
  static const double tradeReceiptNoticeIcon = 14;
  static const double tradeReceiptNoticeGap = AppSpacing.rowGap;
  static const double tradeReceiptSupportHeight = 46;
  static const EdgeInsets tradeReceiptSupportPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double tradeReceiptSupportIcon = 16;
  static const double tradeReceiptSupportGap = 9;
  static const double tradeReceiptSupportChevronGap = 4;
  static const EdgeInsets tradeReceiptFooterPadding = EdgeInsets.fromLTRB(
    40,
    16,
    40,
    AppSpacing.rowGap,
  );
  static const double tradeReceiptFooterButtonHeight = 48;
  static const double tradeReceiptFooterGap = 12;
  static const double tradeReceiptFooterIcon = 16;
  static const double tradeBotBottomInsetVisual = 92;
  static const double tradeBotBottomInsetNative = 28;
  static const double tradeBotFooterBottomInsetVisual = 128;
  static const double tradeBotFooterBottomInsetNative = 96;
  static const double tradeBotPageTopGap = 14;
  static const double tradeBotContentGap = 18;
  static const double tradeBotSmallGap = 8;
  static const double tradeBotTinyGap = 5;
  static const double tradeBotRowGap = 10;
  static const double tradeBotCardGap = 12;
  static const double tradeBotPanelGap = 16;
  static const double tradeBotHairline = AppSpacing.dividerHairline;
  static const double tradeBotSectionMarkerWidth = 4;
  static const double tradeBotSectionMarkerHeight = 15;
  static const double tradeBotNoticeIconTop = 1;
  static const double tradeBotIntroIconTop = 2;
  static const double tradeBotRecordIconTop = 4;
  static const double tradeBotCardIconGap = 12;
  static const double tradeBotInlineIconGap = 8;
  static const double tradeBotNarrowIconGap = 6;
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
  static const double tradeBotCheckbox = 24;
  static const double tradeBotCheckboxIcon = 16;
  static const double tradeBotSmallIcon = 14;
  static const double tradeBotMediumIcon = 17;
  static const double tradeBotActionIcon = 20;
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
  static const double tradeBotCassMetricHeight = 47;
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
  static const double tradeBotClientMoneyTopGap = 27;
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
  static const double tradeBotDisputeTabBadgeSize = 18;
  static const double tradeBotDisputeComplaintHeight = 62;
  static const double tradeBotDisputeProviderHeight = 46;
  static const double tradeBotDisputeDropdownIcon = 22;
  static const double tradeBotDisputeEvidenceHeight = 45;
  static const double tradeBotDisputeEscalateHeight = 36;
  static const double tradeBotAttributionMetricAspectRatio = 2.18;
  static const double tradeBotAttributionTabHeight = 54;
  static const double tradeBotAttributionTabIndicatorWidth = 70;
  static const double tradeBotAttributionReturnsChartHeight = 260;
  static const double tradeBotAttributionDrawdownChartHeight = 252;
  static const double tradeBotAttributionProjectionChartHeight = 270;
  static const double tradeBotAttributionCorrelationChartHeight = 250;
  static const double tradeBotAttributionProgressHeight = 8;
  static const double tradeBotAttributionLegendLineWidth = 18;
  static const double tradeBotAttributionLegendLineHeight =
      AppSpacing.hairlineStroke;
  static const double tradeBotAttributionLegendItemGap = 4;
  static const double tradeBotAttributionLegendGroupGap = 12;
  static const double tradeBotMiniStatHeight =
      LaunchpadSpacingTokens.launchpadBox56;
  static const double tradeBotLineHeightTight = 1;
  static const double tradeBotSuitabilityResultTitleLineHeight = 1.1;
  static const double tradeBotLineHeightShort = 1.15;
  static const double tradeBotLineHeightCaption = 1.2;
  static const double tradeBotLineHeightCompact = 1.25;
  static const double tradeBotLineHeightBody = 1.35;
  static const double tradeBotLineHeightMedium = 1.4;
  static const double tradeBotLineHeightReadable = 1.45;
  static const double tradeBotLineHeightLoose = 1.5;
  static const double tradeBotLineHeightRelaxed = 1.55;
  static const double tradeBotLineHeightLong = 1.6;
  static const double tradeBotLineHeightLegal = 1.68;
  static EdgeInsets traderProfileScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets traderProfileHeroPadding = EdgeInsets.all(
    AppSpacing.contentPad,
  );
  static const EdgeInsets traderProfilePanelPadding = EdgeInsets.all(
    AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets traderProfileRiskPanelPadding = EdgeInsets.all(
    AppSpacing.x4 - AppSpacing.x1,
  );
  static const EdgeInsets traderProfileTradeCardPadding = EdgeInsets.all(
    AppSpacing.x4 - AppSpacing.x1,
  );
  static const EdgeInsets traderProfileMetricPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    AppSpacing.x3 + AppSpacing.hairlineStroke,
    AppSpacing.x3,
    AppSpacing.x3,
  );
  static const EdgeInsets traderProfileStatsLinePadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3 + AppSpacing.hairlineStroke,
  );
  static const double traderProfileAvatarSize =
      AppSpacing.x7 + AppSpacing.x4 - AppSpacing.x2;
  static const double traderProfileHeaderGap = AppSpacing.x4 + AppSpacing.x1;
  static const double traderProfileSectionGap = AppSpacing.x4 + AppSpacing.x1;
  static const double traderProfilePanelInnerGap =
      AppSpacing.x4 - AppSpacing.x1;
  static const double traderProfileWrapGap = AppSpacing.x2 + AppSpacing.x1;
  static const double traderProfileTinyGap =
      AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double traderProfileChartHeight = 160;
  static const double traderProfileDailyChartHeight = 100;
  static const double traderProfileMetricHeight =
      AppSpacing.x7 - AppSpacing.hairlineStroke;
  static const double traderProfileProgressHeight = AppSpacing.x3;
  static const double traderProfileWinLossBarHeight =
      AppSpacing.x4 - AppSpacing.x1;
  static const double traderProfileStatsValueWidth =
      AppSpacing.x7 - AppSpacing.hairlineStroke;
  static const double traderProfileDetailIcon = 15;
  static const double traderProfileActionIcon = tradeBotMediumIcon;
  static const double productGovernanceBottomInsetVisual = 118;
  static const double productGovernanceBottomInsetNative = 28;
  static const double productGovernanceTopInset =
      AppSpacing.x6 + AppSpacing.hairlineStroke;
  static const double productGovernanceContentGap = AppSpacing.x3;
  static const double productGovernanceInlineGap = tradeBotRowGap;
  static const double productGovernancePillGap = AppSpacing.x2;
  static const double productGovernanceTagGap = tradeBotNarrowIconGap;
  static const double productGovernanceTargetGap =
      AppSpacing.x4 - AppSpacing.hairlineStroke;
  static const double productGovernanceDateSectionGap = tradeBotMediumIcon;
  static const double productGovernanceNegativeTagGap = tradeBotContentGap;
  static const double productGovernanceReviewGap = AppSpacing.x3;
  static const double productGovernanceReviewActionGap = tradeBotNarrowIconGap;
  static const double productGovernanceReviewTextGap =
      AppSpacing.x2 - AppSpacing.hairlineStroke;
  static const double productGovernanceActionIcon = tradeBotMediumIcon;
  static const double productGovernanceNoticeIcon = tradeBotMediumIcon;
  static const double productGovernanceChannelIconBox =
      LaunchpadSpacingTokens.launchpadBox40;
  static const double productGovernanceChannelStatusIcon = 19;
  static const double productGovernanceDateBoxHeight = tradeBotCassMetricHeight;
  static const double productGovernanceLineHeightTight =
      tradeBotLineHeightTight;
  static const EdgeInsets productGovernanceNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    0,
    AppSpacing.x3,
    0,
  );
  static const EdgeInsets productGovernanceCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets productGovernanceReviewRowPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets productGovernanceDistributionCardPadding =
      EdgeInsets.all(AppSpacing.x3 + AppSpacing.hairlineStroke);
  static const EdgeInsets productGovernanceDateBoxPadding = EdgeInsets.fromLTRB(
    tradeBotRowGap,
    AppSpacing.x2,
    tradeBotRowGap,
    AppSpacing.x2,
  );
  static EdgeInsets productGovernanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        productGovernanceTopInset,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double activeCopiesBottomInsetVisual = 104;
  static const double activeCopiesBottomInsetNative = 28;
  static const double activeCopiesPortfolioHeight = 194;
  static const double activeCopiesPnlHeight = 62;
  static const double activeCopiesTabsHeight =
      AppSpacing.inputHeight - AppSpacing.x4;
  static const double activeCopiesMiniValueHeight =
      AppSpacing.inputHeight - AppSpacing.hairlineStroke;
  static const double activeCopiesReturnHeight =
      LaunchpadSpacingTokens.launchpadBox40 + AppSpacing.hairlineStroke;
  static const double activeCopiesPerformanceHeight =
      AppSpacing.x7 - AppSpacing.hairlineStroke;
  static const double activeCopiesActionHeight =
      WalletSpacingTokens.walletDepositCopyButtonHeight;
  static const double activeCopiesPnlIcon = tradeBotMediumIcon;
  static const double activeCopiesVerifiedIcon =
      AppSpacing.x3 + AppSpacing.x4 - AppSpacing.x1;
  static const double activeCopiesExpandIcon =
      productGovernanceChannelStatusIcon;
  static const double activeCopiesExpandPadding = 4.5;
  static const double activeCopiesLineHeightTight = tradeBotLineHeightTight;
  static const double activeCopiesLineHeightShort = 1.1;
  static const double activeCopiesLineHeightCompact = tradeBotLineHeightShort;
  static const double activeCopiesLineHeightCaption = tradeBotLineHeightCaption;
  static const double activeCopiesLineHeightNotice = tradeBotLineHeightReadable;
  static const EdgeInsets activeCopiesPnlPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowPy,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets activeCopiesTabsPadding = EdgeInsets.all(
    AppSpacing.x1,
  );
  static const EdgeInsets activeCopiesMiniValuePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets activeCopiesReturnPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets activeCopiesDetailsPadding = EdgeInsets.only(
    top: AppSpacing.rowPy,
  );
  static const EdgeInsets activeCopiesSmallCardPadding = EdgeInsets.all(
    WalletSpacingTokens.walletAssetPillGap,
  );
  static const EdgeInsets activeCopiesActionPadding = EdgeInsets.symmetric(
    horizontal: WalletSpacingTokens.walletAssetPillGap,
  );
  static EdgeInsets activeCopiesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets activeCopiesStopSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.x5 + bottomInset,
      );
  static const double copyConfigurationBottomInsetVisual = 84;
  static const double copyConfigurationBottomInsetNative = 24;
  static const double copyConfigurationAvatarSize =
      WalletSpacingTokens.walletTokenHeroIcon;
  static const double copyConfigurationPrimaryGap =
      WalletSpacingTokens.transferSectionGap;
  static const double copyConfigurationTinyGap = AppSpacing.hairlineStroke * 2;
  static const double copyConfigurationSmallGap = AppSpacing.x3;
  static const double copyConfigurationMediumGap =
      AppSpacing.x4 - AppSpacing.x1;
  static const double copyConfigurationInlineGap =
      AppSpacing.cardGap - AppSpacing.x1;
  static const double copyConfigurationCardPaddingValue = 16;
  static const double copyConfigurationInnerPaddingValue = AppSpacing.rowPy;
  static const double copyConfigurationValidationPaddingValue = 12;
  static const double copyConfigurationProgressHeight = AppSpacing.x3;
  static const double copyConfigurationDividerHeight =
      AppSpacing.x5 + AppSpacing.hairlineStroke / 2;
  static const double copyConfigurationModeIcon = tradeBotActionIcon;
  static const double copyConfigurationRiskIcon = AppSpacing.ctaLoadingIcon;
  static const double copyConfigurationValidationIcon = tradeBotCheckboxIcon;
  static const double copyConfigurationPresetHeight =
      AppSpacing.buttonCompact + AppSpacing.hairlineStroke;
  static const double copyConfigurationRatioWidth =
      AppSpacing.x7 - AppSpacing.hairlineStroke / 2;
  static const double copyConfigurationDescriptionLineHeight =
      tradeBotLineHeightBody;
  static const EdgeInsets copyConfigurationCardPadding = EdgeInsets.all(
    copyConfigurationCardPaddingValue,
  );
  static const EdgeInsets copyConfigurationInnerPadding = EdgeInsets.all(
    copyConfigurationInnerPaddingValue,
  );
  static const EdgeInsets copyConfigurationRiskTogglePadding =
      EdgeInsets.symmetric(
        horizontal: copyConfigurationInnerPaddingValue,
        vertical: copyConfigurationMediumGap,
      );
  static const EdgeInsets copyConfigurationValidationPadding = EdgeInsets.all(
    copyConfigurationValidationPaddingValue,
  );
  static const EdgeInsets copyConfigurationSummaryRowPadding = EdgeInsets.only(
    bottom: copyConfigurationSmallGap,
  );
  static EdgeInsets copyConfigurationScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets copyConfigurationFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double copyConfirmationBottomInsetVisual =
      copyConfigurationBottomInsetVisual;
  static const double copyConfirmationBottomInsetNative =
      copyConfigurationBottomInsetNative;
  static const double copyConfirmationSectionGap =
      AppSpacing.x4 + AppSpacing.x1;
  static const double copyConfirmationCardPaddingValue =
      copyConfigurationCardPaddingValue;
  static const double copyConfirmationSoftPaddingValue =
      copyConfigurationInnerPaddingValue;
  static const double copyConfirmationCompactPaddingValue =
      copyConfigurationValidationPaddingValue;
  static const double copyConfirmationTinyGap =
      WalletSpacingTokens.walletAddressCompactGap;
  static const double copyConfirmationSmallGap = copyConfigurationSmallGap;
  static const double copyConfirmationInlineGap = copyConfigurationMediumGap;
  static const double copyConfirmationRowGap =
      AppSpacing.contentPad - AppSpacing.x3;
  static const double copyConfirmationIconGap = copyConfirmationInlineGap;
  static const double copyConfirmationLabelGap = AppSpacing.formFieldLabelGap;
  static const double copyConfirmationDividerHeight =
      AppSpacing.x5 + AppSpacing.dividerHairline;
  static const double copyConfirmationCheckboxIcon =
      SharedSpacingTokens.walletAddressSwitchKnob;
  static const double copyConfirmationWarningIcon =
      AppSpacing.x5 + AppSpacing.x1;
  static const double copyConfirmationCoolingIcon = tradeBotDisputeTabBadgeSize;
  static const double copyConfirmationProviderAvatarRadius =
      AppSpacing.x5 + AppSpacing.x2;
  static const double copyConfirmationStepRadius = AppSpacing.x4;
  static const double copyConfirmationLineHeightDense =
      complaintCaseLineHeightDense;
  static const double copyConfirmationLineHeightBody =
      complaintsHandlingRightsBodyLineHeight;
  static const double copyConfirmationLineHeightReadable =
      complaintsHandlingOmbudsmanLineHeight;
  static const EdgeInsets copyConfirmationCardPadding =
      copyConfigurationCardPadding;
  static const EdgeInsets copyConfirmationSoftPadding = EdgeInsets.all(
    copyConfirmationSoftPaddingValue,
  );
  static const EdgeInsets copyConfirmationCompactPadding = EdgeInsets.all(
    copyConfirmationCompactPaddingValue,
  );
  static const EdgeInsets copyConfirmationSummaryRowPadding =
      copyConfigurationSummaryRowPadding;
  static EdgeInsets copyConfirmationScrollPadding(double bottomInset) =>
      copyConfigurationScrollPadding(bottomInset);
  static EdgeInsets copyConfirmationFooterPadding(double bottomInset) =>
      copyConfigurationFooterPadding(bottomInset);
  static const double regulatoryInspectionBottomInsetVisualExtra =
      AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x1;
  static const double regulatoryInspectionBottomInsetNativeExtra =
      AppSpacing.x6 - AppSpacing.formFieldLabelGap;
  static const double regulatoryInspectionContentGap = AppSpacing.rowPy;
  static const double regulatoryInspectionScoreMinHeight =
      AppSpacing.buttonHero * 2 +
      AppSpacing.x5 +
      AppSpacing.x1 +
      AppSpacing.dividerHairline;
  static const double regulatoryInspectionCardPaddingHorizontal =
      AppSpacing.contentPad - AppSpacing.x1;
  static const double regulatoryInspectionCardPaddingVertical =
      AppSpacing.ctaLoadingIcon - AppSpacing.x1;
  static const double regulatoryInspectionMetricGap = AppSpacing.rowGapRegular;
  static const double regulatoryInspectionCompactGap = AppSpacing.x2;
  static const double regulatoryInspectionInlineGap = AppSpacing.x3;
  static const double regulatoryInspectionSmallGap = AppSpacing.x4;
  static const double regulatoryInspectionMediumGap = AppSpacing.rowPy;
  static const double regulatoryInspectionLargeGap =
      AppSpacing.statusPillHeightLg;
  static const double regulatoryInspectionLooseGap =
      AppSpacing.x5 + AppSpacing.x2;
  static const double regulatoryInspectionScoreIconBox =
      AppSpacing.buttonStandard + AppSpacing.x1;
  static const double regulatoryInspectionScoreIcon =
      AppSpacing.statusPillHeightMd + AppSpacing.x2;
  static const double regulatoryInspectionProgressHeight =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double regulatoryInspectionReadyIconTop =
      AppSpacing.hairlineStroke / 2;
  static const double regulatoryInspectionTinyIcon =
      AppSpacing.x3 + AppSpacing.dividerHairline;
  static const double regulatoryInspectionRequirementIcon =
      AppSpacing.rowGapRegular;
  static const double regulatoryInspectionQuickStatIcon =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double regulatoryInspectionBodyIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.x1;
  static const double regulatoryInspectionStandardIcon =
      AppSpacing.ctaLoadingIcon;
  static const double regulatoryInspectionQuickStatHeight =
      WalletSpacingTokens.walletAddressAddWhitelistHeight + AppSpacing.x2;
  static const double regulatoryInspectionDocumentHeight =
      AppSpacing.buttonStandard + AppSpacing.x1;
  static const double regulatoryInspectionDocumentIconBox =
      AppSpacing.buttonCompact + AppSpacing.x2;
  static const double regulatoryInspectionPortalIconBox =
      AppSpacing.inputHeight - AppSpacing.x2;
  static const double regulatoryInspectionPortalIcon =
      AppSpacing.iconMd + AppSpacing.x1;
  static const double regulatoryInspectionPortalGap =
      AppSpacing.contentPad - AppSpacing.x1;
  static const double regulatoryInspectionActionHeight =
      AppSpacing.searchBarCompactHeight;
  static const double regulatoryInspectionLineHeightTight = 1;
  static const double regulatoryInspectionLineHeightCompact = 1.1;
  static const double regulatoryInspectionLineHeightNote = 1.25;
  static const double regulatoryInspectionLineHeightReadable = 1.35;
  static const EdgeInsets regulatoryInspectionCardPadding = EdgeInsets.fromLTRB(
    regulatoryInspectionCardPaddingHorizontal,
    regulatoryInspectionCardPaddingVertical,
    regulatoryInspectionCardPaddingHorizontal,
    regulatoryInspectionCardPaddingVertical,
  );
  static const EdgeInsets regulatoryInspectionQuickStatPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.rowGapRegular,
        AppSpacing.rowGapRegular,
        AppSpacing.rowGapRegular,
        AppSpacing.rowGapRegular + AppSpacing.x1,
      );
  static const EdgeInsets regulatoryInspectionDocumentPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.rowGapRegular + AppSpacing.x1,
        AppSpacing.x4,
        AppSpacing.rowGapRegular + AppSpacing.x1,
      );
  static const EdgeInsets regulatoryInspectionPortalPadding = EdgeInsets.all(
    AppSpacing.contentPad - AppSpacing.x1,
  );
  static const EdgeInsets regulatoryInspectionScoreTextPadding =
      EdgeInsets.only(top: AppSpacing.x1);
  static const EdgeInsets regulatoryInspectionReadyIconPadding =
      EdgeInsets.only(top: regulatoryInspectionReadyIconTop);
  static EdgeInsets regulatoryInspectionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double executionVenueBottomInsetVisualExtra =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x3;
  static const double executionVenueBottomInsetNativeExtra =
      AppSpacing.x6 - AppSpacing.formFieldLabelGap;
  static const double executionVenueContentGap = 0;
  static const double executionVenueSectionGap = AppSpacing.x4 + AppSpacing.x1;
  static const double executionVenueControlGap =
      AppSpacing.x5 + AppSpacing.x3 - AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double executionVenueTabBodyGap =
      AppSpacing.x5 + AppSpacing.x3 - AppSpacing.x2 + AppSpacing.x1;
  static const double executionVenueNoticeTopOffset = AppSpacing.ctaLoadingIcon;
  static const double executionVenueNoticeIcon = AppSpacing.ctaLoadingIcon;
  static const double executionVenueBodyIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.x1;
  static const double executionVenueSummaryGap = AppSpacing.x4 - AppSpacing.x1;
  static const double executionVenueSummaryHeight =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double executionVenueSortIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.dividerHairline;
  static const double executionVenueSortLabelWidth =
      AppSpacing.buttonCompact + AppSpacing.x3;
  static const double executionVenueSortLabelGap =
      AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double executionVenueLineHeightTight = 1;
  static const double executionVenueLineHeightControl = 1.15;
  static const double executionVenueCardPaddingValue = AppSpacing.x4;
  static const double executionVenuePanelPaddingValue =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double executionVenueCompactPanelPaddingValue =
      AppSpacing.x4 - AppSpacing.x1;
  static const double executionVenueRankGap =
      AppSpacing.x4 - AppSpacing.hairlineStroke;
  static const double executionVenueWinnerIcon = AppSpacing.x4 + AppSpacing.x1;
  static const double executionVenueMetricBoxHeight =
      AppSpacing.buttonCompact + AppSpacing.x4 + AppSpacing.x1;
  static const double executionVenueMetricBoxBottomPadding =
      AppSpacing.x3 - AppSpacing.hairlineStroke + AppSpacing.x1;
  static const double executionVenueMetricGap =
      AppSpacing.x3 - AppSpacing.hairlineStroke + AppSpacing.x1;
  static const double executionVenueProgressGap =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double executionVenueProgressHeight =
      AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double executionVenueTrendBarHeight = AppSpacing.x3;
  static const EdgeInsets executionVenueNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x3 + AppSpacing.x1,
    AppSpacing.x3,
    AppSpacing.x3 + AppSpacing.x1,
  );
  static const EdgeInsets executionVenueSummaryCardPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4,
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4 - AppSpacing.x1,
      );
  static const EdgeInsets executionVenueCardPadding = EdgeInsets.all(
    executionVenueCardPaddingValue,
  );
  static const EdgeInsets executionVenueMetricBoxPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    AppSpacing.x3,
    AppSpacing.x3,
    executionVenueMetricBoxBottomPadding,
  );
  static const EdgeInsets executionVenuePanelPadding = EdgeInsets.all(
    executionVenuePanelPaddingValue,
  );
  static const EdgeInsets executionVenueCompactPanelPadding = EdgeInsets.all(
    executionVenueCompactPanelPaddingValue,
  );
  static EdgeInsets executionVenueScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: AppSpacing.x4,
        bottom: bottomInset,
      );
  static const double providerGovernanceBottomInsetVisualExtra =
      AppSpacing.buttonHero + AppSpacing.x6 + AppSpacing.x2;
  static const double providerGovernanceBottomInsetNativeExtra =
      AppSpacing.x6 - AppSpacing.formFieldLabelGap;
  static const double providerGovernanceContentGap = 0;
  static const double providerGovernanceDashboardHeight = 136;
  static const double providerGovernanceDashboardIconBox =
      AppSpacing.inputHeight - AppSpacing.x2;
  static const double providerGovernanceDashboardIcon =
      AppSpacing.iconMd + AppSpacing.x1;
  static const double providerGovernanceDashboardGap = AppSpacing.rowPy;
  static const double providerGovernanceDashboardMetricGap = AppSpacing.x4;
  static const double providerGovernanceCompactGap = AppSpacing.x2;
  static const double providerGovernanceSmallGap = AppSpacing.x3;
  static const double providerGovernanceMediumGap = AppSpacing.rowGapRegular;
  static const double providerGovernanceSectionGap = AppSpacing.rowPy;
  static const double providerGovernanceControlGap =
      AppSpacing.x5 + AppSpacing.x2;
  static const double providerGovernanceTabHeight =
      AppSpacing.x7 + AppSpacing.x2;
  static const double providerGovernanceTabBodyGap =
      AppSpacing.statusPillHeightMd;
  static const double providerGovernanceNoticeMinHeight =
      AppSpacing.inputHeight;
  static const double providerGovernanceNoticeIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double providerGovernanceNoticeGap =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double providerGovernanceModificationHeight = 154;
  static const double providerGovernanceModificationIcon = AppSpacing.iconSm;
  static const double providerGovernanceMetaIcon =
      AppSpacing.x3 + AppSpacing.x1;
  static const double providerGovernanceMetaGap =
      AppSpacing.ctaLoadingIcon - AppSpacing.x1;
  static const double providerGovernancePanelIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.dividerHairline;
  static const double providerGovernanceRequestHeight =
      ReferralSpacingTokens.referralCtaHeight;
  static const double providerGovernanceLineHeightTight =
      tradeBotLineHeightTight;
  static const double providerGovernanceLineHeightReadable =
      tradeBotLineHeightReadable;
  static const double providerLeaderboardBottomInsetVisualExtra = 126;
  static const double providerLeaderboardBottomInsetNativeExtra = 28;
  static const double providerLeaderboardTopInset =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double providerLeaderboardContentGap = AppSpacing.x4;
  static const double providerLeaderboardReviewPaddingValue =
      AppSpacing.x4 - AppSpacing.x1;
  static const double providerLeaderboardWarningPaddingStart = AppSpacing.x3;
  static const double providerLeaderboardWarningPaddingEnd = AppSpacing.x3;
  static const double providerLeaderboardWarningPaddingBottom =
      AppSpacing.x3 - AppSpacing.hairlineStroke;
  static const double providerLeaderboardWarningIcon =
      AppSpacing.x3 + AppSpacing.x1;
  static const double providerLeaderboardWarningGap =
      AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double providerLeaderboardWarningTitleGap = AppSpacing.x2;
  static const double providerLeaderboardCardPaddingStart =
      AppSpacing.x4 + AppSpacing.x1;
  static const double providerLeaderboardCardPaddingEnd =
      AppSpacing.x4 + AppSpacing.x1;
  static const double providerLeaderboardCardPaddingBottom =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double providerLeaderboardCardTitleGap =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double providerLeaderboardCardMetricsGap =
      AppSpacing.x4 - AppSpacing.x1;
  static const double providerLeaderboardCardTrailingTop =
      AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double providerLeaderboardVerifiedIconGap =
      AppSpacing.x3 - AppSpacing.hairlineStroke;
  static const double providerLeaderboardVerifiedIcon =
      AppSpacing.x4 - AppSpacing.x1;
  static const double providerLeaderboardFollowersIcon =
      AppSpacing.x2 + AppSpacing.x2;
  static const double providerLeaderboardFiltersLabelGap =
      AppSpacing.x3 - AppSpacing.hairlineStroke;
  static const double providerLeaderboardVerifiedPaddingStart =
      AppSpacing.x4 - AppSpacing.x1;
  static const double providerLeaderboardVerifiedPaddingEnd = AppSpacing.x4;
  static const double providerLeaderboardDisclaimerPaddingStart =
      AppSpacing.ctaLoadingIcon;
  static const double providerLeaderboardDisclaimerPaddingTop =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double providerLeaderboardDisclaimerPaddingBottom =
      AppSpacing.x4 + AppSpacing.x1;
  static const double providerLeaderboardLineHeightFlat = 1;
  static const double providerLeaderboardLineHeightReadable = 1.45;
  static const double providerLeaderboardLineHeightLoose = 1.5;
  static const EdgeInsets providerGovernanceDashboardPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad - AppSpacing.x1,
        AppSpacing.rowPy,
        AppSpacing.contentPad - AppSpacing.x1,
        AppSpacing.x4,
      );
  static const EdgeInsets providerGovernanceSectionTitlePadding =
      EdgeInsets.only(left: AppSpacing.rowGapRegular);
  static const EdgeInsets providerGovernanceNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x4,
    AppSpacing.x4,
    AppSpacing.rowGapRegular + AppSpacing.x1,
  );
  static const EdgeInsets providerGovernanceModificationPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad - AppSpacing.x1,
        AppSpacing.x4,
        AppSpacing.contentPad - AppSpacing.x1,
        AppSpacing.rowGapRegular,
      );
  static const EdgeInsets providerGovernancePanelPadding = EdgeInsets.all(
    AppSpacing.rowPy,
  );
  static const EdgeInsets providerGovernanceMessagePanelPadding =
      EdgeInsets.all(AppSpacing.contentPad);
  static const EdgeInsets providerLeaderboardReviewPadding = EdgeInsets.all(
    providerLeaderboardReviewPaddingValue,
  );
  static const EdgeInsets providerLeaderboardWarningPadding =
      EdgeInsets.fromLTRB(
        providerLeaderboardWarningPaddingStart,
        providerLeaderboardWarningPaddingStart,
        providerLeaderboardWarningPaddingEnd,
        providerLeaderboardWarningPaddingBottom,
      );
  static const EdgeInsets providerLeaderboardCardPadding = EdgeInsets.fromLTRB(
    providerLeaderboardCardPaddingStart,
    providerLeaderboardCardPaddingStart,
    providerLeaderboardCardPaddingEnd,
    providerLeaderboardCardPaddingBottom,
  );
  static const EdgeInsets providerLeaderboardTrailingIconPadding =
      EdgeInsets.only(top: providerLeaderboardCardTrailingTop);
  static const EdgeInsets providerLeaderboardVerifiedPadding =
      EdgeInsets.fromLTRB(
        providerLeaderboardVerifiedPaddingStart,
        providerLeaderboardVerifiedPaddingStart,
        providerLeaderboardVerifiedPaddingEnd,
        providerLeaderboardVerifiedPaddingStart,
      );
  static const EdgeInsets providerLeaderboardDisclaimerPadding =
      EdgeInsets.fromLTRB(
        providerLeaderboardDisclaimerPaddingStart,
        providerLeaderboardDisclaimerPaddingTop,
        providerLeaderboardDisclaimerPaddingStart,
        providerLeaderboardDisclaimerPaddingBottom,
      );
  static EdgeInsets providerLeaderboardScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: providerLeaderboardTopInset,
        bottom: bottomInset,
      );
  static EdgeInsets providerGovernanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double armIntegrationBottomInsetVisualExtra =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x3;
  static const double armIntegrationBottomInsetNativeExtra =
      AppSpacing.x6 - AppSpacing.formFieldLabelGap;
  static const double armIntegrationContentGap = AppSpacing.rowPy;
  static const double armIntegrationCardPaddingValue =
      AppSpacing.contentPad - AppSpacing.x1;
  static const double armIntegrationProviderIconBox =
      AppSpacing.inputHeight - AppSpacing.x2;
  static const double armIntegrationProviderIcon =
      AppSpacing.iconMd + AppSpacing.x1;
  static const double armIntegrationInlineGap = AppSpacing.x4;
  static const double armIntegrationLabelGap =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double armIntegrationMetricRowGap = AppSpacing.rowPy;
  static const double armIntegrationCardSectionGap = AppSpacing.x4;
  static const double armIntegrationMetricHeight = AppSpacing.buttonStandard;
  static const double armIntegrationMetricPaddingHorizontal =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double armIntegrationMetricPaddingTop =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double armIntegrationMetricPaddingBottom = AppSpacing.x3;
  static const double armIntegrationDetailsGap = AppSpacing.rowGapRegular;
  static const double armIntegrationTestIcon =
      AppSpacing.x4 + AppSpacing.hairlineStroke;
  static const double armIntegrationLogsIcon =
      AppSpacing.x4 + AppSpacing.dividerHairline;
  static const double armIntegrationLineHeightTight = tradeBotLineHeightTight;
  static const double armIntegrationChartHeight =
      WalletSpacingTokens.walletAssetChartHeight - AppSpacing.rowGapRegular;
  static const double armIntegrationDividerHeight = AppSpacing.dividerHairline;
  static const double armIntegrationLegendGap = AppSpacing.ctaLoadingIcon;
  static const double armIntegrationSlaGap =
      AppSpacing.ctaLoadingIcon - AppSpacing.x1;
  static const double armIntegrationProgressLabelGap = AppSpacing.x4;
  static const double armIntegrationProgressHeight = AppSpacing.x3;
  static const double armIntegrationQuickActionIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.dividerHairline;
  static const EdgeInsets armIntegrationCardPadding = EdgeInsets.all(
    armIntegrationCardPaddingValue,
  );
  static const EdgeInsets armIntegrationMetricPadding = EdgeInsets.fromLTRB(
    armIntegrationMetricPaddingHorizontal,
    armIntegrationMetricPaddingTop,
    armIntegrationMetricPaddingHorizontal,
    armIntegrationMetricPaddingBottom,
  );
  static const EdgeInsets armIntegrationDetailsPadding = EdgeInsets.symmetric(
    horizontal: armIntegrationMetricPaddingHorizontal,
    vertical: armIntegrationMetricPaddingTop,
  );
  static const EdgeInsets armIntegrationLatencyPadding = EdgeInsets.fromLTRB(
    armIntegrationCardPaddingValue,
    AppSpacing.rowPy,
    armIntegrationCardPaddingValue,
    AppSpacing.rowPy,
  );
  static const EdgeInsets armIntegrationSlaPadding = EdgeInsets.fromLTRB(
    armIntegrationCardPaddingValue,
    armIntegrationSlaGap,
    armIntegrationCardPaddingValue,
    armIntegrationSlaGap,
  );
  static EdgeInsets armIntegrationScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double regulatoryDisclosuresBottomInsetVisualExtra =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x3;
  static const double regulatoryDisclosuresBottomInsetNativeExtra =
      AppSpacing.x6 - AppSpacing.formFieldLabelGap;
  static const double regulatoryDisclosuresContentGap =
      AppSpacing.x5 + AppSpacing.x1;
  static const double regulatoryDisclosuresReviewGap = 0;
  static const double regulatoryDisclosuresReviewInnerGap = AppSpacing.x3;
  static const double regulatoryDisclosuresHeroPaddingValue =
      AppSpacing.x4 + AppSpacing.x1;
  static const double regulatoryDisclosuresHeroIconBox = 48;
  static const double regulatoryDisclosuresHeroIcon =
      AppSpacing.iconMd + AppSpacing.x1;
  static const double regulatoryDisclosuresHeroGap = AppSpacing.x4;
  static const double regulatoryDisclosuresHeroSubtitleGap =
      AppSpacing.formFieldLabelGap + AppSpacing.dividerHairline;
  static const double regulatoryDisclosuresHeroTitleLineHeight = 1.08;
  static const double regulatoryDisclosuresLineHeightCompact =
      tradeBotLineHeightCaption;
  static const double regulatoryDisclosuresActionPaddingValue = AppSpacing.x4;
  static const double regulatoryDisclosuresContactPaddingValue =
      AppSpacing.rowPy;
  static const double regulatoryDisclosuresNoticePaddingValue =
      AppSpacing.contentPad;
  static const double regulatoryDisclosuresActionIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double regulatoryDisclosuresExternalIcon =
      AppSpacing.x4 + AppSpacing.dividerHairline;
  static const double regulatoryDisclosuresContactIcon = AppSpacing.contentPad;
  static const double regulatoryDisclosuresActionGap =
      AppSpacing.x3 + AppSpacing.dividerHairline;
  static const double regulatoryDisclosuresContactGap = tradeBotCardGap;
  static const double regulatoryDisclosuresContactTextGap = AppSpacing.x1;
  static const double regulatoryDisclosuresNoticeTitleGap =
      AppSpacing.rowGapRegular;
  static const double regulatoryDisclosuresNoticeActionGap = tradeBotPanelGap;
  static const EdgeInsets regulatoryDisclosuresHeroPadding = EdgeInsets.all(
    regulatoryDisclosuresHeroPaddingValue,
  );
  static const EdgeInsets regulatoryDisclosuresActionPadding = EdgeInsets.all(
    regulatoryDisclosuresActionPaddingValue,
  );
  static const EdgeInsets regulatoryDisclosuresContactPadding = EdgeInsets.all(
    regulatoryDisclosuresContactPaddingValue,
  );
  static const EdgeInsets regulatoryDisclosuresNoticePadding = EdgeInsets.all(
    regulatoryDisclosuresNoticePaddingValue,
  );
  static EdgeInsets regulatoryDisclosuresScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double tradeBotTermsReadThreshold = 50;
  static const double tradeBotSheetActionHeight = 44;
  static const double tradeBotFooterTopOffset = 10;
  static const EdgeInsets tradeBotScrollPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    tradeBotPageTopGap,
    AppSpacing.contentPad,
    0,
  );
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
  static const EdgeInsets tradeBotDisputeDescriptionLabelPadding =
      EdgeInsets.only(top: tradeBotSmallGap);
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
  static const EdgeInsets tradeBotMetricTableHeaderPadding = EdgeInsets.only(
    bottom: tradeBotRowGap,
  );
  static const EdgeInsets tradeBotMetricTableRowPadding = EdgeInsets.symmetric(
    vertical: tradeBotRowGap,
  );
  static const EdgeInsets tradeBotMetricTableStarGap = EdgeInsets.only(
    left: AppSpacing.dividerHairline,
  );
  static const EdgeInsets tradeBotTermsBulletPadding = EdgeInsets.only(
    left: tradeBotCardGap,
    bottom: tradeBotSmallGap,
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
  static EdgeInsets tradeBotScrollPaddingWithBottom(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeBotPageTopGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotClientMoneyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeBotClientMoneyTopGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotDisputeScrollPadding(
    double topInset,
    double bottomInset,
  ) => EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    topInset,
    AppSpacing.contentPad,
    bottomInset,
  );
  static EdgeInsets tradeBotDisputeUploadPadding(double topGap) =>
      EdgeInsets.only(top: topGap);
  static EdgeInsets tradeBotAttributionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeBotCardGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotCopyDemoScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets tradeBotSecurityScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotActionButtonPadding(bool compact) =>
      EdgeInsets.symmetric(horizontal: compact ? AppSpacing.x3 : AppSpacing.x4);
  static EdgeInsets tradeBotSheetPaddingWithBottom(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        tradeBotCheckbox + bottomInset,
      );
  static const double tradeToolBottomInsetSlippageVisual = 118;
  static const double tradeToolBottomInsetSlippageNative = 28;
  static const double tradeToolBottomInsetRiskVisual = 97;
  static const double tradeToolBottomInsetRiskNative = 24;
  static const double tradeToolBottomInsetExport = 126;
  static const double tradeToolPageTopGap = 14;
  static const double tradeToolSectionGap = 26;
  static const double tradeToolContentGap = 24;
  static const double tradeToolReviewGap = 22;
  static const double tradeToolCardGap = 12;
  static const double tradeToolInlineGap = 8;
  static const double tradeToolTinyGap = 5;
  static const double tradeToolMicroGap = 2;
  static const double tradeToolIconGap = 10;
  static const double tradeToolSectionHeaderGap = 12;
  static const double tradeToolTabHeight = 53;
  static const double tradeToolRiskTabHeight = 44;
  static const double tradeToolStatCardHeight = 150;
  static const double tradeToolStatValueHeight = 52;
  static const double tradeToolMetricHeight = 60;
  static const double tradeToolMetricRowHeight = 30;
  static const double tradeToolDateColumnWidth = 46;
  static const double tradeToolExportSummaryHeight = 132;
  static const double tradeToolFormatHeight = 118;
  static const double tradeToolIncludeRowHeight = 41;
  static const double tradeToolProgressHeight = 8;
  static const double tradeToolIconTileSm = 40;
  static const double tradeToolIconTileMd = 48;
  static const double tradeToolAlertIcon = 17;
  static const double tradeToolBodyIcon = 18;
  static const double tradeToolPanelIcon = 19;
  static const double tradeToolFormatIcon = 24;
  static const double tradeToolFooterIcon = 17;
  static const double tradeToolCloseIcon = 16;
  static const double tradeToolFooterReadyHeight = 42;
  static const int tradeToolFooterButtonFlex = 2;
  static const EdgeInsets tradeToolAlertPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    12,
  );
  static const EdgeInsets tradeToolCardPadding = EdgeInsets.all(14);
  static const EdgeInsets tradeToolCardPaddingCompact = EdgeInsets.all(13);
  static const EdgeInsets tradeToolMetricPadding = EdgeInsets.fromLTRB(
    8,
    8,
    8,
    7,
  );
  static const EdgeInsets tradeToolMetricRowPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const EdgeInsets tradeToolNoticePadding = EdgeInsets.fromLTRB(
    12,
    9,
    8,
    9,
  );
  static const EdgeInsets tradeToolRiskReviewPadding = EdgeInsets.all(12);
  static const EdgeInsets tradeToolRiskIntroPadding = EdgeInsets.all(16);
  static const EdgeInsets tradeToolSheetRowPadding = EdgeInsets.symmetric(
    vertical: 7,
  );
  static const EdgeInsets tradeToolToastPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets tradeToolExportSummaryPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    15,
  );
  static const EdgeInsets tradeToolFormatPadding = EdgeInsets.fromLTRB(
    12,
    16,
    12,
    14,
  );
  static const EdgeInsets tradeToolIncludeListPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets tradeToolTaxNotePadding = EdgeInsets.fromLTRB(
    12,
    11,
    12,
    11,
  );
  static const EdgeInsets tradeToolFooterPaddingStandard = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    16,
    AppSpacing.contentPad,
    tradeToolPageTopGap,
  );
  static const EdgeInsets tradeToolFooterPaddingExported = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    12,
    AppSpacing.contentPad,
    tradeToolPageTopGap,
  );
  static EdgeInsets tradeToolScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeToolPageTopGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeToolExportScrollPadding(double bottomChrome) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeToolPageTopGap,
        AppSpacing.contentPad,
        bottomChrome + tradeToolBottomInsetExport,
      );
}
