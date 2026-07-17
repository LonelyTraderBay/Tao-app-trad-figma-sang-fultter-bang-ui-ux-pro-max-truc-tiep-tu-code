final class OnboardingBackendContractMissingException implements Exception {
  const OnboardingBackendContractMissingException();

  String get message =>
      'Onboarding remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Onboarding is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'OnboardingBackendContractMissingException: $message';
}
