final class WalletBackendContractMissingException implements Exception {
  const WalletBackendContractMissingException();

  String get message =>
      'Wallet remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Wallet service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'WalletBackendContractMissingException: $message';
}
