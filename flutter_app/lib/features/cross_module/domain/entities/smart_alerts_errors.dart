final class SmartAlertsBackendContractMissingException implements Exception {
  const SmartAlertsBackendContractMissingException();

  String get message =>
      'Smart alerts remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Smart alerts are unavailable because the production backend is not '
      'configured yet.';

  @override
  String toString() => 'SmartAlertsBackendContractMissingException: $message';
}
