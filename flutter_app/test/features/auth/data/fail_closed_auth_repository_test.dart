import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';

/// Smoke test for [FailClosedAuthRepository]: pins the fail-closed contract
/// wired into `authRepositoryProvider` (see
/// `lib/features/auth/data/providers/auth_repository_provider.dart`) for when
/// mock data is disabled and no production backend is configured yet.
///
/// [MockAuthRepository] itself is already exercised end-to-end in
/// `test/features/auth/mock_auth_repository_test.dart`; this file fills the
/// remaining gap — every method on [AuthRepository] rejects with
/// [AuthBackendContractMissingException] carrying the exact `message`/
/// `userMessage` copy, and the page-level wrapper
/// (`authOperationErrorMessage`) surfaces the "Authentication service is
/// temporarily unavailable..." copy asserted in `login_page_test.dart`.
void main() {
  const repository = FailClosedAuthRepository();

  group('FailClosedAuthRepository smoke test', () {
    test('AuthBackendContractMissingException pins its message copy', () {
      const exception = AuthBackendContractMissingException();

      expect(
        exception.message,
        'Auth remote repository is required when mock data is disabled.',
      );
      expect(
        exception.userMessage,
        'Authentication service is unavailable because the production '
        'backend is not configured yet.',
      );
      expect(
        exception.toString(),
        'AuthBackendContractMissingException: Auth remote repository is '
        'required when mock data is disabled.',
      );
    });

    test('login rejects with AuthBackendContractMissingException', () async {
      await expectLater(
        repository.login(identifier: 'user@vittrade.vn', password: 'secret'),
        throwsA(isA<AuthBackendContractMissingException>()),
      );
    });

    test('register rejects with AuthBackendContractMissingException', () async {
      await expectLater(
        repository.register(
          name: 'Vit Trader',
          contact: 'trader@vittrade.vn',
          contactType: AuthContactType.email,
          password: 'super-secret',
          referralCode: 'REF123',
        ),
        throwsA(isA<AuthBackendContractMissingException>()),
      );
    });

    test(
      'verifyFactor rejects with AuthBackendContractMissingException',
      () async {
        await expectLater(
          repository.verifyFactor(
            contact: 'trader@vittrade.vn',
            code: '123456',
            purpose: AuthOtpPurpose.register,
          ),
          throwsA(isA<AuthBackendContractMissingException>()),
        );
      },
    );

    test(
      'setupTwoFactor rejects with AuthBackendContractMissingException',
      () async {
        await expectLater(
          repository.setupTwoFactor(
            secretKey: 'secret-key',
            code: '123456',
            backupCodesSaved: true,
          ),
          throwsA(isA<AuthBackendContractMissingException>()),
        );
      },
    );

    test('requestPasswordReset rejects with '
        'AuthBackendContractMissingException', () async {
      await expectLater(
        repository.requestPasswordReset(email: 'trader@vittrade.vn'),
        throwsA(isA<AuthBackendContractMissingException>()),
      );
    });

    test(
      'resetPassword rejects with AuthBackendContractMissingException',
      () async {
        await expectLater(
          repository.resetPassword(
            email: 'trader@vittrade.vn',
            otp: '123456',
            newPassword: 'brand-new-password',
          ),
          throwsA(isA<AuthBackendContractMissingException>()),
        );
      },
    );
  });
}
