/// Thrown when the Launchpad feature needs a real repository but only mock data is configured.
final class LaunchpadBackendContractMissingException implements Exception {
  const LaunchpadBackendContractMissingException();

  String get message =>
      'Launchpad remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Launchpad service is unavailable because the production backend is '
      'not configured yet.';

  @override
  String toString() => 'LaunchpadBackendContractMissingException: $message';
}
