import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/onboarding/data/providers/onboarding_repository_provider.dart';
import 'package:vit_trade_flutter/features/onboarding/presentation/controllers/onboarding_controller.dart';

export 'package:vit_trade_flutter/features/onboarding/presentation/controllers/onboarding_controller.dart';

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  return OnboardingController(ref.watch(onboardingRepositoryProvider));
});
