import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_entities.dart';

/// Trust slice of [P2PRepository] (dispute, insurance, security, compliance).
abstract interface class P2PTrustRepository {
  Future<P2PDisputeDetailSnapshot> getDisputeDetail(String disputeId);

  Future<P2PDisputeEvidenceSnapshot> getDisputeEvidence(String disputeId);

  Future<P2PDisputeResolutionSnapshot> getDisputeResolution(String disputeId);

  Future<P2PDisputeOpenSnapshot> getDisputeOpen(String orderId);

  Future<P2PDisputesSnapshot> getDisputes();

  Future<P2PReportMerchantSnapshot> getReportMerchant(String merchantId);

  Future<P2PReviewsSnapshot> getReviews();

  Future<P2PInsuranceFundSnapshot> getInsuranceFund();

  Future<P2PInsuranceCertificateSnapshot> getInsuranceCertificate();

  Future<P2PInsuranceScoreSnapshot> getInsuranceScore();

  Future<P2PInsurancePolicySnapshot> getInsurancePolicy();

  Future<P2PContributionHistorySnapshot> getContributionHistory();

  Future<P2PClaimDetailSnapshot> getClaimDetail(String claimId);

  Future<P2PSecurityCenterSnapshot> getSecurityCenter();

  Future<P2PTwoFactorSettingsSnapshot> getTwoFactorSettings();

  Future<P2PDeviceManagementSnapshot> getDeviceManagement();

  Future<P2PAntiPhishingCodeSnapshot> getAntiPhishingCode();

  Future<P2PLoginHistorySnapshot> getLoginHistory();

  Future<P2PSuspiciousActivitySnapshot> getSuspiciousActivity();

  Future<P2PE2EInfoSnapshot> getE2EInfo();

  Future<P2PFraudPreventionSnapshot> getFraudPrevention();

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

  Future<P2PAchievementsSnapshot> getAchievements();

  Future<P2PBlacklistAddSnapshot> getBlacklistAdd();

  Future<P2PBlacklistSnapshot> getBlacklist();
}
