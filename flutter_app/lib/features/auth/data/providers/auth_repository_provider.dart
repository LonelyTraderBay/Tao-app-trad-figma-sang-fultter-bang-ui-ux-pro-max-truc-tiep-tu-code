import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../repositories/fail_closed_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'Auth',
    mock: () => const MockAuthRepository(),
    failClosed: () => const FailClosedAuthRepository(),
  );
});
