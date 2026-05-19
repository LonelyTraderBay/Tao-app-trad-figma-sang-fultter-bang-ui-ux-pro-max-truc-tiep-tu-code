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
}

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
}
