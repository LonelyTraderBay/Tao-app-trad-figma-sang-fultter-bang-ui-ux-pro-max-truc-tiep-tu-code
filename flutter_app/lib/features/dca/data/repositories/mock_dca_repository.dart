import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';
import 'package:vit_trade_flutter/features/dca/domain/repositories/dca_repository.dart';

part '../fixtures/mock_dca_repository_methods_part_01.dart';
part '../fixtures/mock_dca_repository_methods_part_02.dart';
part '../fixtures/mock_dca_repository_methods_part_03.dart';
part '../fixtures/mock_dca_repository_methods_part_04.dart';

final class MockDcaRepository
    with
        _DcaRepositoryMethodsPart01,
        _DcaRepositoryMethodsPart02,
        _DcaRepositoryMethodsPart03,
        _DcaRepositoryMethodsPart04
    implements DcaRepository {
  const MockDcaRepository();
}
