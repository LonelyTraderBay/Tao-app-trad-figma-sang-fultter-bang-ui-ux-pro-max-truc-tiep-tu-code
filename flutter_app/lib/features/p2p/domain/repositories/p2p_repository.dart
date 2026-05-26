import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';

abstract interface class P2PRepository {
  P2PHomeSnapshot getHome({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    String fiat = 'VND',
  });

  P2PExpressSnapshot getExpress();

  P2PExpressConfirmSnapshot getExpressConfirm({
    P2PTradeType tradeType = P2PTradeType.buy,
    String asset = 'USDT',
    double fiatAmount = 0,
    double cryptoAmount = 0,
    String? adId,
    String? paymentMethod,
  });

  P2POrderTimelineSnapshot getOrderTimeline(String orderId);

  P2POrderRateSnapshot getOrderRate(String orderId);

  P2POrderCancelSnapshot getOrderCancel(String orderId);

  P2POrderProofSnapshot getOrderProof(String orderId);

  P2POrderSnapshot getOrder(String orderId);

  P2PChatSnapshot getChat(String orderId);

  P2PDisputeDetailSnapshot getDisputeDetail(String disputeId);

  P2PDisputeEvidenceSnapshot getDisputeEvidence(String disputeId);

  P2PDisputeResolutionSnapshot getDisputeResolution(String disputeId);

  P2PDisputeOpenSnapshot getDisputeOpen(String orderId);

  P2PDisputesSnapshot getDisputes();

  P2PAdAnalyticsSnapshot getAdAnalytics(String adId);

  P2PAdDetailSnapshot getAdDetail(String adId);

  P2PMyAdsSnapshot getMyAds();

  P2PCreateAdSnapshot getCreateAd();

  P2PMerchantApplySnapshot getMerchantApply();

  P2PMerchantProfileSnapshot getMerchantProfile(String merchantId);

  P2PReportMerchantSnapshot getReportMerchant(String merchantId);

  P2PTradingLevelSnapshot getTradingLevel();

  P2PReviewsSnapshot getReviews();

  P2PPaymentMethodAddSnapshot getPaymentMethodAdd();

  P2PPaymentMethodVerificationSnapshot getPaymentMethodVerification(
    String methodId,
  );

  P2PPaymentMethodOwnershipSnapshot getPaymentMethodOwnership(String methodId);

  P2PPaymentMethodCoolingPeriodSnapshot getPaymentMethodCoolingPeriod();

  P2PPaymentMethodHistorySnapshot getPaymentMethodHistory();

  P2PPaymentMethodsSnapshot getPaymentMethods();

  P2PInsuranceFundSnapshot getInsuranceFund();

  P2PInsuranceCertificateSnapshot getInsuranceCertificate();

  P2PInsuranceScoreSnapshot getInsuranceScore();

  P2PInsurancePolicySnapshot getInsurancePolicy();

  P2PContributionHistorySnapshot getContributionHistory();

  P2PClaimDetailSnapshot getClaimDetail(String claimId);

  P2PEscrowBalanceSnapshot getEscrowBalance({String asset = 'USDT'});

  P2PEscrowDetailSnapshot getEscrowDetail(String orderId);

  P2PKycRequirementsSnapshot getKycRequirements();

  P2PKycStatusSnapshot getKycStatus();

  P2PIdentityVerificationSnapshot getIdentityVerification();

  P2PAddressProofSnapshot getAddressProof();

  P2PSelfieVerificationSnapshot getSelfieVerification();

  P2PVideoVerificationSnapshot getVideoVerification();

  P2PSecurityCenterSnapshot getSecurityCenter();

  P2PTwoFactorSettingsSnapshot getTwoFactorSettings();

  P2PDeviceManagementSnapshot getDeviceManagement();

  P2PAntiPhishingCodeSnapshot getAntiPhishingCode();

  P2PLoginHistorySnapshot getLoginHistory();

  P2PSuspiciousActivitySnapshot getSuspiciousActivity();

  P2PE2EInfoSnapshot getE2EInfo();

  P2PFraudPreventionSnapshot getFraudPrevention();

  P2PWalletTransferSnapshot getWalletTransfer({
    String asset = 'USDT',
    String type = 'deposit',
  });

  P2PFundLockHistorySnapshot getFundLockHistory({
    bool walletHistoryAlias = false,
  });

  P2PWalletSnapshot getWallet();

  P2PLimitTrackerSnapshot getLimitTracker();

  P2PTransactionLimitsSnapshot getTransactionLimits();

  P2PComplianceOverviewSnapshot getComplianceOverview();

  P2PAmlScreeningSnapshot getAmlScreening();

  P2PSourceOfFundsSnapshot getSourceOfFunds();

  P2PLargeTransactionJustificationSnapshot getLargeTransactionJustification({
    double amount = 100000000,
  });

  P2PRiskAssessmentSnapshot getRiskAssessment();

  P2PTaxReportingSnapshot getTaxReporting({
    int selectedYear = 2025,
    String selectedJurisdiction = 'US',
  });

  P2POrderBookSnapshot getOrderBook({String selectedAsset = 'USDT'});

  P2PDashboardSnapshot getDashboard({String timeFilter = '30d'});

  P2PAchievementsSnapshot getAchievements();

  P2PBlacklistAddSnapshot getBlacklistAdd();

  P2PBlacklistSnapshot getBlacklist();

  P2PNotificationSettingsSnapshot getNotificationSettings();

  P2PSettingsSnapshot getSettings();

  P2PGuideSnapshot getGuide();

  P2PMyOrdersSnapshot getMyOrders();
}
