final class SupportBackendContractMissingException implements Exception {
  const SupportBackendContractMissingException();

  String get message =>
      'Support remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Support is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'SupportBackendContractMissingException: $message';
}
