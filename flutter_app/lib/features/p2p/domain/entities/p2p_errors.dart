final class P2PBackendContractMissingException implements Exception {
  const P2PBackendContractMissingException();

  String get message =>
      'P2P remote repository is required when mock data is disabled.';

  String get userMessage =>
      'P2P service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'P2PBackendContractMissingException: $message';
}
