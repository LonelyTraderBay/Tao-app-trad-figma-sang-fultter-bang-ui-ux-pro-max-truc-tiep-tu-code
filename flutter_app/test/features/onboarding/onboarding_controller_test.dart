import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/onboarding/data/repositories/mock_onboarding_repository.dart';
import 'package:vit_trade_flutter/features/onboarding/presentation/controllers/onboarding_controller.dart';

void main() {
  group('OnboardingController', () {
    test('exposes onboarding flow through repository contract', () {
      final controller = OnboardingController(const MockOnboardingRepository());

      final snapshot = controller.getFlow();

      expect(snapshot.endpoint, '/api/mobile/onboarding/onboarding');
      expect(snapshot.steps, contains(OnboardingStepDraft.complete));
      expect(snapshot.modules, hasLength(5));
      expect(snapshot.boundaries.last.title, 'Open Arena');
      expect(snapshot.supportedStates, contains(OnboardingScreenState.offline));
    });
  });
}
