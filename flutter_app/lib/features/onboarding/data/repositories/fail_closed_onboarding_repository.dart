import 'package:vit_trade_flutter/features/onboarding/domain/entities/onboarding_errors.dart';
import 'package:vit_trade_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';

final class FailClosedOnboardingRepository implements OnboardingRepository {
  const FailClosedOnboardingRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const OnboardingBackendContractMissingException();
  }
}
