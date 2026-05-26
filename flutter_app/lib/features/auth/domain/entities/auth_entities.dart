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
