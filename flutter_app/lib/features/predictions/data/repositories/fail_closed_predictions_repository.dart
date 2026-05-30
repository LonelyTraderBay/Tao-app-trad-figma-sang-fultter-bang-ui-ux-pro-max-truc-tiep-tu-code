import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_errors.dart';
import 'package:vit_trade_flutter/features/predictions/domain/repositories/predictions_repository.dart';

final class FailClosedPredictionsRepository implements PredictionsRepository {
  const FailClosedPredictionsRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const PredictionsBackendContractMissingException();
  }
}
