import 'package:vit_trade_flutter/core/utils/accent_tone.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';

part '../fixtures/mock_market_repository_methods_part_01.dart';
part '../fixtures/mock_market_repository_methods_part_02.dart';
part '../fixtures/mock_market_repository_methods_part_03.dart';
part '../fixtures/mock_market_repository_fixtures_part_01.dart';
part '../fixtures/mock_market_repository_fixtures_part_02.dart';
part '../fixtures/mock_market_repository_fixtures_part_03.dart';
part '../fixtures/mock_market_repository_fixtures_part_04.dart';
part '../fixtures/mock_market_repository_fixtures_part_05.dart';
part '../fixtures/mock_market_repository_fixtures_part_06.dart';
part '../fixtures/mock_market_repository_fixtures_part_07.dart';
part '../fixtures/mock_market_repository_fixtures_part_08.dart';

mixin _MockMarketRepositoryBase implements MarketRepository {}

final class MockMarketRepository
    with
        _MockMarketRepositoryBase,
        _MockMarketRepositoryMethodsPart01,
        _MockMarketRepositoryMethodsPart02,
        _MockMarketRepositoryMethodsPart03 {
  const MockMarketRepository();
}
