import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/support/domain/repositories/support_repository.dart';
import 'package:vit_trade_flutter/features/support/data/repositories/fail_closed_support_repository.dart';
import 'package:vit_trade_flutter/features/support/data/repositories/mock_support_repository.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'Support',
    mock: () => const MockSupportRepository(),
    failClosed: () => const FailClosedSupportRepository(),
  );
});
