import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';
import 'package:vit_trade_flutter/features/dca/domain/repositories/dca_repository.dart';

part '../fixtures/mock_dca_repository_methods_dashboard_and_configs.dart';
part '../fixtures/mock_dca_repository_methods_dynamic_amount_backtest_multi_asset.dart';
part '../fixtures/mock_dca_repository_methods_performance_and_smart_rules.dart';
part '../fixtures/mock_dca_repository_methods_overview_demo.dart';

final class MockDcaRepository
    with
        _DcaRepositoryMethodsPart01,
        _DcaRepositoryMethodsPart02,
        _DcaRepositoryMethodsPart03,
        _DcaRepositoryMethodsPart04
    implements DcaRepository {
  const MockDcaRepository();
}
