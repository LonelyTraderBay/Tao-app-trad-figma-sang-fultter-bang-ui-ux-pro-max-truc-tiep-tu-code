import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/domain/repositories/predictions_repository.dart';

part '../fixtures/mock_predictions_repository_methods_part_01.dart';
part '../fixtures/mock_predictions_repository_methods_part_02.dart';
part '../fixtures/mock_predictions_repository_fixtures_part_01.dart';
part '../fixtures/mock_predictions_repository_fixtures_part_02.dart';
part '../fixtures/mock_predictions_repository_fixtures_part_03.dart';
part '../fixtures/mock_predictions_repository_fixtures_part_04.dart';
part '../fixtures/mock_predictions_repository_fixtures_part_05.dart';

mixin _MockPredictionsRepositoryBase implements PredictionsRepository {}

final class MockPredictionsRepository
    with
        _MockPredictionsRepositoryBase,
        _MockPredictionsRepositoryMethodsPart01,
        _MockPredictionsRepositoryMethodsPart02 {
  const MockPredictionsRepository();
}
