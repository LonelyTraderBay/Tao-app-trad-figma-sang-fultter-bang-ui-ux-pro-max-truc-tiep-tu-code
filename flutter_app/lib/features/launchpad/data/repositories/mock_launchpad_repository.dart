import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';

part '../fixtures/mock_launchpad_repository_methods_part_01.dart';
part '../fixtures/mock_launchpad_repository_methods_part_02.dart';
part '../fixtures/mock_launchpad_repository_fixtures_part_01.dart';
part '../fixtures/mock_launchpad_repository_fixtures_part_02.dart';
part '../fixtures/mock_launchpad_repository_fixtures_part_03.dart';
part '../fixtures/mock_launchpad_repository_fixtures_part_04.dart';
part '../fixtures/mock_launchpad_repository_fixtures_part_05.dart';
part '../fixtures/mock_launchpad_repository_fixtures_part_06.dart';
part '../fixtures/mock_launchpad_repository_fixtures_part_07.dart';

abstract class _MockLaunchpadRepositoryBase implements LaunchpadRepository {
  const _MockLaunchpadRepositoryBase();
}

final class MockLaunchpadRepository extends _MockLaunchpadRepositoryBase
    with
        _MockLaunchpadRepositoryMethodsPart01,
        _MockLaunchpadRepositoryMethodsPart02 {
  const MockLaunchpadRepository();
}
