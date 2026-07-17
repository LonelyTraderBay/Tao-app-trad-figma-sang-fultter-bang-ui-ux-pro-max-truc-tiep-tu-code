/// Thrown when [DcaRepository] mock data is disabled but no production
/// remote implementation has been configured yet (ADR-001).
final class DcaBackendContractMissingException implements Exception {
  const DcaBackendContractMissingException();

  String get message =>
      'Dca remote repository is required when mock data is disabled.';

  String get userMessage =>
      'DCA service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'DcaBackendContractMissingException: $message';
}
