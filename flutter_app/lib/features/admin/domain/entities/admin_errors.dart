/// Thrown when [AdminRepository] mock data is disabled but no production
/// remote implementation has been configured yet (ADR-001).
final class AdminBackendContractMissingException implements Exception {
  const AdminBackendContractMissingException();

  String get message =>
      'Admin remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Admin service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'AdminBackendContractMissingException: $message';
}
