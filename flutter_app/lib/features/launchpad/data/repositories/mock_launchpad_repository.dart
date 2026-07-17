import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/core/utils/accent_tone.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';

part '../fixtures/mock_launchpad_repository_screen_methods.dart';
part '../fixtures/mock_launchpad_repository_bridge_contract_methods.dart';
part '../fixtures/mock_launchpad_repository_directory_fixtures.dart';
part '../fixtures/mock_launchpad_repository_staking_bridge_fixtures.dart';
part '../fixtures/mock_launchpad_repository_bridge_compare_notif_log_fixtures.dart';
part '../fixtures/mock_launchpad_repository_abi_webhook_wallet_gas_fixtures.dart';
part '../fixtures/mock_launchpad_repository_gas_rebalance_multisig_fixtures.dart';
part '../fixtures/mock_launchpad_repository_risk_tools_fixtures.dart';
part '../fixtures/mock_launchpad_repository_tx_simulation_fixtures.dart';

abstract class _MockLaunchpadRepositoryBase implements LaunchpadRepository {
  const _MockLaunchpadRepositoryBase();
}

final class MockLaunchpadRepository extends _MockLaunchpadRepositoryBase
    with
        _MockLaunchpadRepositoryMethodsPart01,
        _MockLaunchpadRepositoryMethodsPart02 {
  const MockLaunchpadRepository();
}
