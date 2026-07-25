/// The channel a contact identifier (email or phone) belongs to.
enum AuthContactType { email, phone }

/// What an OTP code is being requested/verified for.
enum AuthOtpPurpose { register, twoFactor, passwordReset, verify }

/// A signed-in session (identifier, demo flag, issue time).
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

/// Cặp access/refresh token sau login hoặc refresh (P0.4).
///
/// Token sống trong [SecureStore], không serialize vào [AuthSession] JSON
/// để tránh lẫn metadata phiên với bí mật phiên.
final class AuthTokenPair {
  const AuthTokenPair({required this.accessToken, this.refreshToken});

  final String accessToken;
  final String? refreshToken;
}

/// Result of a registration attempt: the new [authSession] plus the
/// credentials, OTP challenge, and device-trust state that produced it.
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

/// Submitted registration credentials (name, contact, optional referral
/// code).
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

/// A pending OTP challenge (contact, delivery channel, purpose).
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

/// The current device's label and whether it is trusted.
final class AuthDeviceTrustDraft {
  const AuthDeviceTrustDraft({
    required this.deviceLabel,
    required this.trusted,
  });

  final String deviceLabel;
  final bool trusted;
}

/// Result of verifying an OTP code, including success/error state and the
/// resulting session/credentials/challenge/device context.
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

/// Result of setting up two-factor authentication, including success/error
/// state and whether an audit trail entry is required.
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

/// Result of a password-reset request/submission, including success/error
/// state and whether an audit trail entry is required.
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
