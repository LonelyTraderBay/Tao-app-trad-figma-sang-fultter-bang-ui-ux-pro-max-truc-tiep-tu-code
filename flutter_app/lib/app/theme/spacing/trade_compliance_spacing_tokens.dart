// DEBT-89 (A-Plus GD3): tach tu trade_spacing_tokens.dart (2261 dong) —
// literal cua khu Compliance (regulatory/complaint/product); facade TradeSpacingTokens giu alias cung ten nen
// call site khong doi. Const co tham chieu xuyen nhom van o lai facade.
import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

final class TradeComplianceSpacingTokens {
  const TradeComplianceSpacingTokens._();

  static const double complaintSubmissionBottomInsetVisual =
      AppSpacing.buttonCompact - AppSpacing.x2;
  static const double complaintSubmissionBottomInsetNative =
      AppSpacing.x5 + AppSpacing.x1;
  static const double complaintSubmissionSectionGap = AppSpacing.rowPy;
  static const double complaintSubmissionFooterHeight =
      AppSpacing.x7 + AppSpacing.x4;
  static const double complaintSubmissionLineHeightTight = 1;
  static const double complaintSubmissionLineHeightShort = 1.2;
  static const double complaintSubmissionLineHeightHint = 1.4;
  static const double complaintSubmissionLineHeightLong = 1.5;
  static const double complaintSubmissionMultilineHeight =
      WalletSpacingTokens.walletAddressCardHeight + AppSpacing.dividerHairline;
  static const double complaintSubmissionSingleLineHeight =
      WalletSpacingTokens.walletTransactionExplorerHeight;
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
  static const double complaintCaseBottomInsetVisual =
      AppSpacing.buttonCompact + AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double complaintCaseBottomInsetNative =
      AppSpacing.x5 + AppSpacing.x1;
  static const double complaintCaseLineHeightTight = 1;
  static const double complaintCaseLineHeightSlight = 1.1;
  static const double complaintCaseLineHeightTitle = 1.15;
  static const double complaintCaseLineHeightBody =
      complaintSubmissionLineHeightShort;
  static const double complaintCaseLineHeightReadable =
      complaintSubmissionLineHeightHint;
  static const double complaintCaseIconNudge = AppSpacing.dividerHairline;
  static const double complaintCaseSmallIcon =
      WalletSpacingTokens.walletAddressActionIcon;
  static const double complaintCaseActionIcon =
      WalletSpacingTokens.walletAddressAddAgreementIcon;
  static const EdgeInsets complaintCaseCardPadding =
      AppSpacing.cardPaddingCompact;
  static const EdgeInsets complaintCaseTitleNudgePadding = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets complaintCaseIconNudgePadding = EdgeInsets.only(
    top: complaintCaseIconNudge,
  );
  static const double complaintTrackingSectionGap =
      AppSpacing.sectionGapCompact;
  static const double complaintTrackingActionHeight =
      AppSpacing.buttonCompact + AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double complaintTrackingTimelineRailWidth = 32;
  static const double complaintTrackingTimelineConnectorHeight =
      WalletSpacingTokens.walletTokenHeroIcon;
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
  static const double complaintsHandlingBottomInsetVisual =
      AppSpacing.x7 +
      AppSpacing.sectionGapCompact +
      AppSpacing.x2 -
      AppSpacing.x1;
  static const double complaintsHandlingBottomInsetNative =
      AppSpacing.x5 + AppSpacing.x2 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double complaintsHandlingPrimaryGap = AppSpacing.x5;
  static const double complaintsHandlingReviewGap = AppSpacing.x4;
  static const double complaintsHandlingStatsGap = AppSpacing.x6;
  static const double complaintsHandlingTabGap = AppSpacing.x5;
  static const double complaintsHandlingCategoryWidth = 194;
  static const double complaintsHandlingCategoryHeight =
      WalletSpacingTokens.walletAddressSecurityCardHeight + AppSpacing.x3;
  static const double complaintsHandlingTimelineStepSize =
      AppSpacing.buttonCompact - AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double complaintsHandlingTimelineLabelGap =
      AppSpacing.formFieldLabelGap;
  static const double complaintsHandlingRightsIconGap = 10;
  static const EdgeInsets complaintsHandlingCategoryPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4,
        WalletSpacingTokens.walletAddressActionIcon + AppSpacing.hairlineStroke,
        AppSpacing.x4,
        AppSpacing.x4,
      );
  static const double productGovernanceBottomInsetVisual = 118;
  static const double productGovernanceBottomInsetNative = 28;
  static const double productGovernanceContentGap = AppSpacing.x3;
  static const double productGovernancePillGap = AppSpacing.x2;
  static const double productGovernanceTargetGap =
      AppSpacing.x4 - AppSpacing.hairlineStroke;
  static const double productGovernanceReviewGap = AppSpacing.x3;
  static const double productGovernanceReviewTextGap =
      AppSpacing.x2 - AppSpacing.hairlineStroke;
  static const double productGovernanceChannelIconBox =
      LaunchpadSpacingTokens.launchpadBox40;
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
  static const double regulatoryDisclosuresContactTextGap = AppSpacing.x1;
  static const double regulatoryDisclosuresNoticeTitleGap =
      AppSpacing.rowGapRegular;
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
}
