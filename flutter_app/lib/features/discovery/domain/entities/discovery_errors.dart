/// Thrown when [DiscoveryRepository] mock data is disabled but no
/// production remote implementation has been configured yet (ADR-001).
final class DiscoveryBackendContractMissingException implements Exception {
  const DiscoveryBackendContractMissingException();

  String get message =>
      'Discovery remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Discovery is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'DiscoveryBackendContractMissingException: $message';
}
