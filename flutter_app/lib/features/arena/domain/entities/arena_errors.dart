final class ArenaBackendContractMissingException implements Exception {
  const ArenaBackendContractMissingException();

  String get message =>
      'Arena remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Open Arena service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'ArenaBackendContractMissingException: $message';
}
