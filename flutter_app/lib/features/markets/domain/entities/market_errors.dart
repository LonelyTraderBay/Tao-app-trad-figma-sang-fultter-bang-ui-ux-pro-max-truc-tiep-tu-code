/// Thrown when a market remote repository is required but mock data is
/// disabled and the production backend has not been configured yet.
final class MarketBackendContractMissingException implements Exception {
  const MarketBackendContractMissingException();

  String get message =>
      'Market remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Market data is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'MarketBackendContractMissingException: $message';
}
