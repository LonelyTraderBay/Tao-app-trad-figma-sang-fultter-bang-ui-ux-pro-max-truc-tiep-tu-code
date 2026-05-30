import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordResetChallengeProvider =
    NotifierProvider<PasswordResetChallengeController, PasswordResetChallenge?>(
      PasswordResetChallengeController.new,
    );

final passwordResetChallengeControllerProvider =
    passwordResetChallengeProvider.notifier;

final class PasswordResetChallenge {
  const PasswordResetChallenge({
    required this.email,
    required this.otp,
    required this.verifiedAt,
  });

  final String email;
  final String otp;
  final DateTime verifiedAt;
}

final class PasswordResetChallengeController
    extends Notifier<PasswordResetChallenge?> {
  @override
  PasswordResetChallenge? build() => null;

  void save({required String email, required String otp}) {
    state = PasswordResetChallenge(
      email: email.trim(),
      otp: otp,
      verifiedAt: DateTime.now(),
    );
  }

  void clear() {
    state = null;
  }
}
