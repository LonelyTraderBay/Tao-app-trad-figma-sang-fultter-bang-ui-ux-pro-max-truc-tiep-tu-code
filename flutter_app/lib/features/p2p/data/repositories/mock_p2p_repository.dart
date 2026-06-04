import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/domain/repositories/p2p_repository.dart';

part '../fixtures/mock_p2p_repository_methods_part_01.dart';
part '../fixtures/mock_p2p_repository_methods_part_02.dart';
part '../fixtures/mock_p2p_repository_methods_part_03.dart';
part '../fixtures/mock_p2p_repository_methods_part_04.dart';
part '../fixtures/mock_p2p_repository_methods_part_05.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_01.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_02.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_03.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_04.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_05.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_06.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_07.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_08.dart';
part '../fixtures/mock_p2p_repository_fixtures_part_09.dart';

abstract class _MockP2PRepositoryBase implements P2PRepository {
  const _MockP2PRepositoryBase();
}

final class MockP2PRepository extends _MockP2PRepositoryBase
    with
        _MockP2PRepositoryMethodsPart01,
        _MockP2PRepositoryMethodsPart02,
        _MockP2PRepositoryMethodsPart03,
        _MockP2PRepositoryMethodsPart04,
        _MockP2PRepositoryMethodsPart05 {
  const MockP2PRepository();
}
