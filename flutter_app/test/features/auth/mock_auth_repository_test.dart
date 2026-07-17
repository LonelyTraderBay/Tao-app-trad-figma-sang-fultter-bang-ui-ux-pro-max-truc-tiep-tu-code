import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';

/// Smoke test for [MockAuthRepository]: exercises every method on
/// [AuthRepository] and asserts each call succeeds without throwing and
/// returns a plausible, correctly-typed result.
void main() {
  const repository = MockAuthRepository(delay: Duration.zero);

  group('MockAuthRepository smoke test', () {
    test('login returns a populated session', () async {
      final session = await repository.login(
        identifier: 'user@vittrade.vn',
        password: 'secret',
      );

      expect(session, isA<AuthSession>());
      expect(session.identifier, 'user@vittrade.vn');
      expect(session.demo, isFalse);
      expect(session.issuedAt, isA<DateTime>());
    });

    test('login honors the demo flag', () async {
      final session = await repository.login(
        identifier: 'demo@vittrade.vn',
        password: 'secret',
        demo: true,
      );

      expect(session.demo, isTrue);
    });

    test('register returns a populated registration draft', () async {
      final draft = await repository.register(
        name: 'Vit Trader',
        contact: 'trader@vittrade.vn',
        contactType: AuthContactType.email,
        password: 'super-secret',
        referralCode: 'REF123',
      );

      expect(draft, isA<AuthRegistrationDraft>());
      expect(draft.authSession.identifier, 'trader@vittrade.vn');
      expect(draft.userCredentials.name, 'Vit Trader');
      expect(draft.userCredentials.contact, 'trader@vittrade.vn');
      expect(draft.userCredentials.contactType, AuthContactType.email);
      expect(draft.userCredentials.referralCode, 'REF123');
      expect(draft.otpChallenge.contact, 'trader@vittrade.vn');
      expect(draft.otpChallenge.purpose, 'register');
      expect(draft.deviceTrust.trusted, isFalse);
    });

    test('register does not require a referral code', () async {
      final draft = await repository.register(
        name: 'Vit Trader',
        contact: 'trader@vittrade.vn',
        contactType: AuthContactType.phone,
        password: 'super-secret',
      );

      expect(draft.userCredentials.referralCode, isNull);
      expect(draft.userCredentials.contactType, AuthContactType.phone);
    });

    test('verifyFactor succeeds for the accepted mock code', () async {
      final draft = await repository.verifyFactor(
        contact: 'trader@vittrade.vn',
        code: '123456',
        purpose: AuthOtpPurpose.register,
      );

      expect(draft, isA<AuthOtpVerificationDraft>());
      expect(draft.success, isTrue);
      expect(draft.authSession.identifier, 'trader@vittrade.vn');
      expect(draft.otpChallenge.purpose, AuthOtpPurpose.register.name);
      expect(draft.deviceTrust.trusted, isTrue);
      expect(draft.errorMessage, isNull);
    });

    test('verifyFactor fails without throwing for an incorrect code', () async {
      late final AuthOtpVerificationDraft draft;

      await expectLater(
        () async => draft = await repository.verifyFactor(
          contact: 'trader@vittrade.vn',
          code: 'wrong',
          purpose: AuthOtpPurpose.twoFactor,
        ),
        returnsNormally,
      );
      expect(draft.success, isFalse);
      expect(draft.deviceTrust.trusted, isFalse);
      expect(draft.errorMessage, isNotNull);
      expect(draft.errorMessage, isNotEmpty);
    });

    test('setupTwoFactor succeeds when all inputs are valid', () async {
      final draft = await repository.setupTwoFactor(
        secretKey: 'secret-key',
        code: '123456',
        backupCodesSaved: true,
      );

      expect(draft, isA<AuthTwoFaSetupDraft>());
      expect(draft.success, isTrue);
      expect(draft.auditTrailRequired, isTrue);
      expect(draft.deviceTrust.trusted, isTrue);
      expect(draft.errorMessage, isNull);
    });

    test('setupTwoFactor does not throw and reports failure when backup codes '
        'are not saved', () async {
      late final AuthTwoFaSetupDraft draft;

      await expectLater(
        () async => draft = await repository.setupTwoFactor(
          secretKey: 'secret-key',
          code: '123456',
          backupCodesSaved: false,
        ),
        returnsNormally,
      );
      expect(draft.success, isFalse);
      expect(draft.errorMessage, isNotNull);
    });

    test('requestPasswordReset returns a populated draft', () async {
      final draft = await repository.requestPasswordReset(
        email: 'trader@vittrade.vn',
      );

      expect(draft, isA<AuthPasswordResetDraft>());
      expect(draft.success, isTrue);
      expect(draft.authSession.identifier, 'trader@vittrade.vn');
      expect(draft.otpChallenge.purpose, AuthOtpPurpose.passwordReset.name);
      expect(draft.auditTrailRequired, isTrue);
      expect(draft.errorMessage, isNull);
    });

    test('requestPasswordReset does not throw and reports failure for an '
        'empty email', () async {
      late final AuthPasswordResetDraft draft;

      await expectLater(
        () async => draft = await repository.requestPasswordReset(email: ''),
        returnsNormally,
      );
      expect(draft.success, isFalse);
      expect(draft.errorMessage, isNotNull);
    });

    test('resetPassword returns a populated draft for valid inputs', () async {
      final draft = await repository.resetPassword(
        email: 'trader@vittrade.vn',
        otp: '123456',
        newPassword: 'brand-new-password',
      );

      expect(draft, isA<AuthPasswordResetDraft>());
      expect(draft.success, isTrue);
      expect(draft.authSession.identifier, 'trader@vittrade.vn');
      expect(draft.deviceTrust.trusted, isTrue);
      expect(draft.errorMessage, isNull);
    });

    test(
      'resetPassword does not throw and reports failure for an invalid otp',
      () async {
        late final AuthPasswordResetDraft draft;

        await expectLater(
          () async => draft = await repository.resetPassword(
            email: 'trader@vittrade.vn',
            otp: 'bad',
            newPassword: 'brand-new-password',
          ),
          returnsNormally,
        );
        expect(draft.success, isFalse);
        expect(draft.errorMessage, isNotNull);
      },
    );
  });
}
