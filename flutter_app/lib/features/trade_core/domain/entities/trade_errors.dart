/// Thrown when a trade remote repository is required but mock data is
/// disabled and the production backend has not been configured yet.
final class TradeBackendContractMissingException implements Exception {
  const TradeBackendContractMissingException();

  String get message =>
      'Trade remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Trade service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'TradeBackendContractMissingException: $message';
}
