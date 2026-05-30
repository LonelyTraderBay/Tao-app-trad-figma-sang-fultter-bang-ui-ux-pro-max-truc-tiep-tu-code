import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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

abstract class _MockMarketRepositoryBase implements MarketRepository {
  const _MockMarketRepositoryBase();
}

final class MockMarketRepository extends _MockMarketRepositoryBase
    with
        _MockMarketRepositoryMethodsPart01,
        _MockMarketRepositoryMethodsPart02,
        _MockMarketRepositoryMethodsPart03 {
  const MockMarketRepository();
}
