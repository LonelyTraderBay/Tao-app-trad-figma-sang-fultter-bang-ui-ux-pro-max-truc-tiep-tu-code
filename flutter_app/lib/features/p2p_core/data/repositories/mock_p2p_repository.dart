import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_repository.dart';

part '../fixtures/p2p_escrow_repository_methods.dart';
part '../fixtures/p2p_escrow_repository_fixtures.dart';
part '../fixtures/p2p_home_repository_methods.dart';
part '../fixtures/p2p_home_repository_fixtures.dart';
part '../fixtures/p2p_payments_repository_methods.dart';
part '../fixtures/p2p_payments_repository_fixtures.dart';
part '../fixtures/p2p_wallet_repository_methods.dart';
part '../fixtures/p2p_wallet_repository_fixtures.dart';
part '../fixtures/p2p_disputes_repository_methods.dart';
part '../fixtures/p2p_disputes_repository_fixtures.dart';
part '../fixtures/p2p_ads_repository_methods.dart';
part '../fixtures/p2p_ads_repository_fixtures.dart';
part '../fixtures/p2p_kyc_repository_methods.dart';
part '../fixtures/p2p_kyc_repository_fixtures.dart';
part '../fixtures/p2p_merchant_repository_methods.dart';
part '../fixtures/p2p_merchant_repository_fixtures.dart';
part '../fixtures/p2p_compliance_risk_repository_methods.dart';
part '../fixtures/p2p_compliance_risk_repository_fixtures.dart';
part '../fixtures/p2p_security_repository_methods.dart';
part '../fixtures/p2p_security_repository_fixtures.dart';
part '../fixtures/p2p_insurance_repository_methods.dart';
part '../fixtures/p2p_insurance_repository_fixtures.dart';
part '../fixtures/p2p_dashboard_ux_repository_methods.dart';
part '../fixtures/p2p_dashboard_ux_repository_fixtures.dart';
part '../fixtures/p2p_orders_repository_methods.dart';
part '../fixtures/p2p_orders_repository_fixtures.dart';

abstract class _MockP2PRepositoryBase implements P2PRepository {
  const _MockP2PRepositoryBase({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) throw StateError('p2p_mock_fetch_failed');
  }
}

final class MockP2PRepository extends _MockP2PRepositoryBase
    with
        _MockP2PRepositoryEscrowMethods,
        _MockP2PRepositoryHomeMethods,
        _MockP2PRepositoryPaymentsMethods,
        _MockP2PRepositoryWalletMethods,
        _MockP2PRepositoryDisputesMethods,
        _MockP2PRepositoryAdsMethods,
        _MockP2PRepositoryKycMethods,
        _MockP2PRepositoryMerchantMethods,
        _MockP2PRepositoryComplianceRiskMethods,
        _MockP2PRepositorySecurityMethods,
        _MockP2PRepositoryInsuranceMethods,
        _MockP2PRepositoryDashboardUxMethods,
        _MockP2PRepositoryOrdersMethods {
  const MockP2PRepository({super.simulateError, super.loadDelay});
}
