/// Thrown when mock data is disabled but no production home repository has
/// been configured.
final class HomeBackendContractMissingException implements Exception {
  const HomeBackendContractMissingException();

  String get message =>
      'Home remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Home data is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'HomeBackendContractMissingException: $message';
}
