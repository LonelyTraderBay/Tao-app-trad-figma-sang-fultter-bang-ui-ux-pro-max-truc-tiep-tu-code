import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/admin/domain/repositories/admin_repository.dart';
import 'package:vit_trade_flutter/features/admin/data/repositories/mock_admin_repository.dart';

import '../repositories/fail_closed_admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Admin',
    mock: () => const MockAdminRepository(),
    failClosed: () => const FailClosedAdminRepository(),
  ),
);
