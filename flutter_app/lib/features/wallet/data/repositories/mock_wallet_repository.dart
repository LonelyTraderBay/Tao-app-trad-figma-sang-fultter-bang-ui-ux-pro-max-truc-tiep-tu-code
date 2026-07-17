import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';

part '../fixtures/mock_wallet_repository_methods.dart';
part '../fixtures/mock_wallet_repository_account_activity_fixtures.dart';
part '../fixtures/mock_wallet_repository_management_tools_fixtures.dart';
part '../fixtures/mock_wallet_repository_home_operations_fixtures.dart';

abstract class _MockWalletRepositoryBase implements WalletRepository {
  const _MockWalletRepositoryBase();
}

final class MockWalletRepository extends _MockWalletRepositoryBase
    with _MockWalletRepositoryMethodsPart01 {
  const MockWalletRepository();
}
