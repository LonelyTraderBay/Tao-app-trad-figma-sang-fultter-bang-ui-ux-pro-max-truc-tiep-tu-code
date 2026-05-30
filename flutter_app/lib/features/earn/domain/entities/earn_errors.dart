final class EarnBackendContractMissingException implements Exception {
  const EarnBackendContractMissingException();

  String get message =>
      'Earn remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Earn service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'EarnBackendContractMissingException: $message';
}
