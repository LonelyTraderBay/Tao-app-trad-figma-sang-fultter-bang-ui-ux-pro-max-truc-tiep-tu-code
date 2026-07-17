import 'package:vit_trade_flutter/features/onboarding/domain/entities/onboarding_entities.dart';

/// Data source contract for the Onboarding feature.
abstract interface class OnboardingRepository {
  OnboardingSnapshot getFlow();
}
