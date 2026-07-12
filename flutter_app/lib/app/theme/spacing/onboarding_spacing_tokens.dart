import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class OnboardingSpacingTokens {
  const OnboardingSpacingTokens._();

  static const double onboardingHeaderWelcomeTop = AppSpacing.x3;
  static const double onboardingHeaderWelcomeBottom = AppSpacing.x2;
  static const EdgeInsets onboardingHeaderWelcomePadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    onboardingHeaderWelcomeTop,
    AppSpacing.contentPad,
    onboardingHeaderWelcomeBottom,
  );
  static const double onboardingHeaderProgressTop = AppSpacing.x4;
  static const double onboardingHeaderProgressBottom = AppSpacing.x3;
  static const EdgeInsets onboardingHeaderProgressPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    onboardingHeaderProgressTop,
    AppSpacing.contentPad,
    onboardingHeaderProgressBottom,
  );
  static EdgeInsets onboardingFooterPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        AppSpacing.x5 + bottomInset,
      );
  static const EdgeInsets onboardingCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets onboardingGoalTilePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets onboardingSelectedCheckPadding = EdgeInsets.all(
    AppSpacing.x1,
  );
  static const int onboardingGoalGridColumns = 2;
  static const double onboardingGoalGridAspectRatio = 1.08;
  static const double onboardingHeroIconElevation = AppSpacing.x3;
  static const double onboardingBulletDotIcon = 7;
  static const double onboardingBulletIcon = 14;
}
