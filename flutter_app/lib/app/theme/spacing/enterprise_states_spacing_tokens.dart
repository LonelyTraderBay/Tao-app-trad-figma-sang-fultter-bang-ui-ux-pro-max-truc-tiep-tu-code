import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/support_spacing_tokens.dart';

final class EnterpriseStatesSpacingTokens {
  const EnterpriseStatesSpacingTokens._();

  static const double enterpriseStatesLineHeightBody =
      SupportSpacingTokens.supportLineHeightExpanded;
  static EdgeInsets enterpriseStatesScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets enterpriseStatesHeroPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x4,
    AppSpacing.contentPad,
    AppSpacing.zero,
  );
  static const EdgeInsets enterpriseStatesContentPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const EdgeInsets enterpriseStatesTabShellPadding = EdgeInsets.all(
    AppSpacing.x1,
  );
  static const EdgeInsets enterpriseStatesTabButtonPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.rowPy,
      );
  static const EdgeInsets enterpriseStatesCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets enterpriseStatesFrameHeaderPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: AppSpacing.x3);
  static const EdgeInsets enterpriseStatesPreviewPadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets enterpriseStatesPreviewLargePadding = EdgeInsets.all(
    AppSpacing.x6,
  );
}
