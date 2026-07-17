/// Thrown when [OnboardingRepository] mock data is disabled but no
/// production remote implementation has been configured yet (ADR-001).
final class OnboardingBackendContractMissingException implements Exception {
  const OnboardingBackendContractMissingException();

  String get message =>
      'Onboarding remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Onboarding is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'OnboardingBackendContractMissingException: $message';
}
