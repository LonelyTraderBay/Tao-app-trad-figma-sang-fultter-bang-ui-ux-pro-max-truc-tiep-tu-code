import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return const MockAuthRepository();
});

abstract interface class AuthRepository {
  Future<AuthSession> login({
    required String identifier,
    required String password,
    bool demo,
  });

  Future<AuthRegistrationDraft> register({
    required String name,
    required String contact,
    required AuthContactType contactType,
    required String password,
    String? referralCode,
  });

  Future<AuthOtpVerificationDraft> verifyFactor({
    required String contact,
    required String code,
    required AuthOtpPurpose purpose,
  });

  Future<AuthTwoFaSetupDraft> setupTwoFactor({
    required String secretKey,
    required String code,
    required bool backupCodesSaved,
  });

  Future<AuthPasswordResetDraft> requestPasswordReset({required String email});

  Future<AuthPasswordResetDraft> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

enum AuthContactType { email, phone }

enum AuthOtpPurpose { register, twoFactor, passwordReset, verify }

final class AuthSession {
  const AuthSession({
    required this.identifier,
    required this.demo,
    required this.issuedAt,
  });

  final String identifier;
  final bool demo;
  final DateTime issuedAt;
}

final class AuthRegistrationDraft {
  const AuthRegistrationDraft({
    required this.authSession,
    required this.userCredentials,
    required this.otpChallenge,
    required this.deviceTrust,
  });

  final AuthSession authSession;
  final AuthUserCredentialsDraft userCredentials;
  final AuthOtpChallengeDraft otpChallenge;
  final AuthDeviceTrustDraft deviceTrust;
}

final class AuthUserCredentialsDraft {
  const AuthUserCredentialsDraft({
    required this.name,
    required this.contact,
    required this.contactType,
    this.referralCode,
  });

  final String name;
  final String contact;
  final AuthContactType contactType;
  final String? referralCode;
}

final class AuthOtpChallengeDraft {
  const AuthOtpChallengeDraft({
    required this.contact,
    required this.channel,
    required this.purpose,
  });

  final String contact;
  final AuthContactType channel;
  final String purpose;
}

final class AuthDeviceTrustDraft {
  const AuthDeviceTrustDraft({
    required this.deviceLabel,
    required this.trusted,
  });

  final String deviceLabel;
  final bool trusted;
}

final class AuthOtpVerificationDraft {
  const AuthOtpVerificationDraft({
    required this.success,
    required this.authSession,
    required this.userCredentials,
    required this.otpChallenge,
    required this.deviceTrust,
    this.errorMessage,
  });

  final bool success;
  final AuthSession authSession;
  final AuthUserCredentialsDraft userCredentials;
  final AuthOtpChallengeDraft otpChallenge;
  final AuthDeviceTrustDraft deviceTrust;
  final String? errorMessage;
}

final class AuthTwoFaSetupDraft {
  const AuthTwoFaSetupDraft({
    required this.success,
    required this.authSession,
    required this.userCredentials,
    required this.otpChallenge,
    required this.deviceTrust,
    required this.auditTrailRequired,
    this.errorMessage,
  });

  final bool success;
  final AuthSession authSession;
  final AuthUserCredentialsDraft userCredentials;
  final AuthOtpChallengeDraft otpChallenge;
  final AuthDeviceTrustDraft deviceTrust;
  final bool auditTrailRequired;
  final String? errorMessage;
}

final class AuthPasswordResetDraft {
  const AuthPasswordResetDraft({
    required this.success,
    required this.authSession,
    required this.userCredentials,
    required this.otpChallenge,
    required this.deviceTrust,
    required this.auditTrailRequired,
    this.errorMessage,
  });

  final bool success;
  final AuthSession authSession;
  final AuthUserCredentialsDraft userCredentials;
  final AuthOtpChallengeDraft otpChallenge;
  final AuthDeviceTrustDraft deviceTrust;
  final bool auditTrailRequired;
  final String? errorMessage;
}

final class MockAuthRepository implements AuthRepository {
  const MockAuthRepository({this.delay = const Duration(milliseconds: 250)});

  final Duration delay;

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
    bool demo = false,
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    return AuthSession(
      identifier: identifier,
      demo: demo,
      issuedAt: DateTime.now(),
    );
  }

  @override
  Future<AuthRegistrationDraft> register({
    required String name,
    required String contact,
    required AuthContactType contactType,
    required String password,
    String? referralCode,
  }) async {
    assert(password.isNotEmpty);
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    return AuthRegistrationDraft(
      authSession: AuthSession(
        identifier: contact,
        demo: false,
        issuedAt: DateTime.now(),
      ),
      userCredentials: AuthUserCredentialsDraft(
        name: name,
        contact: contact,
        contactType: contactType,
        referralCode: referralCode,
      ),
      otpChallenge: AuthOtpChallengeDraft(
        contact: contact,
        channel: contactType,
        purpose: 'register',
      ),
      deviceTrust: const AuthDeviceTrustDraft(
        deviceLabel: 'Flutter mock device',
        trusted: false,
      ),
    );
  }

