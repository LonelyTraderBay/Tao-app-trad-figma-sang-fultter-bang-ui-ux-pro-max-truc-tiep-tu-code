import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';

void main() {
  ProviderContainer container() {
    final value = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const MockAuthRepository(delay: Duration.zero),
        ),
      ],
    );
    addTearDown(value.dispose);
    return value;
  }

  test('AuthController trims credentials before login', () async {
    final controller = container().read(authControllerProvider);

    final session = await controller.login(
      identifier: ' user@vittrade.vn ',
      password: 'secret',
    );

    expect(session.identifier, 'user@vittrade.vn');
    expect(session.demo, isFalse);
  });

  test('AuthController exposes OTP and reset intents', () async {
    final controller = container().read(authControllerProvider);

    final otp = await controller.verifyFactor(
      contact: ' user@vittrade.vn ',
      code: ' 123456 ',
      purpose: AuthOtpPurpose.passwordReset,
    );
    final reset = await controller.resetPassword(
      email: ' user@vittrade.vn ',
      otp: ' 123456 ',
      newPassword: 'new-password',
    );

    expect(otp.success, isTrue);
    expect(otp.otpChallenge.contact, 'user@vittrade.vn');
    expect(reset.success, isTrue);
    expect(reset.authSession.identifier, 'user@vittrade.vn');
  });

  test('AuthController forwards 2FA backup-code gate', () async {
    final controller = container().read(authControllerProvider);

    final blocked = await controller.setupTwoFactor(
      secretKey: 'secret',
      code: '123456',
      backupCodesSaved: false,
    );
    final enabled = await controller.setupTwoFactor(
      secretKey: 'secret',
      code: '123456',
      backupCodesSaved: true,
    );

    expect(blocked.success, isFalse);
    expect(enabled.success, isTrue);
  });
}
