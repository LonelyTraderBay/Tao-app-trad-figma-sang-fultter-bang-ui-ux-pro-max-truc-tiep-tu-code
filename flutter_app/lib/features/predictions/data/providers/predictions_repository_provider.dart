import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/predictions/domain/repositories/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/data/repositories/mock_predictions_repository.dart';

import '../repositories/fail_closed_predictions_repository.dart';

final predictionsRepositoryProvider = Provider<PredictionsRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'Predictions',
    mock: () => const MockPredictionsRepository(),
    failClosed: () => const FailClosedPredictionsRepository(),
  );
});
