import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/dca/domain/repositories/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/data/repositories/mock_dca_repository.dart';

import '../repositories/fail_closed_dca_repository.dart';

final dcaRepositoryProvider = Provider<DcaRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Dca',
    mock: () => const MockDcaRepository(),
    failClosed: () => const FailClosedDcaRepository(),
  ),
);
