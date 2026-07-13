final class TradeBackendContractMissingException implements Exception {
  const TradeBackendContractMissingException();

  String get message =>
      'Trade remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Trade service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'TradeBackendContractMissingException: $message';
}
