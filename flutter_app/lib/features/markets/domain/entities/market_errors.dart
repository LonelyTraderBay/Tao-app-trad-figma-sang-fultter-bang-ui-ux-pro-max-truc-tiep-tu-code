final class MarketBackendContractMissingException implements Exception {
  const MarketBackendContractMissingException();

  String get message =>
      'Market remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Market data is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'MarketBackendContractMissingException: $message';
}
