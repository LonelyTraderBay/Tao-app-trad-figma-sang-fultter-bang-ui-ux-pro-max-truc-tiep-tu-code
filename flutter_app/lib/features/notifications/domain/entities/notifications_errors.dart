/// Thrown when mock data is disabled but no production notifications
/// repository has been configured.
final class NotificationsBackendContractMissingException implements Exception {
  const NotificationsBackendContractMissingException();

  String get message =>
      'Notifications remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Notifications service is unavailable because the production backend is not configured yet.';

  @override
  String toString() => 'NotificationsBackendContractMissingException: $message';
}
