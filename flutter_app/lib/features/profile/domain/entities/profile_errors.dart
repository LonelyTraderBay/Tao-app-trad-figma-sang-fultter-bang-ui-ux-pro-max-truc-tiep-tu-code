final class ProfileBackendContractMissingException implements Exception {
  const ProfileBackendContractMissingException();

  String get message =>
      'Profile remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Profile service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'ProfileBackendContractMissingException: $message';
}
