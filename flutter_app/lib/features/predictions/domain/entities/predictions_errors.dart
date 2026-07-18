/// Thrown when [PredictionsRepository] mock data is disabled but no
/// production remote implementation has been configured yet (ADR-001).
final class PredictionsBackendContractMissingException implements Exception {
  const PredictionsBackendContractMissingException();

  String get message =>
      'Predictions remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Prediction Markets service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'PredictionsBackendContractMissingException: $message';
}
