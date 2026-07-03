import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/trade/domain/entities/trade_entities.dart';
import 'package:vit_trade_flutter/features/trade/domain/repositories/trade_repository.dart';

part '../fixtures/mock_trade_repository_methods_part_01.dart';
part '../fixtures/mock_trade_repository_methods_part_02.dart';
part '../fixtures/mock_trade_repository_methods_part_03.dart';
part '../fixtures/mock_trade_repository_methods_part_04.dart';
part '../fixtures/mock_trade_repository_methods_part_05.dart';
part '../fixtures/mock_trade_repository_methods_part_06.dart';
part '../fixtures/mock_trade_repository_fixtures_part_01.dart';
part '../fixtures/mock_trade_repository_fixtures_part_02.dart';
part '../fixtures/mock_trade_repository_fixtures_part_03.dart';
part '../fixtures/mock_trade_repository_fixtures_part_04.dart';
part '../fixtures/mock_trade_repository_fixtures_part_05.dart';
part '../fixtures/mock_trade_repository_fixtures_part_06.dart';
part '../fixtures/mock_trade_repository_fixtures_part_07.dart';
part '../fixtures/mock_trade_repository_fixtures_part_08.dart';
part '../fixtures/mock_trade_repository_fixtures_part_09.dart';
part '../fixtures/mock_trade_repository_fixtures_part_10.dart';
part '../fixtures/mock_trade_repository_fixtures_part_11.dart';
part '../fixtures/mock_trade_repository_fixtures_part_12.dart';
part '../fixtures/mock_trade_repository_fixtures_part_13.dart';
part '../fixtures/mock_trade_repository_fixtures_part_14.dart';
part '../fixtures/mock_trade_repository_fixtures_part_15.dart';

mixin _MockTradeRepositoryBase implements TradeRepository {}

final class MockTradeRepository
    with
        _MockTradeRepositoryBase,
        _MockTradeRepositoryMethodsPart01,
        _MockTradeRepositoryMethodsPart02,
        _MockTradeRepositoryMethodsPart03,
        _MockTradeRepositoryMethodsPart04,
        _MockTradeRepositoryMethodsPart05,
        _MockTradeRepositoryMethodsPart06 {
  const MockTradeRepository();
}
