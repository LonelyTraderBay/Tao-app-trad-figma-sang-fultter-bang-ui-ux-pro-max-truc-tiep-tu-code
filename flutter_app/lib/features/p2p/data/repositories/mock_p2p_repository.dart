import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/domain/repositories/p2p_repository.dart';

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

mixin _MockP2PRepositoryBase implements P2PRepository {}

final class MockP2PRepository
    with
        _MockP2PRepositoryBase,
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
  const MockP2PRepository();
}
