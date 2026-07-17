// DEBT-89 (A-Plus GD3): tach tu trade_spacing_tokens.dart (2261 dong) —
// literal cua khu Copy Trading (copy/provider/trader); facade TradeSpacingTokens giu alias cung ten nen
// call site khong doi. Const co tham chieu xuyen nhom van o lai facade.
import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/referral_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

final class TradeCopySpacingTokens {
  const TradeCopySpacingTokens._();

  static const double copyTradingBottomInsetVisual = 126;
  static const double copyTradingBottomInsetNative = 28;
  static const double copyTradingHeroPanelPaddingValue = AppSpacing.contentPad;
  static const double copyTradingHeroMetricPaddingValue = AppSpacing.rowPy;
  static const double copyTradingHeroGap = AppSpacing.cardGap - AppSpacing.x1;
  static const double copyTradingHeroMetricGap = AppSpacing.x4 - AppSpacing.x1;
  static const double copyTradingHeroLabelGap = AppSpacing.x4 - AppSpacing.x1;
  static const double copyTradingMetricCellGap = AppSpacing.hairlineStroke;
  static const double copyTradingWeeklyStrokeWidth = AppSpacing.borderWidth;
  static const double copyTradingDisclaimerLineHeight = 1.5;
  static const double copyTradingDisclaimerTopPad = AppSpacing.hairlineStroke;
  static const double copyTradingDisclaimerBottomPad =
      AppSpacing.hairlineStroke * 2;
  static const EdgeInsets copyTradingHeroPanelPadding = EdgeInsets.all(
    copyTradingHeroPanelPaddingValue,
  );
  static const EdgeInsets copyTradingHeroMetricPadding = EdgeInsets.all(
    copyTradingHeroMetricPaddingValue,
  );
  static const EdgeInsets copyTradingDisclaimerPadding = EdgeInsets.only(
    top: copyTradingDisclaimerTopPad,
    bottom: copyTradingDisclaimerBottomPad,
  );
  static const double copyProviderDetailBottomInsetVisualExtra = 104;
  static const double copyProviderDetailBottomInsetNativeExtra = 28;
  static const int copyProviderDetailMetricColumns = 3;
  static const double copyProviderDetailMetricAspectRatio = 1.22;
  static const EdgeInsets copyProviderDetailNotFoundPadding = EdgeInsets.only(
    top: WalletSpacingTokens.walletAddressEmptyIconSize,
  );
  static const double copyPerformanceBottomInsetVisualExtra = 26;
  static const double copyPerformanceBottomInsetNativeExtra = 14;
  static const double copyPerformanceReturnCardHeight = 92;
  static const double copyPerformanceTabsHeight = 52;
  static const double copyPerformanceEquityChartHeight = 258;
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
  static const double providerApplicationIntroTitleLineHeight = 1.18;
  static const double providerApplicationIntroDescriptionLineHeight = 1.42;
  static const double providerApplicationBenefitDescriptionLineHeight = 1.25;
  static const double providerApplicationResponsibilityLineHeight = 1.3;
  static const double providerApplicationConsentLineHeight = 1.5;
  static const double providerApplicationPanelDescriptionLineHeight = 1.45;
  static const BoxConstraints providerApplicationBenefitCardConstraints =
      BoxConstraints(minHeight: 64);
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
  static const double copyAuditMetadataConfigHeight =
      WalletSpacingTokens.walletTransactionSummaryStatusIcon;
  static const double copyAuditSummaryCardHeight = 69;
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
  static const double copySafetyTierIcon = AppSpacing.x5;
  static const double copySafetyIconTextIcon = AppSpacing.x3 + AppSpacing.x2;
  static const double copySafetyIconTextGap =
      AppSpacing.rowGap + AppSpacing.hairlineStroke;
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
  static const double copyConfigurationRiskIcon = AppSpacing.ctaLoadingIcon;
  static const double copyConfigurationPresetHeight =
      AppSpacing.buttonCompact + AppSpacing.hairlineStroke;
  static const double copyConfigurationRatioWidth =
      AppSpacing.x7 - AppSpacing.hairlineStroke / 2;
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
  static const double copyConfirmationProviderAvatarRadius =
      AppSpacing.x5 + AppSpacing.x2;
  static const double copyConfirmationStepRadius = AppSpacing.x4;
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
  static const double providerLeaderboardBottomInsetVisualExtra = 126;
  static const double providerLeaderboardBottomInsetNativeExtra = 28;
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
}
