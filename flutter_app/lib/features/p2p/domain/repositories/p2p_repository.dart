import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';

/// Abstract data-access contract every P2P screen depends on; implemented by mock and remote repositories.
abstract interface class P2PRepository {
  Future<P2PHomeSnapshot> getHome({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    String fiat = 'VND',
  });

  Future<P2PExpressSnapshot> getExpress();

  Future<P2PExpressConfirmSnapshot> getExpressConfirm({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    double fiatAmount = 0,
    double cryptoAmount = 0,
    String? adId,
    String? paymentMethod,
  });

  Future<P2POrderTimelineSnapshot> getOrderTimeline(String orderId);

  Future<P2POrderRateSnapshot> getOrderRate(String orderId);

  Future<P2POrderCancelSnapshot> getOrderCancel(String orderId);

  Future<P2POrderProofSnapshot> getOrderProof(String orderId);

  Future<P2POrderSnapshot> getOrder(String orderId);

  Future<P2PChatSnapshot> getChat(String orderId);

  Future<P2PDisputeDetailSnapshot> getDisputeDetail(String disputeId);

  Future<P2PDisputeEvidenceSnapshot> getDisputeEvidence(String disputeId);

  Future<P2PDisputeResolutionSnapshot> getDisputeResolution(String disputeId);

  Future<P2PDisputeOpenSnapshot> getDisputeOpen(String orderId);

  Future<P2PDisputesSnapshot> getDisputes();

  Future<P2PAdAnalyticsSnapshot> getAdAnalytics(String adId);

  Future<P2PAdDetailSnapshot> getAdDetail(String adId);

  Future<P2PMyAdsSnapshot> getMyAds();

  Future<P2PCreateAdSnapshot> getCreateAd();

  Future<P2PMerchantApplySnapshot> getMerchantApply();

  Future<P2PMerchantProfileSnapshot> getMerchantProfile(String merchantId);

  Future<P2PReportMerchantSnapshot> getReportMerchant(String merchantId);

  Future<P2PTradingLevelSnapshot> getTradingLevel();

  Future<P2PReviewsSnapshot> getReviews();

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

  Future<P2PInsuranceFundSnapshot> getInsuranceFund();

  Future<P2PInsuranceCertificateSnapshot> getInsuranceCertificate();

  Future<P2PInsuranceScoreSnapshot> getInsuranceScore();

  Future<P2PInsurancePolicySnapshot> getInsurancePolicy();

  Future<P2PContributionHistorySnapshot> getContributionHistory();

  Future<P2PClaimDetailSnapshot> getClaimDetail(String claimId);

  Future<P2PEscrowBalanceSnapshot> getEscrowBalance({String asset = 'USDT'});

  Future<P2PEscrowDetailSnapshot> getEscrowDetail(String orderId);

  Future<P2PKycRequirementsSnapshot> getKycRequirements();

  Future<P2PKycStatusSnapshot> getKycStatus();

  Future<P2PIdentityVerificationSnapshot> getIdentityVerification();

  Future<P2PAddressProofSnapshot> getAddressProof();

  Future<P2PSelfieVerificationSnapshot> getSelfieVerification();

  Future<P2PVideoVerificationSnapshot> getVideoVerification();

  Future<P2PSecurityCenterSnapshot> getSecurityCenter();

  Future<P2PTwoFactorSettingsSnapshot> getTwoFactorSettings();

  Future<P2PDeviceManagementSnapshot> getDeviceManagement();

  Future<P2PAntiPhishingCodeSnapshot> getAntiPhishingCode();

  Future<P2PLoginHistorySnapshot> getLoginHistory();

  Future<P2PSuspiciousActivitySnapshot> getSuspiciousActivity();

  Future<P2PE2EInfoSnapshot> getE2EInfo();

  Future<P2PFraudPreventionSnapshot> getFraudPrevention();

  Future<P2PWalletTransferSnapshot> getWalletTransfer({
    String asset = 'USDT',
    String type = 'deposit',
  });

  Future<P2PFundLockHistorySnapshot> getFundLockHistory({
    bool walletHistoryAlias = false,
  });

  Future<P2PWalletSnapshot> getWallet();

  Future<P2PLimitTrackerSnapshot> getLimitTracker();

  Future<P2PTransactionLimitsSnapshot> getTransactionLimits();

  Future<P2PComplianceOverviewSnapshot> getComplianceOverview();

  Future<P2PAmlScreeningSnapshot> getAmlScreening();

  Future<P2PSourceOfFundsSnapshot> getSourceOfFunds();

  Future<P2PLargeTransactionJustificationSnapshot>
  getLargeTransactionJustification({double amount = 100000000});

  Future<P2PRiskAssessmentSnapshot> getRiskAssessment();

  Future<P2PTaxReportingSnapshot> getTaxReporting({
    int selectedYear = 2025,
    String selectedJurisdiction = 'US',
  });

  Future<P2POrderBookSnapshot> getOrderBook({String selectedAsset = 'USDT'});

  Future<P2PDashboardSnapshot> getDashboard({String timeFilter = '30d'});

  Future<P2PAchievementsSnapshot> getAchievements();

  Future<P2PBlacklistAddSnapshot> getBlacklistAdd();

  Future<P2PBlacklistSnapshot> getBlacklist();

  Future<P2PNotificationSettingsSnapshot> getNotificationSettings();

  Future<P2PSettingsSnapshot> getSettings();

  Future<P2PGuideSnapshot> getGuide();

  Future<P2PMyOrdersSnapshot> getMyOrders();
}