  @override
  Future<AuthOtpVerificationDraft> verifyFactor({
    required String contact,
    required String code,
    required AuthOtpPurpose purpose,
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final success = code == '123456';
    return AuthOtpVerificationDraft(
      success: success,
      authSession: AuthSession(
        identifier: contact,
        demo: false,
        issuedAt: DateTime.now(),
      ),
      userCredentials: AuthUserCredentialsDraft(
        name: 'VitTrade User',
        contact: contact,
        contactType: AuthContactType.email,
      ),
      otpChallenge: AuthOtpChallengeDraft(
        contact: contact,
        channel: AuthContactType.email,
        purpose: purpose.name,
      ),
      deviceTrust: AuthDeviceTrustDraft(
        deviceLabel: success ? 'Verified Flutter mock device' : 'Unverified',
        trusted: success,
      ),
      errorMessage: success ? null : 'Mã OTP không đúng. Vui lòng thử lại.',
    );
  }

  @override
  Future<AuthTwoFaSetupDraft> setupTwoFactor({
    required String secretKey,
    required String code,
    required bool backupCodesSaved,
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final success =
        secretKey.isNotEmpty && code == '123456' && backupCodesSaved;
    return AuthTwoFaSetupDraft(
      success: success,
      authSession: AuthSession(
        identifier: 'user@vittrade.vn',
        demo: false,
        issuedAt: DateTime.now(),
      ),
      userCredentials: const AuthUserCredentialsDraft(
        name: 'VitTrade User',
        contact: 'user@vittrade.vn',
        contactType: AuthContactType.email,
      ),
      otpChallenge: const AuthOtpChallengeDraft(
        contact: 'user@vittrade.vn',
        channel: AuthContactType.email,
        purpose: 'twoFactorSetup',
      ),
      deviceTrust: AuthDeviceTrustDraft(
        deviceLabel: success
            ? '2FA enabled Flutter mock device'
            : 'Pending 2FA setup',
        trusted: success,
      ),
      auditTrailRequired: true,
      errorMessage: success
          ? null
          : 'Không thể hoàn tất 2FA. Kiểm tra mã xác thực và mã dự phòng.',
    );
  }

  @override
  Future<AuthPasswordResetDraft> requestPasswordReset({
    required String email,
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final normalizedEmail = email.trim();
    final success = normalizedEmail.isNotEmpty;
    return AuthPasswordResetDraft(
      success: success,
      authSession: AuthSession(
        identifier: normalizedEmail,
        demo: false,
        issuedAt: DateTime.now(),
      ),
      userCredentials: AuthUserCredentialsDraft(
        name: 'VitTrade User',
        contact: normalizedEmail,
        contactType: AuthContactType.email,
      ),
      otpChallenge: AuthOtpChallengeDraft(
        contact: normalizedEmail,
        channel: AuthContactType.email,
        purpose: AuthOtpPurpose.passwordReset.name,
      ),
      deviceTrust: const AuthDeviceTrustDraft(
        deviceLabel: 'Password reset Flutter mock device',
        trusted: false,
      ),
      auditTrailRequired: true,
      errorMessage: success ? null : 'Vui lòng nhập email đã đăng ký.',
    );
  }

  @override
  Future<AuthPasswordResetDraft> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final normalizedEmail = email.trim();
    final success =
        normalizedEmail.isNotEmpty &&
        otp.length == 6 &&
        newPassword.length >= 8;
    return AuthPasswordResetDraft(
      success: success,
      authSession: AuthSession(
        identifier: normalizedEmail,
        demo: false,
        issuedAt: DateTime.now(),
      ),
      userCredentials: AuthUserCredentialsDraft(
        name: 'VitTrade User',
        contact: normalizedEmail,
        contactType: AuthContactType.email,
      ),
      otpChallenge: AuthOtpChallengeDraft(
        contact: normalizedEmail,
        channel: AuthContactType.email,
        purpose: AuthOtpPurpose.passwordReset.name,
      ),
      deviceTrust: AuthDeviceTrustDraft(
        deviceLabel: success
            ? 'Password reset verified Flutter mock device'
            : 'Password reset pending',
        trusted: success,
      ),
      auditTrailRequired: true,
      errorMessage: success
          ? null
          : 'Không thể đặt lại mật khẩu. Vui lòng kiểm tra mã OTP.',
    );
  }
}
