import 'package:vit_trade_flutter/features/onboarding/domain/entities/onboarding_entities.dart';
import 'package:vit_trade_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';

export 'package:vit_trade_flutter/features/onboarding/domain/entities/onboarding_entities.dart';
export 'package:vit_trade_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';

final class OnboardingController implements OnboardingRepository {
  const OnboardingController(this._repository);

  final OnboardingRepository _repository;

  @override
  OnboardingSnapshot getFlow() {
    return _repository.getFlow();
  }
}
