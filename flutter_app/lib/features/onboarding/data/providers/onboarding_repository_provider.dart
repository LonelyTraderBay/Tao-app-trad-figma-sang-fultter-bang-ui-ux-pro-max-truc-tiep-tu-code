import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:vit_trade_flutter/features/onboarding/data/repositories/fail_closed_onboarding_repository.dart';
import 'package:vit_trade_flutter/features/onboarding/data/repositories/mock_onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Onboarding',
    mock: () => const MockOnboardingRepository(),
    failClosed: () => const FailClosedOnboardingRepository(),
  ),
);
