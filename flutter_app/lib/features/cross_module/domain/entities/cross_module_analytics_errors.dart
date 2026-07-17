final class CrossModuleAnalyticsBackendContractMissingException
    implements Exception {
  const CrossModuleAnalyticsBackendContractMissingException();

  String get message =>
      'Cross-module analytics remote repository is required when mock data '
      'is disabled.';

  String get userMessage =>
      'Cross-module analytics is unavailable because the production backend '
      'is not configured yet.';

  @override
  String toString() =>
      'CrossModuleAnalyticsBackendContractMissingException: $message';
}
