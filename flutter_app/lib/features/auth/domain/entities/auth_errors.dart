/// Thrown when [AuthRepository] mock data is disabled but no production
/// remote implementation has been configured yet (ADR-001).
final class AuthBackendContractMissingException implements Exception {
  const AuthBackendContractMissingException();

  String get message =>
      'Auth remote repository is required when mock data is disabled.';

  String get userMessage =>
      'Dịch vụ xác thực chưa sẵn sàng vì backend production chưa được cấu hình.';

  @override
  String toString() => 'AuthBackendContractMissingException: $message';
}
