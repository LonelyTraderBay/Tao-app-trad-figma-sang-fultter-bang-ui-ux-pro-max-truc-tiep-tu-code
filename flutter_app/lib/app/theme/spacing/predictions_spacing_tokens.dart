import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class PredictionsSpacingTokens {
  const PredictionsSpacingTokens._();

  static const double predictionHomeBottomInsetVisual = 54;
  static const double predictionHomeBottomInsetNative = AppSpacing.contentPad;
  static EdgeInsets predictionHomeScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionHomeContentGap = AppSpacing.x4;
  static const EdgeInsets predictionHomeEventPadding = EdgeInsets.all(16);
  static const double predictionHomeBadgeGap = 6;
  static const double predictionHomeBadgeRunGap = AppSpacing.x2;
  static const double predictionHomeEventTitleGap = 10;
  static const double predictionHomeSectionGap = 12;
  static const double predictionHomeActionGap = AppSpacing.x3;
  static const double predictionHomeChanceLabelGap = 7;
  static const double predictionHomeChanceBarHeight = AppSpacing.x3;
  static const EdgeInsets predictionHomeOutcomeChipPadding =
      EdgeInsets.symmetric(horizontal: 9, vertical: AppSpacing.x2);
  static const double predictionHomeOutcomeDot = AppSpacing.x3;
  static const double predictionHomeOutcomeGap = 6;
  static const double predictionHomeStatGap = 12;
  static const double predictionHomeTrendIcon = 12;
  static const double predictionHomeStatIcon = 11;
  static const double predictionHomeStatIconGap = 4;
  static const double predictionHomeActionHeight = 42;
  static const EdgeInsets predictionHomeBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const double predictionHomeEmptyHeight = 220;
  static const double predictionHomeEmptyIcon = 40;
  static const double predictionHomeEmptyTitleGap = 12;
  static const double predictionHomeEmptySubtitleGap = 4;
  static const double predictionHomeFilterGap = AppSpacing.x3;
  static const double predictionHomeFilterHeight = 36;
  static const EdgeInsets predictionHomeFilterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
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
  static const double predictionHomeHighlightTinyGap =
      AppSpacing.hairlineStroke;
  static const double predictionHomeBridgeTinyGap = AppSpacing.x1;
  static const double predictionHomeBridgeWrapGap = 7;
  static const double predictionDetailBottomInsetVisual = 54;
  static const double predictionDetailBottomInsetNative = AppSpacing.contentPad;
  static EdgeInsets predictionDetailScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionDetailContentGap = 15;
  static const double predictionDetailBadgeGap = 7;
  static const double predictionDetailBadgeRunGap = 6;
  static const double predictionDetailTitleTopGap = 9;
  static const double predictionDetailMetaTopGap = AppSpacing.x3;
  static const double predictionDetailMetaGap = 12;
  static const double predictionDetailOutcomeTopGap = 15;
  static const double predictionDetailOutcomeGap = 12;
  static const EdgeInsets predictionDetailOutcomePadding = EdgeInsets.all(15);
  static const double predictionDetailOutcomeDot = 11;
  static const double predictionDetailOutcomeLabelGap = 7;
  static const double predictionDetailOutcomeChanceGap = 6;
  static const double predictionDetailOutcomeMetaGap = AppSpacing.x3;
  static const double predictionDetailMultiOutcomeBottomGap = AppSpacing.x3;
  static const EdgeInsets predictionDetailMultiOutcomePadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const double predictionDetailMultiOutcomeDot = 10;
  static const double predictionDetailMultiOutcomeGap = 10;
  static const double predictionDetailProbabilityTopGap = 12;
  static const double predictionDetailProbabilityHeight = 10;
  static const double predictionDetailStatsGap = AppSpacing.x3;
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
  static const double predictionDetailPositionBadgeGap = AppSpacing.x3;
  static const EdgeInsets predictionDetailChartCardPadding = EdgeInsets.all(14);
  static const double predictionDetailChartPeriodHeight = 30;
  static const double predictionDetailChartPeriodGap = 6;
  static const double predictionDetailChartPlotGap = 10;
  static const double predictionDetailChartHeight = 178;
  static const double predictionDetailChartVolumeLabelGap = 9;
  static const double predictionDetailChartVolumeBarsGap = AppSpacing.x2;
  static const double predictionDetailChartVolumeBarsHeight = 42;
  static const EdgeInsets predictionDetailChartVolumeBarMargin =
      EdgeInsets.symmetric(horizontal: 1.5);
  static const double predictionDetailChartVolumeBarMinFactor = .10;
  static const EdgeInsets predictionDetailOrderBookTogglePadding =
      EdgeInsets.symmetric(horizontal: 15, vertical: 13);
  static const double predictionDetailOrderBookToggleIcon = 15;
  static const double predictionDetailOrderBookToggleGap = AppSpacing.x3;
  static const double predictionDetailOrderBookChevron = 18;
  static const double predictionDetailOrderBookExpandedGap = AppSpacing.x3;
  static const EdgeInsets predictionDetailOrderBookCardPadding = EdgeInsets.all(
    14,
  );
  static const double predictionDetailOrderBookHeaderGap = 6;
  static const EdgeInsets predictionDetailOrderBookMidPriceMargin =
      EdgeInsets.symmetric(vertical: 7);
  static const EdgeInsets predictionDetailOrderBookMidPricePadding =
      EdgeInsets.symmetric(vertical: 7);
  static const EdgeInsets predictionDetailOrderBookRowPadding =
      EdgeInsets.symmetric(vertical: 6, horizontal: AppSpacing.hairlineStroke);
  static const double predictionDetailOrderBookColumnWidth = 72;
  static const double predictionDetailHolderRankColumnWidth = 28;
  static const double predictionDetailHolderSideColumnWidth = 54;
  static const double predictionDetailHolderSharesColumnWidth = 70;
  static const double predictionDetailHolderHeaderGap = AppSpacing.x3;
  static const EdgeInsets predictionDetailHolderRowPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3);
  static const double predictionDetailHolderWinnerIcon = 15;
  static const double predictionDetailHolderDefaultIcon = 6;
  static const EdgeInsets predictionDetailActivityRowPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3);
  static const double predictionDetailActivityIconBox = 30;
  static const double predictionDetailActivityIcon = 14;
  static const double predictionDetailActivityIconGap = 10;
  static const EdgeInsets predictionDetailTradeCardPadding = EdgeInsets.all(14);
  static const double predictionDetailTradeSectionGap = AppSpacing.x4;
  static const double predictionDetailTradeLabelGap = 7;
  static const EdgeInsets predictionDetailTradeOutcomeChipPadding =
      EdgeInsets.only(right: predictionDetailTradeLabelGap);
  static const double predictionDetailTradeHelperGap = 4;
  static const double predictionDetailTradePresetGap = 6;
  static const double predictionDetailTradeAmountPresetGap = AppSpacing.x3;
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
  static const double predictionDetailRiskChevronGap = AppSpacing.x1;
  static const double predictionDetailRiskChevron = 14;
  static const EdgeInsets predictionDetailTabsPadding = EdgeInsets.all(4);
  static const double predictionDetailTabsGap = 4;
  static const double predictionDetailTabHeight = 34;
  static const EdgeInsets predictionDetailTabPadding = EdgeInsets.symmetric(
    horizontal: 11,
  );
  static const EdgeInsets predictionDetailTabCardPadding = EdgeInsets.all(15);
  static const double predictionDetailTabSectionGap = AppSpacing.x4;
  static const double predictionDetailTabInfoGap = 10;
  static const double predictionDetailTabTitleGap = AppSpacing.x3;
  static const double predictionDetailRuleBottomGap = AppSpacing.x3;
  static const double predictionDetailRuleNumberWidth = 22;
  static const double predictionDetailInfoIcon = 13;
  static const double predictionDetailInfoIconGap = 7;
  static const EdgeInsets predictionDetailInfoBoxPadding = EdgeInsets.all(12);
  static const double predictionDetailInfoBoxIcon = 14;
  static const double predictionDetailInfoBoxGap = AppSpacing.x3;
  static const double predictionDetailInfoBoxTextGap = AppSpacing.x1;
  static const double predictionDetailRelatedGap = 12;
  static const double predictionDetailRelatedCardWidth = 220;
  static const EdgeInsets predictionDetailRelatedCardPadding = EdgeInsets.all(
    13,
  );
  static const double predictionDetailRelatedBadgeGap = AppSpacing.x3;
  static const double predictionDetailRelatedMetaGap = 10;
  static const double predictionDetailRelatedDot = AppSpacing.x3;
  static const double predictionDetailRelatedDotGap = 6;
  static const double predictionDetailRelatedLabelGap = 4;
  static const EdgeInsets predictionDetailArenaPadding = EdgeInsets.all(15);
  static const double predictionDetailArenaIconBox = 36;
  static const double predictionDetailArenaIcon = 18;
  static const double predictionDetailArenaHeaderGap = 10;
  static const double predictionDetailArenaBadgeGap = 6;
  static const double predictionDetailArenaRoomsGap = 12;
  static const double predictionDetailArenaRoomBottomGap = AppSpacing.x3;
  static const EdgeInsets predictionDetailArenaRoomPadding = EdgeInsets.all(10);
  static const double predictionDetailArenaRoomIcon = 15;
  static const double predictionDetailArenaRoomGap = AppSpacing.x3;
  static const EdgeInsets predictionDetailArenaCreatePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: 11);
  static const double predictionDetailArenaCreateIcon = 15;
  static const double predictionDetailArenaCreateGap = AppSpacing.x3;
  static const double predictionDetailArenaCreateBadgeGap = 4;
  static const double predictionDetailArenaCreateChevron = 16;
  static const EdgeInsets predictionDetailArenaBadgePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: AppSpacing.hairlineStroke);
  static const EdgeInsets predictionDetailCommentWarningPadding =
      EdgeInsets.all(11);
  static const double predictionDetailCommentWarningIcon = 15;
  static const double predictionDetailCommentWarningGap = AppSpacing.x2;
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
    top: AppSpacing.x1,
  );
  static const EdgeInsets predictionDetailCommentActionGap = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const double predictionDetailCommentLikeIcon = 12;
  static const double predictionDetailCommentLikeGap = AppSpacing.x1;
  static const double predictionDetailCommentReportGap = 12;
  static const EdgeInsets predictionOrderPreviewPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    11,
  );
  static const double predictionOrderPreviewIcon = 15;
  static const double predictionOrderPreviewIconGap = AppSpacing.x3;
  static const double predictionOrderPreviewHeaderGap = 10;
  static const double predictionOrderPreviewRowGap = 7;
  static const double predictionOrderPreviewFooterGap = 9;
  static const EdgeInsets predictionOrderPreviewBadgePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 4);
  static const EdgeInsets predictionDetailQuickLinkPadding = EdgeInsets.all(11);
  static const double predictionDetailQuickLinkGap = AppSpacing.x3;
  static const double predictionDetailQuickLinkIcon = 16;
  static const double predictionPortfolioBottomInsetVisual = 54;
  static const double predictionPortfolioBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionPortfolioScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  // PRED-PORTFOLIO-HOME-01: legacy hero/tabs/bridge tokens superseded by home* primitives.
  @Deprecated('Superseded by home* tokens after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioContentGap = 16;
  @Deprecated('Superseded by VitAccentPill after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: AppSpacing.x1);
  @Deprecated(
    'Superseded by homePortfolioCardPadding after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioSummaryPadding =
      EdgeInsets.fromLTRB(20, 15, 20, 20);
  @Deprecated('Superseded by VitInlineIconAction after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioVisibilityButton = 32;
  @Deprecated('Superseded by VitInlineIconAction after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioVisibilityIcon = 17;
  static const double predictionPortfolioValueGap = AppSpacing.x3;
  @Deprecated('Superseded by VitMetricDeltaPill after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioPnlGap = 6;
  @Deprecated('Superseded by VitMetricDeltaPill after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioPnlPillPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 6);
  static const double predictionPortfolioPnlIcon = 13;
  static const double predictionPortfolioPnlIconGap = 4;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioSummaryStatsGap = 18;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioSummaryStatGap = AppSpacing.x3;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioSummaryStatHeight = 51;
  @Deprecated('Superseded by VitCardStat after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioSummaryStatPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 9);
  @Deprecated(
    'Superseded by VitAnnouncementBanner after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioSharesNotePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: 11);
  static const double predictionPortfolioSharesNoteIcon = 15;
  static const double predictionPortfolioSharesNoteGap = 9;
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioTabsHeight = 43;
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioTabsPadding = EdgeInsets.all(4);
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioTabLabelGap = AppSpacing.x2;
  @Deprecated('Superseded by VitTabBar segment after PRED-PORTFOLIO-HOME-01')
  static const EdgeInsets predictionPortfolioCountBadgePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: 1);
  @Deprecated(
    'Superseded by grouped VitCard lists after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioListGap = 10;
  @Deprecated(
    'Superseded by AppSpacing.cardPadding grouped rows after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioPositionCardPadding =
      EdgeInsets.fromLTRB(14, 14, 12, 26);
  static const double predictionPortfolioPositionIconBox = 38;
  static const double predictionPortfolioPositionIcon = 19;
  static const double predictionPortfolioPositionGap = 12;
  static const double predictionPortfolioPositionTitleGap = 6;
  static const double predictionPortfolioChipGap = AppSpacing.x3;
  static const double predictionPortfolioChipRunGap = 4;
  static const double predictionPortfolioPositionMetricsGap = AppSpacing.x3;
  static const double predictionPortfolioPositionRowsGap = 6;
  static const double predictionPortfolioPnlArrowIcon = 13;
  static const double predictionPortfolioPnlArrowGap = AppSpacing.x1;
  static const double predictionPortfolioTrailingGap = AppSpacing.x3;
  static const EdgeInsets predictionPortfolioTrailingIconPadding =
      EdgeInsets.only(top: 18);
  static const double predictionPortfolioTrailingIcon = 18;
  static const double predictionPortfolioMetricGap = 4;
  @Deprecated('Superseded by VitSectionHeader after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioOrdersHeaderGap = AppSpacing.x3;
  @Deprecated('Superseded by VitSectionHeader after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioOrdersHelpGap = 6;
  @Deprecated('Superseded by VitSectionHeader after PRED-PORTFOLIO-HOME-01')
  static const double predictionPortfolioOrdersHelpIcon = 13;
  @Deprecated(
    'Superseded by AppSpacing.cardPadding grouped rows after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioOrderCardPadding = EdgeInsets.all(
    12,
  );
  static const double predictionPortfolioOrderIconBox = 32;
  static const double predictionPortfolioOrderIcon = 17;
  static const double predictionPortfolioOrderGap = 12;
  static const double predictionPortfolioOrderTitleGap = AppSpacing.x2;
  static const double predictionPortfolioOrderProgressGap = AppSpacing.x3;
  static const double predictionPortfolioOrderProgressHeight = AppSpacing.x2;
  static const double predictionPortfolioOrderTrailingGap = 10;
  static const double predictionPortfolioOrderChevron = 14;
  static const double predictionPortfolioOrderCancelGap = AppSpacing.x3;
  static const double predictionPortfolioOrderCancelHeight = 32;
  static const EdgeInsets predictionPortfolioOrderCancelPadding =
      EdgeInsets.symmetric(horizontal: 10);
  static const double predictionPortfolioOrderCancelIcon = 12;
  static const double predictionPortfolioOrderCancelIconGap = 4;
  @Deprecated(
    'Superseded by AppSpacing.cardPadding grouped rows after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioReceiptCardPadding =
      EdgeInsets.all(13);
  static const double predictionPortfolioReceiptIconBox = 36;
  static const double predictionPortfolioReceiptIcon = 17;
  static const double predictionPortfolioReceiptGap = 11;
  static const double predictionPortfolioReceiptTitleGap = AppSpacing.x2;
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
  static const double predictionPortfolioBridgeTextGap = AppSpacing.x1;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeBadgeGap = AppSpacing.x3;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const EdgeInsets predictionPortfolioBridgeBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: AppSpacing.x1);
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeChevronGap = 7;
  @Deprecated(
    'Superseded by VitDiscoveryActionCard after PRED-PORTFOLIO-HOME-01',
  )
  static const double predictionPortfolioBridgeChevron = 17;
  static const double predictionRiskBottomInsetVisual = 54;
  static const double predictionRiskBottomInsetNative = AppSpacing.contentPad;
  static EdgeInsets predictionRiskScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionRiskContentGap = 16;
  static const double predictionRiskTabsHeight = 54;
  static const double predictionRiskTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double predictionRiskTabIndicatorWidth = 116;
  static const EdgeInsets predictionRiskCardPadding = EdgeInsets.all(16);
  static const double predictionRiskFieldGap = 16;
  static const double predictionRiskInputLabelGap = AppSpacing.x3;
  static const double predictionRiskInputRowGap = 12;
  static const double predictionRiskOutcomeGap = 10;
  static const double predictionRiskOutcomeButtonHeight = 42;
  static const double predictionRiskSummaryTitleGap = 14;
  static const double predictionRiskSummaryRowGap = 12;
  static const double predictionRiskMetricGap = 4;
  static const double predictionRiskMetricVertical = 7;
  static const double predictionRiskMetricCompactVertical = AppSpacing.x1;
  static const EdgeInsets predictionRiskMetricPadding = EdgeInsets.symmetric(
    vertical: predictionRiskMetricVertical,
  );
  static const EdgeInsets predictionRiskMetricCompactPadding =
      EdgeInsets.symmetric(vertical: predictionRiskMetricCompactVertical);
  static const double predictionRiskMetricIcon = 16;
  static const double predictionRiskMetricIconGap = AppSpacing.x3;
  static const double predictionRiskKellyIcon = 17;
  static const double predictionRiskKellyIconGap = AppSpacing.x3;
  static const double predictionRiskKellySubtitleGap = AppSpacing.x1;
  static const double predictionRiskKellyValueGap = 14;
  static const double predictionRiskKellyValueWrapGap = AppSpacing.x3;
  static const double predictionRiskKellyValueRunGap = AppSpacing.x1;
  static const EdgeInsets predictionRiskWarningPadding = EdgeInsets.all(12);
  static const double predictionRiskWarningIcon = 15;
  static const double predictionRiskWarningGap = AppSpacing.x3;
  static const double predictionRiskScenarioTitleGap = 14;
  static const EdgeInsets predictionRiskGuidePadding = EdgeInsets.all(14);
  static const double predictionRiskGuideTitleGap = 5;
  static const double predictionReceiptBottomInsetVisual = 54;
  static const double predictionReceiptBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionReceiptScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionReceiptContentGap = 15;
  static const EdgeInsets predictionReceiptSummaryRowPadding =
      EdgeInsets.symmetric(vertical: 5);
  static const double predictionReceiptSummaryTrailingGap = 5;
  static const double predictionReceiptSummaryTrailingIcon = 12;
  static const double predictionReceiptFillDividerGap = 12;
  static const double predictionReceiptFillBarGap = 7;
  static const double predictionReceiptFillBarHeight = AppSpacing.x3;
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
  static const double predictionReceiptHeroPillGap = AppSpacing.x3;
  static const double predictionReceiptHeroOutcomeGap = 12;
  static const double predictionReceiptHeroEventGap = AppSpacing.x1;
  static const EdgeInsets predictionReceiptCardPadding = EdgeInsets.all(16);
  static const EdgeInsets predictionReceiptDisclosurePadding = EdgeInsets.all(
    12,
  );
  static const double predictionReceiptShareBorderWidth = 1.5;
  static const double predictionReceiptShareIcon = 17;
  static const double predictionReceiptShareIconGap = AppSpacing.x3;
  static const double predictionReceiptDisclosureIcon = 15;
  static const double predictionReceiptDisclosureGap = AppSpacing.x3;
  static const double predictionReceiptActionGap = 12;
  static const double predictionAnalyzerBottomInsetVisual = 54;
  static const double predictionAnalyzerBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionAnalyzerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionAnalyzerContentGap = 16;
  static const double predictionAnalyzerTabsHeight = 54;
  static const double predictionAnalyzerTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double predictionAnalyzerTabIndicatorWidth = 116;
  static const EdgeInsets predictionAnalyzerSummaryPadding =
      EdgeInsets.fromLTRB(16, 16, 16, 18);
  static const double predictionAnalyzerValueGap = 11;
  static const double predictionAnalyzerPnlGap = AppSpacing.x3;
  static const EdgeInsets predictionAnalyzerPnlPadding = EdgeInsets.only(
    bottom: AppSpacing.hairlineStroke,
  );
  static const double predictionAnalyzerPnlIcon = 15;
  static const double predictionAnalyzerPnlIconGap = AppSpacing.x1;
  static const double predictionAnalyzerSummaryPrimaryGap = 22;
  static const double predictionAnalyzerSummarySecondaryGap = 16;
  static const EdgeInsets predictionAnalyzerCardPadding = EdgeInsets.all(16);
  static const int predictionAnalyzerGridColumns = 2;
  static const double predictionAnalyzerGridExtent = 84;
  static const double predictionAnalyzerGridGap = 12;
  static const double predictionAnalyzerStatIcon = 16;
  static const double predictionAnalyzerStatIconGap = AppSpacing.x3;
  static const EdgeInsets predictionAnalyzerCategoryPadding =
      EdgeInsets.fromLTRB(16, 18, 16, 18);
  static const double predictionAnalyzerCategoryTitleGap = 16;
  static const double predictionAnalyzerDonutHeight = 190;
  static const double predictionAnalyzerDonutWidth = 240;
  static const double predictionAnalyzerLegendGap = 18;
  static const int predictionAnalyzerLegendColumns = 2;
  static const double predictionAnalyzerLegendExtent = 42;
  static const double predictionAnalyzerLegendCrossGap = 16;
  static const double predictionAnalyzerLegendMainGap = AppSpacing.x1;
  static const double predictionAnalyzerPerformanceChartGap = 16;
  static const double predictionAnalyzerPerformanceChartHeight = 180;
  static const double predictionAnalyzerTradeStatsGap = 16;
  static const double predictionAnalyzerTradeProgressGap = 14;
  static const double predictionAnalyzerTradeProgressHeight = AppSpacing.x3;
  static const EdgeInsets predictionAnalyzerAttributionPadding = EdgeInsets.all(
    14,
  );
  static const double predictionAnalyzerAttributionLabelGap = AppSpacing.x1;
  static const double predictionAnalyzerAttributionTrailingGap = 10;
  static const double predictionAnalyzerRiskChartTitleGap = 16;
  static const double predictionAnalyzerRiskChartHeight = 160;
  static const double predictionAnalyzerRiskIcon = 16;
  static const double predictionAnalyzerRiskIconGap = AppSpacing.x3;
  static const double predictionAnalyzerRiskTextGap = AppSpacing.x1;
  static const double predictionAnalyzerScoreGap = 12;
  static const double predictionAnalyzerScoreSuffixGap = 5;
  static const EdgeInsets predictionAnalyzerWarningPadding = EdgeInsets.all(12);
  static const double predictionAnalyzerWarningIcon = 15;
  static const double predictionAnalyzerWarningGap = AppSpacing.x3;
  static const double predictionAnalyzerSummaryMetricGap = 5;
  static const double predictionAnalyzerLegendSwatch = 12;
  static const EdgeInsets predictionAnalyzerLegendSwatchMargin =
      EdgeInsets.only(top: AppSpacing.hairlineStroke);
  static const double predictionAnalyzerLegendItemGap = AppSpacing.x3;
  static const double predictionAnalyzerRiskMetricVertical = 10;
  static const double predictionAnalyzerRiskBarHorizontal = 5;
  static const EdgeInsets predictionAnalyzerRiskMetricPadding =
      EdgeInsets.symmetric(vertical: predictionAnalyzerRiskMetricVertical);
  static const EdgeInsets predictionAnalyzerRiskBarPadding =
      EdgeInsets.symmetric(horizontal: predictionAnalyzerRiskBarHorizontal);
  static const double predictionAnalyzerRiskBarLabelGap = 7;
  static const double predictionBreakingBottomInsetVisual = 54;
  static const double predictionBreakingBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionBreakingScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionBreakingContentGap = 14;
  static const EdgeInsets predictionBreakingMovementPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const double predictionBreakingMovementIcon = 18;
  static const double predictionBreakingMovementGap = AppSpacing.x3;
  static const double predictionBreakingMovementCountGap = 12;
  static const double predictionBreakingCountIcon = 13;
  static const double predictionBreakingCountIconGap = AppSpacing.x1;
  static const double predictionBreakingTabGap = AppSpacing.x3;
  static const double predictionBreakingTabHeight = 36;
  static const EdgeInsets predictionBreakingTabPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const EdgeInsets predictionBreakingMoverPadding = EdgeInsets.all(16);
  static const double predictionBreakingRankBox = 32;
  static const double predictionBreakingMoverGap = 12;
  static const double predictionBreakingTitleGap = AppSpacing.x3;
  static const double predictionBreakingOutcomeGap = 10;
  static const double predictionBreakingOutcomeRunGap = 6;
  static const double predictionBreakingMetaGap = 10;
  static const double predictionBreakingMetaRunGap = 5;
  static const EdgeInsets predictionBreakingChangePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 3);
  static const double predictionBreakingChangeIcon = 12;
  static const double predictionBreakingChangeIconGap = AppSpacing.x1;
  static const EdgeInsets predictionBreakingTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: AppSpacing.hairlineStroke);
  static const double predictionBreakingMetaIcon = 10;
  static const double predictionBreakingMetaIconGap = AppSpacing.x1;
  static const EdgeInsets predictionBreakingEmailPadding = EdgeInsets.all(16);
  static const double predictionBreakingEmailIconBox = 40;
  static const double predictionBreakingEmailIcon = 18;
  static const double predictionBreakingEmailGap = 12;
  static const double predictionBreakingEmailFormGap = 12;
  static const double predictionBreakingEmailButtonGap = AppSpacing.x3;
  static const double predictionBreakingSubscribeHeight = 42;
  static const EdgeInsets predictionBreakingSubscribePadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const double predictionBreakingEmptyHeight = 220;
  static const double predictionBreakingEmptyIcon = 40;
  static const double predictionBreakingEmptyTitleGap = 12;
  static const double predictionBreakingEmptySubtitleGap = AppSpacing.x1;
  static const double predictionMarketMakerBottomInsetVisual = 54;
  static const double predictionMarketMakerBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionMarketMakerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionMarketMakerContentGap = 16;
  static const double predictionMarketMakerTabsHeight = 54;
  static const double predictionMarketMakerTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double predictionMarketMakerTabIndicatorWidth = 116;
  static const EdgeInsets predictionMarketMakerCardPadding = EdgeInsets.all(16);
  static const double predictionMarketMakerOverviewIconBox = 48;
  static const double predictionMarketMakerOverviewIcon = 25;
  static const double predictionMarketMakerOverviewGap = 12;
  static const double predictionMarketMakerOverviewStatsGap = 16;
  static const double predictionMarketMakerFormGap = 16;
  static const double predictionMarketMakerInputLabelGap = AppSpacing.x3;
  static const double predictionMarketMakerInputPrefixIcon = 19;
  static const double predictionMarketMakerHelperGap = 5;
  static const double predictionMarketMakerEstimateGap = 14;
  static const double predictionMarketMakerAddButtonGap = 16;
  static const double predictionMarketMakerSpreadGap = AppSpacing.x3;
  static const double predictionMarketMakerSpreadButtonHeight = 36;
  static const EdgeInsets predictionMarketMakerEstimatePadding = EdgeInsets.all(
    12,
  );
  static const double predictionMarketMakerAddIcon = 20;
  static const double predictionMarketMakerAddIconGap = AppSpacing.x3;
  static const EdgeInsets predictionMarketMakerWarningPadding = EdgeInsets.all(
    12,
  );
  static const double predictionMarketMakerWarningIcon = 15;
  static const double predictionMarketMakerWarningGap = AppSpacing.x3;
  static const double predictionMarketMakerPositionMetricGap = 12;
  static const double predictionMarketMakerPositionCardGap = 12;
  static const double predictionMarketMakerEarningsTitleGap = 16;
  static const double predictionMarketMakerEarningsChartHeight = 160;
  static const double predictionMarketMakerEarningsBarHorizontal =
      AppSpacing.x1;
  static const EdgeInsets predictionMarketMakerEarningsBarPadding =
      EdgeInsets.symmetric(
        horizontal: predictionMarketMakerEarningsBarHorizontal,
      );
  static const double predictionMarketMakerEarningsBarLabelGap = 6;
  static const double predictionMarketMakerOverviewMetricGap = AppSpacing.x1;
  static const double predictionMarketMakerAnalysisRowVertical = AppSpacing.x3;
  static const EdgeInsets predictionMarketMakerAnalysisRowPadding =
      EdgeInsets.symmetric(vertical: predictionMarketMakerAnalysisRowVertical);
  static const double predictionMarketMakerAnalysisIcon = 16;
  static const double predictionMarketMakerAnalysisIconGap = AppSpacing.x3;
  static const double predictionSocialBottomInsetVisual = 54;
  static const double predictionSocialBottomInsetNative = AppSpacing.contentPad;
  static EdgeInsets predictionSocialScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionSocialContentGap = 16;
  static const double predictionSocialTabsHeight = 54;
  static const double predictionSocialTabIndicatorHeight =
      AppSpacing.hairlineStroke;
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
  static const double predictionSocialPostIconGap = AppSpacing.x3;
  static const double predictionSocialStanceHeight = 29;
  static const double predictionSocialReplyIndent = 48;
  static const double predictionSocialCommentHeaderGap = 10;
  static const double predictionSocialCommentMoreIcon = 18;
  static const double predictionSocialCommentBodyGap = 12;
  static const double predictionSocialReplyGap = 14;
  static const double predictionSocialUserBadgeGap = 6;
  static const double predictionSocialUserBadgeRunGap = AppSpacing.x1;
  static const double predictionSocialUserMetaGap = AppSpacing.x1;
  static const double predictionSocialTimeIcon = 11;
  static const double predictionSocialTimeIconGap = AppSpacing.x1;
  static const double predictionSocialStanceBadgeGap = 7;
  static const double predictionSocialActionGap = AppSpacing.x3;
  static const double predictionSocialActionReportGap = 10;
  static const double predictionSocialAvatar = 32;
  static const double predictionSocialAvatarIcon = 17;
  static const EdgeInsets predictionSocialSmallBadgePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const EdgeInsets predictionSocialActionPillPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 6);
  static const double predictionSocialActionIcon = 14;
  static const double predictionSocialActionIconGap = 5;
  static const double predictionSocialDisclosureIcon = 15;
  static const double predictionSocialDisclosureGap = AppSpacing.x3;
  static const double predictionSocialSentimentTitleGap = 16;
  static const double predictionSocialSentimentChartHeight = 190;
  static const double predictionSocialSentimentLegendGap = 12;
  static const double predictionSocialShareButtonGap = 12;
  static const double predictionSocialCopyTitleGap = 10;
  static const double predictionSocialCopyBoxHeight = 38;
  static const EdgeInsets predictionSocialCopyBoxPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double predictionSocialCopyButtonGap = AppSpacing.x3;
  static const double predictionSocialCopyIcon = 14;
  static const double predictionSocialPreviewImage = 60;
  static const double predictionSocialPreviewIcon = 28;
  static const double predictionSocialPreviewGap = 12;
  static const double predictionSocialPreviewTitleGap = 5;
  static const double predictionSocialPreviewBodyGap = 6;
  static const double predictionSocialContributorIcon = 20;
  static const double predictionSocialContributorGap = 12;
  static const double predictionSocialContributorBadgeGap = 6;
  static const double predictionSocialContributorMetaGap = AppSpacing.x1;
  static const double predictionSocialTrendGap = AppSpacing.x1;
  static const double predictionSocialShareButtonHeight = 56;
  static const EdgeInsets predictionSocialShareButtonPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const double predictionSocialShareIcon = 20;
  static const double predictionSocialShareIconGap = 10;
  static const double predictionSocialMetricGap = AppSpacing.x1;
  static const double predictionSocialLegendSwatch = 10;
  static const double predictionSocialLegendGap = AppSpacing.x1;
  static const double predictionSocialLegendValueGap = AppSpacing.x1;
  static const double predictionCalendarBottomInsetVisual = 54;
  static const double predictionCalendarBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionCalendarScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionCalendarContentGap = 16;
  static const double predictionCalendarTabsHeight = 54;
  static const double predictionCalendarTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double predictionCalendarTabIndicatorWidth = 116;
  static const double predictionCalendarFilterGap = AppSpacing.x3;
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
  static const double predictionCalendarTitleTrailingGap = AppSpacing.x3;
  static const EdgeInsets predictionCalendarStatusPadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: AppSpacing.x1);
  static const double predictionCalendarEventMetricGap = 10;
  static const double predictionCalendarTimeIcon = 12;
  static const double predictionCalendarTimeIconGap = 5;
  static const EdgeInsets predictionCalendarCategoryBadgePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x1);
  static const double predictionCalendarCategoryGap = AppSpacing.x3;
  static const double predictionCalendarChevron = 16;
  static const EdgeInsets predictionCalendarCardPadding = EdgeInsets.all(16);
  static const EdgeInsets predictionCalendarInfoPadding = EdgeInsets.all(12);
  static const EdgeInsets predictionCalendarNotificationRowPadding =
      EdgeInsets.symmetric(vertical: 10);
  static const double predictionCalendarNotificationLabelGap =
      AppSpacing.hairlineStroke;
  static const double predictionCalendarWatchingIcon = 17;
  static const double predictionCalendarWatchingIconGap = AppSpacing.x3;
  static const EdgeInsets predictionCalendarWatchingCategoryPadding =
      EdgeInsets.only(left: 25);
  static const double predictionCalendarWatchingCategoryGap = AppSpacing.x1;
  static const double predictionCalendarWatchingMetricGap = 14;
  static const double predictionCalendarEditButtonGap = 12;
  static const double predictionCalendarEditButtonHeight = 38;
  static const double predictionCalendarEditIcon = 15;
  static const double predictionCalendarEditIconGap = AppSpacing.x3;
  static const double predictionCalendarInfoIcon = 15;
  static const double predictionCalendarInfoIconGap = AppSpacing.x3;
  static const double predictionCalendarToggleWidth = 48;
  static const double predictionCalendarToggleHeight = 28;
  static const EdgeInsets predictionCalendarTogglePadding = EdgeInsets.all(2);
  static const double predictionCalendarToggleKnob = 24;
  static const double predictionCalendarStatGap = 6;
  static const double predictionCalendarMetricGap = AppSpacing.x1;
  static const double predictionTournamentBottomInsetVisual = 54;
  static const double predictionTournamentBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionTournamentScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionTournamentContentGap = 16;
  static const double predictionTournamentTabsHeight = 54;
  static const double predictionTournamentTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double predictionTournamentTabIndicatorWidth = 116;
  static const EdgeInsets predictionTournamentCardPadding = EdgeInsets.all(16);
  static const double predictionTournamentFeaturedIcon = 16;
  static const double predictionTournamentFeaturedIconGap = 7;
  static const double predictionTournamentFeaturedCardGap = 9;
  static const double predictionTournamentTitleIcon = 16;
  static const double predictionTournamentTitleIconGap = 6;
  static const double predictionTournamentDescriptionGap = AppSpacing.x1;
  static const double predictionTournamentStatusGap = 10;
  static const double predictionTournamentRankGap = 14;
  static const double predictionTournamentRankHeight = 35;
  static const EdgeInsets predictionTournamentRankPadding =
      EdgeInsets.symmetric(horizontal: 10);
  static const double predictionTournamentStatsGap = 14;
  static const double predictionTournamentDividerTopGap = 13;
  static const double predictionTournamentDividerHeight = 1;
  static const double predictionTournamentDividerBottomGap = 12;
  static const double predictionTournamentChevronGap = AppSpacing.x1;
  static const double predictionTournamentChevron = 16;
  static const int predictionTournamentStatsColumns = 2;
  static const double predictionTournamentStatsMainGap = AppSpacing.x3;
  static const double predictionTournamentStatsCrossGap = 16;
  static const double predictionTournamentStatsAspect = 4.6;
  static const double predictionTournamentStatIcon = 12;
  static const double predictionTournamentStatIconGap = 7;
  static const double predictionTournamentStatValueGap = AppSpacing.x1;
  static const EdgeInsets predictionTournamentPillPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 5);
  static const EdgeInsets predictionTournamentInfoPadding = EdgeInsets.all(12);
  static const double predictionTournamentInfoIcon = 14;
  static const double predictionTournamentInfoGap = AppSpacing.x3;
  static const double predictionTournamentMineStatsGap = 12;
  static const double predictionTournamentCenteredMetricGap = AppSpacing.x1;
  static const EdgeInsets predictionTournamentEmptyPadding =
      EdgeInsets.symmetric(horizontal: 18, vertical: 26);
  static const double predictionTournamentEmptyIcon = 44;
  static const double predictionTournamentEmptyTitleGap = 10;
  static const double predictionTournamentEmptyMessageGap = AppSpacing.x1;
  static const EdgeInsets predictionTournamentLeaderboardPadding =
      EdgeInsets.all(12);
  static const double predictionTournamentLeaderboardRankWidth = 32;
  static const double predictionTournamentLeaderboardWinnerIcon = 21;
  static const double predictionTournamentLeaderboardIcon = 18;
  static const double predictionTournamentLeaderboardGap = 10;
  static const double predictionTournamentLeaderboardScoreGap =
      AppSpacing.hairlineStroke;
  static const double predictionTournamentDetailHeroGap = 14;
  static const double predictionTournamentDetailDescriptionGap = AppSpacing.x3;
  static const double predictionAdvancedBottomInsetVisual = 54;
  static const double predictionAdvancedBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionAdvancedScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionAdvancedContentGap = 16;
  static const double predictionAdvancedTabsHeight = 54;
  static const double predictionAdvancedTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double predictionAdvancedTabIndicatorWidth = 116;
  static const double predictionAdvancedTimeframeGap = 10;
  static const double predictionAdvancedTimeframeHeight = 36;
  static const EdgeInsets predictionAdvancedCardPadding = EdgeInsets.all(16);
  static const double predictionAdvancedSummaryGap = 7;
  static const double predictionAdvancedSummaryValueGap = 9;
  static const EdgeInsets predictionAdvancedSummaryChangePadding =
      EdgeInsets.only(bottom: 5);
  static const double predictionAdvancedTrendIcon = 16;
  static const double predictionAdvancedTrendIconGap = AppSpacing.x1;
  static const double predictionAdvancedChartGap = 12;
  static const double predictionAdvancedProbabilityChartHeight = 286;
  static const double predictionAdvancedVolumeChartHeight = 122;
  static const int predictionAdvancedLayerColumns = 2;
  static const double predictionAdvancedLayerGap = AppSpacing.x3;
  static const double predictionAdvancedLayerAspect = 3.9;
  static const EdgeInsets predictionAdvancedLayerPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double predictionAdvancedLayerIcon = 14;
  static const double predictionAdvancedRsiHeight = 124;
  static const double predictionAdvancedRsiInfoIcon = 12;
  static const double predictionAdvancedRsiInfoGap = 7;
  static const EdgeInsets predictionAdvancedCompactPadding = EdgeInsets.all(12);
  static const double predictionAdvancedIndicatorDescGap =
      AppSpacing.hairlineStroke;
  static const double predictionAdvancedIndicatorStrengthGap = 10;
  static const double predictionAdvancedMiniBarHeight = AppSpacing.x1;
  static const double predictionAdvancedStrengthGap = 10;
  static const double predictionAdvancedOverallSignalGap = AppSpacing.x3;
  static const double predictionAdvancedOverallDescriptionGap = AppSpacing.x1;
  static const double predictionAdvancedOverallIcon = 18;
  static const double predictionAdvancedOrderFlowHeight = 202;
  static const double predictionAdvancedLevelValueGap = 5;
  static const double predictionAdvancedLevelHelperGap =
      AppSpacing.hairlineStroke;
  static const double predictionAdvancedLevelIcon = 18;
  static const double predictionAdvancedPatternGap = 14;
  static const double predictionAdvancedPatternIconGap = 7;
  static const double predictionAdvancedPatternIcon = 12;
  static const double predictionAdvancedPatternBarGap = 7;
  static const double predictionAdvancedPatternConfidenceGap = 12;
  static const double predictionAdvancedDisclaimerIcon = 14;
  static const double predictionAdvancedDisclaimerGap = AppSpacing.x3;
  static const EdgeInsets predictionAdvancedSignalBadgePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 5);
  static const double predictionAdvancedLegendSwatch = 12;
  static const double predictionAdvancedLegendGap = AppSpacing.x3;
  static const double predictionRewardsBottomInsetVisual = 54;
  static const double predictionRewardsBottomInsetNative =
      AppSpacing.contentPad;
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
    top: AppSpacing.x2,
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
  static const double predictionRewardsFilterGap = AppSpacing.x2;
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
  static const double predictionRewardsChevronGap = AppSpacing.x1;
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
  static const double predictionRewardsArenaMetaGap = AppSpacing.x2;
  static const double predictionRewardsArenaChevron = 17;
  static const EdgeInsets predictionRewardsTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: 3);
  static const double predictionRewardsTinyBadgeLineHeight = 1.1;
  static const double predictionLeaderboardBottomInsetVisual = 54;
  static const double predictionLeaderboardBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionLeaderboardScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionLeaderboardContentGap = 16;
  static const EdgeInsets predictionLeaderboardSheetPadding =
      predictionRewardsSheetPadding;
  static const double predictionLeaderboardTimeFilterHeight = 42;
  static const EdgeInsets predictionLeaderboardTimeFilterPadding =
      EdgeInsets.all(AppSpacing.x1);
  static const double predictionLeaderboardMetricGap = AppSpacing.x2;
  static const double predictionLeaderboardMetricHeight = 32;
  static const EdgeInsets predictionLeaderboardMetricPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets predictionLeaderboardInfoPadding = EdgeInsets.only(
    left: AppSpacing.x1,
  );
  static const double predictionLeaderboardInfoIcon = 12;
  static const double predictionLeaderboardMetricIcon = 13;
  static const double predictionLeaderboardMetricIconGap = 5;
  static const EdgeInsets predictionLeaderboardPodiumPadding =
      EdgeInsets.fromLTRB(14, 16, 14, 0);
  static const double predictionLeaderboardPodiumHeight = 198;
  static const List<double> predictionLeaderboardPodiumHeights = [90, 110, 75];
  static const double predictionLeaderboardPodiumAvatar = 22;
  static const double predictionLeaderboardPodiumAvatarGap = AppSpacing.x1;
  static const double predictionLeaderboardPodiumUserGap = 2;
  static const double predictionLeaderboardPodiumValueGap = 12;
  static const EdgeInsets predictionLeaderboardPodiumColumnMargin =
      EdgeInsets.symmetric(horizontal: 5);
  static const EdgeInsets predictionLeaderboardPodiumColumnPadding =
      EdgeInsets.only(bottom: 13);
  static const double predictionLeaderboardWinnerIcon = 14;
  static const double predictionLeaderboardWinnerGap = AppSpacing.x1;
  static const double predictionLeaderboardRankingHeaderHeight = 40;
  static const EdgeInsets predictionLeaderboardRankingPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const double predictionLeaderboardRankWidth = 32;
  static const double predictionLeaderboardMetricWidth = 84;
  static const double predictionLeaderboardWinRateWidth = 58;
  static const double predictionLeaderboardRankingRowHeight = 58;
  static const double predictionLeaderboardTraderAvatar = 17;
  static const double predictionLeaderboardTraderGap = AppSpacing.x2;
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
  static const double predictionSearchBottomInsetNative = AppSpacing.contentPad;
  static EdgeInsets predictionSearchScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionSearchContentGap = 14;
  static const EdgeInsets predictionSearchFilterPanelPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets predictionSearchFilterLabelGap = EdgeInsets.only(
    top: AppSpacing.x2,
  );
  static const EdgeInsets predictionSearchFilterSectionGap = EdgeInsets.only(
    top: 16,
  );
  static const double predictionSearchChipGap = AppSpacing.x2;
  static const EdgeInsets predictionSearchCategoryChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: AppSpacing.x2);
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
  static const double predictionSearchMetaSpacing = AppSpacing.x2;
  static const double predictionSearchMetaRunSpacing = AppSpacing.x1;
  static const EdgeInsets predictionSearchTinyBadgePadding =
      EdgeInsets.symmetric(horizontal: 7, vertical: 2);
  static const double predictionSearchEmptyHeight = 240;
  static const double predictionSearchEmptyIcon = 42;
  static const EdgeInsets predictionSearchEmptyTitleGap = EdgeInsets.only(
    top: 12,
  );
  static const EdgeInsets predictionSearchEmptyMessageGap = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const double predictionActivityBottomInsetVisual = 54;
  static const double predictionActivityBottomInsetNative =
      AppSpacing.contentPad;
  static EdgeInsets predictionActivityScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionActivityContentGap = 16;
  static const EdgeInsets predictionActivityLiveStatsPadding = EdgeInsets.all(
    16,
  );
  static const double predictionActivityLiveIcon = 15;
  static const double predictionActivityLiveDotOffset = -1;
  static const double predictionActivityLiveDotSize = 7;
  static const double predictionActivityLiveGap = AppSpacing.x2;
  static const EdgeInsets predictionActivityStatsTopGap = EdgeInsets.only(
    top: 14,
  );
  static const double predictionActivityStatsGap = 12;
  static const double predictionActivityStatHeight = 55;
  static const EdgeInsets predictionActivityStatValueGap = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const double predictionActivityFilterIcon = 13;
  static const double predictionActivityFilterGap = AppSpacing.x2;
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
  static const EdgeInsets predictionActivityEventGap = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets predictionActivityOrderGap = EdgeInsets.only(top: 5);
  static const double predictionActivityAmountGap = AppSpacing.x2;
  static const double predictionActivityAmountWidth = 58;
  static const EdgeInsets predictionActivityTimestampGap = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets predictionActivityOutcomePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const double predictionActivityOutcomeLineHeight = 1.0;
  static const double predictionDataBottomInsetVisual = 54;
  static const double predictionDataBottomInsetNative = AppSpacing.contentPad;
  static EdgeInsets predictionDataScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double predictionDataContentGap = 16;
  static const double predictionDataTabBarHeight = 54;
  static const double predictionDataTabIndicatorHeight =
      AppSpacing.hairlineStroke;
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
  static const double predictionDataHeaderWrapGap = AppSpacing.x2;
  static const double predictionDataHeaderRunGap = 5;
  static const double predictionDataSmallTopGap = AppSpacing.x1;
  static const double predictionDataSourceMetricsGap = 15;
  static const double predictionDataSourceUrlGap = 12;
  static const double predictionDataSourceLinkIcon = 12;
  static const double predictionDataSourceLinkGap = 7;
  static const EdgeInsets predictionDataStatusPillPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x1);
  static const double predictionDataStatusPillLineHeight = 1.0;
  static const EdgeInsets predictionDataNeutralChipPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: 5);
  static const double predictionDataInlineButtonSize = 30;
  static const double predictionDataInlineIcon = 15;
  static const double predictionDataIconBubble = 32;
  static const double predictionDataIconBubbleIcon = 16;
  static const double predictionDataPrimaryButtonHeight = 48;
  static const EdgeInsets predictionDataNoticePadding = EdgeInsets.all(12);
  static const double predictionDataNoticeIcon = 15;
  static const double predictionDataNoticeGap = AppSpacing.x2;
  static const double predictionDataNoticeLineHeight = 1.5;
  static const double predictionDataApiKeyBoxMinHeight = 44;
  static const EdgeInsets predictionDataApiKeyBoxPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: AppSpacing.x2,
  );
  static const double predictionDataApiKeyIcon = 15;
  static const double predictionDataApiKeyGap = AppSpacing.x2;
  static const double predictionDataApiKeyBoxTopGap = 14;
  static const double predictionDataPermissionsTopGap = 13;
  static const double predictionDataPermissionLabelGap = 7;
  static const double predictionDataChipGap = 6;
  static const double predictionDataLastUsedGap = 12;
  static const double predictionDataLastUsedIcon = 12;
  static const double predictionDataLastUsedIconGap = 6;
  static const double predictionDataWebhookHeaderIcon = 15;
  static const double predictionDataWebhookUrlGap = AppSpacing.x2;
  static const double predictionDataWebhookUrlLineHeight = 1.45;
  static const double predictionDataWebhookActionGap = 10;
  static const double predictionDataWebhookSectionGap = 14;
}
