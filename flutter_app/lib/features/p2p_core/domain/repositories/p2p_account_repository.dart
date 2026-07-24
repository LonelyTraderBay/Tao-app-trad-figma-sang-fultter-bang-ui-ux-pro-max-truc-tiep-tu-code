import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_entities.dart';

/// Account slice of [P2PRepository] (merchant, KYC, payment methods).
abstract interface class P2PAccountRepository {
  Future<P2PMerchantApplySnapshot> getMerchantApply();

  Future<P2PMerchantProfileSnapshot> getMerchantProfile(String merchantId);

  Future<P2PPaymentMethodAddSnapshot> getPaymentMethodAdd();

  Future<P2PPaymentMethodVerificationSnapshot> getPaymentMethodVerification(
    String methodId,
  );

  Future<P2PPaymentMethodOwnershipSnapshot> getPaymentMethodOwnership(
    String methodId,
  );

  Future<P2PPaymentMethodCoolingPeriodSnapshot> getPaymentMethodCoolingPeriod();

  Future<P2PPaymentMethodHistorySnapshot> getPaymentMethodHistory();

  Future<P2PPaymentMethodsSnapshot> getPaymentMethods();

  Future<P2PKycRequirementsSnapshot> getKycRequirements();

  Future<P2PKycStatusSnapshot> getKycStatus();

  Future<P2PIdentityVerificationSnapshot> getIdentityVerification();

  Future<P2PAddressProofSnapshot> getAddressProof();

  Future<P2PSelfieVerificationSnapshot> getSelfieVerification();

  Future<P2PVideoVerificationSnapshot> getVideoVerification();
}
