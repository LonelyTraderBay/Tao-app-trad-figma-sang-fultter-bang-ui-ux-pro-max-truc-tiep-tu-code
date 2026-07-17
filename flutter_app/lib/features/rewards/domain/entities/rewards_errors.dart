final class RewardsBackendContractMissingException implements Exception {
  const RewardsBackendContractMissingException();

  String get message =>
      'Rewards remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Rewards are unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'RewardsBackendContractMissingException: $message';
}
