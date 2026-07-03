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
  static const double serviceTileBadgePaddingHorizontal = 5;
  static const double serviceTileBadgePaddingVertical = 2;
  static const double serviceTileBadgeFont = 8;
  static const double serviceTileIconContainer = 26;
  static const double serviceTileIconContainerCompact = 22;
  static const double serviceTileIconSize = 20;
  static const double serviceTileIconSizeCompact = 16;
  static const double serviceTileGridAspectStandard = 1.68;
  static const double serviceTileGridAspectCompact = 1.88;
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

  // Module-prefixed screen tokens — migrate to features/<module>/ (finding #15).


  static const double walletHorizontalPadding = 20;
  static const double walletAssetHeroHeight = 238;
  static const double walletAssetHeroPaddingTop = 16;
  static const double walletAssetHeroPaddingBottom = 14;
  static const EdgeInsets walletAssetHeroPadding = EdgeInsets.fromLTRB(
    walletHorizontalPadding,
    walletAssetHeroPaddingTop,
    walletHorizontalPadding,
    walletAssetHeroPaddingBottom,
  );
  static const double walletAssetChartHeight = 209;
  static const EdgeInsets walletAssetStatPillPadding = EdgeInsets.fromLTRB(
    walletAssetPillHorizontalPad,
    walletAssetPillVerticalPad,
    x3,
    walletAssetPillBottomPad,
  );
  static const double walletAssetLogoSize = 52;
  static const double walletAssetStatHeight = 52;
  static const double walletAssetActionHeight = 90;
  static const double walletAssetActionIcon = 40;
  static const double walletHistoryActionHeight = 30;
  static const double walletHistorySectionHeaderHeight = 41;
  static const double walletHistoryAmountColumnWidth = 126;
  static const double walletHistoryItemMinHeight = 84;
  static const double walletTransactionSummaryIconSize = 56;
  static const double walletTransactionSummaryBadgeHeight = 34;
  static const double walletTransactionProgressDotSize = 13;
  static const double walletHistoryDividerWidth = 31;
  static const double walletAssetHeroTopGap = 12;
  static const double walletAssetHeroValueGap = 6;
  static const double walletAssetSmallGap = 7;
  static const double walletAssetPillHorizontalPad = 10;
  static const double walletAssetPillVerticalPad = 6;
  static const double walletAssetPillBottomPad = 6;
  static const double walletAssetPillGap = 9;
  static const double walletAssetActionIconInner = 22;
  static const double walletAssetActionGap = 12;
  static const EdgeInsets walletAssetActionTilePadding = EdgeInsets.symmetric(
    vertical: sectionGapCompact,
  );
  static const double walletAssetPeriodChipHeight = 27;
  static const double walletAssetPeriodChipPadX = 11;
  static const EdgeInsets walletAssetPeriodChipPadding = EdgeInsets.symmetric(
    horizontal: walletAssetPeriodChipPadX,
  );
  static const double walletAssetChartBottomPad = 14;
  static const double walletAssetChartBottomGap = 10;
  static const double walletAssetTransactionIcon = 36;
  static const double walletAssetTransactionGlyph = 18;
  static const double walletAssetTransactionsGap = 12;
  static const double walletHistoryExportBarPadH = 14;
  static const double walletHistoryExportBarPadV = 10;
  static const double walletHistoryFilterTextPadX = 5;
  static const double walletHistoryExportIcon = 12;
  static const double walletHistoryExportIconGap = 5;
  static const double walletHistoryExportChipPadX = 11;
  static const double walletHistorySectionPadLeft = 19;
  static const double walletHistoryTradeIcon = 24;
  static const double walletHistoryTradeIconGlyph = 14;
  static const double walletHistoryTradeBadgeRadius = 6;
  static const double walletHistoryStatusBadgePadH = 7;
  static const double walletHistoryStatusBadgePadV = 3;
  static const double walletHistoryLineSpacing = 4;
  static const double walletHistoryTextSpacing = 5;
  static const double walletHistoryStatusBadgeHeightGap = 6;
  static const double walletHistoryRowToChevronGap = 9;
  static const double walletHistoryRowChevronGap = 9;
  static const double walletHistoryEndListTopPad = 28;
  static const double walletHistoryEndListBottomPad = 20;
  static const double walletHistoryEndListGap = 10;
  static const double walletHistoryDividerHeight = 1;
  static const double walletHistoryFilterTopPad = 24;
  static const double walletHistoryGroupTopPad = 22;
  static const double walletHistoryTitleSpacing = 17;
  static const double walletHistoryFilterGap = 12;
  static const double walletTransactionSummaryBadgePadH = 13;
  static const double walletTransactionSummarySectionVPad = 21;
  static const double walletAssetSectionGap = 16;
  static const double walletAssetTransactionsTopPad = 19;
  static const EdgeInsets walletTransactionSummaryPadding = EdgeInsets.fromLTRB(
    20,
    21,
    20,
    20,
  );
  static const double walletTransactionDetailsPadH = 20;
  static const double walletTransactionSummaryTopGap = 16;
  static const EdgeInsets walletTransactionSummaryHeaderPadding =
      EdgeInsets.fromLTRB(20, 20, 20, 12);
  static const EdgeInsets walletTransactionDetailRowPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 13);
  static const double walletTransactionSummaryStatusIcon = 29;
  static const double walletTransactionStepSpacing = 23;
  static const double walletTransactionStepLineHeight = 36;
  static const double walletDepositWarningCardMinHeight = 129;
  static const double walletDepositSectionGap = 16;
  static const double walletDepositTitleGap = 12;
  static const EdgeInsets walletDepositSelectorPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletDepositWarningPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: rowPy,
  );
  static const double walletDepositCopyIcon = 15;
  static const double walletDepositCopyButtonHeight = 42;
  static const EdgeInsets walletDepositCopyButtonPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double walletDepositQrCodeSize = 180;
  static const double walletDepositQrShadowBlur = 32;
  static const double walletDepositQrShadowOffsetY = 8;
  static const double walletDepositTopGap = 24;
  static const double walletTransactionProgressLineWidth = 2;
  static const double walletTransactionProgressLineSpacing = 4;
  static const double walletTransactionProgressVerticalGap = 9;
  static const double walletTransactionAfterHashGap = 18;
  static const double walletTransactionProgressBottomGap = 17;
  static const double walletTransactionStatusBadgeIcon = 15;
  static const double walletTransactionInfoRowMinHeight = 44;
  static const double walletTransactionCopyIconSize = 27;
  static const double walletTransactionExplorerHeight = 48;
  static const double walletTransactionExplorerLabelGap = 8;
  static const double walletTransactionActionIcon = 16;
  static const double walletTransactionCopyIconGlyph = 14;
  static const double walletTransactionDetailsPadVertical = 13;
  static const double walletTransactionDetailsBottomPad = 12;
  static const EdgeInsets walletTransactionProgressCardPadding =
      EdgeInsets.fromLTRB(16, 17, 16, 18);
  static const double walletTransactionMissingTopPad = 56;
  static const double walletTransactionMissingIcon = 64;
  static const double walletTransactionMissingActionHeight = 42;
  static const double walletTransactionMissingActionPad = 20;

  static const double walletBottomInsetVisualChrome = 92;
  static const double walletBottomInsetNativeChrome = 28;
  static const double walletBuyBannerHeight = 57;
  static const double walletBuyBannerGap = 17;
  static const double walletBuyAmountCardMinHeight = 252;
  static const double walletBuyAmountCardGap = 19;
  static const double walletBuyPaymentTitleGap = 18;
  static const double walletBuySectionGap = 16;
  static const double walletBuyAmountLabelGap = 21;
  static const double walletBuyPresetGap = 24;
  static const double walletBuyReceiveGap = 17;
  static const double walletBuyPresetChipHeight = 30;
  static const double walletBuyReceivePanelHeight = 66;
  static const double walletBuySelectorHeight = 42;
  static const double walletBuyPaymentCardHeight = 64;
  static const double walletBuyPaymentLogoSize = 40;
  static const double walletBuySuccessIconSize = 88;
  static const double walletBuySuccessIconRadius = 44;
  static const double walletBuySuccessGlyph = 46;
  static const double walletBuyCryptoLogoSize = 40;
  static const double walletBuyCryptoLogoCompact = 25;
  static const double walletBuyInlineGap = 12;
  static const double walletBuyCompactGap = 10;
  static const double walletBuyMicroGap = 7;
  static const double walletBuyGroupIconGap = 6;
  static const double walletBuyPaymentMetaGap = 5;
  static const double walletBuyPaymentPopularGap = 8;
  static const double walletBuyPaymentCardGap = 10;
  static const double walletBuyConfirmAmountGap = 20;
  static const double walletBuySuccessTopPad = 40;
  static const double walletBuySuccessBottomPad = 120;
  static const double walletBuySuccessTitleGap = 22;
  static const double walletBuySuccessCtaGap = 24;
  static const double walletBuyAmountLineHeight = tradeBotLineHeightTight;
  static const double walletBuyReceiveLineHeight = 1.1;
  static const double walletBuyMetaLineHeight = tradeBotLineHeightCaption;
  static const double walletBuyBannerLineHeight = tradeBotLineHeightReadable;
  static const EdgeInsets walletBuyBannerPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletBuyAmountCardPadding = EdgeInsets.fromLTRB(
    20,
    22,
    20,
    20,
  );
  static const EdgeInsets walletBuyReceivePanelPadding = EdgeInsets.fromLTRB(
    14,
    10,
    14,
    10,
  );
  static const EdgeInsets walletBuySelectorPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets walletBuyPopularBadgePadding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: 4,
  );
  static const EdgeInsets walletBuyPaymentCardPadding = EdgeInsets.fromLTRB(
    12,
    10,
    13,
    10,
  );
  static const EdgeInsets walletBuyRateInfoPadding = EdgeInsets.fromLTRB(
    16,
    15,
    16,
    15,
  );
  static const EdgeInsets walletBuyConfirmPadding = EdgeInsets.all(20);
  static const EdgeInsets walletBuySuccessPadding = EdgeInsets.fromLTRB(
    contentPad,
    walletBuySuccessTopPad,
    contentPad,
    walletBuySuccessBottomPad,
  );
  static const EdgeInsets walletBuyOptionRowMargin = EdgeInsets.only(
    bottom: walletBuyPaymentCardGap,
  );
  static const EdgeInsets walletBuyOptionRowPadding = EdgeInsets.all(12);
  static const EdgeInsets walletNetworkStatusPageScrollPadding =
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, 0);
  static const EdgeInsets walletMultiManagerPageScrollPadding =
      EdgeInsets.fromLTRB(contentPad, 12, contentPad, 0);
  static const double transferSectionGap = 18;
  static const double transferCardGap = 9;
  static const double transferHintGap = 6;
  static const double transferTileGap = 7;
  static const double transferInputGap = 12;
  static const double transferInfoGap = 14;
  static const double transferCardHeight = 99;
  static const double transferAmountCardHeight = 90;
  static const double transferNoticeMinHeight = 59;
  static const EdgeInsets transferCardPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const EdgeInsets transferCardInnerPadding = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 16,
  );
  static const EdgeInsets transferNoticePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets transferSuccessPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const double transferIcon = 40;
  static const double transferActionIcon = 20;
  static const double transferSwapButton = 40;
  static const double transferSwapButtonShadow = 14;
  static const double transferSwapButtonShadowOffset = 4;
  static const double transferListIcon = 36;
  static const double transferBadgeIcon = 18;
  static const double transferHistoryRowPadding = 12;
  static const EdgeInsets transferSheetPadding = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    24,
  );
  static EdgeInsets transferSheetPaddingWithAdditionalBottom(
    double bottomInset,
  ) => EdgeInsets.fromLTRB(
    transferSheetPadding.left,
    transferSheetPadding.top,
    transferSheetPadding.right,
    transferSheetPadding.bottom + bottomInset,
  );
  static const double walletWithdrawPrimaryGap = 16;
  static const double walletWithdrawSectionGap = 14;
  static const EdgeInsets walletWithdrawBalancePadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets walletWithdrawSelectorPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletWithdrawScanButtonPadding =
      EdgeInsets.symmetric(horizontal: rowGap);
  static const EdgeInsets walletWithdrawInputSuffixPadding = EdgeInsets.only(
    left: searchBarHorizontalTrailingPadding,
  );
  static const EdgeInsets walletWithdrawRecentAddressPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static const EdgeInsets walletWithdrawSupportPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets walletWithdrawNetworkOptionMargin = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets walletWithdrawNetworkOptionPadding =
      EdgeInsets.symmetric(
        horizontal: searchBarHorizontalPadding,
        vertical: rowGap,
      );
  static const EdgeInsets walletWithdrawPreviewRowPadding = EdgeInsets.only(
    bottom: rowGap,
  );
  static const double walletAllocationChartSize = 92;
  static const double walletAllocationChartStroke = 16;
  static const double walletAllocationChartInset = 8;
  static const double walletAllocationCenterRadius = 22;
  static const double walletAllocationLegendMarker = 10;
  static const double walletAllocationLegendGap = 8;
  static const double walletAllocationLegendItemGap = 10;
  static const EdgeInsets walletTransferHistoryRowPadding =
      EdgeInsets.symmetric(vertical: transferHistoryRowPadding);
  static const EdgeInsets walletTransferConfirmRowPadding =
      EdgeInsets.symmetric(vertical: transferTileGap);
  static const EdgeInsets walletTransferNoteIconPadding = EdgeInsets.only(
    top: x1,
  );
  static const double walletAddressCardHeight = 168;
  static const EdgeInsets walletAddressCardPadding = EdgeInsets.all(16);
  static const double walletAddressIconSize = 40;
  static const double walletAddressShieldIcon = 19;
  static const double walletAddressPrimaryGap = 13;
  static const double walletAddressMetaGap = 6;
  static const double walletAddressCompactGap = 4;
  static const double walletAddressActionGap = 10;
  static const double walletAddressCopyHeight = 36;
  static const double walletAddressActionSize = 36;
  static const double walletAddressActionIcon = 17;
  static const EdgeInsets walletAddressEmptyPadding = EdgeInsets.symmetric(
    vertical: 42,
  );
  static const double walletAddressEmptyIconSize = 64;
  static const double walletAddressEmptyIconGlyph = 32;
  static const double walletAddressFilterHeight = 30;
  static const EdgeInsets walletAddressFilterPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double walletAddressFilterGap = 16;
  static const double walletAddressStatsHeight = 70;
  static const double walletAddressStatsGap = 8;
  static const double walletAddressStatsValueGap = 9;
  static const double walletAddressSectionIcon = 15;
  static const double walletAddressSectionGap = 6;
  static const double walletAddressSecurityCardHeight = 74;
  static const EdgeInsets walletAddressSecurityPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const double walletAddressSwitchWidth = 48;
  static const double walletAddressSwitchHeight = 28;
  static const double walletAddressSwitchKnob = 22;
  static const EdgeInsets walletAddressSwitchKnobMargin = EdgeInsets.symmetric(
    horizontal: 2.5,
  );
  static const double walletAddressSwitchBorder = 1.4;
  static const EdgeInsets walletAddressAddSheetPadding = transferSheetPadding;
  static const double walletAddressAddSheetTitleGap = 8;
  static const double walletAddressAddSheetSectionGap = 14;
  static const double walletAddressAddFooterHeight = 72;
  static const EdgeInsets walletAddressAddFooterPadding = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    8,
  );
  static const EdgeInsets walletAddressAddSuccessPadding = EdgeInsets.symmetric(
    horizontal: 32,
  );
  static const double walletAddressAddSuccessIconSize = 80;
  static const double walletAddressAddSuccessIconGlyph = 42;
  static const double walletAddressAddSuccessTitleGap = 20;
  static const double walletAddressAddSuccessMessageGap = 8;
  static const double walletAddressAddSuccessPillGap = 18;
  static const EdgeInsets walletAddressAddStatusPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
  static const double walletAddressAddWhitelistHeight = 80;
  static const double walletAddressAddSwitchWidth = 44;
  static const double walletAddressAddSwitchHeight = 24;
  static const double walletAddressAddSwitchKnob = 18;
  static const EdgeInsets walletAddressAddSwitchKnobMargin =
      EdgeInsets.symmetric(horizontal: 3);
  static const double walletAddressAddSwitchBorder = 1.5;
  static const EdgeInsets walletAddressAddWarningIconPadding = EdgeInsets.only(
    top: 2,
  );
  static const double walletAddressAddAgreementBox = 24;
  static const EdgeInsets walletAddressAddAgreementBoxMargin = EdgeInsets.only(
    top: 2,
  );
  static const double walletAddressAddAgreementRadius = 9;
  static const double walletAddressAddAgreementBorder = 2;
  static const double walletAddressAddAgreementIcon = 16;
  static const EdgeInsets walletAddressAddInputPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletAddressAddWalletInputPadding = EdgeInsets.only(
    left: 16,
    right: 9,
  );
  static const double walletAddressAddIconButton = 32;
  static const double walletAddressAddIcon = 16;
  static const EdgeInsets walletAddressAddHelperPadding = EdgeInsets.fromLTRB(
    4,
    6,
    4,
    0,
  );
  static const EdgeInsets walletAddressAddHintPadding = EdgeInsets.only(
    left: 4,
  );
  static const double walletAddressAddFormSectionGap = 26;
  static const double walletAddressAddAssetLabelGap = 12;
  static const double walletAddressAddAddressSectionGap = 34;
  static const double walletAddressAddHintGap = 5;
  static const double walletAddressAddMemoGap = 28;
  static const double walletAddressAddAgreementGap = 24;
  static const double walletAddressAddPreviewGap = 18;
  static const double walletAddressAddMemoHeight = 48;
  static const double walletAddressAddNetworkSpacing = 10;
  static const double walletAddressAddNetworkRunSpacing = 8;
  static const double walletAddressAddNetworkChipWidth = 126.5;
  static const double walletAddressAddNetworkChipHeight = 40;
  static const EdgeInsets walletAddressAddNetworkChipPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const double walletAddressAddNetworkDot = 12;
  static const double walletAddressAddAssetSpacing = 17;
  static const double walletAddressAddAssetRunSpacing = 12;
  static const double walletAddressAddAssetChipWidth = 53;
  static const double walletAddressAddAssetChipWideWidth = 64;
  static const double walletAddressAddAssetChipHeight = 34;
  static const double walletAddressAddScrollBottomExtra = 112;
  static EdgeInsets walletAddressAddScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(20, 14, 20, bottomInset);
  static const double walletTokenSectionGap = 18;
  static const double walletTokenAlertGap = 17;
  static const double walletTokenLabelGap = 11;
  static const double walletTokenCardGap = 14;
  static const double walletTokenNoticeGap = 16;
  static const double walletTokenOverviewHeight = 203;
  static const EdgeInsets walletTokenOverviewPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double walletTokenHeroIcon = 48;
  static const double walletTokenHeroIconGlyph = 25;
  static const double walletTokenHeroGap = 13;
  static const double walletTokenTitleGap = 8;
  static const double walletTokenMetricTopGap = 14;
  static const double walletTokenMetricValueGap = 8;
  static const double walletTokenAlertHeight = 104;
  static const EdgeInsets walletTokenAlertPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    16,
  );
  static const double walletTokenAlertIcon = 17;
  static const double walletTokenSectionMarkerWidth = 4;
  static const double walletTokenSectionMarkerHeight = 14;
  static const double walletTokenSectionMarkerRadius = 2;
  static const double walletTokenApprovalMinHeight = 212;
  static const double walletTokenApprovalWarningMinHeight = 252;
  static const EdgeInsets walletTokenApprovalPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    14,
  );
  static const double walletTokenApprovalHeaderGap = 10;
  static const double walletTokenApprovalActionGap = 8;
  static const double walletTokenApprovalActionSize = 32;
  static const double walletTokenApprovalActionIcon = 16;
  static const double walletTokenApprovalContentGap = 18;
  static const double walletTokenApprovalAmountGap = 15;
  static const double walletTokenApprovalUnusedGap = 16;
  static const double walletTokenApprovalUnusedHeight = 30;
  static const EdgeInsets walletTokenApprovalUnusedPadding =
      EdgeInsets.symmetric(horizontal: 10);
  static const double walletTokenApprovalUnusedIcon = 12;
  static const double walletTokenApprovalUnusedTextGap = 6;
  static const double walletTokenCategoryIcon = 32;
  static const double walletTokenCategoryGlyph = 17;
  static const double walletTokenHeaderWrapSpacing = 8;
  static const double walletTokenHeaderRunSpacing = 6;
  static const double walletTokenVerifiedIcon = 13;
  static const double walletTokenSpenderGap = 11;
  static const double walletTokenMaskedGap = 14;
  static const double walletTokenRiskBadgeHeight = 17;
  static const EdgeInsets walletTokenRiskBadgePadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const double walletTokenAmountHeight = 36;
  static const EdgeInsets walletTokenAmountPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const double walletTokenStatValueGap = 10;
  static const double walletTokenNoticeMinHeight = 58;
  static const EdgeInsets walletTokenNoticePadding = EdgeInsets.fromLTRB(
    14,
    12,
    14,
    12,
  );
  static const double walletTokenNoticeIcon = 14;
  static const double walletTokenSheetButtonHeight = 46;
  static const double walletTokenScanButtonHeight = 48;
  static const EdgeInsets walletTokenSwitchPadding = EdgeInsets.all(2);
  static const double walletTokenSwitchKnob = 24;
  static const EdgeInsets walletTokenHistoryRowPadding = EdgeInsets.all(14);
  static const double walletTokenTabsHeight = 54;
  static const double walletTokenTabIndicatorInset = 7;
  static const double walletNetworkActionIconBox = 32;
  static const double walletNetworkActionIcon = 18;
  static const double walletNetworkStatHeight = 48;
  static const EdgeInsets walletNetworkStatPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 5,
  );
  static const double walletNetworkStatTextGap = x2;
  static const double walletNetworkProgressHeight = 5;
  static const double walletNetworkAvailabilityHeight = 30;
  static const EdgeInsets walletNetworkNotePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 9,
  );
  static const EdgeInsets walletNetworkSummaryPadding = EdgeInsets.fromLTRB(
    20,
    21,
    20,
    20,
  );
  static const double walletNetworkSummaryIcon = 44;
  static const double walletNetworkSummaryIconGlyph = 23;
  static const double walletNetworkSummaryStatHeight = 59;
  static const double walletNetworkLegendIcon = 22;
  static const double walletNetworkLegendIconGlyph = 12;
  static const EdgeInsets walletNetworkDisclaimerPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const EdgeInsets walletNetworkHealthPillPadding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: 4,
  );
  static const double walletNetworkHealthPillRadius = 7;
  static const double walletPendingBottomInsetVisual =
      walletBottomInsetVisualChrome;
  static const double walletPendingBottomInsetNative =
      walletBottomInsetNativeChrome;
  static const double walletPendingPageTopPadding = 12;
  static const double walletPendingContentGap = 16;
  static const double walletPendingSummaryHeight = 78;
  static const EdgeInsets walletPendingSummaryPadding = EdgeInsets.all(16);
  static const double walletPendingSummaryIconBox = 44;
  static const double walletPendingSummaryIconGlyph = 22;
  static const double walletPendingRefreshButton = 34;
  static const double walletPendingRefreshGlyph = 16;
  static const double walletPendingChipHeight = 30;
  static const EdgeInsets walletPendingChipPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double walletPendingChipGap = 10;
  static const EdgeInsets walletPendingCardPadding = EdgeInsets.all(16);
  static const double walletPendingAssetIconBox = 40;
  static const double walletPendingAssetIconGlyph = 20;
  static const double walletPendingRowGap = 12;
  static const double walletPendingInlineGap = rowGap;
  static const double walletPendingTextGap = walletAssetSmallGap;
  static const double walletPendingProgressGap = 10;
  static const double walletPendingProgressBlockGap = 18;
  static const double walletPendingStatusGap = 14;
  static const double walletPendingProgressHeight = 6;
  static const double walletPendingProgressDot = 6;
  static const EdgeInsets walletPendingBadgePadding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: x1,
  );
  static const double walletPendingNoticeMinHeight = 34;
  static const EdgeInsets walletPendingNoticePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 9,
  );
  static const double walletPendingNoticeIcon = 14;
  static const EdgeInsets walletPendingDetailsPadding = EdgeInsets.fromLTRB(
    12,
    11,
    12,
    10,
  );
  static const double walletPendingDetailsGap = 9;
  static const double walletPendingTxGap = 6;
  static const double walletPendingCopyHeight = 24;
  static const EdgeInsets walletPendingCopyPadding = EdgeInsets.symmetric(
    horizontal: rowGap,
  );
  static const double walletPendingCopyIcon = 11;
  static const double walletPendingCopyGap = x1;
  static const double walletPendingEmptyVerticalPadding = 64;
  static const EdgeInsets walletPendingEmptyPadding = EdgeInsets.symmetric(
    vertical: walletPendingEmptyVerticalPadding,
  );
  static const double walletPendingEmptyIconBox = 64;
  static const double walletPendingEmptyIconGlyph = 32;
  static const EdgeInsets walletPendingInfoPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static EdgeInsets walletPendingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        walletPendingPageTopPadding,
        contentPad,
        bottomInset,
      );
  static const double walletAnalyticsBottomInsetVisual =
      walletBottomInsetVisualChrome;
  static const double walletAnalyticsBottomInsetNative =
      walletBottomInsetNativeChrome;
  static const double walletAnalyticsPageTopPadding = 13;
  static const double walletAnalyticsContentGap = 18;
  static EdgeInsets walletAnalyticsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        walletAnalyticsPageTopPadding,
        contentPad,
        bottomInset,
      );
  static const double walletAnalyticsSummaryHeight = 252;
  static const EdgeInsets walletAnalyticsSummaryPadding = EdgeInsets.fromLTRB(
    20,
    22,
    20,
    20,
  );
  static const double walletAnalyticsSummaryGap = 16;
  static const double walletAnalyticsReturnPillWidth = 164;
  static const double walletAnalyticsReturnPillHeight = 23;
  static const EdgeInsets walletAnalyticsReturnPillPadding =
      EdgeInsets.symmetric(horizontal: rowGap);
  static const double walletAnalyticsReturnPillIcon = 13;
  static const double walletAnalyticsReturnPillGap = x1;
  static const double walletAnalyticsReturnMetaGap = 9;
  static const double walletAnalyticsQuickStatGap = 12;
  static const double walletAnalyticsQuickStatHeight = 78;
  static const EdgeInsets walletAnalyticsQuickStatPadding = EdgeInsets.fromLTRB(
    12,
    8,
    12,
    7,
  );
  static const double walletAnalyticsQuickStatTextGap = x2;
  static const double walletAnalyticsSwitcherHeight = 46;
  static const EdgeInsets walletAnalyticsSwitcherPadding = EdgeInsets.all(4);
  static const double walletAnalyticsSwitcherIcon = 14;
  static const double walletAnalyticsSwitcherIconGap = walletAssetSmallGap;
  static const double walletAnalyticsOverviewPeriodGap = 14;
  static const double walletAnalyticsOverviewChartGap = 16;
  static const double walletAnalyticsOverviewMetricsGap = 18;
  static const double walletAnalyticsPeriodHeight = 29;
  static const double walletAnalyticsChartHeight = 214;
  static const EdgeInsets walletAnalyticsChartPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    15,
  );
  static const EdgeInsets walletAnalyticsMetricsPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    13,
  );
  static const double walletAnalyticsMetricsTitleGap = 17;
  static const double walletAnalyticsMetricRowHeight = 36;
  static const EdgeInsets walletAnalyticsAssetsHeaderPadding =
      walletAnalyticsMetricsPadding;
  static const double walletAnalyticsAssetRowMinHeight = 91;
  static const EdgeInsets walletAnalyticsAssetRowPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    13,
  );
  static const double walletAnalyticsAssetAvatar = 36;
  static const double walletAnalyticsAssetGap = 16;
  static const double walletAnalyticsAssetValueGap = 10;
  static const double walletAnalyticsAssetProgressHeight = 4;
  static const double walletAnalyticsAssetTopGap = 11;
  static const double walletAnalyticsAssetBottomGap = 13;
  static const EdgeInsets walletAnalyticsPlaceholderPadding = EdgeInsets.all(
    20,
  );
  static const double walletHealthBottomInsetVisual =
      walletBottomInsetVisualChrome;
  static const double walletHealthBottomInsetNative =
      walletBottomInsetNativeChrome;
  static const double walletHealthPageTopPadding = 12;
  static EdgeInsets walletHealthScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        walletHealthPageTopPadding,
        contentPad,
        bottomInset,
      );
  static const double walletHealthContentGap = 16;
  static const EdgeInsets walletHealthSheetPadding = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    24,
  );
  static const double walletHealthSheetGap = 16;
  static const double walletHealthTabsHeight = 54;
  static const double walletHealthTabIndicatorInset = 7;
  static const double walletHealthTabIndicatorHeight = 2;
  static const double walletHealthOverallHeight = 292;
  static const EdgeInsets walletHealthOverallPadding = EdgeInsets.fromLTRB(
    16,
    22,
    16,
    20,
  );
  static const double walletHealthCardGap = 10;
  static const double walletHealthGaugeSize = 160;
  static const double walletHealthScoreGap = rowGap;
  static const double walletHealthRadarHeight = 325;
  static const EdgeInsets walletHealthRadarPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    16,
  );
  static const double walletHealthMetricHeight = 60;
  static const EdgeInsets walletHealthMetricPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    11,
  );
  static const double walletHealthMetricValueGap = rowGap;
  static const double walletHealthProgressHeight = 6;
  static const double walletHealthTrendHeight = 205;
  static const EdgeInsets walletHealthTrendPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    14,
  );
  static const double walletHealthTrendGap = 12;
  static const EdgeInsets walletHealthCardPadding = EdgeInsets.all(16);
  static const EdgeInsets walletHealthCompactCardPadding = EdgeInsets.all(12);
  static const double walletHealthRecommendationGap = 12;
  static const double walletHealthActionHeight = 34;
  static const double walletHealthActionIcon = 14;
  static const double walletHealthInlineGap = rowGap;
  static const double walletHealthNoticeGap = 10;
  static const double walletHealthSummaryIconBox = 48;
  static const double walletHealthSummaryIconGlyph = 24;
  static const double walletHealthSummaryTextGap = 6;
  static const double walletHealthChecklistIconBox = 24;
  static const double walletHealthChecklistIconGlyph = 14;
  static const double walletHealthPieHeight = 200;
  static const double walletHealthSectionGap = 12;
  static const double walletHealthLegendSpacing = 20;
  static const double walletHealthLegendRunSpacing = 10;
  static const double walletHealthLegendWidth = 156;
  static const double walletHealthLegendSwatch = 12;
  static const double walletHealthConcentrationGap = 14;
  static const double walletHealthAllocationGap = 10;
  static const double walletHealthSectionMarkerWidth = 4;
  static const double walletHealthSectionMarkerHeight = 14;
  static const double walletHealthSectionLabelGap = 6;
  static const EdgeInsets walletHealthBadgePadding = EdgeInsets.symmetric(
    horizontal: rowGap,
    vertical: x1,
  );
  static const EdgeInsets walletDustScrollPadding = EdgeInsets.fromLTRB(
    contentPad,
    14,
    contentPad,
    16,
  );
  static const double walletDustContentGap = 16;
  static const double walletDustInlineFooterHeightThreshold = 1000;
  static const double walletDustInlineFooterBottomGap = 96;
  static const EdgeInsets walletDustSheetPadding = EdgeInsets.fromLTRB(
    20,
    18,
    20,
    20,
  );
  static const double walletDustSheetGap = 16;
  static const EdgeInsets walletDustPreviewPadding = EdgeInsets.all(14);
  static const double walletDustPreviewGap = 14;
  static const EdgeInsets walletDustHeroPadding = EdgeInsets.all(20);
  static const double walletDustHeroIconBox = 48;
  static const double walletDustHeroIconGlyph = 25;
  static const double walletDustHeroHeaderGap = 13;
  static const double walletDustHeroTitleGap = rowGap;
  static const double walletDustHeroStatsGap = 11;
  static const double walletDustHeroStatGap = rowGap;
  static const double walletDustHeroStatHeight = 52;
  static const EdgeInsets walletDustHeroStatPadding = EdgeInsets.symmetric(
    horizontal: rowGap,
    vertical: x2,
  );
  static const double walletDustAssetRowHeight = 59;
  static const EdgeInsets walletDustAssetRowPadding = EdgeInsets.fromLTRB(
    12,
    walletAssetSmallGap,
    12,
    walletAssetSmallGap,
  );
  static const double walletDustCheckboxIcon = 18;
  static const double walletDustAssetCheckboxGap = 13;
  static const double walletDustTokenLogo = 34;
  static const double walletDustAssetInfoGap = 12;
  static const double walletDustTextGap = walletAssetSmallGap;
  static const double walletDustTargetGap = 10;
  static const double walletDustTargetHeight = buttonStandard + x2;
  static const EdgeInsets walletDustTargetPadding = EdgeInsets.fromLTRB(
    14,
    rowGap,
    14,
    rowGap,
  );
  static const double walletDustTargetLogoGap = 11;
  static const double walletDustTargetTextGap = walletAssetSmallGap;
  static const double walletDustSelectAllHeight = 34;
  static const EdgeInsets walletDustSelectAllPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double walletDustSelectAllIcon = 17;
  static const double walletDustSelectAllGap = 10;
  static const double walletDustAssetListTopGap = 16;
  static const double walletDustAssetRowGap = rowGap;
  static const double walletDustFooterHorizontalPadding = contentPad;
  static const double walletDustFooterTopPadding = 16;
  static const double walletDustFooterBottomPadding = 6;
  static const double walletDustButtonHeight = ctaHeight;
  static const double walletDustPreviewRowGap = 11;
  static const EdgeInsets walletDustConvertedPadding = EdgeInsets.all(13);
  static const double walletDustConvertedIcon = 19;
  static const double walletDustConvertedGap = 10;
  static const double walletDustSectionMarkerWidth = 4;
  static const double walletDustSectionMarkerHeight = 15;
  static const double walletDustSectionLabelGap = walletAssetSmallGap;
  static const double walletGasBottomInsetVisual =
      walletBottomInsetVisualChrome;
  static const double walletGasBottomInsetNative =
      walletBottomInsetNativeChrome;
  static const double walletGasPageTopPadding = 13;
  static EdgeInsets walletGasScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        walletGasPageTopPadding,
        contentPad,
        bottomInset,
      );
  static const double walletGasContentGap = 16;
  static const double walletGasSecondaryContentGap = 14;
  static const double walletGasTabsHeight = 54;
  static const double walletGasTabIndicatorInset = 7;
  static const double walletGasTabIndicatorHeight = 2;
  static const double walletGasStatusHeight = 88;
  static const EdgeInsets walletGasStatusPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    14,
  );
  static const double walletGasIcon = 17;
  static const double walletGasIconGap = rowGap;
  static const double walletGasSectionMarkerWidth = 4;
  static const double walletGasSectionMarkerHeight = 14;
  static const double walletGasSectionLabelGap = 6;
  static const double walletGasLevelHeight = 85;
  static const EdgeInsets walletGasLevelPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    15,
  );
  static const double walletGasLevelBadgeGap = rowGap;
  static const double walletGasLevelMetaGap = 12;
  static const double walletGasLevelValueGap = 10;
  static const double walletGasLevelProgressHeight = 4;
  static const double walletGasBadgeHeight = 18;
  static const double walletGasRecommendedBadgeHeight = 17;
  static const EdgeInsets walletGasBadgePadding = EdgeInsets.symmetric(
    horizontal: rowGap,
  );
  static const EdgeInsets walletGasSmallBadgePadding = EdgeInsets.symmetric(
    horizontal: walletAssetSmallGap,
  );
  static const double walletGasComparisonHeight = 260;
  static const EdgeInsets walletGasComparisonPadding = EdgeInsets.fromLTRB(
    16,
    20,
    16,
    17,
  );
  static const double walletGasComparisonTitleGap = 17;
  static const double walletGasComparisonRowGap = 15;
  static const double walletGasComparisonTextGap = walletAssetSmallGap;
  static const double walletGasRefreshHeight = 41;
  static const double walletGasRefreshIcon = 15;
  static const double walletGasChartLargeHeight = 254;
  static const double walletGasChartSmallHeight = 194;
  static const EdgeInsets walletGasChartPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    16,
  );
  static const double walletGasChartGap = 14;
  static const EdgeInsets walletGasBestTimePadding = EdgeInsets.all(16);
  static const double walletGasBestTimeTextGap = 6;
  static const double walletGasBestTimeMetricGap = 14;
  static const double walletGasBestTimeColumnGap = 12;
  static const double walletGasBestTimeValueGap = rowGap;
  static const EdgeInsets walletGasTipPadding = EdgeInsets.all(16);
  static const double walletGasTipIconBox = 32;
  static const double walletGasTipIcon = 17;
  static const double walletGasTipIconGap = 10;
  static const double walletGasTipTitleGap = rowGap;
  static const double walletGasTipFooterGap = 10;
  static const double walletGasSavingIcon = 13;
  static const double walletGasQuickActionsTitleGap = 12;
  static const double walletGasQuickActionBottomGap = rowGap;
  static const double walletGasQuickActionHeight = 44;
  static const EdgeInsets walletGasQuickActionPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double walletGasQuickActionIcon = 16;
  static const double walletGasQuickActionIconGap = 9;
  static const double walletGasQuickActionArrow = 15;
  static const double walletGasLineChartInsetX = 10;
  static const double walletGasLineChartInsetTop = 4;
  static const double walletGasLineChartInsetBottom = 24;
  static const double walletGasChartStroke = 2;
  static const double walletGasNetworkBarHeightInset = 10;
  static const double walletGasNetworkBarLeftPadding = 12;
  static const double walletGasNetworkBarWidthDivisor = 2.2;
  static const double walletGasNetworkBarGapMultiplier = 1.2;
  static const double walletManagerRiskGap = 14;
  static const double walletManagerTabsHeight = 54;
  static const double walletManagerTabIndicatorInset = 7;
  static const double walletManagerTabIndicatorHeight = 2;
  static const double walletManagerSectionMarkerWidth = 4;
  static const double walletManagerSectionMarkerHeight = 14;
  static const double walletManagerSectionLabelGap = 6;
  static const double walletManagerTinyButton = 14;
  static const double walletManagerTinyIcon = 11;
  static const double walletManagerDefaultBadgeHeight = 17;
  static const double walletManagerAssetChipHeight = 18;
  static const double walletManagerTypeBadgeHeight = 19;
  static const EdgeInsets walletManagerCompactBadgePadding =
      EdgeInsets.symmetric(horizontal: walletAssetSmallGap);
  static const EdgeInsets walletManagerBadgePadding = EdgeInsets.symmetric(
    horizontal: rowGap,
  );
  static const double walletManagerButtonIcon = 18;
  static const double walletManagerButtonIconGap = rowGap;
  static const double walletManagerSecurityMinHeight = 58;
  static const EdgeInsets walletManagerSecurityPadding = EdgeInsets.fromLTRB(
    14,
    12,
    14,
    12,
  );
  static const double walletManagerSecurityIconTop = 1;
  static const double walletManagerSecurityIcon = 14;
  static const double walletManagerSecurityGap = 10;
  static const double walletManagerSummaryHeight = 148;
  static const EdgeInsets walletManagerSummaryPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double walletManagerSummaryTitleGap = 14;
  static const double walletManagerSummaryValueGap = 9;
  static const double walletManagerSummaryTrendIcon = 15;
  static const double walletManagerSummaryTrendGap = 4;
  static const double walletManagerSummaryMetricGap = 10;
  static const double walletManagerDistributionHeight = 245;
  static const EdgeInsets walletManagerDistributionPadding =
      EdgeInsets.fromLTRB(16, 18, 16, 16);
  static const double walletManagerDistributionTitleGap = 12;
  static const double walletManagerDistributionCenterY = .54;
  static const double walletManagerDistributionRadiusFactor = .315;
  static const double walletManagerDistributionStroke = 27;
  static const double walletManagerDistributionArcGap = .033;
  static const double walletManagerAllSummaryGap = 16;
  static const double walletManagerAllDistributionGap = 17;
  static const double walletManagerAllSectionGap = rowGap;
  static const double walletManagerAllWalletGap = 14;
  static const double walletManagerAllAddTopGap = 18;
  static const double walletManagerAllSecurityTopGap = 16;
  static const double walletManagerWalletCardHeight = 200;
  static const EdgeInsets walletManagerWalletCardPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    14,
  );
  static const double walletManagerWalletIconGap = 10;
  static const double walletManagerWalletBadgeGap = walletAssetSmallGap;
  static const double walletManagerWalletFavoriteIcon = 13;
  static const double walletManagerWalletAddressGap = 9;
  static const double walletManagerWalletInlineGap = rowGap;
  static const double walletManagerWalletActionGap = walletAssetSmallGap;
  static const double walletManagerWalletMoreGap = 6;
  static const double walletManagerWalletMoreIcon = 18;
  static const double walletManagerWalletBalanceBlockGap = 20;
  static const double walletManagerWalletBalanceLabelGap = 9;
  static const double walletManagerWalletBalanceValueGap = rowGap;
  static const double walletManagerWalletTrendIcon = 13;
  static const double walletManagerWalletTrendGap = x1;
  static const double walletManagerWalletAssetTopGap = 17;
  static const double walletManagerWalletAssetGap = rowGap;
  static const double walletManagerWalletDividerHeight = 1;
  static const double walletManagerWalletFooterGap = 10;
  static const double walletManagerWalletFooterIcon = 11;
  static const double walletManagerWalletFooterIconGap = x2;
  static const double walletManagerWalletTypeIconBox = 36;
  static const double walletManagerWalletTypeIcon = 18;
  static const double walletManagerGroupsSectionGap = 10;
  static const double walletManagerGroupCardGap = 12;
  static const double walletManagerGroupCreateTopGap = 14;
  static const double walletManagerGroupCreateHeight = 46;
  static const double walletManagerGroupCreateIcon = 16;
  static const double walletManagerGroupCreateIconGap = rowGap;
  static const EdgeInsets walletManagerGroupCardPadding = EdgeInsets.all(16);
  static const double walletManagerGroupSwatch = 12;
  static const double walletManagerGroupSwatchGap = rowGap;
  static const double walletManagerGroupMoreIcon = 18;
  static const double walletManagerGroupMetaGap = 13;
  static const double walletManagerGroupValueGap = rowGap;
  static const double walletManagerGroupWalletGap = rowGap;
  static const double walletManagerGroupWalletRowHeight = 48;
  static const EdgeInsets walletManagerGroupWalletRowPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const double walletManagerGroupWalletTextGap = 6;
  static const double walletManagerActivitySectionGap = 10;
  static const double walletManagerActivityRowGap = 10;
  static const double walletManagerActivityRowHeight = 62;
  static const EdgeInsets walletManagerActivityRowPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const double walletManagerActivityIconBox = 32;
  static const double walletManagerActivityIcon = 16;
  static const double walletManagerActivityIconGap = 10;
  static const double walletManagerActivityTextGap = walletAssetSmallGap;
  static const double walletManagerActivityTimeGap = rowGap;
  static const double tradeBottomInsetVisual = 54;
  static const double tradeBottomInsetNative = 20;
  static const double tradeHistoryBottomInsetVisual = 42;
  static const double tradeHistoryBottomInsetNative = 20;
  static const double tradeHorizontalPadding = contentPad;
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
  static const double tradePageContentGap = x3;

  static const double tradeSectionGap = 20;
  static const double tradeHeaderLogo = 32;
  static const EdgeInsets tradeHeaderBodyPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: rowGap,
  );
  static const double tradeHeaderChevronGap = x2;
  static const double tradeHeaderChevron = 18;
  static const double tradeHeaderTrailingWidth = 128;
  static const double tradeQuickNavHeight = 74;
  static const EdgeInsets tradeQuickNavPadding = EdgeInsets.symmetric(
    horizontal: tradeHorizontalPadding,
    vertical: 6,
  );
  static const double tradeQuickNavGap = rowGap;
  static const double tradeQuickChipWidth = 96;
  static const EdgeInsets tradeQuickChipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: walletAssetSmallGap,
  );
  static const double tradeQuickChipIcon = 15;
  static const double tradeQuickChipIconGap = x2;
  static const double tradeQuickChipBadgeGap = 6;
  static const double tradeQuickChipBadgeMaxWidth = 74;
  static const EdgeInsets tradeQuickChipBadgePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: hairlineStroke,
  );
  static const EdgeInsets tradeDataTabsPadding = EdgeInsets.fromLTRB(
    tradeHorizontalPadding,
    4,
    tradeHorizontalPadding,
    rowGap,
  );
  static const double tradeDataTabsHeight = 34;
  static const double vitPresetChipRowGap = x1;
  static const double vitPresetChipRowHeight = buttonCompact;
  static const double tradeChartHeight = 122;
  static const double tradeChartOverlayInset = 10;
  static const double tradeChartOverlayTop = 12;
  static const double tradeChartLogoSize = 44;
  static const double copyTradingBottomInsetVisual = 126;
  static const double copyTradingBottomInsetNative = 28;
  static const double copyTradingHeroPanelPaddingValue = contentPad;
  static const double copyTradingHeroAumPaddingValue = 16;
  static const double copyTradingHeroMetricPaddingValue = rowPy;
  static const double copyTradingHeroGap = cardGap - x1;
  static const double copyTradingHeroMetricGap = x4 - x1;
  static const double copyTradingHeroLabelGap = x4 - x1;
  static const double copyTradingMetricIcon =
      tradeBotSmallIcon + hairlineStroke / 2;
  static const double copyTradingMetricIconGap = tradeBotNarrowIconGap;
  static const double copyTradingMetricCellGap = hairlineStroke;
  static const double copyTradingWeeklyTitleGap = tradeBotNarrowIconGap;
  static const double copyTradingWeeklyChartHeight =
      buttonCompact - tradeBotNarrowIconGap;
  static const double copyTradingWeeklyStrokeWidth = borderWidth;
  static const double copyTradingDisclaimerLineHeight = 1.5;
  static const double copyTradingDisclaimerTopPad = hairlineStroke;
  static const double copyTradingDisclaimerBottomPad = hairlineStroke * 2;
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
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double preCopyAssessmentBottomInsetVisualExtra = 104;
  static const double preCopyAssessmentBottomInsetNativeExtra = 28;
  static const double preCopyAssessmentContentTopPadding = x4 + x1;
  static const double preCopyAssessmentContentGap = x4 + x1 - hairlineStroke;
  static const double preCopyAssessmentQuestionCardGap = 12;
  static const EdgeInsets preCopyAssessmentCardPadding = EdgeInsets.all(
    x4 + x1,
  );
  static const EdgeInsets preCopyAssessmentOptionMargin = EdgeInsets.only(
    bottom: x3,
  );
  static const EdgeInsets preCopyAssessmentOptionCardPadding = EdgeInsets.all(
    x4 - x1,
  );
  static EdgeInsets preCopyAssessmentScrollPadding(double bottomInset) =>
      contentInsets.copyWith(
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
    top: walletAddressEmptyIconSize,
  );
  static EdgeInsets copyProviderDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double positionDashboardLabelLineHeight = 1.1;
  static const double positionDashboardTightLineHeight =
      tradeBotLineHeightTight;
  static const double futuresPriceLineHeight = tradeBotLineHeightTight;
  static const double futuresMarketStatCardHeight = walletAddressStatsHeight;
  static const double futuresSideSwitchHeight = 56;
  static const double futuresOrderTypeSelectorHeight = searchBarCompactHeight;
  static const double futuresPercentButtonLineHeight = tradeBotLineHeightTight;
  static const double futuresSafetyTitleLineHeight = 1.1;
  static const double convertPairSparklineWidth = 72;
  static const double convertPairSparklineHeight = 31;
  static const double convertSlippageCardHeight = 108;
  static const double convertModeTabHeight = searchBarCompactHeight;
  static const double convertControlHeight = buttonCompact + x1;
  static const double convertChipHeight = buttonCompact - x3;
  static const double convertFavoriteChipHeight = searchBarCompactHeight;
  static const double convertHeroFlipSize = buttonCompact + x1;
  static const double convertSubmitHeight = searchBarCompactHeight;
  static const double convertStickyCtaClearance = ctaHeight + x5;
  static const double dustStickyFooterClearance = ctaHeight + x6;
  static const double launchpadSwapStickyCtaClearance =
      convertStickyCtaClearance;
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
      EdgeInsets.fromLTRB(contentPad, cardGap, contentPad, bottomInset);
  static const EdgeInsets copyPerformanceTradeCardPadding = EdgeInsets.all(
    rowPy,
  );
  static const EdgeInsets copyPerformanceCostItemPadding = EdgeInsets.only(
    bottom: x3,
  );
  static const EdgeInsets copyPerformanceMetricItemPadding = EdgeInsets.only(
    bottom: walletAssetPillGap,
  );
  static const EdgeInsets copyPerformanceInfoBoxPadding = EdgeInsets.all(x4);
  static const EdgeInsets copyPerformanceInfoLinePadding = EdgeInsets.only(
    bottom: x1,
  );
  static const EdgeInsets copyPerformanceReturnCardPadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: rowGapRegular);
  static const double providerComparisonBottomInsetVisualExtra = 26;
  static const double providerComparisonBottomInsetNativeExtra = 14;
  static const double providerComparisonWarningLineHeight =
      tradeBotLineHeightReadable;
  static const double providerComparisonLegendLineHeight =
      tradeBotLineHeightBody;
  static EdgeInsets providerComparisonScrollPadding(double bottomInset) =>
      contentInsets.copyWith(top: x4 - x1, bottom: bottomInset);
  static const EdgeInsets providerComparisonPanelPadding = EdgeInsets.all(
    x4 - x1,
  );
  static const EdgeInsets providerComparisonMetricHeaderPadding =
      EdgeInsets.only(left: x4 - x1, bottom: ctaLoadingIcon);
  static const EdgeInsets providerComparisonMetricLabelPadding =
      EdgeInsets.only(left: x4 - x1);
  static const EdgeInsets providerComparisonCategoryPadding = EdgeInsets.only(
    left: x3,
  );
  static const double bestExecutionActionButtonHeight = 40;
  static const double bestExecutionSummaryLineHeight = 1;
  static const double bestExecutionReportTitleLineHeight =
      tradeBotLineHeightCaption;
  static const double bestExecutionReportMetaLineHeight =
      tradeBotLineHeightBody;
  static const EdgeInsets bestExecutionSummaryCardPadding = EdgeInsets.fromLTRB(
    x4 - x1,
    x4,
    x4 - x1,
    x4 - x1,
  );
  static const EdgeInsets bestExecutionReportActionsPadding = EdgeInsets.all(
    x4 + x1,
  );
  static const EdgeInsets bestExecutionArchiveReportPadding = EdgeInsets.all(
    x4,
  );
  static const EdgeInsets bestExecutionNoticePadding = EdgeInsets.fromLTRB(
    x4 - x1,
    x3 + x1,
    x3,
    x3 + x1,
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
    bottom: x4 + x1,
  );
  static const EdgeInsets providerApplicationConsentPadding = EdgeInsets.all(
    x4 + x1 - hairlineStroke,
  );
  static const EdgeInsets providerApplicationPanelPadding = EdgeInsets.all(
    x4 + x1,
  );
  static const EdgeInsets providerApplicationInputContentPadding =
      EdgeInsets.symmetric(
        horizontal: x4 + x1 - hairlineStroke,
        vertical: x4 - x1,
      );
  static const EdgeInsets providerApplicationBenefitCardPadding =
      EdgeInsets.symmetric(horizontal: x4 - x1, vertical: x3 + hairlineStroke);
  static const EdgeInsets providerApplicationResponsibilityItemPadding =
      EdgeInsets.only(bottom: x1);
  static const EdgeInsets providerApplicationRequirementPreviewPadding =
      EdgeInsets.symmetric(horizontal: x4 - x1);
  static const double copyAuditBottomInsetVisualExtra = 118;
  static const double copyAuditBottomInsetNativeExtra = 28;
  static EdgeInsets copyAuditScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const EdgeInsets copyAuditSheetPadding = transferSheetPadding;
  static const EdgeInsets copyAuditNoticePadding = EdgeInsets.fromLTRB(
    cardGap,
    cardGap,
    cardGap,
    rowGapRegular,
  );
  static const EdgeInsets copyAuditSummaryTitlePadding = EdgeInsets.only(
    left: walletAssetPillGap,
  );
  static const EdgeInsets copyAuditMetadataConfigPadding = EdgeInsets.symmetric(
    horizontal: walletAssetPillGap,
  );
  static const EdgeInsets copyAuditMetadataPanelPadding = EdgeInsets.all(
    walletAssetPillGap,
  );
  static const EdgeInsets copyAuditExportButtonPadding = EdgeInsets.all(x4);
  static const double copyAuditNoticeLineHeight = tradeBotLineHeightBody;
  static const double copyAuditSheetTitleLineHeight = tradeBotLineHeightCompact;
  static const double copyAuditEventTitleLineHeight = tradeBotLineHeightCaption;
  static const double copyAuditEventDescriptionLineHeight =
      tradeBotLineHeightCompact;
  static const double copyAuditMetaLineHeight = tradeBotLineHeightTight;
  static const double copyAuditExportLineHeight = tradeBotLineHeightShort;
  static const double copyAuditMetadataConfigHeight =
      walletTransactionSummaryStatusIcon;
  static const double copyAuditSummaryCardHeight = 69;
  static const double exPostCostsReportNoticeIcon = x4 + x1;
  static const double exPostCostsReportNoticeIconGap = x3 + hairlineStroke;
  static const double exPostCostsReportNoticeBodyGap = x3;
  static const double exPostCostsReportSummaryHeight = 46;
  static const double exPostCostsReportSummaryLineHeight =
      tradeBotLineHeightCaption;
  static const double exPostCostsReportBreakdownTitleTop = x3 + hairlineStroke;
  static const double exPostCostsReportBreakdownEstimateGap =
      rowGap + dividerHairline;
  static const double exPostCostsReportBreakdownNoteGap = x5 + dividerHairline;
  static const double exPostCostsReportVarianceNoteIcon = rowGap + x1;
  static const double exPostCostsReportVarianceNoteIconGap =
      x1 + hairlineStroke;
  static const double exPostCostsReportLineHeightTight =
      tradeBotLineHeightTight;
  static const double exPostCostsReportLineHeightBody = tradeBotLineHeightBody;
  static const double exPostCostsReportVarianceGap = contentPad;
  static const EdgeInsets exPostCostsReportNoticePadding = EdgeInsets.fromLTRB(
    x3 + hairlineStroke,
    0,
    x3,
    0,
  );
  static const EdgeInsets exPostCostsReportSummaryPadding = EdgeInsets.fromLTRB(
    x3 + hairlineStroke,
    x4 + hairlineStroke,
    x3 + hairlineStroke,
    x4,
  );
  static const EdgeInsets exPostCostsReportBreakdownPadding =
      EdgeInsets.fromLTRB(x4 + x1, x4 + x1, x4 + x1, x4 + hairlineStroke);
  static const EdgeInsets exPostCostsReportBreakdownTitlePadding =
      EdgeInsets.only(top: exPostCostsReportBreakdownTitleTop);
  static const EdgeInsets exPostCostsReportVarianceNoteHigherPadding =
      EdgeInsets.fromLTRB(x3 + hairlineStroke, x3, x3 + hairlineStroke, x3);
  static const EdgeInsets exPostCostsReportVarianceNoteLowerPadding =
      EdgeInsets.fromLTRB(x3, x3, x3 + hairlineStroke, x3);
  static const EdgeInsets exPostCostsReportVariancePadding =
      EdgeInsets.fromLTRB(x4 + x1, x5, x4 + x1, x4 + x1);
  static const EdgeInsets exPostCostsReportVarianceBodyPadding =
      EdgeInsets.fromLTRB(x4 - x1, x4, x4 - x1, x4 - x1);
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
    bottom: sectionGapRegular,
  );
  static const EdgeInsets copySettingsModeButtonPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets copySettingsNotificationPadding =
      EdgeInsets.symmetric(horizontal: cardGap, vertical: walletAssetPillGap);
  static const EdgeInsets copySettingsToggleKnobMargin = EdgeInsets.all(x1);
  static const EdgeInsets copySettingsChannelPadding = EdgeInsets.symmetric(
    horizontal: cardGap,
  );
  static EdgeInsets copySettingsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double complaintSubmissionBottomInsetVisual = buttonCompact - x2;
  static const double complaintSubmissionBottomInsetNative = x5 + x1;
  static const double complaintSubmissionTopInset = x5 + x2 + hairlineStroke;
  static const double complaintSubmissionSectionGap = rowPy;
  static const double complaintSubmissionFooterHeight = x7 + x4;
  static const double complaintSubmissionLineHeightTight = 1;
  static const double complaintSubmissionLineHeightShort = 1.2;
  static const double complaintSubmissionLineHeightBody = 1.35;
  static const double complaintSubmissionLineHeightHint = 1.4;
  static const double complaintSubmissionLineHeightReadable = 1.45;
  static const double complaintSubmissionLineHeightLong = 1.5;
  static const double complaintSubmissionMultilineHeight =
      walletAddressCardHeight + dividerHairline;
  static const double complaintSubmissionSingleLineHeight =
      walletTransactionExplorerHeight;
  static const double complaintSubmissionEvidenceHeight =
      walletDepositWarningCardMinHeight + tradeBotRowGap;
  static const double complaintSubmissionCheckboxSize =
      iconMd + dividerHairline;
  static const EdgeInsets complaintSubmissionFooterPadding =
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, x1);
  static const EdgeInsets complaintSubmissionNoticePadding = EdgeInsets.all(x4);
  static const EdgeInsets complaintSubmissionCategoryPadding =
      EdgeInsets.symmetric(horizontal: x4);
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
        contentPad,
        complaintSubmissionTopInset,
        contentPad,
        bottomInset,
      );
  static EdgeInsets complaintSubmissionFooterInset(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double complaintCaseBottomInsetVisual =
      buttonCompact + x1 + hairlineStroke;
  static const double complaintCaseBottomInsetNative = x5 + x1;
  static const double complaintCaseCompactGap = contentPad - x3;
  static const double complaintCaseLineHeightTight = 1;
  static const double complaintCaseLineHeightSlight = 1.1;
  static const double complaintCaseLineHeightTitle = 1.15;
  static const double complaintCaseLineHeightBody =
      complaintSubmissionLineHeightShort;
  static const double complaintCaseLineHeightDense = 1.25;
  static const double complaintCaseLineHeightReadable =
      complaintSubmissionLineHeightHint;
  static const double complaintCaseIconNudge = dividerHairline;
  static const double complaintCaseSmallIcon = walletAddressActionIcon;
  static const double complaintCaseActionIcon = walletAddressAddAgreementIcon;
  static const double complaintCaseTrailingIcon = tradeBotDisputeTabBadgeSize;
  static const EdgeInsets complaintCaseCardPadding = cardPaddingCompact;
  static const EdgeInsets complaintCaseTitleNudgePadding = EdgeInsets.only(
    top: x1,
  );
  static const EdgeInsets complaintCaseIconNudgePadding = EdgeInsets.only(
    top: complaintCaseIconNudge,
  );
  static EdgeInsets complaintTrackingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        sectionGapCompact,
        contentPad,
        bottomInset,
      );
  static const double complaintTrackingSectionGap = sectionGapCompact;
  static const double complaintTrackingActionHeight =
      buttonCompact + x3 + hairlineStroke;
  static const double complaintTrackingTimelineRailWidth = 32;
  static const double complaintTrackingTimelineConnectorHeight =
      walletTokenHeroIcon;
  static const EdgeInsets complaintTrackingStatusCardPadding =
      EdgeInsets.fromLTRB(
        walletAddressActionIcon,
        walletAddressActionIcon,
        walletAddressActionIcon,
        copyTradingHeroAumPaddingValue,
      );
  static const EdgeInsets complaintTrackingMetricPadding = EdgeInsets.fromLTRB(
    x4,
    x3,
    x4,
    x3,
  );
  static const EdgeInsets complaintTrackingConnectorPadding =
      EdgeInsets.symmetric(vertical: dividerHairline);
  static const EdgeInsets complaintTrackingStepContentPadding = EdgeInsets.only(
    top: hairlineStroke,
    bottom: contentPad,
  );
  static EdgeInsets ombudsmanScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double ombudsmanSectionGap = complaintCaseCompactGap;
  static const EdgeInsets ombudsmanEligibilityPadding = EdgeInsets.fromLTRB(
    copyTradingHeroAumPaddingValue,
    contentPad - x2,
    copyTradingHeroAumPaddingValue,
    rowPy,
  );
  static const EdgeInsets ombudsmanProcessPadding = EdgeInsets.all(x4);
  static const double ombudsmanContactIconBox =
      buttonCompact + formFieldLabelGap;
  static const double complaintsHandlingBottomInsetVisual =
      x7 + sectionGapCompact + x2 - x1;
  static const double complaintsHandlingBottomInsetNative =
      x5 + x2 + x1 - hairlineStroke;
  static const double complaintsHandlingTopInset =
      buttonCompact - formFieldLabelGap - hairlineStroke;
  static const double complaintsHandlingPrimaryGap = x5;
  static const double complaintsHandlingReviewGap = x4;
  static const double complaintsHandlingStatsGap = x6;
  static const double complaintsHandlingTabGap = x5;
  static const double complaintsHandlingGridGap = complaintCaseCompactGap;
  static const double complaintsHandlingCategoryWidth = 194;
  static const double complaintsHandlingCategoryHeight =
      walletAddressSecurityCardHeight + x3;
  static const double complaintsHandlingTimelineStepSize =
      buttonCompact - x1 + hairlineStroke;
  static const double complaintsHandlingTimelineItemGap =
      copyTradingHeroAumPaddingValue;
  static const double complaintsHandlingTimelineLabelGap = formFieldLabelGap;
  static const double complaintsHandlingRightsIconGap = 10;
  static const double complaintsHandlingRightsBodyLineHeight =
      complaintSubmissionLineHeightBody;
  static const double complaintsHandlingOmbudsmanLineHeight =
      complaintSubmissionLineHeightReadable;
  static const EdgeInsets complaintsHandlingRightsPadding = EdgeInsets.fromLTRB(
    complaintCaseCompactGap,
    0,
    x3,
    0,
  );
  static const EdgeInsets complaintsHandlingCategoryPadding =
      EdgeInsets.fromLTRB(x4, walletAddressActionIcon + hairlineStroke, x4, x4);
  static const EdgeInsets complaintsHandlingTimelinePadding =
      EdgeInsets.fromLTRB(
        copyTradingHeroAumPaddingValue,
        walletAddressActionIcon,
        copyTradingHeroAumPaddingValue,
        walletAddressActionIcon,
      );
  static EdgeInsets complaintsHandlingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        complaintsHandlingTopInset,
        contentPad,
        bottomInset,
      );
  static const double copyTradingV2GlassHeroHeight = 300;
  static const double copyTradingV2BoldHeroHeight = 256;
  static const double copyTradingV2VariantMinHeight = 56;
  static const double copyTradingV2VariantButtonHeight =
      walletHistoryActionHeight;
  static const double copyTradingV2VariantButtonMinWidth = walletAssetLogoSize;
  static const double copyTradingV2SortTopRoiWidth = 78;
  static const double copyTradingV2SortAumWidth = 82;
  static const double copyTradingV2SortCopiersWidth = 108;
  static const double copyTradingV2SortDefaultWidth = 106;
  static const double copyTradingV2SortChipHeight = statusPillHeightLg;
  static const double copyTradingV2TraderCardHeight = 158;
  static const double copyTradingV2TraderAvatarStackWidth =
      walletTransactionExplorerHeight;
  static const double copyTradingV2TraderAvatarStackHeight = inputHeight;
  static const double copyTradingV2TraderAvatarSize =
      walletTransactionExplorerHeight;
  static const double copyTradingV2TraderTierBadgeSize = homeChipMinHeight;
  static const double copyTradingV2TraderTierBadgeIcon =
      statusPillIconSizeMd - hairlineStroke / 2;
  static const double copyTradingV2RoiMaxWidth = copyTradingV2SortDefaultWidth;
  static const double copyTradingV2DetailsButtonHeight = walletAddressIconSize;
  static const double copyTradingV2HeroIconBox =
      walletTransactionExplorerHeight;
  static const double copyTradingV2HeroIconGlyph =
      walletAssetActionIconInner + hairlineStroke / 2;
  static const double copyTradingV2GlassStatHeight = 112;
  static const double copyTradingV2GlassStatIconBox = walletAddressSwitchHeight;
  static const double copyTradingV2GlassStatIconGlyph = walletDepositCopyIcon;
  static const double copyTradingV2BoldStatHeight = walletAddressStatsHeight;
  static const double copyEducationIntroMinHeight = 96;
  static const double copyEducationModeMinHeight = 116;
  static const double copyEducationTabHeight = buttonStandard + statusPillGapLg;
  static const EdgeInsets copyEducationStepNumberPadding = EdgeInsets.only(
    top: rowGapRegular,
  );
  static const EdgeInsets liveMarketPairCardPadding = EdgeInsets.fromLTRB(
    contentPad - x4,
    rowPy + hairlineStroke / 2,
    contentPad - x4,
    sectionGapCompact,
  );
  static const double liveMarketPairCardHeight = buttonHero + x6 - x1;
  static const double liveMarketHeaderIcon = inputPrefixIcon;
  static const double liveMarketInlineIcon = statusPillIconSizeLg;
  static const double liveMarketTrendIcon = statusPillIconSizeLg + x1 / 2;
  static const double liveMarketTrendActionIcon = iconMd + hairlineStroke;
  static const double liveMarketRatioBarHeight = statusPillIconSizeMd;
  static const double liveMarketMetricMinHeight =
      buttonStandard + hairlineStroke;
  static const EdgeInsets liveMarketMetricPadding = EdgeInsets.symmetric(
    horizontal: statusPillHorizontalPaddingMd,
    vertical: statusPillHorizontalPaddingMd,
  );
  static const double liveMarketToggleHeight = buttonCompact + rowGap;
  static const EdgeInsets liveMarketTogglePadding = EdgeInsets.all(
    hairlineStroke * 2,
  );
  static const double liveMarketFundingCountdownHeight = buttonStandard - x1;
  static const EdgeInsets liveMarketFundingCountdownPadding =
      EdgeInsets.symmetric(horizontal: rowPy);
  static const double liveMarketFundingChartHeight = buttonStandard + x4 - x1;
  static const EdgeInsets liveMarketFundingChartPadding = EdgeInsets.fromLTRB(
    0,
    rowGap,
    0,
    formFieldLabelGap,
  );
  static const double liveMarketTopTraderHighlightHeight =
      buttonHero + buttonCompact;
  static const double liveMarketTrendActionBox = buttonCompact + rowGap;
  static const EdgeInsets liveMarketInfoPadding = EdgeInsets.symmetric(
    horizontal: rowGapRelaxed,
    vertical: statusPillHorizontalPaddingMd,
  );
  static const EdgeInsets liveMarketRowPadding = EdgeInsets.all(rowGapRegular);
  static const double liveMarketPairValueGap = statusPillHorizontalPaddingMd;
  static const double liveMarketCardGap = rowGapRelaxed;
  static const double marginTradingHubHeroStatHeight = 85;
  static const double marginTradingHubMenuItemMinHeight = 92;
  static const double marginTradingHubNavIconSize = iconMd + hairlineStroke / 2;
  static const double marginTradingHubChevronIcon = iconMd + hairlineStroke;
  static const double marginTradingHubFeatureCheckIcon = x4 + x1;
  static const double marginTradingHubComplianceIcon = x4 + x1;
  static const double marginTradingHubComplianceGap = rowGap + dividerHairline;
  static const double marginTradingHubComplianceBodyGap = tradeBotNarrowIconGap;
  static const int marginTradingHubComplianceGridColumns = 2;
  static const double marginTradingHubComplianceGridExtent =
      buttonCompact + hairlineStroke;
  static const double marginTradingHubComplianceGridCrossGap = tradeBotRowGap;
  static const double marginTradingHubComplianceGridMainGap = x3;
  static const double marginTradingHubLineHeightTight = tradeBotLineHeightTight;
  static const double marginTradingHubLineHeightTitle = 1.1;
  static const double marginTradingHubLineHeightCaption =
      tradeBotLineHeightCaption;
  static const double marginTradingHubLineHeightBody =
      tradeBotLineHeightReadable;
  static const EdgeInsets marginTradingHubComplianceInfoPadding =
      tradeToolAlertPadding;
  static EdgeInsets transactionReportingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const EdgeInsets transactionReportingStatsPanelPadding =
      EdgeInsets.all(contentPad - x1);
  static const EdgeInsets transactionReportingStatCardPadding =
      EdgeInsets.fromLTRB(x4, x4, rowGapRegular, rowGapRegular + x1);
  static const EdgeInsets transactionReportingReportCardPadding =
      EdgeInsets.all(x4);
  static const EdgeInsets transactionReportingErrorPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x3);
  static const EdgeInsets transactionReportingActionPadding =
      EdgeInsets.symmetric(horizontal: x3);
  static const EdgeInsets transactionReportingQuickActionCardPadding =
      EdgeInsets.all(x4);
  static const EdgeInsets transactionReportingComplianceNoticePadding =
      EdgeInsets.all(x4);
  static const EdgeInsets transactionReportingNoticePanelPadding =
      EdgeInsets.fromLTRB(rowPy, x4, rowGapRegular, x4);
  static const double transactionReportingLineHeightTight =
      tradeBotLineHeightTight;
  static const double transactionReportingNoticeLineHeight =
      tradeBotLineHeightMedium;
  static const double transactionReportingErrorLineHeight = 1.3;
  static const double transactionReportingStatIcon = x4 + x1;
  static const double transactionReportingStatusIcon = x4 + x3;
  static const double transactionReportingErrorIcon = x3 + hairlineStroke;
  static const EdgeInsets tradeBodyReviewCardPadding = EdgeInsets.all(x3);
  static EdgeInsets copySafetyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double copySafetyHeroMinHeight = 95;
  static const double copySafetyTierBasicMinHeight = 207;
  static const double copySafetyTierVerifiedMinHeight = 260;
  static const double copySafetyTierProMinHeight = 296;
  static const EdgeInsets copySafetyHeroPadding = EdgeInsets.fromLTRB(
    x4 + x1,
    walletTokenApprovalActionIcon,
    x4 + x1,
    rowPy,
  );
  static const EdgeInsets copySafetyTierPadding = EdgeInsets.fromLTRB(
    x4 + x1,
    x4 + x1,
    x4 + x1,
    walletTokenApprovalActionIcon,
  );
  static const EdgeInsets copySafetyListIndentPadding = EdgeInsets.only(
    left: dividerHairline,
  );
  static const EdgeInsets copySafetyListItemPadding = EdgeInsets.only(
    left: rowPy,
  );
  static const EdgeInsets copySafetyMetricExpandedPadding = EdgeInsets.fromLTRB(
    x4 + x1,
    0,
    x4 + x1,
    x4 + x1,
  );
  static const EdgeInsets copySafetyMetricInfoPadding = EdgeInsets.all(
    walletAssetPillGap,
  );
  static const EdgeInsets copySafetyActionCardPadding = EdgeInsets.all(rowPy);
  static const EdgeInsets copySafetyIconTextPadding = EdgeInsets.all(10);
  static const double copySafetyHeroTitleLineHeight = 1.05;
  static const double copySafetyListItemLineHeight = tradeBotLineHeightCaption;
  static const double copySafetyDescriptionLineHeight =
      tradeBotLineHeightCompact;
  static const double copySafetyBodyLineHeight = tradeBotLineHeightBody;
  static const double copySafetyIntroLineHeight = tradeBotLineHeightMedium;
  static const double copySafetyLineHeightTight = tradeBotLineHeightTight;
  static const double copySafetyTierIcon = x5;
  static const double copySafetyIconTextIcon = x3 + x2;
  static const double copySafetyIconTextGap = rowGap + hairlineStroke;
  static const double tradeChartTvLeft = 12;
  static const double tradeChartTvBottom = rowGap;
  static const double tradeChartPriceRight = rowGap;
  static const double tradeChartPriceTopDefault = 38;
  static const double tradeChartPriceTopDefaultSecond = 60;
  static const double tradeChartPriceTopPair = 18;
  static const double tradeChartPriceTopPairSecond = 40;
  static const double tradeChartPriceRightTop = 46;
  static const double tradeChartPriceRightBottom = 22;
  static const EdgeInsets tradePriceBadgePadding = EdgeInsets.symmetric(
    horizontal: walletAssetSmallGap,
    vertical: x1,
  );
  static const EdgeInsets tradeMarketListPadding = EdgeInsets.all(14);
  static const double tradeBookRowTopGap = walletAssetSmallGap;
  static const double tradeBookDividerHeight = 16;
  static const double tradeTapeRowBottomGap = rowGap;
  static const EdgeInsets tradeInstrumentHeroPadding = EdgeInsets.all(x4);
  static const double tradeInstrumentHeroMetricGap = x3;
  static const int tradeHubPrimaryCount = 6;
  static const double tradeHubTileExtent = buttonCompact + x2;
  static const EdgeInsets tradeOrderRowPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double tradeChartPanelHeight = x7 + x6 + x4;
  static const double tradeOrderTabsHeight = 44;
  static const EdgeInsets tradeOrderTabsInnerPadding = EdgeInsets.all(4);
  static const double tradeFormGap = 16;
  static const double tradeFormSmallGap = 14;
  static const double tradePctGap = 10;
  static const double tradeSideSwitchHeight = 46;
  static const EdgeInsetsDirectional kidGeneratorPreviewPadding =
      EdgeInsetsDirectional.all(x4);
  static const EdgeInsetsDirectional kidGeneratorSectionCardPadding =
      EdgeInsetsDirectional.symmetric(horizontal: x3, vertical: x2);
  static const EdgeInsetsDirectional kidGeneratorMetricPadding =
      EdgeInsetsDirectional.fromSTEB(x3, x1, x3, x1);
  static EdgeInsets kidGeneratorScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const double tradeOrderTypeSize = 39;
  static const double tradePctButtonHeight = 38;
  static const double tradeTpslHeight = 38;
  static const EdgeInsets tradeTpslPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const double tradeTpslIcon = 16;
  static const double tradeTpslGap = rowGap;
  static const EdgeInsets tradeFeeCardPadding = EdgeInsets.all(16);
  static const double tradeFeeRowGap = 10;
  static const EdgeInsets tradeFeeBadgePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: hairlineStroke,
  );
  static const double tradeCtaHeight = ctaHeight;
  static const double tradeListGap = 12;
  static const EdgeInsets tradeListCardPadding = EdgeInsets.all(14);
  static const double tradeHistoryTabGap = rowGap;
  static const EdgeInsets tradeHistoryTopTabsPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    12,
  );
  static const double tradeHistoryTopTabHeight = 40;
  static const EdgeInsets tradeHistoryBadgePadding = EdgeInsets.symmetric(
    horizontal: rowGap,
    vertical: 4,
  );
  static const double tradeHistoryTypeBadgeMinWidth = 18;
  static const double tradeHistoryInfoGap = x2;
  static const EdgeInsets tradeHistoryEmptyPadding = EdgeInsets.symmetric(
    vertical: 84,
  );
  static const double tradeHistoryEmptyIcon = 48;
  static const double tradeHistoryEmptyGap = 12;
  static const EdgeInsets tradeHistoryFilterPadding = EdgeInsets.fromLTRB(
    16,
    rowGap,
    16,
    rowGap,
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
  static const double tradeHistorySymbolGap = rowGap;
  static const double tradeHistoryTypeGap = 6;
  static const double tradeHistoryStatusWidth = 118;
  static const double tradeHistoryStatusIcon = 15;
  static const double tradeHistoryStatusGap = x2;
  static const double tradeHistoryTileGap = 12;
  static const double tradeHistoryTileSmallGap = 10;
  static const double tradeHistoryProgressHeight = x2;
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
    horizontal: rowGap,
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
    rowGap,
  );
  static const double tradeReceiptRiskValueGap = x2;
  static const EdgeInsets tradeReceiptNoticePadding = EdgeInsets.fromLTRB(
    12,
    10,
    12,
    10,
  );
  static const double tradeReceiptNoticeIconTop = 2;
  static const double tradeReceiptNoticeIcon = 14;
  static const double tradeReceiptNoticeGap = rowGap;
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
    rowGap,
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
  static const double tradeBotHairline = dividerHairline;
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
  static const double tradeBotTabsHeight = inputHeight - x1;
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
  static const double tradeBotClientMoneyRiskGap = rowGap;
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
  static const double tradeBotAttributionLegendLineHeight = hairlineStroke;
  static const double tradeBotAttributionLegendItemGap = 4;
  static const double tradeBotAttributionLegendGroupGap = 12;
  static const double tradeBotMiniStatHeight = launchpadBox56;
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
        contentPad,
        x4 + x1 - hairlineStroke,
        contentPad,
        bottomInset,
      );
  static const EdgeInsets traderProfileHeroPadding = EdgeInsets.all(contentPad);
  static const EdgeInsets traderProfilePanelPadding = EdgeInsets.all(x4 + x1);
  static const EdgeInsets traderProfileRiskPanelPadding = EdgeInsets.all(
    x4 - x1,
  );
  static const EdgeInsets traderProfileTradeCardPadding = EdgeInsets.all(
    x4 - x1,
  );
  static const EdgeInsets traderProfileMetricPadding = EdgeInsets.fromLTRB(
    x3,
    x3 + hairlineStroke,
    x3,
    x3,
  );
  static const EdgeInsets traderProfileStatsLinePadding = EdgeInsets.symmetric(
    vertical: x3 + hairlineStroke,
  );
  static const double traderProfileAvatarSize = x7 + x4 - x2;
  static const double traderProfileHeaderGap = x4 + x1;
  static const double traderProfileSectionGap = x4 + x1;
  static const double traderProfilePanelInnerGap = x4 - x1;
  static const double traderProfileWrapGap = x2 + x1;
  static const double traderProfileTinyGap = x1 + hairlineStroke;
  static const double traderProfileChartHeight = 160;
  static const double traderProfileDailyChartHeight = 100;
  static const double traderProfileMetricHeight = x7 - hairlineStroke;
  static const double traderProfileProgressHeight = x3;
  static const double traderProfileWinLossBarHeight = x4 - x1;
  static const double traderProfileStatsValueWidth = x7 - hairlineStroke;
  static const double traderProfileDetailIcon = 15;
  static const double traderProfileActionIcon = tradeBotMediumIcon;
  static const double productGovernanceBottomInsetVisual = 118;
  static const double productGovernanceBottomInsetNative = 28;
  static const double productGovernanceTopInset = x6 + hairlineStroke;
  static const double productGovernanceContentGap = x3;
  static const double productGovernanceInlineGap = tradeBotRowGap;
  static const double productGovernancePillGap = x2;
  static const double productGovernanceTagGap = tradeBotNarrowIconGap;
  static const double productGovernanceTargetGap = x4 - hairlineStroke;
  static const double productGovernanceDateSectionGap = tradeBotMediumIcon;
  static const double productGovernanceNegativeTagGap = tradeBotContentGap;
  static const double productGovernanceReviewGap = x3;
  static const double productGovernanceReviewActionGap = tradeBotNarrowIconGap;
  static const double productGovernanceReviewTextGap = x2 - hairlineStroke;
  static const double productGovernanceActionIcon = tradeBotMediumIcon;
  static const double productGovernanceNoticeIcon = tradeBotMediumIcon;
  static const double productGovernanceChannelIconBox = launchpadBox40;
  static const double productGovernanceChannelStatusIcon = 19;
  static const double productGovernanceDateBoxHeight = tradeBotCassMetricHeight;
  static const double productGovernanceLineHeightTight =
      tradeBotLineHeightTight;
  static const EdgeInsets productGovernanceNoticePadding = EdgeInsets.fromLTRB(
    x3,
    0,
    x3,
    0,
  );
  static const EdgeInsets productGovernanceCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets productGovernanceReviewRowPadding = EdgeInsets.all(
    x3,
  );
  static const EdgeInsets productGovernanceDistributionCardPadding =
      EdgeInsets.all(x3 + hairlineStroke);
  static const EdgeInsets productGovernanceDateBoxPadding = EdgeInsets.fromLTRB(
    tradeBotRowGap,
    x2,
    tradeBotRowGap,
    x2,
  );
  static EdgeInsets productGovernanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        productGovernanceTopInset,
        contentPad,
        bottomInset,
      );
  static const double activeCopiesBottomInsetVisual = 104;
  static const double activeCopiesBottomInsetNative = 28;
  static const double activeCopiesPortfolioHeight = 194;
  static const double activeCopiesPnlHeight = 62;
  static const double activeCopiesTabsHeight = inputHeight - x4;
  static const double activeCopiesMiniValueHeight =
      inputHeight - hairlineStroke;
  static const double activeCopiesReturnHeight =
      launchpadBox40 + hairlineStroke;
  static const double activeCopiesPerformanceHeight = x7 - hairlineStroke;
  static const double activeCopiesActionHeight = walletDepositCopyButtonHeight;
  static const double activeCopiesPnlIcon = tradeBotMediumIcon;
  static const double activeCopiesVerifiedIcon = x3 + x4 - x1;
  static const double activeCopiesExpandIcon =
      productGovernanceChannelStatusIcon;
  static const double activeCopiesExpandPadding = 4.5;
  static const double activeCopiesLineHeightTight = tradeBotLineHeightTight;
  static const double activeCopiesLineHeightShort = 1.1;
  static const double activeCopiesLineHeightCompact = tradeBotLineHeightShort;
  static const double activeCopiesLineHeightCaption = tradeBotLineHeightCaption;
  static const double activeCopiesLineHeightNotice = tradeBotLineHeightReadable;
  static const EdgeInsets activeCopiesPnlPadding = EdgeInsets.symmetric(
    horizontal: rowPy,
    vertical: x3,
  );
  static const EdgeInsets activeCopiesTabsPadding = EdgeInsets.all(x1);
  static const EdgeInsets activeCopiesMiniValuePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x3,
  );
  static const EdgeInsets activeCopiesReturnPadding = EdgeInsets.all(x3);
  static const EdgeInsets activeCopiesDetailsPadding = EdgeInsets.only(
    top: rowPy,
  );
  static const EdgeInsets activeCopiesSmallCardPadding = EdgeInsets.all(
    walletAssetPillGap,
  );
  static const EdgeInsets activeCopiesActionPadding = EdgeInsets.symmetric(
    horizontal: walletAssetPillGap,
  );
  static EdgeInsets activeCopiesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static EdgeInsets activeCopiesStopSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, contentPad, contentPad, x5 + bottomInset);
  static const double copyConfigurationBottomInsetVisual = 84;
  static const double copyConfigurationBottomInsetNative = 24;
  static const double copyConfigurationAvatarSize = walletTokenHeroIcon;
  static const double copyConfigurationPrimaryGap = transferSectionGap;
  static const double copyConfigurationTinyGap = hairlineStroke * 2;
  static const double copyConfigurationSmallGap = x3;
  static const double copyConfigurationMediumGap = x4 - x1;
  static const double copyConfigurationInlineGap = cardGap - x1;
  static const double copyConfigurationCardPaddingValue = 16;
  static const double copyConfigurationInnerPaddingValue = rowPy;
  static const double copyConfigurationValidationPaddingValue = 12;
  static const double copyConfigurationProgressHeight = x3;
  static const double copyConfigurationDividerHeight = x5 + hairlineStroke / 2;
  static const double copyConfigurationModeIcon = tradeBotActionIcon;
  static const double copyConfigurationRiskIcon = ctaLoadingIcon;
  static const double copyConfigurationValidationIcon = tradeBotCheckboxIcon;
  static const double copyConfigurationPresetHeight =
      buttonCompact + hairlineStroke;
  static const double copyConfigurationRatioWidth = x7 - hairlineStroke / 2;
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
      EdgeInsets.fromLTRB(contentPad, x4 + x1, contentPad, bottomInset);
  static EdgeInsets copyConfigurationFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double copyConfirmationBottomInsetVisual =
      copyConfigurationBottomInsetVisual;
  static const double copyConfirmationBottomInsetNative =
      copyConfigurationBottomInsetNative;
  static const double copyConfirmationSectionGap = x4 + x1;
  static const double copyConfirmationCardPaddingValue =
      copyConfigurationCardPaddingValue;
  static const double copyConfirmationSoftPaddingValue =
      copyConfigurationInnerPaddingValue;
  static const double copyConfirmationCompactPaddingValue =
      copyConfigurationValidationPaddingValue;
  static const double copyConfirmationTinyGap = walletAddressCompactGap;
  static const double copyConfirmationSmallGap = copyConfigurationSmallGap;
  static const double copyConfirmationInlineGap = copyConfigurationMediumGap;
  static const double copyConfirmationRowGap = contentPad - x3;
  static const double copyConfirmationIconGap = copyConfirmationInlineGap;
  static const double copyConfirmationLabelGap = formFieldLabelGap;
  static const double copyConfirmationDividerHeight = x5 + dividerHairline;
  static const double copyConfirmationCheckboxIcon = walletAddressSwitchKnob;
  static const double copyConfirmationWarningIcon = x5 + x1;
  static const double copyConfirmationCoolingIcon = tradeBotDisputeTabBadgeSize;
  static const double copyConfirmationProviderAvatarRadius = x5 + x2;
  static const double copyConfirmationStepRadius = x4;
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
  static const double regulatoryInspectionBottomInsetVisualExtra = x6 + x5 + x1;
  static const double regulatoryInspectionBottomInsetNativeExtra =
      x6 - formFieldLabelGap;
  static const double regulatoryInspectionContentGap = rowPy;
  static const double regulatoryInspectionScoreMinHeight =
      buttonHero * 2 + x5 + x1 + dividerHairline;
  static const double regulatoryInspectionCardPaddingHorizontal =
      contentPad - x1;
  static const double regulatoryInspectionCardPaddingVertical =
      ctaLoadingIcon - x1;
  static const double regulatoryInspectionMetricGap = rowGapRegular;
  static const double regulatoryInspectionCompactGap = x2;
  static const double regulatoryInspectionInlineGap = x3;
  static const double regulatoryInspectionSmallGap = x4;
  static const double regulatoryInspectionMediumGap = rowPy;
  static const double regulatoryInspectionLargeGap = statusPillHeightLg;
  static const double regulatoryInspectionLooseGap = x5 + x2;
  static const double regulatoryInspectionScoreIconBox = buttonStandard + x1;
  static const double regulatoryInspectionScoreIcon = statusPillHeightMd + x2;
  static const double regulatoryInspectionProgressHeight = rowGapRegular + x1;
  static const double regulatoryInspectionReadyIconTop = hairlineStroke / 2;
  static const double regulatoryInspectionTinyIcon = x3 + dividerHairline;
  static const double regulatoryInspectionRequirementIcon = rowGapRegular;
  static const double regulatoryInspectionQuickStatIcon = rowGapRegular + x1;
  static const double regulatoryInspectionBodyIcon = ctaLoadingIcon - x1;
  static const double regulatoryInspectionStandardIcon = ctaLoadingIcon;
  static const double regulatoryInspectionQuickStatHeight =
      walletAddressAddWhitelistHeight + x2;
  static const double regulatoryInspectionDocumentHeight = buttonStandard + x1;
  static const double regulatoryInspectionDocumentIconBox = buttonCompact + x2;
  static const double regulatoryInspectionPortalIconBox = inputHeight - x2;
  static const double regulatoryInspectionPortalIcon = iconMd + x1;
  static const double regulatoryInspectionPortalGap = contentPad - x1;
  static const double regulatoryInspectionActionHeight = searchBarCompactHeight;
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
        rowGapRegular,
        rowGapRegular,
        rowGapRegular,
        rowGapRegular + x1,
      );
  static const EdgeInsets regulatoryInspectionDocumentPadding =
      EdgeInsets.fromLTRB(x4, rowGapRegular + x1, x4, rowGapRegular + x1);
  static const EdgeInsets regulatoryInspectionPortalPadding = EdgeInsets.all(
    contentPad - x1,
  );
  static const EdgeInsets regulatoryInspectionScoreTextPadding =
      EdgeInsets.only(top: x1);
  static const EdgeInsets regulatoryInspectionReadyIconPadding =
      EdgeInsets.only(top: regulatoryInspectionReadyIconTop);
  static EdgeInsets regulatoryInspectionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double executionVenueBottomInsetVisualExtra = x7 + x6 + x5 + x3;
  static const double executionVenueBottomInsetNativeExtra =
      x6 - formFieldLabelGap;
  static const double executionVenueContentGap = 0;
  static const double executionVenueSectionGap = x4 + x1;
  static const double executionVenueControlGap = x5 + x3 - x2 + hairlineStroke;
  static const double executionVenueTabBodyGap = x5 + x3 - x2 + x1;
  static const double executionVenueNoticeTopOffset = ctaLoadingIcon;
  static const double executionVenueNoticeIcon = ctaLoadingIcon;
  static const double executionVenueBodyIcon = ctaLoadingIcon - x1;
  static const double executionVenueSummaryGap = x4 - x1;
  static const double executionVenueSummaryHeight =
      x7 + x6 + x1 - hairlineStroke;
  static const double executionVenueSortIcon = ctaLoadingIcon - dividerHairline;
  static const double executionVenueSortLabelWidth = buttonCompact + x3;
  static const double executionVenueSortLabelGap = x2 + hairlineStroke;
  static const double executionVenueLineHeightTight = 1;
  static const double executionVenueLineHeightControl = 1.15;
  static const double executionVenueCardPaddingValue = x4;
  static const double executionVenuePanelPaddingValue =
      x4 + x1 - hairlineStroke;
  static const double executionVenueCompactPanelPaddingValue = x4 - x1;
  static const double executionVenueRankGap = x4 - hairlineStroke;
  static const double executionVenueWinnerIcon = x4 + x1;
  static const double executionVenueMetricBoxHeight = buttonCompact + x4 + x1;
  static const double executionVenueMetricBoxBottomPadding =
      x3 - hairlineStroke + x1;
  static const double executionVenueMetricGap = x3 - hairlineStroke + x1;
  static const double executionVenueProgressGap = x3 + hairlineStroke;
  static const double executionVenueProgressHeight = x2 + hairlineStroke;
  static const double executionVenueTrendBarHeight = x3;
  static const EdgeInsets executionVenueNoticePadding = EdgeInsets.fromLTRB(
    x4 - x1,
    x3 + x1,
    x3,
    x3 + x1,
  );
  static const EdgeInsets executionVenueSummaryCardPadding =
      EdgeInsets.fromLTRB(x4 - x1, x4, x4 - x1, x4 - x1);
  static const EdgeInsets executionVenueCardPadding = EdgeInsets.all(
    executionVenueCardPaddingValue,
  );
  static const EdgeInsets executionVenueMetricBoxPadding = EdgeInsets.fromLTRB(
    x3,
    x3,
    x3,
    executionVenueMetricBoxBottomPadding,
  );
  static const EdgeInsets executionVenuePanelPadding = EdgeInsets.all(
    executionVenuePanelPaddingValue,
  );
  static const EdgeInsets executionVenueCompactPanelPadding = EdgeInsets.all(
    executionVenueCompactPanelPaddingValue,
  );
  static EdgeInsets executionVenueScrollPadding(double bottomInset) =>
      contentInsets.copyWith(top: x4, bottom: bottomInset);
  static const double providerGovernanceBottomInsetVisualExtra =
      buttonHero + x6 + x2;
  static const double providerGovernanceBottomInsetNativeExtra =
      x6 - formFieldLabelGap;
  static const double providerGovernanceContentGap = 0;
  static const double providerGovernanceDashboardHeight = 136;
  static const double providerGovernanceDashboardIconBox = inputHeight - x2;
  static const double providerGovernanceDashboardIcon = iconMd + x1;
  static const double providerGovernanceDashboardGap = rowPy;
  static const double providerGovernanceDashboardMetricGap = x4;
  static const double providerGovernanceCompactGap = x2;
  static const double providerGovernanceSmallGap = x3;
  static const double providerGovernanceMediumGap = rowGapRegular;
  static const double providerGovernanceSectionGap = rowPy;
  static const double providerGovernanceControlGap = x5 + x2;
  static const double providerGovernanceTabHeight = x7 + x2;
  static const double providerGovernanceTabBodyGap = statusPillHeightMd;
  static const double providerGovernanceNoticeMinHeight = inputHeight;
  static const double providerGovernanceNoticeIcon = x4 + x1;
  static const double providerGovernanceNoticeGap = rowGapRegular + x1;
  static const double providerGovernanceModificationHeight = 154;
  static const double providerGovernanceModificationIcon = iconSm;
  static const double providerGovernanceMetaIcon = x3 + x1;
  static const double providerGovernanceMetaGap = ctaLoadingIcon - x1;
  static const double providerGovernancePanelIcon =
      ctaLoadingIcon - dividerHairline;
  static const double providerGovernanceRequestHeight = referralCtaHeight;
  static const double providerGovernanceLineHeightTight =
      tradeBotLineHeightTight;
  static const double providerGovernanceLineHeightReadable =
      tradeBotLineHeightReadable;
  static const double providerLeaderboardBottomInsetVisualExtra = 126;
  static const double providerLeaderboardBottomInsetNativeExtra = 28;
  static const double providerLeaderboardTopInset = x4 + x1 - hairlineStroke;
  static const double providerLeaderboardContentGap = x4;
  static const double providerLeaderboardReviewPaddingValue = x4 - x1;
  static const double providerLeaderboardWarningPaddingStart = x3;
  static const double providerLeaderboardWarningPaddingEnd = x3;
  static const double providerLeaderboardWarningPaddingBottom =
      x3 - hairlineStroke;
  static const double providerLeaderboardWarningIcon = x3 + x1;
  static const double providerLeaderboardWarningGap = x2 + hairlineStroke;
  static const double providerLeaderboardWarningTitleGap = x2;
  static const double providerLeaderboardCardPaddingStart = x4 + x1;
  static const double providerLeaderboardCardPaddingEnd = x4 + x1;
  static const double providerLeaderboardCardPaddingBottom =
      x4 + x1 - hairlineStroke;
  static const double providerLeaderboardCardTitleGap = x3 + hairlineStroke;
  static const double providerLeaderboardCardMetricsGap = x4 - x1;
  static const double providerLeaderboardCardTrailingTop = x1 + hairlineStroke;
  static const double providerLeaderboardVerifiedIconGap = x3 - hairlineStroke;
  static const double providerLeaderboardVerifiedIcon = x4 - x1;
  static const double providerLeaderboardFollowersIcon = x2 + x2;
  static const double providerLeaderboardFiltersLabelGap = x3 - hairlineStroke;
  static const double providerLeaderboardVerifiedPaddingStart = x4 - x1;
  static const double providerLeaderboardVerifiedPaddingEnd = x4;
  static const double providerLeaderboardDisclaimerPaddingStart =
      ctaLoadingIcon;
  static const double providerLeaderboardDisclaimerPaddingTop =
      x4 + x1 - hairlineStroke;
  static const double providerLeaderboardDisclaimerPaddingBottom = x4 + x1;
  static const double providerLeaderboardLineHeightFlat = 1;
  static const double providerLeaderboardLineHeightReadable = 1.45;
  static const double providerLeaderboardLineHeightLoose = 1.5;
  static const EdgeInsets providerGovernanceDashboardPadding =
      EdgeInsets.fromLTRB(contentPad - x1, rowPy, contentPad - x1, x4);
  static const EdgeInsets providerGovernanceSectionTitlePadding =
      EdgeInsets.only(left: rowGapRegular);
  static const EdgeInsets providerGovernanceNoticePadding = EdgeInsets.fromLTRB(
    x4,
    x4,
    x4,
    rowGapRegular + x1,
  );
  static const EdgeInsets providerGovernanceModificationPadding =
      EdgeInsets.fromLTRB(contentPad - x1, x4, contentPad - x1, rowGapRegular);
  static const EdgeInsets providerGovernancePanelPadding = EdgeInsets.all(
    rowPy,
  );
  static const EdgeInsets providerGovernanceMessagePanelPadding =
      EdgeInsets.all(contentPad);
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
      contentInsets.copyWith(
        top: providerLeaderboardTopInset,
        bottom: bottomInset,
      );
  static EdgeInsets providerGovernanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double armIntegrationBottomInsetVisualExtra = x7 + x6 + x5 + x3;
  static const double armIntegrationBottomInsetNativeExtra =
      x6 - formFieldLabelGap;
  static const double armIntegrationContentGap = rowPy;
  static const double armIntegrationCardPaddingValue = contentPad - x1;
  static const double armIntegrationProviderIconBox = inputHeight - x2;
  static const double armIntegrationProviderIcon = iconMd + x1;
  static const double armIntegrationInlineGap = x4;
  static const double armIntegrationLabelGap = rowGapRegular + x1;
  static const double armIntegrationMetricRowGap = rowPy;
  static const double armIntegrationCardSectionGap = x4;
  static const double armIntegrationMetricHeight = buttonStandard;
  static const double armIntegrationMetricPaddingHorizontal =
      rowGapRegular + x1;
  static const double armIntegrationMetricPaddingTop = rowGapRegular + x1;
  static const double armIntegrationMetricPaddingBottom = x3;
  static const double armIntegrationDetailsGap = rowGapRegular;
  static const double armIntegrationTestIcon = x4 + hairlineStroke;
  static const double armIntegrationLogsIcon = x4 + dividerHairline;
  static const double armIntegrationLineHeightTight = tradeBotLineHeightTight;
  static const double armIntegrationChartHeight =
      walletAssetChartHeight - rowGapRegular;
  static const double armIntegrationDividerHeight = dividerHairline;
  static const double armIntegrationLegendGap = ctaLoadingIcon;
  static const double armIntegrationSlaGap = ctaLoadingIcon - x1;
  static const double armIntegrationProgressLabelGap = x4;
  static const double armIntegrationProgressHeight = x3;
  static const double armIntegrationQuickActionIcon =
      ctaLoadingIcon - dividerHairline;
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
    rowPy,
    armIntegrationCardPaddingValue,
    rowPy,
  );
  static const EdgeInsets armIntegrationSlaPadding = EdgeInsets.fromLTRB(
    armIntegrationCardPaddingValue,
    armIntegrationSlaGap,
    armIntegrationCardPaddingValue,
    armIntegrationSlaGap,
  );
  static EdgeInsets armIntegrationScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double regulatoryDisclosuresBottomInsetVisualExtra =
      x7 + x6 + x5 + x3;
  static const double regulatoryDisclosuresBottomInsetNativeExtra =
      x6 - formFieldLabelGap;
  static const double regulatoryDisclosuresContentGap = x5 + x1;
  static const double regulatoryDisclosuresReviewGap = 0;
  static const double regulatoryDisclosuresReviewInnerGap = x3;
  static const double regulatoryDisclosuresHeroPaddingValue = x4 + x1;
  static const double regulatoryDisclosuresHeroIconBox = 48;
  static const double regulatoryDisclosuresHeroIcon = iconMd + x1;
  static const double regulatoryDisclosuresHeroGap = x4;
  static const double regulatoryDisclosuresHeroSubtitleGap =
      formFieldLabelGap + dividerHairline;
  static const double regulatoryDisclosuresHeroTitleLineHeight = 1.08;
  static const double regulatoryDisclosuresLineHeightCompact =
      tradeBotLineHeightCaption;
  static const double regulatoryDisclosuresActionPaddingValue = x4;
  static const double regulatoryDisclosuresContactPaddingValue = rowPy;
  static const double regulatoryDisclosuresNoticePaddingValue = contentPad;
  static const double regulatoryDisclosuresActionIcon = x4 + x1;
  static const double regulatoryDisclosuresExternalIcon = x4 + dividerHairline;
  static const double regulatoryDisclosuresContactIcon = contentPad;
  static const double regulatoryDisclosuresActionGap = x3 + dividerHairline;
  static const double regulatoryDisclosuresContactGap = tradeBotCardGap;
  static const double regulatoryDisclosuresContactTextGap = x1;
  static const double regulatoryDisclosuresNoticeTitleGap = rowGapRegular;
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
      EdgeInsets.fromLTRB(contentPad, rowPy, contentPad, bottomInset);
  static const double tradeBotTermsReadThreshold = 50;
  static const double tradeBotSheetActionHeight = 44;
  static const double tradeBotFooterTopOffset = 10;
  static const EdgeInsets tradeBotScrollPadding = EdgeInsets.fromLTRB(
    contentPad,
    tradeBotPageTopGap,
    contentPad,
    0,
  );
  static const EdgeInsets tradeBotPageBodyPadding = EdgeInsets.fromLTRB(
    contentPad,
    x5,
    contentPad,
    0,
  );
  static const EdgeInsets tradeBotHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets tradeBotTabShellPadding = EdgeInsets.all(x1);
  static const EdgeInsets tradeBotCardPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    16,
  );
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
    horizontal: x4,
    vertical: x3,
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
  static const EdgeInsets tradeBotCopyDemoPanelPadding = EdgeInsets.all(x5);
  static const EdgeInsets tradeBotCopyDemoCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets tradeBotCopyDemoCompactPadding = EdgeInsets.all(x3);
  static const EdgeInsets tradeBotCopyDemoInlinePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets tradeBotCopyDemoBadgePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets tradeBotCopyDemoLinePadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets tradeBotCopyDemoCompactLinePadding = EdgeInsets.only(
    bottom: x1,
  );
  static const EdgeInsets tradeBotCopyDemoDividerPadding = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets tradeBotCopyDemoRowPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets tradeBotCopyDemoSectionBottomPadding =
      EdgeInsets.only(bottom: x3);
  static const EdgeInsets tradeBotCopyDemoHeaderBottomPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets tradeBotTermsScrollPadding = EdgeInsets.fromLTRB(
    contentPad,
    22,
    contentPad,
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
    left: dividerHairline,
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
    contentPad,
    10,
    contentPad,
    10,
  );
  static const EdgeInsets tradeBotSheetPadding = EdgeInsets.fromLTRB(
    contentPad,
    contentPad,
    contentPad,
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
        contentPad,
        tradeBotPageTopGap,
        contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotClientMoneyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        tradeBotClientMoneyTopGap,
        contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotDisputeScrollPadding(
    double topInset,
    double bottomInset,
  ) => EdgeInsets.fromLTRB(contentPad, topInset, contentPad, bottomInset);
  static EdgeInsets tradeBotDisputeUploadPadding(double topGap) =>
      EdgeInsets.only(top: topGap);
  static EdgeInsets tradeBotAttributionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, tradeBotCardGap, contentPad, bottomInset);
  static EdgeInsets tradeBotCopyDemoScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets tradeBotSecurityScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets tradeBotActionButtonPadding(bool compact) =>
      EdgeInsets.symmetric(horizontal: compact ? x3 : x4);
  static EdgeInsets tradeBotSheetPaddingWithBottom(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        contentPad,
        contentPad,
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
    contentPad,
    16,
    contentPad,
    tradeToolPageTopGap,
  );
  static const EdgeInsets tradeToolFooterPaddingExported = EdgeInsets.fromLTRB(
    contentPad,
    12,
    contentPad,
    tradeToolPageTopGap,
  );
  static EdgeInsets tradeToolScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        tradeToolPageTopGap,
        contentPad,
        bottomInset,
      );
  static EdgeInsets tradeToolExportScrollPadding(double bottomChrome) =>
      EdgeInsets.fromLTRB(
        contentPad,
        tradeToolPageTopGap,
        contentPad,
        bottomChrome + tradeToolBottomInsetExport,
      );
  static const double p2pDashboardBottomInsetVisual = x6;
  static const double p2pDashboardBottomInsetNative = x4;
  static EdgeInsets p2pDashboardScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x5, contentPad, bottomInset);
  static EdgeInsets p2pDashboardPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const double p2pDashboardContentGap = x4;
  static const EdgeInsets p2pDashboardFilterChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets p2pDashboardCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pDashboardCardPadding = EdgeInsets.all(x4);
  static const double p2pDashboardMetricRowGap = x3;
  static const double p2pDashboardChartLargeHeight = 140;
  static const double p2pDashboardChartMediumHeight = 130;
  static const double p2pDashboardDonutSize = 94;
  static const double p2pDashboardAssetSwatch = 10;
  static const EdgeInsets p2pDashboardAssetLinePadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets p2pDashboardPillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pDashboardRequirementPillPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x1);
  static const EdgeInsets p2pDashboardQuickActionPadding = EdgeInsets.all(x4);
  static const double p2pDashboardIconBubbleSmallIcon = 16;
  static const double p2pDashboardTrendIcon = 11;
  static const double p2pDashboardMerchantStar = 12;
  static const EdgeInsets p2pDashboardMerchantPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets p2pDashboardActivityPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets p2pDashboardTextLinkPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const double p2pDashboardMonthlyBarWidth = x3;
  static const double p2pDashboardMonthlyBarMinHeight = 6;
  static const double p2pDashboardMonthlyLabelOffsetX = 10;
  static const double p2pDashboardMonthlyLabelOffsetY = x2;
  static const double p2pMarketplaceAnalyticsBottomInsetVisual = x4;
  static const double p2pMarketplaceAnalyticsBottomInsetNative = x4;
  static EdgeInsets p2pMarketplaceAnalyticsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pMarketplaceAnalyticsCardPadding = EdgeInsets.all(
    x3,
  );
  static const EdgeInsets p2pMarketplaceAnalyticsCompactPadding =
      EdgeInsets.all(x3);
  static const EdgeInsets p2pMarketplaceAnalyticsIdentityPadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets p2pMarketplaceAnalyticsMetricIconPadding =
      EdgeInsets.zero;
  static const EdgeInsets p2pMarketplaceAnalyticsChipPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static const EdgeInsets p2pMarketplaceAnalyticsTinyPillPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x1);
  static const EdgeInsets p2pMarketplaceAnalyticsTableCellPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static const EdgeInsets p2pMarketplaceAnalyticsSelectorPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static const EdgeInsets p2pMarketplaceAnalyticsOrderRowPadding =
      EdgeInsets.symmetric(horizontal: x2);
  static const double p2pMarketplaceAnalyticsIdentityHeight = x7 + x3;
  static const double p2pMarketplaceAnalyticsMetricCardHeight =
      buttonHero + x4 + x3;
  static const double p2pMarketplaceAnalyticsQuickStatsHeight = x7 + x6;
  static const double p2pMarketplaceAnalyticsIconBox = x6;
  static const double p2pMarketplaceAnalyticsTrendIcon = 11;
  static const double p2pMarketplaceAnalyticsSmallIcon = 14;
  static const double p2pMarketplaceAnalyticsLegendDot = x3;
  static const double p2pMarketplaceAnalyticsAssetChipMinWidth = 110;
  static const double p2pMarketplaceAnalyticsAssetChipMinHeight = 52;
  static const double p2pMarketplaceAnalyticsDepthChartHeight = 144;
  static const double p2pMarketplaceAnalyticsOrderRowHeight = x5;
  static const double p2pMarketplaceAnalyticsDividerHeight =
      walletHistoryDividerHeight;
  static const double p2pMarketplaceAnalyticsChartLargeHeight = buttonHero * 2;
  static const double p2pMarketplaceAnalyticsChartTallHeight = x7 * 3;
  static const double p2pMarketplaceAnalyticsRadarHeight = buttonHero * 2 + x6;
  static const double p2pMarketplaceAnalyticsTightLineHeight = 1;
  static const double p2pMarketplaceAnalyticsBodyLineHeight = 1.6;
  static const double p2pHomeBottomInsetVisual = x6;
  static const double p2pHomeBottomInsetNative = x4;
  static EdgeInsets p2pHomeScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const EdgeInsets p2pHomeOfflinePadding = EdgeInsets.only(bottom: x3);
  static const EdgeInsets p2pHomeCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pHomeTabsPadding = EdgeInsets.all(x1);
  static const EdgeInsets p2pHomeTradeTabPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets p2pHomeChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pHomeActionButtonPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pHomeClearFilterPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets p2pHomePriceBaselinePadding = EdgeInsets.only(
    bottom: x1,
  );
  static const EdgeInsets p2pHomeDividerMargin = EdgeInsets.symmetric(
    horizontal: x1,
  );
  static const EdgeInsets p2pHomePillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets p2pHomeSmallPillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const double p2pHomeTextTightLineHeight = 1;
  static const double p2pHomeTinyIcon = 11;
  static const double p2pHomeSmallIcon = 12;
  static const double p2pHomeVerifiedIcon = 13;
  static const double p2pHomeInlineIcon = 14;
  static const double p2pHomeAccentIcon = 17;
  static const double p2pHomeActionIcon = 18;
  static const double p2pHomeMerchantOnlineOffset = -dividerHairline;
  static const double p2pHomeMerchantOnlineBorderWidth = hairlineStroke;
  static const double p2pE2EBottomInsetVisual = x5;
  static const double p2pE2EBottomInsetNative = x4;
  static EdgeInsets p2pE2EScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const double p2pE2EContentGap = 0;
  static const EdgeInsets p2pE2ECardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pE2EServerPadding = EdgeInsets.all(x3);
  static const double p2pE2EHeroIconBox = 80;
  static const double p2pE2EEndpointAvatarSize = 50;
  static const double p2pE2EStepNodeSize = 28;
  static const double p2pE2EConnectorWidth = x4;
  static const double p2pE2EConnectorHeight = hairlineStroke;
  static const double p2pE2ELockBox = x7 + x1;
  static const double p2pE2ELockIcon = p2pHomeInlineIcon;
  static const double p2pE2EBodyLineHeight = 1.6;
  static const double p2pE2EStepLineHeight = 1.5;
  static const double p2pE2EFingerprintLineHeight = 1.9;
  static const double p2pE2EFingerprintLetterSpacing = hairlineStroke;
  static const double p2pAddressProofBottomInsetVisual = x5;
  static const double p2pAddressProofBottomInsetNative = x4;
  static EdgeInsets p2pAddressProofScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const double p2pAddressProofContentGap = 0;
  static const EdgeInsets p2pAddressProofCardPadding = EdgeInsets.all(x2);
  static const EdgeInsetsDirectional p2pAddressProofHeroIconPadding =
      EdgeInsetsDirectional.all(x2);
  static const EdgeInsetsDirectional p2pAddressProofUploadVerticalPadding =
      EdgeInsetsDirectional.symmetric(vertical: x3);
  static const EdgeInsets p2pAddressProofDocumentExamplePadding =
      EdgeInsets.only(left: buttonCompact + x2);
  static const EdgeInsets p2pAddressProofExamplePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets p2pAddressProofChecklistIconPadding = EdgeInsets.only(
    top: dividerHairline,
  );
  static const EdgeInsets p2pAddressProofActionHorizontalPadding =
      EdgeInsets.symmetric(horizontal: x3);
  static const EdgeInsetsDirectional p2pAddressProofExampleTilePadding =
      EdgeInsetsDirectional.all(x2);
  static const EdgeInsetsDirectional p2pAddressProofUploadIconPadding =
      EdgeInsetsDirectional.all(x3);
  static const double p2pAddressProofReadableLineHeight = 1.35;
  static const double p2pAddressProofChecklistIcon = p2pHomeVerifiedIcon;
  static const double p2pKycBottomInsetVisual = x4;
  static const double p2pKycBottomInsetNative = x4;
  static EdgeInsets p2pKycScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static EdgeInsets p2pKycStatusScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const double p2pKycContentGap = 0;
  static const EdgeInsets p2pKycCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pKycCompactCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pKycNoticePadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pKycCompactNoticePadding = EdgeInsets.all(x2);
  static const EdgeInsetsDirectional p2pKycRequirementsCardPadding =
      EdgeInsetsDirectional.all(x3);
  static const EdgeInsetsDirectional p2pKycRequirementsNoticePadding =
      EdgeInsetsDirectional.all(x3);
  static const EdgeInsetsDirectional p2pKycRequirementsTierSectionPadding =
      EdgeInsetsDirectional.all(x3);
  static const EdgeInsetsDirectional p2pKycRequirementsTierActionPadding =
      EdgeInsetsDirectional.fromSTEB(x3, zero, x3, x3);
  static const EdgeInsetsDirectional p2pKycRequirementsChecklistIconPadding =
      EdgeInsetsDirectional.only(top: x1);
  static EdgeInsetsDirectional p2pKycRequirementsScrollPadding(
    double bottomInset,
  ) => EdgeInsetsDirectional.fromSTEB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pKycTierSectionPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets p2pKycTierActionPadding = EdgeInsets.fromLTRB(
    x4,
    0,
    x4,
    x4,
  );
  static const EdgeInsets p2pKycChecklistIconPadding = EdgeInsets.only(
    top: dividerHairline,
  );
  static const EdgeInsets p2pKycInlineActionPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets p2pKycTimelineRowPadding = EdgeInsets.only(
    bottom: x3,
  );
  static const EdgeInsets p2pKycStatusTimelineRowPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const double p2pKycReadableLineHeight = 1.35;
  static const double p2pKycTitleLineHeight = 1.05;
  static const double p2pKycSmallIcon = p2pHomeSmallIcon;
  static const double p2pKycChecklistIcon = p2pHomeVerifiedIcon;
  static const double p2pKycTimelineMetaIcon = p2pHomeTinyIcon;
  static const double p2pKycTimelineNodeBorder = hairlineStroke;
  static const double p2pKycTimelineLineWidth = hairlineStroke;
  static const double p2pKycUploadDropHeight = 128;
  static const double p2pClaimBottomInsetVisual = x5;
  static const double p2pClaimBottomInsetNative = x4;
  static EdgeInsets p2pClaimScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const double p2pClaimContentGap = x4;
  static const EdgeInsets p2pClaimHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pClaimCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pClaimCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pClaimInfoRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets p2pClaimActionPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pClaimChecklistPadding = EdgeInsets.only(
    bottom: x1,
  );
  static EdgeInsets p2pClaimTimelineRowPadding(bool isLast) =>
      EdgeInsets.only(bottom: isLast ? 0 : x4, top: x1);
  static const double p2pClaimProgressLineHeight = x1;
  static const double p2pClaimReasonLabelWidth = 72;
  static const double p2pClaimBodyLineHeight = 1.45;
  static const double p2pClaimDescriptionLineHeight = 1.55;
  static const double p2pClaimInlineIcon = p2pHomeSmallIcon;
  static const double p2pClaimSmallIcon = p2pHomeVerifiedIcon;
  static const double p2pClaimBenchmarkIcon = 15;
  static const double p2pClaimFeedbackIcon = 18;
  static const double p2pClaimTimelineNodeSize = x7;
  static const double p2pClaimTimelineNodeIcon = 15;
  static const double p2pClaimTimelineConnectorWidth = dividerHairline;
  static const double p2pClaimTimelineConnectorHeight = x6;
  static const double p2pBlacklistBottomInsetVisual = x4;
  static const double p2pBlacklistBottomInsetNative = x4;
  static EdgeInsets p2pBlacklistScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets p2pBlacklistFormScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const double p2pBlacklistContentGap = x2;
  static const double p2pBlacklistFormContentGap = 0;
  static const EdgeInsets p2pBlacklistSummaryPadding = EdgeInsets.fromLTRB(
    contentPad,
    0,
    contentPad,
    x2,
  );
  static const EdgeInsets p2pBlacklistHorizontalPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets p2pBlacklistResultPadding = EdgeInsets.fromLTRB(
    contentPad,
    x2,
    contentPad,
    0,
  );
  static const EdgeInsets p2pBlacklistEmptyPadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pBlacklistCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pBlacklistCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pBlacklistTinyCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pBlacklistFilterRailPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets p2pBlacklistChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pBlacklistReasonCountPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x2,
  );
  static const EdgeInsets p2pBlacklistSmallReasonPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets p2pBlacklistReasonBadgePadding = EdgeInsets.symmetric(
    horizontal: x1,
  );
  static const EdgeInsets p2pBlacklistChecklistPadding = EdgeInsets.only(
    bottom: x1,
  );
  static const EdgeInsets p2pBlacklistReasonTilePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double p2pBlacklistReadableLineHeight = 1.35;
  static const double p2pBlacklistHeroTitleLineHeight = 1.1;
  static const double p2pBlacklistHeroSubtitleMaxWidth = 280;
  static const double p2pBlacklistReasonIcon = 16;
  static const double p2pBlacklistVerifiedIcon = p2pHomeTinyIcon;
  static const double p2pBlacklistInlineIcon = p2pHomeInlineIcon;
  static const double p2pBlacklistReasonCountIcon = 10;
  static const double p2pBlacklistReasonBubbleIcon = 18;
  static const double p2pBlacklistFeedbackIcon = 18;
  static const double p2pBlacklistAvatarSize = 40;
  static const double p2pBlacklistAvatarBadgeSize = 16;
  static const double p2pBlacklistAvatarBadgeOffset = -2;
  static const double p2pBlacklistAvatarBorder = borderWidth;
  static const double p2pBlacklistAvatarBadgeBorder = hairlineStroke;
  static const double p2pBlacklistAvatarBadgeIcon = 8;
  static const double p2pBlacklistActionHeight = 40;
  static const double p2pBlacklistNoteFieldHeight = 110;
  static const EdgeInsetsDirectional p2pBlacklistListCardPadding =
      EdgeInsetsDirectional.all(x2);
  static const EdgeInsetsDirectional p2pBlacklistListTinyPadding =
      EdgeInsetsDirectional.all(x2);
  static const EdgeInsets p2pBlacklistListSummaryPadding = EdgeInsets.fromLTRB(
    contentPad,
    0,
    contentPad,
    x1,
  );
  static const EdgeInsets p2pBlacklistListResultPadding = EdgeInsets.fromLTRB(
    contentPad,
    x1,
    contentPad,
    0,
  );
  static const EdgeInsets p2pBlacklistListFilterChipPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x1);
  static EdgeInsets p2pBlacklistAddScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const double p2pMerchantApplyBottomInsetVisual = x5;
  static const double p2pMerchantApplyBottomInsetNative = x4;
  static EdgeInsets p2pMerchantApplyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x5, contentPad, bottomInset);
  static const EdgeInsets p2pMerchantApplyProgressPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    x3,
  );
  static const EdgeInsets p2pMerchantApplyConnectorPadding =
      EdgeInsets.symmetric(horizontal: x2);
  static const EdgeInsets p2pMerchantApplyCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pMerchantApplyInfoPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pMerchantApplyChoicePadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets p2pMerchantApplyInputPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets p2pMerchantApplyCheckboxMargin = EdgeInsets.only(
    top: x1,
  );
  static const EdgeInsets p2pMerchantApplyRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const double p2pMerchantApplyConnectorHeight = 2;
  static const double p2pMerchantApplyStepDotSize = 24;
  static const double p2pMerchantApplyIconBadgeSize = 32;
  static const double p2pMerchantApplyLargeIconBadgeSize = 48;
  static const double p2pMerchantApplyStatusIconSize = 28;
  static const int p2pMerchantApplyBenefitCrossAxisCount = 2;
  static const double p2pMerchantApplyBenefitMainAxisExtent = 112;
  static const double p2pMerchantApplyReadableLineHeight = 1.55;
  static const double p2pMerchantApplyCompactLineHeight = 1.35;
  static const double p2pMerchantApplyTightLineHeight = 1;
  static const double p2pChatHeaderTopGap = x3;
  static EdgeInsets p2pChatHeaderPadding(double topInset) =>
      EdgeInsets.fromLTRB(contentPad, topInset + x3, contentPad, x3);
  static const EdgeInsets p2pChatRiskBannerPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: x3,
  );
  static const EdgeInsets p2pChatBannerPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: x3,
  );
  static const EdgeInsets p2pChatScrollPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    x4,
  );
  static const EdgeInsets p2pChatEncryptionPillPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets p2pChatDatePadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets p2pChatMessageBottomPadding = EdgeInsets.only(
    bottom: x4,
  );
  static const EdgeInsets p2pChatSystemMessagePadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pChatMessagePadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static EdgeInsets p2pChatComposerBottomPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pChatQuickReplyRailPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: x3,
  );
  static const EdgeInsets p2pChatComposerInputPadding = EdgeInsets.fromLTRB(
    contentPad,
    x2,
    contentPad,
    x3,
  );
  static const EdgeInsets p2pChatComposerLabelPadding = EdgeInsets.only(
    left: x3,
  );
  static const EdgeInsets p2pChatReplyChipOuterPadding = EdgeInsets.only(
    right: x2,
  );
  static const EdgeInsets p2pChatReplyChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets p2pChatSmallHeaderButtonPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static const double p2pChatHeaderAvatarRadius = 18;
  static const double p2pChatMerchantAvatarRadius = 14;
  static const double p2pChatOnlineBadgeSize = 9;
  static const double p2pChatOnlineBadgeOffset = -1;
  static const double p2pChatOnlineBadgeBorder = 2;
  static const double p2pChatSystemMessageMaxWidth = 340;
  static const double p2pChatMessageMaxWidth = 300;
  static const double p2pChatTinyIcon = 10;
  static const double p2pChatCloseIcon = 13;
  static const double p2pChatReadIcon = 12;
  static const double p2pChatRoundIconButtonSize = 40;
  static const double p2pExpressBottomInsetVisual = x6;
  static const double p2pExpressBottomInsetNative = x5;
  static EdgeInsets p2pExpressScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets p2pExpressTogglePadding = EdgeInsets.all(x1);
  static const EdgeInsets p2pExpressCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pExpressCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pExpressSelectorPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pExpressEscrowPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pExpressHowStepPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets p2pExpressMerchantRowPadding = EdgeInsets.only(
    bottom: x3,
  );
  static const EdgeInsets p2pExpressSmallChipPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const double p2pExpressAmountBorderWidth = 2;
  static const double p2pExpressAssetMarkSize = x5;
  static const double p2pExpressIconBoxSize = x6;
  static const EdgeInsets p2pExpressTightCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pExpressChoiceChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static EdgeInsets p2pExpressConfirmScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pExpressConfirmCompactCardPadding = EdgeInsets.all(
    x2,
  );
  static EdgeInsets p2pAdDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets p2pAdDetailFlushScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets p2pAdDetailFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pAdDetailCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pAdDetailCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pAdDetailInputPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets p2pAdDetailPercentPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets p2pAdDetailSignalChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double p2pAdDetailAvatarSize = x7;
  static const double p2pAdDetailOnlineBadgeSize = x4;
  static const double p2pAdDetailOnlineBadgeBorder = 2;
  static const double p2pAdDetailEscrowLineHeight = 1.6;
  static EdgeInsets p2pSettingsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets p2pSettingsCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pSettingsCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pSettingsHorizontalCardPadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets p2pSettingsSegmentRailPadding = EdgeInsets.all(x1);
  static const EdgeInsets p2pSettingsOptionChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets p2pSettingsRowPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets p2pSettingsSegmentButtonPadding =
      EdgeInsets.symmetric(vertical: x3);
  static const EdgeInsets p2pSettingsSwitchPadding = EdgeInsets.all(2);
  static const double p2pSettingsSwitchWidth = 44;
  static const double p2pSettingsSwitchHeight = 24;
  static const double p2pSettingsSwitchThumbSize = 18;
  static const double p2pSettingsAutoReplyLineHeight = 1.45;
  static EdgeInsets p2pSettingsPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pSettingsPageCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pSettingsPageCompactCardPadding = EdgeInsets.all(
    x2,
  );
  static const EdgeInsets p2pSettingsPageHorizontalCardPadding =
      EdgeInsets.symmetric(horizontal: x2);
  static const EdgeInsets p2pSettingsPageRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static EdgeInsets p2pTwoFactorScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pTwoFactorCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTwoFactorInnerPadding = EdgeInsets.all(x2);
  static EdgeInsets p2pDevicesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pDevicesCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pDevicesInnerPadding = EdgeInsets.all(x2);
  static EdgeInsets p2pNotificationsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pNotificationsCardPadding = EdgeInsets.all(x2);
  static const EdgeInsetsGeometry p2pNotificationsChannelPadding =
      EdgeInsetsDirectional.symmetric(horizontal: x2, vertical: x3);
  static EdgeInsets p2pTaxScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pTaxCardPadding = EdgeInsets.all(x3);
  static EdgeInsets p2pTradingLevelScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pTradingLevelHeroHeaderPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTradingLevelHeroBodyPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTradingLevelMetricPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTradingLevelNextCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTradingLevelCardHeaderPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTradingLevelCardBodyPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTradingLevelLimitPadding = EdgeInsets.all(x2);
  static const double p2pTradingLevelHeroBadgeSize = 44;
  static const double p2pTradingLevelLevelBadgeSize = 40;
  static const double p2pTradingLevelMetricMinHeight = 72;
  static const double p2pTradingLevelMetricIconSize = 20;
  static const double p2pTradingLevelMetricGlyphSize = 12;
  static const double p2pTradingLevelInlineIcon = 15;
  static const double p2pTradingLevelRequirementIcon = 14;
  static const double p2pTradingLevelTinyIcon = 12;
  static const double p2pTradingLevelDailyTrackHeight = 6;
  static const double p2pTradingLevelNextTrackHeight = 6;
  static const double p2pTradingLevelBadgeIconScale = 0.48;
  static const double p2pTradingLevelBadgeElevation = 2;
  static const double p2pTradingLevelTitleLineHeight = 1.15;
  static const double p2pTradingLevelMicroLineHeight = 1.15;
  static const double p2pTradingLevelRequirementLineHeight = 1.35;
  static const double p2pTradingLevelUpgradeButtonHeight = 36;
  static EdgeInsets p2pGuideScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const EdgeInsets p2pGuideTabsPadding = EdgeInsets.fromLTRB(
    contentPad,
    x3,
    contentPad,
    0,
  );
  static const EdgeInsets p2pGuideFaqCardPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pGuideFaqAnswerPadding = EdgeInsets.fromLTRB(
    x6,
    0,
    x3,
    x2,
  );
  static const EdgeInsets p2pGuideModeRailPadding = EdgeInsets.all(x1);
  static const EdgeInsets p2pGuideCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pGuideModeButtonPadding = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets p2pGuideStepContentPadding = EdgeInsets.only(top: x1);
  static const EdgeInsets p2pGuideSafetyTipPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pGuideVideoEmptyPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pGuideVideoCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pGuideConceptPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pGuideTonePillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const double p2pGuideAnswerLineHeight = 1.35;
  static const double p2pGuideBodyLineHeight = 1.35;
  static const double p2pGuidePillLineHeight = 1;
  static const double p2pGuideThumbWidth = x6;
  static const double p2pGuideThumbHeight = buttonCompact;
  static EdgeInsets p2pSelfieScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pSelfieReviewPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pSelfieCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pSelfieLargeCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pSelfieResultIconMargin = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets p2pSelfieScoreRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets p2pSelfieChecklistIconPadding = EdgeInsets.only(
    top: x1,
  );
  static const double p2pSelfieBodyLineHeight = 1.45;
  static const double p2pSelfieSampleAspectRatio = 4 / 3;
  static const double p2pSelfieCaptureAspectRatio = 3 / 4;
  static const double p2pSelfieLivenessGridAspectRatio = 1.2;
  static const double p2pSelfieSampleIconSize = 72;
  static const double p2pSelfieLivenessIconSize = 64;
  static const double p2pSelfieChecklistIconSize = iconSm;
  static const int p2pSelfieLivenessGridColumns = 2;
  static EdgeInsets p2pVideoScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pVideoCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pVideoCompactCardPadding = EdgeInsets.all(x2);
  static EdgeInsets p2pRiskAssessmentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pRiskAssessmentHeroPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pRiskAssessmentCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pRiskAssessmentInnerPadding = EdgeInsets.all(x2);
  static EdgeInsets p2pLimitTrackerScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pLimitTrackerCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pLimitTrackerCompactPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pLimitTrackerMetricPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x2,
  );
  static const EdgeInsets p2pLimitTrackerPeriodTabPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x2);
  static EdgeInsets p2pAmlScreeningScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pAmlScreeningCardPadding = EdgeInsets.all(x2);
  static EdgeInsets p2pComplianceOverviewScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pComplianceOverviewCompactPadding = EdgeInsets.all(
    x2,
  );
  static const EdgeInsetsDirectional p2pComplianceOverviewHeroPadding =
      EdgeInsetsDirectional.all(x3);
  static const EdgeInsetsDirectional p2pComplianceOverviewItemPadding =
      EdgeInsetsDirectional.symmetric(horizontal: x3, vertical: x2);
  static EdgeInsets p2pSourceOfFundsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets p2pSuspiciousActivityScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static EdgeInsets p2pLargeTransactionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets p2pInsuranceScoreScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pInsuranceScoreLargeCardPadding = EdgeInsets.all(
    x3,
  );
  static const EdgeInsets p2pInsuranceScoreCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pInsuranceScoreInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pInsuranceScoreRecommendationPadding =
      EdgeInsets.all(x2);
  static const EdgeInsets p2pInsuranceScoreGainPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double p2pInsuranceScoreBodyLineHeight = 1.35;
  static const double p2pInsuranceScoreMicroLineHeight = 1.35;
  static const double p2pInsuranceScoreRingBox = 124;
  static const double p2pInsuranceScoreRingTrack = 116;
  static const double p2pInsuranceScoreRingStroke = 8;
  static const double p2pInsuranceScoreFactorIconBox = 34;
  static const double p2pInsuranceScoreFactorRailIndent = 46;
  static const EdgeInsets p2pInsuranceScoreFactorRailPadding = EdgeInsets.only(
    left: p2pInsuranceScoreFactorRailIndent,
  );
  static const double p2pInsuranceScoreFactorStatusWidth = 62;
  static const double p2pInsuranceScoreProgressHeight = 5;
  static const double p2pInsuranceScoreHeaderIcon = iconSm;
  static const double p2pInsuranceScoreSmallIcon = 16;
  static const double p2pInsuranceScoreFactorIcon = 17;
  static const double p2pInsuranceScoreRecommendationIcon = 14;
  static const double p2pInsuranceScoreActionDot = x2;
  static EdgeInsets p2pEscrowDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pEscrowDetailHeroPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pEscrowDetailCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pEscrowDetailInnerPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pEscrowDetailExplorerPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pEscrowDetailInfoRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets p2pEscrowDetailTimelineRowPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const double p2pEscrowDetailSignatureStroke = x1;
  static const double p2pEscrowDetailTimelineIcon = 14;
  static const double p2pEscrowDetailBodyLineHeight = 1.45;
  static EdgeInsets p2pEscrowBalanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pEscrowBalanceLargePadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pEscrowBalanceCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pEscrowBalanceInnerPadding = EdgeInsets.all(x2);
  static EdgeInsets p2pMyOrdersScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pMyOrdersStatPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x2,
  );
  static const EdgeInsets p2pMyOrdersCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pMyOrdersCompactPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pMyOrdersLargePadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pMyOrdersChipPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets p2pOrderBookCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pOrderBookCompactPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pOrderBookSelectorPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pOrderBookRowPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static EdgeInsets p2pOrderBookScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static EdgeInsets p2pFraudScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pFraudCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pFraudInnerPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pFraudPatternPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pFraudCategoryTabPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x2,
  );
  static const EdgeInsets p2pFraudChecklistItemPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const double p2pFraudProgressHeight = x2;
  static const double p2pFraudHeaderIcon = iconMd;
  static const double p2pFraudActionIcon = iconSm;
  static const double p2pFraudChecklistBox = 22;
  static const double p2pFraudChecklistCheckIcon = 14;
  static const double p2pFraudDetailIcon = 13;
  static const double p2pFraudBodyLineHeight = 1.45;
  static const double p2pFraudDisclosureLineHeight = 1.5;
  static EdgeInsets p2pSecurityCenterScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets p2pSecurityCenterCardPadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pSecurityCenterItemPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pSecurityCenterNoticePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x3,
  );
  static const EdgeInsets p2pSecurityCenterViewAllPadding =
      EdgeInsets.symmetric(vertical: x3, horizontal: x4);
  static const double p2pSecurityCenterScoreBox = 128;
  static const double p2pSecurityCenterScoreTrack = 118;
  static const double p2pSecurityCenterScoreStroke = 7;
  static const double p2pSecurityCenterIconBox = 40;
  static const double p2pSecurityCenterTimeIcon = 11;
  static const int p2pSecurityCenterQuickActionCrossAxisCount = 2;
  static const double p2pSecurityCenterQuickActionAspectRatio = 1.66;
  static const double p2pSecurityCenterLabelLineHeight = 1.3;
  static const double p2pSecurityCenterCompactLineHeight = 1.35;
  static const double p2pSecurityCenterBodyLineHeight = 1.45;
  static const double p2pSecurityCenterNumberLineHeight = 1;
  static EdgeInsets p2pLoginHistoryScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets p2pLoginHistoryPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets p2pAchievementsPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static EdgeInsets p2pFundLockScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets p2pContributionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const EdgeInsets p2pLoginHistoryStatPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x3,
  );
  static const EdgeInsets p2pLoginHistoryFilterPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets p2pLoginHistoryNoticePadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pLoginHistoryEventPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pLoginHistoryBadgePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets p2pLoginHistoryEmptyPadding = EdgeInsets.symmetric(
    vertical: x7,
  );
  static const double p2pLoginHistoryIconBox = inputHeight;
  static const double p2pLoginHistoryEventIcon = 22;
  static const double p2pLoginHistoryMetaIcon = 11;
  static const double p2pLoginHistoryStatusIcon = 11;
  static const double p2pLoginHistoryTrailingMaxWidth = 92;
  static const double p2pLoginHistoryExpandIcon = 16;
  static const double p2pLoginHistoryWarningLineHeight = 1.5;
  static const double p2pLoginHistoryRiskLineHeight = 1.45;
  static const double p2pLoginHistoryInfoLineHeight = 1.55;
  static EdgeInsets p2pTransactionLimitsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pTransactionLimitsCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTransactionLimitsInnerPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pTransactionLimitsBadgePadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static const EdgeInsets p2pTransactionLimitsTrackerPadding =
      EdgeInsets.symmetric(horizontal: x2);
  static const EdgeInsets p2pTransactionLimitsCtaPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static EdgeInsets p2pTransactionLimitsUsageItemPadding(bool isLast) =>
      EdgeInsets.only(bottom: isLast ? 0 : x4);
  static const double p2pTransactionLimitsIconBox = inputHeight;
  static const double p2pTransactionLimitsDetailIcon = 20;
  static const double p2pTransactionLimitsRequirementIcon = iconSm;
  static const double p2pTransactionLimitsInfoIcon = 16;
  static const double p2pTransactionLimitsTrackerIcon = 15;
  static const double p2pTransactionLimitsInfoLineHeight = 1.55;
  static EdgeInsets p2pSecurityDetailsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets p2pSecurityDetailsCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pSecurityDetailsInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pSecurityDetailsCodePadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x5,
  );
  static const EdgeInsets p2pSecurityDetailsActionPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x3);
  static const EdgeInsets p2pSecurityDetailsEditPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static EdgeInsets p2pSecurityDetailsDeviceActionPadding(bool compact) =>
      EdgeInsets.symmetric(horizontal: compact ? x4 : x3, vertical: x3);
  static const EdgeInsets p2pSecurityDetailsBulletPadding = EdgeInsets.only(
    top: 7,
  );
  static const double p2pSecurityDetailsIconBox = inputHeight;
  static const double p2pSecurityDetailsHeroIconBox = 52;
  static const double p2pSecurityDetailsMethodIconBox = 40;
  static const double p2pSecurityDetailsIconActionBox = 32;
  static const double p2pSecurityDetailsDeviceIcon = 24;
  static const double p2pSecurityDetailsTinyIcon = 14;
  static const double p2pSecurityDetailsMetaIcon = 11;
  static const double p2pSecurityDetailsInlineIcon = 12;
  static const double p2pSecurityDetailsCheckIcon = 13;
  static const double p2pSecurityDetailsSmallBullet = 4;
  static const double p2pSecurityDetailsBullet = 5;
  static const double p2pSecurityDetailsHeroLineHeight = 1.12;
  static const double p2pSecurityDetailsBodyLineHeight = 1.55;
  static const double p2pSecurityDetailsCaptionLineHeight = 1.45;
  static const double p2pSecurityDetailsNoticeLineHeight = 1.35;
  static const double p2pSecurityDetailsDeviceNoticeLineHeight = 1.5;
  static EdgeInsets p2pRiskControlsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets p2pRiskControlsReportScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x5, contentPad, bottomInset);
  static EdgeInsets p2pRiskControlsBottomScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pRiskControlsHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pRiskControlsOrderHeroPadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: x6);
  static const EdgeInsets p2pRiskControlsCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pRiskControlsInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pRiskControlsActionPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets p2pRiskControlsReasonPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets p2pRiskControlsReasonButtonPadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets p2pRiskControlsSummaryRowPadding =
      EdgeInsets.symmetric(vertical: x2);
  static const EdgeInsets p2pRiskControlsReasonItemPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets p2pRiskControlsDetailBottomPadding = EdgeInsets.only(
    bottom: x4,
  );
  static const double p2pRiskControlsScoreBox = 80;
  static const double p2pRiskControlsAvatarSize = 48;
  static const double p2pRiskControlsOrderHeroIconBox = x7 + x3;
  static const double p2pRiskControlsReasonIconBox = 36;
  static const double p2pRiskControlsChoiceBox = x5;
  static const double p2pRiskControlsInfoIcon = 16;
  static const double p2pRiskControlsNoticeIcon = 14;
  static const double p2pRiskControlsReasonIcon = 16;
  static const double p2pRiskControlsChoiceBorderWidth = hairlineStroke;
  static const double p2pRiskControlsSelectedBorderWidth = 1.5;
  static const double p2pRiskControlsOrderHeroMaxWidth = 280;
  static const double p2pRiskControlsBodyLineHeight = 1.45;
  static const double p2pRiskControlsInfoLineHeight = 1.5;
  static const double p2pRiskControlsNoticeLineHeight = 1.55;
  static EdgeInsets p2pDocumentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets p2pDocumentInfoRowPadding(double bottomGap) =>
      EdgeInsets.only(bottom: bottomGap);
  static const EdgeInsets p2pDocumentCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pDocumentLargePadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pDocumentHeroPadding = EdgeInsets.symmetric(
    horizontal: x5,
    vertical: x6,
  );
  static const EdgeInsets p2pDocumentChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets p2pDocumentDownloadPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pDocumentDividerBottomPadding = EdgeInsets.only(
    bottom: x4,
  );
  static const EdgeInsets p2pDocumentBulletTopPadding = EdgeInsets.only(
    top: x3,
  );
  static const double p2pDocumentChipMinWidth = 64;
  static const double p2pDocumentIconBox = inputHeight;
  static const double p2pDocumentHeroIconBox = x7;
  static const double p2pDocumentBullet = x2;
  static const double p2pDocumentTinyIcon = 13;
  static const double p2pDocumentDownloadIcon = 14;
  static const double p2pDocumentSmallIcon = 15;
  static const double p2pDocumentInlineIcon = 16;
  static const double p2pDocumentRowIcon = 17;
  static const double p2pDocumentCalloutIcon = 18;
  static const double p2pDocumentBodyLineHeight = 1.45;
  static const double p2pDocumentPrivacyLineHeight = 1.5;
  static const double p2pDocumentNoticeLineHeight = 1.55;
  static const double p2pDocumentPolicyLineHeight = 1.6;
  static EdgeInsets p2pInsuranceCertificateScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pInsuranceCertificateLargePadding = EdgeInsets.all(
    x3,
  );
  static const EdgeInsets p2pInsuranceCertificateCardPadding = EdgeInsets.all(
    x2,
  );
  static const EdgeInsets p2pInsuranceCertificateHeroPadding = EdgeInsets.all(
    x3,
  );
  static const EdgeInsets p2pInsuranceCertificateDividerPadding =
      EdgeInsets.only(bottom: x2);
  static const EdgeInsets p2pInsuranceCertificateBulletPadding =
      EdgeInsets.only(top: x2);
  static const double p2pInsuranceCertificateBodyLineHeight = 1.35;
  static const EdgeInsets p2pInsuranceFundTourSkipPadding =
      EdgeInsets.symmetric(horizontal: x4);
  static EdgeInsets p2pFinancialSafetyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets p2pFinancialSafetyBottomPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pFinancialSafetyHorizontalPadding =
      EdgeInsets.symmetric(horizontal: contentPad);
  static const EdgeInsets p2pFinancialSafetyLargePadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pFinancialSafetyCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pFinancialSafetyInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pFinancialSafetyTilePadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets p2pFinancialSafetyTipPadding = EdgeInsets.symmetric(
    vertical: x1,
  );
  static const double p2pFinancialSafetyIconBox = inputHeight;
  static const double p2pFinancialSafetyCompactIconBox = buttonCompact;
  static const double p2pFinancialSafetyEmptyIconBox = x7;
  static const double p2pFinancialSafetyProofThumb = x7 + x6;
  static const double p2pFinancialSafetyUploadCardHeight =
      buttonHero + ctaHeight;
  static const double p2pFinancialSafetyAccentLineWidth = x5;
  static const double p2pFinancialSafetyAccentLineHeight = hairlineStroke * 2;
  static const double p2pFinancialSafetyUploadBorderWidth = 2;
  static const double p2pFinancialSafetyTinyIcon = 12;
  static const double p2pFinancialSafetyBodyLineHeight = 1.45;
  static EdgeInsets p2pMerchantCommerceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets p2pMerchantCommerceRelaxedScrollPadding(
    double bottomInset,
  ) => EdgeInsets.fromLTRB(contentPad, x5, contentPad, bottomInset);
  static EdgeInsets p2pMerchantCommerceFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pMerchantCommerceSectionLabelPadding =
      EdgeInsets.only(bottom: x2);
  static const EdgeInsets p2pMerchantCommerceCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pMerchantCommerceCompactPadding = EdgeInsets.all(
    x3,
  );
  static const EdgeInsets p2pMerchantCommerceSegmentPadding = EdgeInsets.all(
    x1,
  );
  static const EdgeInsets p2pMerchantCommerceLargePadding = EdgeInsets.all(x6);
  static const EdgeInsets p2pMerchantCommerceStatPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x4,
  );
  static const EdgeInsets p2pMerchantCommerceChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pMerchantCommerceWideChipPadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: x2);
  static const EdgeInsets p2pMerchantCommerceTextAreaPadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets p2pMerchantCommerceQuickLinkPadding =
      EdgeInsets.symmetric(vertical: x2);
  static const EdgeInsets p2pMerchantCommerceDetailRightPadding =
      EdgeInsets.only(right: x2);
  static const EdgeInsets p2pMerchantCommerceStarPadding = EdgeInsets.only(
    right: x1,
  );
  static const EdgeInsets p2pMerchantCommerceReplyPadding = EdgeInsets.only(
    left: x3,
  );
  static const double p2pMerchantCommerceStatCardHeight = buttonHero + x5;
  static const double p2pMerchantCommerceActionButtonHeight = inputHeight - x2;
  static const double p2pMerchantCommerceSegmentHeight = inputHeight - x2;
  static const double p2pMerchantCommerceSortButtonHeight =
      buttonCompact + x2 + x2;
  static const double p2pMerchantCommerceTextAreaMinHeight = buttonHero + x6;
  static const double p2pMerchantCommerceReviewScoreWidth = 92;
  static const double p2pMerchantCommerceConfirmLabelWidth = 76;
  static const double p2pMerchantCommerceQuickLinkIconBox = x7;
  static const double p2pMerchantCommerceAvatarSize = x6;
  static const double p2pMerchantCommerceMerchantAvatarSize = buttonHero;
  static const double p2pMerchantCommerceOnlineDot = x4;
  static const double p2pMerchantCommerceOnlineBorderWidth = 2;
  static const double p2pMerchantCommerceRatingIcon = 14;
  static const double p2pMerchantCommerceSmallIcon = 13;
  static const double p2pMerchantCommerceTinyIcon = 10;
  static const double p2pMerchantCommerceDividerHeight =
      walletHistoryDividerHeight;
  static const double p2pMerchantCommerceReplyBorderWidth = hairlineStroke;
  static const double p2pMerchantCommerceInputBorderWidth = 1.5;
  static const double p2pMerchantCommerceTightLineHeight = 1;
  static const double p2pMerchantCommerceBodyLineHeight = 1.45;
  static const double p2pMerchantCommerceWarningLineHeight = 1.55;
  static EdgeInsets p2pMerchantCommercePageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pMerchantCommerceInnerPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pMerchantCommerceDialogButtonPadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets p2pMerchantCommerceWarningPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static EdgeInsets p2pTrustProgressScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static EdgeInsets p2pTrustProgressRelaxedScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x5, contentPad, bottomInset);
  static const EdgeInsets p2pTrustProgressTabPadding = EdgeInsets.fromLTRB(
    contentPad,
    x3,
    contentPad,
    x2,
  );
  static const EdgeInsets p2pTrustProgressTourPadding = EdgeInsets.fromLTRB(
    contentPad,
    x7,
    contentPad,
    x5,
  );
  static const EdgeInsets p2pTrustProgressCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pTrustProgressCompactPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pTrustProgressHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pTrustProgressChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pTrustProgressSummaryMetricPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x3);
  static const EdgeInsets p2pTrustProgressTinyPillPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x1);
  static const EdgeInsets p2pTrustProgressInputPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets p2pTrustProgressInfoRowPadding = EdgeInsets.symmetric(
    vertical: x1,
  );
  static const EdgeInsets p2pTrustProgressNotificationRowPadding =
      EdgeInsets.symmetric(vertical: x2);
  static const EdgeInsets p2pTrustProgressStepPadding = EdgeInsets.only(
    bottom: x3,
  );
  static const double p2pTrustProgressChartHeight = buttonHero * 1.55;
  static const double p2pTrustProgressInputHeight = inputHeight;
  static const double p2pTrustProgressTourMaxHeight = 956;
  static const double p2pTrustProgressTourStepHeight = 3;
  static const double p2pTrustProgressIconBox = 44;
  static const double p2pTrustProgressIconBoxLarge = 56;
  static const double p2pTrustProgressIcon = 21;
  static const double p2pTrustProgressIconLarge = x7;
  static const double p2pTrustProgressBadgeSize = x4 + x2;
  static const double p2pTrustProgressBadgeInset = -3;
  static const double p2pTrustProgressBadgeBorderWidth = 2;
  static const double p2pTrustProgressBadgeIcon = 10;
  static const double p2pTrustProgressTinyIcon = 11;
  static const double p2pTrustProgressSmallIcon = 18;
  static const double p2pTrustProgressContributionAmountWidth = 112;
  static const double p2pTrustProgressRewardMaxWidth = 220;
  static const double p2pTrustProgressStepRadius = x3;
  static const double p2pTrustProgressSummaryProgressHeight = x2;
  static const double p2pTrustProgressCardProgressHeight = 6;
  static const double p2pTrustProgressAmountLineHeight = 1.05;
  static const double p2pTrustProgressBodyLineHeight = 1.45;
  static const double p2pTrustProgressCaptionLineHeight = 1.35;
  static const double p2pTrustProgressDotSize = x2;
  static const double p2pWalletBottomInsetVisual = x5;
  static const double p2pWalletBottomInsetNative = x4;
  static EdgeInsets p2pWalletScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets p2pWalletHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pWalletHeroActionPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const EdgeInsets p2pWalletCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pWalletCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pWalletNoticePadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pWalletTextActionPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const EdgeInsets p2pWalletTransferChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets p2pWalletTransferPercentPadding =
      EdgeInsets.symmetric(vertical: x3);
  static const EdgeInsets p2pWalletTransferSwitchPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets p2pWalletTransferAssetTilePadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x3);
  static EdgeInsets p2pWalletTransferScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pWalletTransferCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pWalletTransferDirectionSwitchPadding =
      EdgeInsets.symmetric(horizontal: x2);
  static const EdgeInsets p2pWalletTransferConfirmSummaryPadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: x3);
  static const EdgeInsets p2pWalletTransferAssetChipPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x2);
  static const EdgeInsets p2pWalletTransferConfirmHeroPadding =
      EdgeInsets.symmetric(vertical: x2);
  static const double p2pWalletInlineActionIcon = 14;
  static const double p2pWalletMetaIcon = 11;
  static const double p2pWalletTransactionIcon = 20;
  static const double p2pWalletInfoIcon = 16;
  static const double p2pWalletTransferAssetTileMinHeight = 80;
  static const double p2pWalletTransferConfirmIconBox = 80;
  static const double p2pWalletTransferConfirmIcon = 40;
  static const double p2pWalletTransferNoticeLineHeight =
      complaintSubmissionLineHeightReadable;
  static const double p2pOrderBottomInsetVisual = x6;
  static const double p2pOrderBottomInsetNative = x4;
  static EdgeInsets p2pOrderScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const double p2pOrderContentGap = x4;
  static const EdgeInsets p2pOrderStatusPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: x4,
  );
  static const EdgeInsets p2pOrderStepperPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: x4,
  );
  static const EdgeInsets p2pOrderStepperConnectorPadding = EdgeInsets.only(
    top: x3 + hairlineStroke,
  );
  static const EdgeInsets p2pOrderCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pOrderCompactCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pOrderBulletPadding = EdgeInsets.only(bottom: x1);
  static const EdgeInsets p2pOrderEscrowActionPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pOrderQrTogglePadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets p2pOrderQrPanelPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pOrderQrInnerPadding = EdgeInsets.all(x2);
  static const double p2pOrderQrSize = 140;
  static const EdgeInsets p2pOrderPaymentFieldPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets p2pOrderTimelineItemPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets p2pOrderInfoLinePadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets p2pOrderSmallPillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pOrderSmallButtonPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets p2pOrderQuickButtonPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const EdgeInsets p2pOrderTextActionPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets p2pOrderInlineWarningPadding = EdgeInsets.all(x3);
  static const double p2pOrderDividerHeight = walletHistoryDividerHeight;
  static const double p2pOrderStepperConnectorHeight = hairlineStroke;
  static const double p2pOrderTimelineConnectorWidth = hairlineStroke;
  static const double p2pOrderTimelineIcon = 15;
  static const double p2pOrderSmallPillIcon = 11;
  static const double p2pOrderQuickActionIcon = 12;
  static const double p2pOrderSmallButtonIcon = 13;
  static const double p2pOrderTimelineEventIcon = 18;
  static const double p2pOrderRatingStarIcon = iconLg + x2;
  static const double p2pOrderRatingMerchantAvatarSize = x7 + x3;
  static const double p2pOrderRatingSuccessIconBox = x7 + x5;
  static EdgeInsets p2pOrderLifecycleScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pOrderRateCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pOrderRateStarChipPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const EdgeInsets p2pOrderRateTagChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static EdgeInsets p2pOrderTimelineRowPadding({required bool isLast}) =>
      EdgeInsets.only(bottom: isLast ? 0 : x6);
  static const EdgeInsets p2pOrderLifecycleHorizontalPadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets p2pOrderLifecycleSummaryLinePadding =
      EdgeInsets.symmetric(vertical: x3);
  static const EdgeInsets p2pOrderLifecycleHeroPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pOrderLifecycleSuccessPadding = EdgeInsets.all(
    contentPad,
  );
  static const double p2pComplianceBottomInsetVisual = x5;
  static const double p2pComplianceBottomInsetNative = x4;
  static const double p2pNotificationBottomInsetVisual = x4;
  static const double p2pNotificationBottomInsetNative = x4;
  static EdgeInsets p2pComplianceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets p2pComplianceCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pComplianceCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pComplianceMetricPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets p2pCompliancePeriodTabPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const EdgeInsets p2pComplianceChecklistIconPadding = EdgeInsets.only(
    top: 2,
  );
  static const double p2pComplianceIconBox = inputHeight;
  static const double p2pComplianceDividerHeight = hairlineStroke;
  static const double p2pComplianceHeroIcon = 26;
  static const double p2pComplianceChannelButtonHeight = 46;
  static const double p2pComplianceChannelIcon = 17;
  static const double p2pComplianceChecklistIcon = 13;
  static const double p2pComplianceDismissButton = x6 + x2;
  static const double p2pComplianceMetaIcon = 11;
  static const double p2pComplianceCalendarIcon = 12;
  static const double p2pComplianceUnavailableIcon = 20;
  static const double p2pComplianceReadableLineHeight = 1.45;
  static const double p2pComplianceInfoLineHeight = 1.5;
  static const double p2pComplianceTitleLineHeight = 1.15;
  static const double p2pPaymentBottomInsetVisual = x5;
  static const double p2pPaymentBottomInsetNative = x4;
  static EdgeInsets p2pPaymentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const double p2pPaymentSectionGap = x3;
  static const double p2pPaymentCardGap = x2;
  static const double p2pPaymentSmallGap = x2;
  static const EdgeInsets p2pPaymentEmptyPadding = EdgeInsets.symmetric(
    vertical: x6,
  );
  static const EdgeInsets p2pPaymentDialogOuterPadding = EdgeInsets.all(
    contentPad,
  );
  static const EdgeInsets p2pPaymentCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pPaymentCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pPaymentButtonPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double p2pPaymentVerifiedIcon = 13;
  static const EdgeInsets p2pPaymentSetDefaultPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static EdgeInsets p2pPaymentAddScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const double p2pPaymentAddBottomInset = x4;
  static const EdgeInsets p2pPaymentConfirmRowPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const double p2pPaymentTypeIcon = 18;
  static const EdgeInsets p2pPaymentOptionPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double p2pPaymentPreviewLabelWidth = 108;
  static EdgeInsets p2pPaymentFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pPaymentCountdownPadding = EdgeInsets.symmetric(
    vertical: x5,
  );
  static const double p2pPaymentHeroIcon = 28;
  static const double p2pPaymentMetaIcon = 11;
  static const double p2pPaymentChevronIcon = 20;
  static const double p2pPaymentVerificationIntroIconBox = 64;
  static const double p2pPaymentVerificationIntroIcon = 32;
  static const double p2pPaymentVerificationStepDot = 24;
  static const EdgeInsets p2pPaymentMethodsListCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pPaymentMethodsListButtonPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x2);
  static const EdgeInsets p2pPaymentMethodsListDefaultPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x1);
  static const EdgeInsets p2pPaymentMethodsListEmptyPadding =
      EdgeInsets.symmetric(vertical: x4);
  static const double p2pPaymentMethodsListSectionGap = x1;
  static const double p2pPaymentMethodsListCardMinExtent = 80;
  static const EdgeInsets p2pPaymentAddFormCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pPaymentAddFormOptionPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x2,
  );
  static EdgeInsets p2pPaymentAddFormScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static const EdgeInsets p2pPaymentAddFormPreviewGap = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets p2pPaymentDialogActionPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets p2pPaymentOwnershipCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pPaymentOwnershipOptionPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x2);
  static EdgeInsets p2pPaymentOwnershipScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static EdgeInsets p2pPaymentCoolingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const EdgeInsets p2pPaymentCoolingHeroCountdownPadding =
      EdgeInsets.symmetric(vertical: x3);
  static EdgeInsets p2pPaymentHistoryScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets p2pPaymentVerificationScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const double p2pDisputeBottomInsetVisual = x4;
  static const double p2pDisputeBottomInsetNative = x4;
  static EdgeInsets p2pDisputeScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, bottomInset);
  static EdgeInsets p2pDisputesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x5, contentPad, bottomInset);
  static const double p2pDisputeContentGap = x4;
  static const double p2pDisputeSectionGap = x3;
  static const double p2pDisputeSmallGap = x1;
  static const EdgeInsets p2pDisputeCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pDisputeCompactCardPadding = EdgeInsets.all(x3);
  static const EdgeInsets p2pDisputeEmptyPadding = EdgeInsets.all(x5);
  static const EdgeInsets p2pDisputeReasonTilePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const double p2pDisputeReasonMinHeight = buttonCompact + x2;
  static const double p2pDisputeHeroIconBox = buttonCompact;
  static const double p2pDisputeUploadHeight = ctaHeight + x4;
  static const double p2pDisputeDashLength = x3;
  static const double p2pDisputeDashGap = x2;
  static const double p2pDisputeStatCardHeight = buttonHero + x5;
  static const double p2pDisputeStatIconBox = x6;
  static const double p2pDisputeNoticeMinHeight = buttonHero + x1;
  static const EdgeInsets p2pDisputeNoticePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x4,
  );
  static const double p2pDisputeGuideMinHeight = buttonHero + x7;
  static const EdgeInsets p2pDisputePillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const double p2pDisputeReadableLineHeight = 1.45;
  static const EdgeInsets p2pDisputeNoticeIconPadding = EdgeInsets.only(top: 3);
  static const double p2pDisputeNoticeBulletIcon = 12;
  static const double p2pDisputeMetaIcon = 11;
  static const double p2pDisputeStatusIconBox = 50;
  static const double p2pDisputeStatusIcon = 24;
  static const double p2pDisputeActionIconBox = 38;
  static const EdgeInsets p2pDisputeActionTilePadding = EdgeInsets.all(x3);
  static const double p2pDisputeEvidenceThumb = 80;
  static const EdgeInsets p2pDisputeEvidenceButtonPadding =
      EdgeInsets.symmetric(horizontal: x3);
  static const double p2pDisputeTimelineDot = 12;
  static const double p2pDisputeTimelineConnectorWidth = hairlineStroke;
  static const double p2pDisputeTimelineConnectorHeight = x6;
  static const EdgeInsets p2pDisputeTimelineItemPadding = EdgeInsets.only(
    bottom: x3,
  );
  static const EdgeInsets p2pDisputeChatHeaderPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets p2pDisputeChatBodyPadding = EdgeInsets.all(x4);
  static const EdgeInsets p2pDisputeChatInputPadding = EdgeInsets.fromLTRB(
    x4,
    x3,
    x4,
    x3,
  );
  static const double p2pDisputeSendButtonSize = 38;
  static const double p2pDisputeBubbleMaxWidth = 300;
  static const EdgeInsets p2pDisputeBubbleMargin = EdgeInsets.only(bottom: x3);
  static const EdgeInsets p2pDisputeBubblePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double p2pDisputeBubbleRadius = 16;
  static const double p2pDisputeBubbleTailRadius = 4;
  static const EdgeInsets p2pDisputeLevelConnectorPadding = EdgeInsets.only(
    top: 17,
  );
  static const double p2pDisputeLevelConnectorHeight = hairlineStroke;
  static const double p2pDisputeLevelNodeSize = 37;
  static const EdgeInsets p2pDisputeEscalatePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x3,
  );
  static const EdgeInsets p2pDisputeAppealButtonPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static EdgeInsets p2pDisputeResolutionScrollPadding(double bottomInset) =>
      p2pDisputeScrollPadding(bottomInset);
  static const EdgeInsets p2pDisputeResolutionCardPadding = EdgeInsets.all(x2);
  static const EdgeInsets p2pDisputeResolutionCompactCardPadding =
      EdgeInsets.all(x2);
  static EdgeInsets p2pDisputeDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets p2pDisputeEvidenceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static EdgeInsets marketScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketNativeBottomExtra = 18;
  static const double marketVisualBottomExtra = 40;
  static const double marketColumnHeaderHeight = 46;
  static const EdgeInsets marketColumnHeaderPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets marketPairRowPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: 14,
  );
  static const double marketPairGap = 12;
  static const double marketPairMicroGap = 4;
  static const double marketPairPriceGap = 5;
  static const double marketPairFavoriteGap = 8;
  static const double marketPairSparklineWidth = 70;
  static const double marketPairSparklineHeight = 32;
  static const double marketPairPriceColumnWidth = 74;
  static const double marketPairFavoriteWidth = 28;
  static const double marketPairFavoriteHeight = 32;
  static const double marketPairFavoriteRadius = 18;
  static const double marketPairFavoriteIcon = 18;
  static const double marketPairAvatar = 34;
  static const double marketPairAvatarBorder = 1.5;
  static const EdgeInsets marketPairChangePadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 5,
  );
  static const EdgeInsets marketListPairCompactHeaderPadding =
      EdgeInsets.symmetric(horizontal: contentPad - x3);
  static const EdgeInsets marketListPairCompactRowPadding =
      EdgeInsets.symmetric(horizontal: contentPad - x3, vertical: x4 - x1);
  static const EdgeInsets marketListPairChangePillPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x1);
  static const EdgeInsets marketListFilterCompactPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets marketListMoverCompactPadding = EdgeInsets.all(x3);
  static const EdgeInsets marketListToolCompactPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets vitChoicePillCompactPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets vitChoicePillComfortablePadding =
      EdgeInsets.symmetric(horizontal: x4);
  static const EdgeInsets marketFilterSheetPadding = EdgeInsets.all(12);
  static const double marketFilterGap = 8;
  static const double marketCategoryGap = 9;
  static const double marketCategoryHeight = 38;
  static const double marketTimeframeLabelGap = 10;
  static const double marketTimeframeSelectorHeight = 32;
  static const double marketCategoryDropdownHeight = 44;
  static const EdgeInsets marketCategoryDropdownPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const double marketFilterChipMinHeight = 34;
  static const double marketCategoryChipMinHeight = 36;
  static const EdgeInsets marketFilterChipPadding = EdgeInsets.symmetric(
    horizontal: 13,
    vertical: 8,
  );
  static const double marketToolsHeight = 36;
  static const double marketToolHeight = 34;
  static const double marketToolGap = 8;
  static const EdgeInsets marketToolPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double marketToolIcon = 14;
  static const double marketToolIconGap = 7;
  static const double marketMoverGap = 12;
  static const double marketMoverCardHeight = 130;
  static const EdgeInsets marketMoverCardPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    11,
  );
  static const double marketMoverIcon = 14;
  static const double marketMoverIconGap = 6;
  static const double marketMoverHeaderGap = 10;
  static const double marketMoverRowGap = 8;
  static const double marketMoverRowHeight = 65;
  static const EdgeInsets marketMoverRowPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const double marketMoverRankWidth = 20;
  static const double marketMoverAvatar = 35;
  static const double marketMoverSparklineWidth = 66;
  static const double marketMoverSparklineHeight = 30;
  static const double marketMoverPriceColumnWidth = 74;
  static const double marketMoverIdentityBadgeGap = 5;
  static const double marketMoverMetricGap = 7;
  static const EdgeInsets marketMoverRankBadgePadding = EdgeInsets.symmetric(
    horizontal: 5,
    vertical: 2,
  );
  static const EdgeInsets watchlistCardPadding = EdgeInsets.all(16);
  static const EdgeInsets watchlistPairTextPadding = EdgeInsets.symmetric(
    vertical: 3,
  );
  static const EdgeInsets watchlistToolbarPadding = EdgeInsets.fromLTRB(
    20,
    12,
    20,
    13,
  );
  static const EdgeInsets watchlistNotePadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets watchlistActionPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets watchlistEmptyPadding = EdgeInsets.only(top: 70);
  static const double watchlistTinyGap = 3;
  static const double watchlistPairTextGap = 4;
  static const double watchlistStatGap = 5;
  static const double watchlistSmallGap = 6;
  static const double watchlistCountGap = 7;
  static const double watchlistActionGap = 8;
  static const double watchlistSectionGap = 12;
  static const double watchlistSparklineHeight = 42;
  static const double watchlistAvatar = 44;
  static const double watchlistTrendIcon = 15;
  static const double watchlistRemoveButton = 38;
  static const double watchlistRemoveIcon = 18;
  static const double watchlistNoteHeight = 36;
  static const double watchlistNoteIcon = 16;
  static const double watchlistActionHeight = 38;
  static const double watchlistActionMinWidth = 102;
  static const double watchlistAddButton = 40;
  static const double watchlistAddIcon = 22;
  static const double watchlistCountIcon = 15;
  static const double marketDiscoverLabelGap = 8;
  static const double marketDiscoverAccentWidth = 4;
  static const double marketDiscoverAccentHeight = 17;
  static const double marketDiscoverLabelTextGap = 7;
  static const EdgeInsets marketDiscoverRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const double marketDiscoverIconBox = 40;
  static const double marketDiscoverIcon = 18;
  static const double marketDiscoverRowGap = 12;
  static const double marketDiscoverTitleBadgeGap = 7;
  static const EdgeInsets marketDiscoverBadgePadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );
  static const double marketDiscoverSubtitleGap = 5;
  static const double marketDiscoverChevron = 16;
  static const double marketAnalyticsTinyGap = 3;
  static const double marketAnalyticsMicroGap = 4;
  static const double marketAnalyticsSmallGap = 6;
  static const double marketAnalyticsCompactGap = 8;
  static const double marketAnalyticsMediumGap = 10;
  static const double marketAnalyticsGap = 12;
  static const double marketAnalyticsBreadthGap = 9;
  static const double marketAnalyticsFooterGap = 13;
  static const double marketAnalyticsLargeGap = 16;
  static const double marketAnalyticsHeroHeight = 170;
  static const double marketAnalyticsStatCardHeight = 96;
  static const double marketAnalyticsSentimentCardHeight = 183;
  static const double marketAnalyticsIconBubble = 24;
  static const double marketAnalyticsStatIcon = 14;
  static const double marketAnalyticsTrendIcon = 12;
  static const double marketAnalyticsBreadthDot = 8;
  static const double marketAnalyticsBreadthTrackHeight = 6;
  static const double marketAnalyticsGaugeWidth = 120;
  static const double marketAnalyticsGaugeHeight = 64;
  static const double marketOverviewQuickNavHeight = 90;
  static const double marketOverviewQuickNavIcon = 40;
  static const double marketOverviewQuickNavGlyph = 18;
  static const double marketOverviewMoverCardHeight = 272;
  static const double marketOverviewMoverHeaderIcon = 14;
  static const double marketOverviewMoverChevron = 15;
  static const double marketOverviewMoverAvatar = 25;
  static const double marketOverviewMoverPriceWidth = 34;
  static const double marketOverviewMoverChangeWidth = 58;
  static const double marketOverviewSectorRowHeight = 61;
  static const double marketOverviewSectorIcon = 36;
  static const double marketOverviewSectorGlyph = 18;
  static const double marketOverviewSectorChevron = 16;
  static const double marketOverviewHistoryHeight = 128;
  static const double marketOverviewHistoryBarMaxHeight = 64;
  static const double marketOverviewToolHeight = 60;
  static const double marketOverviewToolIcon = 22;
  static const double marketOverviewMiniHeaderIcon = 14;
  static const double marketOverviewMiniHeaderGap = 7;
  static const double marketAdvancedTabsHeight = 54;
  static const double marketAdvancedTabIndicatorHeight = hairlineStroke;
  static const double marketAdvancedActionMinHeight = 30;
  static const double marketAdvancedChipRemoveIcon = 12;
  static const double marketAdvancedSignalAccentWidth = 3;
  static const double marketAdvancedSignalAccentHeight = 14;
  static const int marketAdvancedGridColumns = 3;
  static const double marketAdvancedGridAspectRatio = .92;
  static const double marketAdvancedIndicatorAvatar = 32;
  static const double marketAdvancedToggleSize = 32;
  static const double marketAdvancedToggleIcon = 16;
  static const double marketAdvancedInfoIcon = 17;
  static const double marketAdvancedToolIcon = 25;
  static const double marketAdvancedTipIcon = 18;
  static const double marketAdvancedDisclaimerIcon = 14;
  static const double marketAdvancedSignalBarHeight = 8;
  static const double marketHeatmapSectionGap = 28;
  static const double marketHeatmapSummaryGap = 12;
  static const double marketHeatmapSummaryHeight = 62;
  static const double marketHeatmapControlsHeight = 42;
  static const double marketHeatmapFilterHeight = 34;
  static const double marketHeatmapLegendDot = 12;
  static const double marketHeatmapAvatar = 40;
  static const double marketHeatmapDetailButtonHeight = 36;
  static const double marketHeatmapTrendCardHeight = 156;
  static const double marketHeatmapTrendIcon = 15;
  static const double marketHeatmapTrendRowHeight = 32;
  static const double marketHeatmapTreemapHeight = 360;
  static const int marketHeatmapTreemapColumns = 5;
  static const double marketHeatmapTreemapCellHeight = 50;
  static const double marketHeatmapTreemapGap = 4;
  static const double marketDepthSectionGap = 16;
  static const double marketDepthTabsHeight = 54;
  static const double marketDepthTabIndicatorHeight = hairlineStroke;
  static const double marketDepthAvatar = 40;
  static const double marketDepthTrendIcon = 12;
  static const double marketDepthChartHeight = 200;
  static const double marketDepthPainterPadding = 8;
  static const double marketDepthPainterDash = 4;
  static const double marketDepthPainterDashGap = 8;
  static const double marketDepthStroke = borderWidth;
  static const double marketDepthDashedStroke = dividerHairline;
  static const double marketDepthLegendDot = 12;
  static const double marketDepthRatioBarHeight = 21;
  static const double marketDepthOrderRowHeight = 28;
  static const double marketDepthWhaleIconBox = 40;
  static const double marketSocialTabsHeight = 54;
  static const double marketSocialTabIndicatorHeight = hairlineStroke;
  static const double marketSocialSectionGap = 12;
  static const double marketSocialTinyGap = 2;
  static const double marketSocialSmallGap = 4;
  static const double marketSocialCompactGap = 6;
  static const double marketSocialGap = 8;
  static const double marketSocialMediumGap = 10;
  static const double marketSocialLargeGap = 14;
  static const double marketSocialFilterHeight = 36;
  static const double marketSocialCategoryHeight = 34;
  static const double marketSocialTinyBadgeHeight = 16;
  static const double marketSocialTinyBadgeHeightMd = 18;
  static const double marketSocialTinyBadgeHeightLg = 20;
  static const double marketSocialTargetHeight = 44;
  static const double marketSocialProviderRank = 28;
  static const double marketSocialDividerHeight = dividerHairline;
  static const double marketSocialStatusBarHeight = 12;
  static const double marketSocialLegendDot = 10;
  static const double marketSocialResultIcon = 16;
  static const double marketSocialSectionBarWidth = 3;
  static const double marketSocialSectionBarHeight = 16;
  static const double marketSocialEmptyHeight = 180;
  static const double marketSocialEmptyIcon = 32;
  static const double marketDerivativesNativeBottomExtra = contentPad;
  static const double marketDerivativesVisualBottomExtra = 54;
  static const double marketDerivativesPageGap = 10;
  static const double marketDerivativesHeroLabelGap = 10;
  static const double marketDerivativesHeroValueGap = 10;
  static const double marketDerivativesHeroDeltaBottom = 5;
  static const int marketDerivativesStatGridColumns = 2;
  static const double marketDerivativesStatGridGap = 8;
  static const double marketDerivativesStatGridAspectRatio = 2;
  static const double marketDerivativesStatIconBox = 24;
  static const double marketDerivativesStatIcon = 14;
  static const double marketDerivativesSplitBarHeight = 6;
  static const double marketDerivativesSplitBarCompactHeight = 4;
  static const double marketDerivativesSplitLabelGap = 6;
  static const double marketDerivativesMetricGap = 3;
  static const double marketDerivativesTimelineTimeWidth = 48;
  static const double marketDerivativesTimelineTimeGap = 8;
  static const double marketDerivativesTimelineItemGap = 8;
  static const double marketDerivativesTimelineDividerHeight = 18;
  static const double marketDerivativesTimelineBarHeight = 12;
  static const double marketDerivativesLegendDot = 10;
  static const double marketDerivativesLegendGap = 7;
  static const double marketDerivativesLegendItemGap = 18;
  static const double marketDerivativesPairAvatarSm = 30;
  static const double marketDerivativesPairAvatarMd = 34;
  static const double marketDerivativesPairGap = 12;
  static const double marketDerivativesOiRowGap = 2;
  static const double marketDerivativesSummaryLabelGap = 8;
  static const double marketDerivativesSummarySplitGap = 14;
  static const double marketDerivativesLiquidationRowGap = 7;
  static const double marketDerivativesRiskIcon = 18;
  static const double marketDerivativesRiskIconGap = 10;
  static const double marketDerivativesRiskTitleGap = 4;
  static const double marketDerivativesRiskLineHeight = 1.45;
  static const double marketDerivativesSortGap = 8;
  static const double marketDerivativesLeverageGap = 7;
  static const double marketDerivativesPerpetualMetaGap = 14;
  static const double marketDerivativesPerpetualSplitGap = 12;
  static const double marketDerivativesTabsHeight = 54;
  static const double marketDerivativesTabIndicatorHeight = hairlineStroke;
  static const EdgeInsets marketDerivativesHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDerivativesStatCardPadding = EdgeInsets.all(12);
  static const EdgeInsets marketDerivativesHeroDeltaPadding = EdgeInsets.only(
    bottom: marketDerivativesHeroDeltaBottom,
  );
  static const EdgeInsets marketDerivativesTimelinePadding = EdgeInsets.all(16);
  static const EdgeInsets marketDerivativesOiRowPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets marketDerivativesLiquidationSummaryPadding =
      EdgeInsets.all(16);
  static const EdgeInsets marketDerivativesPairCardPadding = EdgeInsets.all(12);
  static const EdgeInsets marketDerivativesRiskPadding = EdgeInsets.all(14);
  static const EdgeInsets marketDerivativesSortChipPadding =
      EdgeInsets.symmetric(horizontal: 13, vertical: 8);
  static EdgeInsets marketDerivativesScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double tokenUnlocksNativeBottomExtra = contentPad;
  static const double tokenUnlocksVisualBottomExtra = 54;
  static const double tokenUnlocksPageGap = 12;
  static const double tokenUnlocksTabsHeight = 54;
  static const double tokenUnlocksTabIndicatorHeight = hairlineStroke;
  static const double tokenUnlocksHeroLabelGap = 6;
  static const double tokenUnlocksHeroValueGap = 9;
  static const double tokenUnlocksHeroMetaGap = 18;
  static const double tokenUnlocksFilterGap = 2;
  static const double tokenUnlocksListGap = 4;
  static const double tokenUnlocksAvatarLg = 40;
  static const double tokenUnlocksAvatarMd = 36;
  static const double tokenUnlocksAvatarSm = 28;
  static const double tokenUnlocksCardGap = 12;
  static const double tokenUnlocksBadgeSpacing = 6;
  static const double tokenUnlocksBadgeRunSpacing = 4;
  static const double tokenUnlocksDateIcon = 12;
  static const double tokenUnlocksDateGap = 6;
  static const double tokenUnlocksValueGap = 4;
  static const double tokenUnlocksDetailMetricGap = 2;
  static const double tokenUnlocksExpandedMetricGap = 12;
  static const double tokenUnlocksPriceWarningGap = 12;
  static const double tokenUnlocksPriceWarningIcon = 14;
  static const double tokenUnlocksPriceWarningIconGap = 8;
  static const double tokenUnlocksImpactTitleGap = 12;
  static const double tokenUnlocksImpactStatGap = 8;
  static const double tokenUnlocksImpactStatValueGap = 4;
  static const double tokenUnlocksCategoryGap = 12;
  static const double tokenUnlocksCategoryDot = 10;
  static const double tokenUnlocksCategoryDotGap = 8;
  static const double tokenUnlocksCategoryProgressGap = 6;
  static const double tokenUnlocksCategoryProgressHeight = 5;
  static const double tokenUnlocksDilutionRankWidth = 14;
  static const double tokenUnlocksDilutionRankGap = 10;
  static const double tokenUnlocksDilutionRowGap = 2;
  static const double tokenUnlocksWarningIcon = 18;
  static const double tokenUnlocksWarningIconGap = 12;
  static const double tokenUnlocksWarningTitleGap = 3;
  static const double tokenUnlocksWarningLineHeight = 1.55;
  static const double tokenUnlocksScheduleGap = 8;
  static const double tokenUnlocksScheduleSupplyGap = 14;
  static const double tokenUnlocksScheduleProgressGap = 6;
  static const double tokenUnlocksScheduleTitleGap = 14;
  static const double tokenUnlocksVestingMarker = 24;
  static const double tokenUnlocksVestingLine = dividerHairline;
  static const double tokenUnlocksVestingIconOpen = 12;
  static const double tokenUnlocksVestingIconLocked = 9;
  static const double tokenUnlocksVestingContentGap = 12;
  static const double tokenUnlocksVestingBottomGap = 13;
  static const double tokenUnlocksTinyBadgeLineHeight = 1.2;
  static const double tokenUnlocksSectionBarWidth = 3;
  static const double tokenUnlocksSectionBarHeight = 14;
  static const double tokenUnlocksSectionHeaderGap = 8;
  static const double tokenUnlocksEmptyIcon = 34;
  static const double tokenUnlocksEmptyGap = 12;
  static const EdgeInsets tokenUnlocksHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksFilterPadding = EdgeInsets.symmetric(
    horizontal: 2,
    vertical: 6,
  );
  static const EdgeInsets tokenUnlocksCardHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 13,
  );
  static const EdgeInsets tokenUnlocksExpandedPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    14,
  );
  static const EdgeInsets tokenUnlocksPriceWarningPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets tokenUnlocksAnalysisCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksImpactStatPadding = EdgeInsets.symmetric(
    vertical: 12,
  );
  static const EdgeInsets tokenUnlocksDilutionRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets tokenUnlocksWarningPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksScheduleCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksVestingEventPadding = EdgeInsets.only(
    bottom: tokenUnlocksVestingBottomGap,
  );
  static const EdgeInsets tokenUnlocksTinyBadgePadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );
  static const EdgeInsets tokenUnlocksEmptyPadding = EdgeInsets.symmetric(
    vertical: 48,
  );
  static EdgeInsets tokenUnlocksScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double socialSentimentNativeBottomExtra = contentPad;
  static const double socialSentimentVisualBottomExtra = 54;
  static const double socialSentimentPageGap = 12;
  static const double socialSentimentTabsHeight = 54;
  static const double socialSentimentTabIndicatorHeight = hairlineStroke;
  static const double socialSentimentHeroHeaderGap = 16;
  static const double socialSentimentHeroScoreGap = 6;
  static const double socialSentimentHeroScoreBottom = 6;
  static const double socialSentimentHeroGaugeGap = 12;
  static const double socialSentimentHeroGaugeHeight = 8;
  static const double socialSentimentHeroLegendGap = 4;
  static const double socialSentimentStatGap = 8;
  static const double socialSentimentStatIcon = 12;
  static const double socialSentimentStatIconGap = 6;
  static const double socialSentimentStatValueGap = 8;
  static const double socialSentimentStatSubGap = 2;
  static const double socialSentimentDominanceTitleGap = 10;
  static const double socialSentimentDominanceBarHeight = 20;
  static const double socialSentimentDominanceLegendGap = 16;
  static const double socialSentimentLegendDot = 10;
  static const double socialSentimentLegendGap = 6;
  static const double socialSentimentTimelineRowGap = 3;
  static const double socialSentimentTimelineTimeWidth = 56;
  static const double socialSentimentTimelineTimeGap = 8;
  static const double socialSentimentTimelineScoreGap = 10;
  static const double socialSentimentTimelineScoreWidth = 24;
  static const double socialSentimentTimelineBarHeight = 6;
  static const double socialSentimentSectionGap = 6;
  static const double socialSentimentListGap = 4;
  static const double socialSentimentAvatarLg = 40;
  static const double socialSentimentAvatarMd = 36;
  static const double socialSentimentRowGap = 12;
  static const double socialSentimentStatusDot = 10;
  static const double socialSentimentStatusShadowBlur = 8;
  static const double socialSentimentSortGap = 8;
  static const double socialSentimentSplitBarHeight = 6;
  static const double socialSentimentTokenMetricGap = 10;
  static const double socialSentimentTopicGap = 8;
  static const int socialSentimentHeatmapCrossAxisCount = 4;
  static const double socialSentimentHeatmapGap = 6;
  static const double socialSentimentHeatmapAspectRatio = .95;
  static const double socialSentimentLeaderboardGap = 8;
  static const double socialSentimentLeaderboardRowGap = 4;
  static const double socialSentimentLeaderboardRankWidth = 16;
  static const double socialSentimentVelocitySymbolWidth = 44;
  static const double socialSentimentVelocityBarHeight = 5;
  static const double socialSentimentVelocityGap = 10;
  static const double socialSentimentVelocityValueWidth = 52;
  static const EdgeInsets socialSentimentHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets socialSentimentHeroScorePadding = EdgeInsets.only(
    bottom: socialSentimentHeroScoreBottom,
  );
  static const EdgeInsets socialSentimentStatPadding = EdgeInsets.all(12);
  static const EdgeInsets socialSentimentDominancePadding = EdgeInsets.all(14);
  static const EdgeInsets socialSentimentTimelinePadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const EdgeInsets socialSentimentTimelineRowPadding =
      EdgeInsets.symmetric(vertical: socialSentimentTimelineRowGap);
  static const EdgeInsets socialSentimentRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets socialSentimentSortChipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets socialSentimentTokenDetailPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets socialSentimentTopicCardPadding = EdgeInsets.all(16);
  static const EdgeInsets socialSentimentTopicChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets socialSentimentLeaderboardRowPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 8);
  static const EdgeInsets socialSentimentVelocityRowPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static EdgeInsets socialSentimentScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double tokenInfoNativeBottomExtra = contentPad;
  static const double tokenInfoVisualBottomExtra = 54;
  static const double tokenInfoPageGap = 14;
  static const double tokenInfoTabsHeight = 54;
  static const double tokenInfoTabIndicatorHeight = hairlineStroke;
  static const double tokenInfoTabIndicatorWidth = 116;
  static const double tokenInfoSectionGap = 14;
  static const double tokenInfoHeroAvatar = 44;
  static const double tokenInfoHeroAvatarGap = 12;
  static const double tokenInfoHeroSubtitleGap = 2;
  static const double tokenInfoHeroPriceGap = 16;
  static const double tokenInfoInfoIcon = 13;
  static const double tokenInfoInfoIconGap = 9;
  static const double tokenInfoSupplyProgressGap = 8;
  static const double tokenInfoSupplyProgressHeight = 6;
  static const double tokenInfoMetricGap = 12;
  static const double tokenInfoDonutSize = 80;
  static const double tokenInfoDonutStroke = 18;
  static const double tokenInfoDonutInset = 9;
  static const double tokenInfoDistributionGap = 18;
  static const double tokenInfoDistributionDot = 10;
  static const double tokenInfoDistributionDotGap = 8;
  static const double tokenInfoRecordCardGap = 12;
  static const double tokenInfoRecordIcon = 13;
  static const double tokenInfoRecordIconGap = 6;
  static const double tokenInfoRecordValueGap = 10;
  static const double tokenInfoRecordDeltaGap = 8;
  static const double tokenInfoChartIconBox = 42;
  static const double tokenInfoChartIconGap = 12;
  static const double tokenInfoChartSubtitleGap = 2;
  static const double tokenInfoOnchainIcon = 16;
  static const double tokenInfoOnchainIconGap = 8;
  static const double tokenInfoOnchainTitleGap = 14;
  static const double tokenInfoMiniStatGap = 10;
  static const double tokenInfoMiniStatValueGap = 4;
  static const double tokenInfoProjectTitleGap = 10;
  static const double tokenInfoProjectLinkGap = 8;
  static const double tokenInfoProjectLinkIcon = 18;
  static const double tokenInfoProjectLinkIconGap = 10;
  static const double tokenInfoProjectLinkOpenIcon = 15;
  static const double tokenInfoDisclaimerIcon = 14;
  static const double tokenInfoDisclaimerIconGap = 8;
  static const double tokenInfoDisclaimerLineHeight = 1.35;
  static const EdgeInsets tokenInfoTabPadding = EdgeInsets.symmetric(
    vertical: 14,
  );
  static const EdgeInsets tokenInfoHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoInfoCardPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets tokenInfoInfoRowPadding = EdgeInsets.symmetric(
    vertical: 11,
  );
  static const EdgeInsets tokenInfoSupplyCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoMetricLinePadding = EdgeInsets.symmetric(
    vertical: 5,
  );
  static const EdgeInsets tokenInfoRecordCardPadding = EdgeInsets.all(14);
  static const EdgeInsets tokenInfoChartCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoOnchainCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoMiniStatPadding = EdgeInsets.all(12);
  static const EdgeInsets tokenInfoProjectCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoProjectLinkPadding = EdgeInsets.all(12);
  static const EdgeInsets tokenInfoDisclaimerPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static EdgeInsets tokenInfoScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketCorrelationsNativeBottomExtra = contentPad;
  static const double marketCorrelationsVisualBottomExtra = 54;
  static const double marketCorrelationsPageGap = 14;
  static const double marketCorrelationsTabsHeight = 54;
  static const double marketCorrelationsTabIndicatorHeight = hairlineStroke;
  static const double marketCorrelationsChipGap = 8;
  static const double marketCorrelationsTimeframeChipHeight = 36;
  static const double marketCorrelationsSortChipHeight = 32;
  static const double marketCorrelationsMatrixGap = 12;
  static const double marketCorrelationsHeatmapLabelSize = 28;
  static const double marketCorrelationsLegendGap = 4;
  static const double marketCorrelationsLegendDot = 10;
  static const double marketCorrelationsInfoIcon = 14;
  static const double marketCorrelationsInfoIconGap = 12;
  static const double marketCorrelationsInfoTitleGap = 3;
  static const double marketCorrelationsBodyLineHeight = 1.55;
  static const double marketCorrelationsInsightGap = 10;
  static const double marketCorrelationsInsightValueGap = 6;
  static const double marketCorrelationsInsightSubGap = 2;
  static const double marketCorrelationsRecommendationIcon = 16;
  static const double marketCorrelationsRecommendationIconGap = 12;
  static const double marketCorrelationsRecommendationTitleGap = 5;
  static const double marketCorrelationsHeroLabelGap = 6;
  static const double marketCorrelationsHeroMetaGap = 8;
  static const double marketCorrelationsHeroPillGap = 12;
  static const double marketCorrelationsHeroProgressGap = 12;
  static const double marketCorrelationsHeroProgressHeight = 8;
  static const double marketCorrelationsHeroScaleGap = 5;
  static const double marketCorrelationsMetricGap = 10;
  static const double marketCorrelationsMetricValueGap = 5;
  static const double marketCorrelationsTimelineRowGap = 12;
  static const double marketCorrelationsScoreLabelWidth = 30;
  static const double marketCorrelationsScoreValueWidth = 30;
  static const double marketCorrelationsScoreBarHeight = 8;
  static const double marketCorrelationsScoreGap = 10;
  static const double marketCorrelationsDisclaimerIcon = 12;
  static const double marketCorrelationsDisclaimerIconGap = 8;
  static const double marketCorrelationsRankWidth = 18;
  static const double marketCorrelationsRankGap = 10;
  static const double marketCorrelationsAssetDot = 24;
  static const double marketCorrelationsAssetDotGap = 5;
  static const double marketCorrelationsPairGap = 12;
  static const EdgeInsets marketCorrelationsTimeframeChipPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const EdgeInsets marketCorrelationsSortChipPadding =
      EdgeInsets.symmetric(horizontal: 13);
  static const EdgeInsets marketCorrelationsMatrixPadding = EdgeInsets.all(12);
  static const EdgeInsets marketCorrelationsInfoPadding = EdgeInsets.all(16);
  static const EdgeInsets marketCorrelationsInsightPadding = EdgeInsets.all(14);
  static const EdgeInsets marketCorrelationsRecommendationPadding =
      EdgeInsets.all(16);
  static const EdgeInsets marketCorrelationsHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets marketCorrelationsHeroMetaPadding = EdgeInsets.only(
    bottom: marketCorrelationsHeroMetaGap,
  );
  static const EdgeInsets marketCorrelationsMetricPadding = EdgeInsets.all(14);
  static const EdgeInsets marketCorrelationsScoreCardPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets marketCorrelationsScoreRowPadding = EdgeInsets.only(
    bottom: marketCorrelationsTimelineRowGap,
  );
  static const EdgeInsets marketCorrelationsDisclaimerPadding = EdgeInsets.all(
    12,
  );
  static const EdgeInsets marketCorrelationsPairRowPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static EdgeInsets marketCorrelationsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double portfolioTrackerNativeBottomExtra = contentPad;
  static const double portfolioTrackerVisualBottomExtra = 54;
  static const double portfolioTrackerPageGap = 12;
  static const double portfolioTrackerTabsHeight = 54;
  static const double portfolioTrackerTabIndicatorHeight = hairlineStroke;
  static const double portfolioTrackerHeroTitleGap = 6;
  static const double portfolioTrackerHeroPnlGap = 4;
  static const double portfolioTrackerHeroTogglePadding = 4;
  static const double portfolioTrackerHeroToggleIcon = 16;
  static const double portfolioTrackerHeroPnlIcon = 15;
  static const double portfolioTrackerHeroPnlIconGap = 8;
  static const double portfolioTrackerQuickStatGap = 8;
  static const double portfolioTrackerMiniStatValueGap = 5;
  static const double portfolioTrackerAllocationTitleGap = 14;
  static const double portfolioTrackerDonutSize = 120;
  static const double portfolioTrackerDonutGap = 28;
  static const double portfolioTrackerLegendGap = 8;
  static const double portfolioTrackerLegendDot = 10;
  static const double portfolioTrackerSectionGap = 4;
  static const double portfolioTrackerSectionHeaderGap = 6;
  static const double portfolioTrackerHoldingAvatarSm = 28;
  static const double portfolioTrackerHoldingAvatarMd = 32;
  static const double portfolioTrackerHoldingAvatarLg = 36;
  static const double portfolioTrackerHoldingRowGap = 12;
  static const double portfolioTrackerHoldingSparklineWidth = 54;
  static const double portfolioTrackerHoldingSparklineHeight = 22;
  static const double portfolioTrackerHoldingSparklineGap = 8;
  static const double portfolioTrackerHoldingValueWidth = 86;
  static const double portfolioTrackerRiskTitleGap = 12;
  static const double portfolioTrackerRiskProgressLabelGap = 5;
  static const double portfolioTrackerRiskProgressHeight = 5;
  static const double portfolioTrackerRiskCopyGap = 8;
  static const double portfolioTrackerRiskLineHeight = 1.45;
  static const double portfolioTrackerChipGap = 8;
  static const double portfolioTrackerHoldingDetailGap = 14;
  static const double portfolioTrackerHoldingMetricGap = 2;
  static const double portfolioTrackerChartTitleGap = 12;
  static const double portfolioTrackerChartHeight = 160;
  static const double portfolioTrackerPnlRowGap = 4;
  static const double portfolioTrackerPnlAvatarGap = 12;
  static const double portfolioTrackerPnlProgressGap = 6;
  static const double portfolioTrackerPnlProgressHeight = 4;
  static const double portfolioTrackerSummaryGap = 8;
  static const double portfolioTrackerSummaryValueGap = 4;
  static const double portfolioTrackerAllocationDonutInset = 8;
  static const double portfolioTrackerAllocationDonutStroke = 16;
  static const double portfolioTrackerPerformanceTopPadding = 8;
  static const double portfolioTrackerPerformanceBottomPadding = 24;
  static const double portfolioTrackerPerformanceLineStroke = 2;
  static const double portfolioTrackerPerformanceLastPoint = 4;
  static const double portfolioTrackerPerformanceInnerPoint = 2;
  static const double portfolioTrackerPerformanceDateBottom = 16;
  static const double portfolioTrackerSparklineStroke = 1.4;
  static const EdgeInsets portfolioTrackerHeroPadding = EdgeInsets.all(14);
  static const EdgeInsets portfolioTrackerHeroTogglePaddingInsets =
      EdgeInsets.all(portfolioTrackerHeroTogglePadding);
  static const EdgeInsets portfolioTrackerMiniStatPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 10);
  static const EdgeInsets portfolioTrackerAllocationPadding =
      EdgeInsets.fromLTRB(16, 16, 16, 18);
  static const EdgeInsets portfolioTrackerHoldingRowPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets portfolioTrackerRiskPadding = EdgeInsets.all(16);
  static const EdgeInsets portfolioTrackerChipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets portfolioTrackerHoldingDetailPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets portfolioTrackerChartCardPadding = EdgeInsets.all(16);
  static const EdgeInsets portfolioTrackerPnlRowPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets portfolioTrackerSummaryPadding = EdgeInsets.all(12);
  static EdgeInsets portfolioTrackerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketScreenerNativeBottomExtra = contentPad;
  static const double marketScreenerVisualBottomExtra = 54;
  static const double marketScreenerPageGap = 16;
  static const double marketScreenerPresetHeight = 36;
  static const double marketScreenerPresetGap = 8;
  static const double marketScreenerPresetIcon = 14;
  static const double marketScreenerPresetIconGap = 8;
  static const double marketScreenerPresetLineHeight = 1.0;
  static const double marketScreenerAdvancedTitleGap = 12;
  static const double marketScreenerAdvancedCategoryGap = 8;
  static const double marketScreenerAdvancedRangeGap = 12;
  static const double marketScreenerAdvancedRangeRowGap = 10;
  static const double marketScreenerResetIcon = 14;
  static const double marketScreenerResetHeight = 32;
  static const double marketScreenerCategoryChipHeight = 34;
  static const double marketScreenerCategoryChipLineHeight = 1.0;
  static const double marketScreenerInputVerticalPadding = 10;
  static const double marketScreenerSortHeight = 38;
  static const double marketScreenerSortChipHeight = 36;
  static const double marketScreenerSortGap = 4;
  static const double marketScreenerSortResultGap = 6;
  static const double marketScreenerSortResultWidth = 62;
  static const double marketScreenerSortIconGap = 2;
  static const double marketScreenerSortIcon = 15;
  static const double marketScreenerRowGap = 4;
  static const double marketScreenerRowHeight = 62;
  static const double marketScreenerRowRankWidth = 22;
  static const double marketScreenerRowAvatar = 32;
  static const double marketScreenerRowGapMain = 10;
  static const double marketScreenerSparklineWidth = 58;
  static const double marketScreenerSparklineHeight = 24;
  static const double marketScreenerSparklineGap = 16;
  static const double marketScreenerValueWidth = 82;
  static const double marketScreenerTextGap = 5;
  static const double marketScreenerTrendIcon = 12;
  static const double marketScreenerTrendGap = 3;
  static const double marketScreenerRowTitleLineHeight = 1.1;
  static const double marketScreenerRowMetaLineHeight = 1.3;
  static const double marketScreenerTrendLineHeight = 1.2;
  static const double marketScreenerEmptyIcon = 36;
  static const double marketScreenerEmptyGap = 12;
  static const double marketScreenerSparklineStroke = 1.7;
  static const EdgeInsets marketScreenerAdvancedPadding = EdgeInsets.all(16);
  static const EdgeInsets marketScreenerResetPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const EdgeInsets marketScreenerPresetPadding = EdgeInsets.symmetric(
    horizontal: 11,
  );
  static const EdgeInsets marketScreenerCategoryChipPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets marketScreenerInputPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: marketScreenerInputVerticalPadding,
  );
  static const EdgeInsets marketScreenerSortChipPadding = EdgeInsets.symmetric(
    horizontal: 6,
  );
  static const EdgeInsets marketScreenerRowPadding = EdgeInsets.fromLTRB(
    14,
    9,
    14,
    9,
  );
  static const EdgeInsets marketScreenerEmptyPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 42,
  );
  static EdgeInsets marketScreenerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketNewsNativeBottomExtra = contentPad;
  static const double marketNewsVisualBottomExtra = 54;
  static const double marketNewsPageGap = 14;
  static const double marketNewsBreakingTimeGap = 10;
  static const double marketNewsBreakingTitleGap = 10;
  static const double marketNewsBreakingTitleLineHeight = 1.38;
  static const double marketNewsBreakingDot = 8;
  static const double marketNewsBreakingDotGap = 6;
  static const double marketNewsBreakingTokenGap = 8;
  static const double marketNewsFilterGap = 8;
  static const double marketNewsSentimentIcon = 12;
  static const double marketNewsSentimentIconGap = 5;
  static const double marketNewsFeedGap = 6;
  static const double marketNewsCardIcon = 40;
  static const double marketNewsCardIconGlyph = 21;
  static const double marketNewsCardIconGap = 12;
  static const double marketNewsCardTagGap = 5;
  static const double marketNewsCardTitleGap = 6;
  static const double marketNewsCardTitleLineHeight = 1.35;
  static const double marketNewsSaveGap = 8;
  static const double marketNewsSavePadding = 4;
  static const double marketNewsSaveIcon = 18;
  static const double marketNewsTagSpacing = 6;
  static const double marketNewsTagRunSpacing = 4;
  static const double marketNewsTagIcon = 8;
  static const double marketNewsTagIconGap = 2;
  static const double marketNewsMetaIcon = 10;
  static const double marketNewsMetaIconGap = 4;
  static const double marketNewsMetaSeparatorGap = 7;
  static const double marketNewsExpandedSummaryLineHeight = 1.55;
  static const double marketNewsExpandedGap = 12;
  static const double marketNewsExpandedTokenGap = 8;
  static const double marketNewsExpandedTokenIconGap = 4;
  static const double marketNewsExpandedTokenIcon = 14;
  static const double marketNewsEmptyVerticalPadding = 48;
  static const double marketNewsEmptyIcon = 40;
  static const double marketNewsEmptyGap = 12;
  static const EdgeInsets marketNewsBreakingPadding = EdgeInsets.all(16);
  static const EdgeInsets marketNewsBreakingBadgePadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 3,
  );
  static const EdgeInsets marketNewsBreakingTokenPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 3,
  );
  static const EdgeInsets marketNewsCategoryChipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets marketNewsSentimentChipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 7,
  );
  static const EdgeInsets marketNewsCardPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 13,
  );
  static const EdgeInsets marketNewsSavePaddingInsets = EdgeInsets.all(
    marketNewsSavePadding,
  );
  static const EdgeInsets marketNewsTagPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );
  static const EdgeInsets marketNewsMetaSeparatorPadding = EdgeInsets.symmetric(
    horizontal: marketNewsMetaSeparatorGap,
  );
  static const EdgeInsets marketNewsExpandedPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    14,
  );
  static const EdgeInsets marketNewsExpandedTokenPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const EdgeInsets marketNewsEmptyPadding = EdgeInsets.symmetric(
    vertical: marketNewsEmptyVerticalPadding,
  );
  static const EdgeInsets marketNewsEmptyCtaPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );
  static EdgeInsets marketNewsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketCalendarNativeBottomExtra = contentPad;
  static const double marketCalendarVisualBottomExtra = 54;
  static const double marketCalendarPageGap = 16;
  static EdgeInsets marketCalendarScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketCalendarGroupGap = 8;
  static const double marketCalendarDateHeaderGap = 8;
  static const double marketCalendarEventIcon = 36;
  static const double marketCalendarEventIconGlyph = 18;
  static const double marketCalendarEventIconGap = 12;
  static const double marketCalendarBadgeSpacing = 6;
  static const double marketCalendarBadgeRunSpacing = 4;
  static const double marketCalendarEventTitleGap = 6;
  static const double marketCalendarEventMetaGap = 8;
  static const double marketCalendarEventTimeIcon = 13;
  static const double marketCalendarEventTimeGap = 5;
  static const double marketCalendarEventImpactGap = 6;
  static const double marketCalendarEventCountdownGap = 8;
  static const double marketCalendarEventSourceGap = 8;
  static const double marketCalendarEventTitleLineHeight = 1.25;
  static const double marketCalendarEventDescriptionLineHeight = 1.5;
  static const double marketCalendarViewTabHeight = 54;
  static const double marketCalendarViewUnderlineHeight = hairlineStroke;
  static const double marketCalendarStatsGap = 8;
  static const double marketCalendarMiniStatHeight = 73;
  static const double marketCalendarMiniStatValueGap = 8;
  static const double marketCalendarFilterGap = 8;
  static const double marketCalendarFilterChipHeight = 36;
  static const double marketCalendarImpactDot = 6;
  static const double marketCalendarMonthTitleGap = 16;
  static const double marketCalendarGridSpacing = hairlineStroke * 2;
  static const double marketCalendarGridAspect = 1.0;
  static const int marketCalendarGridColumns = 7;
  static const double marketCalendarMonthDividerTopGap = 14;
  static const double marketCalendarMonthLegendTopGap = 12;
  static const double marketCalendarEventDot = hairlineStroke * 2;
  static const double marketCalendarEventDotGap = hairlineStroke;
  static const double marketCalendarLegendSpacing = 12;
  static const double marketCalendarLegendRunSpacing = 8;
  static const double marketCalendarLegendDot = 8;
  static const double marketCalendarLegendGap = 5;
  static const double marketCalendarDayBorderWidth = 1.5;
  static const EdgeInsets marketCalendarEventCardPadding = EdgeInsets.all(14);
  static const EdgeInsets marketCalendarEventExpandedPadding =
      EdgeInsets.fromLTRB(14, 12, 14, 14);
  static const EdgeInsets marketCalendarMiniStatPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 10,
  );
  static const EdgeInsets marketCalendarFilterChipPadding =
      EdgeInsets.symmetric(horizontal: 13, vertical: 8);
  static const EdgeInsets marketCalendarImpactChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const EdgeInsets marketCalendarMonthPadding = EdgeInsets.all(x4);
  static const double marketSectorsNativeBottomExtra = contentPad + x1;
  static const double marketSectorsVisualBottomExtra = 52;
  static EdgeInsets marketSectorsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketSectorCardIcon = 42;
  static const double marketSectorCardIconGlyph = 21;
  static const double marketSectorDetailIcon = 46;
  static const double marketSectorDetailIconGlyph = 24;
  static const double marketSectorDistributionIcon = 26;
  static const double marketSectorDistributionIconGlyph = 16;
  static const double marketSectorTopCoinAvatar = 32;
  static const double marketSectorTopCoinRowHeight = 52;
  static const double marketSectorDistributionHeight = 132;
  static const double marketSectorDistributionBarHeight = 12;
  static const double marketSectorDominanceHeight = 6;
  static const double marketSectorLegendDot = 8;
  static const double marketSectorControlHeight = 32;
  static const double marketSectorControlChipGap = 8;
  static const double marketSectorControlGroupGap = 10;
  static const double marketSectorControlChipPadX = 10;
  static const double marketSectorComparisonCellWidth = 54;
  static const double marketSectorComparisonRowHeight = 34;
  static const double marketSectorComparisonMarker = 8;
  static const double marketSectorCardHeaderGap = 12;
  static const double marketSectorTitleGap = 4;
  static const double marketSectorCardSectionGap = 16;
  static const double marketSectorMetricGap = 14;
  static const double marketSectorMetricInlineGap = 6;
  static const double marketSectorDominanceLabelGap = 6;
  static const double marketSectorChipGap = 8;
  static const double marketSectorDistributionHeaderGap = 10;
  static const double marketSectorDistributionBarGap = 14;
  static const double marketSectorLegendGap = 5;
  static const double marketSectorComparisonHeaderGap = 10;
  static const double marketSectorComparisonMarkerGap = 8;
  static const double marketSectorTopCoinPriceGap = 10;
  static const double marketSectorLineHeightTight = 1.0;
  static const double marketSectorLineHeightCompact = 1.1;
  static const double marketSectorLineHeightTitle = 1.2;
  static const EdgeInsets marketSectorCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketSectorTopCoinsPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSectorDetailMetricPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSectorComparisonPadding = EdgeInsets.all(14);
  static const EdgeInsets marketSectorComparisonRowPadding =
      EdgeInsets.symmetric(horizontal: hairlineStroke);
  static const EdgeInsets marketSectorRefreshFooterPadding = EdgeInsets.only(
    top: hairlineStroke,
  );
  static const EdgeInsets marketSectorControlChipPadding = EdgeInsets.symmetric(
    horizontal: marketSectorControlChipPadX,
  );
  static const double priceAlertsNativeBottomExtra = contentPad;
  static const double priceAlertsVisualBottomExtra = 48;
  static const double priceAlertsSectionGap = 13;
  static const double priceAlertsCardGap = 12;
  static const double priceAlertsAddNoticeGap = 10;
  static const double priceAlertsBottomReviewGap = 16;
  static const double priceAlertsFilterGap = 8;
  static const double priceAlertsFilterHeight = 36;
  static const double priceAlertsStatGap = 12;
  static const double priceAlertsStatHeight = 72;
  static const double priceAlertsStatLabelGap = 9;
  static const double priceAlertsAvatar = 36;
  static const double priceAlertsHeaderGap = 10;
  static const double priceAlertsTrendIcon = 14;
  static const double priceAlertsTrendGap = 4;
  static const double priceAlertsToggleIcon = 34;
  static const double priceAlertsActionGap = 8;
  static const double priceAlertsDeleteIcon = 16;
  static const double priceAlertsProgressGap = 9;
  static const double priceAlertsProgressHeight = 7;
  static const double priceAlertsTargetGap = 17;
  static const double priceAlertsTargetWidth = 60;
  static const double priceAlertsTriggeredGap = 13;
  static const double priceAlertsTriggeredDividerGap = 11;
  static const double priceAlertsTriggeredIcon = 15;
  static const double priceAlertsTriggeredIconGap = 7;
  static const double priceAlertsEmptyIcon = 34;
  static const double priceAlertsEmptyGap = 10;
  static const double priceAlertsAddIcon = 18;
  static const double priceAlertsAddGap = 8;
  static const double comparisonToolNativeBottomExtra = contentPad;
  static const double comparisonToolVisualBottomExtra = 54;
  static const double comparisonToolPageGap = 18;
  static const double comparisonToolStripHeight = 52;
  static const double comparisonToolStripGap = 10;
  static const double comparisonToolAddWidth = 82;
  static const double comparisonToolAddIcon = 16;
  static const double comparisonToolAddGap = 6;
  static const double comparisonToolTokenAvatar = 28;
  static const double comparisonToolTokenTextGap = 9;
  static const double comparisonToolTokenMetricGap = 5;
  static const double comparisonToolRemoveGap = 8;
  static const double comparisonToolRemoveIcon = 14;
  static const double comparisonToolSparklineHeight = 48;
  static const double comparisonToolSparklineGap = 14;
  static const double comparisonToolSparklinePairGap = 18;
  static const double comparisonToolMetricSectionGap = 10;
  static const double comparisonToolMetricCardGap = 4;
  static const double comparisonToolMetricMinHeight = 66;
  static const double comparisonToolMetricValueGap = 12;
  static const double comparisonToolBestGap = 9;
  static const double comparisonToolDistributionHeight = 24;
  static const double comparisonToolDistributionGap = 12;
  static const double comparisonToolDistributionLegendGap = 14;
  static const double comparisonToolDistributionLegendRunGap = 8;
  static const double comparisonToolLegendDot = 10;
  static const double comparisonToolLegendGap = 6;
  static const double comparisonToolMarketCapRowGap = 5;
  static const double comparisonToolMarketCapBarHeight = 6;
  static const double comparisonToolNeedIcon = 42;
  static const double comparisonToolNeedGap = 12;
  static const double comparisonToolPickerSearchHeight = 40;
  static const double comparisonToolPickerIcon = 15;
  static const double comparisonToolPickerGap = 12;
  static const double comparisonToolPickerSearchIconGap = 8;
  static const double comparisonToolPickerQuickHeight = 34;
  static const double comparisonToolPickerQuickGap = 8;
  static const double comparisonToolPickerListGap = 10;
  static const double comparisonToolPickerListMaxHeight = 190;
  static const double comparisonToolPickerRowHeight = 40;
  static const double comparisonToolPickerRowAvatar = 26;
  static const double comparisonToolPickerRowGap = 10;
  static const EdgeInsets comparisonToolSparklineCardPadding =
      EdgeInsets.fromLTRB(16, 16, 16, 14);
  static const EdgeInsets comparisonToolTokenPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets comparisonToolMetricCardPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    12,
  );
  static const EdgeInsets comparisonToolDistributionPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets comparisonToolNeedPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: 48,
  );
  static const EdgeInsets comparisonToolPickerPadding = EdgeInsets.all(16);
  static const EdgeInsets comparisonToolPickerSearchPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets comparisonToolPickerQuickPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets comparisonToolPickerRowPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static EdgeInsets comparisonToolScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets priceAlertsNoticePadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets priceAlertsFilterHeaderPadding = EdgeInsets.fromLTRB(
    contentPad,
    13,
    contentPad,
    13,
  );
  static const EdgeInsets priceAlertsFilterTabPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const EdgeInsets priceAlertsCardPadding = EdgeInsets.fromLTRB(
    16,
    13,
    16,
    13,
  );
  static const EdgeInsets priceAlertsEmptyPadding = EdgeInsets.symmetric(
    vertical: 48,
    horizontal: 18,
  );
  static EdgeInsets priceAlertsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets marketAnalyticsHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets marketAnalyticsStatPadding = EdgeInsets.all(12);
  static const EdgeInsets marketHeatmapSummaryPadding = EdgeInsets.all(13);
  static const EdgeInsets marketHeatmapControlsPadding = EdgeInsets.all(4);
  static const EdgeInsets marketHeatmapFilterPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets marketHeatmapLegendPadding = EdgeInsets.only(
    top: 4,
    bottom: 2,
  );
  static const EdgeInsets marketHeatmapSelectedCardPadding = EdgeInsets.all(15);
  static const EdgeInsets marketHeatmapDetailButtonPadding =
      EdgeInsets.symmetric(horizontal: 13);
  static const EdgeInsets marketHeatmapTrendCardPadding = EdgeInsets.all(13);
  static const EdgeInsets marketHeatmapTilePaddingLarge = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 5,
  );
  static const EdgeInsets marketHeatmapTilePaddingSmall = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 5,
  );
  static const EdgeInsets marketDepthPairSummaryPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDepthHeaderPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const EdgeInsets marketDepthOrderRowPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets marketDepthMidPricePadding = EdgeInsets.symmetric(
    vertical: 10,
  );
  static const EdgeInsets marketDepthMiniStatPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 13,
  );
  static const EdgeInsets marketDepthChartPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    12,
  );
  static const EdgeInsets marketDepthLevelChipPadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 6,
  );
  static const EdgeInsets marketDepthRatioPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDepthWhaleCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDepthWhaleSummaryPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSocialDisclaimerPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSocialDisclaimerIconPadding = EdgeInsets.only(
    top: 2,
  );
  static const EdgeInsets marketSocialFilterPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const EdgeInsets marketSocialTinyBadgePadding = EdgeInsets.symmetric(
    horizontal: 5,
  );
  static const EdgeInsets marketSocialTinyBadgePaddingWide =
      EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets marketSocialSignalCardPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    14,
  );
  static const EdgeInsets marketSocialExpandedPadding = EdgeInsets.fromLTRB(
    16,
    10,
    16,
    14,
  );
  static const EdgeInsets marketSocialTargetSpacing = EdgeInsets.only(right: 8);
  static const EdgeInsets marketSocialCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketSocialResultPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets marketOverviewHistoryPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    14,
  );
  static const EdgeInsets marketOverviewToolPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
  static const EdgeInsets marketBodyReviewCardPadding = EdgeInsets.all(12);
  static const EdgeInsets marketMetricDeltaPillPadding = EdgeInsets.only(
    bottom: dividerHairline,
  );
  static const EdgeInsets marketAdvancedClearButtonPadding =
      EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets marketAdvancedActiveChipPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const EdgeInsets marketAdvancedFilterChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 7);
  static const EdgeInsets marketAdvancedIndicatorHeaderPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets marketAdvancedCategoryBadgePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  static const EdgeInsets marketAdvancedDetailsPadding = EdgeInsets.fromLTRB(
    16,
    10,
    16,
    14,
  );
  static const EdgeInsets marketAdvancedParamPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const EdgeInsets marketAdvancedSignalMetricPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 9);
  static const EdgeInsets marketAdvancedPivotPadding = EdgeInsets.symmetric(
    vertical: 6,
  );
  static const EdgeInsets marketAdvancedCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketAdvancedCardPaddingCompact = EdgeInsets.all(12);
  static const EdgeInsets marketOverviewMoverCardPadding = EdgeInsets.fromLTRB(
    12,
    12,
    8,
    11,
  );
  static const EdgeInsets marketOverviewMoverHeaderPadding = EdgeInsets.only(
    right: 2,
  );
  static const EdgeInsets marketOverviewSectorListPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets marketOverviewSectorActionPadding =
      EdgeInsets.symmetric(vertical: 13);
  static const EdgeInsets marketAnalyticsMetricPadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 10,
  );
  static const double marketLineHeightTight = tradeBotLineHeightTight;
  static const double marketLineHeightShort = tradeBotLineHeightShort;
  static const double marketLineHeightCaption = tradeBotLineHeightCaption;
  static const double marketLineHeightReadable = tradeBotLineHeightReadable;
  static EdgeInsets pairDetailScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double pairDetailNativeBottomExtra = contentPad;
  static const double pairDetailVisualBottomExtra = 54;
  static const double pairHeaderLeadingWidth = 40;
  static const EdgeInsets pairHeaderSymbolPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 8,
  );
  static const double pairHeaderLogo = 28;
  static const double pairHeaderSymbolGap = 9;
  static const double pairHeaderChevronGap = 5;
  static const double pairHeaderChevron = 17;
  static const double pairHeaderTrailingWidth = 88;
  static const double pairHeaderTrailingGap = 8;
  static const EdgeInsets pairPriceOverviewPadding = EdgeInsets.fromLTRB(
    contentPad,
    16,
    contentPad,
    14,
  );
  static const double pairPriceChangeGap = 12;
  static const EdgeInsets pairPriceChangePadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 6,
  );
  static const double pairPriceStatsGap = 15;
  static const double pairPriceStatGap = 2;
  static const EdgeInsets pairViewTabsPadding = EdgeInsets.fromLTRB(
    contentPad,
    10,
    contentPad,
    8,
  );
  static const double pairViewTabGap = 8;
  static const double pairViewTabHeight = 38;
  static const EdgeInsets pairViewTabPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const double pairViewTabIcon = 15;
  static const double pairViewTabIconGap = 6;
  static const EdgeInsets pairTimeframePadding = EdgeInsets.fromLTRB(
    24,
    0,
    contentPad,
    5,
  );
  static const double pairTimeframeHeight = 36;
  static const double pairIndicatorHeight = 42;
  static const EdgeInsets pairIndicatorListPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const double pairIndicatorGap = 8;
  static const double pairIndicatorChipHeight = 36;
  static const EdgeInsets pairIndicatorChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const double pairChartHeight = 230;
  static const EdgeInsets pairRiskMargin = EdgeInsets.fromLTRB(
    contentPad,
    10,
    contentPad,
    x4,
  );
  static const EdgeInsets pairRiskPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const double pairRiskIcon = 14;
  static const double pairRiskGap = 9;
  static const EdgeInsets pairLinkMargin = EdgeInsets.fromLTRB(
    contentPad,
    0,
    contentPad,
    x4,
  );
  static const EdgeInsets pairLinkPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );
  static const double pairLinkIconBox = 40;
  static const double pairLinkIcon = 19;
  static const double pairLinkGap = x4;
  static const double pairLinkSubtitleGap = hairlineStroke;
  static const double pairLinkChevron = 20;
  static const EdgeInsets pairTradeCtaPadding = EdgeInsets.fromLTRB(
    contentPad,
    0,
    contentPad,
    16,
  );
  static const double pairTradeCtaGap = 12;
  static const double pairTradeButtonHeight = 55;
  static const EdgeInsets pairOrderPanelPadding = EdgeInsets.fromLTRB(
    contentPad,
    4,
    contentPad,
    8,
  );
  static const EdgeInsets pairOrderCardPadding = EdgeInsets.all(14);
  static const double pairOrderSectionGap = 12;
  static const double pairOrderDividerHeight = contentPad;
  static const EdgeInsets pairDepthRowPadding = EdgeInsets.symmetric(
    vertical: 4,
  );
  static const EdgeInsets pairTradeHeaderPadding = EdgeInsets.only(bottom: 8);
  static const EdgeInsets pairTradeRowPadding = EdgeInsets.symmetric(
    vertical: 5,
  );
  static const double profileBottomInsetVisual = 92;
  static const double profileBottomInsetNative = 28;
  static EdgeInsets profileScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const double profileHeroToVipGap = 24;
  static const double profileVipToSectionGap = 26;
  static const double profileSectionLabelGap = 11;
  static const double profilePredictionToArenaGap = 14;
  static const double profileSectionGap = 25;
  static const double profileActivityGap = 28;
  static const double profileFooterGap = 38;
  static const double profileHeroHeight = 216;
  static const EdgeInsets profileHeroPadding = EdgeInsets.all(16);
  static const double profileHeroAvatar = 58;
  static const double profileHeroTextGap = x3;
  static const double profileHeroEmailGap = 12;
  static const double profileHeroPillGap = x3;
  static const double profileHeroPillRunGap = 6;
  static const double profileEditButton = 40;
  static const double profileEditIcon = iconMd;
  static const double profileHeroInfoGap = 12;
  static const EdgeInsets profileHeroPillPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const double profileHeroInfoHeight = 66;
  static const EdgeInsets profileHeroInfoPadding = EdgeInsets.fromLTRB(
    14,
    13,
    14,
    12,
  );
  static const double profileHeroInfoTrailingGap = 6;
  static const double profileProductGridGap = 10;
  static const double profileProductTileHeight = 74;
  static const EdgeInsets profileProductTilePadding = EdgeInsets.all(12);
  static const double profileProductIconBox = 34;
  static const double profileProductIcon = 19;
  static const double profileProductGap = 10;
  static const double profileProductLabelGap = 7;
  static const double profileMenuRowHeight = 62;
  static const EdgeInsets profileMenuRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double profileMenuIconBox = 36;
  static const double profileMenuIcon = 20;
  static const double profileMenuGap = 14;
  static const double profileMenuSubtitleGap = x3;
  static const double profileMenuChevron = 20;
  static const double profileActivityButtonHeight = 44;
  static const double profileLogoutButtonHeight = 54;
  static const double profileLogoutIcon = iconMd;
  static const double profileLogoutGap = 10;
  static const double profileSectionAccentWidth = 4;
  static const double profileSectionAccentHeight = 15;
  static const double profileSectionAccentGap = 7;
  static const double profileModuleCardHeight = 137;
  static const double profileVipCardHeight = 92;
  static const EdgeInsets profileModuleCardPadding = EdgeInsets.all(16);
  static const double profileModuleIcon = 15;
  static const double profileModuleGap = x3;
  static const double profileModuleStatGap = 12;
  static const double profileModuleLinkIcon = 14;
  static const double profileModuleEndGap = 20;
  static const EdgeInsets profileTinyTagPadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 5,
  );
  static const double profileVipProgressGap = 12;
  static const double profileVipProgressHeight = x3;
  static const double profileEditBottomInsetVisual = 42;
  static const double profileEditBottomInsetNative = 24;
  static const double profileEditScrollTop = 36;
  static EdgeInsets profileEditScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        contentPad,
        profileEditScrollTop,
        contentPad,
        bottomInset,
      );
  static const double profileEditAvatarFormGap = 52;
  static const double profileEditFieldGap = 18;
  static const double profileEditRiskGap = 14;
  static const double profileEditAvatarSize = 96;
  static const double profileEditCameraOffsetEnd = -1;
  static const double profileEditCameraOffsetBottom = 1;
  static const double profileEditAvatarCaptionGap = 10;
  static const double profileEditFieldLabelGap = 10;
  static const double profileEditFieldNoteGap = 7;
  static const double profileEditAvatarCaptionLineHeight = 1.1;
  static const double profileEditTightLineHeight = 1;
  static const double settingsBottomInsetVisual = 124;
  static const double settingsBottomInsetNative = 32;
  static EdgeInsets settingsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 14, contentPad, bottomInset);
  static const double settingsSectionTitleGap = 8;
  static const double settingsCurrencyToLanguageGap = 27;
  static const double settingsSectionGap = 28;
  static const double settingsNotificationsToInfoGap = 26;
  static const double settingsCurrencyCardHeight = 92;
  static const EdgeInsets settingsCurrencyCardPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    15,
  );
  static const double settingsCurrencyIcon = 21;
  static const double settingsCurrencyIconGap = 16;
  static const double settingsCurrencyTitleGap = 12;
  static const double settingsCurrencyChipGap = x2;
  static const double settingsCurrencyChipHeight = 24;
  static const double settingsCurrencyChipMinWidth = 48;
  static const EdgeInsets settingsCurrencyChipPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double settingsLanguageRowHeight = 54;
  static const EdgeInsets settingsLanguageRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double settingsLanguageSelectedDot = 10;
  static const double settingsTradeSecurityRowHeight = 72;
  static const double settingsNotificationRowHeight = 68;
  static const EdgeInsets settingsRowPaddingWithIcon = EdgeInsets.fromLTRB(
    16,
    0,
    16,
    0,
  );
  static const EdgeInsets settingsRowPaddingNoIcon = EdgeInsets.fromLTRB(
    20,
    0,
    16,
    0,
  );
  static const double settingsRowIcon = 20;
  static const double settingsRowIconGap = 16;
  static const double settingsRowSubtitleGap = x2;
  static const double settingsRowSwitchGap = 12;
  static const double settingsSwitchWidth = 48;
  static const double settingsSwitchHeight = 28;
  static const double settingsSwitchKnob = 22;
  static const EdgeInsets settingsSwitchKnobMargin = EdgeInsets.all(3);
  static const double settingsAppInfoHeight = 172;
  static const EdgeInsets settingsAppInfoPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    14,
  );
  static const double settingsAppInfoTitleGap = 10;
  static const double settingsAppInfoRowHeight = 36;
  static const double settingsAppInfoValueGap = 16;
  static const double securityBottomInsetVisual = 58;
  static const double securityBottomInsetNative = 24;
  static EdgeInsets securityScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 14, contentPad, bottomInset);
  static const double securityContentGap = 18;
  static const double securityScoreHeight = 140;
  static const EdgeInsets securityCardPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double securityScoreBarsGap = 17;
  static const double securityScoreBarHeight = 7;
  static const double securityScoreBarGap = x3;
  static const double securityScoreAlertGap = x4;
  static const double securityScoreAlertHeight = 53;
  static const EdgeInsets securityScoreAlertPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: 10,
  );
  static const double securitySmallIcon = 14;
  static const double securityIconGap = x3;
  static const double securityRowHeight = 76;
  static const EdgeInsets securityRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double securityRowIconBox = 40;
  static const double securityRowIcon = iconMd;
  static const double securityRowGap = 16;
  static const double securityRowSubtitleGap = x3;
  static const double securityStatusGap = x3;
  static const double securityChevronGap = 11;
  static const double securityChevron = 19;
  static const EdgeInsets securityStatusPillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: 6,
  );
  static const double securityDeviceHeaderGap = x3;
  static const double securityDeviceMinHeight = 73;
  static const EdgeInsets securityDevicePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: x4,
  );
  static const double securityDeviceIcon = 20;
  static const double securityDeviceGap = 12;
  static const double securityDeviceNameGap = 7;
  static const double securityDeviceMetaGap = 6;
  static const double securityAntiPhishingHeight = buttonHero + inputHeight;
  static const double securityAntiPhishingIcon = 18;
  static const double securityAntiPhishingTitleGap = 7;
  static const double securityAntiPhishingInputGap = 14;
  static const double securitySaveButtonWidth = 58;
  static const double securitySaveButtonHeight = 32;
  static const double securitySupportHeight = 68;
  static const EdgeInsets securitySupportPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double securitySupportIconBox = 38;
  static const double securitySupportIcon = 20;
  static const double securitySupportGap = 14;
  static const double securitySupportTextGap = x3;
  static const double kycBottomInsetVisual = 120;
  static const double kycBottomInsetNative = 32;
  static EdgeInsets kycScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 31, contentPad, bottomInset);
  static const double kycStatusToReviewGap = 18;
  static const double kycReviewToLevelsGap = 33;
  static const double kycLevelGap = 25;
  static const double kycPrivacyGap = 29;
  static const double kycStatusHeight = 81;
  static const EdgeInsets kycStatusPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double kycStatusIconBox = 48;
  static const double kycStatusIcon = 25;
  static const double kycStatusGap = 14;
  static const double kycStatusTextGap = x3;
  static const double kycStatusCheckGap = 4;
  static const double kycStatusCheckIcon = 14;
  static const double kycLevelRowHeight = 73;
  static const EdgeInsets kycLevelRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double kycLevelRowGap = 16;
  static const double kycLevelChevron = 19;
  static const EdgeInsets kycLevelDetailsPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    16,
  );
  static const double kycLevelDetailsGap = 14;
  static const double kycLevelIconBox = 40;
  static const double kycLevelIconBorder = hairlineStroke;
  static const double kycLevelDoneIcon = 24;
  static const double kycDetailTitleGap = x3;
  static const double kycDetailIcon = 12;
  static const double kycDetailIconGap = x3;
  static const double kycDetailLineGap = 6;
  static const double kycPrivacyHeight = 95;
  static const EdgeInsets kycPrivacyPadding = EdgeInsets.fromLTRB(
    16,
    15,
    16,
    14,
  );
  static const double kycPrivacyIcon = 15;
  static const double kycPrivacyGapHorizontal = x3;
  static const double kycPrivacyTitleGap = 10;
  static const double profileApiBottomInsetVisual = 126;
  static const double profileApiBottomInsetNative = 32;
  static EdgeInsets profileApiScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 14, contentPad, bottomInset);
  static const double profileApiContentGap = 18;
  static const double profileApiCardGap = 18;
  static const EdgeInsets profileApiKeyCardPadding = EdgeInsets.all(16);
  static const double profileApiKeySecretGap = 12;
  static const double profileApiSecretRowsGap = x2;
  static const double profileApiPermissionGap = 12;
  static const double profileApiUsageGap = 13;
  static const double profileApiActionsGapTop = 14;
  static const double profileApiActionGap = 10;
  static const double profileApiIconBox = 40;
  static const double profileApiIcon = 19;
  static const double profileApiHeaderGap = 12;
  static const double profileApiTitleStatusGap = 7;
  static const double profileApiMetaGap = x1;
  static const double profileApiToggleWidth = 27;
  static const double profileApiToggleHeight = 16;
  static const double profileApiToggleKnob = 6;
  static const EdgeInsets profileApiToggleKnobMargin = EdgeInsets.all(2);
  static const double profileApiSecretRowHeight = 32;
  static const double profileApiSecretLabelWidth = 48;
  static const double profileApiSecretTrailingGap = x2;
  static const EdgeInsets profileApiSecretPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double profileApiIconAction = 14;
  static const double profileApiPermissionSpacing = 6;
  static const double profileApiPermissionRunSpacing = 6;
  static const double profileApiSmallBadgeHeight = 26;
  static const EdgeInsets profileApiSmallBadgePadding = EdgeInsets.symmetric(
    horizontal: 9,
  );
  static const double profileApiSmallBadgeIcon = 12;
  static const double profileApiSmallBadgeIconGap = x1;
  static const double profileApiUsageIcon = 11;
  static const double profileApiUsageGapInline = x1;
  static const double profileApiActionHeight = 36;
  static const double profileApiDeleteIcon = 17;
  static const double profileApiDocsHeight = 96;
  static const EdgeInsets profileApiDocsPadding = EdgeInsets.fromLTRB(
    16,
    16,
    14,
    16,
  );
  static const double profileApiDocsIconBox = 40;
  static const double profileApiDocsIcon = iconMd;
  static const double profileApiDocsGap = 12;
  static const double profileApiDocsTitleGap = 5;
  static const double profileApiDocsChevron = 18;
  static const double profileApiCreateBottomInsetVisual = 120;
  static const double profileApiCreateBottomInsetNative = 32;
  static EdgeInsets profileApiCreateScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 17, contentPad, bottomInset);
  static EdgeInsets profileApiCreateStepScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 28, contentPad, bottomInset);
  static const double profileApiCreateContentGap = 24;
  static const double profileApiCreateStepGap = 18;
  static const double profileApiCreateFieldGap = 10;
  static const double profileApiCreateHintGap = x2;
  static const double profileApiCreatePermissionGap = 12;
  static const double profileApiCreatePermissionHeight = 73;
  static const EdgeInsets profileApiCreatePermissionPadding =
      EdgeInsets.fromLTRB(16, 13, 16, 13);
  static const double profileApiCreatePermissionIconBox = 40;
  static const double profileApiCreatePermissionIcon = 18;
  static const double profileApiCreatePermissionIconGap = 13;
  static const double profileApiCreatePermissionDescriptionGap = x2;
  static const double profileApiCreatePermissionTrailingGap = 10;
  static const double profileApiCreatePermissionCheck = 24;
  static const double profileApiCreatePermissionCheckIcon = 15;
  static const double profileApiCreatePermissionCheckBorder = hairlineStroke;
  static const double profileApiCreateIpInputGap = x2;
  static const double profileApiCreateIpAddWidth = 56;
  static const double profileApiCreateIpAddIcon = iconMd + 1;
  static const double profileApiCreateIpWarningGap = x2;
  static const double profileApiCreateIpListGap = 10;
  static const double profileApiCreateIpChipGap = 6;
  static const EdgeInsets profileApiCreateIpChipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 7,
  );
  static const int profileApiCreateExpiryCrossAxisCount = 2;
  static const double profileApiCreateExpirySpacing = x2;
  static const double profileApiCreateExpiryExtent = 62;
  static const EdgeInsets profileApiCreateExpiryPadding = EdgeInsets.fromLTRB(
    13,
    10,
    13,
    9,
  );
  static const double profileApiCreateExpiryDescriptionGap = x2;
  static const double profileApiCreateTipsHeight = 160;
  static const EdgeInsets profileApiCreateTipsPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double profileApiCreateTipsIcon = 15;
  static const double profileApiCreateTipsTitleGap = x2;
  static const double profileApiCreateTipsListGap = 14;
  static const double profileApiCreateTipsBullet = 16;
  static const double profileApiCreateTipsBulletGap = 9;
  static const double profileApiCreateTipsItemGap = 9;
  static const double profileApiCreateSuccessIconBox = 80;
  static const double profileApiCreateSuccessIcon = 42;
  static const double profileApiCreateSuccessTitleGap = 14;
  static const EdgeInsets profileApiCreateSummaryPadding = EdgeInsets.all(16);
  static const double profileApiCreateSummaryDivider = 18;
  static const EdgeInsets profileApiCreateWarningPadding = EdgeInsets.all(14);
  static const double profileApiCreateWarningIcon = 17;
  static const double profileApiCreateWarningGap = 10;
  static const EdgeInsets profileApiCreateResultCardPadding = EdgeInsets.all(
    16,
  );
  static const double profileApiCreateResultValueGap = x2;
  static const double profileActivityBottomInsetVisual = 126;
  static const double profileActivityBottomInsetNative = 32;
  static EdgeInsets profileActivityScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets profileActivityListPadding = EdgeInsets.fromLTRB(
    20,
    32,
    20,
    37,
  );
  static const double profileActivityCardGap = 13;
  static const double profileActivityFilterHeight = 148;
  static const EdgeInsets profileActivityFilterPadding = EdgeInsets.fromLTRB(
    20,
    25,
    20,
    13,
  );
  static const double profileActivitySuspiciousHeight = 64;
  static const EdgeInsets profileActivitySuspiciousPadding =
      EdgeInsets.fromLTRB(12, 10, 12, 10);
  static const double profileActivityFilterGap = 13;
  static const double profileActivityFilterRailHeight = 30;
  static const double profileActivityFilterChipGap = 12;
  static const double profileActivityFilterChipHeight = 30;
  static const EdgeInsets profileActivityFilterChipPadding =
      EdgeInsets.symmetric(horizontal: 13);
  static const double profileActivityBannerIcon = 17;
  static const double profileActivityBannerIconGap = 9;
  static const double profileActivityBannerTitleGap = x2;
  static const double profileActivityCardHeight = 226;
  static const EdgeInsets profileActivityCardPadding = EdgeInsets.fromLTRB(
    16,
    13,
    16,
    12,
  );
  static const double profileActivityIconBox = 40;
  static const double profileActivityIcon = 19;
  static const double profileActivityIconGap = 12;
  static const double profileActivityTitleStatusGap = x2;
  static const double profileActivityDescriptionGap = x2;
  static const double profileActivityWarningGap = x2;
  static const double profileActivityWarningIcon = 17;
  static const double profileActivityDetailsGap = 13;
  static const double profileActivityDividerTopGap = x2;
  static const double profileActivityDividerBottomGap = 11;
  static const double profileActivityDetailsHeight = 108;
  static const EdgeInsets profileActivityDetailsPadding = EdgeInsets.fromLTRB(
    13,
    12,
    13,
    12,
  );
  static const double profileActivityDetailsColumnGap = 16;
  static const double profileActivityDetailsRowGap = 14;
  static const double profileActivityDetailIcon = 12;
  static const double profileActivityDetailIconGap = 5;
  static const double profileActivityDetailValueGap = x2;
  static const double profileActivityStatusHeight = 22;
  static const EdgeInsets profileActivityStatusPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const double profileActivityFooterHeight = 64;
  static const EdgeInsets profileActivityFooterPadding = EdgeInsets.fromLTRB(
    20,
    12,
    20,
    12,
  );
  static const double profileActivityFooterIcon = 14;
  static const double profileActivityFooterGap = x2;
  static const double profileSubAccountBottomInsetVisual = 126;
  static const double profileSubAccountBottomInsetNative = 32;
  static EdgeInsets profileSubAccountScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 14, contentPad, bottomInset);
  static const double profileSubAccountSummaryRiskGap = 18;
  static const double profileSubAccountRiskCreateGap = 26;
  static const double profileSubAccountCreateFormGap = 13;
  static const double profileSubAccountAccountsHeaderGap = 24;
  static const double profileSubAccountAccountsListGap = 10;
  static const double profileSubAccountCardGap = 13;
  static const double profileSubAccountInfoNoteGap = 25;
  static const EdgeInsets profileSubAccountSummaryPadding = EdgeInsets.all(20);
  static const double profileSubAccountSummaryIcon = 18;
  static const double profileSubAccountSummaryIconGap = 10;
  static const double profileSubAccountSummaryBalanceGap = 17;
  static const double profileSubAccountSummaryPnlGap = 14;
  static const double profileSubAccountSummaryMetricTopGap = 20;
  static const double profileSubAccountSummaryMetricGap = 12;
  static const double profileSubAccountSummaryMetricHeight = 68;
  static const EdgeInsets profileSubAccountSummaryMetricPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static const double profileSubAccountSummaryMetricValueGap = x3;
  static const EdgeInsets profileSubAccountCardTapPadding = EdgeInsets.all(16);
  static const double profileSubAccountAvatarSize = 45;
  static const double profileSubAccountAvatarGap = 13;
  static const double profileSubAccountTitlePillGap = 7;
  static const double profileSubAccountStatusTopGap = 9;
  static const double profileSubAccountStatusIcon = 12;
  static const double profileSubAccountStatusIconGap = x2;
  static const double profileSubAccountStatusMetaGap = 6;
  static const double profileSubAccountTrailingGap = 10;
  static const double profileSubAccountTrailingPnlGap = x3;
  static const EdgeInsets profileSubAccountCreatePadding = EdgeInsets.all(16);
  static const double profileSubAccountCreateTitleGap = 14;
  static const double profileSubAccountCreateSectionGap = 12;
  static const double profileSubAccountCreateCtaGap = 14;
  static const double profileSubAccountFormLabelGap = 7;
  static const double profileSubAccountFormPillLabelGap = x3;
  static const double profileSubAccountFormPillGap = x3;
  static const EdgeInsets profileSubAccountFormInputPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const EdgeInsets profileSubAccountDetailsPadding = EdgeInsets.fromLTRB(
    16,
    0,
    16,
    16,
  );
  static const double profileSubAccountDetailsDividerHeight = dividerHairline;
  static const double profileSubAccountDetailsTopGap = 14;
  static const double profileSubAccountDetailsMetricGap = 13;
  static const double profileSubAccountDetailLabelGap = 7;
  static const double profileSubAccountPermissionLabelGap = x3;
  static const double profileSubAccountPermissionGap = 7;
  static const double profileSubAccountEmailGap = 13;
  static const double profileSubAccountActionsGap = 13;
  static const double profileSubAccountActionGap = x3;
  static const double profileSubAccountActionHeight = 36;
  static const double profileSubAccountActionIcon = 14;
  static const double profileSubAccountActionIconGap = x2;
  static const EdgeInsets profileSubAccountInfoNotePadding =
      EdgeInsets.fromLTRB(14, 13, 14, 13);
  static const double profileSubAccountInfoNoteIcon = 16;
  static const double profileSubAccountInfoNoteGapInline = 9;
  static const double profileVipBottomInsetVisual = 110;
  static const double profileVipBottomInsetNative = 30;
  static const double profileVipContentGap = x5;
  static const double profileVipHeroHeight = 186;
  static const EdgeInsets profileVipHeroPadding = EdgeInsets.all(contentPad);
  static const double profileVipHeroBadgeIcon = 16;
  static const double profileVipHeroTitleGap = x2;
  static const double profileVipHeroMemberGap = x3;
  static const double profileVipHeroStatusGap = x3;
  static const EdgeInsets profileVipFeePadding = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const double profileVipFeeValueGap = x3;
  static const EdgeInsets profileVipTabsPadding = EdgeInsets.all(x2);
  static const EdgeInsets profileVipProgressPadding = EdgeInsets.all(16);
  static const double profileVipProgressTitleGap = 16;
  static const double profileVipProgressLineGap = 17;
  static const double profileVipProgressBarGap = x3;
  static const double profileVipProgressBarHeight = 10;
  static const EdgeInsets profileVipTableTitlePadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    14,
  );
  static const double profileVipTableDividerHeight = dividerHairline;
  static const EdgeInsets profileVipTableHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );
  static const EdgeInsets profileVipTableRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const double profileVipTierNameGap = x3;
  static const double profileVipActiveDotGap = x2;
  static const double profileVipActiveDot = 6;
  static const EdgeInsets profileVipSavingsPadding = EdgeInsets.all(16);
  static const double profileVipSavingsIcon = 17;
  static const double profileVipSavingsIconGap = x3;
  static const double profileVipSavingsBoxGap = x4;
  static const EdgeInsets profileVipSavingBoxPadding = EdgeInsets.all(x4);
  static const double profileVipSavingBoxValueGap = x3;
  static const double profileVipBenefitCardGap = x4;
  static const EdgeInsets profileVipBenefitHeaderPadding = EdgeInsets.all(16);
  static const EdgeInsets profileVipBenefitBodyPadding = EdgeInsets.all(16);
  static const double profileVipBenefitIconGap = x4;
  static const double profileVipBenefitTitleGap = x3;
  static const double profileVipBenefitStateIcon = 19;
  static const double profileVipBenefitFeatureGap = x3;
  static const double profileVipBenefitFeatureIconBox = 18;
  static const double profileVipBenefitFeatureIcon = 11;
  static const double profileVipBenefitFeatureIconGap = x3;
  static const double profileVipBenefitMetricsGap = x4;
  static const double profileVipBenefitMetricColumnGap = x5;
  static const double profileVipBenefitMetricValueGap = x2;
  static const EdgeInsets profileVipUpgradePadding = EdgeInsets.all(16);
  static const double profileVipUpgradeIconBox = 40;
  static const double profileVipUpgradeIcon = iconMd;
  static const double profileVipUpgradeIconGap = x4;
  static const double profileVipUpgradeTextGap = x3;
  static const double profileVipUpgradeCtaGap = x3;
  static const EdgeInsets profileVipUpgradeCtaPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double profileVipTierIconLarge = 56;
  static const double profileVipTierIconSmall = 18;
  static const double profileVipTierIconGlyphLarge = 29;
  static const double profileVipTierIconGlyphSmall = 14;
  static const EdgeInsets profileVipHistoryCardPadding = EdgeInsets.all(16);
  static const double profileDevicesBottomInsetVisual = 126;
  static const double profileDevicesBottomInsetNative = 32;
  static EdgeInsets profileDevicesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 14, contentPad, bottomInset);
  static const double profileDevicesSummaryGap = 18;
  static const double profileDevicesRiskGap = 27;
  static const double profileDevicesCurrentHeaderGap = 10;
  static const double profileDevicesOtherHeaderGap = 26;
  static const double profileDevicesOtherListGap = 10;
  static const double profileDevicesCardGap = 13;
  static const double profileDevicesFooterSummaryGap = 27;
  static const EdgeInsets profileDevicesSummaryPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double profileDevicesSummaryIconBox = 44;
  static const double profileDevicesSummaryIcon = 23;
  static const double profileDevicesSummaryGapInline = 12;
  static const double profileDevicesSummaryTitleGap = 7;
  static const double profileDevicesSummaryStatsGapTop = 16;
  static const double profileDevicesSummaryStatGap = 12;
  static const double profileDevicesSummaryStatHeight = 58;
  static const EdgeInsets profileDevicesSummaryStatPadding =
      EdgeInsets.fromLTRB(12, 10, 8, 8);
  static const EdgeInsets profileDevicesCardPadding = EdgeInsets.all(16);
  static const double profileDevicesIconBox = 44;
  static const double profileDevicesIcon = iconMd;
  static const double profileDevicesIconGap = 12;
  static const double profileDevicesActionTopGap = 14;
  static const double profileDevicesActionDividerGap = 13;
  static const double profileDevicesActionGap = 9;
  static const EdgeInsets profileDevicesLogoutButtonPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const double profileDevicesActionIcon = 15;
  static const double profileDevicesTrustIcon = 14;
  static const double profileDevicesMetaIcon = 12;
  static const double profileDevicesMetaIconGap = x1;
  static const double profileDevicesNamePillGap = x2;
  static const double profileDevicesWarningIcon = 15;
  static const double profileDevicesBrowserGap = 7;
  static const double profileDevicesMetaGap = x2;
  static const double profileDevicesMetaSpacing = 11;
  static const double profileDevicesMetaRunSpacing = 5;
  static const double profileDevicesIpGap = 7;
  static const double predictionHomeBottomInsetVisual = 54;
  static const double predictionHomeBottomInsetNative = contentPad;
  static EdgeInsets predictionHomeScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionHomeContentGap = x4;
  static const EdgeInsets predictionHomeEventPadding = EdgeInsets.all(16);
  static const double predictionHomeBadgeGap = 6;
  static const double predictionHomeBadgeRunGap = x2;
  static const double predictionHomeEventTitleGap = 10;
  static const double predictionHomeSectionGap = 12;
  static const double predictionHomeActionGap = x3;
  static const double predictionHomeChanceLabelGap = 7;
  static const double predictionHomeChanceBarHeight = x3;
  static const EdgeInsets predictionHomeOutcomeChipPadding =
      EdgeInsets.symmetric(horizontal: 9, vertical: x2);
  static const double predictionHomeOutcomeDot = x3;
  static const double predictionHomeOutcomeGap = 6;
  static const double predictionHomeStatGap = 12;
  static const double predictionHomeTrendIcon = 12;
  static const double predictionHomeStatIcon = 11;
  static const double predictionHomeStatIconGap = 4;
  static const double predictionHomeActionHeight = 42;
  static const EdgeInsets predictionHomeBadgePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const double predictionHomeEmptyHeight = 220;
  static const double predictionHomeEmptyIcon = 40;
  static const double predictionHomeEmptyTitleGap = 12;
  static const double predictionHomeEmptySubtitleGap = 4;
  static const double predictionHomeFilterGap = x3;
  static const double predictionHomeFilterHeight = 36;
  static const EdgeInsets predictionHomeFilterPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const double predictionHomeFilterIcon = 12;
  static const double predictionHomeFilterIconGap = 6;
  static const double predictionHomeCategoryHeight = 31;
  static const EdgeInsets predictionHomeCategoryPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets predictionHomeCompactCardPadding = EdgeInsets.all(14);
  static const EdgeInsets predictionHomeBridgeCardPadding = EdgeInsets.all(16);
  static const double predictionHomeHighlightIconBox = 40;
  static const double predictionHomeHighlightIcon = 20;
  static const double predictionHomeHighlightCtaIcon = 18;
  static const double predictionHomeHighlightGap = 12;
  static const double predictionHomeHighlightTinyGap = hairlineStroke;
  static const double predictionHomeBridgeTinyGap = x1;
  static const double predictionHomeBridgeWrapGap = 7;
  static const double predictionDetailBottomInsetVisual = 54;
  static const double predictionDetailBottomInsetNative = contentPad;
  static EdgeInsets predictionDetailScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionDetailContentGap = 15;
  static const double predictionDetailBadgeGap = 7;
  static const double predictionDetailBadgeRunGap = 6;
  static const double predictionDetailTitleTopGap = 9;
  static const double predictionDetailMetaTopGap = x3;
  static const double predictionDetailMetaGap = 12;
  static const double predictionDetailOutcomeTopGap = 15;
  static const double predictionDetailOutcomeGap = 12;
  static const EdgeInsets predictionDetailOutcomePadding = EdgeInsets.all(15);
  static const double predictionDetailOutcomeDot = 11;
  static const double predictionDetailOutcomeLabelGap = 7;
  static const double predictionDetailOutcomeChanceGap = 6;
  static const double predictionDetailOutcomeMetaGap = x3;
  static const double predictionDetailMultiOutcomeBottomGap = x3;
  static const EdgeInsets predictionDetailMultiOutcomePadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const double predictionDetailMultiOutcomeDot = 10;
  static const double predictionDetailMultiOutcomeGap = 10;
  static const double predictionDetailProbabilityTopGap = 12;
  static const double predictionDetailProbabilityHeight = 10;
  static const double predictionDetailStatsGap = x3;
  static const int predictionDetailStatsColumns = 2;
  static const double predictionDetailStatsAspectRatio = 2.55;
  static const EdgeInsets predictionDetailStatPadding = EdgeInsets.all(10);
  static const double predictionDetailStatIconBox = 32;
  static const double predictionDetailStatIcon = 15;
  static const double predictionDetailStatGap = 10;
  static const EdgeInsets predictionDetailPositionPadding = EdgeInsets.all(13);
  static const double predictionDetailPositionIcon = 13;
  static const double predictionDetailPositionIconGap = 6;
  static const double predictionDetailPositionTopGap = 9;
  static const double predictionDetailPositionBadgeGap = x3;
  static const EdgeInsets predictionDetailChartCardPadding = EdgeInsets.all(14);
  static const double predictionDetailChartPeriodHeight = 30;
  static const double predictionDetailChartPeriodGap = 6;
  static const double predictionDetailChartPlotGap = 10;
  static const double predictionDetailChartHeight = 178;
  static const double predictionDetailChartVolumeLabelGap = 9;
  static const double predictionDetailChartVolumeBarsGap = x2;
  static const double predictionDetailChartVolumeBarsHeight = 42;
  static const EdgeInsets predictionDetailChartVolumeBarMargin =
      EdgeInsets.symmetric(horizontal: 1.5);
  static const double predictionDetailChartVolumeBarMinFactor = .10;
  static const EdgeInsets predictionDetailOrderBookTogglePadding =
      EdgeInsets.symmetric(horizontal: 15, vertical: 13);
  static const double predictionDetailOrderBookToggleIcon = 15;
  static const double predictionDetailOrderBookToggleGap = x3;
  static const double predictionDetailOrderBookChevron = 18;
  static const double predictionDetailOrderBookExpandedGap = x3;
  static const EdgeInsets predictionDetailOrderBookCardPadding = EdgeInsets.all(
    14,
  );
  static const double predictionDetailOrderBookHeaderGap = 6;
  static const EdgeInsets predictionDetailOrderBookMidPriceMargin =
      EdgeInsets.symmetric(vertical: 7);
  static const EdgeInsets predictionDetailOrderBookMidPricePadding =
      EdgeInsets.symmetric(vertical: 7);
  static const EdgeInsets predictionDetailOrderBookRowPadding =
      EdgeInsets.symmetric(vertical: 6, horizontal: hairlineStroke);
  static const double predictionDetailOrderBookColumnWidth = 72;
  static const double predictionDetailHolderRankColumnWidth = 28;
  static const double predictionDetailHolderSideColumnWidth = 54;
  static const double predictionDetailHolderSharesColumnWidth = 70;
  static const double predictionDetailHolderHeaderGap = x3;
  static const EdgeInsets predictionDetailHolderRowPadding =
      EdgeInsets.symmetric(vertical: x3);
  static const double predictionDetailHolderWinnerIcon = 15;
  static const double predictionDetailHolderDefaultIcon = 6;
  static const EdgeInsets predictionDetailActivityRowPadding =
      EdgeInsets.symmetric(vertical: x3);
  static const double predictionDetailActivityIconBox = 30;
  static const double predictionDetailActivityIcon = 14;
  static const double predictionDetailActivityIconGap = 10;
  static const EdgeInsets predictionDetailTradeCardPadding = EdgeInsets.all(14);
  static const double predictionDetailTradeSectionGap = x4;
  static const double predictionDetailTradeLabelGap = 7;
  static const EdgeInsets predictionDetailTradeOutcomeChipPadding =
      EdgeInsets.only(right: predictionDetailTradeLabelGap);
  static const double predictionDetailTradeHelperGap = 4;
  static const double predictionDetailTradePresetGap = 6;
  static const double predictionDetailTradeAmountPresetGap = x3;
  static const double predictionDetailTradePreviewGap = 12;
  static const double predictionDetailTradeDisclaimerGap = 12;
  static const double predictionDetailTradeCtaGap = 10;
  static const EdgeInsets predictionDetailSegmentPadding = EdgeInsets.all(4);
  static const double predictionDetailSegmentGap = 4;
  static const double predictionDetailSegmentHeight = 38;
  static const EdgeInsets predictionDetailToggleChipPadding =
      EdgeInsets.symmetric(horizontal: 11, vertical: 7);
  static const double predictionDetailAmountChipHeight = 31;
  static const double predictionDetailRiskLinkHeight = 38;
  static const double predictionDetailRiskIcon = 13;
  static const double predictionDetailRiskIconGap = 6;
  static const double predictionDetailRiskChevronGap = x1;
  static const double predictionDetailRiskChevron = 14;
  static const EdgeInsets predictionDetailTabsPadding = EdgeInsets.all(4);
  static const double predictionDetailTabsGap = 4;
  static const double predictionDetailTabHeight = 34;
  static const EdgeInsets predictionDetailTabPadding = EdgeInsets.symmetric(
    horizontal: 11,
  );
  static const EdgeInsets predictionDetailTabCardPadding = EdgeInsets.all(15);
  static const double predictionDetailTabSectionGap = x4;
  static const double predictionDetailTabInfoGap = 10;
  static const double predictionDetailTabTitleGap = x3;
  static const double predictionDetailRuleBottomGap = x3;
  static const double predictionDetailRuleNumberWidth = 22;
  static const double predictionDetailInfoIcon = 13;
  static const double predictionDetailInfoIconGap = 7;
  static const EdgeInsets predictionDetailInfoBoxPadding = EdgeInsets.all(12);
  static const double predictionDetailInfoBoxIcon = 14;
  static const double predictionDetailInfoBoxGap = x3;
  static const double predictionDetailInfoBoxTextGap = x1;
  static const double predictionDetailRelatedGap = 12;
  static const double predictionDetailRelatedCardWidth = 220;
  static const EdgeInsets predictionDetailRelatedCardPadding = EdgeInsets.all(
    13,
  );
  static const double predictionDetailRelatedBadgeGap = x3;
  static const double predictionDetailRelatedMetaGap = 10;
  static const double predictionDetailRelatedDot = x3;
  static const double predictionDetailRelatedDotGap = 6;
  static const double predictionDetailRelatedLabelGap = 4;
  static const EdgeInsets predictionDetailArenaPadding = EdgeInsets.all(15);
  static const double predictionDetailArenaIconBox = 36;
  static const double predictionDetailArenaIcon = 18;
  static const double predictionDetailArenaHeaderGap = 10;
  static const double predictionDetailArenaBadgeGap = 6;
  static const double predictionDetailArenaRoomsGap = 12;
  static const double predictionDetailArenaRoomBottomGap = x3;
  static const EdgeInsets predictionDetailArenaRoomPadding = EdgeInsets.all(10);
  static const double predictionDetailArenaRoomIcon = 15;
  static const double predictionDetailArenaRoomGap = x3;
  static const EdgeInsets predictionDetailArenaCreatePadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: 11);
  static const double predictionDetailArenaCreateIcon = 15;
  static const double predictionDetailArenaCreateGap = x3;
  static const double predictionDetailArenaCreateBadgeGap = 4;
  static const double predictionDetailArenaCreateChevron = 16;
  static const EdgeInsets predictionDetailArenaBadgePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: hairlineStroke);
  static const EdgeInsets predictionDetailCommentWarningPadding =
      EdgeInsets.all(11);
  static const double predictionDetailCommentWarningIcon = 15;
  static const double predictionDetailCommentWarningGap = x2;
  static const EdgeInsets predictionDetailCommentAfterWarningGap =
      EdgeInsets.only(top: 13);
  static const EdgeInsets predictionDetailCommentInputTopGap = EdgeInsets.only(
    top: 10,
  );
  static const double predictionDetailCommentInputHeight = 42;
  static const EdgeInsets predictionDetailCommentInputPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets predictionDetailCommentRowPadding = EdgeInsets.only(
    bottom: 13,
  );
  static const double predictionDetailCommentAvatarRadius = 16;
  static const double predictionDetailCommentAvatarGap = 10;
  static const double predictionDetailCommentHeaderGap = 7;
  static const EdgeInsets predictionDetailCommentBodyGap = EdgeInsets.only(
    top: x1,
  );
  static const EdgeInsets predictionDetailCommentActionGap = EdgeInsets.only(
    top: x1,
  );
  static const double predictionDetailCommentLikeIcon = 12;
  static const double predictionDetailCommentLikeGap = x1;
  static const double predictionDetailCommentReportGap = 12;
  static const EdgeInsets predictionOrderPreviewPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    11,
  );
  static const double predictionOrderPreviewIcon = 15;
  static const double predictionOrderPreviewIconGap = x3;
  static const double predictionOrderPreviewHeaderGap = 10;
  static const double predictionOrderPreviewRowGap = 7;
  static const double predictionOrderPreviewFooterGap = 9;
  static const EdgeInsets predictionOrderPreviewBadgePadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: 4);
  static const EdgeInsets predictionDetailQuickLinkPadding = EdgeInsets.all(11);
  static const double predictionDetailQuickLinkGap = x3;
  static const double predictionDetailQuickLinkIcon = 16;
  static const double predictionPortfolioBottomInsetVisual = 54;
  static const double predictionPortfolioBottomInsetNative = contentPad;
  static EdgeInsets predictionPortfolioScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  // PRED-PORTFOLIO-HOME-01: legacy hero/tabs/bridge tokens superseded by home* primitives.
  @Deprecated('Superseded by home* tokens after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioContentGap = 16;
  @Deprecated('Superseded by VitAccentPill after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: x1);
  @Deprecated(
    'Superseded by homePortfolioCardPadding after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioSummaryPadding =
      EdgeInsets.fromLTRB(20, 15, 20, 20);
  @Deprecated('Superseded by VitInlineIconAction after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioVisibilityButton = 32;
  @Deprecated('Superseded by VitInlineIconAction after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioVisibilityIcon = 17;
  static const double predictionPortfolioValueGap = x3;
  @Deprecated('Superseded by VitMetricDeltaPill after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioPnlGap = 6;
  @Deprecated('Superseded by VitMetricDeltaPill after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioPnlPillPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: 6);
  static const double predictionPortfolioPnlIcon = 13;
  static const double predictionPortfolioPnlIconGap = 4;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioSummaryStatsGap = 18;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioSummaryStatGap = x3;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioSummaryStatHeight = 51;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioSummaryStatPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: 9);
  @Deprecated(
    'Superseded by VitAnnouncementBanner after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioSharesNotePadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: 11);
  static const double predictionPortfolioSharesNoteIcon = 15;
  static const double predictionPortfolioSharesNoteGap = 9;
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioTabsHeight = 43;
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioTabsPadding = EdgeInsets.all(4);
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioTabLabelGap = x2;
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioCountBadgePadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: 1);
  @Deprecated(
    'Superseded by grouped VitCard lists after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioListGap = 10;
  @Deprecated(
    'Superseded by cardPadding grouped rows after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioPositionCardPadding =
      EdgeInsets.fromLTRB(14, 14, 12, 26);
  static const double predictionPortfolioPositionIconBox = 38;
  static const double predictionPortfolioPositionIcon = 19;
  static const double predictionPortfolioPositionGap = 12;
  static const double predictionPortfolioPositionTitleGap = 6;
  static const double predictionPortfolioChipGap = x3;
  static const double predictionPortfolioChipRunGap = 4;
  static const double predictionPortfolioPositionMetricsGap = x3;
  static const double predictionPortfolioPositionRowsGap = 6;
  static const double predictionPortfolioPnlArrowIcon = 13;
  static const double predictionPortfolioPnlArrowGap = x1;
  static const double predictionPortfolioTrailingGap = x3;
  static const EdgeInsets predictionPortfolioTrailingIconPadding =
      EdgeInsets.only(top: 18);
  static const double predictionPortfolioTrailingIcon = 18;
  static const double predictionPortfolioMetricGap = 4;
  @Deprecated('Superseded by VitSectionHeader after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioOrdersHeaderGap = x3;
  @Deprecated('Superseded by VitSectionHeader after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioOrdersHelpGap = 6;
  @Deprecated('Superseded by VitSectionHeader after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioOrdersHelpIcon = 13;
  @Deprecated(
    'Superseded by cardPadding grouped rows after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioOrderCardPadding = EdgeInsets.all(
    12,
  );
  static const double predictionPortfolioOrderIconBox = 32;
  static const double predictionPortfolioOrderIcon = 17;
  static const double predictionPortfolioOrderGap = 12;
  static const double predictionPortfolioOrderTitleGap = x2;
  static const double predictionPortfolioOrderProgressGap = x3;
  static const double predictionPortfolioOrderProgressHeight = x2;
  static const double predictionPortfolioOrderTrailingGap = 10;
  static const double predictionPortfolioOrderChevron = 14;
  static const double predictionPortfolioOrderCancelGap = x3;
  static const double predictionPortfolioOrderCancelHeight = 32;
  static const EdgeInsets predictionPortfolioOrderCancelPadding =
      EdgeInsets.symmetric(horizontal: 10);
  static const double predictionPortfolioOrderCancelIcon = 12;
  static const double predictionPortfolioOrderCancelIconGap = 4;
  @Deprecated(
    'Superseded by cardPadding grouped rows after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioReceiptCardPadding =
      EdgeInsets.all(13);
  static const double predictionPortfolioReceiptIconBox = 36;
  static const double predictionPortfolioReceiptIcon = 17;
  static const double predictionPortfolioReceiptGap = 11;
  static const double predictionPortfolioReceiptTitleGap = x2;
  static const double predictionPortfolioReceiptMetaGap = 6;
  static const double predictionPortfolioReceiptChevron = 15;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioBridgePadding = EdgeInsets.all(14);
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeIconBox = 36;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeIcon = 17;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeGap = 12;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeTextGap = x1;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeBadgeGap = x3;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioBridgeBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: x1);
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeChevronGap = 7;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeChevron = 17;
  static const double predictionRiskBottomInsetVisual = 54;
  static const double predictionRiskBottomInsetNative = contentPad;
  static EdgeInsets predictionRiskScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionRiskContentGap = 16;
  static const double predictionRiskTabsHeight = 54;
  static const double predictionRiskTabIndicatorHeight = hairlineStroke;
  static const double predictionRiskTabIndicatorWidth = 116;
  static const EdgeInsets predictionRiskCardPadding = EdgeInsets.all(16);
  static const double predictionRiskFieldGap = 16;
  static const double predictionRiskInputLabelGap = x3;
  static const double predictionRiskInputRowGap = 12;
  static const double predictionRiskOutcomeGap = 10;
  static const double predictionRiskOutcomeButtonHeight = 42;
  static const double predictionRiskSummaryTitleGap = 14;
  static const double predictionRiskSummaryRowGap = 12;
  static const double predictionRiskMetricGap = 4;
  static const double predictionRiskMetricVertical = 7;
  static const double predictionRiskMetricCompactVertical = x1;
  static const EdgeInsets predictionRiskMetricPadding = EdgeInsets.symmetric(
    vertical: predictionRiskMetricVertical,
  );
  static const EdgeInsets predictionRiskMetricCompactPadding =
      EdgeInsets.symmetric(vertical: predictionRiskMetricCompactVertical);
  static const double predictionRiskMetricIcon = 16;
  static const double predictionRiskMetricIconGap = x3;
  static const double predictionRiskKellyIcon = 17;
  static const double predictionRiskKellyIconGap = x3;
  static const double predictionRiskKellySubtitleGap = x1;
  static const double predictionRiskKellyValueGap = 14;
  static const double predictionRiskKellyValueWrapGap = x3;
  static const double predictionRiskKellyValueRunGap = x1;
  static const EdgeInsets predictionRiskWarningPadding = EdgeInsets.all(12);
  static const double predictionRiskWarningIcon = 15;
  static const double predictionRiskWarningGap = x3;
  static const double predictionRiskScenarioTitleGap = 14;
  static const EdgeInsets predictionRiskGuidePadding = EdgeInsets.all(14);
  static const double predictionRiskGuideTitleGap = 5;
  static const double predictionReceiptBottomInsetVisual = 54;
  static const double predictionReceiptBottomInsetNative = contentPad;
  static EdgeInsets predictionReceiptScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionReceiptContentGap = 15;
  static const EdgeInsets predictionReceiptSummaryRowPadding =
      EdgeInsets.symmetric(vertical: 5);
  static const double predictionReceiptSummaryTrailingGap = 5;
  static const double predictionReceiptSummaryTrailingIcon = 12;
  static const double predictionReceiptFillDividerGap = 12;
  static const double predictionReceiptFillBarGap = 7;
  static const double predictionReceiptFillBarHeight = x3;
  static const double predictionReceiptTimelineDot = 18;
  static const double predictionReceiptTimelineIcon = 12;
  static const double predictionReceiptTimelineLineWidth = 1;
  static const EdgeInsets predictionReceiptTimelineLineMargin =
      EdgeInsets.symmetric(vertical: 3);
  static const double predictionReceiptTimelineGap = 10;
  static const double predictionReceiptTimelineItemBottomGap = 14;
  static const double predictionReceiptSoftPillHeight = 27;
  static const EdgeInsets predictionReceiptSoftPillPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets predictionReceiptHeroPadding = EdgeInsets.all(20);
  static const double predictionReceiptHeroPillGap = x3;
  static const double predictionReceiptHeroOutcomeGap = 12;
  static const double predictionReceiptHeroEventGap = x1;
  static const EdgeInsets predictionReceiptCardPadding = EdgeInsets.all(16);
  static const EdgeInsets predictionReceiptDisclosurePadding = EdgeInsets.all(
    12,
  );
  static const double predictionReceiptShareBorderWidth = 1.5;
  static const double predictionReceiptShareIcon = 17;
  static const double predictionReceiptShareIconGap = x3;
  static const double predictionReceiptDisclosureIcon = 15;
  static const double predictionReceiptDisclosureGap = x3;
  static const double predictionReceiptActionGap = 12;
  static const double predictionAnalyzerBottomInsetVisual = 54;
  static const double predictionAnalyzerBottomInsetNative = contentPad;
  static EdgeInsets predictionAnalyzerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionAnalyzerContentGap = 16;
  static const double predictionAnalyzerTabsHeight = 54;
  static const double predictionAnalyzerTabIndicatorHeight = hairlineStroke;
  static const double predictionAnalyzerTabIndicatorWidth = 116;
  static const EdgeInsets predictionAnalyzerSummaryPadding =
      EdgeInsets.fromLTRB(16, 16, 16, 18);
  static const double predictionAnalyzerValueGap = 11;
  static const double predictionAnalyzerPnlGap = x3;
  static const EdgeInsets predictionAnalyzerPnlPadding = EdgeInsets.only(
    bottom: hairlineStroke,
  );
  static const double predictionAnalyzerPnlIcon = 15;
  static const double predictionAnalyzerPnlIconGap = x1;
  static const double predictionAnalyzerSummaryPrimaryGap = 22;
  static const double predictionAnalyzerSummarySecondaryGap = 16;
  static const EdgeInsets predictionAnalyzerCardPadding = EdgeInsets.all(16);
  static const int predictionAnalyzerGridColumns = 2;
  static const double predictionAnalyzerGridExtent = 84;
  static const double predictionAnalyzerGridGap = 12;
  static const double predictionAnalyzerStatIcon = 16;
  static const double predictionAnalyzerStatIconGap = x3;
  static const EdgeInsets predictionAnalyzerCategoryPadding =
      EdgeInsets.fromLTRB(16, 18, 16, 18);
  static const double predictionAnalyzerCategoryTitleGap = 16;
  static const double predictionAnalyzerDonutHeight = 190;
  static const double predictionAnalyzerDonutWidth = 240;
  static const double predictionAnalyzerLegendGap = 18;
  static const int predictionAnalyzerLegendColumns = 2;
  static const double predictionAnalyzerLegendExtent = 42;
  static const double predictionAnalyzerLegendCrossGap = 16;
  static const double predictionAnalyzerLegendMainGap = x1;
  static const double predictionAnalyzerPerformanceChartGap = 16;
  static const double predictionAnalyzerPerformanceChartHeight = 180;
  static const double predictionAnalyzerTradeStatsGap = 16;
  static const double predictionAnalyzerTradeProgressGap = 14;
  static const double predictionAnalyzerTradeProgressHeight = x3;
  static const EdgeInsets predictionAnalyzerAttributionPadding = EdgeInsets.all(
    14,
  );
  static const double predictionAnalyzerAttributionLabelGap = x1;
  static const double predictionAnalyzerAttributionTrailingGap = 10;
  static const double predictionAnalyzerRiskChartTitleGap = 16;
  static const double predictionAnalyzerRiskChartHeight = 160;
  static const double predictionAnalyzerRiskIcon = 16;
  static const double predictionAnalyzerRiskIconGap = x3;
  static const double predictionAnalyzerRiskTextGap = x1;
  static const double predictionAnalyzerScoreGap = 12;
  static const double predictionAnalyzerScoreSuffixGap = 5;
  static const EdgeInsets predictionAnalyzerWarningPadding = EdgeInsets.all(12);
  static const double predictionAnalyzerWarningIcon = 15;
  static const double predictionAnalyzerWarningGap = x3;
  static const double predictionAnalyzerSummaryMetricGap = 5;
  static const double predictionAnalyzerLegendSwatch = 12;
  static const EdgeInsets predictionAnalyzerLegendSwatchMargin =
      EdgeInsets.only(top: hairlineStroke);
  static const double predictionAnalyzerLegendItemGap = x3;
  static const double predictionAnalyzerRiskMetricVertical = 10;
  static const double predictionAnalyzerRiskBarHorizontal = 5;
  static const EdgeInsets predictionAnalyzerRiskMetricPadding =
      EdgeInsets.symmetric(vertical: predictionAnalyzerRiskMetricVertical);
  static const EdgeInsets predictionAnalyzerRiskBarPadding =
      EdgeInsets.symmetric(horizontal: predictionAnalyzerRiskBarHorizontal);
  static const double predictionAnalyzerRiskBarLabelGap = 7;
  static const double predictionBreakingBottomInsetVisual = 54;
  static const double predictionBreakingBottomInsetNative = contentPad;
  static EdgeInsets predictionBreakingScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionBreakingContentGap = 14;
  static const EdgeInsets predictionBreakingMovementPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const double predictionBreakingMovementIcon = 18;
  static const double predictionBreakingMovementGap = x3;
  static const double predictionBreakingMovementCountGap = 12;
  static const double predictionBreakingCountIcon = 13;
  static const double predictionBreakingCountIconGap = x1;
  static const double predictionBreakingTabGap = x3;
  static const double predictionBreakingTabHeight = 36;
  static const EdgeInsets predictionBreakingTabPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const EdgeInsets predictionBreakingMoverPadding = EdgeInsets.all(16);
  static const double predictionBreakingRankBox = 32;
  static const double predictionBreakingMoverGap = 12;
  static const double predictionBreakingTitleGap = x3;
  static const double predictionBreakingOutcomeGap = 10;
  static const double predictionBreakingOutcomeRunGap = 6;
  static const double predictionBreakingMetaGap = 10;
  static const double predictionBreakingMetaRunGap = 5;
  static const EdgeInsets predictionBreakingChangePadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: 3);
  static const double predictionBreakingChangeIcon = 12;
  static const double predictionBreakingChangeIconGap = x1;
  static const EdgeInsets predictionBreakingTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: hairlineStroke);
  static const double predictionBreakingMetaIcon = 10;
  static const double predictionBreakingMetaIconGap = x1;
  static const EdgeInsets predictionBreakingEmailPadding = EdgeInsets.all(16);
  static const double predictionBreakingEmailIconBox = 40;
  static const double predictionBreakingEmailIcon = 18;
  static const double predictionBreakingEmailGap = 12;
  static const double predictionBreakingEmailFormGap = 12;
  static const double predictionBreakingEmailButtonGap = x3;
  static const double predictionBreakingSubscribeHeight = 42;
  static const EdgeInsets predictionBreakingSubscribePadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const double predictionBreakingEmptyHeight = 220;
  static const double predictionBreakingEmptyIcon = 40;
  static const double predictionBreakingEmptyTitleGap = 12;
  static const double predictionBreakingEmptySubtitleGap = x1;
  static const double predictionMarketMakerBottomInsetVisual = 54;
  static const double predictionMarketMakerBottomInsetNative = contentPad;
  static EdgeInsets predictionMarketMakerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionMarketMakerContentGap = 16;
  static const double predictionMarketMakerTabsHeight = 54;
  static const double predictionMarketMakerTabIndicatorHeight = hairlineStroke;
  static const double predictionMarketMakerTabIndicatorWidth = 116;
  static const EdgeInsets predictionMarketMakerCardPadding = EdgeInsets.all(16);
  static const double predictionMarketMakerOverviewIconBox = 48;
  static const double predictionMarketMakerOverviewIcon = 25;
  static const double predictionMarketMakerOverviewGap = 12;
  static const double predictionMarketMakerOverviewStatsGap = 16;
  static const double predictionMarketMakerFormGap = 16;
  static const double predictionMarketMakerInputLabelGap = x3;
  static const double predictionMarketMakerInputPrefixIcon = 19;
  static const double predictionMarketMakerHelperGap = 5;
  static const double predictionMarketMakerEstimateGap = 14;
  static const double predictionMarketMakerAddButtonGap = 16;
  static const double predictionMarketMakerSpreadGap = x3;
  static const double predictionMarketMakerSpreadButtonHeight = 36;
  static const EdgeInsets predictionMarketMakerEstimatePadding = EdgeInsets.all(
    12,
  );
  static const double predictionMarketMakerAddIcon = 20;
  static const double predictionMarketMakerAddIconGap = x3;
  static const EdgeInsets predictionMarketMakerWarningPadding = EdgeInsets.all(
    12,
  );
  static const double predictionMarketMakerWarningIcon = 15;
  static const double predictionMarketMakerWarningGap = x3;
  static const double predictionMarketMakerPositionMetricGap = 12;
  static const double predictionMarketMakerPositionCardGap = 12;
  static const double predictionMarketMakerEarningsTitleGap = 16;
  static const double predictionMarketMakerEarningsChartHeight = 160;
  static const double predictionMarketMakerEarningsBarHorizontal = x1;
  static const EdgeInsets predictionMarketMakerEarningsBarPadding =
      EdgeInsets.symmetric(
        horizontal: predictionMarketMakerEarningsBarHorizontal,
      );
  static const double predictionMarketMakerEarningsBarLabelGap = 6;
  static const double predictionMarketMakerOverviewMetricGap = x1;
  static const double predictionMarketMakerAnalysisRowVertical = x3;
  static const EdgeInsets predictionMarketMakerAnalysisRowPadding =
      EdgeInsets.symmetric(vertical: predictionMarketMakerAnalysisRowVertical);
  static const double predictionMarketMakerAnalysisIcon = 16;
  static const double predictionMarketMakerAnalysisIconGap = x3;
  static const double predictionSocialBottomInsetVisual = 54;
  static const double predictionSocialBottomInsetNative = contentPad;
  static EdgeInsets predictionSocialScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionSocialContentGap = 16;
  static const double predictionSocialTabsHeight = 54;
  static const double predictionSocialTabIndicatorHeight = hairlineStroke;
  static const double predictionSocialTabIndicatorWidth = 116;
  static const EdgeInsets predictionSocialCardPadding = EdgeInsets.all(16);
  static const EdgeInsets predictionSocialCompactPadding = EdgeInsets.all(12);
  static const double predictionSocialEventTitleGap = 10;
  static const double predictionSocialEventIcon = 15;
  static const double predictionSocialEventCommentGap = 7;
  static const double predictionSocialEventMetricGap = 22;
  static const double predictionSocialEventBullishGap = 6;
  static const double predictionSocialCommentTitleGap = 10;
  static const double predictionSocialStanceGap = 10;
  static const double predictionSocialInputGap = 14;
  static const double predictionSocialPostButtonGap = 20;
  static const double predictionSocialPostButtonHeight = 40;
  static const double predictionSocialPostIcon = 16;
  static const double predictionSocialPostIconGap = x3;
  static const double predictionSocialStanceHeight = 29;
  static const double predictionSocialReplyIndent = 48;
  static const double predictionSocialCommentHeaderGap = 10;
  static const double predictionSocialCommentMoreIcon = 18;
  static const double predictionSocialCommentBodyGap = 12;
  static const double predictionSocialReplyGap = 14;
  static const double predictionSocialUserBadgeGap = 6;
  static const double predictionSocialUserBadgeRunGap = x1;
  static const double predictionSocialUserMetaGap = x1;
  static const double predictionSocialTimeIcon = 11;
  static const double predictionSocialTimeIconGap = x1;
  static const double predictionSocialStanceBadgeGap = 7;
  static const double predictionSocialActionGap = x3;
  static const double predictionSocialActionReportGap = 10;
  static const double predictionSocialAvatar = 32;
  static const double predictionSocialAvatarIcon = 17;
  static const EdgeInsets predictionSocialSmallBadgePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const EdgeInsets predictionSocialActionPillPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: 6);
  static const double predictionSocialActionIcon = 14;
  static const double predictionSocialActionIconGap = 5;
  static const double predictionSocialDisclosureIcon = 15;
  static const double predictionSocialDisclosureGap = x3;
  static const double predictionSocialSentimentTitleGap = 16;
  static const double predictionSocialSentimentChartHeight = 190;
  static const double predictionSocialSentimentLegendGap = 12;
  static const double predictionSocialShareButtonGap = 12;
  static const double predictionSocialCopyTitleGap = 10;
  static const double predictionSocialCopyBoxHeight = 38;
  static const EdgeInsets predictionSocialCopyBoxPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double predictionSocialCopyButtonGap = x3;
  static const double predictionSocialCopyIcon = 14;
  static const double predictionSocialPreviewImage = 60;
  static const double predictionSocialPreviewIcon = 28;
  static const double predictionSocialPreviewGap = 12;
  static const double predictionSocialPreviewTitleGap = 5;
  static const double predictionSocialPreviewBodyGap = 6;
  static const double predictionSocialContributorIcon = 20;
  static const double predictionSocialContributorGap = 12;
  static const double predictionSocialContributorBadgeGap = 6;
  static const double predictionSocialContributorMetaGap = x1;
  static const double predictionSocialTrendGap = x1;
  static const double predictionSocialShareButtonHeight = 56;
  static const EdgeInsets predictionSocialShareButtonPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const double predictionSocialShareIcon = 20;
  static const double predictionSocialShareIconGap = 10;
  static const double predictionSocialMetricGap = x1;
  static const double predictionSocialLegendSwatch = 10;
  static const double predictionSocialLegendGap = x1;
  static const double predictionSocialLegendValueGap = x1;
  static const double predictionCalendarBottomInsetVisual = 54;
  static const double predictionCalendarBottomInsetNative = contentPad;
  static EdgeInsets predictionCalendarScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionCalendarContentGap = 16;
  static const double predictionCalendarTabsHeight = 54;
  static const double predictionCalendarTabIndicatorHeight = hairlineStroke;
  static const double predictionCalendarTabIndicatorWidth = 116;
  static const double predictionCalendarFilterGap = x3;
  static const EdgeInsets predictionCalendarFilterChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 7);
  static const EdgeInsets predictionCalendarStatsPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const EdgeInsets predictionCalendarEventPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const double predictionCalendarWatchIcon = 17;
  static const double predictionCalendarUrgentIcon = 16;
  static const double predictionCalendarLeadingGap = 6;
  static const double predictionCalendarTitleTrailingGap = x3;
  static const EdgeInsets predictionCalendarStatusPadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: x1);
  static const double predictionCalendarEventMetricGap = 10;
  static const double predictionCalendarTimeIcon = 12;
  static const double predictionCalendarTimeIconGap = 5;
  static const EdgeInsets predictionCalendarCategoryBadgePadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x1);
  static const double predictionCalendarCategoryGap = x3;
  static const double predictionCalendarChevron = 16;
  static const EdgeInsets predictionCalendarCardPadding = EdgeInsets.all(16);
  static const EdgeInsets predictionCalendarInfoPadding = EdgeInsets.all(12);
  static const EdgeInsets predictionCalendarNotificationRowPadding =
      EdgeInsets.symmetric(vertical: 10);
  static const double predictionCalendarNotificationLabelGap = hairlineStroke;
  static const double predictionCalendarWatchingIcon = 17;
  static const double predictionCalendarWatchingIconGap = x3;
  static const EdgeInsets predictionCalendarWatchingCategoryPadding =
      EdgeInsets.only(left: 25);
  static const double predictionCalendarWatchingCategoryGap = x1;
  static const double predictionCalendarWatchingMetricGap = 14;
  static const double predictionCalendarEditButtonGap = 12;
  static const double predictionCalendarEditButtonHeight = 38;
  static const double predictionCalendarEditIcon = 15;
  static const double predictionCalendarEditIconGap = x3;
  static const double predictionCalendarInfoIcon = 15;
  static const double predictionCalendarInfoIconGap = x3;
  static const double predictionCalendarToggleWidth = 48;
  static const double predictionCalendarToggleHeight = 28;
  static const EdgeInsets predictionCalendarTogglePadding = EdgeInsets.all(2);
  static const double predictionCalendarToggleKnob = 24;
  static const double predictionCalendarStatGap = 6;
  static const double predictionCalendarMetricGap = x1;
  static const double predictionTournamentBottomInsetVisual = 54;
  static const double predictionTournamentBottomInsetNative = contentPad;
  static EdgeInsets predictionTournamentScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionTournamentContentGap = 16;
  static const double predictionTournamentTabsHeight = 54;
  static const double predictionTournamentTabIndicatorHeight = hairlineStroke;
  static const double predictionTournamentTabIndicatorWidth = 116;
  static const EdgeInsets predictionTournamentCardPadding = EdgeInsets.all(16);
  static const double predictionTournamentFeaturedIcon = 16;
  static const double predictionTournamentFeaturedIconGap = 7;
  static const double predictionTournamentFeaturedCardGap = 9;
  static const double predictionTournamentTitleIcon = 16;
  static const double predictionTournamentTitleIconGap = 6;
  static const double predictionTournamentDescriptionGap = x1;
  static const double predictionTournamentStatusGap = 10;
  static const double predictionTournamentRankGap = 14;
  static const double predictionTournamentRankHeight = 35;
  static const EdgeInsets predictionTournamentRankPadding =
      EdgeInsets.symmetric(horizontal: 10);
  static const double predictionTournamentStatsGap = 14;
  static const double predictionTournamentDividerTopGap = 13;
  static const double predictionTournamentDividerHeight = 1;
  static const double predictionTournamentDividerBottomGap = 12;
  static const double predictionTournamentChevronGap = x1;
  static const double predictionTournamentChevron = 16;
  static const int predictionTournamentStatsColumns = 2;
  static const double predictionTournamentStatsMainGap = x3;
  static const double predictionTournamentStatsCrossGap = 16;
  static const double predictionTournamentStatsAspect = 4.6;
  static const double predictionTournamentStatIcon = 12;
  static const double predictionTournamentStatIconGap = 7;
  static const double predictionTournamentStatValueGap = x1;
  static const EdgeInsets predictionTournamentPillPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: 5);
  static const EdgeInsets predictionTournamentInfoPadding = EdgeInsets.all(12);
  static const double predictionTournamentInfoIcon = 14;
  static const double predictionTournamentInfoGap = x3;
  static const double predictionTournamentMineStatsGap = 12;
  static const double predictionTournamentCenteredMetricGap = x1;
  static const EdgeInsets predictionTournamentEmptyPadding =
      EdgeInsets.symmetric(horizontal: 18, vertical: 26);
  static const double predictionTournamentEmptyIcon = 44;
  static const double predictionTournamentEmptyTitleGap = 10;
  static const double predictionTournamentEmptyMessageGap = x1;
  static const EdgeInsets predictionTournamentLeaderboardPadding =
      EdgeInsets.all(12);
  static const double predictionTournamentLeaderboardRankWidth = 32;
  static const double predictionTournamentLeaderboardWinnerIcon = 21;
  static const double predictionTournamentLeaderboardIcon = 18;
  static const double predictionTournamentLeaderboardGap = 10;
  static const double predictionTournamentLeaderboardScoreGap = hairlineStroke;
  static const double predictionTournamentDetailHeroGap = 14;
  static const double predictionTournamentDetailDescriptionGap = x3;
  static const double predictionAdvancedBottomInsetVisual = 54;
  static const double predictionAdvancedBottomInsetNative = contentPad;
  static EdgeInsets predictionAdvancedScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionAdvancedContentGap = 16;
  static const double predictionAdvancedTabsHeight = 54;
  static const double predictionAdvancedTabIndicatorHeight = hairlineStroke;
  static const double predictionAdvancedTabIndicatorWidth = 116;
  static const double predictionAdvancedTimeframeGap = 10;
  static const double predictionAdvancedTimeframeHeight = 36;
  static const EdgeInsets predictionAdvancedCardPadding = EdgeInsets.all(16);
  static const double predictionAdvancedSummaryGap = 7;
  static const double predictionAdvancedSummaryValueGap = 9;
  static const EdgeInsets predictionAdvancedSummaryChangePadding =
      EdgeInsets.only(bottom: 5);
  static const double predictionAdvancedTrendIcon = 16;
  static const double predictionAdvancedTrendIconGap = x1;
  static const double predictionAdvancedChartGap = 12;
  static const double predictionAdvancedProbabilityChartHeight = 286;
  static const double predictionAdvancedVolumeChartHeight = 122;
  static const int predictionAdvancedLayerColumns = 2;
  static const double predictionAdvancedLayerGap = x3;
  static const double predictionAdvancedLayerAspect = 3.9;
  static const EdgeInsets predictionAdvancedLayerPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double predictionAdvancedLayerIcon = 14;
  static const double predictionAdvancedRsiHeight = 124;
  static const double predictionAdvancedRsiInfoIcon = 12;
  static const double predictionAdvancedRsiInfoGap = 7;
  static const EdgeInsets predictionAdvancedCompactPadding = EdgeInsets.all(12);
  static const double predictionAdvancedIndicatorDescGap = hairlineStroke;
  static const double predictionAdvancedIndicatorStrengthGap = 10;
  static const double predictionAdvancedMiniBarHeight = x1;
  static const double predictionAdvancedStrengthGap = 10;
  static const double predictionAdvancedOverallSignalGap = x3;
  static const double predictionAdvancedOverallDescriptionGap = x1;
  static const double predictionAdvancedOverallIcon = 18;
  static const double predictionAdvancedOrderFlowHeight = 202;
  static const double predictionAdvancedLevelValueGap = 5;
  static const double predictionAdvancedLevelHelperGap = hairlineStroke;
  static const double predictionAdvancedLevelIcon = 18;
  static const double predictionAdvancedPatternGap = 14;
  static const double predictionAdvancedPatternIconGap = 7;
  static const double predictionAdvancedPatternIcon = 12;
  static const double predictionAdvancedPatternBarGap = 7;
  static const double predictionAdvancedPatternConfidenceGap = 12;
  static const double predictionAdvancedDisclaimerIcon = 14;
  static const double predictionAdvancedDisclaimerGap = x3;
  static const EdgeInsets predictionAdvancedSignalBadgePadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: 5);
  static const double predictionAdvancedLegendSwatch = 12;
  static const double predictionAdvancedLegendGap = x3;
  static const double predictionRewardsBottomInsetVisual = 54;
  static const double predictionRewardsBottomInsetNative = contentPad;
  static EdgeInsets predictionRewardsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionRewardsContentGap = 16;
  static const EdgeInsets predictionRewardsSheetPadding = EdgeInsets.fromLTRB(
    20,
    18,
    20,
    28,
  );
  static const EdgeInsets predictionRewardsRiskSheetGap = EdgeInsets.only(
    top: x2,
  );
  static const EdgeInsets predictionRewardsHeroPadding = EdgeInsets.all(20);
  static const double predictionRewardsHeroIconBox = 48;
  static const double predictionRewardsHeroIcon = 23;
  static const double predictionRewardsHeroTitleGap = 13;
  static const double predictionRewardsHeroPoolGap = 15;
  static const double predictionRewardsPoolIcon = 13;
  static const double predictionRewardsPoolGap = 7;
  static const EdgeInsets predictionRewardsNotePadding = EdgeInsets.symmetric(
    horizontal: 13,
    vertical: 11,
  );
  static const double predictionRewardsNoteIcon = 15;
  static const double predictionRewardsNoteGap = 9;
  static const double predictionRewardsNoteLineHeight = 1.45;
  static const double predictionRewardsFilterHeight = 31;
  static const double predictionRewardsFilterGap = x2;
  static const EdgeInsets predictionRewardsFilterPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double predictionRewardsFilterIcon = 11;
  static const double predictionRewardsFilterIconGap = 5;
  static const double predictionRewardsHeaderHeight = 36;
  static const EdgeInsets predictionRewardsTablePadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double predictionRewardsMarketColumnGap = 6;
  static const double predictionRewardsSpreadWidth = 54;
  static const double predictionRewardsMinWidth = 48;
  static const double predictionRewardsRewardWidth = 58;
  static const double predictionRewardsHeaderTrailingGap = 14;
  static const double predictionRewardsRowHeight = 64;
  static const double predictionRewardsFavoriteWidth = 20;
  static const double predictionRewardsFavoriteIcon = 15;
  static const double predictionRewardsFavoriteGap = 7;
  static const EdgeInsets predictionRewardsRowMetaGap = EdgeInsets.only(top: 5);
  static const double predictionRewardsMetaGap = 7;
  static const double predictionRewardsChangeIcon = 11;
  static const double predictionRewardsChevronGap = x1;
  static const double predictionRewardsChevron = 15;
  static const EdgeInsets predictionRewardsRiskLinkPadding =
      EdgeInsets.symmetric(vertical: 9);
  static const double predictionRewardsRiskIcon = 13;
  static const double predictionRewardsRiskGap = 7;
  static const double predictionRewardsRiskChevron = 14;
  static const EdgeInsets predictionRewardsArenaCardPadding = EdgeInsets.all(
    14,
  );
  static const double predictionRewardsArenaLabelIcon = 10;
  static const double predictionRewardsArenaLabelGap = 5;
  static const EdgeInsets predictionRewardsArenaContentGap = EdgeInsets.only(
    top: 12,
  );
  static const double predictionRewardsArenaIconBox = 38;
  static const double predictionRewardsArenaIcon = 17;
  static const double predictionRewardsArenaGap = 12;
  static const double predictionRewardsArenaMetaGap = x2;
  static const double predictionRewardsArenaChevron = 17;
  static const EdgeInsets predictionRewardsTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: 3);
  static const double predictionRewardsTinyBadgeLineHeight = 1.1;
  static const double predictionLeaderboardBottomInsetVisual = 54;
  static const double predictionLeaderboardBottomInsetNative = contentPad;
  static EdgeInsets predictionLeaderboardScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionLeaderboardContentGap = 16;
  static const EdgeInsets predictionLeaderboardSheetPadding =
      predictionRewardsSheetPadding;
  static const double predictionLeaderboardTimeFilterHeight = 42;
  static const EdgeInsets predictionLeaderboardTimeFilterPadding =
      EdgeInsets.all(x1);
  static const double predictionLeaderboardMetricGap = x2;
  static const double predictionLeaderboardMetricHeight = 32;
  static const EdgeInsets predictionLeaderboardMetricPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets predictionLeaderboardInfoPadding = EdgeInsets.only(
    left: x1,
  );
  static const double predictionLeaderboardInfoIcon = 12;
  static const double predictionLeaderboardMetricIcon = 13;
  static const double predictionLeaderboardMetricIconGap = 5;
  static const EdgeInsets predictionLeaderboardPodiumPadding =
      EdgeInsets.fromLTRB(14, 16, 14, 0);
  static const double predictionLeaderboardPodiumHeight = 198;
  static const List<double> predictionLeaderboardPodiumHeights = [90, 110, 75];
  static const double predictionLeaderboardPodiumAvatar = 22;
  static const double predictionLeaderboardPodiumAvatarGap = x1;
  static const double predictionLeaderboardPodiumUserGap = 2;
  static const double predictionLeaderboardPodiumValueGap = 12;
  static const EdgeInsets predictionLeaderboardPodiumColumnMargin =
      EdgeInsets.symmetric(horizontal: 5);
  static const EdgeInsets predictionLeaderboardPodiumColumnPadding =
      EdgeInsets.only(bottom: 13);
  static const double predictionLeaderboardWinnerIcon = 14;
  static const double predictionLeaderboardWinnerGap = x1;
  static const double predictionLeaderboardRankingHeaderHeight = 40;
  static const EdgeInsets predictionLeaderboardRankingPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const double predictionLeaderboardRankWidth = 32;
  static const double predictionLeaderboardMetricWidth = 84;
  static const double predictionLeaderboardWinRateWidth = 58;
  static const double predictionLeaderboardRankingRowHeight = 58;
  static const double predictionLeaderboardTraderAvatar = 17;
  static const double predictionLeaderboardTraderGap = x2;
  static const double predictionLeaderboardRankBadge = 21;
  static const EdgeInsets predictionLeaderboardWinCardPadding = EdgeInsets.all(
    14,
  );
  static const double predictionLeaderboardWinIconBox = 42;
  static const double predictionLeaderboardWinIcon = 20;
  static const double predictionLeaderboardWinGap = 12;
  static const double predictionLeaderboardWinAvatar = 15;
  static const double predictionLeaderboardWinAvatarGap = 6;
  static const double predictionLeaderboardWinMarketGap = 3;
  static const double predictionLeaderboardWinMarketArrow = 10;
  static const double predictionSearchBottomInsetVisual = 54;
  static const double predictionSearchBottomInsetNative = contentPad;
  static EdgeInsets predictionSearchScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionSearchContentGap = 14;
  static const EdgeInsets predictionSearchFilterPanelPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets predictionSearchFilterLabelGap = EdgeInsets.only(
    top: x2,
  );
  static const EdgeInsets predictionSearchFilterSectionGap = EdgeInsets.only(
    top: 16,
  );
  static const double predictionSearchChipGap = x2;
  static const EdgeInsets predictionSearchCategoryChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: x2);
  static const double predictionSearchSortChipHeight = 34;
  static const EdgeInsets predictionSearchSortChipPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const double predictionSearchSortIcon = 12;
  static const double predictionSearchSortIconGap = 6;
  static const double predictionSearchStatusChipHeight = 36;
  static const EdgeInsets predictionSearchClearGap = EdgeInsets.only(top: 14);
  static const double predictionSearchClearHeight = 40;
  static const double predictionSearchClearIcon = 14;
  static const double predictionSearchClearIconGap = 6;
  static const EdgeInsets predictionSearchResultPadding = EdgeInsets.all(16);
  static const double predictionSearchChanceBox = 48;
  static const double predictionSearchResultGap = 12;
  static const double predictionSearchTitleLineHeight = 1.35;
  static const EdgeInsets predictionSearchMetaTopGap = EdgeInsets.only(top: 7);
  static const double predictionSearchMetaSpacing = x2;
  static const double predictionSearchMetaRunSpacing = x1;
  static const EdgeInsets predictionSearchTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: 2);
  static const double predictionSearchEmptyHeight = 240;
  static const double predictionSearchEmptyIcon = 42;
  static const EdgeInsets predictionSearchEmptyTitleGap = EdgeInsets.only(
    top: 12,
  );
  static const EdgeInsets predictionSearchEmptyMessageGap = EdgeInsets.only(
    top: x1,
  );
  static const double predictionActivityBottomInsetVisual = 54;
  static const double predictionActivityBottomInsetNative = contentPad;
  static EdgeInsets predictionActivityScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionActivityContentGap = 16;
  static const EdgeInsets predictionActivityLiveStatsPadding = EdgeInsets.all(
    16,
  );
  static const double predictionActivityLiveIcon = 15;
  static const double predictionActivityLiveDotOffset = -1;
  static const double predictionActivityLiveDotSize = 7;
  static const double predictionActivityLiveGap = x2;
  static const EdgeInsets predictionActivityStatsTopGap = EdgeInsets.only(
    top: 14,
  );
  static const double predictionActivityStatsGap = 12;
  static const double predictionActivityStatHeight = 55;
  static const EdgeInsets predictionActivityStatValueGap = EdgeInsets.only(
    top: x1,
  );
  static const double predictionActivityFilterIcon = 13;
  static const double predictionActivityFilterGap = x2;
  static const double predictionActivityAmountChipGap = 6;
  static const double predictionActivityAmountChipHeight = 28;
  static const EdgeInsets predictionActivityAmountChipPadding =
      EdgeInsets.symmetric(horizontal: 10);
  static const double predictionActivityRowMinHeight = 78;
  static const EdgeInsets predictionActivityRowPadding = EdgeInsets.symmetric(
    vertical: 12,
  );
  static const double predictionActivityAvatarBox = 38;
  static const double predictionActivityAvatarText = 17;
  static const double predictionActivityRowGap = 12;
  static const double predictionActivityActorSpacing = 5;
  static const double predictionActivityActorRunSpacing = 3;
  static const EdgeInsets predictionActivityEventGap = EdgeInsets.only(top: x1);
  static const EdgeInsets predictionActivityOrderGap = EdgeInsets.only(top: 5);
  static const double predictionActivityAmountGap = x2;
  static const double predictionActivityAmountWidth = 58;
  static const EdgeInsets predictionActivityTimestampGap = EdgeInsets.only(
    top: x1,
  );
  static const EdgeInsets predictionActivityOutcomePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const double predictionActivityOutcomeLineHeight = 1.0;
  static const double predictionDataBottomInsetVisual = 54;
  static const double predictionDataBottomInsetNative = contentPad;
  static EdgeInsets predictionDataScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionDataContentGap = 16;
  static const double predictionDataTabBarHeight = 54;
  static const double predictionDataTabIndicatorHeight = hairlineStroke;
  static const double predictionDataTabIndicatorWidth = 116;
  static const EdgeInsets predictionDataCardPadding = EdgeInsets.all(16);
  static const double predictionDataHeroIconBox = 48;
  static const double predictionDataHeroIcon = 26;
  static const double predictionDataHeroGap = 12;
  static const double predictionDataHeroTitleGap = 2;
  static const double predictionDataOverviewMetricsGap = 16;
  static const double predictionDataMetricValueGap = 6;
  static const double predictionDataCompactLineHeight = 1.1;
  static const double predictionDataMetricLineHeight = 1.2;
  static const double predictionDataMetricIconGap = 5;
  static const double predictionDataMetricIcon = 12;
  static const double predictionDataHeaderWrapGap = x2;
  static const double predictionDataHeaderRunGap = 5;
  static const double predictionDataSmallTopGap = x1;
  static const double predictionDataSourceMetricsGap = 15;
  static const double predictionDataSourceUrlGap = 12;
  static const double predictionDataSourceLinkIcon = 12;
  static const double predictionDataSourceLinkGap = 7;
  static const EdgeInsets predictionDataStatusPillPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x1);
  static const double predictionDataStatusPillLineHeight = 1.0;
  static const EdgeInsets predictionDataNeutralChipPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: 5);
  static const double predictionDataInlineButtonSize = 30;
  static const double predictionDataInlineIcon = 15;
  static const double predictionDataIconBubble = 32;
  static const double predictionDataIconBubbleIcon = 16;
  static const double predictionDataPrimaryButtonHeight = 48;
  static const EdgeInsets predictionDataNoticePadding = EdgeInsets.all(12);
  static const double predictionDataNoticeIcon = 15;
  static const double predictionDataNoticeGap = x2;
  static const double predictionDataNoticeLineHeight = 1.5;
  static const double predictionDataApiKeyBoxMinHeight = 44;
  static const EdgeInsets predictionDataApiKeyBoxPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: x2,
  );
  static const double predictionDataApiKeyIcon = 15;
  static const double predictionDataApiKeyGap = x2;
  static const double predictionDataApiKeyBoxTopGap = 14;
  static const double predictionDataPermissionsTopGap = 13;
  static const double predictionDataPermissionLabelGap = 7;
  static const double predictionDataChipGap = 6;
  static const double predictionDataLastUsedGap = 12;
  static const double predictionDataLastUsedIcon = 12;
  static const double predictionDataLastUsedIconGap = 6;
  static const double predictionDataWebhookHeaderIcon = 15;
  static const double predictionDataWebhookUrlGap = x2;
  static const double predictionDataWebhookUrlLineHeight = 1.45;
  static const double predictionDataWebhookActionGap = 10;
  static const double predictionDataWebhookSectionGap = 14;
  static const double arenaHomeBottomInsetVisualExtra = 78;
  static const double arenaHomeBottomInsetNativeExtra = 24;
  static EdgeInsets arenaBottomScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets arenaPaddingX2 = EdgeInsets.all(x2);
  static const EdgeInsets arenaPaddingX3 = EdgeInsets.all(x3);
  static const EdgeInsets arenaPaddingX4 = EdgeInsets.all(x4);
  static const EdgeInsets arenaPaddingX5 = EdgeInsets.all(x5);
  static const EdgeInsets arenaTopPaddingX1 = EdgeInsets.only(top: x1);
  static const EdgeInsets arenaBottomPaddingX2 = EdgeInsets.only(bottom: x2);
  static const EdgeInsets arenaBottomPaddingX3 = EdgeInsets.only(bottom: x3);
  static const EdgeInsets arenaHorizontalPaddingX4 = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets arenaVerticalPaddingX1 = EdgeInsets.symmetric(
    vertical: x1,
  );
  static const EdgeInsets arenaVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets arenaVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets arenaActionSheetPadding = EdgeInsets.fromLTRB(
    x5,
    x5,
    x5,
    x6,
  );
  static const EdgeInsets arenaPresetSectionTabsPadding = EdgeInsets.fromLTRB(
    x5,
    x3,
    x5,
    x3,
  );
  static const EdgeInsets arenaPresetSectionChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x3,
  );
  static const EdgeInsets arenaPresetChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets arenaPresetPillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets arenaPresetDomainExpandedPadding =
      EdgeInsets.fromLTRB(x4, 0, x4, x4);
  static EdgeInsets arenaPresetScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset + x6);
  static const EdgeInsets arenaBridgePrincipleNumberPadding = EdgeInsets.only(
    top: arenaBridgeTinyGap,
  );
  static const EdgeInsets arenaProductionPillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets arenaProductionRegistryRowPadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: x3);
  static const EdgeInsets arenaProductionFlowLineMarginPadding =
      EdgeInsets.symmetric(vertical: arenaProductionFlowLineMargin);
  static EdgeInsets arenaProductionFlowStepPadding(bool last) =>
      EdgeInsets.only(bottom: last ? 0 : x4, left: x1, right: x1);
  static EdgeInsets arenaHomeScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double arenaHomeIntroLineHeight = 1.35;
  static const EdgeInsets arenaHomeQuickChipGapPadding = EdgeInsets.only(
    right: x2,
  );
  static const double arenaHomeQuickChipHeight = 36;
  static const double arenaHomeQuickChipIcon = 13;
  static const double arenaHomeQuickChipLineHeight = 1.0;
  static const double arenaHomeHeroTitleLineHeight = 1.05;
  static const int arenaHomeTemplateColumns = 2;
  static const double arenaHomeTemplateExtent = 90;
  static const double arenaHomeTemplateTitleLineHeight = 1.15;
  static const double arenaHomeTemplateDescriptionLineHeight = 1.3;
  static const double arenaHomeModeCardWidth = 220;
  static const double arenaHomeModeCardMinHeight = 132;
  static const double arenaHomeModeTitleLineHeight = 1.15;
  static const double arenaHomeDividerHeight = dividerHairline;
  static const double arenaHomeRoomProgressHeight = 6;
  static const double arenaHomeCreatorCardWidth = 140;
  static const double arenaHomeCreatorCardMinHeight = 148;
  static const double arenaHomeCreatorAvatar = 40;
  static const double arenaHomeCreatorIcon = 20;
  static const double arenaHomeBridgeChevron = 18;
  static const double arenaHomeVerifiedLineHeight = 1.3;
  static const double arenaHomeFooterIcon = 16;
  static const double arenaHomeFooterShieldIcon = 17;
  static const double arenaHomeFooterLineHeight = 1.35;
  static const double arenaCommunityRulesLinkLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaCommunityRulesLinkIcon = iconMd;
  static const EdgeInsetsDirectional arenaCommunityRulesLinkPadding =
      EdgeInsetsDirectional.symmetric(horizontal: x4, vertical: x3);
  static const double arenaHomeSearchChevron = 18;
  static const double arenaHomeActionIconBox = 32;
  static const double arenaHomeActionIcon = 17;
  static const double arenaHomeCountBadgeMinWidth = 16;
  static const double arenaHomeCountBadgeHeight = 16;
  static const EdgeInsets arenaHomeCountBadgePadding = EdgeInsets.symmetric(
    horizontal: x1,
  );
  static const double arenaHomeCountBadgeLineHeight = 1.0;
  static const double myArenaBottomInsetVisualExtra =
      arenaHomeBottomInsetVisualExtra;
  static const double myArenaBottomInsetNativeExtra =
      arenaHomeBottomInsetNativeExtra;
  static EdgeInsets myArenaScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double myArenaBalanceLineHeight = 1.0;
  static const EdgeInsets myArenaBalanceSuffixPadding = EdgeInsets.only(
    bottom: hairlineStroke,
  );
  static const double myArenaDividerHeight = dividerHairline;
  static const double myArenaPointsDeltaDividerHeight = 36;
  static const double myArenaDeltaDot = x2;
  static const double myArenaStatCardMinHeight = 116;
  static const double myArenaStatIconBox = arenaHomeActionIconBox;
  static const double myArenaStatIcon = arenaHomeActionIcon;
  static const double myArenaQuickLinkHeight = 44;
  static const double myArenaQuickLinkIcon = 14;
  static const double myArenaTabHeight = 36;
  static const double myArenaTabIcon = 14;
  static const double myArenaTextLineHeight = 1.2;
  static const double myArenaDraftIconBox = 36;
  static const double myArenaDraftIcon = 18;
  static const double myArenaSectionChevron = 20;
  static const double myArenaAnalyticsIcon = 18;
  static const double myArenaRewardMetricLineHeight = 1.0;
  static const double myArenaDistributionLabelWidth = 112;
  static const double myArenaDistributionProgressHeight = 10;
  static const double myArenaDistributionValueWidth = 30;
  static const double myArenaSafetyChevron = 20;
  static const double myArenaFooterIcon = arenaHomeFooterIcon;
  static const double myArenaFooterShieldIcon = arenaHomeFooterShieldIcon;
  static const double myArenaFooterLineHeight = arenaHomeFooterLineHeight;
  static const double myArenaEmptyIcon = 26;
  static const double myArenaActionIconBox = 40;
  static const double myArenaActionIcon = 18;
  static const double myArenaStatusPillLineHeight = 1.0;
  static const double myArenaAccentPillHeight = 44;
  static const double myArenaAccentPillIcon = 15;
  static const double myArenaAccentPillLineHeight = 1.0;
  static const double myArenaTextIconButtonIcon = 14;
  static const double arenaChallengeTitleLineHeight = 1.15;
  static const double arenaChallengeBodyLineHeight = 1.45;
  static const double arenaChallengeDividerHeight = dividerHairline;
  static const double arenaChallengeSmallIcon = 15;
  static const double arenaChallengeMdIcon = 17;
  static const double arenaChallengeLgIcon = 18;
  static const double arenaChallengeCountdownHeight = 40;
  static const double arenaChallengeProgressHeight = x2;
  static const double arenaChallengeClarityProgressHeight = 7;
  static const double arenaChallengeBridgeProgressHeight = 6;
  static const double arenaChallengeTeamDot = 12;
  static const double arenaChallengeMemberLineHeight = 1.2;
  static const double arenaChallengeFairPlayIcon = 11;
  static const double arenaChallengeRuleNumberWidth = 24;
  static const double arenaChallengeActivityDot = x2;
  static const double arenaChallengeBridgeIcon = 14;
  static const double arenaChallengeBridgeLetterSpacing = .5;
  static const double arenaChallengeBridgeTitleLineHeight = 1.25;
  static const double arenaChallengeBridgeNoticeLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaChallengeActionShareSize = 52;
  static const double arenaChallengeCommunityIcon = arenaHomeFooterIcon;
  static const double arenaChallengeSummaryLabelWidth = 108;
  static const double arenaChallengeSummaryLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaChallengeBannerIcon = 15;
  static const double arenaChallengeBannerLineHeight = 1.4;
  static const double arenaChallengeSecondaryIcon = 14;
  static const double arenaChallengeInlineIcon = 14;
  static const double arenaChallengeLiveDot = x2;
  static const double arenaChallengeIconBubble = 38;
  static const double arenaChallengeIconBubbleIcon = 19;
  static const double arenaChallengeInitialBadge = 16;
  static const double arenaChallengeInitialLineHeight = 1.0;
  static const double arenaLeaderboardPodiumSideSize = 54;
  static const double arenaLeaderboardPodiumWinnerSize = 70;
  static const double arenaLeaderboardPodiumBorderWidth = hairlineStroke;
  static const double arenaLeaderboardPodiumShadowBlur = 18;
  static const double arenaLeaderboardPodiumShadowSpread = -2;
  static const double arenaLeaderboardPodiumIcon = 26;
  static const double arenaLeaderboardLineHeight = 1.0;
  static const double arenaLeaderboardDividerHeight = dividerHairline;
  static const double arenaLeaderboardSectionMarkerWidth = x1;
  static const double arenaLeaderboardSectionMarkerHeight = 16;
  static const double arenaLeaderboardMyRankIconBox = 42;
  static const double arenaLeaderboardMyRankIcon = 22;
  static const double arenaLeaderboardFilterIcon = iconSm;
  static const double arenaLeaderboardRowRankWidth = 28;
  static const double arenaLeaderboardRowAvatar = 40;
  static const double arenaLeaderboardRowIcon = 20;
  static const double arenaLeaderboardFairPlayIcon = 10;
  static const double arenaLeaderboardRisingIcon = iconSm;
  static const double arenaLeaderboardCompactIcon = 30;
  static const double arenaLeaderboardFooterIcon = arenaHomeFooterIcon;
  static const double arenaLeaderboardFooterShieldIcon =
      arenaHomeFooterShieldIcon;
  static const double arenaLeaderboardFooterLineHeight =
      arenaHomeFooterLineHeight;
  static const EdgeInsets arenaLeaderboardHeroPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaLeaderboardFilterPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets arenaLeaderboardRowPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x4,
  );
  static const EdgeInsets arenaLeaderboardCompactStatePadding = EdgeInsets.all(
    x5,
  );
  static const EdgeInsets arenaLeaderboardFooterActionPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x2);
  static const EdgeInsets arenaLeaderboardFooterCardPadding = EdgeInsets.all(
    x4,
  );
  static const EdgeInsets arenaLeaderboardPodiumPadding = EdgeInsets.only(
    top: x2,
    bottom: x4,
  );
  static const double arenaModeActionIconDefaultSize = 32;
  static const double arenaModeActionIconLargeThreshold = 40;
  static const double arenaModeActionIconLargeGlyph = 22;
  static const double arenaModeActionIconGlyph = 17;
  static const double arenaModeHeroIcon = 48;
  static const EdgeInsets arenaModeMiniStatPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x4,
  );
  static const double arenaModeTitleLineHeight = 1.08;
  static const double arenaModeCreatorIcon = 34;
  static const double arenaModeChevron = 18;
  static const double arenaModeDescriptionLineHeight = 1.55;
  static const double arenaModeRuleLabelWidth = 112;
  static const double arenaModeRuleValueLineHeight = arenaHomeFooterLineHeight;
  static const int arenaModeQualityColumns = 2;
  static const double arenaModeQualityExtent = 62;
  static const double arenaModeQualityInfoIcon = 14;
  static const double arenaModeQualityIcon = arenaHomeActionIcon;
  static const EdgeInsets arenaModeQualityCardPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const double arenaModeTrustIcon = myArenaActionIconBox;
  static const double arenaModeTrustTextLineHeight = 1.4;
  static const EdgeInsets arenaModePredictionCardPadding = EdgeInsets.all(x4);
  static const double arenaModePredictionInfoIcon = iconSm;
  static const double arenaModePredictionLetterSpacing =
      arenaChallengeBridgeLetterSpacing;
  static const double arenaModePredictionTitleLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaModePredictionMetricIcon = 14;
  static const double arenaModePredictionProgressHeight = 6;
  static const double arenaModePredictionActionIcon = iconSm;
  static const double arenaModePredictionNoticeLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaModeRelatedDividerHeight = dividerHairline;
  static const double arenaModeRelatedCardWidth = 184;
  static const double arenaModeRelatedCardMinHeight = 132;
  static const double arenaModeRelatedTitleLineHeight = 1.2;
  static const double arenaModeRelatedDescriptionLineHeight =
      arenaHomeFooterLineHeight;
  static const double arenaJoinInlineIcon = iconSm;
  static const double arenaJoinCreatorAvatar = 44;
  static const double arenaJoinRuleNumberWidth = 24;
  static const double arenaJoinBodyLineHeight = arenaHomeFooterLineHeight;
  static const double arenaJoinNoticeLineHeight = arenaHomeFooterLineHeight;
  static const double arenaJoinAcknowledgementMinHeight = 44;
  static const double arenaJoinAcknowledgementLineHeight = 1.55;
  static const double arenaJoinCheckboxSize = 26;
  static const double arenaJoinCheckboxBorderWidth = 1.5;
  static const double arenaJoinCheckboxIcon = 18;
  static const EdgeInsets arenaJoinCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaJoinInfoRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const double arenaPointsMicroIcon = iconSm;
  static const double arenaPointsSmallIcon = 14;
  static const double arenaPointsInlineIcon = iconSm + 3;
  static const double arenaPointsCheckInIcon = 17;
  static const double arenaPointsChevron = 22;
  static const double arenaPointsDividerHeight = dividerHairline;
  static const double arenaPointsCompactLineHeight = 1.0;
  static const double arenaPointsBadgeLineHeight = 1.2;
  static const EdgeInsets arenaPointsExpiringPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets arenaPointsCheckInTilePadding = EdgeInsets.symmetric(
    horizontal: x1,
    vertical: x3,
  );
  static const EdgeInsets arenaPointsFilterPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets arenaPointsLeaderboardRowPadding =
      EdgeInsets.symmetric(vertical: x3);
  static const EdgeInsets arenaPointsMiniBadgePadding = EdgeInsets.symmetric(
    horizontal: x1,
  );
  static const double arenaPointsBodyLineHeight = 1.35;
  static const double arenaPointsNoticeLineHeight = arenaJoinNoticeLineHeight;
  static const double arenaPointsLedgerIconBox = 36;
  static const double arenaPointsLedgerGlyph = 17;
  static const double arenaPointsLedgerBalanceArrowIcon = 9;
  static const double arenaPointsLedgerBalanceArrowGap = 2;
  static const double arenaPointsTypeBadgeVerticalPadding = 2;
  static const EdgeInsets arenaPointsLedgerCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaPointsLedgerFilterPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets arenaPointsLedgerRowPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: rowPy,
  );
  static const EdgeInsets arenaPointsLedgerBadgePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: arenaPointsTypeBadgeVerticalPadding,
  );
  static const EdgeInsets arenaPointsLedgerNoticePadding = EdgeInsets.all(x3);
  static const EdgeInsets arenaPointsLedgerRulesPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const double arenaPointsEntryBalanceArrowBox = buttonCompact;
  static const double arenaPointsEntryLinkMaxWidth = 155;
  static const double arenaPointsEntrySectionMarkerWidth = 4;
  static const double arenaPointsEntrySectionMarkerHeight = 18;
  static const double arenaPointsEntryDetailLabelWidth = 105;
  static const EdgeInsets arenaPointsEntryHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets arenaPointsEntryCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaPointsEntryNoticePadding = EdgeInsets.all(x3);
  static const EdgeInsets arenaPointsEntryCopyPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets arenaPointsEntryRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets arenaPointsEntryLinkPadding = EdgeInsets.symmetric(
    horizontal: x1,
    vertical: x1,
  );
  static const double arenaSafetyFooterIcon = arenaPointsSmallIcon;
  static const double arenaSafetyIconBox = 40;
  static const double arenaSafetyMarkerWidth = 4;
  static const double arenaSafetyMarkerHeight = 18;
  static const double arenaSafetySectionTitleLineHeight = 1.25;
  static const double arenaSafetyBodyLineHeight = arenaPointsBodyLineHeight;
  static const double arenaSafetyNoticeLineHeight = arenaPointsNoticeLineHeight;
  static const double arenaSafetyBannedIcon = 15;
  static const double arenaSafetyProcessColumnWidth = 30;
  static const double arenaSafetyProcessStepBox = 28;
  static const double arenaSafetyProcessLineWidth = dividerHairline;
  static const double arenaSafetyProcessLineHeight = 28;
  static const double arenaSafetyInfoIcon = 18;
  static const double arenaSafetyCheckIcon = arenaPointsSmallIcon;
  static const double arenaSafetyCheckLineHeight = 1.4;
  static const double arenaSafetyDividerHeight = dividerHairline;
  static const EdgeInsets arenaSafetyCardPadding = EdgeInsets.all(x4);
  static EdgeInsets arenaSafetyProcessBodyPadding({required bool isLast}) =>
      EdgeInsets.only(bottom: isLast ? 0 : x3);
  static const double arenaReportSmallIcon = arenaPointsSmallIcon;
  static const double arenaReportInlineIcon = 18;
  static const double arenaReportToneIconBox = 40;
  static const double arenaReportToneIcon = 20;
  static const double arenaReportMarkerWidth = 4;
  static const double arenaReportMarkerHeight = 18;
  static const double arenaReportBodyLineHeight = arenaPointsBodyLineHeight;
  static const double arenaReportNoticeLineHeight = arenaPointsNoticeLineHeight;
  static const double arenaReportActionLineHeight = 1.5;
  static const double arenaReportTimelineColumnWidth = 20;
  static const double arenaReportTimelineDot = 12;
  static const double arenaReportTimelineBorderWidth = hairlineStroke;
  static const double arenaReportTimelineLineWidth = dividerHairline;
  static const double arenaReportTimelineLineHeight = 28;
  static const double arenaReportTimelineDateGap = 2;
  static const double arenaReportAppealCtaHeight = 36;
  static const EdgeInsets arenaReportCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaReportInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets arenaReportTimelineDotMargin = EdgeInsets.only(
    top: x1,
  );
  static const EdgeInsets arenaReportTimelineBodyPadding = EdgeInsets.only(
    bottom: x3,
  );
  static EdgeInsets arenaReportRelatedItemPadding({required bool isLast}) =>
      EdgeInsets.only(bottom: isLast ? 0 : x2);
  static const double myArenaReportsFilterHeight = 44;
  static const double myArenaReportsBadgeHeight = 20;
  static const double myArenaReportsBadgeMinWidth = 20;
  static const double myArenaReportsBadgePaddingHorizontal = 6;
  static const double myArenaReportsCompactLineHeight = 1.0;
  static const double myArenaReportsBodyLineHeight =
      arenaReportNoticeLineHeight;
  static const double myArenaReportsWrapRunSpacing = 2;
  static const double myArenaReportsChevron = arenaReportInlineIcon;
  static const double myArenaReportsIconBox = 40;
  static const double myArenaReportsIcon = 19;
  static const double myArenaReportsToneIcon = arenaReportInlineIcon;
  static const double myArenaReportsDividerHeight = dividerHairline;
  static const EdgeInsets myArenaReportsSummaryTilePadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x4);
  static const EdgeInsets myArenaReportsFilterPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets myArenaReportsBadgePadding = EdgeInsets.symmetric(
    horizontal: myArenaReportsBadgePaddingHorizontal,
  );
  static const EdgeInsets myArenaReportsCardPadding = EdgeInsets.all(x4);
  static const double arenaBlockedBodyLineHeight = arenaReportNoticeLineHeight;
  static const double arenaBlockedTinyGap = 2;
  static const double arenaBlockedAvatarBox = 40;
  static const double arenaBlockedAvatarIcon = arenaReportToneIcon;
  static const double arenaBlockedActionHeight = 30;
  static const double arenaBlockedActionMinWidth = 74;
  static const double arenaBlockedDialogLineHeight =
      arenaReportActionLineHeight;
  static const double arenaBlockedToneIconBox = 36;
  static const double arenaBlockedToneIcon = arenaReportInlineIcon;
  static const EdgeInsets arenaBlockedCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaBlockedRowPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets arenaBlockedActionPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const double arenaBridgeHeroLineHeight = 1.2;
  static const double arenaBridgeTitleLineHeight =
      arenaSafetySectionTitleLineHeight;
  static const double arenaBridgeMetricLineHeight = arenaPointsBodyLineHeight;
  static const double arenaBridgeBodyLineHeight = arenaReportNoticeLineHeight;
  static const double arenaBridgeIntroLineHeight = arenaReportActionLineHeight;
  static const double arenaBridgeTabHeight = 44;
  static const double arenaBridgePrincipleMinHeight = 84;
  static const double arenaBridgeTopicMinHeight = 32;
  static const double arenaBridgeDemoMinHeight = 76;
  static const double arenaBridgeStatMinHeight = 112;
  static const double arenaBridgeBadgeMinHeight = 26;
  static const double arenaBridgeTinyGap = 2;
  static const double arenaBridgeMicroIcon = arenaPointsMicroIcon;
  static const double arenaBridgeSmallIcon = arenaPointsSmallIcon;
  static const double arenaBridgeBadgeIcon = 12;
  static const double arenaBridgeChipIcon = arenaSafetyBannedIcon;
  static const double arenaBridgeInlineIcon = arenaPointsInlineIcon;
  static const double arenaBridgeActionIcon = arenaReportInlineIcon;
  static const double arenaBridgeMetricLabelWidth = 72;
  static const double arenaBridgeCompactIconBox = 30;
  static const double arenaBridgeIconBox = 36;
  static const double arenaBridgeCompactGlyph = 15;
  static const double arenaBridgeGlyph = 17;
  static const double arenaBridgeLetterSpacing = .2;
  static const double arenaProductionHeroLineHeight = arenaBridgeHeroLineHeight;
  static const double arenaProductionTitleLineHeight =
      arenaBridgeHeroLineHeight;
  static const double arenaProductionBodyLineHeight = arenaBridgeBodyLineHeight;
  static const double arenaProductionMetricLineHeight =
      arenaBridgeMetricLineHeight;
  static const double arenaProductionCompactLineHeight =
      arenaPointsCompactLineHeight;
  static const double arenaProductionCheckLineHeight =
      arenaSafetyCheckLineHeight;
  static const double arenaProductionTabHeight = arenaBridgeTabHeight;
  static const double arenaProductionTabIcon = arenaBridgeChipIcon;
  static const double arenaProductionScreenMinHeight = 132;
  static const double arenaProductionFlowIcon = arenaBridgeGlyph;
  static const double arenaProductionFlowBarHeight = 4;
  static const double arenaProductionFlowColumnWidth =
      arenaReportTimelineColumnWidth;
  static const double arenaProductionFlowDot = arenaBridgeMicroIcon;
  static const double arenaProductionFlowBorderWidth = hairlineStroke;
  static const double arenaProductionFlowLineWidth = hairlineStroke;
  static const double arenaProductionFlowLineMargin = arenaBridgeTinyGap;
  static const double arenaProductionStatusDot = x3;
  static const double arenaProductionHandoffIcon = arenaBridgeInlineIcon;
  static const double arenaProductionChecklistIcon = arenaBridgeSmallIcon;
  static const double arenaProductionStateIcon = arenaBridgeBadgeIcon;
  static const double arenaProductionStateMatrixMinWidth = 70;
  static const double arenaProductionStateMatrixIcon = 11;
  static const double arenaPresetCaptionLineHeight = 1.3;
  static const double arenaPresetBodyLineHeight = arenaPointsBodyLineHeight;
  static const double arenaPresetCheckLineHeight = arenaSafetyCheckLineHeight;
  static const double arenaPresetNoticeLineHeight = arenaPointsNoticeLineHeight;
  static const double arenaPresetSmallIcon = arenaPointsSmallIcon;
  static const double arenaPresetHeaderIcon = 15;
  static const double arenaPresetTinyIcon = arenaBridgeBadgeIcon;
  static const double arenaPresetMicroIcon = arenaBridgeMicroIcon;
  static const double arenaPresetInlineIcon = arenaBridgeInlineIcon;
  static const double arenaPresetSearchIcon = arenaReportInlineIcon;
  static const double arenaPresetChevron = arenaReportInlineIcon;
  static const double arenaPresetDomainIconBox = 40;
  static const double arenaPresetDomainIcon = arenaReportToneIcon;
  static const double arenaPresetSuggestionMaxWidth = 250;
  static const double arenaPresetTitleMaxWidth = 260;
  static const double arenaPresetProcessLabelWidth = 56;
  static const double arenaPresetStepDot = 22;
  static const double arenaPresetDividerHeight = dividerHairline;
  static const double arenaEcosystemMetricLineHeight =
      arenaBridgeMetricLineHeight;
  static const double arenaEcosystemBodyLineHeight = arenaBridgeBodyLineHeight;
  static const double arenaEcosystemIntroLineHeight =
      arenaBridgeIntroLineHeight;
  static const double arenaEcosystemTitleLineHeight =
      arenaBridgeTitleLineHeight;
  static const double arenaEcosystemCheckLineHeight =
      arenaSafetyCheckLineHeight;
  static const double arenaEcosystemTabHeight = arenaBridgeTabHeight;
  static const double arenaEcosystemTabIcon = arenaBridgeChipIcon;
  static const double arenaEcosystemScreenMinHeight = 136;
  static const double arenaEcosystemFlowDot = arenaPresetStepDot;
  static const double arenaEcosystemFlowBorderWidth = borderWidth;
  static const double arenaEcosystemFlowBridgeIcon =
      arenaProductionStateMatrixIcon;
  static const double arenaEcosystemFlowLineWidth = borderWidth;
  static const double arenaEcosystemFlowLineHeight = 38;
  static const double arenaEcosystemCompactIcon = arenaBridgeMicroIcon;
  static const double arenaEcosystemBlockIcon = arenaBridgeChipIcon;
  static const double arenaEcosystemBoardChipHeight = 38;
  static const double arenaEcosystemSmallIcon = arenaBridgeSmallIcon;
  static const double arenaEcosystemInlineIcon = arenaBridgeInlineIcon;
  static const double arenaEcosystemPillMinHeight = arenaPresetStepDot;
  static const double arenaEcosystemTintIconBox = arenaBridgeIconBox;
  static const double arenaEcosystemTintIconBoxSmall =
      arenaBridgeCompactIconBox;
  static const double arenaEcosystemTintGlyph = arenaBridgeGlyph;
  static const double arenaEcosystemTintGlyphSmall = arenaBridgeCompactGlyph;
  static const double arenaGovernanceStepperLineHeight = hairlineStroke;
  static const double arenaGovernanceStepActive = 31;
  static const double arenaGovernanceStepDefault = 28;
  static const double arenaGovernanceSubtitleLineHeight =
      arenaPresetCaptionLineHeight;
  static const double arenaGovernanceBodyLineHeight =
      arenaSafetyCheckLineHeight;
  static const double arenaGovernanceNoticeLineHeight =
      arenaReportNoticeLineHeight;
  static const double arenaGovernanceSmallIcon = arenaPresetSmallIcon;
  static const double arenaGovernanceAddIcon = arenaPresetHeaderIcon;
  static const double arenaGovernanceIcon = arenaBridgeInlineIcon;
  static const double arenaGovernanceLargeIcon = arenaReportInlineIcon;
  static const double arenaGovernanceFooterIcon = arenaPresetStepDot;
  static const double arenaGovernanceClarityProgressHeight = 7;
  static const double arenaGovernancePillPadCompactV = 1;
  static const double arenaGovernancePillPadV = 3;
  static const double arenaGovernanceOptionMaxWidth = 132;
  static const int arenaGovernanceGridColumns = 2;
  static const double arenaGovernanceDomainGridAspect = 3.2;
  static const double arenaGovernanceWinGridAspect = 2.45;
  static const double arenaGovernanceInputBorderWidth = 1.4;
  static const EdgeInsets arenaGovernanceStepperLineMargin = EdgeInsets.only(
    bottom: x5,
  );
  static const EdgeInsets arenaGovernanceCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaGovernanceInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets arenaGovernanceSummaryRowPadding = EdgeInsets.only(
    bottom: x2,
  );
  static EdgeInsets arenaGovernancePillPadding({required bool compact}) =>
      EdgeInsets.symmetric(
        horizontal: compact ? x1 : x2,
        vertical: compact
            ? arenaGovernancePillPadCompactV
            : arenaGovernancePillPadV,
      );
  static const EdgeInsets arenaGovernanceNextActionPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x2);
  static const EdgeInsets arenaGovernanceFooterPadding = EdgeInsets.fromLTRB(
    x5,
    x4,
    x5,
    x2,
  );
  static const EdgeInsets arenaGovernanceSavePadding = EdgeInsets.symmetric(
    horizontal: x1,
    vertical: x2,
  );
  static const EdgeInsets arenaGovernanceListItemPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets arenaGovernanceComparePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets arenaGovernancePrivacyChipPadding =
      EdgeInsets.symmetric(vertical: x3);
  static const EdgeInsets arenaGovernanceOptionChipPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: x2);
  static const EdgeInsets arenaGovernanceEdgeFieldPadding = EdgeInsets.only(
    top: x3,
  );
  static const EdgeInsets arenaGovernanceDropdownPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x3,
  );
  static const EdgeInsets arenaGovernanceSwitchRowPadding = EdgeInsets.only(
    top: x2,
  );
  static const EdgeInsets arenaGovernanceInputPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const double arenaSmartRuleStepperLineHeight =
      arenaGovernanceStepperLineHeight;
  static const double arenaSmartRuleStepDot = arenaGovernanceStepDefault;
  static const double arenaSmartRuleStepIcon = arenaGovernanceSmallIcon;
  static const double arenaSmartRuleSubtitleLineHeight =
      arenaGovernanceSubtitleLineHeight;
  static const double arenaSmartRuleIcon = arenaGovernanceIcon;
  static const double arenaSmartRuleSmallIcon = arenaGovernanceSmallIcon;
  static const double arenaSmartRuleTinyIcon = arenaGovernanceAddIcon;
  static const double arenaSmartRuleBodyLineHeight =
      arenaGovernanceBodyLineHeight;
  static const double arenaSmartRuleProgressHeight = x2;
  static const double arenaSmartRuleOptionWidth = 181;
  static const double arenaSmartRuleChallengeTypeWidth = 200;
  static const double arenaSmartRuleSummaryLabelWidth = 112;
  static const EdgeInsets arenaSmartRuleStepperLineMargin = EdgeInsets.only(
    bottom: x5,
  );
  static const EdgeInsets arenaSmartRuleCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaSmartRuleInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets arenaSmartRuleLinkPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets arenaSmartRuleSelectorPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x4,
  );
  static const EdgeInsets arenaSmartRuleCompactSelectorPadding =
      EdgeInsets.symmetric(horizontal: x3, vertical: x3);
  static const EdgeInsets arenaSmartRuleTilePadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets arenaSmartRuleEdgeFieldPadding = EdgeInsets.only(
    top: x4,
  );
  static const EdgeInsets arenaSmartRuleSwitchRowPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets arenaSmartRuleSummaryRowPadding =
      EdgeInsets.symmetric(vertical: x2);
  static const double arenaStudioStepperLineHeight =
      arenaSmartRuleStepperLineHeight;
  static const double arenaStudioStepDot = arenaSmartRuleStepDot;
  static const double arenaStudioStepIcon = arenaSmartRuleStepIcon;
  static const double arenaStudioStepLabelLineHeight = 1.1;
  static const double arenaStudioStepIconBox = arenaBridgeIconBox;
  static const double arenaStudioDescriptionLineHeight =
      arenaReportNoticeLineHeight;
  static const double arenaStudioTemplateIconBox = 44;
  static const double arenaStudioTemplateGlyph = arenaPresetStepDot;
  static const double arenaStudioSelectedIcon = arenaBridgeGlyph;
  static const double arenaStudioLockIcon = arenaSmartRuleIcon;
  static const double arenaStudioTemplateLineHeight = 1.35;
  static const double arenaStudioCommunityIcon = arenaSmartRuleIcon;
  static const double arenaStudioFeeIconBox = arenaSafetyIconBox;
  static const double arenaStudioFeeBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaStudioFeeInfoIcon = iconSm;
  static const double arenaStudioFeeChevron = arenaPresetHeaderIcon;
  static const double arenaStudioFeeDetailIcon = arenaSmartRuleSmallIcon;
  static const double arenaStudioFooterButton = searchBarCompactHeight;
  static const double arenaStudioFooterContinueWidth = 148;
  static const double arenaStudioFooterSubmitWidth = 172;
  static const double arenaStudioFooterStateIcon = arenaPresetHeaderIcon;
  static const double arenaStudioFooterToolButton = arenaBridgeIconBox;
  static const EdgeInsets arenaStudioStepperPadding = EdgeInsets.only(top: x2);
  static const EdgeInsets arenaStudioStepperLineMargin = EdgeInsets.only(
    bottom: x5,
  );
  static const EdgeInsets arenaStudioCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaStudioTemplatePadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaStudioFeeTogglePadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets arenaStudioFeeDetailPadding = EdgeInsets.only(
    top: x2,
  );
  static const EdgeInsets arenaStudioFooterCtaPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const double arenaCreatorEmptyIcon = arenaGovernanceStepDefault;
  static const double arenaCreatorInlineIcon = arenaSmartRuleSmallIcon;
  static const double arenaCreatorAvatar = 64;
  static const double arenaCreatorAvatarGlyph = 34;
  static const double arenaCreatorSectionMarkerWidth = 4;
  static const double arenaCreatorSectionMarkerHeight = 16;
  static const double arenaCreatorChevron = arenaSmartRuleIcon;
  static const double arenaCreatorMetricIconBox = arenaBridgeIconBox;
  static const double arenaCreatorMetricGlyph = arenaReportInlineIcon;
  static const double arenaCreatorTabButtonHeight = arenaStudioFooterButton;
  static const double arenaCreatorModeIconBox = arenaSafetyIconBox;
  static const double arenaCreatorModeGlyph = arenaReportToneIcon;
  static const double arenaCreatorModeChevron = arenaReportToneIcon;
  static const double arenaCreatorAboutLineHeight =
      arenaStudioDescriptionLineHeight;
  static const EdgeInsets arenaCreatorHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets arenaCreatorStatPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x3,
  );
  static const EdgeInsets arenaCreatorTrustActionPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x2,
  );
  static const EdgeInsets arenaCreatorMetricPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaCreatorModeRowPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x4,
  );
  static const EdgeInsets arenaCreatorCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaCreatorEmptyPadding = EdgeInsets.all(x5);
  static const EdgeInsets arenaCreatorPolicyPadding = EdgeInsets.symmetric(
    horizontal: x1,
    vertical: x2,
  );
  static const double arenaGuideCtaIcon = arenaSmartRuleIcon;
  static const EdgeInsets arenaGuideTabsPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const double arenaGuideHeroIcon = arenaStudioSelectedIcon;
  static const double arenaGuideModeIcon = arenaSmartRuleIcon;
  static const EdgeInsets arenaGuideModeSwitchPadding = EdgeInsets.all(x1);
  static const double arenaGuideTimelineLeft = arenaReportInlineIcon;
  static const double arenaGuideTimelineInset = 26;
  static const double arenaGuideTimelineLineWidth = hairlineStroke;
  static EdgeInsets arenaGuideTimelineStepPadding(bool last) =>
      EdgeInsets.only(bottom: last ? 0 : x3);
  static const double arenaGuideStepIconBox = 38;
  static const double arenaGuideStepBorderWidth = hairlineStroke;
  static const double arenaGuideStepGlyph = arenaStudioSelectedIcon;
  static const double arenaGuideStepTextTopPadding = arenaBridgeTinyGap;
  static const EdgeInsets arenaGuideStepTextPadding = EdgeInsets.only(
    top: arenaGuideStepTextTopPadding,
  );
  static const double arenaGuideStepBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaGuideStartIconBox = arenaSafetyIconBox;
  static const double arenaGuideStartGlyph = arenaReportToneIcon;
  static const double arenaGuideReasonIcon = iconSm;
  static const EdgeInsets arenaGuideReasonPadding = EdgeInsets.only(bottom: x1);
  static const double arenaGuideTipsHeaderIcon = 19;
  static const double arenaGuideShowMoreIcon = arenaSmartRuleIcon;
  static const double arenaGuideChecklistIcon = arenaReportInlineIcon;
  static const double arenaGuideChecklistBox = arenaReportInlineIcon;
  static const EdgeInsets arenaGuideChecklistItemPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const double arenaGuideChecklistLineHeight =
      myArenaReportsCompactLineHeight;
  static const double arenaGuideSafetyHeroIcon = arenaGuideTipsHeaderIcon;
  static const double arenaGuideFeatureIconBox = arenaSafetyIconBox;
  static const double arenaGuideFeatureGlyph = arenaReportToneIcon;
  static const double arenaGuideSafetyTipIconBox = arenaGuideStepIconBox;
  static const double arenaGuideSafetyTipGlyph = arenaReportInlineIcon;
  static EdgeInsets arenaGuideSafetyTipPadding(bool last) =>
      EdgeInsets.only(bottom: last ? 0 : x3);
  static const double arenaGuideChevron = arenaReportInlineIcon;
  static const double arenaGuideSupportChevron = arenaSmartRuleSmallIcon;
  static const double arenaGuideAccordionIconBox = arenaBridgeCompactIconBox;
  static const double arenaGuideAccordionGlyph = arenaSmartRuleIcon;
  static const double arenaGuideAccordionDot = x2;
  static const double arenaGuideAccordionChevron = arenaReportInlineIcon;
  static EdgeInsets arenaGuideAccordionListPadding(bool last) =>
      EdgeInsets.only(bottom: last ? 0 : x2);
  static const EdgeInsets arenaGuideAccordionBodyPadding = EdgeInsets.fromLTRB(
    x4,
    x3,
    x4,
    x4,
  );
  static const double arenaGuideAccordionBodyLineHeight = 1.55;
  static const double arenaGuideSmallBadgePadH = 7;
  static const double arenaGuideSmallBadgePadV = 3;
  static const EdgeInsets arenaGuideSmallBadgePadding = EdgeInsets.symmetric(
    horizontal: arenaGuideSmallBadgePadH,
    vertical: arenaGuideSmallBadgePadV,
  );
  static const double arenaGuideSmallBadgeLineHeight =
      myArenaReportsCompactLineHeight;
  static const double arenaGuideMetaChipPadH = x2;
  static const double arenaGuideMetaChipPadV = x1;
  static const EdgeInsets arenaGuideMetaChipPadding = EdgeInsets.symmetric(
    horizontal: arenaGuideMetaChipPadH,
    vertical: arenaGuideMetaChipPadV,
  );
  static const double arenaGuideTipPillIcon = arenaBridgeBadgeIcon;
  static const EdgeInsets arenaGuideTipPillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const double arenaGuideLegendDot = x2;
  static const double arenaFlowMapDividerHeight = dividerHairline;
  static const double arenaFlowMapSmallIcon = arenaSmartRuleSmallIcon;
  static const double arenaFlowMapInlineIcon = arenaReportInlineIcon;
  static const double arenaFlowMapSectionIcon = arenaStudioSelectedIcon;
  static const double arenaFlowMapConnectionLineHeight =
      arenaStudioTemplateLineHeight;
  static const double arenaFlowMapHeroLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaFlowMapBodyLineHeight = arenaSafetyCheckLineHeight;
  static const double arenaFlowMapQaLineHeight = arenaStudioTemplateLineHeight;
  static const double arenaFlowMapMarkerWidth = arenaCreatorSectionMarkerWidth;
  static const double arenaFlowMapMarkerHeight = arenaStudioSelectedIcon;
  static const EdgeInsets arenaFlowMapHeroPadding = EdgeInsets.all(x5);
  static const EdgeInsets arenaFlowMapCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaFlowMapInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets arenaFlowMapStatPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x4,
  );
  static const EdgeInsets arenaFlowMapSectionTogglePadding =
      EdgeInsets.symmetric(vertical: x3);
  static const EdgeInsets arenaFlowMapRouteHeaderPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets arenaFlowMapRouteRowPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const double arenaTrustScoreBox = 72;
  static const double arenaTrustHeroLineHeight = arenaSafetyCheckLineHeight;
  static const double arenaTrustDisclaimerLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaTrustMetricIconBox = arenaCreatorMetricIconBox;
  static const double arenaTrustMetricGlyph = arenaCreatorMetricGlyph;
  static const double arenaTrustCreatorAvatar = arenaSafetyIconBox;
  static const double arenaTrustSafetyIcon = arenaGuideFeatureGlyph;
  static const EdgeInsets arenaTrustCardPadding = EdgeInsets.all(x4);
  static const double arenaVerifiedHeroTextMaxWidth = 360;
  static const double arenaVerifiedHeroIconBox = x7 + x5;
  static const double arenaVerifiedHeroLineHeight =
      arenaGuideAccordionBodyLineHeight;
  static const double arenaVerifiedInfoIcon = arenaStudioSelectedIcon;
  static const double arenaVerifiedFeatureIcon = statusPillIconSizeSm;
  static const double arenaVerifiedFeatureLineHeight =
      arenaStudioDescriptionLineHeight;
  static const EdgeInsets arenaVerifiedInfoPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaVerifiedFeatureIconPadding = EdgeInsets.only(
    top: x1,
  );
  static const double arenaResolutionBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const double arenaStateCardIcon = arenaReportInlineIcon;
  static const double arenaStateCardBodyLineHeight =
      arenaStudioDescriptionLineHeight;
  static const EdgeInsets arenaStateCardPaddingCompact = EdgeInsets.all(x3);
  static const EdgeInsets arenaStateCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets arenaStateCardIconPadding = EdgeInsets.all(x2);
  static const EdgeInsets arenaStateCardMetricPadding = EdgeInsets.only(
    top: x2,
  );
  static const EdgeInsets arenaStateCardPillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets earnPaddingX1 = EdgeInsets.all(x1);
  static const EdgeInsets earnPaddingX2 = EdgeInsets.all(x2);
  static const EdgeInsets earnPaddingX3 = EdgeInsets.all(x3);
  static const EdgeInsets earnPaddingX4 = EdgeInsets.all(x4);
  static const EdgeInsets earnPaddingX5 = EdgeInsets.all(x5);
  static const EdgeInsets earnPaddingX6 = EdgeInsets.all(x6);
  static const EdgeInsets earnHorizontalPaddingX2 = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const EdgeInsets earnHorizontalPaddingX3 = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets earnHorizontalPaddingX4 = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets earnPillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets earnPillPaddingLarge = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets earnSmallPillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets earnCardPaddingX5 = EdgeInsets.all(x5);
  static const EdgeInsets earnCardPaddingX4 = EdgeInsets.all(x4);
  static const EdgeInsets earnCardPaddingX3 = EdgeInsets.all(x3);
  static const EdgeInsets earnCardPaddingX4TopX5 = EdgeInsets.fromLTRB(
    x4,
    x5,
    x4,
    x4,
  );
  static const EdgeInsets earnCardPaddingX4X3 = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets earnCardPaddingX4X7 = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x7,
  );
  static const EdgeInsets earnCardPaddingX2X3 = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x3,
  );
  static const EdgeInsets earnCardPaddingX2X4 = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x4,
  );
  static const EdgeInsets earnCardPaddingX3X2 = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets earnCardPaddingX3X4 = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x4,
  );
  static const EdgeInsets earnWidePillPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets earnStaticSelectPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x4,
  );
  static const EdgeInsets earnVerticalPaddingX1 = EdgeInsets.symmetric(
    vertical: x1,
  );
  static const EdgeInsets earnVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets earnVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets earnVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets earnTopPaddingX1 = EdgeInsets.only(top: x1);
  static const EdgeInsets earnTopPaddingX2 = EdgeInsets.only(top: x2);
  static const EdgeInsets earnTopPaddingX3 = EdgeInsets.only(top: x3);
  static const EdgeInsets earnTopPaddingX4 = EdgeInsets.only(top: x4);
  static const EdgeInsets earnTopPaddingX5 = EdgeInsets.only(top: x5);
  static const EdgeInsets earnBottomPaddingX1 = EdgeInsets.only(bottom: x1);
  static const EdgeInsets earnBottomPaddingX2 = EdgeInsets.only(bottom: x2);
  static const EdgeInsets earnBottomPaddingX3 = EdgeInsets.only(bottom: x3);
  static const EdgeInsets earnContentMargin = EdgeInsets.all(contentPad);
  static const EdgeInsets earnContentHorizontalPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets earnSheetContentPadding = EdgeInsets.fromLTRB(
    contentPad,
    x5,
    contentPad,
    x6,
  );
  static const EdgeInsets earnSurfaceTabsPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    zero,
  );
  static const EdgeInsets earnInlineMarginX1 = EdgeInsets.symmetric(
    horizontal: x1,
  );
  static EdgeInsets earnLeftPaddingX2(bool enabled) =>
      EdgeInsets.only(left: enabled ? x2 : zero);
  static const EdgeInsets earnBulletTopMarginX3 = EdgeInsets.only(top: x3);
  static const EdgeInsets earnDisclosurePanelPadding = EdgeInsets.fromLTRB(
    x4,
    x3,
    x4,
    x4,
  );
  static const EdgeInsets earnDisclosureDetailsPadding = EdgeInsets.fromLTRB(
    x4,
    x4,
    x4,
    x3,
  );
  static EdgeInsets earnBottomInsetPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets earnSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(x5, x4, x5, bottomInset + x6);
  static const double earnTermsHeroIconBox = 48;
  static const double earnTermsHeroBorderWidth = borderWidth;
  static const double earnTermsHeroIcon = 24;
  static const double earnTermsActionHeight = searchBarCompactHeight;
  static const double earnTermsMetaIcon = iconSm;
  static const double earnTermsNoticeIcon = arenaStudioSelectedIcon;
  static const double earnTermsSectionChevron = arenaPresetStepDot;
  static const double earnTermsParagraphLineHeight = 1.7;
  static const double earnTermsAcceptanceBox = arenaPresetStepDot;
  static const double earnTermsAcceptanceTopMargin = arenaBridgeTinyGap;
  static const double earnTermsAcceptanceIcon = arenaPresetHeaderIcon;
  static const double earnWithdrawalInfoMinHeight = 104;
  static const double earnWithdrawalTabMinHeight = 54;
  static const double earnWithdrawalBorderWidth = borderWidth;
  static const double earnWithdrawalInfoIcon = earnTermsHeroIcon;
  static const double earnWithdrawalInfoLineHeight = 1.6;
  static const double earnWithdrawalProcessIconBox = 42;
  static const double earnWithdrawalProcessIcon = 21;
  static const double earnWithdrawalProcessLineHeight =
      arenaReportActionLineHeight;
  static const double earnWithdrawalTimelineMinHeight = 122;
  static const double earnWithdrawalTimelineMinHeightTall = 152;
  static const double earnWithdrawalTimelineValueLineHeight =
      arenaVerifiedFeatureLineHeight;
  static const double earnWithdrawalPenaltyBodyLineHeight = 1.65;
  static const double earnWithdrawalFormulaIcon = arenaGuideFeatureGlyph;
  static const double earnWithdrawalEmergencyIconBox = earnTermsHeroIconBox;
  static const double earnWithdrawalEmergencyStepBox = buttonCompact;
  static const double earnWithdrawalEmergencyStepLineHeight =
      arenaVerifiedFeatureLineHeight;
  static const double earnWithdrawalTimerIcon = arenaSmartRuleSmallIcon;
  static const double earnWithdrawalFeeTileWidth = 174;
  static const double earnWithdrawalFeeTileMinHeight = 84;
  static const double earnWithdrawalFeeLineHeight =
      arenaStudioTemplateLineHeight;
  static const double earnWithdrawalSheetRadius = 28;
  static const double earnWithdrawalSheetHandleWidth = 42;
  static const double earnWithdrawalSheetHandleHeight = x1;
  static const double earnWithdrawalSheetHandleRadius = arenaBridgeTinyGap;
  static const double earnWithdrawalNoticeIcon = arenaReportInlineIcon;
  static const double earnWithdrawalNoticeLineHeight =
      arenaGuideAccordionBodyLineHeight;
  static const double earnWithdrawalBulletTopPadding = 7;
  static const double earnWithdrawalBulletSize = 5;
  static const double earnWithdrawalBulletLineHeight =
      arenaReportActionLineHeight;
  static const double earnWithdrawalBadgePadV = arenaGuideSmallBadgePadV;
  static const double earnWithdrawalBadgeLineHeight =
      arenaStudioStepLabelLineHeight;
  static const EdgeInsets earnWithdrawalBulletPadding = EdgeInsets.only(
    top: earnWithdrawalBulletTopPadding,
  );
  static const EdgeInsets earnWithdrawalBadgePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: earnWithdrawalBadgePadV,
  );
  static const double earnAnalyticsActionHeight = arenaSafetyIconBox;
  static const double earnAnalyticsSummaryIcon = arenaPresetHeaderIcon;
  static const double earnAnalyticsInlineIcon = arenaReportInlineIcon;
  static const double earnAnalyticsCaptionLineHeight =
      arenaStudioTemplateLineHeight;
  static const double earnAnalyticsEarningsChartHeight = 214;
  static const int earnAnalyticsGridColumns = 2;
  static const double earnAnalyticsAssetDot = x2;
  static const double earnAnalyticsChartHeight = 220;
  static const double earnAnalyticsRoiFontSize = 19;
  static const double earnAnalyticsProgressMinHeight = 6;
  static const double earnAnalyticsAvatarBox = earnWithdrawalProcessIconBox;
  static const double earnAnalyticsInsightIcon = arenaStudioSelectedIcon;
  static const double earnAnalyticsInsightLineHeight =
      arenaVerifiedFeatureLineHeight;
  static const double earnAnalyticsFooterLineHeight =
      arenaReportActionLineHeight;
  static const double earnAnalyticsAxisWidth = earnWithdrawalProcessIconBox;
  static const double earnAnalyticsLegendMarkerWidth = statusPillIconSizeSm;
  static const double earnAnalyticsLegendMarkerHeight =
      arenaBridgeTinyGap + dividerHairline;
  static const double savingsWhatIfHeroIcon = arenaGuideFeatureGlyph;
  static const double savingsWhatIfBadgeIcon = iconSm;
  static const double savingsWhatIfSectionMarkerWidth =
      arenaCreatorSectionMarkerWidth;
  static const double savingsWhatIfSectionMarkerHeight =
      arenaCreatorSectionMarkerHeight;
  static const double savingsWhatIfRiskPillPadV = arenaBridgeTinyGap;
  static const double savingsWhatIfRiskPillLineHeight =
      arenaBridgeHeroLineHeight;
  static const double savingsWhatIfRoundIconBox = arenaSafetyIconBox;
  static const double savingsWhatIfInlineIcon = arenaReportInlineIcon;
  static const double savingsWhatIfScoreRing = arenaCreatorAvatar;
  static const double savingsWhatIfLegendDot = 9;
  static const double savingsWhatIfAssetBadge = 31;
  static const double savingsWhatIfAssetFontSize = 8;
  static const double savingsWhatIfStressLabelWidth = 88;
  static const double savingsWhatIfStressProgressHeight = x2;
  static const double savingsWhatIfStressValueWidth = 52;
  static const double savingsWhatIfEmptyIcon = searchBarCompactHeight;
  static const double savingsWhatIfComparisonChartHeight = 150;
  static const double savingsRebalanceInlineIcon = arenaReportInlineIcon;
  static const double savingsRebalanceAssetBadge = 32;
  static const double savingsRebalanceLockIcon = arenaPresetHeaderIcon;
  static const double savingsRebalanceTrackHeight = 6;
  static const double savingsRebalanceIconBox = arenaSafetyIconBox;
  static const double savingsRebalanceIcon = arenaGuideFeatureGlyph;
  static const double savingsRebalanceDriftChartHeight = 160;
  static const double savingsRebalanceSelectedIcon = arenaSmartRuleIcon;
  static const double savingsRebalanceCompareLabelWidth = 74;
  static const double savingsRebalanceLegendDot = 7;
  static const double stakingRiskDisclosureWarningMinHeight = 144;
  static const double stakingRiskDisclosureBorderWidth = borderWidth;
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
      myArenaReportsCompactLineHeight;
  static const double stakingRiskDisclosureProductMinHeight = 94;
  static const double stakingRiskDisclosureProductMinHeightTall = 125;
  static const double stakingRiskDisclosureCategoryIconBox =
      searchBarCompactHeight;
  static const double stakingRiskDisclosureCategoryIcon = arenaPresetStepDot;
  static const double stakingRiskDisclosureDetailBulletTop =
      earnWithdrawalBulletTopPadding;
  static const EdgeInsets stakingRiskDisclosureDetailBulletPadding =
      EdgeInsets.only(top: stakingRiskDisclosureDetailBulletTop);
  static const double stakingRiskDisclosureDetailBullet =
      arenaCreatorSectionMarkerWidth;
  static const double stakingRiskDisclosureAssessmentIconBox =
      earnTermsHeroIconBox;
  static const double stakingRiskDisclosureAssessmentIcon = earnTermsHeroIcon;
  static const double stakingRiskDisclosureCtaHeight = searchBarCompactHeight;
  static const double stakingRiskDisclosureSectionMarkerWidth =
      arenaCreatorSectionMarkerWidth;
  static const double stakingRiskDisclosureSectionMarkerHeight =
      arenaPresetHeaderIcon;
  static const double stakingRiskDisclosureSectionMarkerRadius =
      arenaBridgeTinyGap;
  static const double stakingRiskDashboardFooterLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double stakingRiskDashboardScoreRing = 128;
  static const double stakingRiskDashboardScoreBorderWidth = 4;
  static const double stakingRiskDashboardScoreFontSize = 36;
  static const double stakingRiskDashboardSummaryLineHeight =
      earnWithdrawalProcessLineHeight;
  static const double stakingRiskDashboardMetricLineHeight =
      arenaStudioTemplateLineHeight;
  static const double stakingRiskDashboardExposureChartHeight = 180;
  static const double stakingRiskDashboardExposurePieSize = 148;
  static const double stakingRiskDashboardEventLineHeight =
      arenaSafetyCheckLineHeight;
  static const int stakingRiskDashboardActionGridColumns = 2;
  static const double stakingRiskDashboardActionGridAspect = 1.55;
  static const double savingsLadderHeroDot = savingsRebalanceTrackHeight;
  static const double savingsLadderTemplateLineHeight = 1.25;
  static const double savingsLadderRungIndexBox = arenaGovernanceStepDefault;
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
      arenaPresetCaptionLineHeight;
  static const double savingsLadderSectionMarkerWidth =
      arenaCreatorSectionMarkerWidth;
  static const double savingsLadderSectionMarkerHeight = arenaPresetHeaderIcon;
  static const double savingsLadderRoundIcon = arenaSafetyIconBox;
  static const double savingsLadderDisclaimerLineHeight =
      arenaStudioTemplateLineHeight;
  static const double savingsLadderSheetRadius = 24;
  static const double savingsNotificationSummaryBorderWidth = borderWidth;
  static const double savingsNotificationSummaryLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double savingsNotificationCardLineHeight =
      arenaSafetyCheckLineHeight;
  static const double savingsNotificationAlertLineHeight = 1.32;
  static const double savingsNotificationHistoryTitleLineHeight =
      savingsLadderTemplateLineHeight;
  static const double savingsNotificationHistoryBodyLineHeight =
      arenaReportActionLineHeight;
  static const double savingsNotificationIconBox = 40;
  static const double savingsNotificationSummaryIconBox =
      searchBarCompactHeight;
  static const double savingsNotificationSummaryIcon = 22;
  static const double savingsNotificationInlineIcon = arenaReportInlineIcon;
  static const double savingsNotificationAlertIcon = 19;
  static const double savingsNotificationActionIcon = 20;
  static const double savingsNotificationSeverityPadV = arenaBridgeTinyGap;
  static const double savingsNotificationSwitchWidth = searchBarCompactHeight;
  static const double savingsNotificationSwitchHeight =
      savingsLadderTimelineBarHeight;
  static const double savingsNotificationSwitchPadding =
      savingsNotificationSeverityPadV + arenaBridgeTinyGap;
  static const EdgeInsets savingsNotificationSwitchInset = EdgeInsets.all(
    savingsNotificationSwitchPadding,
  );
  static const double savingsNotificationSwitchThumb = arenaPresetHeaderIcon;
  static const double savingsNotificationTokenSwitchWidth = 46;
  static const double savingsNotificationTokenSwitchHeight = statusPillHeightMd;
  static const double savingsNotificationTokenSwitchPadding =
      arenaBridgeTinyGap;
  static const EdgeInsets savingsNotificationTokenSwitchInset = EdgeInsets.all(
    savingsNotificationTokenSwitchPadding,
  );
  static const double savingsNotificationTokenSwitchThumb =
      bottomNavBadgeMinWidth + savingsNotificationSeverityPadV * 2;
  static const double stakingEmergencySheetBodyLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double stakingEmergencyActionLineHeight =
      arenaReportActionLineHeight;
  static const double stakingEmergencyUseCaseIcon =
      arenaPresetHeaderIcon + arenaBridgeTinyGap;
  static const double stakingInsuranceTabIndicatorHeight =
      tabBarUnderlineHeight;
  static const double stakingInsuranceShieldIconBox = 60;
  static const double stakingInsuranceShieldBorderWidth = hairlineStroke;
  static const int stakingInsuranceBenefitGridColumns = 2;
  static const double stakingInsuranceBenefitGridAspect =
      stakingRiskDashboardActionGridAspect;
  static const double stakingProofInfoLineHeight =
      earnWithdrawalNoticeLineHeight;
  static const double stakingProofTabIndicatorHeight = tabBarUnderlineHeight;
  static const double stakingProofTrendChartHeight = 210;
  static const double stakingProofBodyLineHeight = arenaReportActionLineHeight;
  static const double stakingProofReportLineHeight =
      earnWithdrawalProcessLineHeight;
  static const double stakingProofProgressRing = 160;
  static const double stakingProofProgressBorderWidth = x1;
  static const double stakingProofExternalIcon = arenaSmartRuleIcon;
  static const double earnGuideProgressHeight = earnAnalyticsProgressMinHeight;
  static const double earnGuideParagraphLineHeight = 1.65;
  static const double earnGuideHeroLineHeight = stakingProofInfoLineHeight;
  static const double earnGuideCardLineHeight =
      stakingRiskDashboardMetricLineHeight;
  static const double earnGuideBodyLineHeight =
      stakingEmergencyActionLineHeight;
  static const double earnGuideTipLineHeight = stakingProofReportLineHeight;
  static const double earnGuideBulletTop = earnWithdrawalBulletTopPadding;
  static const double earnGuideBulletSize = arenaCreatorSectionMarkerWidth;
  static const double earnGuidePillLineHeight = 1;
  static const double earnFaqQuestionLineHeight =
      savingsLadderTemplateLineHeight;
  static const double earnFaqAnswerLineHeight = earnWithdrawalInfoLineHeight;
  static const double earnFaqDividerHeight = dividerHairline;
  static const double savingsAutoPilotApprovalButtonHeight =
      savingsNotificationIconBox;
  static const int savingsAutoPilotMetricGridColumns = 2;
  static const double savingsAutoPilotMetricGridAspect = 1.95;
  static const double savingsAutoPilotRiskProgressHeight =
      earnWithdrawalBulletSize;
  static const double savingsAutoPilotIconBadge = savingsNotificationIconBox;
  static const double savingsAutoPilotSectionMarkerWidth = earnGuideBulletSize;
  static const double savingsAutoPilotSectionMarkerHeight =
      iconSm + earnWithdrawalBulletSize;
  static const double savingsPortfolioHeroFontSize = 27;
  static const double savingsPortfolioEarningsFontSize = 30;
  static const double savingsPortfolioHeroIconButton = 32;
  static const double savingsPortfolioActionHeight = searchBarCompactHeight;
  static const double savingsPortfolioSectionMarkerWidth = earnGuideBulletSize;
  static const double savingsPortfolioSectionMarkerHeight = iconSm + x1;
  static const double savingsPortfolioDaysLineHeight = 1.1;
  static const double savingsPortfolioSecondaryButtonHeight = 38;
  static const double savingsPortfolioDonutHeight = 150;
  static const double savingsPortfolioDonutDiameter = 116;
  static const double savingsPortfolioDonutStrokeWidth = statusPillHeightMd;
  static const double savingsPortfolioAllocationDot = iconSm;
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
  static const double stakingTaxBorderWidth = borderWidth;
  static const double stakingTaxCalculatorIcon = statusPillHeightMd;
  static const double stakingTaxResultFontSize = searchBarFont;
  static const double stakingTaxResultFontSizeLarge = arenaSmartRuleIcon;
  static const double stakingTaxJurisdictionMetricMinHeight = 96;
  static const double stakingTaxJurisdictionMetricLineHeight =
      arenaSafetyCheckLineHeight;
  static const double stakingTaxResourceIcon = iconSm + arenaBridgeTinyGap * 2;
  static const double stakingTaxResourceExternalIcon = arenaPresetHeaderIcon;
  static const double stakingTaxDisclaimerMinHeight = 136;
  static const double stakingTaxTabsMinHeight =
      stakingRiskDisclosureTabsMinHeight;
  static const double stakingTaxDisclaimerIcon = earnTermsHeroIcon;
  static const double stakingTaxCodeBadgeSmall = savingsLadderTimelineBarHeight;
  static const double stakingTaxCodeBadgeRegular = 36;
  static const double stakingTaxCodeBadgeLarge = earnTermsHeroIconBox;
  static const double stakingTaxCodeFontSmall = statusPillIconSizeSm;
  static const double stakingTaxCodeFontRegular = searchBarFont;
  static const double stakingTaxCodeFontLarge = arenaSmartRuleIcon;
  static const double stakingGovernanceVotingPowerFontSize = statusPillHeightMd;
  static const double stakingGovernancePillLineHeight = earnGuidePillLineHeight;
  static const double stakingGovernanceInfoLineHeight =
      stakingProofInfoLineHeight;
  static const int stakingGovernanceGridColumns = 2;
  static const double stakingGovernanceGridAspect = 1.75;
  static const double stakingGovernanceStatFontSize =
      savingsNotificationTokenSwitchThumb;
  static const double stakingGovernanceDividerHeight = dividerHairline;
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
  static const double stakingAssessmentScoreBorderWidth = x1;
  static const double stakingAssessmentBodyLineHeight =
      stakingProofInfoLineHeight;
  static const double stakingAssessmentFooterLineHeight =
      stakingProofReportLineHeight;
  static const double stakingAssessmentQuestionFontSize =
      savingsNotificationInlineIcon;
  static const double stakingAssessmentQuestionLineHeight =
      stakingRiskDashboardMetricLineHeight;
  static const double stakingAssessmentOptionBorderWidth = borderWidth;
  static const double stakingAssessmentOptionLineHeight = 1.3;
  static const double stakingAssessmentHelpLineHeight = earnGuideBodyLineHeight;
  static const double stakingRiskScoreBorderWidth =
      stakingRiskDashboardScoreBorderWidth;
  static const double stakingRiskScorePillIcon = stakingEmergencyUseCaseIcon;
  static const double stakingRiskScoreRadarHeight = earnAnalyticsChartHeight;
  static const double stakingNotificationsSwitchWidth = earnTermsHeroIconBox;
  static const double stakingNotificationsSwitchHeight = statusPillHeightMd;
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
  static const double stakingHistoryPillPadV = x1;
  static const double stakingHistoryPillLineHeight = earnGuidePillLineHeight;
  static const double stakingHistoryFooterLineHeight =
      stakingProofReportLineHeight;
  static const double stakingAuditBodyLineHeight = stakingProofInfoLineHeight;
  static const int stakingAuditPayoutGridColumns = 2;
  static const double stakingAuditPayoutGridAspect = 2.55;
  static const double stakingAuditFooterLineHeight =
      stakingProofReportLineHeight;
  static const double stakingAuditRoundIconBox = earnTermsHeroIconBox;
  static const double earnExportHeroStatFontSize = x6;
  static const double earnExportTitleMarkerWidth = arenaBridgeTinyGap;
  static const double earnExportTitleMarkerHeight =
      statusPillIconSizeLg + dividerHairline;
  static const double earnExportFormatIcon = earnTermsHeroIcon;
  static const double earnExportCardLineHeight =
      savingsLadderTemplateLineHeight;
  static const double earnExportDescriptionLineHeight =
      stakingAssessmentOptionLineHeight - 0.02;
  static const double earnExportWarningLineHeight =
      stakingRiskDashboardActionGridAspect - 0.2;
  static const double earnExportSelectionDot = savingsNotificationActionIcon;
  static const double earnExportSelectionDotInner = statusPillIconSizeSm;
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
      tabBarUnderlineHeight;
  static const double stakingTransactionReportingDividerHeight =
      dividerHairline;
  static const double stakingTransactionReportingMetricLineHeight =
      stakingRiskDashboardActionGridAspect - 0.05;
  static const double stakingTransactionReportingMethodLineHeight =
      stakingRiskDashboardActionGridAspect - 0.1;
  static const double stakingTransactionReportingNoticeLineHeight =
      stakingProofReportLineHeight;
  static const double savingsGoalHeroProgressRing = 76;
  static const double savingsGoalHeroProgressStroke = x2;
  static const double savingsGoalCardProgressRing = 52;
  static const double savingsGoalCardProgressStroke =
      arenaBridgeTinyGap + dividerHairline;
  static const double savingsGoalDetailProgressRing =
      earnWithdrawalFeeTileMinHeight;
  static const double savingsGoalDetailProgressStroke =
      savingsRebalanceTrackHeight;
  static const double savingsGoalTimelineDividerHeight = dividerHairline;
  static const double savingsGoalMilestoneBorderWidth = borderWidth;
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
  static const double savingsRecommendationsDividerHeight = dividerHairline;
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
  static const double autoCompoundSettingsDividerHeight = dividerHairline;
  static const double stakingAutoCompoundPlanBorderWidth = borderWidth;
  static const double stakingAutoCompoundChartHeight = 190;
  static const double stakingAutoCompoundAxisFontSize = 9;
  static const double stakingAutoCompoundResultMarkerHeight = hairlineStroke;
  static const double stakingAutoCompoundHeroStatFontSize =
      savingsPortfolioEarningsFontSize;
  static const double stakingAutoCompoundHeroIconBorderWidth = x1;
  static const double stakingAutoCompoundCheckBorderWidth = borderWidth;
  static const double stakingAutoCompoundToggleWidth = earnTermsHeroIconBox;
  static const double stakingAutoCompoundToggleHeight =
      statusPillHeightMd + hairlineStroke;
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
  static const double stakingCustodyActionIcon = x6;
  static const double stakingCustodyActionBorderWidth = borderWidth;
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
      savingsNotificationAlertIcon - hairlineStroke;
  static const double stakingContingencyFooterLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingSlashingBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const int stakingSlashingStatsGridColumns = 2;
  static const double stakingSlashingStatsGridAspect = 1.65;
  static const double stakingSlashingMeasureLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double stakingSlashingTabIndicatorHeight = tabBarUnderlineHeight;
  static const double stakingSlashingFooterLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingApiBodyLineHeight = stakingCustodyBodyLineHeight;
  static const double stakingApiStatTileHeight = 66;
  static const double stakingApiTabIndicatorHeight = tabBarUnderlineHeight;
  static const double stakingApiCopyIcon = stakingTaxDetailFontSize;
  static const double stakingApiFooterLineHeight = stakingCustodyBodyLineHeight;
  static const double stakingApiEndpointBodyLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingApiEndpointDescriptionLineHeight =
      stakingCustodyDescriptionLineHeight;
  static const double stakingApiDividerHeight = dividerHairline;
  static const double stakingApiSandboxLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double stakingIntegrationBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingDeveloperConsoleBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double savingsHistoryFilterButton = 38;
  static const double savingsHistoryTransactionIcon = searchBarIcon;
  static const double savingsHistoryMetaFontSize = stakingTaxDetailFontSize;
  static const double savingsHistoryBadgeLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double savingsHistoryDividerHeight = dividerHairline;
  static const double stakingEarningsEventIcon = savingsNotificationAlertIcon;
  static const double stakingEarningsPillLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double stakingEarningsInfoLineHeight =
      earnExportWarningLineHeight;
  static const double stakingEarningsTabHeight = 53;
  static const int stakingEarningsCalendarColumns = 7;
  static const double stakingEarningsEventDotGap = hairlineStroke;
  static const double stakingEarningsLegendWidth = 148;
  static const double stakingValidatorHealthBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingValidatorHealthDividerHeight = dividerHairline;
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
  static const double stakingValidatorSelectionDividerHeight = dividerHairline;
  static const double stakingValidatorSelectionPillLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double stakingValidatorSelectionDetailLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingProductMetricFontSize =
      savingsPortfolioEarningsFontSize;
  static const double stakingProductTabIndicatorHeight = tabBarUnderlineHeight;
  static const double stakingProductDividerHeight = dividerHairline;
  static const double stakingProductBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double stakingProductCompactBodyLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double stakingProductDonutChartHeight =
      stakingCustodyHotColdChart;
  static const double stakingProductHistoryChartHeight =
      earnAnalyticsChartHeight;
  static const double stakingProductLegendWidth = 160;
  static const double stakingProductIconBorderWidth = hairlineStroke;
  static const int stakingProductGridColumns = 2;
  static const double stakingProductLiquidBenefitAspect = 1.35;
  static const double stakingProductInstitutionalFeatureAspect =
      stakingRiskDashboardActionGridAspect;
  static const double savingsConsumerHeroAmountFontSize = statusPillHeightMd;
  static const double savingsConsumerCaptionFontSize = stakingTaxDetailFontSize;
  static const double savingsConsumerProductRateFontSize =
      savingsNotificationSummaryIcon;
  static const double savingsConsumerActionHeight = stakingTaxCodeBadgeRegular;
  static const double savingsConsumerStatFontSize =
      savingsPortfolioHeroIconButton;
  static const double savingsConsumerDividerHeight = dividerHairline;
  static const double savingsConsumerPillLineHeight =
      savingsGoalMilestoneLineHeight;
  static const double savingsConsumerBodyLineHeight =
      stakingCustodyBodyLineHeight;
  static const double savingsConsumerCompactBodyLineHeight =
      stakingTransactionReportingMetricLineHeight;
  static const double savingsConsumerDescriptionLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double savingsConsumerBorderWidth = borderWidth;
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
  static const double stakingCommunityDividerHeight = dividerHairline;
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
      searchBarCompactHeight + dividerHairline;
  static const double savingsGoalSheetTitleLineHeight =
      stakingEarnHeroTabLabelLineHeight;
  static const double savingsLadderGridAspect = 1.72;
  static const double stakingApiAuthLineHeight =
      stakingApiEndpointBodyLineHeight;
  static const double stakingSlashingStatsChartHeight = 172;
  static const double stakingAnalyticsMetricGridAspect =
      stakingAuditPayoutGridAspect;
  static const double dcaMainInlineIcon = searchBarIcon;
  static EdgeInsets dcaBottomInsetPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets dcaContentPadding = EdgeInsets.all(contentPad);
  static const EdgeInsets dcaPaddingX1 = EdgeInsets.all(x1);
  static const EdgeInsets dcaPaddingX2 = EdgeInsets.all(x2);
  static const EdgeInsets dcaPaddingX3 = EdgeInsets.all(x3);
  static const EdgeInsets dcaPaddingX4 = EdgeInsets.all(x4);
  static const EdgeInsets dcaPaddingX5 = EdgeInsets.all(x5);
  static const EdgeInsets dcaTopPaddingX1 = EdgeInsets.only(top: x1);
  static const EdgeInsets dcaTopPaddingX2 = EdgeInsets.only(top: x2);
  static const EdgeInsets dcaTopPaddingX3 = EdgeInsets.only(top: x3);
  static const EdgeInsets dcaTopPaddingX4 = EdgeInsets.only(top: x4);
  static const EdgeInsets dcaTopPaddingX5 = EdgeInsets.only(top: x5);
  static const EdgeInsets dcaBottomPaddingX2 = EdgeInsets.only(bottom: x2);
  static const EdgeInsets dcaBottomPaddingX3 = EdgeInsets.only(bottom: x3);
  static const EdgeInsets dcaBottomPaddingX4 = EdgeInsets.only(bottom: x4);
  static const EdgeInsets dcaHorizontalPaddingX1 = EdgeInsets.symmetric(
    horizontal: x1,
  );
  static const EdgeInsets dcaHorizontalPaddingX3 = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets dcaVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets dcaVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets dcaChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets dcaTinyChipPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets dcaButtonChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets dcaScoreChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets dcaPrimaryChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets dcaMetricCellPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x4,
  );
  static const EdgeInsets dcaFrequencyTilePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x4,
  );
  static const EdgeInsets dcaSectionHeaderPadding = EdgeInsets.fromLTRB(
    x5,
    x5,
    x5,
    x3,
  );
  static const EdgeInsets dcaChartPadding = EdgeInsets.fromLTRB(x3, 0, x3, x2);
  static const EdgeInsets dcaChartFooterPadding = EdgeInsets.fromLTRB(
    x5,
    0,
    x5,
    x4,
  );
  static EdgeInsets dcaBottomSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, 0, contentPad, bottomInset);
  static const EdgeInsets dcaSheetMargin = EdgeInsets.fromLTRB(
    contentPad,
    0,
    contentPad,
    contentPad,
  );
  static const double dcaMainHeroAmountFontSize = 29;
  static const double dcaMainTightLineHeight = savingsGoalMilestoneLineHeight;
  static const double dcaMainSparklineWidth = 96;
  static const double dcaMainStatCardHeight = 78;
  static const double dcaMainStatLabelLineHeight = 1.15;
  static const double dcaMainStatValueFontSize =
      savingsConsumerProductRateFontSize;
  static const double dcaMainToolCardHeight = 98;
  static const double dcaMainToolIconBox = earnWithdrawalProcessIconBox;
  static const double dcaMainToolIcon = savingsConsumerProductRateFontSize;
  static const double dcaMainToolSubtitleLineHeight =
      stakingEarnHeroTabLabelLineHeight;
  static const double dcaMainPlanStatusBarHeight = x1;
  static const double dcaMainActionHeight = searchBarCompactHeight;
  static const double dcaMainAssetIconBox = savingsNotificationTokenSwitchWidth;
  static const double dcaMainAssetIcon = savingsConsumerHeroAmountFontSize + x1;
  static const double dcaMainHistoryChartHeight =
      stakingProductHistoryChartHeight;
  static const double dcaMultiTabIndicatorHeight = hairlineStroke;
  static const double dcaMultiTabIndicatorWidth = 116;
  static const double dcaMultiTightLineHeight = dcaMainTightLineHeight;
  static const double dcaMultiIcon = dcaMainInlineIcon;
  static const double dcaMultiToggleWidth = 52;
  static const double dcaMultiToggleHeight = statusPillHeightLg;
  static const double dcaMultiTogglePadding = x1;
  static const double dcaMultiToggleThumb = savingsLadderTimelineBarHeight;
  static const double dcaMultiAllocationChartHeight = 200;
  static const double dcaMultiLegendMarker = stakingApiCopyIcon;
  static const double dcaMultiGrowthChartHeight = 240;
  static const double dcaMultiScoreFontSize =
      savingsConsumerHeroAmountFontSize + hairlineStroke;
  static const double dcaMultiScoreSuffixBottom = x2;
  static const double dcaMultiProgressHeight = savingsRebalanceTrackHeight;
  static const double dcaMultiDot = statusPillIconSizeSm;
  static const double dcaRebalanceBodyLineHeight =
      stakingTransactionReportingMethodLineHeight;
  static const double dcaRebalanceCompactLineHeight =
      earnExportWarningLineHeight;
  static const double dcaRebalanceTightLineHeight = dcaMainTightLineHeight;
  static const double dcaRebalanceRingSize = 132;
  static const double dcaRebalanceIcon = dcaMainInlineIcon;
  static const double dcaRebalanceIconSm = bottomNavBadgeMinWidth;
  static const double dcaRebalanceIconXs = searchBarCompactFont;
  static const double dcaRebalanceConnectorWidth = hairlineStroke;
  static const double dcaRebalanceTileIconBox = dcaMainToolIconBox;
  static const double dcaRebalanceToggleWidth = dcaMultiToggleWidth;
  static const double dcaRebalanceToggleHeight =
      statusPillHeightLg - hairlineStroke;
  static const double dcaRebalanceToggleThumb = dcaMultiToggleThumb;
  static const double dcaScheduleSectionIcon = dcaMainInlineIcon;
  static const double dcaScheduleSectionTitleFontSize = dcaMainInlineIcon;
  static const double dcaScheduleAccentIconBox = 40;
  static const double dcaScheduleSelectedDot = dcaMultiToggleThumb;
  static const double dcaScheduleSelectedDotInner =
      savingsGoalMilestoneFontSize;
  static const double dcaScheduleInfoFontSize = stakingTaxDetailFontSize;
  static const double dcaScheduleSliderTrackHeight =
      savingsRebalanceTrackHeight;
  static const double dcaSmartTabIndicatorHeight = tabBarUnderlineHeight;
  static const double dcaSmartTabIndicatorWidth = dcaMultiTabIndicatorWidth;
  static const double dcaSmartStatsIconBox = 48;
  static const double dcaSmartStatsIcon = savingsConsumerHeroAmountFontSize;
  static const double dcaSmartSectionFontSize = dcaMainInlineIcon;
  static const double dcaSmartInlineIcon = dcaMainInlineIcon;
  static const double dcaSmartButtonHeight = statusPillHeightLg;
  static const double dcaSmartButtonIcon = searchBarFont;
  static const double dcaSmartTinyIcon = stakingApiCopyIcon;
  static const double dcaSmartBadgeLineHeight = dcaRebalanceTightLineHeight;
  static const double dcaOverviewMetaIcon = searchBarFont;
  static const double dcaOverviewMetricIcon = iconSm;
  static const double dcaOverviewMetricLabelLineHeight =
      dcaMainStatLabelLineHeight;
  static const double dcaOverviewInlineIcon = dcaMainInlineIcon;
  static const double dcaOverviewSectionTitleFontSize = dcaMainInlineIcon;
  static const double dcaOverviewHeroFontSize = 31;
  static const double dcaOverviewHeroLineHeight = dcaMainTightLineHeight;
  static const double dcaOverviewPreviewMaxWidth = 360;
  static const EdgeInsets dcaOverviewActionButtonPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x3,
  );
  static const double dcaOverviewSkeletonTitleWidth = 160;
  static const double dcaOverviewSkeletonTitleHeight = searchBarFont;
  static const double dcaOverviewSkeletonToggleSize = iconMd;
  static const double dcaOverviewSkeletonChipWidth = 130;
  static const double dcaOverviewSkeletonMetaWidth = 60;
  static const double dcaOverviewSkeletonMetaHeight = stakingTaxDetailFontSize;
  static const double dcaPerformanceCompareChartHeight = 240;
  static const double dcaPerformanceCompareProgressHeight =
      savingsRebalanceTrackHeight;
  static const double dcaPerformanceCompareRadarHeight = 280;
  static const double dcaPerformanceCompareSmallIcon = stakingApiCopyIcon;
  static const double dcaPerformanceCompareInlineIcon = dcaMainInlineIcon;
  static const double dcaPerformanceCompareTabIndicatorHeight =
      dcaSmartTabIndicatorHeight;
  static const double dcaPerformanceCompareTabIndicatorWidth =
      dcaSmartTabIndicatorWidth;
  static const double dcaPerformanceCompareLegendDot = x3;
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
  static const double dcaPortfolioOptimizerDividerWidth = hairlineStroke;
  static const int dcaPortfolioOptimizerRiskGridColumns = 2;
  static const double dcaPortfolioOptimizerRiskGridAspect = 1.25;
  static const double dcaBacktesterBodyLineHeight = dcaRebalanceBodyLineHeight;
  static const double launchpadLineHeightTight = dcaRebalanceTightLineHeight;
  static const double launchpadLineHeightMicro = 1.05;
  static const double launchpadLineHeightCompact = 1.1;
  static const double launchpadLineHeightLabel =
      dcaOverviewMetricLabelLineHeight;
  static const double launchpadLineHeightShort = dcaDynamicCaptionLineHeight;
  static const double launchpadLineHeightEvent = 1.24;
  static const double launchpadLineHeightBody = dcaDynamicHistoryLineHeight;
  static const double launchpadLineHeightDense =
      dcaPortfolioOptimizerBodyLineHeight;
  static const double launchpadLineHeightReadable = dcaBacktesterBodyLineHeight;
  static const double launchpadLineHeightLong = dcaDynamicDescriptionLineHeight;
  static const double launchpadLineHeightLoose = dcaDynamicExplainerLineHeight;
  static const double launchpadGapXxs = hairlineStroke * 2;
  static const double launchpadGapXs = x1;
  static const double launchpadDividerWidth = hairlineStroke;
  static const double launchpadDividerHeight = hairlineStroke;
  static const double launchpadRadiusXxs = hairlineStroke / 2;
  static const double launchpadBorderWidthFocus = 1.5;
  static const double launchpadBorderWidthStrong = x1 + hairlineStroke;
  static const double launchpadVerticalMarkerWidth = x1;
  static const double launchpadSheetMaxWidth = 440;
  static const double launchpadSheetHandleWidth = 40;
  static const double launchpadSheetHandleWide = 44;
  static const double launchpadSheetHandleHeight = x1 + hairlineStroke;
  static const double launchpadDotXs = x2;
  static const double launchpadDotSm = savingsRebalanceTrackHeight;
  static const double launchpadDotMd = x3;
  static const double launchpadFontXxs = serviceTileBadgeFont;
  static const double launchpadFontXs = stakingAutoCompoundAxisFontSize;
  static const double launchpadFontSm = 10;
  static const double launchpadFontMd = arenaModePredictionActionIcon;
  static const double launchpadFontLg = stakingTaxDetailFontSize;
  static const double launchpadFontXl = dcaMainInlineIcon;
  static const double launchpadFont2xl = dcaMainToolIcon;
  static const double launchpadFont3xl = statusPillHeightMd + launchpadGapXxs;
  static const double launchpadFont4xl = 36;
  static const double launchpadIconXxs = launchpadFontSm;
  static const double launchpadIconXs = stakingApiCopyIcon;
  static const double launchpadIconSm = iconSm;
  static const double launchpadIconMd = searchBarFont;
  static const double launchpadIconLg = myArenaAccentPillIcon;
  static const double launchpadIconXl = bottomNavBadgeMinWidth;
  static const double launchpadIcon2xl = dcaMainInlineIcon;
  static const double launchpadIcon3xl = dcaMainToolIcon;
  static const double launchpadIcon4xl = iconMd;
  static const double launchpadIcon5xl = savingsConsumerHeroAmountFontSize;
  static const double launchpadIcon6xl = dcaOverviewInlineIcon + launchpadGapXs;
  static const double launchpadIcon7xl = buttonCompact;
  static const double launchpadIconHuge = statusPillHeightLg;
  static const double launchpadBox12 = launchpadIconXs;
  static const double launchpadBox17 = launchpadIconXl + hairlineStroke;
  static const double launchpadBox18 = launchpadIcon2xl;
  static const double launchpadBox24 = dcaMultiToggleThumb;
  static const double launchpadBox28 = statusPillHeightMd + launchpadGapXxs;
  static const double launchpadBox30 = savingsPortfolioEarningsFontSize;
  static const double launchpadBox31 = launchpadBox30 + hairlineStroke;
  static const double launchpadBox32 = statusPillHeightLg;
  static const double launchpadBox34 = buttonCompact;
  static const double launchpadBox36 = stakingRiskDashboardScoreFontSize;
  static const double launchpadBox40 = dcaScheduleAccentIconBox;
  static const double launchpadBox42 = dcaRebalanceTileIconBox;
  static const double launchpadBox44 = searchBarCompactHeight;
  static const double launchpadBox48 = dcaSmartStatsIconBox;
  static const double launchpadBox56 = x7 + hairlineStroke;
  static const double launchpadBox58 = launchpadBox56 + launchpadGapXxs;
  static const double launchpadBox60 = launchpadBox58 + launchpadGapXxs;
  static const double launchpadBox64 = 64;
  static const double launchpadBox68 =
      launchpadBox64 + launchpadSheetHandleHeight;
  static const double launchpadBox76 = dcaMainStatCardHeight - launchpadGapXxs;
  static const double launchpadBox104 = 104;
  static const double launchpadBox150 = 150;
  static const double launchpadDcaHistoryChartHeight = 170;
  static const double launchpadPerformanceChartHeight =
      dcaPortfolioOptimizerBacktestChartHeight;
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
  static const EdgeInsets launchpadPaddingX2 = EdgeInsets.all(x2);
  static const EdgeInsets launchpadPaddingX3 = EdgeInsets.all(x3);
  static const EdgeInsets launchpadPaddingX4 = EdgeInsets.all(x4);
  static const EdgeInsets launchpadPaddingX5 = EdgeInsets.all(x5);
  static const EdgeInsets launchpadPaddingX6 = EdgeInsets.all(x6);
  static const EdgeInsets launchpadEmptyStatePadding = EdgeInsets.symmetric(
    horizontal: x5,
    vertical: x6,
  );
  static const EdgeInsets launchpadMetricCardPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x4,
  );
  static const EdgeInsets launchpadTierChipPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x3,
  );
  static const EdgeInsets launchpadHorizontalPaddingX1 = EdgeInsets.symmetric(
    horizontal: x1,
  );
  static const EdgeInsets launchpadHorizontalPaddingX3 = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets launchpadHorizontalContentPadding =
      EdgeInsets.symmetric(horizontal: contentPad);
  static const EdgeInsets launchpadVerticalPaddingX1 = EdgeInsets.symmetric(
    vertical: x1,
  );
  static const EdgeInsets launchpadVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets launchpadVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets launchpadVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets launchpadBottomPaddingX2 = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets launchpadBottomPaddingX1 = EdgeInsets.only(
    bottom: x1,
  );
  static const EdgeInsets launchpadBottomPaddingX3 = EdgeInsets.only(
    bottom: x3,
  );
  static const EdgeInsets launchpadTopPaddingX1 = EdgeInsets.only(top: x1);
  static const EdgeInsets launchpadTopPaddingX2 = EdgeInsets.only(top: x2);
  static const EdgeInsets launchpadTopPaddingX3 = EdgeInsets.only(top: x3);
  static const EdgeInsets launchpadTopPaddingX4 = EdgeInsets.only(top: x4);
  static const EdgeInsets launchpadRightPaddingX2 = EdgeInsets.only(right: x2);
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
    vertical: x1,
  );
  static const EdgeInsets launchpadPillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets launchpadInlinePillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets launchpadTimelineMarkerPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets launchpadLiveBadgePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: 2,
  );
  static const EdgeInsets launchpadEventLevelPadding = EdgeInsets.symmetric(
    vertical: 1,
  );
  static const EdgeInsets launchpadEventFooterPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets launchpadHeaderStatsPadding = EdgeInsets.fromLTRB(
    contentPad,
    x3,
    contentPad,
    x2,
  );
  static const EdgeInsets launchpadStatsStripPadding = EdgeInsets.fromLTRB(
    contentPad,
    0,
    contentPad,
    x2,
  );
  static const EdgeInsets launchpadCreateSheetPadding = EdgeInsets.fromLTRB(
    contentPad,
    x3,
    contentPad,
    x6,
  );
  static const EdgeInsets launchpadActionButtonPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets launchpadSupportButtonPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const double launchpadTabIndicatorWidth = 116;
  static const EdgeInsets launchpadSheetHeaderPadding = EdgeInsets.fromLTRB(
    x4,
    x2,
    x4,
    x6,
  );
  static const EdgeInsets launchpadConfirmSheetPadding = EdgeInsets.fromLTRB(
    x5,
    x4,
    x5,
    x6,
  );
  static const EdgeInsets launchpadSheetHandleMargin = EdgeInsets.only(
    bottom: x4,
  );
  static EdgeInsets launchpadSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(x4, x2, x4, bottomInset);
  static EdgeInsets launchpadClaimSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, x5 + bottomInset);
  static const EdgeInsets discoveryOfflineBannerPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    x2,
  );
  static EdgeInsets discoveryContentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x2, contentPad, bottomInset);
  static const EdgeInsets discoverySearchBandPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    x4,
  );
  static const EdgeInsets discoveryRailPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
    vertical: x4,
  );
  static const EdgeInsets discoveryCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets discoveryChipHorizontalPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets discoveryPillPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets discoveryBadgePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets discoveryMiniBadgePadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets discoveryInlineActionPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets discoveryHeroStatPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets discoveryLeftIndentedCopyPadding = EdgeInsets.only(
    left: x7,
  );
  static const double discoveryCreatorAvatarBox = launchpadBox24;
  static const double discoveryAccentIconBox = launchpadBox42;
  static const double discoveryPredictionTitleLineHeight = 1.32;
  static const double referralChartHeight = 140;
  static const double referralFinePadding = launchpadBorderWidthFocus;
  static const double referralSortIcon = launchpadIconLg;
  static const double referralDividerHeight = launchpadDividerHeight;
  static const double referralLineHeightTight = launchpadLineHeightTight;
  static const double referralLineHeightShort = launchpadLineHeightShort;
  static const double referralBorderWidth = hairlineStroke;
  static const double referralHeroIcon = launchpadBox48;
  static const double referralSplitDividerWidth = launchpadDividerWidth;
  static const double referralSplitDividerHeight = launchpadBox32;
  static const double referralCtaHeight = 46;
  static const double referralRankWidth = launchpadBox28;
  static const double referralStepBox = launchpadBox28;
  static const double referralSectionMarkerWidth = launchpadSheetHandleHeight;
  static const double referralSectionMarkerHeight = launchpadBox18;
  static const double referralLeaderboardWidth = 122;
  static const double referralHistoryFilterHeight = launchpadBox44;
  static const double referralHistoryAvatarBox = launchpadBox44;
  static const double referralHistoryIconSm = launchpadIconSm;
  static const double referralHistoryIconMd = launchpadIconLg;
  static const double referralProgressHeight = launchpadDotMd;
  static const double referralCampaignIconBox = launchpadBox34;
  static EdgeInsets referralBottomScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets referralPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x4, contentPad, bottomInset);
  static const EdgeInsets referralSheetPadding = EdgeInsets.fromLTRB(
    contentPad,
    x5,
    contentPad,
    x6,
  );
  static const EdgeInsets referralFriendDetailPadding = EdgeInsets.fromLTRB(
    x6,
    x2,
    x6,
    0,
  );
  static const EdgeInsets referralCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets referralCardPaddingLarge = EdgeInsets.all(x5);
  static const EdgeInsets referralInnerPadding = EdgeInsets.all(x3);
  static const EdgeInsets referralFineInset = EdgeInsets.all(
    referralFinePadding,
  );
  static const EdgeInsets referralHeroMetricPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x4,
  );
  static const EdgeInsets referralCompactPillPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets referralNoticePadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets referralNoticePaddingDense = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const EdgeInsets referralTinyPillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets referralSortChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const EdgeInsets referralTabButtonPadding = EdgeInsets.symmetric(
    horizontal: x2,
  );
  static const EdgeInsets referralFilterChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets referralStepRowPadding = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets referralLedgerHeaderPadding = EdgeInsets.fromLTRB(
    x4,
    x3,
    x4,
    x3,
  );
  static const EdgeInsets referralFaqAnswerPadding = EdgeInsets.fromLTRB(
    x4,
    0,
    x4,
    x4,
  );
  static const EdgeInsets referralChartPadding = EdgeInsets.fromLTRB(
    x4,
    x4,
    x4,
    x3,
  );
  static const EdgeInsets referralEmptyPadding = EdgeInsets.all(x6);
  static const EdgeInsets referralSectionMarkerMargin = EdgeInsets.only(
    top: x1,
  );
  static const EdgeInsets referralLeftDividerPadding = EdgeInsets.only(top: x1);

  static const double newsFeedGap = 12;
  static const double newsSectionBreak = 18;
  static const double newsFilterBarHeight = 60;
  static const double newsFilterChipHeight = 32;
  static const double newsArticleAvatarSize = 40;
  static const double newsSheetMaxWidth = 440;
  static const double newsSheetMaxHeightFactor = .85;
  static const double newsSheetHandleWidth = 48;
  static const double newsSheetHandleHeight = 4;
  static const double newsEmptyIconSize = 48;
  static const double newsChevronIconSize = 22;
  static const double newsCalendarIconSize = 10;
  static const double newsSheetCalendarIconSize = 13;
  static const double newsSectionIconSize = 15;
  static const double newsTagIconSize = 11;
  static const double newsLineHeightTight = 1;
  static const double newsTitleLineHeight = 1.25;
  static const double newsSummaryLineHeight = 1.34;
  static const double newsSheetTitleLineHeight = 1.3;
  static const double newsSheetSummaryLineHeight = 1.45;
  static const double newsSheetBodyLineHeight = 1.7;
  static EdgeInsets newsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets newsFilterBarPadding = EdgeInsets.fromLTRB(
    contentPad,
    newsFeedGap,
    contentPad,
    newsFeedGap,
  );
  static const EdgeInsets newsFilterChipPadding = EdgeInsets.symmetric(
    horizontal: newsFeedGap,
  );
  static const EdgeInsets newsCardPadding = EdgeInsets.all(sectionGapCompact);
  static const EdgeInsets newsBadgePadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets newsTagPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1 + 1,
  );
  static const EdgeInsets newsEmptyPadding = EdgeInsets.symmetric(vertical: 80);
  static const EdgeInsets newsChevronPadding = EdgeInsets.only(top: x2 + 1);
  static const EdgeInsets newsSheetHandleMargin = EdgeInsets.symmetric(
    vertical: x4 + 1,
  );
  static const EdgeInsets newsSheetPadding = EdgeInsets.fromLTRB(
    x5 + x1,
    zero,
    x5 + x1,
    x5 + x1,
  );
  static const EdgeInsets newsSheetBadgePadding = EdgeInsets.symmetric(
    horizontal: x3 + 2,
    vertical: x2,
  );
  static const EdgeInsets newsSheetSummaryPadding = EdgeInsets.all(x4 + 1);

  static const double adminLineHeightTight = launchpadLineHeightTight;
  static const double adminLineHeightShort = launchpadLineHeightShort;
  static const double adminLineHeightCompact = 1.3;
  static const double adminLineHeightDense = launchpadLineHeightDense;
  static const double adminDividerHeight = launchpadDividerHeight;
  static const double adminDividerThickness = launchpadDividerHeight;
  static const double adminProgressHeight = savingsGoalMilestoneFontSize;
  static const double adminFontXs = launchpadFontXs;
  static const double adminFontSm = launchpadFontSm;
  static const double adminFontMd = launchpadFontMd;
  static const double adminFontLg = stakingTaxDetailFontSize;
  static const double adminFontXl = launchpadIconLg;
  static const double adminFont2xl = dcaOverviewInlineIcon;
  static const double adminFont3xl = launchpadIcon3xl;
  static const double adminIconXs = launchpadIconXs;
  static const double adminIconSm = launchpadIconMd;
  static const double adminIconMd = launchpadIconXl;
  static const double adminIconLg = dcaOverviewInlineIcon;
  static const double adminIconXl = launchpadIcon3xl;
  static const double adminIcon2xl = launchpadBox24;
  static const double adminIconHero = launchpadBox48;
  static const double adminBox24 = launchpadBox24;
  static const double adminBox32 = launchpadBox32;
  static const double adminBox40 = launchpadBox40;
  static const double adminBox48 = launchpadBox48;
  static const double adminAnalyticsChartHeight = 260;
  static const double adminAnalyticsSparklineHeight = 180;
  static const double adminFunnelWaterfallHeight = 200;
  static const int adminGridColumns = 2;
  static const double adminMetricTileExtent = 82;
  static const double adminPainterLabelMaxWidth = 42;
  static const double adminPainterWideLabelMaxWidth = 70;
  static const double adminStateRadius = stakingTaxDetailFontSize;
  static EdgeInsets adminScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets adminCompactPadding = EdgeInsets.all(x3);
  static const EdgeInsets adminCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets adminEmptyPadding = EdgeInsets.all(x6);
  static const EdgeInsets adminRowPadding = EdgeInsets.symmetric(vertical: x3);
  static const EdgeInsets adminStatusPillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets adminChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets adminHorizontalCardPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets adminSegmentButtonPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x2,
  );
  static const EdgeInsets adminFinePadding = EdgeInsets.all(x1);

  static const double devLineHeightTight = adminLineHeightTight;
  static const double devDividerHeight = adminDividerHeight;
  static const double devDividerThickness = adminDividerThickness;
  static const double devFontXs = adminFontXs;
  static const double devFontLg = adminFontLg;
  static const double devFont2xl = adminFont2xl;
  static const double devFontHero = statusPillHeightSm + launchpadGapXxs;
  static const int devRouteGridColumns = 4;
  static const double devRouteGridAspect = 1.18;
  static EdgeInsets devScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets devHeaderPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    x3,
  );
  static const EdgeInsets devCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets devCardPaddingLarge = EdgeInsets.all(x5);
  static const EdgeInsets devCompactPadding = EdgeInsets.all(x3);
  static const EdgeInsets devTinyPadding = EdgeInsets.all(x2);
  static const EdgeInsets devTokenCardPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets devInlinePillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets devChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x2,
  );
  static const EdgeInsets devCompactChipPadding = EdgeInsets.symmetric(
    horizontal: x3,
    vertical: x1,
  );
  static const EdgeInsets devWideChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets devInputPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x4,
  );
  static const EdgeInsets devVerticalPaddingX2 = EdgeInsets.symmetric(
    vertical: x2,
  );
  static const EdgeInsets devVerticalPaddingX3 = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets devVerticalPaddingX4 = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets devVerticalPaddingX5 = EdgeInsets.symmetric(
    vertical: x5,
  );
  static const EdgeInsets devBottomPaddingX3 = EdgeInsets.only(bottom: x3);
  static const double enterpriseStatesLineHeightBody =
      supportLineHeightExpanded;
  static const double enterpriseStatesIconBox = inputHeight;
  static EdgeInsets enterpriseStatesScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets enterpriseStatesHeroPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    zero,
  );
  static const EdgeInsets enterpriseStatesContentPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets enterpriseStatesTabShellPadding = EdgeInsets.all(x1);
  static const EdgeInsets enterpriseStatesTabButtonPadding =
      EdgeInsets.symmetric(horizontal: x2, vertical: rowPy);
  static const EdgeInsets enterpriseStatesCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets enterpriseStatesFrameHeaderPadding =
      EdgeInsets.symmetric(horizontal: x4, vertical: x3);
  static const EdgeInsets enterpriseStatesPreviewPadding = EdgeInsets.all(x5);
  static const EdgeInsets enterpriseStatesPreviewLargePadding = EdgeInsets.all(
    x6,
  );

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
  static const double homeAnnouncementCardVerticalPadding = 10;
  static const double homeAnnouncementCardHorizontalPadding = 14;
  static const EdgeInsets homeAnnouncementCardPadding = EdgeInsets.symmetric(
    horizontal: homeAnnouncementCardHorizontalPadding,
    vertical: homeAnnouncementCardVerticalPadding,
  );
  static const EdgeInsets homeAnnouncementCardPaddingCompact =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const double homeActionRowGap = 8;
  static const double homePortfolioHeaderIcon = 18;
  static const double homePortfolioHeaderActionPadding = 6;
  static const double homePortfolioBadgeHorizontalPadding = 10;
  static const double homePortfolioBadgeVerticalPadding = 4;
  static const double homePortfolioBadgeIcon = 12;
  static const EdgeInsets homePortfolioCardPadding = EdgeInsets.symmetric(
    horizontal: homeAnnouncementCardHorizontalPadding,
    vertical: homeAnnouncementCardVerticalPadding,
  );
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
  static const double homeSectionInnerGap = 6;
  static const double homeChevronGap = 4;
  static const double homeMoreProductsSheetHandleWidth = 36;
  static const double homeMoreProductsSheetHandleHeight = 4;
  static const EdgeInsets homeMoreProductsSheetPadding = EdgeInsets.fromLTRB(
    homeSectionCtaGap,
    x2,
    homeSectionCtaGap,
    homeSectionCtaGap,
  );
  static const double sheetPanelMaxHeightFactor = 0.72;
  static const double homeDiscoverySectionGap = 10;
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
  static const double homeMarketTickerStripGap = x3;
  static const EdgeInsets homeMarketTickerCardPadding = EdgeInsets.all(12);
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
  static const double inputPrefixIcon = 18;
  static const double authScrollBottomInset = x6;
  static const EdgeInsets authScrollBottomPadding = EdgeInsets.only(
    bottom: authScrollBottomInset,
  );
  static const double authStandaloneTopInset = 52;
  static const double authStandaloneBottomInset = x3;
  static const EdgeInsets authStandaloneContentPadding = EdgeInsets.fromLTRB(
    contentPad,
    authStandaloneTopInset,
    contentPad,
    authStandaloneBottomInset,
  );
  static const EdgeInsets authTopGapX1 = EdgeInsets.only(top: x1);
  static const EdgeInsets authTopGapX2 = EdgeInsets.only(top: x2);
  static const EdgeInsets authTopGapX3 = EdgeInsets.only(top: x3);
  static const EdgeInsets authTopGapX4 = EdgeInsets.only(top: x4);
  static const EdgeInsets authTopGapX5 = EdgeInsets.only(top: x5);
  static const EdgeInsets authTopGapX6 = EdgeInsets.only(top: x6);
  static const double authPageContentGap = 16;
  static const double authHeroFormGap = 49;
  static const double authFormFooterGap = 52;
  static const EdgeInsets authHeroFormTopPadding = EdgeInsets.only(
    top: authHeroFormGap,
  );
  static const EdgeInsets authFormFooterTopPadding = EdgeInsets.only(
    top: authFormFooterGap,
  );
  static const double authLogoBoxSize = 64;
  static const double authLogoMarkSize = 36;
  static const double authLogoElevation = 8;
  static const double authHeroIconBoxSm = 64;
  static const double authHeroIconBoxMd = 80;
  static const double authStateIconBox = 96;
  static const double authHeroPainterSize = 32;
  static const double authHeroIconMd = 34;
  static const double authHeroIconLg = 40;
  static const double authStateIconLg = 48;
  static const double authErrorIcon = 14;
  static const double authInlineIcon = 12;
  static const double authInlineIconSm = 10;
  static const double authInlineCheckIcon = 14;
  static const double authSegmentedHeight = 48;
  static const double authSegmentedPaddingValue = 4;
  static const EdgeInsets authSegmentedPadding = EdgeInsets.all(
    authSegmentedPaddingValue,
  );
  static const double authTextButtonHeight = 32;
  static const double authTextButtonHeightLg = 36;
  static const double authInlineTextButtonPadX = 4;
  static const EdgeInsets authInlineTextButtonPadding = EdgeInsets.symmetric(
    horizontal: authInlineTextButtonPadX,
  );
  static const EdgeInsets authDividerLabelPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const EdgeInsets authErrorBannerPaddingSm = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets authErrorBannerPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const double authAgreementCheckSize = 20;
  static const double authAgreementCheckTop = 2;
  static const EdgeInsets authAgreementCheckMargin = EdgeInsets.only(
    top: authAgreementCheckTop,
  );
  static const double authAgreementCheckBorder = 1.3;
  static const double authPasswordStrengthHeight = 4;
  static const double authPasswordStrengthIcon = 11;
  static const double authOtpBoxSize = 48;
  static const double authOtpBoxHeight = 56;
  static const double authOtpDigitGap = 12;
  static const EdgeInsets authOtpDigitTopPadding = EdgeInsets.only(
    top: authOtpDigitGap,
  );
  static const double authOtpProgressHeight = 2;
  static const double authInputTopGap = 17;
  static const EdgeInsets authInputTopPadding = EdgeInsets.only(
    top: authInputTopGap,
  );
  static const double authCompactVerticalGap = 6;
  static const EdgeInsets authCompactTopPadding = EdgeInsets.only(
    top: authCompactVerticalGap,
  );
  static const EdgeInsets authStateVerticalPadding = EdgeInsets.symmetric(
    vertical: x6,
  );
  static const double authTextLetterSpacing = 8;
  static const double authReadableLineHeight = 1.6;
  static const double authAgreementLineHeight = 1.45;
  static const double authFooterLineHeight = 1.5;
  static const double onboardingHeaderWelcomeTop = x3;
  static const double onboardingHeaderWelcomeBottom = x2;
  static const EdgeInsets onboardingHeaderWelcomePadding = EdgeInsets.fromLTRB(
    contentPad,
    onboardingHeaderWelcomeTop,
    contentPad,
    onboardingHeaderWelcomeBottom,
  );
  static const double onboardingHeaderProgressTop = x4;
  static const double onboardingHeaderProgressBottom = x3;
  static const EdgeInsets onboardingHeaderProgressPadding = EdgeInsets.fromLTRB(
    contentPad,
    onboardingHeaderProgressTop,
    contentPad,
    onboardingHeaderProgressBottom,
  );
  static EdgeInsets onboardingFooterPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(contentPad, x3, contentPad, x5 + bottomInset);
  static const EdgeInsets onboardingCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets onboardingGoalTilePadding = EdgeInsets.all(x3);
  static const EdgeInsets onboardingSelectedCheckPadding = EdgeInsets.all(x1);
  static const int onboardingGoalGridColumns = 2;
  static const double onboardingGoalGridAspectRatio = 1.08;
  static const double onboardingHeroIconElevation = x3;
  static const double onboardingSmallIconBox = buttonCompact + x3;
  static const double onboardingBulletDotIcon = 7;
  static const double onboardingBulletIcon = 14;
  static EdgeInsets notificationsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets notificationsToolbarPadding = EdgeInsets.fromLTRB(
    contentPad,
    x3,
    contentPad,
    x3,
  );
  static const EdgeInsets notificationsRowPadding = EdgeInsets.fromLTRB(
    contentPad,
    x2,
    contentPad,
    x2,
  );
  static const double notificationsUnreadDotSize = x3;
  static const EdgeInsets notificationsUnreadDotMargin = EdgeInsets.only(
    left: x2,
  );
  static const double notificationsMessageLineHeight = 1.25;
  static const double notificationsPillLineHeight = 1.1;
  static const double notificationsTypeIconBox = 38;
  static const EdgeInsets notificationsTypeIconMargin = EdgeInsets.only(
    top: x1,
  );
  static const double notificationsTypeIcon = 19;
  static const EdgeInsets notificationsFooterPadding = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const double notificationsFooterDividerWidth = 36;
  static const double notificationsFooterDividerHeight = dividerHairline;
  static EdgeInsets crossModuleScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets crossModuleTabBarPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets crossModuleTabLabelPadding = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets crossModuleCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets crossModulePanelPadding = EdgeInsets.all(x3);
  static const EdgeInsets crossModulePillPadding = EdgeInsets.symmetric(
    horizontal: x2,
    vertical: x1,
  );
  static const EdgeInsets crossModuleSelectorPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x3,
  );
  static const EdgeInsets crossModulePresetButtonPadding = EdgeInsets.symmetric(
    vertical: x3,
  );
  static const EdgeInsets crossModuleFormatButtonPadding = EdgeInsets.symmetric(
    vertical: x4,
  );
  static const EdgeInsets crossModuleTrailingRowPadding = EdgeInsets.only(
    bottom: x2,
  );
  static const EdgeInsets crossModuleTogglePadding = EdgeInsets.all(x2);
  static const EdgeInsets crossModuleTextButtonPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x2,
  );
  static const double crossModuleLineHeightBody = 1.45;
  static EdgeInsets supportScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets supportContentPadding = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets supportSectionMargin = EdgeInsets.symmetric(
    horizontal: contentPad,
  );
  static const EdgeInsets supportQuickLinksPadding = EdgeInsets.fromLTRB(
    contentPad,
    x4,
    contentPad,
    x4,
  );
  static const EdgeInsets supportCardPadding = EdgeInsets.all(x4);
  static const EdgeInsets supportQuickCardPadding = EdgeInsets.symmetric(
    horizontal: x4,
    vertical: x4,
  );
  static const EdgeInsets supportFilterRailPadding = EdgeInsets.fromLTRB(
    contentPad,
    x5,
    contentPad,
    x1,
  );
  static const EdgeInsets supportFilterChipPadding = EdgeInsets.symmetric(
    horizontal: x4,
  );
  static const double supportTinyGap = 2;
  static const double supportLineHeightFilter = 1.1;
  static const double supportLineHeightTight = 1.25;
  static const double supportLineHeightReadable = 1.35;
  static const double supportLineHeightBody = 1.45;
  static const double supportLineHeightExpanded = 1.55;
  static const double supportContextIconBox = 34;
  static const double supportContextIcon = 19;
  static const double supportTimelineRailWidth = 24;
  static const double supportTimelineDotSize = 18;
  static const double supportTimelineLineWidth = dividerHairline;
  static EdgeInsets supportTimelineLabelPadding(bool isLast) =>
      EdgeInsets.only(bottom: isLast ? zero : x3);
  static const double supportFaqToggleIconBox = 24;
  static const int supportCategoryGridColumns = 2;
  static const double supportCategoryGridAspectRatio = 1.9;
  static const double supportCategoryIcon = 24;
  static const double supportArticleIcon = 21;
  static const double supportFilterChipHeight = 34;
  static const double supportAnnouncementIconBox = 42;
  static const double supportAnnouncementIcon = 20;
  static const double authTwoFaContentGap = contentPad;
  static const double authTwoFaStepperTop = 16;
  static const double authTwoFaStepperBottom = 12;
  static const EdgeInsets authTwoFaStepperPadding = EdgeInsets.fromLTRB(
    contentPad,
    authTwoFaStepperTop,
    contentPad,
    authTwoFaStepperBottom,
  );
  static const EdgeInsets authTwoFaProgressMargin = EdgeInsets.symmetric(
    horizontal: x3,
  );
  static const double authTwoFaStepDotSize = 32;
  static const double authTwoFaStepIcon = 17;
  static const double authTwoFaHeroTopGap = 18;
  static const EdgeInsets authTwoFaHeroTopPadding = EdgeInsets.only(
    top: authTwoFaHeroTopGap,
  );
  static const double authTwoFaQrTopGap = 22;
  static const EdgeInsets authTwoFaQrTopPadding = EdgeInsets.only(
    top: authTwoFaQrTopGap,
  );
  static const double authTwoFaSectionTopGap = contentPad;
  static const EdgeInsets authTwoFaSectionTopPadding = EdgeInsets.only(
    top: authTwoFaSectionTopGap,
  );
  static const double authTwoFaBackupActionTopGap = 16;
  static const EdgeInsets authTwoFaBackupActionTopPadding = EdgeInsets.only(
    top: authTwoFaBackupActionTopGap,
  );
  static const double authTwoFaQrSize = 192;
  static const double authTwoFaCardPaddingValue = 16;
  static const EdgeInsets authTwoFaQrPadding = EdgeInsets.all(
    authTwoFaCardPaddingValue,
  );
  static const EdgeInsets authTwoFaSecretPadding = EdgeInsets.fromLTRB(
    authTwoFaCardPaddingValue,
    rowPy,
    authTwoFaCardPaddingValue,
    authTwoFaCardPaddingValue,
  );
  static const double authTwoFaCopyIcon = 15;
  static const EdgeInsets authTwoFaCopyButtonPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double authTwoFaWarningIcon = 16;
  static const EdgeInsets authTwoFaBannerPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const double authTwoFaBackupIndexSize = 24;
  static const double authTwoFaBackupCheckSize = 22;
  static const double authTwoFaBackupCheckTop = 1;
  static const EdgeInsets authTwoFaBackupCheckMargin = EdgeInsets.only(
    top: authTwoFaBackupCheckTop,
  );
  static const double authTwoFaBackupCheckBorder = 1.4;
  static const double authTwoFaBackupCheckIcon = 15;
  static const double authTwoFaVerifyCodeTopGap = 28;
  static const EdgeInsets authTwoFaVerifyCodeTopPadding = EdgeInsets.only(
    top: authTwoFaVerifyCodeTopGap,
  );
  static const double authTwoFaCodeDigitGap = 10;
  static const double authTwoFaHiddenInputSize = dividerHairline;
  static const double authTwoFaCodeDigitWidth = 44;
  static const double authTwoFaCodeDigitHeight = 56;
}
