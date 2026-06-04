import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';

part '../fixtures/mock_wallet_repository_methods_part_01.dart';
part '../fixtures/mock_wallet_repository_fixtures_part_01.dart';
part '../fixtures/mock_wallet_repository_fixtures_part_02.dart';
part '../fixtures/mock_wallet_repository_fixtures_part_03.dart';

abstract class _MockWalletRepositoryBase implements WalletRepository {
  const _MockWalletRepositoryBase();
}

final class MockWalletRepository extends _MockWalletRepositoryBase
    with _MockWalletRepositoryMethodsPart01 {
  const MockWalletRepository();
}
