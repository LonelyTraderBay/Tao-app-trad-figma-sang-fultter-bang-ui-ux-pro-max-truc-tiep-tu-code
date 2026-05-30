import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_errors.dart';
import 'package:vit_trade_flutter/features/auth/domain/repositories/auth_repository.dart';

final class FailClosedAuthRepository implements AuthRepository {
  const FailClosedAuthRepository();

  Future<T> _missingContract<T>() {
    return Future<T>.error(const AuthBackendContractMissingException());
  }

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
    bool demo = false,
  }) {
    return _missingContract();
  }

  @override
  Future<AuthRegistrationDraft> register({
    required String name,
    required String contact,
    required AuthContactType contactType,
    required String password,
    String? referralCode,
  }) {
    return _missingContract();
  }

  @override
  Future<AuthOtpVerificationDraft> verifyFactor({
    required String contact,
    required String code,
    required AuthOtpPurpose purpose,
  }) {
    return _missingContract();
  }

  @override
  Future<AuthTwoFaSetupDraft> setupTwoFactor({
    required String secretKey,
    required String code,
    required bool backupCodesSaved,
  }) {
    return _missingContract();
  }

  @override
  Future<AuthPasswordResetDraft> requestPasswordReset({required String email}) {
    return _missingContract();
  }

  @override
  Future<AuthPasswordResetDraft> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return _missingContract();
  }
}
