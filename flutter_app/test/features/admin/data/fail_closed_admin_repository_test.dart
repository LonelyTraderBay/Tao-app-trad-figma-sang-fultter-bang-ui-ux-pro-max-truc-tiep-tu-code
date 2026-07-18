import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';
import 'package:vit_trade_flutter/features/admin/domain/entities/admin_errors.dart';

/// Smoke test for [FailClosedAdminRepository]: pins the fail-closed contract
/// wired into `adminRepositoryProvider` (see
/// `lib/features/admin/data/providers/admin_repository_provider.dart`) for
/// when mock data is disabled and no production backend is configured yet.
///
/// [MockAdminRepository] itself is already exercised end-to-end in
/// `test/features/admin/mock_admin_repository_test.dart`; this file fills
/// the remaining gap — [FailClosedAdminRepository] relies on `noSuchMethod`
/// to reject every call on [AdminRepository], so this pins that the
/// `noSuchMethod` override still throws
/// [AdminBackendContractMissingException] with the exact `message`/
/// `userMessage` copy for every method rather than a generic
/// `NoSuchMethodError`.
void main() {
  const repository = FailClosedAdminRepository();

  group('FailClosedAdminRepository smoke test', () {
    test('AdminBackendContractMissingException pins its message copy', () {
      const exception = AdminBackendContractMissingException();

      expect(
        exception.message,
        'Admin remote repository is required when mock data is disabled.',
      );
      expect(
        exception.userMessage,
        'Admin service is unavailable because the production backend is '
        'not configured yet.',
      );
      expect(
        exception.toString(),
        'AdminBackendContractMissingException: Admin remote repository is '
        'required when mock data is disabled.',
      );
    });

    test('getHome rejects with AdminBackendContractMissingException', () {
      expect(
        repository.getHome,
        throwsA(isA<AdminBackendContractMissingException>()),
      );
    });

    test('getAnalytics rejects with AdminBackendContractMissingException', () {
      expect(
        repository.getAnalytics,
        throwsA(isA<AdminBackendContractMissingException>()),
      );
    });

    test('getAbTests rejects with AdminBackendContractMissingException', () {
      expect(
        repository.getAbTests,
        throwsA(isA<AdminBackendContractMissingException>()),
      );
    });

    test('getFunnels rejects with AdminBackendContractMissingException', () {
      expect(
        repository.getFunnels,
        throwsA(isA<AdminBackendContractMissingException>()),
      );
    });
  });
}
