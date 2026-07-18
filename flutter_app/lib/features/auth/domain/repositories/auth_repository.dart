import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';

/// Data source contract for the Auth feature: login, registration, OTP
/// verification, two-factor setup, and password reset.
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
