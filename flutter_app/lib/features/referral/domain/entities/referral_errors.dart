final class ReferralBackendContractMissingException implements Exception {
  const ReferralBackendContractMissingException();

  String get message =>
      'Referral remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Referral data is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'ReferralBackendContractMissingException: $message';
}
