import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/onboarding/data/repositories/fail_closed_onboarding_repository.dart';
import 'package:vit_trade_flutter/features/onboarding/domain/entities/onboarding_errors.dart';

/// Smoke test for [FailClosedOnboardingRepository]: pins the fail-closed
/// contract wired into `onboardingRepositoryProvider` (see
/// `lib/features/onboarding/data/providers/onboarding_repository_provider.dart`)
/// for when mock data is disabled and no production backend is configured
/// yet.
///
/// [MockOnboardingRepository] itself is already exercised end-to-end in
/// `test/features/onboarding/mock_onboarding_repository_test.dart`; this
/// file fills the remaining gap — [FailClosedOnboardingRepository] relies on
/// `noSuchMethod` to reject every call on [OnboardingRepository] (there is
/// only one, `getFlow`), so this pins that the `noSuchMethod` override still
/// throws [OnboardingBackendContractMissingException] with the exact
/// `message`/`userMessage` copy rather than a generic `NoSuchMethodError`.
void main() {
  const repository = FailClosedOnboardingRepository();

  group('FailClosedOnboardingRepository smoke test', () {
    test('OnboardingBackendContractMissingException pins its message copy', () {
      const exception = OnboardingBackendContractMissingException();

      expect(
        exception.message,
        'Onboarding remote repository is required when mock data is '
        'disabled.',
      );
      expect(
        exception.userMessage,
        'Onboarding is unavailable because the production backend is '
        'not configured yet.',
      );
      expect(
        exception.toString(),
        'OnboardingBackendContractMissingException: Onboarding remote '
        'repository is required when mock data is disabled.',
      );
    });

    test('getFlow rejects with OnboardingBackendContractMissingException '
        'instead of a raw NoSuchMethodError', () {
      expect(
        repository.getFlow,
        throwsA(isA<OnboardingBackendContractMissingException>()),
      );
    });

    test('getFlow keeps rejecting the same way across repeated calls', () {
      expect(
        repository.getFlow,
        throwsA(isA<OnboardingBackendContractMissingException>()),
      );
      expect(
        repository.getFlow,
        throwsA(isA<OnboardingBackendContractMissingException>()),
      );
    });
  });
}
