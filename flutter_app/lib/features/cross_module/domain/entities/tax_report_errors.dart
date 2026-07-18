/// Thrown when [TaxReportRepository] mock data is disabled but no
/// production remote implementation has been configured yet (ADR-001).
final class TaxReportBackendContractMissingException implements Exception {
  const TaxReportBackendContractMissingException();

  String get message =>
      'Tax report remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Tax report is unavailable because the production backend is not '
      'configured yet.';

  @override
  String toString() => 'TaxReportBackendContractMissingException: $message';
}
