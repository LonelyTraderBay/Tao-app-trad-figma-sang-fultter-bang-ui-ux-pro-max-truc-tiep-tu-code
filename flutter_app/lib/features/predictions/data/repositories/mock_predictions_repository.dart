import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/core/utils/accent_tone.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/domain/repositories/predictions_repository.dart';

part '../fixtures/mock_predictions_repository_core_methods.dart';
part '../fixtures/mock_predictions_repository_extended_methods.dart';
part '../fixtures/mock_predictions_repository_fixtures_events_and_positions.dart';
part '../fixtures/mock_predictions_repository_fixtures_receipts_calendar_social.dart';
part '../fixtures/mock_predictions_repository_fixtures_tournaments_integrations_rewards.dart';
part '../fixtures/mock_predictions_repository_fixtures_leaderboard_and_activity.dart';
part '../fixtures/mock_predictions_repository_fixtures_home_receipts_rewards.dart';

mixin _MockPredictionsRepositoryBase implements PredictionsRepository {}

final class MockPredictionsRepository
    with
        _MockPredictionsRepositoryBase,
        _MockPredictionsRepositoryMethodsPart01,
        _MockPredictionsRepositoryMethodsPart02 {
  const MockPredictionsRepository();
}
