/// Thrown when mock data is disabled but no production news repository has
/// been configured.
final class NewsBackendContractMissingException implements Exception {
  const NewsBackendContractMissingException();

  String get message =>
      'News remote repository is required when mock data is disabled.';

  String get userMessage =>
      'News is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'NewsBackendContractMissingException: $message';
}
