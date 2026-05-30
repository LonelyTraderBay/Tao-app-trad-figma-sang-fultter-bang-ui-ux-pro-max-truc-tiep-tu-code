final class PredictionsBackendContractMissingException implements Exception {
  const PredictionsBackendContractMissingException();

  String get message =>
      'Predictions remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Prediction Markets service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'PredictionsBackendContractMissingException: $message';
}
